//           (##/                                                                                                      
//             ####.   ,                                                                                               
//               #####    ,#(.                                                                                         
//                 (#####     (####*.                                                                                  
//                   ,######.     %########*                                                                           
//                      #######(     ,##############(/,.                                                               
//                        ,########/     .############################(/*,...                                          
//                           /#########(      *###################/*,..            ,###                                
//                              /###########*      ./((/                       .########(                              
//                                 *###########%*                                   ,(########*                        
//                                     /##*                                         */(###########(                    
//                                                                                               ###(                  
//                                                                                                 ((                  
//                                                                                                             
//                                       @@@@@@@@@@@@@@@@@@@@@@@,   .@@@@@@@@@@@@@%                                    
//                                       @@@@@@.                 &@@@@&          @@@@@.                                
//                                       @@@@@@.               .@@@@@@            @@@@@&                               
//                                       @@@@@@@@@@@@@@@@@@@   /@@@@@@(          &@@@@@@/                              
//                                       @@@@@@.                ,@@@@@@@@%///(&@@(@@@@@@*                              
//                                       @@@@@@.                    &@@@@@@@@@*  (@@@@@%                               
//                                       @@@@@@.                                &@@@@@*                                
//                                       @@@@@@                              /@@@@@@.                                  
//                                       @@@@                   ,,**/(@@@@@@@@@/                                       
//                                                            ...                         
//
//
//
// ==================================================================
// FALCON 9 MISSION SOFTWARE - WRITTEN BY QUASY - FOR THE COMMUNITY
// CREDIT TO THE AUTHORS OF THE LIBRARIES INCLUDED
// ==================================================================
//
// SCRIPT: (BOOSTER) EVENTS
//

GLOBAL FUNCTION _BOOSTER_GRAVITY_TURN_ASCENT 
{
    LOCK THROTTLE TO 1.
    WAIT UNTIL SHIP:AIRSPEED > 0.5.
    _GET_FALCON_PROPELLANT("BOOSTER").

    UNTIL _BOOSTER_FUEL_PERCENTAGE < _RECOVERY_BOOSTER_FUEL_CUTOFF + 3 {
        _GET_FALCON_PROPELLANT("BOOSTER").
        _GRAVITY_TURN(). 
    }
}



GLOBAL FUNCTION _BOOSTER_STAGE_SEPARATION
{
   LOCK STEERING TO PROGRADE.
    WAIT 6.
    LOCK THROTTLE TO 0.
    RCS ON.
    WAIT 2.5.

    _BOOSTER_ENGINE_CONTROL("THREE ENGINES").
    _INITIALIZE_UPPER_CPU(). // Prepare S2
    _BOOSTER_ACTIONS("INTERSTAGE SEPARATION"). // Separate

    WAIT 3.
}







// ======== LANDING =========



GLOBAL FUNCTION _BOOSTER_BOOSTBACK_BURN
{
    SET _DISTANCE_IMPACT TO 99999999. // Ignore now
    SET _CURRENT_PITCH TO ROUND(90 - vAng(SHIP:UP:FOREVECTOR, SHIP:FACING:FOREVECTOR)).

    WAIT 0.5.

    // FLIP MANEUVER
        // INITIAL KICK
            // IF SHIP:FACING:ROLL > -10 AND SHIP:FACING:ROLL < 10 
            // {
            //     SET SHIP:CONTROL:PITCH TO +1.
            // }
            // ELSE 
            // {
            //     SET SHIP:CONTROL:PITCH TO -1.
            // }
            SET SHIP:CONTROL:PITCH TO 1.

        // SLOW DOWN
            UNTIL _CURRENT_PITCH > 85 
            {
                PRINT ROUND(_CURRENT_PITCH) + "     " AT (0,1).
                SET _CURRENT_PITCH TO ROUND(90 - vAng(SHIP:UP:FOREVECTOR, SHIP:FACING:FOREVECTOR)).
            }

            SET SHIP:CONTROL:PITCH TO 0.3.

        // STARTUP BOOSTBACK
            _BOOSTER_ENGINE_CONTROL("THREE ENGINES").
            LOCK THROTTLE TO 1.

            UNTIL _CURRENT_PITCH < 30 
            {
                IF _CURRENT_PITCH < 29 
                {
                    SET STEERINGMANAGER:MAXSTOPPINGTIME TO 0.5. 
                }

                PRINT ROUND(_CURRENT_PITCH) + "     "    at (0,1).
                SET _CURRENT_PITCH TO round(90 - vAng(ship:up:forevector, ship:facing:forevector)).
            }
           
        // STOP PITCHING WHEN POINTING TO LZ
            SET SHIP:CONTROL:PITCH TO 0.
            SET SHIP:CONTROL:NEUTRALIZE TO TRUE.
            RCS OFF. // Engines power so no RCS required

    // BOOSTBACK
        UNTIL _DISTANCE_IMPACT <= 10000 
        {
            _BOOSTBACK_STEERING(0, 0, 0).
        }

        SET _CURRENT_VEHICLE_DIRECTION TO SHIP:FACING.
        LOCK STEERING TO _CURRENT_VEHICLE_DIRECTION.

        UNTIL _DISTANCE_IMPACT <= 1000
            { // Boost the impact point to the pad
                _BOOSTBACK_STEERING(0, 0, 0).

                IF _DISTANCE_IMPACT <= 10000 {LOCK THROTTLE TO 0.5.} // Reduce throttle for precision 
                ELSE {LOCK THROTTLE TO 1.} // Full throttle above certain threshold
            }

            // _BOOSTER_ENGINE_CONTROL("ONE ENGINE"). // Switch to 1 engine for precise burn (boostback)
            SET STEERINGMANAGER:MAXSTOPPINGTIME TO 0.01. // Slow Steering to prevent flipping

            IF _RECOVERY_TYPE = "ASDS" {LOCK THROTTLE TO 0. IF _RECOVERY_LANDING_ENGINES = 1 {_BOOSTER_ENGINE_CONTROL("ONE ENGINE").} ELSE {_BOOSTER_ENGINE_CONTROL("THREE ENGINES").}} 
            ELSE IF _RECOVERY_TYPE = "RTLS" 
            {
                UNTIL _DISTANCE_IMPACT > 1000
                { // Boost past the pad and overshoot due to atmosphere aerodynamic
                    _BOOSTBACK_STEERING(0, 0, 0).
                    
                }

                SET _CURRENT_FACING_DIRECTION TO SHIP:FACING.
                LOCK STEERING TO _CURRENT_FACING_DIRECTION. // LOCK TO CURRENT DIRECTION
        
                UNTIL _DISTANCE_IMPACT > 1600 
                { // Burns to the point up until shutdown
                    SET _OVERSHOOT_LAT_LNG TO LATLNG(_LANDING_TARGET:LAT, _LANDING_TARGET:LNG). 
                    SET _DISTANCE_IMPACT TO _CALC_DISTANCE(_OVERSHOOT_LAT_LNG, ADDONS:TR:IMPACTPOS).

                    WAIT 0.
                }

                SET STEERINGMANAGER:MAXSTOPPINGTIME TO 1.
                LOCK THROTTLE TO 0. // Boostback Shutdown
                _BOOSTER_ENGINE_CONTROL("THREE ENGINES"). // 3 Engines
                WAIT 1.
            }
    // END BOOSTBACK ---------------------------------------------------
}



GLOBAL FUNCTION _BOOSTER_ATMOSPHERIC_GUIDANCE
{
    SET STEERINGMANAGER:TORQUEEPSILONMAX TO 0.04. // Stops RCS spasming and using too much while looking up
    SET STEERINGMANAGER:TORQUEEPSILONMIN TO 0.02. // ^
    SET STEERINGMANAGER:MAXSTOPPINGTIME TO 1. // Better Steering Control Speeds

    RCS ON.
    LOCK STEERING TO UP.

    WAIT UNTIL SHIP:VERTICALSPEED < -50.
    BRAKES ON.
    LOCK STEERING TO SRFRETROGRADE.

    SET STEERINGMANAGER:TORQUEEPSILONMAX TO 0.0002. // Back to default value
    SET STEERINGMANAGER:TORQUEEPSILONMIN TO 0.001. // ^
    SET STEERINGMANAGER:MAXSTOPPINGTIME TO 1. // Better Steering Control Speeds
    SET STEERINGMANAGER:ROLLTS TO 10. // Roll Wiggle Fix

    LOCK STEERING TO _LANDING_ZONE_GUIDANCE(). // Steer to the LZ (CofP Change)
    SET _ANGLE_OF_ATTACK_LIMIT TO 15.

    _LANDING_BURN_VARIABLES().

    // ENTRY BURN
        UNTIL SHIP:ALTITUDE < 32500 {WAIT 0.}
        LOCK STEERING TO SRFRETROGRADE.
        SET STEERINGMANAGER:MAXSTOPPINGTIME TO 10.
        _BOOSTER_ENGINE_CONTROL("ONE ENGINE").
        IF _SOOT_TOGGLE {_BOOSTER_TANK[0]:getmodule("ModuleTundraSoot"):doaction("Toggle Soot", true). _BOOSTER_INTERSTAGE[0]:getmodule("ModuleTundraSoot"):doaction("Toggle Soot", true).}
        LOCK THROTTLE TO 1.
        WAIT 0.75.
        _BOOSTER_ENGINE_CONTROL("THREE ENGINES").
        UNTIL SHIP:VERTICALSPEED > -300 {WAIT 0.}
        LOCK THROTTLE TO 0.

        LOCK STEERING TO _LANDING_ZONE_GUIDANCE().
        IF _RECOVERY_LANDING_ENGINES = 1 {_BOOSTER_ENGINE_CONTROL("ONE ENGINE").}

    // LANDING BURN
        WAIT UNTIL SHIP:ALTITUDE < 4000. // Prevent early start
        UNTIL _TRUE_RADAR <= (_STOP_DISTANCE + _BOOSTER_HEIGHT) 
        {
            IF _ANGLE_OF_ATTACK_LIMIT > 15 {SET _ANGLE_OF_ATTACK_LIMIT TO 15.}
            IF SHIP:ALTITUDE < 10000 {SET _ANGLE_OF_ATTACK_LIMIT TO (ALT:RADAR / 100) + 1.}
            WAIT 0.
        }
}



GLOBAL FUNCTION _BOOSTER_LANDING_BURN
{
   // LANDING BURN STARTUP
        RCS OFF. // Under Engine Power
        LOCK STEERING TO _LANDING_ZONE_GUIDANCE().
        LOCK THROTTLE TO _BURN_THROTTLE + 0.2. // Start Landing Burn with extra power to be finished early
        SET _ANGLE_OF_ATTACK_LIMIT TO -3. // Inverted AOA when under engine power

    // LANDING GEAR TRIGGER & AOA
        IF ADDONS:TR:HASIMPACT 
        {
            WHEN ALT:RADAR < 300 THEN {SET _ANGLE_OF_ATTACK_LIMIT TO -1.} // LIMIT AOA CLOSE TO GND
            WHEN ALT:RADAR < 200 THEN {GEAR ON.} // Landing Gear Deploy
        }

    // REST OF LANDING BURN
        UNTIL SHIP:VERTICALSPEED > -40
        {
            SET _ANGLE_OF_ATTACK_LIMIT TO -(ALT:RADAR / 100) + 1. // 100 Meters = 0 AOA, 200 = - 1 etc.

            PRINT round(_ANGLE_OF_ATTACK_LIMIT, 1) AT (0,7).
            IF _ANGLE_OF_ATTACK_LIMIT < -4 {SET _ANGLE_OF_ATTACK_LIMIT TO -4.}
            IF _ANGLE_OF_ATTACK_LIMIT > -1 {SET _ANGLE_OF_ATTACK_LIMIT TO -1.}

            WAIT 0.
        }

        IF _RECOVERY_LANDING_ENGINES = 3 {_BOOSTER_ENGINE_CONTROL("ONE ENGINE").} // Switch to 1 engines when slow
        
        SET _ANGLE_OF_ATTACK_LIMIT TO -0.25.
        LOCK THROTTLE TO _BURN_THROTTLE + 0.2. // Higher throttle for early burn
        
    // TOUCHDOWN
        UNTIL SHIP:VERTICALSPEED >= -0.01 {WAIT 0.01.}

    // SHUTDOWN ENGINES
        LOCK THROTTLE TO 0. // Shutdown Engines on landing burn complete
        _BOOSTER_ENGINE_CONTROL("SHUTDOWN"). // Engines Off

        LOCK STEERING TO UP.

        WAIT 10.
        // BRAKES OFF.
        RCS OFF.
        AG6 OFF.
        SHUTDOWN.
}
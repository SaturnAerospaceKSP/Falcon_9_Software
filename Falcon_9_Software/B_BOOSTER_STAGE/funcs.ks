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
// SCRIPT: (BOOSTER) FUNCS
//

GLOBAL FUNCTION _INITIALIZE_UPPER_CPU
{
    SET _UPPER_CPU_CONNECTION TO _UPPER_CPU:GETMODULE("kOSProcessor"):CONNECTION.
    _UPPER_CPU_CONNECTION:SENDMESSAGE("STAGE 2 INITIALIZE").
}



GLOBAL FUNCTION _BOOSTER_ACTIONS
{
    PARAMETER _ACTION.

    IF _ACTION = "TOGGLE SOOT"
    {
        _BOOSTER_INTERSTAGE[0]:GETMODULE("ModuleTundraSoot"):DOACTION("Toggle Soot", true).
        _BOOSTER_TANK[0]:GETMODULE("ModuleTundraSoot"):DOACTION("Toggle Soot", true).
    }
    ELSE IF _ACTION = "INTERSTAGE SEPARATION"
    {
        _BOOSTER_INTERSTAGE[0]:GETMODULE("ModuleTundraDecoupler"):DOACTION("Decouple", true).
    }
}



GLOBAL FUNCTION _LANDING_BURN_VARIABLES
{
    LOCK _TRUE_RADAR TO ALT:RADAR - _BOOSTER_HEIGHT.
    LOCK _GRAVITY TO CONSTANT:G * BODY:MASS / BODY:RADIUS ^ 2.
    LOCK _MAX_DECEL TO SHIP:AVAILABLETHRUST / SHIP:MASS - _GRAVITY.
    LOCK _STOP_DISTANCE TO SHIP:VERTICALSPEED ^ 2 / (2 * _MAX_DECEL).
    LOCK _BURN_THROTTLE TO _STOP_DISTANCE / _TRUE_RADAR. // Landing Burn Throttling
}



LOCAL FUNCTION _GET_IMPACT 
{
    IF addons:tr:hasimpact {
        return addons:tr:impactpos.
        // return ship:position + (ship:velocity:surface:mag * addons:tr:timetillimpact - 3).
    }

    return ship:geoPosition.
}



LOCAL FUNCTION _POSITION_ERROR 
{
    return _GET_IMPACT():position - _LANDING_TARGET:position.
}



GLOBAL FUNCTION _LANDING_ZONE_GUIDANCE 
{ // Copied from saturn code - edwinrobert
    local _ERRORVECTOR is _POSITION_ERROR().
    local _VELOCITYVECTOR is -ship:velocity:surface.
    local _RESULT is _VELOCITYVECTOR + _ERRORVECTOR * 1.

    if vAng(_RESULT, _VELOCITYVECTOR) > _ANGLE_OF_ATTACK_LIMIT {
        set _RESULT to _VELOCITYVECTOR:normalized + TAN(_ANGLE_OF_ATTACK_LIMIT) * _ERRORVECTOR:normalized.
    }

    return lookDirUp(_RESULT, facing:topvector).
}



GLOBAL FUNCTION _CALC_DISTANCE 
{
    parameter geo1, geo2.

    return (geo1:position - geo2:position):mag.
}



LOCAL FUNCTION _GEO_DIR 
{
    parameter geo1, geo2.

    return arcTan2(geo1:lng - geo2:lng, geo1:lat - geo2:lat).
}



GLOBAL FUNCTION _BOOSTBACK_STEERING
{
    parameter _PITCH IS 1, _OVSHTLATMOD is 0, _OVSHTLNGMOD is 0.

    set _OVSHTLATLNG to latlng(_LANDING_TARGET:lat + _OVSHTLATMOD, _LANDING_TARGET:lng + _OVSHTLNGMOD). // Sets overshooting distances
    set _TGTDIRECTION to _GEO_DIR(addons:tr:impactpos, _OVSHTLATLNG). // Set direction based on overshooting
    set _DISTANCE_IMPACT to _CALC_DISTANCE(_OVSHTLATLNG, addons:tr:impactpos). // Distance to impact updates
    set _STEERDIRECTION to _TGTDIRECTION - 180. // Direction changer

    print "DIST TO IMPACT: " + _DISTANCE_IMPACT at (10, 10). 

    IF _RECOVERY_TYPE = "RTLS" 
    { // RTLS landings
        LOCK STEERING TO HEADING(_STEERDIRECTION, _PITCH, 0).
    } 
    ELSE IF _RECOVERY_TYPE = "ASDS"  
    { // For the ASDS landing boostback correction
        LOCK STEERING TO HEADING(_STEERDIRECTION, _PITCH, 0).
    }
}
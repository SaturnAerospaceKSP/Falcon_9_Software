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
// SCRIPT: (GROUND) EVENTS

GLOBAL FUNCTION _INITIALIZE_BOOSTER_CPU
{
    SET _BOOSTER_CPU_CONNECTION TO _BOOSTER_CPU:GETMODULE("kOSProcessor"):CONNECTION.
    _BOOSTER_CPU_CONNECTION:SENDMESSAGE(_MISSION_TYPE).
}



GLOBAL FUNCTION _IGNITE_BOOSTER_ENGINES
{
    LOCK THROTTLE TO 1.
    _BOOSTER_ENGINE_CONTROL("STARTUP"). // Engage engines
    _BOOSTER_ENGINE_CONTROL("NINE ENGINES").
}



GLOBAL FUNCTION _RELEASE_FALCON_9
{
    SET _RELEASE_CONFIRMED TO TRUE.
    
    SET _CURRENT_VEHICLE_PITCH TO round(90 - vAng(SHIP:UP:FOREVECTOR, SHIP:FACING:FOREVECTOR)).
    _GET_FALCON_PROPELLANT("BOTH"). 

    // LISTED CASES OF STOPPING RELEASE OF FALCON 9
        IF SHIP:MAXTHRUST < 50 {SET _RELEASE_CONFIRMED TO FALSE.}
        IF _CURRENT_VEHICLE_PITCH < 88 OR _CURRENT_VEHICLE_PITCH > 92 {SET _RELEASE_CONFIRMED TO FALSE.}
        // IF _BOOSTER_FUEL_PERCENTAGE < 98 OR _BOOSTER_OXID_PERCENTAGE < 98 {SET _RELEASE_CONFIRMED TO FALSE.}
        IF SHIP:AIRSPEED > 2 {SET _RELEASE_CONFIRMED TO FALSE.}

    // RELEASE
        IF _RELEASE_CONFIRMED {_LAUNCH_CLAMP_ACTIONS(_CURRENT_LAUNCH_CLAMP, "RELEASE").}
        IF not _RELEASE_CONFIRMED {_FALCON_PAD_ABORT().}

    WAIT 2.
    WAIT UNTIL VESSEL("FALCON 9"):ALTITUDE > 50. // The ground waits for F9 to be lifted off
}



GLOBAL FUNCTION _COUNTDOWN_EVENTS 
{
    PARAMETER _CURRENT_TIME.

    IF _CURRENT_TIME = _COUNTDOWN_STRONGBACK_RETRACT        {_LAUNCH_CLAMP_ACTIONS(_CURRENT_LAUNCH_CLAMP, "RETRACT STRONGBACK").}
    ELSE IF _CURRENT_TIME = _COUNTDOWN_BOOSTER_IGNITION + 3 {SET KUNIVERSE:TIMEWARP:WARP TO 0. _INITIALIZE_BOOSTER_CPU().} // Check booster for connection 
    ELSE IF _CURRENT_TIME = _COUNTDOWN_BOOSTER_IGNITION + 1.5 {IF CORE:MESSAGES:EMPTY {_FALCON_PAD_ABORT().}}
    ELSE IF _CURRENT_TIME = _COUNTDOWN_BOOSTER_IGNITION     {_IGNITE_BOOSTER_ENGINES().}
}



GLOBAL FUNCTION _FALCON_PAD_ABORT
{
    LOCK THROTTLE TO 0.
    _BOOSTER_ENGINE_CONTROL("SHUTDOWN").

    CLEARSCREEN.
    PRINT "PAD ABORT INITIATED @ " + _FORMAT_SECONDS(_TICK).
    LOG "HOLD" TO "0:/Logs/Mission_Time.txt".

    REBOOT.
} 
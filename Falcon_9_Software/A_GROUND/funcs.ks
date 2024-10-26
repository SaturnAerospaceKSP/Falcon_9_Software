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
// SCRIPT: (GROUND) FUNCS

GLOBAL FUNCTION _MISSION_COUNTDOWN
{
    PARAMETER _VESSEL_TIME IS FALSE, _PLANET_TIME IS FALSE, _LAN_TIME IS FALSE.

    CLEARSCREEN.
    SET _TICK TO _COUNTDOWN_START_TIME.

    IF _VESSEL_TIME 
    {  // WAIT FOR VESSEL OVERHEAD

    }
    ELSE IF _PLANET_TIME
    { // WAIT FOR RELATIVE INCLINATION TO BE LOW

    }
    ELSE IF _LAN_TIME
    { // LAUNCH TO SPECIFIC LAN

    }
    ELSE 
    { // NO TARGETS - NORMAL COUNTDOWN
        UNTIL _TICK = 0 
        { // 4 Counts per second

            PRINT "T-" + _FORMAT_SECONDS(_TICK) + "   " AT (0,0).
            LOG "T-" + _FORMAT_SECONDS(_TICK) TO "0:/Logs/Mission_Time.txt".

            _COUNTDOWN_EVENTS(_TICK).
            _FALCON_9_VALIDITY_CHECK(_TICK).

            SET _TICK TO _TICK - 0.25.
            WAIT 0.25. 
        }   
    }
}



LOCAL FUNCTION _FALCON_9_VALIDITY_CHECK
{
    PARAMETER _CURRENT_TIME.

    IF _CURRENT_TIME >= _COUNTDOWN_LAST_MANUAL_ABORT
    { // Before auto aborts
        // FALCON 9 CHECKING ITSELF
            _GET_FALCON_PROPELLANT("BOTH").
            // CHECK CODE

        // HOLDING
            IF AG9 
            {
                AG9 OFF.
                SET _HOLD_TIME TO _TICK.
                CLEARSCREEN.
                
                UNTIL AG6 
                {
                    SET _TICK TO _HOLD_TIME.
                    PRINT "HOLDING COUNT @ " + _FORMAT_SECONDS(_TICK) AT (0,0).
                    PRINT "AG6 = CONTINUE" AT (0,1).
                    PRINT "AG9 = REBOOT" AT (0,2).

                    IF AG9 {AG9 OFF. REBOOT.} // Close script and restart
                }

                AG6 OFF.
            }
    }
    ELSE 
    { // Auto Aborts
    
    }
}



// GROUND ACTIONS
GLOBAL FUNCTION _LAUNCH_CLAMP_ACTIONS
{
    PARAMETER _CLAMP, _ACTION.

    IF _CLAMP = "40TU" 
    {
        IF _ACTION = "RETRACT STRONGBACK"
        {
            IF _LAUNCH_CLAMP[0]:GETMODULE("ModuleAnimateGeneric"):HASEVENT("Open Erector")
            {
                _LAUNCH_CLAMP[0]:GETMODULE("ModuleAnimateGeneric"):DOEVENT("Open Erector").
            }
        }
        ELSE IF _ACTION = "REVERT STRONGBACK"
        {
            IF _LAUNCH_CLAMP[0]:GETMODULE("ModuleAnimateGeneric"):HASEVENT("Close Erector")
            {
                _LAUNCH_CLAMP[0]:GETMODULE("ModuleAnimateGeneric"):DOEVENT("Close Erector").
            }
        }
        ELSE IF _ACTION = "RELEASE"
        {
            IF _LAUNCH_CLAMP[0]:GETMODULE("ModuleTundraDecoupler"):HASEVENT("Decouple")
            {
                _LAUNCH_CLAMP[0]:GETMODULE("ModuleTundraDecoupler"):DOEVENT("Decouple").
            }
        }
    } ELSE IF _CLAMP = "39TU"
    {
        IF _ACTION = "RETRACT STRONGBACK" 
        {
            IF _LAUNCH_CLAMP[0]:GETMODULE("ModuleAnimateGeneric"):HASEVENT("Open Erector")
            {
                _LAUNCH_CLAMP[0]:GETMODULE("ModuleAnimateGeneric"):DOEVENT("Open Erector").
            }
        }
        ELSE IF _ACTION = "REVERT STRONGBACK" 
        {
            IF _LAUNCH_CLAMP[0]:GETMODULE("ModuleAnimateGeneric"):HASEVENT("Close Erector")
            {
                _LAUNCH_CLAMP[0]:GETMODULE("ModuleAnimateGeneric"):DOEVENT("Close Erector").
            }
        }
        ELSE IF _ACTION = "RELEASE" 
        {
            IF _LAUNCH_CLAMP[0]:GETMODULE("ModuleTundraDecoupler"):HASACTION("Decouple")
            {
                _LAUNCH_CLAMP[0]:GETMODULE("ModuleTundraDecoupler"):DOACTION("Decouple", true).
            }
        }
    }
}
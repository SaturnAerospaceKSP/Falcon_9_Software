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
// SCRIPT: (BOOSTER) MAIN 
//

PARAMETER _MISSION_INIT_TYPE.
__BOOSTER_MAIN__().

LOCAL FUNCTION __BOOSTER_MAIN__
{ // The main function to tell the launch pad what to do
    // FILE INITIALIZATION
        RUNONCEPATH("0:/libraries/EXTERNAL/External_Libs.ks"). // Libraries From External Sources
        RUNONCEPATH("0:/Falcon_9_Software/INITIALIZATION/settings_init.ks"). // Settings & Configg
        RUNONCEPATH("0:/Falcon_9_Software/INITIALIZATION/booster_init.ks"). // Load booster parts while attached
        RUNONCEPATH("0:/Falcon_9_Software/INITIALIZATION/upper_stage_init.ks"). // Load booster parts while attached
        RUNONCEPATH("0:/libraries/PROPELLANT/Falcon_Fuel.ks"). // Fuel on F9 itself
        RUNONCEPATH("0:/Falcon_9_Software/B_BOOSTER_STAGE/funcs.ks"). // Booster Functions
        RUNONCEPATH("0:/Falcon_9_Software/B_BOOSTER_STAGE/events.ks"). // Booster Events
        RUNONCEPATH("0:/libraries/COMMUNICATIONS/F9_CommLink.ks"). // Communications
        RUNONCEPATH("0:/libraries/CONTROL/Engine_Control_Unit.ks"). // F9 Engine Control 
        RUNONCEPATH("0:/libraries/CONTROL/Grid_Fins.ks"). // Grid Fin control
        RUNONCEPATH("0:/libraries/CONTROL/Landing_Legs.ks"). // Landing Legs on the Booster
        RUNONCEPATH("0:/libraries/CONTROL/RCS_Unit.ks"). // Reaction Control System
        RUNONCEPATH("0:/libraries/GUIDANCE/Booster_guidance.ks"). // Booster ascent guidance
    // ===================

    // ENSURE STATE 
        CLEARSCREEN.
        PRINT "BOOSTER MAIN BEGUN" AT (0,0).
        SAS OFF.
        BRAKES OFF.
        AG6 OFF. AG9 OFF. AG4 OFF. AG10 OFF.
        RADIATORS ON. 
        SET STEERINGMANAGER:MAXSTOPPINGTIME TO 10.
        SET STEERINGMANAGER:ROLLTS TO 20.
    // ===================

    // PING THE GROUND 
        SET _GROUND_CPU TO SHIP:PARTSTAGGED("GROUNDCPU")[0].
        SET _GROUND_CPU_CONNECTION TO _GROUND_CPU:GETMODULE("kOSProcessor"):CONNECTION.
        _GROUND_CPU_CONNECTION:SENDMESSAGE("FALCON 9 BOOSTER ALIVE").
    // ===================

    // BOOSTER SEQUENCE
        IF _MISSION_INIT_TYPE = "LAUNCH" 
        {
            _BOOSTER_GRAVITY_TURN_ASCENT().
            _BOOSTER_STAGE_SEPARATION().
            IF _RECOVERY_TYPE = "ASDS" or _RECOVERY_TYPE = "RTLS"
            { // RECOVERY 
                _BOOSTER_BOOSTBACK_BURN().
                _BOOSTER_ATMOSPHERIC_GUIDANCE().
                _BOOSTER_LANDING_BURN(). 
            }
            IF SHIP:AIRSPEED > 2 {SET SHIP:NAME TO "FALCON 9".}
        } ELSE IF _MISSION_INIT_TYPE = "STATIC FIRE"
        {
            // CODE SOON
        }
    // ===================
}
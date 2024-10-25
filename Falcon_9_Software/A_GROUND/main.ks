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
// SCRIPT: (GROUND) MAIN

__GROUND_MAIN__().

LOCAL FUNCTION __GROUND_MAIN__
{ // The main function to tell the launch pad what to do
    // FILE INITIALIZATION
        RUNONCEPATH("0:/libraries/EXTERNAL/External_Libs.ks"). // Libraries From External Sources
        RUNONCEPATH("0:/libraries/PROPELLANT/Dragon_Propellant.ks"). // Fuel on Dragon Capsule
        RUNONCEPATH("0:/Falcon_9_Software/INITIALIZATION/settings_init.ks"). // Settings & Config
        RUNONCEPATH("0:/Falcon_9_Software/INITIALIZATION/ground_clamp_init.ks"). // Ground parts & config
        RUNONCEPATH("0:/Falcon_9_Software/INITIALIZATION/booster_init.ks"). // Load booster parts while attached
        RUNONCEPATH("0:/Falcon_9_Software/INITIALIZATION/upper_stage_init.ks"). // Load booster parts while attached
        RUNONCEPATH("0:/libraries/PROPELLANT/Falcon_Fuel.ks"). // Fuel on F9 itself
        RUNONCEPATH("0:/Falcon_9_Software/A_GROUND/funcs.ks"). // Ground Functions
        RUNONCEPATH("0:/Falcon_9_Software/A_GROUND/events.ks"). // Ground Events
        RUNONCEPATH("0:/libraries/COMMUNICATIONS/F9_CommLink.ks"). // Communications
        RUNONCEPATH("0:/libraries/CONTROL/Engine_Control_Unit.ks"). // F9 Engine Control 
        RUNONCEPATH("0:/libraries/CONTROL/Grid_Fins.ks"). // Grid Fin control
        RUNONCEPATH("0:/libraries/CONTROL/Landing_Legs.ks"). // Landing Legs on the Booster
        RUNONCEPATH("0:/libraries/CONTROL/RCS_Unit.ks"). // Reaction Control System
    // ===================

    // ENSURE STATE 
        CLEARSCREEN.
        PRINT "GROUND MAIN BEGUN" AT (0,0).
        SAS OFF.
        BRAKES OFF.
        AG6 OFF. AG9 OFF. AG4 OFF. AG10 OFF.
        RADIATORS ON. 
    // ===================

    // GROUND SEQUENCING
        _MISSION_COUNTDOWN(_LAUNCH_TO_VESSEL, _LAUNCH_TO_PLANET, _LAUNCH_TO_LAN). 
        _RELEASE_FALCON_9().
    // ===================

    // NOW SHUTDOWN 
        SHUTDOWN. 
    // ===================
}
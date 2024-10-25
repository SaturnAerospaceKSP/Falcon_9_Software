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
// SCRIPT: (STAGE 2) MAIN
//

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
// SCRIPT: (STAGE 2) MAIN 
//

__STAGE_2_MAIN__().

LOCAL FUNCTION __STAGE_2_MAIN__
{ // The main function to tell the launch pad what to do
    // FILE INITIALIZATION
        RUNONCEPATH("0:/libraries/EXTERNAL/External_Libs.ks"). // Libraries From External Sources
        RUNONCEPATH("0:/Falcon_9_Software/INITIALIZATION/settings_init.ks"). // Settings & Configg
        RUNONCEPATH("0:/Falcon_9_Software/INITIALIZATION/upper_stage_init.ks"). // Load stage 2 parts while attached
        RUNONCEPATH("0:/libraries/PROPELLANT/Falcon_Fuel.ks"). // Fuel on F9 itself
        RUNONCEPATH("0:/Falcon_9_Software/C_UPPER_STAGE/funcs.ks"). // Stage 2 Functions
        RUNONCEPATH("0:/Falcon_9_Software/C_UPPER_STAGE/events.ks"). // Stage 2 Events
        RUNONCEPATH("0:/libraries/COMMUNICATIONS/F9_CommLink.ks"). // Communications
        RUNONCEPATH("0:/libraries/CONTROL/Engine_Control_Unit.ks"). // F9 Engine Control 
        RUNONCEPATH("0:/libraries/CONTROL/RCS_Unit.ks"). // Reaction Control System
        RUNONCEPATH("0:/libraries/GUIDANCE/Upper_Stage_Guidance.ks"). // Stage 2 guidance
    // ===================

    // ENSURE STATE 
        CLEARSCREEN.
        PRINT "STAGE 2 MAIN BEGUN" AT (0,0).
        SAS OFF.
        BRAKES OFF.
        AG6 OFF. AG9 OFF. AG4 OFF. AG10 OFF.
        RADIATORS ON. 
        SET STEERINGMANAGER:MAXSTOPPINGTIME TO 0.5.
        SET STEERINGMANAGER:ROLLTS TO 20.
    // ===================

    // UPPER STAGE SEQUENCE
        _UPPER_STAGE_INSERTION_BURN().
        _UPPER_STAGE_COAST_APOAPSIS().
        _UPPER_STAGE_RAISE_PERIAPSIS().  
    // =================== 

    // NOW SHUTDOWN 
        SHUTDOWN. 
    // ===================
}
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
// SCRIPT: SETTINGS_INIT
//

RUNONCEPATH("0:/Falcon_9_Software/CONFIG/Settings.ks").
RUNONCEPATH("0:/Falcon_9_Software/CONFIG/Landing_Sites.ks").
RUNONCEPATH("0:/libraries/EXTERNAL/External_Libs.ks"). 
_SETTINGS_INITIALIZATION(). 

LOCAL FUNCTION _SETTINGS_INITIALIZATION 
{
    // initialize all of the required variables and details for the mission
    SET _LAUNCH_TO_VESSEL TO FALSE.
    SET _LAUNCH_TO_PLANET TO FALSE.
    SET _LAUNCH_TO_LAN    TO FALSE.
    SET _COUNTDOWN_START_TIME TO -1.
    GLOBAL _MISSION_TYPE IS _FALCON_9_SETTINGS["MISSION"].



    // Targets
    GLOBAL _MISSION_APOAPSIS_TARGET IS _FALCON_9_SETTINGS["LAUNCH_TARGETS"]["APOAPSIS"] * 1000.
    GLOBAL _MISSION_PERIAPSIS_TARGET IS _FALCON_9_SETTINGS["LAUNCH_TARGETS"]["PERIAPSIS"] * 1000.   
    GLOBAL _MISSION_INCLINE_TARGET IS _FALCON_9_SETTINGS["LAUNCH_TARGETS"]["INCLINATION"].
    GLOBAL _MISSION_LAN_TARGET IS _FALCON_9_SETTINGS["LAUNCH_TARGETS"]["LONG_ASCEND_NODE"].
    GLOBAL _MISSION_DOCKING_TARGET IS _FALCON_9_SETTINGS["LAUNCH_TARGETS"]["TARGET_DOCKING"].
    GLOBAL _MISSION_PLANET_TARGET IS _FALCON_9_SETTINGS["LAUNCH_TARGETS"]["TARGET_PLANET"].
    GLOBAL _MISSION_UNIX_TARGET IS _FALCON_9_SETTINGS["LAUNCH_TARGETS"]["UNIX_TIME"].

    IF _MISSION_LAN_TARGET     = not FALSE {SET _LAUNCH_TO_LAN TO TRUE.}
    IF _MISSION_DOCKING_TARGET = not FALSE {SET _LAUNCH_TO_VESSEL TO TRUE.}
    IF _MISSION_PLANET_TARGET  = not FALSE {SET _LAUNCH_TO_PLANET TO TRUE.}
    IF _MISSION_UNIX_TARGET    = not FALSE {SET _COUNTDOWN_START_TIME TO _MISSION_UNIX_TARGET - KUNIVERSE:REALWORLDTIME.}



    // Safety Margins
    GLOBAL _SAFETY_ACCELERATION_LIMIT IS _FALCON_9_SETTINGS["SAFETY_MARGINS"]["G_FORCE_LIMIT"].
    GLOBAL _SAFETY_MAX_PITCH_DEVIATION IS _FALCON_9_SETTINGS["SAFETY_MARGINS"]["MAX_PITCH_DEVIATION"].



    // Recovery Settings
    GLOBAL _RECOVERY_TYPE IS _FALCON_9_SETTINGS["RECOVERY_SETTINGS"]["TYPE"].
    GLOBAL _RECOVERY_ENTRY_BURN IS _FALCON_9_SETTINGS["RECOVERY_SETTINGS"]["ENTRY_BURN"].
    GLOBAL _RECOVERY_LANDING_ENGINES IS _FALCON_9_SETTINGS["RECOVERY_SETTINGS"]["LANDING_BURN_ENG"].
    GLOBAL _SOOT_TOGGLE IS _FALCON_9_SETTINGS["RECOVERY_SETTINGS"]["TOGGLE_SOOT"].
    GLOBAL _LANDING_ZONE_SELECTION IS _FALCON_9_SETTINGS["RECOVERY_SETTINGS"]["LANDING_ZONE"].
    IF _RECOVERY_TYPE = "ASDS" {GLOBAL _RECOVERY_BOOSTER_FUEL_CUTOFF IS _FALCON_9_SETTINGS["RECOVERY_SETTINGS"]["FUEL_MARGINS"]["ASDS"].}
    ELSE IF _RECOVERY_TYPE = "RTLS" {GLOBAL _RECOVERY_BOOSTER_FUEL_CUTOFF IS _FALCON_9_SETTINGS["RECOVERY_SETTINGS"]["FUEL_MARGINS"]["RTLS"].}
    ELSE {GLOBAL _RECOVERY_BOOSTER_FUEL_CUTOFF IS 1.}
    



    // Countdown Timings
    IF _MISSION_UNIX_TARGET = FALSE {SET _COUNTDOWN_START_TIME TO _FORMAT_LEXICON_TIME(_FALCON_9_SETTINGS["COUNTDOWN_TIMINGS"]["BEGIN_COUNTDOWN"]).}
    GLOBAL _COUNTDOWN_CREW_ARM IS _FORMAT_LEXICON_TIME(_FALCON_9_SETTINGS["COUNTDOWN_TIMINGS"]["CREW_ARM_RETRACT"]).
    GLOBAL _COUNTDOWN_STRONGBACK_RETRACT IS _FORMAT_LEXICON_TIME(_FALCON_9_SETTINGS["COUNTDOWN_TIMINGS"]["RETRACT_STRONGBACK"]).
    GLOBAL _COUNTDOWN_LAST_MANUAL_ABORT IS _FORMAT_LEXICON_TIME(_FALCON_9_SETTINGS["COUNTDOWN_TIMINGS"]["LAST_MANUAL_ABORT"]).
    GLOBAL _COUNTDOWN_BOOSTER_IGNITION IS _FORMAT_LEXICON_TIME(_FALCON_9_SETTINGS["COUNTDOWN_TIMINGS"]["BOOSTER_IGNITION"]).

    

    // DATA
    IF EXISTS("0:/Logs/Mission_Time.txt") {DELETEPATH("0:/Logs/Mission_Time.txt"). LOG "N/A" TO "0:/Logs/Mission_Time.txt".}
}
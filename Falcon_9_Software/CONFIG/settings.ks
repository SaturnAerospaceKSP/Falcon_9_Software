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
// SCRIPT: SETTINGS

GLOBAL _FALCON_9_SETTINGS IS LEXICON(
    "MISSION", "LAUNCH", // "LAUNCH" / "STATIC FIRE"

    "LAUNCH_TARGETS", LEXICON(
        "APOAPSIS",         245,   // Highest point of orbit (Km)
        "PERIAPSIS",        105,   // Lowest point (Km)
        "INCLINATION",      -40,     // Inclination from Equator (Deg)
        "LONG_ASCEND_NODE", FALSE, // Longitude of Ascending Node target
        "TARGET_DOCKING",   FALSE, // FALSE OR vessel("ShipName")
        "TARGET_PLANET",    FALSE, // FALSE OR name of planet
        "UNIX_TIME",        FALSE  // Leave at 0 when not in use. | This website gives UNIX times - https://unixtimeconverter.net/
    ),  
    
    "SAFETY_MARGINS", LEXICON(
        "G_FORCE_LIMIT",            2.5,   // Acceleration throughout mission
        "MAX_PITCH_DEVIATION",      4.0    // Pitch deviation throughout flight until abort triggers
    ),

    "RECOVERY_SETTINGS", LEXICON(
        "TYPE",             "ASDS",  // "ASDS" / "RTLS" / "EXPD"
        "ENTRY_BURN",       TRUE,    // TRUE / FALSE - Arguably, no burn needed unless RSS 
        "LANDING_BURN_ENG", 3,       // 1 / 3 - How many engines for landing burn?
        "TOGGLE_SOOT",      TRUE,    // TRUE / FALSE
        "LANDING_ZONE",     "KSC 1", // "KSC 1" / "KSC 2" / "KSC 3" / "CUSTOM 1" / "CUSTOM 2" - ONLY REQUIRED RTLS (ASDS IS AUTOMATIC)
        "FUEL_MARGINS", LEXICON(
            "RTLS", 25.0,   // % Of LiquidFuel on MECO
            "ASDS", 22.0    // ^^  
        )
    ),

    "COUNTDOWN_TIMINGS", LEXICON(
        "BEGIN_COUNTDOWN",    LEXICON("HOURS", 0,   "MINS", 0,   "SECONDS", 15), // Start countdown time (only when unix not used)
        "CREW_ARM_RETRACT",   LEXICON("HOURS", 0,   "MINS", 42,   "SECONDS", 0),
        "RETRACT_STRONGBACK", LEXICON("HOURS", 0,   "MINS", 4,   "SECONDS", 0), 
        "LAST_MANUAL_ABORT",  LEXICON("HOURS", 0,   "MINS", 0,   "SECONDS", 30), // Last time to manually abort with AG9 
        "BOOSTER_IGNITION",   LEXICON("HOURS", 0,   "MINS", 0,   "SECONDS", 3)
    )

).
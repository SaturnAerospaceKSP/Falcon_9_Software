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
// SCRIPT: BOOSTER_INIT
//

_BOOSTER_PART_SETUP().

LOCAL FUNCTION _BOOSTER_PART_SETUP
{
    SET _ANGLE_OF_ATTACK_LIMIT TO 10.
    SET _BOOSTER_HEIGHT TO 31.02. // Can be changed if booster is taller / shorter
    _CHOOSE_LANDING_ZONE().

    GLOBAL _BOOSTER_INTERSTAGE IS SHIP:PARTSTITLED("VC-13B Booster Guidance Unit").
    GLOBAL _BOOSTER_TANK IS SHIP:PARTSTITLED("Ghidorah K1-180 Tank").
    GLOBAL _BOOSTER_ENGINES IS SHIP:PARTSTITLED("VL-9R " + CHAR(34) + "Octopus" + CHAR(34) + " Liquid Fuel Engine").
    GLOBAL _BOOSTER_RCS_PORTS IS SHIP:PARTSTITLED("Advanced Haddock Gas Thruster").
    GLOBAL _BOOSTER_CPU IS SHIP:PARTSTAGGED("BOOSTERCPU")[0].

}

LOCAL FUNCTION _CHOOSE_LANDING_ZONE
{
    LOCAL _LANDING_ZONE_KSC_ONE IS _LANDING_SITES["KENNEDY_SPACE_CENTER"]["LANDING_ZONE_1"].
    LOCAL _LANDING_ZONE_KSC_TWO IS _LANDING_SITES["KENNEDY_SPACE_CENTER"]["LANDING_ZONE_2"].
    LOCAL _LANDING_ZONE_KSC_THREE IS _LANDING_SITES["KENNEDY_SPACE_CENTER"]["LANDING_ZONE_3"].

    LOCAL _CUSTOM_SITE_ONE IS _LANDING_SITES["CUSTOM_SITES"]["SITE_1"].
    LOCAL _CUSTOM_SITE_TWO IS _LANDING_SITES["CUSTOM_SITES"]["SITE_2"].

    IF _LANDING_ZONE_SELECTION = "KSC 1" {GLOBAL _LANDING_TARGET IS _LANDING_ZONE_KSC_ONE.}
    IF _LANDING_ZONE_SELECTION = "KSC 2" {GLOBAL _LANDING_TARGET IS _LANDING_ZONE_KSC_TWO.}
    IF _LANDING_ZONE_SELECTION = "KSC 3" {GLOBAL _LANDING_TARGET IS _LANDING_ZONE_KSC_THREE.}
    IF _LANDING_ZONE_SELECTION = "CUSTOM 1" {GLOBAL _LANDING_TARGET IS _CUSTOM_SITE_ONE.}
    IF _LANDING_ZONE_SELECTION = "CUSTOM 2" {GLOBAL _LANDING_TARGET IS _CUSTOM_SITE_TWO.}

    IF _RECOVERY_TYPE = "ASDS" {GLOBAL _LANDING_TARGET IS VESSEL("DRONESHIP_MAIN"):GEOPOSITION.} // CHANGE THIS IF YOUR DRONESHIP NAME IS DIFFERENT
}
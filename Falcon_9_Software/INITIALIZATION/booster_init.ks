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



    IF _LANDING_ZONE_KSC_ONE:DISTANCE < _LANDING_ZONE_KSC_TWO:DISTANCE and _LANDING_ZONE_KSC_ONE:DISTANCE < _LANDING_ZONE_KSC_THREE:DISTANCE and _LANDING_ZONE_KSC_ONE:DISTANCE < _CUSTOM_SITE_ONE:DISTANCE and _LANDING_ZONE_KSC_ONE:DISTANCE < _CUSTOM_SITE_TWO:DISTANCE 
    {
        GLOBAL _LANDING_TARGET IS _LANDING_ZONE_KSC_ONE.
    }
    ELSE IF _LANDING_ZONE_KSC_TWO:DISTANCE < _LANDING_ZONE_KSC_ONE:DISTANCE and _LANDING_ZONE_KSC_TWO:DISTANCE < _LANDING_ZONE_KSC_THREE:DISTANCE and _LANDING_ZONE_KSC_TWO:DISTANCE < _CUSTOM_SITE_ONE:DISTANCE and _LANDING_ZONE_KSC_TWO:DISTANCE < _CUSTOM_SITE_TWO:DISTANCE 
    {
        GLOBAL _LANDING_TARGET IS _LANDING_ZONE_KSC_TWO.
    }
    ELSE IF _LANDING_ZONE_KSC_THREE:DISTANCE < _LANDING_ZONE_KSC_ONE:DISTANCE and _LANDING_ZONE_KSC_THREE:DISTANCE < _LANDING_ZONE_KSC_TWO:DISTANCE and _LANDING_ZONE_KSC_THREE:DISTANCE < _CUSTOM_SITE_ONE:DISTANCE and _LANDING_ZONE_KSC_THREE:DISTANCE < _CUSTOM_SITE_TWO:DISTANCE 
    {
        GLOBAL _LANDING_TARGET IS _LANDING_ZONE_KSC_THREE.
    }
    ELSE IF _CUSTOM_SITE_ONE:DISTANCE < _LANDING_ZONE_KSC_ONE:DISTANCE and _CUSTOM_SITE_ONE:DISTANCE < _LANDING_ZONE_KSC_TWO:DISTANCE and _CUSTOM_SITE_ONE:DISTANCE < _LANDING_ZONE_KSC_THREE:DISTANCE and _CUSTOM_SITE_ONE:DISTANCE < _CUSTOM_SITE_TWO:DISTANCE 
    {
        GLOBAL _LANDING_TARGET IS _CUSTOM_SITE_ONE.
    }
    ELSE IF _CUSTOM_SITE_TWO:DISTANCE < _LANDING_ZONE_KSC_ONE:DISTANCE and _CUSTOM_SITE_TWO:DISTANCE < _LANDING_ZONE_KSC_TWO:DISTANCE and _CUSTOM_SITE_TWO:DISTANCE < _LANDING_ZONE_KSC_THREE:DISTANCE and _CUSTOM_SITE_TWO:DISTANCE < _CUSTOM_SITE_ONE:DISTANCE 
    {
        GLOBAL _LANDING_TARGET IS _CUSTOM_SITE_TWO.
    }
}
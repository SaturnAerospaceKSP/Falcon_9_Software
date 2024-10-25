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
// SCRIPT: UPPER_STAGE_INIT
//

_UPPER_STAGE_PART_SETUP().

LOCAL FUNCTION _UPPER_STAGE_PART_SETUP
{
    SET _RIDESHARE_CONFIG  TO FALSE.
    SET _STANDARD_CONFIG   TO FALSE.
    SET _DRAGON_CONFIG     TO FALSE.

    IF SHIP:PARTSTITLED("T-625 Top Rideshare Adapter"):LENGTH > 0 {SET _RIDESHARE_CONFIG TO TRUE.} ELSE {SET _STANDARD_CONFIG TO TRUE.}
    IF SHIP:PARTSTITLED("VC-13C SpaceCraft Separator"):LENGTH > 0 {SET _DRAGON_CONFIG TO TRUE.}

    IF _RIDESHARE_CONFIG 
    {
        IF SHIP:PARTSTITLED("G-01 Fairing Half"):LENGTH > 0 {GLOBAL _UPPER_FAIRING_HALVES IS SHIP:PARTSTITLED("G-01 Fairing Half").}
        ELSE IF SHIP:PARTSTITLED("G-02 Extended Fairing Half"):LENGTH > 0 {GLOBAL _UPPER_FAIRING_HALVES IS SHIP:PARTSTITLED("G-02 Extended Fairing Half").}
        
        IF SHIP:PARTSTITLED("T-625 Top Rideshare Adapter"):LENGTH > 0 {SET _RIDESHARE_TOP_PART TO SHIP:PARTSTITLED("T-625 Top Rideshare Adapter").}
        IF SHIP:PARTSTITLED("T-625 Rideshare Adapter"):LENGTH > 0 {SET _RIDESHARE_LARGE_ADAPTER TO SHIP:PARTSTITLED("T-625 Rideshare Adapter").}
        IF SHIP:PARTSTITLED("T-3125 Rideshare Adapter"):LENGTH > 0 {SET _RIDESHARE_SMALL_ADAPTER TO SHIP:PARTSTITLED("T-3125 Rideshare Adapter").}
    }
    ELSE IF _STANDARD_CONFIG 
    {
        IF SHIP:PARTSTITLED("G-01 Fairing Half"):LENGTH > 0 {GLOBAL _UPPER_FAIRING_HALVES IS SHIP:PARTSTITLED("G-01 Fairing Half").}
        ELSE IF SHIP:PARTSTITLED("G-02 Extended Fairing Half"):LENGTH > 0 {GLOBAL _UPPER_FAIRING_HALVES IS SHIP:PARTSTITLED("G-02 Extended Fairing Half").}
    }
    ELSE IF _DRAGON_CONFIG 
    {
        SET _DRAGON_SEPARATOR TO SHIP:PARTSTITLED("VC-13C SpaceCraft Separator").
    }


    GLOBAL _UPPER_STAGE_TANK IS SHIP:PARTSTITLED("Ghidorah K2-81 Tank").
    GLOBAL _UPPER_STAGE_VACCUM_ENGINE IS SHIP:PARTSTITLED("RU-1K " + CHAR(34) + "Marlin" + CHAR(34) + " Vacuum Engine").
    GLOBAL _UPPER_RCS_PORTS IS SHIP:PARTSTITLED("3-way Barracuda Thruster").
    GLOBAL _UPPER_CPU IS SHIP:PARTSTAGGED("UPPERCPU")[0].

}
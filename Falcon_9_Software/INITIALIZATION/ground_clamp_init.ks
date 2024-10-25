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
// SCRIPT: GROUND_CLAMP_INIT
//

_GROUND_PART_SETUP().

LOCAL FUNCTION _GROUND_PART_SETUP
{
    GLOBAL _CURRENT_LAUNCH_CLAMP IS "".

    IF SHIP:PARTSTITLED("Ghidorah 40 Launcher Platform"):LENGTH > 0 {SET _CURRENT_LAUNCH_CLAMP TO "40TU".}
    IF SHIP:PARTSTITLED("Falcon 9 Pad 40 Rebuilt"):LENGTH > 0       {SET _CURRENT_LAUNCH_CLAMP TO "40S8".}
    IF SHIP:PARTSTITLED("Ghidorah Launcher Platform"):LENGTH > 0    {SET _CURRENT_LAUNCH_CLAMP TO "39TU".}
    IF SHIP:PARTSTITLED("39A Launch Pad"):LENGTH > 0                {SET _CURRENT_LAUNCH_CLAMP TO "39S8".}

    IF _CURRENT_LAUNCH_CLAMP = "40TU" 
    {
        GLOBAL _LAUNCH_CLAMP IS SHIP:PARTSTITLED("Ghidorah 40 Launcher Platform").
        
    }
    ELSE IF _CURRENT_LAUNCH_CLAMP = "40S8" 
    {

    }
    ELSE IF _CURRENT_LAUNCH_CLAMP = "39TU"
    {

    }
    ELSE IF _CURRENT_LAUNCH_CLAMP = "39S8"
    {
        
    }

    GLOBAL _GROUND_CPU IS SHIP:PARTSTAGGED("GROUNDCPU")[0]. // Universal Part independant of launch clamp
}
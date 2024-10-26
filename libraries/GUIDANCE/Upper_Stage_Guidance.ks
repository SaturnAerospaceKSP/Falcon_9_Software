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
// SCRIPT: UPPER_STAGE_GUIDANCE
//

GLOBAL FUNCTION _UPPER_STAGE_GUIDANCE_LOOP
{
    LOCAL _APOAPSIS_OFFSET IS SHIP:APOAPSIS - BODY:ATM:HEIGHT + 10000.
    LOCAL _HALF_ETA_APOAPSIS IS 15 - ETA:APOAPSIS.

    SET _HEADING_CONTROL TO _LAUNCH_AZIMUTH(_MISSION_INCLINE_TARGET, _MISSION_APOAPSIS_TARGET).
    SET _PITCH_CONTROL TO (_HALF_ETA_APOAPSIS * 2) + ((_APOAPSIS_OFFSET / 5000) * 10).

    SET _PITCH_CONTROL TO MAX(-8, MIN(10, _PITCH_CONTROL)).

    IF SHIP:APOAPSIS < BODY:ATM:HEIGHT AND _PITCH_CONTROL < 0 {SET _PITCH_CONTROL TO 0.}
    IF SHIP:APOAPSIS > BODY:ATM:HEIGHT AND SHIP:PERIAPSIS > -50000 {SET _PITCH_CONTROL TO 0.}
    IF SHIP:VERTICALSPEED < 0 {SET _PITCH_CONTROL TO -SHIP:VERTICALSPEED + 1.75.}

    LOCK STEERING TO HEADING(_HEADING_CONTROL, _PITCH_CONTROL, 0).
}
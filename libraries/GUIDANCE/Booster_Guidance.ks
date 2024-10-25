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
// SCRIPT: BOOSTER_GUIDANCE
//

GLOBAL FUNCTION _GRAVITY_TURN
{
    LOCAL _FINISH_ALTITUDE IS (BODY:ATM:HEIGHT - 35000).
    LOCAL _FINISH_PITCH IS    25.
    LOCAL _MAX_G_FORCE IS     _SAFETY_ACCELERATION_LIMIT.  // Max G (works with Q (dynamic))
    LOCAL _EARTH_GRAVITY IS   9.81. // M/S^2

    // GUIDANCE
        // LOCAL _CURRENT_ACCEL IS SHIP:MAXTHRUST / (SHIP:MASS * _EARTH_GRAVITY).
        LOCAL _ALTITUDE_OFF IS (SHIP:ALTITUDE / _FINISH_ALTITUDE).
        LOCAL _TARGET_PITCH IS 90 - (_ALTITUDE_OFF * (90 - _FINISH_PITCH)).
        LOCAL _HEADING_TARGET IS _LAUNCH_AZIMUTH(_MISSION_INCLINE_TARGET, _FINISH_ALTITUDE).

        // SEPARATION STEER
            IF SHIP:ALTITUDE > _FINISH_ALTITUDE - 5000 {SET _TARGET_PITCH TO _TARGET_PITCH + 5.}

        // MAX Q & G THROTTLE
            SET _ACCEL_THROTTLE TO ((_MAX_G_FORCE * SHIP:MASS * _EARTH_GRAVITY) / SHIP:MAXTHRUST) - 0.2.
            LOCK THROTTLE TO _ACCEL_THROTTLE.

        // STEERING
            LOCK STEERING TO HEADING(_HEADING_TARGET, _TARGET_PITCH, 0).
}
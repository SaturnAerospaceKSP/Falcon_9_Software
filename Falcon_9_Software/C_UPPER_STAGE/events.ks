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
// SCRIPT: (STAGE 2) EVENTS
//

GLOBAL FUNCTION _UPPER_STAGE_INSERTION_BURN
{
    RCS ON.
    SET _CURRENT_DIRECTION_FACING TO SHIP:FACING.
    LOCK STEERING TO _CURRENT_DIRECTION_FACING.

    LOCK THROTTLE TO 0.075.
    _UPPER_VACCUM_ENGINE_CONTROL("STARTUP").

    WAIT 2.
    LOCK THROTTLE TO 1.

    SET _FAIRINGS_ATTACHED TO TRUE.
    WAIT UNTIL SHIP:APOAPSIS > BODY:ATM:HEIGHT + 2000.
    UNTIL SHIP:APOAPSIS > _MISSION_APOAPSIS_TARGET - 2000 
    {
        IF SHIP:ALTITUDE > BODY:ATM:HEIGHT AND _FAIRINGS_ATTACHED {SET _FAIRINGS_ATTACHED TO FALSE. _FAIRING_ACTIONS("DEPLOY").}

        _GET_FALCON_PROPELLANT("UPPER STAGE").
        _UPPER_STAGE_GUIDANCE_LOOP(). 
    }

    LOCK THROTTLE TO 0.
}



GLOBAL FUNCTION _UPPER_STAGE_COAST_APOAPSIS 
{

}



GLOBAL FUNCTION _UPPER_STAGE_RAISE_PERIAPSIS
{

}
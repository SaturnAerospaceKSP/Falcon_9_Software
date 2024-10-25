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
// SCRIPT: FALCON_FUEL
//

GLOBAL FUNCTION _GET_FALCON_PROPELLANT
{
    PARAMETER _STAGE.

    IF _STAGE = "BOOSTER" 
    {
        FOR RES IN _BOOSTER_TANK[0]:RESOURCES 
        {
            IF RES:NAME = "LiquidFuel"
            {
                SET _BOOSTER_CURRENT_LF TO RES:AMOUNT.
                SET _BOOSTER_CAPACITY_LF TO RES:CAPACITY.
                SET _BOOSTER_FUEL_PERCENTAGE TO ROUND(100 * _BOOSTER_CURRENT_LF / _BOOSTER_CAPACITY_LF, 2).
            }
            ELSE IF RES:NAME = "OXIDIZER"
            {
                SET _BOOSTER_CURRENT_OX TO RES:AMOUNT.
                SET _BOOSTER_CAPACITY_OX TO RES:CAPACITY.
                SET _BOOSTER_OXID_PERCENTAGE TO ROUND(100 * _BOOSTER_CURRENT_OX / _BOOSTER_CAPACITY_OX, 2).
            }
        }
    } 
    ELSE IF _STAGE = "UPPER STAGE"
    {
        FOR RES IN _UPPER_STAGE_TANK[0]:RESOURCES 
        {
            IF RES:NAME = "LiquidFuel"
            {
                SET _UPPER_STAGE_CURRENT_LF TO RES:AMOUNT.
                SET _UPPER_STAGE_CAPACITY_LF TO RES:CAPACITY.
                SET _UPPER_STAGE_FUEL_PERCENTAGE TO ROUND(100 * _UPPER_STAGE_CURRENT_LF / _UPPER_STAGE_CAPACITY_LF, 2).
            }
            ELSE IF RES:NAME = "OXIDIZER"
            {
                SET _UPPER_STAGE_CURRENT_OX TO RES:AMOUNT.
                SET _UPPER_STAGE_CAPACITY_OX TO RES:CAPACITY.
                SET _UPPER_STAGE_OXID_PERCENTAGE TO ROUND(100 * _UPPER_STAGE_CURRENT_OX / _UPPER_STAGE_CAPACITY_OX, 2).
            }
        }
    }
    ELSE IF _STAGE = "BOTH"
    {
        _GET_FALCON_PROPELLANT("BOOSTER").
        _GET_FALCON_PROPELLANT("UPPER STAGE").
    }
}
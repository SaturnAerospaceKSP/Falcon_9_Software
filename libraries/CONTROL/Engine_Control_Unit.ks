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
// SCRIPT: ENGINE_CONTROL_UNIT
//

GLOBAL FUNCTION _BOOSTER_ENGINE_CONTROL
{
    PARAMETER _ACTION.

    IF _ACTION = "STARTUP"
    {
        _BOOSTER_ENGINES[0]:GETMODULE("ModuleTundraEngineSwitch"):DOACTION("Activate Engine", true).
    }
    ELSE IF _ACTION = "SHUTDOWN"
    {
        _BOOSTER_ENGINES[0]:GETMODULE("ModuleTundraEngineSwitch"):DOACTION("Shutdown Engine", true).
    }
    ELSE IF _ACTION = "NINE ENGINES"
    {
        IF _BOOSTER_ENGINES[0]:GETMODULE("ModuleTundraEngineSwitch"):GETFIELD("Mode") = "Three Landing" 
        {
            _BOOSTER_ENGINES[0]:GETMODULE("ModuleTundraEngineSwitch"):DOACTION("Previous Engine Mode", true).
        }
        ELSE IF _BOOSTER_ENGINES[0]:GETMODULE("ModuleTundraEngineSwitch"):GETFIELD("Mode") = "Center Only" 
        {
            _BOOSTER_ENGINES[0]:GETMODULE("ModuleTundraEngineSwitch"):DOACTION("Next Engine Mode", true).
        }
    }
    ELSE IF _ACTION = "THREE ENGINES"
    {
        IF _BOOSTER_ENGINES[0]:GETMODULE("ModuleTundraEngineSwitch"):GETFIELD("Mode") = "All Engines" 
        {
            _BOOSTER_ENGINES[0]:GETMODULE("ModuleTundraEngineSwitch"):DOACTION("Next Engine Mode", true).
        }
        ELSE IF _BOOSTER_ENGINES[0]:GETMODULE("ModuleTundraEngineSwitch"):GETFIELD("Mode") = "Center Only" 
        {
            _BOOSTER_ENGINES[0]:GETMODULE("ModuleTundraEngineSwitch"):DOACTION("Previous Engine Mode", true).
        }
    }
    ELSE IF _ACTION = "ONE ENGINE"
    {
        IF _BOOSTER_ENGINES[0]:GETMODULE("ModuleTundraEngineSwitch"):GETFIELD("Mode") = "All Engines" 
        {
            _BOOSTER_ENGINES[0]:GETMODULE("ModuleTundraEngineSwitch"):DOACTION("Previous Engine Mode", true).
        }
        ELSE IF _BOOSTER_ENGINES[0]:GETMODULE("ModuleTundraEngineSwitch"):GETFIELD("Mode") = "Three Landing" 
        {
            _BOOSTER_ENGINES[0]:GETMODULE("ModuleTundraEngineSwitch"):DOACTION("Next Engine Mode", true).
        }
    }
}

GLOBAL FUNCTION _UPPER_VACCUM_ENGINE_CONTROL 
{
    PARAMETER _ACTION.

    IF _ACTION = "STARTUP"
    {
        _UPPER_STAGE_VACCUM_ENGINE[0]:getmodule("ModuleEnginesFX"):doaction("Activate Engine", true).
    }
    ELSE IF _ACTION = "SHUTDOWN"
    {
        _UPPER_STAGE_VACCUM_ENGINE[0]:getmodule("ModuleEnginesFX"):doaction("Shutdown Engine", true).
    }
}
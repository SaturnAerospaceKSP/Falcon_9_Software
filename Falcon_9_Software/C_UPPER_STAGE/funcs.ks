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
// SCRIPT: (STAGE 2) FUNCS
//

GLOBAL FUNCTION _FAIRING_ACTIONS
{
    PARAMETER _ACTION.

    IF _ACTION = "DEPLOY"
    {
        FOR P IN _UPPER_FAIRING_HALVES
        {
            IF _UPPER_FAIRING_HALVES[0]:GETMODULE("ModuleDecouple"):HASEVENT("Decouple")
            {
                _UPPER_FAIRING_HALVES[0]:GETMODULE("ModuleDecouple"):DOEVENT("Decouple").
                _UPPER_FAIRING_HALVES[1]:GETMODULE("ModuleDecouple"):DOEVENT("Decouple").
            }

            // IF P:MODULES:CONTAINS("ModuleDecouple") 
            // {
            //     LOCAL M IS P:GETMODULE("ModuleDecouple").
            //     FOR A in M:ALLACTIONNAMES()
            //     {
            //         IF A:CONTAINS("Decouple") {M:DOACTION(A, true).}
            //     }
            // }
        }
    }
}
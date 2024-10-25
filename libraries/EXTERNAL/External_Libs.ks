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
// SCRIPT: EXTERNAL_LIBS
//
// LINKS TO THE LIBRARIES: 
// - https://github.com/iezekiel/RP-0/blob/master/Scripts/lib/libLaunchWindow.ks
// - https://github.com/iezekiel/RP-0/blob/master/Scripts/lib/libWaitForLAN.ks
// - https://github.com/KSP-KOS/KSLib/blob/master/library/lib_lazcalc.ks
// - Made By Quasy (TIME FUNCTIONS)




// =================================AZIMUTH =============================
GLOBAL FUNCTION _LAUNCH_AZIMUTH 
{
    PARAMETER _TARGET_INCLINE, _ORBIT_ALT, _RAW is false, _AUTOSWITCH is false.

    LOCAL _SHIP_LAT is ship:latitude.
    LOCAL _RAW_HEAD IS 0. // Azimuth without auto switch

    IF ABS(_TARGET_INCLINE) < abs(_SHIP_LAT) {set _TARGET_INCLINE TO _SHIP_LAT.}
    IF (_TARGET_INCLINE > 180) {set _TARGET_INCLINE to -360 + _TARGET_INCLINE.}
    IF (_TARGET_INCLINE < -180) {set _TARGET_INCLINE to 360 + _TARGET_INCLINE.}
    IF hasTarget {SET _AUTOSWITCH to true.}

    LOCAL _HEAD IS arcSin(max(min(cos(_TARGET_INCLINE) / cos(_SHIP_LAT), 1), -1)).
    set _RAW_HEAD to _HEAD.

    IF _AUTOSWITCH {
        IF _NODE_SIGN_TARGET() > 0 {set _HEAD to 180 - _HEAD.}
    } ELSE IF (_TARGET_INCLINE < 0) {set _HEAD to 180 - _HEAD.}

    LOCAL _EQ_VEL is (2 * constant:pi * body:radius) / body:rotationperiod.
    local _V_ORBIT is sqrt(body:mu / (_ORBIT_ALT + body:radius)).
    LOCAL _V_ROT_X is _V_ORBIT * sin(_HEAD) - (_EQ_VEL * cos(_SHIP_LAT)).
    LOCAL _V_ROT_Y is _V_ORBIT * cos(_HEAD).
    
    SET _HEAD TO 90 - arcTan2(_V_ROT_Y, _V_ROT_X).

    IF _RAW {return mod(_RAW_HEAD + 360, 360).}
    ELSE {return mod(_HEAD + 360, 360).}
}

GLOBAL FUNCTION _NODE_SIGN_TARGET { // approaching AN or DN
	if (hasTarget) {
		local joinVec is vcrs(_ORBIT_BINORMAL(), _TARGET_BINORMAL()):normalized.
		local signVec is vcrs(-body:position:normalized, joinVec):normalized.
		local sign is vdot(_ORBIT_BINORMAL(), signVec).

		if (sign > 0) { return 1. }
		else { return -1. }
	} 
	else { return 1. }
}

GLOBAL FUNCTION _ORBIT_TANGENT { // ship velocity
    parameter ves is ship.

    return ves:velocity:orbit:normalized.
}

GLOBAL FUNCTION _ORBIT_BINORMAL { // ship binormal
    parameter ves is ship.

    return vcrs((ves:position - ves:body:position):normalized, _ORBIT_TANGENT(ves)):normalized.
}

GLOBAL FUNCTION _TARGET_BINORMAL { // target binormal
    parameter ves is target.

    return vcrs((ves:position - ves:body:position):normalized, _ORBIT_TANGENT(ves)):normalized.
}
// ======================================================================


// ================================ LAZCALC =============================
GLOBAL FUNCTION LAZcalc_init {
    PARAMETER
        desiredAlt, //Altitude of desired target orbit (in *meters*)
        desiredInc. //Inclination of desired target orbit

    PARAMETER autoNodeEpsilon IS 10. // How many m/s north or south
        // will be needed to cause a north/south switch. Pass zero to disable
        // the feature.
    SET autoNodeEpsilon to ABS(autoNodeEpsilon).
    
    //We'll pull the latitude now so we aren't sampling it multiple times
    LOCAL launchLatitude IS SHIP:LATITUDE.
    
    LOCAL data IS LIST().   // A list is used to store information used by LAZcalc
    
    //Orbital altitude can't be less than sea level
    IF desiredAlt <= 0 {
        PRINT "Target altitude cannot be below sea level".
        SET launchAzimuth TO 1/0.		//Throws error
    }.
    
    //Determines whether we're trying to launch from the ascending or descending node
    LOCAL launchNode TO "Ascending".
    IF desiredInc < 0 {
        SET launchNode TO "Descending".
        
        //We'll make it positive for now and convert to southerly heading later
        SET desiredInc TO ABS(desiredInc).
    }.
    
    //Orbital inclination can't be less than launch latitude or greater than 180 - launch latitude
    IF ABS(launchLatitude) > desiredInc {
        SET desiredInc TO ABS(launchLatitude).
        HUDTEXT("Inclination impossible from current latitude, setting for lowest possible inclination.", 10, 2, 30, RED, FALSE).
    }.
    
    IF 180 - ABS(launchLatitude) < desiredInc {
        SET desiredInc TO 180 - ABS(launchLatitude).
        HUDTEXT("Inclination impossible from current latitude, setting for highest possible inclination.", 10, 2, 30, RED, FALSE).
    }.
    
    //Does all the one time calculations and stores them in a list to help reduce the overhead or continuously updating
    LOCAL equatorialVel IS (2 * CONSTANT():Pi * BODY:RADIUS) / BODY:ROTATIONPERIOD.
    LOCAL targetOrbVel IS SQRT(BODY:MU/ (BODY:RADIUS + desiredAlt)).
    data:ADD(desiredInc).       //[0]
    data:ADD(launchLatitude).   //[1]
    data:ADD(equatorialVel).    //[2]
    data:ADD(targetOrbVel).     //[3]
    data:ADD(launchNode).       //[4]
    data:ADD(autoNodeEpsilon).  //[5]
    RETURN data.
}.

FUNCTION LAZcalc {
    PARAMETER
        data. //pointer to the list created by LAZcalc_init
    LOCAL inertialAzimuth IS ARCSIN(MAX(MIN(COS(data[0]) / COS(SHIP:LATITUDE), 1), -1)).
    LOCAL VXRot IS data[3] * SIN(inertialAzimuth) - data[2] * COS(data[1]).
    LOCAL VYRot IS data[3] * COS(inertialAzimuth).
    
    // This clamps the result to values between 0 and 360.
    LOCAL Azimuth IS MOD(ARCTAN2(VXRot, VYRot) + 360, 360).

    IF data[5] {
        LOCAL NorthComponent IS VDOT(SHIP:VELOCITY:ORBIT, SHIP:NORTH:VECTOR).
        IF NorthComponent > data[5] {
            SET data[4] TO "Ascending".
        } ELSE IF NorthComponent < -data[5] {
            SET data[4] to "Descending".
        }.
    }.
    
    //Returns northerly azimuth if launching from the ascending node
    IF data[4] = "Ascending" {
        RETURN Azimuth.
        
    //Returns southerly azimuth if launching from the descending node
    } ELSE IF data[4] = "Descending" {
        IF Azimuth <= 90 {
            RETURN 180 - Azimuth.
            
        } ELSE IF Azimuth >= 270 {
            RETURN 540 - Azimuth.
            
        }.
    }.
}.
// ======================================================================


// ================================= QUASY ==============================

GLOBAL FUNCTION _FORMAT_LEXICON_TIME 
{ // Converts Hours, Mins & Secs into a usable time format
    PARAMETER _TIME_UNIT.

    SET _HOUR_VAR TO _TIME_UNIT:HOURS * 3600. // Seconds in an hour
    SET _MINS_VAR TO _TIME_UNIT:MINS * 60. // Seconds in a minute
    SET _SECS_VAR TO _TIME_UNIT:SECONDS * 1. // Seconds in a second

    RETURN _HOUR_VAR + _MINS_VAR + _SECS_VAR. // Add them up to get time
}
//
//
GLOBAL FUNCTION _FORMAT_SECONDS 
{ // Formats seconds into H, M, S
    parameter time_Unit.

    local hour_Zero is "".
    local minute_Zero is "".
    local second_Zero is "".

    local hour_Floor is floor(time_Unit / 3600).
    local minute_Floor is floor((time_Unit - (hour_Floor * 3600)) / 60).
    local second_Floor is floor(time_Unit - (hour_Floor * 3600) - (minute_Floor * 60)).

    if hour_Floor < 10 {set hour_Zero to "0".} else {set hour_Zero to "".}
    if minute_Floor < 10 {set minute_Zero to "0".} else {set minute_Zero to "".}
    if second_Floor < 10 {set second_Zero to "0".} else {set second_Zero to "".}
    
    local time_Unit_Formatted is hour_Zero + hour_Floor + ":" + minute_Zero + minute_Floor + ":" + second_Zero + second_Floor.
    return time_Unit_Formatted.
}

// ======================================================================
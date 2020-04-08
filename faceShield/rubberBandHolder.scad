/**
 * Rubber Band Holder
 * 
 * A face shield component that clips into a basic hairband and holds a 
 * rubberband in place.
 *
 * Meant to be clipped onto the back of a hairband with rubberbands to tighten
 * a face shield. This clip assumes there is a slight bend on both ends of
 * the hairband preventing the clip from slipping off.
 */

use <clipComponent.scad>;

module halfDoubleNotch(doubleNotchParmList) {
    doubleNotchWidth = doubleNotchParmList[0];
    doubleNotchThickness = doubleNotchParmList[1];
    doubleNotchMidWidth = doubleNotchParmList[2];
    doubleNotchBorderHeight = doubleNotchParmList[3];
    doubleNotchMiddleHeight = doubleNotchParmList[4];
    
    notchAngle = atan((doubleNotchWidth - doubleNotchMidWidth) / doubleNotchMidWidth);
    assert(notchAngle <= 45, "Notch middle too small - notch angle must be less than 45 degrees");
    assert(doubleNotchMidWidth <= doubleNotchWidth, "Notch middle must be smaller than ends");
    
    hull() {
        cube([doubleNotchWidth, doubleNotchThickness, doubleNotchBorderHeight]);
        translate([doubleNotchWidth/2 - doubleNotchMidWidth/2, 0, doubleNotchBorderHeight])
            cube([doubleNotchMidWidth, doubleNotchThickness, doubleNotchMiddleHeight/2]);
    }
}

module doubleNotch(doubleNotchParmList) {
    doubleNotchBorderHeight = doubleNotchParmList[3];
    doubleNotchMiddleHeight = doubleNotchParmList[4];
    
    halfDoubleNotch(doubleNotchParmList);
    translate([0,0, 2 * doubleNotchBorderHeight + doubleNotchMiddleHeight])
        mirror([0,0,1])
        halfDoubleNotch(doubleNotchParmList);
}

module rubberBandHolderClip(doubleNotchParmList, clipParmList) {
    frontWallHeight = clipParmList[1];
    bottomThickness = clipParmList[4];
    
    totalFrontWallHeight = frontWallHeight + bottomThickness;
    clipComponent(clipParmList);
    translate([0, 0, totalFrontWallHeight])
        doubleNotch(doubleNotchParmList);
}

// --- Parameters ---

// Clip Component Parameters
clipWidth = 5;

frontWallHeight = 5;
frontWallThickness = 1.5;

spaceBetweenWalls = 2;
bottomThickness = 1.5;

backWallHeight = 7;
backWallThickness = 1.5;

hookHeight = 3; // how much wall space the hook head occupies
hookProtrusion = 1; // how far out the hook head extends
hookBottomAngle = 45; // bottom angle of the hook off the wall (angle > 45 degrees may need supports)

clipParmList = [
    clipWidth, frontWallHeight, frontWallThickness, spaceBetweenWalls, bottomThickness,
    backWallHeight, backWallThickness, hookHeight, hookProtrusion, hookBottomAngle
];

// Double Notch Parameters
doubleNotchWidth = clipWidth;
doubleNotchThickness = frontWallThickness;
doubleNotchMidWidth = 3; // inner width of notch

doubleNotchBorderHeight = 0.5; // height of top and bottom borders
doubleNotchMiddleHeight = 4; // height between borders

doubleNotchParmList = [
    doubleNotchWidth, doubleNotchThickness, doubleNotchMidWidth, 
    doubleNotchBorderHeight, doubleNotchMiddleHeight
];

rubberBandHolderClip(doubleNotchParmList, clipParmList);
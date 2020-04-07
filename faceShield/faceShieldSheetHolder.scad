// Face Shield Sheet Holder
PADDING = 0.01; // padding value to extend negative volumes to fix z-fighting

use <clipComponent.scad>;

module frontBarTriangle(extrusionHeight, frontBarWidth, triangleLength) {
    linear_extrude(height=extrusionHeight)
        polygon(points=[[0, 0], [frontBarWidth, 0],[0, triangleLength]]);
}

module frontBar(extrusionHeight, frontBarParmList) {
    frontBarLength = frontBarParmList[0];
    frontBarWidth = frontBarParmList[1];
    frontBarSideAngle = frontBarParmList[2];
    
    triangleLength = frontBarWidth / tan(frontBarSideAngle);
    translate([triangleLength, 0, 0])
        cube([frontBarLength - (2 * triangleLength), frontBarWidth, extrusionHeight]);
    translate([frontBarLength - triangleLength, frontBarWidth, 0])
        rotate([0, 0, -90])
        frontBarTriangle(extrusionHeight, frontBarWidth, triangleLength);
    translate([triangleLength, frontBarWidth, extrusionHeight])
        rotate([0, 180, 90])
    frontBarTriangle(extrusionHeight, frontBarWidth, triangleLength);
}

function arcRadius(height, width) = (height / 2) + (pow(width, 2) / (8 * height));

module backBar(extrusionHeight, backBarParmList) {
    backBarLength = backBarParmList[0];
    backBarWidth = backBarParmList[1];
    backBarDeflection = backBarParmList[2];
    
    radius = arcRadius(backBarDeflection, backBarLength);
    intersection() {
        translate([0, radius + backBarWidth, 0])
            rotate_extrude(angle=-180, convexity=10)
                translate([radius, 0, 0])
                square([backBarWidth, extrusionHeight]);
        translate([-backBarLength/2, 0, 0])
            cube([backBarLength, backBarWidth + backBarDeflection, extrusionHeight]);
    }
}

module cornerSupport(radius, thickness) {
    difference() {
        cube([thickness, radius, radius]);
        translate([-PADDING, 0, radius])
            rotate([0, 90, 0])
            cylinder(r=radius, h=thickness + (2 * PADDING));
    }
}

function hypotenuseLength(x, y) = sqrt(pow(x, 2) + pow(y, 2));

module arm(extrusionHeight, armParmList, clipParmList, clipRotationAngle) {
    armsHorizontalDistance = armParmList[0];
    armsWidth = armParmList[1];
    armsBackBarGap = armParmList[2];
    armsClipGap = armParmList[3];
    
    clipWidth = clipParmList[0];
    clipFrontWallHeight = clipParmList[1];
    clipBottomThickness = clipParmList[4];
    clipFrontWallTotalHeight = clipFrontWallHeight + clipBottomThickness;
    
    hypotenuse = hypotenuseLength(armsClipGap - armsBackBarGap, armsHorizontalDistance);
    armAngle = atan((armsClipGap - armsBackBarGap) / armsHorizontalDistance);
    rotationGapCover = tan(armAngle) * armsWidth;
    
    totalClipRotation = clipRotationAngle + armAngle; // add armAngle to reset clip angle
    clipRotationGapCover = tan(totalClipRotation) * armsWidth;
    
    rotate([0, 0, -armAngle])
        translate([0, -rotationGapCover, 0])
        union() {
            cube([armsWidth, hypotenuse + rotationGapCover, extrusionHeight]);
            translate([0, (hypotenuse + rotationGapCover) - (clipFrontWallTotalHeight - extrusionHeight), extrusionHeight])
                cornerSupport(clipFrontWallTotalHeight - extrusionHeight, armsWidth);
            translate([0, hypotenuse + rotationGapCover, 0])
                cube([armsWidth, clipRotationGapCover, clipFrontWallTotalHeight]);
            translate([0, hypotenuse + rotationGapCover, 0])
                rotate([0, 0, totalClipRotation] )
                translate([-clipWidth/2 + armsWidth/2, 0, 0])
                    clipComponent(clipParmList);
        }
}

module sheetHolder(extrusionHeight, frontBarParmList, spaceParmList, backBarParmList, armParmList, clipParmList, clipRotationAngle) {
    frontBarLength = frontBarParmList[0];
    frontBarWidth = frontBarParmList[1];
    
    spacerLength = spaceParmList[0];
    spacerWidth = spaceParmList[1];
    
    backBarWidth = backBarParmList[1];
    
    armsWidth = armParmList[1];
    armsBackBarGap = armParmList[2]; 
    
    // Front Bar
    translate([-frontBarLength/2, 0, 0])
        frontBar(extrusionHeight, frontBarParmList);
    // Spacer
    translate([-spacerLength/2, frontBarWidth, 0])
        cube([spacerLength, spacerWidth + backBarWidth / 2, extrusionHeight]);
    // Back Bar
    translate([0, frontBarWidth + spacerWidth, 0])
        backBar(extrusionHeight, backBarParmList);
    // Arms
    sumBarWidth = frontBarWidth + spacerWidth + backBarWidth;
    translate([armsBackBarGap/2, sumBarWidth, 0])
        arm(extrusionHeight, armParmList, clipParmList, clipRotationAngle);
    translate([-armsBackBarGap/2, sumBarWidth, 0])
        mirror([1, 0, 0])
        arm(extrusionHeight, armParmList, clipParmList, clipRotationAngle);
}
// Parameters
$fn = 64; // global var controlling number of vertices in a cylinder

// Sheet holder parameters
sheetHolderHeight = 3;

frontBarLength = 14;
frontBarWidth = 1.5;
frontBarSideAngle = 40;

spacerLength = 4.5;
spacerWidth = 1.5;

backBarLength = 25;
backBarWidth = 1.5;
backBarDeflection = 1;

armsHorizontalDistance = 20;
armsWidth = 2;
armsBackBarGap = 3;
armsClipGap = 10;

frontBarParmList = [frontBarLength, frontBarWidth, frontBarSideAngle];
spaceParmList = [spacerLength, spacerWidth];
backBarParmList = [backBarLength, backBarWidth, backBarDeflection];
armParmList = [armsHorizontalDistance, armsWidth, armsBackBarGap, armsClipGap];

// Clip Component parameters
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

// Integration Parameters
clipRotationAngle = 0;

sheetHolder(sheetHolderHeight, frontBarParmList, spaceParmList, backBarParmList, armParmList, clipParmList, clipRotationAngle);

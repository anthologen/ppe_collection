// Face Shield Sheet Holder
EPSILON = 0.01; // padding value to extend negative volumes to fix z-fighting

module frontBarTriangle(sheetHolderHeight, frontBarWidth, triangleLength) {
    linear_extrude(height=sheetHolderHeight)
        polygon(points=[[0, 0], [frontBarWidth, 0],[0, triangleLength]]);
}

module frontBar(sheetHolderHeight, frontBarLength, frontBarWidth, frontBarSideAngle, sheetHolderHeight) {
    triangleLength = frontBarWidth / tan(frontBarSideAngle);
    translate([triangleLength, 0, 0])
        cube([frontBarLength - (2 * triangleLength), frontBarWidth, sheetHolderHeight]);
    translate([frontBarLength - triangleLength, frontBarWidth, 0])
        rotate([0, 0, -90])
        frontBarTriangle(sheetHolderHeight, frontBarWidth, triangleLength);
    translate([triangleLength, frontBarWidth, sheetHolderHeight])
        rotate([0, 180, 90])
    frontBarTriangle(sheetHolderHeight, frontBarWidth, triangleLength);
}

function arcRadius(height, width) = (height / 2) + (pow(width, 2) / (8 * height));

module backBar(sheetHolderHeight, backBarLength, backBarWidth, backBarDeflection) {
    radius = arcRadius(backBarDeflection, backBarLength);
    intersection() {
        translate([0, radius + backBarWidth, 0])
            rotate_extrude(angle=-180, convexity=10)
                translate([radius, 0, 0])
                square([backBarWidth, sheetHolderHeight]);
        translate([-backBarLength/2, 0, 0])
            cube([backBarLength, backBarWidth + backBarDeflection, sheetHolderHeight]);
    }
}

module cornerSupport(radius, thickness) {
    difference() {
        cube([thickness, radius, radius]);
        translate([-EPSILON, 0, radius])
            rotate([0, 90, 0])
            cylinder(r=radius, h=thickness + (2 * EPSILON));
    }
}

function hypotenuseLength(x, y) = sqrt(pow(x, 2) + pow(y, 2));

module arm(sheetHolderHeight, armsHorizontalDistance, armsWidth, armsBackBarGap, armsClipGap, clipFrontWallHeight, sheetHolderHeight) {
    hypotenuse = hypotenuseLength(armsClipGap - armsBackBarGap, armsHorizontalDistance);
    armAngle = atan((armsClipGap - armsBackBarGap) / armsHorizontalDistance);
    rotationGapCover = tan(armAngle) * armsWidth;
    rotate([0, 0, armAngle])
        translate([0, -rotationGapCover, 0])
        union() {
            cube([armsWidth, hypotenuse + rotationGapCover, sheetHolderHeight]);
            translate([0, (hypotenuse + rotationGapCover) - sheetHolderHeight, sheetHolderHeight])
                cornerSupport(clipFrontWallHeight - sheetHolderHeight, armsWidth);
        }
}

module sheetHolder(sheetHolderHeight, frontBarLength, frontBarWidth, frontBarSideAngle, spacerLength, spacerWidth, backBarLength, backBarWidth, backBarDeflection, armsHorizontalDistance, armsWidth, armsBackBarGap, armsClipGap, clipFrontWallHeight) {
    translate([-frontBarLength/2, 0, 0])
        frontBar(sheetHolderHeight, frontBarLength, frontBarWidth, frontBarSideAngle);
    translate([-spacerLength/2, frontBarWidth, 0])
        cube([spacerLength, spacerWidth + backBarWidth / 2, sheetHolderHeight]);
    translate([0, frontBarWidth + spacerWidth, 0])
        backBar(sheetHolderHeight, backBarLength, backBarWidth, backBarDeflection);
    sumBarWidth = frontBarWidth + spacerWidth + backBarWidth;
    translate([-armsWidth -(armsBackBarGap/2), sumBarWidth, 0])
        arm(sheetHolderHeight, armsHorizontalDistance, armsWidth, armsBackBarGap, armsClipGap, clipFrontWallHeight);
    translate([armsWidth + (armsBackBarGap/2), sumBarWidth, 0])
        mirror([1, 0, 0])
        arm(sheetHolderHeight, armsHorizontalDistance, armsWidth, armsBackBarGap, armsClipGap, clipFrontWallHeight);
}
// Parameters
$fn = 64; // global var controlling number of vertices in a cylinder

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

clipFrontWallHeight = 6;

sheetHolder(sheetHolderHeight, frontBarLength, frontBarWidth, frontBarSideAngle, spacerLength, spacerWidth, backBarLength, backBarWidth, backBarDeflection, armsHorizontalDistance, armsWidth, armsBackBarGap, armsClipGap, clipFrontWallHeight);

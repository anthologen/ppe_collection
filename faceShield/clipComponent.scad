/** 
 * Single Hook Upright Clip Component 
 * 
 * A generic clip with a hook on one side.
 * 
 * This component is the interface between the hairband and the rest
 * of the models. Intended to be printed in the upright position 
 * so keep anisotropy in mind.
 */

PADDING = 0.01; // Constant padding value extending negative volumes to fix z-fighting

module hookHead(hookHeight, hookProtrusion, hookBottomAngle, thickness) {
    linear_extrude(height=clipWidth)
        polygon(points=[[0,0], [0,hookHeight],
            [hookProtrusion, hookProtrusion / tan(hookBottomAngle)]]
        );
}

module cornerReinforcement(spaceBetweenWalls, clipWidth) {
    difference() {
        cube([clipWidth, spaceBetweenWalls, spaceBetweenWalls/2]);
        translate([-PADDING, spaceBetweenWalls/2, spaceBetweenWalls/2])
            rotate([0, 90, 0])
            scale([1, 1, 1 + (2 * PADDING)])
            cylinder(h=clipWidth, r=spaceBetweenWalls/2);
    }
}

module clipComponent(clipParmList) {
    clipWidth = clipParmList[0];
    frontWallHeight = clipParmList[1];
    frontWallThickness = clipParmList[2];
    spaceBetweenWalls = clipParmList[3];
    bottomThickness = clipParmList[4];
    backWallHeight = clipParmList[5];
    backWallThickness = clipParmList[6];
    hookHeight = clipParmList[7];
    hookProtusion = clipParmList[8];
    hookBottomAngle = clipParmList[9];
    
    if (hookBottomAngle > 45) echo("WARNING: The hook may require supports");
    
    // Front wall
    cube([clipWidth, frontWallThickness + spaceBetweenWalls + backWallThickness, bottomThickness]);
    // Bottom
    translate([0, 0, bottomThickness])
        cube([clipWidth, frontWallThickness, frontWallHeight]);
    // Back wall
    translate([0, frontWallThickness + spaceBetweenWalls, bottomThickness])
        cube([clipWidth, backWallThickness, backWallHeight]);
    // Add rounded corner reinforcement for wall bending during insertion into clip
    translate([0, frontWallThickness, bottomThickness])
        cornerReinforcement(spaceBetweenWalls, clipWidth);
    // Hook head
    translate([clipWidth, frontWallThickness + spaceBetweenWalls, backWallHeight + bottomThickness - hookHeight])
        rotate([90, 0, -90])
        hookHead(hookHeight, hookProtrusion, hookBottomAngle, clipWidth);
}

// --- Parameters ---
$fn = 16; // global variable controlling number of vertices in a cylinder

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


clipComponent(clipParmList);

// Single Hook Upright Clip Component 

module hookHead(hookHeight, hookProtusion, hookBottomAngle, thickness) {
    linear_extrude(height=clipWidth)
        polygon(points=[[0,0], [0,hookHeight],
            [hookProtusion, hookProtusion / tan(hookBottomAngle)]]
        );
}

module visorClip(frontWallHeight, frontWallThickness, spaceBetweenWalls, bottomThickness, backWallHeight, backWallThickness, clipWidth, hookHeight, hookProtusion, hookBottomAngle) {
    // Front wall
    cube([clipWidth, frontWallThickness + spaceBetweenWalls + backWallThickness, bottomThickness]);
    // Bottom
    translate([0, 0, bottomThickness])
        cube([clipWidth, frontWallThickness, frontWallHeight]);
    // Back wall
    translate([0, frontWallThickness + spaceBetweenWalls, bottomThickness])
        cube([clipWidth, backWallThickness, backWallHeight]);
    // Add rounded corner reinforcement for wall bending during clip insertion
    translate([0, frontWallThickness, bottomThickness])
        difference() {
            cube([clipWidth, spaceBetweenWalls, spaceBetweenWalls/2]);
            translate([0, spaceBetweenWalls/2, spaceBetweenWalls/2])
                rotate([0, 90, 0])
                cylinder(h=clipWidth, r=spaceBetweenWalls/2);
    }   
    // Hook head
    translate([clipWidth, frontWallThickness + spaceBetweenWalls, backWallHeight + bottomThickness - hookHeight])
        rotate([90, 0, -90])
        hookHead(hookHeight, hookProtusion, hookBottomAngle, clipWidth);
}

// Parameters
$fn = 16; // global var controlling number of vertices in a cylinder

frontWallHeight = 5;
frontWallThickness = 1.5;
spaceBetweenWalls = 2;
bottomThickness = 1.5;
backWallHeight = 7;
backWallThickness = 1.5;
clipWidth = 5;
hookHeight = 3; // how much wall space the hook head occupies
hookProtusion = 1; // how far out the hook head extends
hookBottomAngle = 45; // bottom angle of the hook off the wall (angle > 45 degrees may need supports)


visorClip(frontWallHeight, frontWallThickness, spaceBetweenWalls, bottomThickness, backWallHeight, backWallThickness, clipWidth, hookHeight, hookProtusion, hookBottomAngle);

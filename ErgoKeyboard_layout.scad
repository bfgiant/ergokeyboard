key1 = 19.05; // 1x1 keycap spacing (mm)
mode = 1; // changes what geometry is drawn (see cutout module for details)

//cutout([10,-75,0],-30); // Example of cutout usage
//translate([0,15.5,-2.5]) color([1,1,1]) cube([285,105,5],true); // bounding box
half(); mirror([1,0,0]) color("grey") half();

module half () {
    rotate(8.5) translate([1.75,0,0]*key1) {
        color("yellow") mainBlock();
        color("red") bottomRow();
        color("blue") inside();
        color("green") outside();
    }
}

module mainBlock () {
    block([3,5],[0,0.125,0.25,0.125,-0.125]);
}

module bottomRow () {
    translate([0,-1,0]*key1) {
        translate([1,0,0]*key1) block([1,5],[.125,.25,.125,-.125,-.125]); // 5 in line
        movx = -0.05;
        movy = movx - 0.01;
        rot = 7.5;
        translate([movx,movy,0]*key1) rotate(rot) {
            block([1,1]); // 1st thumb key
            translate([movx-1.01,movy,0]*key1) rotate(rot) {
                block([1,1]); // 2nd thumb key
            }
        }
    }
}

module inside () {
    translate([-1,0,0]*key1) block([2,1]);
}

module outside () {
    translate([5,-0.125,0]*key1) block([3,1]);
}


////////////////////////////
// The "function" modules //
////////////////////////////

module block (size,shift) {
    // size: [rows, columns]
    // shift: the absolute vertical shift, per column. 1 = 100% = 1 row up
    rows = size[0];
    columns = size[1];
    for(row = [1:rows]) {
        for(column = [1:columns]) {
            if (len(shift) == undef) { // if shift is not defined
                scaled = [column-1,row-1,0]*key1;
                cutout(scaled,0);
            } else {
                scaled = [column-1,row-1+shift[column-1],0]*key1;
                cutout(scaled,0);
            }
        }
    }
}

module cutout (position,rotation,keysize) {
    // position: the coordinate of the center of the cutout
    // rotation: the CCW rotation, in degrees, of the cutout
    // keysize: key size, in units (default: 1x1)
    translate(position) rotate(rotation) union() {
        if (mode == 1) { // keycap silhouette
            square(18.5,true);
        } else if (mode == 2) { // clearance silhouette
            square(key1,true);
        } else { // cutout in proper location
            square(14,true);
            translate([0,14/2-1-3.1/2]) square([14+2*.8,3.1],true);
            translate([0,-(14/2-1-3.1/2)]) square([14+2*.8,3.1],true);
        }
    }
}
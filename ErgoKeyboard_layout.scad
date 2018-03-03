spacing = 19.05; // mm

//cutout([10,-75,0],-30);
//translate([0,28,-2.5]) color([1,1,1]) cube([280,125,5],true);
half(); mirror([1,0,0]) half();

module half () {
    rotate(8.5) translate([1.75,0,0]*spacing) {
//        translate([-1,0.5,0]*spacing) block([1,1]);
        thumbcluster();
        block([4,5],[0,2.5,5,2.5,0]/10); // main block
        translate([5,0,0]*spacing) block([3,1]); // pinky
    }
}

module thumbcluster () {
    translate([-0.85,-1.25,0]*spacing) rotate(15) {
        block([2,1]);
        translate([1.1,-0.1,0]*spacing) rotate(-7.5) {
            block([1,1]);
            translate([1.1,0.1,0]*spacing) rotate(-7.5) block([1,2]);
        }
    }
}

module block (size,shift) {
    // size: [rows, columns]
    // shift: the absolute vertical shift, per column. 1 = 100% = 1 row up
    rows = size[0];
    columns = size[1];
    for(row = [1:rows]) {
        for(column = [1:columns]) {
            if (len(shift) == undef) {
                scaled = [column-1,row-1,0]*spacing;
                cutout(scaled,0);
            } else {
                scaled = [column-1,row-1+shift[column-1],0]*spacing;
                cutout(scaled,0);
            }
//            scaled = [column-1,row-1+shift[column-1],0]*spacing;
//            cutout(scaled,0);
        }
    }
}

module cutout (position,rotation,outline,keysize) {
    // position: the coordinate of the center of the cutout
    // rotation: the CCW rotation, in degrees, of the cutout
    // outline: draw a square the size of the key spacing
    // keysize: key size, in units (default: 1x1)
    translate(position) rotate(rotation) union() {
//        square(spacing,true); // Clearance squares
        square(18.5,true);
//        square(14,true);
//        translate([0,14/2-1-3.1/2]) square([14+2*.8,3.1],true);
//        translate([0,-(14/2-1-3.1/2)]) square([14+2*.8,3.1],true);
    }
}

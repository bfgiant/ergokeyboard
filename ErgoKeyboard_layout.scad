mode = 1; // changes what geometry is drawn (see cutout module for details)

/////////////////////////
// Required Dimensions //
//       (in mm)       //
/////////////////////////

spacing = 1.05;
s1 = 18; // 1u
s1_25 = s1*1.25; // 1.25u
key1 = s1 + spacing; // center-center distance between 1u keys
key1_25 = s1_25 + spacing;


/////////////////////////////
// "Building" the Keyboard //
/////////////////////////////

//cutout(pos = [10,-75,0],rot = -10,size = s1_25); // Example of cutout usage
translate([0,15.5,-2.5]) color([1,1,1]) cube([285,105,5],true); // bounding box
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
           cutout(); // 1st thumb key
            translate([movx-1.01,movy,0]*key1) rotate(rot) {
                cutout(pos = [0,0.125,0]*key1,rot = 90,size = s1_25); // 2nd thumb key
            }
        }
    }
}

module inside () {
    translate([-1,0.1,0]*key1) block([2,1]);
}

module outside () {
    translate([5,-0.125,0]*key1) block([3,1]);
}


////////////////////////////
//   "Function" Modules   //
////////////////////////////

module block (size,shift) {
    // size: [rows, columns]
    // shift: the absolute vertical shift, per column. 1 = 100% = 1 row up
    rows = size[0];
    columns = size[1];
    for(row = [1:rows]) {
        for(column = [1:columns]) {
            if (len(shift) == undef) { // if shift is not defined
                scaledpos = [column-1,row-1,0]*key1;
                cutout(scaledpos,0);
            } else { // shift is defined
                scaledpos = [column-1,row-1+shift[column-1],0]*key1;
                cutout(scaledpos,0);
            }
        }
    }
}

module cutout (pos=[0,0,0],rot=0,size=s1) {
    // pos: the coordinate of the center of the cutout
    // rot: the CCW rotation, in degrees, of the cutout
    // size: key size, in units
    translate(pos) rotate(rot) union() {
        if (mode == 1) { // keycap silhouette
            square([size,s1],true);
        } else if (mode == 2) { // clearance silhouette
            square([size+spacing,key1],true);
        } else { // cutout in proper location
            translate([(size-s1)/2,0,0]) {
                square(14,true);
                translate([0,14/2-1-3.1/2]) square([14+2*.8,3.1],true);
                translate([0,-(14/2-1-3.1/2)]) square([14+2*.8,3.1],true);
            }
        }
    }
}
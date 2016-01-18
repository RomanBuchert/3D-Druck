
SCALE=5.0;
GAP=0.5;

BIT = 1.0 * SCALE;
HEIGHT = 2 * BIT;
LENGTH = 5 * HEIGHT;
GAP_2=GAP / 2;
//BIT_GAP = BIT + GAP;

BLOCK=[HEIGHT, LENGTH, HEIGHT];


function bit_gap(bits) = (bits*BIT + GAP);

function bit_pos(bits) = (bits*BIT - GAP_2);

module part_one(){
    difference(){
        cube(BLOCK);
        translate([bit_pos(0), bit_pos(3), bit_pos(1)])
        cube([bit_gap(2), bit_gap(4), bit_gap(1)]);
        translate([bit_pos(1), bit_pos(4), bit_pos(0)])
        cube([bit_gap(1), bit_gap(1), bit_gap(1)]);
    };
};

module part_two(){
    difference(){
        cube(BLOCK);
        translate([bit_pos(0), bit_pos(3), bit_pos(1)])
        cube([bit_gap(1), bit_gap(4), bit_gap(1)]);
        translate([bit_pos(1), bit_pos(4), bit_pos(1)])
        cube([bit_gap(1), bit_gap(2), bit_gap(1)]);
    };
};


module part_three(){
    difference(){
        cube(BLOCK);
        translate([bit_pos(0), bit_pos(3), bit_pos(1)])
        cube([bit_gap(2), bit_gap(2), bit_gap(1)]);
        translate([bit_pos(0), bit_pos(6), bit_pos(1)])
        cube([bit_gap(2), bit_gap(1), bit_gap(1)]);
    };
};

module part_four(){
    difference(){
        cube(BLOCK);
        translate([bit_pos(0), bit_pos(5), bit_pos(1)])
        cube([bit_gap(1), bit_gap(1), bit_gap(1)]);
        translate([bit_pos(1), bit_pos(5), bit_pos(1)])
        cube([bit_gap(1), bit_gap(2), bit_gap(1)]);
        translate([bit_pos(1), bit_pos(5), bit_pos(0)])
        cube([bit_gap(1), bit_gap(1), bit_gap(1)]);
    };
};

module part_five(){
        translate([HEIGHT,0,0])
        mirror([1,0,0])
        part_one();
};

module part_six(){
    part_one();
};

part_one();
translate([HEIGHT + 1,0,0])
part_two();
translate([2*HEIGHT + 2,0,0])
part_three();
translate([3*HEIGHT + 3,0,0])
part_four();
translate([4*HEIGHT + 4,0,0])
part_five();
translate([5*HEIGHT + 5,0,0])
part_six();

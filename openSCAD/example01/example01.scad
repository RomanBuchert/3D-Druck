function inc (a) = (a = a+1)

module hexbox(xsize, ysize, zsize, diameter, space) {
    oldfn = $fn;
    $fn = 6;
    space_2 = space/2;
    radius = diameter/2;
    rowCntr = 0;
    a = 0;
    for ( y = [radius + space_2 : diameter + space: ysize]) {
        for ( x = [radius + space_2: diameter + space: xsize]) {
            rowCntr = rowCntr + 1;
            echo (a);
            translate([x, y, 0]){
                cylinder(zsize, radius, radius, true);
            };
        };
    };
};

hexbox(100, 100, 1, 5, 0);

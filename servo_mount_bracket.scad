// Mechanical Task 1 — Robot Dog Servo Mounting Bracket
// Units: millimetres
// Overall dimensions: 60 W x 40 D x 35 H

$fn = 64;

W = 60;
D = 40;
T = 4;
H = 35;
R = 2;

module rounded_plate(w,d,t,r=2) {
    minkowski() {
        cube([w-2*r,d-2*r,t], center=false);
        cylinder(r=r,h=0.01);
    }
}

module hole(x,y,r=2.25,h=12,z=-4) {
    translate([x,y,z]) cylinder(r=r,h=h);
}

// Base: 60 x 40 x 4 mm, with four M4 clearance holes
module base_plate() {
    difference() {
        translate([R,R,0]) rounded_plate(W,D,T,R);
        for (x=[8,W-8]) for (y=[8,D-8]) hole(x,y,2.25);
    }
}

// Vertical servo mounting plate: 60 x 35 x 4 mm
// Six M3 clearance holes in two rows for adjustable servo mounting
module upright_plate() {
    difference() {
        translate([0,D-T,0]) cube([W,T,H]);
        for (x=[12,30,48]) for (z=[12,25])
            rotate([90,0,0]) translate([x,z,-D+T-4]) cylinder(r=1.7,h=12);
        // central cable pass-through
        translate([24,D-T-2,7]) cube([12,8,6]);
    }
}

// Triangular side gussets improve rigidity
module gusset(x) {
    polyhedron(
        points=[
            [x,0,0],[x,D-T,0],[x,D-T,H],
            [x+T,0,0],[x+T,D-T,0],[x+T,D-T,H]
        ],
        faces=[
            [0,1,2],[3,5,4],[0,3,4,1],
            [1,4,5,2],[2,5,3,0]
        ]
    );
}

union() {
    base_plate();
    upright_plate();
    gusset(0);
    gusset(W-T);
}

/* [Global settings] */

// Global rescaler (X*1mm)
rescaler = 1; 

// Min. facet render level (mm)
$fs = 0.1;  // Don't generate smaller facets than 0.1 mm

// Min angles render level (deg)
$fa = 5;    // Don't generate larger angles than 5 degrees

// Enable helper geometry
debug = false; // [True, False]

// Horiz. spacing between debug parts (mm)
debug_spacing_y = 5;

// Vert. spacing between debug parts (mm)
debug_spacing_z = 15; 



/* [Foot dimensions] */

// Thickness of foot (mm)
foot_y = 1.8;

// Width of foot (mm)
foot_x = 7;

// Height of foot (mm)
foot_z = 9.2; 



/* [Stork dimensions] */

// Thickness of stork (mm)
stork_y = 2; 

// Diameter of stork (mm)
stork_d = 5.7; 

/* [Surround dimensions] */

// length of surround (mm)
surround_y = 10;

// starting diameter of surround (mm)
surround_d1 = 7.8;

// ending diameter of surround (mm)
surround_d2 = 5.8;



/* [Cut-outs] */

//Number of cutouts
surround_cutout_n = 3; // [0, 3, 4, 5] 

// Gap size between surround sections (mm)
surround_cutout_h = 1; //

// Diameter of wire cut-out (mm)
inner_d = 3.8;




// Main geometry
scale([rescaler,rescaler,rescaler])color("yellow") union() {
    translate([0,0-surround_y/2-foot_y/2-stork_y,0]) foot_stork_inner();
    surround_cutouts();
}

// Helpers
if (debug) helpers();
    
// Core geometric primitives
module foot() {
    color("Blue") cube([foot_x,foot_y,foot_z], center=true);
}
module stork() {
   color("Red") rotate([90,0,0]) cylinder(h=stork_y, r=(stork_d/2), center=true);
}
module surround() {
    color("Green") rotate([90,0,0]) cylinder(h=surround_y, r2=surround_d1/2, r1=surround_d2/2, center=true);
}
module surround_cutout() {
    color("Cyan") rotate([90,0,0]) cylinder(h=surround_cutout_h, r=(5), center=true);
}
module inner() {
    color("Pink") rotate([90,0,0]) cylinder(h=foot_y+stork_y+surround_y*1.1, r=(inner_d/2), center=true); // cut-out 10% longer than surround 
}

// Intermediate components
module surround_cutouts() {
    difference() { // apply inner cut-out for center
        difference() {
            surround();
            inner();
        }
        if (surround_cutout_n == 3) { 
            translate([0,0-surround_y*0.25,0]) surround_cutout();
            translate([0,0,0]) surround_cutout();
            translate([0,0+surround_y*0.25,0]) surround_cutout(); 
        }
        if (surround_cutout_n == 4) { 
            translate([0,0-surround_y*0.30,0]) surround_cutout();
            translate([0,0-surround_y*0.10,0]) surround_cutout();
            translate([0,0+surround_y*0.10,0]) surround_cutout();
            translate([0,0+surround_y*0.30,0]) surround_cutout(); 
        }
        if (surround_cutout_n == 5) { 
            translate([0,0-surround_y*0.30,0]) surround_cutout();
            translate([0,0-surround_y*0.15,0]) surround_cutout();
            translate([0,0,0]) surround_cutout();
            translate([0,0+surround_y*0.15,0]) surround_cutout(); 
            translate([0,0+surround_y*0.30,0]) surround_cutout(); 
        }
    }
    intersection() { // apply strut cut-out to surround
        union() { // define cut-out mask for the surround struts
            cube([1,surround_y, surround_d1*1.1], center=true); // cut-out mask 10% taller than largest radius
            rotate([0,90,0]) cube([1,surround_y, surround_d1*1.1], center=true); // cut-out mask 10% wider than largest radius
        }
    difference() { 
            surround();
            inner();
        }
    } 
}

module foot_stork_inner() {
    difference() {
        union() {
            translate([0,0,0]) foot();
            translate([0,0+foot_y/2+stork_y/2,0]) stork();
        }
        translate([0,0.5,0]) inner();
    }
}

// debug display 
module helpers() {
    translate([0, 0 - debug_spacing_y*2 - foot_y/2, debug_spacing_z * -2]) foot();
    translate([0, 0 - debug_spacing_y - stork_y/2, debug_spacing_z * -2]) stork();
    translate([0, 0 + surround_y/2, debug_spacing_z * -2]) surround();
    translate([0, 0 + debug_spacing_y + surround_y, debug_spacing_z * -2]) surround_cutout();
    translate([0, 0 + debug_spacing_y*2 + foot_y+stork_y+surround_y+5, debug_spacing_z * -2]) inner();
    
    translate([0, 0 - foot_y - stork_y - debug_spacing_y, debug_spacing_z * -1]) foot_stork_inner();
    translate([0, debug_spacing_y, debug_spacing_z * -1]) surround_cutouts();
}

echo(version=version());
// Written by Ed Watson <mail@edwardwatson.co.uk>
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain
// Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

              
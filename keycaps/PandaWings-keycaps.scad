// created by IndiePandaaaaa

use <des/MX_DES_Thumb.scad>
use <des/MX_DES_Standard.scad>
use <des/MX_DES_travel_stop.scad>

RENDER_ALL_CAPS = false;

// cherry activation point
CSILVER = 1.2;  // cherry mx silver
CRED = 2;  // cherry mx red
GPANDA = 2.5;  // glorious panda

// o-ring uncompressed thickness
RING_009 = 1.8;
GLORIOUS_A40_THIN = 1.5;

// needed keys
standard = [ [0, 10], [1, 12], [2, 12] ];
thumbs = [ [0, 1], [1, 1], [2, 1] ];
keycount = 40;


module standard_caps(id) {
  keycap_standard(
    keyID = id, // change profile refer to KeyParameters Struct
    cutLen = 0, // Don't change. for chopped caps
    Stem = true, // turn on shell and stems
    Dish = true, // turn on dish cut
    Stab = 0,
    visualizeDish = false, // turn on debug visual of Dish
    crossSection = false, // center cut to check internal
    homeDot = false, // turn on homedots
    Legends = false  // not working
  );
}

module thumb_caps(id) {
  keycap_thumb(
    keyID = id, //change profile refer to KeyParameters Struct
    cutLen = 0, //Don't change. for chopped caps
    Stem = true, //tusn on shell and stems
    Dish = true, //turn on dish cut
    Stab = 0,
    visualizeDish = false, // turn on debug visual of Dish
    crossSection = false, // center cut to check internal
    homeDot = false, //turn on homedots
    Legends = false // not working
  );
}

difference() {
  union() {
    // alphanumerical keycaps
    translate([10, 30, 0]) for (i = [0:len(standard) - 1]) {
      for (j = [0:RENDER_ALL_CAPS ? standard[i][1] : 0]) {
        translate([RENDER_ALL_CAPS ? 20 * j - (20 * standard[i][1]) / 2 : 0, 20 * i, 0]) standard_caps(id = standard[i][0]);
      }
    }
    
    // thumb cluster keycaps
    translate([10, 0, 0]) for (i = [0:1]) {
      mirror([i, 0, 0]) translate([20 * i, 0, 0]) for (x = [0:len(thumbs) - 1]) {
        translate([20 * x, 0, 0]) thumb_caps(id = thumbs[x][0]);
      }
    }

    // travel_stop
    translate([10, -30, 0]) for (i=[0: (RENDER_ALL_CAPS? keycount-1:0)]) {
      translate([15*(i%5), -15*floor(i/5), 0]) travel_stop(GPANDA, GLORIOUS_A40_THIN);
    }
  }
}


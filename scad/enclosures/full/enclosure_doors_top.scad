include <enclosure_common.scad>
use <../../utils.scad>

use <parametric_hinge_door_top.scad>
C_CONSTANT = 0 + 0;

C_FEMALE = C_CONSTANT + 0;
C_MALE = C_CONSTANT + 1;

//$preview_screws = false;

module ABS_door_top_hinge_stl() {
    $fn = 90;
    enclosure_door_top_hinge(angle = 0);
}

module enclosure_door_top_hinge(angle = 0) {
    stl("ABS_door_top_hinge");

    color("teal") {
        rotate([0.0, angle, 0.0]) leaf(C_FEMALE);
        leaf(C_MALE);
    }
}

module enclosure_door_top_hinge_rotated(angle = 0) {
    rotate([0,-90,0])
        enclosure_door_top_hinge(angle);
}

module enclosure_door_top_place_hinges(width, length) {
    translate([-width/2-5,length/3,0])
        children();

    translate([-width/2-5,-length/3,0])
        children();
}

module enclosure_door_top_sketch(width, length) {
    difference() {
        square([width, length],center = true);

        enclosure_door_top_place_handle(w = width, l = length)
        enclosure_door_top_handle_mounts()
        circle(r = M3_clearance_radius);

        enclosure_door_top_place_hinges(width+MATERIAL_STEEL_THICKNESS*2, length)
        tool_cutter_fastener_place(3, 1) circle(r = M3_clearance_radius);

        enclosure_door_top_frame_place_screws(width) {
            translate([0, length/2 - 7, 0])
                circle(r = M3_clearance_radius);
            translate([0, -(length/2 - 7), 0])
                circle(r = M3_clearance_radius);
        }

        translate([(width/2 - 5), 0, 0])
        rotate([0,0,90])
        enclosure_door_top_frame_place_screws(length-20) {
                circle(r = M3_clearance_radius);
        }
    }
}

module enclosure_door_top_frame_place_screws(length) {
    for(i = [-length/2+20 : (length-40)/3 : length/2-20])
        translate([i, 0, 0])
            children();
}

module STEEL_3mm_enclosure_door_top_frame_hinge_part_450_dxf() {
    enclosure_door_top_frame_hinge_part_sketch(450);
}

module enclosure_door_top_frame_hinge_part(length) {
    dxf(str("STEEL_", MATERIAL_STEEL_THICKNESS, "mm_enclosure_door_top_frame_hinge_part_",length));
    color("silver")
    linear_extrude(MATERIAL_STEEL_THICKNESS)
        enclosure_door_top_frame_hinge_part_sketch(length);

    if($preview_screws)
    translate([0,8,12])
    rotate([0,0,-90])
    enclosure_door_top_place_hinges(0, length+20)
    tool_cutter_fastener_place(3, 1)
    screw(M3_pan_screw, 12);
}

module enclosure_door_top_frame_hinge_part_sketch(length) {
    difference() {
        translate([0,-6,0])
        square([length, 10], center = true);

        translate([0,8,0])
        rotate([0,0,-90])
        enclosure_door_top_place_hinges(0, length+20)
        tool_cutter_fastener_place(3, 1) circle(r = M3_tap_radius);
    }
}


module STEEL_3mm_enclosure_door_top_frame_l500_dxf() {
    enclosure_door_top_frame_sketch(500);
}

module STEEL_3mm_enclosure_door_top_frame_l450_dxf() {
    enclosure_door_top_frame_sketch(450);
}

module enclosure_door_top_frame(length) {
    dxf(str("STEEL_", MATERIAL_STEEL_THICKNESS, "mm_enclosure_door_top_frame_l",length));
    color("silver")
    linear_extrude(MATERIAL_STEEL_THICKNESS)
        enclosure_door_top_frame_sketch(length);

    if($preview_screws)
    translate_z(8)
    enclosure_door_top_frame_place_screws(length)
    screw(M3_pan_screw, 8);
}

module enclosure_door_top_frame_sketch(length) {
    difference() {
        square([length-2, 8], center = true);
        enclosure_door_top_frame_place_screws(length) circle(r = M3_tap_radius);

//        enclosure_door_top_place_handle(l = 0, w = length)
        translate([length/2, 0])
        rotate([0,0,-90])
        enclosure_door_top_handle_mounts()
        circle(r = M3_tap_radius);
    }
}

module enclosure_door_top_handle_mounts() {
    translate([0, -50])
        children();
    translate([0, -10])
        children();
}
module enclosure_door_top_place_handle(w, l) {
    translate([w/2,-l/2+7,0])
    rotate([0,0,-90])
    children();
}

module ABS_enclosure_door_top_handle_stl() {
    enclosure_door_top_handle();
}

module enclosure_door_top_handle() {
    stl("ABS_enclosure_door_top_handle");

    screw = M3_cap_screw;

    difference() {
        hull() {
            translate([- 20, - 60, 0])
                cylinder(d = 3, h = 0.5);
            translate([- 20, 0, 0])
                cylinder(d = 3, h = 0.5);

            translate([0, - 60, 0])
                cylinder(d = 3, h = 5);
            cylinder(d = 3, h = 5);

            translate([30, - 60, 0])
                cylinder(d = 3, h = 5);
            translate([30, 0, 0])
                cylinder(d = 3, h = 5);
        }
        translate_z(-1)
        enclosure_door_top_handle_mounts(){
            translate_z(3)
            cylinder(r = screw_head_radius(screw), h = 10);
            cylinder(r = screw_clearance_radius(screw), h = 10);
        }
    }
}

module enclosure_door_top(width, length, angle = 0) {
    name = str("PC_",MATERIAL_DOOR_TOP_THICKNESS, "mm", "_enclosure_top_door_", width, "x", length);

    dxf(name);
    translate_z(10){
        translate_z(- 10){
            rotate_about_pt(y = - angle, pt = [- width / 2 - (MATERIAL_STEEL_THICKNESS * 2 + 2), 0,
                        MATERIAL_STEEL_THICKNESS * 2 + 4])
            color("blue", 0.5)
                linear_extrude(MATERIAL_DOOR_TOP_THICKNESS)
                    enclosure_door_top_sketch(width, length);

            translate_z(MATERIAL_DOOR_TOP_THICKNESS)
            enclosure_door_top_place_handle(w = width, l = length)
            enclosure_door_top_handle();
        }

        translate([-MATERIAL_STEEL_THICKNESS, 0])
        enclosure_door_top_place_hinges(width, length)
        enclosure_door_top_hinge_rotated(angle = 90 - angle);
    }

    rotate_about_pt(y = - angle, pt = [-width/2-(MATERIAL_STEEL_THICKNESS*2+2), 0, MATERIAL_STEEL_THICKNESS*2+4])
    translate_z(-MATERIAL_STEEL_THICKNESS){
        translate([0,length/2-7,0])
        enclosure_door_top_frame(width);

        translate([0,-(length/2-7),0])
        enclosure_door_top_frame(width);

        translate([(width/2-5),0,0])
        rotate([0,0,90])
        enclosure_door_top_frame(length-20);

        translate([-(width/2-5),0,0])
            rotate([0,0,90])
            enclosure_door_top_frame_hinge_part(length-20);
    }

    if($preview_screws) {
        enclosure_door_top_place_hinges(width, length)
        mirror([1, 0, 0])tool_cutter_fastener_place(3, 1)
        translate_z(- 9)
        rotate([0, 90, 0])
            translate_z(- 16)
            screw(M3_pan_screw, 8);

        enclosure_door_top_place_handle(w = width, l = length)
        enclosure_door_top_handle_mounts()
        translate_z(8)
            screw(M3_pan_screw, 10);

    }
}

module PC_5mm_enclosure_top_door_500x470_dxf() {
    enclosure_door_top_sketch(500, 470);
}

//PC_5mm_enclosure_top_door_500x470_dxf();

//$preview_screws = false;
//enclosure_door_top(width = 500, length = 470);
//ABS_enclosure_door_top_handle_stl();

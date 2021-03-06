include <toolhead_extruder_generic.scad>
include <toolhead_extruder_heatbreak_e3d_cooler.scad>
use <../../lib/extruder_orbiter/extruder_orbiter.scad>
use <toolhead_extruder_heatbreak_e3d_cooler.scad>
use <toolhead_extruder_orbiter_generic.scad>
use <../../lib/hotend_e3d/e3d_volcano.scad>

module toolhead_extruder_orbiter_vitamins_assembly(
width, length, heigth, inset_length, inset_depth, motor_type) {
    translate_z(heigth+15+3) {
        rotate([0,0,-90]) {
            translate_z(-11.95) {
                extruder_orbiter();
                extruder_orbiter_stepper_position(2) LDO_stepper();
            }
        }
        translate_z(-16.5)
            children();
    }

    toolhead_extruder_e3d_bottom_plate(
        width = width,
        length = length,
        inset_length = inset_length,
        inset_depth = inset_depth,
        heigth = heigth
    );

    translate_z(5.9)
    extruder_orbiter_hot_end_position() {
        e3d_volcano_hotend_assembly();
        translate_z(-40) {
            toolhead_extruder_heatbreak_e3d_cooler(length, cut_half = true);
            toolhead_extruder_heatbreak_e3d_fan_duct_nozzle();
        }
    }
}

module toolhead_extruder_orbiter_e3d_assembly(
        width,
        length,
        inset_length,
        inset_depth,
        heigth,
        motor_type = NEMA17S) {

    toolhead_extruder_orbiter_vitamins_assembly(
        width = width,
        length = length,
        heigth = heigth,
        inset_length = inset_length,
        inset_depth = inset_depth,
        motor_type = motor_type
    ){
        toolhead_extruder_orbiter_mount(
        width = width,
        length = length,
        inset_length = inset_length,
        padding = 5,
        motor_type = motor_type
        );
    }

    translate_z(heigth)
    toolhead_extruder_top_plate(
        width = width,
        length = length,
        inset_length = inset_length
    );
}



//toolhead_extruder_orbiter_e3d_assembly(60, 100, 80, 8, 29);
//toolhead_extruder_orbiter_mount_60x100x80_NEMA17S_5_stl();

/*
 * Igor Soares' lightweight extruder
 * Body
 * (C) 2014 by Ígor Bruno Pereira Soares
 *
 * This project is free: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This project is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this project.  If not, see <http://www.gnu.org/licenses/>.
 */

WALL_WIDTH = 2.05;
STRUCTURAL_WALL_WIDTH = 5.0;
VERTICAL_SUPPORT_WALL = 0.5;
HORIZONTAL_SUPPORT_WALL = 0.4;

MOTOR_HOLDER_ARM_WIDTH= 5.0;
MOTOR_HOLDER_RING_WIDTH = 7.0;
MOTOR_HOLDER_SCREW_DIAMETER = 3.4;
MOTOR_HOLDER_SCREWS_DISTANCE = 31;
MOTOR_HOLDER_INNER_DIAMETER = 37.5;

BASE_SCREWS_DIAMETER = 5.8;
BASE_SCREWS_NUT_WIDTH = 8.2;
BASE_SCREW_HOTEND_DISTANCE = 25.0; //center to center

HOTEND_BODY_DIAMETER = 16.4;
HOTEND_MOUNT_GROOVE_DIAMETER = 10.2;
HOTEND_BODY_ABOVE_GROOVE_H = 4.8;
HOTEND_MOUNT_SCREW_DIAMETER = 3.0;
HOTEND_MOUNT_SCREW_HEAD_DIAMETER = 5.0;
HOTEND_MOUNT_SCREW_LENGHT = 25.0;

BEARING_DIAMETER = 11.6;
BEARING_WIDTH = 5.4;
BEARING_ACCESS_HOLE_DIAMETER = 10;
PRESSURE_BEARING_CLEARANCE = -1;

SECOND_BEARING_FILAMENT_DISTANCE = 30;
BEARING_HOLDING_SCREW_DIAMETER = 3.6;
BEARING_HOLDING_SCREW_NUT_WIDTH = 6.7;
BEARING_HOLDING_SCREW_NUT_H = 3;
BEARING_HOLDING_SCREW_HEAD_DIAMETER = 6;
BEARING_HOLDING_SCREW_LENGTH = 25;

HOBBED_BOLT_AXIS_H = 21.2; //Dont make this EXACTLY half the gearbox diameter
                           // to avoid creatiing a defect in the model
                           // adding (or subtracting) a small value is enough
HOBBED_BOLT_DIAMETER=4.8;

FILAMENT_ROOM_DIAMETER = 4.0;
FILAMENT_APROX_DIAMETER = 3.0;
FILAMENT_BEARING_DISTANCE = 2.0;
GEARBOX_ROOM_DIAMETER = 41;
GEARBOX_ROOM_H = 27;

EXTRUDER_COMPRESSION_NUT_TRAP_BODY = 6;
IDLER_LEFT_WALL = 5;
IDLER_RIGHT_WALL = 7;
IDLER_BASE_SCREW_DIAMETER = 3.4;
IDLER_BASE_SCREW_NUT_WIDTH = 5.8;
IDLER_BASE_SCREW_NUT_H = 2;
IDLER_BASE_DIAMETER = 9.0;
IDLER_TOLERANCES = 0.4;
IDLER_COMPRESSION_SCREW_DIAMETER = 3.6;
IDLER_COMPRESSION_SCREW_NUT_WIDTH = 6.7;
IDLER_COMPRESSION_SCREW_NUT_H = 3;
IDLER_GUIDE_H = BEARING_DIAMETER/2;
IDLER_BEARING_SCREW_DIAMETER = 5.2;
IDLER_BEARING_SCREW_NUT_WIDTH = 8.4;
IDLER_BEARING_SCREW_NUT_H = 4;
IDLER_BODY_BELOW_BEARING_SCREW = 2;
IDLER_BODY_ABOVE_BEARING_SCREW = 0.5;


ST = 0.001;

ANGLE = -55;

$fn=64;

//idler();
extruder_with_supports_original_orientation();
//extruder();
//top_bearing_holder();

translate([IDLER_BODY_BELOW_BEARING_SCREW + IDLER_BEARING_SCREW_DIAMETER/2 +
             BEARING_DIAMETER/2 + FILAMENT_ROOM_DIAMETER/2,
           IDLER_LEFT_WALL + FILAMENT_APROX_DIAMETER/2 -
             PRESSURE_BEARING_CLEARANCE,
           HOBBED_BOLT_AXIS_H - IDLER_BASE_DIAMETER/2 -
             BEARING_DIAMETER/2 - IDLER_TOLERANCES])
  rotate([0,0,-90]) rotate([90,0,0])
    %idler();


module streched_cylinder(r=1, strech=0, h=1) {
  union() {
    translate([-strech/2, 0,0])
      cylinder(r=r, h=h);
    translate([-strech/2, -r,0])
      cube([strech, 2*r, h]);
    translate([strech/2, 0,0])
      cylinder(r=r, h=h);
  }
}

module extruder_base(
  wall=STRUCTURAL_WALL_WIDTH,
  base_screw_r=BASE_SCREWS_DIAMETER/2,
  base_screw_nut_r=BASE_SCREWS_NUT_WIDTH/(2*cos(30)),
  screw_hotend_distance=BASE_SCREW_HOTEND_DISTANCE,
  hotend_body_r=HOTEND_BODY_DIAMETER/2,
  angle=ANGLE
) {
  w = 2*hotend_body_r + 2*wall;
  h=wall;

  rotate([0,0,-angle])
    translate([-wall - base_screw_r - screw_hotend_distance,
               -wall - hotend_body_r,
               0])
    union()
    {
      translate([wall + base_screw_r, hotend_body_r - base_screw_r, 0])
        cube([2*screw_hotend_distance, 2*base_screw_r + 2*wall, h]);

      //translate([wall + base_screw_r + screw_hotend_distance, w/2, 0])
      //  rotate([0,0,angle]) 
      //    cylinder(r=hotend_body_r+wall, h=h);
      translate([wall + base_screw_r, w/2, 0])
        rotate([0,0,angle]) 
          cylinder(r=base_screw_r+wall, h=h);
      translate([wall + base_screw_r + 2*screw_hotend_distance, w/2, 0])
        rotate([0,0,angle]) 
          cylinder(r=base_screw_r+wall, h=h);
    }

}

module extruder_base_screws(
  wall=STRUCTURAL_WALL_WIDTH,
  base_screw_r=BASE_SCREWS_DIAMETER/2,
  base_screw_nut_r=BASE_SCREWS_NUT_WIDTH/(2*cos(30)),
  screw_hotend_distance=BASE_SCREW_HOTEND_DISTANCE,
  hotend_body_r=HOTEND_BODY_DIAMETER/2,
  angle=ANGLE
) {
  w = 2*hotend_body_r + 2*wall;
  h=wall;

  rotate([0,0,-angle])
    translate([-wall - base_screw_r - screw_hotend_distance,
               -wall - hotend_body_r,
               0])
      union()
  {

    translate([wall + base_screw_r, w/2, -1])
      rotate([0,0,angle])
        cylinder(r=base_screw_r,h=h+2);
    translate([wall + base_screw_r, w/2, lwall])
      rotate([0,0,angle+30])
        cylinder(r=base_screw_nut_r,h=h+2, $fn=6);

    translate([wall + base_screw_r + 2*screw_hotend_distance, w/2, -1])
      rotate([0,0,angle])
        cylinder(r=base_screw_r, h=h+2);

    translate([wall + base_screw_r + 2*screw_hotend_distance, w/2, lwall])
      rotate([0,0,angle+30])
        cylinder(r=base_screw_nut_r, h=h+2, $fn=6);
  }
}

module extruder(
  wall=STRUCTURAL_WALL_WIDTH,
  lwall=WALL_WIDTH,
  vsupport_w=VERTICAL_SUPPORT_WALL,
  hsupport_w=HORIZONTAL_SUPPORT_WALL,
  base_screw_r=BASE_SCREWS_DIAMETER/2,
  base_screw_nut_r=BASE_SCREWS_NUT_WIDTH/(2*cos(30)),
  screw_hotend_distance=BASE_SCREW_HOTEND_DISTANCE,
  hotend_body_r=HOTEND_BODY_DIAMETER/2,
  body_above_groove=HOTEND_BODY_ABOVE_GROOVE_H,
  bearing_r=BEARING_DIAMETER/2,
  bearing_access_r=BEARING_ACCESS_HOLE_DIAMETER/2,
  bearing_width=BEARING_WIDTH,
  bearing_holding_screw_r=BEARING_HOLDING_SCREW_DIAMETER/2,
  bearing_holding_screw_nut_r=BEARING_HOLDING_SCREW_NUT_WIDTH/(2*cos(30)),
  bearing_holding_screw_nut_h=BEARING_HOLDING_SCREW_NUT_H,
  bearing_holding_screw_length=BEARING_HOLDING_SCREW_LENGTH,
  bearing_holding_screw_head_r=BEARING_HOLDING_SCREW_HEAD_DIAMETER/2,
  idler_bearing_clearance=PRESSURE_BEARING_CLEARANCE,
  hobbed_bolt_h=HOBBED_BOLT_AXIS_H,
  hobbed_bolt_r=HOBBED_BOLT_DIAMETER/2,
  second_bearing_filament_distance=SECOND_BEARING_FILAMENT_DISTANCE,
  filament_r=FILAMENT_APROX_DIAMETER/2,
  filament_room_r=FILAMENT_ROOM_DIAMETER/2,
  filament_bearing_distance=FILAMENT_BEARING_DISTANCE,
  gearbox_r=GEARBOX_ROOM_DIAMETER/2,
  gearbox_room_h=GEARBOX_ROOM_H,
  idler_screw_r=IDLER_BASE_SCREW_DIAMETER/2,
  idler_base_r=IDLER_BASE_DIAMETER/2,
  idler_front_h=IDLER_BODY_ABOVE_BEARING_SCREW + IDLER_BEARING_SCREW_DIAMETER/2,
  idler_tolerances=IDLER_TOLERANCES,
  idler_left_wall=IDLER_LEFT_WALL,
  idler_right_wall=IDLER_RIGHT_WALL,
  compression_screw_r=IDLER_COMPRESSION_SCREW_DIAMETER/2,
  compression_screw_nut_r=IDLER_COMPRESSION_SCREW_NUT_WIDTH/(2*cos(30)),
  compression_screw_nut_h=IDLER_COMPRESSION_SCREW_NUT_H,
  compression_nut_trap_body=EXTRUDER_COMPRESSION_NUT_TRAP_BODY,
  motor_holder_arm=MOTOR_HOLDER_ARM_WIDTH,
  motor_holder_ring=MOTOR_HOLDER_RING_WIDTH,
  motor_screw_r=MOTOR_HOLDER_SCREW_DIAMETER/2,
  motor_screws_distance=MOTOR_HOLDER_SCREWS_DISTANCE,
  motor_holder_inner_r=MOTOR_HOLDER_INNER_DIAMETER/2,
  angle=ANGLE
) {
  axis_pos=-hobbed_bolt_r - filament_r;
  motor_holder_side = 2*gearbox_r*sin(acos((hobbed_bolt_h-wall)/gearbox_r));

  difference() {
    union() {
      extruder_base(
        wall=wall,
        lwall=lwall,
        base_screw_r=base_screw_r,
        base_screw_nut_r=base_screw_nut_r,
        screw_hotend_distance=screw_hotend_distance,
        hotend_body_r=hotend_body_r,
        angle=angle
      );
      cylinder(r=hotend_body_r + wall,
                h=lwall + body_above_groove);
      cylinder(r=filament_room_r + lwall,
                h=hobbed_bolt_h);
      translate([0,0, hobbed_bolt_h + bearing_r])
        cylinder(r=filament_room_r + lwall,
                 h=wall);
      translate([axis_pos -bearing_r - wall,
                 filament_room_r,
                 0])
        cube([2*bearing_r + wall - ST,
              bearing_width + 2*filament_bearing_distance,
              hobbed_bolt_h + bearing_r + wall]);

      translate([axis_pos -bearing_r - wall,
                 -second_bearing_filament_distance -
                   2*filament_bearing_distance - bearing_width,
                 0])
      {
        cube([2*bearing_r + 2*wall - ST,
              bearing_width + 2*filament_bearing_distance,
              hobbed_bolt_h - bearing_r/sqrt(2)]);
        cube([2*bearing_r + wall - ST,
              second_bearing_filament_distance + 2*filament_bearing_distance +
                bearing_width,
              wall]);
      }

      translate([axis_pos +bearing_r - compression_nut_trap_body -
                   compression_screw_nut_h,
                 filament_room_r,
                 hobbed_bolt_h + bearing_r + wall - ST])
        cube([compression_nut_trap_body + compression_screw_nut_h,
              2*filament_bearing_distance + bearing_width,
              2*compression_screw_nut_r]);

      translate([axis_pos + hobbed_bolt_r + filament_room_r + bearing_r,
                 filament_room_r - idler_bearing_clearance -
                   bearing_width - 1.5*idler_tolerances,
                 hobbed_bolt_h - bearing_r - idler_tolerances - idler_base_r])
        rotate([-90,0,0])
          cylinder(r=idler_base_r, h=bearing_width + idler_tolerances);
      translate([0,
                 filament_room_r - idler_bearing_clearance -
                   bearing_width - 1.5*idler_tolerances,
                 0])
          cube([axis_pos + hobbed_bolt_r + filament_room_r + bearing_r +
                  2*idler_base_r,
                bearing_width + idler_tolerances,
                hobbed_bolt_h - bearing_r - idler_tolerances - idler_base_r +
                  idler_screw_r]);

      //motor holding arms
      translate([axis_pos - motor_holder_side/2 - motor_holder_arm,
                 filament_room_r + 2*filament_bearing_distance +
                   bearing_width - motor_holder_arm,
                 0])
        cube([motor_holder_side + 2*motor_holder_arm,
              gearbox_room_h + motor_holder_arm + wall,
              wall]);
      translate([axis_pos - motor_holder_arm/2, filament_room_r, 0]) {
        translate([0, 0,
                 hobbed_bolt_h +motor_holder_inner_r + motor_holder_ring])
          cube([motor_holder_arm,
                gearbox_room_h + bearing_width + 2*filament_bearing_distance +
                  wall,
                wall]);
        translate([0,0, hobbed_bolt_h])
          cube([motor_holder_arm, bearing_width + 2*filament_bearing_distance,
                motor_holder_inner_r + motor_holder_ring + ST]);

        translate([0,
                 bearing_width + 2*filament_bearing_distance + gearbox_room_h,
                 hobbed_bolt_h +motor_holder_inner_r])
          #cube([motor_holder_arm,
                wall,
                motor_holder_ring+ST]);
      }

      // motor holding_cylinder
      translate([axis_pos,
                 filament_bearing_distance + filament_bearing_distance +
                   bearing_width  + filament_room_r + gearbox_room_h,
                 hobbed_bolt_h])
        rotate([-90,0,0])
          cylinder(r=motor_holder_inner_r + motor_holder_ring,
                   h=wall);
    }
      #extruder_base_screws(
        wall=wall,
        lwall=lwall,
        base_screw_r=base_screw_r,
        base_screw_nut_r=base_screw_nut_r,
        screw_hotend_distance=screw_hotend_distance,
        hotend_body_r=hotend_body_r,
        angle=angle
      );

    translate([0,0,-1])
      #cylinder(r=hotend_body_r, h=body_above_groove +1);

    translate([0,0,body_above_groove + hsupport_w])
      #cylinder(r=filament_room_r, h=hobbed_bolt_h + bearing_r + 2);

    translate([axis_pos,
               filament_bearing_distance + filament_room_r -ST,
               hobbed_bolt_h])
      rotate([-90,0,0])
        #cylinder(r=bearing_r, h=bearing_width, $fn=64);

//    translate([axis_pos,
//               filament_bearing_distance + filament_room_r -ST,
//               hobbed_bolt_h + bearing_r])
//      rotate([-90,0,0])
//        #cube([bearing_r, 2*bearing_r, bearing_width]);
    translate([axis_pos,
               filament_room_r -ST,
               hobbed_bolt_h + bearing_access_r])
      rotate([-90,0,0])
        #cube([bearing_r, 2*bearing_access_r,
               bearing_width + 2*filament_bearing_distance + 2*ST]);

    translate([axis_pos -bearing_r - wall - ST,
               filament_room_r - ST,
               hobbed_bolt_h - bearing_r/sqrt(2)])
      #cube([wall+bearing_r + 2*ST,
             2*filament_bearing_distance + bearing_width + 2*ST,
             bearing_r*sqrt(2)]);

    translate([axis_pos + bearing_r + hobbed_bolt_r - filament_room_r,
               filament_bearing_distance + filament_room_r +ST,
               hobbed_bolt_h])
      rotate([90,0,0])
        #cylinder(r=bearing_r,
                  h=bearing_width+filament_bearing_distance +
                      2*filament_room_r + lwall,
                  $fn=64);
    translate([axis_pos,
               -hotend_body_r,
               hobbed_bolt_h])
      rotate([-90,0,0])
        #cylinder(r=bearing_access_r,
                  h=2*hotend_body_r + filament_bearing_distance +
                      bearing_width +1,
                  $fn=64);
    translate([axis_pos - bearing_r - bearing_holding_screw_r,
               filament_bearing_distance + filament_room_r +
                 bearing_width/2,
               hobbed_bolt_h + bearing_r + wall - bearing_holding_screw_nut_h])
      cylinder(r=bearing_holding_screw_nut_r,
               h=bearing_holding_screw_nut_h + ST,
               $fn=6);
    translate([axis_pos - bearing_r - bearing_holding_screw_r,
               filament_bearing_distance + filament_room_r +
                 bearing_width/2,
               hobbed_bolt_h + bearing_r + wall -
                 bearing_holding_screw_length - ST])
      cylinder(r=bearing_holding_screw_r,
               h=bearing_holding_screw_length + 2*ST,
               $fn=64);
    translate([axis_pos - bearing_r - bearing_holding_screw_r,
               filament_bearing_distance + filament_room_r +
                 bearing_width/2,
               hobbed_bolt_h + bearing_r + wall - bearing_holding_screw_length])
      mirror([0,0,1])
      cylinder(r=bearing_holding_screw_head_r,
               h=hobbed_bolt_h + bearing_r + wall -
                   bearing_holding_screw_length + ST,
               $fn=64);
    //second bearing
    translate([axis_pos,
               -second_bearing_filament_distance - bearing_width -
                 filament_bearing_distance,
               hobbed_bolt_h])
      rotate([-90,0,0])
        #cylinder(r=bearing_r, h=bearing_width, $fn=64);
    translate([axis_pos,
               -second_bearing_filament_distance - bearing_width -
                 2*filament_bearing_distance - ST,
               hobbed_bolt_h])
      rotate([-90,0,0])
        #cylinder(r=bearing_access_r,
                  h=bearing_width + 2*filament_bearing_distance + 2*ST,
                  $fn=64);

    translate([axis_pos,
               filament_bearing_distance + filament_bearing_distance +
                 bearing_width  + filament_room_r + ST,
               hobbed_bolt_h])
      rotate([-90,0,0])
        #cylinder(r=gearbox_r, h=gearbox_room_h, $fn=64);

    translate([axis_pos - bearing_r - bearing_holding_screw_r,
               -second_bearing_filament_distance - bearing_width/2 -
                 filament_bearing_distance - ST,
               hobbed_bolt_h + bearing_r + wall -
                 bearing_holding_screw_length - ST])
      cylinder(r=bearing_holding_screw_r,
               h=bearing_holding_screw_length + 2*ST,
               $fn=64);
    translate([axis_pos - bearing_r - bearing_holding_screw_r,
               -second_bearing_filament_distance - bearing_width/2 -
                 filament_bearing_distance - ST,
               hobbed_bolt_h + bearing_r + wall - bearing_holding_screw_length])
      mirror([0,0,1])
      cylinder(r=bearing_holding_screw_head_r,
               h=hobbed_bolt_h + bearing_r + wall -
                   bearing_holding_screw_length + ST,
               $fn=64);
    translate([axis_pos + bearing_r + bearing_holding_screw_r,
               -second_bearing_filament_distance - bearing_width/2 -
                 filament_bearing_distance - ST,
               hobbed_bolt_h + bearing_r + wall -
                 bearing_holding_screw_length - ST])
      cylinder(r=bearing_holding_screw_r,
               h=bearing_holding_screw_length + 2*ST,
               $fn=64);
    translate([axis_pos + bearing_r + bearing_holding_screw_r,
               -second_bearing_filament_distance - bearing_width/2 -
                 filament_bearing_distance - ST,
               hobbed_bolt_h + bearing_r + wall - bearing_holding_screw_length])
      mirror([0,0,1])
      cylinder(r=bearing_holding_screw_head_r,
               h=hobbed_bolt_h + bearing_r + wall -
                   bearing_holding_screw_length + ST,
               $fn=64);

    //compression screw
      translate([axis_pos +bearing_r - compression_nut_trap_body -
                   compression_screw_nut_h -1,
                 filament_room_r + filament_bearing_distance + bearing_width/2,
                 hobbed_bolt_h + bearing_r + wall +compression_screw_nut_r -ST])
        rotate([0,90,0])
          #cylinder(r=compression_screw_r,
                    h=compression_nut_trap_body + compression_screw_nut_h +2);
      translate([axis_pos +bearing_r - compression_nut_trap_body -
                   compression_screw_nut_h -1,
                 filament_room_r + filament_bearing_distance + bearing_width/2,
                 hobbed_bolt_h + bearing_r + wall +compression_screw_nut_r -ST])
        rotate([0,90,0]) rotate([0,0,30])
          #cylinder(r=compression_screw_nut_r,
                    h=compression_screw_nut_h+1,
                    $fn=6);
    // idler support
    translate([axis_pos + hobbed_bolt_r + filament_room_r + bearing_r,
               filament_room_r - idler_bearing_clearance -
                 bearing_width - 1.5*idler_tolerances - ST,
               hobbed_bolt_h - bearing_r - idler_tolerances - idler_base_r])
      rotate([90,0,0])
        #cylinder(r=idler_base_r + idler_tolerances,
                  h=idler_right_wall + 2*idler_tolerances);
    translate([axis_pos + hobbed_bolt_r + filament_room_r + bearing_r,
               filament_room_r - idler_bearing_clearance -
                 bearing_width - 3.5*idler_tolerances - idler_right_wall,
               hobbed_bolt_h - bearing_r - idler_tolerances - 2*idler_base_r])
      #cube([hotend_body_r + wall, idler_right_wall +2*idler_tolerances -ST,
             idler_base_r]);

    translate([axis_pos + hobbed_bolt_r + filament_room_r + bearing_r,
               filament_room_r - idler_bearing_clearance -
                 0.5*idler_tolerances + ST,
               hobbed_bolt_h - bearing_r - idler_tolerances - idler_base_r])
      rotate([-90,0,0])
        #cylinder(r=idler_base_r + idler_tolerances,
                  h=idler_left_wall + 2*idler_tolerances);
    translate([axis_pos + hobbed_bolt_r + filament_room_r + bearing_r,
               filament_room_r - idler_bearing_clearance -
                 0.5*idler_tolerances + ST,
               hobbed_bolt_h - bearing_r - idler_tolerances - 2*idler_base_r])
      #cube([hotend_body_r + wall, idler_left_wall + 2*idler_tolerances - ST,
             idler_base_r]);

    translate([axis_pos + hobbed_bolt_r + filament_room_r + bearing_r,
               filament_room_r - idler_bearing_clearance -
                 0.5*idler_tolerances + ST,
               hobbed_bolt_h - bearing_r - idler_tolerances - idler_base_r])
      rotate([90,0,0])
        #cylinder(r=idler_screw_r, h = bearing_width + 2*idler_tolerances +2);

      //motor holding holes
      translate([axis_pos,
                 filament_bearing_distance + filament_bearing_distance +
                   bearing_width  + filament_room_r + gearbox_room_h -1,
                 0])
        union()
      {
        translate([-motor_holder_inner_r - motor_holder_ring, 0, 0])
          mirror([0,0,1])
           #cube([2*motor_holder_inner_r + 2*motor_holder_ring, wall +2,
                  gearbox_r]);
        translate([0,0,hobbed_bolt_h]) rotate([-90,0,0]) {
          #cylinder(r=motor_holder_inner_r, h=wall+2);
          for(a=[0, 90, 180, 270]) rotate([0,0,a]) {
            translate([motor_screws_distance/sqrt(2),0,0])
              #cylinder(r=motor_screw_r, h=wall+2);
          }
        }
      }
  }
}

module extruder_with_supports_original_orientation(
  wall=STRUCTURAL_WALL_WIDTH,
  lwall=WALL_WIDTH,
  vsupport_w=VERTICAL_SUPPORT_WALL,
  hsupport_w=HORIZONTAL_SUPPORT_WALL,
  base_screw_r=BASE_SCREWS_DIAMETER/2,
  base_screw_nut_r=BASE_SCREWS_NUT_WIDTH/(2*cos(30)),
  screw_hotend_distance=BASE_SCREW_HOTEND_DISTANCE,
  hotend_body_r=HOTEND_BODY_DIAMETER/2,
  body_above_groove=HOTEND_BODY_ABOVE_GROOVE_H,
  bearing_r=BEARING_DIAMETER/2,
  bearing_access_r=BEARING_ACCESS_HOLE_DIAMETER/2,
  bearing_width=BEARING_WIDTH,
  bearing_holding_screw_r=BEARING_HOLDING_SCREW_DIAMETER/2,
  bearing_holding_screw_nut_r=BEARING_HOLDING_SCREW_NUT_WIDTH/(2*cos(30)),
  bearing_holding_screw_nut_h=BEARING_HOLDING_SCREW_NUT_H,
  bearing_holding_screw_length=BEARING_HOLDING_SCREW_LENGTH,
  bearing_holding_screw_head_r=BEARING_HOLDING_SCREW_HEAD_DIAMETER/2,
  idler_bearing_clearance=PRESSURE_BEARING_CLEARANCE,
  hobbed_bolt_h=HOBBED_BOLT_AXIS_H,
  hobbed_bolt_r=HOBBED_BOLT_DIAMETER/2,
  second_bearing_filament_distance=SECOND_BEARING_FILAMENT_DISTANCE,
  filament_r=FILAMENT_APROX_DIAMETER/2,
  filament_room_r=FILAMENT_ROOM_DIAMETER/2,
  filament_bearing_distance=FILAMENT_BEARING_DISTANCE,
  gearbox_r=GEARBOX_ROOM_DIAMETER/2,
  gearbox_room_h=GEARBOX_ROOM_H,
  idler_screw_r=IDLER_BASE_SCREW_DIAMETER/2,
  idler_base_r=IDLER_BASE_DIAMETER/2,
  idler_front_h=IDLER_BODY_ABOVE_BEARING_SCREW + IDLER_BEARING_SCREW_DIAMETER/2,
  idler_tolerances=IDLER_TOLERANCES,
  idler_left_wall=IDLER_LEFT_WALL,
  idler_right_wall=IDLER_RIGHT_WALL,
  compression_screw_r=IDLER_COMPRESSION_SCREW_DIAMETER/2,
  compression_screw_nut_r=IDLER_COMPRESSION_SCREW_NUT_WIDTH/(2*cos(30)),
  compression_screw_nut_h=IDLER_COMPRESSION_SCREW_NUT_H,
  compression_nut_trap_body=EXTRUDER_COMPRESSION_NUT_TRAP_BODY,
  motor_holder_arm=MOTOR_HOLDER_ARM_WIDTH,
  motor_holder_ring=MOTOR_HOLDER_RING_WIDTH,
  motor_screw_r=MOTOR_HOLDER_SCREW_DIAMETER/2,
  motor_screws_distance=MOTOR_HOLDER_SCREWS_DISTANCE,
  motor_holder_inner_r=MOTOR_HOLDER_INNER_DIAMETER/2,
  angle=ANGLE
) {
  axis_pos=-hobbed_bolt_r - filament_r;
  motor_holder_side = 2*gearbox_r*sin(acos((hobbed_bolt_h-wall)/gearbox_r));

  union() {
    extruder(
      wall=wall,
      lwall=lwall,
      vsupport_w=vsupport_w,
      hsupport_w=hsupport_w,
      base_screw_r=base_screw_r,
      base_screw_nut_r=base_screw_nut_r,
      screw_hotend_distance=screw_hotend_distance,
      hotend_body_r=hotend_body_r,
      body_above_groove=body_above_groove,
      bearing_r=bearing_r,
      bearing_access_r=bearing_access_r,
      bearing_width=bearing_width,
      idler_bearing_clearance=idler_bearing_clearance,
      hobbed_bolt_h=hobbed_bolt_h,
      hobbed_bolt_r=hobbed_bolt_r,
      filament_r=filament_r,
      filament_room_r=filament_room_r,
      filament_bearing_distance=filament_bearing_distance,
      gearbox_r=gearbox_r,
      gearbox_room_h=gearbox_room_h,
      idler_screw_r=idler_screw_r,
      idler_base_r=idler_base_r,
      idler_front_h=idler_front_h,
      idler_tolerances=idler_tolerances,
      idler_left_wall=idler_left_wall,
      idler_right_wall=idler_right_wall,
      compression_screw_r=compression_screw_r,
      compression_screw_nut_r=compression_screw_nut_r,
      compression_screw_nut_h=compression_screw_nut_h,
      compression_nut_trap_body=compression_nut_trap_body,
      motor_holder_arm=motor_holder_arm,
      motor_holder_ring=motor_holder_ring,
      motor_screw_r=motor_screw_r,
      motor_screws_distance=motor_screws_distance,
      motor_holder_inner_r=motor_holder_inner_r,
      angle=angle
    );

    translate([axis_pos - bearing_r - wall - ST,
               filament_room_r,
               body_above_groove +lwall -ST])
      cube([bearing_r + wall +
              max(bearing_r,hobbed_bolt_r + filament_room_r + lwall),
            vsupport_w,
            hobbed_bolt_h + bearing_r - body_above_groove - lwall + ST]);
    translate([axis_pos - bearing_r - ST,
               filament_bearing_distance + filament_room_r - vsupport_w,
               body_above_groove +lwall -ST])
      cube([bearing_r + max(bearing_r,hobbed_bolt_r + filament_room_r + lwall),
            vsupport_w,
            hobbed_bolt_h + bearing_r - body_above_groove - lwall + ST]);

    translate([axis_pos - bearing_r - ST,
               filament_room_r + filament_bearing_distance + bearing_width,
               body_above_groove +lwall -ST])
      cube([2*bearing_r, vsupport_w, hobbed_bolt_h]);
    translate([axis_pos - bearing_r - wall - ST,
               2*filament_bearing_distance + filament_room_r + bearing_width -
                 vsupport_w,
               body_above_groove +lwall -ST])
      cube([2*bearing_r + wall, vsupport_w, hobbed_bolt_h]);

    //bearing holder screw bridges
    translate([axis_pos - bearing_r - wall - ST,
               filament_bearing_distance/2 + filament_room_r,
               hobbed_bolt_h +bearing_r+wall -bearing_holding_screw_length -ST])
      #cube([wall, filament_bearing_distance + bearing_width, hsupport_w]);
    translate([axis_pos - bearing_r - wall - ST,
               filament_bearing_distance/2 + filament_room_r,
               hobbed_bolt_h +bearing_r/sqrt(2) -ST])
      #cube([wall, filament_bearing_distance + bearing_width, hsupport_w]);
    translate([axis_pos - bearing_r - wall - ST,
               -second_bearing_filament_distance - 2*filament_bearing_distance -
                 bearing_width,
               hobbed_bolt_h +bearing_r+wall -bearing_holding_screw_length -ST])
      #cube([wall, filament_bearing_distance + bearing_width, hsupport_w]);
    translate([axis_pos + bearing_r - ST,
               -second_bearing_filament_distance - 2*filament_bearing_distance -
                 bearing_width,
               hobbed_bolt_h +bearing_r+wall -bearing_holding_screw_length -ST])
      #cube([wall, filament_bearing_distance + bearing_width, hsupport_w]);

    translate([-filament_room_r - lwall, -filament_room_r - lwall,
               body_above_groove + ST])
      cube([2*filament_room_r + 2*lwall, vsupport_w,
            hobbed_bolt_h + bearing_r - body_above_groove +ST]);
    translate([-filament_room_r - lwall, -filament_room_r - lwall,
               hobbed_bolt_h + bearing_r])
      cube([2*filament_room_r + 2*lwall,
            2*filament_room_r + 2*lwall,
            hsupport_w]);

    //supports to hotend hole
    cylinder(r=2*vsupport_w/cos(30), h=body_above_groove + ST, $fn=6);
    for (i=[0:6]) rotate([0,0,i*360/6])
      translate([(hotend_body_r + 2*vsupport_w)/3, 0, 0])
        cylinder(r=2*vsupport_w/cos(30), h=body_above_groove + ST, $fn=6);
    for (i=[0:11]) rotate([0,0,i*360/11])
      translate([2*(hotend_body_r + 2*vsupport_w)/3, 0, 0])
        cylinder(r=2*vsupport_w/cos(30), h=body_above_groove + ST, $fn=6);

    // upper arm support
    for(i=[1:4]) translate([
      axis_pos - motor_holder_arm/2,
      2*filament_bearing_distance + filament_room_r + bearing_width +
        gearbox_room_h*(i/5),
      0])
        cube([motor_holder_arm, vsupport_w, hobbed_bolt_h +
                motor_holder_inner_r + motor_holder_ring + ST]);
  }
  translate([
      axis_pos - motor_holder_arm/2,
      2*filament_bearing_distance + filament_room_r + bearing_width +
        0,
      0])
        cube([vsupport_w, gearbox_room_h, hobbed_bolt_h +
                motor_holder_inner_r + motor_holder_ring + ST]);
  // ring support
  translate([
      axis_pos,
      2*filament_bearing_distance + filament_room_r + bearing_width +
        gearbox_room_h,
      hobbed_bolt_h])
      rotate([-90,0,0])
      difference()
  {
    cylinder(r=motor_holder_inner_r + ST, h=wall);
    translate([0,0,vsupport_w])
      cylinder(r=motor_holder_inner_r + ST, h=wall - 2*vsupport_w);

    translate([motor_holder_inner_r*cos(45), - motor_holder_inner_r, -1])
      cube([2*motor_holder_inner_r, 2*motor_holder_inner_r, wall+2]);
    mirror([1,0,0])
    translate([motor_holder_inner_r*cos(45), - motor_holder_inner_r, -1])
      cube([2*motor_holder_inner_r, 2*motor_holder_inner_r, wall+2]);
  }
}

module idler(
  wall=STRUCTURAL_WALL_WIDTH,
  lwall=WALL_WIDTH,
  left_wall=IDLER_LEFT_WALL,
  right_wall=IDLER_RIGHT_WALL,
  body_below_screw=IDLER_BODY_BELOW_BEARING_SCREW,
  body_above_screw=IDLER_BODY_ABOVE_BEARING_SCREW,
  base_screw_r=IDLER_BASE_SCREW_DIAMETER/2,
  base_nut_r=IDLER_BASE_SCREW_NUT_WIDTH/(2*cos(30)),
  base_nut_h=IDLER_BASE_SCREW_NUT_H,
  base_r=IDLER_BASE_DIAMETER/2,
  bearing_tolerance=IDLER_TOLERANCES,
  compression_screw_r=IDLER_COMPRESSION_SCREW_DIAMETER/2,
  guide_h=IDLER_GUIDE_H,
  bearing_screw_r=IDLER_BEARING_SCREW_DIAMETER/2,
  bearing_screw_nut_r=IDLER_BEARING_SCREW_NUT_WIDTH/(2*cos(30)),
  bearing_screw_nut_h=IDLER_BEARING_SCREW_NUT_H,
  bearing_r=BEARING_DIAMETER/2,
  bearing_width=BEARING_WIDTH,
  vsupport_w=VERTICAL_SUPPORT_WALL,
  compression_screw_pos_h=BEARING_DIAMETER/2 + STRUCTURAL_WALL_WIDTH +
                          IDLER_COMPRESSION_SCREW_NUT_WIDTH/(2*cos(30)),
  compression_screw_pos_y= FILAMENT_BEARING_DISTANCE + BEARING_WIDTH/2 +
                           IDLER_TOLERANCES/2 + PRESSURE_BEARING_CLEARANCE
) {
  h1 = body_below_screw + 2*bearing_screw_r + body_above_screw;
  hs = body_below_screw + bearing_screw_r;
  ys = base_r + bearing_tolerance + bearing_r;

  difference() {
    union() {
      translate([0, base_r + ST, 0])
        cube([bearing_width + left_wall + right_wall + 2*bearing_tolerance,
              2*bearing_r + wall + 2*bearing_tolerance,
              h1]);
      translate([left_wall, 0, hs])
        rotate([0, -90, 0])
          cylinder(r=base_r, h=wall);

      translate([0, 0, 0])
        cube([left_wall,
              base_r + 2*ST,
              hs+ body_above_screw + bearing_screw_r]);
      translate([left_wall + 2*bearing_tolerance + bearing_width, 0, 0])
        cube([right_wall,
              base_r + 2*ST,
              hs+ body_above_screw + bearing_screw_r]);

     translate([left_wall-compression_screw_pos_y,
                ys + bearing_r, 0])
       cube([compression_screw_pos_y + 2*bearing_tolerance + bearing_width +
               right_wall,
             compression_screw_pos_h - bearing_r,
             h1]);
     translate([left_wall-compression_screw_pos_y,
                ys + compression_screw_pos_h,
                0])
       rotate([0,0,90])
         cylinder(r=compression_screw_r + wall, h=h1);

     //support for left arm
     difference() {
      translate([-wall+left_wall, -base_r, 0])
        cube([wall, 2*base_r, hs]);
      translate([-wall+left_wall + vsupport_w, -base_r -1, -1])
        cube([wall - 2*vsupport_w, 2*base_r + 2, hs +2]);
     }

      translate([left_wall + bearing_width + 2*bearing_tolerance, 0, hs])
        rotate([0, 90, 0])
          cylinder(r=base_r, h=right_wall);

     //support for right arm
     difference() {
      translate([left_wall + 2*bearing_tolerance + bearing_width, -base_r, 0])
        cube([right_wall, 2*base_r, hs]);
      translate([left_wall + 2*bearing_tolerance + bearing_width + vsupport_w,
                 -base_r -1,
                 -1])
        cube([right_wall - 2*vsupport_w, 2*base_r + 2, hs +2]);
     }
    }
    translate([left_wall, ys, hs]) difference() {
        union() {
          rotate([0,90,0])
            #cylinder(r=bearing_r + bearing_tolerance,
                     h=bearing_width + 2*bearing_tolerance);
          translate([0, - bearing_tolerance - bearing_r, 0])
            #cube([bearing_width + 2*bearing_tolerance,
                   2*bearing_r + 2*bearing_tolerance,
                   body_above_screw + bearing_screw_r + ST]);
        }
        rotate([0,90,0])
          translate([0,0,-ST])
            cylinder(r1=bearing_screw_r + 2*vsupport_w,
                     r2=bearing_screw_r + vsupport_w,
                     h=bearing_tolerance +ST);
    }

    translate([-1, ys, hs])
      rotate([0,90,0])
        #cylinder(r=bearing_screw_r,
                  h=left_wall + right_wall + 2*bearing_tolerance +
                     bearing_width + 2);
    translate([left_wall + bearing_tolerance + bearing_width, ys, hs])
      rotate([0,90,0]) rotate([0,0,30])
        #cylinder(r=bearing_screw_nut_r, h=bearing_screw_nut_h, $fn=6);

    translate([-1, 0, hs])
      rotate([0,90,0])
        #cylinder(r=base_screw_r,
                  h=wall + right_wall + 2*bearing_tolerance +
                     bearing_width + 2);
    translate([left_wall + 2*bearing_tolerance + bearing_width - ST, 0, hs])
      rotate([0,90,0]) rotate([0,0,30])
        #cylinder(r=base_nut_r, h=base_nut_h, $fn=6);

    translate([left_wall + ST, 0, hs])
      rotate([0,90,0])
        #cylinder(r=base_r + bearing_tolerance,
                  h=bearing_screw_nut_h + 2*bearing_tolerance  + ST,
                  $fn=64);

    translate([left_wall-compression_screw_pos_y,
               ys + compression_screw_pos_h + wall,
               -1])
      rotate([0,0,90])
        #streched_cylinder(r=compression_screw_r,
                           strech=2*wall,
                           h=h1+2);
  }
}

module top_bearing_holder(
  wall=STRUCTURAL_WALL_WIDTH,
  bearing_r=BEARING_DIAMETER/2,
  bearing_access_r=BEARING_ACCESS_HOLE_DIAMETER/2,
  bearing_width=BEARING_WIDTH,
  filament_bearing_distance=FILAMENT_BEARING_DISTANCE,
  bearing_holding_screw_r=BEARING_HOLDING_SCREW_DIAMETER/2,
  bearing_holding_screw_nut_r=BEARING_HOLDING_SCREW_NUT_WIDTH/(2*cos(30)),
  bearing_holding_screw_nut_h=BEARING_HOLDING_SCREW_NUT_H,
  hsupport_w=HORIZONTAL_SUPPORT_WALL
) {
  rotate([180,0,0]) difference() {
    cube([2*bearing_r + 2*wall, bearing_width + 2*filament_bearing_distance,
          bearing_r/sqrt(2) + wall]);
    translate([bearing_r + wall, -ST, -bearing_r*(sqrt(2) -1)])
      rotate([-90,0,0])
        #cylinder(r=bearing_access_r,
                  h=2*filament_bearing_distance + bearing_width + 2*ST);
    translate([bearing_r + wall, filament_bearing_distance,
               -bearing_r*(sqrt(2) -1)])
      rotate([-90,0,0])
        #cylinder(r=bearing_r, h=bearing_width);

    translate([wall - bearing_holding_screw_r,
               filament_bearing_distance + bearing_width/2,
               bearing_r/sqrt(2) + wall - bearing_holding_screw_nut_h])
      #cylinder(r=bearing_holding_screw_nut_r,
                h=bearing_holding_screw_nut_h + ST,
                $fn=6);
    translate([wall - bearing_holding_screw_r,
               filament_bearing_distance + bearing_width/2,
               -ST])
      #cylinder(r=bearing_holding_screw_r,
                h=bearing_r/sqrt(2) + wall - bearing_holding_screw_nut_h -
                    hsupport_w,
                $fn=64);

    translate([wall + 2*bearing_r + bearing_holding_screw_r,
               filament_bearing_distance + bearing_width/2,
               bearing_r/sqrt(2) + wall - bearing_holding_screw_nut_h])
      #cylinder(r=bearing_holding_screw_nut_r,
                h=bearing_holding_screw_nut_h + ST,
                $fn=6);
    translate([wall + 2*bearing_r + bearing_holding_screw_r,
               filament_bearing_distance + bearing_width/2,
               -ST])
      #cylinder(r=bearing_holding_screw_r,
                h=bearing_r/sqrt(2) + wall - bearing_holding_screw_nut_h -
                    hsupport_w,
                $fn=64);
  }
}


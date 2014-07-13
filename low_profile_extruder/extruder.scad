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

include <configuration.scad>

$fn=64;

mirror([0,1,0]) extruder_with_support();

module extruder_base(
  wall=STRUCTURAL_WALL_WIDTH,
  base_screw_r=BASE_SCREWS_DIAMETER/2,
  base_screw_nut_r=BASE_SCREWS_NUT_WIDTH/(2*cos(30)),
  screw_hotend_distance=BASE_SCREW_HOTEND_DISTANCE,
  hotend_body_r=HOTEND_BODY_DIAMETER/2,
  angle=90
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
  lwall=WALL_WIDTH,
  base_screw_r=BASE_SCREWS_DIAMETER/2,
  base_screw_nut_r=BASE_SCREWS_NUT_WIDTH/(2*cos(30)),
  screw_hotend_distance=BASE_SCREW_HOTEND_DISTANCE,
  hotend_body_r=HOTEND_BODY_DIAMETER/2,
  angle=90
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
        cylinder(r=base_screw_r,h=h+2);
    translate([wall + base_screw_r, w/2, lwall])
      rotate([0,0,30])
        cylinder(r=base_screw_nut_r,h=h+2, $fn=6);

    translate([wall + base_screw_r + 2*screw_hotend_distance, w/2, -1])
        cylinder(r=base_screw_r, h=h+2);

    translate([wall + base_screw_r + 2*screw_hotend_distance, w/2, lwall])
      rotate([0,0,30])
        cylinder(r=base_screw_nut_r, h=h+2, $fn=6);
  }
}

module extruder(
  wall=STRUCTURAL_WALL_WIDTH,
  lwall=WALL_WIDTH,
  hsupport=HORIZONTAL_SUPPORT_WALL,
  vsupport=VERTICAL_SUPPORT_WALL,
  base_screw_r=BASE_SCREWS_DIAMETER/2,
  base_screw_nut_r=BASE_SCREWS_NUT_WIDTH/(2*cos(30)),
  screw_hotend_distance=BASE_SCREW_HOTEND_DISTANCE,
  hotend_body_r=HOTEND_BODY_DIAMETER/2,
  hotend_body_above_groove_h=HOTEND_BODY_ABOVE_GROOVE_H,
  bearing_r=BEARING_DIAMETER/2,
  bearing_access_r=BEARING_ACCESS_HOLE_DIAMETER/2,
  bearing_width=BEARING_WIDTH,
  bearing_screw_r=BEARING_SCREW_DIAMETER/2,
  hobbed_bolt_r=HOBBED_BOLT_DIAMETER/2,
  filament_r=FILAMENT_APROX_DIAMETER/2,
  idler_width=IDLER_W,
  idler_holder_screw_r=IDLER_HOLDER_SCREW_DIAMETER/2,
  idler_holder_screw_head_r=IDLER_HOLDER_SCREW_HEAD_DIAMETER/2,
  idler_holder_screw_head_room_h=IDLER_HOLDER_SCREW_HEAD_ROOM_H,
  idler_holder_screw_nut_r=IDLER_HOLDER_SCREW_NUT_WIDTH/(2*cos(30)),
  idler_holder_screw_nut_h=IDLER_HOLDER_SCREW_NUT_H,
  idler_pressure_screw_r=IDLER_PRESSURE_SCREW_DIAMETER/2,
  idler_pressure_screw_z_pos=IDLER_PRESSURE_SCREW_Z_POS,
  idler_pressure_screw_x_pos=IDLER_PRESSURE_SCREW_Y_POS,
  gears_shafts_distance=GEAR_SHAFTS_DISTANCE,
  second_bearing_pos=SECOND_BEARING_POS,
  motor_screw_r=MOTOR_SCREW_DIAMETER/2,
  motor_screw_mount=MOTOR_SCREW_MOUNT,
  motor_screw_wall=MOTOR_SCREW_WALL,
  motor_mount_width=MOTOR_MOUNT_WIDTH,
  motor_mount_inner_r=MOTOR_HOLDER_INNER_DIAMETER/2,
  motor_shaft_h=MOTOR_SHAFT_H,
  motor_shaft_pos=MOTOR_SHAFT_POS,
  motor_size=MOTOR_SIZE,
  fist_bearing_screw_angular_pos=FIST_BEARING_SCREW_ANGLE,
  invert_motor=INVERT_MOTOR_SIDE,
  angle=ANGLE
) {
  axis_pos=filament_r + hobbed_bolt_r;
  axis_h = hotend_body_above_groove_h + hobbed_bolt_r;

  first_bearing_pos = screw_hotend_distance - base_screw_nut_r*cos(30) -
bearing_width +ST;

  wall_support_pos = [
    filament_r - idler_holder_screw_r,
    axis_pos + bearing_access_r + lwall + idler_holder_screw_r,
    0];
  a1 = atan(
           (second_bearing_pos - first_bearing_pos)/
           (gears_shafts_distance - wall_support_pos[1] + 2*wall));

  flat_bottom_bearing_width = (axis_h > bearing_r + wall) ?
                                ST :
                                2*bearing_r*sin(
                                    acos( (axis_h-wall-bearing_r)/bearing_r)
                                  ) + 2*lwall;
  motor_holder_size_from_axis = motor_shaft_pos + motor_screw_mount/2 +
                                motor_screw_wall +motor_screw_r;
  motor_holder_size_from_base = motor_shaft_h - motor_size[1]/2;
  motor_holder_top = motor_shaft_h + motor_screw_mount/2 +
                                motor_screw_wall +motor_screw_r;

  motor_pos = motor_shaft_pos - motor_size[0]/2;

  angle_diagonal = -atan(
                     (second_bearing_pos + lwall + bearing_width
                        - motor_mount_width)/
                     (motor_holder_size_from_axis - flat_bottom_bearing_width/2)
                   );
  mount_plante_diagonal_angle = -atan(
    ((bearing_r + wall) + (motor_shaft_pos -motor_screw_mount/2 -
                           motor_screw_wall - motor_screw_r))/
   (motor_holder_top - axis_h)
  );
  invert_motor_flag=(invert_motor) ? 1 : 0;

  difference() {
    union() {
      extruder_base(
        wall=wall,
        base_screw_r=base_screw_r,
        base_screw_nut_r=base_screw_nut_r,
        screw_hotend_distance=screw_hotend_distance,
        hotend_body_r=hotend_body_r
      );

      //hotend
      cylinder(r=hotend_body_r +wall, h=hotend_body_above_groove_h);

      //first bearing
      translate([first_bearing_pos - lwall, axis_pos, axis_h]) 
        rotate([0,90,0])
          cylinder(r=bearing_r + wall, h=bearing_width + lwall);
      //first bearing holding screw
      translate([first_bearing_pos - lwall, axis_pos, axis_h]) 
        rotate([0,90,0]) rotate([0,0,fist_bearing_screw_angular_pos]) {
          translate([0, bearing_r + bearing_screw_r + ST, 0])
            cylinder(r=bearing_screw_r + wall,
                     h=bearing_width + lwall);
      }

      //second bearing
      translate([second_bearing_pos, axis_pos, axis_h]) 
        rotate([0,90,0])
          cylinder(r=bearing_r + wall, h=bearing_width + lwall);
      translate([second_bearing_pos, axis_pos, axis_h]) 
        rotate([0,90,0])
      {
          for(a=[90]) rotate([0,0,a])
            translate([0, bearing_r + bearing_screw_r + ST, 0])
              cylinder(r=bearing_screw_r + wall,
                       h=bearing_width + lwall);
      }

      //motor holder
      translate([0, axis_pos, 0]) mirror([0,invert_motor_flag,0]) {
        //mount plate
        translate([second_bearing_pos + lwall + bearing_width,
                   motor_shaft_pos,
                   motor_shaft_h])
          rotate([0,-90,0]) rotate([0,0,90])
            motor_mount(screw_w=motor_screw_wall,
                        r=motor_mount_inner_r,
                        wall=motor_mount_width,
                        screw_mount=motor_screw_mount,
                        screw_r=motor_screw_r);
        //base
        translate([second_bearing_pos + lwall + bearing_width, 0, 0])
          mirror([1,0,0]) cube([motor_mount_width, motor_holder_size_from_axis,
                                motor_holder_size_from_base +ST]);
        //inter bearing reinforcement
        translate([first_bearing_pos, motor_pos, axis_h - lwall/2])
          mirror([0,1,0])
          cube([second_bearing_pos - first_bearing_pos + lwall +bearing_width,
                wall, lwall]);

        //diagonal reinforcement
        translate([ST, flat_bottom_bearing_width/2, 0])
          rotate([0,0,angle_diagonal])
            cube([wall,
                  (motor_holder_size_from_axis - flat_bottom_bearing_width/2)/
                    cos(angle_diagonal),
                  motor_holder_size_from_base]);

        //diagonal reinforcement in the mount plate plane
        translate([second_bearing_pos +bearing_width + lwall - wall,
                   -bearing_r - wall,
                   axis_h - ST])
          rotate([mount_plante_diagonal_angle,0,0])
          cube([wall, wall,
                (motor_holder_top - axis_h)/cos(mount_plante_diagonal_angle)]);
      }

      //flat bottom
      translate([0, axis_pos - wall - base_screw_r, 0])
        cube([second_bearing_pos + lwall + bearing_width,
              2*(wall + base_screw_r),
              wall]);
      translate([0, axis_pos - flat_bottom_bearing_width/2, 0])
        cube([first_bearing_pos + wall + 2*bearing_width,
              flat_bottom_bearing_width,
              wall]);

      //pressure screw wall
      translate([-hotend_body_r, 0,0])
        cube([2*hotend_body_r, axis_pos + bearing_access_r + wall,
              hotend_body_above_groove_h]);
      translate([wall_support_pos[0],
                 wall_support_pos[1] - lwall - idler_holder_screw_r,
                 0])
        cube([first_bearing_pos + bearing_width - wall_support_pos[0],
              2*(idler_holder_screw_r + lwall),
              hotend_body_above_groove_h +idler_pressure_screw_z_pos +
                idler_pressure_screw_r + idler_holder_screw_nut_h]);
      translate([wall_support_pos[0], wall_support_pos[1], wall_support_pos[2]])
        cylinder(r=idler_holder_screw_r + lwall,
                 h=hotend_body_above_groove_h +idler_pressure_screw_z_pos +
                   idler_pressure_screw_r + idler_holder_screw_nut_h);


      //idler holding screws
      translate([0,
                 -hotend_body_r - idler_holder_screw_head_r -lwall,
                 hotend_body_above_groove_h/2])
        cube([2*(idler_holder_screw_r + lwall) + idler_width +
                2*idler_holder_screw_r,
              2*(idler_holder_screw_r + wall),
              hotend_body_above_groove_h], center=true);
    }
    #extruder_base_screws(
      wall=STRUCTURAL_WALL_WIDTH,
      lwall=lwall,
      base_screw_r=base_screw_r,
      base_screw_nut_r=base_screw_nut_r,
      screw_hotend_distance=screw_hotend_distance,
      hotend_body_r=hotend_body_r
    );

    //hotend
    translate([0,0,-ST])
      #cylinder(r=hotend_body_r, h=max(hotend_body_above_groove_h, wall) +2*ST);

    //hobbed bolt bearing
    translate([hotend_body_r, axis_pos, axis_h])
      rotate([0,-90,0])
        #cylinder(r=hobbed_bolt_r, h=2*hotend_body_r);

    //bearings for the hobbed bolt
    translate([first_bearing_pos, axis_pos, axis_h]) 
      rotate([0,90,0])
        #cylinder(r=bearing_r,
                  h=2*bearing_width);
    //first bearing holding screw
    translate([first_bearing_pos - lwall -1, axis_pos, axis_h]) 
      rotate([0,90,0]) rotate([0,0,fist_bearing_screw_angular_pos]) {
          translate([0, bearing_r + bearing_screw_r + ST, 0])
        #cylinder(r=bearing_screw_r,
                  h=bearing_width + lwall +2);
    }

    //second bearing for the hobbed bolt
    translate([second_bearing_pos +lwall, axis_pos, axis_h]) 
      rotate([0,90,0])
        #cylinder(r=bearing_r,
                  h=2*bearing_width);
    translate([second_bearing_pos -1, axis_pos, axis_h]) 
      rotate([0,90,0])
    {
        for(a=[90]) rotate([0,0,a])
          translate([0, bearing_r + bearing_screw_r + ST, 0])
        #cylinder(r=bearing_screw_r,
                  h=bearing_width + lwall +2);
    }


    //bearing access for the hobbed bolt
    translate([-wall-hotend_body_r, axis_pos, axis_h]) 
      rotate([0,90,0])
        #cylinder(r=bearing_access_r,
                  h=second_bearing_pos + wall+bearing_width +lwall + hotend_body_r);
 
    //no part can be below z=0
    translate([0, -bearing_r - wall, -ST])
      mirror([0,0,1])
        #cube([second_bearing_pos + 2*(bearing_width + lwall) +2*ST,
               2*(bearing_r + wall),
               bearing_r + wall]);

    //idler holding screws
    translate([-idler_width/2 - idler_holder_screw_r,
               -hotend_body_r - idler_holder_screw_head_r -lwall,
               idler_holder_screw_head_room_h + hsupport])
      #cylinder(r=idler_holder_screw_r,
               h=hotend_body_above_groove_h +1);
    translate([-idler_width/2 - idler_holder_screw_r,
               -hotend_body_r - idler_holder_screw_head_r -lwall,
               -1])
      #cylinder(r=idler_holder_screw_head_r,
               h=idler_holder_screw_head_room_h +1);
    translate([idler_width/2 + idler_holder_screw_r,
               -hotend_body_r - idler_holder_screw_head_r -lwall,
               idler_holder_screw_head_room_h + hsupport])
      #cylinder(r=idler_holder_screw_r,
               h=hotend_body_above_groove_h + 1);
    translate([idler_width/2 + idler_holder_screw_r,
               -hotend_body_r - idler_holder_screw_head_r -lwall,
               -1])
      #cylinder(r=idler_holder_screw_head_r,
               h=idler_holder_screw_head_room_h +1);

    //wall reinforcement
    translate([wall_support_pos[0], wall_support_pos[1],-1])
      #cylinder(r=idler_holder_screw_head_r,
                h=idler_holder_screw_head_room_h +1);
    translate([wall_support_pos[0], wall_support_pos[1],
               idler_holder_screw_head_room_h + hsupport])
      #cylinder(r=idler_holder_screw_r,
                h=idler_pressure_screw_z_pos + 2*idler_holder_screw_nut_r +
                  lwall);
    translate([wall_support_pos[0], wall_support_pos[1],
               hotend_body_above_groove_h + idler_pressure_screw_z_pos +
                 idler_pressure_screw_r])
      #cylinder(r=idler_holder_screw_nut_r,
                h=idler_holder_screw_nut_h + ST,
                $fn=6);

    //pressure screw
    translate([idler_pressure_screw_x_pos, 0,
               hotend_body_above_groove_h + idler_pressure_screw_z_pos])
      rotate([-90,0,0])
        #cylinder(r=1.6, h=30);
  }
}

module extruder_with_support(
  wall=STRUCTURAL_WALL_WIDTH,
  lwall=WALL_WIDTH,
  hsupport=HORIZONTAL_SUPPORT_WALL,
  vsupport=VERTICAL_SUPPORT_WALL,
  base_screw_r=BASE_SCREWS_DIAMETER/2,
  base_screw_nut_r=BASE_SCREWS_NUT_WIDTH/(2*cos(30)),
  screw_hotend_distance=BASE_SCREW_HOTEND_DISTANCE,
  hotend_body_r=HOTEND_BODY_DIAMETER/2,
  hotend_body_above_groove_h=HOTEND_BODY_ABOVE_GROOVE_H,
  bearing_r=BEARING_DIAMETER/2,
  bearing_access_r=BEARING_ACCESS_HOLE_DIAMETER/2,
  bearing_width=BEARING_WIDTH,
  bearing_screw_r=BEARING_SCREW_DIAMETER/2,
  hobbed_bolt_r=HOBBED_BOLT_DIAMETER/2,
  filament_r=FILAMENT_APROX_DIAMETER/2,
  idler_width=IDLER_W,
  idler_holder_screw_r=IDLER_HOLDER_SCREW_DIAMETER/2,
  idler_holder_screw_head_r=IDLER_HOLDER_SCREW_HEAD_DIAMETER/2,
  idler_holder_screw_head_room_h=IDLER_HOLDER_SCREW_HEAD_ROOM_H,
  idler_holder_screw_nut_r=IDLER_HOLDER_SCREW_NUT_WIDTH/(2*cos(30)),
  idler_holder_screw_nut_h=IDLER_HOLDER_SCREW_NUT_H,
  idler_pressure_screw_r=IDLER_PRESSURE_SCREW_DIAMETER/2,
  idler_pressure_screw_z_pos=IDLER_PRESSURE_SCREW_Z_POS,
  idler_pressure_screw_x_pos=IDLER_PRESSURE_SCREW_Y_POS,
  gears_shafts_distance=GEAR_SHAFTS_DISTANCE,
  second_bearing_pos=SECOND_BEARING_POS,
  motor_screw_r=MOTOR_SCREW_DIAMETER/2,
  motor_screw_mount=MOTOR_SCREW_MOUNT,
  motor_screw_wall=MOTOR_SCREW_WALL,
  motor_mount_width=MOTOR_MOUNT_WIDTH,
  motor_mount_inner_r=MOTOR_HOLDER_INNER_DIAMETER/2,
  motor_shaft_h=MOTOR_SHAFT_H,
  motor_shaft_pos=MOTOR_SHAFT_POS,
  motor_size=MOTOR_SIZE,
  fist_bearing_screw_angular_pos=FIST_BEARING_SCREW_ANGLE,
  invert_motor=INVERT_MOTOR_SIDE,
  angle=ANGLE
) {
  axis_pos=filament_r + hobbed_bolt_r;
  axis_h = hotend_body_above_groove_h + hobbed_bolt_r;

  first_bearing_pos = screw_hotend_distance - base_screw_nut_r*cos(30) -
bearing_width +ST;

  union() {
    extruder(
      wall=wall,
      lwall=lwall,
      hsupport=hsupport,
      vsupport=vsupport,
      base_screw_r=base_screw_r,
      base_screw_nut_r=base_screw_nut_r,
      screw_hotend_distance=screw_hotend_distance,
      hotend_body_r=hotend_body_r,
      hotend_body_above_groove_h=hotend_body_above_groove_h,
      bearing_r=bearing_r,
      bearing_access_r=bearing_access_r,
      bearing_width=bearing_width,
      bearing_screw_r=bearing_screw_r,
      hobbed_bolt_r=hobbed_bolt_r,
      filament_r=filament_r,
      idler_width=idler_width,
      idler_holder_screw_r=idler_holder_screw_r,
      idler_holder_screw_head_r=idler_holder_screw_head_r,
      idler_holder_screw_head_room_h=idler_holder_screw_head_room_h,
      idler_holder_screw_nut_r=idler_holder_screw_nut_r,
      idler_holder_screw_nut_h=idler_holder_screw_nut_h,
      idler_pressure_screw_r=idler_pressure_screw_r,
      idler_pressure_screw_z_pos=idler_pressure_screw_z_pos,
      idler_pressure_screw_x_pos=idler_pressure_screw_x_pos,
      gears_shafts_distance=gears_shafts_distance,
      second_bearing_pos=second_bearing_pos,
      motor_screw_r=motor_screw_r,
      motor_screw_mount=motor_screw_mount,
      motor_screw_wall=motor_screw_wall,
      motor_mount_width=motor_mount_width,
      motor_mount_inner_r=motor_mount_inner_r,
      motor_shaft_h=motor_shaft_h,
      motor_shaft_pos=motor_shaft_pos,
      motor_size=motor_size,
      fist_bearing_screw_angular_pos=fist_bearing_screw_angular_pos,
      invert_motor=invert_motor,
      angle=angle
    );

    //first bearing
    translate([first_bearing_pos - lwall, axis_pos, axis_h + ST])
      rotate([0,90,0])
        cylinder(r=bearing_access_r, h=vsupport);
    translate([first_bearing_pos, axis_pos, axis_h + ST])
      rotate([0,-90,0])
        cylinder(r=bearing_access_r, h=vsupport);
    translate([first_bearing_pos + bearing_width, axis_pos, axis_h + ST])
      rotate([0,-90,0])
        cylinder(r=bearing_r, h=vsupport);

    //second bearing
    translate([second_bearing_pos, axis_pos, axis_h + ST])
      rotate([0,90,0])
        cylinder(r=bearing_access_r, h=vsupport);
    translate([second_bearing_pos + lwall, axis_pos, axis_h + ST])
      rotate([0,-90,0])
        cylinder(r=bearing_access_r, h=vsupport);
    translate([second_bearing_pos + bearing_width +lwall, axis_pos, axis_h + ST])
      rotate([0,-90,0])
        cylinder(r=bearing_r, h=vsupport);
  }
}

module motor_mount(r=14, screw_mount=26, wall=5, screw_r=1.7, screw_w=2) {
  w = screw_mount + 2*screw_r + 2*screw_w;
  difference() {
    union() {
      translate([-w/2, -w/2, 0])
      cube([w,w, wall]);
    }
    for(a=[45,135,225,315]) rotate([0,0,a]) {
      translate([screw_mount/sqrt(2), 0, -1])
        #cylinder(r=screw_r, h=wall +2);
    }
    translate([0,0,-1])
      #cylinder(r=r, h=wall+2);
  }
}


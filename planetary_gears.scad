//Based on Emmet's Differential planetary drive
//http://www.thingiverse.com/emmett

// Modified by Igor Soares
// http://www.thingiverse.com/igorbpsoares

use <write/Write.scad>
use <MCAD/involute_gears.scad>

//assembly();
//choose(export);
//plate();

//joined_planets_upper_sun_plate();

//upper_planets_sun_plate();
//lower_planets_sun_plate();
//housing();
//sun_with_coupler();

ring_with_supports();

//planet_assembly_plate();


// choose the object to render
export=0;// [0:Input,1:Output]
// outer diameter of ring
D=36;
// thickness
T=4;
// upper thickness
UT=7;
// clearance between gear teeth
tol=0.10;
// vertical clearance
vtol=0.5;
number_of_planets=4;
number_of_teeth_on_planets=6;
approximate_number_of_teeth_on_sun=10;
// difference in teeth on ring gears
delta=2;
// number of teeth to twist across
nTwist=0.4;
// pressure angle
P=30;
// width of hexagonal hole
w=5.4;

//very small value to avoid overlapping features
ST = 0.001;

//use emmett gears or involute gears
use_mcad_gears = false;

DR=2/PI;// maximum depth ratio of teeth

support_vertical_wall = 0.5;
support_horizontal_wall = 0.4; //bridge

m=round(number_of_planets);
np=round(number_of_teeth_on_planets);
nsa=approximate_number_of_teeth_on_sun;
ka=round(2/m*(nsa+np));
k= ka*m%2!=0 ? ka+1 : ka;
ns=k*m/2-np;
echo(ns);
nr=ns+2*np;
nr2=nr+delta;
np2=np+delta;
ns2=ns-delta;
pitchD=0.9*D/(1+depth_diameter(nr,P,DR));
pitch=pitchD*PI/nr;
echo(pitch);
helix_angle=atan(2*nTwist*pitch/UT);
echo(helix_angle);

planets_vertical_spacing = 1;
planet_screw_diameter = 3.6;
planet_screw_head_diameter = 5.4;
planet_screw_head_room = 2;
planet_screw_nut_width = 6.7;
planet_screw_nut_h = 3;

upper_sun_screw_diameter = 3.7;
upper_sun_screw_head_diameter = 6.0;
upper_sun_screw_head_room = 0.02;
upper_sun_screw_nut_width = 5.8;
upper_sun_screw_nut_h = 0.02;
upper_sun_halves_clearence = 1;

input_shaft_diameter = 5.7;
input_coupler_h=10;
input_coupler_minor_diameter=11.5;
input_coupler_diameter=22;
input_coupler_screw_diameter = 3.6;
input_coupler_nut_width = 5.8;
input_coupler_nut_h = 2.6;
input_coupler_nut_pos = 0.5;

screw_mount_distance = 31;
screw_mount_width = 8;
screw_mount_h = 4;
screw_mount_wall = 4;
screw_diameter = 3.6;

output_ring_wall_width = 3.0;
output_ring_clearance = 1;
output_ring_inner_diameter = 15.4;

output_ring_screw_diameter = 3.4;
output_ring_screw_head_diameter = 6.0;
output_ring_screw_h = 5.0;
output_ring_screw_nut_width = 6.0;
output_ring_screw_nut_h = 1.0;
output_ring_support_walls_distance = 4;

phi=$t*360;
R1=(1+nr/ns);// sun to planet-carrier ratio
R2=-nr2*np/(ns+np)/delta;// planet-carrier to ring ratio
R=R1*R2;
//R_NUM = (ns +nr)*(-nr2*np);
//R_DENOM = ns*(ns+np)*delta;
echo(R);

module choose(i){
if(i==0) planetary();
else ring();
}

module lower_planets_sun_plate() {
  pwidth = 2.2*outerR(np, pitch, P, tol, DR);
  swidth = 2.2*outerR(ns, pitch, P, tol, DR);
  for(i=[1:m]) translate([pwidth*(-m/2 -0.5 +i), 0,0])
    lower_planet(i-1, render_number=true);
  translate([0, (pwidth + swidth)/2, 0])
    sun();
}

module upper_planets_sun_plate() {
  pwidth = 2.2*outerR(np2, pitch, P, tol, DR);
  swidth = 2.2*outerR(ns2, pitch, P, tol, DR);
  for(i=[1:m]) translate([pwidth*(-m/2 -0.5 +i), 0,0])
    upper_planet(i-1, render_number=true);
  translate([-0.6*swidth, (pwidth + swidth)/2, 0])
    upper_sun_upper_half();
  translate([0.6*swidth, (pwidth + swidth)/2, 0])
    upper_sun_lower_half();
}

module joined_planets_upper_sun_plate() {
  pwidth = 2.5*outerR(np2, pitch, P, tol, DR);
  swidth = 2.5*outerR(ns2, pitch, P, tol, DR);
  for(i=[1:m]) translate([pwidth*(-m/2 -0.5 +i), 0,0])
    planet_both(i-1, render_number=true);
  translate([-0.6*swidth, (pwidth + swidth)/2, 0])
    upper_sun_upper_half();
  translate([0.6*swidth, (pwidth + swidth)/2, 0])
    upper_sun_lower_half();
}

module plate(){
translate([D+1,0,0])planetary();
translate([-D-1,0,0])ring();
}

module assembly(){
planetary();
translate([0,0,T+ UT + 3*vtol])rotate([180,0,phi/R2-turn(nr2,pitch,helix_angle,vtol)])render()ring();
}

module ring_with_supports() {
  union() {
  translate([0,0,UT + output_ring_clearance + output_ring_screw_h +
                    output_ring_screw_head_diameter/2])
    rotate([180,0,0])
      ring();
    difference() {
      cylinder(r=D/2*nr2/nr, h=output_ring_screw_head_diameter + ST, $fn=32);
      translate([0,0,-1])
      cylinder(r=D/2*nr2/nr - support_vertical_wall,
               h=output_ring_screw_head_diameter + ST +2, $fn=32);
    }
    difference() {
      cylinder(r=D/2*nr2/nr - output_ring_support_walls_distance,
               h=output_ring_screw_head_diameter + ST,
               $fn=32);
      translate([0,0,-1])
      cylinder(r=D/2*nr2/nr - support_vertical_wall -
                  output_ring_support_walls_distance,
               h=output_ring_screw_head_diameter + ST +2,
               $fn=32);
    }
    //translate([0,0,output_ring_screw_head_diameter-output_ring_wall_width]) {
    //  cylinder(r=D/2*nr2/nr, h=support_horizontal_wall);

    //}
  }
}

module ring()
difference(){
	union(){
		difference(){
			cylinder(r=D/2*nr2/nr,h=UT,$fn=100);
			translate([0,0,UT/2])
                                herringbone(nr2,pitch,P,DR,-tol,helix_angle,
                                             UT+ST);
		}
                //hack to create some clearance space without removing
                //support for the teeth above
		translate([0,0,UT-ST]) difference(){
			cylinder(r=D/2*nr2/nr,h=UT,$fn=100);
			translate([0,0,UT/2])
                                herringbone(nr2,pitch,P,DR,-tol,
                                             helix_angle, UT+2*ST);
                        translate([0,0,output_ring_clearance + 2*ST])
                                cylinder(r=D*nr2/nr +ST, h=UT);
		}
               translate([0,0,
                          UT+output_ring_clearance +output_ring_screw_h +
                             output_ring_screw_head_diameter/2])
                    mirror([0,0,1])
                      difference()
               {
                    translate([0,0,-ST]) #cylinder(
                            r=(output_ring_inner_diameter +
                              output_ring_wall_width)/2,
                            h=output_ring_screw_head_diameter,
                            $fn=100);
                    translate([0,0,-ST-1]) cylinder(
                            r=output_ring_inner_diameter/2,
                            h=output_ring_screw_head_diameter +2,
                            $fn=100);
                }
                translate([0,0, UT + output_ring_clearance])
                difference() {
                        cylinder(r=D/2*nr2/nr, h=output_ring_wall_width,$fn=100);
                        translate([0,0,-1])
                                cylinder(r=output_ring_inner_diameter/2,
                                         h=output_ring_wall_width +2, $fn=100);
                }
                for(a=[0,120,240])
                        translate([0,0,UT + output_ring_clearance +
                                       output_ring_screw_h])
                        rotate([0,0,a]) rotate([90,0,0])
                        translate([0,0,-output_ring_inner_diameter/2 -
                                       (output_ring_screw_nut_h +
                                       output_ring_wall_width)/2])
                                cube([output_ring_screw_nut_width/cos(30) +
                                        2*output_ring_wall_width,
                                      output_ring_screw_head_diameter,
                                      (output_ring_screw_nut_h +
                                       output_ring_wall_width)],
                                      center=true);
	}
        for(a=[0,120,240])
                translate([0,0,UT + output_ring_clearance +
                               output_ring_screw_h])
                rotate([0,0,a]) rotate([90,0,0])
                union()
        {
                translate([0,0,-output_ring_inner_diameter/2 -
                               output_ring_screw_nut_h])
                        #cylinder(r=output_ring_screw_nut_width/(2*cos(30)),
                                  h=output_ring_inner_diameter/2,
                                  $fn=6);
                translate([0,0,-D/2])
                        #cylinder(r=output_ring_screw_diameter/2,
                                  h=D/2,
                                  $fn=64);
                translate([-output_ring_screw_head_diameter/2,
                           -output_ring_screw_head_diameter/2 - ST/2,
                           -output_ring_inner_diameter/2 -
                               output_ring_screw_nut_h -
                               output_ring_wall_width - ST])
                        mirror([0,0,1])
                        #cube([output_ring_screw_head_diameter,
                               output_ring_screw_head_diameter +ST,
                                  D/2]);
        }

        //for(a=[0,120,240])
        //     rotate([0,0,a+60]) translate([0,pitchD/2*(ns+np)/nr,UT-ST])
        //        rotate([0,0,30])
        //         #cylinder(r=1.1*planet_screw_head_diameter/(2*cos(30)),
        //                   h=output_ring_screw_head_diameter +
        //                         output_ring_wall_width +2, $fn=6);
}

module housing() {
    union() {
	translate([0,0,T/2-ST]) difference(){
		cylinder(r=D/2,h=T,center=true,$fn=100);
		spur_gear_wrapper(nr,pitch,P,DR,-tol,helix_angle,T+3);
		difference(){
			union(){
				rotate([0,0,180])translate([0,-D/2,0])rotate([90,0,0])
monogram(h=10);
                                translate([0,0,0])
//				writecylinder(text=str(R_NUM,"/",R_DENOM),
//                                        radius=D/2,h=5*T/8,
//                                        t=2,
//					font="write/Letters.dxf");
				writecylinder(text=str(R),
                                        radius=D/2,h=5*T/8,
                                        t=2,
					font="write/Letters.dxf");
			}
			cylinder(r=D/2-0.25,h=T+2,center=true,$fn=100);
		}
	}
        mount_plate(diameter=D, support_h=screw_mount_wall);
    }
}

module mount_plate(diameter=30, support_h=7) {
  platew = screw_mount_distance + 2*screw_mount_wall + screw_diameter;
  difference() {
    for(a=[45,135,225]) rotate([0,0,a]) {
      difference() {
        union() {
          translate([0, -screw_mount_width/2, 0])
            cube([screw_mount_distance/(2*cos(45)), screw_mount_width,
                  support_h]);
          translate([screw_mount_distance/(2*cos(45)), 0, 0])
            cylinder(r=screw_mount_width/2, h=support_h);
        }
        translate([0,0,screw_mount_h]) union() {
          translate([0, -screw_mount_width/2 + vertical_support_wall, 0])
            cube([screw_mount_distance/(2*cos(45)),
                  screw_mount_width - 2*vertical_support_wall,
                  support_h+1]);
          translate([screw_mount_distance/(2*cos(45)), 0, 0])
            cylinder(r=screw_mount_width/2 - vertical_support_wall, 
                     h=support_h+1);
        }
        translate([screw_mount_distance/(2*cos(45)), 0, -1])
          #cylinder(r=screw_diameter/2,
                    h=screw_mount_h + 2,
                    $fn=16);
      }
    }
    translate([0,0,-1])
      cylinder(r=diameter/2 - ST, h=support_h +2, $fn=64);
  }
}

module lower_half_housing() {
        intersection() {
                translate([0,0,-1])
                        cylinder(r=D/2 +1, h=T/2+1);
                translate([0,0,T/2])
                        housing();
        }
}

module upper_half_housing() {
        intersection() {
                cylinder(r=D/2 +1, h=T/2+1);
                housing();
        }
}

module sun() {
	translate([0,0,T/2]) difference(){
		mirror([0,1,0])
			spur_gear_wrapper(ns,pitch,P,DR,tol,helix_angle,T);
		translate([0,0,-1])cylinder(r=w/2,h=T,center=true,$fn=6);
	}
}

module sun_with_coupler() {
  translate([0,0,input_coupler_h]) difference() {
    union() {
      translate([0,0,T + ST]) intersection() {
        mirror([0,0,1]) translate([0,0,T/2 -ST])
          sun(NP=np, NS=ns);
        translate([0,0, - input_coupler_h])
          cylinder(r2=outerR(ns,pitch,P,tol,DR),
                   r1=input_coupler_diameter/2,
                   h=input_coupler_h/2 + ST);
      }
      mirror([0,0,1]) translate([0,0,-ST]) {
        cylinder(r1=input_coupler_minor_diameter/2,
                 r2=input_coupler_diameter/2,
                 h=(input_coupler_diameter-input_coupler_minor_diameter)/2,
                 $fn=64);
      }
      translate([0,0,-input_coupler_h]) {
        cylinder(r=input_coupler_diameter/2,
                 h=input_coupler_h + ST -
                    (input_coupler_diameter-input_coupler_minor_diameter)/2,
                 $fn=64);

      }
      sun();
    }
    translate([0,0,-input_coupler_h -ST])
      #cylinder(r=input_shaft_diameter/2, h=input_coupler_h + T + 3*ST, $fn=64);

    translate([-input_coupler_nut_width/2,
               input_shaft_diameter/2 + input_coupler_nut_pos,
               -input_coupler_h -ST])
      #cube([input_coupler_nut_width, input_coupler_nut_h,
             input_coupler_nut_width/cos(30) + ST]);
    translate([0,0,-input_coupler_h + input_coupler_nut_width/2 -ST])
      rotate([-90, 0,0])
        #cylinder(r=input_coupler_screw_diameter/(2*cos(30)),
                 h=input_coupler_diameter/2,
                 $fn=6);
  }
}

module upper_sun() {
	translate([0,0,UT/2]) difference(){
		mirror([0,1,0])
			herringbone(ns2,pitch,P,DR,tol,helix_angle,UT);
		#cylinder(r=upper_sun_screw_diameter/2,
                                            h=UT + 2,
                                            center=true,
                                            $fn=64);
	}
}

module upper_sun_upper_half() {
  translate([0,0,-UT/2]) difference() {
    upper_sun();
    translate([0,0,UT-upper_sun_halves_clearence/2]) difference() {
      cylinder(r=outerR(np2,pitch,P,tol,DR) ,
               h=upper_sun_halves_clearence/2 + ST,
               $fn=64);
      translate([0,0,-1])
        cylinder(r=innerR(np2,pitch,P,tol,DR) ,
                 h=upper_sun_halves_clearence/2 + 2,
                 $fn=64);
    }
    translate([0,0,-1])
      cylinder(r=D/2, UT/2 +1);
    translate([0,0,UT - upper_sun_screw_head_room])
      #cylinder(r=upper_sun_screw_head_diameter/2,
                h=upper_sun_screw_head_room+1, $fn=64);
  }
}

module upper_sun_lower_half() {
  translate([0,0,UT/2]) rotate([180,0,0]) difference() {
    upper_sun();
    translate([0,0,-ST]) difference() {
      cylinder(r=outerR(np2,pitch,P,tol,DR) ,
                h=upper_sun_halves_clearence/2,
                $fn=64);
      translate([0,0,-1])
        cylinder(r=innerR(np2,pitch,P,tol,DR),
                 h=upper_sun_halves_clearence/2 + 2,
                 $fn=64);
    }
    translate([0,0,UT/2])
      cylinder(r=D/2, UT/2 +1);
    translate([0,0,-1])
      #cylinder(r=upper_sun_screw_nut_width/(2*cos(30)),
                h=upper_sun_screw_nut_h +1, $fn=6);
  }
}

module planet_assembly_plate() {
  widthp = 1.2*pitchD*nr2/nr;
  widthi = pitchD*ns2/nr;
   translate([0,0,UT+ST + 1.5*planets_vertical_spacing ]) rotate([180,0,0])difference() {
    translate([0,0,UT + ST]) {
      difference() {
        cylinder(r=widthp/2, h=1.5);
        //translate([0,0,-ST])
        //cylinder(r=widthi/2, h=1.5*planets_vertical_spacing + 2*ST);
      }
    }
    union() {
      for(i=[1:m])rotate([0,0,i*360/m+phi])translate([pitchD/2*(ns+np)/nr,0,0]){
        scale([1.2,
               1.2, 1]) union() {
          #translate([0,0,0.79*T]) lower_planet(i);
          #cylinder(r=planet_screw_diameter/2 + ST,
                    h=UT +1.5*planets_vertical_spacing + 2*ST,
                    $fn=100);
          translate([-pitchD/4*(ns+np)/nr,0,UT+ST + 1.5*planets_vertical_spacing
-3])
             #writecube(text=str(i), where=[0,0,0], face="top",
                           h=1.4*innerR(np2,pitch,P,tol,DR),
                           t=4*support_horizontal_wall,
                           font="write/Letters.dxf");
          //mirror([1,0,0]) translate([0, -planet_screw_diameter/2, UT-ST])
          //#cube([widthp/2, planet_screw_diameter,
          //       1.5*planets_vertical_spacing + 4*ST]);
        }
      }
    }
  }
}

module upper_planet(i=0, render_number=false) {
translate([0,0,T +UT + planets_vertical_spacing]) rotate([180,0,0])
  planet(i,render_upper=true, render_lower=false, render_number=render_number);
}

module lower_planet(i=0, render_number=false) {
  planet(i,render_upper=false, render_lower=true, render_number=render_number);
}

module planet_both(i=0, render_number=false) {
  difference() {
    union() {
      planet(i=i, render_number=render_number, render_spacing=false,
             render_holes=false);
      translate([0,0,T + planets_vertical_spacing + ST]) intersection() {
        rotate([0,0,
                -phi*(ns+np)/np-phi + 360/np2*nTwist -i*nr2/m*360/np2 +
                + nTwist*360
        ])
          mirror([0,0,1])
            emmett_gear(np2,pitch,P,DR,tol,helix_angle,UT/2);
        mirror([0,0,1]) cylinder(r1=outerR(np2,pitch,P,tol,DR),
                                 r2=outerR(np,pitch,P,tol,DR),
                                 h=planets_vertical_spacing+2*ST);
      }

      translate([0,0,T])
        cylinder(r=innerR(np,pitch,P,tol,DR),
                 h=planets_vertical_spacing/2+ 2*ST,
                 $fn=32);
      difference() {
        cylinder(r=outerR(np,pitch,P,tol,DR) + 3*support_vertical_wall,
                 h=T + ST);
        translate([0,0,-1])
        cylinder(r=outerR(np,pitch,P,tol,DR) + 2*support_vertical_wall,
                 h=T+ 1 - support_horizontal_wall);
      }
    }
    translate([0,0,T+UT+ planets_vertical_spacing - 0*support_horizontal_wall])
    #writecube(text=str(i+1), where=[0,0,0], face="top",
                  h=1.4*innerR(np2,pitch,P,tol,DR),
                  t=4*support_horizontal_wall,
                  font="write/Letters.dxf");
    //#writecube(text=str(i+1), where=[0,0,0], face="top",
    //              h=1.4*innerR(np,pitch,P,tol,DR),
    //              t=4*support_horizontal_wall,
    //              font="write/Letters.dxf");
  }
}

module planet(i=0, render_lower=true, render_upper=true, render_number=false,
              render_spacing=true, render_holes=true)
{
  difference() {
    union() {
	translate([0,0,T/2]) rotate([0,0,-phi*(ns+np)/np-phi]){
		if (render_lower) difference(){
			rotate([0,0,i*ns/m*360/np])
                                spur_gear_wrapper(np,pitch,P,DR,tol,helix_angle,T);
			translate([0,0,-D/2-T/2])cube(D,center=true);
		}
                translate([0,0,T/2-ST]) union() {
                        if (render_lower && render_spacing) {
                          pattern_planet(i=i, positive=false,
                                         render_number=render_number);
                        }
                        if (render_upper && render_spacing) {
                          pattern_planet(i=i, positive=true,
                                         render_number=render_number);
                        }
                }
		if (render_upper) rotate([0,0,-i*nr2/m*360/np2])
                        translate([0,0,T/2 + UT/2 + planets_vertical_spacing])
			herringbone(np2,pitch,P,DR,tol,helix_angle,UT);
	}
    }
    if(render_holes)
    translate([0,0,planet_screw_nut_h + support_horizontal_wall])
      #cylinder(r=planet_screw_diameter/2,
               h=T + UT + planets_vertical_spacing - 2*support_horizontal_wall-
                  (planet_screw_head_room + planet_screw_nut_h),
               $fn=32);
    if(render_holes)
    translate([0,0,-1])
      cylinder(r=planet_screw_nut_width/(2*cos(30)),
               h=planet_screw_nut_h +1,
               $fn=6);
    if(render_holes)
    translate([0,0,T+UT+planets_vertical_spacing - planet_screw_head_room])
      cylinder(r=planet_screw_head_diameter/2,
               h=planet_screw_head_room +1,
               $fn=64);
  }
}

module pattern_planet(i=0, positive=false, render_number=false) {
  if (!positive) {
    intersection() {
      pattern_cylinder(i=i, render_number=render_number);
      pattern_pos();
    }
  } else {
    difference() {
      pattern_cylinder(i=i, render_number=render_number);
      pattern_pos();
    }
  }
}

module pattern_cylinder(i=0, render_number=false) {
  difference() {
    cylinder(r=innerR(np2,pitch,P,tol,DR),
             h=planets_vertical_spacing+ 2*ST,
             $fn=32);
    if(render_number) {
      for (a=[0,90,180,270]) {
        translate([0,0,planets_vertical_spacing/2]) rotate([0,0,40+a])
          #writecylinder(text=str(i+1),radius=innerR(np2,pitch,P,tol,DR),
                        h=planets_vertical_spacing,
                        t=innerR(np2,pitch,P,tol,DR) - planet_screw_diameter/2,
                        font="write/Letters.dxf");
      }
    }
  }
}

module pattern_pos() {
      translate([0,0,0.5*planets_vertical_spacing]) union(){
        translate([0,D/2,0])
            cube(D, center=true);
      }
}

module planetary()
translate([0,0,T/2]){
        housing();
	rotate([0,0,(np+1)*180/ns+phi*R1])
	sun();
	rotate([0,0,(np2-0.5)*180/ns+phi*R1]) translate([0,0,
T+planets_vertical_spacing])
                upper_sun();
	for(i=[1:m])rotate([0,0,i*360/m+phi])translate([pitchD/2*(ns+np)/nr,0,0])
                planet(i);
}

module monogram(h=1)
linear_extrude(height=h,center=true)
translate(-[3,2.5])union(){
	difference(){
		square([4,5]);
		translate([1,1])square([2,3]);
	}
	square([6,1]);
	translate([0,2])square([2,1]);
}

module spur_gear_wrapper(
	number_of_teeth=15,
	circular_pitch=10,
	pressure_angle=20,
	depth_ratio=2/PI,
	clearance=0,
	helix_angle=0,
	gear_thickness=5){
                translate([0,0,-gear_thickness/2])
                gear(
                        number_of_teeth=number_of_teeth,
                        circular_pitch=(180/PI)*circular_pitch,
                        pressure_angle=pressure_angle,
                        depth_ratio=depth_ratio,
                        clearance=clearance,
                        backlash=2*clearance,
                        helix_angle=helix_angle,
                        rim_thickness=gear_thickness + ST,
                        bore_diameter=0,
                        hub_thickness=gear_thickness + ST,
                        gear_thickness=gear_thickness + ST,
                        rim_width=0,
                        involute_facets=32,
                        twist=0);
}

module herringbone(
	number_of_teeth=15,
	circular_pitch=10,
	pressure_angle=20,
	depth_ratio=2/PI,
	clearance=0,
	helix_angle=0,
	gear_thickness=5){
        if (use_mcad_gears) {
            union() {
                translate([0,0,-gear_thickness/2])
                gear(
                        number_of_teeth=number_of_teeth,
                        circular_pitch=(180/PI)*circular_pitch,
                        pressure_angle=pressure_angle,
                        depth_ratio=depth_ratio,
                        clearance=clearance,
                        helix_angle=helix_angle,
                        rim_thickness=gear_thickness/2 + ST,
                        bore_diameter=0,
                        hub_thickness=gear_thickness/2 + ST,
                        gear_thickness=gear_thickness/2 + ST,
                        rim_width=0,
                        twist=helix_angle);
                translate([0,0,gear_thickness/2]) mirror([0,0,1])
                gear(
                        number_of_teeth=number_of_teeth,
                        circular_pitch=(180/PI)*circular_pitch,
                        pressure_angle=pressure_angle,
                        depth_ratio=depth_ratio,
                        clearance=clearance,
                        helix_angle=helix_angle,
                        rim_thickness=gear_thickness/2 + ST,
                        bore_diameter=0,
                        hub_thickness=gear_thickness/2 + ST,
                        gear_thickness=gear_thickness/2 + ST,
                        rim_width=0,
                        twist=helix_angle);
            }
        } else {
                emmett_herringbone(
                        number_of_teeth=number_of_teeth,
                        circular_pitch=circular_pitch,
                        pressure_angle=pressure_angle,
                        depth_ratio=depth_ratio,
                        clearance=clearance,
                        helix_angle=helix_angle,
                        gear_thickness=gear_thickness);
        }
}

module emmett_herringbone(
	number_of_teeth=15,
	circular_pitch=10,
	pressure_angle=20,
	depth_ratio=2/PI,
	clearance=0,
	helix_angle=0,
	gear_thickness=5){
union(){
	emmett_gear(number_of_teeth,
		circular_pitch,
		pressure_angle,
		depth_ratio,
		clearance,
		helix_angle,
		gear_thickness/2);
	mirror([0,0,1])
		emmett_gear(number_of_teeth,
			circular_pitch,
			pressure_angle,
			depth_ratio,
			clearance,
			helix_angle,
			gear_thickness/2);
}}

module gear_wrapper (
	number_of_teeth=15,
	circular_pitch=10,
	pressure_angle=20,
	depth_ratio=2/PI,
	clearance=0,
	helix_angle=0,
	gear_thickness=5,
	flat=false){
        emmett_gear (
                number_of_teeth=number_of_teeth,
                circular_pitch=circular_pitch,
                pressure_angle=pressure_angle,
                depth_ratio=depth_ratio,
                clearance=clearance,
                helix_angle=helix_angle,
                gear_thickness=gear_thickness,
                flat=flat);
}

module emmett_gear (
	number_of_teeth=15,
	circular_pitch=10,
	pressure_angle=20,
	depth_ratio=2/PI,
	clearance=0,
	helix_angle=0,
	gear_thickness=5,
	flat=false){
twist=turn(number_of_teeth,circular_pitch,helix_angle,gear_thickness);

flat_extrude(h=gear_thickness,twist=twist,flat=flat)
	emmett_gear2D (
		number_of_teeth,
		circular_pitch,
		pressure_angle,
		depth_ratio,
		clearance);
}

module flat_extrude(h,twist,flat){
	if(flat==false)
		linear_extrude(height=h,twist=twist,slices=twist/6)child(0);
	else
		child(0);
}

module emmett_gear2D (
	number_of_teeth,
	circular_pitch,
	pressure_angle,
	depth_ratio,
	clearance){
pitch_radius = pitchR(number_of_teeth,circular_pitch);
base_radius = pitch_radius*cos(pressure_angle);
depth = rackDepth(circular_pitch,pressure_angle);
max_radius = pitch_radius+depth/2+max(-clearance,0);
//outer_radius = pitch_radius+depth_ratio*circular_pitch/2-clearance/2;
outer_radius = outerR(number_of_teeth, circular_pitch, pressure_angle, clearance, depth_ratio);
//root_radius1 = pitch_radius-depth/2-clearance/2;
//root_radius = (clearance<0 && root_radius1<base_radius) ? base_radius : root_radius1;
//inner_radius = max(root_radius,pitch_radius-depth_ratio*circular_pitch/2-clearance/2);
inner_radius = innerR(number_of_teeth, circular_pitch, pressure_angle, clearance, depth_ratio);
min_radius = max(base_radius,inner_radius);
backlash_angle = clearance/(pitch_radius*cos(pressure_angle)) * 180 / PI;
pitch_point = involute (base_radius, involute_intersect_angle (base_radius, pitch_radius));
tip_angle = atan2(pitch_point[1], pitch_point[0]) + 90/number_of_teeth - backlash_angle/2;

intersection(){
	circle($fn=number_of_teeth*2,r=outer_radius);
	union(){
		rotate(90/number_of_teeth)
			circle($fn=number_of_teeth*2,r=inner_radius);
		for (i = [1:number_of_teeth])rotate(i*360/number_of_teeth){
			halftooth (
				base_radius,
				min_radius,
				max_radius,
				tip_angle);		
			mirror([0,1])halftooth (
				base_radius,
				min_radius,
				max_radius,
				tip_angle);
		}
	}
}}

module halftooth (
	base_radius,
	min_radius,
	max_radius,
	tip_angle){
index=[0,1,2,3,4,5];
start_angle = max(involute_intersect_angle (base_radius, min_radius)-5,0);
stop_angle = involute_intersect_angle (base_radius, max_radius);
angle=index*(stop_angle-start_angle)/index[len(index)-1];
p=[[0,0],
	involute(base_radius,angle[0]+start_angle),
	involute(base_radius,angle[1]+start_angle),
	involute(base_radius,angle[2]+start_angle),
	involute(base_radius,angle[3]+start_angle),
	involute(base_radius,angle[4]+start_angle),
	involute(base_radius,angle[5]+start_angle)];

difference(){
	rotate(-tip_angle)polygon(points=p);
	square(2*max_radius);
}}

// Mathematical Functions
//===============

// Finds the angle of the involute about the base radius at the given distance (radius) from it's center.
//source: http://www.mathhelpforum.com/math-help/geometry/136011-circle-involute-solving-y-any-given-x.html

function involute_intersect_angle (base_radius, radius) = sqrt (pow (radius/base_radius, 2) - 1) * 180 / PI;

// Calculate the involute position for a given base radius and involute angle.

function involute (base_radius, involute_angle) =
[
	base_radius*(cos (involute_angle) + involute_angle*PI/180*sin (involute_angle)),
	base_radius*(sin (involute_angle) - involute_angle*PI/180*cos (involute_angle))
];

function pitchR(Nteeth=15, pitch=10) = Nteeth*pitch/(2*PI);

function turn(Nteeth=15, pitch=10, helix_angle=0, h=5) = tan(helix_angle)*h/pitchR(Nteeth, pitch)*180/PI;

function rackDepth(pitch=10, pressure_angle=20) = pitch/(2*tan(pressure_angle));

function baseR(Nteeth=15, pitch=10, pressure_angle=20) = pitchR(Nteeth, pitch)*cos(pressure_angle);

function innerR(Nteeth=15, pitch=10, pressure_angle=20, clearance=0, depth_ratio=2/PI) = 
	max(max(pitchR(Nteeth, pitch)-rackDepth(pitch, pressure_angle)/2-clearance/2,
		baseR(Nteeth, pitch, pressure_angle)*sign(-clearance)),
		pitchR(Nteeth, pitch)-depth_ratio*pitch/2-clearance/2);

function outerR(Nteeth=15, pitch=10, pressure_angle=20, clearance=0, depth_ratio=2/PI) = 
	pitchR(Nteeth, pitch) + min(depth_ratio*pitch/2-clearance/2,
		rackDepth(pitch, pressure_angle)/2+max(-clearance,0));

function depth_diameter(Nteeth=15, pressure_angle=20, depth_ratio=2/PI) = 
	min(PI/(2*Nteeth*tan(pressure_angle)),PI*depth_ratio/Nteeth);

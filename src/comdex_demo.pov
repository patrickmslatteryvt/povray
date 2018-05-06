#include "colors.inc"
#include "rad_def.inc"
#default {finish{ambient 0}}
//
// global_settings {
//    radiosity {
//       Rad_Settings(Radiosity_Normal,off,off)
//    }
// }


#local p_start      =  64/image_width;
#local p_end_tune   =  8/image_width;
#local p_end_final  =  4/image_width;
#local smooth_eb    =  0.50;
#local smooth_count =  75;
#local final_eb     =  0.1875;
#local final_count  =  smooth_count * smooth_eb * smooth_eb / (final_eb * final_eb);

global_settings{
radiosity
{
    pretrace_start p_start        // Use p_end_final for the pretrace_end value
    pretrace_end   p_end_final    //
    count final_count            // as calculated above
    nearest_count 20             // set nearest_count to 20 for final trace
    error_bound final_eb         //  from what we determined before, defined above
                                 //   halfway between 0.25 and 0.5
    recursion_limit 3            // Recursion should be near what you want it to be
                                 //  If you aren't sure, start with 3 or 4
    minimum_reuse 0.005          // Use a lower minimum reuse
    }
}


#declare PlaneFinish =
finish
{
  specular  0.02
  roughness 0.10
  ambient   0.25
}

#declare MirrorFinish =
finish
{
  reflection  1.00
  diffuse     0.00
  ambient     0.00
}


// The ground plane:
plane
{
  <0.0, 1.0, 0.0>, -1
  pigment { checker White Red scale 1.5 }
  finish { PlaneFinish }
}

// The static mirrored ball - http://wiki.povray.org/content/Reference:Sphere
sphere {
  <-1.25, 0.0, 0.85>, 1
  finish { MirrorFinish }
}


// The bouncing mirrored ball - http://wiki.povray.org/content/HowTo:Create_animations
sphere { <1.25, 0.0, 0.85>,1 translate <0.0, clock, 0.0> finish { MirrorFinish } }


// A cloudy sky - http://wiki.povray.org/content/Reference:Sky_Sphere
// http://wiki.povray.org/content/Documentation:Tutorial_Section_3.5
sky_sphere {
  pigment {
    gradient y
    color_map {
        [ 0.5  color CornflowerBlue ]
        [ 0.75  color MidnightBlue ]
    }
    scale 2
    translate -1
  }
  pigment {
    bozo
    turbulence 0.65
    octaves 6
    omega 0.7
    lambda 2
    color_map {
        [0.0 0.1 color rgb <0.85, 0.85, 0.85>
                 color rgb <0.75, 0.75, 0.75>]
        [0.1 0.5 color rgb <0.75, 0.75, 0.75>
                 color rgbt <1, 1, 1, 1>]
        [0.5 1.0 color rgbt <1, 1, 1, 1>
                 color rgbt <1, 1, 1, 1>]
    }
    scale <0.3, 0.425, 0.35>
  }
  rotate -125*x
}


// The Sun in the sky - http://povray.wikia.com/wiki/Sun
sphere
{
0,100
pigment { rgbt 1 } hollow
interior
        { media
              { emission rgb <0.8,0.8,10>
              density
              { spherical density_map
              { [0 rgb 0]
                [60 Orange]
                [80 Red]
                [100 Yellow]
              }
              scale 100
              }
              }
        }
translate <10,100,-100> * 2
}


// Let there be light!
light_source
{
  <0,0,0>
  color rgb <10,10,10>
  translate <10,100,-100> * 2
}


// Lights! Camera! Action!
camera
 {
//  orthographic
// Solution for: The image gets distorted when rendering a square image
//  right x*1280/720
  right x*image_width/image_height
//  right x*2560/1440
  location  <0,0.5,-4>
  look_at   <0,1,0>
}

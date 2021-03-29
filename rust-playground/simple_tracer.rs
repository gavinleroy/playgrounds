// First ray tracer I've ever done
// Code translated from source: @
// https://gist.github.com/DaleyPaley/2ce6ddbf9bc0a9303bca717d3c0beaae#file-minimalraytracer-cpp

use std::ops::{Add, Sub, Mul};

static W: i32 = 1920;
static H: i32 = 1080;

#[derive(Copy, Clone)]
pub struct Vec3D {
    pub x: f32,
    pub y: f32,
    pub z: f32,
}

impl Vec3D {
    pub fn new(x: f32, y: f32, z: f32) -> Self {
        Vec3D { x, y, z }
    }

    pub fn length(self) -> f32 {
        (self.x * self.x + self.y * self.y + self.z * self.z).sqrt()
    }

    pub fn unit(self) -> Vec3D {
        let l = self.length();
        Vec3D::new( self.x / l, self.y / l, self.z / l )
    }

    pub fn dot(lhs: Vec3D, rhs: Vec3D) -> f32 {
        lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z
    }
}

impl Add<Vec3D> for Vec3D {
    type Output =  Vec3D;

    fn add(self, rhs: Vec3D) -> Vec3D {
        Vec3D::new( self.x + rhs.x, self.y + rhs.y, self.z + rhs.z )
    }
}

impl Sub<Vec3D> for Vec3D {
    type Output = Vec3D;

    fn sub(self, rhs: Vec3D) -> Vec3D {
        Vec3D::new( self.x - rhs.x, self.y - rhs.y, self.z - rhs.z )
    }
}

impl Mul<Vec3D> for Vec3D {
    type Output = Vec3D;

    fn mul(self, rhs: Vec3D) -> Vec3D {
        Vec3D::new( self.x * rhs.x, self.y * rhs.y, self.z * rhs.z )
    }
}

impl Mul<f32> for Vec3D {
    type Output = Vec3D;

    fn mul(self, c: f32) -> Vec3D {
        Vec3D::new( self.x * c, self.y * c, self.z * c )
    }
}

#[derive(Copy, Clone)]
pub struct Sphere {
     pub center: Vec3D,
     pub color: Vec3D,
     pub radius: f32,
}

#[allow(non_snake_case)]
fn intersect(sphere: Sphere, origin: Vec3D, dir: Vec3D, dist: &mut f32) -> bool {
    let P: Vec3D = origin - sphere.center;
    let a: f32 = Vec3D::dot(dir, dir);
    let b: f32 = Vec3D::dot(P, dir) * 2_f32;
    let c: f32 = Vec3D::dot(P, P) - sphere.radius.powi(2);
    let d = b.powi(2) - 4_f32 * a * c;

    if d < 0_f32 {
        return false;
    }

    let dsc = 2_f32 * a;
    let sqd: f32 = d.sqrt();

    *dist = (-b - sqd) / dsc;
    if  *dist > 0.1_f32 {
        return true;
    }
    *dist = (-b + sqd) / dsc;
    if  *dist > 0.1_f32 {
        return true;
    }
    return false;
}

fn trace(mut max_rec_depth: i32, origin: Vec3D, dir: Vec3D,
    spheres: &mut Vec<Sphere>, lights: &Vec<Sphere>) -> Vec3D {

    let mut sphere_ind: Option<usize> = None;
    let mut min_dist: f32 = 1e10_f32;
    let mut temp_dist: f32 = 0_f32;

    let num_spheres = spheres.len();
    let num_lights = lights.len();

    for i in 0_usize..num_spheres {
        if intersect(spheres[i], origin, dir, &mut temp_dist) {
            if min_dist > temp_dist {
                min_dist = temp_dist; 
                sphere_ind = Some(i);
            }
        }
    }

    if let Some(ind) = sphere_ind {
        let p: Vec3D = origin + dir * min_dist;
        let n: Vec3D = (p - spheres[ind].center).unit();
        let r: Vec3D = dir - n * Vec3D::dot(dir, n) * 2_f32;
        let mut c: Vec3D = spheres[ind].color * 0.1_f32;

        // If the sphere index was 0, this means the large white sphere (ground) was hit.
        // We can use the x and z indeces to code the tiling of the floor
        if ind == 0 {
            spheres[0].color = // alternating the color depending on where we hit it.
                if (((p.x + 1e2_f32) as i32 + (p.z + 1e2_f32) as i32) & 1) != 0 {
                    Vec3D::new(1_f32, 1_f32, 1_f32)
                } else {
                    Vec3D::new(0_f32, 0_f32, 0_f32)
                };
        }

        for j in 0usize..num_lights {
            let l: Vec3D = (lights[j].center - p).unit();

            let mut sh = false;
            for i in 0usize..num_spheres {
                sh = sh || intersect(spheres[i], p, l, &mut min_dist);
            }

            if !sh {
                let df: f32 = 0_f32.max(Vec3D::dot(l, n)) * 0.7_f32;
                let sp: f32 = 0_f32.max(Vec3D::dot(l, n)).powf(50_f32) * 0.3_f32;

                c = c + spheres[ind].color * lights[j].color * df + Vec3D::new(sp,sp,sp);
            }
        }

        max_rec_depth -= 1;
        if max_rec_depth > 0 {
            c = c + trace(max_rec_depth, p, r, spheres, lights) * 0.51_f32;
        }
        return c;
    }

    Vec3D::new( 1_f32 - dir.y, 1_f32 - dir.y, 0.5_f32 + dir.y )
}

fn main() {
    println!("P3\n{} {}\n255", W, H);

    let max_rec_depth: i32 = 5;
    let hf: f32 = H as f32;
    let wf: f32 = W as f32;

    let camera: Vec3D = Vec3D::new( 0_f32, 1_f32, 5_f32 ); // side

    let mut spheres = vec![Sphere { 
            center: Vec3D::new( 0_f32, -1000_f32, 0_f32 ), 
            color: Vec3D::new( 1_f32, 1_f32, 1_f32 ), 
            radius: 1000_f32
        }, Sphere { // Left Sphere
            center: Vec3D::new( -2_f32, 1_f32, 0_f32 ), 
            color: Vec3D::new( 1_f32, 0_f32, 0_f32 ), 
            radius: 1_f32
        }, Sphere { // Middle Sphere
            center: Vec3D::new( 0_f32, 1_f32, 0_f32 ), 
            color: Vec3D::new( 0_f32, 1_f32, 0_f32 ), 
            radius: 1_f32
        }, Sphere { // Right Sphere
            center: Vec3D::new( 2_f32, 1_f32, 0_f32 ), 
            color: Vec3D::new( 0_f32, 0_f32, 1_f32 ), 
            radius: 1_f32
        }];

    let lights = vec![Sphere { 
            center: Vec3D::new( 0_f32, 100_f32, 0_f32 ), 
            color: Vec3D::new( 0_f32, 0.1_f32, 0.2_f32 ), 
            radius: 0_f32 
        }, Sphere { 
            center: Vec3D::new( 100_f32, 100_f32, 200_f32 ), 
            color: Vec3D::new( 0.3_f32, 0.1_f32, 0.0_f32 ), 
            radius: 0_f32 
        }, Sphere { 
            center: Vec3D::new( -100_f32, 300_f32, 100_f32 ), 
            color: Vec3D::new( 0.1_f32, 0.3_f32, 0.0_f32 ), 
            radius: 0_f32 
        }];

    for y in 0..H {
        for x in 0..W {
            let c: Vec3D = trace(max_rec_depth, camera, 
                                 Vec3D::new((x as f32) - wf / 2_f32, hf / 2_f32 - (y as f32), -hf).unit(), 
                                 &mut spheres, &lights);
            println!("{} {} {}",
                   (1_f32.min(c.x) * 255_f32) as i32,
                   (1_f32.min(c.y) * 255_f32) as i32,
                   (1_f32.min(c.z) * 255_f32) as i32);
        }
    }
}

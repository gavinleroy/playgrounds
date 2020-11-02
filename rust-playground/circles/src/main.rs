use std::f32::consts::PI;

struct Circle {
    radius: f32,
}

impl Circle {
    fn area(&self) -> f32 {
        self.radius.powf(2.0) * PI
    }
    fn diameter(&self) -> f32 {
        2.0 * self.radius * PI
    }
    fn scale(&mut self, c: f32) {
       self.radius = self.radius * c; 
    }
    fn create(radius: f32) -> Circle {
        Circle{ radius }
    }
}

fn main() {
    let mut c = Circle::create(3.0);
    println!("Area: {} Diameter: {} Radius: {}", c.area(), c.diameter(), c.radius);
    c.scale(2.0);
    println!("Area: {} Diameter: {} Radius: {}", c.area(), c.diameter(), c.radius);
}

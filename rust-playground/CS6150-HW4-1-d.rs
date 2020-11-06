// Gavin Gray CS 6150 HW4 1.d
use std::vec::Vec;
use std::f64;

fn fact(n:u32) -> u64 {
  let mut f:u64 = n as u64;
  for i in 2..n {
    f *= i as u64;
  }
  return f;
}
fn choose(n: u32, k: u32)  -> u64 {
   let mut num:u64 = n as u64;
   for i in 1..k {
     num *= (n-i) as u64;
   }
   return num / fact(k);
}
fn prob(j: u32, n: u32) -> f64 {
   (j - 1) as f64 * (n - j) as f64 / choose(n, 3) as f64
}
fn solve(v: &mut Vec<f64>) {
    v.push(0.); 
    v.push(1.); 
    v.push(3.); 
    for n in 3..=1000 {
        let summation: f64 = (1..n)
            .fold(0., |s: f64, j| 
                  s + (prob(j, n) * 
                       f64::max(v[(j-1) as usize], v[(n-j) as usize])));
        v.push(n as f64 + summation);
    }
}
fn main() {
    let mut v = Vec::<f64>::new();
    solve(&mut v);
    println!("{}", v[1]);
    println!("{}", v[2]);
    println!("{}", v[100] / 100.);
    println!("{}", v[200] / 200.);
    println!("{}", v[1000] / 1000.);
}

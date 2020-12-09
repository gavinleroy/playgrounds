fn main() {
    let mut count = 0;
    let mut cl = || -> i32 { let r = count; count += 1; r };

    for x in 0..10 {
        println!("{}th call {}", x, cl ());
    }

    count += 1;
    println!("Count is: {}", count);

    // This call not possible due to immutable borrow
    // println!("last call {}", cl ());

    let ho_cl = |i: i32| { move || -> i32 { i } };
    let mut a = ho_cl (1);

    println!("Calling a: {}", a ());

    let b = ho_cl (2);
    a = b;

    println!("Calling a: {}", a ());

    println!("Hello, world!");
}

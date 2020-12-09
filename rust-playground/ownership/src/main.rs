fn main() {
    println!("Hello, Ownership!");

    let s1 = String::from("My name is judge");
    let s2 = s1; // Obviously copies the ref value

    // s1 was `moved` into s2 making the below invalid
    // println!("What did you say? {}", s1);

    take_ownership(s2);

    // This print is not possible becuase of the implicit move
    // println!("s from main: {}", s2);

    let s3 = String::from("Second times the charm :)");

    borrow(&s3);

    println!("Can still use it here: {}", s3);

    let mut s4 = String::from("gavinleroy");

    {
        let s5 = &mut s4; 
        // let mut s5 = &mut s4; // You don't need the first mut here
        s5.push_str("gray");
        // s5.push_str("gray"); // ERROR
        println!("{}", s5);
    }

    println!("s4: {}", s4); // Stays modified
}

fn take_ownership(s: String) {
    println!("s from func: {}", s);
}

fn borrow(s: &String) {
    println!("borrowed capabilities of: {}", s);
}

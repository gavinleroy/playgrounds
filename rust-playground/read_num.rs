use std::io;

fn double(x: u32) -> u32{
   return x*2; 
}

fn main() {
    let mut input_text = String::new();
    io::stdin()
        .read_line(&mut input_text);

    let trimmed = input_text.trim();
    match trimmed.parse::<u32>() {
        Ok(i) => println!("Twice your input is: {}", double(i)),
        Err(..) => println!("this was not an integer: {}", trimmed),
    };
}

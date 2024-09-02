use std::fs;
use std::io;

#[allow(warnings)]
mod bindings;

fn main() {
    let mesg_vec = fs::read_dir("/shenanigans").unwrap()
        .map(|res| res.map(|e| e.path()))
        .collect::<Result<Vec<_>, io::Error>>().unwrap();

    let mesg = mesg_vec.into_iter().map(|boop| {
        boop.into_os_string().into_string().unwrap_or(String::from(""))
    }).collect::<Vec<String>>().join("\n");

    println!("{}", mesg);
}

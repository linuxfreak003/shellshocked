// Written using rustc version 1.49.0
use std::collections::HashMap;
use std::env;
use std::io;
use std::io::Write;
use std::io::{Error, ErrorKind};
use std::path::Path;
use std::process::Command;

fn jsh_cd(args: Vec<String>) -> io::Result<()> {
    let path = Path::new(&args[1]);
    return env::set_current_dir(&path);
}
fn jsh_exit(_args: Vec<String>) -> io::Result<()> {
    return Err(Error::new(ErrorKind::Other, ""));
}

fn jsh_split_line(line: String) -> Vec<String> {
    let args: Vec<String> = line.split_whitespace().map(|s| s.to_string()).collect();
    return args;
}

fn jsh_launch(args: Vec<String>) -> io::Result<()> {
    println!("Starting command: {:?}", args);
    let mut cmd = Command::new(&args[0]);
    for a in &args[1..] {
        cmd.arg(a);
    }
    let status = cmd.status().expect("failed to execute command");
    println!("Proceass exited with: {}", status);
    return Ok(());
}

fn jsh_execute(args: Vec<String>) -> io::Result<()> {
    if args.len() == 0 {
        return Ok(());
    }

    let mut built_in = HashMap::new();
    built_in.insert(
        "cd".to_string(),
        jsh_cd as fn(Vec<String>) -> std::result::Result<(), std::io::Error>,
    );
    built_in.insert("exit".to_string(), jsh_exit);

    match built_in.get(&args[0]) {
        Some(f) => return f(args),
        None => return jsh_launch(args),
    }
}

fn jsh_loop() -> io::Result<()> {
    loop {
        let cwd = env::current_dir()?;
        print!(">{}$ ", cwd.display());
        io::stdout().flush().unwrap();
        let mut line = String::new();
        let _ = io::stdin().read_line(&mut line).unwrap();

        let args = jsh_split_line(line);
        match jsh_execute(args) {
            Ok(_) => continue,
            Err(e) => {
                println!("error {}", e);
                break;
            }
        }
    }
    return Ok(());
}

fn main() {
    println!("Starting shell.");
    match jsh_loop() {
        Ok(()) => println!("Exiting shell."),
        Err(e) => println!("There was an error: {}", e),
    };
}

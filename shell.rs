use std::env;
use std::io;
use std::io::BufRead;
use std::io::Write;

fn main() {
    println!("Starting shell.");
    match jsh_loop() {
        Ok(()) => println!("Exiting shell."),
        Err(e) => println!("There was an error: {}", e),
    };
}

fn jsh_loop() -> io::Result<()> {
    loop {
        let cwd = env::current_dir()?;
        print!(">{}$ ", cwd.display());
        io::stdout().flush().unwrap();
        let stdin = io::stdin();
        let line = stdin.lock().lines().next().unwrap().unwrap();

        if line == "exit" {
            break;
        }

        println!("You wrote: {}", line);
    }
    return Ok(());
}

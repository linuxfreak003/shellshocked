# shellshocked
Different shells, written so far C, OCaml, Python, and Go

The C code is mostly copied over from Stephen Brennan's blog [here.](https://brennan.io/2015/01/16/write-a-shell-in-c/)

I started the C code to learn more about creating a shell.
The OCaml code was to get a little bit of experience
and become more familiar with OCaml.
The python and Go implementations are just to add more languages to the mix.


The included `Makefile` will compile to the given language

Default `make` will compile the OCaml version

`make run` will compile and run the OCaml version

Note: This likely will not work with the newest version of OCaml, unfortunately, I forgot
what version of OCaml I was using when I wrote it, and the code has changed, so... Good luck.

To compile in different languages:
* OCaml: `make` or `make ocaml`
* C: `make c`
    - Requires `gcc`
* Go: `make go`
    - Requires `go`
    - `go get github.com/gookit/color`
* Rust: `make rust`
    - Requires `rustc`

They will all output a `jsh` binary that can be run

To run in Python
* `python3 shell.py` - you must have python3 installed

To create a `.deb` package run `make deb` (this probably needs to be done on a Debian based system).

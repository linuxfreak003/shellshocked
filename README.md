# shellshocked
Different shells, so far C and OCaml

The C code is mostly copied over from Stephen Brennan's blog [here.](https://brennan.io/2015/01/16/write-a-shell-in-c/)

I started the C code to learn more about creating a shell. The OCaml code was to get a little bit of experience and become more familiar with OCaml.

I may add some Python code someday if I get bored and feel like doing something.

To run use makefile.
* `make jsh` or simply `make` to create the native binary from OCaml.
* `make jshc` to compile the C code into a binary.
* `make clean` will remove auxilary files.
* `make deepclean` will remove binaries as well.

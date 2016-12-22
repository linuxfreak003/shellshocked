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

License
-------

This code is distributed under the Simplified BSD License.

> Copyright © 2016 Jared Chapman.
> All rights reserved.
> 
> Redistribution and use in source and binary forms, with or without
> modification, are permitted provided that the following conditions
> are met:
> 
> 1.  Redistributions of source code must retain the above copyright
>     notice, this list of conditions and the following disclaimer.
> 
> 2.  Redistributions in binary form must reproduce the above
>     copyright notice, this list of conditions and the following
>     disclaimer in the documentation and/or other materials provided with
>     the distribution.
> 
> THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
> FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
> COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
> INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
> BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
> LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
> CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
> LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
> ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
> POSSIBILITY OF SUCH DAMAGE.

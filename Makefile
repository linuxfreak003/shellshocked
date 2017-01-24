all: jsh

jsh: shell.ml jshc
	ocamlfind ocamlopt -linkpkg -thread -package core shell.ml -o jsh

jshc: shell.c
	gcc -o jshc shell.c

deepclean:
	rm -rf *.cmi *.cmo *.cmx *.o
	rm -rf jsh
	rm -rf jshc

clean:
	rm -rf *.cmi *.cmo *.cmx *.o

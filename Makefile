all: jsh

jshc: shell.c
	gcc -o jshc shell.c

jsh: shell.ml
	ocamlfind ocamlopt -linkpkg -thread -package core shell.ml -o jsh

deepclean:
	rm -rf *.cmi *.cmo *.cmx *.o
	rm -rf jsh
	rm -rf jshc

clean:
	rm -rf *.cmi *.cmo *.cmx *.o

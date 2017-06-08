VERSION := 1.1
TARGET := jsh

all: $(TARGET)

run: $(TARGET)
	./$(TARGET)

$(TARGET): shell.ml
	ocamlfind ocamlopt -linkpkg -thread -package core shell.ml -o jsh

jshc: shell.c
	gcc -o jshc shell.c

deb: $(TARGET)
	mkdir -p $(TARGET)_$(VERSION)/usr/local/bin
	cp $(TARGET) $(TARGET)_$(VERSION)/usr/local/bin/.
	mkdir $(TARGET)_$(VERSION)/DEBIAN
	echo "Package: $(TARGET)\n\
Version: $(VERSION)\n\
Section: base\n\
Priority: optional\n\
Architecture: amd64\n\
Depends:\n\
Maintainer: Jared Chapman <jaredpchapman@gmail.com>\n\
Description: ShellShocked\n\
 A simple shell written in\n\
 Objective-Caml" > $(TARGET)_$(VERSION)/DEBIAN/control;\
 	dpkg-deb --build $(TARGET)_$(VERSION)
	rm -rf $(TARGET)_$(VERSION)

clean:
	rm -rf *.cmi *.cmo *.cmx *.o
	rm $(TARGET)
	rm -rf jshc

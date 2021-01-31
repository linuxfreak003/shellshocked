VERSION := 1.1
TARGET := jsh

all: go

$(TARGET): go

run: go
	./$(TARGET)

ocaml: shell.ml
	ocamlfind ocamlopt -linkpkg -thread -package core shell.ml -o $(TARGET)

# cpp: shell.cpp
# 	g++ -o shell shell.cpp

c: shell.c
	gcc -o $(TARGET) shell.c

go: shell.go
	go build -o $(TARGET) shell.go

rust: shell.rs
	rustc -o $(TARGET) shell.rs

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
Maintainer: Linuxfreak003 <linuxfreak003@gmail.com>\n\
Description: ShellShocked\n\
 A simple shell written in\n\
 Objective-Caml" > $(TARGET)_$(VERSION)/DEBIAN/control;\
 	dpkg-deb --build $(TARGET)_$(VERSION)
	rm -rf $(TARGET)_$(VERSION)

clean:
	@rm -rf *.cmi *.cmo *.cmx *.o
	@rm -f $(TARGET)
	@rm -rf $(TARGET)_$(VERSION)

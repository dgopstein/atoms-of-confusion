test: build
	./test.sh orig_files/cdua.c cdua.c

build: FORCE
	gcc cdua.c -o bin/cdua

scratch:
	gcc scratch.c -o bin/scratch && bin/scratch

FORCE:

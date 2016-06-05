test: build
	./test.sh orig_files/dodsond1.c dodsond1.c

build: FORCE
	gcc dodsond1.c -o bin/dodsond1

scratch:
	gcc scratch.c -o bin/scratch && bin/scratch

FORCE:

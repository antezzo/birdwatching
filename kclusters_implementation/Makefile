

all: k_means.so

k_means.so: k_means

k_means: k_means.c
	gcc -c -fPIC -o k_means k_means.c
	gcc -shared -o k_means.so k_means
	rm k_means

clean:
	rm k_means.so

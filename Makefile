all: gui_main

clean:
	rm -f beak/tweets/*; rm -f beak/z_scored*; rm -f beak/users_data.txt; rm -f feathers/graph_temp/graph_*

gui_test:
	ruby feathers/gui_main.rb

tsne_test:
	python beak/tsne.py
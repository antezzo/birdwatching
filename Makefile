all: gui_main

clean:
	rm beak/tweets/*; rm beak/z_scored*; rm beak/users_data.txt; rm feathers/graph_temp/graph_*

gui_test:
	ruby feathers/gui_main.rb

tsne_test:
	python beak/tsne.py
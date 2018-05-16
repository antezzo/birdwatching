all: gui_main

gui_main:
	ruby feathers/gui_main.rb

tsne:
	python beak/tsne.py
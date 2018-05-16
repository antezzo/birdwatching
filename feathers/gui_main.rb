require 'tk'
require 'tkextlib/tile'
require 'RMagick'
include Magick
require_relative '../beak/gullet.rb'

class GUIMain
	def makeImage(runClusters,clusterNum,userNum,doScrape)
		$keyVar = TkVariable.new
		$keyVar = @keywordMenu.get
		$sVar = false

		if doScrape == 0 then
			$sVar = false
		else
			$sVar = true
		end

		gullet = Gullet.new()
		print gullet.process_data($keyVar, clusterNum, userNum, $sVar)

		cmd = "python beak/tsne.py"
		pid = Process.spawn(cmd)
		Process.wait(pid)

		makeGIF
		outImage = TkPhotoImage.new(:file => "feathers/graph_temp/graph_temp.gif")
		
		@kVal.text = $keyVar.to_s
		@cVal.text = clusterNum.to_s
		@label.image = outImage
	end

	def clearImage
		@label.image = @defaultImage
		@kVal.text = nil
		@cVal.text = nil
	end

	def makeGIF
		tempImage = ImageList.new("feathers/graph_temp/graph_temp.png")
		tempResize = tempImage.scale(600,450)
		tempResize.write("feathers/graph_temp/graph_temp.gif")
	end

	def initialize

		root = TkRoot.new do  
			title "Birdwatching"
			geometry '850x600+50+50'
			resizable false, false
		end

		content = Tk::Tile::Frame.new(root) {width 850; height 600} # content container
		menuBarFrame = Tk::Tile::Frame.new(content) {width 850; height 50} # menu bar container
		mainContentFrame = Tk::Tile::Frame.new(content) {width 600; height 450} # main content container
		controlBarFrame = Tk::Tile::Frame.new(content) {width 850; height 100} # 
		sideBarFrame = Tk::Tile::Frame.new(content) {width 200; height 450}

		heading = Tk::Tile::Label.new(content) {text "Birdwatching GUI"; font 'TkMenuFont'}

		runButton = Tk::Tile::Button.new(sideBarFrame) {text "Run"}
		runButton.command{ makeImage($scrapeVar,$clusterVar,$userVar,$scrapeVar) }
		cancelButton = Tk::Tile::Button.new(sideBarFrame) {text "Clear"}
		cancelButton.command{ clearImage }

		$scrapeVar = TkVariable.new( true )
		doScrape = Tk::Tile::CheckButton.new(sideBarFrame) {text "Scrape new data?"; variable $scrapeVar; onvalue true; offvalue false}

		kText = TkLabel.new(sideBarFrame) {text "Keyword:"; justify 'left'}
		cText = TkLabel.new(sideBarFrame) {text "Number of clusters:"; justify 'left'}
		uText = TkLabel.new(sideBarFrame) {text "Number of users:"; justify 'left'}

		$clusterVar = TkVariable.new(2)
		$userVar = TkVariable.new(5)
		@keywordMenu = Tk::Tile::Combobox.new(sideBarFrame) {values [ 'kim kardashian', 'c2', 'c3']; state 'normal'; justify 'center'}
		@clusterMenu = Tk::Tile::Spinbox.new(sideBarFrame) {from 2; to 20; textvariable $clusterVar}
		@userMenu = Tk::Tile::Spinbox.new(sideBarFrame) {from 5; to 200; textvariable $userVar}
		
		@label = Tk::Tile::Label.new(root)
		@defaultImage = TkPhotoImage.new(:file => "feathers/graph_temp/default.gif")
		@label.image = @defaultImage

		logoLabel = Tk::Tile::Label.new(root)
		logo = TkPhotoImage.new(:file => "feathers/logo.gif")
		logoLabel.image = logo

		curK = Tk::Tile::Label.new(root) {text "Current keyword:"; compound 'left'}
		@kVal = Tk::Tile::Label.new(root) {compound 'left'}
		curC = Tk::Tile::Label.new(root) {text "Number of clusters:"; compound 'left'}
		@cVal = Tk::Tile::Label.new(root) {compound 'left'}

		content.grid :column => 0, :row => 0, :columnspan => 16, :rowspan => 12
		menuBarFrame.grid :column => 0, :row => 0, :columnspan => 16, :rowspan => 1 
		mainContentFrame.grid :column => 0, :row => 1, :columnspan => 12, :rowspan => 9
		sideBarFrame.grid :column => 14, :row => 0, :columnspan => 2, :rowspan => 6 
		controlBarFrame.grid :column => 0, :row => 10, :columnspan => 16, :rowspan => 2

		heading.grid :column => 0, :row => 0

		kText.grid :column => 14, :row => 0, :columnspan => 2 # keyword selector
		@keywordMenu.grid :column => 14, :row => 1, :columnspan => 2 # keyword drop down menu
		cText.grid :column => 14, :row => 2, :columnspan => 2 # cluster number selector
		@clusterMenu.grid :column => 14, :row => 3, :columnspan => 2 # cluster drop down menu
		uText.grid :column => 14, :row => 4, :columnspan => 2 # user number selector
		@userMenu.grid :column => 14, :row => 5, :columnspan => 2 # cluster drop down menu

		doScrape.grid :column => 14, :row => 6, :columnspan => 2 # rescrape checkbutton
		runButton.grid :column => 14, :row => 7, :columnspan => 2 # run button
		cancelButton.grid :column => 14, :row => 8, :columnspan => 2 # clear button

		curK.grid :column => 1, :row => 10 # current keyword label
		curC.grid :column => 1, :row => 11 # current cluster number label

		@kVal.grid :column => 2, :row => 10, :columnspan => 3 # current keyword val
		@cVal.grid :column => 2, :row => 11, :columnspan => 3 # current cluster val

		@label.grid :column => 0, :row => 1, :columnspan => 12, :rowspan => 9 # main image
		logoLabel.grid :column => 14, :row => 11, :columnspan => 2, :rowspan => 2 # logo


		Tk.mainloop

	end
end

GUIMain.new
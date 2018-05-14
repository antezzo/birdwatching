require 'tk'
require 'tkextlib/tile'

class GUIMain
	def loadImage
		$keyVar = TkVariable.new
		$clusterNo = TkVariable.new
		$keyVar = @keywordMenu.get
		$clusterNo = @clusterMenu.get
		if ($keyVar == "c1") then
				@image = TkPhotoImage.new(:file => "graph_temp/graph_temp1.gif")
		elsif ($keyVar == "c2") then
			@image = TkPhotoImage.new(:file => "graph_temp/graph_temp2.gif")
		elsif ($keyVar == "c3") then
			@image = TkPhotoImage.new(:file => "graph_temp/graph_temp3.gif")
		else
			@image = TkPhotoImage.new(:file => "graph_temp/graph_temp4.gif")
		end
		@kVal.text = $keyVar.to_s
		@cVal.text = $clusterNo.to_s
		@label.image = @image
	end

	def clearImage
		@label.image = @defaultImage
	end

	def initialize

		root = TkRoot.new do  
			title "Birdwatching"
			geometry '800x600+50+50'
			resizable false, false
		end

		content = Tk::Tile::Frame.new(root) {width 600; height 800}
		menuBarFrame = Tk::Tile::Frame.new(content) {width 800; height 50}
		mainContentFrame = Tk::Tile::Frame.new(content) {width 600; height 450}
		controlBarFrame = Tk::Tile::Frame.new(content) {width 800; height 100}
		sideBarFrame = Tk::Tile::Frame.new(content) {width 200; height 450}

		runButton = Tk::Tile::Button.new(content) {text "Run"}
		runButton.command{ loadImage }
		cancelButton = Tk::Tile::Button.new(content) {text "Clear"}
		cancelButton.command{ clearImage }

		$value = TkVariable.new( 5 )
		oneCheck = Tk::Tile::CheckButton.new(content) {text "One"; variable $value; onvalue 1}
		twoCheck = Tk::Tile::CheckButton.new(content) {text "Two"; variable $value; onvalue 2}
		threeCheck = Tk::Tile::CheckButton.new(content) {text "Three"; variable $value; onvalue 3}
		fourCheck = Tk::Tile::CheckButton.new(content) {text "Four"; variable $value; onvalue 4}

		kText = TkLabel.new(sideBarFrame) {text "Keyword:"; justify 'left'}
		cText = TkLabel.new(sideBarFrame) {text "Number of clusters:"; justify 'left'}

		@keywordMenu = Tk::Tile::Combobox.new(sideBarFrame) {values [ 'c1', 'c2', 'c3']; state 'normal'; justify 'center'}
		@kVal = Tk::Tile::Label.new(root)

		@clusterMenu = Tk::Tile::Combobox.new(sideBarFrame) {values ['2','3','4','5','6','7','8','9','10','11','12','13','14','15']; state 'normal'; justify 'center'}
		@cVal = Tk::Tile::Label.new(root)

		@label = Tk::Tile::Label.new(root)
		@defaultImage = TkPhotoImage.new(:file => "graph_temp/default.gif")
		@label.image = @defaultImage

		logoLabel = TkLabel.new(root)
		logo = TkPhotoImage.new(:file => "logo.gif")
		logoLabel.image = logo

		curK = TkLabel.new(root) {text "Current keyword:"; justify 'left'}
		curC = TkLabel.new(root) {text "# of clusters:"; justify 'left'}

		content.grid :column => 0, :row => 0, :columnspan => 16, :rowspan => 12
		menuBarFrame.grid :column => 0, :row => 0, :columnspan => 16, :rowspan => 1 
		mainContentFrame.grid :column => 0, :row => 1, :columnspan => 12, :rowspan => 9 
		sideBarFrame.grid :column => 14, :row => 0, :columnspan => 2, :rowspan => 9 
		controlBarFrame.grid :column => 0, :row => 10, :columnspan => 16, :rowspan => 2

		runButton.grid :column => 14, :row => 0
		cancelButton.grid :column => 15, :row => 0

		@kVal.grid :column => 15, :row => 1
		@cVal.grid :column => 15, :row => 2

		curK.grid :column => 14, :row => 1
		curC.grid :column => 14, :row => 2

		kText.grid :column => 14, :row => 0, :columnspan => 2
		cText.grid :column => 14, :row => 2, :columnspan => 2

		@keywordMenu.grid :column => 14, :row => 1, :columnspan => 2
		@clusterMenu.grid :column => 14, :row => 3, :columnspan => 2

		@label.grid :column => 0, :row => 1, :columnspan => 12, :rowspan => 9
		logoLabel.place('height' => 50, 'width' => 50, 'x' => 0, 'y' => 0)


		Tk.mainloop

	end
end

GUIMain.new
package bare.utils;
import processing.core.*;

public class Image {
	// image object
	public PImage img;
	
	// path to image file
	public String path;
	
	FreeTransform parent;
	
	// constructor
	Image(String path, FreeTransform parent_)
	{
		parent = parent_;
		img = parent.myParent.createImage(1, 1, PConstants.RGB);
		this.path = path;
	}
	
	public void loadImage()
	{
		img = parent.myParent.loadImage(path);
	}
	
	public void loadPath(String path_)
	{
		path = path_;
	}
	
}

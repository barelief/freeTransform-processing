/**
 *
 * Images class contains info about interactively loaded images from disk. 
 * You can load images while running sketch. press 'l' to load image info currently selected quad.
 * Image file path is automatically saved to json and load next time you restart the sketch
 * 
 * @author Bartosh Polonski
 * @version 0.4
 * @since 2016-05-13
 * 
 * @example Hello 
 * 
 * 
 */

package bare.utils;
import processing.core.*;

public class Image {
	// image object
	public PImage img;
	
	// path to image file
	public String path;
	
	// parent object (needed for to get PApplet functions like createImage)
	FreeTransform parent;
	
	// constructor
	Image(String path, FreeTransform parent_)
	{
		parent = parent_;
		img = parent.myParent.createImage(1, 1, PConstants.RGB);
		this.path = path;
	}
	
	// load image file into img object
	public void loadImage()
	{
		img = parent.myParent.loadImage(path);
	}
	
	// loads image path string into path object
	public void loadPath(String path_)
	{
		path = path_;
	}
	
}

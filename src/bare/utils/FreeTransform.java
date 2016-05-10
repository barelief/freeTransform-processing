/**
 *
 * FreeTransform class contains quad objects distinguishes quads between
 * selected and/or focused for interaction routines saves/loads coordinates
 * to/from external json file
 * 
 * @author Bartosh Polonski
 * @version 0.3.0
 * @since 2016-04-30
 * 
 * @example Hello 
 * 
 * 
 */

package bare.utils;

import processing.data.JSONArray;
import processing.data.JSONObject;
import processing.event.KeyEvent;

import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;

import processing.core.*;

public class FreeTransform {

	// myParent is a reference to the parent sketch
	PApplet myParent;

	PVector P; // user input vector (mouse)
	PVector beginP; // inial P position (before making offset)
	PVector offsetP; // offset made by moving P from initial position

	int myVariable = 0;

	public final static String VERSION = "##library.prettyVersion##";

	ArrayList<Polygon> quads;

	// images from json to be transformed
	ArrayList<Image> images;

	int selectedQuad;
	boolean helpMode = false; //
	JSONArray quadData;
	public boolean isEnabled = false;

	Events events; //

	int defaultSize = 50;

	// load image cursors (they should be as png files in data/ folder
	Cursors cursors;

	/**
	 * a Constructor, usually called in the setup() method in your sketch to
	 * initialize and start the Library.
	 * 
	 * @example Hello
	 * @param theParent
	 *            parent Processing object
	 */

	public FreeTransform(PApplet theParent) {
		this.myParent = theParent;
		welcome();
		quads = new ArrayList<Polygon>();
		images = new ArrayList<Image>();
		// load cooradinates for all quads points from external JSON file
		loadValues();

		// enable mouse and key events (unregistered by default)
		events = new Events(this);
		this.myParent.registerMethod("keyEvent", this);
		System.out.println("[notice ] Press t to enable/disable Free Transform.. ");

		// create Cursors object
		cursors = new Cursors();
		cursors.loadCursors(theParent, this);
	}

	public void toggleTransform() {
		isEnabled = !isEnabled;

		// enable or disable transformation mouse / key events
		if (isEnabled)
			events.register();
		else {
			events.unregister();
			myParent.cursor();
		}
	}

	public void draw() {
		update();
		// render();
	}

	public void update() {
		// interate backwards to avoid out of bounds exceptions when removieng
		// from arraylist
		Iterator<Polygon> quadsIterator = quads.iterator();
		while (quadsIterator.hasNext()) {

			Polygon quad = quadsIterator.next(); //
			// update quad points (neede to transform textures)
			quad.update();

			// display quad ,cursors
			if (isEnabled) {
				quad.render(); //
				cursors.render();
			}
		}

		// diplay help and debug information
		showDebugInfo();
	}

	// display images loaded from json file
	public void render() {
		for (int i = 0; i < quads.size(); i++) {
			// if image path exists
			if (!images.get(i).path.equals(""))
				// display this image
				render(i, images.get(i).img);
		}
	}

	// return the currently mouse selected quad
	int selectedQuadId() {

		for (int i = 0; i < quads.size(); i++) {
			Polygon quad = quads.get(i); //
			if (quad.dragLock) {
				selectedQuad = quad.id;
				quad.isSelected = true; //
			} else
				quad.isSelected = false;
		}
		return selectedQuad;
	}

	// return the currently mouse focused quad
	int focusedQuadId() {

		for (int i = 0; i < quads.size(); i++) {
			Polygon quad = quads.get(i); //
			if (quad.isFocused()) {
				selectedQuad = quad.id;
			}
		}
		return selectedQuad;
	}

	// display useful help and debug info
	void showDebugInfo() {
		Polygon quad = quads.get(selectedQuadId()); //
		myParent.stroke(255);

		if (isEnabled) {
			myParent.text("Transforming [" + quads.size() + " quads][" + selectedQuadId() + "]", 20, 20);
			if (!helpMode)
				myParent.text("[h] for help\n[t] to disable transform", 20, 40);
			else
				myParent.text("mode: " + quad.state + "\nMOUSESCROLL or +/- keyboard to zoom in/out\n"
						+ "hold CTRL to free transform\n" + "hold SHIFT to scale proportionally\n"
						+ /* "↑ ↓ ← → to update w/ keyboard (disabled)\n" + */ "h to hide this help info"
						+ "\nl to load image into selected quad"
					    + "\nr to reset selected quad \nR to reset all quads"
						+ "\na to add new quad\n" + "x to remove selected quad" + "\nframe rate: "
						+ (int) myParent.frameRate, 20, 40);

			/*
			 * // display path names for Images for (int i = 0; i <
			 * quads.size(); i++) { myParent.text(images.get(i).path, 20, 50 + i
			 * * 20); }
			 */
		}
	}

	// saves current points coordinates to disk
	void savePoints() {
		// nunullinam coordinates
		quadData = new JSONArray();

		for (int i = 0; i < quads.size(); i++) {
			JSONObject pointToSave = new JSONObject();
			// set the id of the quad
			pointToSave.setInt("id", i);

			// save picture path to json
			String path = images.get(i).path;
			pointToSave.setString("picture", path);

			// load particular quad
			Polygon quad = quads.get(i);

			for (int j = 0; j < quad.amount; j++) {
				pointToSave.setInt("x" + j, (int) quad.point[j].position.x);
				pointToSave.setInt("y" + j, (int) quad.point[j].position.y);
			}
			quadData.setJSONObject(i, pointToSave);
		}

		myParent.saveJSONArray(quadData, "data/data.json");
		System.out.println("[notice ] Values saved to disk...");
	}

	void loadPoints() {
		for (int i = 0; i < quads.size(); i++) {
			// load particular quad
			Polygon quad = quads.get(i);

			for (int j = 0; j < quad.amount; j++) {
			}
		}

		System.out.println("[notice ] Values loaded from disk...");
	}

	// load polygon points previously saved to disk
	void loadValues() {
		quadData = new JSONArray();

		// try loading coordinates of polygon points from an external file
		try {
			quadData = myParent.loadJSONArray("data.json");
			// assign loaded values to polygon variables

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("[warning ] data file not found.. but dont worry, we'll create that later..");

			// if external file does not exist, make a default point arrangement
			// as in resetPosition();
			quadData = createDefaultValues();

			// create new json file
			myParent.saveJSONArray(quadData, "data/data.json");
			System.out.println("[notice ] data/data.json created with one quad points values");
		}

		// quadAmount = coordinateValues.size();
		setupValues(quadData);
	}

	JSONArray createDefaultValues() {
		JSONArray defaultValues = new JSONArray();
		JSONObject pointToSave = new JSONObject();

		// set first quads id to 0
		pointToSave.setInt("id", 0);
		pointToSave.setString("picture", "");

		// create temporal Quad to reset it's position points
		Polygon quad = new Polygon(myParent, 0);

		// reset it's position and size
		quad.repositionQuad(new PVector(myParent.width / 2, myParent.height / 2));
		quad.reset(67);

		// get quads points ositions and assign them to JSONObject
		for (int j = 0; j < quad.amount; j++) {
			pointToSave.setInt("x" + j, (int) quad.point[j].position.x);
			pointToSave.setInt("y" + j, (int) quad.point[j].position.y);
		}

		// save quad no. 0 values to JSONArray
		defaultValues.setJSONObject(0, pointToSave);
		return defaultValues;
	}

	public void removeLastQuad() {
		if (quads.size() > 0)
			removeQuad(quads.size() - 1);
	}

	// remove selected quad
	public void removeQuad(int quadIndex) {
		// quads.remove(quadIndex);

		// prevent from removing the last quad (may should make the option to
		// have 0 quads?)
		if (quadIndex < quads.size() && quads.size() > 1) {
			quads.remove(quadIndex);
			images.remove(quadIndex);
			System.out.println("[notice ] removed quad with id " + quadIndex);
			recalcID();
		}
	}

	void removeSelectedQuad() {
		removeQuad(selectedQuadId());
		// recalcID();
	}

	// recalculate ids when one of the quads was removed from array
	void recalcID() {
		for (int i = 0; i < quads.size(); i++) {
			Polygon quad = quads.get(i); //
			quad.id = i;
		}
		selectedQuad = 0; // !!!!!
		// System.out.println("[notice ] ids resorted");
	}

	// add new Quad to the array (quad is saved to json file automatically, upon
	// keyrelease (see Events.java:KeyEvent.RELEASE)
	void addQuad() {
		int quadAmount = quads.size();
		quads.add(new Polygon(myParent, quadAmount));
		images.add(new Image("", this));
		PImage img = images.get(quadAmount).img;
		JSONObject pointToSave = new JSONObject();
		pointToSave.setString("picture", "");
		quadData.setJSONObject(quadAmount, pointToSave);
		// quadData.app
		img = myParent.loadImage(quadData.getJSONObject(quadAmount).getString("picture"));

		Polygon quad = quads.get(quadAmount); //
		quad.repositionQuad(new PVector(myParent.width / 2, myParent.height / 2));

		resetQuad(quadAmount);
		System.out.println("[notice ] added new quad with id " + quadAmount);
		// quadAmount++;
	}

	// reset all quads to their default positions
	void resetAllQuads() {
		PVector newPosition = new PVector();
		int step = myParent.width / quads.size();

		for (int i = 0; i < quads.size(); i++) {
			Polygon quad = quads.get(i); //
			newPosition.set(i * step + defaultSize, defaultSize);
			quad.repositionQuad(newPosition);
			resetQuad(i);
		}
	}

	// reset quadId quad to its default position
	void resetQuad(int quadId) {
		Polygon quad = quads.get(quadId); //
		quad.reset(defaultSize);
	}

	// reset currently selected quad to its default position
	void resetQuad() {
		Polygon quad = quads.get(selectedQuadId()); //
		quad.reset(defaultSize);
	}

	// get loaded values from disk
	// and assign them to the polygon class points
	void setupValues(JSONArray values) {
		System.out.println("[notice ] setting up values..");
		// load points form external file

		for (int i = 0; i < values.size(); i++) {
			// create brand new quad object, set id to i
			quads.add(new Polygon(myParent, i));

			// create brand new PImage object
			images.add(new Image("", this));

			// load particular quad
			Polygon quad = quads.get(i);

			// load particular img
			Image picture = images.get(i);

			picture.path = values.getJSONObject(i).getString("picture");

			if (!picture.path.equals("")) {
				System.out.println("[notice ] loading Image[" + i + "]: " + picture.path);
				// load image to to img object
				picture.loadImage();
			}

			// i - quad id, j - no. of point of this quad
			for (int j = 0; j < quad.amount; j++) {
				quad.point[j] = new Point(myParent, values.getJSONObject(i).getInt("x" + j),
						values.getJSONObject(i).getInt("y" + j), j, quad);
				// for example "y0": 266, "x0": 422... etc.
			}
		}
	}

	// returns particular quad, based on its id
	Polygon getQuad(int id) {
		Polygon quad = quads.get(id); // load particular quad
		return quad;
	}

	// translate image texture with quad points
	public void render(int id, PImage img) {

		// prevent from rendering if there are no quads
		if (quads.size() > 0) {
			// prevent from indexOutOfBoundException if main code has render id
			// bigger than quadAmount
			id = PApplet.constrain(id, 0, quads.size() - 1);

			Polygon quad = quads.get(id);
			myParent.noStroke();
			myParent.beginShape();
			myParent.texture(img);
			myParent.vertex(quad.point[0].x, quad.point[0].y, 0, 0);
			myParent.vertex(quad.point[1].x, quad.point[1].y, img.width, 0);
			myParent.vertex(quad.point[2].x, quad.point[2].y, img.width, img.height);
			myParent.vertex(quad.point[3].x, quad.point[3].y, 0, img.height);
			myParent.endShape();
		}
	}

	// translate PGraphics object texture with quad points
	public void render(int id, PGraphics img) {

		// prevent from rendering if there are no quads
		if (quads.size() > 0) {
			// avoid indexOutOfBoundException if main code has render id bigger
			// than quadAmount
			id = PApplet.constrain(id, 0, quads.size() - 1);

			Polygon quad = quads.get(id);
			myParent.noStroke();
			myParent.beginShape();
			myParent.texture(img);
			myParent.vertex(quad.point[0].x, quad.point[0].y, 0, 0);
			myParent.vertex(quad.point[1].x, quad.point[1].y, img.width, 0);
			myParent.vertex(quad.point[2].x, quad.point[2].y, img.width, img.height);
			myParent.vertex(quad.point[3].x, quad.point[3].y, 0, img.height);
			myParent.endShape();
		}
	}

	// Keyboard inputs aka "press t to transform on/off"
	public void keyEvent(KeyEvent e) {

		switch (e.getAction()) {
		// if key was released
		case KeyEvent.RELEASE:
			// System.out.println("KEY Released");

			break;

		// if key was pressed
		case KeyEvent.PRESS:

			switch (e.getKey()) {
			case 't':
				toggleTransform(); // reset
				// quad.setupValues(quad.values); // load resetted values
				break;

			case PConstants.CODED:
				switch (e.getKeyCode()) {
				case PConstants.CONTROL:
					// control
					break;

				case PConstants.SHIFT:
					// shift
					break;
				}
				break;

			}

			break;
		}
	}

	private void welcome() {
		System.out.println("##library.name## ##library.prettyVersion## by ##author##");
	}

	/**
	 * return the version of the Library.
	 * 
	 * @return String
	 */
	public static String version() {
		return VERSION;
	}

	public void fileSelected(File selection) {
		if (selection == null) {
			System.out.println("Window was closed or the user hit cancel.");
		} else {
			System.out.println("Image selected " + selection.getAbsolutePath() + " into quad no. " + selectedQuadId());

			// load picture into parentTransform.images.get(id)
			Image picture = images.get(selectedQuadId());
			picture.img = myParent.loadImage(selection.getAbsolutePath());
			picture.path = selection.getAbsolutePath();
			savePoints();
		}
	}

}

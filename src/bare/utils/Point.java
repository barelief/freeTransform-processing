/**
*
* Point class contains information of the single poind and methods to rotate or transform it
*
* @author Bartosh Polonski
* @version 0.prototype
* @since 2015-09-13
* 
*/
package bare.utils;

import processing.core.*;

class Point {
	// myParent is a reference to the parent sketch
	PApplet myParent;

	float x, y; // this is additiona float for easier coordienate reading from
				// outside the class (i.e. A.x instead A.position.x)
	PVector position; // actual position vector
	PVector beginPosition; // this is the lock state of the postion, it's used
							// when starting calculating offset vector to
							// understand the starting point of the
							// transformation
	boolean sticked = false; // is this point sticked to mouse?

	// rotation transformations
	PVector tmp; // temporary copy of the postion vector neede for the rotation
					// transformations

	float angle = 0; //
	float startAngle = 0; //

	float offsetAngle = 0; //
	float startOffsetAngle = 0; //

	int sensitivity = 30; // how close mouse should be to start interaction

	int id; // point id, we use this id to update quad.selectedPoint

	Polygon parent;

	// constructor
	Point(PApplet theParent, float x, float y, int id_, Polygon parent_) {
		this.myParent = theParent;
		position = new PVector(x, y);
		beginPosition = position;
		tmp = new PVector();
		id = id_;
		parent = parent_;
	}

	void draw() {
		update();
		render();
	}

	void update() {
		x = position.x;
		y = position.y;
	}

	// reset the begin position
	void reset() {
		beginPosition = position;
	}

	void render() {
		myParent.rectMode(PConstants.CENTER);
		myParent.pushStyle();
		myParent.noFill();

		// make the right colouring: black when not in focus, yellow when
		// focused, green while dragging
		if (isFocusedOnThePoint()) {
			if (!parent.dragLock) {
				myParent.stroke(255, 255, 0);
				parent.selectedPoint = id;
			} else {
				myParent.stroke(0, 255, 0);
			}
		} else
			myParent.stroke(0);

		myParent.rect(x, y, 5, 5);
		myParent.popStyle();
	}

	// checks is mouse is close enough to the point
	boolean isFocusedOnThePoint() {
		PVector P = new PVector();
		P.set(myParent.mouseX, myParent.mouseY);
		if (position.dist(P) < sensitivity)
			return true;
		else
			return false;
	}

	// begin rotation process, lock initial positions
	// THIS METHOD NEED EXPLAINING DRAWING! (even if it works perfectly :)
	void startRotating() {
		startOffsetAngle = parent.anchorLine.heading(); // lock initial offset
														// angle
		beginPosition.set(position); // lock position A and save it to
										// beginPosition vector
		tmp = PVector.sub(beginPosition, parent.lockAnchor); // create
																// temporarary
																// vector to
																// contain
																// infomation
		startAngle = tmp.heading(); //
	}

	// rotate the point around the anchor
	void rotate() {
		offsetAngle = parent.anchorLine.heading() - startOffsetAngle; // rotate
																		// offset
																		// made
																		// beginning
																		// with
																		// 0
																		// (mousePressed),
																		// ending
																		// with
																		// final
																		// mouseDragged
		angle = startAngle + offsetAngle; // final rotation amount
		tmp = PVector.sub(beginPosition, parent.lockAnchor); // create temporary
																// (absolute
																// position)
																// vector from
																// anchor to
																// point A
		tmp.rotate(-tmp.heading()); // back to initial position
		tmp.rotate(angle); // add your desired rotation amount
		tmp.add(parent.lockAnchor); // position vector back to it's place on the
									// screen
		position.set(tmp); // update original vector based on transformed
							// temporary vector
	}

	// drag the point with amount of offsetP
	void drag() {
		if (sticked) {
			// reposition point based the offset made by P
			position = PVector.add(beginPosition, parent.offsetP);
		}
	}
}

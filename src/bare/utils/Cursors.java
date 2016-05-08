package bare.utils;

import processing.core.*;

public class Cursors {
	PImage[] cursor = new PImage[4]; // create array of images used as cursors
	PApplet myParent;
	FreeTransform transform;

	// load cursor image files into the app
	void loadCursors(PApplet theParent, FreeTransform parentTransofrm) {
		this.myParent = theParent;
		this.transform = parentTransofrm;
		for (int i = 0; i < 4; i++)
			cursor[i] = myParent.loadImage("cursors/" + i + ".png");
	}

	// display cursors based on current interactive state
	void render() {
		int selected = transform.focusedQuadId();
		Polygon quad = transform.quads.get(selected);

		PVector diff = new PVector();
		PVector P = new PVector(myParent.mouseX, myParent.mouseY);
		myParent.ellipse(P.x, P.y, 3, 3);
		diff = PVector.sub(P, quad.anchor);
		myParent.imageMode(PConstants.CENTER);

		switch (quad.state) {
		case DRAG_FREE_LINE:
			myParent.noCursor();
			myParent.image(cursor[0], P.x, P.y);
			break;

		case SCALE_PROPORTIONALLY_LINE:
			myParent.noCursor();
			myParent.pushMatrix();
			myParent.translate(P.x, P.y);
			myParent.rotate(cursorAngle(diff));
			myParent.image(cursor[3], 0, 0);
			myParent.popMatrix();
			break;

		case ROTATE:
			myParent.noCursor();
			diff = PVector.sub(P, quad.anchor);
			myParent.pushMatrix();
			myParent.translate(P.x, P.y);
			myParent.rotate(rotateCursorAngle(diff));
			myParent.image(cursor[2], 0, 0);
			myParent.popMatrix();
			break;

		case DRAG_AREA:
			myParent.noCursor();
			myParent.image(cursor[1], P.x, P.y);
			break;

		case DRAG_FREE_POINT:
			myParent.noCursor();
			myParent.image(cursor[0], P.x, P.y);
			break;

		case SCALE_PORPORTIONALLY_POINT:
			myParent.noCursor();
			diff = PVector.sub(P, quad.anchor);
			myParent.pushMatrix();
			myParent.translate(P.x, P.y);
			myParent.rotate(cursorAngle(diff));
			myParent.image(cursor[3], 0, 0);
			myParent.popMatrix();
			break;

		case SCALE_FREE_POINT:
			myParent.noCursor();
			diff = PVector.sub(P, quad.anchor);
			myParent.pushMatrix();
			myParent.translate(P.x, P.y);
			myParent.rotate(cursorAngle(diff));
			myParent.image(cursor[3], 0, 0);
			myParent.popMatrix();
			break;
		case NONE:
			myParent.cursor();
		}
	}

	// display rotate cursor according to cursor-anchor angle
	// http://i.imgur.com/NG5pNH9.jpg
	// http://i.imgur.com/NG5pNH9.jpg

	float cursorAngle(PVector diff) {
		float angle = 0;
		float[] angles = { -PConstants.PI, -(PConstants.HALF_PI + PConstants.HALF_PI / 2), -PConstants.HALF_PI,
				-PConstants.HALF_PI / 2, 0, PConstants.HALF_PI / 2, PConstants.HALF_PI,
				PConstants.HALF_PI + PConstants.HALF_PI / 2, PConstants.PI };

		for (int i = 0; i < angles.length; i++) {
			if (diff.heading() > angles[i] && diff.heading() < angles[i + 1])
				angle = angles[i];
		}

		return angle;
	}

	// rotate cursor angle method to reduce angle to four simplified states
	float rotateCursorAngle(PVector diff) {
		float angle = 0;
		float[] angles = { -PConstants.PI, -PConstants.HALF_PI, 0, PConstants.HALF_PI, PConstants.PI };

		for (int i = 0; i < angles.length; i++) {
			if (diff.heading() > angles[i] && diff.heading() < angles[i + 1])
				angle = angles[i];
		}

		return angle;
	}

}

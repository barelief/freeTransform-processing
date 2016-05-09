/**
 *
 * Events class contains mouse and keyboard routines. They are enabled and disabled in FreeTransform.toggleTransform()
 * 
 * @author Bartosh Polonski
 * @version 0.3.0
 * @since 2016-04-30
 * 
 */

package bare.utils;

import processing.core.*;
import processing.event.KeyEvent;
import processing.event.MouseEvent;

public class Events {

	FreeTransform parentTransform;
	float scalingSensitivity = .05f;

	public Events(FreeTransform theParent) {
		parentTransform = theParent;
		// register();
	}

	public void register() {
		parentTransform.myParent.registerMethod("mouseEvent", this);
		parentTransform.myParent.registerMethod("keyEvent", this);
	}
	
	public void unregister() {
		parentTransform.myParent.unregisterMethod("mouseEvent", this);
		parentTransform.myParent.unregisterMethod("keyEvent", this);
	}


	public void mouseEvent(MouseEvent e) {

		// int x = e.getX();
		// int y = e.getY();
		// PVector mouse = new PVector(x, y);

		switch (e.getAction()) {

		case MouseEvent.PRESS:
			if (parentTransform.myParent.mouseButton == PConstants.LEFT) {
				// isSelected
				int focused = parentTransform.focusedQuadId();
				Polygon quad = parentTransform.quads.get(focused);
				//System.out.println("[notice ] state: " + quad.state);

				switch (quad.state) {

				case DRAG_FREE_LINE:
					quad.setupDragLines();
					quad.dragLock = true;
					break;

				case SCALE_PROPORTIONALLY_LINE:

					quad.setupLineScaleProportional();
					quad.dragLock = true;
					break;

				case ROTATE:
					// quad.setupPolygonRotate();
					// quad.dragLock = true;
					int selected = parentTransform.selectedQuadId();
					Polygon rotatingQuad = parentTransform.quads.get(selected);
					rotatingQuad.setupPolygonRotate();
					rotatingQuad.dragLock = true;
					break;

				case DRAG_AREA:
					quad.setupPolygonDrag();
					quad.dragLock = true;
					break;

				case DRAG_FREE_POINT:
					quad.setupDragPoint();
					quad.dragLock = true;
					break;

				case SCALE_PORPORTIONALLY_POINT:
					quad.setupScalePointProportionally();
					quad.dragLock = true;
					break;

				case SCALE_FREE_POINT:
					quad.setupPointScaleFree();
					quad.dragLock = true;
					break;
				default:
					break;
				}
			}

			break;

		case MouseEvent.DRAG:
			// System.out.print("drag");
			if (parentTransform.myParent.mouseButton == PConstants.LEFT) {
				int selected = parentTransform.selectedQuadId();
				Polygon quad = parentTransform.quads.get(selected);

				switch (quad.state) {
				case DRAG_FREE_LINE:
					quad.dragLines();
					// quad.lineScaleProportional();
					break;

				case SCALE_PROPORTIONALLY_LINE:
					quad.lineScaleProportional();
					break;

				case ROTATE:
					quad.rotatePolygon();
					break;

				case DRAG_AREA:
					quad.dragPolygon();
					break;

				case DRAG_FREE_POINT:
					quad.dragPoint();
					break;

				case SCALE_PORPORTIONALLY_POINT:
					quad.scalePointProportionally();
					break;

				case SCALE_FREE_POINT:
					quad.pointScaleFree();
					break;
				default:
					break;
				}
			}

			break;

		case MouseEvent.RELEASE:
			if (parentTransform.myParent.mouseButton == PConstants.LEFT)
				releaseQuad();
			// System.out.println("left mouse release");
			break;
			
		case MouseEvent.WHEEL:
			  // If SHIFT is pressed
			  int selected = parentTransform.selectedQuadId();
			  Polygon quad = parentTransform.quads.get(selected); 

			  if (quad.pointMode == 2) 
			    scalingSensitivity = .01f;
			  else scalingSensitivity = .05f;
			  float wheelDirection = e.getCount();
			  
			  if (wheelDirection < 0) quad.scaleArea(1-scalingSensitivity);
			  else quad.scaleArea(1+scalingSensitivity);

			  // update points after scaling area for next interactions
			  // for (int i=0; i<amount; i++)
			  // quad.updateGlobalPoints(i);

			  // reset locks and initial positions	
			  quad.release();
			break;
		}
	}

	public void keyEvent(KeyEvent e) {
		// System.out.println("keyPressed");

		switch (e.getAction()) {
		// if key was released
		case KeyEvent.RELEASE:
			// System.out.println("KEY Released");
			int selected = parentTransform.selectedQuadId();
			Polygon quad = parentTransform.quads.get(selected);

			if (!quad.dragLock) {
				// if no key is selected then return to deafault mode
				// (SCALE_FREE_POINT)
				quad.pointMode = 0;

				// return to dafault mode SCALE_PROPORTIONALLY_LINE
				quad.lineMode = 0;
				//
				quad.rotateMode = 0;
				// save current polygon points to external file
				parentTransform.savePoints();

			}
			break;

		// if key was pressed
		case KeyEvent.PRESS:

			selected = parentTransform.selectedQuadId();
			quad = parentTransform.quads.get(selected);
			// quad.selectedLine=key-49;
			switch (e.getKey()) {
			case 'r':
				parentTransform.resetQuad(); // reset
				// quad.setupValues(quad.values); // load resetted values
				break;
				
			case 'R':
				parentTransform.resetAllQuads(); 
				break;
				
			case 'a':
				parentTransform.addQuad();
				break;
				
			case 'x':
				// parentTransform.removeQuad(parentTransform.selectedQuadId());
				parentTransform.removeSelectedQuad();
				break;

			case 'd':
				quad.debugMode = !quad.debugMode;
				break;

			case 'h':
				parentTransform.helpMode = !parentTransform.helpMode;
				break;

			/*
			 * case 't': parentTransform.isEnabled = !parentTransform.isEnabled;
			 * if (!parentTransform.isEnabled) { quad.state = State.NONE; }
			 * break;
			 */

			case PConstants.CODED:
				switch (e.getKeyCode()) {
				case PConstants.CONTROL:
					quad.pointMode = 1; // state = DRAG_FREE_POINT
					quad.lineMode = 1; // state = DRAG_FREE_LINE

					break;

				case PConstants.SHIFT:
					quad.pointMode = 2; // state = SCALE_PORPORTIONALLY_POINT
					quad.rotateMode = 1; // rotate with a 45 degree step
					break;
				}
				break;
			case '+':
				quad.scaleArea(1+scalingSensitivity);
				break;
			case '-':
				quad.scaleArea(1-scalingSensitivity);
				break;

			case 1:
				quad.state = State.SCALE_PROPORTIONALLY_LINE;
				break;
			case 2:
				quad.state = State.DRAG_FREE_LINE;
				break;
			}

			break;
		}
	}

	// release quad locks
	void releaseQuad() {
		int selected = parentTransform.selectedQuadId();
		Polygon quad = parentTransform.quads.get(selected);
		quad.release(); // release all locks
		//
		parentTransform.savePoints(); // save current polygon points to external
										// file
	}
}

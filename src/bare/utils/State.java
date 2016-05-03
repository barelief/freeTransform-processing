/**
*
*    Mouse interaction states 
*
*    @author Bartosh Polonski
*    @version 0.prototype
*    @since 2015-09-13
* 
*/

package bare.utils;

public enum State {
	DRAG_FREE_POINT, // http://i.imgur.com/ChQASj4.gif while CTRL is pressed
	DRAG_FREE_LINE, // http://i.imgur.com/3LlgFqL.gif while CTRL is pressed
	DRAG_AREA, // drags all points
	SCALE_FREE_POINT, // http://i.imgur.com/qXuA8Pa.gif
	SCALE_PORPORTIONALLY_POINT, // http://i.imgur.com/0q5vWsN.gif when SHIFT pressed
	SCALE_PROPORTIONALLY_LINE, // http://i.imgur.com/VnX6EWr.gif 
	ROTATE, // rotates all points when outside the polygon area
	NONE
}
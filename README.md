# Free Transform for Processing

## About

Scale, rotate and variously transform textures (PImage, PGraphics). Transformations are automatically saved and loaded after restarting the sketch. Tested against Processing 3+ and windows

![Ft](http://i.imgur.com/FxJHjKs.png)

https://vid.me/5Psa

## Usage

```
import bare.utils.*;
FreeTransform hello;
PImage img;

void setup() {
  size(777, 500, P3D);
  hello = new FreeTransform(this);
  img = loadImage("moon.png");
}

void draw() 
{
  background(100);
  hello.render(0, img);
  hello.draw();
}


```

## Get the library 

1. Download library here: [Releases](https://github.com/barelief/freeTransform-processing/releases) 
2. copy it to your Processing libraries forlder 

or 

use built-in [PDE Contribution Manager](http://i.imgur.com/DlSQZ4B.png)

## Need your feedback

As for now, libray has been tested against Processing 3+ and windows 10. Please test on other platforms give feedback in [Issues](https://github.com/barelief/freeTransform-processing/issues). 

Feel free to optimize or add new features. 

This lib needs your comments, code optimization and other improvemens. 

Check [Prototypes](https://github.com/barelief/freeTransform-processing/tree/master/prototypes) to see how FreeTransform is constructed from separate sketches 

Please use it and give feedback in [Issues](https://github.com/barelief/freeTransform-processing/issues) section

See [Roadmap](https://github.com/barelief/freeTransform-processing/tree/master#roadmap) for details

Thank you!

## Roadmap
* ~~0.1 transform one object~~
* ~~0.2 transform ArrayList of objects~~
* ~~0.3 save coordinates of ArrayList quads~~
* ~~0.4 add/remove Quad interactively (+interactive image loading)~~
* 0.5 homography [[Issue #9](https://github.com/barelief/freeTransform-processing/issues/9)]
* 0.7 snapping
* 0.8 select multiple (also scale/move/rotate) - maybe..
* 0.9 ctrl-Z

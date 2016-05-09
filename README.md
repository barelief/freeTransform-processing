# Free Transform for Processing

## About

Scale, rotate and variously transform textures (PImage, PGraphics) 

Transformations are automatically saved

![Ft](http://i.imgur.com/FxJHjKs.png)

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

Download library here: [Releases](https://github.com/barelief/freeTransform-processing/releases)

## How to use

Copy it to your libraries forlder 
~~or use built-in Contribution Manager [screenshot link]~~

## Call to action

Feel free to optimize or add new features. 

This lib needs your comments, code optimization, other improvemens. 

Check [Prototypes](https://github.com/barelief/freeTransform-processing/tree/master/prototypes) to see how FreeTransform is constructed from separate sketches 

Please use it and give feedback in [Issues](https://github.com/barelief/freeTransform-processing/issues) section

See [Roadmap](https://github.com/barelief/freeTransform-processing/tree/master#roadmap) for details


Thank you!

## Roadmap
* ~~0.1 transform one object~~
* ~~0.2 transform ArrayList of objects~~
* ~~0.3 save coordinates of ArrayList quads~~
* 0.4 add/remove Quad interactively (+interactive image loading)
* 0.5 homography
* 0.7 snapping
* 0.8 select multiple (also scale/move/rotate) - maybe..
* 0.9 ctrl-Z

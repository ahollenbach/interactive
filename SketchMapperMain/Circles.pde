// P_2_2_3_02_TABLET.pde
//
// This is a Generative Gestaltung piece adapted to the SketchMapper tool.
//
// Generative Gestaltung, ISBN: 978-3-87439-759-9
// First Edition, Hermann Schmidt, Mainz, 2009
// Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
// Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
* form mophing process by connected random agents
* two forms: circle and line
*
* MOUSE
* click               : start a new circe
* position x/y        : direction and speed of floating
*
* TABLET
* pressure            : step size
*
* KEYS
* 1-2                 : fill styles
* 3-4                 : form styles circle/line
* f                   : freeze. loop on/off
* Delete/Backspace    : clear display
* s                   : save png
* r                   : start pdf recording
* e                   : stop pdf recording
*/

import generativedesign.*;
import processing.pdf.*;
import java.util.Calendar;

public class Circles extends AbstractSketch {

    int formResolution = 15;
    float stepSize = 2;
    float initRadius = 100;
    float centerX, centerY;
    float[] x = new float[formResolution];
    float[] y = new float[formResolution];

    boolean filled = false;
    boolean freeze = false;
    int mode = 0;
    
    // change directions
    float targetX = 0;
    float targetY = 0;
    int countdown = 0;
    float lastLvl = 0;

    private String name;
    private float scaling;

    public Circles(final PApplet parent, String name, final int width, final int height, float scaling) {
        super(parent, width, height);

        this.name = name;
        this.scaling = scaling;
    }

    @Override
    void setup(){
      graphics.beginDraw();
      graphics.background(255);
      graphics.fill(255);
      graphics.rect(0, 0, graphics.width, graphics.height);
      graphics.endDraw();

      // init form
      centerX = graphics.width/2;
      centerY = graphics.height/2;
      float angle = radians(360/float(formResolution));
      for (int i=0; i<formResolution; i++){
        x[i] = cos(angle*i) * initRadius;
        y[i] = sin(angle*i) * initRadius;
      }
    }


    void draw(){
      graphics.beginDraw();

      graphics.stroke(0, 50);

      // get audio level
      //float lvl = map(SketchMapperMain.in.mix.level(),0,1,0,3);
      float lvl = SketchMapperMain.in.mix.level()*scaling;
      lvl = (lastLvl + lvl) / 2; // smoothing
      float lvlGamma = gamma(SketchMapperMain.in.mix.level()*1.1, 1.2);
      // map audio level to step size
      stepSize = map(lvlGamma, 0,1, 1,1.5);

      // floating towards mouse position
      if(countdown == 0) {
        targetX = random(0,displayWidth/2);
        targetY = random(0,displayHeight/2);
        countdown = (int)random(20,50);
        
        // move a little bit with smoothing, then add a base movement speed
        centerX += (targetX-centerX) * lvl * 0.02 + ((int) Math.signum(targetX-centerX)) * 0.2;
        centerY += (targetY-centerY) * lvl * 0.02 + ((int) Math.signum(targetY-centerY)) * 0.2;
      } else {
        countdown--;
        
        centerX += (targetX-centerX) * lvl * 0.02 + ((int) Math.signum(targetX-centerX)) * 0.2;
        centerY += (targetY-centerY) * lvl * 0.02 + ((int) Math.signum(targetX-centerX)) * 0.2;
      }

      // calculate new points
      for (int i=0; i<formResolution; i++){
        x[i] += random(-stepSize,stepSize);
        y[i] += random(-stepSize,stepSize);
        // ellipse(x[i],y[i],5,5);
      }

      graphics.strokeWeight(0.75);
      if (filled) graphics.fill(random(255));
      else graphics.noFill();

      if (mode == 0) {
        graphics.beginShape();
        // start controlpoint
        graphics.curveVertex(x[formResolution-1]+centerX, y[formResolution-1]+centerY);

        // only these points are drawn
        for (int i=0; i<formResolution; i++){
          graphics.curveVertex(x[i]+centerX, y[i]+centerY);
        }
        graphics.curveVertex(x[0]+centerX, y[0]+centerY);

        // end controlpoint
        graphics.curveVertex(x[1]+centerX, y[1]+centerY);
        graphics.endShape();
      }

      if (mode == 1) {
        graphics.beginShape();
        // start controlpoint
        graphics.curveVertex(x[0]+centerX, y[0]+centerY);

        // only these points are drawn
        for (int i=0; i<formResolution; i++){
          graphics.curveVertex(x[i]+centerX, y[i]+centerY);
        }

        // end controlpoint
        graphics.curveVertex(x[formResolution-1]+centerX, y[formResolution-1]+centerY);
        graphics.endShape();
      }

      graphics.endDraw();

    }


    void mousePressed() {
      /*
      // init forms on mouse position
      centerX = mouseX;
      centerY = mouseY;

      // circle
      if (mode == 0) {
        centerX = mouseX;
        centerY = mouseY;
        float angle = radians(360/float(formResolution));
        float radius = initRadius * random(0.5,1.0);
        for (int i=0; i<formResolution; i++){
          x[i] = cos(angle*i) * radius;
          y[i] = sin(angle*i) * radius;
        }
      }

      // line
      if (mode == 1) {
        centerX = mouseX;
        centerY = mouseY;
        float radius = initRadius * random(0.5,5.0);
        float angle = random(PI);
        float x1 = cos(angle) * radius;
        float y1 = sin(angle) * radius;
        float x2 = cos(angle-PI) * radius;
        float y2 = sin(angle-PI) * radius;
        for(int i=0; i<formResolution; i++) {
          x[i] = lerp(x1, x2, i/(float)formResolution);
          y[i] = lerp(y1, y2, i/(float)formResolution);
        }
      }*/
    }

    // gamma ramp, non linear mapping ...
    float gamma(float theValue, float theGamma) {
      return pow(theValue, theGamma);
    }

    @Override
    public void keyEvent(KeyEvent event) {
      if (key == DELETE || key == BACKSPACE) background(255);

      if (key == 'f') filled = !filled; // flip filled/not-filled
      if (key == 'm') mode = ++mode%2;  // flip mode between 0 and 1

      // switch draw loop on/off
      //if (key == 'f' || key == 'F') freeze = !freeze;
      if (freeze == true) noLoop();
      else loop();
    }

    @Override
    public void mouseEvent(MouseEvent event) {
      // Doesn't work?
    }

    @Override
    public String getName() {
        return this.name;
    }
}

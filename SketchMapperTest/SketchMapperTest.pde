import javax.media.jai.*;
import jto.processing.sketch.mapper.*;
import com.sun.media.jai.util.*;
import ixagon.surface.mapper.*;
import ddf.minim.*;

private SketchMapper sketchMapper;
Minim minim;
AudioInput in;

public void setup() {
  size(displayWidth, displayHeight, OPENGL);
  if (frame != null) {
    frame.setResizable(true);
  }

  // Set up audio processing
  minim = new Minim(this);
  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn();
  
  sketchMapper = new SketchMapper(this);
  sketchMapper.addSketch(new TestSketch(this, width / 2, height / 2, minim, in));

  
}

public void draw() {
  sketchMapper.draw();
}



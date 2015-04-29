import javax.media.jai.*;
import jto.processing.sketch.mapper.*;
import com.sun.media.jai.util.*;
import ixagon.surface.mapper.*;
import ddf.minim.*;

private SketchMapper sketchMapper;

private Minim minim;
private AudioInput in;

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
  
  // Add different sketch options
  sketchMapper.addSketch(new Levelizer(this, "Levelizer - Yellow", width / 2, height / 2, minim, in, color(240,242,166)));
  sketchMapper.addSketch(new Levelizer(this, "Levelizer - Pink", width / 2, height / 2, minim, in, color(224,222,250)));
  sketchMapper.addSketch(new Equalizer(this, "Equalizer - Pink", width / 2, height / 2, minim, in, color(224,222,250)));
  sketchMapper.addSketch(new Circles(this, "Circles", width / 2, height / 2, minim, in));
  sketchMapper.addSketch(new Wanderers(this, "Wanderers", width / 2, height / 2, minim, in));
  sketchMapper.addSketch(new NewTest(this, "New", width / 2, height / 2, minim, in));

}

public void draw() {
  sketchMapper.draw();
}

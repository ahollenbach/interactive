import javax.media.jai.*;
import jto.processing.sketch.mapper.*;
import com.sun.media.jai.util.*;
import ixagon.surface.mapper.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

private SketchMapper sketchMapper;

// Make all these available to the sketches, so we process once
public static Minim minim;
public static AudioInput in;
public static FFT fft;

public void setup() {
  size(displayWidth, displayHeight, OPENGL);
  if (frame != null) {
    frame.setResizable(true);
  }

  // Set up audio processing
  minim = new Minim(this);
  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn();

  // Set up FFT
  fft = new FFT(in.bufferSize(), in.sampleRate());
  //fft.logAverages(11,12);


  // And lastly, set up SketchMapper
  sketchMapper = new SketchMapper(this);

  // Add different sketch options
  sketchMapper.addSketch(new Levelizer(this, "Levelizer - Yellow", width / 2, height / 2, color(240,242,166)));
  sketchMapper.addSketch(new Levelizer(this, "Levelizer - Pink", width / 2, height / 2, color(224,222,250)));
  sketchMapper.addSketch(new Equalizer(this, "Equalizer - Pink", width / 2, height / 2, color(224,222,250)));
  sketchMapper.addSketch(new Circles(this, "Circles", width / 2, height / 2));
  sketchMapper.addSketch(new Wanderers(this, "Wanderers", width / 2, height / 2));
  sketchMapper.addSketch(new WanderingCircles(this, "WanderingCircles", width / 2, height / 2));
  sketchMapper.addSketch(new SpinningSquares(this, "Spinning Squares", width / 2, height / 2));

}

public void draw() {
  // Process the audio for this cycle
  // This way each sketch does not have to track its own FFT
  fft.forward(in.mix);

  sketchMapper.draw();
}

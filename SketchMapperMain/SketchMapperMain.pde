import javax.media.jai.*;
import jto.processing.sketch.mapper.*;
import com.sun.media.jai.util.*;
import ixagon.surface.mapper.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

private SketchMapper sketchMapper;
private int[] curSurfaceId;

// Make all these available to the sketches, so we process once
public static Minim minim;
public static AudioInput in;
public static BeatDetect beat;
public static FFT fft;
public static int numSamples;

public void setup() {
  size(displayWidth, displayHeight, OPENGL);
  if (frame != null) {
    frame.setResizable(true);
  }
  
  curSurfaceId = new int[20]; // no more than 20 surfaces! TODO no.

  // Set up audio processing
  minim = new Minim(this);
  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn();
  
  beat = new BeatDetect();
  beat.setSensitivity(50);

  // Set up FFT
  fft = new FFT(in.bufferSize(), in.sampleRate());
  fft.logAverages(11,12);
  numSamples = 8*11;


  // And lastly, set up SketchMapper
  sketchMapper = new SketchMapper(this);

  // Add different sketch options
  sketchMapper.addSketch(new Levelizer(this, "Levelizer - Yellow", width / 2, height / 2, color(240,242,166)));
  sketchMapper.addSketch(new Levelizer(this, "Levelizer - Pink", width / 2, height / 2, color(224,222,250)));
  sketchMapper.addSketch(new BassDrum(this, "Bass Drum - Pink", width / 2, height / 2, color(224,222,250)));
  sketchMapper.addSketch(new Equalizer(this, "Equalizer - Pink", width / 2, height / 2, color(224,222,250)));
  sketchMapper.addSketch(new Circles(this, "Circles", width / 2, height / 2));
  sketchMapper.addSketch(new Wanderers(this, "Wanderers", width / 2, height / 2));
  sketchMapper.addSketch(new WanderingCircles(this, "WanderingCircles", width / 2, height / 2));
  sketchMapper.addSketch(new SpinningSquares(this, "Spinning Squares", width / 2, height / 2));
  sketchMapper.addSketch(new Repulse(this, "Repulse - Blue", width / 2, height / 2, new int[]{28,100,69,140,135,170}));
  sketchMapper.addSketch(new Repulse(this, "Repulse - Blue/Yellow", width / 2, height / 2, new int[]{28,240,69,202,135,65}));
}

public void draw() {
  // Process the audio for this cycle
  // This way each sketch does not have to track its own FFT
  fft.forward(in.mix);
  SketchMapperMain.beat.detect(SketchMapperMain.in.mix);

  sketchMapper.draw();
}

public void keyPressed(KeyEvent event) {
  // if we click a number button, it corresponds to that surface and cycles
  if (event.getKeyCode() >= 48 && event.getKeyCode() <= 57) {
    int i = event.getKeyCode() - 48;
    
    // Don't accept if we don't have a surface
    if(i >= sketchMapper.getSurfaces().size()) return;
    
    System.out.println(i + " " + curSurfaceId[i]);
    // gets the ith surface (the number we clicked), and moves to the next sketch in the list.
    curSurfaceId[i] = (curSurfaceId[i] + 1)%sketchMapper.getSketchList().size();
    System.out.println(curSurfaceId[i]);
    sketchMapper.getSurfaces().get(i).setSketch(sketchMapper.getSketchList().get(curSurfaceId[i]));
  }
}



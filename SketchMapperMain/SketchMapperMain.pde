import javax.media.jai.*;
import jto.processing.sketch.mapper.*;
import com.sun.media.jai.util.*;
import java.util.*;
import java.awt.Rectangle;
import ixagon.surface.mapper.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

private SketchMapper sketchMapper;
private int[] sketchOnSurface;
private int[][] surfaceBounds;

// Make all these available to the sketches, so we process once
public static Minim minim;
public static AudioInput in;
public static BeatDetect beat;
public static FFT fft;
public static int numSamples;

public ArrayList<Movie> videos;

public void setup() {
  size(displayWidth, displayHeight, OPENGL);
  if (frame != null) {
    frame.setResizable(true);
  }
  
  videos = new ArrayList<Movie>();
  sketchOnSurface = new int[10]; // no more than 10 surfaces! TODO no.
  surfaceBounds = new int[10][2];

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
  
  loadVideos(sketchMapper);

  // Add different sketch options
  sketchMapper.addSketch(new Levelizer       (this, "Levelizer - Yellow", width/2, height/2, 1.5,   color(240,242,166)));
  sketchMapper.addSketch(new Levelizer       (this, "Levelizer - Pink",   width/2, height/2, 1.5,   color(224,222,250)));
  sketchMapper.addSketch(new BassDrum        (this, "Bass Drum - Pink",   width/2, height/2, 0.015, color(224,222,250)));
  sketchMapper.addSketch(new Equalizer       (this, "Equalizer - Pink",   width/2, height/2, 4,     color(224,222,250)));
  sketchMapper.addSketch(new Circles         (this, "Circles",            width/2, height/2, 3      ));
  sketchMapper.addSketch(new WanderingCircles(this, "WanderingCircles",   width/2, height/2, 4      ));
  sketchMapper.addSketch(new SpinningSquares (this, "Spinning Squares",   width/2, height/2, 6      ));
  sketchMapper.addSketch(new Repulse         (this, "Repulse - Blue",     width/2, height/2, 3,     new int[]{28,100,69,140,135,170}));
  sketchMapper.addSketch(new Repulse         (this, "Repulse - Rainbow",  width/2, height/2, 3,     new int[]{28,240,69,202,135,65}));
  
}

public void loadVideos(SketchMapper sketchMapper) {
  // Adapted from SurfaceMapperGUI
  String[] imageTypes = {"jpg","jpeg","png","gif","bmp"};
  String[] movieTypes = {"mp4","mov","avi"};
  
  // sketchPath + "/data/videos"
  File file = new File(sketchPath + "/data/videos");
  File[] files = file.listFiles();
  
  for(int i=0; i<files.length; i++) {
    // Get and split the filename
    String filename = files[i].getName();
    String[] filenameParts = split(filename,".");
    
    if(filenameParts.length < 2) continue;

    // Check to see if file is an image
    boolean isImage = false;
    boolean isMovie = false;
    for(int j=0; j<movieTypes.length; j++) {
//      if(filenameParts[1].equals(imageTypes[j])) {
//        isImage = true;
//      } else 
      if (filenameParts[1].toLowerCase().equals(movieTypes[j])) {
        isMovie = true;
        Movie m = new Movie(this, sketchPath + "/data/videos/" + filename);
        videos.add(m);
        sketchMapper.addSketch(new MovieSketch(this, "Movie - " + filename, width, height, m));
      }
    }
  }
}

public void draw() {
  // Process the audio for this cycle
  // This way each sketch does not have to track its own FFT
  fft.forward(in.mix);
  SketchMapperMain.beat.detect(SketchMapperMain.in.mix);

  sketchMapper.draw();
}

public void keyPressed(KeyEvent event) {
  // run once, if unset
  // TODO check whether are entering render or no
  if(surfaceBounds[0][0] == 0) {
    setSurfaceRatios();
  }
  //System.out.println(surfaceBounds[0][0] + " " + surfaceBounds[0][1]);
  // if we click a number button, it corresponds to that surface and cycles
  if (event.getKeyCode() >= 48 && event.getKeyCode() <= 57) {
    int i = event.getKeyCode() - 48;
    
    // Don't accept if we don't have a surface for it
    if(i >= sketchMapper.getSurfaces().size()) return;
    
    // gets the ith surface (the number we clicked), and moves to the next sketch in the list.
    sketchMapper.getSketchList().get(sketchOnSurface[i]).unfocus(); // notify that a sketch is being hidden. Super important for performance with video.
    sketchOnSurface[i] = (sketchOnSurface[i] + 1)%sketchMapper.getSketchList().size();
    sketchMapper.getSurfaces().get(i).setSketch(sketchMapper.getSketchList().get(sketchOnSurface[i]));
    // Set dimensions for the sketch given the surface dimensions
    AbstractSketch s = (AbstractSketch) sketchMapper.getSketchList().get(sketchOnSurface[i]);
    s.setDimensions(surfaceBounds[i][0],surfaceBounds[i][1]);
    s.focus();
  } else if(event.getKey() == ' ') {
    // TODO tmp fix to set bounds for everything
    // Set dimensions for the sketch given the surface dimensions
    for(int i=0;i<10;i++) {
      AbstractSketch s = (AbstractSketch) sketchMapper.getSketchList().get(sketchOnSurface[i]);
      s.setDimensions(surfaceBounds[i][0],surfaceBounds[i][1]);
    }
  }
}

public void setSurfaceRatios() {
  List<SuperSurface> surfaces = sketchMapper.getSurfaces();
  for (int i=0;i<surfaces.size();i++) {
    SuperSurface s = surfaces.get(i);
    Rectangle bounds = s.getPolygon().getBounds();
    surfaceBounds[i][0] = bounds.width;
    surfaceBounds[i][1] = bounds.height;
  }
}

void movieEvent(Movie movie) {
  movie.read();
}


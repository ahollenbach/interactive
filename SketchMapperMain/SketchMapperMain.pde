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

public ArrayList<Movie> videos;

public void setup() {
  size(displayWidth, displayHeight, OPENGL);
  if (frame != null) {
    frame.setResizable(true);
  }
  
  videos = new ArrayList<Movie>();
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
  
  loadVideos(sketchMapper);

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
        sketchMapper.addSketch(new MovieSketch(this, "Movie - " + filename, width / 2, height / 2, m));
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
  // if we click a number button, it corresponds to that surface and cycles
  if (event.getKeyCode() >= 48 && event.getKeyCode() <= 57) {
    int i = event.getKeyCode() - 48;
    
    // Don't accept if we don't have a surface
    if(i >= sketchMapper.getSurfaces().size()) return;
    
    // gets the ith surface (the number we clicked), and moves to the next sketch in the list.
    curSurfaceId[i] = (curSurfaceId[i] + 1)%sketchMapper.getSketchList().size();
    sketchMapper.getSurfaces().get(i).setSketch(sketchMapper.getSketchList().get(curSurfaceId[i]));
  }
}

void movieEvent(Movie movie) {
  movie.read();
}


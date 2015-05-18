import javax.media.jai.*;
import jto.processing.sketch.mapper.*;
import com.sun.media.jai.util.*;
import java.util.*;
import java.awt.Rectangle;
import ixagon.surface.mapper.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

private SketchMapper sketchMapper;
public AbstractSketch[] sketchOnSurface;
public int[][] surfaceBounds;

// Make all these available to the sketches, so we process once
public static Minim minim;
public static AudioInput in;
public static BeatDetect beat;
public static FFT fft;
public static int numSamples;

boolean isCtrlPressed = false;
static boolean hideAllOutput = false;
boolean[] keysPressed;

public ArrayList<Movie> videos;
public HashMap<String, AbstractSketch> sketches;
public String[][] queue;
public int[] queueIt;

public void setup() {
  size(displayWidth, displayHeight, OPENGL);
  if (frame != null) {
    frame.setResizable(true);
  }
  
  videos = new ArrayList<Movie>();
  sketchOnSurface = new AbstractSketch[10]; // no more than 10 surfaces! TODO no.
  surfaceBounds = new int[10][2];
  keysPressed = new boolean[10];

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
  
  sketches = new HashMap<String,AbstractSketch>();
  loadVideos(sketchMapper);

  // Add different sketch options
  
  sketches.put("Levelizer - Yellow", new Levelizer       (this, "Levelizer - Yellow", width/2, height/2, 1.5,   color(240,242,166)));
  sketches.put("Levelizer - Pink",   new Levelizer       (this, "Levelizer - Pink",   width/2, height/2, 1.5,   color(224,222,250)));
  sketches.put("Bass Drum - Pink",   new BassDrum        (this, "Bass Drum - Pink",   width/2, height/2, 0.015, color(224,222,250)));
  sketches.put("Equalizer - Pink",   new Equalizer       (this, "Equalizer - Pink",   width/2, height/2, 4,     color(224,222,250)));
  sketches.put("Circles",            new Circles         (this, "Circles",            width/2, height/2, 3      ));
  sketches.put("WanderingCircles",   new WanderingCircles(this, "WanderingCircles",   width/2, height/2, 4      ));
  sketches.put("Spinning Squares",   new SpinningSquares (this, "Spinning Squares",   width/2, height/2, 6      ));
  sketches.put("Repulse - Blue",     new Repulse         (this, "Repulse - Blue",     width/2, height/2, 3,     new int[]{28,100,69,140,135,170}));
  sketches.put("Repulse - Rainbow",  new Repulse         (this, "Repulse - Rainbow",  width/2, height/2, 3,     new int[]{28,240,69,202,135,65}));
  
  // Add them to sketchMapper
  Iterator it = sketches.entrySet().iterator();
  while (it.hasNext()) {
      Map.Entry pair = (Map.Entry)it.next();
      sketchMapper.addSketch((AbstractSketch)pair.getValue());
  }
  
  loadSurfaceQueues();
}

public void loadSurfaceQueues() {
  queue = new String[10][];
  queueIt = new int[10];
  
  
//  queue[0] = new String[]{"Repulse - Blue","1shadow","9sand"};
//  queue[1] = new String[]{"5Clouds","WanderingCircles"};
  
//  queue[0] = new String[]{};
//  queue[1] = new String[]{};
//  queue[2] = new String[]{};
//  queue[3] = new String[]{};
//  queue[4] = new String[]{"7underwater", "3shadow", "4shadow"};
//  queue[5] = new String[]{"9sand", "12Underwater", "10underwater_ripples"};
  
  queue[0] = new String[]{"14Color Circles"};
  queue[1] = new String[]{"5Clouds", "6Floating fire", "11Gold_Box"};
  queue[2] = new String[]{"15Hand Shadow"};
  queue[3] = new String[]{"2shadow"};
  queue[4] = new String[]{"10underwater_ripples", "13blackink"};
  
  for(int i=0;i<5;i++) { // TODO not hardcode this value
    sketchOnSurface[i] = sketches.get(queue[i][0]);
  }
}

public void loadVideos(SketchMapper sketchMapper) {
  // Adapted from SurfaceMapperGUI
  String[] imageTypes = {"jpg","jpeg","png","gif","bmp"};
  String[] movieTypes = {"mp4","mov","avi"};
  
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
        sketches.put(filenameParts[0], new MovieSketch(this, "Movie - " + filename, width, height, m));
        //sketchMapper.addSketch(new MovieSketch(this, "Movie - " + filename, width, height, m));
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
  if (event.getKey() == 'p') {
    hideAllOutput = !hideAllOutput;
  }
  //System.out.println(event.getKeyCode());
  if (event.getKeyCode() == 17 && isCtrlPressed == false) isCtrlPressed = true;
  
  // run once, if unset
  // TODO check whether are entering render or no
  if(surfaceBounds[0][0] == 0) {
    setSurfaceRatios();
  }
  //System.out.println(surfaceBounds[0][0] + " " + surfaceBounds[0][1]);
  // if we click a number button, it corresponds to that surface and cycles
  if (event.getKeyCode() >= 48 && event.getKeyCode() <= 57) {
    int i = event.getKeyCode() - 48;
    keysPressed[i] = true;
    
    // Don't accept if we don't have a surface for it
    if(i >= sketchMapper.getSurfaces().size()) return;
    
    if(isCtrlPressed) {
      // toggle visibility of surface
      AbstractSketch s = sketchOnSurface[i];
      s.hideOutput = !s.hideOutput;
      return;
    }
    System.out.println(i + " " + sketchOnSurface[0]);
    // gets the ith surface (the number we clicked), and moves to the next sketch in the list.
    sketchOnSurface[i].unfocus(); // notify that a sketch is being hidden. Super important for performance with video.
    queueIt[i] += 1;
    queueIt[i] = queueIt[i]%queue[i].length;
    //sketchOnSurface[i] = queueIt[i]%queue[i].length;
    System.out.println(queue[i][queueIt[i]] + " " + queueIt[i]);
    sketchOnSurface[i] = sketches.get(queue[i][queueIt[i]]);
    
    //sketchOnSurface[i] = (sketchOnSurface[i] + 1)%sketchMapper.getSketchList().size();
    //sketchMapper.getSurfaces().get(i).setSketch(sketchMapper.getSketchList().get(sketchOnSurface[i]));
    sketchMapper.getSurfaces().get(i).setSketch(sketchOnSurface[i]);
    
    
    // Set dimensions for the sketch given the surface dimensions
    AbstractSketch s = sketchOnSurface[i];
    s.focus();
  } else if(event.getKey() == ' ') {
    setSurfaceRatios();
  }
}

void keyReleased(Event event) {
  if (keyCode == 17 && isCtrlPressed == true) isCtrlPressed = false;
  
  if (keyCode >= 48 && keyCode <= 57) {
    int i = keyCode - 48;
    keysPressed[i] = false;
  }
}

public void setSurfaceRatios() {
  List<SuperSurface> surfaces = sketchMapper.getSurfaces();
  for (int i=0;i<surfaces.size();i++) {
    SuperSurface s = surfaces.get(i);
    Rectangle bounds = s.getPolygon().getBounds();
    surfaceBounds[i][0] = bounds.width;
    surfaceBounds[i][1] = bounds.height;
    //s.setDimensions(surfaceBounds[i][0],surfaceBounds[i][1]);
  }
}

void movieEvent(Movie movie) {
  movie.read();
}


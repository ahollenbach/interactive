import processing.video.*;

public class MovieSketch extends AbstractSketch {
    private String name;
    
    final static float sourceRatio = 1920.0/1080;
    float aspectRatio;
    int startX;
    int startY;
    int targetWidth;
    int targetHeight;
    Movie movie;
    
    boolean init = false;
    
    // File types that are accepted as textures
    String[] imageTypes = {"jpg","jpeg","png","gif","bmp"};
    String[] movieTypes = {"mp4","mov","avi"};

    public MovieSketch(final PApplet parent, String name, final int width, final int height, Movie movie) {
        super(parent, width, height);

        this.name = name;
        this.movie = movie;
    }
    
    @Override
    public void setup() {
    }

    @Override
    public void draw() {
      if(hideOutput || SketchMapperMain.hideAllOutput) {
        graphics.beginDraw();
        graphics.background(0);
        graphics.endDraw();
        return;
      }
      
        if(!init) focus();
      
        graphics.beginDraw();
        graphics.background(0);
          
        PImage curFrame;
        // Crop using our already-figured-out ratios
        curFrame = movie.get(startX,startY,targetWidth,targetHeight);
        //PImage test = loadImage("test.png");
        //curFrame = test.get(startX,startY,targetWidth,targetHeight);
        
        // Scale to fill window
        curFrame.resize(Math.round(graphics.width),Math.round(graphics.height));
        
        // Place on screen
        graphics.image(curFrame, 0,0);
        
        graphics.endDraw();
    }

    @Override
    public void focus() {
      init = true;
      movie.loop();
      
      if(this.sWidth == 0) this.sWidth = graphics.width;
      if(this.sHeight == 0) this.sHeight = graphics.height;
      
      aspectRatio = float(this.sWidth)/this.sHeight;
      //System.out.println(this.sWidth + " " + this.sHeight + " " + aspectRatio);
      if (aspectRatio > 1) {
        // scale to fill width, lose some vertical
        targetWidth = graphics.width;
        targetHeight = Math.round(this.sHeight);
        startX = 0;
        startY = Math.round((targetWidth/sourceRatio)/2 - targetHeight/2);;
      } else {
        // scale to fill height, lose some width
        targetWidth = Math.round(this.sWidth); // +50 accounts for some math error TODO no.
        targetHeight = graphics.height;
        startX = Math.round(targetHeight*sourceRatio/2 - targetWidth/2);
        startY = 0;
      }
      //System.out.println(startX + " " + startY + " " + targetWidth + " " + targetHeight);
    }
    
    @Override
    public void unfocus() {
      movie.stop();
    }
    
    
    @Override
    public void keyEvent(KeyEvent event) {
      //System.out.println("movie key"); // works
//      if(event.getKey() == ' ') {
//        if(moviesPlaying) {
//          for(int i=0; i<movies.size(); i++) {
//            GSMovie movie = movies.get(i);
//            movie.pause();
//            movie.jump(0);
//          }
//          moviesPlaying = false;
//        } else {
//          for(int i=0; i<movies.size(); i++) {
//            GSMovie movie = movies.get(i);
//            movie.loop();
//          }
//          moviesPlaying = true;
//        }
//      }
    }

    @Override
    public void mouseEvent(MouseEvent event) {

    }

    @Override
    public String getName() {
        return this.name;
    }
}

import processing.video.*;

public class MovieSketch extends AbstractSketch {
    private String name;
    
    Movie movie;
    PImage img;
    
    boolean moviesPlaying = false;
    
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
      movie.loop();
      
      //img = loadImage("arc.jpg");
    }

    @Override
    public void draw() {
        graphics.beginDraw();
        graphics.background(255);
        //graphics.clear(0);
        

          //tint(255, 20);
          //graphics.rect(graphics.width/2, graphics.height/2,10,10);
          graphics.image(movie, 0,0);
          //graphics.image(img,0,0);
          
          graphics.endDraw();
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

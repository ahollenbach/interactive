import processing.opengl.*;

public class Movie extends AbstractSketch {
    private String name;
    
    // ArrayLists for textures, movies and lookups
    ArrayList<GLTexture> textures;          // Actual textures
    ArrayList<String> textureNames;         // File names of textures
    ArrayList<Integer> textureLookup;       // Associates surfaces (ID) to texture index
    ArrayList<GSMovie> movies;              // All videos in textures folder
    ArrayList<Integer> movieTextureLookup;  // Associates videos to textures
    
    public static final String LOAD_LAYOUT_HANDLER_METHOD_NAME = "loadLayoutHandler";
    public static final String SAVE_LAYOUT_HANDLER_METHOD_NAME = "saveLayoutHandler";
    
    boolean moviesPlaying = false;
    
    // File types that are accepted as textures
    String[] imageTypes = {"jpg","jpeg","png","gif","bmp"};
    String[] movieTypes = {"mp4","mov","avi"};

    public Movie(final PApplet parent, String name, final int width, final int height) {
        super(parent, width, height);

        this.name = name;
    }
    
    @Override
    public void setup() {
      // Initialize texture ArrayLists
      textures = new ArrayList();
      textureNames = new ArrayList();
      textureLookup = new ArrayList();
      movies = new ArrayList();
      movieTextureLookup = new ArrayList();
    
      // Create reference to default texture for first quad
      textureLookup.add(0);
    
      loadTextures();
    }

    @Override
    public void draw() {
        graphics.beginDraw();
        graphics.background(0);
        graphics.clear(0);
        graphics.endDraw();
        
        // Update every texture (gets all new frames from movies)
        for(int i=0; i<textures.size(); i++) {
          GLTexture tex = textures.get(i);
          tex.putPixelsIntoTexture();
        }
        
        // Render each surface to the GLOS using their textures
        for(SuperSurface ss : sm.getSurfaces()) {
          ss.render(glos, textures.get(textureLookup.get(ss.getId())));
        }
        
        image(glos.getTexture(),0,0,width,height);
    }
    
    void loadTextures() {
      // Load all textures from texture folder
      File file = new File(sketchPath + "/data/textures");
    
      if(file.isDirectory()) {
        File[] files = file.listFiles();
    
        for(int i=0; i<files.length; i++) {
          // Get and split the filename
          String filename = files[i].getName();
          String[] filenameParts = split(filename,".");
    
          // Check to see if file is an image
          boolean isImage = false;
          for(int j=0; j<imageTypes.length; j++)
            if(filenameParts[1].equals(imageTypes[j]))
              isImage = true;
    
          // Check to see if file is a movie
          boolean isMovie = false;
          if(!isImage)
            for(int j=0; j<movieTypes.length; j++)
              if(filenameParts[1].equals(movieTypes[j]))
                isMovie = true;
    
          // Create a texture for the files, add to ArrayList
          GLTexture tex;
    
          // Images get added directly to textures ArrayList
          if(isImage) {
            tex = new GLTexture(this, sketchPath + "/data/textures/" + filename);
            textures.add(tex);
            textureNames.add(filename);
    
          // Videos need empty texture in textures ArrayList, as well as
          // actual video in videos ArrayList (and lookup)
          } else if(isMovie) {
            // Create texture
            tex = new GLTexture(this);
            textures.add(tex);
            textureNames.add(filename);
    
            // Create movie
            GSMovie movie = new GSMovie(this, sketchPath + "/data/textures/" + filename);
            movie.setPixelDest(tex);
            movies.add(movie);
    
            // Associate movie to texture
            movieTextureLookup.add(movies.size()-1, textures.size()-1);
          }
        }
      }
    }

    void movieEvent(GSMovie movie) {
      movie.read();
    }
    
    @Override
    public void keyEvent(KeyEvent event) {
      if(event.getKey() == ' ') {
        if(moviesPlaying) {
          for(int i=0; i<movies.size(); i++) {
            GSMovie movie = movies.get(i);
            movie.pause();
            movie.jump(0);
          }
          moviesPlaying = false;
        } else {
          for(int i=0; i<movies.size(); i++) {
            GSMovie movie = movies.get(i);
            movie.loop();
          }
          moviesPlaying = true;
        }
      }
    }

    @Override
    public void mouseEvent(MouseEvent event) {

    }

    @Override
    public String getName() {
        return this.name;
    }
}

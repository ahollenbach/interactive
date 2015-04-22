/**
  * Lane Lawley's Wanderers script, adapted to take audio input
  */
public class Wanderers extends AbstractSketch {
    private String name;

    private Minim minim;
    private AudioInput in;
    
    int numWanderers = 1000;
    int numColors = 2048;
    int colPtr = 0;
    float vel = 0;
    
    color[] colors;
    ArrayList<Wanderer> wanderers;

    public Wanderers(final PApplet parent, String name, final int width, final int height, Minim m, AudioInput i) {
        super(parent, width, height);
        
        this.name = name;
        this.minim = m;
        this.in = i;
        
        colors = new color[numColors];
        wanderers = new ArrayList<Wanderer>();
    }

    @Override
    public void draw() {
      vel = in.mix.level();
      graphics.beginDraw();
      
      for (Wanderer f : wanderers) {
          f.move();
      }
      graphics.endDraw();
    }
    
    color randColor() {
        return colors[int(random(colors.length))];
    }
    
    // Crawl image for a color pool
    // Idea from j tarbell
    void getImgColors(String file) {
      PImage img = loadImage(file);
      image(img, 0, 0);
    
    trucking:
      for (int i = 0; i < img.width; ++i) {
        for (int j = 0; j < img.height; ++j) {
          color col = get(i, j);
    
          // Is this a unique color?
          for (int k = 0; k < colPtr; ++k) {
            if (colors[k] == col) {
              continue trucking; // :)
            }
          }
    
          // Add it to the pool
          if (colPtr < colors.length) {
            colors[colPtr] = col;
            ++colPtr;
          }
        }
      }
    }

    @Override
    public void keyEvent(KeyEvent event) {

    }

    @Override
    public void mouseEvent(MouseEvent event) {
      
    }

    @Override
    public void setup() {
      getImgColors("pollockShimmering.jpg");
      
      graphics.beginDraw();
      graphics.background(255);
      graphics.fill(255);
      graphics.rect(0, 0, graphics.width, graphics.height);
      graphics.endDraw();
      
      for (int i = 0; i < numWanderers; ++i) {
        // Initial placement in Cartesian coordinates for rectangular boundaries
        float x = random(graphics.width);
        float y = random(graphics.height);
      
        wanderers.add(new Wanderer(randColor(), x, y, random(360)/*, 1*/));
      }
      
      for (int i = 0; i < numWanderers; ++i){
        // For some reason, no point convergence occurs unless we randomize targets
        // I think it's because someone needs to get themselves, but that seems unlikely to happen every time?
        wanderers.get(i).target = wanderers.get(int(random(wanderers.size())));
      }
    }
    
    @Override
    public String getName() {
        return this.name;
    }
    
    class Wanderer {
      color c;
      float x, y;
      float theta;
      //float vel;
      Wanderer target;
    
      Wanderer(color c, float x, float  y, float theta/*, float vel*/) {
        this.c = c;
        this.x = x;
        this.y = y;
        this.theta = theta;
        //this.vel = vel;
      }
    
      void move() {
        // Calculate angle to target
        float tdx = target.x - this.x;
        float tdy = target.y - this.y;
        float ttheta = atan2(tdy, tdx) * 180/PI;
    
        // Move toward target
        x += vel * cos(ttheta * PI/180);
        y += vel * sin(ttheta * PI/180);
    
        // Stay within frame, even if it means teleporting :)
        if (x <= 0 || x >= graphics.width) {
          x = graphics.width - x;
        }
        if (y <= 0 || y >= graphics.height) {
          y = graphics.height - y;
        }
    
        // Try to keep lines drawn at reasonable sizes
        float targetDist = sqrt(tdx*tdx + tdy*tdy);
        if (targetDist <= graphics.width*0.75 && targetDist > 5) {
          graphics.stroke(c, 30);
          graphics.line(x, y, target.x, target.y);
        }
      }
    }
}

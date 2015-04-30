import ddf.minim.analysis.*;

public class WanderingCircles extends AbstractSketch {
    private String name;

    private Minim minim;
    private AudioInput in;
    private FFT fft;
    
    int[][] circles = new int[30][];

    public WanderingCircles(final PApplet parent, String name, final int width, final int height, Minim m, AudioInput i) {
        super(parent, width, height);

        this.minim = m;
        this.in = i;
        this.name = name;
        
        for(int j=0;j<30;j++) {
          circles[j] = getCircle(width, height);
        }
    }
    
    @Override
    public void setup() {
      int timeSize = 2048;
      fft = new FFT(in.bufferSize(), in.sampleRate());
      System.out.println("=======");
      System.out.println(timeSize);
      System.out.println(in.bufferSize());
      System.out.println(in.sampleRate());
    }

    @Override
    public void draw() {
        graphics.beginDraw();
        graphics.background(0);

        // Reverse the orientation of y axis
        graphics.scale(1, -1);
        graphics.translate(0, -graphics.height);

        // Draw the equalizer
        fft.forward(in.mix);
        int numSamples = 30; //fft.specSize()
        
        
        for (int i = 0; i < numSamples; i++) {
           int[] c = circles[i];
           graphics.noStroke();
           graphics.fill(c[2],c[3],c[4]);
           float radius = getRadius(circles[i], fft.getBand(i) * 4); // fft.getBand(i) * 4;
           graphics.ellipse(c[0], c[1], radius, radius);
           wander(circles[i]);
         }
         
        
        //graphics.rect(0, 0, graphics.width, graphics.height*in.mix.level()*4);

        graphics.endDraw();
    }
    
    /**
     * Because we couldn't figure out why we were getting compiler errors on the circle object (I blame Andrew)
     * we're just working with an array of circle parameters. The order is as follows:
     * 0 - The circle center's x-coordinate
     * 1 - The circle center's y-coordinate
     * 2 - The circle's red color value
     * 3 - The circle's green color value
     * 4 - The circle's blue color value
     * 5 - An integer approximation of the circle's last radius. 
     *        (Used for size gradient padding)
     * 6/7 - The circle's movement vector.
     */
    public int[] getCircle(float xBound, float yBound) {
      int xB = Math.round(xBound);
      int yB = Math.round(yBound);
      
      int[] circle = new int[8];
      
      circle[0] = Math.round(random(xB));
      circle[1] = Math.round(random(yB));
      
      circle[2] = Math.round(random(255));
      circle[3] = Math.round(random(255));
      circle[4] = Math.round(random(255));
      circle[5] = 0;
      circle[6] = Math.round(random(2)) - 1;
      circle[7] = Math.round(random(2)) - 1;
      
      return circle;
    }
    
    /**
     * So my main goal with this one is to keep an estimate of the last radius value in memory
     * and use it in tandem with the live value to prevent more aggressive jumps. Hopefully this
     * will smooth out size changes to the circles.
     * @param circle - the circle parameter array
     * @param augment - the newest radius to fold into the circle array
     * @return - the radius to use.
     */
    public float getRadius(int[] circle, float augment) {
        float avg = (circle[5] + augment) / 2f;
        circle[5] = Math.round(avg);
        return avg;
    }
    
    /**
     * Twiddles the x and y values of the circle array.
     */
    public void wander(int[] circle) {
      int xMove = Math.round(random(2)) - 1;
      int yMove = Math.round(random(2)) - 1;
      
      circle[6] += xMove;
      circle[7] += yMove;
      
      if(circle[6] > 2 || circle[6] < -2) circle[6] = 0;
      if(circle[7] > 2 || circle[7] < -2) circle[7] = 0;
      
      circle[0] += circle[6];
      circle[1] += circle[7]; 
      
      if(circle[0] < 0) {
        circle[6] = Math.abs(circle[6]);
      } else if(circle[0] > width) {
        circle[6] = -1 * Math.abs(circle[6]);
      }
      if(circle[1] < 0) {
        circle[7] = Math.abs(circle[7]);
      } else if(circle[1] > height) {
        circle[7] = -1 * Math.abs(circle[7]);
      }
    }

    @Override
    public void keyEvent(KeyEvent event) {

    }

    @Override
    public void mouseEvent(MouseEvent event) {
      
    }
    
    @Override
    public String getName() {
        return this.name;
    }
}

import ddf.minim.analysis.*;

public class NewTest extends AbstractSketch {
    private String name;

    private Minim minim;
    private AudioInput in;
    private FFT fft;
    
    int[][] circles = new int[30][];

    public NewTest(final PApplet parent, String name, final int width, final int height, Minim m, AudioInput i) {
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
           graphics.fill(c[2],c[3],c[4]);
           graphics.ellipse(c[0], c[1], fft.getBand(i) * 4, fft.getBand(i) * 4);
         }
         
        
        //graphics.rect(0, 0, graphics.width, graphics.height*in.mix.level()*4);

        graphics.endDraw();
    }
    
    public int[] getCircle(float xBound, float yBound) {
      int xB = Math.round(xBound);
      int yB = Math.round(yBound);
      
      int[] circle = new int[5];
      
      circle[0] = Math.round(random(xB));
      circle[1] = Math.round(random(yB));
      
      circle[2] = Math.round(random(255));
      circle[3] = Math.round(random(255));
      circle[4] = Math.round(random(255));
      
      return circle;
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

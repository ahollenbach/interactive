import ddf.minim.analysis.*;
public class Equalizer extends AbstractSketch {
    private int curColor;
    private String name;

    private Minim minim;
    private AudioInput in;
    private FFT fft;

    public Equalizer(final PApplet parent, String name, final int width, final int height, Minim m, AudioInput i, int colr) {
        super(parent, width, height);

        this.minim = m;
        this.in = i;
        this.curColor = colr;
        this.name = name;
    }
    
    @Override
    public void setup() {
      fft = new FFT(in.bufferSize(), in.sampleRate());
      System.out.println("=======");
      System.out.println(in.bufferSize());
      System.out.println(in.sampleRate());
      
      fft.logAverages(11,12);
      
      System.out.println(fft.specSize());
    }

    @Override
    public void draw() {
        graphics.beginDraw();
        graphics.background(0);
        graphics.fill(curColor);

        // Reverse the orientation of y axis
        graphics.scale(1, -1);
        graphics.translate(0, -graphics.height);

        // Draw the equalizer
        fft.forward(in.mix);
        int numSamples = 11*8; //fft.specSize()
        float w = ((float)graphics.width)/numSamples;
        for (int i = 0; i < numSamples; i++) {
           graphics.rect(i*w, 0, w, fft.getBand(i) * 8);
         }
         
        
        //graphics.rect(0, 0, graphics.width, graphics.height*in.mix.level()*4);

        graphics.endDraw();
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

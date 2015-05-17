public class SpinningSquares extends AbstractSketch {
    private String name;
    private float scaling;
    private static final int numBands = 10;
    private static final int alpha = 155;

    float[][] squares = new float[numBands][];

    public SpinningSquares(final PApplet parent, String name, final int width, final int height, float scaling) {
        super(parent, width, height);
        
        this.name = name;
        this.scaling = scaling;

        for(int j=0;j<numBands;j++) {
          squares[j] = getSquare(width, height);
        }
    }

    @Override
    public void setup() {
    }

    @Override
    public void draw() {
        graphics.beginDraw();
        graphics.background(0);

        // Reverse the orientation of y axis
        graphics.scale(1, -1);
        graphics.translate(0, -graphics.height);

        for (int i = 0; i < numBands; i++) {
           float[] s = squares[i];
           float size = getSize(squares[i], SketchMapperMain.fft.getBand(i) * scaling);
           float[] x = {-1 * size/2f, size/2f, size/2f, -1 * size/2f};
           float[] y = {size/2f, size/2f, -1 * size/2f, -1 * size/2f};

           rotatePoints(x, y, s[2], 4);

           PShape square = createShape();
           square.beginShape();
           square.noStroke();
           square.fill(s[3],s[4],s[5],alpha);
           for(int j = 0; j < 4; j++)
             square.vertex(x[j] + s[0], y[j] + s[1]);
           square.endShape(CLOSE);

           shape(square);

           spin(squares[i]);
         }


        //graphics.rect(0, 0, graphics.width, graphics.height*in.mix.level()*4);

        graphics.endDraw();
    }

    /**
     * Because we couldn't figure out why we were getting compiler errors on the circle object (I blame Andrew)
     * we're just working with an array of circle parameters. The order is as follows:
     * 0 - The square center's x-coordinate
     * 1 - The square center's y-coordinate
     * 2 - The square's rotation angle
     * 3 - The square's red color value
     * 4 - The square's green color value
     * 5 - The square's blue color value
     * 6 - The square's last size value
     * 7 - The square's last theta augment
     */
    public float[] getSquare(float xBound, float yBound) {
      int xB = Math.round(xBound);
      int yB = Math.round(yBound);

      float[] square = new float[8];

      square[0] = Math.round(random(xB));
      square[1] = Math.round(random(yB));
      square[2] = 0;
      square[3] = Math.round(random(255));
      square[4] = Math.round(random(255));
      square[5] = Math.round(random(255));
      square[6] = 0;
      square[7] = 0;

      return square;
    }

    /**
     * So my main goal with this one is to keep an estimate of the last radius value in memory
     * and use it in tandem with the live value to prevent more aggressive jumps. Hopefully this
     * will smooth out size changes to the circles.
     * @param circle - the circle parameter array
     * @param augment - the newest radius to fold into the circle array
     * @return - the radius to use.
     */
    public float getSize(float[] square, float augment) {
        float avg = (square[6] + augment) / 2f;
        square[6] = Math.round(avg);
        return avg;
    }

    public void spin(float[] square) {
      float avg = (square[7] + random(5)) / 2f;
      square[2] += avg;
      square[7] = avg;
    }

    public void rotatePoints(float[] x, float[] y, float theta, int n) {
        // x' = x * cos(theta) - y * sin(theta)
        // y' = x * sin(theta) + y * cos(theta)
        for(int i = 0; i < n; i++) {
           float x_ = x[i] * cos(radians(theta)) - y[i] * sin(radians(theta));
           float y_ = x[i] * sin(radians(theta)) + y[i] * cos(radians(theta));
           x[i] = x_;
           y[i] = y_;
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

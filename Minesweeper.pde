

import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons = new MSButton[NUM_ROWS] [NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);   
    
    // make the manager
    Interactive.make( this );
    
        //your code to declare and initialize buttons goes here
    for (int r = 0; r < buttons.length; r++)
        for (int c = 0; c < buttons[r].length; c++)
            buttons[r] [c] = new MSButton(r,c);
    for (int i = 0; i < 50; i++)
        setBomb();
}
public void setBomb()
{
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (!bombs.contains(buttons[r][c]))
    {
        bombs.add(buttons[r][c]);
    }
    else
        setBomb();
}

public void draw ()
{
    background( 0 );
    if(isWon())
    {
        displayWinningMessage();
    }
}
public boolean isWon()
{
    for (int r = 0; r < NUM_ROWS; r++)
        for (int c = 0; c < NUM_COLS; c++)
            if (!bombs.contains(buttons[r][c]) && !buttons[r][c].isClicked())
                return false;
    return true;
}
public void displayLosingMessage()
{
    noLoop();
    buttons[5][8].setLabel("L");
    buttons[5][9].setLabel("O");
    buttons[5][10].setLabel("S");
    buttons[5][11].setLabel("E");
}
public void displayWinningMessage()
{
    noLoop();
    buttons[5][9].setLabel("W");
    buttons[5][10].setLabel("I");
    buttons[5][11].setLabel("N");
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
         width = 400/NUM_COLS;
         height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        if (!clicked && mouseButton == RIGHT)
        {
            marked = !marked;
        }
        else 
        {
            if (!isMarked())
            {
                clicked = true;
                if (bombs.contains(this))
                {
                    for (int i = 0; i < bombs.size(); i++)
                        if (!bombs.get(i).isClicked())
                            bombs.get(i).mousePressed(); 
                    displayLosingMessage();
                }
                else if (countBombs(r, c) > 0)
                    setLabel(str(countBombs(r,c)));
                else 
                    for (int row = r - 1; row < r + 2; row++)
                        for (int col = c - 1; col < c + 2; col++)
                            if (isValid(row,col) && !buttons[row][col].isClicked())
                                buttons[row ][col].mousePressed();
            }
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
         else if( clicked && bombs.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if (r >= 0 && r < 20 && c >=0 && c < 20)
            return true;
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for (int r = row -1; r < row+2; r++)
            for (int c = col -1; c < col + 2; c++)
                if (isValid(r,c) && bombs.contains(buttons[r][c]))
                    numBombs++;
        return numBombs;
    }
}




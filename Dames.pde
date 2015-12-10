/* * TODO :

- algo de détection des déplacements des pions



* * * * */

static final int GRID_SIZE = 10;

int[] coordsX = new int[100];
int[] coordsY = new int[100];

Pawn[] whitePawns = new Pawn[20];
Pawn[] blackPawns = new Pawn[20];

void setup()
{
  noStroke();
  size(750, 500);
  get_coords();
  place_pawns();
}

void draw()
{
  clear();
  draw_board();
  for(int i = 0 ; i < 20 ; i++)
  {
    whitePawns[i].update();
    blackPawns[i].update();
  }
  /*fill(#FF0000);
  rect(0, 0, 64, 64);*/
}

// stocke les coordonées de chaque case du plateau dans les tableaux coordsX et coordsY
void get_coords()
{
  for(int x = 0 ; x < 10 ; x++)
  {
    for(int y = 0 ; y < 10 ; y++)
    {
      coordsX[x] = 50*x;
      coordsY[y] = 50*y;
    }
  }
}

//algorithme de placement des pions en début de partie
void place_pawns()
{
  char numb = 0;
  
  for(int l = 0 ; l < 4 ; l++) {
    for(int c = 0; c < 5 ; c++) {
      whitePawns[numb] = new Pawn((c*2) + (l % 2), l, WHITE);
      blackPawns[numb++] = new Pawn((c*2) + (l % 2), l+6, BLACK);
    }
  }  
}

//dessine la grille du plateau à l'écran
void draw_board()
{
  char c = 1;
 
  for(int x = 0 ; x < 10 ; x++)
  {
    for(int y = 0 ; y < 10 ; y++)
    {
      if(c == 0) c = 1; else c = 0;
      
      fill(c*#222222+#79725F);
      rect(x * 50, y*50, 50, 50);    
    }
    if(c == 0) c = 1; else c = 0;
  }
}

/**********CLASSES***********/

final static color BLACK = #000000;
final static color WHITE = #FFFFFF;





class Pawn
{
  private boolean canGoBack = false;
  private boolean isDead = false;
  private int x, y;
  color c;
  
  Pawn(int x, int y, color c)
  {
    this.x = x;
    this.y = y;
    this.c = c;
    // temp
    //if(random(40) < 10) canGoBack = true;
    
    this.debug();
  }
  
  int getX() { return this.x; }
  int getY() { return this.y; }
  boolean isDead() { return this.isDead; }
  void setX(int x) { this.x = x; }
  void setY(int y) { this.y = y; }
  void setDead(boolean b) { this.isDead = b; }
  
  //dessine le pion à l'écran
  void update()
  {
    
    if(mouseX > coordsX[this.x] && mouseX < coordsX[this.x]+50 && mouseY > coordsY[this.y] && mouseY < coordsY[this.y]+50)
    {
      renderMoveLocations(getMoveLocations());
      strokeWeight(4);
      stroke(#33AA33);  
    }
    fill(c);
    ellipse(coordsX[this.x] + 25, coordsY[this.y] + 25, 50 / 1.2, 50 / 1.2);
    
    if(canGoBack)
    {
      noFill();
      strokeWeight(2);
      stroke(#DD2222);
      ellipse(coordsX[this.x] + 25, coordsY[this.y] + 25, 50 / 2, 50 / 2);
      strokeWeight(1);
    }

    noStroke();
  }
  
  //affiche les informations sur le pion dans la console
  void debug()
  {
     println("Color : " + ((c == BLACK) ? "WHITE" : "BLACK") + "  |  Location : " + x + ", " + y); 
  }
  
  //récupère un tableau contenant les cases sur lesquelles le pion peut se déplacer
  public ArrayList<PVector> getMoveLocations()
  {
    ArrayList<PVector> ml = new ArrayList<PVector>();
    /*
    o o
     x 
    o o
    */
    if(this.c == WHITE) {
      if(!this.canGoBack) {
        if(x > 0 && getPawnByLocation(x-1, y+1) == null) 
        {
          ml.add(new PVector(x-1, y+1));
        }
        
        if(x < 9 && getPawnByLocation(x+1, y+1) == null)
        {
          ml.add(new PVector(x+1, y+1));
          println("test");
        }
           
      } else { // le pion est une damme
        
      }
    } else {
      if(!this.canGoBack) {
        
      } else { // le pion est une damme
        
      }
    }
    
    return ml;
  }
  
  public void renderMoveLocations(ArrayList<PVector> ml)
  {
    for(int i = 0 ; i < ml.size() ; i++)
    {
      fill(#628348);
      rect(coordsX[ (int) ml.get(i).x], coordsY[ (int) ml.get(i).y], 50, 50);
    }
  }
}







//récupère un pointeur sur le pion se trouvant sur la case x, y -> retourne null si aucun pion ne se trouve à cet endroit

public Pawn getPawnByLocation(int x, int y)
{
  Pawn p = null;
  
  for(int i = 0; i < 20; i++) {
    p = whitePawns[i];
    if(p.getX() == x && p.getY() == y && !p.isDead()) break;
    p = blackPawns[i];
    if(p.getX() == x && p.getY() == y && !p.isDead()) break; 
    p = null;
  }
  
  return p;
}
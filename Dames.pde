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
  char offset = 0,
       numb = 0;
                
  for(int cols = 0 ; cols < 4 ; cols++)
  {
    for(int ln = offset; ln < 10 ; ln += 2)
    {
      whitePawns[numb] = new Pawn(ln, cols, WHITE);
      blackPawns[numb++] = new Pawn(ln, cols+6, BLACK);   
    }
    if(offset == 1) offset = 0; else offset = 1;
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
      
      fill(c*#AAAAAA+#444444);
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
  boolean canGoBack = false;
  int x, y;
  color c;
  
  Pawn(int x, int y, color c)
  {
    this.x = x;
    this.y = y;
    this.c = c;
    // temp
    if(random(40) < 10) canGoBack = true;
  }
  
  //dessine le pion à l'écran
  void update()
  {
    fill(c);
    if(mouseX > coordsX[this.x] && mouseX < coordsX[this.x]+50 && mouseY > coordsY[this.y] && mouseY < coordsY[this.y]+50)
      stroke(#33DD55);
    
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
}

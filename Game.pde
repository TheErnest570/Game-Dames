/* * TODO :

- algo de détection des déplacements des pions



* * * * */

// taille d'un coté du plateau (en cases)
static final int GRID_SIZE = 10;

// contient les coordonnées en pixels de toutes les cases du plateau
int[] coordsX = new int[100];
int[] coordsY = new int[100];

// contient les pions placés sur le plateau 
Pawn[] whitePawns = new Pawn[20];
Pawn[] blackPawns = new Pawn[20];


void setup()
{
  noStroke();
  size(750, 500); //50 * GRID_SIZE
  get_coords(); // initialise les tableaux de coordonnées
  //place_pawns();
  place_pawns_with_array(); // fonction de debug permettant d'avoir des pions placés n'importe ou sur le plateau en début de partie
}


void draw()
{
  clear();
  draw_board(); // dessine les cases du polateau de jeu
  
  for(int i = 0 ; i < 40 ; i++) { // met à jour et dessine tous les pions sur le plateau
    Pawn p;
    p = (i < 20) ? whitePawns[i] : blackPawns[i-20];
    
    p.update();
  }
  
  for(int i = 0 ; i < 40 ; i++) {// si le canEat d'un pion !=null, on surligne les cibles en rouge
    Pawn p;
    p = (i < 20) ? whitePawns[i] : blackPawns[i-20];
     
    ArrayList<PVector> ce = p.getCanEat();
    if(ce != null)
      for(int u = 0 ; u < ce.size() ; u++) {
         Pawn ep = getPawnByLocation((int) ce.get(u).x, (int) ce.get(u).y);
         highlight_red(ep);
      }
    p.setCanEat(null);
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
  char numb = 0;
  
  for(int l = 0 ; l < 4 ; l++) {
    for(int c = 0; c < 5 ; c++) {
      whitePawns[numb] = new Pawn((c*2) + (l % 2), l, WHITE);
      blackPawns[numb++] = new Pawn((c*2) + (l % 2), l+6, BLACK);
    }
  }  
}


//utilise un tableau pour placer les pions sur la grille -> DEBUG FUNCTION
void place_pawns_with_array()
{
   int wn = 0, bn = 0;
  
   char[][] pawns = 
   {
     {1,0,1,0,1,0,1,0,2,0},
     {0,1,0,1,0,1,2,1,0,1},
     {2,0,1,0,0,0,0,0,0,0},
     {2,0,0,2,1,0,0,0,0,2},
     {0,1,0,0,0,0,1,2,0,0},
     {0,0,1,0,0,1,0,0,2,0},
     {2,0,0,0,0,0,2,2,0,2},
     {0,2,1,0,1,0,0,1,0,0},
     {0,0,0,2,2,2,2,0,2,0},
     {0,2,0,0,2,1,0,0,1,0}
   };  
   
   for(int y = 0 ; y < 10 ; y++)
   {
      for(int x = 0 ; x < 10 ; x++)
      {
        if(pawns[y][x] == 1) {
          whitePawns[wn++] = new Pawn(x, y, WHITE);
        } else if (pawns[y][x] == 2) {
          blackPawns[bn++] = new Pawn(x, y, BLACK);            
        }
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

void highlight_red(Pawn p)
{
  noStroke();
  fill(#792E2E, 128);
  rect(coordsX[p.getX()], coordsY[p.getY()], 50, 50);
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


// CONSTANTES DE COULEURS
final static color BLACK = #000000;
final static color WHITE = #FFFFFF;
class Pawn
{
  private boolean canGoBack = false; // le pion est une Dame
  private boolean isDead = false; // le pion a été bouffé
  private int x, y; // coordonnées du pion (en cases)
  color c; // couleur du pion (BLACK ou WHITE)
  
  Pawn(int x, int y, color c)
  {
    this.x = x;
    this.y = y;
    this.c = c;
    // temp
    //if(random(40) < 10) canGoBack = true; // debug pour avoir des Dames en début de partie
    
    this.debug(); // affiche les infos concernant le pions : coords & couleur
  }
  
  //Getters / Setters
  int getX() { return this.x; }
  int getY() { return this.y; }
  boolean isDead() { return this.isDead; }
  void setX(int x) { this.x = x; }
  void setY(int y) { this.y = y; }
  void setDead(boolean b) { this.isDead = b; }
  
  //dessine le pion à l'écran
  void update()
  {
    // ********** UPDATE ***********
    
    
    
    // ********** RENDER ***********
    if(mouseX > coordsX[this.x] && mouseX < coordsX[this.x]+50 && mouseY > coordsY[this.y] && mouseY < coordsY[this.y]+50) // si la souris est sur la case du pion
    {
      renderMoveLocations(getMoveLocations()); // on surligne les cases sur lesquelles il est possible de se déplacer
      strokeWeight(4);
      stroke(#33AA33);
    }
    fill(c);
    ellipse(coordsX[this.x] + 25, coordsY[this.y] + 25, 50 / 1.2, 50 / 1.2); // on dessine le pion en fonction de ses coordonnées et avec la couleur

    if(canGoBack) // si le pion est une Dame : on lui dessine un cercle rouge
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
    
    if(this.c == WHITE) { // si le pion est blanc
      if(!this.canGoBack) { // et n'est pas une Dame :
      // on recherche des places libres en dessous du pion
        if(x > 0 && y < 9 && getPawnByLocation(x-1, y+1) == null)
        {
          ml.add(new PVector(x-1, y+1));
        }
        
        if(x < 9 && y < 9 && getPawnByLocation(x+1, y+1) == null)
        {
          ml.add(new PVector(x+1, y+1));
        }
           
      } else { // le pion est une dame
        
      }
    } else { // le pion est noir
      if(!this.canGoBack) { // et n'est pas une Dame
      // on recherche les pions libres au dessus
        if(x > 0 && y > 0 && getPawnByLocation(x-1, y-1) == null)
        {
          ml.add(new PVector(x-1, y-1));
        }
        
        if(x < 9 && y > 0 && getPawnByLocation(x+1, y-1) == null)
        {
          ml.add(new PVector(x+1, y-1));
        }
      } else { // le pion est une damme
        
      }
    }
    
    return ml;
  }
  
  // surligne les cases dont les coords sont stockées dans L'ArrayList ml
  public void renderMoveLocations(ArrayList<PVector> ml)
  {
    for(int i = 0 ; i < ml.size() ; i++)
    {
      fill(#628348);
      rect(coordsX[ (int) ml.get(i).x], coordsY[ (int) ml.get(i).y], 50, 50);
    }
  }
}
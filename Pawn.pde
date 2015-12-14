class Pawn
{
  public static final float PAWN_SIZE = 50 / 1.2;
    
  private boolean canGoBack = false; // le pion est une Dame
  private boolean isDead = false; // le pion a été bouffé
  private int x, y; // coordonnées du pion (en cases)
  color c; // couleur du pion (BLACK ou WHITE)
  
  //GRAPHIC VARS 
  private ArrayList<PVector> canEat; // liste des pions pouvant être bouffés durant le tour
  private ArrayList<PVector> eatLocations; // associe chaque pion bouffable a la position que doit prendre le joueur pour bouffer ce pion
  
  
  //turn var
  boolean dragged = false;
  

  Pawn(int x, int y, color c)
  {
    this.x = x;
    this.y = y;
    this.c = c;
    // temp
    //if(random(40) < 10) canGoBack = true; // debug pour avoir des Dames en début de partie
    canEat = null;
    
    this.debug(); // affiche les infos concernant le pions : coords & couleur
  }

  //Getters / Setters
  int getX() { return this.x; }
  int getY() { return this.y; }
  boolean isDead() { return this.isDead; }
  ArrayList<PVector> getCanEat() { return this.canEat; }
  ArrayList<PVector> getEatLocations() { return this.eatLocations; }
  void setX(int x) { this.x = x; }
  void setY(int y) { this.y = y; }
  void setDead(boolean b) { this.isDead = b; }
  void setCanEat(ArrayList ce) { this.canEat = ce; }
  void setEatLocations(ArrayList el) { this.eatLocations = el; }

  //dessine le pion à l'écran
  void update()
  {
    
    
    
    
    // ********** RENDER ***********
    if(!isDead) {
      if(((this.isMouseOn() && draggedPawn == null) || draggedPawn == this) && turn == c ) // si la souris est sur la case du pion ou si le pion est drag
      {
        if(draggedPawn == this) renderMoveLocations(getMoveLocations()); // on surligne les cases sur lesquelles il est possible de se déplacer
        strokeWeight(4);
        stroke(#33AA33);
      }
      fill(c);
      ellipse(coordsX[this.x] + 25, coordsY[this.y] + 25, PAWN_SIZE, PAWN_SIZE); // on dessine le pion en fonction de ses coordonnées et avec la couleur
  
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
    
    
    // ********** UPDATE ***********
    
    if(draggedPawn == null) { // aucun pion n'est encore drag
      if(this.isMouseOn() && mousePressed && turn == c) {
        draggedPawn = this;
        draggedPawn.dragged = true;
        println("drag " + random(10));
        
        dragXStart = mouseX;
        dragYStart = mouseY;
        dragXEnd = mouseX;
        dragYEnd = mouseY;
        
      }
    } else {
      if(!mousePressed) {
        
        //déplacement si possible du pion :
        ArrayList<PVector> mvl = draggedPawn.getMoveLocations();
        if(mvl != null) {
          PVector msl = draggedPawn.getMouseLocation();
          for(int i = 0 ; i < mvl.size() ; i++) {
            if(mvl.get(i).x == msl.x && mvl.get(i).y == msl.y) {
              draggedPawn.move((int)msl.x, (int)msl.y);
              println("Moved ! ");
              /*
              ArrayList<PVector> ce = this.getCanEat();
              ArrayList<PVector> el = this.getEatLocations();
              if(canEat != null)
              {
                println("ALERT");
                for(int u = 0; u < el.size() ; u++)
                {
                  if(draggedPawn.getX() == el.get(u).x && draggedPawn.getY() == el.get(u).y) 
                  {
                    getPawnByLocation((int)ce.get(u).x, (int)ce.get(u).y).setDead(true);
                  }
                }
              }*/
              
              turn = (turn == WHITE) ? BLACK : WHITE; 
            }
          }
        }
        draggedPawn.dragged = false;
        draggedPawn = null;
      }
      dragXEnd = mouseX;
      dragYEnd = mouseY;
    }
  }
  
  
  public boolean isMouseOn()
  {
    boolean r = (mouseX > coordsX[this.x] && mouseX < coordsX[this.x]+50 && mouseY > coordsY[this.y] && mouseY < coordsY[this.y]+50);
    return r;
  }
  
  public boolean isMouseOn(Pawn p)
  {
    boolean r = (mouseX > coordsX[p.x] && mouseX < coordsX[p.x]+50 && mouseY > coordsY[p.y] && mouseY < coordsY[p.y]+50);
    return r;
  }
  
  public PVector getMouseLocation()
  {
    PVector r = new PVector(-1, -1);
    
    for(int x = 0; x < 10 ; x++) {
      for(int y = 0; y < 10 ; y++) {
        if(mouseX > coordsX[x] && mouseX < coordsX[x]+50 && mouseY > coordsY[y] && mouseY < coordsY[y]+50)
        {
          r.x = x;
          r.y = y;
        }
      }
    }
    return r;
  }
  
  private void move(int x, int y) {
     this.setX(x);
     this.setY(y);
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
        if(x > 0 && y < 9) {
          if(getPawnByLocation(x-1, y+1) == null) {
            ml.add(new PVector(x-1, y+1));
          } else if(getPawnByLocation(x-1, y+1).c == BLACK && x > 1 && y < 8 && getPawnByLocation(x-2, y+2) == null) { // si il est possible de bouffer un pion noir a gauche
            ml.add(new PVector(x-2, y+2));
            initCanEat();
            canEat.add(new PVector(x-1, y+1));
            eatLocations.add(new PVector(x-2, y+2));
          }
        }
        
        if(x < 9 && y < 9) {
          if(getPawnByLocation(x+1, y+1) == null) {
            ml.add(new PVector(x+1, y+1));
          } else if(getPawnByLocation(x+1, y+1).c == BLACK && x <8 && y < 8 && getPawnByLocation(x+2, y+2) == null) { // si il est possible de bouffer un pion noir a droite
            ml.add(new PVector(x+2, y+2));
            initCanEat();
            canEat.add(new PVector(x+1, y+1));
            eatLocations.add(new PVector(x+2, y+2));
          }
        }
           
      } else { // le pion est une dame
        
      }
    } else { // le pion est noir
      if(!this.canGoBack) { // et n'est pas une Dame
      // on recherche les pions libres au dessus
        if(x > 0 && y > 0) {
          if(getPawnByLocation(x-1, y-1) == null) {
            ml.add(new PVector(x-1, y-1));
          } else if(getPawnByLocation(x-1, y-1).c == WHITE && x > 1 && y > 1 && getPawnByLocation(x-2, y-2) == null) { // si il est possible de bouffer un pion blanc a droite
            ml.add(new PVector(x-2, y-2));
            initCanEat();
            canEat.add(new PVector(x-1, y-1));
            eatLocations.add(new PVector(x-2, y-2));
          } 
        }
        
        if(x < 9 && y > 0) {
          if(getPawnByLocation(x+1, y-1) == null) {
            ml.add(new PVector(x+1, y-1));
          } else if(getPawnByLocation(x+1, y-1).c == WHITE && x < 8 && y > 1 && getPawnByLocation(x+2, y-2) == null) { // si il est possible de bouffer un pion blanc a droite
            ml.add(new PVector(x+2, y-2));
            initCanEat();
            canEat.add(new PVector(x+1, y-1));
            eatLocations.add(new PVector(x+2, y-2));
          }
        }
      } else { // le pion est une damme
        
      }
    }
    
    return ml;
  }
  
  // initialise le tableau canEat si celui ci est égal à null
  private void initCanEat()
  {
    if(canEat == null)
      canEat = new ArrayList<PVector>();
    
    initEatLocation();
  }
  
  private void initEatLocation()
  {
    if(eatLocations == null)
      eatLocations = new ArrayList<PVector>();
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
class Pillar {
  float x;
  float topHeight;
  float bottomHeight;
  float speed = 3; 
  float pillarWidth = 100;
  float gap = 300; 

  Pillar() {
    this(width);
  }
  
  Pillar(float start) {
    x = start; 
    topHeight = random(height - gap - 100);
    //topHeight = constrain(topHeight , height /4 , 3 * height /4);
    bottomHeight = height - (topHeight + gap); 
  }

  void show() {
    show(false);
  }
  
  void show(boolean closest) {
    if(closest)
      fill(255, 255, 0);
    else 
      fill(0, 255, 0); 
    noStroke();
    rect(x, 0, pillarWidth, topHeight);
    rect(x, height - bottomHeight, pillarWidth, bottomHeight);
  }

  void update() {
    x -= speed; 
  }

  boolean isOffscreen() {
    return x < -pillarWidth; 
  }
  
    // New function to check for circle collision
  boolean hits(PVector pos,int size) {
    // Check collision with the top pillar
    if (x < pos.x + size && x + pillarWidth > pos.x - size && 
        0 < pos.y + size && topHeight > pos.y - size) {
      float closestX = constrain(pos.x, x, x + pillarWidth);
      float closestY = constrain(pos.y, 0, topHeight);
      float distance = dist(pos.x, pos.y, closestX, closestY);
      if (distance < size) {
        return true;
      }
    }

    // Check collision with the bottom pillar
    if (x < pos.x + size && x + pillarWidth > pos.x - size && 
        height - bottomHeight < pos.y + size && height > pos.y - size) {
      float closestX = constrain(pos.x, x, x + pillarWidth);
      float closestY = constrain(pos.y, height - bottomHeight, height);
      float distance = dist(pos.x, pos.y, closestX, closestY);
      if (distance < size) {
        return true;
      }
    }
    
    return false;
  }
}

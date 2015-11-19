

PImage bg1, bg2, enemy, fighter, hp, treasure, start1, start2, end1, end2, shoot;
PImage [] flame = new PImage[6];

void setup () {
  size(640,480) ;
  bg1 = loadImage ("img/bg1.png");
  bg2 = loadImage ("img/bg2.png");
  enemy = loadImage ("img/enemy.png");
  fighter = loadImage ("img/fighter.png");
  hp = loadImage ("img/hp.png");
  treasure = loadImage ("img/treasure.png");
  end1 = loadImage ("img/end1.png");
  end2 = loadImage ("img/end2.png");
  start1 = loadImage ("img/start1.png");
  start2 = loadImage ("img/start2.png");
  shoot = loadImage ("img/shoot.png");
  for(int i = 1; i < 6; i++){
    flame[i] = loadImage ("img/flame"+i+".png");
  }
}

final int enemyCount = 10;
final int bulletCount = 5;

boolean gameState = false;
boolean endState = false;
boolean startFlash = false;
boolean endFlash = false;
boolean upState = false;
boolean downState = false;
boolean leftState = false;
boolean rightState = false;
boolean [] enemyState = new boolean[enemyCount];
boolean [] bulletState = new boolean[bulletCount];
int [] explosion = new int[enemyCount];
int [] explosionBuffer = new int[enemyCount];
int heroSpeed = 10;
int bg1Pos = 640;
int bg2Pos = 0;
int enemyWave = 0;
int score = -1;
int startBuffer = 0;
int endBuffer = 0;
int enemyBuffer = 0;
int enemyOnline = 0;
float heroPosX = 550;
float heroPosY = 240;
float [] enemyPosX = new float [enemyCount];
float [] enemyPosY = new float [enemyCount];
float [] explosionPosX = new float[enemyCount];
float [] explosionPosY = new float[enemyCount];
float [] bulletPosX = new float[bulletCount];
float [] bulletPosY = new float[bulletCount];
float hpAmount = 195;
float hpPercentage = 0.2;
float treasurePosX = random(40,560);
float treasurePosY = random(60,420);

void draw() {
  if(gameState==false){
    for(int i = 0; i < explosion.length; i++){
      explosion[i] = -1;
      explosionPosX[i] = -500;
      explosionPosY[i] = -500;
      explosionBuffer[i] = 0;
    }
    for(int i = 0; i < bulletCount; i++){
      bulletState[i] = true;
      bulletPosX[i] = -1000;
      bulletPosY[i] = -1000;
    }
    if(endState==true){
      if(mouseX <= 436 && mouseX >= 206 && mouseY <= 355 && mouseY >= 308){
        image(end1, 0, 0);
        endFlash = true;
      }else{
        image(end2, 0, 0);
        endFlash = false;
      }
    }else{
      if(mouseX <= 449 && mouseX >= 198 && mouseY <= 414 && mouseY >= 376){
        image(start1, 0, 0);
        startFlash = true;
      }else{
        image(start2, 0, 0);
        startFlash = false;
      }
    }
  }else{
    image(bg1,-640+bg1Pos,0);
    image(bg2,-640+bg2Pos,0);
    bg1Pos += 10;
    bg1Pos = bg1Pos % 1280;
    bg2Pos += 10;
    bg2Pos = bg2Pos % 1280; //background scrolling
    fill(255,0,0);
    noStroke();
    image(treasure, treasurePosX, treasurePosY); //treasure
    if(upState == true && heroPosY>0){
      heroPosY -= heroSpeed;
    }
    if(downState == true && heroPosY<429){
      heroPosY += heroSpeed;
    }
    if(leftState == true && heroPosX>0){
      heroPosX -= heroSpeed;
    }
    if(rightState == true && heroPosX<589){
      heroPosX += heroSpeed;
    }
    for(int i = 0; i < bulletCount; i++){
      if(!bulletState[i]){
        image(shoot, bulletPosX[i], bulletPosY[i]);
        bulletPosX[i] -= 10;
        if(bulletPosX[i] < -30){
          bulletState[i] = true;
          bulletPosX[i] = -1000;
          bulletPosY[i] = -1000;
        }
      }
    }
    image(fighter, heroPosX, heroPosY); // fighter position
    if(heroPosX + 51 >= treasurePosX && heroPosX <= treasurePosX + 41 && heroPosY + 51 >= treasurePosY && heroPosY <= treasurePosY + 41){
      if(hpPercentage < 0.99){
        hpPercentage += 0.1;
        treasurePosX = random(40,560);
        treasurePosY = random(60,420);
      }
    }
    if(enemyBuffer <= 6){
      for(int i = 0; i < enemyCount; i++){
        enemyState[i] = true;
        enemyPosX[i] = -500;
        enemyPosY[i] = -500;
      }
      enemyWave ++;
      enemyPosX[0] = -100;
      if(enemyWave > 3){
        enemyWave = 1;
      }
      if(enemyWave == 1){
        enemyOnline = 5;
        enemyPosY[0] = random(30,420);
        for(int i = 1; i <= 4; i++){
          enemyPosX[i] = enemyPosX[i-1] - 60;
          enemyPosY[i] = enemyPosY[0];
        }
      }else if(enemyWave == 2){
        enemyOnline = 5;
        enemyPosY[0] = random(30,180);
        for(int i = 1; i <= 4; i++){
          enemyPosX[i] = enemyPosX[i-1] - 60;
          enemyPosY[i] = enemyPosY[i-1] + 60;
        }
      }else if(enemyWave == 3){
        enemyOnline = 9;
        enemyPosY[0] = random(120,300);
        for(int i = 1; i <= 3; i++){
          for(int j = 1; j <= 3; j++){
            if(i != 2 || j != 2 && i + j != 2){
              enemyPosX[(i-1)*3+(j-1)] = enemyPosX[0] - 60*((i-1)+(j-1));
              enemyPosY[(i-1)*3+(j-1)] = enemyPosY[0] + 60*((i-1)-(j-1));
            }
          }
        }
      }
      score += 1;
    }
    for(int i = 0; i < enemyOnline; i++){
      enemyPosX[i] += 7;
      //println(i + "=" + enemyPosX[i] + "," + enemyPosY[i]);
    }
    rect(50,34,hpAmount*hpPercentage,17); //hp amount
    image(hp, 40, 30); //hp outline
    for(int i = 0; i < enemyOnline; i ++){
      if(enemyState[i]){
        image(enemy, enemyPosX[i], enemyPosY[i]);
        if(heroPosX + 51 >= enemyPosX[i] && heroPosX <= enemyPosX[i] + 61 && heroPosY + 51 >= enemyPosY[i] && heroPosY <= enemyPosY[i] + 61){
          explosion[i] = 0;
          explosionPosX[i] = enemyPosX[i];
          explosionPosY[i] = enemyPosY[i];
          if(hpPercentage > 0.21){
            hpPercentage -= 0.2;
            score -= 1;
            enemyState[i] = !enemyState[i];
          }else{
            gameState=false;
            endState=true;
          }
        }
        for(int j = 0; j < bulletCount; j++){
          if(bulletPosX[j] <= enemyPosX[i] + 61 && bulletPosY[j] + 27 >= enemyPosY[i] && bulletPosY[j] <= enemyPosY[i] + 61){
            explosion[i] = 0;
            explosionPosX[i] = enemyPosX[i];
            explosionPosY[i] = enemyPosY[i];
            enemyState[i] = !enemyState[i];
            bulletState[j] = true;
            bulletPosX[j] = -1000;
            bulletPosY[j] = -1000;
          }
        }
      }
    }
    enemyBuffer += 7;
    enemyBuffer %= 1200;
    for(int i = 0; i < enemyCount; i++){
      if(explosion[i] >= 0){
        image(flame[explosion[i]+1], explosionPosX[i], explosionPosY[i]);
        explosionBuffer[i] += 1;
        if(explosionBuffer[i] == 5){
          explosion[i] += 1;
          explosionBuffer[i] = 0;
        }
        if(explosion[i] > 4){
          explosion[i] = -1;
        }
      }
    }
  }
}

void mousePressed(){
  if(endFlash){
    for(int i = 0; i < explosion.length; i++){
      explosion[i] = -1;
      explosionPosX[i] = -1000;
      explosionPosY[i] = -1000;
      explosionBuffer[i] = 0;
    }
    for(int i = 0; i < bulletCount; i++){
      bulletState[i] = true;
      bulletPosX[i] = -500;
      bulletPosY[i] = -500;
    }
    endState = false;
    hpPercentage = 0.2;
    enemyBuffer = 0;
    heroPosX = 550;
    heroPosY = 240;
    treasurePosX = random(40,560);
    treasurePosY = random(60,420);
    score = -1;
    endFlash = false;
    enemyWave = 0;
  }
  if(startFlash){
    gameState = true;
    startFlash = false;
  }
}


void keyPressed(){
  if(key==CODED){
    switch(keyCode){
      case UP:
        upState = true;
        break;
      case DOWN:
        downState = true;
        break;
      case LEFT:
        leftState = true;
        break;
      case RIGHT:
        rightState = true;
        break;
    }
  }
}

void keyReleased(){
  if(key==CODED){
    switch(keyCode){
      case UP:
        upState = false;
        break;
      case DOWN:
        downState = false;
        break;
      case LEFT:
        leftState = false;
        break;
      case RIGHT:
        rightState = false;
        break;
    }
  }
  if(key==' '){
    for(int i = 0; i < bulletCount; i++){
      if(bulletState[i]){
        bulletPosX[i] = heroPosX;
        bulletPosY[i] = heroPosY;
        bulletState[i] = false;
        break;
      }
    }
  }
}


// Distance de la camera au sujet.
float rayon = 1600;

// Angle de la camera avec le sujet sur le plan XZ.
float theta = 0;
// Angle de la camera avec le sujet sur le plan YZ.
float phi = 0;

// Position cartésienne de la camera
// calculée à partir du rayon et de l'angle.
float camX = 0;
float camY = 0;
float camZ = 0;


PImage deskPlaneTextureImage;
PImage mouseTopTextureImage;
PImage keyboardTopTextureImage;
PImage computerFrontTextureImage;
PImage screenWallpaperTextureImage;
PImage classRoomRoofTopTextureImage;
PImage classRoomFloorTextureImage;
PImage decorationFrameTextureImage1;
PImage decorationFrameTextureImage2;
PImage decorationFrameTextureImage3;
PImage doorTextureImage;

PShape wholeDesk;
PShape classRoom;




void setup() {
  size(600, 600, P3D);

  deskPlaneTextureImage = loadImage("deskPlaneTexture.png");
  //mouseTopTextureImage = loadImage("mouseTopTexture.png");
  //keyboardTopTextureImage=loadImage("keyboardTopTexture.png");
  //computerFrontTextureImage =  loadImage("computerFrontTexture.png");
  //screenWallpaperTextureImage = loadImage("screenWallpaper.png");
  classRoomRoofTopTextureImage = loadImage("classRoomRoofTopTexture.png");
  classRoomFloorTextureImage = loadImage("classRoomFloorTexture.png");
  decorationFrameTextureImage1 = loadImage("decorationImage1.png");
  decorationFrameTextureImage2 = loadImage("decorationImage2.png");
  decorationFrameTextureImage3 = loadImage("decorationImage3.png");
  doorTextureImage = loadImage("doorTexture.png");

  //wholeDesk = createWholeDesk(200, 125, 5);

  classRoom = createClassRoomShell(1200, 900, 300);
}

void draw() {
  background(191);

  translate(width/2, height/2, 0);

  bougerCamera();

  camera(
    camX, camY, camZ,
    0, 0, 0,
    0, 1, 0);

  //shape(wholeDesk);
  shape(classRoom);
}


PShape createClassRoomShell(float w, float h, float t) {
  PShape classRoom = createShape(GROUP);

  PShape frontWall, backWall, rooftop, floor, leftWall, rightWall;
  PShape chalkBoard, doorLeft, doorRight;
  PShape decorationFrame1, decorationFrame2, decorationFrame3;


  frontWall = createClassRoomFrontWall(h, t, 1);
  chalkBoard = createClassRoomChalkBoard(h/2, t/2, 1);

  backWall = createClassRoomBackWall(h, t, 1);
  decorationFrame1 = createClassRoomDecorationFrame(t/2, w/8, 1, decorationFrameTextureImage3);

  rooftop = createClassRoomRoofTopWall(h, w, 1);
  floor = createClassRoomFloorWall(h, w, 1);

  rightWall = createClassRoomRightWall(t, w, 1);
  decorationFrame2 = createClassRoomDecorationFrame(t/2, w/8, 1, decorationFrameTextureImage1);
  decorationFrame3 = createClassRoomDecorationFrame(t/2, w/8, 1, decorationFrameTextureImage2);
  doorRight = createClassRoomDoor(t/1.5, w/5, 1);


  frontWall.translate(0, 0, -w/2);
  chalkBoard.translate(h/8, 0, -w/2+2); // +2 to avoid z-fighting

  backWall.translate(0, 0, w/2);
  decorationFrame1.rotateY(PI);
  decorationFrame1.translate(0, 0, w/2-2);

  rooftop.rotateX(HALF_PI);
  rooftop.translate(0, -t/2, 0);

  floor.rotateX(HALF_PI);
  floor.translate(0, t/2, 0);

  rightWall.rotateY(HALF_PI);
  rightWall.rotateX(HALF_PI);
  rightWall.translate(w/2-t/2, 0, 0);
  decorationFrame2.rotateY(-HALF_PI);
  decorationFrame2.translate(w/2-t/2 -2, 0, 0);
  decorationFrame3.rotateY(-HALF_PI);
  decorationFrame3.translate(w/2-t/2 -2, 0, t);
  doorRight.rotateY(-HALF_PI);
  doorRight.translate(w/2-t/2 -2, t/10, -t);

  classRoom.addChild(frontWall);
  classRoom.addChild(chalkBoard);

  classRoom.addChild(backWall);
  classRoom.addChild(decorationFrame1);

  classRoom.addChild(rooftop);
  classRoom.addChild(floor);
  //classRoom.addChild(leftWall);

  classRoom.addChild(rightWall);
  classRoom.addChild(decorationFrame2);
  classRoom.addChild(decorationFrame3);
  classRoom.addChild(doorRight);

  return classRoom;
}

PShape createClassRoomFrontWall(float w, float h, float t) {
  PShape frontWall = createShape(GROUP);

  PVector[] emissveness = { // no emissivness
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
  };

  PImage[] frontWallTexture = {
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
  };
  int[] tints = {
    255, 255, 255, 255, 255, 255,
  };

  frontWall = createUnitaryBox(frontWallTexture, emissveness, tints);
  frontWall.scale(w, h, t);


  return frontWall;
}

PShape createClassRoomChalkBoard(float w, float h, float t) {
  PShape chalkBoard = createShape(GROUP);

  PVector[] emissveness = { // no emissivness
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
  };

  PImage[] chalkBoardTexture = {
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
  };
  int[] tints = {
    120, 120, 120, 120, 120, 120
  };

  chalkBoard = createUnitaryBox(chalkBoardTexture, emissveness, tints);
  chalkBoard.scale(w, h, t);


  return chalkBoard;
}

PShape createClassRoomBackWall(float w, float h, float t) {
  PShape backWall = createShape(GROUP);

  PVector[] emissveness = { // no emissivness
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
  };

  PImage[] backWallTexture = {
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
  };
  int[] tints = {
    255, 255, 255, 255, 255, 255,
  };

  backWall = createUnitaryBox(backWallTexture, emissveness, tints);
  backWall.scale(w, h, t);

  return backWall;
}


PShape createClassRoomRoofTopWall(float w, float h, float t) {
  PShape rooftop = createShape(GROUP);

  PVector[] emissveness = { // no emissivness
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
  };

  PImage[] rooftopWallTexture = {
    classRoomRoofTopTextureImage,
    classRoomRoofTopTextureImage,
    classRoomRoofTopTextureImage,
    classRoomRoofTopTextureImage,
    classRoomRoofTopTextureImage,
    classRoomRoofTopTextureImage,
  };
  int[] tints = {
    255, 255, 255, 255, 255, 255,
  };

  rooftop = createUnitaryBox(rooftopWallTexture, emissveness, tints);
  rooftop.scale(w, h, t);

  return rooftop;
}


PShape createClassRoomFloorWall(float w, float h, float t) {
  PShape floor = createShape(GROUP);

  PVector[] emissveness = { // no emissivness
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
  };

  PImage[] floorWallTexture = {
    classRoomFloorTextureImage,
    classRoomFloorTextureImage,
    classRoomFloorTextureImage,
    classRoomFloorTextureImage,
    classRoomFloorTextureImage,
    classRoomFloorTextureImage,
  };
  int[] tints = {
    255, 255, 255, 255, 255, 255,
  };

  floor = createUnitaryBox(floorWallTexture, emissveness, tints);
  floor.scale(w, h, t);

  return floor;
}


PShape createClassRoomRightWall(float w, float h, float t) {
  PShape rightWall = createShape(GROUP);

  PVector[] emissveness = { // no emissivness
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
  };

  PImage[] rightWallTexture = {
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
  };
  int[] tints = {
    255, 255, 255, 255, 255, 255,
  };

  rightWall = createUnitaryBox(rightWallTexture, emissveness, tints);
  rightWall.scale(w, h, t);

  return rightWall;
}

PShape createClassRoomDoor(float w, float h, float t) {
  PShape door = createShape(GROUP);

  PVector[] emissveness = { // no emissivness
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
  };

  PImage[] doorTexture = {
    doorTextureImage,
    doorTextureImage,
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
  };
  int[] tints = {
    255, 255, 50, 50, 50, 50
  };

  door = createUnitaryBox(doorTexture, emissveness, tints);
  door.scale(w, h, t);

  return door;
}


PShape createClassRoomDecorationFrame(float w, float h, float t, PImage texture) {
  PShape frame = createShape(GROUP);

  PVector[] emissveness = { // no emissivness
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
  };

  PImage[] frameTexture = {
    texture,
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
  };
  int[] tints = {
    255, 50, 255, 255, 255, 255, // ignore the back and make the sides the same color as the texture
  };

  frame = createUnitaryBox(frameTexture, emissveness, tints);
  frame.scale(w, h, t);

  return frame;
}


PShape createWholeDesk(float w, float h, float t) {
  PShape wholeDesk = createShape(GROUP);

  PShape screen;
  PShape computer;
  PShape keyboard;
  PShape mouse;
  PShape desk;
  PShape chair;

  screen = createScreenShape(w/3, h/3, t/3);

  computer = createComputerShape(w/8, h/4, t*8);
  computer.translate(w/3, h/8.5, 0);

  keyboard = createKeyboardShape(w/5, h/6, t/3);
  keyboard.translate(0, h/4, w/5);

  mouse = createMouseShape(w/25, h/12, t/5);
  mouse.translate(w/5, h/4, w/5);

  desk = createDeskShape(w, h, t);
  desk.translate(0, h/3.5, 0);

  chair = createChairShape(w/2.5, h/1.5, t);
  chair.rotateY(PI);
  chair.translate(0, h/4, h/1.5);

  wholeDesk.addChild(screen);
  wholeDesk.addChild(computer);
  wholeDesk.addChild(keyboard);
  wholeDesk.addChild(mouse);
  wholeDesk.addChild(chair);
  wholeDesk.addChild(desk);

  return wholeDesk;
}


PShape createChairShape(float w, float h, float t) {
  PShape chair = createShape(GROUP);


  PVector[] emissveness = { // no emissivness
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
  };

  PImage[] backRestTexture = {
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
  };
  int[] chairRestAreasTints = {
    255, 255, 255, 255, 255, 255,
  };

  PShape backRest = createUnitaryBox(backRestTexture, emissveness, chairRestAreasTints);
  backRest.scale(w, h, t);


  PImage[] buttomRest = {
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
  };


  PShape buttom =createUnitaryBox(buttomRest, emissveness, chairRestAreasTints);
  buttom.scale(w, h, t);
  buttom.rotateX(HALF_PI);
  buttom.translate(0, w/2, h/2);

  PImage[] legsTextures = {
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
  };

  int[] tints = {
    50, 50, 50, 50, 50, 50,
  };

  PShape[] legs = {
    createUnitaryBox(legsTextures, emissveness, tints),
    createUnitaryBox(legsTextures, emissveness, tints),
    createUnitaryBox(legsTextures, emissveness, tints),
    createUnitaryBox(legsTextures, emissveness, tints),
  };



  legs[0].scale(w/10, h, t*2);
  legs[0].translate(-w/2, h);

  legs[1].scale(w/10, h, t*2);
  legs[1].translate(w/2, h);

  legs[2].scale(w/10, h, t*2);
  legs[2].translate(-w/2, h, h);

  legs[3].scale(w/10, h, t*2);
  legs[3].translate(w/2, h, h);



  chair.addChild(backRest);
  chair.addChild(buttom);

  chair.addChild(legs[0]);
  chair.addChild(legs[1]);
  chair.addChild(legs[2]);
  chair.addChild(legs[3]);

  return chair;
}


PShape createDeskShape(float w, float h, float t) {
  PShape desk = createShape(GROUP);


  PVector[] emissveness = {  // no emissveness
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
  };

  PImage[] deskPlaneTexture = {
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
    deskPlaneTextureImage,
  };

  int[] deskPlaneTints = {
    255, 255, 255, 255, 255, 255,
  };

  PShape deskPlane = createUnitaryBox(deskPlaneTexture, emissveness, deskPlaneTints);
  deskPlane.scale(w, h, t);



  PImage[] legsTextures = {
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
  };
  int[] tints = {
    50, 50, 50, 50, 50, 50,
  };

  PShape[] legs = {
    createUnitaryBox(legsTextures, emissveness, tints),
    createUnitaryBox(legsTextures, emissveness, tints),
    createUnitaryBox(legsTextures, emissveness, tints),
    createUnitaryBox(legsTextures, emissveness, tints),
  };

  legs[0].scale(w/20, h, t);
  legs[0].rotateX(-HALF_PI);
  legs[0].translate(-w/2, -h/2, h/2);

  legs[1].scale(w/20, h, t);
  legs[1].rotateX(-HALF_PI);
  legs[1].translate(w/2, -h/2, h/2);

  legs[2].scale(w/20, h, t);
  legs[2].rotateX(-HALF_PI);
  legs[2].translate(-w/2, h/2, h/2);

  legs[3].scale(w/20, h, t);
  legs[3].rotateX(-HALF_PI);
  legs[3].translate(w/2, h/2, h/2);



  desk.addChild(deskPlane);


  desk.addChild(legs[0]);
  desk.addChild(legs[1]);
  desk.addChild(legs[2]);
  desk.addChild(legs[3]);

  desk.rotateX(-HALF_PI);
  return desk;
}

PShape createMouseShape(float w, float h, float t) {
  PShape mouse;

  PVector[] emissveness = { // no emissivness
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
  };

  PImage[] mouseTexture = {
    mouseTopTextureImage,
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
  };
  int[] tints = {
    191,
    50, 50, 50, 50, 50,
  };
  mouse = createUnitaryBox(mouseTexture, emissveness, tints);
  mouse.scale(w, h, t);
  mouse.rotateX(HALF_PI);

  return mouse;
}

PShape createKeyboardShape(float w, float h, float t) {
  PShape keyboard;


  PVector[] emissveness = { // no emissivness
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
  };

  PImage[] keyboardTexture = {
    keyboardTopTextureImage,
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
  };
  int[] tints = {
    255,
    50, 50, 50, 50, 50,
  };


  keyboard = createUnitaryBox(keyboardTexture, emissveness, tints);
  keyboard.scale(w, h, t);
  keyboard.rotateX(HALF_PI);

  return keyboard;
}


PShape createComputerShape(float w, float h, float t) {
  PShape computer;


  PVector[] emissveness = { // no emissivness
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
  };

  PImage[] computerTexture = {
    computerFrontTextureImage,
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
  };
  int[] tints = {
    255,
    50, 50, 50, 50, 50,
  };


  computer = createUnitaryBox(computerTexture, emissveness, tints);
  computer.scale(w, h, t);


  return computer;
}


PShape createScreenShape(float w, float h, float t) {
  PShape screen = createShape(GROUP);



  PVector[] screenEmissveness = {
    new PVector(200, 10, 10),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
  };

  PImage[] screenPlaneTexture = {
    screenWallpaperTextureImage,
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
  };

  int[] screenTints = {
    255, // for the display
    50, 50, 50, 50, 50, // for the other sides
  };

  PShape screenPlane = createUnitaryBox(screenPlaneTexture, screenEmissveness, screenTints);
  screenPlane.scale(w, h, t);



  PVector[] emissveness = { // no emissivness
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
    new PVector(),
  };

  PImage[] legTextures = {
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
    new PImage(),
  };
  int[] legTints = {
    50, 50, 50, 50, 50, 50,
  };

  PShape leg = createUnitaryBox(legTextures, emissveness, legTints);

  leg.scale(w/10, h/2, t);
  leg.translate(0, h/2, -t);


  PShape buttomRestPlane = createUnitaryBox(legTextures, emissveness, legTints);

  buttomRestPlane.scale(w/3, h/2, t);
  buttomRestPlane.rotateX(HALF_PI);

  buttomRestPlane.translate(0, h-h*.3, h/(4*10));



  screen.addChild(screenPlane);
  screen.addChild(leg);
  screen.addChild(buttomRestPlane);


  return screen;
}



PShape createUnitaryBox(PImage[] facesTextures, PVector[] facesEmissiveness, int[] facesTints) {
  assert(facesTextures.length == 6);
  assert(facesEmissiveness.length == 6);
  assert(facesTints.length == 6);

  PShape box = createShape(GROUP);

  PShape[] faces = {
    createShape(),
    createShape(),
    createShape(),
    createShape(),
    createShape(),
    createShape(),
  };

  float c = 0.5;


  // AVANT

  faces[0].beginShape();
  faces[0].noStroke();
  faces[0].textureMode(NORMAL);
  faces[0].texture(facesTextures[0]);
  faces[0].tint(facesTints[0]);
  faces[0].emissive(facesEmissiveness[0].x, facesEmissiveness[0].y, facesEmissiveness[0].z);
  faces[0].vertex(-c, -c, c, 0, 0);
  faces[0].vertex(-c, c, c, 0, 1);
  faces[0].vertex(c, c, c, 1, 1);
  faces[0].vertex(c, -c, c, 1, 0);
  faces[0].endShape();


  // FOND
  faces[1].beginShape();
  faces[1].noStroke();
  faces[1].textureMode(NORMAL);
  faces[1].texture(facesTextures[1]);
  faces[1].tint(facesTints[1]);
  faces[1].emissive(facesEmissiveness[1].x, facesEmissiveness[1].y, facesEmissiveness[1].z);
  faces[1].vertex(-c, -c, -c, 0, 0);
  faces[1].vertex(-c, c, -c, 0, 1);
  faces[1].vertex(c, c, -c, 1, 1);
  faces[1].vertex(c, -c, -c, 1, 0);
  faces[1].endShape();

  // HAUT
  faces[2].beginShape();
  faces[2].noStroke();
  faces[2].textureMode(NORMAL);
  faces[2].texture(facesTextures[2]);
  faces[2].tint(facesTints[2]);
  faces[2].emissive(facesEmissiveness[2].x, facesEmissiveness[2].y, facesEmissiveness[2].z);
  faces[2].vertex(-c, -c, c, 0, 0);
  faces[2].vertex(c, -c, c, 1, 0);
  faces[2].vertex(c, -c, -c, 1, 1);
  faces[2].vertex(-c, -c, -c, 0, 1);
  faces[2].endShape();


  // GAUCHE
  faces[3].beginShape();
  faces[3].noStroke();
  faces[3].textureMode(NORMAL);
  faces[3].texture(facesTextures[3]);
  faces[3].tint(facesTints[3]);
  faces[3].emissive(facesEmissiveness[3].x, facesEmissiveness[3].y, facesEmissiveness[3].z);
  faces[3].vertex(-c, -c, c, 1, 1);
  faces[3].vertex(-c, -c, -c, 0, 1);
  faces[3].vertex(-c, c, -c, 0, 0);
  faces[3].vertex(-c, c, c, 1, 0);
  faces[3].endShape();

  // DROITE
  faces[4].beginShape();
  faces[4].noStroke();
  faces[4].textureMode(NORMAL);
  faces[4].texture(facesTextures[4]);
  faces[4].tint(facesTints[4]);
  faces[4].emissive(facesEmissiveness[4].x, facesEmissiveness[4].y, facesEmissiveness[4].z);
  faces[4].vertex(c, -c, c, 1, 1);
  faces[4].vertex(c, -c, -c, 0, 1);
  faces[4].vertex(c, c, -c, 0, 0);
  faces[4].vertex(c, c, c, 1, 0);
  faces[4].endShape();

  // BAS
  faces[5].beginShape();
  faces[5].noStroke();
  faces[5].textureMode(NORMAL);
  faces[5].texture(facesTextures[5]);
  faces[5].tint(facesTints[5]);
  faces[5].emissive(facesEmissiveness[5].x, facesEmissiveness[5].y, facesEmissiveness[5].z);
  faces[5].vertex(-c, c, c, 0, 0);
  faces[5].vertex(c, c, c, 1, 0);
  faces[5].vertex(c, c, -c, 1, 1);
  faces[5].vertex(-c, c, -c, 0, 1);
  faces[5].endShape();



  for (int i = 0; i < faces.length; i++) {
    box.addChild(faces[i]);
  }
  return box;
}

void bougerCamera() {
  // Calcul de la position cartésienne sur le
  // plan XZ et YZ en même temps :
  camX = rayon * cos(phi) * sin(theta);
  camY = rayon * sin(phi);
  camZ = rayon * cos(phi) * cos(theta);


  // On incrémente l'angle :
  if (pmouseX < mouseX)
    theta = (theta - 0.05) % TWO_PI;
  else if (pmouseX > mouseX)
    theta = (theta + 0.05) % TWO_PI;

  if (pmouseY < mouseY)
    phi = (phi - 0.05) % TWO_PI;
  else if (pmouseY > mouseY)
    phi = (phi + 0.05) % TWO_PI;
}

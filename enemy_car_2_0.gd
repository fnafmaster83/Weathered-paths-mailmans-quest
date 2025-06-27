<!DOCTYPE html>
<html>
<head>
  <title>Car Chase Game</title>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.4.2/p5.min.js"></script>
</head>
<body>
<script>
let playerCar;
let enemyCar;
let mapWidth = 800;
let mapHeight = 600;
let gameOver = false;

function setup() {
  createCanvas(mapWidth, mapHeight);
  // Initialize player car at center
  playerCar = {
	x: mapWidth / 2,
	y: mapHeight / 2,
	angle: 0,
	speed: 0,
	maxSpeed: 5,
	acceleration: 0.2,
	rotationSpeed: 0.05
  };
  // Initialize enemy car at a random position
  enemyCar = {
	x: random(50, mapWidth - 50),
	y: random(50, mapHeight - 50),
	angle: 0,
	speed: 0,
	maxSpeed: 3,
	acceleration: 0.1
  };
}

function draw() {
  background(220);
  // Draw map boundaries
  stroke(0);
  noFill();
  rect(0, 0, mapWidth, mapHeight);

  if (!gameOver) {
	// Update and draw player car
	updatePlayerCar();
	drawCar(playerCar, color(0, 0, 255)); // Blue for player

	// Update and draw enemy car
	updateEnemyCar();
	drawCar(enemyCar, color(255, 0, 0)); // Red for enemy

	// Check for collision
	if (checkCollision()) {
	  gameOver = true;
	}
  } else {
	// Display game over message
	textSize(32);
	fill(255, 0, 0);
	textAlign(CENTER, CENTER);
	text("Game Over! Press R to Restart", mapWidth / 2, mapHeight / 2);
  }
}

function updatePlayerCar() {
  // Player controls
  if (keyIsDown(UP_ARROW)) {
	playerCar.speed = min(playerCar.speed + playerCar.acceleration, playerCar.maxSpeed);
  } else if (keyIsDown(DOWN_ARROW)) {
	playerCar.speed = max(playerCar.speed - playerCar.acceleration, -playerCar.maxSpeed / 2);
  } else {
	playerCar.speed *= 0.95; // Gradual slowdown
  }
  if (keyIsDown(LEFT_ARROW)) {
	playerCar.angle -= playerCar.rotationSpeed;
  }
  if (keyIsDown(RIGHT_ARROW)) {
	playerCar.angle += playerCar.rotationSpeed;
  }

  // Update player position
  playerCar.x += cos(playerCar.angle) * playerCar.speed;
  playerCar.y += sin(playerCar.angle) * playerCar.speed;

  // Keep player within map bounds
  playerCar.x = constrain(playerCar.x, 20, mapWidth - 20);
  playerCar.y = constrain(playerCar.y, 20, mapHeight - 20);
}

function updateEnemyCar() {
  // Calculate direction to player
  let dx = playerCar.x - enemyCar.x;
  let dy = playerCar.y - enemyCar.y;
  let targetAngle = atan2(dy, dx);

  // Smoothly rotate towards player
  let angleDiff = targetAngle - enemyCar.angle;
  angleDiff = (angleDiff + PI) % TWO_PI - PI; // Normalize to [-PI, PI]
  enemyCar.angle += constrain(angleDiff, -0.05, 0.05);

  // Move towards player autonomously
  let distance = dist(enemyCar.x, enemyCar.y, playerCar.x, playerCar.y);
  if (distance > 20) { // Reduced minimum distance for collision
	enemyCar.speed = min(enemyCar.speed + enemyCar.acceleration, enemyCar.maxSpeed);
  } else {
	enemyCar.speed *= 0.9; // Slow down when very close
  }

  // Update enemy position
  enemyCar.x += cos(enemyCar.angle) * enemyCar.speed;
  enemyCar.y += sin(enemyCar.angle) * enemyCar.speed;

  // Keep enemy within map bounds
  enemyCar.x = constrain(enemyCar.x, 20, mapWidth - 20);
  enemyCar.y = constrain(enemyCar.y, 20, mapHeight - 20);
}

function checkCollision() {
  // Simple bounding box collision detection
  let playerBox = { x: playerCar.x - 15, y: playerCar.y - 7.5, w: 30, h: 15 };
  let enemyBox = { x: enemyCar.x - 15, y: enemyCar.y - 7.5, w: 30, h: 15 };
  return (
	playerBox.x < enemyBox.x + enemyBox.w &&
	playerBox.x + playerBox.w > enemyBox.x &&
	playerBox.y < enemyBox.y + enemyBox.h &&
	playerBox.y + playerBox.h > enemyBox.y
  );
}

function drawCar(car, col) {
  push();
  translate(car.x, car.y);
  rotate(car.angle);
  fill(col);
  rectMode(CENTER);
  rect(0, 0, 30, 15); // Simple car shape
  pop();
}

function keyPressed() {
  // Reset game with 'R'
  if (keyCode === 82) {
	playerCar.x = mapWidth / 2;
	playerCar.y = mapHeight / 2;
	playerCar.speed = 0;
	playerCar.angle = 0;
	enemyCar.x = random(50, mapWidth - 50);
	enemyCar.y = random(50, mapHeight - 50);
	enemyCar.speed = 0;
	enemyCar.angle = 0;
	gameOver = false;
  }
}
</script>
</body>
</html>

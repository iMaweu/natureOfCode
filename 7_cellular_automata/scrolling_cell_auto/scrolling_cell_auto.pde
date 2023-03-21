// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Wolfram Cellular Automata

// Simple demonstration of a Wolfram 1-dimensional cellular automata
// with the system scrolling by
// Also implements wrap around

CA ca;   // An object to describe a Wolfram elementary Cellular Automata

int ruleId;

//int [] coolRuleSetIds = {109, 114, 105, 165, 73, 86, 89, 90, 102, 110, 124, 126, 129, 135, 137, 146, 149, 181, 169};
int [] coolRuleSetIds = {105, 105};

void setup() {
  size(700, 1000);
  frameRate(30);
  background(255);
  // 222, 190, 30, 110, 90
  int[] ruleset = {0,1,1,1,1,0,0,0};   // Rule 30
  ruleId = -1;
  
  ca = new CA(ruleset);                 // Initialize CA
  ca.setRuleSet (169);
}

void draw() {
  background(255);
  if(!mousePressed) {
    ca.display();          // Draw the CA
    ca.generate();
  }
  else
  {
    ruleId++;
    if (ruleId < coolRuleSetIds.length) {
      ca.restart (coolRuleSetIds[ruleId]);
      ca.display();          // Draw the CA
      ca.generate();
    }
    else {
      ruleId = 0;
    }
  }
}

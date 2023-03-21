int [] convertRuleIdToRuleSet (int ruleId)
{
  String binaryString = binary(ruleId,8);
  int [] result = new int [8];
  for (int j = 0; j < 8; j++) {
    int digit = binaryString.charAt(7-j) == '1' ? 1 : 0;
    result[j] = digit;
  }
  return result;
}

int convertRuleSetToRuleId (int[]rs)
{
  String s = "";
  for(int i = (rs.length-1); i >= 0; i--) {
    s += rs[i];
  }
  return Integer.parseInt(s, 2);
}

void printRuleSet(int [] rs)
{
  for(int i = 0; i < rs.length; i++) {
    print (rs[i], ' ');
  }
}

void printRuleSet(int ruleId)
{
  printRuleSet (convertRuleIdToRuleSet (ruleId));
}

void printRules ()
{
  //int[] crs = {0,1,1,1,1,0,1,1};   // Rule 222
  for (int i = 0; i <= 255; i ++) {
    //if (i == 222)
    {
      printRuleSet(convertRuleIdToRuleSet(i));
      print (" : ", i, '\n');
    }
  }
}

// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Wolfram Cellular Automata

// A class to manage the CA
 
class CA {
  int [] ruleset;     // An array to store the ruleset, for example {0,1,1,0,1,1,0,1}
  int cellSize = 3;  // (w)
  int genLen;         // (cols) number of cells in a generation == width/cellSize
  int numOfGen;       // (rows) number of generations on the screen  == height/cellSize

  int [][] matrix;    // Store a history of generations in 2D array, not just one
  int currentGen;     // (generation) current generation 
  
  CA(int [] rs) {
    ruleset = rs;
    genLen = width/cellSize;
    numOfGen = height/cellSize;
    matrix = new int [numOfGen][genLen];
    restart ();
  }

  // Reset to generation 0
  void restart () {
    for (int genId = 0; genId < matrix.length; genId++)
      for (int cellId = 0; cellId < matrix[0].length; cellId++)
        matrix[genId][cellId] = 0;
     
     matrix[0][genLen/2] = 1;
     matrix[0][int(random(genLen))] = 1;
     matrix[0][int(random(genLen))] = 1;
     matrix[0][int(random(genLen))] = 1;
     currentGen = 0;
  }
  
  void restart (int ruleId) {
    restart ();
    setRuleSet(ruleId);
    print("start with rule: ", ruleId, " : ");
    printRuleSet (ruleId);
    print('\n');
  }

  void generate () {
    for (int cellId = 0; cellId < genLen; cellId++) {
      int rightCellId = (cellId + 1) % genLen;           // %genLen so that last cell uses first cell as its
                                                         // right hand side cell. (wraparound)
      
      int leftCellId =  (cellId - 1 + genLen) % genLen;  // +genLen because we don't want to take modulus
                                                         // of a negative number. Equivalent to: (cellId - 1) % genLen

      
      // %numOfGen below because after currentGen goes past numOfGen we want to overwrite the oldest generation
      // since it will not be displayed due to scrolling, that is ((currentGen + 1) % numOfGen)
      matrix[(currentGen + 1) % numOfGen][cellId] = rules(matrix[currentGen % numOfGen][leftCellId]
                                                        , matrix[currentGen % numOfGen][cellId]
                                                        , matrix[currentGen % numOfGen][rightCellId]);  
    }
    currentGen++;
  }
  
  // This is the easy part, just draw the cells, fill 255 for '1', fill 0 for '0'
  void display () {
    int offset = currentGen % numOfGen;
    for (int genId = 0; genId < matrix.length; genId++) {
      for (int cellId = 0; cellId < matrix[0].length; cellId++) {
        
        int y = genId - offset;          // shift all generations up by offset to keep the oldest generation at the top
        
        if (y <= 0) {
          y = y + numOfGen;              // new/latset generations shifted out of view should now be displayed at the
                                         // bottom of the screen
        }
        
        if (matrix[genId][cellId] == 1) {
          fill(0);
        }
        else {
          fill(255);
        }

        noStroke ();

        rect (cellId * cellSize
            , (y-1) * cellSize
            , cellSize
            , cellSize);
      }
    }
  }

  // This is the easy part, just draw the cells, fill 255 for '1', fill 0 for '0'
  void displayMatrixScreenShots () {
    for (int genId = 0; genId < matrix.length; genId++) {
      for (int cellId = 0; cellId < matrix[0].length; cellId++) {
        
        if (matrix[genId][cellId] == 1) {
          fill(0);
        }
        else {
          fill(255);
        }

        noStroke ();

        rect (cellId * cellSize
            , genId * cellSize
            , cellSize
            , cellSize);
      }
    }
  }

  int rules (int a, int b, int c) {
    String s = "" + a + b + c;
    int index = Integer.parseInt(s, 2);
    return ruleset[index];
  }
  
  void setRuleSet (int ruleId)
  {
    ruleset = convertRuleIdToRuleSet(ruleId);
  }
  
  // The CA is done if it reaches the bottom of the screen
  boolean finished() {
    if (currentGen > numOfGen) {
      return true;
    } 
    else {
      return false;
    }
  }
  
  void printDisplayDebug (int offset) {  
    print("currentGen: ", currentGen, '\n');
    print("offset: ", offset, "\n\n");
  }

  void printCAInvariants () {
    print ("genLen: ", genLen, "\n");                     // e.g. genLen:  32
    print ("numOfGen: ", numOfGen, "\n");                 // e.g. numOfGen:  40
    print ("matrix = new int [numOfGen][genLen] ", "\n"); // e.g. matrix = new int [numOfGen][genLen]
    print ("matrix[0].length: ", matrix[0].length, "\n"); // e.g. matrix[0].length: 32
    print ("matrix.length: ", matrix.length, "\n");       // e.g. matrix.length: 40
  }
  
  void printMatrix () {
    for (int [] genearation : matrix) {
      for (int cellId = 0; cellId < genearation.length; cellId++) {
        print (genearation[cellId], ' ');
      }
      print ('\n');
    }
  }
}

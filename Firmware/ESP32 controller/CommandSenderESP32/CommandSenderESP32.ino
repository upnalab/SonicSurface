#include "WiFi.h"

#include "EmitterPos.h"
#include "FocusAlg.h"
#include "PointsMov.h"

#define ESPFOCAL_VERSION "0.0"

#define BUTTON_PIN 12


/* Array control functions */
int ibpIterations = 4;
byte buff[N_EMITTERS]; //phases to be emitted
float pointPos[MAX_POINTS * 3];

void switchOnArray(boolean onTop, boolean onBottom);
void switchBuffer();
void sendBuffer();
void sendPhases(String command);

void processCommand(String command);

int parseFloats(String s, int startIndex, float target[], int maxNumbers);

/* Network functions*/

const char* ssid = "FOCAL_ESP";
const char* password = "12345678";
WiFiServer server(80);

void configWifiAsAccessPoint(const char* ssidName) {
  Serial.println("Configuring as access point...");
  WiFi.mode(WIFI_AP);
  WiFi.softAP( ssidName, password );
  Serial.println("Wait 100 ms for AP_START...");
  delay(100);

  Serial.println("Set softAPConfig");
  IPAddress Ip(192, 168, 1, 1);
  IPAddress NMask(255, 255, 255, 0);
  WiFi.softAPConfig(Ip, Ip, NMask);
  IPAddress myIP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(myIP);
}


/* Setup*/
void setup() {
  Serial.begin(230400); // this serial is for receiving commands and sending debug info to the computer
  Serial2.begin(230400, SERIAL_8N1, 17, 16); //RX2 TX2 This serial communicates with the array
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  Serial.println(ESPFOCAL_VERSION);
  Serial.println( ssid );

  configWifiAsAccessPoint( ssid ); //start as access point with regular ssid
  server.begin();
  delay(200);

  Serial2.write( 151 ); //switch on the FPGA clocks (in case that they were off with the 150 command send at random during start up)
  Serial.println("Switching off the array...");
  switchOnArray(false, false);

  ibp_initEmitters();
}


void focusArrayAtPoints() {
  //this is the IBP method. slow but stronger trapping points. hard to join at closer distances.
  ibp_initPropagators(2, pointPos);
  for (int i = 0; i < ibpIterations; ++i)
    ibp_iterate( 2 );
  ibp_applySolution(2, buff);
  
  
  //this is the other method. faster, works at closer distances but not as strong
  //multiFocusAt(2,  pointPos,  buff);

  sendBuffer();
}

int previousButton = HIGH;
int cyclesButtonHigh = 0;
enum ePointsStatus {statusOff, statusFocus, statusMoving};
ePointsStatus currentStatus = statusOff;
void loop() {

  /* button press */
  const int currentButtonState = digitalRead(BUTTON_PIN);
  if (previousButton == HIGH && currentButtonState == LOW && cyclesButtonHigh > 100) { //when the button is pressed. last part is for debouncing
    cyclesButtonHigh = 0;
    /* button has been pressed*/
    Serial.println("Button has been pressed");
    if (currentStatus == statusOff) {
      Serial.println("Focusing points");
      currentStatus = statusFocus;
      points_reset(2, pointPos, POINTS_MOV_SEP, ARRAY_HEIGHT/2 );
      focusArrayAtPoints();
    } else if (currentStatus == statusFocus) {
      Serial.println("Moving");
      currentStatus = statusMoving;
    } else if (currentStatus == statusMoving) {
      Serial.println("Off");
      currentStatus = statusOff;
      switchOnArray(false, false);
    }
  }
  if (currentButtonState == HIGH && cyclesButtonHigh < 0xFF) {
    cyclesButtonHigh += 1;
  } else if (currentButtonState == LOW) {
    cyclesButtonHigh = 0;
  }
  previousButton = currentButtonState;

  if (currentStatus == statusMoving) {
    points_bringCloser(2,   pointPos, POINTS_MOV_ATTRACTION*2);
    points_rotateAroundY(2,   pointPos, POINTS_MOV_ROT*2);
    focusArrayAtPoints();
    //delay(25);
  }

  /*Commands comming from Serial*/
  if ( Serial.available() ) {
    String command = Serial.readStringUntil('\n');
    processCommand( command);
  }
  /* Commands comming from HTTP */
  WiFiClient client = server.available();
  if (client) {
    String request = client.readStringUntil('\r');
    client.println("HTTP/1.1 200 OK\nContent-type:text/html\nConnection: close\n\n");

    const int sep1 = request.indexOf('/');
    if (sep1 != -1) {
      String command = request.substring(sep1 + 1);
      processCommand( command );
    }
    client.stop();
  }

}



void processCommand(String command) {
  if ( command.startsWith("focus=") ) {
    const int n = parseFloats( command, command.indexOf('=') + 1 , pointPos, 3 );

    Serial.printf("Read %d %f %f %f\n", n, pointPos[0], pointPos[1], pointPos[2] );
    if (n == 3) {
      simpleFocusAt(pointPos, buff );
      sendBuffer();
    }
  }else if ( command.startsWith("itersIBP=") ) {
    ibpIterations = command.substring( command.indexOf('=') + 1).toFloat();
    Serial.printf("IBP iterations set at %d\n", ibpIterations);
  }else if ( command.startsWith("focusIBP=") ) {
    const int n = parseFloats( command, command.indexOf('=') + 1 , pointPos, 3 * MAX_POINTS);
    if (n >= 3 && n % 3 == 0) {
      const int nPoints = n / 3;
      //const long timeBefore = millis();
      ibp_initPropagators(nPoints, pointPos);
      // with 8 iteration it takes 46ms, with 4 it takes 39.
      for (int i = 0; i < ibpIterations; ++i)
        ibp_iterate( nPoints );
      ibp_applySolution(nPoints, buff);
      //const int duration = millis() - timeBefore;
      //Serial.printf("Millis of IBP %d", duration);
      sendBuffer();
    }
  } else if ( command.startsWith("focusMulti=") ) {
    const int n = parseFloats( command, command.indexOf('=') + 1 , pointPos, 3 * MAX_POINTS);
    if (n >= 3 && n % 3 == 0) {
      const int nPoints = n / 3;
      //const long timeBefore = millis();
      //it takes less than 1ms
      multiFocusAt(nPoints,  pointPos,  buff);
      //const int duration = millis() - timeBefore;
      //Serial.printf("Millis of Multi %d", duration);
      sendBuffer();
    }
  } else if ( command.startsWith("phases=") ) {
    sendPhases( command );
  } else if ( command.startsWith("off") ) {
    Serial.println("Switching off the array...");
    switchOnArray(false, false);
  } else if ( command.startsWith("on") ) {
    Serial.println("Switching on the array...");
    switchOnArray(true, true);
  } else if ( command.startsWith("top") ) {
    Serial.println("Switching on top...");
    switchOnArray(true, false);
  } else if ( command.startsWith("bottom") ) {
    Serial.println("Switching on bottom...");
    switchOnArray(false, true);
  } else if ( command.startsWith("switch") ) {
    Serial.println("Switching emissions...");
    switchBuffer();
  } else if ( command.startsWith("version") ) {
    Serial.printf("Version is %s\n", ESPFOCAL_VERSION);
  }

}


void sendBuffer() {
  Serial2.write( 254 ); //start sending phases
  Serial2.write( 192 + 0 ); //for board id 0
  Serial2.write( buff, N_EMITTERS / 2);
  Serial2.write( 192 + 1 ); //for board id 1
  Serial2.write( & buff[N_EMITTERS / 2] , N_EMITTERS / 2);
  Serial2.write( 253 ); //commit
  Serial2.flush();
}

void switchOnArray(boolean onTop, boolean onBottom) {
  for (int j = 0; j < N_EMITTERS / 2; j += 1)
    buff[j] = onTop ? 1 : 32; //32 is the value for switching off the transducer

  for (int j = N_EMITTERS / 2; j < N_EMITTERS; j += 1)
    buff[j] = onBottom ? 1 : 32; //32 is the value for switching off the transducer

  sendBuffer();
}

void switchBuffer() {
  Serial2.write( 253 );
}

void sendPhases(String command) {
  int index = 0;
  int number = 0;
  const int n = command.length();
  for (int i = command.indexOf('=') + 1; i < n; ++i) {
    char c = command.charAt(i);
    if ( c >= '0' && c <= '9') {
      number = number * 10 + (c - '0');
    } else {
      buff[index] = number;
      number = 0;
      index += 1;
      if (index == N_EMITTERS)
        break;
    }
  }
  sendBuffer();
}


int parseFloats(String s, int startIndex, float target[], int maxNumbers) {
  int index = 0;
  const int n = s.length();
  float number = 0;
  boolean haveSeenDecPoint = false;
  boolean haveSeenMinus = false;
  float divider = 10;
  for (int i = startIndex; i < n; ++i) {
    char c = s.charAt(i);
    if ( c >= '0' && c <= '9') {
      if (! haveSeenDecPoint) {
        number = number * 10 + (c - '0');
      } else {
        number += divider * (c - '0');
        divider /= 10;
      }
    } else if ( c == '.') {
      haveSeenDecPoint = true;
      divider = 0.1;
    } else if (c == '-') {
      haveSeenMinus = true;
    } else {
      if (haveSeenMinus) {
        number = -number;
      }
      target[index] = number;
      number = 0;
      haveSeenDecPoint = false;
      haveSeenMinus = false;
      divider = 0.1;
      index += 1;
      if (index == maxNumbers)
        break;
    }
  }
  return index;
}

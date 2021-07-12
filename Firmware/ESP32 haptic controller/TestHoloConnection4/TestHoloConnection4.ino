#include "WiFi.h"


#define ULTRATACT_VERSION "2.1"
const char* ssid = "UltraTactile Master";
const char* ssidMaster = "UltraTactile Master";
const char* password = "12345678";
#define BUTTON_PIN 12
#define MOD_PERIODS_DEFAULT 10

WiFiServer server(80);

#define N_TRANS 256
const float TRANS_POS[N_TRANS*3] = { -0.078749985, 0.0, 0.07874999, -0.05774999, 0.0, 0.07874999, -0.04724999, 0.0, 0.07874999, -0.068249986, 0.0, 0.06824999, -0.078749985, 0.0, 0.06824999, -0.04724999, 0.0, 0.06824999, -0.05774999, 0.0, 0.06824999, -0.068249986, 0.0, 0.07874999, -0.078749985, 0.0, 0.057749998, -0.05774999, 0.0, 0.057749998, -0.04724999, 0.0, 0.057749998, -0.068249986, 0.0, 0.04725, -0.078749985, 0.0, 0.04725, -0.04724999, 0.0, 0.04725, -0.05774999, 0.0, 0.04725, -0.068249986, 0.0, 0.057749998, -0.078749985, 0.0, 0.036750004, -0.05774999, 0.0, 0.036750004, -0.04724999, 0.0, 0.036750004, -0.068249986, 0.0, 0.026250003, -0.078749985, 0.0, 0.026250003, -0.04724999, 0.0, 0.026250003, -0.05774999, 0.0, 0.026250003, -0.068249986, 0.0, 0.036750004, -0.078749985, 0.0, 0.015750004, -0.05774999, 0.0, 0.015750004, -0.04724999, 0.0, 0.015750004, -0.068249986, 0.0, 0.0052500046, -0.078749985, 0.0, 0.0052500046, -0.04724999, 0.0, 0.0052500046, -0.05774999, 0.0, 0.0052500046, -0.068249986, 0.0, 0.015750004, -0.078749985, 0.0, -0.005249995, -0.05774999, 0.0, -0.005249995, -0.04724999, 0.0, -0.005249995, -0.068249986, 0.0, -0.015749995, -0.078749985, 0.0, -0.015749995, -0.04724999, 0.0, -0.015749995, -0.05774999, 0.0, -0.015749995, -0.068249986, 0.0, -0.005249995, -0.078749985, 0.0, -0.026249994, -0.05774999, 0.0, -0.026249994, -0.04724999, 0.0, -0.026249994, -0.068249986, 0.0, -0.036749996, -0.078749985, 0.0, -0.036749996, -0.04724999, 0.0, -0.036749996, -0.05774999, 0.0, -0.036749996, -0.068249986, 0.0, -0.026249994, -0.078749985, 0.0, -0.04724999, -0.05774999, 0.0, -0.04724999, -0.04724999, 0.0, -0.04724999, -0.068249986, 0.0, -0.05774999, -0.078749985, 0.0, -0.05774999, -0.04724999, 0.0, -0.05774999, -0.05774999, 0.0, -0.05774999, -0.068249986, 0.0, -0.04724999, -0.078749985, 0.0, -0.068249986, -0.05774999, 0.0, -0.068249986, -0.04724999, 0.0, -0.068249986, -0.068249986, 0.0, -0.078749985, -0.078749985, 0.0, -0.078749985, -0.04724999, 0.0, -0.078749985, -0.05774999, 0.0, -0.078749985, -0.068249986, 0.0, -0.068249986, -0.036749996, 0.0, 0.07874999, -0.015749995, 0.0, 0.07874999, -0.005249995, 0.0, 0.07874999, -0.026249994, 0.0, 0.06824999, -0.036749996, 0.0, 0.06824999, -0.005249995, 0.0, 0.06824999, -0.015749995, 0.0, 0.06824999, -0.026249994, 0.0, 0.07874999, -0.036749996, 0.0, 0.057749998, -0.015749995, 0.0, 0.057749998, -0.005249995, 0.0, 0.057749998, -0.026249994, 0.0, 0.04725, -0.036749996, 0.0, 0.04725, -0.005249995, 0.0, 0.04725, -0.015749995, 0.0, 0.04725, -0.026249994, 0.0, 0.057749998, -0.036749996, 0.0, 0.036750004, -0.015749995, 0.0, 0.036750004, -0.005249995, 0.0, 0.036750004, -0.026249994, 0.0, 0.026250003, -0.036749996, 0.0, 0.026250003, -0.005249995, 0.0, 0.026250003, -0.015749995, 0.0, 0.026250003, -0.026249994, 0.0, 0.036750004, -0.036749996, 0.0, 0.015750004, -0.015749995, 0.0, 0.015750004, -0.005249995, 0.0, 0.015750004, -0.026249994, 0.0, 0.0052500046, -0.036749996, 0.0, 0.0052500046, -0.005249995, 0.0, 0.0052500046, -0.015749995, 0.0, 0.0052500046, -0.026249994, 0.0, 0.015750004, -0.036749996, 0.0, -0.005249995, -0.015749995, 0.0, -0.005249995, -0.005249995, 0.0, -0.005249995, -0.026249994, 0.0, -0.015749995, -0.036749996, 0.0, -0.015749995, -0.005249995, 0.0, -0.015749995, -0.015749995, 0.0, -0.015749995, -0.026249994, 0.0, -0.005249995, -0.036749996, 0.0, -0.026249994, -0.015749995, 0.0, -0.026249994, -0.005249995, 0.0, -0.026249994, -0.026249994, 0.0, -0.036749996, -0.036749996, 0.0, -0.036749996, -0.005249995, 0.0, -0.036749996, -0.015749995, 0.0, -0.036749996, -0.026249994, 0.0, -0.026249994, -0.036749996, 0.0, -0.04724999, -0.015749995, 0.0, -0.04724999, -0.005249995, 0.0, -0.04724999, -0.026249994, 0.0, -0.05774999, -0.036749996, 0.0, -0.05774999, -0.005249995, 0.0, -0.05774999, -0.015749995, 0.0, -0.05774999, -0.026249994, 0.0, -0.04724999, -0.036749996, 0.0, -0.068249986, -0.015749995, 0.0, -0.068249986, -0.005249995, 0.0, -0.068249986, -0.026249994, 0.0, -0.078749985, -0.036749996, 0.0, -0.078749985, -0.005249995, 0.0, -0.078749985, -0.015749995, 0.0, -0.078749985, -0.026249994, 0.0, -0.068249986, 0.0052500046, 0.0, 0.07874999, 0.026250003, 0.0, 0.07874999, 0.036750004, 0.0, 0.07874999, 0.015750004, 0.0, 0.06824999, 0.0052500046, 0.0, 0.06824999, 0.036750004, 0.0, 0.06824999, 0.026250003, 0.0, 0.06824999, 0.015750004, 0.0, 0.07874999, 0.0052500046, 0.0, 0.057749998, 0.026250003, 0.0, 0.057749998, 0.036750004, 0.0, 0.057749998, 0.015750004, 0.0, 0.04725, 0.0052500046, 0.0, 0.04725, 0.036750004, 0.0, 0.04725, 0.026250003, 0.0, 0.04725, 0.015750004, 0.0, 0.057749998, 0.0052500046, 0.0, 0.036750004, 0.026250003, 0.0, 0.036750004, 0.036750004, 0.0, 0.036750004, 0.015750004, 0.0, 0.026250003, 0.0052500046, 0.0, 0.026250003, 0.036750004, 0.0, 0.026250003, 0.026250003, 0.0, 0.026250003, 0.015750004, 0.0, 0.036750004, 0.0052500046, 0.0, 0.015750004, 0.026250003, 0.0, 0.015750004, 0.036750004, 0.0, 0.015750004, 0.015750004, 0.0, 0.0052500046, 0.0052500046, 0.0, 0.0052500046, 0.036750004, 0.0, 0.0052500046, 0.026250003, 0.0, 0.0052500046, 0.015750004, 0.0, 0.015750004, 0.0052500046, 0.0, -0.005249995, 0.026250003, 0.0, -0.005249995, 0.036750004, 0.0, -0.005249995, 0.015750004, 0.0, -0.015749995, 0.0052500046, 0.0, -0.015749995, 0.036750004, 0.0, -0.015749995, 0.026250003, 0.0, -0.015749995, 0.015750004, 0.0, -0.005249995, 0.0052500046, 0.0, -0.026249994, 0.026250003, 0.0, -0.026249994, 0.036750004, 0.0, -0.026249994, 0.015750004, 0.0, -0.036749996, 0.0052500046, 0.0, -0.036749996, 0.036750004, 0.0, -0.036749996, 0.026250003, 0.0, -0.036749996, 0.015750004, 0.0, -0.026249994, 0.0052500046, 0.0, -0.04724999, 0.026250003, 0.0, -0.04724999, 0.036750004, 0.0, -0.04724999, 0.015750004, 0.0, -0.05774999, 0.0052500046, 0.0, -0.05774999, 0.036750004, 0.0, -0.05774999, 0.026250003, 0.0, -0.05774999, 0.015750004, 0.0, -0.04724999, 0.0052500046, 0.0, -0.068249986, 0.026250003, 0.0, -0.068249986, 0.036750004, 0.0, -0.068249986, 0.015750004, 0.0, -0.078749985, 0.0052500046, 0.0, -0.078749985, 0.036750004, 0.0, -0.078749985, 0.026250003, 0.0, -0.078749985, 0.015750004, 0.0, -0.068249986, 0.04725, 0.0, 0.07874999, 0.06824999, 0.0, 0.07874999, 0.07874999, 0.0, 0.07874999, 0.057749998, 0.0, 0.06824999, 0.04725, 0.0, 0.06824999, 0.07874999, 0.0, 0.06824999, 0.06824999, 0.0, 0.06824999, 0.057749998, 0.0, 0.07874999, 0.04725, 0.0, 0.057749998, 0.06824999, 0.0, 0.057749998, 0.07874999, 0.0, 0.057749998, 0.057749998, 0.0, 0.04725, 0.04725, 0.0, 0.04725, 0.07874999, 0.0, 0.04725, 0.06824999, 0.0, 0.04725, 0.057749998, 0.0, 0.057749998, 0.04725, 0.0, 0.036750004, 0.06824999, 0.0, 0.036750004, 0.07874999, 0.0, 0.036750004, 0.057749998, 0.0, 0.026250003, 0.04725, 0.0, 0.026250003, 0.07874999, 0.0, 0.026250003, 0.06824999, 0.0, 0.026250003, 0.057749998, 0.0, 0.036750004, 0.04725, 0.0, 0.015750004, 0.06824999, 0.0, 0.015750004, 0.07874999, 0.0, 0.015750004, 0.057749998, 0.0, 0.0052500046, 0.04725, 0.0, 0.0052500046, 0.07874999, 0.0, 0.0052500046, 0.06824999, 0.0, 0.0052500046, 0.057749998, 0.0, 0.015750004, 0.04725, 0.0, -0.005249995, 0.06824999, 0.0, -0.005249995, 0.07874999, 0.0, -0.005249995, 0.057749998, 0.0, -0.015749995, 0.04725, 0.0, -0.015749995, 0.07874999, 0.0, -0.015749995, 0.06824999, 0.0, -0.015749995, 0.057749998, 0.0, -0.005249995, 0.04725, 0.0, -0.026249994, 0.06824999, 0.0, -0.026249994, 0.07874999, 0.0, -0.026249994, 0.057749998, 0.0, -0.036749996, 0.04725, 0.0, -0.036749996, 0.07874999, 0.0, -0.036749996, 0.06824999, 0.0, -0.036749996, 0.057749998, 0.0, -0.026249994, 0.04725, 0.0, -0.04724999, 0.06824999, 0.0, -0.04724999, 0.07874999, 0.0, -0.04724999, 0.057749998, 0.0, -0.05774999, 0.04725, 0.0, -0.05774999, 0.07874999, 0.0, -0.05774999, 0.06824999, 0.0, -0.05774999, 0.057749998, 0.0, -0.04724999, 0.04725, 0.0, -0.068249986, 0.06824999, 0.0, -0.068249986, 0.07874999, 0.0, -0.068249986, 0.057749998, 0.0, -0.078749985, 0.04725, 0.0, -0.078749985, 0.07874999, 0.0, -0.078749985, 0.06824999, 0.0, -0.078749985, 0.057749998, 0.0, -0.068249986};
const byte PHASES_FOR_LINE[N_TRANS] = {14,6,20,15,3,10,27,24,20,14,29,22,4,14,31,5,16,14,28,14,25,6,26,4,0,2,14,25,3,18,7,21,3,7,18,21,0,14,2,25,25,26,6,4,16,28,14,14,4,31,14,5,20,29,14,22,3,27,10,24,14,20,6,15,31,0,2,28,21,25,22,3,9,11,14,3,26,0,29,17,9,12,15,29,20,26,23,18,27,31,2,9,31,6,3,5,31,3,6,5,27,2,31,9,20,23,26,18,9,15,12,29,26,29,0,17,9,14,11,3,21,22,25,3,31,2,0,28,3,9,0,5,25,22,31,14,14,19,10,11,0,27,5,25,15,19,10,5,26,21,31,26,2,6,29,17,6,0,10,13,6,10,0,13,2,29,6,17,26,31,21,26,15,10,19,5,0,5,27,25,14,10,19,11,25,31,22,14,3,0,9,5,21,3,17,8,11,5,24,17,0,10,22,11,19,5,26,27,4,6,17,3,16,27,16,25,25,23,2,14,29,5,26,10,29,26,5,10,25,2,23,14,16,16,27,25,4,17,6,3,19,26,5,27,0,22,10,11,11,24,5,17,21,17,3,8};

byte bufferToSend[N_TRANS + 2];

unsigned long millisFromLastButtonPress = 0;
byte buttonPresses = 0;

/* Array control functions */

void swichOffArray() {
  bufferToSend[0] = 254; //start phases command
  bufferToSend[N_TRANS + 1] = 253; //swap double buffer command (like a commit)
  for (int i = 1; i < N_TRANS + 1; i += 1)
    bufferToSend[i] = 32; //32 is the value for switching of the transducer
  Serial2.write( bufferToSend, N_TRANS + 2 );
  Serial2.flush();
}

void changeModulation(byte periods){
  if (periods < 1) periods = 1;
  else if(periods > 31) periods = 31;
  Serial2.write( 0b10100000 | periods);
}

const float WAVELENGTH = 0.00865f;
const float PHASE_DIV = 32.0f;
void focusArrayAt(const float posX, const float posY, const float posZ) { //positions are in meters in respect to the center of the array
  bufferToSend[0] = 254; //start phases command
  bufferToSend[N_TRANS + 1] = 253; //swap double buffer command (i.e. commit)
  for (int i = 1; i < N_TRANS+1; i += 1) {
    const float diffX = TRANS_POS[(i-1)*3 + 0] - posX;
    const float diffY = TRANS_POS[(i-1)*3 + 1] - posY;
    const float diffZ = TRANS_POS[(i-1)*3 + 2] - posZ;
    const float distInWavelengths = sqrt(diffX * diffX + diffY * diffY + diffZ * diffZ) / WAVELENGTH;
    const byte phase = (byte)((ceil(distInWavelengths) - distInWavelengths) * PHASE_DIV);
    bufferToSend[i] = phase;
  }
  Serial2.write( bufferToSend, N_TRANS + 2 );
  Serial2.flush();
}

void makeBeeps(int nBeeps, int modulation=7){
  if (nBeeps < 1) nBeeps = 1;
  else if(nBeeps > 10) nBeeps = 10;
  
  swichOffArray();
  changeModulation( modulation );
  for (int i = 0; i < nBeeps; i+=1 ){
    focusArrayAt(0,0.1,0);
    delay(250);
    swichOffArray();
    delay(250);
  }
  changeModulation( MOD_PERIODS_DEFAULT );
}




void sendPhasePattern(const byte* pattern){
  Serial2.write( 254 );
  Serial2.write( pattern, N_TRANS);
  Serial2.write( 253 );
  Serial2.flush();
}

/* Network functions*/

void configWifiAsAccessPoint(const char* ssidName){
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

boolean configWifiAsSlave(const byte lastIPDigit){
  Serial.println("Configuring as station...");
  WiFi.mode(WIFI_STA); 

  IPAddress local_IP(192, 168, 1, lastIPDigit);
  IPAddress gateway(192, 168, 1, 1);
  IPAddress subnet(255, 255, 255, 0);
  IPAddress primaryDNS(8, 8, 8, 8);   //optional
  IPAddress secondaryDNS(8, 8, 4, 4); //optional

  if (!WiFi.config(local_IP, gateway, subnet, primaryDNS, secondaryDNS)) {
    Serial.println("STA Failed to configure");
  }

  Serial.println("Conecting to master");
  WiFi.begin(ssidMaster, password); 
  for (int tries = 0; WiFi.status() != WL_CONNECTED; tries+= 1) { 
    delay(250); 
    Serial.print("."); 
    if (tries >= 4*5){ //after 5 seconds trying to connect
       Serial.println("failure connecting to the master SSID");
       return false;
    }
  } 
  
  IPAddress myIP = WiFi.localIP();
  Serial.print("Station IP address: ");
  Serial.println(myIP);
  return true;
}

void setup() {
  Serial.begin(230400); // this serial is for receiving commands and sending debug info to the computer
  Serial2.begin(230400, SERIAL_8N1, 17, 16); //RX2 TX2 This serial communicates with the array
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  Serial.println(ULTRATACT_VERSION);
  Serial.println( ssid );

  configWifiAsAccessPoint( ssid ); //start as access point with regular ssid  
  server.begin();
  delay(200);
  Serial.println("Switching off the array...");

  makeBeeps( 1 );
}




int previousButton = HIGH;
int itersButtonHigh = 0;
bool randomMode = false;
unsigned long randomModeTriggerMillis = 0;

void loop() {  
  const unsigned long currentMillis = millis();

  /* Button pres input */
  if ( currentMillis - millisFromLastButtonPress > 1000 && buttonPresses > 0){
    randomMode = false;
    swichOffArray();
    if (buttonPresses == 1){ //switch off the emitter
      Serial.println("Button pressed once, switching off the array");
    }else if (buttonPresses >= 2){ //try to connect to the master ssid, 
      const int lastIPDigit = 98 + buttonPresses; //with increasing IP numbers (.101 .102 ...)
      Serial.print("Button pressed >=2, connecting with ip ");
      Serial.println(lastIPDigit);
      const boolean conectedToMaster = configWifiAsSlave(lastIPDigit);
      if (conectedToMaster == false ){ //we failed connecting to the master, so we become the master
        configWifiAsAccessPoint(ssidMaster);
        makeBeeps( 1, 5 );
      }else{
        makeBeeps( buttonPresses );
      }
    }
    delay(500);
    buttonPresses = 0;
  }
  
  const int currentButtonState = digitalRead(BUTTON_PIN);
  if (previousButton == HIGH && currentButtonState == LOW && itersButtonHigh > 100){ //when the button is pressed. last part is for avoid bouncing
    buttonPresses += 1;
    millisFromLastButtonPress = currentMillis;
  }
  if ( currentButtonState == HIGH && itersButtonHigh < 0x0FFF){
    itersButtonHigh += 1;
  }else{
    itersButtonHigh = 0;
  }
  previousButton = currentButtonState;


  /* Serial control, mainly to debug*/
  if (Serial.available() > 1) {
    byte letter = Serial.read();
    Serial.read(); //read the newline
    if (letter == 's') {
      swichOffArray();
    } else if (letter == 'f') {
      focusArrayAt( 0, 0.1f, 0);
    } else {
      Serial.println("Yeah, I am still alive");
    }
  }

  /* random mode*/
  if (randomMode && randomModeTriggerMillis <= currentMillis){
    randomModeTriggerMillis = currentMillis + random(20,150);
    focusArrayAt( random(-40,40) / 1000.0f, random(90,110) / 1000.0f, random(-40,40) / 1000.0f);
  }
  
  
  /* Commands comming from HTTP */
  WiFiClient client = server.available();
  if (client) {
    String request = client.readStringUntil('\r');
    Serial.print( currentMillis );
    Serial.print(' ');
    Serial.println( request );

    client.println("HTTP/1.1 200 OK\nContent-type:text/html\nConnection: close\n\n");

    // /focus/x_y_z
    // /off
    // /mode/number  number 1 to 4, mainly affects the modulation frequency
    // /line   at 10cm, 0 degrees
    // /noise    at 10cm, sparks (random mode)
  
    int sep1 = request.indexOf('/');
    if (sep1 == -1) 
      return;

    //disable randomMode (noise pop...)
    randomMode = false;
    
    //command
    if ((sep1 = request.indexOf("focus", sep1+1)) != -1){
      const int sep2 = request.indexOf('/', sep1 + 1);
      const int sep3 = request.indexOf('_', sep2 + 1);
      const int sep4 = request.indexOf('_', sep3 + 1);
      const int sep5 = request.indexOf(' ', sep4 + 1);
      if (sep2 == -1 || sep3 == -1 || sep4 == -1 || sep5 == -1)
        return;
  
      const float posX = request.substring(sep2 + 1, sep3).toFloat();
      const float posY = request.substring(sep3 + 1, sep4).toFloat();
      const float posZ = request.substring(sep4 + 1, sep5).toFloat();
      Serial.printf("Focusing at %f %f %f\n", posX, posY, posZ);
      focusArrayAt( -posX, posY, posZ);
      Serial.println("Focused");
      client.printf("Focused at %f %f %f\n", posX, posY, posZ);
      
    }else if((sep1 = request.indexOf("off", sep1+1)) != -1){
      Serial.println("Switching off the array...");
      swichOffArray();
    }else if((sep1 = request.indexOf("mode", sep1+1)) != -1){
      const int sep2 = request.indexOf('/', sep1 + 1);
      const int sep3 = request.indexOf(' ', sep2 + 1);
      const int mod = request.substring(sep2 + 1, sep3).toInt();
      
      if (mod == 1){
        changeModulation( MOD_PERIODS_DEFAULT );
      }else if (mod == 2){
        changeModulation( 7 );
      }else if (mod == 3){
        changeModulation( 15 );
      }else if (mod == 4){
       changeModulation( 8 );
      }else{
        changeModulation( MOD_PERIODS_DEFAULT );
      }
 
    }else if((sep1 = request.indexOf("line", sep1+1)) != -1){
      Serial.println("Emitting a line...");
      sendPhasePattern( PHASES_FOR_LINE );
    }else if((sep1 = request.indexOf("sparks", sep1+1)) != -1){
      Serial.println("Emitting noise...");
      randomMode = true;
      randomModeTriggerMillis = currentMillis;
    }else if((sep1 = request.indexOf("version", sep1+1)) != -1){
      Serial.println("Version is");
      client.printf("Version is %s\n", ULTRATACT_VERSION);
    }

    client.stop();
  }

}

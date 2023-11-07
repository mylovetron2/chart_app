#include <Arduino.h>
#if defined(ESP32)
  #include <WiFi.h>
#elif defined(ESP8266)
  #include <ESP8266WiFi.h>
#endif
#include <Firebase_ESP_Client.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
//Provide the token generation process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// Insert your network credentials
#define WIFI_SSID "Family F2"
#define WIFI_PASSWORD "23456781"

// Insert Firebase project API Key
#define API_KEY "AIzaSyAJCyHQmTX6xjs1uktvxWbk-Bc8sfYLw2I"

// Insert RTDB URLefine the RTDB URL */
#define DATABASE_URL "https://temperature-app-3d881-default-rtdb.firebaseio.com" 

//Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
int count = 0;
bool signupOK = false;

int epoch_time;
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org");
String parent_path;
//get current epoch time

unsigned long Get_Epoch_Time() {

  timeClient.update();

  unsigned long now = timeClient.getEpochTime();

  return now;

}

void setup(){
  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;
  auth.user.email = "mystore2018myapp@gmail.com";
  auth.user.password = "Vandethuong0803";

  /* Sign up */
  // if (Firebase.signUp(&config, &auth,"mystore2018myapp@gmail.com","Vandethuong0803")){
  //   Serial.println("signUp ok");
  //   signupOK = true;
  // }
  // else{
  //   Serial.printf("%s\n", config.signer.signupError.message.c_str());
  // }

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h
  
  timeClient.begin();

  Firebase.begin(&config, &auth);
  Serial.println("Getting User UID...");

  while ((auth.token.uid) == "") {

    Serial.print('.');

    delay(1000);

  }
  String UID;
  UID = auth.token.uid.c_str();

  Serial.print("User UID: ");

  Serial.println(UID);
  Firebase.reconnectWiFi(true);
}

void loop(){
  if (Firebase.ready() && (millis() - sendDataPrevMillis > 15000 || sendDataPrevMillis == 0)){
    sendDataPrevMillis = millis();

     epoch_time = Get_Epoch_Time();
    // Write an Int number on the database path test/int
    parent_path="data/" + String(epoch_time)+"/time";
    if (Firebase.RTDB.setInt(&fbdo, parent_path, epoch_time)){
      Serial.println("PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    }
    else {
      Serial.println("FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }
    
    parent_path="data/" + String(epoch_time)+"/temp";
    // Write an Float number on the database path test/float
    if (Firebase.RTDB.setFloat(&fbdo, parent_path, 0.01 + random(0,100))){
      Serial.println("PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    }
    else {
      Serial.println("FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }
  }
}
library my_prj.globals;

IndoorControl controlData = IndoorControl();

String Tip1;
List <String> globalHintTexts = List(10);
List <String> globalHintTitles = List(10);
List <String> globalHintComments = List(10);

class IndoorControl {
  //control
  bool automaticWatering = false;
  bool humCtrlHigh = false;
  bool humidityControl = false;
  int humidityOffHour = 0;
  int humidityOnHour = 0;
  int humiditySet = 0;
  int offHour = 0;
  int onHour = 0;
  int soilMoistureSet = 0;
  bool tempCtrlHigh = false;
  bool temperatureControl = false;
  int temperatureOffHour = 0;
  int temperatureOnHour = 0;
  int temperatureSet = 0;
  bool water = false;

  //dashboard
  double humidity = 10;
  double temperature = 0;
  bool watering = false;
  double lux = 0;
  bool humidityControlOn = false;
  bool temperatureControlOn = false;
  bool lights = false;
  bool soil = false;
  String ESPtag = "";
  int soilMoisture = 0;
}
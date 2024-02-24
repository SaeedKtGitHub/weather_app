import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  //api key:
   final _weatherService=WeatherService('ed9c6aa165eb5203cc773c58a19e48f5');
   Weather? _weather;


   @override
   void initState() {
     super.initState();

     // Set the default value for the _cityController
     getCurrentCityName().then((cityName) {
       if (cityName.isNotEmpty) {
         setState(() {
           _cityController.text = cityName;
         });
       }
     });

     // Fetch weather based on the default or user-entered city
     _fetchWeather();
   }

   Future<String> getCurrentCityName() async {
     return await _weatherService.getCurrentCity();
   }
   _fetchWeather() async {
     var cityName = _cityController.text;
     // Check if the city name is not empty and then fetch weather data
     if (cityName.isNotEmpty) {
       try {
         final weather = await _weatherService.getWeather(cityName);
         setState(() {
           _weather = weather;
         });
       } catch (e) {
         print(e);
       }
     }else{
       cityName =await _weatherService.getCurrentCity();
       try {
         final weather = await _weatherService.getWeather(cityName);
         setState(() {
           _weather = weather;
         });
       } catch (e) {
         print(e);
       }
     }
   }


  

      String getWeatherAnimation(String? mainCondition){
      if(mainCondition==null){
        return 'assets/sunny.json';
      }

      switch(mainCondition.toLowerCase()){
        case 'clouds':
          return 'assets/cloud.json';
        case 'mist':
        case 'smoke':
        case 'haze':
        case 'dust':
        case 'fog':
        return 'assets/cloud.json';
        case 'rain':
          return 'assets/rain.json';
        case 'drizzle':
        case 'shower rain':
        return 'assets/rain.json';
        case 'thunderstorm':
          return 'assets/thunder.json';
        case 'clear':
          return 'assets/sunny.json';
        default:
        return 'assets/sunny.json';



      }

      }

   final TextEditingController _cityController = TextEditingController();
   //weather animations:
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Align children at the top
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height/17,),
                Container(
                padding: EdgeInsets.symmetric(horizontal: width/15),
                child: TextField(
                  controller: _cityController,
                  onChanged: (value) {},
                  style:const  TextStyle(
                    color: Colors.black,
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                      _fetchWeather();
                    },
                    decoration: InputDecoration(
                      suffixIcon:const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      hintStyle: TextStyle(color: Colors.black),
                      hintText: 'Search City'.toUpperCase(),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
                SizedBox(height: height/13,),
                //city name:
                Text(_weather?.cityName??"loading city..",
                  style:TextStyle(
                    fontSize: 20
                  ) ,
                ),
                SizedBox(height: height/23,),

                //animation:
                Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                //temperature :
                Text('${_weather?.temperature.round()}C',
                style: TextStyle(
                  fontSize: 24
                ),
                ),
                SizedBox(height: height/31,),
                //temperature :
                Text('${_weather?.mainCondition ?? ""}',
                  style: TextStyle(
                      fontSize: 24
                  ),
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}

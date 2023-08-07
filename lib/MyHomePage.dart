import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:havaduurumu/search_Page.dart';
import 'package:http/http.dart' as http;

import 'Witget/daily_weather_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  String location = 'Sydney';
  double temperature = 20.0;
  final String key = 'c05d4692988f1f1ea2f2c0e508498463'; //siteden aldık
  var locationData; //sehrin sicaklık bilgilerine ulasmak iciin kullanacagmz degisken
  Position? devicePosition;
  String? code = 'home';
  Position? position;
  String? icon = '01d';

  List<String> icons = ["01d", "01d", "01d", "01d", "01d"];
  List<double> temperatures = [20.0, 20.0, 20.0, 20.0, 20.0];
  List<String> dates = ["Pzrts", "Salı", "Carsmb", "Persmb", "Cuma"];

  //benibeklemelisin

  //bu fonksiyon kullanici bir sehir girisi yaptiginda calisacak
  Future<void> getlocationdataDataFromAPI() async {
    //geridönüs response
    locationData = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$key&units=metric'));

    final locationDataParsed = jsonDecode(
        locationData.body); //KARMASİK KODU OKUYUP LOCATİONDATAPARSED E AKTARDIK

    setState(() {
      temperature = locationDataParsed['main']['temp'];
      location = locationDataParsed['name'];
      code = locationDataParsed['weather'].first['main'];
      icon = locationDataParsed['weather'].first['icon'];

      // code = locationDataParsed['weather']?.first['main'] ?? 'default';
    });
  }

  @override
  void initState() {
    //bu methodun icine esenkron kod yazamazsın

    //getlocationdataDataFromAPI();

    //initStateData();
    super.initState();
    //getDevicePosition();
    initStateData();
  }

//bu fonksiyon kullanıcı uygulamayı baslatır baslatmaaz mevcut gps verisi icin yazilmistir
  Future<void> getDevicePosition() async {
    // Position devicePosition = await _determinePosition();
    //print(devicePosition);
    Position? position = await _determinePosition();
    setState(() {
      //Position sınıfı, geolocator paketi ile sağlanan bir sınıftır ve coğrafi konum bilgilerini (latitude ve longitude)
      // ve diğer özellikleri içerir.
      devicePosition = position; //konum bilgilerini devicePosition a aktardık
      // devicePosition'a değer atanıncak, sonra locationData alınacak
      getlocationdataDataFromAPIByLatLon(); //konum bilgisini bu fonksiyona aktararak konumdaki hava durumunu aldık
      //getlocationdataDataFromAPIByLatLon fonksiyonunu
      // çağırarak, cihazın mevcut konum bilgisine bağlı
      // olarak hava durumu verilerini alabiliriz.
    });
  }

  /*Future<void> getDevicePosition() async {
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      //"getCurrentPosition": Bu metot, mevcut konumu almak için kullanılır.
      // Cihazın GPS veya diğer konum servisleri üzerinden koordinatları alır.
      //"desiredAccuracy": Bu, istenen konum doğruluğunu belirten bir parametredir.
      // "LocationAccuracy.low" ifadesi, düşük doğruluk seviyesini temsil eder.
      // Yani, GPS veya diğer konum hizmetleri mümkün olduğunca
      // az enerji tüketir ve daha az hassas bir sonuç döndürebilir.
    } catch (e) {
      print('su hata olustu $e');
    } finally {
      //sorun ne olursa olsun buradaki kod calssin
    }
  }*/

  Future<void> getlocationdataDataFromAPIByLatLon() async {
    //geridönüs response

    try {
      var forecastData = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=${devicePosition!.latitude}&lon=${devicePosition!.longitude}&appid=$key&units=metric'));
      var forecastDataParsed = jsonDecode(forecastData.body);
      // temperatures.clear();
      //icons.clear();
      //dates.clear();

      setState(() {
        for (int i = 6; i < 39; i += 8) {
          temperatures.add(forecastDataParsed['list'][i]['main']['temp']);
          icons.add(forecastDataParsed['list'][i]['weather'][0]['icon']);
          dates.add(forecastDataParsed['list'][i]['dt_txt']);
        }
      });
    } catch (e) {
      print('getDailyForecastByLation Error: $e');
    }
    /*if (devicePosition != null) {
      this.locationData = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${devicePosition!.latitude}&lon=${devicePosition!.longitude}&appid=$key&units=metric'));

      final locationDataParsed = jsonDecode(locationData
          .body); //KARMASİK KODU OKUYUP LOCATİONDATAPARSED E AKTARDIK

      setState(() {
        temperature = locationDataParsed['main']['temp'];
        location = locationDataParsed['name'];
        code = locationDataParsed['weather'].first['main'];
        icon = locationDataParsed['weather'].first['icon'];

        // code = locationDataParsed['weather']?.first['main'] ?? 'default';
      });
    }*/
  }

  Future<void> getDailyForecastByLocation() async {
    var forecastData = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?$location&appid=$key&units=metric'));
    var forecastDataParsed = jsonDecode(forecastData.body);
    temperatures.clear();
    icons.clear();
    dates.clear();

    setState(() {
      temperatures.add(forecastDataParsed['list'][6]['main']['temp']);
      temperatures.add(forecastDataParsed['list'][14]['main']['temp']);
      temperatures.add(forecastDataParsed['list'][22]['main']['temp']);
      temperatures.add(forecastDataParsed['list'][30]['main']['temp']);
      temperatures.add(forecastDataParsed['list'][38]['main']['temp']);
      icons.add(forecastDataParsed['list'][6]['weather'][0]['icon']);
      icons.add(forecastDataParsed['list'][14]['weather'][0]['icon']);
      icons.add(forecastDataParsed['list'][22]['weather'][0]['icon']);
      icons.add(forecastDataParsed['list'][30]['weather'][0]['icon']);
      icons.add(forecastDataParsed['list'][38]['weather'][0]['icon']);
      dates.add(forecastDataParsed['list'][6]['dt_txt']);
      dates.add(forecastDataParsed['list'][14]['dt_txt']);
      dates.add(forecastDataParsed['list'][22]['dt_txt']);
      dates.add(forecastDataParsed['list'][30]['dt_txt']);
      dates.add(forecastDataParsed['list'][38]['dt_txt']);
    });
  }

  Future<void> getDailyForecastByLation() async {
    var forecastData = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=${devicePosition!.latitude}&lon=${devicePosition!.longitude}&appid=$key&units=metric'));
    var forecastDataParsed = jsonDecode(forecastData.body);
    temperatures.clear();
    icons.clear();
    dates.clear();

    setState(() {
      for (int i = 6; i < 39; i += 8) {
        temperatures.add(forecastDataParsed['list'][i]['main']['temp']);
        icons.add(forecastDataParsed['list'][i]['weather'][0]['icon']);
        dates.add(forecastDataParsed['list'][i]['dt_txt']);
      }
    });
  }

  void initStateData() async {
    //initStateData fonksiyonu,
    // initState fonksiyonu içinde çağrılan ve
    // cihazın konum bilgisini alarak hava durumu verilerini
    // elde etmeyi sağlayan bir yardımcı fonksiyondu

    await getDevicePosition();
    await getlocationdataDataFromAPIByLatLon(); //current weather data
    await getDailyForecastByLocation(); //forecast for 5 days
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/$code.jpg'),

          fit: BoxFit.cover, //resmin genisligini ayarlayan parametre
        ),
      ),
      //eger temparature==null ise circularprograssindicator goster aksi halde veri gelince setstate yap ve scaffold göster

      child: (temperature == null || devicePosition == null)
          ? Center(
              child: Column(
                children: [
                  const CircularProgressIndicator(),
                  Text('BEKLE'),
                ],
              ),
            ) //yuklenme isareti
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /*ElevatedButton(
                onPressed: () async {
                  print('getlocationData cagrılmadan once : $locationData');
                  await getlocationdata(); //yapılmasini bekle sonra alt saatıra gec ,await sayesinde
                  //3saniye bekle ve print calistir
                  // Future.delayed(
                  //   Duration(
                  //   seconds: 3,
                  //),
                  // () => print(
                  //   'getlocationData cagrildiktan sonra : $locationData'));
                  print('getlocationData cagrildiktan sonra : $locationData');

                  final locationDataParsed = jsonDecode(locationData.body);
                  // print(locationData.body);
                  //print(locationData.body.runtimeType);
                  print(locationDataParsed);
                  print(locationDataParsed.runtimeType);
                  print(locationDataParsed['main']['temp']);
                },
                child: Text('getlocationData'),
              ),*/
                    SizedBox(
                      //container yerine kullanabilirsin ufak bir kutu olacak cunku
                      height: 100,
                      width: 150,
                      child: icon != null
                          ? Image.network(
                              'https://openweathermap.org/img/wn/$icon@2x.png')
                          : Placeholder(), //Image.network(
                      //'https://openweathermap.org/img/wn/$icon@2x.png'),
                    ),
                    Text(
                      // const Text dersek icindeki sey hicbir zaman degismez demek
                      '$temperature °C',
                      style:
                          TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        //buradan bir yanıt gelecegi icin beklemek gerek
                        final selectedCity = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const searchPage()));
                        setState(() {
                          location = selectedCity;
                        });

                        await getlocationdataDataFromAPI();
                        await getDailyForecastByLocation();

                        // print(selectedCity);
                      },
                      icon: const Icon(Icons.search),
                    ),
                    BuildWeatherCard(context)
                  ],
                ),
              ),
            ),
    );
  }

  Widget BuildWeatherCard(BuildContext context) {
    print("Icons: $icons");
    print("Temperatures: $temperatures");
    print("Dates: $dates");
    if (icons.length < 5 || temperatures.length < 5 || dates.length < 5) {
      //Listeler henüz doldurulmamış, yükleme göstergesi gösterin veya duruma uygun şekilde işleyin
      return CircularProgressIndicator();
    }
    // if (icons.isEmpty || temperatures.isEmpty || dates.isEmpty) {
    // return Container();
    // }

    List<DailyWeatherCard> cards = [
      /* DailyWeatherCard(
        icon: icons[0],
        temperature: temperatures[0],
        data: dates[0],
      ),
      DailyWeatherCard(
        icon: icons[1],
        temperature: temperatures[1],
        data: dates[1],
      ),
      DailyWeatherCard(
        icon: icons[2],
        temperature: temperatures[2],
        data: dates[2],
      ),
      DailyWeatherCard(
        icon: icons[3],
        temperature: temperatures[3],
        data: dates[3],
      ),
      DailyWeatherCard(
        icon: icons[4],
        temperature: temperatures[4],
        data: dates[4],
      ),*/
    ];
    for (int i = 0; i < 5; i++) {
      cards.add(DailyWeatherCard(
        icon: icons[i],
        temperature: temperatures[i],
        data: dates[i],
      ));
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.20,
      //mevcut ekranın yüzde doksanı kadar olan alana yayıl
      width: MediaQuery.of(context).size.width * 0.95,
      child: ListView(
        //tum alani kaplamak ister sınırlandırmalıyız

        scrollDirection: Axis.horizontal, // ekseniniz x dir
        children: cards,
      ),
    );
  }

//gps bilgisi
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}

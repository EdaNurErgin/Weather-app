import 'package:flutter/material.dart';

class DailyWeatherCard extends StatelessWidget {
  const DailyWeatherCard(
      {Key? key, this.icon, required this.temperature, required this.data})
      : super(key: key);

  final String? icon;
  final double temperature;
  final String data;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      child: SizedBox(
        height: 120,
        width: 64, //'https://openweathermap.org/img/wn/$icon@2x.png'
        child: Column(
          children: [
            icon != null
                ? Image.network(
                    'https://openweathermap.org/img/wn/$icon@2x.png')
                : Placeholder(), // Varsayılan bir resim göstermek için Placeholder() widget'ını kullanabilirsiniz.
            //Image.network('https://openweathermap.org/img/wn/$icon@2x.png'),
            Text(
              // const Text dersek icindeki sey hicbir zaman degismez demek
              '$temperature °C',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            Text(
              data,
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

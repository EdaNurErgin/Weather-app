import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class searchPage extends StatefulWidget {
  const searchPage({Key? key}) : super(key: key);

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  String selectedCity = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/home.jpg'),
          fit: BoxFit.cover, //resmin genisligini ayarlayan parametre
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0, //appbar yüksekligi
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(
                  onChanged: (value) {
                    selectedCity = value;
                    print(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'sehir seciniz',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  style: TextStyle(
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  //bir sehir icin API yanıt veriyormu
                  var response = await http.get(Uri.parse(
                      'https://api.openweathermap.org/data/2.5/weather?q=$selectedCity&appid=c05d4692988f1f1ea2f2c0e508498463&units=metric'));
                  //sayfayi kaldır ve aynı zamanda bu sayfayı cagıran/acan yere komuta/satıra geri don
                  // Navigator.pop(context, selectedCity);
                  print('Response Status Code: ${response.statusCode}');
                  print('Response Body: ${response.body}');
                  if (response.statusCode == 200) {
                    //sayfayi kaldir ve ayni zamanda bir sayfayi cagiran/acan yere komut/satıra bir veri dön

                    Navigator.pop(context, selectedCity);
                  } else {
                    //kullaniciya uyarı ver ve sayfada kal
                    //alert diolog goster
                    _showMyDialog();
                  }
                },
                child: const Text('select city'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          setState(() {
            print('Setstaterun');
          });
        }),
      ),
    );
  }

  //alert dialog yapisi
  //geri donut stickeri olarak düsünebilrisin
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('lokasyon bulunamadi'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('lutfen lokasyon sec'),
                Text('okey'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

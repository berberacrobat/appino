import 'dart:async';

import 'package:appino/placeholder_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_color_generator/material_color_generator.dart';
import 'eureka.dart';
import 'homeWidget.dart';

void main() {
  runApp(const MyApp());
}

class SpalshScreen extends StatefulWidget {
  @override
  _SpalshScreenState createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MyHomePage(title: 'Foraging ..'))));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromARGB(255, 173, 82, 167),
        child: const FittedBox(
          fit: BoxFit.cover,
          child: Image(
            image: NetworkImage(
                'https://images.fineartamerica.com/images/artworkimages/mediumlarge/3/1-watercolor-rhythmic-gymnastics-with-hoop-watercolor-print-sports-art-teen-room-dance-nursery-art-spo-leith-huber.jpg'),
          ),
        ));
    //https://ak.picdn.net/offset/photos/5f2088bca75ca0db3709b12d/medium/offset_976371.jpg
    //FlutterLogo(size: MediaQuery.of(context).size.height));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  //static const int priaryColor = 0xFF9ED5A0;
  //static const Color _greenPrimaryValue = Color.fromARGB(255, 204, 24, 24);
  /* static const MaterialColor myGreen = MaterialColor(
    priaryColor,
    <int, Color>{
      50: Color(0xFFE8F5E9),
      100: Color(0xFFC8E6C9),
      200: Color(0xFFA5D6A7),
      300: Color(0xFF81C784),
      350: Color(
          0xFFD6D6D6), // only for raised button while pressed in light theme
      400: Color(0xFF66BB6A),
      500: _greenPrimaryValue,
      600: Color(0xFF43A047),
      700: Color(0xFF388E3C),
      800: Color(0xFF2E7D32),
      850: Color(0xFF303030), // only for background color in dark theme
      900: Color(0xFF1B5E20),
    },
  ); */

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ForeAging APP',
      theme: ThemeData(
        primarySwatch:
            generateMaterialColor(color: Color.fromARGB(255, 180, 131, 180)),
      ),
      home: SpalshScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _selectedIndex = 0;

  final List _pages = [
    HomeWidget(Color.fromARGB(255, 227, 189, 231)),
    const PlaceholderWidget(Color.fromARGB(255, 193, 238, 81)),
    const PlaceholderWidget(Colors.green),
    const EurekaMarkersPage(),
    const PlaceholderWidget(Colors.brown)
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _getData() async {
    //String url = 'http://127.0.0.1:8000/api/areas/';
    String url = 'https://events.managerplay.com/api/areas/';
    final response = await http
        .get(Uri.parse(url), headers: {"Access-Control-Allow-Origin": "*"});

    print(response.body.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*   appBar: AppBar(
        title: Text(widget.title),
      ), */
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 180, 131, 180),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color.fromARGB(255, 92, 55, 90),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_basket,
              color: Color.fromARGB(255, 92, 55, 90),
            ),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Color.fromARGB(255, 92, 55, 90),
            ),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.remove_red_eye,
              color: Color.fromARGB(255, 92, 55, 90),
            ),
            label: 'Eureka',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Color.fromARGB(255, 92, 55, 90),
            ),
            label: 'Account',
          )
        ],
        selectedItemColor: Color.fromARGB(255, 69, 17, 60),
        onTap: _onItemTapped,
      ),
      /* floatingActionButton: FloatingActionButton(
        onPressed: _getData,
        tooltip: 'Get data',
        child: const Icon(Icons.add),
      ), */
    );
  }
}

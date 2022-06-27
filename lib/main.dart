import 'package:appino/placeholder_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_color_generator/material_color_generator.dart';
import 'homeWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const int priaryColor = 0xFF9ED5A0;
  static const Color _greenPrimaryValue = Color(priaryColor);
  static const MaterialColor myGreen = MaterialColor(
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
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(color: Color(0xFF30F495)),
      ),
      home: const MyHomePage(title: 'Foraging'),
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
    HomeWidget(Color(0xFFBEF5D1)),
    const PlaceholderWidget(Colors.deepOrange),
    const PlaceholderWidget(Colors.green),
    const PlaceholderWidget(Colors.blueGrey)
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
    String url = 'http://127.0.0.1:8000/api/areas/';
    final response = await http
        .get(Uri.parse(url), headers: {"Access-Control-Allow-Origin": "*"});

    print(response.body.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Basket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          )
        ],
        selectedItemColor: Color.fromARGB(255, 6, 158, 122),
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getData,
        tooltip: 'Get data',
        child: const Icon(Icons.add),
      ),
    );
  }
}

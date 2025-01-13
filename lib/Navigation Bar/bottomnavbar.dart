import 'package:flutter/material.dart';
import 'package:pingstar/Logged%20In%20Users/allchatspage.dart';
import 'package:pingstar/Logged%20In%20Users/callpage.dart';
import 'package:pingstar/Logged%20In%20Users/updatespage.dart';
import 'package:pingstar/Utils/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    AllChats(),
    UpdatesPage(),
    CallPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: WhatsAppColors.darkGreen, // Bottom nav bar background
      currentIndex: currentIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.green, // Active icon color
      unselectedItemColor: Colors.white, // Inactive icon color
      selectedLabelStyle: TextStyle(color: Colors.white), // Active text color
      unselectedLabelStyle: TextStyle(color: Colors.white), // Inactive text color
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.photo),
          label: 'Updates',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.call),
          label: 'Calls',
        ),
      ],
    );
  }
}


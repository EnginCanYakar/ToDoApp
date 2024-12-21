import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/presentation/pages/Calendar/calenderPage.dart';
import 'package:to_do_app/presentation/pages/Focus/focus_mode.dart';
import 'package:to_do_app/presentation/pages/Home%20Page/UserHomePAge.dart';
import 'package:to_do_app/presentation/pages/Profile/ProfilePage.dart';
import 'functions/add_task_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  List<Widget> pageList = [
    const Userhomepage(),
    const Calenderpage(),
    FocusPage(),
    const Profilepage(),
  ];

  void _showAddTaskDialog({DocumentSnapshot? task}) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(task: task),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ],
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        title: Text(
          "Index",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      drawer: const Drawer(),
      body: Center(child: pageList[_currentIndex]),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            labelTextStyle:
                WidgetStatePropertyAll(TextStyle(color: Colors.white))),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: _onItemTapped,
              backgroundColor: const Color(0xff363636),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home, color: Colors.white),
                  selectedIcon: Icon(Icons.home, color: Colors.purple),
                  label: "Home",
                ),
                Padding(
                  padding: EdgeInsets.only(right: 48.0),
                  child: NavigationDestination(
                    icon: Icon(Icons.today, color: Colors.white),
                    selectedIcon: Icon(Icons.today, color: Colors.purple),
                    label: "Calendar",
                  ),
                ),
                // Boş alan oluşturmak için Spacer yerine SizedBox
                Padding(
                  padding: EdgeInsets.only(left: 48.0),
                  child: NavigationDestination(
                    icon: Icon(Icons.schedule, color: Colors.white),
                    selectedIcon: Icon(Icons.schedule, color: Colors.purple),
                    label: "Focus",
                  ),
                ),
                NavigationDestination(
                  icon: Icon(Icons.person, color: Colors.white),
                  selectedIcon: Icon(Icons.person, color: Colors.purple),
                  label: "Profile",
                ),
              ],
            ),
            Positioned(
              bottom: 30,
              left: MediaQuery.of(context).size.width * 0.5 - 35,
              child: GestureDetector(
                onTap: () => _showAddTaskDialog(),
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purpleAccent,
                  ),
                  child: const Icon(Icons.add, size: 40, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

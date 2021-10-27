import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/ui/historic/historic_page.dart';
import 'package:salon/ui/home/home_page.dart';
import 'package:salon/ui/perfil/perfil_page.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({ Key? key }) : super(key: key);

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _selectedIndex = 1;

  static List _pages = [
    HistoricPage(),
    HomePage(),
    PerfilPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pages[_selectedIndex], 
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        decoration: BoxDecoration(
          color: markPrimaryColor,
        ),
        child: GNav(
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
          gap: 8,
          activeColor: markTertiaryColor,
          iconSize: 24,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: Duration(milliseconds: 400),
          tabBackgroundColor: Colors.red[100]!,
          color: Colors.white,
          tabs: [
            GButton(
              icon: Icons.history,
              text: 'Histórico',
            ),
            GButton(
              icon: Icons.home,
              text: 'Início',
            ),
            GButton(
              icon: Icons.person_outline,
              text: 'Perfil',
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() =>_selectedIndex = index);
          },
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/ui/perfil/perfil_page.dart';
import 'package:salon/ui/ui_manager/clientes_manager/clientes_manager_page.dart';

import '../manager_home_page.dart';

class BottomNavigatorManager extends StatefulWidget {
  const BottomNavigatorManager({ Key? key }) : super(key: key);

  @override
  _BottomNavigatorManagerState createState() => _BottomNavigatorManagerState();
}

class _BottomNavigatorManagerState extends State<BottomNavigatorManager> {
  int _selectedIndex = 1;

  static List _pages = [
    ClientesmanagerPage(),
    ManagerHomePage(),
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
              icon: Icons.people,
              text: 'Clientes',
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
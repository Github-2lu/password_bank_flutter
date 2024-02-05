import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: Column(
        children: [
          DrawerHeader(
              child: Column(
            children: [Icon(Icons.private_connectivity), Text("User")],
          ))
        ],
      ),
    );
  }
}

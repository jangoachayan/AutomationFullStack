import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../core/theme/global_theme_provider.dart';
import '../widgets/room_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Hardcoded User Identity as requested
  final String currentUser = "Dr. Febi Cherian";
  
  // Tab Definitions
  final List<String> _allTabs = ["Home", "Living Room", "Bedroom", "Server Room", "Main Gate"];

  List<String> get _visibleTabs {
    if (currentUser == "Dr. Febi Cherian") {
      return _allTabs.where((tab) => !["Server Room", "Main Gate"].contains(tab)).toList();
    }
    return _allTabs;
  }

  // Mock State for Rooms
  Map<String, bool> roomStates = {
    "Living Room": true,
    "Bedroom": false,
    "Kitchen": false,
    "Garden": true,
  };

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<GlobalThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          themeProvider.logoPath,
          height: 30,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Navigation Tabs (Filtered)
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _visibleTabs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Chip(
                    label: Text(_visibleTabs[index]),
                    backgroundColor: index == 0 ? Theme.of(context).primaryColor : null,
                    labelStyle: TextStyle(
                      color: index == 0 ? Colors.white : Colors.black87
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: roomStates.keys.map((room) {
                return RoomCard(
                  roomName: room,
                  isActive: roomStates[room]!,
                  onTap: () {
                    setState(() {
                      roomStates[room] = !roomStates[room]!;
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

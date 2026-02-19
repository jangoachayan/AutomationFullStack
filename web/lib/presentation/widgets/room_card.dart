import 'package:flutter/material.dart';
import '../../core/utils/haptic_service.dart';

class RoomCard extends StatefulWidget {
  final String roomName;
  final bool isActive;
  final VoidCallback onTap;

  const RoomCard({
    super.key, 
    required this.roomName, 
    this.isActive = false, 
    required this.onTap
  });

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.mediumImpact();
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: widget.isActive
              ? [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.6),
                    blurRadius: 15,
                    spreadRadius: 2,
                  )
                ]
              : [],
          border: widget.isActive 
              ? Border.all(color: Theme.of(context).primaryColor, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            widget.roomName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: widget.isActive 
                  ? Theme.of(context).primaryColor 
                  : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}

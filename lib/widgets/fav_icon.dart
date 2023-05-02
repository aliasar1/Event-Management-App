import 'package:event_booking_app/models/event.dart';
import 'package:flutter/material.dart';

import '../controllers/events_controller.dart';

class FavoriteIcon extends StatefulWidget {
  final Event event;
  final EventController eventController;

  FavoriteIcon({required this.event, required this.eventController});

  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  bool isFavorite = false;

  @override
  void initState() {
    _getFavStatus();
    super.initState();
  }

  void _getFavStatus() async {
    bool favStatus = await widget.eventController.getFavStatus(widget.event.id);
    setState(() {
      isFavorite = favStatus;
    });
  }

  void _toggleFavStatus() async {
    widget.eventController.toggleFavStatus(widget.event);
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _toggleFavStatus(),
      child: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.grey,
      ),
    );
  }
}

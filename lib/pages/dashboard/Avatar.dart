import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;

class Avatar extends StatefulWidget {
  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  Future futureProfile;
  String _avatar = '';

  @override
  void initState() {
    super.initState();

    setState(() {
      _avatar =
          'https://s3-ap-southeast-2.amazonaws.com/prod-app-media.earth2.io/thumbnails/f108dd87-0202-41b4-99b6-b075323f68ea_avatar_31b2e358-e13a-4824-aacc-027ccd507d82.svgxml';
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final avatarSize = screenWidth * 0.2;

    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 4,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: avatarSize * 0.95,
          height: avatarSize * 0.95,
          decoration: new BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: SvgPicture.network(
            _avatar,
            semanticsLabel: 'Avatar',
            placeholderBuilder: (BuildContext context) => Container(
              padding: const EdgeInsets.all(3.0),
              child: const CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}

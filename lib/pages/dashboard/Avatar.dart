import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;

class Avatar extends StatefulWidget {
  String avatar = '';

  Avatar({Key key, @required this.avatar}) : super(key: key);

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final avatarSize = screenWidth * 0.2;

    return Stack(
      children: [
        Container(
          width: avatarSize * 1.1,
          height: avatarSize * 1.2,
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
        ),
        Container(
          width: avatarSize * 1.1,
          height: avatarSize * 1.4,
          child: Center(
            child: SvgPicture.network(
              widget.avatar,
              semanticsLabel: 'Avatar',
              width: avatarSize,
              placeholderBuilder: (BuildContext context) => Container(
                padding: const EdgeInsets.all(3.0),
                child: const CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

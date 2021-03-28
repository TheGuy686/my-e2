import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;

class Avatar extends StatefulWidget {
  String avatar = '';

  Avatar({Key key, @required this.avatar}) : super(key: key);

  @override
  _AvatarState createState() => _AvatarState();
}

Widget _renderAvatarImage(widget, avatarSize) {
  RegExp regExp = new RegExp(
    r"(\.svg)",
    caseSensitive: false,
    multiLine: false,
  );

  double imageWidth = 100;

  if (!regExp.hasMatch(widget.avatar)) {
    return Container(
      padding: EdgeInsets.all(3.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(imageWidth / 2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Image.network(
            widget.avatar,
            height: 80,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  return SvgPicture.network(
    widget.avatar,
    semanticsLabel: 'Avatar',
    width: avatarSize,
    placeholderBuilder: (BuildContext context) => Container(
      padding: EdgeInsets.all(3.0),
      child: CircularProgressIndicator(),
    ),
  );
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
          decoration: BoxDecoration(
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
          height: avatarSize * 1.2,
          child: Center(
            child: _renderAvatarImage(widget, avatarSize),
          ),
        ),
      ],
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveButton extends StatelessWidget {
  final String _text;
  final VoidCallback _handler;
  
  AdaptiveButton(this._text, this._handler);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ?
    CupertinoButton(
      child: Text(_text),
      color: Theme.of(context).primaryColor,
      onPressed: _handler,
    ):
    OutlinedButton(
      child: Text(_text),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(
            Theme.of(context).primaryColor),
        //backgroundColor: MaterialStateProperty.all(Colors.blue),
      ),
      onPressed: _handler,
    );
  }
}

import 'package:flutter/material.dart';

class MyTextEditingController extends TextEditingController {
  final RegExp regex;
  final Color color;
  MyTextEditingController({@required this.regex, this.color = Colors.red});

  TextSpan generateTextSpan(TextStyle style) {
    var highlightStyle = style.merge(TextStyle(color: color));

    Iterable<RegExpMatch> matches = regex.allMatches(text);

    if (matches.length == 0) {
      return TextSpan(style: style, text: text);
    }
    int cursor = 0;
    List<TextSpan> tsList = [];

       for (int i = 0; i < matches.length; i++) {
      RegExpMatch match = matches.elementAt(i);

      if (cursor == match.start) {
        tsList.add(TextSpan(
            style: highlightStyle,
            text: text.substring(match.start, match.end)));
      } else {
        tsList.add(
            TextSpan(style: style, text: text.substring(cursor, match.start)));
        tsList.add(TextSpan(
            style: highlightStyle,
            text: text.substring(match.start, match.end)));
      }

      cursor = match.end;

      if (i == matches.length - 1 && cursor != text.length) {
        tsList.add(
            TextSpan(style: style, text: text.substring(cursor, text.length)));
        print('3');
      }
    }
    
    return TextSpan(children: tsList);
  }

  @override
  TextSpan buildTextSpan({TextStyle style, bool withComposing}) {
    if (!value.composing.isValid || !withComposing) {
      return generateTextSpan(style);
    }
    final TextStyle composingStyle = style.merge(
      const TextStyle(decoration: TextDecoration.underline),
    );
    return TextSpan(style: style, children: <TextSpan>[
      TextSpan(text: value.composing.textBefore(value.text)),
      TextSpan(
        style: composingStyle,
        text: value.composing.textInside(value.text),
      ),
      TextSpan(text: value.composing.textAfter(value.text)),
    ]);
  }
}

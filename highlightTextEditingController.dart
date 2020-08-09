import 'package:flutter/material.dart';

class MyTextEditingController extends TextEditingController {
  final RegExp regex;
  MyTextEditingController({@required this.regex});

  TextSpan generateTextSpan(TextStyle style) {
    
    var highlightStyle = style.merge(TextStyle(color: Colors.red));

    Iterable<RegExpMatch> matches = regex.allMatches(text);

    if (matches.length == 0) {
      return TextSpan(style: style, text: text);
    }
    int cursor = 0;
    List<TextSpan> tsList = [];

    //if we have match in the beginning of text
    if (matches.elementAt(0).start == 0) {
      for (int i = 0; i < matches.length; i++) {
        RegExpMatch match = matches.elementAt(i);
        //add first match
        if (i == 0) {
          tsList.add(TextSpan(
              style: highlightStyle,
              text: text.substring(match.start, match.end)));
          cursor = match.end;
        } else {
          //add excluded match
          tsList.add(TextSpan(
              style: style, text: text.substring(cursor, match.start)));
          //add match
          tsList.add(TextSpan(
              style: highlightStyle,
              text: text.substring(match.start, match.end)));
          cursor = match.end;
          //add remain text after last match
          if (i == matches.length - 1) {
            tsList.add(TextSpan(
                style: style, text: text.substring(cursor, text.length)));
          }
        }
      }
    } else {
      for (int i = 0; i < matches.length; i++) {
        RegExpMatch match = matches.elementAt(i);
        //add text before match
        tsList.add(
            TextSpan(style: style, text: text.substring(cursor, match.start)));
        //add match
        tsList.add(TextSpan(
            style: highlightStyle,
            text: text.substring(match.start, match.end)));
        cursor = match.end;
        //add remain text after last match
        if (i == matches.length - 1) {
          tsList.add(TextSpan(
              style: style, text: text.substring(cursor, text.length)));
        }
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

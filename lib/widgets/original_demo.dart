// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

abstract class MarkdownDemoWidget extends Widget {
  // The title property should be a short name to uniquely identify the example
  // demo. The title will be displayed at the top of the card in the home screen
  // to identify the demo and as the banner title on the demo screen.
  String get title;

  // The description property should be a short explanation to provide
  // additional information to clarify the actions performed by the demo. This
  // should be a terse explanation of no more than three sentences.
  String get description;

  // The data property is the sample Markdown source text data to be displayed
  // in the Formatted and Raw tabs of the demo screen. This data will be used by
  // the demo widget that implements MarkdownDemoWidget to format the Markdown
  // data to be displayed in the Formatted tab. The raw source text of data is
  // used by the Raw tab of the demo screen. The data can be as short or as long
  // as needed for demonstration purposes.
  Future<String> get data;

  // The notes property is a detailed explanation of the syntax, concepts,
  // comments, notes, or other additional information useful in explaining the
  // demo. The notes are displayed in the Notes tab of the demo screen. Notes
  // supports Markdown data to allow for rich text formatting.
  Future<String> get notes;
}

const String _markdownData = """
# Markdown Example
Markdown allows you to easily include formatted text, images, and even formatted
Dart code in your app.

## Titles

Setext-style

```
This is an H1
=============

This is an H2
-------------
```

Atx-style

```
# This is an H1

## This is an H2

###### This is an H6
```

Select the valid headers:

- [x] `# hello`
- [ ] `#hello`

## Links

[Google's Homepage][Google]

```
[inline-style](https://www.google.com)

[reference-style][Google]
```

## Images

![Flutter logo](/dart-lang/site-shared/master/src/_assets/image/flutter/icon/64.png)

## Tables

|Syntax                                 |Result                               |
|---------------------------------------|-------------------------------------|
|`*italic 1*`                           |*italic 1*                           |
|`_italic 2_`                           | _italic 2_                          |
|`**bold 1**`                           |**bold 1**                           |
|`__bold 2__`                           |__bold 2__                           |
|`This is a ~~strikethrough~~`          |This is a ~~strikethrough~~          |
|`***italic bold 1***`                  |***italic bold 1***                  |
|`___italic bold 2___`                  |___italic bold 2___                  |
|`***~~italic bold strikethrough 1~~***`|***~~italic bold strikethrough 1~~***|
|`~~***italic bold strikethrough 2***~~`|~~***italic bold strikethrough 2***~~|

## Styling
Style text as _italic_, __bold__, ~~strikethrough~~, or `inline code`.

- Use bulleted lists
- To better clarify
- Your points

## Code blocks
Formatted Dart code looks really pretty too:

```
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Markdown(data: markdownData),
    ),
  ));
}
```

## Center Title

###### ※ ※ ※

_* How to implement it see main.dart#L129 in example._

## Custom Syntax

NaOH + Al_2O_3 = NaAlO_2 + H_2O

C_4H_10 = C_2H_6 + C_2H_4

## Markdown widget

This is an example of how to create your own Markdown widget:

    Markdown(data: 'Hello _world_!');

Enjoy!

[Google]: https://www.google.com/

## Line Breaks

This is an example of how to create line breaks (tab or two whitespaces):

line 1
  
   
line 2
  
  
  
line 3
""";

const String _notes = """
# Original Markdown Demo
---

## Overview

This is the original Flutter Markdown demo example that was created to
show how to use the flutter_markdown package. There were limitations in
the implementation of this demo example that didn't show the full potential
or extensibility of using the flutter_markdown package. This demo example
is being preserved for reference purposes.

## Comments

This demo example is being preserved for reference purposes.
""";

class OriginalMarkdownDemo extends StatelessWidget
    implements MarkdownDemoWidget {
  static const _title = 'Original Markdown Demo';

  @override
  String get title => OriginalMarkdownDemo._title;

  @override
  String get description => 'The original demo example. This demo was '
      'include with versions of the package prior to version 0.4.4.';

  @override
  Future<String> get data => Future<String>.value(_markdownData);

  @override
  Future<String> get notes => Future<String>.value(_notes);

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Markdown(
          controller: controller,
          selectable: true,
          data: _markdownData,
          imageDirectory: 'https://raw.githubusercontent.com',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_upward),
        onPressed: () => controller.animateTo(0,
            duration: Duration(seconds: 1), curve: Curves.easeOut),
      ),
    );
  }
}

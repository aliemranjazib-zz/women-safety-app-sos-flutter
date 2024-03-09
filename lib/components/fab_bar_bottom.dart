import 'package:flutter/material.dart';
import 'package:women_safety_app/utils/constants.dart';

class FABBottomAppBarItem {
  FABBottomAppBarItem({required this.iconData, required this.text});
  final IconData iconData;
  final String text;
}

class FABBottomAppBar extends StatefulWidget {
  FABBottomAppBar({
    required this.items,
    this.centerItemText,
    this.height = 60.0,
    this.iconSize = 24.0,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.notchedShape,
    required this.onTabSelected,
  }) {
//    assert(this.items.length == 2 || this.items.length == 4);
  }
  final List<FABBottomAppBarItem> items;
  final String? centerItemText;
  final double height;
  final double iconSize;
  final Color? backgroundColor;
  final Color? color;
  final Color? selectedColor;
  final NotchedShape? notchedShape;
  final ValueChanged<int> onTabSelected;

  @override
  _FABBottomAppBarState createState() => _FABBottomAppBarState();
}

class _FABBottomAppBarState extends State<FABBottomAppBar> {
  int _selectedIndex = 0;

  void _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildTabItem({
      required FABBottomAppBarItem item,
      required int index,
      required ValueChanged<int> onPressed,
    }) {
      Color color = _selectedIndex == index ? Colors.white : kColorLightRed1;
      return Expanded(
        child: SizedBox(
          height: widget.height,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () => onPressed(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(item.iconData, color: color, size: widget.iconSize),
                  SizedBox(height: 5.0),
                  Text(item.text, style: TextStyle(color: color, fontSize: 12))
                ],
              ),
            ),
          ),
        ),
      );
    }

    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });

    return Container(
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(10),
        // color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.white.withOpacity(.5),
              spreadRadius: 2,
              blurRadius: 0),
          BoxShadow(
              color: Colors.white.withOpacity(.5),
              spreadRadius: 0,
              blurRadius: 20),
        ],
      ),
      child: BottomAppBar(
        elevation: 5,
        color: kColorRed,
        surfaceTintColor: kColorRed,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items,
        ),
      ),
    );
  }
}

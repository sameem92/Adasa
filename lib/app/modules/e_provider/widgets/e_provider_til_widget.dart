

import 'package:flutter/material.dart';

import '../../../../common/ui.dart';

class EProviderTilWidget extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget> actions;
  final double horizontalPadding;

  const EProviderTilWidget({Key key, this.title, this.content, this.actions, this.horizontalPadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 20, vertical: 2),
      decoration: Ui.getBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Row(
          //   children: [
          //     Expanded(child: title),
          //     if (actions != null)
          //       Wrap(
          //         children: actions,
          //       )
          //   ],
          // ),
          // const Divider(
          //   height: 20,
          //   thickness: 1.2,
          // ),
          content,
        ],
      ),
    );
  }
}

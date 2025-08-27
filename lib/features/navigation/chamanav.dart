import 'package:flexpay/features/flexchama/ui/flexchama_landing.dart';
import 'package:flexpay/features/flexchama/ui/optflexchama.dart';
import 'package:flutter/material.dart';

class FlexChamaTab extends StatelessWidget {
  final bool showOnBoard;
  final VoidCallback onOptIn;

  const FlexChamaTab(
      {Key? key, required this.showOnBoard, required this.onOptIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return showOnBoard ? OnBoardFlexChama(onOptIn: onOptIn) : FlexChama();
  }
}

import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class CardDetails extends StatelessWidget {
  const CardDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: ModelViewer(src: "assets/trio_cat.glb"));
  }
}

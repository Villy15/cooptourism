import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart' as p;

class ViewImagePage extends StatelessWidget {
  final String url;
  const ViewImagePage({
    Key? key,
    required this.url 
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(p.basename(url))
      ),
      body: Image.network(url)
    ); 
    
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart' as p;

class ViewPDFPage extends StatelessWidget {
  final String path;
  const ViewPDFPage({
    Key? key,
    required this.path 
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(p.basename(path))
      ),
      body: PDFView(
        filePath: path,
        
      )
    ); 
    
  }
}
import 'package:flutter/material.dart';
//import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'pdf_document_model.dart';

// ignore: must_be_immutable
class ReaderScreen extends StatefulWidget {
  ReaderScreen(this.doc, {super.key});
  PDFDocument doc;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottomOpacity: 0.5,
        elevation: 0.5,
        leading: Container(
          margin: const EdgeInsets.only(
            left: 20.0,
          ),
          child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              iconSize: 25,
              color: Color(
                  int.parse("#0097b2".substring(1, 7), radix: 16) + 0xFF000000),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        toolbarHeight: 90,
        title: Text(
          '${widget.doc.title!} (${widget.doc.detail!})',
          style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.black),
        ),
        centerTitle: true,
      ),
      //body: SfPdfViewer.network(widget.doc.url!),
    );
  }
}

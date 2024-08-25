import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mr_mm/modules/files/files_screen.dart';
import 'package:mr_mm/modules/home_screen.dart';
import 'package:mr_mm/shared/components.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http; // Add this for network requests

class FileViewScreen extends StatelessWidget {
  final File? file; // Now optional
  final String? fileUrl; // Add this for network files
  final bool isPdf;

  const FileViewScreen({
    super.key,
    this.file,
    this.fileUrl,
    required this.isPdf,
  });

  Future<void> printFile() async {
    try {
      if (isPdf) {
        final bytes = file != null
            ? file!.readAsBytesSync()
            : await http.readBytes(Uri.parse(fileUrl!));
        await Printing.layoutPdf(onLayout: (format) => bytes);
      } else {
        // ... (rest of the printing logic remains the same)
      }
    } catch (e) {
      print("Error printing file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: defaultAppBar(theme, context, () {
        navigateTo(context, const FilesScreen());
      }),
      // appBar: AppBar(
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      //   title: const Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Icon(
      //         Icons.fact_check_outlined,
      //         size: 34.0,
      //         color: Colors.orange,
      //       ),
      //       SizedBox(
      //         width: 5.0,
      //       ),
      //       Text(
      //         'EduManage',
      //         style: TextStyle(
      //             color: Colors.black,
      //             fontWeight: FontWeight.bold,
      //             fontSize: 24.0),
      //       ),
      //     ],
      //   ),
      //   actions: [
      //     isPdf
      //         ? IconButton(
      //             icon: const Icon(Icons.print),
      //             onPressed: printFile,
      //           )
      //         : Container(),
      //   ],
      // ),
      body: WillPopScope(
        onWillPop: () async {
          navigateTo(context, const FilesScreen());
          return true;
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: theme.primaryColor,
          child: isPdf
              ? PdfPreview(
                  build: (format) async => file != null
                      ? file!.readAsBytesSync()
                      : await http.readBytes(Uri.parse(fileUrl!)),
                )
              : Center(
                  child: file != null
                      ? Image.file(file!)
                      : Image.network(fileUrl!),
                ),
        ),
      ),
    );
  }
}

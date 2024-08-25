import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mr_mm/modules/home_screen.dart';
import 'package:mr_mm/shared/constant.dart';

import '../../shared/components.dart';
import 'file_view_screen.dart';

class FilesScreen extends StatefulWidget {
  const FilesScreen({super.key});

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  FilePickerResult? result;
  String? fileName;
  PlatformFile? pickedFile;
  File? fileToDisplay;
  bool isLoading = false;
  List<Map<String, dynamic>> filesList = [];

  @override
  void initState() {
    super.initState();
    loadFiles();
  }

  Future<void> loadFiles() async {
    setState(() {
      isLoading = true;
    });

    filesList = await getAllFiles();

    setState(() {
      isLoading = false;
    });
  }

  void pickFile() async {
    try {
      setState(() {
        isLoading = true;
      });
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png'],
        allowMultiple: false,
      );
      if (result != null) {
        fileName = result!.files.first.name;
        pickedFile = result!.files.first;
        fileToDisplay = File(pickedFile!.path.toString());
        print('File name = $fileName');

        await uploadFileToFirebase();
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> uploadFileToFirebase() async {
    if (pickedFile == null) return;

    try {
      setState(() {
        isLoading = true;
      });

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('files/$uId/${pickedFile!.name}'); // Include uId in the path

      await storageRef.putFile(File(pickedFile!.path!));

      String downloadUrl = await storageRef.getDownloadURL();

      // Use a subcollection for files
      await FirebaseFirestore.instance
          .collection('files')
          .doc(uId)
          .collection('userFiles') // Subcollection for user's files
          .add({
        'name': pickedFile!.name,
        'url': downloadUrl,
        'uploadedAt': Timestamp.now(),
      });

      print('File uploaded successfully: $downloadUrl');
      loadFiles();
    } catch (e) {
      print('Failed to upload file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload file: $e')),
      );
    } finally {
      showToast(text: 'Added successfully!', state: ToastStates.SUCCESS);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> getAllFiles() async {
    filesList.clear();
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('files')
          .doc(uId)
          .collection('userFiles') // Access the subcollection
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Failed to get files: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: defaultAppBar(theme, context, () {
        navigateAndFinish(context, const HomeScreen());
      }),
      body: WillPopScope(
        onWillPop: () async {
          navigateAndFinish(context, const HomeScreen());
          return true;
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: theme.primaryColor,
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                  ),
                )
              : filesList.isEmpty
                  ? Center(
                      child: Text(
                        'No files found',
                        style: TextStyle(
                            fontSize: 21.0, color: theme.unselectedWidgetColor),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      itemBuilder: (context, index) {
                        final file = filesList[index];
                        final fileName = file['name'];
                        final isPdf = fileName.endsWith('.pdf');
                        final fileUrl = file['url'];

                        return buildFileItem(fileName, isPdf, fileUrl, context,theme);
                      },
                      separatorBuilder: (context, index) => Container(
                        width: double.infinity,
                        height: 1.0,
                        color: theme.unselectedWidgetColor,
                      ),
                      itemCount: filesList.length,
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickFile();
        },
        backgroundColor: Colors.orange,
        tooltip: 'Add',
        child: !isLoading
            ? Icon(
                Icons.add,
                size: 40.0,
                color: theme.primaryColor,
              )
            : CircularProgressIndicator(
                color: theme.primaryColor,
              ),
      ),
    );
  }
}

Widget buildFileItem(
    String fileName, bool isPdf, String fileUrl, BuildContext context , ThemeData theme) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: InkWell(
      onTap: () {
        navigateTo(
          context,
          FileViewScreen(
            fileUrl: fileUrl,
            isPdf: isPdf,
          ),
        );
      },
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                fileName,
                style: TextStyle(fontSize: 21.0, color: theme.unselectedWidgetColor),
              ),
            ),
          ),
          const Spacer(),
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: isPdf ? Colors.red : Colors.transparent,
              // Conditionally set color
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: isPdf
                ?  Center(
                    child: Text(
                      'pdf',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: theme.primaryColor), // Added white color for better visibility
                    ),
                  )
                : Image.network(
                    fileUrl,
                    fit: BoxFit.cover,
                  ),
          ),
        ],
      ),
    ),
  );
}

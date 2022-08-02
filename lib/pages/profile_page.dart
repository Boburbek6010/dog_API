import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/network_service.dart';
import '../services/unit_service.dart';
import '../services/util_service.dart';
import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  final int crossAxisCount;

  const ProfilePage({Key? key, this.crossAxisCount = 2}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? file;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  TextEditingController controller = TextEditingController();

  void _gallery() async {
    Navigator.of(context).pop();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      file = File(image.path);
    }
    setState(() {});
  }

  void _getImage() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
                leading: Icon(Icons.photo_library_outlined),
                title: Text("From Gallery"),
                onTap: _gallery),
            ListTile(
              leading: Icon(Icons.camera_alt_outlined),
              title: Text("Take a photo"),
              onTap: _camera,
            ),
          ],
        ),
      ),
    );
  }

  void _camera()async{
    Navigator.of(context).pop();
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if(image == null) return;
    final imageTemp = File(image.path);
    setState(() {
      file = imageTemp;
    });
  }

  void _clear(){
    file = null;
    setState(() {});
  }

  void _upload() async {
    String subId = controller.text.trim();
    if (subId.isEmpty || file == null) {
      Util.fireSnackBar("Please upload image or enter title!", context);
      return;
    }

    isLoading = true;
    setState(() {});

    String? resUploadImg = await NetworkService.MULTIPART(
        NetworkService.API_IMAGE_UPLOAD,
        file!.path,
        NetworkService.bodyImageUpload(subId));

    isLoading = false;
    setState(() {});

    if (resUploadImg != null) {
      if (mounted) {
        Util.fireSnackBar("Your image was successfully uploaded!", context);
      }
      controller.clear();
      file = null;
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => HomePage(
              crossAxisCount: widget.crossAxisCount,
              subPage: 1,
            ),
            transitionDuration: const Duration(seconds: 0),
          ),
        );
      }
    } else {
      if (mounted) {
        Util.fireSnackBar(
            "Failed! Please try again! System error!",
            context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: _upload,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Upload",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: _clear,
                      icon: const Icon(Icons.clear),
                    ),
                  ],
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Container(
                      constraints: file == null
                          ?const BoxConstraints(
                          minHeight: 280,
                          minWidth: 280,
                          maxHeight: 350,
                          maxWidth: 350)
                          :const BoxConstraints(
                          minHeight: 350,
                          minWidth: 350,
                          maxHeight: 400,
                          maxWidth: 400),
                      decoration: file == null
                          ?BoxDecoration(
                          border: Border.all(color: Colors.black, width: 7),
                          shape: BoxShape.circle)
                          :const BoxDecoration(),
                      child: IconButton(
                        splashRadius: 130,
                        onPressed: _getImage,
                        icon: file == null
                            ? const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage("assets/images/img.png")),
                              )
                            : GestureDetector(
                                onTap: _getImage,
                                child: Container(
                                  constraints: const BoxConstraints(
                                      minHeight: 200,
                                      minWidth: 200,
                                      maxHeight: 450,
                                      maxWidth: 450
                                  ),
                                  child: Image.file(file!, fit: BoxFit.fill),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          child: TextField(
                            decoration: InputDecoration(hintText: "Title"),
                          ),
                        )
                      ],
                    )),
              ],
            ),
            const Visibility(
              visible: false,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ));
  }
}

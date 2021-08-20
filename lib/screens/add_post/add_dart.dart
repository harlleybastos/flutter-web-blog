import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news/constants.dart';
import 'package:news/providers/auth.dart';
import 'package:news/services/crud.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({
    Key key,
  }) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String titlePost, descriptionPost, category;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: ChangeNotifierProvider<MyProvider>(
        create: (context) => MyProvider(),
        child: Consumer<MyProvider>(builder: (context, provider, child) {
          return provider.isLoading
              ? Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        FilePickerResult result =
                            await FilePicker.platform.pickFiles();

                        if (result != null) {
                          Uint8List file = result.files.first.bytes;
                          String fileName = result.files.first.name;
                          String path = result.files.first.path;

                          provider.setImage(file, fileName);
                        }
                      },
                      child: provider.image != null
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: 400,
                              margin: EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.memory(provider.image),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding),
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  (6),
                                ),
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.black45,
                              ),
                            ),
                    ),
                    SizedBox(
                      height: kDefaultPadding,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(hintText: "Title"),
                            onChanged: (value) {
                              provider.setTitle(value);
                            },
                          ),
                          TextField(
                            decoration:
                                InputDecoration(hintText: "Description"),
                            onChanged: (value) {
                              provider.setDescription(value);
                            },
                          ),
                          TextField(
                            decoration: InputDecoration(hintText: "Category"),
                            onChanged: (value) {
                              provider.setCategory(value);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: MaterialButton(
                        onPressed: () async {
                          provider.makePostRequest();
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text("Make a post !"),
                      ),
                    )
                  ],
                );
        }),
      ),
    );
  }
}

class MyProvider extends ChangeNotifier {
  var image;
  var title;
  var description;
  bool isLoading = false;
  var fileNameForUpload;
  var fileForUpload;
  var category;
  FilePickerResult pickerResulted;
  CrudMethod crudMethods = new CrudMethod();
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  Future setPickerResult(FilePickerResult resultPicker) async {
    this.pickerResulted = resultPicker;
    this.notifyListeners();
  }

  Future setImage(Uint8List fileBytes, String fileName) async {
    this.image = fileBytes;
    this.fileNameForUpload = fileName;
    this.fileForUpload = fileBytes;
    this.notifyListeners();
  }

  Future setTitle(titlePost) async {
    this.title = titlePost;
    this.notifyListeners();
  }

  Future setDescription(descriptionPost) async {
    this.description = descriptionPost;
    this.notifyListeners();
  }

  Future setCategory(categoryPost) async {
    this.category = categoryPost;
    this.notifyListeners();
  }

  Future setLoading(bool) async {
    this.isLoading = bool;
    this.notifyListeners();
  }

  Future makePostRequest() async {
    var imgUrl;
    if (image != null) {
      setLoading(true);
      UploadTask task = FirebaseStorage.instance
          .ref()
          .child("Files/$fileNameForUpload")
          .putData(fileForUpload);
      imgUrl = await (task.then((res) => res.ref.getDownloadURL()));

      Map<String, String> blogMap = {
        "imgUrl": imgUrl,
        "title": title,
        "description": description,
        "date": formattedDate,
        "category": category
      };
      crudMethods.addData(blogMap).then((value) {
        setLoading(false);
        imgUrl = null;
        title = null;
        description = null;
        formattedDate = null;
        image = null;
        category = null;
      });
      // print("This url $downloadURL");
    }
  }
}

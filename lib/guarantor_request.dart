import 'dart:convert';
import 'dart:io';

import 'package:cooperativeapp/util/my_color.dart';
import 'package:cooperativeapp/util/uitools.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle, rootBundle;
import 'package:cooperativeapp/dio/api_base_helper.dart';
import 'package:cooperativeapp/models/guarantor.dart';
import 'package:cooperativeapp/models/member.dart';
import 'package:cooperativeapp/models/society.dart';
import 'package:cooperativeapp/params/guarantor_resp_param.dart';
import 'package:cooperativeapp/util/app_dialogs.dart';
import 'package:cooperativeapp/util/local_storage.dart';
import 'package:cooperativeapp/util/widget_society_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as IMG;
import 'package:image_cropper/image_cropper.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';

class GuarantorRequestWidget extends StatefulWidget {
  @override
  _GuarantorRequestWidgetState createState() => _GuarantorRequestWidgetState();
}

class _GuarantorRequestWidgetState extends State<GuarantorRequestWidget> {
  List<GuarantorRequest> guarantorRequests = List.empty(growable: true);
  List<GuarantorRequest> searchFilterRequests = List.empty(growable: true);
  List<GuarantorRequest> societyFilteredRequests = List.empty(growable: true);
  List<Member> members = List.empty(growable: true);
  List<Member> membersArray = List.empty(growable: true);
  List<Member> searchFilterMembers = List.empty(growable: true);
  List<Member> societyFilteredMembers = List.empty(growable: true);
  List<Society> societies = List.empty(growable: true);
  Society selectedSociety = new Society(name: 'All');
  bool isLoading = true, isSearching = false;
  TextEditingController controller = TextEditingController();
  int listLength = 0;
  String selectedLoanId = '';
  int selectedLoanIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    societies.add(selectedSociety);
    (ApiBaseHelper().getGuarantorRequests()).then((gValue) {
      if (gValue.success) {
        List<int> ids = List.empty(growable: true);
        for (GuarantorRequest object in gValue.data!) {
          ids.add(int.parse(object.loanRequestMemberId!));
        }
        if (ids.length == 0) {
          setState(() {
            this.isLoading = false;
          });
        } else {
          (ApiBaseHelper().getManyMembers(ids)).then((value) {
            if (value.success) {
              setState(() {
                membersArray.addAll(value.data!);
                members.addAll(convertReq2Mem(gValue.data!));
                searchFilterMembers.addAll(convertReq2Mem(gValue.data!));
                societyFilteredMembers.addAll(convertReq2Mem(gValue.data!));
                this.isLoading = false;
              });
            } else {
              AppDialogs()
                  .handleErrorFromServer(value.statusCode ?? 0, value, context);
            }
          });
        }
        setState(() {
          guarantorRequests.addAll(gValue.data!);
          searchFilterRequests.addAll(gValue.data!);
          societyFilteredRequests.addAll(gValue.data!);
//          guarantorRequests.addAll(value.data.where((element) => element.loanRequestStatus=='pending'));
        });
      } else {
        AppDialogs()
            .handleErrorFromServer(gValue.statusCode ?? 0, gValue, context);
      }
    });

    (LocalStorage().getSocieties()).then((value) {
      setState(() {
        societies.addAll(value!);
      });
    });
    super.initState();
  }

  List<Member> convertReq2Mem(List<GuarantorRequest> requests) {
    List<Member> mems = List.empty(growable: true);
    requests.forEach((element) {
      mems.add(membersArray
          .firstWhere((e) => e.id.toString() == element.loanRequestMemberId));
    });
    return mems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark),
        title: isSearching
            ? searchBox()
            : Text(
                'Guarantor Requests',
                style: TextStyle(color: MyColor.navy, fontSize: 18),
              ),
        actions: isSearching
            ? null
            : [
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        isSearching = true;
                      });
                    })
              ],
        iconTheme: const IconThemeData(color: MyColor.navy),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: SocietyDropDown(
                          societies: societies,
                          selectedSociety: selectedSociety,
                          onChangeValue: (newValue) {
                            societyFilteredMembers.clear();
                            societyFilteredRequests.clear();
                            searchFilterMembers.clear();
                            searchFilterRequests.clear();
                            setState(() {
                              selectedSociety = newValue;
                            });
                            if (selectedSociety.name == 'All') {
                              setState(() {
                                societyFilteredMembers.addAll(members);
                                searchFilterRequests.addAll(guarantorRequests);
                                searchFilterMembers
                                    .addAll(societyFilteredMembers);
                                searchFilterRequests
                                    .addAll(societyFilteredRequests);
                              });
                            } else {
                              societyFilteredRequests.addAll(
                                  guarantorRequests.where((element) =>
                                      element.loanRequestSocietyId ==
                                      selectedSociety.id.toString()));
                              societyFilteredRequests.forEach((element) async {
                                societyFilteredMembers.add(
                                    membersArray.firstWhere((e) =>
                                        e.id.toString() ==
                                        element.loanRequestMemberId));
                              });
                              setState(() {
                                searchFilterRequests
                                    .addAll(societyFilteredRequests);
                                searchFilterMembers
                                    .addAll(societyFilteredMembers);
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Text(
                      '\nThese people want you to be their guarantor (' +
                          searchFilterMembers.length.toString() +
                          ')',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 14, color: Colors.blue)),
                ],
              ),
            ),
            Divider(),
            isLoading
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : Expanded(
                    child: searchFilterMembers.length == 0
                        ? Center(
                            child: Text('No Guarantor Requests',
                                style: TextStyle(fontSize: 18)))
                        : ListView.builder(
                            itemCount: searchFilterMembers.length,
                            itemBuilder: (context, index) {
                              DateTime dateTime = DateTime.parse(
                                  searchFilterRequests[index].createdAt!);
                              Jiffy jiffy = new Jiffy([
                                dateTime.year,
                                dateTime.month,
                                dateTime.day
                              ]);
                              return GestureDetector(
                                onTapDown: (TapDownDetails details) {
                                  if (searchFilterRequests[index].status ==
                                      'pending') {
                                    setState(() {
                                      selectedLoanId =
                                          searchFilterRequests[index]
                                              .loanRequestId!;
                                      selectedLoanIndex = index;
                                    });
                                    _showPopMenu(details.globalPosition);
                                  }
                                },
                                child: Ink(
                                  //color: Colors.white,
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        leading: CircleAvatar(
                                            radius: 24,
                                            backgroundColor:
                                                Colors.indigoAccent,
                                            child: searchFilterMembers[index]
                                                        .passport ==
                                                    ''
                                                ? Icon(Icons.person)
                                                : ClipOval(
                                                    child: Image.network(
                                                      searchFilterMembers[index]
                                                          .passport!,
                                                      height: 48,
                                                      width: 48,
                                                      scale: 1,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          exception,
                                                          stackTrace) {
                                                        return ClipOval(
                                                            child: Image.asset(
                                                          'assets/default_female_avatar.png',
                                                          fit: BoxFit.cover,
                                                        ));
                                                      },
                                                    ),
                                                  )),
                                        title: Text(
                                          searchFilterMembers[index].name!,
                                          style: getTextStyle(
                                              searchFilterRequests[index]
                                                  .status!),
                                        ),
                                        subtitle: Text(
                                          societies
                                                  .firstWhere((e) =>
                                                      e.id.toString() ==
                                                      searchFilterRequests[
                                                              index]
                                                          .loanRequestSocietyId)
                                                  .name ??
                                              '',
                                          style: getTextStyle(
                                              searchFilterRequests[index]
                                                  .status!),
                                        ),
                                        contentPadding: EdgeInsets.all(0),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            getStatusIcon(
                                                searchFilterRequests[index]
                                                    .status!),
                                            Text(
                                              jiffy.format('dd/MM/yy'),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider()
                                    ],
                                  ),
                                ),
                              );
                            }),
                  )
          ],
        ),
      ),
    );
  }

  Icon getStatusIcon(String status) {
    if (status == 'accepted') {
      return Icon(Icons.done, color: Colors.green);
    } else if (status == 'pending') {
      return Icon(Icons.hourglass_full, color: Colors.orange);
    } else {
      return Icon(Icons.close, color: Colors.grey[500]);
    }
  }

  Color getColor(String status) {
    if (status == 'accepted') {
      return Colors.greenAccent;
    } else if (status == 'rejected') {
      return Colors.grey.shade200;
    } else {
      return Colors.yellow;
    }
  }

  TextStyle getTextStyle(String status) {
    if (status == 'accepted') {
      return TextStyle(color: MyColor.navy);
    } else if (status == 'rejected') {
      return TextStyle(color: Colors.grey[500]);
    } else {
      return TextStyle(color: Colors.green);
    }
  }

  Widget searchBox() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextField(
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        onChanged: (value) {
          onSearchTextChanged(value);
        },
        controller: controller,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            suffixIcon: IconButton(
              iconSize: 24,
              icon: Icon(Icons.close, color: Colors.grey.shade100),
              onPressed: () {
                setState(() {
                  isSearching = false;
                  searchFilterMembers.clear();
                  searchFilterRequests.clear();
                  controller.text = '';
                  searchFilterMembers.addAll(societyFilteredMembers);
                  searchFilterRequests.addAll(societyFilteredRequests);
                });
              },
            ),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade100),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            filled: true,
            fillColor: Colors.indigoAccent,
            hintText: 'Search name here...',
            hintStyle: TextStyle(color: Colors.grey.shade100)),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    List<Member> filter = List.empty(growable: true);
    List<GuarantorRequest> filterReq = List.empty(growable: true);
    searchFilterMembers.clear();
    searchFilterRequests.clear();
    for (int i = 0; i < societyFilteredMembers.length; i++) {
      Member member = societyFilteredMembers[i];
      GuarantorRequest request = societyFilteredRequests[i];
      if (member.name!.toLowerCase().contains(text.toLowerCase())) {
        filter.add(member);
        filterReq.add(request);
      }
    }
    setState(() {
      searchFilterMembers.addAll(filter);
      searchFilterRequests.addAll(filterReq);
    });
  }

  _showPopMenu(Offset offset) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, 10000000, 0),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          child: Text('Accept'),
          value: 1,
        ),
        PopupMenuItem(
          child: Text('Reject'),
          value: 2,
        ),
      ],
      elevation: 5.0,
    ).then<void>((value) {
      if (value == null) return;

      if (value == 1) {
        AppDialogs().showToast(
            'Attention',
            'This feature is not yet available on mobile. Please goto the ICT unit of the Union to accept this guarantor request.',
            context);
        // acceptRequest();
      } else if (value == 2) {
        showRejectAlertDialog(context);
      }
    });
  }

  showAcceptAlertDialog(BuildContext context, String base64) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        AppDialogs().onLoadingDialog(context);
        GuarantorResponseParam param = new GuarantorResponseParam();
        param.response = 'accepted';
        param.loanRequestId = selectedLoanId;
        param.guarantorImg = base64;
        (ApiBaseHelper().respondToGuarantorReq(param)).then((value) {
          Navigator.pop(context);
          if (value.success) {
            AppDialogs().showToast('Success', value.msg ?? '', context);
            setState(() {
              searchFilterRequests[selectedLoanIndex].status = 'accepted';
            });
          } else {
            AppDialogs()
                .handleErrorFromServer(value.statusCode ?? 0, value, context);
          }
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Accept Request"),
      content: Text("Are you sure you want to accept guarantor request from " +
          (societyFilteredMembers[selectedLoanIndex].name ?? '') +
          "? "),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showRejectAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.pop(context);
        AppDialogs().onLoadingDialog(context);
        GuarantorResponseParam param = new GuarantorResponseParam();
        param.response = 'rejected';
        param.loanRequestId = selectedLoanId;
        param.guarantorImg = null;
        (ApiBaseHelper().respondToGuarantorReq(param)).then((value) {
          Navigator.pop(context);
          if (value.success) {
            AppDialogs().showToast('Success', value.msg ?? '', context);
            setState(() {
              searchFilterRequests[selectedLoanIndex].status = 'rejected';
            });
          } else {
            AppDialogs()
                .handleErrorFromServer(value.statusCode ?? 0, value, context);
          }
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Reject Request"),
      content: Text("Are you sure you want to reject guarantor request from " +
          (societyFilteredMembers[selectedLoanIndex].name ?? '') +
          "?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void acceptRequest() {
    // ImagePicker imagePicker = new ImagePicker();
    // Future<XFile?> pickedFile = imagePicker.pickImage(source: ImageSource.camera, maxWidth: 160, maxHeight: 160, imageQuality: 50);
    // pickedFile.then((value) {
    //   if(value !=null){
    //     bottomSheetPicture(value.path, id, index);
    //   }
    // });
    getImageFileFromAssets('test_pic.jpg');
  }

  void getImageFileFromAssets(String path) async {
    imageCache.clear();
    final byteData = await rootBundle.load('assets/$path');

    // var decodedImage = await decodeImageFromList(byteData);

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    cropImage(file, path);
    //FOR IMAGE SIZE IN KB

    // final bytes = (await image.readAsBytes()).lengthInBytes;
    // final bytes = image.readAsBytesSync().lengthInBytes;
    // final kb = bytes / 1024;
    // final mb = kb / 1024;
  }

  void cropImage(File imageFile, String fileName) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        // CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        // CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9
      ],
      compressFormat: ImageCompressFormat.jpg,
      cropStyle: CropStyle.rectangle,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          cropFrameColor: Colors.blue,
          cropFrameStrokeWidth: 2,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (croppedFile != null) {
      bottomSheetPicture(File(croppedFile.path));
    }
  }

  void bottomSheetPicture(File croppedFile) async {
    final image = IMG.decodeImage(croppedFile.readAsBytesSync());
    final thumbnail = IMG.copyResize(image!, width: 160, height: 120);
    String tempFilePath =
        '${(await getTemporaryDirectory()).path}/croppeed_temp${DateTime.now().toIso8601String()}.png';
    File(tempFilePath).writeAsBytesSync(IMG.encodeJpg(thumbnail));
    File resizedPic = File(tempFilePath);
    //   final imageByte2 = IMG.encodeJpg(thumbnail);

    //
    String base64 = base64Encode(resizedPic.readAsBytesSync());

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
            color: Color(0xFF737373),
            child: new Container(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppRectangle(
                      child: Image.file(
                        croppedFile,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Text(base64),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        MaterialButton(
                            padding: EdgeInsets.all(12),
                            onPressed: () {
                              // Navigator.pop(context);
                              // acceptRequest(id, index);
                            },
                            color: Colors.indigoAccent,
                            child: Text(
                              'RECAPTURE',
                              style: TextStyle(color: Colors.white),
                            )),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: MaterialButton(
                              padding: EdgeInsets.all(12),
                              onPressed: () {
                                showAcceptAlertDialog(context, base64);
                              },
                              color: Colors.indigo,
                              child: Text(
                                'PROCEED',
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                      ],
                    ),
                  ],
                )));
      },
    );
  }
}

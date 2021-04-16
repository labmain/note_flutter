import 'package:note_flutter/Manager/UserTools.dart';
import 'package:uuid/uuid.dart';

class NotebookModel {
  late String id;
  late String name;
  List<String> noteList = [];
  double? updateTime;
  late String userID;

  NotebookModel(
      {required this.id,
      required this.name,
      this.updateTime,
      required this.userID});

  NotebookModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    updateTime = json['updateTime'];
    if ( json['userID'] == null) {
      userID = "0";
    } else {
      userID = json['userID'];
    }
    if (json['noteList'] != null) {
      noteList = <String>[];
      json['noteList'].forEach((v) {
        noteList.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['updateTime'] = this.updateTime;
    data['userID'] = this.userID;
    if (this.noteList != null) {
      data['noteList'] = this.noteList;
    }
    return data;
  }

  // 创建一个笔记模型
  static NotebookModel createNote(String name) {
    var notebook = NotebookModel(
        id: Uuid().v1(), name: name, userID: UserTools.instance.currentUser.id);
    return notebook;
  }
}

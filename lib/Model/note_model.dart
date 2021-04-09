import 'package:uuid/uuid.dart';

class NoteModel {
  /// 笔记id
  String id;

  /// 关联的书本id
  String noteBookID;

  /// 时间戳
  double updateTime;

  /// 笔记本标题
  String get title {
    if (content == null) {
      return "无内容";
    }
    if (content.length < 40) {
      return content.replaceAll("\n", "\t");
    }
    return content.substring(0, 40).replaceAll("\n", "\t");
  }

  /// 笔记内容
  String content;
  String userID;

  NoteModel({this.id, this.content, this.userID});

  NoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noteBookID = json['noteBookID'];
    content = json['content'];
    userID = json['userID'];
    updateTime = json["updateTime"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['noteBookID'] = this.noteBookID;
    data['content'] = this.content;
    data['user_id'] = this.userID;

    return data;
  }

  // 创建一个笔记模型
  static NoteModel createNote(String notebookID) {
    var note = NoteModel();
    note.noteBookID = notebookID;
    note.id = Uuid().v1();
    return note;
  }
}

import 'package:uuid/uuid.dart';

class NoteModel {
  /// 笔记id
  String id;

  /// 关联的书本id
  String noteBookID;

  /// 笔记本标题
  String title;

  /// 笔记内容
  String content;
  String userID;

  NoteModel({this.id, this.title, this.content, this.userID});

  NoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    noteBookID = json['note_book_id'];
    content = json['content'];
    userID = json['userID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
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

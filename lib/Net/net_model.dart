import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:note_flutter/Model/note_model.dart';
import 'package:note_flutter/Model/notebook_model.dart';
import 'json_convert_content.dart';
import 'net_utils.dart';
import 'package:dio/dio.dart';

class SystemNetUtils {
  static final String iPString = "http://localhost:8080";

  /// 返回所有的笔记本列表
  static Future<List<NotebookModel>> requestNodeBookList() async {
    ResponseResult<NotebookModel> result =
        await NetUtils.instance.get<NotebookModel>('$iPString/notebook');
    return result.list;
  }

  /// 返回所有的笔记列表
  static Future<List<NoteModel>> getAllNoteList({String notebookID}) async {
    ResponseResult<NoteModel> result = await NetUtils.instance
        .get<NoteModel>('$iPString/note', params: {"id": notebookID});
    return result.list;
  }

  /// 删除一个笔记
  static Future<bool> deleteNote(String noteID) async {
    ResponseResult result =
        await NetUtils.instance.del("$iPString/note", body: {"id": noteID});
    return result.state == ResponseResultType.success;
  }

  /// 保存一个笔记
  static Future<bool> saveNote(NoteModel note) async {
    ResponseResult result =
        await NetUtils.instance.post("$iPString/note", body: note.toJson());
    return result.state == ResponseResultType.success;
  }
}

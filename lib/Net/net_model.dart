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
  static Future<List<NoteModel>> getAllNoteList() async {
    ResponseResult<NoteModel> result =
        await NetUtils.instance.get<NoteModel>('$iPString/note');
    return result.list;
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:note_flutter/Model/note_model.dart';
import 'package:note_flutter/Model/notebook_model.dart';
import 'package:note_flutter/Model/user_model.dart';
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

  static Future<bool> checkNotebookName(String name) async {
    ResponseResult<Map<String, dynamic>> result = await NetUtils.instance
        .get<Map<String, dynamic>>("$iPString/notebook/check",
            params: {"name": name});
    return result.result["isHas"] == "1";
  }

  /// 创建一本笔记
  static Future<bool> createNotebook(NotebookModel notebook) async {
    ResponseResult<NotebookModel> result = await NetUtils.instance
        .post<NotebookModel>("$iPString/notebook", body: notebook.toJson());
    return result.state == ResponseResultType.success;
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

  /// 创建一个用户
  static Future<User> registerUser(
      String name, String password, String confirmPassword) async {
    ResponseResult<User> result = await NetUtils.instance
        .post<User>("$iPString/users", body: {
      "name": name,
      "password": password,
      "confirmPassword": confirmPassword
    });
    return result.result;
  }

  /// 登录
  static Future<User> login(String name, String password) async {
    // 基本加密 base64
    var str = name + ":" + password;
    var bytes = utf8.encode(str);
    var encoded1 = base64Encode(bytes);

    ResponseResult<User> result = await NetUtils.instance.post<User>(
        "$iPString/login",
        header: {"Authorization": "Basic " + encoded1});
    return result.result;
  }
}

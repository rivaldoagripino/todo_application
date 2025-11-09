import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_application/modules/todo/domain/models/todo_item_model.dart';

class CustomSharedPreferences {
  static SharedPreferences? _prefs;

  static Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    await _init();
    await _prefs!.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    await _init();
    return _prefs!.getString(key);
  }

  static Future<void> setInt(String key, int value) async {
    await _init();
    await _prefs!.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    await _init();
    return _prefs!.getInt(key);
  }

  static Future<void> setBool(String key, bool value) async {
    await _init();
    await _prefs!.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    await _init();
    return _prefs!.getBool(key);
  }

  static Future<void> remove(String key) async {
    await _init();
    await _prefs!.remove(key);
  }

  static Future<void> clear() async {
    await _init();
    await _prefs!.clear();
  }

  static Future<void> setTodoList(List<TodoItemModel> todoList) async {
    await _init();
    final jsonList = todoList.map((e) => e.toJsonString()).toList();
    await _prefs!.setStringList('todoList', jsonList);
  }

  static Future<void> removeTodoItem(List<TodoItemModel> todoItems) async {
    await _init();
    final currentList = await getTodoList();
    final idsToRemove = todoItems.map((item) => item.id).toSet();
    final updatedList =
        currentList.where((item) => !idsToRemove.contains(item.id)).toList();
    await setTodoList(updatedList);
  }

  static Future<List<TodoItemModel>> getTodoList() async {
    await _init();
    final jsonList = _prefs!.getStringList('todoList');
    return jsonList?.map((e) => TodoItemModel.fromJsonString(e)).toList() ?? [];
  }
}

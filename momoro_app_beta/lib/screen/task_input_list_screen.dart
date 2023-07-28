import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../data_manage_component/db_helper.dart';


class TaskInputListScreen extends StatefulWidget {
  final DateTime selectedDate;

  const TaskInputListScreen({super.key, required this.selectedDate});

  @override
  State<TaskInputListScreen> createState() => _TaskInputListScreenState();
}

class _TaskInputListScreenState extends State<TaskInputListScreen> {

  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;

// Get All Data From Database
  void _refreshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

// Add Data
  Future<void> _addData() async {
    await SQLHelper.createData(_titleController.text, _descController.text);
    _refreshData();
  }

// Update Data
  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(id, _titleController.text, _descController.text);
    _refreshData();
  }

// Delete Data (삭제 아이콘 누르면 밑에 빨간색 표시되는 부분)
  Future<void> _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text("Data Deleted"),
    ));
    _refreshData();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  void showBottomSheet(int? id) async {
    // if id is not null then it will update other wise it will new data
    // when edit icon is pressed then id will be given to bottomsheet function and
    // it will edit
    if (id != null) {
      final existingData =
      _allData.firstWhere((element) => element['id'] == id);
      _titleController.text = existingData['title'];
      _descController.text = existingData['desc'];
    }

    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) =>
          Container(
            padding: EdgeInsets.only(
              top: 30,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 50,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    //labelText: "Title",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.redAccent),
                    ),
                    border: OutlineInputBorder(),
                    labelText: "'감사한 일' / '다행인 일' / '잘한 일' 중 1가지 입력",
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _descController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.redAccent),
                    ),
                    border: OutlineInputBorder(),
                    labelText: "내용 입력",
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (id == null) {
                        await _addData();
                      }
                      if (id != null) {
                        await _updateData(id);
                      }

                      _titleController.text = "";
                      _descController.text = "";

                      Navigator.of(context).pop();
                      print("Data Added");
                    },
                    child: Padding(
                      padding: EdgeInsets.all(18),
                      child: Text(id == null ? "Add Data" : "Update",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = widget.selectedDate;

    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Challenge"),
        centerTitle: true,
      ),

      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              height: 150,
              //color: Colors.greenAccent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일 "
                          "${DateFormat.EEEE('ko').format(selectedDate)}",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    //color: Colors.amberAccent,
                    margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            "오늘의 점수는?",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          padding: EdgeInsets.only(right: 8),
                        ),
                        RatingBar.builder(
                          initialRating: 3,
                          minRating: 0.5,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.favorite,
                            color: Colors.pinkAccent,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.indigo,
                    width: 3,
                  ),
                  color: Colors.indigoAccent,
                ),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                //padding: EdgeInsets.only(top: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      //color: Colors.tealAccent,
                      child: Text(
                        "<'감사한 일' / '다행인 일' / '잘한 일'>",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          //color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _allData.length,
                        itemBuilder: (context, index) =>
                            Card(
                              margin: EdgeInsets.all(15),
                              child: ListTile(
                                title: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    _allData[index]['title'],
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                subtitle: Text(_allData[index]['desc']),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showBottomSheet(_allData[index]['id']);
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.indigo,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _deleteData(_allData[index]['id']);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet(null),
        child: Icon(Icons.add),
      ),
    );
  }
}
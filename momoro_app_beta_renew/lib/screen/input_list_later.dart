import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../data_manage_component/db_helper.dart';

class InputListLaterScreen extends StatefulWidget {
  final DateTime selectedDate;

  const InputListLaterScreen({super.key, required this.selectedDate});

  @override
  State<InputListLaterScreen> createState() => _InputListLaterScreenState();
}

class _InputListLaterScreenState extends State<InputListLaterScreen> {
  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;
  late double ratingValue; // Rating_Bar 별점 점수 저장하기 위한 변수

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
  Future<void> _addData(rating, date) async {
    await SQLHelper.createData(rating, _thanksController.text,
        _reliefController.text, _goodController.text, date);
    _refreshData();
  }

// Update Data
  Future<void> _updateData(date) async {
    await SQLHelper.updateDescData(date, _thanksController.text,
        _reliefController.text, _goodController.text);
    _refreshData();
  }

  final TextEditingController _thanksController = TextEditingController();
  final TextEditingController _reliefController = TextEditingController();
  final TextEditingController _goodController = TextEditingController();

  void showBottomSheet(int? id) async {
    // if id is not null then it will update other wise it will new data
    // when edit icon is pressed then id will be given to bottomsheet function and
    // it will edit
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);

      _thanksController.text = existingData['thanksDesc'];
      _reliefController.text = existingData['reliefDesc'];
      _goodController.text = existingData['goodDesc'];
    }

    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
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
              controller: _thanksController,
              decoration: const InputDecoration(
                //labelText: "Title",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.redAccent),
                ),
                border: OutlineInputBorder(),
                labelText: "'감사한 일' / '다행인 일' / '잘한 일' 중 1가지 입력",
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _updateData(widget.selectedDate);

                  _thanksController.text = "";

                  Navigator.of(context).pop();
                  print("Data Added");
                },
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    id == null ? "Add Data" : "Update",
                    style: const TextStyle(
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
        title: const Text("Daily Challenge"),
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
                    //color: Colors.amberAccent,
                    padding: const EdgeInsets.only(top: 10),
                    height: 150,
                    //color: Colors.greenAccent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일 "
                            "${DateFormat.EEEE('ko').format(selectedDate)}",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          //color: Colors.amberAccent,
                          margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(right: 8),
                                child: const Text(
                                  "오늘의 점수는?",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              RatingBar.builder(
                                initialRating: 3,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.favorite,
                                  color: Colors.pinkAccent,
                                ),

                                // 여기서 점수 받는 변수 선언한 뒤 rating 받기
                                onRatingUpdate: (rating) {
                                  ratingValue = rating;
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
                          width: 1,
                        ),
                        color: Colors.indigoAccent,
                      ),
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                      //padding: EdgeInsets.only(top: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // '1. 감사한 일' 박스
                          Container(
                            margin: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "1. 감사한 일",
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.indigo,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // '2. 다행인 일' 박스
                          Container(
                            margin: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "2. 다행인 일",
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.indigo,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // '3. 잘한 일' 박스
                          Container(
                            margin: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "3. 잘한 일",
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.indigo,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

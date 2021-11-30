library date_selector;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DateSelector extends StatefulWidget {

  bool isYear;
  bool isDay;
  String category;
  String firstDate;
  String lastDate;
  String initDate;
  Function onChangeFunction;
  Function? onSubmitFunction;
  double fontSize;
  EdgeInsets contentPadding;
  bool reset;


  DateSelector(
      {
        Key? key,
        this.isYear = false,
        this.isDay = false,
        this.category = '',
        this.firstDate = '',
        this.lastDate = '',
        required this.initDate,
        required this.onChangeFunction,
        this.onSubmitFunction,
        this.fontSize = 14,
        this.contentPadding = const EdgeInsets.fromLTRB(0, 0, 0, 7),
        this.reset = true,
      }
      ) : super(key: key);

  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {

  late FocusNode _yearFocus;
  late FocusNode _monthFocus;
  late FocusNode _dayFocus;
  late FocusNode _yearTextFieldFocus;

  final TextEditingController _yearController = TextEditingController(text: '2020');
  final TextEditingController _monthController = TextEditingController(text: '12');
  final TextEditingController _dayController = TextEditingController(text: '01');

  bool _yearFocusCheck = false;
  bool _monthFocusCheck = false;
  bool _dayFocusCheck = false;

  String _prevYear = '';
  String _prevMonth = '';
  String _prevDay = '';

  int _lastDay = 31;

  static void _toastMsg(String msg, {int showTime=3}){
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: showTime,
      textColor: Colors.white,
      fontSize: 16.0,
      webPosition: 'center',
      webBgColor: '#009aff',
    );
  }

  static bool _checkRegNumber(String text) {
    String pattern = r'^(0(\.\d+)?|(-?[1-9]\d*(\.\d+)?)|(-0\.\d*[1-9]+\d*))$';
    return RegExp(pattern).hasMatch(text);
  }

  void _setDate(){
    String date = '';
    if(widget.isYear){
      date = _yearController.text + "-01-01";
    }else if(widget.isYear == false && widget.isDay == false){
      String month = _monthController.text;
      month = month.length==1 ? "0"+month : month;
      date = _yearController.text + "-" + month + "-01";
    }else{
      String month = _monthController.text;
      month = month.length==1 ? "0"+month : month;
      String day = _dayController.text;
      day = day.length==1 ? "0"+day : day;
      date = _yearController.text + "-" + month + "-" + day;
    }
    widget.onChangeFunction(date);
  }

  void _setLastDay(){
    String year = _yearController.text;
    String month = _monthController.text;
    if(year != '0' && month != '0'){
      try{
        month = month.substring(0,1) == '0' ? month.substring(1) : month;
        _lastDay = DateTime(int.parse(year),int.parse(month)+1,0).day;
        // print(year + ":" + month + ":"+_lastDay.toString());
      }catch(e){
        _toastMsg('올바르지 않은 형식입니다.');
      }
    }
  }

  void _resetParam(){
    String year = widget.initDate.split('-')[0];
    String month = widget.initDate.split('-')[1];
    String day = widget.initDate.split('-')[2];
    _yearController.text = year;
    _monthController.text = month;
    _dayController.text = day;
  }

  void monthListener(){
    if(_monthController.selection.isValid){
      _monthController.selection = TextSelection(baseOffset: 0, extentOffset: _monthController.text.length);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _yearFocus = FocusNode();
    _monthFocus = FocusNode();
    _dayFocus = FocusNode();
    _yearTextFieldFocus = FocusNode();

    _yearFocus.addListener((){
      _yearFocusCheck = _yearFocus.hasFocus;
      if(_yearFocusCheck && _yearTextFieldFocus.hasFocus == false){
        _yearFocus.requestFocus(_yearTextFieldFocus);
      }
      _yearController.notifyListeners();
    });
    _yearController.addListener((){
      _yearController.selection = TextSelection(baseOffset: _yearFocusCheck ? 0 : _yearController.text.length, extentOffset: _yearController.text.length);
    });

    _monthFocus.addListener((){
      _monthFocusCheck = _monthFocus.hasFocus;
      _monthController.notifyListeners();
    });
    _monthController.addListener((){
      _monthController.selection = TextSelection(baseOffset: _monthFocusCheck ? 0 : _monthController.text.length, extentOffset: _monthController.text.length);
    });

    _dayFocus.addListener((){
      _dayFocusCheck = _dayFocus.hasFocus;
      _dayController.notifyListeners();
    });
    _dayController.addListener((){
      _dayController.selection = TextSelection(baseOffset: _dayFocusCheck ? 0 : _dayController.text.length, extentOffset: _dayController.text.length);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _yearFocus.dispose();
    _monthFocus.dispose();
    _dayFocus.dispose();
    _yearTextFieldFocus.dispose();

    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.reset){
      widget.reset = false;
      _resetParam();
    }
    return Container(
      height: 40,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 년
          SizedBox(
            width: 37,
            child: RawKeyboardListener(
              focusNode: _yearFocus,
              onKey: (event){
                if(event is RawKeyDownEvent){
                  if((event.isShiftPressed == false && event.isKeyPressed(LogicalKeyboardKey.tab)) || event.isKeyPressed(LogicalKeyboardKey.arrowRight)){
                    _monthFocus.requestFocus();
                  }else if(event.isShiftPressed && event.isKeyPressed(LogicalKeyboardKey.tab)){
                    _yearFocus.requestFocus();
                  }else{
                    if(event.character != null && _checkRegNumber(event.character!)){
                      _prevYear = _yearController.text;
                    }else if(event.isKeyPressed(LogicalKeyboardKey.arrowUp)){
                      int upYear = int.parse(_yearController.text) + 1;
                      if(upYear <= 9999){
                        _yearController.text = upYear.toString();
                      }else{
                        _yearController.text = '0';
                      }
                    }else if(event.isKeyPressed(LogicalKeyboardKey.arrowDown)){
                      int downYear = int.parse(_yearController.text) - 1;
                      if(downYear >= 0){
                        _yearController.text = downYear.toString();
                      }else{
                        _yearController.text = '9999';
                      }
                    }else if(event.isKeyPressed(LogicalKeyboardKey.backspace)){
                      _yearController.text = '0';
                    }
                    _setDate();
                    _setLastDay();
                  }
                }
              },
              child: TextField(
                focusNode: _yearTextFieldFocus,
                controller: _yearController,
                maxLength: 4,
                decoration: InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  contentPadding: widget.contentPadding,
                ),
                style: TextStyle(fontSize: widget.fontSize,),
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.go,
                onChanged: (value){
                  if(_checkRegNumber(value) == false){
                    if(value.trim() != ''){
                      _toastMsg('숫자만 입력할 수 있습니다.');
                    }
                    _yearController.text = '0';
                  }else{
                    if(_prevYear.length == 4){
                      _prevYear = _prevYear.substring(1);
                    }else if(_prevYear == '0'){
                      _prevYear = '';
                    }
                    _yearController.text = _prevYear + value;
                    _setLastDay();
                  }
                  _setDate();
                },
                onSubmitted: widget.onSubmitFunction != null ? (value){
                  widget.onSubmitFunction!();
                } : null,
              ),
            ),
          ),
          widget.isYear ? Container() : Row(
            children: [
              Text('-', style: TextStyle(fontSize: widget.fontSize),),
              SizedBox(
                width: 20,
                child: RawKeyboardListener(
                  focusNode: _monthFocus,
                  onKey: (event){
                    if(event is RawKeyDownEvent){
                      if((event.isShiftPressed == false && event.isKeyPressed(LogicalKeyboardKey.tab)) || (widget.isDay && event.isKeyPressed(LogicalKeyboardKey.arrowRight))){
                        _dayFocus.requestFocus();
                      }else if(event.isShiftPressed && event.isKeyPressed(LogicalKeyboardKey.tab)){
                        _monthFocus.requestFocus();
                      }else if(event.isKeyPressed(LogicalKeyboardKey.arrowLeft)){
                        _yearFocus.requestFocus();
                      }else{
                        if(event.character != null && _checkRegNumber(event.character!)){
                          _prevMonth = _monthController.text.substring(1);
                        }else if(event.isKeyPressed(LogicalKeyboardKey.arrowUp)){
                          int upMonth = int.parse(_monthController.text) + 1;
                          if(upMonth < 10){
                            _monthController.text = "0"+upMonth.toString();
                          }else if(upMonth <= 12){
                            _monthController.text = upMonth.toString();
                          }else{
                            _monthController.text = '01';
                          }
                        }else if(_monthController.text.trim() != '' && event.isKeyPressed(LogicalKeyboardKey.arrowDown)){
                          int downMonth = int.parse(_monthController.text) - 1;
                          if(10 <= downMonth && downMonth <= 12){
                            _monthController.text = downMonth.toString();
                          }else if(1 <= downMonth && downMonth < 10){
                            _monthController.text = "0"+downMonth.toString();
                          }else{
                            _monthController.text = '12';
                          }
                        }else if(event.isKeyPressed(LogicalKeyboardKey.backspace)){
                          _monthController.text = '01';
                        }
                        _setDate();
                        _setLastDay();
                      }
                    }
                  },
                  child: TextField(
                    controller: _monthController,
                    maxLength: 2,
                    decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      contentPadding: widget.contentPadding,
                    ),
                    style: TextStyle(fontSize: widget.fontSize,),
                    textAlign: TextAlign.center,
                    onChanged: (value){
                      if(_checkRegNumber(value) == false){
                        if(value.trim() != ''){
                          _toastMsg('숫자만 입력할 수 있습니다.');
                        }
                        _monthController.text = '01';
                      }else{
                        if(_prevMonth == '1'){
                          if(int.parse(value) > 2){
                            _monthController.text = '0' + value;
                          }else{
                            _monthController.text = _prevMonth + value;
                          }
                        }else if(_prevMonth == '0' && value == '0'){
                          _monthController.text = '01';
                        }else{
                          _monthController.text = '0' + value;
                        }
                        _setLastDay();
                      }
                      _setDate();
                    },
                  ),
                ),
              ),
              widget.isDay ? Row(
                children: [
                  Text('-', style: TextStyle(fontSize: widget.fontSize),),
                  SizedBox(
                    width: 20,
                    child: RawKeyboardListener(
                      focusNode: _dayFocus,
                      onKey: (event){
                        if(event is RawKeyDownEvent){
                          if(event.isShiftPressed && event.isKeyPressed(LogicalKeyboardKey.tab)){
                            _dayFocus.requestFocus();
                          }else if(event.isKeyPressed(LogicalKeyboardKey.arrowLeft)){
                            _monthFocus.requestFocus();
                          }else{
                            if(event.character != null && _checkRegNumber(event.character!)){
                              _prevDay = _dayController.text.substring(1);
                            }else if(event.isKeyPressed(LogicalKeyboardKey.arrowUp)){
                              int upDay = int.parse(_dayController.text) + 1;
                              if(upDay < 10){
                                _dayController.text = "0"+upDay.toString();
                              }else if(upDay <= _lastDay){
                                _dayController.text = upDay.toString();
                              }else{
                                _dayController.text = '01';
                              }
                            }else if(event.isKeyPressed(LogicalKeyboardKey.arrowDown)){
                              int downDay = int.parse(_dayController.text) - 1;
                              if(10 <= downDay && downDay <= _lastDay){
                                _dayController.text = downDay.toString();
                              }else if(1 <= downDay && downDay < 10){
                                _dayController.text = "0"+downDay.toString();
                              }else{
                                _dayController.text = _lastDay.toString();
                              }
                            }else if(event.isKeyPressed(LogicalKeyboardKey.backspace)){
                              _dayController.text = '01';
                            }
                            _setDate();
                          }
                        }
                      },
                      child: TextField(
                        controller: _dayController,
                        maxLength: 2,
                        decoration: InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          contentPadding: widget.contentPadding,
                        ),
                        style: TextStyle(fontSize: widget.fontSize,),
                        textAlign: TextAlign.center,
                        onChanged: (value){
                          if(_checkRegNumber(value) == false){
                            if(value.trim() != ''){
                              _toastMsg('숫자만 입력할 수 있습니다.');
                            }
                            _dayController.text = '01';
                          }else {
                            if (_prevDay == '1') {
                              _dayController.text = _prevDay + value;
                            } else if (_prevDay == '2' || _prevDay == '3') {
                              if(int.parse(_prevDay + value) > _lastDay){
                                _dayController.text = '0' + value;
                              }else{
                                _dayController.text = _prevDay + value;
                              }
                            } else if (_prevDay == '0' && value == '0') {
                              _dayController.text = '01';
                            } else {
                              _dayController.text = '0' + value;
                            }
                          }
                          _setDate();
                        },
                      ),
                    ),
                  ),
                ],
              ) : Container(),
            ],
          )
        ],
      ),
    );
  }
}

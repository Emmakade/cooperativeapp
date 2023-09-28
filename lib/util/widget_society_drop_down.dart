import 'package:cooperativeapp/models/society.dart';
import 'package:flutter/material.dart';


class SocietyDropDown extends StatefulWidget {
  final List<dynamic>? societies;
  final dynamic selectedSociety;
  final Function(dynamic)? onChangeValue;
  SocietyDropDown({this.societies, this.selectedSociety, this.onChangeValue});

  @override
  _SocietyDropDownState createState() => _SocietyDropDownState();
}

class _SocietyDropDownState extends State<SocietyDropDown> {

  @override
  Widget build(BuildContext context) {
//    return InputDecorator(
//      expands: true,
//      decoration: InputDecoration(
//          filled: true,
//          fillColor: Colors.grey[200],
//          contentPadding:
//          EdgeInsets.symmetric(vertical: 4, horizontal: 16),
//          //errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
//          border: OutlineInputBorder(
//              borderRadius: BorderRadius.circular(10),
//              borderSide: BorderSide(style: BorderStyle.none, width: 0))),
//      child: DropdownButtonHideUnderline(
//        child: DropdownButton(
//          hint: Text('Select Society'),
//          value: widget.selectedSociety,
//          onChanged: widget.onChangeValue,
//          items: buildDropDownMenuItems(widget.societies),
//        ),
//      ),
//    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
       // border: Border.all(
       //   color: Colors.black,
       //   width: 0
       // )
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          hint: Text('Select Society'),
          value: widget.selectedSociety,
          onChanged: widget.onChangeValue,
          items: buildDropDownMenuItems(widget.societies?.cast()??[]),
        ),
      ),
    );
  }


  List<DropdownMenuItem<Society>> buildDropDownMenuItems(List<Society> societies) {
    List<DropdownMenuItem<Society>> items = [];
    for (Society society in societies) {
      items.add(DropdownMenuItem(
        value: society,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(society.name??'',maxLines: 1, overflow: TextOverflow.ellipsis,),
        ),
      ));
    }
    return items;
  }

}


class YearDropDown extends StatefulWidget {
  final List<int>? yearList;
  final dynamic selectedYear;
  final Function(dynamic)? onChangeValue;
  YearDropDown({this.yearList, this.selectedYear, this.onChangeValue});

  @override
  _YearDropDownState createState() => _YearDropDownState();
}

class _YearDropDownState extends State<YearDropDown> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
//        border: Border.all(
//          color: Colors.black,
//          width: 0
//        )
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: Text('Select Society'),
          value: widget.selectedYear,
          onChanged: widget.onChangeValue,
          items: buildDropDownMenuItems(widget.yearList??[]),
        ),
      ),
    );
  }


  List<DropdownMenuItem<int>> buildDropDownMenuItems(List<int> years) {
    List<DropdownMenuItem<int>> items = [];
    for (int year in years) {
      items.add(DropdownMenuItem(
        value: year,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(year.toString(), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ));
    }
    return items;
  }

}


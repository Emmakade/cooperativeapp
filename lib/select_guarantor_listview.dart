
import 'package:cooperativeapp/models/member.dart';
import 'package:cooperativeapp/util/local_storage.dart';
import 'package:flutter/material.dart';


class GuarantorsListView extends StatefulWidget {
  final List<Member> listData;
  GuarantorsListView(this.listData);

  @override
  _GuarantorsListViewState createState() => _GuarantorsListViewState();
}

class _GuarantorsListViewState extends State<GuarantorsListView> {

  List<Member> _filteredList = List.empty(growable: true);
  List<Member> _selectedList = List.empty(growable: true);
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _filteredList.addAll(widget.listData);
    (LocalStorage().getLoginDetails()).then((value){
      String id = value?.user?.memberId??'';
      setState(() {
        _filteredList.removeWhere((element) => element.id.toString() == id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.close), onPressed: (){ Navigator.pop(context);}),
                Expanded(child: Text(_selectedList.length.toString() + ' selected', style: TextStyle(fontSize: 16),)),
                IconButton(icon: Icon(Icons.done), onPressed: (){ Navigator.pop(context, _selectedList);})
              ],
            )
        ),
        Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: TextField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            onChanged: (value) {onSearchTextChanged(value);},
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 0, style: BorderStyle.none),
                  borderRadius: BorderRadius.all(
                      Radius.circular(10)),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Search name here...',
                hintStyle: TextStyle(color: Colors.grey)),
          ),
        ),
        Container(
          height: 500,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _filteredList.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTileItem(
                        image: _filteredList[index].passport??'',
                        title: _filteredList[index].name??'',
                        onChanged: (value) {
                          if (value) {
                            setState(() {
                              _selectedList.add(_filteredList[index]);
                            });
                          } else {
                            setState(() {
                              _selectedList.remove(_filteredList[index]);
                            });
                          }
                        })
                );
              }),
        ),
      ],
    );
  }


  onSearchTextChanged(String text) async {
    List<Member> filter = List.empty(growable: true);
    _filteredList.clear();
    widget.listData.forEach((member) {
      if (member.name!.toLowerCase().contains(text.toLowerCase())) {
        setState(() {
          filter.add(member);
        });
      }
    });
    setState(() {
      _filteredList.addAll(filter);
    });
  }


}

class ListTileItem extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final String title, image;
  ListTileItem({required this.title, required this.onChanged, required this.image});

  @override
  _ListTileItemState createState() => _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem> {
  bool _selected = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){setState(() {
        _selected = !_selected;
        widget.onChanged(_selected);
      });},
      leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.indigoAccent,
          child: widget.image=='' ? Icon(Icons.person) :
          ClipOval(
            child: Image.network(widget.image,
              height: 48,
              width: 48,
              scale: 1,
              fit: BoxFit.cover,
              errorBuilder: (context, exception, stackTrace) {
                return ClipOval(child: Image.asset('assets/default_female_avatar.png', fit: BoxFit.cover,));
              },
            ),
          )
      ),
      title: Text(widget.title),
      trailing: Checkbox(
          value: _selected,
          onChanged: null
      ),
    );
  }
}


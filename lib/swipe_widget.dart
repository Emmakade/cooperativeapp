import 'package:flutter/material.dart';

class SwipeWidget extends StatefulWidget {
  final Widget AssetCard;
  final Widget LoanCard;

  const SwipeWidget({Key? key, required this.AssetCard, required this.LoanCard})
      : super(key: key);
  @override
  _SwipeWidgetState createState() => _SwipeWidgetState();
}

class _SwipeWidgetState extends State<SwipeWidget> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Set a bounded height
      child: Column(
        children: [
          SizedBox(
            height: 150, // Set the height for your cards
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                print("Page: $page");
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                widget.AssetCard,
                widget.LoanCard,
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: (() {
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }),
                  child: Text(
                    'Savings',
                    style: TextStyle(color: Colors.blueGrey),
                  )),
              SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text(
                  'Loan',
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

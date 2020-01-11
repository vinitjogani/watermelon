import 'package:flutter/material.dart';

class SplashLayout extends StatelessWidget {

  final String title, subtitle, buttonText;
  final Function callback;
  final bool buttonVisible;

  SplashLayout({this.title, this.subtitle, this.buttonText, this.callback, this.buttonVisible = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff43cea2),
                Color(0xff185a9d),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 100, 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[100], fontSize: 20, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20,),
              Visibility(
                visible: buttonVisible,
                child: InkWell(
                  onTap: callback,
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Color(0xffefefef),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            buttonText,
                            style: TextStyle(fontSize: 20, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          Icon(Icons.chevron_right)
                        ],
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

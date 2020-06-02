import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:to_do_task/scoped_model.dart/main.dart';
import 'package:to_do_task/widget_utils/custom_bottom_navigationbar.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatefulWidget {
  final MainModel model;
  Contact(this.model);
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Invalid $url';
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: false,
        headers: <String, String>{"header_key": "header_value"},
      );
    } else {
      throw ("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: width / 15.0),
        child: ListView(physics: BouncingScrollPhysics(), children: <Widget>[
          ListTile(
            title: Text(
              "1234-1234567-1234",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Help Desk"),
            trailing: Padding(
              padding: const EdgeInsets.all(0.0),
              child: RawMaterialButton(
                onPressed: () => _makePhoneCall("tel:+92-51-1234567"),
                child: Icon(
                  Icons.call,
                  color: Colors.white,
                ),
                elevation: 2,
                shape: CircleBorder(),
                fillColor: Color(0xff7061aa),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0, right: 40),
            child: Divider(color: Colors.black45),
          ),
          ListTile(
            title: Text(
              "Visit our Website",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Visit Our Website"),
            trailing: Padding(
              padding: const EdgeInsets.all(0.0),
              child: RawMaterialButton(
                onPressed: () => _launchURL("https://google.com"),
                child: Icon(
                  MdiIcons.web,
                  color: Colors.white,
                ),
                elevation: 2,
                shape: CircleBorder(),
                fillColor: Color(0xff7061aa),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0, right: 40),
            child: Divider(color: Colors.black45),
          ),
          ListTile(
            title: Text(
              "Visit our Facebook Page",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Official Facebook Page"),
            trailing: Padding(
              padding: const EdgeInsets.all(0.0),
              child: RawMaterialButton(
                onPressed: () =>
                    _launchURL("https://web.facebook.com/kustofficial/"),
                child: Icon(
                  MdiIcons.facebook,
                  color: Colors.white,
                ),
                elevation: 2,
                shape: CircleBorder(),
                fillColor: Color(0xff7061aa),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0, right: 40),
            child: Divider(color: Colors.black45),
          ),
        ]),
      ),
      bottomNavigationBar: CustonBottomNavigationBar(widget.model),
    );
  }
}

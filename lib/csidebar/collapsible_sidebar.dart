import 'package:finalproject/constant.dart';
import 'package:finalproject/csidebar/photouploads.dart';
import 'package:finalproject/csidebar/settings.dart';
import 'package:finalproject/screen/auth/login_page.dart';
import 'package:finalproject/screen/home.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class NavBar extends StatefulWidget {

  final List data;
  const NavBar({
    required this.data,
    Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  File? file;
  ImagePicker image = ImagePicker();
  List users = <dynamic>[];
  late SharedPreferences loginData;
  late String username;
  List user = <dynamic>[];
  int userId = 0;

  @override
  void initState() {
    super.initState();
    getUsers();
  }


  getUsers() async {
    var url = 'https://640d7547b07afc3b0dadbf4d.mockapi.io/users';
    var response = await http.get(Uri.parse(url));

    setState( () {
      users = convert.jsonDecode(response.body) as List<dynamic>;
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: primaryBGColor,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              accountName: Text("${widget.data[0]['username']}",
                style: TextStyle(
                  color: mainTextColor,
                ),
              ),
              accountEmail: Text('${widget.data[0]['email']}',
                style: TextStyle(
                  color: mainTextColor,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                  child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black,
                          child: ClipOval(
                            child: SizedBox(
                              width: 150.0,
                              height: 100.0,
                              child: Image.network(
                                "${widget.data[0]['avatar']}",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ]
                  )
              ),
              decoration: const BoxDecoration(
                color: Colors.greenAccent,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        'https://static.vecteezy.com/system/resources/thumbnails/000/582/800/small_2x/RR-v-mar-2019-52.jpg'
                    )
                ),
              )
          ),
          ListTile(
            leading: Icon(Icons.home,
              color: mainTextColor,
            ),
            title: Text ('Home',
              style: TextStyle(
                color: mainTextColor,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                          data: widget.data
                      )
                  )
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.image_rounded,
              color: mainTextColor,
            ),
            title: Text ('Photo Uploads',
              style: TextStyle(
                color: mainTextColor,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ImageShare())
              );
            },
          ),
          ListTile(
            leading: Icon(
                Icons.settings,
              color: mainTextColor,
            ),
            title: Text('Settings',
              style: TextStyle(
                color: mainTextColor,
              ),
            ),
            onTap: () {
              userId = int.parse(widget.data[0]['id']);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Settings(
                          data: userId,
                      )
                  )
              );
            },
          ),
          // ListTile(
          //   leading: Icon(
          //       Icons.email,
          //     color: mainTextColor,
          //   ),
          //   title: Text('Profile',
          //     style: TextStyle(
          //       color: mainTextColor,
          //     ),
          //   ),
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const Profile()
          //         )
          //     );
          //   },
          // ),
          const Divider(),
          ListTile(
            title: Text('Log Out',
              style: TextStyle(
                color: mainTextColor,
              ),
            ),
            leading: Icon(Icons.logout_sharp,
              color: mainTextColor,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginPage()
                  )
              );
            },
          ),
        ],
      ),
    );
  }
  getCam(ImageSource source) async {
    // ignore: deprecated_member_use
    var img = await image.getImage(
        source: ImageSource.camera
    );
    setState(() {
      file = File(img!.path);
    });
  }

  getGall(ImageSource source) async {
    // ignore: deprecated_member_use
    var img = await image.getImage(
        source: ImageSource.gallery
    );
    setState(() {
      file = File(img!.path);
    });
  }
}

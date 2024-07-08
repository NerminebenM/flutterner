import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_green/CustomBottomNavigationBar.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = 'Your Name';
  String _email = 'email@example.com';
  String _imagePath = 'assets/images/pfp.jpg';

  //
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  _loadProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Your Name';
      _email = prefs.getString('email') ?? 'email@example.com';
      _imagePath = prefs.getString('image') ?? 'assets/images/pfp.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            LineAwesomeIcons.angle_left,
            color: Colors.white,
          ),
        ),
        title: Text(
          "profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.blue,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  border: Border.all(width: 4, color: Colors.white),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1),
                    )
                  ],
                  shape: BoxShape.circle,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: _imagePath.startsWith('http')
                          ? NetworkImage(_imagePath, scale: 1.0)
                              as ImageProvider<Object>
                          : AssetImage(_imagePath),
                      onError: (exception, stackTrace) {
                        // handle the error here
                        print("Failed to load image: $exception");
                      },
                      // colorFilter: ColorFilter.mode(
                      //   Colors.green.withOpacity(0.3),
                      //   BlendMode.dstATop,
                      // ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                _username,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white),
              ),
              Text(
                _email,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
              ),
              ElevatedButton(
                onPressed: () {
                  print(
                      'Edit Profile Pressed'); // Add a print statement to check if this gets printed
                  Navigator.pushNamed(context, '/updateProfile');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 50, vertical: 20), // adjusted padding
                  minimumSize: Size(200, 60), // minimum width and height
                  textStyle:
                      TextStyle(fontSize: 20), // font size of button text
                ),
                child: Text('Edit Profile',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),

              const SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width *
                    0.7, // 70% of screen width
                child: const Divider(),
              ),
              const SizedBox(
                height: 10,
              ),
              // Menu
              ProfileMenuWidget(
                title: "Settings",
                icon: LineAwesomeIcons.cog,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "help and assistance",
                icon: LineAwesomeIcons.question,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "User Management",
                icon: LineAwesomeIcons.user_check,
                onPress: () {},
              ),

              ProfileMenuWidget(
                title: "Information",
                icon: LineAwesomeIcons.info,
                onPress: () {
                  Navigator.pushNamed(context, '/grid');
                },
              ),

              Container(
                width: MediaQuery.of(context).size.width *
                    0.7, // 70% of screen width
                child: const Divider(),
              ),
              ProfileMenuWidget(
                title: "Logout",
                icon: LineAwesomeIcons.alternate_sign_out,
                textColor: Colors.red,
                iconColor: Colors.red,
                iconOutlineColor: Colors.red.withOpacity(0.2),
                endIcon: false,
                onPress: () {
                  // Show a confirmation dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content:
                            const Text('Are you sure you want to log out?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();

                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.clear();

                              Navigator.pushNamed(context, '/');
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _currentIndex = index;
          switch (index) {



            case 0:
              Navigator.pushNamed(context, '/listpost');
              break;


            case 1:
              Navigator.pushNamed(context, '/adminEvent');
              break;
            case 2:
              Navigator.pushNamed(context, '/events');
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;



            default:
          }
        },
      ),
      // bottomNavigationBar: ,
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
    this.iconColor,
    this.iconOutlineColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;
  final Color? iconColor;
  final Color? iconOutlineColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: iconOutlineColor ?? Colors.white.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: iconColor ?? Colors.white,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor ?? Colors.white,
        ),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white.withOpacity(0.1),
              ),
              child: const Icon(
                LineAwesomeIcons.angle_right,
                size: 18,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}

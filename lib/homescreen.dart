import 'dart:convert';
import 'package:assignment01/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<UserModel> userDataList = [];
  Future<List<UserModel>> getUserApi() async {
    final response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      for (var i in data) {
        userDataList.add(UserModel.fromJson(i));
      }
      return userDataList;
    } else {
      return userDataList;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          "User Data",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: getUserApi(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: userDataList.length,
              itemBuilder: (context, index) {
                LatLng userLocation = LatLng(
                  double.parse(
                      userDataList[index].address!.geo!.lat.toString()),
                  double.parse(
                      userDataList[index].address!.geo!.lng.toString()),
                );
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: Card(
                    color: Colors.grey[200],
                    elevation: 7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                              color: Colors.blueGrey, shape: BoxShape.circle),
                          child: Center(
                              child: Text(
                            "${index + 1}",
                            style: const TextStyle(color: Colors.white),
                          )),
                        ),
                        ReusableRow(
                          icon: Icons.person_4_rounded,
                          value: userDataList[index].name.toString(),
                        ),
                        ReusableRow(
                          icon: Icons.email,
                          value: userDataList[index].email.toString(),
                        ),
                        ReusableRow(
                          icon: Icons.phone,
                          value: userDataList[index].phone.toString(),
                        ),
                        ReusableRow(
                          icon: Icons.web,
                          value: userDataList[index].website.toString(),
                        ),
                        ReusableRow(
                          icon: Icons.location_on,
                          value: userDataList[index].address!.city.toString(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  IconData? icon;
  String value;
  ReusableRow({
    super.key,
    this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.blueGrey),
          Text(value),
        ],
      ),
    );
  }
}

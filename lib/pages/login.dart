import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/config.dart';
import 'package:flutter_application_2/config/internal_config.dart';
import 'package:flutter_application_2/model/request/customer_login_post_req.dart';
import 'package:flutter_application_2/model/response/customer_login_post_res.dart';
import 'package:flutter_application_2/pages/register.dart';
import 'package:flutter_application_2/pages/showtrip.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  String url = '';
  int number = 0;
  String phoneNo = '';
  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndPoint'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onDoubleTap: () {
                log('onDoubleTap is fired');
              },
              child: Image.asset('assets/images/logo.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(children: [Text('หมายเลขโทรศัพท์')]),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                    controller: phoneNoCtl,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(children: [Text('รหัสผ่าน')]),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                    controller: passwordCtl,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: register,
                    child: const Text('ลงทะเบียนใหม่'),
                  ),
                  FilledButton(
                    onPressed: login,
                    child: const Text('เข้าสู่ระบบ'),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 10,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void login() async {
    text = '';
    CustomerLoginPostRequest req = CustomerLoginPostRequest(
      phone: phoneNoCtl.text,
      password: passwordCtl.text,
    );

    http
        .post(
          Uri.parse("$API_ENDPOINT/customers/login"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerLoginPostRequestToJson(req),
        )
        .then((value) {
          log(value.body);
          CustomerLoginPostResponse customerLoginPostResponse =
              customerLoginPostResponseFromJson(value.body);
          log(customerLoginPostResponse.customer.fullname);
          log(customerLoginPostResponse.customer.email);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      ShowTripPage(cid: customerLoginPostResponse.customer.idx),
            ),
          );
        })
        .catchError((error) {
          log('Error $error');
          text = 'Error, Invalid phone or password';
        });
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }
}

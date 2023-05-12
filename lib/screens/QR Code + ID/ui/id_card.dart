import 'package:flutter/material.dart';
import 'dart:convert';

Widget IDCard(
  String name,
  String branch,
  String dob,
  String uid,
  String phone,
  String imgURL,
  Color c,
) {
  return Container(
    margin: const EdgeInsets.all(10),
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 100,
          color: c,
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                color: c,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'Society for Computer Technology & Research\'s',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'PUNE INSTITUTE OF',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      'COMPUTER TECHNOLOGY',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin:
              const EdgeInsets.only(top: 50, bottom: 10, left: 100, right: 100),
          // width: 150,
          height: 150,
          color: Colors.grey,
          child: Image.memory(
            fit: BoxFit.cover,
            base64Decode(imgURL),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Name : ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              name,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        const SizedBox(
          height: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Branch : ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              branch,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        const SizedBox(
          height: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              ' D.O.B : ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              dob,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Reg.ID NO : ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              uid.toString(),
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Phone No : ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              phone,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Container(
          height: 20,
          color: c,
        ),
      ],
    ),
  );
}

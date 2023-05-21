import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LibraryDetails {
  late String bookName;
  late DateTime issueDate;
  late DateTime returnDate;
}

Widget LibraryCardWidget(Map<String, String> m, Function deleteBook) {
  return Container(
    height: 120,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: 120,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            color: Colors.blue,
          ),
          child: const Center(
            child: Icon(
              Icons.book,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m['bookName'] ?? 'No Book Name',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  (m['issueDate'] ?? '').isEmpty
                      ? 'No Issue Date'
                      : 'Issue Date: ${DateFormat("yyyy-MM-dd").parse(m['issueDate']!).toString().substring(0, 10)}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  (m['returnDate'] ?? '').isEmpty
                      ? 'No Return Date'
                      : 'Return Date: ${DateFormat("yyyy-MM-dd").parse(m['returnDate']!).toString().substring(0, 10)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            deleteBook(m['bookName']);
          },
          icon: const Icon(Icons.delete),
        ),
        const SizedBox(
          width: 5,
        ),
      ],
    ),
  );
}

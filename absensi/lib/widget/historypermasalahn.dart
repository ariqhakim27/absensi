import 'package:flutter/material.dart';

class historypermasalahanwidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(children: [
              for (int i = 0; i < 5; i++)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      width: 300,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Flexible(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                // Container(
                                //   width: 190,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "SI621400 - Audit Sistem Informasi",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    SizedBox(height: 11),
                                    Text(
                                      "15-03-2024",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ])));
  }
}

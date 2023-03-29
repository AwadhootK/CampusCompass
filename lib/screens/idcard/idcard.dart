import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Idcard extends StatelessWidget {
  Map<String, String> user = {'Name':'Kaustubh Narendra Joshi', "Branch":'Computer Engineering', 'DOB':'15-07-2003', 'Validity':'JULY 2021 - JUNE 2022'};

  final String uid;
  Idcard(@required this.uid);

  Future<void> getData() async {
    //get map
    // user
  }

  @override
  Widget build(BuildContext context) {
    // getData();
    return Container
    
    (
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column
      (
        children: 
        [
          Container(height: 50,color: Color.fromARGB(255, 137, 199, 230)),
          Container(height: 100,color: Color.fromARGB(255, 111, 226, 53),padding: EdgeInsets.all(10),
            child: Row
            (
              children: 
              [
                 Image.asset('assets/images/pict.png'),
                 Column
                 (
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: 
                  [
                    Center(child: Text('Society for Computer Technology & Research\'s',style: TextStyle(color: Colors.white,fontSize: 10),)),
                    SizedBox(height: 10,),
                    Center(child: Text('PUNE INSTITUTE OF',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                    SizedBox(height: 3,),
                    Center(child: Text('COMPUTER TECHNOLOGY',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                  ],
                 ),
              ],
            ),),
            Container(margin: EdgeInsets.only(top: 50, bottom: 10, left: 100, right:100),
              width: 150, height: 150, color: Colors.grey,),
            Center(child: Text(user['Name']!.toUpperCase(),style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold), )),
            SizedBox(height: 7,),
            Center(child: Text(user['Branch']!.toUpperCase(), style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold),)),
            SizedBox(height: 7,),
            Row
            (
              mainAxisAlignment: MainAxisAlignment.center,

              children: 
              [
                Text(' D.O.B : ',style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),),
                Text(user['DOB']!,style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),),
              ],
            ),
            SizedBox(height: 5,),
            Row
            (
              mainAxisAlignment: MainAxisAlignment.center,
              children: 
              [
                Text('Reg.ID NO : ', style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),),
                Text(uid.toString(),style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),),
              ],
            ),
            SizedBox(height: 5,),
            Row
            (
              mainAxisAlignment: MainAxisAlignment.center,

              children: 
              [
                Text('Validity : ',style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),),
                Text(user['Validity']!,style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),),
              ],
            ),
            SizedBox(height: 50,),
            Container(height: 20,color: Color.fromARGB(255, 111, 226, 53),),
        ],
      ),
      
    color: Colors.white,);
  }
}
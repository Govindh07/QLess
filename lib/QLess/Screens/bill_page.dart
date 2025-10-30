import 'package:flutter/material.dart';

class BillPage extends StatelessWidget {
  const BillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            child: Stack(
                children: [Container(
                  height: 180,
                  child: Center(),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50)),
                      color: Colors.blue
                  ),
                ),
                  Positioned(
                      bottom: 80,
                      right: 0,
                      left: 0,


                      child: Center(

                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              image: DecorationImage(image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/800px-QR_code_for_mobile_English_Wikipedia.svg.png'))
                          ),
                          height: 150,
                          width: 150,

                        ),
                      )),
                  Positioned(

                      left: 0,
                      right: 0,
                      bottom: 35,
                      child: Center(child: Column(
                        children: [
                          Text("Here's Your Qr",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),),
                          Text('Qr : 7777',
                            style: TextStyle(
                                fontSize: 14
                            ),),

                        ],
                      )
                      )

                  )




                ]
            ),
            height: 300,
            width: double.infinity,
          ),
          Center(child: Text('Thank You for Shopping With us!!',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold

            ),),)


        ],
      ),
    );
  }
}
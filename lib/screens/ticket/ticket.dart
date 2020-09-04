import 'package:flutter/material.dart';

class Ticket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(top:200.0),
        child: Container(
          height: 300,
          child: Column(
            children: [
              Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.symmetric(vertical: 0.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey[300],
            ),
            borderRadius: BorderRadius.circular(25.0)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Departure In:"),
                      SizedBox(
                        height: 5.0,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 
                              // distance != null
                              //     ? roundDouble((distance * 1.6), 2).toString(): 
                              "no value",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            TextSpan(
                                text: "min",
                                style: Theme.of(context).textTheme.subtitle),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Travel Time: ",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: "tim",
                                  // travelTime(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45)),
                              TextSpan(
                                  text: " min",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Travel Distance: ",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: "dis", 
                                  // travelDistance(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45)),
                              TextSpan(
                                  text: " KM",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ],
                          ),
                        ),
                      ]),
                  // Text(
                  //   "19:57",
                  //   style:
                  //       Theme.of(context).textTheme.body2.apply(color: Colors.blue),
                  // ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
               crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.directions_bus,
                          color: Colors.black54,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                          child: Text(
                            "07:05",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 3.0,
                          width: 3,
                        ),
                        Text(
                        "a",
                          // getStationName(_valueFrom),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.directions_bus,
                          color: Colors.black54,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 9.0),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                          child: Text(
                            "07:23",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                          height: 3.0,
                        ),
                        Text("a",
                          // getStationName(_valueTo),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: RaisedButton.icon(
                    color: Colors.lightGreen,
                    icon: Icon(Icons.confirmation_number, color: Colors.white),
                    onPressed: () {},
                    label: Text(
                      // roundDouble(double.parse(travelDistance()) * 2.5, 2)
                      //         .toString() +
                          "SR",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .apply(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
              ),
            ]),
              ),
              )
    );
  }
}

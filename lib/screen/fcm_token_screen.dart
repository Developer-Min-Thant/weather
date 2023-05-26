import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather/utils/notification_service.dart';

class FCMTokenScreen extends StatelessWidget {
  const FCMTokenScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Use below token to send firebase notificaiton.'),
              const SizedBox(height: 30,),
              FutureBuilder<String>(
                future: NotificationService().getFCMToken(),
                builder: (context, snapshot){  
                  if(snapshot.hasData) {
                    return Column(
                      children: [
                        Text(snapshot.data.toString()),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: snapshot.data.toString()));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Text copied to clipboard'),
                              ),
                            );// Replace with your desired text
                          },
                          child: const Text('Click To Copy'),
                        ),
                      ],
                    );
                    
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return const Center(child: SpinKitCubeGrid(color: Colors.blue, size: 80));
                  }  
                }          
              ),
              
              
            ],
           
          ),
        )
      ),
    );
  }
}



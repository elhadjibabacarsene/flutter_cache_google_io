import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gallery_cache/src/features/news/presentation/widgets/news_item.dart';
import '../../../../constants/colors/app_colors.dart';
import '../widgets/error.dart';
import '../widgets/not_connected.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gray01,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions:  const [
          const Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(
              Icons.refresh,
              color: Colors.black,
            ),
          )
        ],
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DakarNews',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Hello, voici les dernières news 🤗',
              style: TextStyle(
                color: gray02,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:SingleChildScrollView(
              child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ), ListView.separated(
                      separatorBuilder: (context, index){
                        return const Divider();
                      },
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: 0,
                      itemBuilder: (context, index) {
                        return Container();
                      },
                    )
                  ],
                ),
            )
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<StatefulWidget> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(flex: 1),
          SizedBox(
            height: 500,
            child: PageView.builder(
              onPageChanged: (index){
                setState(() {
                  _selectedIndex = index;
                });
              },
                itemCount: demoData.length,
                itemBuilder: (context,index){
                      return OnboardingContent(illustration: demoData[index]['illustration'], text: demoData[index]['text'], title: demoData[index]['title']);
                }
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(demoData.length, (index) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: AnimatedDot(isActive:  _selectedIndex == index,),
            ))
          ),
          Spacer(flex: 2),
          ElevatedButton(onPressed: (){}, child: Text("Commencer".toUpperCase())),
          Spacer()
        ],
      )
    );
  }
}

class AnimatedDot extends StatelessWidget {
  const AnimatedDot({
    super.key, required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 20 : 6,
      decoration: BoxDecoration(
          color: isActive ? Color(0xFF000000) : Color(0xFF868686).withOpacity(0.25),
        borderRadius: BorderRadius.all(Radius.circular(12))
      ),

    );
  }
}

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key, required this.illustration, required this.text, required this.title,
  });

  final String illustration,text,title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
        Column(
          children: [
            Expanded(child: AspectRatio(aspectRatio: 1, child: Image.asset(illustration))),
            SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        )
    );
  }
}

List<Map<String,dynamic>> demoData = [
  {
    "illustration" : "assets/Illustrations/I1.png",
    "title" : "All your fav1",
    "text" : "Order now"
  },
  {
    "illustration" : "assets/Illustrations/I1.png",
    "title" : "All your fav2",
    "text" : "Order now"
  },
  {
    "illustration" : "assets/Illustrations/I1.png",
    "title" : "All your fav3",
    "text" : "Order now"
  }
];
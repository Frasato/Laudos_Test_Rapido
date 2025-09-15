import 'package:flutter/material.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/bg.jpg'),
          fit: BoxFit.cover
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Laudos Para Testes Rápidos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: ()=>{Navigator.pushReplacementNamed(context, '/covid')},
                  child: Text('Covid-19')
                ),
                SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: ()=>{Navigator.pushReplacementNamed(context, '/dengue')},
                  child: Text('Dengue')
                ),
              ],
            ),
          ],
        )
      ),
    )
  );
}
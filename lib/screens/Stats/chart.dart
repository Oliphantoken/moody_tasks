import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyChart extends StatefulWidget {
  const MyChart({super.key});

  @override
  State<MyChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  @override
  Widget build(BuildContext context) {
    return BarChart(createBarChart());
  }

  BarChartData createBarChart(){
    return BarChartData(

      //Labels
      titlesData: FlTitlesData (
        show: true,
        topTitles: AxisTitles( sideTitles: SideTitles(showTitles: false) ),   //Top
        rightTitles: AxisTitles( sideTitles: SideTitles(showTitles: false) ), //Right

        //Left
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50, //width of label
            getTitlesWidget: _getLeftTitles,
          )
        ),
       
        //Bottom
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 38,
            getTitlesWidget: _getBottomTitles,
          )
        ),

      ),

      borderData: FlBorderData( show: false ),
      gridData: const FlGridData( show: false ),
      
      //SHOW DATA
      barGroups: showGroups()


    );
  }

  ///Horizontal labels in bottom x axis, goes from left to right
  SideTitleWidget _getBottomTitles(double value, TitleMeta tm){

    const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14);

    Widget text;
    switch (value.toInt()) {
      case 0: text = const Text('01', style: style); break;
      case 1: text = const Text('02', style: style); break;
      case 2: text = const Text('03', style: style); break;
      case 3: text = const Text('04', style: style); break;
      case 4: text = const Text('05', style: style); break;
      case 5: text = const Text('06', style: style); break;
      case 6: text = const Text('07', style: style); break;
      case 7: text = const Text('08', style: style); break;
      default: text = const Text('', style: style); break;
    }

    return SideTitleWidget(meta: tm, space: 16, child: text);
  }

///Vertical labels to the left, goes from bottom to top
  SideTitleWidget _getLeftTitles(double value, TitleMeta tm){
    
    const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14);
   
    String text;
    switch(value.toInt()){
      case 0: text = "£ 1K"; break;
      case 1: text = "£ 2K"; break;
      case 2: text = "£ 3K"; break;
      case 3: text = "£ 4K"; break;
      case 4: text = "£ 5K"; break;
      case 5: text = "£ 6K"; break;
      case 6: text = "£ 7K"; break;
      default: text = ""; break;
    }  

    return SideTitleWidget(meta: tm, space: 16, child: Text(text, style: style));
  }

///Creates a list of rods with order and value
  List<BarChartGroupData> showGroups() => List.generate(8, (i) {
    switch (i) {
      case 0: return makeGroupData(0, 2);
      case 1: return makeGroupData(1, 3);
      case 2: return makeGroupData(2, 2);
      case 3: return makeGroupData(3, 4.5);
      case 4: return makeGroupData(4, 3.8);
      case 5: return makeGroupData(5, 1.5);
      case 6: return makeGroupData(6, 4);
      case 7: return makeGroupData(7, 3.8);
      default: throw Error();
    }

  });

///Creates a bar/rod in the order based on an index (x) and filled to a value (y)
  BarChartGroupData makeGroupData(int x, double y) {
      return BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: y,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.tertiary,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.primary,
              ],
              transform: const GradientRotation(pi/40),
            ),
            width: 10, //rod width
            backDrawRodData: BackgroundBarChartRodData( //what's not filled by the value
              show: true,
              toY: 5,
              color: Colors.grey.shade300
            )
            
          )
        ]
      );
  }


}
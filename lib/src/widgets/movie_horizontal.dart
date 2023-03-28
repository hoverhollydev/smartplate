import 'package:flutter/material.dart';
import 'package:smartplate/src/models/placa_model.dart';

class MovieHorizontal extends StatelessWidget{

  final List<DatosPlaca> listaItems;

  MovieHorizontal({@required this.listaItems});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;// para saber el tamaño de la pantalla
    return Container(
      height: _screenSize.height*0.32,

      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          //keepPage: true,
          initialPage: 1,
          viewportFraction: 0.3 ,
        ),
        //children: _tarjetas(context),
        itemCount: listaItems.length,
        itemBuilder: (context, i)=> _tarjeta(context, listaItems[i]),
      ),
    );
  }

  Widget _tarjeta(BuildContext context, DatosPlaca datosPlaca){
    final _screenSize =MediaQuery.of(context).size;
    datosPlaca.uniqueId='${datosPlaca.placa}-poster';
    final tarjeta = Container(
      margin: EdgeInsets.only(right:15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //Hero(
            //tag: datosPlaca.uniqueId,
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage(
                image: NetworkImage(datosPlaca.getImgCarro()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fadeInDuration: Duration(milliseconds: 400),
                fit: BoxFit.cover,
                height: _screenSize.height*0.20,
              ),
            ),
          //),
          //SizedBox
          Padding(
            padding: EdgeInsets.only(top: 8.0),
          ),
          Text(
            datosPlaca.placa,
            overflow: TextOverflow.ellipsis,
            //style: Theme.of(context).textTheme.body1,
            textScaleFactor: 0.8,
            style: TextStyle(color: Colors.yellowAccent,
                fontWeight: FontWeight.bold),
          ),
          Text(
            new DateTime.fromMillisecondsSinceEpoch(datosPlaca.ts).toString(),
            //overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            //style: Theme.of(context).textTheme.caption,
            textScaleFactor: 0.56,
            style: TextStyle(color: Colors.yellowAccent,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: (){
        Navigator.pushNamed(context, 'detalle',arguments: datosPlaca);
        //print('ID de la Película ${pelicula.id}');
      },
    );
  }

  /*List<Widget> _tarjetas(BuildContext context){
    final _screenSize =MediaQuery.of(context).size;
    return listaItems.map((itemsPlaca){
      return Container(
        margin: EdgeInsets.only(right:15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(14.0),
              child: FadeInImage(
                image: NetworkImage(itemsPlaca.getImgPlaca()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fadeInDuration: Duration(milliseconds: 200),
                fit: BoxFit.cover,
                height: _screenSize.height*0.20,
              ),
            ),
            //SizedBox
            Text(
              itemsPlaca.placa,
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1.0,
              style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

    }).toList();
  }*/

}
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:smartplate/src/models/placa_model.dart';

class CardSwiper extends StatelessWidget{

  final List<DatosPlaca> listaItems;

  CardSwiper({@required this.listaItems});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final index=0;



    return Swiper(
          layout: SwiperLayout.STACK,
          itemWidth: _screenSize.width*0.65,
          itemHeight:_screenSize.height*0.35,
          itemBuilder: (BuildContext context,int index){
            listaItems[index].uniqueId='${listaItems[index].placa}-tarjeta';
            return //Hero(
              //tag: listaItems[index].uniqueId,
              Stack(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                   ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, 'detalle',arguments: listaItems[index] ),
                      child: FadeInImage(
                        image: NetworkImage(listaItems[index].getImgCarro()),
                        placeholder: AssetImage('assets/img/no-image.jpg'),
                        fadeInDuration: Duration(milliseconds: 400),
                        fit: BoxFit.cover,
                        height: _screenSize.height*0.55,
                        width: _screenSize.height*0.45,
                        ),
                      )
                    ),

                    Align(
                      alignment: Alignment.topLeft,
                      child:Wrap(
                          children: <Widget>[
                            new Container(
                              padding: new EdgeInsets.only(top:4.0, left:3.0, bottom: 3.0),
                              color: Colors.black26,
                              child: new Icon(
                                Icons.monochrome_photos,
                                size: 16.0,
                                color: Colors.greenAccent,
                              ),
                            ),
                            new Container(
                              padding: new EdgeInsets.only(top:4.0, left:3.0, bottom: 3.0, right: 3.0),
                              color: Colors.black26,
                              child: Text(
                                listaItems[index].placa,
                                overflow: TextOverflow.ellipsis,
                                //style: Theme.of(context).textTheme.body1,
                                //textScaleFactor: 1.2,
                                style: TextStyle(color: Colors.greenAccent,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],

                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: new Wrap(
                        children: <Widget>[
                          new Container(
                            color: Colors.black26,
                            padding: new EdgeInsets.only(bottom:4.0, right:3.0, top: 3, left: 3),
                            child: new Icon(
                              Icons.access_time,
                              size: 10.6,
                              color: Colors.greenAccent,
                            ),
                          ),
                          new Container(
                            color: Colors.black26,
                            padding: new EdgeInsets.only(bottom:4.0, right:5.0, top: 3),
                            child: Text(
                              new DateTime.fromMillisecondsSinceEpoch(listaItems[index].ts).toString(),
                              //overflow: TextOverflow.visible,
                              textAlign: TextAlign.center,
                              //style: Theme.of(context).textTheme.caption,
                              textScaleFactor: 0.68,
                              style: TextStyle(color: Colors.greenAccent,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
            );
            //);
          },
          itemCount: listaItems.length,
          //index: listaItems.length,
      //autoplay: false,
      /*pagination: new SwiperPagination(
          margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
          builder: new DotSwiperPaginationBuilder(
              color: Colors.white30,
              activeColor: Colors.white,
              size: 20.0,
              activeSize: 20.0)),*/

      pagination: new SwiperPagination(
          alignment: Alignment.topRight,
          margin: new EdgeInsets.only(right: 5.0),
          builder: new SwiperCustomPagination(builder:
              (BuildContext context, SwiperPluginConfig config) {
            return  new Container(
                  //color: Colors.white,
                  child: new Text(

                    "${config.activeIndex + 1}/${config.itemCount}",
                    style: new TextStyle(fontSize: 11.0, color: Colors.orangeAccent),
                  )
            );
          })),
      /*pagination: new SwiperPagination(
          alignment: Alignment.topRight,
          builder: SwiperPagination.fraction,),*/
      //scrollDirection: Axis.vertical,
      //pagination: new SwiperPagination(alignment: Alignment.bottomRight),
      //control: new SwiperControl(),
          autoplay: true,
          loop: false,
          //pagination: new SwiperPagination(),
          //control: new SwiperControl(),
          );

  }

}
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartplate/src/models/detalle_placa_model.dart';
import 'package:smartplate/src/models/placa_model.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:smartplate/src/providers/placas_provider.dart';

class PlacaDetalle extends StatefulWidget {

  //static List<DatosDetallePlaca> _placasDetalle = new List();
  static final _placasDetalleSteamController = StreamController<DatosDetallePlaca>.broadcast();
  static Function(DatosDetallePlaca) get placasDetalleSink => _placasDetalleSteamController.sink.add;
  static Stream <DatosDetallePlaca> get placasDetalleStream => _placasDetalleSteamController.stream;


  @override
  _PlacaDetalleState createState() => _PlacaDetalleState();

  static void recibirListaDetallePlaca(DatosDetallePlaca datosDetallePlaca){
    print('DETALLE length');
    print(datosDetallePlaca.propietario);


    placasDetalleSink(datosDetallePlaca);
    // _cargando=false;
    //}
    //return _placas;

  }
  dispose(){
    _placasDetalleSteamController?.close();
  }

}



class _PlacaDetalleState extends State<PlacaDetalle> {
  final MapController map= new MapController();

  String tipoMapa = 'outdoors';

  @override
  Widget build(BuildContext context) {
    final DatosPlaca datosPlaca= ModalRoute.of(context).settings.arguments;
    PlacasProvider.consultaDatosPlaca(datosPlaca.placa);
    print(DatosPlaca);

    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/bg_10.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            _crearAppbar(datosPlaca),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 2.0,),
                  _crearFlutterMap(context, datosPlaca),

                  _posterTitulo(context, datosPlaca),
                  /*SizedBox(height: 10.0,),
                  _posterTitulo(context, datosPlaca),
                  SizedBox(height: 10.0,),
                  _posterTitulo(context, datosPlaca),
                  SizedBox(height: 10.0,),
                  _posterTitulo(context, datosPlaca),
                  SizedBox(height: 10.0,),
                  _posterTitulo(context, datosPlaca),
                  SizedBox(height: 10.0,),
                  _posterTitulo(context, datosPlaca),
                  SizedBox(height: 10.0,),
                  _posterTitulo(context, datosPlaca),
                  SizedBox(height: 10.0,),
                  _posterTitulo(context, datosPlaca),
                  SizedBox(height: 10.0,),*/
                  /*_descripcion(datosPlaca),
                  _descripcion(datosPlaca),
                  _descripcion(datosPlaca),
                  _descripcion(datosPlaca),
                  _descripcion(datosPlaca),*/
                ]
              ),
            ),
          ],
        ),
      ),
      //floatingActionButton: _crearBotonFlotante(context),
      //floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _crearAppbar(DatosPlaca datosPlaca){
    return SliverAppBar(
      elevation: 10.0,
      backgroundColor: Colors.black,
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.my_location),
          onPressed: (){
          map.move(datosPlaca.getLatLng(), 15);
          }
        ),
        IconButton(
            icon: Icon(Icons.cached),
            onPressed: (){
              //streets, dark, light, outdoors, satellite
              if(tipoMapa=='streets'){
                tipoMapa='outdoors';
              } else if(tipoMapa=='outdoors'){
                tipoMapa='satellite';
              }else if(tipoMapa=='satellite'){
                tipoMapa='dark';
              }else if(tipoMapa=='dark'){
                tipoMapa='light';
              }else{
                tipoMapa='streets';
              }

              setState((){});
            }
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        /*centerTitle: true,
        title: Text(
          datosPlaca.placa,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),*/
        background: FadeInImage(
          image: NetworkImage(datosPlaca.getImgCarro()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 250),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, DatosPlaca datosPlaca){
    return Container(
      padding: EdgeInsets.only(left: 25.0, right: 8.0, top: 0.0),
      child: Column(

        children: <Widget>[
          Divider(),
          Row(
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.texture,
                            color: Colors.white70),
                        SizedBox(width: 18.0),
                        Text(
                          datosPlaca.placa,
                          textScaleFactor: 1.7,
                          style: TextStyle(color: Colors.greenAccent,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        )

                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.monochrome_photos,color: Colors.white70),
                        SizedBox(width: 16.0),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(28.0),

                          child: Image(
                            image: NetworkImage(datosPlaca.getImgPlaca()),
                            width: 180.0,
                            //height: 36,
                            fit: BoxFit.cover,
                            //height: 150.0,
                          ),
                        ),

                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                    ),

                    Row(
                      children: <Widget>[
                        Icon(Icons.location_on,color: Colors.white70),
                        SizedBox(width: 20.0),
                        Text(
                          datosPlaca.latitud.toString()+', '+datosPlaca.longitud.toString(),
                          textScaleFactor: 1.0,
                          style: TextStyle(color: Colors.green),
                          overflow: TextOverflow.ellipsis,
                        )

                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.format_indent_decrease,color: Colors.white70),
                        SizedBox(width: 20.0),
                        Text(
                          'ID Cam '+datosPlaca.idCamara,
                          textScaleFactor: 1.0,
                          style: TextStyle(color: Colors.green),
                          overflow: TextOverflow.ellipsis,
                        )

                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.videocam,color: Colors.white70),
                        SizedBox(width: 20.0),
                        Text(
                          datosPlaca.origin,
                          textScaleFactor: 1.0,
                          style: TextStyle(color: Colors.green,
                              ),
                          overflow: TextOverflow.ellipsis,
                        )

                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.border_horizontal,color: Colors.white70),
                        SizedBox(width: 20.0),
                        Text(
                          new DateTime.fromMillisecondsSinceEpoch(datosPlaca.ts).toString(),
                          textScaleFactor: 1.0,
                          style: TextStyle(color: Colors.green),
                          overflow: TextOverflow.ellipsis,
                        )

                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                    ),
                    StreamBuilder(
                      stream: PlacaDetalle.placasDetalleStream,
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        //if(snapshot.hasData && snapshot.data[0].propietario.toString().compareTo('')!=0) {
                        if(snapshot.hasData) {
                          //snapshot.data
                          if(snapshot.data.propietario.compareTo('')!=0) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.perm_identity,
                                          color: Colors.white70),
                                      SizedBox(width: 20.0),
                                      Text(
                                        snapshot.data.propietario,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(color: Colors.green),
                                        overflow: TextOverflow.ellipsis,
                                      )

                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.wb_iridescent,
                                          color: Colors.white70),
                                      SizedBox(width: 20.0),
                                      Text(
                                        snapshot.data.ced,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(color: Colors.green),
                                        overflow: TextOverflow.ellipsis,
                                      )

                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.directions_car,
                                          color: Colors.white70),
                                      SizedBox(width: 20.0),
                                      Text(
                                        snapshot.data.marca,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(color: Colors.green),
                                        overflow: TextOverflow.ellipsis,
                                      )

                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.calendar_view_day,
                                          color: Colors.white70),
                                      SizedBox(width: 20.0),
                                      Text(
                                        snapshot.data.modelo,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(color: Colors.green),
                                        overflow: TextOverflow.ellipsis,
                                      )

                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.invert_colors,
                                          color: Colors.white70),
                                      SizedBox(width: 20.0),
                                      Text(
                                        snapshot.data.color,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(color: Colors.green),
                                        overflow: TextOverflow.clip,
                                      )

                                    ],
                                  )
                                ]
                            );
                          } else {
                            return
                              Wrap(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          SizedBox(width: 45.0),
                                          Icon(Icons.error,
                                              color: Colors.red),
                                          SizedBox(width: 6.0),
                                          Text(
                                            'No se obtuvieron datos de propietario',
                                            textScaleFactor: 1.0,
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontFamily: 'MonteSerrat',color: Colors.redAccent),
                                            overflow: TextOverflow.clip,
                                          )

                                        ],
                                      ),
                                      RaisedButton(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                                          //IU93
                                          child: Text('Volver a intertarlo'),

                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        elevation: 0.0,
                                        color: Colors.deepPurple,
                                        textColor: Colors.white,
                                        onPressed:  ()=> PlacasProvider.consultaDatosPlaca(datosPlaca.placa),
                                      )
                                    ],
                                  )
                                ],
                              );
                          }
                        }else{
                          return
                            Container(
                              height: 50.0,
                              //alignment: AxisDirection.up,
                              child: Center(child: CircularProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                                    )
                                ),
                            );
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0),
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 25.0),
                        //_crearFlutterMap(context, datosPlaca),

                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          Divider(),
          Divider(),
          Divider(),
        ],
      ),
    );

  }

  /*Widget _descripcion(DatosPlaca datosPlaca){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        datosPlaca.ts.toString(),
        textAlign: TextAlign.justify,
      ),
    );
  }*/

  Widget _crearFlutterMap(BuildContext context, DatosPlaca scan){
    return  Container(
      height: 130.0,
      width: double.infinity,

      child: ClipRRect(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0.0), bottomRight: Radius.circular(35.0)),
        child: FlutterMap(
          mapController: map,
          options: MapOptions(
            center: scan.getLatLng(),
            zoom: 15.0,
          ),
          layers: [
            _crearMapa(),
            _crearMarcadores(scan),
          ],
        ),
      ),
    );

  }

  /*Widget _crearBotonFlotante(BuildContext context){
    return Container(
      height: 46,
      width: 46,
      child: FloatingActionButton(

        child: Icon(Icons.repeat),
        backgroundColor: Theme.of(context).primaryColor,

        onPressed: (){

          //streets, dark, light, outdoors, satellite
          if(tipoMapa=='streets'){
            tipoMapa='dark';
          } else if(tipoMapa=='dark'){
            tipoMapa='light';
          }else if(tipoMapa=='light'){
            tipoMapa='outdoors';
          }else if(tipoMapa=='outdoors'){
            tipoMapa='satellite';
          }else{
            tipoMapa='streets';
          }

          setState((){});
        },
      ),
    );
  }*/

  _crearMapa(){
    String token='pk.eyJ1IjoiaG92ZXJob2xseSIsImEiOiJjazU1bHlrNXcwdGhxM29tenhrb2FiaDF3In0.F_DPRX1CeD80ITfXDTnCWA';

    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
          '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken': token,
        'id': 'mapbox.$tipoMapa',
        //streets, dark, light, outdoors, satellite
      },
    );
  }

  _crearMarcadores(DatosPlaca scan){
    return MarkerLayerOptions(
      markers: [
        new Marker(
          width: 80.0,
          height: 80.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            //color: Colors.red,
            child: Icon(
              Icons.location_on,
              size: 45.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

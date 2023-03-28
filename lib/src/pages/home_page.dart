import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smartplate/src/models/placa_model.dart';
import 'package:smartplate/src/providers/placas_provider.dart';
import 'package:smartplate/src/search/search_delegate.dart';
import 'package:smartplate/src/widgets/card_swiper_widget.dart';
import 'package:smartplate/src/widgets/movie_horizontal.dart';

class HomePage extends StatefulWidget{
  static List<DatosPlaca> _placas = new List();
  static final _placasSteamController = StreamController<List<DatosPlaca>>.broadcast();
  static Function(List<DatosPlaca>) get placasSink => _placasSteamController.sink.add;
  static Stream <List<DatosPlaca>> get placasStream => _placasSteamController.stream;

  static List<String> _placasL = new List();
  static final _placasSteamControllerL =StreamController<List<String>>.broadcast();
  static Function(List<String>) get placasSinkL => _placasSteamControllerL.sink.add;
  static Stream <List<String>> get placasStreamL => _placasSteamControllerL.stream;

  //Lista placa pico y placa
  static List<DatosPlaca> _placasPP = new List();
  static final _placasSteamControllerPP =StreamController<List<DatosPlaca>>.broadcast();
  static Function(List<DatosPlaca>) get placasSinkPP => _placasSteamControllerPP.sink.add;
  static Stream <List<DatosPlaca>> get placasStreamPP => _placasSteamControllerPP.stream;

  dispose(){
    _placasSteamController?.close();
    _placasSteamControllerL?.close();
    _placasSteamControllerPP?.close();
  }


  static void recibirListaConsulta(List<DatosPlaca> resp){
    //_placas.addAll(resp);
    //placasSink(_placas);

    print(resp);

    //return resp;
  }




  static void recibirListaSuscripcion(List<DatosPlaca> datosPlaca){
    print('HOMEEEEE length');
    print(_placas.length);
    //if(_cargando){
      //placasSink([]);
    //}else{
     // _cargando=true;
      _placas.addAll(datosPlaca);
      placasSink(_placas);
      print(_placas.length);
     // _cargando=false;
    //}
    //return _placas;

  }

  //Pico y Placa
  static void recibirListaSuscripcionPP(List<DatosPlaca> datosPlaca){
    print('HOMEEEEE length');
    print(_placasPP.length);
    _placasPP.addAll(datosPlaca);
    placasSinkPP(_placasPP);
    print(_placasPP.length);
  }


  static void recibirListaPlacaSpinner(List<String> items){
    print('HOMEEEEE length');
    print(_placasL.length);
    //if(_cargando){
    //placasSink([]);
    //}else{
    // _cargando=true;
    _placasL.addAll(items);
    placasSinkL(_placasL);
    print(_placasL.length);
    // _cargando=false;
    //}
  }


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final placasProvider = new PlacasProvider();

  String _opcionSeleccionada = 'Todas';

  List<String> _listaPlacasSpinner = ['Todas'];

  void disposeStream(){
    HomePage._placasSteamController?.close();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Smartplate'),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(
                context: context,
                delegate: DataSearch(),
                //query: 'hola'
              );
            },
          )
        ],
      ),
      body:
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/bg_10.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _crearDropdown(),
            _swiperTarjetas(),//el que carga datos
            _footer(context, 'Pico y Placa ...'),
          ],
        ),
      ) ,

    );
  }

  Widget _swiperTarjetas(){

    return Container(
      width: double.infinity,
      child: /*Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 25.0) ,
              child: Row(
                children: <Widget>[
                  Icon(Icons.cached, color: Colors.white),
                  SizedBox(width: 10.0),
                  Text(
                    'Esperando Datos ...',
                    textScaleFactor: 1.1,
                    style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold),
                    //style: Theme.of(context).textTheme.subhead,

                  )

                ],
              )
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
          ),*/
        StreamBuilder(
          //stream: HomePage.placasStreamPP,
          stream: HomePage.placasStream,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot){
            if(snapshot.hasData) {
              return CardSwiper(listaItems: snapshot.data);
            }else{
              return Container(
                height: 200.0,
                child: Center(child: CircularProgressIndicator()
                ),
              );
            }
          },
        ),
      //]
    //),
    );

    //peliculasProvider.getEnCines();

//    return CardSwiper(
//      listaItems: [1,2,3,4,5],
//    );
  }

  Widget _footer(BuildContext context, String titulo){
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 15.0) ,
              child: Row(
                children: <Widget>[
                  Icon(Icons.cached, color: Colors.redAccent),
                  SizedBox(width: 10.0),
                  Text(
                    titulo,
                    textScaleFactor: 1.2,
                    style: TextStyle(color: Colors.yellowAccent,
                        fontWeight: FontWeight.w700),
                    //style: Theme.of(context).textTheme.subhead,

                  )

                ],
              )
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
          ),
          StreamBuilder(
            stream: HomePage.placasStreamPP,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot){
              if(snapshot.hasData) {
                return MovieHorizontal(
                    listaItems: snapshot.data);
              }else{
                return
                  Container(
                    height: 200.0,
                    /*child: Center(child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
                    )),*/
                );
              }
            },
          )
        ],
      ),
    );
  }

  /*Widget _crearInput(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            icon: Icon(Icons.videocam, color: Colors.deepPurple),
            labelText: 'Contraseña'
        ),
      ),

    );
  }*/

  List<DropdownMenuItem<String>> getOpcionesDropdown(){
    List<DropdownMenuItem<String>> lista = new List();

    _listaPlacasSpinner.forEach((valor){
      lista.add(DropdownMenuItem(
        child: Text(valor),
        value: valor,
      ));
    });

    return lista;
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown1(List<String> _listaPlacasSpi ){
    List<DropdownMenuItem<String>> lista = new List();

    _listaPlacasSpi.forEach((valor){
      lista.add(DropdownMenuItem(
        child: Text(valor),
        value: valor,
      ));
    });

    return lista;
  }

  /*Widget _holdingDropDown() {
    return StreamBuilder(
        stream: bloc.holding,
        builder: (BuildContext context, AsyncSnapshot<Holding> snapshot) {
          return Container(
            child: Center(
              child: snapshot.hasData
                  ? StreamBuilder(
                stream: bloc.obsHoldingList,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Holding>> holdingListSnapshot) {
                  return holdingListSnapshot.hasData ?
                  DropdownButton<Holding>(
                    value: snapshot.data,
                    items: _listDropDownHoldings,
                    onChanged: (Holding h) {
                      _changeDropDownItemHolding(h);
                    },
                  ): CircularProgressIndicator();
                },
              )
                  : CircularProgressIndicator(),
            ),
          );
        });
  }*/

  Widget _crearDropdown() {

    return Container(
      padding: EdgeInsets.only(left: 5.0, right: 25.0) ,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          /*Theme(
              data: new ThemeData(
                  canvasColor: Colors.green,
                  primaryColor: Colors.black,
                  accentColor: Colors.black,
                  hintColor: Colors.black),
              child: DropdownButton(
                icon: Icon(Icons.videocam,color: Colors.green),
                style: TextStyle(color: Colors.white,fontSize: 16),
                underline: Text(''),
                value: _opcionSeleccionada,

                iconSize: 40,
                items: getOpcionesDropdown(),
                onChanged: (opt) {
                  setState(() {
                    _opcionSeleccionada = opt;

                  });
                },

              )
          ),*/
          StreamBuilder(
            stream: HomePage.placasStreamL,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot){
              if(snapshot.hasData) {
                return Theme(
                    data: new ThemeData(
                        canvasColor: Colors.black54,
                        primaryColor: Colors.black,
                        accentColor: Colors.black,
                        hintColor: Colors.black),
                    child: DropdownButton<String>(
                      icon: Icon(Icons.videocam,color: Colors.redAccent),
                      style: TextStyle(color: Colors.white,fontSize: 14),
                      underline: Text(''),
                      value: _opcionSeleccionada,

                      iconSize: 45,
                      items:  getOpcionesDropdown1(snapshot.data),
                      onChanged: (opt) {
                        setState(() {
                          _opcionSeleccionada = opt;
                          PlacasProvider.suspcribe(_opcionSeleccionada);

                        });
                      },

                    )
                );

              }else{
                return
                  Container(
                    height: 200.0,
                    child: Center(child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
                    )),
                  );
              }
            },
          ),
          SizedBox(width: 12.0),
          //_crearBoton(),
        ],

      ),
    );
  }

  /*Widget _crearBoton(){
    return RaisedButton(
      child: Container(
        height: 45,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: Text('Enviar'),

      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0),
      ),
      elevation: 0.0,
      color: Colors.deepPurple,
      textColor: Colors.white,
      onPressed: (){
        PlacasProvider.suspcribe(_opcionSeleccionada);
        //PlacasProvider.listaCamaras();
        //_footer(context, 'Suscripción CAM 20303 ...');
      },
    );
  }*/
}
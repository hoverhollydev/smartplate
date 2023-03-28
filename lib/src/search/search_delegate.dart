import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smartplate/src/models/placa_model.dart';
import 'package:smartplate/src/providers/placas_provider.dart';

class DataSearch extends SearchDelegate<String> {


  static final _placasSteamController2 =StreamController<List<DatosPlaca>>.broadcast();
  static Function(List<DatosPlaca>) get placasSink2 => _placasSteamController2.sink.add;
  static Stream <List<DatosPlaca>>get placasStream2 => _placasSteamController2.stream;


  dispose(){
    _placasSteamController2?.close();
  }


  String seleccion='';

  final placasProvider =  new PlacasProvider();

  final placasRecientes=[
    'GSD1157',
    'GBO3450',
    'GSH5084',
    'GSR7600',
  ];

  DataSearch({
    String hintText = "Buscar min 4 caracteres",
  }) : super(
    searchFieldLabel: hintText,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.search,
  );

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar iconito de limpiar
    return  [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query='';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return
      IconButton(
        icon: AnimatedIcon(
          icon:AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: (){
         close(context, null);
        },
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados que vamos a mostrar
    if(query.isEmpty || query.length<4){
      return Container();

      /*ListView.builder(
          itemCount: placasRecientes.length,
          itemBuilder: (context, i){
            return ListTile(
              leading: Icon(Icons.movie),
              title: Text(placasRecientes[i]),
              onTap: (){
                seleccion=placasRecientes[i];
                //_listaPlacasStream(seleccion);
              },
            );
          }
      );*/
    }



    PlacasProvider.buscarPorCamara(query);
    return StreamBuilder(
      stream: placasStream2,
      builder: (BuildContext context, AsyncSnapshot<List<DatosPlaca>> snapshot){
        if(snapshot.hasData) {
          final placas = snapshot.data;
          return ListView(
              children: placas.map((placas){
                return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(placas.getImgCarro()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 50.0,
                    fadeInDuration: Duration(milliseconds: 400),
                    fit: BoxFit.contain,
                  ),
                  title: Text(placas.placa),
                  subtitle: Text(new DateTime.fromMillisecondsSinceEpoch(placas.ts).toString()),
                  onTap: (){
                    close(context, null);
                    placas.uniqueId='';
                    Navigator.pushNamed(context, 'detalle', arguments: placas);
                  },
                );
              }).toList()
          );
        }else{
          return Center(
              child: CircularProgressIndicator()
          );
        }
      },
    );

  }

  @override
  Widget buildSuggestions(BuildContext context) {

    // son las sugerencias cuando que aparecen cuando las personas escriben
    /*final listaSugerida = (query.isEmpty)
                          ? placasRecientes
                          : .where(
                            (p)=> p.toLowerCase().startsWith(query.toLowerCase())
                          ).toList();*/

    if(query.isEmpty|| query.length<4){
      return Container();

      /*ListView.builder(
          itemCount: placasRecientes.length,
          itemBuilder: (context, i){
            return ListTile(
              leading: Icon(Icons.movie),
              title: Text(placasRecientes[i]),
              onTap: (){
                seleccion=placasRecientes[i];
                //_listaPlacasStream(seleccion);
              },
            );
          }
      );*/
    }


    PlacasProvider.buscarPorPlaca(query);
    return StreamBuilder(
      stream: placasStream2,
      builder: (BuildContext context, AsyncSnapshot<List<DatosPlaca>> snapshot){
        if(snapshot.hasData) {
          final placas = snapshot.data;
          return ListView(
              children: placas.map((placas){
                return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(placas.getImgCarro()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 50.0,
                    fadeInDuration: Duration(milliseconds: 200),
                    fit: BoxFit.contain,
                  ),
                  title: Text(placas.placa),
                  subtitle: Text(new DateTime.fromMillisecondsSinceEpoch(placas.ts).toString()),
                  onTap: (){
                    PlacasProvider.consultaDatosPlaca(placas.placa);
                    close(context, null);
                    placas.uniqueId='';
                    Navigator.pushNamed(context, 'detalle', arguments: placas);
                  },
                );
              }).toList()
          );
        }else{
          return Center(
              child: CircularProgressIndicator()
          );
        }
      },
    );






    // son las sugerencias cuando que aparecen cuando las personas escriben
    /*final listaSugerida = (query.isEmpty)
                          ? peliculaRecientes
                          : peliculas.where(
                            (p)=> p.toLowerCase().startsWith(query.toLowerCase())
                          ).toList();



    return ListView.builder(
        itemCount: listaSugerida.length,
        itemBuilder: (context, i){
          return ListTile(
            leading: Icon(Icons.movie),
            title: Text(listaSugerida[i]),
            onTap: (){
              seleccion=listaSugerida[i];
              showResults(context);
            },
          );
        }
    );*/
  }


  /*Widget _listaPlacasStream(String criterio){
    PlacasProvider.buscarPorPlaca(criterio);
    return StreamBuilder(
      stream: placasStream2,
      builder: (BuildContext context, AsyncSnapshot<List<DatosPlaca>> snapshot){
        if(snapshot.hasData) {
          final placas = snapshot.data;
          return ListView(
              children: placas.map((placas){
                return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(placas.getImgCarro()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 50.0,
                    fit: BoxFit.contain,
                  ),
                  title: Text(placas.placa),
                  subtitle: Text(placas.latitud.toString()+', '+placas.longitud.toString()),
                  onTap: (){
                    close(context, null);
                    placas.uniqueId='';
                    Navigator.pushNamed(context, 'detalle', arguments: placas);
                  },
                );
              }).toList()
          );
        }else{
          return Center(
              child: CircularProgressIndicator()
          );
        }
      },
    );
  }*/

  static void recibirListaConsulta(List<DatosPlaca> resp){
    //_placas.addAll(resp);
    //placasSink(_placas);


    print('BUSQUEDAD length');
    placasSink2(resp);
    print(resp.length);

    //return resp;
  }
}

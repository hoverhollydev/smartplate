
import 'dart:convert';

import 'package:smartplate/src/models/detalle_placa_model.dart';
import 'package:smartplate/src/models/placa_model.dart';
import 'package:web_socket_channel/io.dart';

class PlacasProvider{

  //Conexion Websocket
  static String _url='ws://157.230.92.7:5000/graphql';
  static Iterable<String> _protocols= <String>['graphql-ws'];
  static IOWebSocketChannel _channel ;

  //final int cont_sus=0;

  static bool _cargando= true;

  //static Map<String, dynamic> _headers = {};
  //static Duration _duration = new Duration(milliseconds: 800);




  PlacasProvider() {

    //if(_channel.stream.isBroadcast==false) {

    //}

    /*Los tres nuevos tienen en la respuesta (si lo pides) datos adicionales por los webservices:
    color: String
    propietario: String
    marca: String
    modelo: String
    ced: String*/


    if(_cargando) {
      _channel = IOWebSocketChannel.connect(_url, protocols: _protocols);
      print( _channel.toString());
      _channel.sink.add(
          '{"type":"connection_init","payload":{"usuario":"prueba1", "password":"prueba1"}}');
      //_channel.sink.add('{"type":"start","id":"subscripcion","payload":{"query":"subscription{capturaPlacaConImagenesAgregado{ts, placa, id_camara, imagenPlaca, imagenCarro, velocidad, latitud, longitud, origin}}"}}');
      //_channel.sink.add('{"type":"start","id":"subscripcion","payload":{"query":"subscription{capturaPlacaConImagenesAgregado{ts, placa, id_camara, velocidad, latitud, longitud, origin}}"}}');
      //_channel.sink.add('{"type":"start","id":"subscripcion","payload":{"query":"subscription{capturaPlacaAgregadoYcarro{ts, placa, id_camara, imagenPlacaUrl, imagenCarroUrl, velocidad, latitud, longitud, origin}}"}}');

      suspcribe('Todas');

      suspcribePicoPlaca('FIJA - Lpr Camera');
      /*String idCam='20303';
      _channel.sink.add('{"type":"start","id":"subscripcion","payload":{"query":"subscription{capturaPlacaAgregadoIdCamaraYcarro(id_camara:\\"$idCam\\"){ts, placa, id_camara, imagenPlaca, imagenCarro, velocidad, latitud, longitud, origin}}"}}');*/

      listaCamaras();


      //recibe mensajes
      _channel.stream.listen((message) {
        final decodedData = json.decode(message);
        print('Server $decodedData');

        String id = decodedData['id'];
        String tipo = decodedData['type'];




        switch (id) {
          case 'consulta':
            {
              if (tipo == 'data') {

                print('TIPO -->: $id $tipo');
                //String tipo2 = decodedData['type'];

                List jsonPlacaList= ((decodedData['payload'])['data'])['obtenerCapturasPlacasYcarro'];
                print(jsonPlacaList);

                new PlacaModel.fromJsonList(jsonPlacaList);

              }
            }
            break;
          case 'subscripcion':
            {
              if (tipo == 'data') {
                print('TIPO -->: $id $tipo');
                Map jsonPlacaOject= ((decodedData['payload'])['data'])['capturaPlacaAgregado'];
                new PlacaModel.fromJsonObject(jsonPlacaOject);
              }
            }
            break;

          case 'subscripcionmultas':
            {
              if (tipo == 'data') {
                print('TIPO -->: $id $tipo');
                Map jsonPlacaOject= ((decodedData['payload'])['data'])['multaPlacaAgregado'];
                new PlacaModel.fromJsonObjectPicoPlaca(jsonPlacaOject);
              }
            }
            break;

          case 'consultaCam':
            if (tipo == 'data') {

              print('TIPO -->: $id $tipo');
              //String tipo2 = decodedData['type'];

              List jsonPlacaListSpinner= ((decodedData['payload'])['data'])['obtenerCamarasCapturaPlaca'];
              print(jsonPlacaListSpinner);


              if(jsonPlacaListSpinner!=null){
                new PlacaModel.fromJsonListSpinner(jsonPlacaListSpinner);
              }

            }
            break;

          case 'consultaPlacaCam':
            {
              if (tipo == 'data') {

                print('TIPO -->: $id $tipo');
                //String tipo2 = decodedData['type'];

                List jsonPlacaList= ((decodedData['payload'])['data'])['obtenerCapturasPlacas'];
                print(jsonPlacaList);

                new PlacaModel.fromJsonList(jsonPlacaList);

              }
            }
            break;
          case 'consultaPlaca':
            {
              if (tipo == 'data') {

                print('TIPO -->: $id $tipo');
                //String tipo2 = decodedData['type'];

                List jsonPlacaList= ((decodedData['payload'])['data'])['obtenerCapturasPlacas'];
                print(jsonPlacaList);

                new PlacaModel.fromJsonList(jsonPlacaList);

              }
            }
            break;
          case 'consultaDatosPlaca':

            //print('DATA $decodedData');
            {
              if (tipo == 'data') {

                print('TIPO -->: $id $tipo');
                //String tipo2 = decodedData['type'];

                Map<String, dynamic> jsonDatosPlaca= ((decodedData['payload'])['data'])['obtenerCarro'];
                //print(jsonDatosPlaca);

                new PlacaDetalleModel.fromJsonObject(jsonDatosPlaca);

              }
            }
            break;
          default:
            {

            }
        }
      });

      _cargando=false;
    }

  }



  static void buscarPorPlaca(String query) {
    _channel.sink.add('{"type":"start","id":"consultaPlaca","payload":{"query":"query{obtenerCapturasPlacas(placas:[\\"$query\\"]){ts, placa, id_camara, imagenPlacaUrl, imagenCarroUrl, velocidad, latitud, longitud, origin}}"}}');
    //List jsonPlacaList= ((decodedData['payload'])['data'])['obtenerCapturasPlacasYcarro'];

  }

  static void consultaDatosPlaca(String query) {
    _channel.sink.add('{"type":"start","id":"consultaDatosPlaca","payload":{"query":"query{obtenerCarro(placa:\\"$query\\"){color, propietario, marca, modelo, ced}}"}}');
    //List jsonPlacaList= ((decodedData['payload'])['data'])['obtenerCapturasPlacasYcarro'];

  }

  static void buscarPorPlacaTodosLatLon(String query) {
    _channel.sink.add('{"type":"start","id":"consultaPlacaLanLon","payload":{"query":"query{obtenerCapturasPlacas(placas:[\\"$query\\"]){ts, placa, id_camara,latitud, longitud}}"}}');
    //List jsonPlacaList= ((decodedData['payload'])['data'])['obtenerCapturasPlacasYcarro'];

  }

  static void buscarPorCamara(String query) {
    _channel.sink.add('{"type":"start","id":"consultaPlacaCam","payload":{"query":"query{obtenerCapturasPlacas(ids_camaras:[\\"$query\\"]){ts, placa, id_camara, imagenPlacaUrl, imagenCarroUrl, velocidad, latitud, longitud, origin}}"}}');
    //List jsonPlacaList= ((decodedData['payload'])['data'])['obtenerCapturasPlacasYcarro'];

  }

  static void listaCamaras() {
    _channel.sink.add('{"type":"start","id":"consultaCam","payload":{"query":"query{obtenerCamarasCapturaPlaca{id_camara, nombre, comentario}}"}}');
    //List jsonPlacaList= ((decodedData['payload'])['data'])['obtenerCapturasPlacasYcarro'];

  }

  static void suspcribe(String idCam) {
    _channel.sink.add('{"type":"stop","id":"subscripcion"}');

    if(idCam.compareTo('Todas')!=0) {
      idCam=idCam.split('/')[0];
      print('Suscribe '+idCam);
      _channel.sink.add('{"type":"start","id":"subscripcion","payload":{"query":"subscription{capturaPlacaAgregado(id_camara:\\"$idCam\\"){ts, placa, id_camara, imagenPlaca, imagenCarro, velocidad, latitud, longitud, origin}}"}}');
      //_channel.sink.add('{"type":"start","id":"subscripcion","payload":{"query":"subscription{capturaPlacaAgregadoIdCamaraYcarro(id_camara:\\"$idCam\\"){ts, placa, id_camara, imagenPlaca, imagenCarro, velocidad, latitud, longitud, origin, propietario, color, marca, modelo, ced}}"}}');
      //_channel.sink.add('{"type":"start","id":"subscripcion","payload":{"query":"subscription{capturaPlacaAgregadoYcarro(id_camara:\\"$idCam\\"){ts, placa, id_camara, imagenPlacaUrl, imagenCarroUrl, velocidad, latitud, longitud, origin, propietario, color, marca, modelo, ced}}"}}');

    }else{
      _channel.sink.add('{"type":"start","id":"subscripcion","payload":{"query":"subscription{capturaPlacaAgregado{ts, placa, id_camara, imagenPlacaUrl, imagenCarroUrl, velocidad, latitud, longitud, origin}}"}}');
      //_channel.sink.add('{"type":"start","id":"subscripcion","payload":{"query":"subscription{capturaPlacaAgregadoYcarro{ts, placa, id_camara, imagenPlacaUrl, imagenCarroUrl, velocidad, latitud, longitud, origin, propietario, color, marca, modelo, ced}}"}}');

      print('Suscribe '+idCam);
    }
  }

  static void suspcribePicoPlaca(String idCam) {
    _channel.sink.add('{"type":"stop","id":"subscripcionmultas"}');
    //_channel.sink.add('{"type":"start","id":"subscripcionmultas","payload":{"query":"subscription{multaPlacaAgregado(id_camara:\\"$idCam\\"){ts, placa, id_camara, imagenPlacaUrl, imagenCarroUrl, velocidad, latitud, longitud, origin, propietario, color, marca, modelo, ced}}"}}');

    _channel.sink.add('{"type":"start","id":"subscripcionmultas","payload":{"query":"subscription{multaPlacaAgregado(id_camara:\\"$idCam\\"){ts, placa, id_camara, imagenPlacaUrl, imagenCarroUrl, latitud, longitud, origin}}"}}');
    print('subscripcionmultas '+idCam);
  }

}

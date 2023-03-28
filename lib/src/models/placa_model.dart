
import 'package:smartplate/src/pages/home_page.dart';
import 'package:smartplate/src/search/search_delegate.dart';
import 'package:latlong/latlong.dart';

class PlacaModel {

  PlacaModel();


  PlacaModel.fromJsonList( List<dynamic> jsonList  ) {
    print('ListplacasCON');
    List<DatosPlaca> items = new List();

    if (jsonList == null) return;

    for (var item in jsonList) {
      final datosPlaca = new DatosPlaca.fromJsonMap(item);
      print(datosPlaca);
      items.add(datosPlaca);
    }
    //print(items[0].idCamara);
    DataSearch.recibirListaConsulta(items);

  }

  int contador=0;
  PlacaModel.fromJsonObject( Map<String, dynamic> jsonItems  ) {
    List<DatosPlaca> items = new List();
    final datosPlaca = new DatosPlaca.fromJsonMap(jsonItems);
    items.add(datosPlaca);
    print('MODEEL');

    print(contador);
    contador++;
    HomePage.recibirListaSuscripcion(items);
  }

  PlacaModel.fromJsonObjectPicoPlaca( Map<String, dynamic> jsonItems  ) {
    List<DatosPlaca> items = new List();
    final datosPlaca = new DatosPlaca.fromJsonMap(jsonItems);
    items.add(datosPlaca);
    print('MODEEL PICO PLACA');
    HomePage.recibirListaSuscripcionPP(items);
  }


  PlacaModel.fromJsonListSpinner( List<dynamic> jsonList  ) {
    print('ListplacasSPINNER');
    List<String> items = new List();
    items.add('Todas');

    if (jsonList == null) return;

    for (var item in jsonList) {
      Map<String, dynamic> json =  item;
      String idCamara=  json['id_camara'];
      String nombre=  json['nombre'];
      String comentario=  json['comentario'];
      print(idCamara+' '+nombre+' '+comentario);
      items.add(idCamara + '/ '+nombre);
    }
    //print(items[0].idCamara);
    //DataSearch.recibirListaConsulta(items);

    HomePage.recibirListaPlacaSpinner(items);

  }


}



class DatosPlaca{
  String uniqueId;
  String placa;
  String imagenPlaca;
  String imagenCarro;
  String origin;
  num latitud;
  num longitud;
  num velocidad=0;
  num ts;
  String idCamara;
  /*String propietario =' ';
  String color =' ';
  String marca =' ';
  String modelo =' ';
  String ced =' ';*/

  DatosPlaca({
    this.placa,
    this.imagenPlaca,
    this.imagenCarro,
    this.origin,
    this.latitud,
    this.longitud,
    this.velocidad,
    this.ts,
    this.idCamara,
    /*this.propietario,
    this.color,
    this.marca,
    this.modelo,
    this.ced*/});

  DatosPlaca.fromJsonMap(Map<String, dynamic> json) {
    this.placa = json['placa'];
    this.imagenPlaca = json['imagenPlacaUrl'];
    this.imagenCarro = json['imagenCarroUrl'];
    this.origin = json['origin'];
    this.latitud = json['latitud'];
    this.longitud = json['longitud'];
    if(json.containsKey('velocidad')) {
      this.velocidad = json['velocidad'];
    }
    this.ts = json['ts'];
    this.idCamara = json['id_camara'];
    /*if(json.containsKey('propietario')) {
      this.propietario = json['propietario'];
      this.color = json['color'];
      this.marca = json['marca'];
      this.modelo = json['modelo'];
      this.ced = json['ced'];
    }*/
  }

  getImgPlaca(){
    if(imagenPlaca==null) {
      return 'http://www.puntodipcuenca.es/img/nodisponible.png';
    }else{
      //imagenPlaca='https://s3.amazonaws.com/elperiodico.com.gt/wp-content/uploads/2019/08/01170428/WhatsApp-Image-2019-08-01-at-5.02.58-PM-1-1024x682.jpeg';
      return '$imagenPlaca';
    }
  }

  getImgCarro(){
    if(imagenCarro==null) {
      return 'http://www.puntodipcuenca.es/img/nodisponible.png';
    }else{
       //imagenCarro='https://ecuadorendirecto.com/wp-content/uploads/2019/10/jjjjjj.jpg';

      return '$imagenCarro';
    }
  }

  LatLng getLatLng(){



    if(latitud==0 || longitud==0){
      latitud=-2.2170106;
      longitud=-79.8895217;
    }

    print(latitud);
    print(longitud);

    //final lat = double.parse(latitud);
    //final lng = double.parse(longitud);
    return LatLng(this.latitud, this.longitud);
  }

}

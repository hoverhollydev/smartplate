import 'package:smartplate/src/pages/placa_detalle.dart';

class PlacaDetalleModel {

  PlacaDetalleModel();



  //int contador=0;
  PlacaDetalleModel.fromJsonObject( Map<String, dynamic> jsonItems  ) {

    //List<DatosDetallePlaca> items = new List();
    final datosDetallePlaca = new DatosDetallePlaca.fromJsonMap(jsonItems);
    //items.add(datosDetallePlaca);
    print('MODEEL DETALLE');

    PlacaDetalle.recibirListaDetallePlaca(datosDetallePlaca);
  }





}




class DatosDetallePlaca{
  String propietario ='XXXXXX';
  String color ='XXXXXX';
  String marca ='XXXXXX';
  String modelo ='XXXXXX';
  String ced ='XXXXXX';

  DatosDetallePlaca({
    this.propietario,
    this.color,
    this.marca,
    this.modelo,
    this.ced});

  DatosDetallePlaca.fromJsonMap(Map<String, dynamic> json) {
    if(json.containsKey('propietario')) {
      this.propietario = json['propietario'];
      this.color = json['color'];
      this.marca = json['marca'];
      this.modelo = json['modelo'];
      this.ced = json['ced'];
    }
  }
  
}

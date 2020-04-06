
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:form_validation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;



import 'package:form_validation/src/models/producto_model.dart';


class ProductosProvider {
  
  

  final String _url = 'https://flutter-console.firebaseio.com';
  final _prefs = new PreferenciasUsuario();

  Future<bool> crearProducto(ProductoModel producto)async{

    final url = '$_url/productos.json?auth=${_prefs.token}';

    final resp = await http.post(url, body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<bool> editarProducto(ProductoModel producto)async{

    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';

    final resp = await http.put(url, body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<List<ProductoModel>> cargarPoductos() async{

    final url = '$_url/productos.json?auth=${_prefs.token}';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductoModel> productos = new List();

    if(decodedData == null ) return [];

    if(decodedData['error'] != null) return [];

    decodedData.forEach((id, productosCreados){

      final prodTemp = ProductoModel.fromJson(productosCreados);
      prodTemp.id = id;

      productos.add(prodTemp);

    });

    print(productos);

    return productos;

  }

  Future<int> borrarProducto(String id)async{

    final url = '$_url/productos/$id.json?auth=${_prefs.token}';
    final resp = await http.delete(url);

    print(json.decode(resp.body));

    return 1;
  }

  Future subirImagen(File image, String path) async{
      
       FirebaseStorage _storage = FirebaseStorage.instance;
       StorageReference firebaseStorageRef = _storage.ref().child(path);

       StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);


       final StorageTaskSnapshot downloadUrl= await uploadTask.onComplete;
       final String url = await downloadUrl.ref.getDownloadURL();

       print('Url Is $url');
       return url;
       
    }

  //Future<String> subirImagen( File imagen ) async {

  //  final url = Uri.parse('https://api.cloudinary.com/v1_1/drixpz4yf/image/upload?upload_preset=dvyv6kf2');
  //  final mimeType = mime(imagen.path).split('/'); //image/jpeg

  //  final imageUploadRequest = http.MultipartRequest(
  //    'POST',
 //     url
  //  );

  //  final file = await http.MultipartFile.fromPath(
  //    'file', 
  //    imagen.path,
  //    contentType: MediaType( mimeType[0], mimeType[1] )
  //  );

  //  imageUploadRequest.files.add(file);


  //  final streamResponse = await imageUploadRequest.send();
  //  final resp = await http.Response.fromStream(streamResponse);

  //  if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
  //    print('Algo salio mal');
  //    print( resp.body );
  //    return null;
  //  }
  //  final respData = json.decode(resp.body);
  //  print( respData);

  //  return respData['secure_url'];
  //}
  
}
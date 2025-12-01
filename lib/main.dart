import 'package:flutter/material.dart';
import 'dart:convert'; // Para convertir el JSON
import 'package:http/http.dart' as http; // Para conectar a internet

void main() {
  runApp(UrlHausApp());
}

class UrlHausApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'URLHaus Monitor',
      // TEMA: Estilo Ciberseguridad (Oscuro y Rojo)
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.redAccent,
        scaffoldBackgroundColor: Color(0xFF1E1E1E), // Gris muy oscuro
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF2C2C2C),
          elevation: 0,
        ),
        cardColor: Color(0xFF2C2C2C),
        colorScheme: ColorScheme.dark().copyWith(
          primary: Colors.redAccent,
          secondary: Colors.red,
        ),
      ),
      home: MaliciousUrlsScreen(),
    );
  }
}

class MaliciousUrlsScreen extends StatefulWidget {
  @override
  _MaliciousUrlsScreenState createState() => _MaliciousUrlsScreenState();
}

class _MaliciousUrlsScreenState extends State<MaliciousUrlsScreen> {
  List<dynamic> _urls = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchRecentThreats();
  }

  // Función para obtener las amenazas recientes
  Future<void> fetchRecentThreats() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final url = Uri.parse('https://urlhaus-api.abuse.ch/v1/urls/recent/');
      
      // AQUI AGREGAMOS TU CLAVE EN LOS HEADERS
      final response = await http.get(
        url,
        headers: {
          'Auth-Key': '56897f82ee168111a2f8a637a09e57595a7b9653d6f4de4c', 
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Si la respuesta es exitosa
        if (data['query_status'] == 'ok' && data['urls'] != null) {
          setState(() {
            _urls = data['urls'].take(50).toList(); 
            _isLoading = false;
          });
        } else {
           // A veces devuelve 200 pero con status "no_results"
           throw Exception('No se encontraron resultados o la API cambió.');
        }
        
      } else {
        // Si falla la autenticación (401) u otro error
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error de conexión.\n\nNota: Si estás en Chrome, es probable que sea un error de CORS (Bloqueo del navegador). Intenta correr esto en Android/iOS.';
        _isLoading = false;
      });
      print("ERROR DETALLADO: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.security, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('Monitor de Amenazas', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchRecentThreats,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.redAccent),
                  SizedBox(height: 20),
                  Text("Autenticando y escaneando...", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(_errorMessage, textAlign: TextAlign.center, style: TextStyle(color: Colors.redAccent)),
                  )
                )
              : ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: _urls.length,
                  itemBuilder: (context, index) {
                    final alert = _urls[index];
                    return _buildThreatCard(alert);
                  },
                ),
    );
  }

  Widget _buildThreatCard(Map<String, dynamic> alert) {
    // Extraer datos con seguridad (si vienen nulos)
    String url = alert['url'] ?? 'Desconocida';
    String status = alert['url_status'] ?? 'unknown';
    String threat = alert['threat'] ?? 'malware';
    String date = alert['date_added'] ?? '';
    List<dynamic> tags = alert['tags'] ?? [];

    // Color según estado (online = peligro activo)
    Color statusColor = status == 'online' ? Colors.redAccent : Colors.grey;
    IconData statusIcon = status == 'online' ? Icons.warning_amber_rounded : Icons.cloud_off;

    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera: Estado y Tipo de Amenaza
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: statusColor),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 16),
                      SizedBox(width: 5),
                      Text(status.toUpperCase(), 
                           style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
                Flexible(
                  child: Text(
                    threat.toUpperCase(),
                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            
            // La URL Maliciosa
            Text(
              "URL DETECTADA:",
              style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1.5),
            ),
            SizedBox(height: 2),
            SelectableText( 
              url,
              style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Courier'),
            ),
            
            SizedBox(height: 15),
            Divider(color: Colors.grey[800]),
            
            // Footer: Fecha y Tags
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey),
                SizedBox(width: 5),
                Text(date.split(" ")[0], style: TextStyle(color: Colors.grey, fontSize: 12)), // Solo fecha
                Spacer(),
                // Tags
                if (tags.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Chip(
                      label: Text(tags.first.toString(), style: TextStyle(fontSize: 10)),
                      backgroundColor: Colors.blueGrey[900],
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
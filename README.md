# 🛡️ URLHaus Threat Monitor

Una aplicación de monitoreo de ciberseguridad desarrollada en **Flutter**.  
Esta herramienta se conecta en tiempo real a la base de datos de **URLHaus (Abuse.ch)** para listar las amenazas de malware y sitios maliciosos detectados recientemente alrededor del mundo.

---

## 📱 Capturas de Pantalla

**Lista de Amenazas (Dark Mode)**  
`./screenshots/threat_list.png`

**Detalle de Alerta**  
`./screenshots/threat_detail.png`

> *(Nota: Reemplaza estas rutas con tus capturas reales)*

---

## ✨ Características Principales

- **Monitoreo en Tiempo Real:**  
  Consume el endpoint de "URLs Recientes" para mostrar las últimas amenazas detectadas.

- **Interfaz "Cybersec":**  
  Diseño en **Dark Mode** con paleta de colores de alto contraste (Gris Oscuro/Rojo) para simular una consola de seguridad.

- **Indicadores de Estado:**  
  - 🔴 **ONLINE:** El sitio es peligroso y está activo actualmente.  
  - ☁️ **OFFLINE:** El sitio ha sido dado de baja.

- **Detalle Técnico:**  
  Muestra el tipo de amenaza (ej: `malware_download`), la fecha de detección y tags específicos del virus (ej: `elf`, `botnet`, `emotet`).

- **Seguridad de Usuario:**  
  Las URLs se muestran como `SelectableText` pero **no son clicables accidentalmente** para evitar visitas no deseadas.

---

## 🛠️ Tecnologías Utilizadas

- **Framework:** Flutter (Dart)  
- **Cliente HTTP:** package:http  
- **API:** URLHaus API v1  
- **Seguridad:** Autenticación vía API Key Headers  

---

## ⚙️ Configuración y Ejecución

Para correr este proyecto, necesitas una clave de API (**Auth-Key**) de Abuse.ch.

### 1️⃣ Clonar el repositorio
```bash
git clone https://github.com/TU_USUARIO/urlhaus_monitor.git
cd urlhaus_monitor
```
2️⃣ Instalar dependencias
flutter pub get

3️⃣ Configurar API Key

El proyecto requiere una Auth-Key válida en los headers de la petición HTTP.

headers: { 'Auth-Key': 'TU_CLAVE_AQUI' }


(Por seguridad, se recomienda usar variables de entorno, aunque para fines educativos la clave puede estar en el código fuente.)

4️⃣ Ejecutar la aplicación

Se recomienda usar un Emulador o Dispositivo Físico (Android/iOS) para evitar bloqueos CORS de navegadores web.

flutter run

📂 Estructura y Lógica del Código

El núcleo de la aplicación se encuentra en lib/main.dart:

Autenticación (Headers)

Inyecta la credencial en la cabecera de la petición HTTP:

headers: { 'Auth-Key': 'TU_CLAVE_AQUI' }

Consumo de Datos (fetchRecentThreats)

Realiza una petición GET asíncrona a:
https://urlhaus-api.abuse.ch/v1/urls/recent/

Procesa la respuesta JSON y extrae una lista de mapas con la información de cada amenaza.

Renderizado de Tarjetas (_buildThreatCard)

Cada amenaza se convierte en una tarjeta visual (Card).

Evalúa dinámicamente el estado:

Si url_status == 'online', colorea los bordes e iconos en rojo.

Extrae y mapea los tags para generar Chips visuales.

⚠️ Disclaimer (Aviso de Seguridad)

Esta aplicación es solo para visualización y educación.

Las URLs mostradas en la pantalla son enlaces reales a sitios maliciosos.

NO visites las URLs mostradas en la aplicación.

El desarrollador no se hace responsable por el mal uso de la información presentada.

✒️ Autor
Christian Márquez

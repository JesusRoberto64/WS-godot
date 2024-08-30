# WS-godot

## Descripción

**WS-godot** es una solución backend diseñada para videojuegos que requieren chatrooms antes de las partidas o que incluyen mecánicas de turnos. Este backend, desarrollado en **Node.js**, utiliza la librería **WebSocket** para gestionar la comunicación en tiempo real, y se integra de manera eficiente con el motor **GODOT** en el cliente.

## Características

- **Chatrooms en Tiempo Real**: Facilita la creación de salas de chat previas a las partidas, permitiendo a los jugadores interactuar y coordinarse antes de iniciar el juego.
- **Soporte para Juegos por Turnos**: Optimizado para manejar las mecánicas de juego por turnos, asegurando que la sincronización entre los jugadores sea fluida y precisa.
- **Integración con GODOT**: Diseñado específicamente para integrarse sin problemas con proyectos de GODOT, utilizando WebSocket para una comunicación rápida y eficiente.

## Tecnologías Utilizadas

- **Node.js**: Plataforma de desarrollo para la creación del servidor backend.
- **WebSocket**: Librería para la comunicación en tiempo real entre el servidor y los clientes.
- **GODOT**: Motor de desarrollo de juegos utilizado en la parte cliente para implementar la lógica y las interfaces de usuario.

## Instalación Server en Node

1. Clona este repositorio en tu máquina local:

   ```bash
   git clone https://github.com/tu-usuario/WS-godot.git
   ```

2. Navega al directorio del proyecto:

   ```bash
   cd WS-godot
   ```

3. Instala las dependencias necesarias:

   ```bash
   npm install
   ```

## Uso

1. Inicia el servidor:

   ```bash
   npm start
   ```
Puedes usar node:
   
   ```bash
   node index.js
   ```


2. Configura tu cliente en GODOT para conectarse al servidor WebSocket proporcionado por este backend.

## Proyecto de Godot

Úsando actualmente GODOT 4.3

La lógica escencial esta en la carpeta de Scripts/ws. Está dibididad en scripts con componentes para la comunicación con el server. 

## Contribuciones

¡Contribuciones son bienvenidas! Si tienes ideas para mejorar este proyecto, no dudes en abrir un issue o enviar un pull request.

## Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para obtener más información.

// Importing required modules
const app = require('express')();
const httpServer = require('http').Server(app);
const io = require('socket.io')(httpServer);

// Set up socket.io to listen for connections
io.on('connection', (socket) => {
  console.log('user connected');      
  // Listen for 'chat_message' event from a client
  socket.on('chat_message', (msg) => {
    console.log('message: ' + msg);
    io.emit('chat_message', msg); // Broadcast the message to all connected clients
  });
  // Listen for 'disconnect' event when a user disconnects
  socket.on('disconnect', () => {
    console.log('user disconnected'); 
  });
});

// Start the HTTP server and listen on port 3000
httpServer.listen(3000, () => {
  console.log('listening on *:3000');
});
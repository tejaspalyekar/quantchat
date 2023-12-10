const app = require('express')();
const httpServer = require('http').Server(app);
const io = require('socket.io')(httpServer);

io.on('connection', (socket) => {
  console.log('user connected');      //when user is connected
  socket.on('chat_message', (msg) => {
    console.log('message: ' + msg);
    io.emit('chat_message', msg);
  });
  socket.on('disconnect', () => {
    console.log('user disconnected'); //user disconnected
  });
});

httpServer.listen(3000, () => {
  console.log('listening on *:3000');
});
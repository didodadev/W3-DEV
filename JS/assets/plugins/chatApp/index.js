// Setup basic express server
var express = require('express');
var app = express();
var server = require('http').createServer(app);
var io = require('socket.io')(server);
var port = process.env.PORT || 3000;


server.listen(port, function () {
  console.log('Server listening at port %d', port);
});

// Routing
//app .use(express.static(__dirname + '/public'));

// Chatroom

// usernames which are currently connected to the chat
var usernames = {};
var numUsers = 0;

var rooms =[];

io.on('connection', function (socket) {
    
    socket.on('new user', function (data) {
        //console.log (data);
        
        socket.username = data.name;
        socket.id       = data.id;
        
        socket.broadcast.emit('join user', {
            username: socket.username,
            id: socket.id
        });
    });
    
   socket.on('crate room', function(room) { 
        //console.log('joining room', room);
        
            rooms.push(room);
            console.log (rooms);
        
        socket.join(room); 
        
   });
    
    
});//io.on connection

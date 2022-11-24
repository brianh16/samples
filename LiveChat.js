var express = require('express');
var bodyParser = require('body-parser');
var app = express();
var http = require('http').Server(app);
var socket = require('socket.io')(http);
var mongoose = require('mongoose');

app.use(express.static(__dirname));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));

var Message = mongoose.model('Message',{
    name : String,
    message : String
  });

app.get('/messages', (req, res) => {
Message.find({},(err, messages)=> {
    res.send(messages);
});
});

app.post('/messages', (req, res) => {
var message = new Message(req.body);
message.save((err) =>{
    if(err)
    sendStatus(500);
    socket.emit('message', req.body);
    res.sendStatus(200);
});
});

socket.on('connection', () =>{
console.log('a user is connected')
});

mongoose.connect(dbUrl ,{useMongoClient : true} ,(err) => {
console.log('mongodb connected',err);
});

var server = http.listen(3001, () => {
console.log('server is running on port', server.address().port);
});

// Global
var rooms = [];
var socket = io();
var msgPanel = $('.con > .panel');
var usersPanel = $('.con > .users');


var onlineUser = function (data){
        //console.log (data);

        socket.emit('new user', data); //user connection
    
        return {
            
                join : function (e){
                    //console.log ('join');

                        socket.on('join user', function (res) {
                            //console.log (res);
                                var uName = res.username;
                                var uId = res.id;
                                var __li    = $('<li>');
                                var __liAttr = {
                                    
                                    onClick : 'createRoom("'+ uName+'",'+ uId+')'
                                    
                                };//liAttr
                            
                            
                            /*
                             
                             join user click function 
                            
                            
                             */
                            
                                usersPanel.find('ul')
                                    .append( __li.text( uName ).attr(__liAttr) );
                        
                        });//socket.on join user
                        
                        
                },//user
                
                message : function(e){
                   //console.log('message')
                    
                    
                }//message
            
        }//return 
    
};//onlineUser

var createRoom  = function (name,id){
    
    var name = name;
    var id = id;
    if (rooms.indexOf(id) > -1 ) return false;    
    rooms.push(id);
    
    socket.emit('crate room',id);
    
    $('<ul>')
            .attr('id',id)
            .append(
                $('<li>')
                .append(name)
            )
            .appendTo(msgPanel);
    
};//createRoom
    
$(function(e){
    
    var name        = ['Alen','Jackie','Sam','Martin','Jhon','Dimitri','Stark','Irish','Marty','Tony','Jim','Eva','Jessa','Penny','Hannah','Tina'];
    var nameNum     = Math.floor((Math.random() * 10) + 1); // random number
    var randName    = name[nameNum]; //add name 
 
    if (!randName) nameNum = Math.floor((Math.random() * 10) + 1); randName = name[nameNum];
        
        var data = {
            'name'  : randName,
            'id'    : nameNum
        };// data object
        
    var __user = new onlineUser(data);
        __user.join();
        
 
});//ready
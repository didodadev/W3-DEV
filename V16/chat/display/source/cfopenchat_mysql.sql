--	Project      :	CFOpenChat
--	Homepage     :	www.opensourcecf.com/cfopenchat
--	Name         : 	cfopenchat_mysql.sql
--	Author       : 	Rick Root
--	Purpose	     : 	Database creation script for MySQL
--	

CREATE TABLE chat_rooms (
	room_id int not null auto_increment,
	room_name nvarchar(30) not null DEFAULT '',
	permanent int not null default 0,
	allow_rename int not null default 0,
	allow_private int not null default 0,
	primary key (room_id)
);

create unique index idxRoomName on chat_rooms(room_name);

insert into chat_rooms 
( room_id, room_name, permanent, allow_rename, allow_private )
values
(0, 'Lobby', 1, 0, 0);

CREATE TABLE chat_users (
	user_id nchar(35) not null,
	uname nvarchar(30) not null,
	primary key (user_id)
);


CREATE TABLE room_users (
	room_id int not null,
	user_id nchar(35) not null,
	uname nvarchar(30) not null,
	pingtime datetime not null,
	active smallint not null default 0,
	primary key (room_id, user_id)
);

CREATE TABLE chat_content (
  line_id int NOT NULL auto_increment,
  room_id int not null,
  action int not null,
  user_id nchar(35) not null,
  uname nvarchar(30) NOT NULL default '',
  content text not null,
  recip_id nchar(35) not null default '',
  tstamp double null,
  PRIMARY KEY  (line_id)
);

--	Project      :	CFOpenChat
--	Homepage     :	www.opensourcecf.com/cfopenchat
--	Name         : 	cfopenchat_mssql.sql
--	Author       : 	Rick Root
--	Purpose	     : 	Database creation script for Microssoft SQL Server
--	

CREATE TABLE chat_rooms (
	room_id int not null IDENTITY(1,1),
	room_name nvarchar(30) not null DEFAULT '',
	permanent int not null default 0,
	allow_rename int not null default 0,
	allow_private int not null default 0,
	primary key (room_id)
);

create unique index idxRoomName on chat_rooms(room_name);

SET IDENTITY_INSERT chat_rooms ON;
insert into chat_rooms 
( room_id, room_name, permanent, allow_rename, allow_private )
values
(1, 'Lobby', 1, 0, 0);
SET IDENTITY_INSERT chat_rooms OFF;

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
  line_id int NOT NULL IDENTITY(1,1),
  room_id int not null,
  action int not null,
  user_id nchar(35) not null,
  uname nvarchar(30) NOT NULL default '',
  content ntext not null,
  recip_id nchar(35) not null default '',
  tstamp double null,
  PRIMARY KEY  (line_id)
);


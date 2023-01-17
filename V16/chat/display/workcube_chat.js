/*
	Project      :	CFOpenChat
	Homepage     :	www.opensourcecf.com/cfopenchat
	Name	 : 	cfopenchat.js
  	Author       : 	Rick Root
*/

/* perform some initialization */
var lastRead = -1;
var connected = false;
var debug_level = 0;
var debugPanel = '';
var disablePageUnload = false;
var currentRoomUsers = '';
var timeoutId = '';
var divChat = '';
var divUsers = '';
var divStatus = '';
var re = /<\/span>/gi;

// if the user needs to login again, where to redirect them?
var loginUrl = 'index.cfm';

/* this is so we don't trip over ourselves updating the chat window,
   in case the server gets slow */

var updateInProgress = 0;
/* monitor how many updates we've skipped, too, in case a request fails,
var skippedUpdates = 0;

/* I don't think you'd want to update the window more often than every
   two seconds.. that's two requests (chat window, and user list) every
   two seconds for every user. */
var refresh_fast = 1000;
var refresh_normal = 2000;
var refresh_slow = 5000;
var refresh = refresh_normal; // default

function toggleDebug()
{
	try
	{
	if (debug_level == 0) {
		debug_level = 1;
		document.getElementById('debugPanel').style.display='block';
	} else {
		debug_level = 0;
		document.getElementById('debugPanel').style.display='none';
	}
	} catch (e) {
		alert('Could not toggle debug pane.  Maybe the div is missing.  Please refer to the documentation.');
	}
}
function debugOutput(str)
{
	if (debug_level > 0 || 1==1)
	{
		if (debugPanel.innerHTML.length > 50000) {
			debugPanel.innerHTML = Date() + ': ' +str + '<br/>';
		} else {
			debugPanel.innerHTML += Date() + ': ' +str + '<br/>';
		}
		debugPanel.scrollTop = debugPanel.scrollHeight;
	}
}
/*
* function takes results from listRoomsAndUsers call and updates the
* users window
*/
function listRoomsAndUsersResult(result)
{
	debugOutput('listRoomsAndUsersResult called ' + result);
	var output = '';
	var lastRoom = '';
	if (typeof result == 'object')
	{
		if (result.room_name.length > 0)
		{
			for (var i=0;i<result.room_name.length;i++)
			{
				var currentRoom = result.room_name[i];
				if (currentRoom != lastRoom)
				{
					// output the room name once
					output += '<div class="divUsersTitle">' + currentRoom + '</div>';
					lastRoom = currentRoom;
				}
				output += '<div class="roomUser">' + result.uname[i] + '</div>';
			}
		}
		if (output != currentRoomUsers)
		{
			currentRoomUsers = output; /* store for later comparisons */
			divUsers.innerHTML = output;
		}
	}
}

/*
* function calls chatInit method on server, which returns an integer
* representing the last row id that was sent to the browser
*/
function chatInit()
{
	// debugOutput('chatInit called');
	DWREngine._execute(_ajaxConfig._cfscriptLocation, null, 'chatInit', 'foo', chatInitResult);
	return false;
}
/*
* function called to clear the chat window.
*/
function clearChatWindow()
{
	divChat.innerHTML = "";
}
/*
* function to get results from chatInit() server method.
* tells you if initializatino failed.
* otherwise, it just sets the lastRead javascript variable,
* and then starts the update process.
*/
function chatInitResult(result)
{
	debugOutput('chatInitResult called, result = '+result );
	if (result == -1)
	{
		output = '<center><h3>Initialization Failed</h3><p>Failed to initialize the chat room.</p><p><a href="' + loginUrl + '">Click here to log in again</a></p></center>';
		divChat.innerHTML = output;
		document.frmSend.content.disabled = true;
		document.frmSend.btnSubmit.disabled = true;
	} else {
		connected = true;
		divStatus.innerHTML = 'Connected.';
		clearChatWindow();
		lastRead = result;
		updateChatWindow();
		document.frmSend.content.focus();
	}
}


/*
* function called when the user tries to send a message or command
* to the chat server.
*/
function sendResponse()
{
	var content = DWRUtil.getValue('content');
	document.frmSend.content.value='';
	if (content == '') {
		/* bypass refresh timer and update the chat window now */
		updateChatWindow();
	} else if (content == "/clear") {
		clearChatWindow();
		/* chat window will update when update timer goes off */
	} else {
		/* when command is set refresh, send to server anyway for response */
		if (content == "/set refresh fast") {
			refresh = refresh_fast;
		} else if (content == "/set refresh normal") {
			refresh = refresh_normal;
		} else if (content == "/set refresh slow") {
			refresh = refresh_slow;
		}
		DWREngine._execute(_ajaxConfig._cfscriptLocation, null, 'sendResponse', content, sendResponseResult);
	}
	return false;
}

/*
* function called when the user clicks "Exit" button
*/
function sendExit()
{
	if (connected)
	{
	var content = '/exit';
	window.clearTimeout(timeoutId);
	document.frmSend.content.value='';
	DWREngine._execute(_ajaxConfig._cfscriptLocation, null, 'sendResponse', content, sendResponseResult);
	} 
	else 
	{
		self.close;
	}
	return false;
}

/*
* function takes results from sendResponse() server call
* and performs necessary actions.
*/
function sendResponseResult(result)
{
	var output='';
	var err = '';
	debugOutput('sendResponseResult(): result='+result);
	if (typeof result == 'string' && result == 'true') {
		result = true;
	} else if (typeof result == 'string' && result == 'false') {
		err = 'An unknown error occurred.';
		err = 'You are not logged into the chat room anymore, and you will need to <a href="' + loginUrl + '">log in again</a>.';
		result = false;
	} else if (typeof result == 'string' && result.substr(0,5).toUpperCase() == 'ERROR') {
		err = result;
		err = 'You are not logged into the chat room anymore, and you will need to <a href="' + loginUrl + '">log in again</a>. [' + result + ']';
		result = false;
	}
	if (typeof result != 'boolean')
	{
		if (result == "exit") {
			/* the user sent the "/exit" command to the server
			* theoretically, we could also use this to force
			* everyone out of the pool, so to speak. 
			*/
			window.clearTimeout(timeoutId);
			disablePageUnload = true;
			window.location.href=loginUrl;
			return true;
		} else if (typeof result == 'object') {
			/*
			* it's actually a coldfusion array.  This is what
			* gets returned if we're pushing a URL to someone
			* like when they type /help
			*/
			var url = result[0];
			var w = result[1];
			var h = result[2];
			var winType = result[3];
			if (winType == 'slim')
			{
				// no address bar, toolbars, etc 
				popup_ultraslim(url,w,h);	
			} else {
				popup(url,w,h);
			}
			/*
			* notify the user in the chat window that we sent
			* them a private message and give them the opportunity
			* to click on a link
			*/
			output += '<span class=privmsg>*** The system has sent you a URL.  If it does not pop up automatically, <a target=_blank href="' + url + '">click here</a></span><br/>';
		} else {
			/* it's a normal private message */
			output += '<span class=privmsg>*** ' + result + '</span><br/>';
		}
		/* send the output */
		divChat.innerHTML = divChat.innerHTML + output;
		// scroll to bottom of chat window
		divChat.scrollTop = divChat.scrollHeight;

	} else {
		/* it returned true or false */
		if (!result) {
			window.clearTimeout(timeoutId);
			output += '<span class=privmsg>*** Your message may not have been sent.  ' + err + '</span>';
			divChat.innerHTML = divChat.innerHTML + output;
			// scroll to bottom of chat window
			divChat.scrollTop = divChat.scrollHeight;
		} else {
			updateChatWindow();
		} /* else it returned true, don't do anything */
	}
}
/*
* function to update the chat window.  Gets called every X seconds
* based on the value of "refresh" earlier.
*
* it's job is to call the getUpdates() server function.
*/
function updateChatWindow()
{
	//alert('updateChatWindow called');
	/* 
	* do NOT do an update if an update is already in progress.
	*/
	if (updateInProgress == 0 )
	{
		updateInProgress = 1;
		skippedUpdates = 0;
		DWREngine._execute(_ajaxConfig._cfscriptLocation, null, 'getUpdates', lastRead, updateChatWindowResult);
	} else if (skippedUpdates > 1) {
		skippedUpdates++;
		debugOutput('Skipped ' + skippedUpdates + ' updates!  Something might be wrong.');
	} else {
		skippedUpdates++;
	}
	return false;
}	
function updateChatWindowResult(result)
{
	var err = '';
	debugOutput('updateChatWindowResult() called.');
	if (typeof result == 'string' && result == 'true') {
		result = true;
	} else if (typeof result == 'string' && result == 'false') {
		err = 'An unknown error occurred.';
		err = 'You are not logged into the chat room anymore, and you will need to <a href="' + loginUrl + '">log in again</a>.';
		result = false;
	} else if (typeof result == 'string' && result.substr(0,5).toUpperCase() == 'ERROR') {
		err = result;
		err = 'You are not logged into the chat room anymore, and you will need to <a href="' + loginUrl + '">log in again</a>. [' + result + ']';
		result = false;
	}

	/* server function returns a boolean value in a variety of cases */
	if (typeof result == 'boolean') {
		output = '<span class=privmsg>*** You seem to be disconnected.  ' + err + '</span>';
		divChat.innerHTML = divChat.innerHTML + output;
		// scroll to bottom of chat window
		divChat.scrollTop = divChat.scrollHeight;
		divStatus.innerHTML = '<b>Disconnected / Temporary Connection Failure.</b>';
		connected = false;
	} else {
		connected = true;
		var lines = result.lines;
		var roominfo = result.roominfo;
		if (lines.action.length > 0)
		{
			var output = '';
			for (var j = 0; j < lines.action.length; j++) {
				if (lines.action[j] == 2 || lines.action[j] == 3)
				{
					/*
					* it's a server action (join/leave)
					* or a user action via the /me command
					* and the output is already formatted
					*/
					if (lines.action[j] == 2 && lines.content[j].indexOf('entered the room') > 0 )
					{
						playSound('open');
					} else if (lines.action[j] == 2 && lines.content[j].indexOf('left the room') > 0 ) {
						playSound('close');
					}
					if ( lines.action[j] == 2 && lines.content[j].indexOf('doesn\'t seem to be here anymore') <= 0) {
						lines.content[j] = lines.content[j].replace(re, ' at ' + getTimestamp(lines.tstamp[j]) + '</span>');
					}
					output += lines.content[j];
				} else if (lines.action[j] == 4){
					/*
					* it's a private message of some kind.
					*/
					playSound('drip');
					output += '<span class=privmsg>***<span class=chat_username>' + lines.uname[j] + ':</span> ' + lines.content[j] + '</span><br/>';
				} else if (lines.action[j] == 5){
					/*
					* it's a pushed URL.. it will look like
					* a private message, with a clickable
					* link but we'll also try to launch
					* the url via popup.
					*/
					var url = lines.content[j];
					output += '<span class=privmsg>*** ' + lines.uname[j] + ' has sent you a URL.  If it does not pop up automatically, <a target=_blank href="' + lines.content[j] + '">click here</a></span><br/>';
					// pop it up!
					popup(url,600,400);
				} else {
					/*
					* normal message from a user
					*/
					output += '<span class=chat_username>' + lines.uname[j] + ':</span> ' + lines.content[j] + '<br/>';
				}
				/* 
				*update the lastRead variable so we don't
				* see lines more than once
				*/
				lastRead = lines.line_id[j];
			} // end for loop
			/*
			* send the completed output to the chat window
			*/
			divChat.innerHTML = divChat.innerHTML + output;
			// scroll to bottom of chat window
			divChat.scrollTop = divChat.scrollHeight;
		}
		listRoomsAndUsersResult(roominfo);
		/* set the refresh process to run again */
		updateInProgress = 0;
		// just in case, clear the timeout
		window.clearTimeout(timeoutId);
		timeoutId=window.setTimeout('updateChatWindow();',refresh);
		// debugOutput('refresh timeout set to ' + refresh + 'ms.');A
		divStatus.innerHTML = 'Connected.';
	}
}

/*
* pageInit sets options
* and then we call chatInit to get things rolling
*/
function pageInit()
{
DWREngine._errorHandler = function(message) 
{
	if (typeof message == "object" && message.name == "Error" && message.description) 
	{
		debugOutput("Error: " + message.description);
	} else {
		debugOutput(message);
	}
	divStatus.innerHTML = '<b>Disconnected / Temporary Connection Failure.111</b>';
	connected = false;
	updateInProgress = 0;
	window.clearTimeout(timeoutId);
	timeoutId=window.setTimeout('updateChatWindow();',refresh);

};
	divChat = document.getElementById('chatWindow');
	divStatus = document.getElementById('statusBar');
	divUsers = document.getElementById('roomUsers');

	try 
	{
		debugPanel = document.getElementById('debugPanel');
		if (debug_level > 0)
		{
			debugPanel.style.display = 'block';
		}
	} catch(err) {
			/* can't unhide debug panel */
	}
	debugOutput('pageInit() called');
	chatInit();
}

// do I need to comment my popup window?
function popup(url,x,y)
{
	newWindow = window.open(url,"","width="+x+",height="+y+",left=20,top=20,bgcolor=white,resizable,scrollbars,menubar");
	if ( newWindow != null )
	{
		newWindow.focus();
	}
}
function popup_ultraslim(url,x,y) 
{
	newWindow = window.open(url,"","width="+x+",height="+y+",left=10,top=10,bgcolor=white,resizable,scrollbars");
	if ( newWindow != null )
	{
		// make sure we're not hiding!
		newWindow.focus();
	}
}

// sound related stuff
var uid = new Date().getTime();
var flashProxy = new FlashProxy(uid, '/chat/display/JavaScriptFlashGateway.swf');

function playSound(snd)
{
	if (document.getElementById('enableSound').checked)
	{
		if (snd == 'open' || snd == 'close')
		{
			flashProxy.call('playDoorSound',snd);
		} else if (snd == 'drip') {
			flashProxy.call('playDripSound');
		}
	}
}

function getTimestamp(dt)
{
	var today=new Date(dt);
	var tt = 'AM';
	var h=today.getHours()
	var m=today.getMinutes()
	var s=today.getSeconds()
	// add a zero in front of numbers<10
	if (h > 12) { h = h - 12; tt = 'PM'; } else if (h = 0) { h = 12; }
	if (m < 10) { m = '0' + '' + m; }
	if (s < 10) { s = '0' + '' + s; }
	// m=checkTime(m)
	// s=checkTime(s)
	var result=h+":"+m+'&nbsp;' + tt;
	return result;
}


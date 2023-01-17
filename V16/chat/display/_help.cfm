<!---
	Project      :	CFOpenChat
	Homepage     :	www.opensourcecf.com/cfopenchat
	Name         : 	help.htm
	Author       : 	Rick Root
	
--->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
	<head>
			<title>Chat Help / Features</title>
		<style type="text/css">
		body {
			font-family: sans-serif;
		}
		h3 {
			background-color: 666666;
			color: white;
			padding: 5px;
		}
		h4 {
			background-color: cccccc;
			color: black;
			padding: 5px;
		}
		.code {
			font-family: monospace;
			font-weight: bold;
		}
		</style>
	</head>

<body>
	<a name="top"></a><h2>CFOpenChat Help & Information</h2>
	<p><a href="javascript:window.close()">Close Window</a></p>
	<ul>
		<li><a href="#helpRename">Change Current Username</a></li>
		<li><a href="#helpPrivateMessage">Send a Private Message</a></li>
		<li><a href="#helpClear">Clear the Screen</a></li>
		<li><a href="#helpJoinRoom">Join a Different Room</a></li>
		<li><a href="#helpAction">Perform an Action</a></li>
	<p>
		<li><a href="#developmentNotes">General Development Notes</a></li>
		<li><a href="#integrationNotes">Integration Notes</a></li>
	</ul>
	<a name="help"></a><h3>Things You Can Do</h3>
	<p>To send a message to the room, just type in your message and hit return or click the "Send" button.</p>
	<p>There are numerous special commands that you can use as well, called "slash commands", and those are discussed below.</p>
	<a name="helpRename"></a><h4>Change Current Username</h4>
		<ul><li><a href="#top">Top of page</a> &#160; <a href="javascript:window.close();">Close Window</a></li></ul>
	<p>You can switch usernames on the fly by using the "/nick" command:</p>
	<blockquote class="code">/nick joe<br/>/nick John Doe</blockquote>
	<p>The ability to dynamically change one's nickname *WILL* be a configurable option that can be disabled for all rooms or enabled on a per-room basis.</p>
	<a name="helpPrivateMessage"></a><h4>Send Private Messages</h4>
		<ul><li><a href="#top">Top of page</a> &#160; <a href="javascript:window.close();">Close Window</a></li></ul>
	<p>You can send private messages to other users in a channel by using the "/msg" command:</p>
	<blockquote class="code">/msg joe Keep this a secret!<br/>/msg "John Doe" Keep this a secret!</blockquote>
	<p>Usernames containing spaces must be quoted.</p>
	<a name="helpClear"></a><h4>Clear the Screen</h4>
		<ul><li><a href="#top">Top of page</a> &#160; <a href="javascript:window.close();">Close Window</a></li></ul>
	<p>If you're in the chat for a very long time, you might want to clear the screen if scrolling starts to get slow, using the "/clear" command:</p>
	<blockquote class="code">/clear</blockquote>
	<a name="helpJoinRoom"></a><h4>Join a Different Room</h4>
		<ul><li><a href="#top">Top of page</a> &#160; <a href="javascript:window.close();">Close Window</a></li></ul>
	<p>You can join a room - whether it exists or not - by using the "/join" command:</p>
	<blockquote class="code">/join coldfusion<br/>/join General Talk</blockquote>
	<p>Quotes are not required, and rooms that do not exist will be created on the fly.  Such rooms will be deleted when they are empty.</p>
	<p>The ability to create such temporary rooms will be a configurable option.</p>
	<a name="helpAction"></a><h4>Perform an action</h4>
		<ul><li><a href="#top">Top of page</a> &#160; <a href="javascript:window.close();">Close Window</a></li></ul>
	<p>You can perform actions in the chat room using  the "/me" command:</p>
	<blockquote class="code">/me smiles<br/>/me will be away for a few minutes<br/>/me gives three snaps in Z formation</blockquote>
	<p></p>
	<a name="developmentNotes"></a><h3>General Development Notes</h3>
	<ul>
		<li><a href="#top">Top of page</a> &#160; <a href="javascript:window.close();">Close Window</a></li>
	</ul>
	<ul>
		<li>Usernames can contain any character except quotes.  It might be worthwhile to place more restrictions on usernames, like allowing only alphanumeric characters and a few other special characters.</li>
		<li>Although my example database uses the latin1 character set (the MySQL default), the chat application would probably support unicode if I set it to UTF-8.</li>
		<li>It's theoretically possible to *NOT* store anything in a database, simply using the Application scope to store the data.  I may build an alternate version at some point that does  this.</li>
		<li>Adding customized "slash" commands is pretty easy.  Try typing /who or /help</li>
		<li>The capability is there to push a URL to a user and cause it to pop up automatically in a new window.  This obviously wouldn't be desirable in a general chat room but might be in a support environment or a moderated chat.</li>
	</ul>
	<a name="integrationNotes"></a><h3>Integration Notes</h3>
	<ul>
		<li><a href="#top">Top of page</a> &#160; <a href="javascript:window.close();">Close Window</a></li>
	</ul>
	<ul>
		<li>
			I'm not building any authentication into this basic application so
			that it can more easily be integrated into EXISTING applications.  That being
			said, if you wanted to add a chat room to your existing application but
			you want to force authentication, then all you need to do is call the
			createUser() function in the chatCFC the exact same way the chat.cfm page
			does, set the session.chat_user_id variable that it returns, then direct them
			to the chat.cfm page - removing the logic from that page that creates
			the user.  I'll try to make an example of this using Ray Camden's Galleon
			Forums.
		</li>
	</ul>
	<p><a href="javascript:window.close()">Close Window</a></p>
</body>
</html>



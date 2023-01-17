<cfheader name="Pragma" value="no-cache">
<cfsetting enablecfoutputonly="yes">
<cfif isDefined("attributes.uname") AND attributes.uname neq "">
	<cfset results = application.chatCFC.createUser(attributes.uname)>
	<cfif results.errorCode is 0>
		<cfset results2 = application.chatCFC.joinChat(results.user_id,attributes.room_id)>
		<cfif results2.errorCode is 0>
			<cfset session.chat_user_id = results.user_id>
			<!--- relocate so as to avoid page reload problems --->
			<cflocation url="#request.self#?fuseaction=chat.popup_chat&1" addtoken="no">
		<cfelse>
			<cfset errorMessage = results2.errorMessage>
		</cfif>
	<cfelse>
		<cfset errorMessage = results.errorMessage>
	</cfif>
<cfelseif not isDefined("session.chat_user_id") or session.chat_user_id eq "">
	<cflocation url="#request.self#?fuseaction=chat.popup_welcome" addtoken="no">
<cfelse>
	<!--- make sure the user is still logged into the chat --->
	<cfset uname = application.chatCFC.getUsername(session.chat_user_id)>
	<cfset room_id = application.chatCFC.getRoom(session.chat_user_id)>
	<cfif uname eq "" or room_id eq 0>
		<cfoutput>
			<cfset hata = 10>
			<cfinclude template="../../dsp_hata.cfm">
		</cfoutput>
		<cfabort>
	</cfif>
</cfif>

<link rel="stylesheet" type="text/css" href="chat/display/cfopenchat.css">
<script type="text/javascript" src="chat/display/JavaScriptFlashGateway.js"></script>
<script type='text/javascript'>_ajaxConfig = {'_cfscriptLocation':'cfopenchat_ajax.cfc', '_jsscriptFolder':'chat/display/js'};</script>
<script type='text/javascript' src='chat/display/js/ajax.js'></script>
<script type='text/javascript' src='chat/display/workcube_chat.js'></script>

<cfsetting enablecfoutputonly="no">
<table width="100%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border"  height="100%">
	<tr height="35" class="color-list">
		<td class="headbold">WorkCube Chat</td>
	</tr>
	<form name="frmSend" onSubmit="return sendResponse();">
	<tr class="color-row">
 		<td valign="top">
		<cfif isDefined("errorMessage") and errorMessage neq "">
			<span class="headbold">Hatalı İşlem Yaptınız.!</span><br/>
			<cfoutput>#errorMessage#</cfoutput>
			<cfabort>
		</cfif>
		<div id="cfopenchat">
		<table cellpadding=1 cellspacing=1 border=0 align="center">
			<tr>
				<td colspan="2"><div id="statusBar" class="statusBar">Not connected.</div></td>
			</tr>
			<tr>
				<td><div ID="chatWindow" class="chatWindow" style="width: 422px; height: 300px;"><center><h3>Please wait...</h3><p>Initialization in progress.</p></div></td>
				<td><div id="roomUsers" class="roomUsers" style="width: 150px; height: 300px;"></div></td>
			</tr>
			<tr>
				<td colspan="2">
				<input name="content" type="text" id="content" style="width:425px;" onFocus="select();" autocomplete="off">
				<input name="btnSubmit" id="btnSubmit" type="submit" value="Send">
				<input name="btnExit" id="btnExit" type="button" value="Exit" onClick="sendExit();">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="checkbox" CHECKED name="enableSound" id="enableSound">Ses Açık &nbsp; &nbsp; &nbsp;
					<cfif session.ep.admin><a href="javascript:toggleDebug();">Debug</a></cfif>
				</td>
			</tr>
		</table>
		<script type="text/javascript">
			var tag = new FlashTag('chat/display/sounds.swf', 1, 1); // last two arguments are height and width
			tag.setFlashvars('lcId='+uid);
			tag.write(document);
		</script>
</div>
<div id="debugPanel" style="display: none; border: 1px solid black; padding: 2px; width: 550px; height:65px; overflow: auto;"></div>
	</td>
 </tr>
</form>
</table>
<script type="text/javascript">
pageInit();
</script>

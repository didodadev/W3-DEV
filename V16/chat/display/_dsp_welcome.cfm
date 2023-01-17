<table width="100%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border"  height="100%">
 <tr height="35" class="color-list">
 	<td class="headbold">WorkCube Chat</td>
 </tr>
 <cfform method="post" action="#request.self#?fuseaction=chat.popup_chat">
 <tr class="color-row">
 	<td valign="top">
		<table>
			<tr>
				<td width="75">Kullanıcı Adı</td>
				<td><cfinput type="text" maxlength="30" name="uname" value="#session.ep.username#" readonly style="width:150px;"></td>
			</tr>
			<tr>
				<td>Oda</td>
				<td>
					<cfset qryRooms = application.chatCFC.listRooms()>
					<cfselect name="room_id" size="1" query="qryRooms" value="room_id" display="room_name" style="width:150px;"></cfselect>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="right" height="30"><input type="submit" value="Giriş"></td>
			</tr>
		</table>
	</td>
 </tr>
 </cfform>
</table>

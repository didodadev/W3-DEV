<cfinclude template="../query/get_wrk_messages.cfm">
<cfif isDefined('session.pda.userid')>
	<cfset time_zone = session.ep.time_zone >
</cfif>
	<cf_popup_box title="#getLang('main',131)#"><!---<cf_get_lang no='180.Workcube Mesaj'>--->
	<table>
        <tr> 
            <td class="headbold">
                <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="1" height="1">
                <param name="movie" value="/images/new_message.swf">
                <param name="quality" value="high">
                <embed src="/images/new_message.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="1" height="1"></embed>
                </object> 
            </td>
        </tr>
		<cfoutput query="get_wrk_messages">
		<tr>
			<td valign="top">
			<table width="100%">
				<tr>
					<td width="75" height="22" class="txtbold"><cf_get_lang no='166.Gönderen'></td>
					<td>:&nbsp;
						<cfif sender_type eq 0>#get_emp_info(sender_id,0,0)#&nbsp;<cf_online id="#sender_id#" zone="ep">
						<cfelseif sender_type eq 1>
							#get_par_info(sender_id,0,0,1)#
							&nbsp;
							<cf_online id="#sender_id#" zone="pp">
						<cfelseif sender_type eq 2>#get_cons_info(sender_id,0,0)#&nbsp;<cf_online id="#sender_id#" zone="ww">
						</cfif>
					</td>
				</tr>
				<tr>
					<td height="22" class="txtbold"><cf_get_lang no='1023.Mesaj Saati'></td>
					<td>:&nbsp;#dateformat(date_add("h",time_zone,send_date),'dd/mm/yyyy')#-#timeformat(date_add("h",time_zone,send_date),'HH:MM')#</td>
				</tr>
				<tr>
					<td height="22" valign="baseline" class="txtbold"><cf_get_lang_main no='131.Mesaj'></td>
					<td><font color="FF0000">:&nbsp;#message#</font></td>
				</tr>
					<cfif is_chat eq 1 and isdefined("session.ep")>
						<tr>
							<td colspan="2">
								<cfif len(room_id)>
									<cf_get_lang no='490.Chat İçin Davet Aldınız'>... <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=chat.popup_chat&room_id=#room_id#&uname=#session.ep.username#','medium');" class="tableyazi"><cf_get_lang no='1024.Tıklayınız'>...</a>
								<cfelse>
									<cf_get_lang no='490.Chat İçin Davet Aldınız'>... <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=chat.popup_welcome','medium');" class="tableyazi"><cf_get_lang no='1024.Tıklayınız'>...</a>
								</cfif>
							</td>
						</tr>
					</cfif>
			</table>
			</td>
		</tr>	
	</cfoutput>
	</table>
	</cf_popup_box>

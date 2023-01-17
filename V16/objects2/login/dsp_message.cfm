<cfinclude template="../query/get_wrk_messages.cfm">
<cfif isDefined('session.ep.userid')>
	<cfset time_zone = session.ep.time_zone>
<cfelseif isDefined('session.pp.userid')>
	<cfset time_zone = session.pp.time_zone>
<cfelseif isDefined('session.ww.userid')>
	<cfset time_zone = session.ww.time_zone>
</cfif>
<cfif get_wrk_messages.recordcount>
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
			<td style="vertical-align:top;">
                <table style="width:100%;">
                    <tr style="height:22px;">
                        <td class="txtbold" style="width:75px;"><cf_get_lang no='166.Gönderen'></td>
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
                        <td class="txtbold" style="height:22px;"><cf_get_lang no='1023.Mesaj Saati'></td>
                        <td>:&nbsp;#dateformat(date_add("h",time_zone,send_date),'dd/mm/yyyy')#-#timeformat(date_add("h",time_zone,send_date),'HH:MM')#</td>
                    </tr>
                    <tr>
                        <td valign="baseline" class="txtbold" style="height:22px;"><cf_get_lang_main no='131.Mesaj'></td>
                        <td><font color="FF0000">:&nbsp;#message#</font></td>
                    </tr>
                        <cfif is_chat eq 1 and isdefined("session.ep")>
                            <tr>
                                <td colspan="2">
                                    <cfif len(room_id)>
                                        <cf_get_lang no='490.Chat İçin Davet Aldınız'>... <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=chat.popup_chat&room_id=#room_id#&uname=#session.ep.username#','medium');" class="tableyazi"><cf_get_lang no='1024.Tıklayınız'>...</a>
                                    <cfelse>
                                        <cf_get_lang no='490.Chat İçin Davet Aldınız'>... <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=chat.popup_welcome','medium');" class="tableyazi"><cf_get_lang no='1024.Tıklayınız'>...</a>
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
	<cfquery name="DEL_MESSAGES" datasource="#DSN#">
		DELETE FROM
			WRK_MESSAGE
		WHERE
			<cfif isdefined("session.ep.userid")>
                RECEIVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND RECEIVER_TYPE = 0
            <cfelseif isdefined("session.pp.userid")>
                RECEIVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND RECEIVER_TYPE = 1
            <cfelseif isdefined("session.ww.userid")>
                RECEIVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND RECEIVER_TYPE = 2
            <cfelse>
                WRK_MESSAGE_ID IS NULL <!--- kayit gelmesin --->
            </cfif>
	</cfquery>
<cfelse><!--- herhangi bir mesaj yoksa mesaj gonder formu ciksin... --->
    <cfquery name="GET_WRK_EP_APPS" datasource="#DSN#">
        SELECT NAME,SURNAME,USERID,DOMAIN_NAME FROM WRK_SESSION WHERE USER_TYPE = 0 ORDER BY DOMAIN_NAME,NAME, SURNAME
    </cfquery>
    <cfquery name="GET_WRK_PP_APPS" datasource="#DSN#">
        SELECT NAME,SURNAME,USERID FROM WRK_SESSION WHERE USER_TYPE = 1 ORDER BY NAME, SURNAME
    </cfquery>
    <cf_popup_box title="#getLang('main',15)#"><!---<cf_get_lang_main no='15.Workcube Online Mesaj'>--->
    <cfform name="add_message" action="#request.self#?fuseaction=objects.emptypopup_add_message" method="post">
        <input type="hidden" value="" name="room_id" id="room_id"/>
        <table>
            <tr>
                <td style="vertical-align:top;">
                    <table>
                        <cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
                            <tr>
                                <td>Çalışan</td>
                                <td>
                                    <cfquery name="GET_NAME" datasource="#DSN#">
                                        SELECT NAME,SURNAME,USERID FROM WRK_SESSION WHERE USER_TYPE = 0 AND USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
                                    </cfquery>
                                    <input type="hidden" name="user_emp" id="user_emp" value="<cfoutput>#get_name.userid#</cfoutput>" />
                                    <cfoutput>#get_name.NAME# #get_name.SURNAME#</cfoutput>
                                </td>
                            </tr>
                        </cfif>
                        <cfif isdefined("session.pp.userid") or isdefined("attributes.partner_id")>
                            <tr> 
                                <td><cf_get_lang no='491.İş Ortağı'></td>
                                <td>
                                <select name="user_par" id="user_par" style="width:210px;">
                                    <option value=""><cf_get_lang_main no='322.Kurumsal Üye Seçiniz'></option>
                                    <cfoutput query="get_wrk_pp_apps">
                                        <option value="#userid#" <cfif isDefined('attributes.partner_id') and attributes.partner_id eq userid>selected</cfif>>#name# #surname#</option>
                                    </cfoutput> 
                                </select>
                                </td>
                            </tr>
                        </cfif>
                        <tr> 
                            <td style="vertical-align:top;"><cf_get_lang_main no='131.Mesaj'></td>
                            <td><textarea name="message" id="message" rows="3" style="width:210px;height:100px;"></textarea></td>
                        </tr>
                    </table>
                </td>
            </tr>
	    </table>
    	<cf_popup_box_footer>
        <cfsavecontent variable="mesaj1"><cf_get_lang_main no='1899.Mesaj Gönder'></cfsavecontent>
        <cf_workcube_buttons is_upd='0' add_function="control()" insert_alert='' insert_info='#mesaj1#'>
    </cf_popup_box_footer>
</cfform>
</cf_popup_box>
	<script type="text/javascript">
		document.getElementById('message').focus();
    </script>
</cfif>
<script type="text/javascript">
	function control()
	{
		if(document.getElementById('message').value=='')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='131.Mesaj'>");
			return false;
		}
	}
</script>

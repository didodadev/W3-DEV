<cfif isdefined('session.pp.userid')>
	<cfif isdefined("attributes.msg_id") and len(attributes.msg_id)>
		<cfset cmp = createObject("component","worknet.objects.messages") />
		<cfset getMessage = cmp.getMessage(msg_id:attributes.msg_id) />
	</cfif>
	<cfparam name="attributes.keyword" default="">
	<div class="haber_liste" <cfif attributes.fuseaction contains 'popup'>style="width:600px; background-color:#FFF;"</cfif>>
		<div class="haber_liste_1" <cfif attributes.fuseaction contains 'popup'>style="width:600px;"</cfif>>
			<div class="haber_liste_11"><h1><cf_get_lang_main no='1899.MESAJLARIM'></h1></div>
			<cfif not attributes.fuseaction contains 'popup'>
				<div class="haber_liste_12">
					<cfform name="search_" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
						<div class="mesaj_11">
							<input class="mesaj_11_txt" name="keyword" id="keyword" type="text" style="border:none;" value="<cfoutput>#attributes.keyword#</cfoutput>"/>
							<input class="mesaj_11_btn" name="" type="submit" value="" style=" border:none;">
						</div>
					</cfform>
				</div>
			</cfif>
		</div>
        <div class="mesaj">
        	<cfif not attributes.fuseaction contains 'popup'>
				<div class="mesaj_1">
				   <div class="mesaj_12">
						<cfset getInboxNotRead = createObject("component","worknet.objects.messages").getMessage(type:'inbox',is_read:0) />
						<cfset getTrashNotRead = createObject("component","worknet.objects.messages").getMessage(type:'trash',is_read:0) />
						<a class="m_12_ym" href="sent_message"><cf_get_lang no='188.Yeni Mesaj'></a>
						<a class="m_12_gm" href="inbox"><cf_get_lang_main no='1562.Gelen'><cfif getInboxNotRead.recordcount><samp><cfoutput>#getInboxNotRead.recordcount#</cfoutput></samp></cfif></a>
						<a class="m_12_gg" href="sentbox"><cf_get_lang no='30.Gönderilmis'></a>
						<a class="m_12_gg" href="trash"><cf_get_lang no='34.Silinmis'><cfif getTrashNotRead.recordcount><samp><cfoutput>#getTrashNotRead.recordcount#</cfoutput></samp></cfif></a>
					</div>
				</div>
			</cfif>
            <div class="mesaj_2" <cfif attributes.fuseaction contains 'popup'>style="width:600px;"</cfif>>
               <table>
                <cfform name="sent_message" action="#request.self#?fuseaction=worknet.emptypopup_query_message" method="post">
                <cfoutput>
                <input type="hidden" name="action_id" id="action_id" value="<cfif isdefined("attributes.action_id")>#attributes.action_id#</cfif>" />
				<input type="hidden" name="action_type" id="action_type" value="<cfif isdefined("attributes.action_type")>#attributes.action_type#</cfif>" />
                <input type="hidden" name="sender_id" id="sender_id" value="#session.pp.userid#" />
                <input type="hidden" name="sender_type" id="sender_type" value="PARTNER" />
				<input type="hidden" name="fuse_type" id="fuse_type" value="<cfif attributes.fuseaction contains 'popup'>1<cfelse>0</cfif>" />
                <cfif isdefined('attributes.member_id')>
					<tr>
						<td width="130"><div class="mesaj_211"><cf_get_lang_main no='512.Kime'> *</div></td>
						<td><input type="hidden" name="receiver_id" id="receiver_id" value="#attributes.member_id#" />
							<input type="hidden" name="receiver_type" id="receiver_type" value="PARTNER" />
							<b>#get_par_info(attributes.member_id,0,0,0)#</b>
						</td>
					</tr>
				<cfelse>
					<tr>
						<td width="130"><div class="mesaj_211"><cf_get_lang_main no='512.Kime'> *</div></td>
						<td><input type="hidden" name="receiver_id" id="receiver_id" value="" />
							<input type="hidden" name="receiver_type" id="receiver_type" value="PARTNER" />
							<input type="text" name="receiver_name" id="receiver_name" style="width:250px;" value=""  />
							<a href="javascript://"  onClick="windowopen('<cfoutput>#request.self#?fuseaction=worknet.popup_contact_list&field_id=sent_message.receiver_id&field_name=sent_message.receiver_name</cfoutput>','list');" style="position:absolute;">
                                <img src="../documents/templates/worknet/tasarim/icon_9.png" width="22" height="22" />
                            </a>
						</td>
					</tr>
				</cfif>
                <tr>
                    <td><div class="mesaj_211"><cf_get_lang_main no='68.Konu'> *</div></td>
                    <td><input type="text" name="subject" id="subject" style="width:400px;" value="<cfif isdefined("getMessage.subject")>#getMessage.subject#</cfif>" maxlength="500"></td>
                </tr>
                <tr>
                    <td valign="top"><div class="mesaj_211"><cf_get_lang_main no='131.Mesaj'></div></td>
                    <td>
<cfsavecontent variable="message_body">
<cfif isdefined("getMessage.body") and len(getMessage.body)>


-------------------------------------
#dateformat(date_add('h',session_base.time_zone,getMessage.sent_date),dateformat_style)# #timeformat(date_add('h',session_base.time_zone,getMessage.sent_date),timeformat_style)#,  #getMessage.sender_name# gönderdi:

#getMessage.body#
</cfif>
</cfsavecontent>
						<textarea name="body" id="body" style="width:450px; height:250px;">#htmlEditFormat(message_body)#</textarea>
					</td> 
                </tr>
                <tr height="35">
                    <td colspan="2" align="right" style="text-align:right;"><input class="mesaj_22_btn" style="border:0;" type="button" value="<cf_get_lang_main no='1331.Gönder'>" onclick="kontrol();" /></td>
                </tr>
            	</cfoutput>    
            </cfform>
            </table>
            </div>
        </div>
	</div>
	<script language="javascript">
		function kontrol()
		{
			if(document.getElementById('receiver_id').value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='512.Kime'>");
				document.getElementById('receiver_id').focus();
				return false;
			}
			if(document.getElementById('subject').value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='68.Konu'>");
				document.getElementById('subject').focus();
				return false;
			}
			if(document.getElementById('body').value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='131.Mesaj'>");
				document.getElementById('body').focus();
				return false;
			}
			if (confirm("<cf_get_lang_main no='123.Kaydetmek istediğinizden eminmisiniz!'>")); else return false;
			
			document.getElementById('sent_message').submit();
		}
	</script>
<cfelseif isdefined("session.ww.userid")>
	<script>
		alert('Bu sayfaya erişmek için firma çalışanı olarak giriş yapmanız gerekmektedir!');
		window.close();
	</script>
	<cfabort>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>

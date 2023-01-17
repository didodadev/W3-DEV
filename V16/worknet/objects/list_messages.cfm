<cfif isdefined('session.pp.userid')>
	<cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.sortdir" default="desc">
    <cfparam name="attributes.sortfield" default="SENT_DATE">
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>	
	<cfset getMessage = createObject("component","worknet.objects.messages").getMessage(type:attributes.type,keyword:attributes.keyword,sortdir:attributes.sortdir,sortfield:attributes.sortfield) />
	<cfparam name="attributes.totalrecords" default="#getMessage.recordcount#">
	<div class="haber_liste">
		<div class="haber_liste_1">
			<div class="haber_liste_11">
				<h1>
				<cfif attributes.type eq 'inbox'>
					<cf_get_lang_main no='1562.Gelen'>
				<cfelseif attributes.type eq 'sentbox'>
					<cf_get_lang no='30.Gönderilmis'>
				<cfelse>
					<cf_get_lang no='34.Silinmis'>
				</cfif>
					<cf_get_lang no='99.MESAJLARIM'>
				</h1>
			</div>
			<div class="haber_liste_12 ie7_mesaj">
				<cfform name="search_" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
					<div class="mesaj_11">
						<input class="mesaj_11_txt" name="keyword" id="keyword" type="text" style="border:none;" value="<cfoutput>#attributes.keyword#</cfoutput>"/>
						<input class="mesaj_11_btn" name="" type="submit" value="" style=" border:none;">
					</div>
				</cfform>
			</div>
		</div>
		<div class="mesaj">
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
			<div class="mesaj_3">
            	<cfif attributes.sortdir is 'desc'>
                	<cfset sortdir = 'asc'>
                <cfelse>
                	<cfset sortdir = 'desc'>
                </cfif>
            	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tablo">
                   <tr class="mesaj_31">
                    <td width="15" class="mesaj_311_2"><cf_get_lang_main no='75.No'></td>
                    <td width="280" class="mesaj_311_2">
						<cfif attributes.type eq 'inbox'>
                        	<a href="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&keyword=#attributes.keyword#&sortfield=sender_name&sortdir=#sortdir#</cfoutput>"><cf_get_lang no='41.Kimden'></a>
						<cfelseif attributes.type eq 'sentbox'>
                        	<a href="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&keyword=#attributes.keyword#&sortfield=RECEIVER_NAME&sortdir=#sortdir#</cfoutput>"><cf_get_lang_main no='512.Kime'></a>
                        <cfelse>
                        	<a href="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&keyword=#attributes.keyword#&sortfield=RECEIVER_NAME&sortdir=#sortdir#</cfoutput>"><cf_get_lang_main no='2034.Kişi'></a>
                        </cfif>
                    </td>
                    <td width="400" class="mesaj_311_2">
                    	<a href="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&keyword=#attributes.keyword#&sortfield=subject&sortdir=#sortdir#</cfoutput>"><cf_get_lang_main no='68.Konu'></a>
                   	</td>
                    <td width="120" class="mesaj_311_2">
                    	<a href="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&keyword=#attributes.keyword#&sortfield=SENT_DATE&sortdir=#sortdir#</cfoutput>"><cf_get_lang_main no='330.Tarih'></a>
                    </td>
                    <td width="25" class="mesaj_311_2" style="text-align:center;"><cfif getMessage.recordcount><input type="checkbox" name="allSelectLink" id="allSelectLink" onClick="check_all();"></cfif></td>
                   </tr>
					<cfif getMessage.recordcount>
                        <cfform name="upd_messages" action="#request.self#?fuseaction=worknet.emptypopup_query_message">
                        <input type="hidden" name="change_type" id="change_type" value="" />
                        <input type="hidden" name="rowcount" id="rowcount" value="<cfoutput>#getMessage.recordcount#</cfoutput>"/>
                        <cfoutput query="getMessage" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                            <tr <cfif is_read eq 0>style="font-weight:bold;"</cfif> <cfif (currentrow mod 2) eq 0>class="mesaj_35"<cfelse>class="mesaj_34"</cfif>>
                                <td class="tablo1">#currentrow#</td>
                                <td class="tablo1"><a href="#request.self#?fuseaction=worknet.dsp_message&msg_id=#msg_id#"><cfif attributes.type eq 'inbox'>#sender_name#<cfelse>#receiver_name#</cfif></a></td>
                                <td class="tablo1"><a href="#request.self#?fuseaction=worknet.dsp_message&msg_id=#msg_id#">#left(subject,200)#</a></td>
                                <td class="tablo1">#dateformat(date_add('h',session_base.time_zone,sent_date),dateformat_style)# #timeformat(date_add('h',session_base.time_zone,getMessage.sent_date),timeformat_style)#</td>
                                <td class="tablo2" style="text-align:center;"><input type="checkbox" name="is_selected_#currentrow#" id="is_selected_#currentrow#" value="#msg_id#"></td>
                            </tr>
                        </cfoutput>
                        </cfform>
                    <cfelse>
                        <tr class="mesaj_34">
                          <td class="tablo1" colspan="5"> <cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                        </tr>
                    </cfif>
              </table>
			</div>
			<div class="mesaj_4">
				<a class="mesaj_41" href="javascript://" onclick="kontrol(1)"><font style="margin-left:-6px;"><cf_get_lang no='3.Okunmadı'></font></a>
			   <cfif attributes.type neq 'trash'> 
					<a class="mesaj_42" href="javascript://" onclick="kontrol(2)"><cf_get_lang_main no='51.Sil'></a>
			   <cfelse>
					<a class="mesaj_42" href="javascript://" onclick="kontrol(3)"><cf_get_lang_main no='51.Sil'></a>
			   </cfif>
			</div>
		</div>
	</div>
	<div class="maincontent">
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset urlstr="&keyword=#attributes.keyword#">
					  <cf_paging page="#attributes.page#" 
						page_type="1"
						maxrows="#attributes.maxrows#" 
						totalrecords="#attributes.totalrecords#" 
						startrow="#attributes.startrow#" 
						adres="#attributes.fuseaction##urlstr#">
		</cfif>
	</div>
	<script type="text/javascript">
		function check_all()
		{
			if(document.getElementById('allSelectLink').checked == true)
			{
				for(i=1;i<=document.getElementById('rowcount').value;++i)
				{
					document.getElementById('is_selected_'+i).checked=true;
				}
			}
			else
			{
				for(i=1;i<=document.getElementById('rowcount').value;++i)
				{
					document.getElementById('is_selected_'+i).checked=false;
				}
			}
		}
		function kontrol(deger)
		{
			if (deger == 1)
				document.getElementById("change_type").value = 0;
			else if (deger == 2)
				document.getElementById("change_type").value = 1;
			else 
				document.getElementById("change_type").value = 2;
				
			document.getElementById('upd_messages').submit();
		}
	</script>
<cfelseif isdefined("session.ww.userid")>
	<script>
		alert('Bu sayfaya erişmek için firma çalışanı olarak giriş yapmanız gerekmektedir!');
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>


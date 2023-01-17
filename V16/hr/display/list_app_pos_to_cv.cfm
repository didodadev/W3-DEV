<table width="98%" cellpadding="0" cellspacing="0" border="0">
  <tr class="color-border">
	<td>
	  <table width="100%" align="center" cellpadding="2" cellspacing="1" border="0" class="color-border">
	  <tr class="color-header" height="22">
		<td colspan="6" class="form-title"><cf_get_lang dictionary_id='58186.Başvurular'></td>
	  </tr>
	  <tr class="color-row">
		  <td width="25" class="txtbold"><cf_get_lang dictionary_id='57487.No'></td>
		  <td width="80" class="txtbold"><cf_get_lang dictionary_id='55247.Basvuru No'></td>
		  <td class="txtbold"><cf_get_lang dictionary_id='55159.İlan'></td>
		  <td width="65" class="txtbold"><cf_get_lang dictionary_id='57742.Tarih'></td>
		  <td width="75" class="txtbold"><cf_get_lang dictionary_id='57756.Durum'></td>
		  <td width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_add_app_pos&app_pos_id=#get_app_pos.app_pos_id#&empapp_id=#get_app.empapp_id#</cfoutput>','medium');"> <img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='55172.Basvuru Ekle'>" border="0"></a></td>
	  </tr>
	<cfif get_app_pos.recordcount>
		<cfoutput query="get_app_pos">
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" >
				<td>#get_app_pos.currentrow#</td>
				<td><a href="#request.self#?fuseaction=hr.upd_app_pos&empapp_id=#empapp_id#&app_pos_id=#app_pos_id#" class="tableyazi">#get_app_pos.app_pos_id#</a></td>	
				<td>
				<cfif len(#get_app_pos.notice_id#)>
					<cfquery name="GET_NOTICES" datasource="#DSN#">
						SELECT NOTICE_HEAD,NOTICE_NO,STATUS FROM NOTICES WHERE NOTICE_ID=#get_app_pos.notice_id# 
					</cfquery>
					#GET_NOTICES.notice_no#-#GET_NOTICES.notice_head#
				<cfelseif len(#get_app_pos.position_id#)>
				</cfif>
				</td>
				<td>#DateFormat(get_app_pos.app_date,dateformat_style)#</td>
				<td><cfif get_app_pos.app_pos_status eq 1><cf_get_lang dictionary_id="57493.Aktif"><cfelse><cf_get_lang dictionary_id="57494.Pasif"></cfif></td>
				<td width="15"><a href="#request.self#?fuseaction=hr.upd_app_pos&empapp_id=#empapp_id#&app_pos_id=#app_pos_id#" ><img src="../../images/update_list.gif" border="0"></a></td>	
			</tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row"><td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td></tr>
	</cfif>
		</table>
		</td>
	</tr>
</table>


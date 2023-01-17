<cfparam name="attributes.usage_purpose_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfif IsDefined("attributes.form_varmi")>
<cfelse>
	<cfset GET_KMS.recordcount=0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_kms.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_medium_list_search title="#getLang('assetcare',718)#">
	<cf_medium_list_search_area>
		<cfform name="search_kms" action="" method="post">
		<input type="hidden" name="form_varmi" id="form_varmi" value="1">
			<table>
				<tr>
					<td><cf_get_lang_main no='1463.Çalışanlar'></td>
					<td><input type="hidden" name="employee_id" id="employee_id" value="<cfif len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
					<input type="text" name="employee_name" id="employee_name" style="width:135px;" maxlength="255">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=search_kms.employee_id&field_name=search_kms.employee_name&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='1463.Çalışanlar'>" border="0" align="absmiddle"></a></td>
					<td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
					<td><cf_wrk_search_button></td>
				</tr>
			</table>
		</cfform>
	</cf_medium_list_search_area>
</cf_medium_list_search>
<cf_medium_list>
	<thead>
		<tr>
			<th><cf_get_lang_main no='1656.Plaka'></th>
			<th><cf_get_lang_main no='132.Sorumlu'></th>
			<th><cf_get_lang_main no='89.Başlangıç'></th>
			<th><cf_get_lang_main no='90.Bitiş'></th>
			<th><cf_get_lang no='219.Son Km'></th>
			<th width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=assetcare.popup_add_km_control_detail&assetp_id=#attributes.assetp_id#</cfoutput>','medium')"><img src="/images/plus_list.gif" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></a></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_kms.recordcount>
        <cfoutput query="get_kms" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<tr>
			<td>#assetp#</td>
			<td>#get_emp_info(employee_id,0,1)#</td>
			<td>#dateformat(start_date,dateformat_style)#</td>
			<td>#dateformat(finish_date,dateformat_style)#</td>
			<td style="text-align:right;">#tlformat(km_finish)#</td>
			<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_upd_km_control_detail&km_control_id=#km_control_id#','medium');"><img src="/images/update_list.gif" alt="<cf_get_lang_main no='52.Güncelle'>" title="<cf_get_lang_main no='52.Güncelle'>" border="0" align="absmiddle"></a> </td>
		</tr>
		</cfoutput>
		<cfelse>
		<tr>
			<td colspan="10"><cfif IsDefined("attributes.form_varmi")><cf_get_lang_main no='72.Kayıt Yok'> <cfelse><cf_get_lang_main no='289.Filtre Ediniz'> !</cfif></td>
		</tr>
	    </cfif>
	</tbody>
</cf_medium_list>	
<cfif (attributes.totalrecords gt attributes.maxrows)> 
	<cfset url_str = "">
	<cfif len(attributes.usage_purpose_id)>
	  <cfset url_str = "#url_str#&usage_purpose_id=#attributes.usage_purpose_id#">
	</cfif>
	<cfif len(attributes.employee_name)>
	  <cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
	</cfif>
	<cfif len(attributes.employee_id)>
	  <cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
	</cfif>
	<cfif len(attributes.assetp_id)>
	  <cfset url_str = "#url_str#&assetp_id=#attributes.assetp_id#">
	</cfif>
  <table width="99%" align="center">
    <tr>
      <td><cf_pages 
			  page="#attributes.page#" 
			  maxrows="#attributes.maxrows#" 
			  totalrecords="#attributes.totalrecords#" 
			  startrow="#attributes.startrow#" 
			  adres="assetcare.popup_list_km_control_detail#url_str#"></td>
      <!-- sil -->
	  <td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
      <!-- sil -->
    </tr>
  </table>
</cfif>

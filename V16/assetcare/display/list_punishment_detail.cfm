<cfparam name="attributes.form_submitted" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfif len(attributes.form_submitted)>
<cfquery name="GET_PUN" datasource="#dsn#">
	SELECT 
		ASSET_P_PUNISHMENT.*,
		ASSET_P.ASSETP,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD,
		SETUP_PUNISHMENT_TYPE.PUNISHMENT_TYPE_NAME
	FROM
		ASSET_P_PUNISHMENT,
		ASSET_P,
		BRANCH,
		DEPARTMENT,
		SETUP_PUNISHMENT_TYPE
	WHERE
		ASSET_P_PUNISHMENT.ASSETP_ID = ASSET_P.ASSETP_ID AND
		ASSET_P.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND		
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND 
		ASSET_P_PUNISHMENT.ASSETP_ID = #attributes.assetp_id# AND
		<cfif len(attributes.employee_id) and len(attributes.employee_name)>ASSET_P_PUNISHMENT.EMPLOYEE_ID = #attributes.employee_id# AND</cfif>
		ASSET_P_PUNISHMENT.PUNISHMENT_TYPE_ID = SETUP_PUNISHMENT_TYPE.PUNISHMENT_TYPE_ID
	ORDER BY
		PUNISHMENT_ID 
	DESC
</cfquery>
<cfelse>
<cfset GET_PUN.recordcount = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_pun.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_medium_list_search title="#getLang('assetcare',133)#">
	<cf_medium_list_search_area>
	<cfform name="search_pun" action="#request.self#?fuseaction=assetcare.popup_list_punishment_detail" method="post">
	<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#attributes.assetp_id#</cfoutput>">
	<input type="hidden" name="form_submitted" id="form_submitted" value="1">
		<table>
			<tr>
				<td><cf_get_lang_main no='1463.Çalışanlar'></td>
					<td><input type="hidden" name="employee_id" id="employee_id" value="<cfif len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
					<input type="text" name="employee_name" id="employee_name" style="width:135px;" maxlength="255" value="<cfoutput>#attributes.employee_name#</cfoutput>">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=search_pun.employee_id&field_name=search_pun.employee_name&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='1463.Çalışanlar'>" border="0" align="absmiddle"></a></td>
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
			<th width="150"><cf_get_lang_main no='2234.Lokasyon'></th>
			<th><cf_get_lang_main no='132.Sorumlu'></th>
			<th width="100"><cf_get_lang no='414.Ceza Tipi'></th>
			<th width="70"><cf_get_lang no='416.Ceza Tarihi'></th>
			<th width="100" style="text-align:right;"><cf_get_lang no='417.Ceza Tutarı'></th>
			<th width="100" style="text-align:right;"><cf_get_lang no='418.Ödenen Tutar'></th>
			<th width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=assetcare.popup_add_punishment_detail&assetp_id=#attributes.assetp_id#</cfoutput>','medium')"><img src="/images/plus_list.gif" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>" border="0" align="absmiddle"></a></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_pun.recordcount>
        <cfoutput query="get_pun" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
				<td>#assetp#</td>
				<td>#branch_name#/#department_head#</td>
				<td>#get_emp_info(employee_id,0,0)#</td>
				<td> #PUNISHMENT_TYPE_NAME# </td>
				<td>#dateformat(punishment_date,dateformat_style)#</td>
				<td style="text-align:right;">#tlformat(punishment_amount)# #PUNISHMENT_AMOUNT_CURRENCY#</td>
				<td style="text-align:right;">#tlformat(paid_amount)# #PAID_AMOUNT_CURRENCY# </td>
				<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_upd_punishment_detail&pun_id=#punishment_id#','medium');"><img src="/images/update_list.gif" alt="Güncelle" title="Güncelle" border="0" align="absmiddle"></a> </td>
			</tr>
          </cfoutput>
        <cfelse>
          <tr>
            <td colspan="8"><cfif len(attributes.form_submitted)><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
          </tr>
        </cfif>
	</tbody>
</cf_medium_list>
<cfif (attributes.totalrecords gt attributes.maxrows)> 
	<cfset url_str = "">
	<cfif len(attributes.employee_id)>
	  <cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
	</cfif>
	<cfif len(attributes.employee_name)>
	  <cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
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
				  adres="assetcare.popup_list_punishment_detail#url_str#"></td>
		  <!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		  <!-- sil -->
		</tr>
	</table>
</cfif>

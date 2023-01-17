 <cfif isdefined("attributes.is_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.is_submitted" default=''>
<cfquery name="get_company" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_INSURANCE_COMPANY 
	WHERE 
		COMPANY_ID IS NOT NULL 
		<cfif len(attributes.keyword)>AND COMPANY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
</cfif>
</cfquery>
<cfparam name="attributes.totalrecords" default='#get_company.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search_corp" action="#request.self#?fuseaction=settings.list_insurance_companies" method="post">
<cf_big_list_search title="#getLang('settings',913)#"> 
	<cf_big_list_search_area>
		<table>
			<tr>
				<td><cf_get_lang_main no ='48.Filtre'><cfinput type="text" name="keyword" id="keyword" style="width:100px;" maxlength="50" value="#attributes.keyword#"></td>
				<td><cfsavecontent variable="message"><cf_get_lang_main no ='131.Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)" style="width:25px;"></td>
				<td><cf_wrk_search_button>
				<input type="hidden" name="is_submitted" id="is_submitted" value="1"></td>
				<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
			</tr>
		</table>
	</cf_big_list_search_area> 
</cf_big_list_search> 
</cfform>
      <!--- Ünvan Kategorileri --->
<cf_big_list>
	<thead>
		<tr>
			<th width="30"><cf_get_lang_main no='1165.Sıra'></th>
			<th><cf_get_lang no='1123.Kurum Adı'></th>
			<th><cf_get_lang no='1138.Kayıt Eden'></th>
			<th width="400"><cf_get_lang_main no='215.Kayıt Tarihi'></th>
			<th class="header_icn_none"><a href="javascript://"  onClick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_add_insurance_company</cfoutput>','small');"><img src="/images/plus_list.gif" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170. Ekle'>"></a></th> <!-- sil -->
		</tr>
	</thead>
	<tbody>
		<cfif get_company.recordcount and form_varmi eq 1>
			<cfoutput query="get_company" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#currentrow#</td>
					<td>#company_name#</td>
					<td>#get_emp_info(record_emp,0,1)#</td>
					<td>#Dateformat(record_date,dateformat_style)#</td>
					<!-- sil --><td width="15" style="text-align:right;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_upd_insurance_company&company_id=#company_id#','small');"><img src="/images/update_list.gif" alt="<cf_get_lang_main no='52.Güncelle'>" title="<cf_get_lang_main no='52. Guncelle'>"></a></td><!-- sil -->
				</tr>	
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="7"><cfif form_varmi eq 0><cf_get_lang_main no='289. Filtre Ediniz'>!<cfelse><cf_get_lang_main no='1074.Kayıt Bulunamadı!'></cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cfset url_string = "settings.list_insurance_companies">
<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.is_submitted)>
	<cfset url_string = "#url_string#&is_submitted=1">
</cfif>
<cf_paging 
    page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#url_string#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

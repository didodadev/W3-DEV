<cfparam name="attributes.keyword" default="">
<cfquery name="GET_SERVICE_CODES" datasource="#DSN3#">
	SELECT 
		SERVICE_CODE_ID,
		SERVICE_CODE,
		SERVICE_CODE_DETAIL
	FROM 
		SETUP_SERVICE_CODE 
		<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
			WHERE
				SERVICE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				SERVICE_CODE_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		</cfif>
</cfquery>
<cfset url_string = "">
<cfif isdefined("attributes.service_code_id")>
	<cfset url_string = "#url_string#&service_code_id=#attributes.service_code_id#">
</cfif>
<cfif isdefined("attributes.service_code")>
	<cfset url_string = "#url_string#&service_code=#attributes.service_code#">
</cfif>
<cfif isdefined("attributes.service_defect_code")>
	<cfset url_string = "#url_string#&service_defect_code=#attributes.service_defect_code#">
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_service_codes.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1 >
<cfform name="search_product" action="#request.self#?fuseaction=service.popup_service_defect_codes&#url_string#" method="post">
	<cf_medium_list_search title="#getLang('objects2',26)#">
    	 <cf_medium_list_search_area>
				<table>
				  	<tr>
						<cfinput type="hidden" name="is_form_submitted" value="1">
						<td><cf_get_lang_main no='48.Filtre'></td>
						<td><cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
						<td><cfinput type="text" name="maxrows" id="maxrows" maxlength="3" style="width:25px;" value="#attributes.maxrows#" validate="integer" onKeyUp="isNumber(this);" range="1," required="yes" message="Lütfen Geçerli Bir Sayı Giriniz !"></td>
						<td><cf_wrk_search_button></td>
				  	</tr>
				</table>
		</cf_medium_list_search_area>
	</cf_medium_list_search>
</cfform>
<cf_medium_list>
	<thead>
		<tr>
			<th style="width:150px;"><cf_get_lang_main no='1522.Arıza Kodu'></th>
			<th><cf_get_lang_main no='217.Açıklama'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_service_codes.recordcount and form_varmi eq 1>
			<cfoutput query="get_service_codes" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td><a href="javascript://" class="tableyazi" onclick="gonder('#service_code_id#','#service_code#');">#service_code#</a></td>
					<td>#service_code_detail#</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="4"><cfif form_varmi eq 0><cf_get_lang_main no='289.Filtre Ediniz'>!<cfelse><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
<cf_popup_box_footer>
<cfif attributes.maxrows lt attributes.totalrecords>
<cfset adres = "#adres#&is_form_submitted=1">
	<table cellpadding="2" cellspacing="0" border="0" style="text-align:center; width:98%">
  		<tr height="2">
			<td>
		  		<cfset adres = attributes.fuseaction>
		  		<cfif len(attributes.keyword)>
					<cfset adres = "#adres#&keyword=#attributes.keyword#">
				</cfif>
		  		<cfif len(url_string)>
					<cfset adres = "#adres#&#url_string#">
		  		</cfif>
	  			<cf_pages page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#adres#">
			</td>
    		<!-- sil -->
			<td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
			<!-- sil -->
  		</tr>
  	</table>
</cfif>
</cf_popup_box_footer>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function gonder(s_code_id,s_code)
	{
		<cfoutput>
		<cfif isdefined("attributes.service_code_id")>
			opener.#attributes.service_code_id#.value = s_code_id;
		</cfif>
		<cfif isdefined("attributes.service_code")>
			opener.#attributes.service_code#.value =s_code;
		</cfif>
		<cfif isdefined("attributes.service_defect_code")>
			opener.#attributes.service_defect_code#.value = s_code;
		</cfif>
		<cfif isdefined("attributes.field_calistir")>
			opener.bosalt();
			opener.butonlari_goster();
		</cfif>
		</cfoutput>
		window.close();
	}
</script>

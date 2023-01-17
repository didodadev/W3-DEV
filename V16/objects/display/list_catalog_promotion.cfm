<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.search_date" default=''>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.modal_id" default="">
<cfif isdefined("attributes.filtered")>
	<cfinclude template="../query/get_catalog_promotion.cfm">
<cfelse>
	<cfset get_catalog_names.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default=#get_catalog_names.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cf_box title="#getLang('','Aksiyonlar',58988)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="prom_cat" action="" method="post">
		<cf_box_search>
			<input type="hidden" value="1" name="filtered" id="filtered">
			<input type="hidden" value="<cfif isdefined("attributes.field_id")><cfoutput>#attributes.field_id#</cfoutput></cfif>" name="field_id" id="field_id">
			<input type="hidden" value="<cfif isdefined("attributes.field_name")><cfoutput>#attributes.field_name#</cfoutput></cfif>" name="field_name" id="field_name">
			<div class="form-group">
				<cfinput type="Text" name="keyword" value="#attributes.keyword#" placeholder="#getLang('','Filtre',57460)#">
			</div>
			<div class="form-group">
				<div class="input-group">
					<cfinput type="text" name="search_date" value="#dateformat(attributes.search_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getLang('','Başlangıç Tarihi',58053)# !">
					<span class="input-group-addon"><cf_wrk_date_image date_field="search_date"></span>
				</div>
			</div>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('prom_cat' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>
				<th width="30"><cf_get_lang dictionary_id='33119.Aksiyon'></th>
				<th><cf_get_lang dictionary_id='33120.Başlama / Bitiş'></th>
				<th><cf_get_lang dictionary_id='33121.Kondüsyon'></th>
				<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
				<th><cf_get_lang dictionary_id='57500.Onay'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_catalog_names.recordcount>
				<cfoutput query="get_catalog_names" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<cfset replaced_head = replace(CATALOG_HEAD,"'","\'",'All')>
						<td><a href="javascript://" onClick="send_to_opener('#CATALOG_ID#','#replaced_head#');">#catalog_head#</a></td>
						<td>#DateFormat(STARTDATE,dateformat_style)# - #DateFormat(FINISHDATE,dateformat_style)#</td>
						<td>#DateFormat(KONDUSYON_DATE,dateformat_style)# - #DateFormat(KONDUSYON_FINISH_DATE,dateformat_style)#</td>
						<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
						<td><cfif Len(VALID)><cf_get_lang dictionary_id='57616.Onaylı'><cfelse><cf_get_lang dictionary_id='57615.Onay Bekliyor'> / <cf_get_lang dictionary_id='32658.Onaysız'></cfif></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="5"><cfif not isdefined("attributes.filtered")><cf_get_lang dictionary_id ='57701.Filte Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>

	<cfset str_url_params = "">
	<cfif isdefined("attributes.field_id")>
		<cfset str_url_params = "&#str_url_params#&field_id=#attributes.field_id#">
	</cfif>
	<cfif isdefined("attributes.is_applied_info")>
		<cfset str_url_params = "&#str_url_params#&is_applied_info=#attributes.is_applied_info#">
	</cfif>
	<cfif isdefined("attributes.field_name")>		
		<cfset str_url_params = "&#str_url_params#&field_name=#attributes.field_name#">
	</cfif>
	<cfif isdefined("attributes.field_id_2")>
		<cfset str_url_params = "&#str_url_params#&field_id_2=#attributes.field_id_2#">
	</cfif>
	<cfif isdefined("attributes.field_name_2")>		
		<cfset str_url_params = "&#str_url_params#&field_name_2=#attributes.field_name_2#">
	</cfif>
	<cfif isdefined("attributes.search_date")>
		<cfset str_url_params = "&#str_url_params#&search_date=#attributes.search_date#">
	</cfif>
	<cfif attributes.totalrecords gt attributes.maxrows >
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="objects.popup_catalog_promotion#str_url_params#&filtered=1"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>
<script type="text/javascript">
document.getElementById('keyword').focus();
function send_to_opener(int_id,str_name)
{
	<cfif isdefined("attributes.field_id")>
		opener.<cfoutput>#attributes.field_id#</cfoutput>.value=int_id;
	</cfif>
	<cfif isdefined("attributes.field_name")>		
		opener.<cfoutput>#attributes.field_name#</cfoutput>.value=str_name;
	</cfif>
	<cfif isdefined("attributes.field_id_2")>
		opener.<cfoutput>#attributes.field_id_2#</cfoutput>.value=int_id;
	</cfif>
	<cfif isdefined("attributes.field_name_2")>		
		opener.<cfoutput>#attributes.field_name_2#</cfoutput>.value=str_name;
	</cfif>
	window.close();
}
</script>

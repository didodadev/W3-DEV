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
<cfif isdefined("attributes.service_defect_id")>
	<cfset url_string = "#url_string#&service_defect_id=#attributes.service_defect_id#">
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
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.totalrecords" default="#get_service_codes.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1 >
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Arıza Kodları',41668)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_product" action="#request.self#?fuseaction=service.popup_service_defect_codes&#url_string#" method="post">
			<cf_box_search>
				<cfinput type="hidden" name="is_form_submitted" value="1">
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('main','Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" id="maxrows" maxlength="3" value="#attributes.maxrows#" validate="integer" onKeyUp="isNumber(this);" range="1," required="yes" message="#getLang('','Kayıt Sayısı Hatalı',57537)#">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_product' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='58934.Arıza Kodu'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
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
						<td colspan="4"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.maxrows lt attributes.totalrecords>
			<cfset adres = "is_form_submitted=1">
			<cfset adres = attributes.fuseaction>
			<cfif len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(url_string)>
				<cfset adres = "#adres#&#url_string#">
			</cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function gonder(s_code_id,s_code)
	{
		<cfoutput>
		<cfif isdefined("attributes.service_code_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.#attributes.service_code_id#.value = s_code_id;
		</cfif>
		<cfif isdefined("attributes.service_code")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.#attributes.service_code#.value =s_code;
		</cfif>
		<cfif isdefined("attributes.service_defect_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.#attributes.service_defect_id#.value = s_code_id;
		</cfif>
		<cfif isdefined("attributes.service_defect_code")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.#attributes.service_defect_code#.value = s_code;
		</cfif>
		<cfif isdefined("attributes.field_calistir")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.bosalt();
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.butonlari_goster();
		</cfif>
		</cfoutput>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>

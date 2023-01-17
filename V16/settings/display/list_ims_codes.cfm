<cfparam  name="attributes.is_form_submitted" default="">
<cfparam name="attributes.keyword" default="">
<cfquery name="GET_IMS_CODE" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_IMS_CODE 
	WHERE 
		IMS_CODE_ID IS NOT NULL
		<cfif len(attributes.keyword)>
		 AND
		 (
		 IMS_CODE LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
		 IMS_CODE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		 )
		</cfif>
	ORDER BY
		IMS_CODE, IMS_CODE_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.totalrecords" default='#get_ims_code.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box>
	<cfform name="search_ims" action="#request.self#?fuseaction=settings.form_list_ims_codes" method="post">
		<cf_box_search > 
			<cfinput type="hidden" name="is_form_submitted" value="1">
				<div class="form-group">
				<cfinput type="text" name="keyword" id="keyword" autocomplete="off" value="#attributes.keyword#" maxlength="50" style="width:50px;" placeholder="#getLang(48,'Keyword',47046)#">
			</div>
			<div class="form-group small">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
			</div>
				<div class="form-group">
				<cf_wrk_search_button button_type="4">
			</div>
		</cf_box_search>
	</cfform> 
</cf_box>
<cf_box  title="#getLang('settings',1181)#" uidrop="1" hide_table_column="1" > 
	<cf_grid_list>
		<thead>
			<tr>
				<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th> 
				<th width="100" nowrap="nowrap"><cf_get_lang dictionary_id='52400.IMS Kodu'> (1001)</th>
				<th width="300"><cf_get_lang dictionary_id='45857.IMS Bölge Adı'> (1001)</th>
				<th width="100" nowrap="nowrap"><cf_get_lang dictionary_id='52400.IMS Kodu'> (501)</th>
				<th><cf_get_lang dictionary_id='45857.IMS Bölge Adı'> (501)</th>
				<!-- sil -->
				<th width="30"><a href="javascript://"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=settings.popup_add_ims_codes</cfoutput>');"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				<!-- sil -->
			</tr>
		</thead>
		<tbody>
			<cfif get_ims_code.recordcount and isdefined("attributes.is_form_submitted") and attributes.is_form_submitted eq 1>
				<cfoutput query="GET_IMS_CODE" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_company_info&ims_id=#ims_code_id#');" class="tableyazi">#ims_code#</a></td>
						<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_upd_ims_codes&ims_id=#ims_code_id# ');" class="tableyazi">#ims_code_name#</a></td>
						<td>#ims_code_501#</td>
						<td>#ims_code_501_name#</td>
						<!-- sil -->
						<td width="15" style="text-align:right;"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_upd_ims_codes&ims_id=#ims_code_id#');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						<!-- sil -->
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<tr>
                        <td colspan="20"><cfif isdefined("attributes.is_form_submitted") and attributes.is_form_submitted eq 1><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                    </tr>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>

	<cfset adres = "settings.form_list_ims_codes">
	<cfif isDefined('attributes.is_form_submitted') and len(attributes.is_form_submitted)>
		<cfset adres = "#adres#&is_form_submitted=#attributes.is_form_submitted#">
	</cfif>
	<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
		<cfset adres = "#adres#&keyword=#attributes.keyword#">
	</cfif>
	<cf_paging page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="#adres#">
	<script type="text/javascript">
		document.getElementById('keyword').focus();
	</script>
</cf_box>

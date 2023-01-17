<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submitted")>
    <cfquery name="GET_PROCESS_TYPE" datasource="#dsn#">
        SELECT 
            * 
        FROM 
            PROCESS_TYPE_ROWS_WORKGRUOP
        WHERE
            PROCESS_ROW_ID IS NULL
            <cfif len(attributes.keyword)>AND WORKGROUP_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"></cfif>
		ORDER BY
			WORKGROUP_NAME
    </cfquery>
<cfelse>
	<cfset get_process_type.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_process_type.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset adres=''>
<cfif isdefined("attributes.keyword")>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Süreç Grupları','43250')#" hide_table_column="1" uidrop="1" resize="0" collapsable="0">
		<cfform name="process_group_" action="#request.self#?fuseaction=process.list_process_groups" method="post" >
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search more="0">
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" id="keyword"  value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=process.popup_form_add_group');" title="<cf_get_lang dictionary_id='57582.Ekle'>"><i class="fa fa-plus"></i></a> 
				</div> 
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id ='36244.Grup'></th>
					<th><cf_get_lang dictionary_id ='36187.Süreçler'></th>
					<th class="header_icn_none" width="20"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=process.popup_form_add_group');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_process_type.recordcount>
					<cfoutput query="get_process_type" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">                 
						<tr>
							<td>#currentrow#</td>
							<td>#workgroup_name#</td>
								<cfquery name="GET_PROS" datasource="#dsn#">
									SELECT 
									DISTINCT
										PROCESS_TYPE.PROCESS_NAME
									FROM
										PROCESS_TYPE,
										PROCESS_TYPE_ROWS,
										PROCESS_TYPE_ROWS_WORKGRUOP
									WHERE
										PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID = #workgroup_id# AND
										PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID AND
										PROCESS_TYPE_ROWS.PROCESS_ROW_ID = PROCESS_TYPE_ROWS_WORKGRUOP.PROCESS_ROW_ID
								</cfquery>
							<td><cfloop query="GET_PROS">#get_pros.process_name#,</cfloop></td>
							<!-- sil -->
							<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=process.popup_form_upd_group&workgroup_id=#workgroup_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="4"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset adres = "process.list_process_groups">
		<cfif isdefined ("attributes.form_submitted") and len(attributes.form_submitted)>
			<cfset adres = "#adres#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

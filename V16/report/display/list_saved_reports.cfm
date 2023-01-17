<cfinclude template="../display/report_menu.cfm">
<cfset x = structdelete(session,'report')>
<cfif isdefined("attributes.form_submitted")>
    <cfquery name="get_saved_reports" datasource="#dsn#">
        SELECT 
            SAVED_REPORTS.SR_ID,
            SAVED_REPORTS.REPORT_NAME,
            SAVED_REPORTS.REPORT_DETAIL,
            SAVED_REPORTS.RECORD_DATE AS RECORD_DATE,
            SAVED_REPORTS.RECORD_EMP,
            EMPLOYEES.EMPLOYEE_NAME,
            EMPLOYEES.EMPLOYEE_SURNAME
        FROM
            SAVED_REPORTS,
            EMPLOYEES
        WHERE
            SAVED_REPORTS.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID
            <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
            AND REPORT_NAME like '%#attributes.keyword#%'
            </cfif>
        UNION ALL
        (
        SELECT 
            SR_ID,
            REPORT_NAME,
            REPORT_DETAIL,
            RECORD_DATE,
            RECORD_EMP,
            '' AS EMPLOYEE_NAME,
            '' AS EMPLOYEE_SURNAME
        FROM
            SAVED_REPORTS
        WHERE
            RECORD_EMP = 0
            <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
            AND REPORT_NAME like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
            </cfif>
        )	
        ORDER BY 
            RECORD_DATE DESC
    </cfquery>
<cfelse>
	<cfset get_saved_reports.recordcount=0>
</cfif>
<cfinclude template="../query/get_modules.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_saved_reports.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_string = "">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.module_id" default="">
<cfif len(attributes.keyword)>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.module_id)>
	<cfset url_string = "#url_string#&module_id=#attributes.module_id#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="filter" action="#request.self#?fuseaction=report.list_saved_reports" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<input type="hidden" name="form_submitted" id="form_submitted" value="1">
					<input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>" maxlength="255" onKeyDown="if(event.keyCode == 13) {searchButtonFunc()}">
				</div>
				<div class="form-group">
					<select name="module_id" id="module_id">
						<option value='0'><cf_get_lang dictionary_id='38728.Modül'></option>
						<cfoutput query="get_MODULES">
						<option value='#MODULE_ID#'<cfif attributes.module_id eq module_id> selected</cfif>>#MODULE_NAME#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3" onKeyUp="isNumber(this)">
				</div>       
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Kayıtlı Raporlar',38807)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th width="300"><cf_get_lang dictionary_id='57434.Rapor'></th>
					<th width="300"><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th width="300"><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th width="300"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<!-- sil --><th width="20" class="header_icn_none text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_saved_reports.recordcount>
					<cfoutput query="get_saved_reports" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=report.popupflush_view_saved_report&sr_id=#sr_id#','list');">#report_name#</a></td>
							<td>#REPORT_DETAIL#</td>
							<td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#RECORD_EMP#');"> #EMPLOYEE_NAME# #EMPLOYEE_SURNAME# </a></td>
							<td>#dateformat(RECORD_DATE,dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,RECORD_DATE),timeformat_style)#)</td>
							<!-- sil --><td align="center"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=report.popup_form_upd_saved_report&sr_id=#sr_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="6"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset adres = attributes.fuseaction>
		<cfif isdefined ('attributes.form_submitted') and len(attributes.form_submitted)>
			<cfset url_string = '#url_string#&form_submitted=#attributes.form_submitted#'>
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres##url_string#">
		<script type="text/javascript">
			document.getElementById('keyword').focus();
		</script>
	</cf_box>
</div>

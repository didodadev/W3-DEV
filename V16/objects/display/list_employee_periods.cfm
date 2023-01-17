<cfinclude template="../query/get_emp_period_details.cfm">
<cfset period_selected = ValueList(get_emp_periods.period_id)>
<cfparam name="attributes.modal_id" default="">
<cfform name="add_period" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_periods_to_employee&position_id=#attributes.position_id#">
	<cf_grid_list>
		<thead>
			<tr>
				<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
				<th width="200"><cf_get_lang dictionary_id='57574.Firma'></th>
				<th width="200"><cf_get_lang dictionary_id='32691.Period'></th>
				<th width="100"><cf_get_lang dictionary_id='57485.Öncelik'></th>
				<th><cf_get_lang dictionary_id='32693.Period Yıl'></th>		  
				<th width="200"><cf_get_lang dictionary_id='51145.Muhasebe İşlem Tarihi Kısıtı'></th>
				<th width="200"><cf_get_lang dictionary_id='60556.Bütçe İşlem Tarih Kısıtı'></th>		
				<th width="20"><cf_get_lang dictionary_id='58693.Seç'></th>
			</tr>
		</thead>
		<input type="hidden" name="auth_emps_pos" id="auth_emps_pos" value="">
		<input type="hidden" name="auth_emps_id" id="auth_emps_id" value="">
		<cfif isdefined("attributes.is_hr")><input type="hidden" name="is_hr" id="is_hr" value="1"></cfif>
		<input type="hidden" name="page_type" id="page_type" value="<cfif isdefined('attributes.type') and len(attributes.type)><cfoutput>#attributes.type#</cfoutput></cfif>">
		<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
		<input type="hidden" name="modal_id" id="modal_id" value="<cfoutput>#attributes.modal_id#</cfoutput>">
		<cfif isDefined("attributes.draggable")><input type="hidden" name="draggable" id="draggable" value="<cfoutput>#attributes.draggable#</cfoutput>"></cfif>
		<cfif get_other_companies.recordcount>
			<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_other_companies.recordcount#</cfoutput>">
			<cfoutput query="get_other_companies">
				<tbody>
					<tr>
						<td>#currentrow#</td>
						<td>#nick_name#</td>
						<td>#period#</td>
						<td class="text-center">
							<cfif (get_emp_periods.default_period is get_other_companies.period_id) and (len(get_emp_periods.default_period) or len(get_other_companies.period_id))>
								<input type="radio" name="period_default" id="period_default" value="#period_id#" checked>
							<cfelse>
								<input type="radio" name="period_default" id="period_default" value="#period_id#">
							</cfif>
						</td>
						<td>#period_year#</td>
							<cfquery name="get_date" dbtype="query">
								SELECT PROCESS_DATE, PERIOD_DATE,BUDGET_PERIOD_DATE FROM GET_EMP_PERIODS WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#period_id#">
							</cfquery>
						<td>
							<div class="form-group">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
									<cfinput validate="#validate_style#" message="#message#" type="text" name="action_date#period_id#" value="#dateformat(get_date.period_date,dateformat_style)#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="action_date#period_id#"></span>
								</div>
							</div>
						</td>
						<td>
							<div class="form-group">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
									<cfinput validate="#validate_style#" message="#message#" type="text" name="budget_action_date#period_id#" value="#dateformat(get_date.budget_period_date,dateformat_style)#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="budget_action_date#period_id#"></span>
								</div>
							</div>
						</td>				
						<td class="text-center"><input type="checkbox" name="periods" id="periods" value="#period_id#" <cfif ListFind(period_selected,period_id,",")>Checked</cfif>></td>
					</tr>
				</tbody>
			</cfoutput>
		</cfif>
	</cf_grid_list>
	<cf_box_footer>
		<cf_record_info query_name="get_emp_periods">
		<cf_workcube_buttons is_upd="0" add_function="control()">
	</cf_box_footer>
</cfform>
<script language="JavaScript1.1">
function kontrol_default_period()
{
	temp1=0;
	<cfif GET_OTHER_COMPANIES.recordcount eq 1>
		if (add_period.period_default.checked)
			temp1 = 1;
	<cfelse>
		for(i=0;i<add_period.period_default.length;i++)
			if (add_period.period_default[i].checked)
				temp1 = 1;
	</cfif>
	if (temp1 == 0)
	{
		if(add_period.period_default.value == 1)
			return true;
			
		alert("<cf_get_lang dictionary_id='33372.Öncelik Kolonundan Standart Bir Dönem Seçmelisiniz'>!");
		return false;
	}
}
function control() {
	get_auth_emps(1,1,0);
	<cfif isdefined("attributes.draggable")>
		loadPopupBox('add_period' , <cfoutput>#attributes.modal_id#</cfoutput>)
	</cfif>
}
</script>

<cfif isdefined("attributes.position_id")>
	<cfset is_add = "hr.emptypopup_add_pos_requirement&ilk=1">
<cfelseif isdefined("attributes.employee_id")>
	<cfset is_add = "hr.emptypopup_add_emp_requirement">
	<cfset get_query = createObject("component","V16.hr.cfc.control_pos")>
	<cfset control =get_query.control(EMPLOYEE_ID:attributes.EMPLOYEE_ID)>
	<cfloop query="control">
		<cfset att_id[CurrentRow][1]=REQ_TYPE_ID>
		<cfset att_id[CurrentRow][2]=REQ_TYPE>
		<cfset kayit_=1>
	</cfloop>
<cfelseif isdefined("attributes.position_cat_id")>
  	<cfset is_add = "hr.emptypopup_add_position_cat_requirements&ilk=1">
</cfif>

<cfquery name="pos_req_types" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		POSITION_REQ_TYPE
	<cfif isDefined("attributes.old_reqs") and len(attributes.old_reqs)>
	WHERE
		REQ_TYPE_ID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.old_reqs#">)
	</cfif>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	WHERE 
		REQ_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
 	</cfif>
</cfquery>
<cfloop query="pos_req_types">
	<cfset pos_id[CurrentRow][1]=REQ_TYPE_ID>
	<cfset pos_id[CurrentRow][2]=REQ_TYPE>
</cfloop>



<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#pos_req_types.recordcount#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfscript>
	url_string = '';
	if (isdefined('attributes.keyword')) url_string = '#url_string#&keyword=#attributes.keyword#';
	if (isdefined('attributes.position_id')) url_string = '#url_string#&position_id=#attributes.position_id#';
	if (isdefined('attributes.employee_id')) url_string = '#url_string#&employee_id=#attributes.employee_id#';
	if (isdefined('attributes.position_cat_id')) url_string = '#url_string#&position_cat_id=#attributes.position_cat_id#';
</cfscript>
<cf_box title="#getLang('hr',386)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform action="#request.self#?fuseaction=#is_add#" method="post" name="list_position_req_types">
		<cfif isDefined("attributes.position_id")>
			<input type="hidden" name="position_id" id="position_id" value="<cfoutput>#attributes.position_id#</cfoutput>">
		<cfelseif isDefined("attributes.employee_id")>
			<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
		<cfelseif isDefined("attributes.position_cat_id")>
			<input type="hidden" name="position_cat_id" id="position_cat_id" value="<cfoutput>#attributes.position_cat_id#</cfoutput>">
		</cfif>
		<cf_grid_list>
			<thead>		
				<tr>
					<th colspan="2"><cf_get_lang dictionary_id='57529.tanımlar'></th>
				</tr>
			</thead>
			<tbody>
				<cfif pos_req_types.recordcount>
					<cfif isdefined("kayit_") and len(kayit_)>
						<cfloop index="i" from=1 to="#pos_req_types.recordcount#">
							<cfoutput> 
								<cfif not ArrayFind(att_id,pos_id[i])>
									<tr>
										<td width="20"><input type="checkbox" name="REQ_TYPE_ID" id="REQ_TYPE_ID" value=" #pos_id[i][1]#"></td>
										<td> #pos_id[i][2]# </td>
									</tr>
								</cfif>
							</cfoutput>
						</cfloop>
					<cfelse>
						<cfoutput query="pos_req_types" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
								<td width="20"><input type="checkbox" name="REQ_TYPE_ID" id="REQ_TYPE_ID" value="#pos_req_types.REQ_TYPE_ID#"></td>
								<td>#pos_req_types.REQ_TYPE#</td>
							</tr>
						</cfoutput>
					</cfif>
				<cfelse>
					<tr>
						<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt yok'> !</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' type_format="1" insert_alert='' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_position_req_types' , #attributes.modal_id#)"),DE(""))#">
		</cf_box_footer>
	</cfform>
	<cf_paging 
		page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="hr.popup_list_pos_req_types#url_string#">
</cf_box>



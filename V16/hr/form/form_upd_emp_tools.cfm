<cfif not isdefined("get_know_levels")>
  	<cfinclude template="../query/get_know_levels.cfm">
</cfif>
<cfif not isdefined("get_hr_detail")>
  	<cfinclude template="../query/get_hr_detail.cfm">
</cfif>
<cfparam name="attributes.draggable" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="62973.Ekipman"></cfsavecontent>
<cf_box title="#message# : #get_emp_info(attributes.employee_id,0,0)#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform action="#request.self#?fuseaction=hr.emptypopup_upd_emp_tools" method="post" name="employe_tools">
		<input type="Hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
		<cf_box_elements>
			<cfset tools_list = get_hr_detail.tools>
			<cfset counter = 0>
			<cfset tools ="">
			<cfset tools_values ="">
			<cfloop list="#tools_list#" index="item" delimiters=";">
				<cfset counter = counter +1>
				<cfif counter mod 2>
					<cfset tools = ListAppend(tools, item,";")>
					<cfelse>
					<cfset tools_values = ListAppend(tools_values, item,";")>
				</cfif>
			</cfloop>
			
		</cf_box_elements>
			<cf_grid_list>
				<thead>
					<th><cf_get_lang dictionary_id='62858.Alet'> - <cf_get_lang dictionary_id='37657.Program'> - <cf_get_lang dictionary_id='62973.Ekipman'></th>
					<th><cf_get_lang dictionary_id='56192.Seviye'></th>
				</thead>
				<tbody>
					<cfloop from="1" to="12" index="i">
						<tr>
							<div class="col medium">
								<td><input type="Text" name="tool<cfoutput>#i#</cfoutput>" id="tool<cfoutput>#i#</cfoutput>" size="40" <cfif i LTE listlen(tools,";")>value="<cfoutput>#listgetat(tools,i,";")#</cfoutput>"</cfif>></td>
							</div>
							<div class="col small">
								<td class="form-group"><select name="tool<cfoutput>#i#</cfoutput>_level" id="tool<cfoutput>#i#</cfoutput>_level" size="1">
									<cfoutput query="know_levels">
									<option value="#knowlevel_id#" <cfif (i LTE listlen(tools,";")) and (listgetat(tools_values,i,";") eq knowlevel_id)>selected</cfif> >#knowlevel# 
									</cfoutput>
								</select></td>
							</div>
						</tr>
					</cfloop>
				</tbody>
			</cf_grid_list>
		<cf_box_footer>
			<cf_record_info query_name="get_hr_detail">
			<cf_workcube_buttons is_upd='0' add_function='#iif(isdefined("attributes.draggable"),DE("loadPopupBox('employe_tools' , #attributes.modal_id#)"),DE(""))#'>
		</cf_box_footer>
	</cfform>
</cf_box>
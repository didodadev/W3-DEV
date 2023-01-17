<cfif not isdefined("attributes.id")>
	<cfexit method="exittemplate">
</cfif>

<cfparam name="attributes.faction_id" default="0">

<cfquery name="GET_MODUL" datasource="#DSN#">
	SELECT MODULE_SHORT_NAME FROM MODULES WHERE MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
</cfquery>

<cfquery name="get_factions" datasource="#dsn#">
	SELECT WRK_OBJECTS_ID,FUSEACTION FROM WRK_OBJECTS WHERE MODUL_SHORT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_MODUL.MODULE_SHORT_NAME#"> ORDER BY FUSEACTION
</cfquery>
<cfquery name="get_emp_name" datasource="#dsn#">
	SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.POS_CODE#">
</cfquery>
<cfset NAME = '#get_emp_name.EMPLOYEE_NAME# #get_emp_name.employee_surname#'>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','workcube objects','60941')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="user_emp" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_emp_denied&pos_code=#attributes.POS_CODE#&module_id=#attributes.ID#">
			<cf_box_search more="0">
				<input type="hidden" name="EMP_NAME" id="EMP_NAME" value="#NAME#">
				<input type="hidden" name="POS_CODE" id="POS_CODE" value="#attributes.POS_CODE#">
				<div class="form-group">
					<cfoutput>#NAME#</cfoutput>
				</div>
			</cf_box_search>
			<cf_grid_list>
				<thead>
					<tr class="color-row">
						<th><cf_get_lang dictionary_id='58081.Hepsi'></th>
						<th class="header_icn_none"><input type="Checkbox" name="all_denied" id="all_denied" value="1" onclick="hepsi_denied_type();"></th>
						<th class="header_icn_none"><input type="Checkbox" name="all_view" id="all_view" value="1" onclick="hepsi_view();"></th>
						<th class="header_icn_none"><input type="Checkbox" name="all_insert" id="all_insert" value="1" onclick="hepsi_insert();"></th>
						<th class="header_icn_none"><input type="Checkbox" name="all_delete" id="all_delete" value="1" onclick="hepsi_delete();"></th>
					</tr>
				</thead>
				<thead>
					<tr>
						<th class="header_icn_none" style="text-align:left;"><cfoutput>#GET_MODUL.MODULE_SHORT_NAME#</cfoutput><cf_get_lang dictionary_id='52709.FuseActions'></th>
						<th class="header_icn_none" style="text-align:center;" nowrap="nowrap"><cf_get_lang dictionary_id='43968.İzin Tipi'></th>
						<th class="header_icn_none" style="text-align:center;"><cf_get_lang dictionary_id='44843.View'></th>
						<th class="header_icn_none" style="text-align:center;"><cf_get_lang dictionary_id='44844.Insert'></th>
						<th class="header_icn_none" style="text-align:center;"><cf_get_lang dictionary_id='44845.Delete'></th>
					</tr>
				</thead>
				<tbody>
					<cfif get_factions.RECORDCOUNT>
						<cfoutput query="get_factions">
							<cfquery name="control" datasource="#dsn#">
								SELECT 
									DENIED_TYPE,
									IS_VIEW,
									IS_INSERT,
									IS_DELETE 
								FROM 
									EMPLOYEE_POSITIONS_DENIED
								WHERE
									MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#"> AND
									POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.POS_CODE#"> AND
									FUSEACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#wrk_objects_id#">
							</cfquery>
							<tr>
								<td>#fuseaction#</td>
								<td style="text-align:center;"><input type="checkbox" name="denied_type_#wrk_objects_id#" id="denied_type_#wrk_objects_id#" value="#wrk_objects_id#" <cfif (CONTROL.RECORDCOUNT) AND (CONTROL.DENIED_TYPE EQ 1)>checked </cfif>></td>
								<td style="text-align:center;"><input type="checkbox" name="is_view_#wrk_objects_id#" id="is_view_#wrk_objects_id#" value="#wrk_objects_id#" <cfif (CONTROL.RECORDCOUNT) AND (CONTROL.IS_VIEW EQ 1)>checked </cfif>></td>
								<td style="text-align:center;"><input type="checkbox" name="is_insert_#wrk_objects_id#" id="is_insert_#wrk_objects_id#" value="#wrk_objects_id#" <cfif (CONTROL.RECORDCOUNT) AND (CONTROL.IS_INSERT EQ 1)>checked</cfif>></td>
								<td style="text-align:center;"><input type="checkbox" name="is_delete_#wrk_objects_id#" id="is_delete_#wrk_objects_id#" value="#wrk_objects_id#"  <cfif (CONTROL.RECORDCOUNT) AND (CONTROL.IS_DELETE EQ 1)>checked </cfif>></td>
							</tr>
						</cfoutput>
					</cfif>
					<input type="hidden" name="list_pos_denied" id="list_pos_denied" value="<cfoutput>#valuelist(get_factions.wrk_objects_id)#</cfoutput>">
				</tbody>
			</cf_grid_list>
			<cf_box_footer>
				<cfif #attributes.faction_id# neq 0>
					<cf_workcube_buttons 
						is_upd='0'
						is_delete='1'
						delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_user_denied_emp&faction_id=#faction_id#&module_id=#attributes.ID#&pos_code=#pos_code#'>
				<cfelse>	
					<cf_workcube_buttons 
						is_upd='0'
						is_delete='0'
						delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_user_denied_emp&module_id=#attributes.ID#&pos_code=#pos_code#'>
				</cfif> 
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script>
function hepsi_view()
{
	if (document.user_emp.all_view.checked)
		{
			<cfoutput query="get_factions">
				document.user_emp.is_view_#wrk_objects_id#.checked = true;
			</cfoutput>
	     }
	 else
	     {
		  <cfoutput query="get_factions">
				document.user_emp.is_view_#wrk_objects_id#.checked = false;
		</cfoutput>
		 }
}
function hepsi_denied_type()
{
	if (document.user_emp.all_denied.checked)
		{
			<cfoutput query="get_factions">
				document.user_emp.denied_type_#wrk_objects_id#.checked = true;
			</cfoutput>
	     }
	 else
	     {
		  <cfoutput query="get_factions">
				document.user_emp.denied_type_#wrk_objects_id#.checked = false;
		</cfoutput>
		 }
}
 function hepsi_insert()
 {
   
    if (document.user_emp.all_insert.checked) 
		{
		 <cfoutput query="get_factions">
				document.user_emp.is_insert_#wrk_objects_id#.checked = true;
		</cfoutput>
        }
	 else
	     {
		  <cfoutput query="get_factions">
				document.user_emp.is_insert_#wrk_objects_id#.checked = false;
		</cfoutput>
		 }
 }
 
 function hepsi_delete()
 {
		
	if (document.user_emp.all_delete.checked)
	    {	
		  <cfoutput query="get_factions">
				document.user_emp.is_delete_#wrk_objects_id#.checked = true;
		</cfoutput>
		}
	else
		{
		  <cfoutput query="get_factions">
				document.user_emp.is_delete_#wrk_objects_id#.checked = false;
		</cfoutput>
		}
}
</script>

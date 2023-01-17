<cfif not isdefined("attributes.id")>
	<cfexit method="exittemplate">
</cfif>
<cfquery name="get_emp_name" datasource="#dsn#">
	SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.POS_CODE#">
</cfquery>
<cfset NAME = '#get_emp_name.EMPLOYEE_NAME# #get_emp_name.employee_surname#'>
<cfquery name="GET_MODULE_NAME" datasource="#DSN#">
	SELECT MODULE_SHORT_NAME FROM MODULES WHERE MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
</cfquery>
<cfquery name="GET_FACTION" datasource="#DSN#">
	SELECT 
		WRK_OBJECTS_ID,
		FUSEACTION
	FROM
		WRK_OBJECTS
	WHERE
		MODUL_SHORT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#GET_MODULE_NAME.MODULE_SHORT_NAME#%">
	ORDER BY
		FUSEACTION
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfform name="add_faction" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_perm_faction_emp">
		<cfoutput>
			<input type="hidden" name="EMP_NAME" id="EMP_NAME" value="#NAME#">
			<input type="hidden" name="POS_CODE" id="POS_CODE" value="#attributes.POS_CODE#">
			<input type="hidden" name="module_id" id="module_id" value="#attributes.id#">
			<input type="hidden" name="position_cat_id" id="position_cat_id" value="#get_emp_name.POSITION_CAT_ID#">
		</cfoutput>
		<cf_box title="#getLang('','Yetki Grupları','42144')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
			<cf_box_search more="0">
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
						<th class="header_icn_none" style="text-align:left;"><cfoutput>#GET_MODULE_NAME.MODULE_SHORT_NAME#</cfoutput> Fuseactions</th>
						<th class="header_icn_none" style="text-align:center;" nowrap="nowrap"><cf_get_lang dictionary_id='43968.İzin Tipi'></th>
						<th class="header_icn_none" style="text-align:center;"><cf_get_lang dictionary_id='44843.View'></th>
						<th class="header_icn_none" style="text-align:center;"><cf_get_lang dictionary_id='44844.Insert'></th>
						<th class="header_icn_none" style="text-align:center;"><cf_get_lang dictionary_id='44845.Delete'></th>
					</tr>
				</thead>
				<tbody>
					<cfif GET_FACTION.RECORDCOUNT>
						<cfoutput query="GET_FACTION">
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
								<td style="text-align:center;"><input type="checkbox" name="denied_type_#wrk_objects_id#" id="denied_type_#wrk_objects_id#" value="#wrk_objects_id# <cfif (CONTROL.RECORDCOUNT) AND (CONTROL.DENIED_TYPE EQ 1)>checked</cfif>"></td>
								<td style="text-align:center;"><input type="checkbox" name="is_view_#wrk_objects_id#" id="is_view_#wrk_objects_id#" value="#wrk_objects_id#" <cfif (CONTROL.RECORDCOUNT) AND (CONTROL.IS_VIEW EQ 1)>checked</cfif>></td>
								<td style="text-align:center;"><input type="checkbox" name="is_insert_#wrk_objects_id#" id="is_insert_#wrk_objects_id#" value="#wrk_objects_id#" <cfif (CONTROL.RECORDCOUNT) AND (CONTROL.IS_INSERT EQ 1)>checked</cfif>></td>
								<td style="text-align:center;"><input type="checkbox" name="is_delete_#wrk_objects_id#" id="is_delete_#wrk_objects_id#" value="#wrk_objects_id#" <cfif (CONTROL.RECORDCOUNT) AND (CONTROL.IS_DELETE EQ 1)>checked</cfif>></td>
							</tr>
						</cfoutput>
					</cfif>
					<input type="hidden" name="list_pos_denied" id="list_pos_denied" value="<cfoutput>#valuelist(get_faction.wrk_objects_id)#</cfoutput>">
				</tbody>
			</cf_grid_list>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' >
			</cf_box_footer>
		</cf_box>
	</cfform>
</div>
<script type="text/javascript">
function hepsi_view()
{
	if (document.add_faction.all_view.checked)
		{
			<cfoutput query="GET_FACTION">
				document.add_faction.is_view_#wrk_objects_id#.checked = true;
			</cfoutput>
	     }
	 else
	     {
			<cfoutput query="GET_FACTION">
				document.add_faction.is_view_#wrk_objects_id#.checked = false;
			</cfoutput>
			
		 }
}
function hepsi_denied_type()
{
	if (document.add_faction.all_denied.checked)
		{
			<cfoutput query="GET_FACTION">
				document.add_faction.denied_type_#wrk_objects_id#.checked = true;
			</cfoutput>
	     }
	 else
	     {
			<cfoutput query="GET_FACTION">
				document.add_faction.denied_type_#wrk_objects_id#.checked = false;
			</cfoutput>
		 }
}
 function hepsi_insert()
 {
   
    if (document.add_faction.all_insert.checked) 
		{
			<cfoutput query="GET_FACTION">
				document.add_faction.is_insert_#wrk_objects_id#.checked = true;
			</cfoutput>

        }
	 else
	     {
			<cfoutput query="GET_FACTION">
				document.add_faction.is_insert_#wrk_objects_id#.checked = false;
			</cfoutput>
		 }
 }
 
 function hepsi_delete()
 {
		
	if (document.add_faction.all_delete.checked)
	    {	
			<cfoutput query="GET_FACTION">
				document.add_faction.is_delete_#wrk_objects_id#.checked = true;
			</cfoutput>
		}
	else
		{
			<cfoutput query="GET_FACTION">
				document.add_faction.is_delete_#wrk_objects_id#.checked = false;
			</cfoutput>
		}
}
</script>

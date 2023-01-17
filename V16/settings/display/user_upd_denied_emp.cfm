<script type="text/javascript">
function send_to_frame(module_id,pos_code)
{
	add_faction.id.value = module_id;
	<!---add_faction.pos_code.value = pos_code;--->
	add_faction.target='molule_ids';
	add_faction.action='<cfoutput>#request.self#?fuseaction=settings.popup_user_denied_emp1&iframe=1</cfoutput>';
	add_faction.submit();
	add_faction.target='_self';
	add_faction.action='<cfoutput>#request.self#?fuseaction=settings.emptypopup_add_perm_faction_emp1</cfoutput>';
}
</script>
<cfquery name="get_emp_name" datasource="#dsn#">
	SELECT 
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME 
	FROM 
		EMPLOYEE_POSITIONS 
	WHERE 
		POSITION_CODE = #URL.pos_code#
</cfquery>
<cfset NAME = '#get_emp_name.EMPLOYEE_NAME# #get_emp_name.employee_surname#'>
<cfquery name="get_moduls" datasource="#dsn#">
	SELECT M.MODULE_ID,
			MODULE_NAME,
			MODULE_SHORT_NAME 
	FROM 
	 	MODULES M,
		SETUP_LANGUAGE_TR SL
	ORDER BY MODULE_NAME
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_catalystHeader>
	<cf_box scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_faction" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_denied_emp&pos_code=#URL.pos_code#">
			<cfset list=''>   
			<cf_box_search more="0">
				<div class="form-group">
					<cf_get_lang_main no='164.Çalışan'>
				</div>
				<div class="form-group">
					<input type="text" name="EMP_NAME" id="EMP_NAME" value="<cfoutput>#NAME#</cfoutput>" style="width:150px;" readonly="yes">
					<input type="hidden" name="POS_CODE" id="POS_CODE" value="<cfoutput>#URL.pos_code#</cfoutput>">
				</div>
			</cf_box_search>
			<cf_grid_list>
				<thead>
					<th colspan="3"><cf_get_lang dictionary_id='33110.Modüller'></th>
				</thead>
				<tbody>			
					<cfoutput query="get_moduls">
						<cfif ((currentrow mod 3) eq 1)>
							<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						</cfif> 
							<td><a href="javascript://" onClick="gonder_popup('#module_id#');return false" class="tableyazi">#MODULE_SHORT_NAME#</a></td>
						<cfif (currentrow mod 3 eq 0)>
							</tr>
						</cfif>	
					</cfoutput>	
					<input type="hidden" name="LIST" id="LIST" value="<cfoutput>#valuelist(get_moduls.MODULE_ID)#</cfoutput>">
					<input type="hidden" name="id" id="id" value="">
				</tbody>
			</cf_grid_list>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function gonder_popup(module_id)
  {
  	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_user_denied_emp1&id=' + module_id + '&pos_code=' + add_faction.POS_CODE.value + '&faction_id=' + <cfoutput>#attributes.faction_id#</cfoutput>);
  }
</script>


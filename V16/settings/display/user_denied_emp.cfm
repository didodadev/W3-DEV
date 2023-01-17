<cfquery name="get_moduls" datasource="#dsn#">
	SELECT MODULE_ID,MODULE_SHORT_NAME FROM MODULES ORDER BY MODULE_NAME
</cfquery>

<cfif isDefined("URL.CONT") and len(URL.CONT)>
	<cfquery name="GET_POS_CODE" datasource="#DSN#">
		SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #URL.CONT#
	</cfquery>
</cfif>

<script type="text/javascript">
function send_to_frame(module_id)
{
	 if (faction_add.pos_code.value.length == 0)
		{
		alert("<cf_get_lang dictionary_id='56649.Çalışan Seçiniz'> !");
		return false;
		}
	add_faction.id.value = module_id;
	add_faction.target='molule_ids';
	add_faction.action='<cfoutput>#request.self#?fuseaction=settings.popup_user_denied_emp&iframe=1</cfoutput>';
	add_faction.submit();
	add_faction.target='_self';
	add_faction.action='<cfoutput>#request.self#?fuseaction=settings.emptypopup_add_perm_faction_emp</cfoutput>';
 
}
</script>

<cfoutput>
	<cfif isdefined('attributes.pos_code') and len(attributes.pos_code)>
		<cfset href= '#request.self#?fuseaction=settings.user_denied_emp&pos_code=#attributes.pos_code#'>
	<cfelse>
		<cfset href= '#request.self#?fuseaction=settings.user_denied_emp'>
	</cfif>
</cfoutput>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_catalystHeader>
	<cf_box scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"><!---Çalışan Yetki Kısıtları--->
		<cfform name="faction_add" method="post" action="#href#">
			<cf_box_search more="0">
				<div class="form-group">
					<div class="input-group">
						<cfif isDefined("URL.CONT") and len(URL.CONT)>
							<input type="text" name="EMP_NAME" id="EMP_NAME"  value="<cfoutput>#GET_POS_CODE.EMPLOYEE_NAME# #GET_POS_CODE.EMPLOYEE_SURNAME#</cfoutput>" onFocus="AutoComplete_Create('EMP_NAME','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','pos_code','','3','150');">
							<input type="hidden" name="pos_code" id="pos_code" value="<cfoutput>#URL.CONT#</cfoutput>">
						<cfelse>
							<input type="text" name="EMP_NAME" id="EMP_NAME" placeholder="<cfoutput>#getLang('main','Çalışan',57576)#</cfoutput>" value="<cfif isdefined("attributes.EMP_NAME")><cfoutput>#attributes.EMP_NAME#</cfoutput></cfif>" onFocus="AutoComplete_Create('EMP_NAME','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','pos_code','','3','150');">
							<input type="hidden" name="pos_code" id="pos_code" value="<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>"/>
						</cfif>
						<cfif not listfindnocase(denied_pages,'settings.popup_emp_list')>
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=settings.popup_emp_list&field_pos_code=faction_add.pos_code&field_name=faction_add.EMP_NAME</cfoutput>');"></span>
						</cfif>
					</div>
				</div>   
			</cf_box_search>
			<cf_grid_list>
				<thead>
					<tr>
						<th colspan="3"><cf_get_lang dictionary_id='52900.Moduller'></th>
					</tr>
				</thead>
				<tbody>
					<cfset son_satir = get_moduls.recordcount>
					<cfoutput query="get_moduls">
						<cfif ((currentrow mod 3) eq 1)>
							<tr>
						</cfif>  
						<cfif son_satir eq currentrow> <!--- Son satırda eksik kalan hucrelere colspan atamasi icin eklendi --->
							<cfif currentrow mod 3 eq 0>
								<cfset colspan_ = 1>
							<cfelseif currentrow mod 3 eq 1>
								<cfset colspan_ = 3>
							<cfelse>
								<cfset colspan_ = 2>
							</cfif>
						<cfelse>
							<cfset colspan_ = 1>
						</cfif>
						<td colspan="#colspan_#">
							<a href="javascript://" onClick="gonder_popup('#module_id#');return false" class="tableyazi">#MODULE_SHORT_NAME#</a>
							<input type="hidden" name="module_id" id="module_id" value="#MODULE_ID#">
						</td>
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
  function kontrol()
  { 
  if (faction_add.pos_code.value.length == 0)
		{
		alert("<cf_get_lang dictionary_id='56649.Çalışan Seçiniz'> !");
		return false;
		}
  }
  function gonder_popup(module_id)
  {
  	if(faction_add.pos_code.value==""){alert("<cf_get_lang dictionary_id='56649.Çalışan Seçiniz'>!");return false;}
  	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_user_denied_emp&id=' + module_id + '&pos_code=' + faction_add.pos_code.value);
  }
</script>

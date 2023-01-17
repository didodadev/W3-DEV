<cfset get_components = createObject("component", "V16.objects2.career.cfc.add_select_emp")>
<cfset GET_SETUP_WARNING = get_components.GET_SETUP_WARNING()>

<cfloop list="#attributes.list_empapp_id#" index="bas" delimiters=",">
	<cfif listvaluecount(attributes.list_empapp_id,bas,',') gt 1>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='35490.More than one record of the same resume is selected. Please check.'>!");
			window.close();
		</script>
		<cfabort>
	</cfif>
</cfloop>

<cfform name="add_list" method="post">
	<cfif not isdefined('attributes.old')>
		<input name="record_num" id="record_num" type="hidden" value="0">
		<input name="record_count" id="record_count" type="hidden" value="0">
		<table cellSpacing="0" cellpadding="0" border="0" width="100%" height="100%" align="center">
		<tr class="color-border">
		<td>
			<table cellspacing="1" cellpadding="2" width="100%" height="100%" border="0">
				<tr class="color-row">
					<td height="35" class="headbold">&nbsp;<cf_get_lang dictionary_id='35093.Create Selection List'></td>
				</tr>
				<tr class="color-row">
					<td valign="top"> 
					<table>
						<tr>
							<td width="90"><cf_get_lang dictionary_id='57493.Active'></td>
							<td><input type="checkbox"  name="list_status" id="list_status" value="1"></td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='57480.Subject'></td>
							<cfsavecontent variable="alert"><cf_get_lang dictionary_id='35491.Please Enter List Name'></cfsavecontent>
							<td><cfinput type="text" name="list_name" style="width:250px;" value="" required="yes" message="#alert#"></td>
						</tr>
						<tr>
							<td><cf_get_lang_main no='217.Açıklama'></td>
							<td><textarea name="list_detail" id="list_detail" style="width:250px;height:50px"></textarea></td>
						</tr>				
						<tr>
							<td><cf_get_lang dictionary_id='35072.Job Posting'></td>
							<td><input type="hidden" name="notice_id_list" id="notice_id_list" value="<cfif isdefined('attributes.notice_head') and isdefined('attributes.notice_id')><cfoutput>#attributes.notice_id#</cfoutput></cfif>">
								<input type="text" name="notice_head_list" id="notice_head_list" value="<cfif isdefined('attributes.notice_head') and isdefined('attributes.notice_id')><cfoutput>#attributes.notice_head#</cfoutput></cfif>" style="width:150px;">
								<a href="javascript://" title="<cf_get_lang dictionary_id='35242.Adverts'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_list_notices&field_id=add_list.notice_id_list&field_name=add_list.notice_head_list','list');"><img src="/images/plus_list.gif"  align="absmiddle" border="0" alt="<cf_get_lang no='921.İlanlar'>" /></a> 
							</td>
						</tr>
						<!--- <tr>
							<td width="85">Pozisyon</td>
							<td><input type="text" name="app_position_list" style="width:150px;" value="<!--- <cfoutput>#attributes.app_position#</cfoutput> --->"></td>
						</tr> --->
						<tr>
							<td></td>
							<td height="30">
								<!--- <cf_workcube_buttons is_upd='0' add_function='kontrol()'> --->
								<cf_workcube_buttons is_insert='1' data_action="/V16/objects2/career/cfc/add_select_emp:add_emp_app_select_list" next_page="#request.self#" >

							</td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
		</td>
		</tr>
		</table>
	<cfelseif isdefined('attributes.old') and attributes.old eq 1>
		<!--- <cfform name="add_list" action="#request.self#?fuseaction=hr.emptypopup_add_select_emp_list#url_str2#" method="post"> --->
		<input type="hidden" name="old" id="old" value="1">
		<table cellSpacing="0" cellpadding="0" border="0" width="100%" height="100%" align="center">
		<tr class="color-border">
		<td>
			<table cellspacing="1" cellpadding="2" width="100%" height="100%" border="0">
				<tr class="color-row">
					<td height="35" class="headbold">&nbsp;<cf_get_lang dictionary_id='35094.Add to Existing Selection List'></td>
				</tr>
				<tr class="color-row">
					<td valign="top"> 
					<table>
						<tr>
							<td><cf_get_lang dictionary_id='35095.Selection List'>*</td>
							<td>
								<input type="hidden" name="list_id" id="list_id" value="">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='35096.Please Choose Selection List'></cfsavecontent>
								<cfinput type="text" name="list_name" value="" required="yes" message="#message#" style="width:250px;">
								<a href="javascript://" title="<cf_get_lang dictionary_id='35095.Selection List'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_list_select_list&field_id=add_list.list_id&field_name=add_list.list_name</cfoutput>','list');" ><img src="../../images/plus_list.gif" border="0" alt="<cf_get_lang dictionary_id='35095.Selection List'>" /></a>
							</td>
						</tr>
						<tr>
							<td></td>
							<td height="30">
								<cf_workcube_buttons is_insert='1' data_action="/V16/objects2/career/cfc/add_select_emp:add_emp_app_select_list" next_page="#request.self#" >

							</td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
		</td>
		</tr>
		</table>
	</cfif>
	<!--- arama kriterleri urlden uzun olduğu için form oalrk yolanyor--->
	<cfoutput>
	<input type="hidden" name="list_app_pos_id" id="list_app_pos_id" value="#attributes.list_app_pos_id#">
	<input type="hidden" name="list_empapp_id" id="list_empapp_id" value="#attributes.list_empapp_id#">
	<input type="hidden" name="search_app_pos" id="search_app_pos" value="#attributes.search_app_pos#"></td>
	<input type="hidden" name="status_app_pos" id="status_app_pos" value="#attributes.status_app_pos#">
	<input type="hidden" name="date_status" id="date_status" value="#attributes.date_status#">
	<!--- <input type="hidden" name="app_position" value="#attributes.app_position#"> --->
	<input type="hidden" name="notice_id" id="notice_id" value="#attributes.notice_id#">
	<input type="hidden" name="notice_head" id="notice_head" value="#attributes.notice_head#">
	<input type="hidden" name="company_id" id="company_id" value="#session.pp.company_id#">
	<input type="hidden" name="company" id="company" value="#session.pp.company#">
	<input type="hidden" name="our_company_id" id="our_company_id" value="#session.pp.our_company_id#">	
	<input type="hidden" name="app_date1" id="app_date1" value="#attributes.app_date1#">
	<input type="hidden" name="app_date2" id="app_date2" value="#attributes.app_date2#">
	<input type="hidden" name="prefered_city" id="prefered_city" value="#attributes.prefered_city#">
	<input type="hidden" name="salary_wanted1" id="salary_wanted1" value="#attributes.salary_wanted1#">
	<input type="hidden" name="salary_wanted2" id="salary_wanted2" value="#attributes.salary_wanted2#">
	<input type="hidden" name="salary_wanted_money" id="salary_wanted_money" value="#attributes.salary_wanted_money#">
	<input type="hidden" name="search_app" id="search_app" value="#attributes.search_app#">
	<input type="hidden" name="status_app" id="status_app" value="#attributes.status_app#">
	<input type="hidden" name="app_name" id="app_name" value="#attributes.app_name#">
	<input type="hidden" name="app_surname" id="app_surname" value="#attributes.app_surname#">
	<input type="hidden" name="birth_date1" id="birth_date1" value="#attributes.birth_date1#">
	<input type="hidden" name="birth_date2" id="birth_date2" value="#attributes.birth_date2#">
	<input type="hidden" name="birth_place" id="birth_place" value="#attributes.birth_place#">
	<input type="hidden" name="married" id="married" value="#attributes.married#">
	<input type="hidden" name="city" id="city"  value="#attributes.city#">
	<input type="hidden" name="sex" id="sex" value="#attributes.sex#">
	<input type="hidden" name="martyr_relative" id="martyr_relative" value="#attributes.martyr_relative#">
	<input type="hidden" name="is_trip" id="is_trip" value="#attributes.is_trip#">
	<input type="hidden" name="driver_licence" id="driver_licence" value="#attributes.driver_licence#">
	<input type="hidden" name="driver_licence_type" id="driver_licence_type" value="#attributes.driver_licence_type#">
	<input type="hidden" name="sentenced" id="sentenced" value="#attributes.sentenced#">
	<input type="hidden" name="defected" id="defected" value="#attributes.defected#">
	<input type="hidden" name="defected_level" id="defected_level" value="#attributes.defected_level#">
	<input type="hidden" name="email" id="email" value="#attributes.email#">
	<input type="hidden" name="military_status" id="military_status" value="#attributes.military_status#">
	<input type="hidden" name="homecity" id="homecity" value="#attributes.homecity#">
	<input type="hidden" name="training_level" id="training_level" value="#attributes.training_level#">
	<input type="hidden" name="edu_finish" id="edu_finish" value="#attributes.edu_finish#">
	<input type="hidden" name="exp_year_s1" id="exp_year_s1" value="#attributes.exp_year_s1#">
	<input type="hidden" name="exp_year_s2" id="exp_year_s2" value="#attributes.exp_year_s2#">
	<input type="hidden" name="lang" id="lang" value="#attributes.lang#">
	<input type="hidden" name="lang_level" id="lang_level" value="#attributes.lang_level#">
	<input type="hidden" name="lang_par" id="lang_par" value="#attributes.lang_par#">
	<input type="hidden" name="edu3_part" id="edu3_part" value="#attributes.edu3_part#">
	<input type="hidden" name="edu4_id" id="edu4_id" value="#attributes.edu4_id#">
	<input type="hidden" name="edu4_part_id" id="edu4_part_id" value="#attributes.edu4_part_id#">
	<input type="hidden" name="edu4" id="edu4" value="#attributes.edu4#">
	<input type="hidden" name="edu4_part" id="edu4_part" value="#attributes.edu4_part#">
	<input type="hidden" name="unit_id" id="unit_id" value="#attributes.unit_id#">
	<input type="hidden" name="unit_row" id="unit_row" value="<cfif isdefined("attributes.unit_row") and len(attributes.unit_row)>#attributes.unit_row#</cfif>">
	<input type="hidden" name="referance" id="referance" value="#attributes.referance#">
	<input type="hidden" name="tool" id="tool" value="#attributes.tool#">
	<input type="hidden" name="kurs" id="kurs" value="#attributes.kurs#">
	<input type="hidden" name="other" id="other" value="#attributes.other#">
	<input type="hidden" name="other_if" id="other_if" value="#attributes.other_if#">
	</cfoutput>
</cfform>
<script type="text/javascript">
function kontrol()
{
	if (add_list.list_detail.value.length>250)
	{
		alert("<cf_get_lang no='776.Detay Alanı 250 Karakterden Fazla Olamaz'>");
		return false;
	}
	return 	process_cat_control();
}
</script>

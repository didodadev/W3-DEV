<!--- İmha Tutanağı Ekleme Sayfası hgul 20110608 --->
<cfquery name="get_fis" datasource="#dsn2#">
	SELECT 
		STOCK_FIS.*,
		STOCK_FIS_ROW.* 
	FROM 
		STOCK_FIS,
		STOCK_FIS_ROW
	WHERE 
		STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID AND
		STOCK_FIS.FIS_ID = #attributes.action_id#
</cfquery>
<cfquery name="get_disposal_result" datasource="#dsn#">
	SELECT * FROM WASTE_DISPOSAL_RESULT WHERE DISPOSAL_ID = #attributes.action_id#
</cfquery>
<cfquery name="GET_CAT" datasource="#DSN#">
	SELECT TEMPLATE_ID,TEMPLATE_HEAD FROM TEMPLATE_FORMS WHERE TEMPLATE_MODULE = 13
</cfquery>
<cfquery name="SETUP_TEMPLATE" datasource="#dsn#">
	SELECT * FROM TEMPLATE_FORMS
	<cfif isDefined("attributes.template_id") and len(attributes.template_id)>		
	WHERE
		TEMPLATE_ID = #attributes.template_id#
	</cfif>
</cfquery>
<table cellspacing="1" cellpadding="2" width="100%" height="100%"  border="0" class="color-border">
	<cfform name="disposal_result" action="#request.self#?fuseaction=objects.emptypopup_add_disposal_report" method="post">
		<input type="hidden" name="header" value="<cfoutput>#get_fis.FIS_NUMBER#</cfoutput>">
		<tr class="color-list">
			<td  height="35" class="headbold" colspan="2">
			<table width="100%">
				<tr>
					<td class="headbold"><cf_get_lang dictionary_id='59042.İmha Tutanağı'></td>
					<td align="right" style="text-align:right;">
						<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.action_id#&print_type=440</cfoutput>','page');"><img src="/images/print.gif" border="0" alt="<cf_get_lang dictionary_id='57474.Yazdır'>" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></a>
					</td>
				</tr>
			</table>
			</td>
		</tr>
		<tr class="color-row">
			<td valign="top" width="500"> 
			<table>
				<tr>
					<td align="right" style="text-align:right;">
						<select name="template_id" style="width:150px;" onchange="_load(this.value);">
							<option value="" selected><cf_get_lang dictionary_id ='58640.Şablon'>
							<cfoutput query="get_cat">
								<option value="#template_id#"<cfif isDefined("attributes.template_id") and (attributes.template_id eq template_id)> selected</cfif>>#TEMPLATE_HEAD# 
							</cfoutput>
						</select>
					</td> 
				</tr>
				<tr>
					<td>
						<cfset tr_topic = get_disposal_result.DISPOSAL_RESULT>
						<cfif isdefined("attributes.corrcat_id")> 
							<cfset tr_topic = SETUP_TEMPLATE.TEMPLATE_CONTENT>
						</cfif>
						<cfmodule
							template="/fckeditor/fckeditor.cfm"
							toolbarSet="Basic"
							basePath="/fckeditor/"
							instanceName="RESULT"
							value="#tr_topic#"
							width="550"
							height="450">
						<input type="hidden" name="disposal_id" value="<cfoutput>#attributes.action_id#</cfoutput>">
					</td>
				</tr>
				<tr>
					<td>
						<cfif not get_disposal_result.recordcount>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57461.Kaydet'></cfsavecontent>
							<cf_workcube_buttons is_upd='0'>
						<cfelse>
							<cf_workcube_buttons 
								is_upd='1'
								delete_page_url='#request.self#?fuseaction=objects.emptypopup_del_disposal_report&disposal_id=#attributes.action_id#'>
						</cfif>
					</td>
				</tr>
				<tr>
					<td>
						<cfif len(get_disposal_result.record_emp)>
							<cf_get_lang dictionary_id='57483.Kayıt'> :
							<cfoutput>#get_emp_info(get_disposal_result.record_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,get_disposal_result.record_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,get_disposal_result.record_date),timeformat_style)#</cfoutput>&nbsp;&nbsp;
						</cfif>
						<cfif len(get_disposal_result.update_emp)>
							<cf_get_lang dictionary_id='57703.Güncelleme'>:<cfoutput>#get_emp_info(get_disposal_result.update_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,get_disposal_result.update_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,get_disposal_result.update_date),timeformat_style)#</cfoutput>
						</cfif>
					</td>
				</tr>
			</table>
			</td>
			<td valign="top">
			<table>
				<tr>
					<td width="250">
						<cf_get_workcube_asset asset_cat_id="-20" module_id='13' action_section='ACTION_ID' action_id='#attributes.action_id#'><br>
					</td>
				</tr>
				<tr>
					<td class="color-list"><cfsavecontent variable="txt_2"><cf_get_lang dictionary_id='57590.Katılımcılar'></cfsavecontent>
						<cf_workcube_to_cc 
							is_update="0"
							to_dsp_name="#txt_2#" 
							form_name="disposal_result" 
							str_list_param="1" 
							data_type="1"
							str_action_names="DISPOSAL_RESULT_EMP AS TO_EMP"
							action_table="WASTE_DISPOSAL_RESULT"
							action_id_name="DISPOSAL_ID"
							action_id="#attributes.action_id#">
					</td> 
				</tr>
				<tr>
					<td id="td_joins" valign="top"><!--- katılımcılar ---></td>
				</tr>
				<tr>
					<td  valign="top" id="gizli1">
						<!--- katılımcılar --->
						<cfset attributes.EMPLOYEE_IDS="">
						<cfif len(get_disposal_result.disposal_result_emp)>
							<cfquery name="GET_EMPLOYEES" datasource="#dsn#">
								SELECT 
									EMPLOYEE_ID,
									EMPLOYEE_NAME, 
									EMPLOYEE_SURNAME
								FROM 
									EMPLOYEE_POSITIONS
								WHERE
									EMPLOYEE_ID IN (#get_disposal_result.disposal_result_emp#)
									AND IS_MASTER = 1
							</cfquery>
							<table>
								<cfoutput query="GET_EMPLOYEES">
									<cfset int_row=currentrow-1>
									<tr id="employees_#int_row#">
										<td>
											<input type="hidden" name="emp_id" value="#employee_id#" />
											<a href="javascript://" onClick="emp_delRow(#int_row#);"><img src="/images/delete_list.gif"  alt="<cf_get_lang dictionary_id='57463.Sil'>" align="absmiddle" border="0"></a>
											#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
										</td>
									</tr>
								</cfoutput>
							</table>
						<cfelseif len(attributes.EMPLOYEE_IDS)>
							<cfquery name="GET_EMPLOYEES" datasource="#dsn#">
								SELECT 
									EMPLOYEE_ID,
									EMPLOYEE_NAME, 
									EMPLOYEE_SURNAME
								FROM 
									EMPLOYEE_POSITIONS
								WHERE
									EMPLOYEE_ID IN (#attributes.EMPLOYEE_IDS#)
									AND IS_MASTER = 1
							</cfquery>
							<cfset attributes.EMPLOYEE_IDS = LISTAPPEND(attributes.EMPLOYEE_IDS,',')>
							<cfoutput query="GET_EMPLOYEES">
								<cfset int_row=currentrow-1>
								<tr id="employees_#int_row#">
									<td>
										<input type="hidden" name="emp_id" value="#employee_id#" />
										<a href="javascript://" onClick="emp_delRow(#int_row#);"><img src="/images/delete_list.gif" alt="<cf_get_lang dictionary_id='57463.Sil'>"  align="absmiddle" border="0"></a>
										#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
									</td>
								</tr>
							</cfoutput>
						</cfif>
					</td>
				</tr>
			</table>
			</td>
		</tr>
	</cfform>
</table>
<script type="text/javascript">
<cfif isdefined("attributes.template_id") and len(attributes.template_id)>
	document.disposal_result.RESULT.value = '<cfoutput>#SETUP_TEMPLATE.TEMPLATE_CONTENT#</cfoutput>';	
</cfif>
function _load(template_id)
{
	var template_id=document.disposal_result.template_id.value;
	if(template_id != null)
		window.open('<cfoutput>#request.self#?fuseaction=objects.popup_add_disposal_report&action_id=#attributes.action_id#</cfoutput>&template_id='+template_id,'_self')
	else 
		return false;
}
function emp_delRow(yer)
{
	flag_custag=document.disposal_result.emp_id.length;
	if(flag_custag > 0)
	{
		try{document.disposal_result.emp_id[yer].value = '';}catch(e){}
	}
	else
	{
		try{document.disposal_result.emp_id.value = '';}catch(e){}
	}
	var my_element = eval("document.getElementById('employees_" + yer + "')");
	my_element.style.display = "none";
}
</script>

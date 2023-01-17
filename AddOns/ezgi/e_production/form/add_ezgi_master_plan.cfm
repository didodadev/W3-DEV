<cfparam name="paper_project_id" default="">
<cfparam name="attributes.detail" default="">
<cfparam name="attributes.shift_id" default="">
<cfparam name="attributes.shift_name" default="">
<cfparam name="attributes.shift" default="">
<cfparam name="attributes.shift_employee_id" default="#session.ep.USERID#">
<cfparam name="attributes.master_plan_status" default="">
<cfsetting showdebugoutput="yes">
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT		PERIOD_ID,
				MONEY,RATE1,
				RATE2 
	FROM 		SETUP_MONEY 
	WHERE 		PERIOD_ID = #session.ep.period_id# 
				AND MONEY_STATUS = 1
</cfquery>
<cfset money_str ='&search_process_date=#DateFormat(now(),"DD/MM/YYYY")#&company_id=1'>
<cfoutput query="GET_MONEY">
<cfset money_str = '#money_str#&#MONEY#=#RATE2#'>
</cfoutput>
<cfquery name="get_master_plan_sablon" datasource="#dsn3#">
	SELECT    	PROCESS_ID, 
				PROCESS_NAME, 
				PAPER_SERIOUS, 
				PAPER_NO, 
				PAPER_NO_LENGTH
	FROM       	EZGI_MASTER_PLAN_SABLON
	WHERE     	(PROCESS_ID = 1)
</cfquery>

<table border="0" width="98%" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td height="35" class="headbold"><cf_get_lang_main no='3345.Üretim Master Planı Ekle'></td>
	</tr>
</table>
<cfoutput>
	<table width="98%" height="92%" cellpadding="2" cellspacing="1" class="color-border" align="center">
		<tr>
			<td valign="top" class="color-row">
				<cfform name="add_shift" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_ezgi_master_plan">
				<table>
					<tr height="15">
						<td width="90"><cf_get_lang_main no='3199.Master Plan Adı'>*</td>
						<td width="250">
							<input type="hidden" name="shift_id" id="shift_id" value="<cfif isdefined("shift_id") and len(shift_id)>#shift_id#</cfif>">
							<input type="text" name="shift_name" id="shift_name" value="<cfif isdefined("shift_name") and len(shift_name)>#shift_name#</cfif>" style="width:175px;" >
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_list_ezgi_shift&field_name=shift_name&field_id=shift_id','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>	</td>
						<td width="90"><cf_get_lang_main no='243.Baslama Tarihi'> *</td>
						<td width="250">
						<cfsavecontent variable="message"><cf_get_lang no ='383.Baslama Tarihi Girmelisiniz'> !</cfsavecontent>
						<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
							<input required="Yes" message="#message#" type="text" name="start_date" id="start_date"  validate="eurodate" style="width:100px;" value="#dateformat(attributes.start_date,'DD/MM/YYYY')#"> 
						<cfelse>
							<input required="Yes" message="#message#" type="text" name="start_date" id="start_date"  validate="eurodate" style="width:100px;" value="">
						</cfif>
						<cf_wrk_date_image date_field="start_date">
						</td>
						<td>&nbsp;</td>
						<td><input type="checkbox" name="master_plan_status" checked="checked" value="1"><cf_get_lang_main no='81.Aktif'></td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='3346.Planı Ekleyen'>*</td>
						<td><input type="hidden" name="shift_employee_id" id="shift_employee_id" value="<cfif Len(attributes.shift_employee_id)>#attributes.shift_employee_id#</cfif>">
							<input type="text" name="shift_employee" id="shift_employee" value="<cfif Len(attributes.shift_employee_id)>#get_emp_info(attributes.shift_employee_id,0,0)#</cfif>" style="width:175px;" onFocus="AutoComplete_Create('shift_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','shift_employee_id','','3','125');" autocomplete="off">
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=shift_employee_id&field_name=shift_employee&select_list=1','list','popup_list_positions');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></td>
                      	<td width="90"><cf_get_lang_main no='288.Bitis Tarihi '> *</td>
                        <td width="250">
						<cfsavecontent variable="message"><cf_get_lang no ='327.Bitis Tarihi Girmelisiniz '> !</cfsavecontent>
						<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
							<input required="Yes" message="#message#" type="text" name="finish_date" id="finish_date"  validate="eurodate" style="width:100px;" value="#dateformat(attributes.finish_date,'DD/MM/YYYY')#"> 
						<cfelse>
							<input required="Yes" message="#message#" type="text" name="finish_date" id="finish_date"  validate="eurodate" style="width:100px;" value="">
						</cfif>
						<cf_wrk_date_image date_field="finish_date">
						</td>      
						
						<td><cf_get_lang_main no='4.Proje'></td>
						<td>
							<input type="hidden" name="project_id" id="project_id" value="#paper_project_id#">
							<input type="text" name="project_head" id="project_head" value="<cfif len(paper_project_id)>#GET_PROJECT_NAME(paper_project_id)#</cfif>" style="width:200px;"onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','135')"autocomplete="off">
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_production_order.project_id&project_head=add_production_order.project_head','list');"><img src="/images/plus_list.gif" align="absmiddle" border="0"></a>					</tr>
					<tr>
						<td><cf_get_lang_main no='468.Belge No'>*</td>
						<td>
							<input name="paper_serious" type="text" readonly="" value="#Trim(get_master_plan_sablon.PAPER_SERIOUS)#" maxlength="1" style="width:30px;" />
							<input name="paper_number" type="text"  value="#get_master_plan_sablon.PAPER_NO#" maxlength="15" style="width:80px;" />						</td>
						<td><cf_get_lang_main no='642.Süreç/Asama'></td>
						<td><cf_workcube_process is_upd='0' process_cat_width='125' is_detail='0'></td>
						<td valign="top"><cf_get_lang_main no='217.Açiklama'></td>
						<td rowspan="2"><textarea name="detail" id="detail" style="width:200px;height:50px;"><cfif isdefined("attributes.order_row_id")>#get_amount.order_detail#</cfif></textarea></td>				
					</tr>
					<tr>

						<td height="30">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="5"></td>
						<td align="left" ><cf_workcube_buttons is_upd='0' add_function ='kontrol_shift_tree_info()'></td>
					</tr>
				</table>
				</cfform>
			</td>
		</tr>
		<tr class="color-row" height="80%">
			<td valign="top"><div id="SHIFT_TREE"></div></td>
		</tr>
	</table>
<script language="JavaScript">
function kontrol_shift_tree_info()
{
	if(document.getElementById('shift_id').value == "")
	{
		alert("<cf_get_lang_main no='3347.Lütfen Master Plan Seçiniz'>!");
		return false;
	}
	if((document.getElementById('start_date').value != "") && (document.getElementById('finish_date').value != ""))
	return time_check(document.getElementById('start_date'), document.getElementById('start_h'), document.getElementById('start_m'), document.getElementById('finish_date'),  document.getElementById('finish_h'), document.getElementById('finish_m'), "<cf_get_lang_main no='3348.Başlama ve Bitiş Tarihlerini Kontrol Ediniz'> !");
	else
	{alert("<cf_get_lang_main no='3348.Başlama ve Bitiş Tarihlerini Kontrol Ediniz'>");return false;}
	return true;
}
</script>
</cfoutput>
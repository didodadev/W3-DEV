<!---
    File: V16\hr\ehesap\display\view_hourly_addfare_percantege.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 08.06.2021
    Description: Ödenek PDKS
        
    History:
        
    To Do:

--->
<cfsetting showdebugoutput="no">
<cfparam name="attributes.department_id" default="">
<cfscript>
	last_month_1 = CreateDateTime(session.ep.period_year, attributes.sal_mon,1,0,0,0);
	last_month_30 = CreateDateTime(session.ep.period_year, attributes.sal_mon,daysinmonth(last_month_1),23,59,59);
	resmi_tatil_gunleri = '';
</cfscript>
<cfset cmp_process = createObject('component','V16.workdata.get_process')>
<cfset get_component = createObject("component","V16.hr.ehesap.cfc.hourly_addfare_percantege")>
<cfset GET_CALENDER_OFFTIMES_ = get_component.GET_CALENDER_OFFTIMES()>

<cfif GET_CALENDER_OFFTIMES_.recordcount>	
	<cfoutput query="GET_CALENDER_OFFTIMES_">
		<cfset off_name_ = OFFTIME_NAME>
		<cfset day_count = DateDiff("d",GET_CALENDER_OFFTIMES_.START_DATE,GET_CALENDER_OFFTIMES_.FINISH_DATE) + 1>
			<cfloop index="k" from="1" to="#day_count#">
				<cfset current_day = date_add("d", k-1, GET_CALENDER_OFFTIMES_.START_DATE)>
				<cfif not (year(now()) eq year(current_day) and month(now()) eq month(current_day) and day(now()) eq day(current_day))>
					<cfset resmi_tatil_gunleri = listappend(resmi_tatil_gunleri,"#dateformat(current_day,'yyyymmdd')#")>
				</cfif>
			</cfloop>
	</cfoutput>
</cfif>

<cfinclude template="../../query/get_emp_codes.cfm">
<cfset aydaki_gun_sayisi = daysinmonth(createdate(session.ep.period_year,attributes.sal_mon,01))>
<cfset GET_SSK_EMPLOYEES = get_component.GET_SSK_EMPLOYEES(
	ssk_office : attributes.ssk_office,
	department_id : attributes.department_id,
	sal_mon : attributes.sal_mon,
	emp_code_list : emp_code_list,
	ssk_statue : attributes.ssk_statue,
	statue_type : attributes.statue_type
)>

<cfif not GET_SSK_EMPLOYEES.RecordCount>
    <script>alert("<cf_get_lang dictionary_id='33572.Çalışan bulunamadı'>!");</script>
    <cfabort>
</cfif>
<cfset get_all_izin = get_component.get_all_izin(
	branch_id : GET_SSK_EMPLOYEES.BRANCH_ID,
	last_month_30 : last_month_30,
	last_month_1 : last_month_1,
	employee_id : valuelist(GET_SSK_EMPLOYEES.employee_id)
)>

<cfset get_all_ins = get_component.get_all_ins(
	last_month_30 : last_month_30, 
	last_month_1 : last_month_1,
	ssk_office : attributes.ssk_office, 
	ssk_statue : attributes.ssk_statue,
	statue_type : attributes.statue_type
)>
<cfset get_allowance = get_component.get_allowance(ssk_statue: attributes.ssk_statue, statue_type: attributes.statue_type)>

<cfoutput query="get_all_ins">
	<!--- <cfset 'min_work_hour_#in_out_id#' = MIN_WORK_HOUR> --->
	<cfset 'total_work_hour_#in_out_id#_#ALLOWANCE_ID#' = TOTAL_WORK_HOUR>
	<cfset 'daily_working_hour_#in_out_id#_#day(START_DATE)#_#ALLOWANCE_ID#' = DAILY_WORKING_HOUR>
	<cfset 'allowance_#in_out_id#' = ALLOWANCE_ID>
</cfoutput>
<cfform name="branch_pdks" action="" method="post">
	<cf_box_elements>
		<div class="col col-12 col-xs-12">
			<div class="form-group">
				<label class="col col-2"><cf_get_lang dictionary_id='64687.M.S.'>  : <cf_get_lang dictionary_id='63068.Minimum Çalışma Saati'> - <cf_get_lang dictionary_id='46633.Ders'></label>
				<label class="col col-2"><cf_get_lang dictionary_id='64688.T.S.'> : <cf_get_lang dictionary_id='33352.Toplam Çalışma Saat'> - <cf_get_lang dictionary_id='46633.Ders'></label>
			</div>
		</div>
	</cf_box_elements>
	<cf_grid_list>
		<input type="hidden" value="<cfoutput>#GET_SSK_EMPLOYEES.recordcount#</cfoutput>" name="kayit_sayisi" id="kayit_sayisi">
		<input type="hidden" value="<cfoutput>#attributes.SAL_MON##SESSION.EP.PERIOD_YEAR##attributes.SSK_OFFICE##attributes.department_id##attributes.ssk_statue##statue_type#</cfoutput>" name="special_code" id="special_code">
		<input type="hidden" value="<cfoutput>#attributes.SAL_MON#</cfoutput>" name="sal_mon" id="sal_mon">
		<input type="hidden" value="<cfoutput>#SESSION.EP.PERIOD_YEAR#</cfoutput>" name="sal_year" id="sal_year">
		<input type="hidden" value="<cfoutput>#aydaki_gun_sayisi#</cfoutput>" name="gun_sayisi" id="gun_sayisi">
		<input type="hidden" value="<cfoutput>#attributes.ssk_statue#</cfoutput>" name="ssk_statue" id="ssk_statue">
		<input type="hidden" value="<cfoutput>#attributes.statue_type#</cfoutput>" name="statue_type" id="statue_type">
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id="57576.Çalışan"></th>
				<th><cf_get_lang dictionary_id='55663.SGK No'></th>
				<th><cf_get_lang dictionary_id="58025.TC Kimlik No"></th>
				<th><cf_get_lang dictionary_id='53610.Ödenek'></th>	
				<th><cf_get_lang dictionary_id='64687.M.S.'> </th>
				<th><cf_get_lang dictionary_id='64688.T.S.'></th>
				<cfloop from="1" to="#aydaki_gun_sayisi#" index="ccc">
					<th><cfoutput>#ccc#</cfoutput></th>
				</cfloop>
				<!--- <th width="20"  class="header_icn_none text-center">
					<cfif GET_SSK_EMPLOYEES.recordcount>
						<input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_pdks_id');">
					</cfif>
				</th> --->
			</tr>
		</thead>
		<tbody>
			<cfif GET_SSK_EMPLOYEES.recordcount>
				<input type="hidden" value="<cfoutput>#GET_SSK_EMPLOYEES.branch_id#</cfoutput>" name="branch_id" id="branch_id">
				<cfoutput query="GET_SSK_EMPLOYEES">
					<cfset in_out_id = in_out_id>
					<input type="hidden" value="#in_out_id#" name="in_out_id_#currentrow#" id="in_out_id_#currentrow#">
					<input type="hidden" value="#employee_id#" name="employee_id_#currentrow#" id="employee_id_#currentrow#">
					<cfscript>
						last_month_1 = CreateDateTime(session.ep.period_year,attributes.sal_mon, 1,0,0,0);
						last_month_30 = CreateDateTime(session.ep.period_year, attributes.sal_mon, daysinmonth(last_month_1), 23,59,59);
						if (datediff("h",last_month_1,start_date) gte 0)
							last_month_1 = start_date;
						last_month_1 = date_add("d",0,last_month_1);
						if (len(finish_date) and datediff("d",finish_date,last_month_30) gt 0)
							last_month_30 = CreateDateTime(year(finish_date),month(finish_date),day(finish_date), 23,59,59);
					</cfscript>
					<tr>
						<td nowrap="nowrap">#employee_name# #employee_surname#</td>
						<td nowrap="nowrap">#socialsecurity_no#</td>
						<td nowrap="nowrap">#tc_identy_no#</td>
						<td>
							<input type="hidden" name="allowance_#in_out_id#_#currentrow#" id="allowance_#in_out_id#_#currentrow#" value="#odkes_id#">
							<input type="text" name="allowance_name_#in_out_id#_#currentrow#" id="allowance_#in_out_id#_#currentrow#" value="#comment_pay#" readonly>
						</td>
						<td nowrap="nowrap">
							<input type="text"  class="unformat_input" name="min_work_hour_#in_out_id#_#currentrow#" id="min_work_hour_#in_out_id#_#currentrow#"  style="width:22px" <cfif isdefined("MINIMUM_COURSE_HOURS")>value="#tlformat(MINIMUM_COURSE_HOURS)#"<cfelse>value="#tlformat(0)#"</cfif> readonly>
						</td>
						<td nowrap="nowrap">
							<input type="text" name="total_work_hour_#in_out_id#_#currentrow#" id="total_work_hour_#in_out_id#_#currentrow#" class="unformat_input" style="width:22px" <cfif isdefined("total_work_hour_#in_out_id#_#odkes_id#")>value="#tlformat(evaluate('total_work_hour_#in_out_id#_#odkes_id#'))#"<cfelse>value="#tlformat(0)#"</cfif> onkeyup="return(FormatCurrency(this,event,8));">
						</td>
						<cfloop from="1" to="#aydaki_gun_sayisi#" index="ccc">
							<cfset to_day_ = createdate(session.ep.period_year,attributes.sal_mon,ccc)>
							<cfset day_ = "#session.ep.period_year#">
							<cfif attributes.sal_mon gte 10>
								<cfset day_ = "#day_##attributes.sal_mon#">
							<cfelse>
								<cfset day_ = "#day_#0#attributes.sal_mon#">
							</cfif>
							<cfif ccc gte 10>
								<cfset day_ = "#day_##ccc#">
							<cfelse>
								<cfset day_ = "#day_#0#ccc#">
							</cfif>
							<td <cfif listfindnocase(resmi_tatil_gunleri,day_)>class="color-header"</cfif> width="22" align="center" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# (#tc_identy_no#) Ay-Gün : #listgetat(ay_list(),attributes.SAL_MON)#-#ccc#">
								<input type="text" class="unformat_input" row-num="row_num_#currentrow#" additional-num="additional_num_#odkes_id#" name="daily_working_hour_#in_out_id#_#ccc#_#currentrow#" id="daily_working_hour_#in_out_id#_#currentrow#" style="width:22px"<cfif isdefined("daily_working_hour_#in_out_id#_#ccc#_#odkes_id#")>value="#tlformat(evaluate("daily_working_hour_#in_out_id#_#ccc#_#odkes_id#"))#"<cfelse>value="#tlformat(0)#"</cfif> onkeyup="return(FormatCurrency(this,event,8));" onchange="sum_row(#in_out_id#,#currentrow#,#odkes_id#)">
							</td>
						</cfloop>
						<!--- <td class="text-center"><input type="checkbox" name="print_pdks_id" id="print_pdks_id"  value="#employee_id#,#attributes.sal_mon#,#attributes.ssk_office#"></td> --->
						<!-- sil -->		
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="50"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı">!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cf_box_elements>
        <div class="col col-4 col-xs-12" type="column" index="1" sort="true">
            <cfset get_process_f = cmp_process.GET_PROCESS_TYPES(
                faction_list : 'ehesap.hourly_addfare_percantege')>
                <cf_workcube_general_process select_value = '#get_process_f.process_row_id#' print_type="318" is_termin_date="0">
        </div>
		<div class="col col-4 col-xs-12" type="column" index="2" sort="true">
			<input type="hidden" id="add_id_list" value="<cfoutput>#valuelist(get_allowance.ODKES_ID)#</cfoutput>">
			<cfoutput query ="get_allowance">
				<div class="form-group" id="item-allowance_expense">
					<label  class="col col-4 col-xs-4"> <cf_get_lang dictionary_id='56249.Ek Ödenek'> : #COMMENT_PAY#</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-8"> 
						<cfinput type="text" name="allowance_expense_#ODKES_ID#" id="allowance_expense_#ODKES_ID#" class="unformat_input" value="0" onKeyUp="isNumber(this);" type-c="allowance_#currentrow#"  readonly>
					</div>
				</div>
			</cfoutput>
			<div class="form-group" id="item-total_hour">
				<label  class="col col-4 col-xs-4"> <cf_get_lang dictionary_id='46377.Toplam Saat'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-8"> 
					<cfinput type="text" name="total_hour" id="total_hour" class="unformat_input" value="0" onKeyUp="isNumber(this);" readonly>
				</div>
			</div>
		</div>
    </cf_box_elements>
	<div class="ui-info-bottom flex-end">
		<cf_workcube_buttons is_upd='0' data_action = "/V16/hr/ehesap/cfc/hourly_addfare_percantege:add_hourly_addfare_percantege" add_function="UnformatFields()" next_page="#request.self#?fuseaction=ehesap.hourly_addfare_percantege">
	</div>
</cfform>
<script type="text/javascript">
$(document).ready(function(){
	<cfoutput query ="get_allowance">
		total_row("#odkes_id#");
	</cfoutput>
}
);
 function send_emp_info(emp_id)
 {
		adres = '<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=533&</cfoutput>';
		adres +='&ssk_office_all_='+document.employee.ssk_office.value;
		adres +='&employee_id='+emp_id;
		adres +='&ssk_office_='+list_getat(document.employee.ssk_office.value,1,'-');
		adres +='&sal_mon_='+document.employee.sal_mon.value;
		adres +='&id='+list_getat(document.employee.ssk_office.value,2,'-');	
		windowopen(adres,'page');
	
 }

function renkDegistir(eleman)
{
	if(eleman.bgColor=="#ffffff")
		eleman.bgColor = 'cccccc';
	else
		eleman.bgColor = 'ffffff';
}
function UnformatFields()
{
	$(".unformat_input").each(function(){
		$(this).val(filterNum($(this).val()))
	});
}
function sum_row(in_out_id,row_num,odkes_id)
{
	row_total = 0;
	
	$("input[row-num =row_num_"+row_num+"]:text").each(function(){
		row_total = row_total + parseFloat(filterNum($(this).val()));
	});
	
	$("#total_work_hour_"+in_out_id+"_"+row_num).val(commaSplit(row_total));
	total_row(odkes_id);
	
}
function total_row(odkes_id)
{
	additional_total = 0;
	$("input[additional-num =additional_num_"+odkes_id+"]:text").each(function(){
		additional_total = additional_total + parseFloat(filterNum($(this).val()));
	});
	$("#allowance_expense_"+odkes_id).val(commaSplit(additional_total));
	total = 0;
	list = $("#add_id_list").val();
	split_list = list.split(",");
	for(i=0 ;i<split_list.length;i++)
	{
		total = total + parseFloat(filterNum($("#allowance_expense_"+split_list[i]).val()));
	} 
	$("#total_hour").val(commaSplit(total));
}
</script>

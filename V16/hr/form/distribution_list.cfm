<cf_xml_page_edit fuseact="hr.distribution_entry">
<cfsetting showdebugoutput="no">
<cfparam name="attributes.start_date" default="#dateadd('d',-1,now())#">
<cfparam name="attributes.distribution_list_type" default="1">
<cfparam name="attributes.collar_type" default="">
<cfif isdefined("attributes.is_submitted")>
	<cfif isdate(attributes.start_date)>
        <cf_date tarih = "attributes.start_date">
    </cfif>
    
    <cfquery name="GET_TIME_COST" datasource="#DSN#">
        SELECT
        	<cfif attributes.distribution_list_type eq 1>
            PARTNER_ID,
            (SELECT COMPANY_PARTNER_NAME+' '+COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = EMPLOYEE_DAILY_IN_OUT.PARTNER_ID) NAME,
            <cfelse>
            EMPLOYEE_ID,
            (SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = EMPLOYEE_DAILY_IN_OUT.EMPLOYEE_ID) NAME,
            </cfif>
            SUM(DATEDIFF(minute,START_DATE,FINISH_DATE)) DATE_DIFF,
            (
            	SELECT 
                    SUM(TOTAL_TIME)
                FROM 
                    TIME_COST 
                WHERE 
                    EVENT_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.start_date)#"> AND
                <cfif attributes.distribution_list_type eq 1>
                    PARTNER_ID = EMPLOYEE_DAILY_IN_OUT.PARTNER_ID
                GROUP BY     
                    PARTNER_ID
                <cfelse>
                    EMPLOYEE_ID = EMPLOYEE_DAILY_IN_OUT.EMPLOYEE_ID
                GROUP BY     
                    EMPLOYEE_ID
                </cfif>
            ) TIME_COST_TOTAL_TIME
        FROM 
            EMPLOYEE_DAILY_IN_OUT
        WHERE 
			START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
            FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.start_date)#"> AND
			ISNULL(FROM_HOURLY_ADDFARE,0) = 0 AND
		<cfif attributes.distribution_list_type eq 1>
            PARTNER_ID IN (SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID = #attributes.company_id#)
        GROUP BY     
            PARTNER_ID
        <cfelse>
            EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE COLLAR_TYPE = #attributes.collar_type#)
        GROUP BY     
            EMPLOYEE_ID
        </cfif>
    </cfquery>
<cfelse>
	<cfset get_time_cost.recordcount = 0>    
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="56892.Tevzi"></cfsavecontent>
	<cf_big_list_search title="#message#">
		<cf_big_list_search_area>
    	<cfform name="form_distribution_list" id="form_distribution_list">
            <table>
                <tr><input type="hidden" name="is_submitted" id="is_submitted" value="1" />
                    <td><cf_get_lang dictionary_id='57585.Kurumsal Üye'></td>
                    <td>
                        <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("company_id") and len(company_id)><cfoutput>#company_id#</cfoutput></cfif>">
                        <input type="text" name="company" id="company" value="<cfif isdefined("company") and len(company)><cfoutput>#company#</cfoutput></cfif>" <cfif attributes.distribution_list_type eq 2>disabled="disabled"</cfif> onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'0\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID','company_id','form','3','250');" autocomplete="off" style="width:125px;">
                        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=form_distribution_list.company&field_comp_id=form_distribution_list.company_id&select_list=2','list');"> <img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                    </td>
                    <td>
                        <select name="collar_type" id="collar_type" <cfif attributes.distribution_list_type eq 1>disabled="disabled"</cfif>>
                            <option value=""><cf_get_lang dictionary_id='56063.Yaka Tipi'></option>
                            <option value="1" <cfif attributes.collar_type eq 1> selected</cfif>><cf_get_lang dictionary_id='56065.Mavi Yaka'></option> 
                            <option value="2" <cfif attributes.collar_type eq 2> selected</cfif>><cf_get_lang dictionary_id='56066.Beyaz Yaka'></option>
                        </select>
                    </td>
                    <td>
                        <cfinput type="text" name="start_date" id="start_date" style="width:70px;" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
                        <cf_wrk_date_image date_field="start_date">
                    </td>
                    <td>
                        Cari
                        <input type="radio" name="distribution_list_type" id="distribution_list_type1" value="1" onClick="disable_comp(1);"<cfif attributes.distribution_list_type eq 1>checked</cfif>>
                        Çalışan
                        <input type="radio" name="distribution_list_type" id="distribution_list_type2" value="2" onClick="disable_comp(2);" <cfif attributes.distribution_list_type eq 2>checked</cfif>>
                    </td>
                    <td><cf_workcube_buttons is_upd='1' is_delete='0' is_cancel='0' insert_info='Çalıştır' insert_alert='' add_function='kontrol()' type_format="1"></td>
                </tr>
            </table>
        </cfform>
        </cf_big_list_search_area>
    </cf_big_list_search>    
    <cfform name="update_distribution" id="update_distribution"  method="post" action="#request.self#?fuseaction=hr.emptypopup_upd_distribution">
    	<cfset current_row = 1>
        <cf_big_list>
            <thead>
                <tr>
                    <input type="hidden" name="today" id="today" value="<cfoutput>#attributes.start_date#</cfoutput>" style="width:70px;" maxlength="10">
                    <th width="30" align="center"><!--- <input type="button" class="eklebuton" title="<cf_get_lang_main no='170.Ekle'>" onClick="add_row();"> ---></th>
                    <th></th>
                    <th width="160" nowrap><cf_get_lang dictionary_id='57576.Çalışan'></th>
                    <th width="140" nowrap><cf_get_lang dictionary_id='38594.İş ID'></th>                        
                    <th width="140" nowrap><cf_get_lang dictionary_id='38472.İş No'></th>
                    <th width="150" nowrap><cf_get_lang dictionary_id='58445.İş'></th>
                    <th width="160" nowrap><cf_get_lang dictionary_id='57416.Proje'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id="58009.PDKS">(<cf_get_lang dictionary_id="57491.Saat">)</th>
                    <th style="text-align:right;" width="70"><cf_get_lang dictionary_id="58009.PDKS">(<cf_get_lang dictionary_id="58827.dk">.)</th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id="36900.Girilen">(<cf_get_lang dictionary_id="57491.Saat">)</th>
                    <th style="text-align:right;" width="70"><cf_get_lang dictionary_id="36900.Girilen">(<cf_get_lang dictionary_id="58827.dk">.)</th>
                    <th style="text-align:right;" width="75" nowrap><cf_get_lang dictionary_id="29513.Süre">(<cf_get_lang dictionary_id="57491.Saat">)</th>
                    <th style="text-align:right;" width="70"><cf_get_lang dictionary_id="29513.Süre">(<cf_get_lang dictionary_id="58827.dk">.)</th>
                </tr>
            </thead>
            <tbody>
				<cfif get_time_cost.recordcount>
                    <cfoutput query="get_time_cost">
                        <cfif time_cost_total_time lt date_diff>
                            <tr id="frm_row#current_row#">
                                <td>#current_row#</td>
                                <td>
                                    <input type="hidden" value="1" id="row_kontrol#current_row#" name="row_kontrol#current_row#"><a href="javascript://" onClick="copy_row('#current_row#');"><img src="images/copy_list.gif" border="0"></a><a href="javascript://" onClick="sil('#current_row#');"><img src="images/delete_list.gif" border="0"></a>
                                </td>
                                <td>
                                    <cfif isdefined("partner_id") and len(partner_id)>
                                        <input type="hidden" name="partner_id#current_row#" id="partner_id#current_row#" value="#partner_id#">
                                        <input type="hidden" name="company_id#current_row#" id="company_id#current_row#" value="#company_id#">
                                        <input type="text" name="member_name#current_row#" id="member_name#current_row#" value="#name#" class="boxtext" onfocus="AutoComplete_Create('member_name#current_row#','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'1,2\',0,0,0','PARTNER_ID,COMPANY_ID','partner_id#current_row#,company_id#current_row#','','3','200');" style="width:161px;text-align:left;">
                                    <cfelseif isdefined("employee_id") and len(employee_id)>
                                        <input type="hidden" name="employee_id#current_row#" id="employee_id#current_row#" value="<cfif attributes.distribution_list_type eq 2>#employee_id#</cfif>">
                                        <input type="text" name="member_name#current_row#" id="member_name#current_row#" value="#name#" onFocus="AutoComplete_Create('member_name#current_row#','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','member_name#current_row#','employee_id#current_row#','','3','125');" autocomplete="off"  style="width:161px;text-align:left;" class="boxtext" >
                                    </cfif>
                                </td>
                                <td style="text-align:right;"><input type="text" name="work_id#current_row#" id="work_id#current_row#" value="" onkeydown="if(event.keyCode == 13) {get_project_detail(#current_row#);return false;}" style="text-align:right;width:140px;"></td>
                                <td style="text-align:right;"><input type="text" name="work_no#current_row#" id="work_no#current_row#" value="" style="text-align:right;width:130px;" class="boxtext"></td>
                                <td>
                                    <input type="text" name="work_head#current_row#" id="work_head#current_row#" value="" onFocus="AutoComplete_Create('work_head#current_row#','WORK_HEAD','WORK_HEAD','get_work','','WORK_ID','work_id#current_row#','','3','110')" style="width:140px;text-align:left;" class="boxtext"><a href="javascript://" onclick="pencere_detail_work(#current_row#);"><img src="/images/plus_thin_p.gif" title="<cf_get_lang_main no='1033.iş'><cf_get_lang_main no='359.detayı'> "align="absmiddle" border="0"></a><a href="javascript://" onClick="pencere_ac_work('#current_row#');"><img src="/images/plus_thin.gif" title="<cf_get_lang_main no='1279.iş listesi'>" align="absmiddle" border="0"></a>
                                </td>
                                <td>
                                    <input type="hidden" name="project_id#current_row#" id="project_id#current_row#" value=""><input type="text" name="project#current_row#" id="project#current_row#" value="" onFocus="AutoComplete_Create('project#current_row#','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id#current_row#','update_distribution','3','110');" autocomplete="off"  style="width:150px;text-align:left;" class="boxtext"><a href="javascript://" onClick="pencere_ac_project('#current_row#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
                                </td>
                                <td width="70">
                                    <cfset totalminute = get_time_cost.date_diff mod 60>
                                    <cfset totalhour = (get_time_cost.date_diff-totalminute)/60>
                                    <cfinput type="text" name="pdks_time_hour#current_row#" id="pdks_time_hour#current_row#" readonly="true" value="#totalhour#" validate="integer" style="width:70px;text-align:right;" class="boxtext">
                                </td>
                                <td>
                                    <cfinput type="text" name="pdks_time_minute#current_row#" id="pdks_time_minute#current_row#"  readonly="true" maxlength="2" validate="integer" style="width:60px;text-align:right;" value="#totalminute#" class="boxtext">
                                </td>
                                <td width="70">
                                    <cfif len(get_time_cost.time_cost_total_time)>
                                        <cfset cost_totalminute = get_time_cost.time_cost_total_time mod 60>
                                        <cfset cost_totalhour = (get_time_cost.time_cost_total_time-cost_totalminute)/60>
                                    <cfelse>
                                        <cfset cost_totalminute = 0>
                                        <cfset cost_totalhour = 0>
                                    </cfif>
                                    <cfinput type="text" name="pdks_time_hour_2#current_row#" id="pdks_time_hour_2#current_row#" readonly="true" value="#cost_totalhour#" validate="integer" style="width:70px;text-align:right;" class="boxtext">
                                </td>
                                <td>
                                    <cfinput type="text" name="pdks_time_minute_2#current_row#" id="pdks_time_minute_2#current_row#"  readonly="true" maxlength="2" validate="integer" style="width:60px;text-align:right;" value="#cost_totalminute#" class="boxtext">
                                </td>
                                <td>
                                    <cfinput type="text" name="time_hour#current_row#" id="time_hour#current_row#" value="0" onBlur="check_pdks_time(#current_row#);" validate="integer" style="width:65px;text-align:right;">
                                </td>
                                <td>
                                    <cfinput type="text" name="time_minute#current_row#" id="time_minute#current_row#" value="0" onBlur="check_pdks_time(#current_row#);" maxlength="2" validate="integer" style="width:65px;text-align:right;">
                                </td>
                            </tr>
                            <cfset ++current_row>
                        </cfif>
                    </cfoutput>
                    <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#current_row#</cfoutput>">
                <cfelse>
                    <tr>
                        <td width="100%" colspan="13"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı"> !<cfelse><cf_get_lang dictionary_id="57701.Filtre Ediniz"> !</cfif></td>
                    </tr>
                </cfif>
            </tbody>
            <tfoot>
                <cfif get_time_cost.recordcount>
                    <tr>
                        <td colspan="13" style="text-align:right;"><cf_workcube_buttons is_upd='1' is_delete='0' is_cancel='0' insert_info='Kaydet' insert_alert='' add_function='submit_control()'></td>
                    </tr>
                </cfif>
            </tfoot>
        </cf_big_list>
    </cfform>
<script type="text/javascript">
	row_count=<cfoutput>#current_row-1#</cfoutput>;

	function kontrol()
	{
		if((document.getElementById('company_id').value == '' || document.getElementById('company').value == '') && document.getElementById('distribution_list_type1').checked == true)
		{
			alert("<cf_get_lang dictionary_id='56329.Cari Seçiniz !'>");
			return false;
		}
		if(document.getElementById('distribution_list_type2').checked == true && document.getElementById('collar_type').value =="")
		{
			alert("<cf_get_lang dictionary_id='38718.Yaka Tipi Seçiniz !'>");
			return false;
		}
	}

	function disable_comp(type)
	{
		if(type== 1)
		{
			document.getElementById('company').disabled = false;
			document.getElementById('collar_type').disabled = true;
		}	
		else
		{
			document.getElementById('company').disabled = true;
			document.getElementById('collar_type').disabled = false;
		}
	}
	function sil(sy)
	{	
		var my_element=document.getElementById('row_kontrol'+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}

	function copy_row(no)
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		newRow.className = 'color-row';
		document.getElementById('record_num').value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" value="1" id="row_kontrol' + row_count +'" name="row_kontrol' + row_count +'"><a href="javascript://" onClick="copy_row(' + row_count + ');"><img src="images/copy_list.gif" border="0"></a><a href="javascript://" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
	<cfif attributes.distribution_list_type eq 1>
		newCell.innerHTML += '<input type="hidden" name="partner_id' + row_count +'" id="partner_id' + row_count +'" value="'+document.getElementById('partner_id'+no).value+'">';
		newCell.innerHTML += '<input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'" value="'+document.getElementById('company_id'+no).value+'">';
		newCell.innerHTML += '<input type="text" name="member_name' + row_count +'" id="member_name' + row_count +'" value="'+document.getElementById('member_name'+no).value+'"  onFocus="AutoComplete_Create(\'member_name'+ row_count +'\',\'MEMBER_NAME,MEMBER_PARTNER_NAME\',\'MEMBER_NAME,MEMBER_PARTNER_NAME\',\'get_member_autocomplete\',\'1,2\',\'CONSUMER_ID,PARTNER_ID,COMPANY_ID\',\'consumer_id' + row_count +',partner_id' + row_count +',company_id' + row_count +'\',\'update_distribution\',3,116);" class="boxtext" style="width:155px;text-align:left;">';
	<cfelse>
		newCell.innerHTML += '<input type="hidden" name="employee_id' + row_count +'" id="employee_id' + row_count +'" value="'+document.getElementById('employee_id'+no).value+'">';
		newCell.innerHTML += '<input type="text" name="member_name' + row_count +'" id="member_name' + row_count +'" value="'+document.getElementById('member_name'+no).value+'"  onFocus="AutoComplete_Create(\'member_name'+ row_count +'\',\'MEMBER_NAME,MEMBER_PARTNER_NAME\',\'MEMBER_NAME,MEMBER_PARTNER_NAME\',\'get_member_autocomplete\',\'1,2\',\'CONSUMER_ID,PARTNER_ID,COMPANY_ID\',\'consumer_id' + row_count +',partner_id' + row_count +',company_id' + row_count +'\',\'update_distribution\',3,116);" class="boxtext" style="width:155px;text-align:left;">';
	</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="work_id' + row_count +'" id="work_id' + row_count +'" value="" style="width:140px;text-align:right;" onkeydown="if(event.keyCode == 13) {get_project_detail(' + row_count +');return false;}">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="work_no' + row_count +'" id="work_no' + row_count +'" value=""style="width:130px;text-align:left;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="work_head' + row_count +'" id="work_head' + row_count +'" value="" onFocus="AutoComplete_Create(\'work_head'+ row_count +'\',\'WORK_HEAD\',\'WORK_HEAD\',\'get_work\',\'\',\'WORK_ID\',\'work_id'+ row_count +'\',\'\',3,116);" style="width:149px;text-align:left;" class="boxtext"><a href="javascript://" onClick="pencere_ac_work('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value=""><input type="text"  id="project'+ row_count +'" name="project'+ row_count +'" value="" onFocus="AutoComplete_Create(\'project'+ row_count +'\',\'PROJECT_HEAD\',\'PROJECT_HEAD\',\'get_project\',\'\',\'PROJECT_ID\',\'project_id'+ row_count +'\',\'update_distribution\',3,116);" style="width:150px;text-align:left;" class="boxtext"><a href="javascript://" onClick="pencere_ac_project('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="pdks_time_hour' + row_count +'" id="pdks_time_hour' + row_count +'" value="'+document.getElementById('pdks_time_hour'+no).value+'" maxlength="2" validate="integer" style="width:70px;text-align:right;" class="boxtext" onKeyup="return(FormatCurrency(this,event,0));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="pdks_time_minute' + row_count +'" id="pdks_time_minute' + row_count +'" value="'+document.getElementById('pdks_time_minute'+no).value+'" maxlength="2" validate="integer" style="width:60px;text-align:right;" range="0,59" class="boxtext" onKeyup="return(FormatCurrency(this,event,0));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="pdks_time_hour_2' + row_count +'" id="pdks_time_hour_2' + row_count +'" value="'+document.getElementById('pdks_time_hour_2'+no).value+'" maxlength="2" validate="integer" style="width:70px;text-align:right;" class="boxtext" onKeyup="return(FormatCurrency(this,event,0));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="pdks_time_minute_2' + row_count +'" id="pdks_time_minute_2' + row_count +'" value="'+document.getElementById('pdks_time_minute_2'+no).value+'" maxlength="2" validate="integer" style="width:60px;text-align:right;" range="0,59" class="boxtext" onKeyup="return(FormatCurrency(this,event,0));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="time_hour' + row_count +'" id="time_hour' + row_count +'" maxlength="2" validate="integer" value ="0"  style="width:65px;text-align:right;"  onBlur="check_pdks_time('+ row_count +');" onKeyup="return(FormatCurrency(this,event,0));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="time_minute' + row_count +'" id="time_minute' + row_count +'" maxlength="2" validate="integer" value ="0" style="width:65px;text-align:right;" range="0,59"  onBlur="check_pdks_time('+ row_count +');" onKeyup="return(FormatCurrency(this,event,0));">';
	}	
	function pencere_ac_company(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=update_distribution.company_id' + no +'&field_partner_name_surname=update_distribution.member_name' + no +'&field_partner=update_distribution.partner_id' + no+'&select_list=2,3','list');
	}
	function pencere_ac_employee(no)
	{	
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=update_distribution.employee_id' + no +'&field_name=update_distribution.employee_name' + no +'&select_list=1&branch_related','list','popup_list_positions');
	}
	function pencere_ac_project(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=update_distribution.project_id' + no +'&project_head=update_distribution.project' + no);
	}
	function pencere_ac_work(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=update_distribution.work_id' + no +'&field_name=update_distribution.work_head' + no +'&field_pro_id=update_distribution.project_id' + no +'&field_pro_name=update_distribution.project' + no+'&work_no=update_distribution.work_no'+no,'list');
	}
	function pencere_detail_work(no)
	{	
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=project.works&event=det&id='+document.getElementById('work_id'+no).value,'list');
	}
	function get_project_detail(no)
	{
		var sql='SELECT WORK_HEAD,WORK_NO,PROJECT_ID,(SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = PRO_WORKS.PROJECT_ID) PROJECT_HEAD FROM PRO_WORKS WHERE WORK_ID ='+document.getElementById('work_id'+no).value;
		get_work_detail = wrk_query(sql,'dsn');

		if(get_work_detail.recordcount >0)
		{
			document.getElementById('work_head'+no).value = get_work_detail.WORK_HEAD;
			document.getElementById('work_no'+no).value = get_work_detail.WORK_NO;
			document.getElementById('project'+no).value = get_work_detail.PROJECT_HEAD;
			document.getElementById('project_id'+no).value = get_work_detail.PROJECT_ID;
		}
		else
		{
			alert(document.getElementById('work_id'+no).value+ "<cf_get_lang dictionary_id= '38715.ID ye ait iş bulunamadı'> !");
		}
	}
	function check_pdks_time(no)
	{
		if(document.getElementById('distribution_list_type1').checked == true)
			var member_id = document.getElementById('partner_id'+no).value;
		else if(document.getElementById('distribution_list_type2').checked == true)
			var member_id = document.getElementById('employee_id'+no).value;

		var pdks_time = (parseInt(document.getElementById('pdks_time_hour'+no).value)*60) + parseInt(document.getElementById('pdks_time_minute'+no).value);
		
		if(document.getElementById('time_hour'+no).value=='')
			var time_hour_ = 0;
		else
			var time_hour_ = parseInt(document.getElementById('time_hour'+no).value) + parseInt(document.getElementById('pdks_time_hour_2'+no).value);
		
		if(document.getElementById('time_minute'+no).value=='')
			var time_minute_ = 0;
		else
			var time_minute_ = parseInt(document.getElementById('time_minute'+no).value) + parseInt(document.getElementById('pdks_time_minute_2'+no).value); 
		
		var time = time_hour_*60+time_minute_;
		
		for(var i=1;i<=document.getElementById('record_num').value;++i)
		{
			if(document.getElementById('row_kontrol'+i) != undefined)
			{
				<cfif attributes.distribution_list_type eq 1>
					var member_type_id = document.getElementById('partner_id'+i).value;
				<cfelse>
					var member_type_id = document.getElementById('employee_id'+i).value;
				</cfif>
				if(i!= no && member_id == member_type_id)
				{
					if(document.getElementById('time_hour'+i).value=='')
						var time_hour_2 = 0;
					else
						var time_hour_2 = parseInt(document.getElementById('time_hour'+i).value);
					
					if(document.getElementById('time_minute'+i).value=='')
						var time_minute_2 = 0;
					else
						var time_minute_2 = parseInt(document.getElementById('time_minute'+i).value);
					
						var time = time + (time_hour_2*60) + time_minute_2;
				}
			}
		}

		if(pdks_time < time)
		{
			alert("<cf_get_lang dictionary_id='38695.PDKS Zamanından Fazla Giremezsiniz!'> <cf_get_lang dictionary_id='58230.Satır No'>:" + no+ );
			document.getElementById('time_hour'+no).value = 0;
			document.getElementById('time_minute'+no).value = 0;			
			return false;
		}
		
		if(document.getElementById('work_id'+no).value == '')
		{
			if(document.getElementById('time_hour'+no).value=='')
				document.getElementById('time_hour'+no).value=0;
			if(document.getElementById('time_minute'+no).value=='')
				document.getElementById('time_minute'+no).value=0;
				
			var time_ = (parseInt(document.getElementById('time_hour'+no).value)*60) + parseInt(document.getElementById('time_minute'+no).value);
			if(time_ != 0)
			{
				alert("<cf_get_lang dictionary_id= '38692.İş Seçiniz'>!" + no +);
				return false;
			}
		}
	}
	function submit_control()
	{
		<cfif x_check_contract>
			<cfoutput>
				var sql_2='SELECT WORK_ID FROM PRO_WORKS,#dsn3_alias#.RELATED_CONTRACT RC WHERE ((RC.CONTRACT_TYPE = 1 AND RC.CONTRACT_ID = PRO_WORKS.PURCHASE_CONTRACT_ID) OR (RC.CONTRACT_TYPE = 2 AND RC.CONTRACT_ID = PRO_WORKS.SALE_CONTRACT_ID)) AND RC.COMPANY_ID = ' + document.getElementById('company_id').value ;
				get_pro_works = wrk_query(sql_2,'dsn');
			</cfoutput>
			for(var i=1;i<=document.getElementById('record_num').value;++i)
			{
				if(document.getElementById('row_kontrol'+i) != undefined)
				{
					var work_count= 0;
					for( var x= 1; x<=get_pro_works.recordcount;++x)
					{
						if(document.getElementById('work_id'+i).value == get_pro_works.WORK_ID[x])
						{
							
							work_count =1;
							break;
						}
					}
					if(work_count == 0)
					{
						alert("<cf_get_lang dictionary_id='38691.Cari ile İlişkili Sözleşmede Bulunmuyor'> <cf_get_lang dictionary_id='58508.Satır'>:"  +i+);
						return false;
					}
				}
			}
			
		</cfif>
		
		
		var check_kontrol_ =0;
		for(i=1;i <=document.getElementById('record_num').value ;++i)
		{
			if(document.getElementById('row_kontrol'+i) != undefined)
			{
				if(document.getElementById('time_hour'+i)!= undefined && check_pdks_time(i)==false)
				check_kontrol_ = 1;
			}
		}
		if(check_kontrol_ ==0)
			document.update_distribution.submit();
		
	}
</script>


<!--- bu sayfaının nerde ise aynısı myhome modülündede var bu sayfada yapılan değişiklikler myhome deki dosyayada taşınsın--->
<cfquery name="get_list" datasource="#dsn#">
SELECT
	*
FROM
	EMPLOYEES_APP_SEL_LIST
WHERE 
	LIST_ID=#attributes.list_id#
</cfquery>

<cfif len(get_list.POSITION_ID)>
	<cfquery name="get_position_name" datasource="#dsn#">
		SELECT
			EMPLOYEE_POSITIONS.POSITION_ID,
			EMPLOYEE_POSITIONS.POSITION_CODE,
			EMPLOYEE_POSITIONS.POSITION_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME
		FROM
			EMPLOYEE_POSITIONS
		WHERE
			EMPLOYEE_POSITIONS.POSITION_CODE = #get_list.POSITION_ID#
	</cfquery>
	<cfset app_position = "#get_position_name.position_name# - #get_position_name.employee_name# #get_position_name.employee_surname#">
<cfelse>
	<cfset app_position = "">
</cfif>
		
<cfif len(get_list.position_cat_id)>
	<cfset attributes.position_cat_id = get_list.position_cat_id>
	<cfinclude template="../query/get_position_cat.cfm">
	<cfset POSITION_CAT = "#GET_POSITION_CAT.POSITION_CAT#">
<cfelse>
	<cfset POSITION_CAT = "">
</cfif>

<cfquery name="GET_SETUP_WARNING" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_WARNINGS 
	ORDER BY 
		SETUP_WARNING
</cfquery>
<!--- <cf_catalystHeader> --->
	<div class="col col-12">
		<cf_box title="#getLang('','Seçim Listeleri',31337)#:#attributes.list_id#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
			<cfform name="upd_list" action="#request.self#?fuseaction=hr.emptypopup_upd_select_emp_list" method="post">
				<input name="record_num" id="record_num" type="hidden" value="0">
				<input name="record_count" id="record_count" type="hidden" value="0">
				<cf_box_elements vertical="1">
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        	<div class="form-group" id="item-list_name">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'></label>
                                <div class="col col-9 col-xs-12">
                                	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'></cfsavecontent>
                    				<cfinput type="text" name="list_name" id="list_name" style="width:175px;" value="#get_list.list_name#" required="yes" message="#message#" >
                                </div>
                            </div>
                            <div class="form-group" id="item-pif_id">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='56204.Personel İstek Formu'>*</label>
                                <div class="col col-9 col-xs-12">
                                	<div class="input-group">
                                    	<cfif len(get_list.pif_id)>
                                        <cfquery name="GET_PIF_LIST" datasource="#DSN#">
                                            SELECT
                                                PERSONEL_REQUIREMENT_HEAD
                                            FROM
                                                PERSONEL_REQUIREMENT_FORM
                                            WHERE
                                                PERSONEL_REQUIREMENT_ID=#get_list.pif_id#
                                        </cfquery>
                                        </cfif>
                                        <input type="hidden" name="pif_id" id="pif_id" value="<cfoutput>#get_list.pif_id#</cfoutput>">
                                        <input type="text" name="pif_name" id="pif_name" value="<cfif isdefined("GET_PIF_LIST")><cfoutput>#GET_PIF_LIST.PERSONEL_REQUIREMENT_HEAD#</cfoutput></cfif>" style="width:175px;">						
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_personel_requirement&field_id=upd_list.pif_id&field_name=upd_list.pif_name</cfoutput>','list');" title="Seçim Listesi Seç"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-company">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='57585.Kurumsal Üye'></label>
                                <div class="col col-9 col-xs-12">
                                	<div class="input-group">
                                    	<input type="hidden" id="company_id" value="<cfoutput>#get_list.company_id#</cfoutput>" name="company_id">
						                <input type="text" name="company" id="company" value="<cfif len(get_list.company_id)><cfoutput>#get_par_info(get_list.company_id,1,0,0)#</cfoutput></cfif>" style="width:175px;">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=upd_list.company_id&field_comp_name=upd_list.company&select_list=7','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-branch">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                <div class="col col-9 col-xs-12">
                                	<div class="input-group">
                                    	<cfif len(get_list.department_id) and len(get_list.our_company_id)>
                                        <cfquery name="get_our_company" datasource="#dsn#">
                                            SELECT
                                                BRANCH.BRANCH_NAME,
                                                BRANCH.BRANCH_ID,
                                                DEPARTMENT.DEPARTMENT_HEAD,
                                                DEPARTMENT.DEPARTMENT_ID
                                            FROM 
                                                DEPARTMENT,
                                                BRANCH
                                            WHERE 
                                                BRANCH.COMPANY_ID=#get_list.our_company_id#
                                                AND	BRANCH.BRANCH_ID=DEPARTMENT.BRANCH_ID
                                                AND BRANCH.BRANCH_ID=#get_list.branch_id#
                                                AND DEPARTMENT.DEPARTMENT_ID=#get_list.department_id#
                                        </cfquery>
                                        </cfif>
                                        <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_list.branch_id#</cfoutput>">
                                        <input type="text" name="branch" id="branch" value="<cfif isdefined('get_our_company') and get_our_company.recordcount><cfoutput>#get_our_company.branch_name#</cfoutput></cfif>" style="width:175px;" >
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=upd_list.department_id&field_name=upd_list.department&field_branch_name=upd_list.branch&field_branch_id=upd_list.branch_id&field_our_company_id=upd_list.our_company_id</cfoutput>','list');"></span>
                                    	<input type="hidden" name="our_company_id" id="our_company_id" value="<cfoutput>#get_list.our_company_id#</cfoutput>">
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-department">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57572.Department'></label>
                                <div class="col col-9 col-xs-12">
                                	<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_list.department_id#</cfoutput>">
                    				<input type="text" name="department" id="department" value="<cfif isdefined('get_our_company') and get_our_company.recordcount><cfoutput>#get_our_company.department_head#</cfoutput></cfif>" style="width:175px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-list_detail">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <div class="col col-9 col-xs-12">
                                	<textarea name="list_detail" id="list_detail" style="width:455px;height:70px"><cfoutput>#get_list.list_detail#</cfoutput></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        	<div class="form-group" id="item-list_status">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                                <div class="col col-9 col-xs-12">
                                	<input type="checkbox"  name="list_status" id="list_status" value="1" <cfif get_list.list_status eq 1>checked</cfif>>
                                </div>
                            </div>
                            <div class="form-group" id="item-sel_list_stage">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='57482.Aşama'></label>
                                <div class="col col-9 col-xs-12">
                                	<cf_workcube_process
                                    is_upd='0' 
                                    select_value ='#get_list.sel_list_stage#'
                                    process_cat_width='150' 
                                    is_detail='0'>
                                </div>
                            </div>
                            <div class="form-group" id="item-notice_head">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='55159.İlan'></label>
                                <div class="col col-9 col-xs-12">
                                	<div class="input-group">
                                    	<cfif len(get_list.notice_id)>
                                          <cfquery name="get_notice" datasource="#dsn#">
                                            SELECT NOTICE_HEAD,NOTICE_NO FROM NOTICES WHERE NOTICE_ID = #get_list.notice_id#
                                          </cfquery>
                                          <input type="hidden" name="notice_id" id="notice_id" value="<cfoutput>#get_list.notice_id#</cfoutput>">
                                          <input type="hidden" name="notice_no" id="notice_no" value="<cfoutput>#get_notice.NOTICE_NO#</cfoutput>">
                                          <input type="text" name="notice_head" id="notice_head" value="<cfoutput>#get_notice.NOTICE_NO#-#get_notice.NOTICE_HEAD#</cfoutput>" style="width:150px;">
                                          <cfelse>
                                          <input type="hidden" name="notice_id" id="notice_id" value="">
                                          <input type="hidden" name="notice_no" id="notice_no" value="">
                                          <input type="text" name="notice_head" id="notice_head" value="" style="width:150px;">
                                        </cfif>
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_notices&field_id=upd_list.notice_id&field_name=upd_list.notice_head&field_comp=upd_list.company&field_comp_id=upd_list.company_id&field_department_id=upd_list.department_id&field_department=upd_list.department&field_branch_id=upd_list.branch_id&field_branch=upd_list.branch&&field_our_company_id=upd_list.our_company_id','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-POSITION_CAT">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
                                <div class="col col-9 col-xs-12">
                                	<div class="input-group">
                                    	<input type="Hidden" name="POSITION_CAT_ID" id="POSITION_CAT_ID" value="<cfoutput>#get_list.position_cat_id#</cfoutput>">
                    					<cfinput type="text" name="POSITION_CAT" id="POSITION_CAT" style="width:150px;" value="#POSITION_CAT#">                                        
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_cats&field_cat_id=upd_list.POSITION_CAT_ID&field_cat=upd_list.POSITION_CAT','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-app_position">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'> *</label>
                                <div class="col col-9 col-xs-12">
                                	<div class="input-group">
                                    	<input type="Hidden" name="POSITION_ID" id="POSITION_ID" value="<cfoutput>#get_list.POSITION_ID#</cfoutput>" maxlength="50">
                    					<cfinput type="text" name="app_position" id="app_position" style="width:150px;" value="#app_position#">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=upd_list.POSITION_ID&field_pos_name=upd_list.app_position&field_comp_id=upd_list.our_company_id&field_branch_name=upd_list.branch&field_branch_id=upd_list.branch_id&field_dep_name=upd_list.department&field_dep_id=upd_list.department_id&show_empty_pos=1','list');"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                    	<div class="col col-12" type="column" sort="false">
                            <table style="width: 100%;">
                                <tr>
                                    <td colspan="4" class="txtbold">
                                        <input type="hidden" name="url_link" id="url_link" value="<cfoutput>#request.self#?fuseaction=myhome.upd_emp_app_select_list&list_id=#attributes.list_id#</cfoutput>">
                                         <cf_get_lang dictionary_id ='55973.Yetkililer'> 
                                          <input type="button" class="eklebuton" title="Ekle" onClick="add_row();">
                                         <!--- <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_pos=upd_list.positions&field_table=td_yetkili&select_list=1</cfoutput>','list');"><img src="/images/plus_thin.gif" border="0"></a> --->
                                         <input type="hidden" name="positions" id="positions" value="">
                                    </td>
                                </tr>
                                <tr>
                                    <cfquery name="get_authority" datasource="#DSN#">
                                        SELECT 
                                            SLA.*,
                                            EP.EMPLOYEE_NAME,
                                            EP.EMPLOYEE_SURNAME
                                        FROM
                                            EMPLOYEES_APP_AUTHORITY SLA,
                                            EMPLOYEE_POSITIONS EP
                                        WHERE
                                            LIST_ID=#attributes.list_id# AND
                                            EP.POSITION_CODE = SLA.POS_CODE AND
                                            SLA.AUTHORITY_STATUS = 1
                                    </cfquery>
                                      <td id="td_yetkili" colspan="4" valign="top">
                                      <cfif get_authority.RECORDCOUNT>
                                        <cfoutput query="get_authority">
                                          <a href="#request.self#?fuseaction=hr.emptypopup_del_select_list_authority&list_id=#attributes.list_id#&pos_code=#get_authority.pos_code#&valid_status=#get_authority.valid_status#"><img src="/images/delete_list.gif" border="0"></a> #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#<br/>
                                        </cfoutput>
                                      </cfif>
                                      </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <table class="workDevList" id="link_table"><!--- uyarılacak kişiler---></table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="row formContentFooter">
                    	<div class="col col-6">
                        	<input type="hidden" name="list_id" id="list_id" value="<cfoutput>#attributes.list_id#</cfoutput>">
        					<cf_record_info query_name="get_list">
                        </div>
                        <div class="col col-6">
                        	<cf_workcube_buttons is_upd='1' add_function='loadPopupBox("upd_list")' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_emp_app_select_list&list_id=#attributes.list_id#'>
                        </div>
                    </div>
        
  
				</cf_box_elements>
			</cfform>
		</cf_box>
	</div>

<!--- <td valign="top" align="center"><cfinclude template="../display/list_emp_app_select_list_mails.cfm"></td> --->
<script type="text/javascript">
function kontrol()
{
	if (upd_list.list_detail.value.length>250)
	{
		alert("<cf_get_lang dictionary_id='56053.Açıklama Alanı 250 Karakterden Fazla Olamaz'>");
		return false;
	}
	return 	process_cat_control();
}

row_count=0;
main_row_count=0;
function sil(sy)
{
	for(i=sy;i<sy+5;i++){
		var my_element=eval("upd_list.row_kontrol"+i);
		my_element.value=0;

		var my_element=eval("frm_row"+i);
		my_element.style.display="none";		
	}
	document.getElementById('record_count').value=parseInt(document.getElementById('record_count').value)-1;
}

function add_row()
{
	row_count++;
	main_row_count++;
	var newRow;
	var newCell;
	
	newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);
				
	document.getElementById('record_num').value=row_count;
	document.getElementById('record_count').value=parseInt(document.getElementById('record_count').value)+1;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("id","td_" + row_count);
	newCell.innerHTML = '<hr size="1" color="#000066"><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';
	eval("td_" + row_count).colSpan = 7;
	
	row_count++;
	var newRow;
	var newCell;
	
	newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);
	
	document.getElementById('record_num').value=row_count;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("id","yetkili_" + row_count);
	newCell.innerHTML = '<cf_get_lang_main no="166.Yetkili">*';
	eval("yetkili_" + row_count).colSpan = 2;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("id","talep_" + row_count);
	newCell.innerHTML = 'Talep*';
	eval("talep_" + row_count).colSpan = 2;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("id","aciklama_" + row_count);
	newCell.innerHTML = 'Açıklama';
	eval("aciklama_" + row_count).colSpan = 2;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + (row_count - 1) + ');" ><img  src="images/delete_list.gif" border="0"></a><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';

	row_count++;
	var newRow;
	var newCell;
	
	newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);
	
	document.getElementById('record_num').value=row_count;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("id","yetkili_in_" + row_count);
	eval("yetkili_in_" + row_count).colSpan = 2;
	newCell.innerHTML = '<input type="text" name="employee' + main_row_count + '" style="width:150px;"><a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_list.position_code" + main_row_count + "&field_name=upd_list.employee" + main_row_count + "','list');"+'"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a><input type="hidden" name="position_code' + main_row_count + '">';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("id","talep_in_" + row_count);
	eval("talep_in_" + row_count).colSpan = 2;
	newCell.innerHTML = '<select name="warning_head' + main_row_count + '" style="width:165px;"><cfoutput query="GET_SETUP_WARNING"><option value="#SETUP_WARNING#--#SETUP_WARNING_ID#">#SETUP_WARNING#</option></cfoutput></select>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("id","aciklama_in_" + row_count);
	eval("aciklama_in_" + row_count).colSpan = 2;
	newCell.innerHTML = '<input type="text" name="warning_description' + main_row_count + '" style="width:150px;">';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '&nbsp;<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';

	row_count++;
	var newRow;
	var newCell;
	
	newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);
	
	document.getElementById('record_num').value=row_count;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("id","son_cevap_" + row_count);
	newCell.innerHTML = 'Son Cevap *';
	eval("son_cevap_" + row_count).colSpan = 2;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("id","SMS_" + row_count);
	newCell.innerHTML = 'SMS';
	eval("SMS_" + row_count).colSpan = 2;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("id","email_" + row_count);
	newCell.innerHTML = 'Email Uyarı';
	eval("email_" + row_count).colSpan = 2;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '&nbsp;<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';

	row_count++;
	var newRow;
	var newCell;
	
	newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);
	
	document.getElementById('record_num').value=row_count;
	
 	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("id","response_date" + main_row_count + "_td");
	newCell.innerHTML = '<input type="text" name="response_date' + main_row_count +'" class="text" maxlength="10" style="width:65px;" value="<cfoutput>#dateformat(now(), dateformat_style)#</cfoutput>">';
	wrk_date_image('response_date' + main_row_count);
	
	newCell = newRow.insertCell(newRow.cells.length);
	HTMLStr = '<select name="response_clock' + main_row_count + '" style="width:37px;;"><cfloop from="0" to="23" index="i"><cfoutput><option value="#i#">#numberformat(i,00)#</option></cfoutput></cfloop></select>';
	HTMLStr = HTMLStr + '<select name="response_min' + main_row_count + '" style="width:37px;;"><option value="00" selected>00</option>';
	HTMLStr = HTMLStr + '<option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option><option value="30">30</option>';
	HTMLStr = HTMLStr + '<option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option>';
	HTMLStr = HTMLStr + '</select>';
	newCell.innerHTML = HTMLStr;
	

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("id","sms_startdate" + main_row_count + "_td");
	newCell.innerHTML = '<input type="text" name="sms_startdate' + main_row_count +'" class="text" maxlength="10" style="width:65px;" value="<cfoutput>#dateformat(now(), dateformat_style)#</cfoutput>">';
	wrk_date_image('sms_startdate' + main_row_count);

	newCell = newRow.insertCell(newRow.cells.length);
	HTMLStr = '<select name="sms_start_clock' + main_row_count + '" style="width:37px;;"><cfloop from="0" to="23" index="i"><cfoutput><option value="#numberformat(i,00)#">#numberformat(i,00)#</option></cfoutput></cfloop></select>';
	HTMLStr = HTMLStr + '<select name="sms_start_min' + main_row_count + '" style="width:37px;;">';
	HTMLStr = HTMLStr + '<option value="00" selected>00</option><option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option>';
	HTMLStr = HTMLStr + '<option value="30">30</option><option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option>';
	HTMLStr = HTMLStr + '</select>';
	newCell.innerHTML = HTMLStr;

	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("id","email_startdate" + main_row_count + "_td");
	newCell.innerHTML = '<input type="text" name="email_startdate' + main_row_count +'" class="text" maxlength="10" style="width:65px;" value="<cfoutput>#dateformat(now(), dateformat_style)#</cfoutput>">';
	wrk_date_image('email_startdate' + main_row_count);

 	newCell = newRow.insertCell(newRow.cells.length);	
 	HTMLStr = '<select name="email_start_clock' + main_row_count + '" style="width:37px;;"><cfloop from="0" to="23" index="i"><cfoutput><option value="#numberformat(i,00)#">#numberformat(i,00)#</option></cfoutput></cfloop></select>';
	HTMLStr = HTMLStr + '<select name="email_start_min' + main_row_count + '" style="width:37px;;">';
	HTMLStr = HTMLStr + '<option value="00" selected>00</option><option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option>';
	HTMLStr = HTMLStr + '<option value="30">30</option><option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option>';
	HTMLStr = HTMLStr + '</select>';
	newCell.innerHTML = HTMLStr;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '&nbsp;<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" >';
}
</script>
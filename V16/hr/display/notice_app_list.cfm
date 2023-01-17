<cfquery name="notice_app_list" datasource="#dsn#">
	SELECT
		EMPLOYEES_APP.EMPAPP_ID,
		EMPLOYEES_APP_POS.APP_POS_ID,
		EMPLOYEES_APP_POS.POSITION_ID,
		EMPLOYEES_APP_POS.POSITION_CAT_ID,
		EMPLOYEES_APP_POS.APP_DATE,
		EMPLOYEES_APP.NAME,
		EMPLOYEES_APP.SURNAME,
		EMPLOYEES_APP.STEP_NO,
		EMPLOYEES_APP_POS.NOTICE_ID,
		EMPLOYEES_APP.COMMETHOD_ID,
		EMPLOYEES_APP_POS.APP_POS_STATUS,
		EMPLOYEES_APP.UPDATE_DATE,
		EMPLOYEES_IDENTY.BIRTH_DATE
	FROM
		EMPLOYEES_APP,
		EMPLOYEES_IDENTY,
		EMPLOYEES_APP_POS
	WHERE
		EMPLOYEES_APP.EMPAPP_ID IS NOT NULL
		AND EMPLOYEES_APP.EMPAPP_ID=EMPLOYEES_APP_POS.EMPAPP_ID
		AND EMPLOYEES_IDENTY.EMPAPP_ID IS NOT NULL
		AND EMPLOYEES_APP.EMPAPP_ID = EMPLOYEES_IDENTY.EMPAPP_ID
		AND EMPLOYEES_APP_POS.APP_POS_STATUS = 1
		AND EMPLOYEES_APP_POS.NOTICE_ID = #attributes.notice_id#
		<cfif IsDefined("attributes.name_search") and len(attributes.name_search)>
		AND EMPLOYEES_APP.NAME LIKE <cfqueryparam value = "%#attributes.name_search#%" CFSQLType ="cf_sql_varchar">
		</cfif>
		<cfif IsDefined("attributes.surname_search") and len(attributes.surname_search)>
		AND EMPLOYEES_APP.SURNAME LIKE <cfqueryparam value = "%#attributes.surname_search#%" CFSQLType ="cf_sql_varchar">
		</cfif>
	ORDER BY 
		EMPLOYEES_APP_POS.APP_DATE DESC
</cfquery>
<!--- <cfdump var="#notice_app_list#"> --->
<cfset attributes.to_day = CreateDate(year(now()),month(now()), day(now()))>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default="">
<cfparam name="attributes.totalrecords" default="">
<div class="col col-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="55681.İlana Başvuranlar Listesi"></cfsavecontent>
	<cf_box>
		<cf_box_search more="0">
			<cfform name="search" method="post" action="#request.self#?fuseaction=hr.popup_notice_app_list&notice_id=#attributes.notice_id#">
				<div class="row form-inline">
					<div class="form-group x-12">
						<input type="text" name="name_search" id="name_search" value="<cfif IsDefined("attributes.name_search") and len(attributes.name_search)><cfoutput>#attributes.name_search#</cfoutput></cfif>" placeholder="<cfoutput><cf_get_lang_main no='219.Ad'></cfoutput>" maxlength="50">
					</div>
					<div class="form-group x-12">
						<input type="text" name="surname_search" id="surname_search" value="<cfif IsDefined("attributes.surname_search") and len(attributes.surname_search)><cfoutput>#attributes.surname_search#</cfoutput></cfif>" placeholder="<cfoutput><cf_get_lang_main no='1314.Soyad'></cfoutput>" maxlength="50">
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type='4'>
					</div>
					<div class="form-group">
						<a class="ui-btn ui-btn-gray" href="javascript://" onClick="add_select_list();"><i class="fa fa-arrow-left" title="<cf_get_lang no ='1752.Seçim Listesi Oluştur'>"></i></a>
					</div>
					<div class="form-group">
						<a class="ui-btn ui-btn-gray2" href="javascript://" onClick="edit_select_list();"><i class="fa fa-arrow-right" title="<cf_get_lang no ='1753.Mevcut Seçim Listesine Ekle'>"></i></a>
					</div>				
				</div>	
			</cfform>
		</cf_box_search>
	</cf_box>
	<cf_box  title="#message#">
	<cf_flat_list>
		<form name="list_application" method="post" action="">
			<thead>
				<tr>
					<th width="100"><cf_get_lang dictionary_id="57570.Ad Soyad"></th>
					<th><cf_get_lang dictionary_id="57709.Okul"></th>
					<th><cf_get_lang dictionary_id="55745.Yaş"></th>
					<th><cf_get_lang dictionary_id="55912.Son Tecrübe"></th>
					<th width="95"><cf_get_lang dictionary_id="32449.Güncelleme Tarihi"></th>
					<th><input type="checkbox" name="all_check" id="all_check" value="1" onclick="wrk_select_all('all_check','ozgecmis_id');""></th>
				</tr>
			</thead>
			<tbody>
				<cfif notice_app_list.recordcount>
				<cfoutput query="notice_app_list">
				<tr>
					<td>
						<a href="#request.self#?fuseaction=hr.list_cv&event=upd&empapp_id=#empapp_id#" class="tableyazi" target="_blank">
							#name# #surname#
						</a>
					</td>
					<td>
						<cfquery name="get_app_edu_info" datasource="#dsn#" maxrows="1">
							SELECT EDU_NAME,EDU_PART_NAME FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = #empapp_id# ORDER BY EDU_START DESC
						</cfquery>
						<cfif get_app_edu_info.recordcount> #get_app_edu_info.edu_name# / #get_app_edu_info.edu_part_name#</cfif>
					</td>
					<td>
					<cfif len(BIRTH_DATE)>
						<cfset YAS = DATEDIFF("yyyy",BIRTH_DATE,NOW())>
						#YAS#
					</cfif>
					</td>
					<td>
					<cfquery name="get_app_work_info" datasource="#dsn#" maxrows="1">
							SELECT EXP,EXP_POSITION,EXP_FINISH FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = #empapp_id# ORDER BY EXP_START DESC
						</cfquery>
						<cfif get_app_work_info.recordcount>
							#get_app_work_info.exp#-#get_app_work_info.exp_position#-#dateformat(get_app_work_info.exp_finish,'mm/yyyy')#</td>
						</cfif>
					<td>#dateformat(update_date,dateformat_style)#</td>
					<td> <input type="hidden" name="basvuru_id" id="basvuru_id" value="#notice_app_list.app_pos_id#">
					<input type="checkbox" name="ozgecmis_id" id="ozgecmis_id" value="#notice_app_list.empapp_id#"></td>
				</tr>
				</cfoutput>
					<cfelse>
					<tr>
					<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
					</tr>
				</cfif>
			</tbody>
		</form>
	</cf_flat_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cf_paging 
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="hr.popup_list_employees_app#url_str#">
	</cfif>
	</cf_box>
	<form name="create_selected_list" method="post" action="">
	<cfoutput>
	<input type="hidden" name="list_app_pos_id" id="list_app_pos_id" value="#notice_app_list.app_pos_id#">
	<input type="hidden" name="list_empapp_id" id="list_empapp_id" value=""><!--- #notice_app_list.empapp_id# --->
	<input type="hidden" name="search_app_pos" id="search_app_pos" value="1">
	<input type="hidden" name="status_app_pos" id="status_app_pos" value="">
	<input type="hidden" name="search_app" id="search_app" value="">
	<input type="hidden" name="app_position" id="app_position" value="">
	<input type="hidden" name="position_cat_id" id="position_cat_id" value="">
	<input type="hidden" name="position_cat" id="position_cat" value="">
	<input type="Hidden" name="position_id" id="position_id" value="">
	<input type="hidden" name="branch_id" id="branch_id" value="">
	<input type="hidden" name="branch" id="branch" value="">
	<input type="hidden" name="our_company_id" id="our_company_id" value="">	
	<input type="hidden" name="department_id" id="department_id" value="">
	<input type="hidden" name="department" id="department" value="">
	<input type="hidden" name="company_id" id="company_id" value="">
	<input type="hidden" name="company" id="company" value="">
	<input type="hidden" name="prefered_city" id="prefered_city" value="">
	<input type="hidden" name="date_status" id="date_status" value="">
	<input type="hidden" name="notice_id" id="notice_id" value="">
	<input type="hidden" name="notice_head" id="notice_head" value="">
	<input type="hidden" name="app_date1" id="app_date1" value="">
	<input type="hidden" name="app_date2" id="app_date2" value="">
	<input type="hidden" name="salary_wanted1" id="salary_wanted1" value="">
	<input type="hidden" name="salary_wanted2" id="salary_wanted2" value="">
	<input type="hidden" name="salary_wanted_money" id="salary_wanted_money" value="">
	<input type="hidden" name="status_app" id="status_app" value="">
	<input type="hidden" name="app_name" id="app_name" value="#notice_app_list.name#">
	<input type="hidden" name="app_surname" id="app_surname" value="#notice_app_list.surname#">
	<input type="hidden" name="birth_date1" id="birth_date1" value="">
	<input type="hidden" name="birth_date2" id="birth_date2" value="">
	<input type="hidden" name="birth_place" id="birth_place" value="">
	<input type="hidden" name="married" id="married" value="">
	<input type="hidden" name="city" id="city"  value="">
	<input type="hidden" name="sex" id="sex" value="">
	<input type="hidden" name="martyr_relative" id="martyr_relative" value="">
	<input type="hidden" name="is_trip" id="is_trip" value="">
	<input type="hidden" name="driver_licence" id="driver_licence" value="">
	<input type="hidden" name="driver_licence_type" id="driver_licence_type" value="">
	<input type="hidden" name="sentenced" id="sentenced" value="">
	<input type="hidden" name="defected" id="defected" value="">
	<input type="hidden" name="defected_level" id="defected_level" value="">
	<input type="hidden" name="email" id="email" value="">
	<input type="hidden" name="military_status" id="military_status" value="">
	<input type="hidden" name="homecity" id="homecity" value="">
	<input type="hidden" name="training_level" id="training_level" value="">
	<input type="hidden" name="edu_finish" id="edu_finish" value="">
	<input type="hidden" name="exp_year_s1" id="exp_year_s1" value="">
	<input type="hidden" name="exp_year_s2" id="exp_year_s2" value="">
	<input type="hidden" name="lang" id="lang" value="">
	<input type="hidden" name="lang_level" id="lang_level" value="">
	<input type="hidden" name="lang_par" id="lang_par" value="">
	<input type="hidden" name="edu3_part" id="edu3_part" value="">
	<input type="hidden" name="edu4_id" id="edu4_id" value="">
	<input type="hidden" name="edu4_part_id" id="edu4_part_id" value="">
	<input type="hidden" name="edu4" id="edu4" value="">
	<input type="hidden" name="edu4_part" id="edu4_part" value="">
	<input type="hidden" name="unit_id" id="unit_id" value="">
	<input type="hidden" name="unit_row" id="unit_row" value="">
	<input type="hidden" name="referance" id="referance" value="">
	<input type="hidden" name="tool" id="tool" value="">
	<input type="hidden" name="kurs" id="kurs" value="">
	<input type="hidden" name="other" id="other" value="">
	<input type="hidden" name="other_if" id="other_if" value="">
	</cfoutput>
	</form>
</div>
<script type="text/javascript">
 $(document).ready(function(){
    $( "#name_search" ).focus();
});

function add_select_list()
 {
<cfif notice_app_list.recordcount>
	<cfif notice_app_list.recordcount gt 1> 
		for(i=0;i<list_application.ozgecmis_id.length;i++)
			if(document.list_application.ozgecmis_id[i].checked)
			{
				if(document.create_selected_list.list_empapp_id.value.length==0) ayirac=''; else ayirac=',';
				document.create_selected_list.list_empapp_id.value=document.create_selected_list.list_empapp_id.value+ayirac+document.list_application.ozgecmis_id[i].value;
				document.create_selected_list.list_app_pos_id.value=document.create_selected_list.list_app_pos_id.value+ayirac+document.list_application.basvuru_id[i].value;
			}
	<cfelse>
		if(document.list_application.ozgecmis_id.checked)
		{
			document.create_selected_list.list_empapp_id.value=document.list_application.ozgecmis_id.value;
			document.create_selected_list.list_app_pos_id.value=document.list_application.basvuru_id.value;
		}
	</cfif>
	if(document.create_selected_list.list_empapp_id.value.length==0)
	{
		alert("<cf_get_lang dictionary_id='56841.Özgeçmiş Seçmelisiniz'>");
		return false;
	}
		windowopen('','list','select_list_window');
		create_selected_list.action='<cfoutput>#request.self#?fuseaction=hr.popup_add_select_emp_list</cfoutput>';
		create_selected_list.target='select_list_window';create_selected_list.submit();
		document.create_selected_list.list_empapp_id.value='';/* id_leri boşaltıyoruz popup açılıp bi ilem yapılmadn kapatılır ve tekrar popup açılırsa aynı idleri tekrar ekliyor*/
		document.create_selected_list.list_app_pos_id.value='';
<cfelse>
	alert("<cf_get_lang dictionary_id='57484.Kayıt Yok'>!")
</cfif>
} 
function edit_select_list()
{
<cfif notice_app_list.recordcount>
	<cfif notice_app_list.recordcount gt 1> 
		for(i=0;i<list_application.ozgecmis_id.length;i++)
			if(document.list_application.ozgecmis_id[i].checked)
			{
			if(document.create_selected_list.list_empapp_id.value.length==0) ayirac=''; else ayirac=',';
				document.create_selected_list.list_empapp_id.value=document.create_selected_list.list_empapp_id.value+ayirac+document.list_application.ozgecmis_id[i].value;
				document.create_selected_list.list_app_pos_id.value=document.create_selected_list.list_app_pos_id.value+ayirac+document.list_application.basvuru_id[i].value;
			}
	<cfelse>
		if(document.list_application.ozgecmis_id.checked)
			document.create_selected_list.list_empapp_id.value=document.list_application.ozgecmis_id.value;
			document.create_selected_list.list_app_pos_id.value=document.list_application.basvuru_id.value;
	</cfif>
	if(document.create_selected_list.list_empapp_id.value.length==0)
	{
		alert("<cf_get_lang dictionary_id ='56841.Özgeçmiş Seçmelisiniz'>");
		return false;
	}
		windowopen('','list','select_list_window');
		create_selected_list.action='<cfoutput>#request.self#?fuseaction=hr.popup_add_select_emp_list&old=1</cfoutput>';
		create_selected_list.target='select_list_window';create_selected_list.submit();
		document.create_selected_list.list_empapp_id.value='';/* id_leri boşaltıyoruz popup açılıp bi ilem yapılmadn kapatılır ve tekrar popup açılırsa aynı idleri tekrar ekliyor*/
		document.create_selected_list.list_app_pos_id.value='';
<cfelse>
	alert("<cf_get_lang dictionary_id='57484.Kayıt Yok'>!")
</cfif>	
}
</script> 

<!--- bu sayfanın benzeri hr de var değişiklik yapılırsa orayada taşınmalı...--->
<cfif get_module_user(3) eq 0>
	<cfquery name="get_list" datasource="#dsn#">
		SELECT
			EASL.*
		FROM
			EMPLOYEES_APP_SEL_LIST EASL,
			EMPLOYEES_APP_AUTHORITY EA
		WHERE
			EA.POS_CODE=#session.ep.position_code# AND
			EA.LIST_ID=#attributes.list_id# AND
			EASL.LIST_ID=#attributes.list_id#
	</cfquery>
	<cfif not get_list.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='31869.Bu Seçim Listesine Yetkiniz Yok'>");
		history.go(-1);
	</script>
	<cfabort>
	</cfif>
<cfelse>
	<cfquery name="get_list" datasource="#dsn#">
		SELECT
			*
		FROM
			EMPLOYEES_APP_SEL_LIST
		WHERE
			LIST_ID=#attributes.list_id#
	</cfquery>
</cfif>

<cfif len(get_list.position_id)>
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
	<cfquery name="get_position_cat" datasource="#dsn#">
		SELECT 
			* 
		FROM 
			SETUP_POSITION_CAT 
		WHERE 
			POSITION_CAT_ID IN (#ListSort(attributes.position_cat_id,"numeric")#)
	</cfquery>
	<cfset position_cat = "#get_position_cat.position_cat#">
<cfelse>
	<cfset position_cat = "">
</cfif>
<cfsavecontent variable="right">
	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_page_warnings&action=myhome.upd_emp_app_select_list&action_name=list_id&action_id=#attributes.list_id#</cfoutput>','list');" style="color:#E08283;font-size:16px;"><i class="fa fa-exclamation-circle" title="<cf_get_lang dictionary_id='57757.Uyarılar'>"></i></a>
	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_upd_select_list&list_id=#attributes.list_id#</cfoutput>','medium');" style="color:#E08283;font-size:16px;margin-left:10px;"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
</cfsavecontent>
<cf_box title="#getLang('','Seçim Listesi',31870)#" right_images="#right#">
	<cf_box_elements>
		<div class="col col-9">
			<div class="col col-3">
				<div class="form-group">
					<label class="col col-6 bold"><cf_get_lang dictionary_id='57480.Konu'>:</label>
					<div class="col col-6"><cfoutput>#get_list.list_name#</cfoutput></div>
				</div>
				<div class="form-group">
					<label class="col col-6 bold"><cf_get_lang dictionary_id='57585.Kurumsal Üye'>:</label>
					<div class="col col-6"><cfif len(get_list.company_id)><cfoutput>#get_par_info(get_list.company_id,1,0,0)#</cfoutput></cfif></div>
				</div>
				<div class="form-group">
					<label class="col col-6 bold"><cf_get_lang dictionary_id='31334.İlan'>:</label>
					<div class="col col-6">
						<cfif len(get_list.notice_id)>
							<cfquery name="get_notice" datasource="#dsn#">
								SELECT NOTICE_HEAD,NOTICE_NO FROM NOTICES WHERE NOTICE_ID = #get_list.notice_id#
							</cfquery>
							<cfoutput>#get_notice.NOTICE_NO#-#get_notice.NOTICE_HEAD#</cfoutput>
						</cfif>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-6 bold"><cf_get_lang dictionary_id='31871.Personel İstek Formu'>:</label>
					<div class="col col-6"><cfoutput>#get_list.pif_id#</cfoutput></div>
				</div>
				<div class="form-group">
					<label class="col col-6 bold"><cf_get_lang dictionary_id='57629.Açıklama'>:</label>
					<div class="col col-6"><cfoutput>#get_list.list_detail#</cfoutput></div>
				</div>
			</div>
			<div class="col col-3">
				<div class="form-group">
					<label class="col col-6 bold"><cf_get_lang dictionary_id='57756.Durum'>:</label>
					<div class="col col-6"><cfif get_list.list_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></div>
				</div>
				<div class="form-group">
					<label class="col col-6 bold"><cf_get_lang dictionary_id='57453.Şube'>:</label>
					<div class="col col-6">
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
						<cfif isdefined('get_our_company') and get_our_company.recordcount><cfoutput>#get_our_company.branch_name#</cfoutput></cfif>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-6 bold"><cf_get_lang dictionary_id='57572.Departman'>:</label>
					<div class="col col-6">
						<cfif isdefined('get_our_company') and get_our_company.recordcount><cfoutput>#get_our_company.department_head#</cfoutput></cfif>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-6 bold"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'>:</label>
					<div class="col col-6"><cfoutput>#POSITION_CAT#</cfoutput></div>
				</div>
				<div class="form-group">
					<label class="col col-6 bold"><cf_get_lang dictionary_id='58497.Pozisyon'>:</label>
					<div class="col col-6"><cfoutput>#app_position#</cfoutput></div>
				</div>
				<div class="form-group">
					<label class="col col-6 bold"><cf_get_lang dictionary_id='57482.Aşama'>:</label>
					<div class="col col-6">
						<cfif len(get_list.sel_list_stage)>
							<cfquery name="get_process" datasource="#dsn#">
								SELECT 
									PROCESS_TYPE_ROWS.STAGE
								FROM
									PROCESS_TYPE_ROWS
								WHERE
									PROCESS_TYPE_ROWS.PROCESS_ROW_ID =#get_list.sel_list_stage#
							</cfquery>
						 	<cfoutput>#get_process.STAGE#</cfoutput>
						</cfif>
					</div>
				</div>
			</div>
		</div>
	</cf_box_elements>
	<cf_box_footer>
		<cfif len(get_list.RECORD_EMP)>
			<cf_record_info query_name="get_list">
		</cfif>
	</cf_box_footer>
</cf_box>
<cfparam name="attributes.row_status" default="1">
<cfparam name="attributes.row_order" default="">

<cfquery name="get_emp_app" datasource="#dsn#">
	SELECT
		LR.LIST_ROW_ID,
		LR.EMPAPP_ID,
		LR.APP_POS_ID,
		EA.EMPAPP_ID,
		EA.NAME,
		EA.SURNAME,
		LR.RECORD_DATE,
		LR.RECORD_EMP,
		LR.STAGE,
		EAEI.EDU_NAME AS EDU_NAME,
		EAEI.EDU_PART_NAME AS EDU_PART_NAME
	FROM
		EMPLOYEES_APP_SEL_LIST_ROWS AS LR,
		EMPLOYEES_APP EA,
		EMPLOYEES_APP_EDU_INFO EAEI
	WHERE
		LR.LIST_ID=#attributes.list_id#
		AND LR.EMPAPP_ID=EA.EMPAPP_ID
		AND EA.EMPAPP_ID = EAEI.EMPAPP_ID
		AND EAEI.EMPAPP_EDU_ROW_ID IN( SELECT MAX(EMPAPP_EDU_ROW_ID) FROM EMPLOYEES_APP_EDU_INFO WHERE EMPLOYEES_APP_EDU_INFO.EMPAPP_ID = EAEI.EMPAPP_ID)
	<cfif IsDefined('attributes.row_status') and len(attributes.row_status)>
		AND ROW_STATUS=#attributes.row_status#
	</cfif>
UNION
	SELECT
		LR.LIST_ROW_ID,
		LR.EMPAPP_ID,
		LR.APP_POS_ID,
		EA.EMPAPP_ID,
		EA.NAME,
		EA.SURNAME,
		LR.RECORD_DATE,
		LR.RECORD_EMP,
		LR.STAGE,
		'' AS EDU_NAME,
		'' AS EDU_PART_NAME
	FROM
		EMPLOYEES_APP_SEL_LIST_ROWS AS LR,
		EMPLOYEES_APP EA
	WHERE
		LR.LIST_ID=#attributes.list_id#
		AND LR.EMPAPP_ID=EA.EMPAPP_ID
		AND EA.EMPAPP_ID NOT IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_EDU_INFO WHERE EMPLOYEES_APP_EDU_INFO.EMPAPP_ID = EA.EMPAPP_ID)
		AND ROW_STATUS=1 
	ORDER BY
		<cfif len(attributes.row_order)>
			<cfif attributes.row_order eq 1>
			EA.NAME
			<cfelseif attributes.row_order eq 2>
			EA.NAME DESC
			<cfelseif attributes.row_order eq 3>
			EA.SURNAME
			<cfelseif attributes.row_order eq 4>
			EA.SURNAME DESC
			<cfelseif attributes.row_order eq 5>
			EDU_NAME
			<cfelseif attributes.row_order eq 6>
			LR.STAGE DESC,EA.NAME
			</cfif>
		<cfelse>
			EA.NAME
		</cfif>
		
</cfquery>

<cfquery name="get_count_list_row" datasource="#dsn#">
	SELECT
		COUNT(ROW_STATUS) TOPLAM,
		ROW_STATUS
	FROM
		EMPLOYEES_APP_SEL_LIST_ROWS
	WHERE
		LIST_ID=#attributes.list_id#
	GROUP BY
		LIST_ID,ROW_STATUS
</cfquery>
<cfset pasif_row=0>
<cfset aktif_row=0>
<cfoutput query="get_count_list_row">
<cfif get_count_list_row.row_status eq 1>
	<cfset aktif_row=get_count_list_row.toplam>
<cfelse>
	<cfset pasif_row=get_count_list_row.toplam>
</cfif>
</cfoutput> 

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_emp_app.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfsavecontent variable="title"><cf_get_lang no ='1112.Seçim Listesi'><cfoutput>&nbsp;&nbsp;(#aktif_row# / #aktif_row+pasif_row#)</cfoutput></cfsavecontent>
<cf_box title="#title#">
	<cfform name="search_list_row" action="#request.self#?fuseaction=myhome.upd_emp_app_select_list&list_id=#attributes.list_id#" method="post">
		<div class="ui-form-list flex-list">
			<div class="form-group">
				<select name="row_order" id="row_order">
					<option value=""  <cfif not len(attributes.row_order)>selected</cfif>><cf_get_lang dictionary_id='31872.Sırala'>
					<option value="1" <cfif attributes.row_order eq 1>selected</cfif>><cf_get_lang dictionary_id='31873.Ad Artan'>
					<option value="2" <cfif attributes.row_order eq 2>selected</cfif>><cf_get_lang dictionary_id='31874.Ad Azalan'>
					<option value="3" <cfif attributes.row_order eq 3>selected</cfif>><cf_get_lang dictionary_id='31875.Soyad Artan'>
					<option value="4" <cfif attributes.row_order eq 4>selected</cfif>><cf_get_lang dictionary_id='31876.Soyad Azalan'>
					<option value="5" <cfif attributes.row_order eq 5>selected</cfif>><cf_get_lang dictionary_id='57709.Okul'>
					<option value="6" <cfif attributes.row_order eq 6>selected</cfif>><cf_get_lang dictionary_id='57482.Aşama'>
				</select>
			</div>
			<div class="form-group">
				<select name="row_status" id="row_status">
					<option value="" <cfif not len(attributes.row_status)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>
					<option value="1" <cfif attributes.row_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
					<option value="0" <cfif attributes.row_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>
				</select>
			</div>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı!',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4">
			</div>
			<div class="form-group">
				<a href="javascript://" class="ui-btn ui-btn-gray2" onClick="windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_find_select_list&list_id=#attributes.list_id#','list'</cfoutput>);"><i class="fa fa-users" title="<cf_get_lang dictionary_id='57904.Daha Fazlası'>"></i></a>
			</div>
		</div>
	</cfform>
	<cf_grid_list>
		<cfform name="select_list" action="#request.self#?fuseaction=myhome.emptypopup_upd_select_list_rows&list_id=#attributes.list_id#" method="post">
			<thead>
				<th><cf_get_lang dictionary_id='32370.Adı Soyadı'></th>
				<th><cf_get_lang dictionary_id='57709.Okul'></th>
				<th><cf_get_lang dictionary_id='30496.Yaş'></th>
				<th><cf_get_lang dictionary_id='55912.Son Tecrübe'></th>
				<th><cf_get_lang dictionary_id='30631.Tarih'></th>
				<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
				<th><cf_get_lang dictionary_id='57756.Durum'></th>
				<th width="20"><i class="icon-time" title="<cf_get_lang dictionary_id='58496.Olay Ekle'>"></i></th>
				<th width="20"><i class="icon-pencil-square-o" title="<cf_get_lang dictionary_id='57465.Not Ekle'>"></i></th>
				<th width="20"><i class="fa fa-folder-open" title="<cf_get_lang dictionary_id='31878.Tüm Yazışma ve Değerlendirmeler'>"></i></th>
				<th width="20"><i class="icon-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></th>
				<th width="20"><input type="checkbox" name="all_check" id="all_check" value="1" onclick="javascript: hepsi();"><input type="hidden" value="" name="del" id="del"></th>
			</thead>
			<tbody>
				<cfif get_emp_app.recordcount>
					<cfoutput query="get_emp_app" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>
								<cfif len(get_emp_app.app_pos_id) and get_emp_app.app_pos_id gt 0>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_dsp_cv&empapp_id=#get_emp_app.empapp_id#&app_pos_id=#get_emp_app.app_pos_id#','page');" class="tableyazi">#get_emp_app.name# #get_emp_app.surname# </a>-(<cf_get_lang dictionary_id='31036.Başvuru'>)
								<cfelse>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_dsp_cv&empapp_id=#get_emp_app.empapp_id#','page');" class="tableyazi">#get_emp_app.name# #get_emp_app.surname# </a>-(<cf_get_lang dictionary_id='49821.Özgeçmiş'>)
								</cfif>
							</td>
							<td>
								<cfif len(EDU_NAME)>#EDU_NAME#</cfif> <cfif len(EDU_PART_NAME)> - #EDU_PART_NAME#</cfif>
							<td>
								<cfquery name="get_birth_date" datasource="#dsn#">
								SELECT BIRTH_DATE FROM EMPLOYEES_IDENTY WHERE EMPAPP_ID IS NOT NULL AND EMPAPP_ID = #empapp_id# 
								</cfquery>
								<cfif get_birth_date.RECORDCOUNT and len(get_birth_date.BIRTH_DATE)>
									<cfset YAS = datediff("yyyy",get_birth_date.BIRTH_DATE,now())>
									<cfif YAS neq 0>
									#YAS#
									</cfif>	
								</cfif>
							</td>
							<td>
								<cfquery name="get_app_work_info" datasource="#dsn#" maxrows="1">
									SELECT EXP,EXP_POSITION,EXP_FINISH FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = #empapp_id# ORDER BY EXP_START DESC
								</cfquery>
							<cfif get_app_work_info.recordcount>
								#get_app_work_info.exp#-#get_app_work_info.exp_position#-#dateformat(get_app_work_info.exp_finish,'mm/yyyy')#
							</cfif>
							</td>
							<td>#dateformat(get_emp_app.record_date,dateformat_style)#</td>
							<td>#get_emp_info(get_emp_app.record_emp,0,1)#</td>
							<cfif len(stage)>
								<cfquery name="get_stage" datasource="#dsn#">
									SELECT 
										PROCESS_TYPE_ROWS.STAGE
									FROM
										PROCESS_TYPE_ROWS
									WHERE
										PROCESS_ROW_ID=#get_emp_app.stage#
								</cfquery>
								<td>#get_stage.stage#</td>
							<cfelse>
								<td></td>
							</cfif>
							<!-- sil -->
								<td align="center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_add_event&action_id=#get_emp_app.list_row_id#&action_section=SELECT_LIST_ROW_ID&empapp_id=#get_emp_app.empapp_id#','list')"><i class="icon-time" title="<cf_get_lang dictionary_id='58496.Olay Ekle'>"></i></a></td>
								<td align="center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_add_note&module=hr&module_id=3&action=LIST_ROW_ID&action_id=#get_emp_app.list_row_id#&action_type=0','small');"><i class="icon-pencil-square-o" title="<cf_get_lang dictionary_id='57465.Not Ekle'>"></i></td>
								<td align="center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_list_app_quiz&list_id=#attributes.list_id#&empapp_id=#get_emp_app.empapp_id#&list_row_id=#get_emp_app.list_row_id#<cfif len(get_emp_app.app_pos_id)>&app_pos_id=#get_emp_app.app_pos_id#</cfif>','medium');"><i class="fa fa-folder-open" title="<cf_get_lang dictionary_id='31878.Tüm Yazışma ve Değerlendirmeler'>"></i></a></td>
								<td align="center"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&print_type=170&iid=#get_emp_app.empapp_id#&action_row_id=#attributes.list_id#','page','workcube_print');"><i class="icon-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></td>
								<td align="center"><input type="checkbox" value="#get_emp_app.list_row_id#" name="list_row_id" id="list_row_id"></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="14">
							<cf_get_lang dictionary_id='57484.Kayıt Yok'> !
						</td>
					</tr>
				</cfif>
			</tbody>
			
		</cfform>
	</cf_grid_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfset url_str = "&list_id=#attributes.list_id#&row_status=#attributes.row_status#&row_order=#attributes.row_order#">
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="myhome.upd_emp_app_select_list#url_str#"> 
	</cfif>
</cf_box>
			
<cf_box>
	<cf_box_elements vertical="1">
		<div class="form-group col col-3">
			<cf_workcube_process 
				is_upd='0' 
				process_cat_width='150' 
				is_detail='0'>
		</div>
	</cf_box_elements>
	<cf_box_footer>
		<cf_workcube_buttons is_upd='1' is_delete='0' is_cancel='0' add_function='kontrol_row2()'>
		<cf_workcube_buttons is_upd='1' is_delete='0' is_cancel='0' add_function='kontrol_row()' insert_info='#getLang('','Sil',57463)#'>
	</cf_box_footer>
</cf_box>
<br/>
<script type="text/javascript">
function kontrol_row()
{
	if(select_list.list_row_id.length>0)
	{
		for(i=0;i<select_list.list_row_id.length;i++)
		if(select_list.list_row_id[i].checked == true)
		{
			select_list.del.value='1';
			select_list.submit();
			return true;
		}
	}
	else
	{
		if(select_list.list_row_id.checked == true)
		{
			select_list.del.value='1';
			select_list.submit();
			return true;
		}
	}
		alert("<cf_get_lang dictionary_id='30942.Listeden Satır Seçmelisiniz'>");
		return false;
}

function kontrol_row2()
{
	if(select_list.list_row_id.length>0)
	{
		for(i=0;i<select_list.list_row_id.length;i++)
		if(select_list.list_row_id[i].checked == true)
		{
			select_list.submit();
			return true;
		}
	}
	else
	{
		if(select_list.list_row_id.checked == true)
		{
			select_list.submit();
			return true;
		}
	}
		alert("<cf_get_lang dictionary_id='30942.Listeden Satır Seçmelisiniz'>");
		return false;
}

function hepsi()
{
	if (document.select_list.all_check.checked)
		{
	<cfif get_emp_app.recordcount gt 1>	
		for(i=0;i<select_list.list_row_id.length;i++) select_list.list_row_id[i].checked = true;
	<cfelseif get_emp_app.recordcount eq 1>
		select_list.list_row_id.checked = true;
	</cfif>
		}
	else
		{
	<cfif get_emp_app.recordcount gt 1>	
		for(i=0;i<select_list.list_row_id.length;i++) select_list.list_row_id[i].checked = false;
	<cfelseif get_emp_app.recordcount eq 1>
		select_list.list_row_id.checked = false;
	</cfif>
		}
}

function send_mail()
{
windowopen('','list','select_list_window');
select_list.action='<cfoutput>#request.self#?fuseaction=hr.popup_app_add_mail&mail_sum=1&list_id=#attributes.list_id#</cfoutput>';
select_list.target='select_list_window';select_list.submit();
}

function start_work()
{
	if(select_list.list_row_id.length>0)
	{
		for(i=0;i<select_list.list_row_id.length;i++)
		if(select_list.list_row_id[i].checked == true)
		{
			windowopen('','list','select_list_window');
			select_list.action='<cfoutput>#request.self#?fuseaction=hr.popup_add_app_test_time&list_id=#attributes.list_id#&toplu=1</cfoutput>';
			select_list.target='select_list_window';
			select_list.submit();
			return true;
		}
	}
		alert("<cf_get_lang no ='1021.Listeden Satır Seçmelisiniz'>");
		return false;
}

/*<!--- bu sayfada list_row_id yi alabilmekk için function a var11 değeri eklendi..--->
function Add_Event(var1,var2,var3,var4,var5,var6,var7,var8,var9,var10,var11)
	{
		windowopen('index.cfm?fuseaction=objects.popup_form_add_event&action_id='+var11+'&action_section=SELECT_LIST_ROW_ID','page');
		event_name = var1;
		event_emp_id = var2;
		event_pos_id = var3;
		event_pos_code = var4;
		event_cons_ids = var5;
		event_comp_ids = var6;
		event_par_ids = var7;
		event_grp_ids = var8;
		event_wgrp_ids = var9;
		event_add_type = var10;
	}*/
</script>

<!--- bu sayfanın yetkilere göre ayarlı şekli myhome dada var değişiklik yapılırsa orayada taşınmalı...--->
<cfquery name="GET_LIST" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_APP_SEL_LIST WHERE LIST_ID=#attributes.list_id#
</cfquery>
<cfset cmp_process = createObject('component','V16.workdata.get_process')>
<cfset get_process1 = cmp_process.GET_PROCESS_TYPES(faction_list : 'hr.update_positions')>
<cfif len(GET_LIST.POSITION_ID)>
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

<cfif len(get_list.POSITION_CAT_ID)>
	<cfset attributes.POSITION_CAT_ID = get_list.POSITION_CAT_ID>
	<cfinclude template="../query/get_position_cat.cfm">
	<cfset POSITION_CAT = "#GET_POSITION_CAT.POSITION_CAT#">
<cfelse>
	<cfset POSITION_CAT = "">
</cfif>
<cf_catalystHeader>
<cf_box>	
	<cf_box_elements>
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group" id="item-list_name">
				<label class="col col-3 col-xs-12 txtbold"><cf_get_lang dictionary_id='57480.Konu'></label>
				<label class="col col-9 col-xs-12">
					: <cfoutput>#get_list.list_name#</cfoutput>
				</label>
			</div>
			<div class="form-group" id="item-company_id">
				<label class="col col-3 col-xs-12 txtbold"><cf_get_lang dictionary_id='57585.Kurumsal Üye'></label>
				<label class="col col-9 col-xs-12">
					:<cfif len(get_list.company_id)><cfoutput>#get_par_info(get_list.company_id,1,0,0)#</cfoutput></cfif>
				</label>
			</div>
			<div class="form-group" id="item-get_notice">
				<label class="col col-3 col-xs-12 txtbold"><cf_get_lang dictionary_id='55159.İlan'></label>
				<label class="col col-9 col-xs-12">
					: 
					<cfif len(get_list.notice_id)>
						<cfquery name="get_notice" datasource="#dsn#">
							SELECT NOTICE_HEAD,NOTICE_NO FROM NOTICES WHERE NOTICE_ID = #get_list.notice_id#
						</cfquery>
						<cfoutput>#get_notice.NOTICE_NO#-#get_notice.NOTICE_HEAD#</cfoutput>
					</cfif>
				</label>
			</div>
			<div class="form-group" id="item-pif_id">
				<label class="col col-3 col-xs-12 txtbold"><cf_get_lang dictionary_id ='56204.Personel İstek Formu'></label>
				<label class="col col-9 col-xs-12">
					: <cfoutput>#get_list.pif_id#</cfoutput>
				</label>
			</div>
		</div>
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
			<div class="form-group" id="item-branch_name">
				<label class="col col-3 col-xs-12 txtbold"><cf_get_lang dictionary_id='57453.Şube'></label>
				<label class="col col-9 col-xs-12">
					:<cfif len(get_list.department_id) and len(get_list.our_company_id)>
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
				</label>
			</div>
			<div class="form-group" id="item-company_id">
				<label class="col col-3 col-xs-12 txtbold"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
				<label class="col col-9 col-xs-12">
					: <cfoutput>#POSITION_CAT#</cfoutput>
				</label>
			</div>
			<div class="form-group" id="item-STAGE">
				<label class="col col-3 col-xs-12 txtbold"><cf_get_lang dictionary_id ='57482.Aşama'></label>
				<label class="col col-9 col-xs-12">
					:<cfif len(get_list.sel_list_stage)>
					<!--- uyarı vermemesi işin aşama el ile değiştiriliyor--->
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
				</label>
			</div>
			<div class="form-group" id="item-list_detail">
				<label class="col col-3 col-xs-12 txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></label>
				<label class="col col-9 col-xs-12">
					: <cfoutput>#get_list.list_detail#</cfoutput>
				</label>
			</div>
		</div>
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
			<div class="form-group" id="item-list_status">
				<label class="col col-3 col-xs-12 txtbold"><cf_get_lang dictionary_id='57756.Durum'></label>
				<label class="col col-9 col-xs-12">
					: <cfif get_list.list_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif>
				</label>
			</div>
			<div class="form-group" id="item-department_head">
				<label class="col col-3 col-xs-12 txtbold"><cf_get_lang dictionary_id='57572.Departman'></label>
				<label class="col col-9 col-xs-12">
					: <cfif isdefined('get_our_company') and get_our_company.recordcount><cfoutput>#get_our_company.department_head#</cfoutput></cfif>
				</label>
			</div>
			<div class="form-group" id="item-app_position">
				<label class="col col-3 col-xs-12 txtbold"><cf_get_lang dictionary_id='58497.Pozisyon'> *</label>
				<label class="col col-9 col-xs-12">
					: <cfoutput>#app_position#</cfoutput>
				</label>
			</div>
		</div>
	</cf_box_elements>
	<cf_box_footer>
		<cf_record_info query_name="get_list">
	</cf_box_footer>
</cf_box>
<cfparam name="attributes.row_status" default="1">
<cfparam name="attributes.row_order" default="">
<cfquery name="get_emp_app" datasource="#dsn#">
	SELECT
		LR.LIST_ROW_ID,
		LR.EMPAPP_ID,
		LR.APP_POS_ID,
		LR.ROW_STATUS,
		EA.NAME,
		EA.SURNAME,
		LR.RECORD_DATE,
		LR.RECORD_EMP,
		LR.STAGE,
		EA.APP_COLOR_STATUS,
		EA.WORK_STARTED,
		EA.WORK_FINISHED,
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
		AND ROW_STATUS = #attributes.row_status#
	</cfif>
UNION
	SELECT
		LR.LIST_ROW_ID,
		LR.EMPAPP_ID,
		LR.APP_POS_ID,
		LR.ROW_STATUS,
		EA.NAME,
		EA.SURNAME,
		LR.RECORD_DATE,
		LR.RECORD_EMP,
		LR.STAGE,
		EA.APP_COLOR_STATUS,
		EA.WORK_STARTED,
		EA.WORK_FINISHED,
		'' AS EDU_NAME,
		'' AS EDU_PART_NAME
	FROM
		EMPLOYEES_APP_SEL_LIST_ROWS AS LR,
		EMPLOYEES_APP EA
	WHERE
		LR.LIST_ID=#attributes.list_id#
		AND LR.EMPAPP_ID=EA.EMPAPP_ID
		AND EA.EMPAPP_ID NOT IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_EDU_INFO WHERE EMPLOYEES_APP_EDU_INFO.EMPAPP_ID = EA.EMPAPP_ID)
		<cfif IsDefined('attributes.row_status') and len(attributes.row_status)>
		AND ROW_STATUS = #attributes.row_status#
	</cfif> 
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
			<!--- EA.EDU1, EA.EDU2, EA.EDU3, EA.EDU4, EA.EDU5, EA.NAME --->
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
<cfsavecontent variable="txt">
    <cf_get_lang dictionary_id='56037.Seçim Listesi'> <cfoutput>&nbsp;&nbsp;(#aktif_row# / #aktif_row+pasif_row#)</cfoutput>
</cfsavecontent>
<cf_box>
	<cfform name="search_list_row" action="#request.self#?fuseaction=hr.emp_app_select_list&event=det&list_id=#attributes.list_id#" method="post">
		<cf_box_search more="1"> 
				<div class="form-group">
						<select name="row_order" id="row_order">
							<option value=""  <cfif not len(attributes.row_order)>selected</cfif>><cf_get_lang dictionary_id='56043.Sırala'>
							<option value="1" <cfif attributes.row_order eq 1>selected</cfif>><cf_get_lang dictionary_id='56044.Ad Artan'>
							<option value="2" <cfif attributes.row_order eq 2>selected</cfif>><cf_get_lang dictionary_id='56045.Ad Azalan'>
							<option value="3" <cfif attributes.row_order eq 3>selected</cfif>><cf_get_lang dictionary_id='56046.Soyad Artan'>
							<option value="4" <cfif attributes.row_order eq 4>selected</cfif>><cf_get_lang dictionary_id='56047.Soyad Azalan'>
							<option value="5" <cfif attributes.row_order eq 5>selected</cfif>><cf_get_lang dictionary_id='57709.Okul'>
							<option value="6" <cfif attributes.row_order eq 6>selected</cfif>><cf_get_lang dictionary_id='57482.Aşama'>
						</select>
				</div>
				<div class="form-group">
						<select name="row_status" id="row_status">
							<option value="" <cfif not len(attributes.row_status)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>	
							<option value="1" <cfif attributes.row_status eq 1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
							<option value="0" <cfif attributes.row_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>			                        
						</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,1250" required="yes" message="#message#">
				</div>
				<div class="form-group">
					<cf_wrk_search_button is_excel='0' button_type="4">
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_employees_app&form_action=hr.emptypopup_add_select_list_empapp&list_id=#attributes.list_id#','list'</cfoutput>);"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
				</div>
		</cf_box_search>
		<cf_box_search_detail>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-status">
					<label class="col col-12"><cf_get_lang dictionary_id='57756.Durum'></label>
					<div class="col col-12">
						<div class="input-group">
							<select name="status" id="status">
								<option value="" selected><cf_get_lang dictionary_id='57708.Tümü'>
								<option value="1"><cf_get_lang dictionary_id='57493.Aktif'>
								<option value="0"><cf_get_lang dictionary_id='57494.Pasif'>               
							</select>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-prefered_city">
					<label class="col col-12"><cf_get_lang dictionary_id='55329.Çalışmak İstediği Yer'></label>
					<div class="col col-12">
						<cfquery name="get_city" datasource="#dsn#">
							SELECT CITY_ID, CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
						</cfquery>
						<div class="input-group">
							<select name="prefered_city" id="prefered_city" style="width:150px;">
								<option value=""><cf_get_lang dictionary_id='56175.TÜM TÜRKİYE'></option>
								<cfoutput query="get_city">
									<option value="#city_id#">#city_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-app_name">
					<label class="col col-12"><cf_get_lang dictionary_id='57631.Ad'></label>
					<div class="col col-12">
						<div class="input-group">
							<input type="text" name="app_name" id="app_name" value="">
						</div>
					</div>
				</div>
				<div class="form-group" id="item-app_surname">
					<label class="col col-12"><cf_get_lang dictionary_id='58726.Soyad'></label>
					<div class="col col-12">
						<div class="input-group">
							<input type="text" name="app_surname" id="app_surname" value="">
						</div>
					</div>
				</div>
				<div class="form-group" id="item-birth_date">
					<label class="col col-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
					<div class="col col-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='641.başlangıç tarihi'></cfsavecontent>
							<cfinput type="text" name="birth_date" id="birth_date" validate="#validate_style#" message="#message#" value="#dateformat(now(),dateformat_style)#" style="width:70px;" maxlength="10" required="yes">
							<span class="input-group-addon"><cf_wrk_date_image date_field="birth_date"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-married">
					<label class="col col-12"><cf_get_lang dictionary_id='55654.Medeni Durum'></label>
					<div class="col col-12">
						<div class="input-group">
							<select name="married" id="married">
								<option value="0"><cf_get_lang dictionary_id='55744.Bekar'>
								<option value="1"><cf_get_lang dictionary_id='55743.Evli'>               
							</select>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-military_status">
					<label class="col col-12"><cf_get_lang dictionary_id='55619.Askerlik'></label>
					<div class="col col-12">
						<div class="input-group">
							<input type="checkbox" name="military_status" id="military_status" value="0">
							<cf_get_lang dictionary_id='55624.Yapmadı'>
							<input type="checkbox" name="military_status" id="military_status" value="1">
							<cf_get_lang dictionary_id='55625.Yaptı'>
							<input type="checkbox" name="military_status" id="military_status" value="2">
							<cf_get_lang dictionary_id='55626.Muaf'>
							<input type="checkbox" name="military_status" id="military_status" value="3">
							<cf_get_lang dictionary_id='55627.Yabancı'> 
							<input type="checkbox" name="military_status" id="military_status" value="4">
							<cf_get_lang dictionary_id='55340.Tecilli'>
						</div>
					</div>
				</div>
			</div>

			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-sex">
					<label class="col col-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
					<div class="col col-12">
						<div class="input-group">
							<select name="sex" id="sex">
								<option value="1"><cf_get_lang dictionary_id='58959.Erkek'>
								<option value="0"><cf_get_lang dictionary_id='55621.Kadın'>             
							</select>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-driver_licence">
					<label class="col col-12"><cf_get_lang dictionary_id='55255.Ehliyeti Var mı'>?</label>
					<div class="col col-12">
						<div class="input-group">
							<select name="driver_licence" id="driver_licence" onchange="driver_licence_check()">
								<option value="0"><cf_get_lang dictionary_id='57496.Hayır'>            
								<option value="1"><cf_get_lang dictionary_id='57495.Evet'>
							</select>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-driver_licence_type" style="display:none;">
					<label class="col col-12"><cf_get_lang dictionary_id='35233.Ehliyet Sınıf'></label>
					<div class="col col-12">
						<div class="input-group">
							<input type="text" name="driver_licence_type" id="driver_licence_type">
						</div>
					</div>
				</div>
				<div class="form-group" id="item-exp_year">
					<label class="col col-12"><cf_get_lang dictionary_id='55307.Deneyim'></label>
					<div class="col col-12">
						<div class="input-group">
							<input type="text" name="exp_year" id="exp_year">
						</div>
					</div>
				</div>
				<div class="form-group" id="item-edu4">
					<cfquery name="GET_EDU4" datasource="#DSN#">
						SELECT
							SCHOOL_ID,
							SCHOOL_NAME
						FROM
							SETUP_SCHOOL
						ORDER BY SCHOOL_NAME
					</cfquery>
					<label class="col col-12"><cf_get_lang dictionary_id='29755.Üniversite'></label>
					<div class="col col-12">
						<div class="input-group">
							<select name="edu4" id="edu4">
								<option value=""><cf_get_lang dictionary_id='29755.Üniversite'></option>
								<cfloop query="GET_EDU4">
									<option value="<cfoutput>#GET_EDU4.SCHOOL_ID#</cfoutput>"><cfoutput>#GET_EDU4.SCHOOL_NAME#</cfoutput></option>
								</cfloop>
							</select>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-edu4_part">
					<label class="col col-12"><cf_get_lang dictionary_id='57995.Bölüm'></label>
					<div class="col col-12">
						<div class="input-group">
							<cfsavecontent variable="text"><cf_get_lang dictionary_id='57995.Bölüm'></cfsavecontent>
							<cf_wrk_combo
								name="edu4_part"
								query_name="GET_SCHOOL_PART"
								option_name="PART_NAME"
								option_value="PART_ID"
								option_text="#text#">
						</div>
					</div>
				</div>
			</div>
		</cf_box_search_detail>
	</cfform>
</cf_box>
<cfform name="select_list" action="#request.self#?fuseaction=hr.emptypopup_upd_select_list_rows" method="post">		
	<cf_box title="#txt#">
		<cf_grid_list>
				<input type="hidden" name="list_id" id="list_id" value="<cfoutput>#attributes.list_id#</cfoutput>" />
				<thead>
					<tr>
						<th width="140"><cf_get_lang dictionary_id='57570.Adı Soyadı'></th>
						<th width="200"><cf_get_lang dictionary_id='57709.Okul'></th>
						<th width="30"><cf_get_lang dictionary_id='55745.Yaş'></th>
						<th width="200"><cf_get_lang dictionary_id='55912.Son Tecrübe'></th>					
						<th width="100"><cf_get_lang dictionary_id='57742.Tarih'></th>
						<th width="100"><cf_get_lang dictionary_id='57899.Kaydeden'></th>
						<th width="50"><cf_get_lang dictionary_id='57756.Durum'></th>   
						<!-- sil -->          
						<th width="25">
						<a href="javascript://" onclick="edit_app_color();"><i class="fa fa-object-ungroup" border="0" title="<cf_get_lang dictionary_id ='56844.Cv Değerlendirme Kategorileri Değiştir'>"></a></th>
						<th width="15" align="center"></th>
						<th width="15"></th>
						<th width="15"><a href="javascript://" onclick="send_mail();"><i class="fa fa-envelope-open" title="<cf_get_lang dictionary_id='57475.Email Gönder'>" border="0"></a></th>
						<th width="15"></th>
						<th></th>
						<th></th>
						<th><input type="checkbox" name="all_check" id="all_check" value="1"><input type="hidden" value="" name="del" id="del"><input type="hidden" name="list_app_pos_id" id="list_app_pos_id" value=""></th>
						<th>
							<i class="wrk-uF0027" title="<cf_get_lang dictionary_id='55703.İşe Başlat'>" alt="<cf_get_lang dictionary_id='55703.İşe Başlat'>"></i>
						</th>
						<!-- sil -->
					</tr>
				</thead>
				<cfif get_emp_app.recordcount>
					<cfset app_color_status_list =''>
				<cfoutput query="get_emp_app" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(app_color_status) and (not listfind(app_color_status_list,app_color_status))>
							<cfset app_color_status_list = listappend(app_color_status_list,get_emp_app.app_color_status,',')>
						</cfif>
					</cfoutput>
					<cfif listlen(app_color_status_list)>
						<cfquery name="get_cv_status" datasource="#dsn#">
							SELECT 
								STATUS_ID,
								STATUS,
								ICON_NAME
							FROM 
								SETUP_CV_STATUS
							WHERE 
								STATUS_ID IN (#app_color_status_list#)
							ORDER BY 
								STATUS_ID
						</cfquery>
						<cfset app_color_status_list = listsort(valuelist(get_cv_status.status_id,','),"numeric","ASC",',')>
					</cfif>
					<tbody>
					<cfoutput query="get_emp_app" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfquery name="get_app_work_info" datasource="#dsn#" maxrows="1">
							SELECT EXP,EXP_POSITION,EXP_FINISH FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = #empapp_id# ORDER BY EXP_START DESC
						</cfquery>
					<tr>
						<input type="hidden" name="action_type_id" id="action_type_id" value="#LIST_ROW_ID#">
						<input hidden="hidden" class="checkControl" type="checkbox" name="action_list_id" id="action_list_id" value="#LIST_ROW_ID#" checked/>
						<td>
						<cfif len(get_emp_app.app_pos_id)>
							<a href="#request.self#?fuseaction=hr.apps&event=upd&empapp_id=#get_emp_app.empapp_id#&app_pos_id=#get_emp_app.app_pos_id#" class="tableyazi">#get_emp_app.name# #get_emp_app.surname# </a>
						<cfelse>
							<a href="#request.self#?fuseaction=hr.list_cv&event=upd&empapp_id=#get_emp_app.empapp_id#" class="tableyazi">#get_emp_app.name# #get_emp_app.surname# </a>
						</cfif>
						</td>
						<td><cfif len(EDU_NAME)>#EDU_NAME#</cfif> <cfif len(EDU_PART_NAME)> - #EDU_PART_NAME#</cfif>
						</td>
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
						<td><cfif get_app_work_info.recordcount>#get_app_work_info.exp#-#get_app_work_info.exp_position#-#dateformat(get_app_work_info.exp_finish,'mm/yyyy')#</cfif></td>
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
							<td width="15" align="center">
								<cfif len(get_emp_app.app_color_status)>
								<img title="#get_cv_status.status[listfind(app_color_status_list,app_color_status,',')]#" src="#file_web_path#hr/cv_image/#get_cv_status.icon_name[listfind(app_color_status_list,app_color_status,',')]#">
								</cfif>
							</td>
							<td width="15" align="center"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_form_add_event&action_id=#get_emp_app.list_row_id#&action_section=SELECT_LIST_ROW_ID&empapp_id=#get_emp_app.empapp_id#')"><i class="icon-time" title="<cf_get_lang_main no='1084.Olay Ekle'>"></a></td>
							<td width="15" align="center"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_form_add_note&module=hr&module_id=3&action=EMPLOYEES_APP_ID&action_id=#get_emp_app.empapp_id#&action_type=0');"><i class="fa fa-pencil" title="<cf_get_lang_main no='53.Not Ekle'>" border="0"></a></td>
							<td width="15" align="center"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=hr.popup_app_add_mail&list_id=#attributes.list_id#&empapp_id=#get_emp_app.empapp_id#&list_row_id=#get_emp_app.list_row_id#<cfif len(get_emp_app.app_pos_id)>&app_pos_id=#get_emp_app.app_pos_id#</cfif>');"><i class="icon-envelope-o" title="<cf_get_lang no='225.Mail Ekle'>" border="0"></a></td>
							<td width="15" align="center"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=hr.popup_list_app_mail_quiz&list_id=#attributes.list_id#&empapp_id=#get_emp_app.empapp_id#&list_row_id=#get_emp_app.list_row_id#<cfif len(get_emp_app.app_pos_id)>&app_pos_id=#get_emp_app.app_pos_id#</cfif>');"><i class="fa fa-folder-open" title="<cf_get_lang no='966.Tüm Değerlendirme ve Yazışmalar'>" border="0"></a></td>
							<td width="15" align="center"><a href="#request.self#?fuseaction=objects.popup_print_files&print_type=170&iid=#get_emp_app.empapp_id#&action_row_id=#attributes.list_id#" target="_blank"><i class="icon-print" title="<cf_get_lang_main no='62.Yazdır'>" border="0"></a></td>
							<td width="15" align="center"><a href="javascript://" onClick="javascript:if (confirm('<cfif ROW_STATUS eq 0><cf_get_lang dictionary_id="64654.Seçili Kişiyi Listeden Siliyorsunuz!"><cfelse><cf_get_lang dictionary_id="64655.Seçili Kişiyi Pasif Yapıyorsunuz!"></cfif> <cf_get_lang dictionary_id="58588.Emin misiniz ?">')) windowopen('#request.self#?fuseaction=hr.emptypopup_del_select_list_empapp&list_id=#attributes.list_id#&empapp_id=#get_emp_app.empapp_id#&app_pos_id=#get_emp_app.app_pos_id#&del=1&ROW_STATUS=#ROW_STATUS#'); else return false;"><i class="icon-minus" title="<cf_get_lang_main no='51.Sil'>" border="0" ></a></td>
							<td align="center" width="15">
								<cfif get_emp_app.work_started eq 0 or get_emp_app.work_finished eq 1 or not len(get_emp_app.work_started)>
									<input type="checkbox" value="#list_row_id#" name="list_row_id" id="_list_row_id_" class="list_row">
									<input type="hidden" name="app_pos_id" id="app_pos_id" value="<cfif len(get_emp_app.app_pos_id)>#get_emp_app.app_pos_id#<cfelse>0</cfif>">
								<cfelse>
									<input type="hidden" value="#list_row_id#" name="list_row_id" id="">
								</cfif>
							</td>
							<input  type="hidden" name="cv_status" id="cv_status" value="<cfif get_emp_app.work_started eq 0 or get_emp_app.work_finished eq 1 or not len(get_emp_app.work_started)>1<cfelse>0</cfif>">
							<td align="center" width="15">
								<cfif get_emp_app.work_started eq 0 or get_emp_app.work_finished eq 1 or not len(get_emp_app.work_started)>
									<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=hr.popup_add_app_test_time&list_row_id=#get_emp_app.list_row_id#&list_app_pos_id=#get_emp_app.app_pos_id#&toplu=1&process_stage_='+document.select_list.process_stage.value+'');"><i class="wrk-uF0027" title="<cf_get_lang dictionary_id='55703.İşe Başlat'>" alt="<cf_get_lang dictionary_id='55703.İşe Başlat'>"></i></div></a>
								</cfif>
							</td>
							<input type="hidden" name="list_row_id" id="list_row_id" value="#get_emp_app.list_row_id#">
					</tr>
					</cfoutput>
					</tbody>
			<cfelse>
				<tbody>
					<tr>
						<td colspan="16">
							<cf_get_lang dictionary_id='57484.Kayıt yok'> !
						</td>
					</tr>
				</tbody>
			</cfif>
		</cf_grid_list>	
		<cf_box_elements>
			<div class="form-group">
				<!--- <cf_workcube_process
				is_upd='0'
				process_cat_width='150' 
				is_detail='0'> --->
			</div>				
		</cf_box_elements>
	</cf_box>
	<cf_box>
		<cf_box_elements vertical="1">
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-6 col-xs-12">
                    <cf_workcube_general_process termin_date="0" is_template_view="false" select_value="#get_emp_app.stage#">
                </div>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="ui-form-list-btn">
                        <input type="hidden" id="paper_submit" name="paper_submit" value="0">
                        <div>
							<cf_workcube_buttons is_upd='1' is_delete='1' delete_function="kontrol_row()" delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_emp_app_select_list&list_id=#attributes.list_id#' is_cancel='0' add_function='kontrol_row2()' type_format="1">
                            <!--- <input type="submit" name="setPositionProcess" id="setPositionProcess" onclick="if(confirm('<cf_get_lang dictionary_id='57535.Kaydetmek istediğinize emin misiniz'>')) return setPositionsProcess() && kontrol_row2(); else return false;" value="<cf_get_lang dictionary_id='57461.Kaydet'>"> --->
                        </div>
                    </div>
                </div>
			</div>
			<!--- <cf_workcube_general_process is_template_view="false"> --->
		</cf_box_elements>
		<cf_box_footer>
			<!--- <cf_workcube_buttons is_upd='1' is_delete='1' delete_function="kontrol_row()" delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_emp_app_select_list&list_id=#attributes.list_id#' is_cancel='0' add_function='kontrol_row2()' type_format="1">	 --->			
		</cf_box_footer>
	</cf_box>	
</cfform>
  
<!-- sil -->
<cfif attributes.totalrecords gt attributes.maxrows>
	<tr>
		<td>
		<cfset attributes_str = "&list_id=#attributes.list_id#&row_status=#attributes.row_status#&row_order=#attributes.row_order#">
		<cf_pages 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="hr.emp_app_select_list#attributes_str#">
		</td>
		<td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
	</tr>
 </cfif>
<!-- sil -->
<script type="text/javascript">
function setPositionsProcess(){
	if( $.trim($('#general_paper_no').val()) == '' ){
		alert("<cf_get_lang dictionary_id='33367.Lütfen Belge No Giriniz'>");
		return false;
	}else{
		paper_no_control = wrk_safe_query('general_paper_control','dsn',0,$('#general_paper_no').val());
		if(paper_no_control.recordcount > 0)
		{
			alert("<cf_get_lang dictionary_id='49009.Girdiğiniz Belge Numarası Kullanılmaktadır'>.<cf_get_lang dictionary_id='59367.Otomatik olarak değişecektir'>.");
			paper_no_val = $('#general_paper_no').val();
			paper_no_split = paper_no_val.split("-");
			if(paper_no_split.length == 1)
				paper_no = paper_no_split[0];
			else
				paper_no = paper_no_split[1];
			paper_no = parseInt(paper_no);
			paper_no++;
			if(paper_no_split.length == 1)
				$('#general_paper_no').val(paper_no);
			else
				$('#general_paper_no').val(paper_no_split[0]+"-"+paper_no);
			return false;
		}
	}
	if( $.trim($('#general_paper_date').val()) == '' ){
		alert("Lütfen Belge Tarihi Giriniz!");
		return false;
	}
	if( $.trim($('#general_paper_notice').val()) == '' ){
		alert("Lütfen Ek Açıklama Giriniz!");
		return false;
	}
	document.getElementById("paper_submit").value = 1;
	$('#setProcessForm').submit();
}
	$(document).ready(function(){
			$("#all_check").click(function(){
			$('.list_row').not(this).prop('checked', this.checked);
		});
		$('.list_row').on('click',function(){
				if($('.list_row:checked').length == $('.list_row').length){
					$('#all_check').prop('checked',true);
				}else{
					$('#all_check').prop('checked',false);
				}
			});
	});
function satir_kontrol()
{
	error_ = 1;
	if(select_list.list_row_id.length>0)
	{
		for(i=0;i<select_list.list_row_id.length;i++)
		if(select_list.list_row_id[i].checked == true)
		{
			error_ = 0;
		}
	}
	else if(select_list.list_row_id.checked == true)
	{
		error_ = 0;
	}
	if(error_==1)
	{
		alert('<cf_get_lang dictionary_id="56052.Listeden Satır Seçmelisiniz">');
		return false;
	}
	return true;
}
function kontrol_row()
{
	if(satir_kontrol())
	{
		document.getElementById('del').value='1';
		return process_cat_control();
	}
	else
	{
		return false;
	}
}

function kontrol_row2()
{
	setPositionsProcess();
	if(satir_kontrol())
	{
		return process_cat_control();
	}else
	{
		return false;
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
		if(document.getElementById('_list_row_id_')!=undefined)
			{
				if(document.getElementById('_list_row_id_').length>0)
					{
						var ayirac='';
						for(i=0;i<document.getElementById('_list_row_id_').length;i++)
							if(document.select_list.list_row_id[i].checked == true)
							{
								select_list.list_app_pos_id.value=select_list.list_app_pos_id.value+ayirac+select_list.app_pos_id[i].value;
								ayirac=',';
							}
							if(ayirac==',')
							{
								windowopen('','list','select_list_window');
								select_list.action='<cfoutput>#request.self#?fuseaction=hr.popup_add_app_test_time&list_id=#attributes.list_id#&process_stage_='+document.getElementById('process_stage').value+'&toplu=1</cfoutput>';
								select_list.target='select_list_window';
								select_list.submit();
								select_list.list_app_pos_id.value='';
								return true;
							}
							else
							{
								alert("<cf_get_lang dictionary_id='56052.Listeden Satır Seçmelisiniz'>");
								return false;
							}
					}
				else
					{
						if(document.getElementById('_list_row_id_').checked == true)
							{
							windowopen('','list','select_list_window');
							select_list.action='<cfoutput>#request.self#?fuseaction=hr.popup_add_app_test_time&list_id=#attributes.list_id#&process_stage_='+document.getElementById('process_stage').value+'&toplu=1</cfoutput>';
							select_list.target='select_list_window';
							select_list.submit();
							select_list.list_app_pos_id.value='';
							return true;
							}
						else
							{
							alert("<cf_get_lang dictionary_id='56052.Listeden Satır Seçmelisiniz'>");
							return false;
							}
					}
				
			}
		else
			{
				alert("<cf_get_lang dictionary_id='56816.Kişi Seçiniz'>");
				return false;
			}
	  }  
	  
function edit_app_color()
	{
	<cfif get_emp_app.recordcount>
		<cfif get_emp_app.recordcount gt 1> 
			if(select_list.list_row_id!=undefined)
				for(z=0;z<select_list.list_row_id.length;z++)
				{
					if(document.select_list.cv_status[z].value == 1)
					{
						if(document.select_list.list_row_id[z]!=undefined && document.select_list.list_row_id[z].checked)
						{
						if(document.getElementById('_list_row_id_').length==0) ayirac=''; else ayirac=',';
							document.getElementById('_list_row_id_').value=document.getElementById('_list_row_id_').value+ayirac+document.select_list.list_row_id[z].value;
						}
					}
				}
		<cfelse>
			if(document.getElementById('_list_row_id_')!=undefined && document.getElementById('_list_row_id_').checked)
			{
				document.getElementById('_list_row_id_').value=document.getElementById('_list_row_id_').value;
			}
		</cfif>
			windowopen('','small','select_list_window');
			select_list.action='<cfoutput>#request.self#?fuseaction=hr.popup_add_list_app_color_status&is_sel_list=1</cfoutput>';
			select_list.target='select_list_window';
			select_list.submit();
	<cfelse>
		alert("<cf_get_lang dictionary_id ='57484.Kayıt Yok'>!")
	</cfif>
	}

function driver_licence_check(){
	if ($("#driver_licence").val() == 1){
		$("#item-driver_licence_type").show();
	}else{
		$("#item-driver_licence_type").hide();
	}
}
</script>
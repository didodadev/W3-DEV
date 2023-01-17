<cfparam name="attributes.position_cat_id" default=''>
<cfparam name="attributes.emp_status" default=1>
<cfparam name="attributes.period_year" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch_name" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.my_form" default="">
<cfscript>
	if(not len(attributes.period_year) and isdefined('attributes.is_form_submit'))
		attributes.period_year = year(now());//session.ep.period_year degeri vardı ancak eski dönmede olabilir diye now yaptık
	url_str = "";
	if(isdefined('attributes.is_form_submit'))
	{
		url_str = '#url_str#&is_form_submit=#attributes.is_form_submit#';
		if(len(attributes.keyword))
			url_str = "#url_str#&keyword=#attributes.keyword#";
		if(len(attributes.my_form))
			url_str = "#url_str#&my_form=#attributes.my_form#";
		if(len(attributes.department_id))
			url_str = "#url_str#&department_id=#attributes.department_id#";
		if(len(attributes.department_name))
			url_str = "#url_str#&department_name=#attributes.department_name#";		
		if(len(attributes.branch_name))
			url_str="#url_str#&branch_name=#attributes.branch_name#";
		if(len(attributes.branch_id))
			url_str="#url_str#&branch_id=#attributes.branch_id#";
		if(isdefined("attributes.position_cat_id"))
			url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#";
		if(isdefined("attributes.period_year"))
			url_str = "#url_str#&period_year=#attributes.period_year#";
		if(isdefined("attributes.attenders"))
			url_str = "#url_str#&attenders=#attributes.attenders#";
		if(isdefined('emp_status'))
			url_str = '#url_str#&emp_status=#attributes.emp_status#';
		if(isdefined('per_stage'))
			url_str = '#url_str#&per_stage=#attributes.per_stage#';
		if(isdefined('perf'))
			url_str = '#url_str#&perf=#attributes.perf#';
	}
</cfscript>
<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
	SELECT
  		PTR.STAGE,
		PTR.PROCESS_ROW_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%myhome.list_perform%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfinclude template="../query/get_position_cats.cfm">
<cfif isdefined('attributes.is_form_submit') and attributes.is_form_submit eq 1>
	<cfquery name="get_all_positions" datasource="#dsn#">
		SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#
	</cfquery>
	<cfset pos_code_list = valuelist(get_all_positions.position_code)>
	<!---İzinde olan kişilerin vekalet bilgileri alınıypr --->
	<cfquery name="Get_Offtime_Valid" datasource="#dsn#">
		SELECT
			O.EMPLOYEE_ID,
			EP.POSITION_CODE
		FROM
			OFFTIME O,
			EMPLOYEE_POSITIONS EP
		WHERE
			O.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
			O.VALID = 1 AND
			#Now()# BETWEEN O.STARTDATE AND O.FINISHDATE
	</cfquery>
	<cfif Get_Offtime_Valid.recordcount>
		<cfset Now_Offtime_PosCode = ValueList(Get_Offtime_Valid.Position_Code)>
		<cfquery name="Get_StandBy_Position1" datasource="#dsn#"><!--- Asil Kisi Izinli ise ve 1.Yedek Izinli Degilse --->
			SELECT POSITION_CODE, CANDIDATE_POS_1 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN(#pos_code_list#)
		</cfquery>
		<cfoutput query="Get_StandBy_Position1">
			<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position1.Position_Code))>
		</cfoutput>
		<cfquery name="Get_StandBy_Position2" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek Izinli ise ve 2.Yedek Izinli Degilse --->
			SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#pos_code_list#)
		</cfquery>
		<cfoutput query="Get_StandBy_Position2">
			<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position2.Position_Code))>
		</cfoutput>
		<cfquery name="Get_StandBy_Position3" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek,2.Yedek Izinli ise ve 3.Yedek Izinli Degilse --->
			SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_3 IN (#pos_code_list#)
		</cfquery>
		<cfoutput query="Get_StandBy_Position3">
			<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position3.Position_Code))>
		</cfoutput>
	</cfif>
	<cfquery name="GET_UNDER_POS" datasource="#dsn#">
		SELECT 
			EMPLOYEE_POSITIONS.EMPLOYEE_ID,
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
			EMPLOYEE_POSITIONS.POSITION_NAME,
			EMPLOYEE_POSITIONS.POSITION_CAT_ID
		FROM 
			EMPLOYEE_POSITIONS,
			EMPLOYEE_POSITIONS_STANDBY,
			DEPARTMENT,
			BRANCH
		WHERE 
			EMPLOYEE_POSITIONS.POSITION_CODE = EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE
			AND EMPLOYEE_POSITIONS.DEPARTMENT_ID =DEPARTMENT.DEPARTMENT_ID
			AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
			AND EMPLOYEE_POSITIONS.EMPLOYEE_ID > 0
			AND 
			( 	EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE IN(#pos_code_list#)
				OR EMPLOYEE_POSITIONS_STANDBY.CHIEF1_CODE IN(#pos_code_list#) 
				OR EMPLOYEE_POSITIONS_STANDBY.CHIEF2_CODE IN(#pos_code_list#) 
				OR EMPLOYEE_POSITIONS_STANDBY.CHIEF3_CODE IN(#pos_code_list#) 
			)
			<cfif len(attributes.department_id)>
				AND DEPARTMENT.DEPARTMENT_ID = #attributes.department_id#
			</cfif> 
			<cfif len(attributes.branch_id)>
				AND BRANCH.BRANCH_ID = #attributes.branch_id#
			</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND
				(
					EMPLOYEE_POSITIONS.POSITION_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				)
			</cfif>
			<cfif isdefined('attributes.perf') and attributes.perf eq 1>
			AND EMPLOYEE_POSITIONS_STANDBY.CHIEF1_CODE IN(#pos_code_list#)
			<cfelseif isdefined('attributes.perf') and attributes.perf eq 2>
			AND EMPLOYEE_POSITIONS_STANDBY.CHIEF2_CODE IN(#pos_code_list#)
			<cfelseif isdefined('attributes.perf') and attributes.perf eq 3>
			AND EMPLOYEE_POSITIONS_STANDBY.CHIEF3_CODE IN(#pos_code_list#)
			</cfif>
	</cfquery>
	<cfif get_under_pos.recordcount>
		<cfset under_emp_list=valuelist(GET_UNDER_POS.EMPLOYEE_ID,',')>
	<cfelse>
		<cfset under_emp_list=0>
	</cfif>
	<cfinclude template="../query/get_perf_results.cfm">
<cfelse>
	<cfset get_perf_results.RECORDCOUNT = 0>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_perf_results.RECORDCOUNT#'>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search" method="post" action="#request.self#?fuseaction=myhome.list_perform">
			<input type="hidden" name="is_form_submit" id="is_form_submit" value="1">
			<cf_box_search>
				<div class="form-group" id="keyword">
					<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#"  value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group" id="my_form">    
					<cfinput type="text" name="my_form" placeholder="#getLang('','Form',29764)#" value="#attributes.my_form#" maxlength="50">
				</div>
				<div class="form-group" id="item-eval_date">
					<select name="period_year" id="period_year">
						<option value="" selected><cf_get_lang dictionary_id='31347.İlgili Yıl'></option>
						<cfloop from="#year(now())+1#" to="2006" index="yr" step="-1">
							<option value="<cfoutput>#yr#</cfoutput>" <cfif isdefined('attributes.period_year') and (yr eq attributes.period_year)>selected</cfif>><cfoutput>#yr#</cfoutput></option>
						</cfloop>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='kontrol()'>
					<cf_workcube_file_action pdf='0' mail='0' doc='0' print='1'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="branch_name">
						<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57572.Departman'></cfsavecontent>
						<input type="text" name="branch_name" id="branch_name" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.branch_name#</cfoutput>">
					</div>
					<div class="form-group" id="item-department_name">
						<div class="input-group">		
							<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#attributes.department_id#</cfoutput>">
							<cfinput type="text" name="department_name" value="#attributes.department_name#">
							<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=search.department_id&field_name=search.department_name&field_branch_id=search.branch_id&field_branch_name=search.branch_name&without_department&field_form_name=search.my_form</cfoutput>&keyword='+encodeURIComponent(document.search.department_name.value));"></span>
						</div>
					</div>
					<div class="form-group" id="item-position_cat_id">
						<div class="input-group">		
							<select name="per_stage" id="per_stage">
								<option value=""><cf_get_lang dictionary_id='58859.Süreç'></option>
								<cfoutput query="get_process_type">
									<option value="#process_row_id#"<cfif isdefined('attributes.per_stage') and attributes.per_stage eq process_row_id>selected</cfif>>#stage#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-perf">
						<div class="input-group">	
							<select name="perf" id="perf">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="1"<cfif isdefined('attributes.perf') and attributes.perf eq 1>selected</cfif>><cf_get_lang dictionary_id='35927.Birinci Amir'></option>
								<option value="2"<cfif isdefined('attributes.perf') and attributes.perf eq 2>selected</cfif>><cf_get_lang dictionary_id='35921.İkinci Amir'></option>
								<option value="3"<cfif isdefined('attributes.perf') and attributes.perf eq 3>selected</cfif>><cf_get_lang dictionary_id='29908.Görüş Bildiren'></option>
							</select>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Ölçme Değerlendirme',31455)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>  
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57576.Çalışan'></th>
					<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
					<th><cf_get_lang dictionary_id='29764.Form'></th>
					<th><cf_get_lang dictionary_id='58859.Süreç'></th>
					<th><cf_get_lang dictionary_id='58472.Dönem'></th>
					<th><cf_get_lang dictionary_id='58466.Degistirme Tarihi'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th width="20" class="header_icn_none text-center"></th>
				</tr>
			</thead>
			<tbody>
				<cfif isdefined('GET_PERF_RESULTS') and get_perf_results.recordcount>
					<cfset emp_id_list = ''>
					<cfset per_stage_list = ''>
					<cfoutput query="GET_PERF_RESULTS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(emp_id) and not listfind(emp_id_list,emp_id)>
							<cfset emp_id_list = listappend(emp_id_list,GET_PERF_RESULTS.emp_id,',')>
						</cfif>
						<cfif len(per_stage) and not listfind(per_stage_list,per_stage)>
							<cfset per_stage_list = listappend(per_stage_list,per_stage,',')>
						</cfif>
					</cfoutput>
					<cfset emp_id_list=listsort(emp_id_list,"numeric","ASC",",")>
					<cfif len(emp_id_list)>
						<cfquery name="get_pos" datasource="#dsn#">
							SELECT
								POSITION_NAME,
								EMPLOYEE_ID 
							FROM 
								EMPLOYEE_POSITIONS 
							WHERE 
								EMPLOYEE_ID IN (#emp_id_list#) AND
								IS_MASTER = 1
							ORDER BY 
								EMPLOYEE_ID
						</cfquery>
					<cfset emp_id_list = listsort(valuelist(get_pos.EMPLOYEE_ID,','),"numeric","ASC",',')>
					</cfif>
					<cfset per_stage_list=listsort(per_stage_list,"numeric","ASC",",")>
					<cfif len(per_stage_list)>
						<cfquery name="get_process" datasource="#dsn#">
							SELECT 
								STAGE,
								PROCESS_ROW_ID 
							FROM 
								PROCESS_TYPE_ROWS 
							WHERE 
								PROCESS_ROW_ID IN (#per_stage_list#)
						</cfquery>
						<cfset per_stage_list = listsort(valuelist(get_process.PROCESS_ROW_ID,','),"numeric","ASC",',')>
					</cfif>
					<cfoutput query="GET_PERF_RESULTS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>#get_emp_info(EMP_ID,0,0)#</td>
							<td><cfif len(emp_id)>#get_pos.position_name[listfind(emp_id_list,emp_id,',')]#</cfif></td>
							<td>#QUIZ_HEAD#</td>
							<td><cfif len(per_stage)>#get_process.stage[listfind(per_stage_list,per_stage,',')]#</cfif></td>
							<td><cfif per_id neq -1>#DateFormat(START_DATE,dateformat_style)# - #DateFormat(FINISH_DATE,dateformat_style)#</cfif></td>
							<td><cfif per_id neq -1 and len(trim(EVAL_DATE))>#DateFormat(EVAL_DATE,dateformat_style)#</cfif></td>
							<td><cfif per_id neq -1>#DateFormat(RECORD_DATE,dateformat_style)#</cfif></td>
							<td>
								<cfif Tip eq 'form_generator'>
									<cfif per_id eq -1>
										<cfif fusebox.circuit eq 'myhome'>
											<cfset survey_main_id_ = contentEncryptingandDecodingAES(isEncode:1,content:survey_main_id,accountKey:session.ep.userid)>
											<cfset EMP_ID_ = contentEncryptingandDecodingAES(isEncode:1,content:EMP_ID,accountKey:session.ep.userid)>
										<cfelse>
											<cfset survey_main_id_ = survey_main_id>
											<cfset EMP_ID_ = EMP_ID>
										</cfif>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_add_detailed_survey_main_result&fbx=myhome&survey_id=#survey_main_id_#&action_type=#type#&action_type_id=#EMP_ID_#&is_popup=1','wide')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
									<cfelse>
										<cfif fusebox.circuit eq 'myhome'>
											<cfset survey_main_id_ = contentEncryptingandDecodingAES(isEncode:1,content:survey_main_id,accountKey:session.ep.userid)>
											<cfset per_id_ = contentEncryptingandDecodingAES(isEncode:1,content:per_id,accountKey:session.ep.userid)>
										<cfelse>
											<cfset survey_main_id_ = survey_main_id>
											<cfset per_id_ = per_id>
										</cfif>
										<cfquery name="get_form_det" datasource="#dsn#">
											SELECT
												IS_MANAGER_0,
												SMR.VALID
											FROM
												SURVEY_MAIN_RESULT SMR
												INNER JOIN SURVEY_MAIN SM ON SM.SURVEY_MAIN_ID = SMR.SURVEY_MAIN_ID
											WHERE
												SM.SURVEY_MAIN_ID = #survey_main_id#
										</cfquery>
										<cfif (get_form_det.is_manager_0 eq 1 and get_form_det.valid eq 1) or (not len(get_form_det.is_manager_0))>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_detailed_survey_main_result&survey_id=#survey_main_id#&result_id=#per_id#','wide')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										<cfelse>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_detailed_survey_main_result&survey_id=#survey_main_id_#&result_id=#per_id_#&is_popup=1&fbx=myhome','wide')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
									</cfif>
								<cfelse>	
									<cfif per_id eq -1>
									<cfif not listfindnocase(denied_pages,'myhome.form_add_performance') and (year(now()) eq attributes.period_year or ( month(now()) lte 3 and year(now())-attributes.period_year lt 2) )> <!--- Bir önceki yılın ilk 3 ayına kadar güncellemeye izin verildi --->
										<a href="#request.self#?fuseaction=myhome.form_add_perf_emp_info&employee_id=#emp_id#&period_year=#attributes.period_year#&quiz_id=#quiz_id#"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
									</cfif>
									<cfelse>
									<cfif not listfindnocase(denied_pages,'myhome.form_upd_perf_emp')>
										<a href="#request.self#?fuseaction=myhome.form_upd_perf_emp&per_id=#per_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
									</cfif>
									</cfif>
								</cfif>
							</td>
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td height="20" colspan="10"><cfif isdefined('attributes.is_form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
						</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="myhome.list_perform#url_str#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function kontrol()
{
	if(document.search.branch_name.value.length==0)document.search.branch_id.value="";
	if(document.search.department_name.value.length==0)document.search.department_id.value="";
	return true;
}
</script>
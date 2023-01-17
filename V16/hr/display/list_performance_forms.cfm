<cfparam name="attributes.is_form_submit" default="0">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.process_stage_list" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.test_time_type" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfif len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih = "attributes.startdate">
</cfif>
<cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih = "attributes.finishdate">
</cfif>

<cfif attributes.is_form_submit>
	<cfquery name="get_survey_participants" datasource="#dsn#">
		SELECT 
			SURVEY_MAIN.SURVEY_MAIN_ID,
			SURVEY_MAIN.SURVEY_MAIN_HEAD,
			SURVEY_MAIN.SURVEY_MAIN_DETAILS,
			SURVEY_MAIN_RESULT.SURVEY_MAIN_RESULT_ID,
			SURVEY_MAIN_RESULT.IS_CLOSED,
			SURVEY_MAIN_RESULT.START_DATE,
			SURVEY_MAIN_RESULT.ACTION_ID,
			SURVEY_MAIN_RESULT.SCORE_RESULT,
			SURVEY_MAIN_RESULT.FINISH_DATE,
			SURVEY_MAIN_RESULT.PROCESS_ROW_ID AS SMR_PRI,
            SURVEY_MAIN.TYPE,
            SURVEY_MAIN.RECORD_DATE,
            SURVEY_MAIN.FINISH_DATE,
            SURVEY_MAIN.PROCESS_ROW_ID,
			E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS CALISAN,
			ETT.TEST_TIME_TYPE_NAME,
			ET.RECORD_DATE AS ATAMA_TARIHI,
			ET.TEST_TIME_DAY,
			EI.START_DATE AS STARTDATE,
			ET.TEST_TIME_DETAIL,
			PTR.STAGE,
			E.EMPLOYEE_NO,
			D.DEPARTMENT_HEAD,
			ST.TITLE
		FROM 
			SURVEY_MAIN,
			SURVEY_MAIN_RESULT
			LEFT JOIN EMPLOYEES_TEST_TIME ET ON  SURVEY_MAIN_RESULT.ACTION_ID = ET.EMPLOYEE_ID  AND SURVEY_MAIN_RESULT.SURVEY_MAIN_ID = ET.QUIZ_ID
			LEFT JOIN EMPLOYEES_TEST_TIME_TYPE ETT ON  ET.TEST_TIME_TYPE = ETT.EMPLOYEES_TEST_TIME_TYPE_ID
			LEFT JOIN EMPLOYEES E ON SURVEY_MAIN_RESULT.ACTION_ID = E.EMPLOYEE_ID
			LEFT JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
			LEFT JOIN SETUP_TITLE ST ON ST.TITLE_ID = EP.TITLE_ID
			LEFT JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID
			LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = ET.TEST_TIME_STAGE
			LEFT JOIN EMPLOYEES_IN_OUT EI ON  EI.EMPLOYEE_ID = ET.EMPLOYEE_ID AND EI.START_DATE = (SELECT TOP 1 START_DATE FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = SURVEY_MAIN_RESULT.ACTION_ID ORDER BY IN_OUT_ID DESC)
		WHERE 
		SURVEY_MAIN_RESULT.SURVEY_MAIN_ID = SURVEY_MAIN.SURVEY_MAIN_ID AND
			TYPE IN (6,8,10) <!--- DENEME SÜRESİ, PERFORMANS , İŞTEN ÇIKIŞ  --->
		<!---	TYPE = 8<!--- performans tipi---> --->
			<cfif len(attributes.keyword)>
				AND 
				(SURVEY_MAIN.SURVEY_MAIN_HEAD LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
				E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR E.EMPLOYEE_NO = '#attributes.keyword#' COLLATE SQL_Latin1_General_CP1_CI_AI) 
			</cfif>
			<cfif len(attributes.branch_id)>
				AND E.EMPLOYEE_ID IN(SELECT EP.EMPLOYEE_ID FROM EMPLOYEE_POSITIONS EP,DEPARTMENT D,BRANCH B WHERE EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.BRANCH_ID = B.BRANCH_ID AND B.BRANCH_ID = #attributes.branch_id#)
			</cfif>
			<cfif len(attributes.department)>
				AND E.EMPLOYEE_ID IN(SELECT EP.EMPLOYEE_ID FROM EMPLOYEE_POSITIONS EP,DEPARTMENT D WHERE EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.DEPARTMENT_ID = #attributes.department#)
			</cfif>
			<cfif len(attributes.process_stage_list)>
				AND ET.TEST_TIME_STAGE = #attributes.process_stage_list#
			</cfif>
			<cfif len(attributes.employee_id) and len(attributes.employee_name)>
				AND SURVEY_MAIN_RESULT.ACTION_ID = #attributes.employee_id#
			</cfif>
			<cfif len(attributes.test_time_type)>
				AND ET.TEST_TIME_TYPE = #attributes.test_time_type#
			</cfif>
			<cfif len(attributes.startdate)>
				AND ET.RECORD_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">   
			</cfif>
			<cfif len(attributes.finishdate) >
				AND (dateadd(d,ET.TEST_TIME_DAY,EI.START_DATE)) = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
			</cfif>
			
		ORDER BY 
			SURVEY_MAIN_RESULT_ID DESC
	</cfquery>
<cfelse>
	<cfset get_survey_participants.recordcount = 0>
</cfif>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_STATUS = 1 ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="get_process_stage" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE AS PT INNER JOIN 
		PROCESS_TYPE_ROWS AS PTR ON PT.PROCESS_ID = PTR.PROCESS_ID
		INNER JOIN PROCESS_TYPE_OUR_COMPANY AS PTO ON PTO.PROCESS_ID = PT.PROCESS_ID
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.PROCESS_ID IN(SELECT DISTINCT PROCESS_ID FROM SURVEY_MAIN WHERE TYPE = 8 AND PROCESS_ID IS NOT NULL)
</cfquery>
<cfquery name="get_test_time_type" datasource="#dsn#">
    SELECT EMPLOYEES_TEST_TIME_TYPE_ID
    ,TEST_TIME_TYPE_NAME
    ,RECORD_DATE
    ,RECORD_EMP
    ,RECORD_IP
    ,UPDATE_DATE
    ,UPDATE_EMP
    ,UPDATE_IP
FROM EMPLOYEES_TEST_TIME_TYPE
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_survey_participants.recordcount#">
<div class="col col-12 col-xs-12">
	<cf_box scroll="0">
		<cfform name="search_performance" method="post" action="#request.self#?fuseaction=hr.list_performance_forms">
			<input type="hidden" name="is_form_submit" id="is_form_submit" value="1">
			<cf_box_search>
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
				</div>	
				<div class="form-group" id="item-employee_id">
					<div class="input-group">
						<input type="hidden" name="employee_id" maxlength="50" id="employee_id" value="<cfif len(attributes.employee_id) and len(attributes.employee_name)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">      
						<input type="text" name="employee_name" maxlength="50" placeholder="<cf_get_lang dictionary_id='46196.Değerlendirilen'>" id="employee_name" value="<cfif len(attributes.employee_id) and len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" />
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_performance.employee_id&field_name=search_performance.employee_name&select_list=1&branch_related')"></span>
					</div>
				</div>
				<div class="form-group" id="item-branch_id">
					<select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
						<option value=""><cf_get_lang dictionary_id='30126.Şube Seçiniz'></option>
						<cfoutput query="get_branch">
							<option value="#get_branch.branch_id#"<cfif attributes.branch_id eq get_branch.branch_id>selected</cfif>>#get_branch.branch_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="item-department">
					<div id="DEPARTMENT_PLACE">
						<select name="department" id="department">
							<option value=""><cf_get_lang dictionary_id='55104.Departman Seçiniz'></option>
							<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
								<cfquery name="get_department" datasource="#dsn#">
									SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE BRANCH_ID = #attributes.branch_id# AND DEPARTMENT_STATUS =1 AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
								</cfquery>
								<cfoutput query="get_department">
									<option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department') and attributes.department eq get_department.department_id>selected</cfif>>#DEPARTMENT_HEAD#</option>
								</cfoutput>
							</cfif>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-department">
						<select id="test_time_type" name="test_time_type">
							<option value=""><cf_get_lang dictionary_id='31949.Değerlendirme'><cf_get_lang dictionary_id='30152.Tipi'><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfloop query="get_test_time_type">
							<cfoutput><option value="#EMPLOYEES_TEST_TIME_TYPE_ID#"<cfif EMPLOYEES_TEST_TIME_TYPE_ID eq attributes.TEST_TIME_TYPE>selected</cfif>>#TEST_TIME_TYPE_NAME#</option></cfoutput>
							</cfloop>
						</select>
				</div>
				<div class="form-group" id="item-process_stage_list">
					<select name="process_stage_list" id="process_stage_list">
						<option value=""><cf_get_lang dictionary_id='58859.Süreç'></option>
						<cfoutput query="get_process_stage">
							<option value="#PROCESS_ROW_ID#" <cfif isdefined("attributes.process_stage_list") and (attributes.process_stage_list eq PROCESS_ROW_ID)>selected</cfif>>#stage#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="item-date">
					<div class="input-group">                      
						<input type="text" name="startdate" id="startdate" value="<cfif len(attributes.startdate)><cfoutput>#dateformat(attributes.startdate,dateformat_style)#</cfoutput></cfif>" maxlength="10"placeholder="<cf_get_lang dictionary_id='61259.Atama Tarihi'>">
						<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
					</div>
				</div>
				<div class="form-group" id="item-date">
					<div class="input-group">                      
						<input type="text" name="finishdate" id="finishdate" value="<cfif len(attributes.finishdate)><cfoutput>#dateformat(attributes.finishdate,dateformat_style)#</cfoutput></cfif>" maxlength="10"placeholder="<cf_get_lang dictionary_id='56685.Değerlendirme'><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
					</div>
			    </div>
				<div class="form-group small" id="item-maxrows">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="55705.Ölçme Değerlendirme"></cfsavecontent>
	<cf_box  title="#message#">
			<cf_grid_list>
				<thead>
					<tr>
						<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th> 
						<th><cf_get_lang dictionary_id='56542.Sicil No'></th>
						<th><cf_get_lang dictionary_id='46196.Değerlendirilen'></th> 
						<th><cf_get_lang dictionary_id='57572.Departman'></th>
						<th><cf_get_lang dictionary_id='57571.Ünvan'></th>
						<th><cf_get_lang dictionary_id='29764.Form'></th>
						<th><cf_get_lang dictionary_id='31949.Değerlendirme'><cf_get_lang dictionary_id='30152.Tipi'></th>
						<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
						<th><cf_get_lang dictionary_id='61259.Atama Tarihi'></th>
						<th><cf_get_lang dictionary_id='56685.Değerlendirme'><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
						<th><cf_get_lang dictionary_id='58859.Süreç'></th>
						<th><cf_get_lang dictionary_id='58984.Puan'></th>		
						<!-- sil -->
						<th><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.form_add_perf_emp_info&is_form_generators=1')"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>" ></i></a></th>
						<th><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.form_add_perf_multiemp_info&is_form_generators=1')"><i class="fa fa-user-plus" title="<cf_get_lang dictionary_id='64209.Toplu Çalışan Formu Oluştur'>" ></i></a></th>
						<!-- sil -->
					</tr>
				</thead>
				<tbody>
					<cfif get_survey_participants.recordcount>
						<cfoutput query="get_survey_participants" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfquery name="get_question_result" datasource="#dsn#">
								SELECT SURVEY_MAIN_RESULT_ID FROM SURVEY_QUESTION_RESULT WHERE SURVEY_MAIN_RESULT_ID = #get_survey_participants.survey_main_result_id#
							</cfquery>
							<tr>
								<td>#currentrow#</td>
								<td>#employee_no#</td>
								<td>#calisan#</td>
								<td>#department_head#</td>
								<td>#title#</td>
								<td>#survey_main_head#</td>
                                <cfif test_time_type_name eq ''>
                                    <td>
                                        <cfif type eq 1>
                                            <cf_get_lang dictionary_id='57612.Fırsat'>
                                        <cfelseif type eq 2>
                                            <cf_get_lang dictionary_id='57653.İçerik'>
                                        <cfelseif type eq 3>
                                            <cf_get_lang dictionary_id='57446.Kampanya'>
                                        <cfelseif type eq 4>
                                            <cf_get_lang dictionary_id='57657.Ürün'>
                                        <cfelseif type eq 5>
                                            <cf_get_lang dictionary_id='57416.Proje'>
                                        <cfelseif type eq 6>
                                            <cf_get_lang dictionary_id='29776.Deneme Süresi'>
                                        <cfelseif type eq 7>
                                            <cf_get_lang dictionary_id='57996.İşe Alım'>
                                        <cfelseif type eq 8>
                                            <cf_get_lang dictionary_id='58003.Performans'>
                                        <cfelseif type eq 9>
                                            <cf_get_lang dictionary_id='57419.Eğitim'>
                                        <cfelseif type eq 10>
                                            <cf_get_lang dictionary_id='29832.İşten Çıkış'>
                                        <cfelseif type eq 11>
                                            <cf_get_lang dictionary_id='58445.İş'>
                                        <cfelseif type eq 12>
                                            <cf_get_lang dictionary_id='57545.Teklif'>
                                        <cfelseif type eq 13>
                                            <cf_get_lang dictionary_id='57611.Sipariş'>
                                        <cfelseif type eq 14>
                                            <cf_get_lang dictionary_id='58662.Anket'>
                                        <cfelseif type eq 15>
                                            <cf_get_lang dictionary_id='30048.Satınalma Teklifleri'>
                                        <cfelseif type eq 16>
                                            <cf_get_lang dictionary_id='44020.Etkinlik'>
                                        <cfelseif type eq 17>
                                            <cf_get_lang dictionary_id='60095.Mal Kabul'>
                                        <cfelseif type eq 18>
                                            <cf_get_lang dictionary_id='33103.Sevkiyat'>
                                        <cfelseif type eq 19>
                                            <cf_get_lang dictionary_id='57438.Call Center'>
                                        </cfif>
                                    </td>
                                <cfelse>
								    <td>#test_time_type_name#</td>
                                </cfif>
                                <cfif test_time_detail eq ''>
                                    <td>#SURVEY_MAIN_DETAILS#</td>
                                <cfelse>
								    <td>#test_time_detail#</td>
                                </cfif>
                                <cfif ATAMA_TARIHI eq ''>
                                    <td>#dateformat(record_date,dateformat_style)#</td>
                                <cfelse>
								    <td>#dateformat(ATAMA_TARIHI,dateformat_style)#</td>
                                </cfif>
                                <cfif test_time_day eq ''>
								    <td>#dateformat(FINISH_DATE,dateformat_style)#</td>
                                <cfelse>
								    <td><cfif len(test_time_day)>#dateformat(dateadd('d',test_time_day,STARTDATE),dateformat_style)#</cfif></td>
                                </cfif>
                                <cfif stage eq ''>
                                    <cfset stage_list =''>
                                    <cfloop query="get_survey_participants">
                                        <cfif len(SMR_PRI) and not listfind(stage_list,SMR_PRI)>
                                            <cfset stage_list=listappend(stage_list,SMR_PRI)>
                                        </cfif>
                                    </cfloop>
                                    <cfif len(stage_list)>
                                        <cfset stage_list=listsort(stage_list,"numeric","ASC",",")>
                                        <cfquery name="PROCESS_TYPE" datasource="#DSN#">
                                            SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#stage_list#">) ORDER BY PROCESS_ROW_ID
                                        </cfquery>
                                        <cfset stage_list = listsort(listdeleteduplicates(valuelist(process_type.process_row_id,',')),'numeric','ASC',',')>
                                    </cfif>
								    <td>
                                        <cfif process_type.STAGE[listfind(stage_list,SMR_PRI,',')] eq ''>
                                            <cf_get_lang dictionary_id='29815.Aşamasız'>
                                        <cfelse>
                                            #process_type.STAGE[listfind(stage_list,SMR_PRI,',')]#
                                        </cfif>
                                    </td>
                                <cfelse>
								    <td><cfif len(stage)>#stage#</cfif></td>
                                </cfif>
								<td><cfif len(score_result)>#TLformat(score_result,session.ep.our_company_info.rate_round_num)#</cfif></td>
								<!-- sil -->
								<td>
									<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_form_upd_detailed_survey_main_result&survey_id=#get_survey_participants.survey_main_id#&result_id=#get_survey_participants.survey_main_result_id#&is_popup=1','','ui-draggable-box-medium')" class="tableyazi">
										<cfif not get_question_result.recordcount>
											<i class="fa fa-plus" title="<cf_get_lang dictionary_id='57762.Formu doldur'>"></i>
										<cfelseif get_survey_participants.action_id neq session.ep.userid>
											<i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i>
										</cfif>
									</a>
								</td>
								<td>
									<cfif is_closed eq 1>
										<i class="fa fa-lock" alt="<cf_get_lang dictionary_id='61322.Kilitli Değerlendirme'>" title="K<cf_get_lang dictionary_id='61322.Kilitli Değerlendirme'>"></i>
									<cfelse>
										<i class="fa fa-unlock" alt="<cf_get_lang dictionary_id='61323.Açık (Kilitsiz) Değerlendirme'>" title="<cf_get_lang dictionary_id='61323.Açık (Kilitsiz) Değerlendirme'>"></i>
									</cfif>
								</td>                   
								<!-- sil -->
							</tr>
						</cfoutput>
						<cfelse>
							<tr>
								<td colspan="20"><cfif attributes.is_form_submit><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
							</tr>
					</cfif>
				</tbody>
			</cf_grid_list> 
			<cfset url_str = "">
<cfif attributes.is_form_submit>
	<cfset url_str = '#url_str#&is_form_submit=#attributes.is_form_submit#'>
	<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif len(attributes.branch_id)>
		<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
	</cfif>
	<cfif len(attributes.department)>
		<cfset url_str = "#url_str#&department_id=#attributes.department#">
	</cfif>
	<cfif len(attributes.process_stage_list)>
		<cfset url_str = "#url_str#&process_stage_list=#attributes.process_stage_list#">
	</cfif>
	<cfif len(attributes.employee_id)>
		<cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
	</cfif>
	<cfif len(attributes.employee_name)>
		<cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
	</cfif>
	<cfif len(attributes.test_time_type)>
		<cfset url_str = "#url_str#&test_time_type=#attributes.test_time_type#">
	</cfif>
	<cfif len(attributes.startdate)>
		<cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
	</cfif>
</cfif>
			<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="hr.list_performance_forms#url_str#">
	</cf_box>
</div>

<script language="javascript">
	document.getElementById('keyword').focus();
	function showDepartment(branch_id)	
	{
		var branch_id = document.search_performance.branch_id.value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
		}
		else
		document.search_performance.department.value ="";
	}
</script>
<cfparam name="attributes.module_id_control" default="34">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.title_id" default="">
<cfparam name="attributes.training_cat_id" default="">
<cfparam name="attributes.training_sec_id" default="">
<cfparam name="attributes.position_cats" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.func_id" default="">
<cfparam name="attributes.training_style" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.is_attenders" default="">
<cfparam name="attributes.is_excuseds" default="">
<cfparam name="attributes.is_trainig_cost" default="">
<cfparam name="attributes.is_attendance" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.quiz_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.par_id" default="">
<cfparam name="attributes.cons_id" default="">
<cfparam name="attributes.emp_par_name" default="">
<cfparam name="attributes.is_excel" default="">
<cfquery name="TITLES" datasource="#dsn#">
	SELECT TITLE_ID,TITLE FROM SETUP_TITLE WHERE IS_ACTIVE = 1 ORDER BY TITLE
</cfquery>
<cfquery name="get_training_cat" datasource="#dsn#">
	SELECT * FROM TRAINING_CAT
</cfquery>
<cfquery name="get_our_company" datasource="#dsn#">
	SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
</cfquery>
<cfquery name="GET_POSITION_CATS" datasource="#dsn#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<cfquery name="get_units" datasource="#dsn#">
	SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT 
</cfquery>
<cfquery name="GET_TRAINING_STYLE" datasource="#dsn#">
	SELECT * FROM SETUP_TRAINING_STYLE
</cfquery>

<cfif len(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
</cfif>
<cfif len(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
</cfif>
<cfset class_id_list = "">
<cfset kayit_sayisi = 0>
<cfif attributes.report_type eq 2>
	<cfquery name="get_function_training_all" datasource="#dsn#">
		SELECT
			BRANCH.BRANCH_ID,
			BRANCH.BRANCH_NAME,
			TRAINING_CLASS_ATTENDER.CLASS_ID,
			EMPLOYEE_POSITIONS.FUNC_ID,
			COUNT(EMPLOYEE_POSITIONS.EMPLOYEE_ID) COUNT_EMPLOYEE,
			TRAINING_CLASS.DATE_NO,
    		TRAINING_CLASS.HOUR_NO
		FROM
			EMPLOYEE_POSITIONS,
			DEPARTMENT,
			BRANCH,
			TRAINING_CLASS_ATTENDER,
			TRAINING_CLASS
			<cfif (isdefined("attributes.comp_id") and len(attributes.comp_id))>
				,OUR_COMPANY C
			</cfif>	
		WHERE
			DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
			AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
			AND EMPLOYEE_POSITIONS.FUNC_ID IS NOT NULL
			AND TRAINING_CLASS_ATTENDER.EMP_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
			AND TRAINING_CLASS.CLASS_ID = TRAINING_CLASS_ATTENDER.CLASS_ID
			<cfif (isdefined("attributes.comp_id") and len(attributes.comp_id))>
				AND C.COMP_ID=BRANCH.COMPANY_ID
				AND C.COMP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.comp_id#">)
			</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND BRANCH.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.branch_id#">)
			</cfif>
			<cfif isdefined("attributes.department") and len(attributes.department)>
				AND EMPLOYEE_POSITIONS.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.department#">)
			</cfif>
			<cfif isdefined("attributes.title_id") and len(attributes.title_id)>
				AND EMPLOYEE_POSITIONS.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">
			</cfif>
			<cfif isdefined("attributes.position_cats") and len(attributes.position_cats)>
				AND EMPLOYEE_POSITIONS.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cats#">
			</cfif>
			<cfif isdefined("attributes.func_id") and len(attributes.func_id)>
				AND EMPLOYEE_POSITIONS.FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.func_id#">
			</cfif>
			<cfif isdefined("attributes.training_cat_id") and len(attributes.training_cat_id) and attributes.training_cat_id neq 0>
				AND TRAINING_CLASS.TRAINING_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_cat_id#">
			</cfif>
			<cfif isdefined("attributes.training_sec_id") and len(attributes.training_sec_id) and attributes.training_sec_id neq 0>
				AND TRAINING_CLASS.TRAINING_SEC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_sec_id#">
			</cfif>
			<cfif isdefined("attributes.training_style") and len(attributes.training_style)>
				AND TRAINING_CLASS.TRAINING_STYLE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_style#">
			</cfif>
			<cfif isdefined("attributes.start_date") and len(attributes.start_date)> 
				AND TRAINING_CLASS.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',-1,attributes.start_date)#">
			</cfif>
			<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)> 
				AND TRAINING_CLASS.FINISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_date)#">
			</cfif>
			<cfif len(trim(attributes.employee)) and len(attributes.employee_id)>
				AND TRAINING_CLASS_ATTENDER.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> 
			</cfif>
		GROUP BY
			BRANCH.BRANCH_ID,
			BRANCH.BRANCH_NAME,
			TRAINING_CLASS_ATTENDER.CLASS_ID,
			EMPLOYEE_POSITIONS.FUNC_ID,
			TRAINING_CLASS.DATE_NO,
    		TRAINING_CLASS.HOUR_NO
		ORDER BY 
			BRANCH.BRANCH_ID
		</cfquery>
	<cfif get_function_training_all.recordcount>
		<cfquery name="get_function_training" dbtype="query">
			SELECT 
				BRANCH_ID,
				BRANCH_NAME,
				COUNT(CLASS_ID) COUNT_CLASS ,
				FUNC_ID,
				SUM(COUNT_EMPLOYEE) COUNT_EMPLOYEE
			FROM
				get_function_training_all
			GROUP BY
				BRANCH_ID,
				BRANCH_NAME,
				FUNC_ID
		</cfquery>
		<cfset kayit_sayisi = get_function_training.recordcount>
	</cfif>
<cfelseif attributes.report_type eq 1>
	<cfquery name="get_class_attender" datasource="#DSN#">
		SELECT
			TRAINING_CLASS_ATTENDER.CLASS_ID,
			TRAINING_CLASS_ATTENDER.EMP_ID AS K_ID
			<cfif (isdefined("attributes.comp_id") and len(attributes.comp_id)) or (isdefined("attributes.branch_id") and len(attributes.branch_id)) or (isdefined("attributes.department") and len(attributes.department))>					
				,BRANCH.BRANCH_NAME AS BRANCH_NAME
			</cfif>
		FROM
			TRAINING_CLASS_ATTENDER
			<cfif (isdefined("attributes.comp_id") and len(attributes.comp_id)) or (isdefined("attributes.branch_id") and len(attributes.branch_id)) or (isdefined("attributes.department") and len(attributes.department))>
				,EMPLOYEE_POSITIONS,
				DEPARTMENT,
				BRANCH,
				OUR_COMPANY C
			</cfif>
		WHERE
			TRAINING_CLASS_ATTENDER.CLASS_ID IS NOT NULL
			<cfif len(trim(attributes.employee)) and len(attributes.employee_id)>
				AND TRAINING_CLASS_ATTENDER.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> 
			</cfif>
		<cfif (isdefined("attributes.comp_id") and len(attributes.comp_id)) or (isdefined("attributes.branch_id") and len(attributes.branch_id)) or (isdefined("attributes.department") and len(attributes.department))>
			AND DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
			AND C.COMP_ID=BRANCH.COMPANY_ID
			AND EMPLOYEE_POSITIONS.EMPLOYEE_ID = TRAINING_CLASS_ATTENDER.EMP_ID
			AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
			AND EMPLOYEE_POSITIONS.IS_MASTER = 1
			<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
				AND C.COMP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.comp_id#">)
			</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND BRANCH.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.branch_id#">)
			</cfif>
			<cfif isdefined("attributes.department") and len(attributes.department)>
				AND EMPLOYEE_POSITIONS.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.department#">)
			</cfif>
			<cfif isdefined("attributes.title_id") and len(attributes.title_id)>
				AND EMPLOYEE_POSITIONS.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">
			</cfif>
			<cfif isdefined("attributes.position_cats") and len(attributes.position_cats)>
				AND EMPLOYEE_POSITIONS.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cats#">
			</cfif>
			<cfif isdefined("attributes.func_id") and len(attributes.func_id)>
				AND EMPLOYEE_POSITIONS.FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.func_id#">
			</cfif>
		</cfif>
		</cfquery>
		<!---<cfset employee_list = listdeleteduplicates(valuelist(employees_ssk.employee_id),',')>--->
		<cfset class_id_list = listdeleteduplicates(valuelist(get_class_attender.CLASS_ID),',')>
		<cfset class_id_list = listsort(class_id_list,'numeric','ASC',',')>
		<cfif len(class_id_list)>
			<cfquery name="get_training_report" datasource="#dsn#">
				SELECT
					CLASS_ID,
					CLASS_NAME,
					TRAINING_CAT_ID,
					TRAINING_SEC_ID,
					<!--- TRAINER_EMP,
					TRAINER_PAR,
					TRAINER_CONS, --->
					CLASS_PLACE,
					START_DATE,
					FINISH_DATE,
					DATE_NO,
					HOUR_NO
				FROM
					TRAINING_CLASS
				WHERE
					CLASS_ID IS NOT NULL
				<cfif get_class_attender.recordcount>
					AND CLASS_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#class_id_list#">)
				</cfif>
				<cfif isdefined("attributes.training_cat_id") and len(attributes.training_cat_id) and attributes.training_cat_id neq 0>
					AND TRAINING_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_cat_id#">
				</cfif>
				<cfif isdefined("attributes.training_sec_id") and len(attributes.training_sec_id) and attributes.training_sec_id neq 0>
					AND TRAINING_SEC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_sec_id#">
				</cfif>
				<cfif isdefined("attributes.training_style") and len(attributes.training_style)>
					AND TRAINING_STYLE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_style#">
				</cfif>
				<cfif isdefined("attributes.start_date") and len(attributes.start_date)> 
					AND START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
				</cfif>
				<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)> 
					AND FINISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_date)#">
				</cfif>
				<cfif len(attributes.emp_id) and len(attributes.emp_par_name)>
					AND CLASS_ID IN(SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">)
				<cfelseif len(attributes.par_id) and len(attributes.emp_par_name)>
					AND CLASS_ID IN(SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.par_id#">)
				<cfelseif len(attributes.cons_id) and len(attributes.emp_par_name)>
					AND CLASS_ID IN(SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE CONS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cons_id#">)
				</cfif>		
				<!--- <cfif len(attributes.emp_id) and len(attributes.emp_par_name)>
					AND TRAINER_EMP = #attributes.emp_id# 
				<cfelseif len(attributes.par_id) and len(attributes.emp_par_name)>
					AND TRAINER_PAR = #attributes.par_id# 
				<cfelseif len(attributes.cons_id) and len(attributes.emp_par_name)>
					AND TRAINER_CONS = #attributes.cons_id# 
				</cfif> --->
				ORDER BY 
					START_DATE DESC
		</cfquery>
		<cfquery name="get_trainers" datasource="#dsn#">
			SELECT
				TCT.ID,
				E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS TRAINER,
				'Çalışan' AS TRAINER_DETAIL,
				TCT.CLASS_ID
			FROM
				TRAINING_CLASS_TRAINERS TCT INNER JOIN EMPLOYEES E
				ON TCT.EMP_ID = E.EMPLOYEE_ID 
			WHERE
				TCT.CLASS_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#class_id_list#">)
			UNION ALL
			SELECT
				TCT.ID,
				CP.COMPANY_PARTNER_NAME+' '+ CP.COMPANY_PARTNER_SURNAME AS TRAINER,
				'Kurumsal' AS TRAINER_DETAIL,
				TCT.CLASS_ID
			FROM
				TRAINING_CLASS_TRAINERS TCT INNER JOIN COMPANY_PARTNER CP
				ON TCT.PAR_ID =CP.PARTNER_ID 
			WHERE
				TCT.CLASS_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#class_id_list#">)
			UNION ALL
			SELECT
				TCT.ID,
				C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS TRAINER,
				'Bireysel' AS TRAINER_DETAIL,
				TCT.CLASS_ID
			FROM
				TRAINING_CLASS_TRAINERS TCT INNER JOIN CONSUMER C
				ON TCT.CONS_ID =C.CONSUMER_ID 
			WHERE
				TCT.CLASS_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#class_id_list#">)
		</cfquery>	
		<cfset kayit_sayisi = get_training_report.recordcount>
	</cfif>
<cfelseif attributes.report_type eq 3>
	<cfif isdefined("form_submitted")>
		<cfquery name="get_training_form_all" datasource="#dsn#">
			SELECT 
				BRANCH.BRANCH_ID,
				BRANCH.BRANCH_NAME,
				COUNT(DISTINCT TRAINING_CLASS_ATTENDER.EMP_ID) EMP_ID,
				TRAINING_CLASS_ATTENDER.CLASS_ID,
				TRAINING_CLASS.CLASS_NAME,
				TRAINING_CLASS.START_DATE,
				TRAINING_CLASS.FINISH_DATE
			FROM
				EMPLOYEE_POSITIONS,
				DEPARTMENT,
				BRANCH,
				TRAINING_CLASS_ATTENDER,
				TRAINING_CLASS,
				<cfif listlen(attributes.quiz_id,'-') eq 1><!--- eski degerlendirme formları--->
					TRAINING_PERFORMANCE,
					EMPLOYEE_QUIZ_RESULTS
				<cfelse><!--- yeni degerlendirme formları--->
					SURVEY_MAIN_RESULT
				</cfif>
				<cfif (isdefined("attributes.comp_id") and len(attributes.comp_id))>
				,OUR_COMPANY C
				</cfif>	
			WHERE
				DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
				AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
				AND TRAINING_CLASS_ATTENDER.EMP_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
				AND EMPLOYEE_POSITIONS.IS_MASTER = 1
				AND TRAINING_CLASS.CLASS_ID = TRAINING_CLASS_ATTENDER.CLASS_ID
				<cfif listlen(attributes.quiz_id,'-') eq 1><!--- eski degerlendirme formları--->
					AND EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (SELECT ENTRY_EMP_ID FROM TRAINING_PERFORMANCE TR WHERE TR.TRAINING_QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quiz_id#"> AND TR.CLASS_ID =TRAINING_CLASS_ATTENDER.CLASS_ID )
					AND TRAINING_CLASS.CLASS_ID = TRAINING_PERFORMANCE.CLASS_ID
					AND TRAINING_PERFORMANCE.TRAINING_PERFORMANCE_ID = EMPLOYEE_QUIZ_RESULTS.TRAINING_PERFORMANCE_ID
					<cfif (isdefined("attributes.quiz_id") and len(attributes.quiz_id))>
						AND EMPLOYEE_QUIZ_RESULTS.QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quiz_id#">
						AND TRAINING_PERFORMANCE.TRAINING_QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quiz_id#">
					</cfif>
				<cfelse><!--- yeni degerlendirme formları--->
					AND EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (SELECT RECORD_EMP FROM SURVEY_MAIN_RESULT TR WHERE TR.SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.quiz_id,'-')#"> AND TR.ACTION_ID =TRAINING_CLASS_ATTENDER.CLASS_ID )
					AND TRAINING_CLASS.CLASS_ID = SURVEY_MAIN_RESULT.ACTION_ID
					<cfif (isdefined("attributes.quiz_id") and len(attributes.quiz_id))>
						AND SURVEY_MAIN_RESULT.SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.quiz_id,'-')#">
					</cfif>
				</cfif>
				<cfif (isdefined("attributes.comp_id") and len(attributes.comp_id))>
					AND C.COMP_ID=BRANCH.COMPANY_ID
					AND C.COMP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.comp_id#">)
				</cfif>
				<cfif isdefined("attributes.department") and len(attributes.department)>
					AND EMPLOYEE_POSITIONS.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.department#">)
				</cfif>
				<cfif isdefined("attributes.title_id") and len(attributes.title_id)>
					AND EMPLOYEE_POSITIONS.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">
				</cfif>
				<cfif isdefined("attributes.position_cats") and len(attributes.position_cats)>
					AND EMPLOYEE_POSITIONS.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cats#">
				</cfif>
				<cfif isdefined("attributes.func_id") and len(attributes.func_id)>
					AND EMPLOYEE_POSITIONS.FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.func_id#">
				</cfif>
				<cfif isdefined("attributes.training_cat_id") and len(attributes.training_cat_id) and attributes.training_cat_id neq 0>
					AND TRAINING_CLASS.TRAINING_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_cat_id#">
				</cfif>
				<cfif isdefined("attributes.training_sec_id") and len(attributes.training_sec_id) and attributes.training_sec_id neq 0>
					AND TRAINING_CLASS.TRAINING_SEC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_sec_id#">
				</cfif>
				<cfif isdefined("attributes.training_style") and len(attributes.training_style)>
					AND TRAINING_CLASS.TRAINING_STYLE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_style#">
				</cfif>
				<cfif isdefined("attributes.start_date") and len(attributes.start_date)> 
					AND TRAINING_CLASS.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
				</cfif>
				<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)> 
					AND TRAINING_CLASS.FINISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_date)#">
				</cfif>
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
					AND BRANCH.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.branch_id#">)
				</cfif>
				<cfif len(trim(attributes.employee)) and len(attributes.employee_id)>
					AND TRAINING_CLASS_ATTENDER.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> 
				</cfif>
			GROUP BY
				BRANCH.BRANCH_ID,
				BRANCH.BRANCH_NAME,
				TRAINING_CLASS_ATTENDER.CLASS_ID,
				TRAINING_CLASS.CLASS_NAME,
				TRAINING_CLASS.START_DATE,
				TRAINING_CLASS.FINISH_DATE
			ORDER BY 
				BRANCH.BRANCH_ID
		</cfquery>
		<cfset kayit_sayisi = get_training_form_all.recordcount>
	<cfelse>
		<cfset kayit_sayisi = 0>
	</cfif>
</cfif>
<cfif isdate(attributes.start_date)>
	<cfset attributes.start_date = dateformat(attributes.start_date, dateformat_style)>
</cfif>
<cfif isdate(attributes.finish_date)>
	<cfset attributes.finish_date = dateformat(attributes.finish_date, dateformat_style)>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default='#kayit_sayisi#'>
<cfif attributes.report_type eq 1>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
</cfif>		
<cfform name="form_report" action="#request.self#?fuseaction=report.training_analyse_function_report" method="post">
<input type="hidden" id="form_submitted" name="form_submitted" value="">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='40346.Fonksiyon Ve Eğitim Bazlı Analiz Raporu'></cfsavecontent>
<cf_report_list_search id="search" title="#title#">
	<cf_report_list_search_area>
		<div class="row">
			<div class="col col-12 col-xs-12">
				<div class="row formContent">
					<div class="row" type="row">
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
							<div class="col col-12 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
									<div class="col col-12 col-xs-12" >
										<div class="multiselect-z3">
											<cfsavecontent variable="text"><cf_get_lang dictionary_id='57574.Şirket'></cfsavecontent>
											<cf_multiselect_check 
												query_name="get_our_company"  
												name="comp_id"
												width="140" 
												option_value="COMP_ID"
												option_name="COMPANY_NAME"
												option_text="#text#"
												value="#attributes.comp_id#"
												onchange="get_branch_list(this.value)">
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12" ><cf_get_lang dictionary_id='57453.Şube'></label>
									<cfquery name="get_branch" datasource="#dsn#">
										SELECT BRANCH_NAME,BRANCH_ID FROM BRANCH,OUR_COMPANY WHERE OUR_COMPANY.COMP_ID=BRANCH.COMPANY_ID <cfif len(attributes.comp_id)>AND OUR_COMPANY.COMP_ID IN (#attributes.comp_id#)</cfif>
									</cfquery>
									<div class="col col-12 col-xs-12">
										<div id="BRANCH_PLACE" class="multiselect-z2">
											<cfsavecontent variable="text"><cf_get_lang dictionary_id='57453.Şube'></cfsavecontent>
											<cf_multiselect_check 
												query_name="get_branch"  
												name="branch_id"
												width="140" 
												option_value="BRANCH_ID"
												option_name="BRANCH_NAME"
												option_text="#text#"
												value="#attributes.branch_id#">
										</div>
									</div>
								</div>
							 	<div class="form-group">
									<label class="col col-12 col-xs-12" ><cf_get_lang dictionary_id ='57572.Departman'></label>
										<cfquery name="get_dept" datasource="#dsn#">
											SELECT D.DEPARTMENT_HEAD,D.DEPARTMENT_ID FROM DEPARTMENT D,BRANCH B WHERE D.BRANCH_ID=B.BRANCH_ID <cfif len(attributes.branch_id)>AND D.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.branch_id#">)</cfif>
										</cfquery>
									<div class="col col-12 col-xs-12">
										<div id="DEPARTMENT_PLACE" class="multiselect-z1">
											<cfsavecontent variable="text"><cf_get_lang dictionary_id ='57572.Departman'></cfsavecontent>
											<cf_multiselect_check 
												query_name="get_dept"  
												name="department"
												width="140" 
												option_text="#text#" 
												option_value="department_id"
												option_name="department_head"
												value="#iif(isdefined("attributes.department"),"attributes.department",DE(""))#">
										</div>
									</div>
									
								</div> 
						
								<div class="form-group">
									<label class="col col-12 col-xs-12" nowrap><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
									<div class="col col-6" nowrap>
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
											<input value="<cfoutput>#attributes.start_date#</cfoutput>" type="text" name="start_date" id="start_date" validate="#validate_style#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
										</div>
									</div>
									<div class="col col-6" nowrap>
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
											<input value="<cfoutput>#attributes.finish_date#</cfoutput>" type="text" name="finish_date" id="finish_date" validate="#validate_style#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
							<div class="col col-12 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39393.Ünvanlar'></label>
									<div class="col col-12 col-xs-12">
										<select name="title_id" id="title_id" style="width:120px;">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfoutput query="titles">
												<option value="#title_id#" <cfif isdefined("attributes.title_id") and attributes.title_id eq title_id>selected</cfif>>#title#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon'></label>
									<div class="col col-12 col-xs-12">
										<select name="position_cats" id="position_cats" style="width:120px;">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfoutput query="get_position_cats">
											<option value="#POSITION_CAT_ID#" <cfif attributes.position_cats eq POSITION_CAT_ID>selected</cfif>>#POSITION_CAT#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39392.Fonksiyon'></label>
									<div class="col col-12 col-xs-12">
										<select name="func_id" id="func_id" style="width:120px;">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfoutput query="get_units">
												<option value="#unit_id#"<cfif isdefined("attributes.func_id") and attributes.func_id eq get_units.unit_id>selected</cfif>>#unit_name#</option>
											</cfoutput>
										</select>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
							<div class="col col-12 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
									<div class="col col-12 col-xs-12">
										<select name="training_cat_id" id="training_cat_id" style="width:120px" onchange="get_training_secs();">
											<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfoutput query="get_training_cat">
												<option value="#training_cat_id#" <cfif isdefined("attributes.training_cat_id") and (attributes.training_cat_id eq training_cat_id)>selected</cfif>>#training_cat#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57995.Bölüm'></label>
									<div class="col col-12 col-xs-12">
										<cfif len(attributes.training_cat_id)>
											<cfquery name="get_training_sec" datasource="#dsn#">
												SELECT TRAINING_SEC_ID, SECTION_NAME FROM TRAINING_SEC WHERE TRAINING_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_cat_id#"> ORDER BY SECTION_NAME
											</cfquery>
										</cfif>
										<select name="training_sec_id" id="training_sec_id" style="width:120px">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfif len(attributes.training_cat_id)>
												<cfoutput query="get_training_sec">
													<option value="#training_sec_id#" <cfif isdefined("attributes.training_sec_id") and (attributes.training_sec_id eq training_sec_id)>selected</cfif>>#section_name#</option>
												</cfoutput>
											</cfif>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57419.Eğitim'><cf_get_lang dictionary_id ='58663.Şekli'></label>
									<div class="col col-12 col-xs-12">
										<select name="training_style" id="training_style" style="width:120px">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfoutput query="get_training_style">
												<option value="#training_style_id#" <cfif attributes.training_style eq training_style_id>selected</cfif>>#TRAINING_STYLE#</option>
											</cfoutput>
										</select>
									</div>
								</div>
							</div>								
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
							<div class="col col-12 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="employee_id" id="employee_id"  value="<cfif len(attributes.employee)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
											<input type="text" name="employee" id="employee" value="<cfif len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,MEMBER_NAME','employee_id,employee','','3','135');">
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_report.employee_id&field_emp_id2=form_report.employee_id&field_name=form_report.employee&select_list=1,9','list');"></span>
										</div>
									</div>
								</div>						
							 <div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='40348.Eğitimci'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="emp_id" id="emp_id" value="<cfif len(attributes.emp_id)><cfoutput>#attributes.emp_id#</cfoutput></cfif>">
											<input type="hidden" name="par_id" id="par_id" value="<cfif len(attributes.par_id)><cfoutput>#attributes.par_id#</cfoutput></cfif>">
											<input type="hidden" name="cons_id" id="cons_id" value="<cfif len(attributes.cons_id)><cfoutput>#attributes.cons_id#</cfoutput></cfif>"> 
											<input type="hidden" name="member_type" id="member_type" value="">
											<input type="text" name="emp_par_name" id="emp_par_name" value="<cfif len(attributes.emp_par_name)><cfoutput>#attributes.emp_par_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('emp_par_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\',0,0','EMPLOYEE_ID,PARTNER_ID,CONSUMER_ID,MEMBER_TYPE','emp_id,par_id,con_id,member_type','','3','250');">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form_report.emp_id&field_name=form_report.emp_par_name&field_type=form_report.member_type&field_partner=form_report.par_id&field_consumer=form_report.cons_id&select_list=1<cfif get_module_user(4)>,2,8</cfif></cfoutput>','list');"></span>
										</div>
									</div>
								</div> 
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
									<div class="col col-12 col-xs-12">
										<select name="report_type" id="report_type" style="width:150px" onChange="goster_anket();">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<option value="1" <cfif (attributes.report_type eq 1)>selected</cfif>><cf_get_lang dictionary_id ='57419.Eğitim'><cf_get_lang dictionary_id ='58601.Bazında'></option>
											<option value="2" <cfif (attributes.report_type eq 2)>selected</cfif>><cf_get_lang dictionary_id='58701.Fonksiyon'><cf_get_lang dictionary_id ='58601.Bazında'></option>
											<option value="3" <cfif (attributes.report_type eq 3)>selected</cfif>><cf_get_lang dictionary_id ='58662.Anket'><cf_get_lang dictionary_id ='58601.Bazında'></option>
										</select>
									</div>
								</div>
								<div class="form-group" id="fonksiyon"<cfif isdefined("attributes.report_type") and len(attributes.report_type) and attributes.report_type eq 1>style="display:"<cfelse>style="display:none"</cfif>>
									<label class="col col-12 col-xs-12"></label>
									<div class="col col-6 col-xs-6" colspan="2">
										<label><cf_get_lang dictionary_id='60122.Katılımcı Sayısı'>
											<input type="checkbox" name="is_attenders" id="is_attenders" <cfif isdefined('attributes.is_attenders') and len(attributes.is_attenders)>checked</cfif>>
										</label>
									</div>
									<div class="col col-6 col-xs-6" colspan="2">
										<label><cf_get_lang dictionary_id ='876.Mazeretli Sayısı'>
											<input type="checkbox" name="is_excuseds" id="is_excuseds" <cfif isdefined('attributes.is_excuseds') and len(attributes.is_excuseds)>checked</cfif>>
										</label>
									</div>
									<div class="col col-6 col-xs-6" colspan="2">
										<label><cf_get_lang dictionary_id='58258.Maliyet'>
											<input type="checkbox" name="is_trainig_cost" id="is_trainig_cost" <cfif isdefined('attributes.is_trainig_cost') and len(attributes.is_trainig_cost)>checked</cfif>>&nbsp;
										</label>
									</div>
									<div class="col col-6 col-xs-6" colspan="2">
										<label><cf_get_lang dictionary_id="40766.Yoklama">
											<input type="checkbox" name="is_attendance" id="is_attendance" <cfif isdefined('attributes.is_attendance') and len(attributes.is_attendance)>checked</cfif>>&nbsp;
										</label>
									</div>
								</div>
								<!--- eski degerlendirme formu kayıtları--->
								<cfquery name="employee_quiz" datasource="#dsn#">
									SELECT
										EQU.QUIZ_HEAD,
										EQU.QUIZ_ID,
										IS_TRAINER,
										COMMETHOD_ID,
										IS_ACTIVE
									FROM
										EMPLOYEE_QUIZ EQU 
									WHERE
										IS_EDUCATION=1
										AND 
										IS_ACTIVE = 1
									ORDER BY
										EQU.QUIZ_HEAD
								</cfquery>
								<!---yeni degerlendirme formları --->
								<cfquery name="get_survey" datasource="#dsn#">
									SELECT SURVEY_MAIN_ID,SURVEY_MAIN_HEAD FROM SURVEY_MAIN WHERE IS_ACTIVE = 1 AND TYPE = 9
								</cfquery>
								<div class="form-group" id="anket"<cfif isdefined("attributes.report_type") and len(attributes.report_type) and attributes.report_type eq 3>style="display:"<cfelse>style="display:none"</cfif>>
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58662.Anket'></label>
									<div class="col col-12 col-xs-12">
										<select name="quiz_id" id="quiz_id">
											<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfoutput query="employee_quiz">
												<option value="#quiz_id#" <cfif isdefined("attributes.quiz_id") and (attributes.quiz_id eq quiz_id)>selected</cfif>>#quiz_head#</option>
											</cfoutput>
											<cfoutput query="get_survey">
												<option value="#SURVEY_MAIN_ID#-1" <cfif isdefined("attributes.quiz_id") and listlen(attributes.quiz_id,'-') eq 2 and listfirst(attributes.quiz_id,'-') eq SURVEY_MAIN_ID>selected</cfif>>#SURVEY_MAIN_HEAD#</option>
											</cfoutput>
										</select>
									</div>
								</div>
							</div>								
						</div>
					</div>
				</div>
				<div class="row ReportContentBorder">
					<div class="ReportContentFooter">
						<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
						<cfelse>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
						</cfif>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57911.Çalıştır'></cfsavecontent>
							<input type="hidden" name="is_submitted" id="is_submitted" value="1">
							<cf_wrk_report_search_button  search_function='kontrol_anket()' insert_info='#message#' button_type='1' is_excel="1">   
					</div>
				</div>	
				
			</div>
		</div>	
	</cf_report_list_search_area>
</cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset filename="mdk_training_analyse_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="content-type" content="text/plain; charset=utf-16">
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=kayit_sayisi>
	<cfset type_ = 1>
	<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif kayit_sayisi neq 0 and isdefined("attributes.form_submitted") and attributes.report_type eq 1>
	<cfset training_cat_id_list=''>
	<cfset training_sec_id_list=''>
	<!--- <cfset trainer_emp_list=''>
	<cfset trainer_par_list=''>
	<cfset trainer_cons_list=''> --->
	<cfset training_classid_list=''>
	<cfoutput query="get_training_report" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		 <cfif not listfind(training_cat_id_list,TRAINING_CAT_ID)>
			<cfset training_cat_id_list=listappend(training_cat_id_list,TRAINING_CAT_ID)>
		 </cfif>
		 <cfif not listfind(training_sec_id_list,TRAINING_SEC_ID)>
			<cfset training_sec_id_list=listappend(training_sec_id_list,TRAINING_SEC_ID)>
		 </cfif>
		<!---  <cfif not listfind(trainer_emp_list,TRAINER_EMP)>
			<cfset trainer_emp_list=listappend(trainer_emp_list,TRAINER_EMP)>
		 </cfif>
		 <cfif not listfind(trainer_par_list,TRAINER_PAR)>
			<cfset trainer_par_list=listappend(trainer_par_list,TRAINER_PAR)>
		 </cfif>
		 <cfif not listfind(trainer_cons_list,TRAINER_CONS)>
			<cfset trainer_cons_list=listappend(trainer_cons_list,TRAINER_CONS)>
		 </cfif> --->
		 <cfif not listfind(training_classid_list,CLASS_ID)>
			<cfset training_classid_list=listappend(training_classid_list,CLASS_ID)>
		 </cfif>
	</cfoutput> 
	<cfset training_cat_id_list=listsort(training_cat_id_list,"numeric")>
	<cfset training_sec_id_list=listsort(training_sec_id_list,"numeric")>
	<!--- <cfset trainer_emp_list=listsort(trainer_emp_list,"numeric")>
	<cfset trainer_par_list=listsort(trainer_par_list,"numeric")>
	<cfset trainer_cons_list=listsort(trainer_cons_list,"numeric")> --->
	<cfset training_classid_list=listsort(training_classid_list,"numeric")>
	<cfif len(training_cat_id_list)>
		 <cfquery name="get_training_cat_list" datasource="#DSN#">
			SELECT TRAINING_CAT,TRAINING_CAT_ID FROM TRAINING_CAT WHERE TRAINING_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#training_cat_id_list#">) ORDER BY TRAINING_CAT_ID
		 </cfquery>
		 <cfset training_cat_id_list = listsort(listdeleteduplicates(valuelist(get_training_cat_list.TRAINING_CAT_ID,',')),'numeric','ASC',',')>
	 </cfif>
	<cfif len(training_sec_id_list)>
		 <cfquery name="get_training_sec" datasource="#DSN#">
			SELECT SECTION_NAME,TRAINING_SEC_ID FROM TRAINING_SEC WHERE TRAINING_SEC_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#training_sec_id_list#">) ORDER BY TRAINING_SEC_ID
		 </cfquery>
		 <cfset training_sec_id_list = listsort(listdeleteduplicates(valuelist(get_training_sec.TRAINING_SEC_ID,',')),'numeric','ASC',',')>
	</cfif>
	<!--- <cfif len(trainer_emp_list)>
		 <cfquery name="get_trainer_emp" datasource="#DSN#">
			SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#trainer_emp_list#) ORDER BY EMPLOYEE_ID
		 </cfquery>
		 <cfset trainer_emp_list = listsort(listdeleteduplicates(valuelist(get_trainer_emp.EMPLOYEE_ID,',')),'numeric','ASC',',')>
	</cfif>
	<cfif len(trainer_par_list)>
		 <cfquery name="get_trainer_par" datasource="#DSN#">
			SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME,PARTNER_ID FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#trainer_par_list#) ORDER BY PARTNER_ID
		 </cfquery>
		 <cfset trainer_par_list = listsort(listdeleteduplicates(valuelist(get_trainer_par.PARTNER_ID,',')),'numeric','ASC',',')>
	</cfif>
	<cfif len(trainer_cons_list)>
		 <cfquery name="get_trainer_cons" datasource="#DSN#">
			SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID IN (#trainer_cons_list#) ORDER BY CONSUMER_ID
		 </cfquery>
		 <cfset trainer_cons_list = listsort(listdeleteduplicates(valuelist(get_trainer_cons.CONSUMER_ID,',')),'numeric','ASC',',')>
	</cfif> --->
	<cfif len(training_classid_list)>
		<cfquery name="GET_CLASS_COST" datasource="#dsn#">
			SELECT CLASS_ID,ONGORULEN_TOPLAM,GERCEKLESEN_TOPLAM FROM TRAINING_CLASS_COST WHERE CLASS_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#training_classid_list#">) ORDER BY CLASS_ID
		</cfquery>
		<cfset training_classid_list = listsort(listdeleteduplicates(valuelist(GET_CLASS_COST.CLASS_ID,',')),'numeric','ASC',',')>
	</cfif>
</cfif>
<cfif isDefined("attributes.form_submitted")>

	<cf_report_list>
				<thead>
				<cfif attributes.report_type eq 1>
					<tr>
						<cfset tt = 9>
						<th nowrap>&nbsp;<cf_get_lang dictionary_id ='57419.Eğitim'><cf_get_lang dictionary_id ='57897.Adı'> </th>
						<th nowrap>&nbsp;<cf_get_lang dictionary_id ='57419.Eğitim'><cf_get_lang dictionary_id='57486.Kategori'></th>
						<th nowrap>&nbsp;<cf_get_lang dictionary_id ='57995.Bölüm'></th>
						<th nowrap>&nbsp;<cf_get_lang dictionary_id ='40348.Eğitimci'></th>
						<th nowrap>&nbsp;<cf_get_lang dictionary_id ='57419.Eğitim'><cf_get_lang dictionary_id ='58664.Yeri'></th>
						<th nowrap>&nbsp;<cf_get_lang dictionary_id ='57742.Tarih'></th>
						<th nowrap>&nbsp;<cf_get_lang dictionary_id ='57491.Saat'></th>
						<th nowrap>&nbsp;<cf_get_lang dictionary_id ='57492.Toplam'><cf_get_lang dictionary_id ='57490.Gün'></th>
						<th nowrap>&nbsp;<cf_get_lang dictionary_id ='57492.Toplam'><cf_get_lang dictionary_id ='57491.Saat'></th>
						<cfif isdefined("is_attenders")>
							<cfset tt = tt+1>
							<th nowrap>&nbsp;<cf_get_lang dictionary_id ='29780.Katılımcı'><cf_get_lang dictionary_id ='39852.Say'></th>
						</cfif>
						<cfif isdefined("is_excuseds")>
							<cfset tt = tt+1>
							<th nowrap>&nbsp;<cf_get_lang dictionary_id ='40347.Mazeretli'><cf_get_lang dictionary_id ='39852.Say'></th>
						</cfif>
						<cfif isdefined("is_trainig_cost")>
							<cfset tt = tt+2>
							<th><cf_get_lang  dictionary_id ='40427.Planlanan Top Maliyet'></th>
							<th><cf_get_lang  dictionary_id ='40428.Gerçekleşen Top Maliyet'></th>
						</cfif>
						<cfif isdefined("is_attendance")>
							<cfset tt = tt+1>
							<th nowrap><cf_get_lang dictionary_id="40766.Yoklama">(%)</th>
						</cfif>
					</tr>
				<cfelseif attributes.report_type eq 2>
					<tr>
						<th><cf_get_lang dictionary_id ='57453.Şube'></th>
						<th><cf_get_lang dictionary_id ='58701.Fonksiyon'></th>
						<th><cf_get_lang dictionary_id ='57419.Eğitim'><cf_get_lang dictionary_id ='39852.Say'></th>
						<th><cf_get_lang dictionary_id ='29780.Katılımcı'><cf_get_lang dictionary_id ='39852.Say'></th>
						<th><cf_get_lang dictionary_id ='57419.Eğitim'><cf_get_lang dictionary_id ='40350.Saati'></th>
						<th><cf_get_lang dictionary_id ='57492.Toplam'><cf_get_lang dictionary_id ='57490.Gün'></th>
						<cfset tt = 6>
					</tr>
				<cfelseif attributes.report_type eq 3>
					<cfif isdefined("attributes.form_submitted")>
						<cfquery name="get_quiz_chapter" datasource="#dsn#">
							SELECT * FROM EMPLOYEE_QUIZ_CHAPTER WHERE QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.quiz_id,'-')#">  
						</cfquery>
						<cfquery name="get_survey_chapter" datasource="#dsn#">
							SELECT SURVEY_CHAPTER_ID,SURVEY_CHAPTER_HEAD,SURVEY_CHAPTER_WEIGHT FROM SURVEY_CHAPTER WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.quiz_id,'-')#"> 
						</cfquery>
					</cfif>
					<cfset tt=4>
					<cfloop query="get_quiz_chapter">
					<cfset tt = tt +1>
					</cfloop>
				
						<tr>
							<th><cf_get_lang dictionary_id='57453.Şube'></th>
							<th><cf_get_lang dictionary_id ='57419.Eğitim'><cf_get_lang dictionary_id ='57897.Adı'></th>
							<th><cf_get_lang dictionary_id ='29427.Kişi Sayısı'></th>
							<th><cf_get_lang dictionary_id ='57419.Eğitim'><cf_get_lang dictionary_id ='58593.Tarihi'> </th>
							<!--- eski degerlendirme formları--->
							<cfif get_quiz_chapter.recordcount>
								<cfif listlen(attributes.quiz_id,'-') eq 1>
									<cfloop query="get_quiz_chapter">
										<th><cfoutput>#get_quiz_chapter.chapter#</cfoutput></th>
									</cfloop>
								<cfelse><!--- yeni degerlendirme formları--->
									<cfloop query="get_survey_chapter">
										<th><cfoutput>#get_survey_chapter.survey_chapter_head#</cfoutput></th>
									</cfloop>
								</cfif>
							
							</cfif> 	
						</tr>	
				</cfif>
				</thead>
			<cfif isdefined("attributes.form_submitted") and attributes.report_type eq 1> 
				<tbody>
				<cfif kayit_sayisi neq 0>
					<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
						<cfset attributes.startrow=1>
						<cfset attributes.maxrows = kayit_sayisi>
					</cfif>
					<cfoutput query="get_training_report" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
							<cfset attributes.startrow=1>
							<cfset attributes.maxrows = get_training_report.recordcount>
						</cfif>
						<tr>
							<td nowrap height="22" width="150">&nbsp;#CLASS_NAME#</td>
							<td nowrap width="90">&nbsp;#get_training_cat_list.TRAINING_CAT[listfind(training_cat_id_list,TRAINING_CAT_ID,',')]#</td>
							<td nowrap width="110">&nbsp;#get_training_sec.SECTION_NAME[listfind(training_sec_id_list,TRAINING_SEC_ID,',')]#</td>
							<td nowrap width="120">&nbsp;
							<cfquery name="get_trainer" dbtype="query">
									SELECT * FROM get_trainers WHERE CLASS_ID = #class_id#
							</cfquery>
							<cfif get_trainer.recordcount>
									<cfloop query="get_trainer">#trainer#<cfif get_trainer.recordcount neq 1>,</cfif></cfloop>
							</cfif>
							<!---  <cfif len(trainer_emp_list)>#get_trainer_emp.EMPLOYEE_NAME[listfind(trainer_emp_list,TRAINER_EMP,',')]# #get_trainer_emp.EMPLOYEE_SURNAME[listfind(trainer_emp_list,TRAINER_EMP,',')]#</cfif>
								<cfif len(trainer_par_list)>#get_trainer_par.COMPANY_PARTNER_NAME[listfind(trainer_par_list,TRAINER_PAR,',')]# #get_trainer_par.COMPANY_PARTNER_SURNAME[listfind(trainer_par_list,TRAINER_PAR,',')]#</cfif>
								<cfif len(trainer_cons_list)>#get_trainer_cons.CONSUMER_NAME[listfind(trainer_cons_list,TRAINER_CONS,',')]# #get_trainer_cons.CONSUMER_SURNAME[listfind(trainer_cons_list,TRAINER_CONS,',')]#</cfif> --->
							</td>
							<td nowrap width="100">&nbsp;#CLASS_PLACE#</td>
							<td nowrap width="160">&nbsp;#dateformat(start_date,dateformat_style)#-#dateformat(finish_date,dateformat_style)#</td>
							<td nowrap width="76">&nbsp;
							<cfset sdate = "">
							<cfset shour = "">
							<cfset fdate = "">
							<cfset fhour = "">
							<cfif len(START_DATE)>
								<cfset sdate=date_add("H",#session.ep.TIME_ZONE#,START_DATE)>
								<cfset shour="#datepart("H",sdate)#:#datepart("N",sdate)#">
							</cfif>
							<cfif len(FINISH_DATE)>
								<cfset fdate=date_add("H",#session.ep.TIME_ZONE#,FINISH_DATE)>
								<cfset fhour="#datepart("H",fdate)#:#datepart("N",fdate)#">
							</cfif>
							<cfif len(START_DATE)>#timeformat(shour,timeformat_style)#</cfif>-<cfif len(FINISH_DATE)>#timeformat(fhour,timeformat_style)#</cfif>
							</td>
							<td nowrap width="70">#DATE_NO# <cf_get_lang dictionary_id ='57490.Gün'></td>
							<td nowrap width="70">#HOUR_NO# <cf_get_lang dictionary_id ='57491.saat'></td>
							<cfif isdefined("is_attenders")>
								<cfquery name="get_training_class_attender" datasource="#dsn#">
									SELECT 
										* 
									FROM 
										TRAINING_CLASS_ATTENDER,
										EMPLOYEE_POSITIONS,
										DEPARTMENT,
										BRANCH
									WHERE 
										CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#">
										AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
										AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
										AND TRAINING_CLASS_ATTENDER.EMP_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
										AND EMPLOYEE_POSITIONS.IS_MASTER = 1 
										<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
											AND BRANCH.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.branch_id#">)
										</cfif>
										<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
											AND EMP_ID IS NOT NULL
										</cfif>
								</cfquery>
							<td width="15" align="right" nowrap style="text-align:right;">
								<cfif get_training_class_attender.RECORDCOUNT>#get_training_class_attender.RECORDCOUNT#</cfif>
							</td>
							</cfif>
							<cfquery name="get_training_class_attendance_" datasource="#dsn#">
								SELECT 
									TCA.START_DATE, 
									TCA.FINISH_DATE, 
									TCADT.EMP_ID,	
									TCADT.CON_ID,	
									TCADT.PAR_ID,
									TCADT.ATTENDANCE_MAIN,
									TCADT.EXCUSE_MAIN,
									TCADT.CLASS_ATTENDANCE_ID,
									TCADT.IS_EXCUSE_MAIN
								FROM 
									TRAINING_CLASS_ATTENDANCE AS TCA, 
									TRAINING_CLASS_ATTENDANCE_DT AS TCADT
								WHERE 
									TCA.CLASS_ATTENDANCE_ID=TCADT.CLASS_ATTENDANCE_ID AND
									TCADT.IS_TRAINER = 0 AND
									<!--- (TCADT.IS_EXCUSE = 1 OR TCADT.IS_EXCUSE_PAR = 1 OR TCADT.IS_EXCUSE_CON = 1) AND  --->
									TCA.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#">
									<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>AND EMP_ID IS NOT NULL</cfif>
							</cfquery>
							<cfif isdefined("is_attendance")>
								<cfquery name="get_total_attendance" dbtype="query">
									SELECT 
										SUM(ATTENDANCE_MAIN) TOTAL_ATTENDANCE
									FROM 
										get_training_class_attendance_
								</cfquery>
							</cfif>
							<cfif isdefined("is_excuseds")>
								<cfquery name="get_training_class_attendance" dbtype="query">
									SELECT 
										*
									FROM 
										get_training_class_attendance_
									WHERE 
										(IS_EXCUSE_MAIN = 1)  
								</cfquery>
							<td width="15" align="right" nowrap style="text-align:right;">
								<cfif get_training_class_attendance.RECORDCOUNT>#get_training_class_attendance.RECORDCOUNT#</cfif>
							</td>
							</cfif>
							<cfif isdefined("is_trainig_cost")>
								<cfquery name="get_training_cost" datasource="#dsn#">
									<!---SELECT
										*
									FROM
										TRAINING_CLASS_COST
									WHERE
									
										CLASS_ID IS NOT NULL
										AND CLASS_ID = #CLASS_ID#--->
									SELECT 
										SUM(CR.GERCEKLESEN) AS GERCEKLESEN_TOPLAM,
										SUM(CR.ONGORULEN) AS ONGORULEN_TOPLAM
									FROM 
										TRAINING_CLASS_COST TC,
										TRAINING_CLASS_COST_ROWS CR
									WHERE 
										TC.TRAINING_CLASS_COST_ID = CR.TRAINING_CLASS_COST_ID AND
										TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#">
								</cfquery>
								<td style="text-align:right"><cfif get_training_cost.recordcount>
										#TLFORMAT(get_training_cost.ONGORULEN_TOPLAM)#
									</cfif>
								</td>
								<td style="text-align:right"><cfif get_training_cost.recordcount>
										#TlFormat(get_training_cost.GERCEKLESEN_TOPLAM)#
									</cfif>
								</td>
							</cfif>
							<cfif isdefined("is_attendance")>
								<td style="text-align:right;"><cfif get_training_class_attendance_.recordcount>&nbsp;#TLFormat(get_total_attendance.total_attendance/get_training_class_attendance_.recordcount)#</cfif></td>
							</cfif>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="16"><cfif isdefined("form_submitted")><cf_get_lang dictionary_id='57484.Kayıt yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '></cfif></td>
					</tr>
				</cfif>
				</tbody>
			<cfelseif attributes.report_type eq 2>
				<cfif isdefined("attributes.form_submitted") and kayit_sayisi neq 0>
				<tbody>
					<cfset count_egitim_saat = 0>
					<cfset count_egitim_gun = 0>
					<cfset count_katilimci = 0>
					<cfset count_egitim = 0>
					<cfset pre_branch_id=0>
					<cfset toplam_saat = 0>
					<cfset toplam_katilimci = 0>
					<cfset toplam_egitim = 0>
					<cfset toplam_gun = 0>
					<cfoutput query="get_function_training">
						<cfquery name="get_hour" dbtype="query">
							SELECT 
								SUM(DATE_NO) TOTAL_DATE_NO,
								SUM(HOUR_NO) TOTAL_HOUR_NO
							FROM
								get_function_training_all
							WHERE
								BRANCH_ID=#BRANCH_ID#
								AND FUNC_ID=#FUNC_ID#
						</cfquery>
						<cfquery name="get_func" dbtype="query">
							SELECT UNIT_ID,UNIT_NAME FROM get_units WHERE UNIT_ID=#FUNC_ID#
						</cfquery>
						<cfset i=currentrow>
						<cfloop condition="BRANCH_ID eq get_function_training.BRANCH_ID[i]"><cfset i=i+1></cfloop>
						<cfif pre_branch_id neq BRANCH_ID and currentrow neq 1>
							<tr class="total">
								<td colspan="2" class="txtboldblue" style="text-align:right;">
									<cf_get_lang dictionary_id ='57492.Toplam'>
								</td>
								<td align="right" class="txtboldblue" style="text-align:right;">#count_egitim#</td>
								<td align="right" class="txtboldblue" style="text-align:right;">#count_katilimci#</td>
								<td align="right" class="txtboldblue" style="text-align:right;">#count_egitim_saat#</td>
								<td align="right" class="txtboldblue" style="text-align:right;">#count_egitim_gun#</td>
								<cfset count_egitim_saat = 0>
								<cfset count_egitim_gun = 0>
								<cfset count_katilimci = 0>
								<cfset count_egitim = 0>
							</tr>
						</cfif>
						<tr>
							<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
								<cfif pre_branch_id neq BRANCH_ID>
									<td>#branch_name#</td>
								<cfelse>
									<td></td>
								</cfif>
							<cfelse>
								<cfif pre_branch_id neq BRANCH_ID>
									<td rowspan="#i-currentrow#">#branch_name#</td>
								</cfif>
							</cfif>
							<td width="200">#get_func.UNIT_NAME#</td>
							<td width="150" align="right" style="text-align:right;">#COUNT_CLASS#</td>
							<td width="200" align="right" style="text-align:right;">#COUNT_EMPLOYEE#</td>
							<td width="170" align="right" style="text-align:right;">#get_hour.TOTAL_HOUR_NO#</td>
							<td align="right" style="text-align:right;">#get_hour.TOTAL_DATE_NO#</td>
						</tr>
						<cfset toplam_saat = toplam_saat + get_hour.TOTAL_HOUR_NO>
						<cfset toplam_gun = toplam_gun + get_hour.TOTAL_DATE_NO>
						<cfset toplam_katilimci = toplam_katilimci + COUNT_EMPLOYEE>
						<cfset toplam_egitim = toplam_egitim + COUNT_CLASS>
						<cfset count_egitim_saat = count_egitim_saat + get_hour.TOTAL_HOUR_NO>
						<cfset count_egitim_gun = count_egitim_gun + get_hour.TOTAL_DATE_NO>
						<cfset count_katilimci = count_katilimci + COUNT_EMPLOYEE>
						<cfset count_egitim = count_egitim + COUNT_CLASS>
						<cfset pre_branch_id=BRANCH_ID>
						<cfif currentrow eq recordcount>
							<tr class="total">
								<td colspan="2" class="txtboldblue" style="text-align:right;">
									<cf_get_lang dictionary_id ='57492.Toplam'>
								</td>
								<td align="right" class="txtboldblue" style="text-align:right;">#count_egitim#</td>
								<td align="right" class="txtboldblue" style="text-align:right;">#count_katilimci#</td>
								<td align="right" class="txtboldblue" style="text-align:right;">#count_egitim_saat#</td>
								<td align="right" class="txtboldblue" style="text-align:right;">#count_egitim_gun#</td>
								<cfset count_egitim_saat = 0>
								<cfset count_egitim_gun = 0>
								<cfset count_katilimci = 0>
								<cfset count_egitim = 0>
							</tr>
						</cfif>
					</cfoutput>
					<tr class="total">
						<td colspan="2" align="right" class="txtbold" style="text-align:right;">Genel <cf_get_lang dictionary_id ='57492.Toplam'></td>
						<cfoutput>
						<td align="right" class="txtbold" style="text-align:right;">#toplam_egitim#</td>
						<td align="right" class="txtbold" style="text-align:right;">#toplam_katilimci#</td>
						<td align="right" class="txtbold" style="text-align:right;">#toplam_saat#</td>
						<td align="right" class="txtbold" style="text-align:right;">#toplam_gun#</td>
						</cfoutput>
					</tr>
				</tbody>
				<cfelse>
					<tr>
						<td colspan="6"><cfif isdefined("form_submitted")><cf_get_lang dictionary_id='57484.Kayıt yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '></cfif></td>
					</tr>
				</tbody>
				</cfif>
			<cfelseif isdefined("attributes.form_submitted") and attributes.report_type eq 3>
				<cfif kayit_sayisi neq 0>
					<cfif get_training_form_all.recordcount>
						<cfset puan = 0>
						<cfset toplam_ortalama_puan = 0>
						<cfloop query="get_quiz_chapter">
							<cfset 'total_#chapter_id#' = 0>
							<cfset 'total_all_#chapter_id#' = 0>
						</cfloop>
						<cfloop query="get_survey_chapter">
							<cfset 'total_#survey_chapter_id#' = 0>
							<cfset 'total_all_#survey_chapter_id#' = 0>
						</cfloop>
						<cfset count_chapter=0>
						<cfset count_all_chapter=0>
						<tbody>
							<cfoutput query="get_training_form_all">	
								<cfif listlen(attributes.quiz_id,'-') eq 1><!---eski degerlendirme formları --->
									<cfquery name="get_class_questions_all" datasource="#dsn#">
										SELECT
											EQC.CHAPTER_WEIGHT,
											EQC.CHAPTER_ID,
											EQRD.QUESTION_POINT,
											EQRD.QUESTION_USER_ANSWERS
										FROM
											EMPLOYEE_QUIZ_QUESTION EQQ,
											EMPLOYEE_QUIZ_RESULTS EQR,
											EMPLOYEE_QUIZ_RESULTS_DETAILS EQRD,
											EMPLOYEE_QUIZ_CHAPTER EQC
										WHERE
											EQR.TRAINING_PERFORMANCE_ID IN 
											(
												SELECT 
													TRAINING_PERFORMANCE_ID
												FROM 
													TRAINING_PERFORMANCE,
													EMPLOYEE_POSITIONS,
													DEPARTMENT 
												WHERE 
													ENTRY_EMP_ID=EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
													EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND
													EMPLOYEE_POSITIONS.IS_MASTER=1 AND
													DEPARTMENT.BRANCH_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#branch_id#"> AND
													CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#"> AND 
													TRAINING_QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quiz_id#">
											)
											AND EQR.RESULT_ID = EQRD.RESULT_ID
											AND EQQ.QUESTION_ID = EQRD.QUESTION_ID
											AND EQQ.CHAPTER_ID = EQC.CHAPTER_ID
											AND EQRD.GD <> 1
										ORDER BY EQC.CHAPTER_ID
									</cfquery>
									<cfif (branch_name neq get_training_form_all.branch_name[currentrow-1] and currentrow neq 1)>
										<tr class="total">
											<td colspan="4" class="txtboldblue">
												<cf_get_lang dictionary_id ='40640.Ortalama'> #get_training_form_all.branch_name[currentrow-1]#
											</td>
											<cfloop query="get_quiz_chapter">
												<td align="right" class="txtboldblue" style="text-align:right;">#wrk_round((evaluate('total_#chapter_id#')/count_chapter),2)#&nbsp;</td>
												<cfset 'total_all_#chapter_id#' = evaluate('total_all_#chapter_id#') + (evaluate('total_#chapter_id#')/count_chapter)>
												<cfset 'total_#chapter_id#' = 0>
											</cfloop>
											<cfset count_all_chapter= count_all_chapter +1>
											<cfset count_chapter = 0>
										</tr>
									</cfif>
								<cfelse>
								<cfquery name="get_class_questions_all" datasource="#dsn#">		
									SELECT
										SURVEY_QUESTION_RESULT.OPTION_POINT AS OPTION_POINT,
										SURVEY_QUESTION_RESULT.SURVEY_QUESTION_ID AS SURVEY_QUESTION_ID
									FROM	
										SURVEY_QUESTION_RESULT,
										SURVEY_MAIN,
										SURVEY_MAIN_RESULT
									WHERE
										SURVEY_MAIN.SURVEY_MAIN_ID = SURVEY_QUESTION_RESULT.SURVEY_MAIN_ID AND
										SURVEY_MAIN.SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.quiz_id,'-')#"> AND
										SURVEY_QUESTION_RESULT.OPTION_POINT IS NOT NULL AND
										<!----SURVEY_QUESTION_RESULT.SURVEY_QUESTION_ID = 539 AND--->
										SURVEY_QUESTION_RESULT.SURVEY_MAIN_RESULT_ID = SURVEY_MAIN_RESULT.SURVEY_MAIN_RESULT_ID AND
										SURVEY_MAIN_RESULT.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#"> AND
										SURVEY_MAIN_RESULT.RECORD_EMP IN(
											SELECT 
												EP.EMPLOYEE_ID 
											FROM 
												EMPLOYEE_POSITIONS EP,
												DEPARTMENT D
											WHERE
												EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
												D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#branch_id#"> AND
												EP.IS_MASTER = 1
											)					 
								</cfquery>
								<cfif (branch_name neq get_training_form_all.branch_name[currentrow-1] and currentrow neq 1)>
									<tr class="total">
										<td colspan="4" class="txtboldblue">
											<cf_get_lang dictionary_id ='40640.Ortalama'> #get_training_form_all.branch_name[currentrow-1]#
										</td>
										<cfloop query="get_survey_chapter">
											<td align="right" class="txtboldblue" style="text-align:right;">#wrk_round((evaluate('total_#survey_chapter_id#')/count_chapter),2)#&nbsp;</td>
											<cfset 'total_all_#survey_chapter_id#' = evaluate('total_all_#survey_chapter_id#') + (evaluate('total_#survey_chapter_id#')/count_chapter)>
											<cfset 'total_#survey_chapter_id#' = 0>
										</cfloop>
										<cfset count_all_chapter= count_all_chapter +1>
										<cfset count_chapter = 0>
									</tr>
								</cfif>
								</cfif>
								<tr>
									<td>&nbsp;#BRANCH_NAME#</td>
									<td>&nbsp;#CLASS_NAME#</td>
									<td align="right" style="text-align:right;">#EMP_ID#&nbsp;</td>
									<td align="center">#dateformat(START_DATE,dateformat_style)# - #dateformat(FINISH_DATE,dateformat_style)#</td>
									<cfset kisi_sayisi = EMP_ID>
									<cfif listlen(attributes.quiz_id,'-') eq 1><!--- eski degerlendirme formları--->
										<cfloop query="get_quiz_chapter">
											<cfquery name="get_chapter_answer" datasource="#dsn#">
												SELECT 
													*
												FROM 
													EMPLOYEE_QUIZ_CHAPTER
												WHERE
													CHAPTER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_quiz_chapter.chapter_id#">
											</cfquery>
											<cfquery name="get_quiz_count" datasource="#dsn#">
												SELECT 
													*
												FROM 
													EMPLOYEE_QUIZ_QUESTION
												WHERE
													CHAPTER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_quiz_chapter.chapter_id#">
											</cfquery>
											<cfset toplam_soru_sayisi = get_quiz_count.recordcount>
											<cfquery name="get_question_point_h" dbtype="query">
												SELECT
													CHAPTER_WEIGHT,
													CHAPTER_ID,
													QUESTION_POINT,
													QUESTION_USER_ANSWERS
												FROM
													get_class_questions_all
												WHERE
													CHAPTER_ID = #get_quiz_chapter.CHAPTER_ID#
											</cfquery>
											<cfset cevaplanan_soru_sayisi = 0>
											
											<cfloop query="get_question_point_h">
												<cfset cevaplanan_soru_sayisi = cevaplanan_soru_sayisi + 1>
											</cfloop>
											<cfset question_point_all = 0>
											<cfset question_points = 0>
											<cfloop query="get_question_point_h">
												<cfset question_points = question_points + get_question_point_h.QUESTION_POINT>
											</cfloop>
											<cfset question_point_all = question_points / kisi_sayisi>
											<cfset max_puan = 0>
											<cfloop from="1" to="20" index="i">
												<cfif evaluate("get_chapter_answer.answer#i#_point") gt max_puan>
													<cfset max_puan = evaluate("get_chapter_answer.answer#i#_point")>
												</cfif> 
											</cfloop>
											<cfif question_point_all neq 0>
												<cfset maximum_puan = INT(wrk_round(get_chapter_answer.chapter_weight/toplam_soru_sayisi*max_puan))*toplam_soru_sayisi>
												<cfset maximum_puann = wrk_round((question_point_all * 100)/maximum_puan)>
											<cfelse>
												<cfset maximum_puann =0>
											</cfif>
											<td align="right" style="text-align:right;">#maximum_puann#&nbsp;</td>
											<cfset 'total_#chapter_id#' = evaluate('total_#chapter_id#') + maximum_puann>
										</cfloop>
									<cfelse><!--- yeni degerlendirme formları--->
										<cfloop query="get_survey_chapter">
											<cfquery name="get_survey_question" datasource="#dsn#">
												SELECT SURVEY_QUESTION_ID FROM SURVEY_QUESTION WHERE SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_chapter_id#">
											</cfquery>
											<cfset toplam_soru_sayisi = get_survey_question.recordcount>
											<cfset max_puan = 0>
											<cfquery name="get_survey_option" datasource="#dsn#">
												SELECT MAX(OPTION_POINT) AS OPTION_POINT FROM SURVEY_OPTION WHERE SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_chapter_id#">
											</cfquery>
											<cfif get_survey_option.OPTION_POINT gt 0>
												<cfset max_puan = get_survey_option.OPTION_POINT>
											</cfif>
											<cfset question_point_all = 0>
											<cfset question_points_ = 0>
											<cfif get_survey_question.recordcount>
												<cfquery name="get_question_point" dbtype="query"> 
													SELECT OPTION_POINT FROM get_class_questions_all WHERE SURVEY_QUESTION_ID IN(#valuelist(get_survey_question.SURVEY_QUESTION_ID,',')#)				
												</cfquery>
												<cfloop query="get_question_point">
													<cfset question_points_ = question_points_ + get_question_point.OPTION_POINT>
												</cfloop>
												<cfset question_point_all = question_points_ / kisi_sayisi>
											</cfif>
											<cfif question_point_all neq 0 and len(SURVEY_CHAPTER_WEIGHT)>
												<cfset maximum_puan = INT(wrk_round(SURVEY_CHAPTER_WEIGHT/toplam_soru_sayisi*max_puan))*toplam_soru_sayisi>
												<cfset maximum_puann = wrk_round((question_point_all * 100)/maximum_puan)>
											<cfelse>
												<cfset maximum_puann =0>
											</cfif>
											<td align="right" style="text-align:right;">#maximum_puann#&nbsp;</td>
											<cfset 'total_#survey_chapter_id#' = evaluate('total_#survey_chapter_id#') + maximum_puann>
										</cfloop>
									</cfif>
								</tr>
								<cfset count_chapter = count_chapter +1>
								<cfif currentrow eq recordcount>
									<tr class="total">
										<td colspan="4" class="txtboldblue">
											<cf_get_lang dictionary_id ='40640.Ortalama'> #get_training_form_all.branch_name[currentrow]#
										</td>
										<cfif listlen(attributes.quiz_id,'-') eq 1><!--- eski degerlendirme formları--->
											<cfloop query="get_quiz_chapter">
												<td align="right" class="txtboldblue" style="text-align:right;">#wrk_round((evaluate('total_#chapter_id#')/count_chapter),2)#&nbsp;</td>
												<cfset 'total_all_#chapter_id#' = evaluate('total_all_#chapter_id#') + (evaluate('total_#chapter_id#')/count_chapter)>
												<cfset 'total_#chapter_id#' = 0>
											</cfloop>
										<cfelse><!---yeni değerlendirme formları --->
											<cfloop query="get_survey_chapter">
												<td align="right" class="txtboldblue" style="text-align:right;">#wrk_round((evaluate('total_#survey_chapter_id#')/count_chapter),2)#&nbsp;</td>
												<cfset 'total_all_#survey_chapter_id#' = evaluate('total_all_#survey_chapter_id#') + (evaluate('total_#survey_chapter_id#')/count_chapter)>
												<cfset 'total_#survey_chapter_id#' = 0>
											</cfloop>
										</cfif>
										<cfset count_all_chapter= count_all_chapter +1>
									</tr>
								</cfif>
							</cfoutput>
							<cfoutput>
								<tr class="total">
									<td colspan="4" class="txtbold"><cf_get_lang dictionary_id ='40640.Ortalama'></td>
									<cfif listlen(attributes.quiz_id,'-') eq 1><!---eski degerlendirme formları --->
										<cfloop query="get_quiz_chapter">
											<td align="right" class="txtbold" style="text-align:right;">#wrk_round((evaluate('total_all_#chapter_id#')/count_all_chapter),2)#&nbsp;</td>
										</cfloop>
									<cfelse><!--- yeni degerlendirme formları--->
										<cfloop query="get_survey_chapter">
											<td align="right" class="txtbold" style="text-align:right;">#wrk_round((evaluate('total_all_#survey_chapter_id#')/count_all_chapter),2)#&nbsp;</td>
										</cfloop>
									</cfif>
								</tr>
							</cfoutput>
						</tbody>
					</cfif>
				<cfelse>
					<tbody>
						<tr>
							<td colspan="8"><cfif isdefined("form_submitted")><cf_get_lang dictionary_id='57484.Kayıt yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '></cfif></td>
						</tr>
					</tbody>
				
				</cfif>
			</cfif>
	</cf_report_list>
</cfif>	
<cfif attributes.report_type eq 1>
	<cfif isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.maxrows>
		<cfset adres = attributes.fuseaction>
		<cfif isdefined("attributes.report_id")>
			<cfset adres = "#adres#&report.training_analyse_function_report">	
		</cfif>
		<cfset adres="#adres#&form_submitted=1">
		<cfset adres="#adres#&report_type=#attributes.report_type#">
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			<cfset adres = "#adres#&branch_id=#attributes.branch_id#">
		</cfif>
		<cfif len(attributes.comp_id)>
			<cfset adres = "#adres#&comp_id=#attributes.comp_id#">
		</cfif>
		<cfif len(attributes.title_id)>
			<cfset adres = "#adres#&title_id=#attributes.title_id#">
		</cfif>
		<cfif len(attributes.training_cat_id)>
			<cfset adres = "#adres#&training_cat_id=#attributes.training_cat_id#">
		</cfif>
		<cfif len(attributes.training_sec_id)>
			<cfset adres = "#adres#&training_sec_id=#attributes.training_sec_id#">
		</cfif>
		<cfif len(attributes.position_cats)>
			<cfset adres = "#adres#&position_cats=#attributes.position_cats#">
		</cfif>
		<cfif len(attributes.department)>
			<cfset adres = "#adres#&department_id='#attributes.department#'">
		</cfif>
		<cfif len(attributes.func_id)>
			<cfset adres = "#adres#&func_id=#attributes.func_id#">
		</cfif>
		<cfif len(attributes.quiz_id)>
			<cfset adres = "#adres#&quiz_id=#attributes.quiz_id#">
		</cfif>
		<cfif len(attributes.training_style)>
			<cfset adres = "#adres#&training_style=#attributes.training_style#">
		</cfif>
		<cfif len(attributes.start_date)>
			<cfset adres = "#adres#&start_date=#attributes.start_date#">
		</cfif>
		<cfif len(attributes.finish_date)>
			<cfset adres = "#adres#&finish_date=#attributes.finish_date#">
		</cfif>
		<cfif isdate(attributes.start_date)>
			<cfset attributes.start_date = dateformat(attributes.start_date, dateformat_style)>
		</cfif>
		<cfif isdate(attributes.finish_date)>
			<cfset attributes.finish_date = dateformat(attributes.finish_date, dateformat_style)>
		</cfif>
		<cfif len(attributes.is_attenders)>
			<cfset adres = "#adres#&is_attenders=#attributes.is_attenders#">
		</cfif>
		<cfif len(attributes.is_excuseds)>
			<cfset adres = "#adres#&is_excuseds=#attributes.is_excuseds#">
		</cfif>
		<cfif len(attributes.is_trainig_cost)>
			<cfset adres = "#adres#&is_trainig_cost=#attributes.is_trainig_cost#">
		</cfif>
		<cfif len(attributes.is_attendance)>
			<cfset adres = "#adres#&is_attendance=#attributes.is_attendance#">
		</cfif>
		<cfif len(attributes.employee_id) and len(attributes.employee)>
			<cfset adres = "#adres#&employee_id=#attributes.employee_id#&employee=#attributes.employee#">
		</cfif>
		<table width="98%" align="center" cellpadding="0" cellspacing="0" height="35">
		<tr>
		  <td>
			<cf_pages page="#attributes.page#"
			  maxrows="#attributes.maxrows#"
			  totalrecords="#attributes.totalrecords#"
			  startrow="#attributes.startrow#"
			  adres="#adres#">
		  </td>
		  <td align="right" style="text-align:right;">
		  <cfoutput><cf_get_lang dictionary_id ='57540.Toplam Kayıt'> :#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id ='57581.Sayfa'> :#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
	  </table>
	</cfif>
</cfif>
<br/>
<script type="text/javascript">
	function goster_anket()
	{
		if(document.form_report.report_type.value == 1)
		fonksiyon.style.display = '';
		else if (document.form_report.report_type.value == 3 || document.form_report.report_type.value == 2)
		fonksiyon.style.display = 'none';
		
		if(document.form_report.report_type.value == 3)
		anket.style.display = '';
		else if (document.form_report.report_type.value == 1 || document.form_report.report_type.value == 2)
		anket.style.display = 'none';
	}
	function kontrol_anket()
	{
		if(document.form_report.report_type.value == 3 && document.form_report.quiz_id.value == 0)
		{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='40017.Eğitim Formu'>");
		return false;
		}
		if(document.form_report.report_type.value == 1 && document.form_report.maxrows.value.length == 0)
		{
		alert("<cf_get_lang dictionary_id ='40353.kayıt sayısını boş bırakmayın'>");
		return false;
		}
		if(document.form_report.is_excel.checked==false)
        {
            document.form_report.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.training_analyse_function_report"
            return true;
        }
        else if(document.form_report.is_excel.checked==true){
			
            document.form_report.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_training_analyse_function_report</cfoutput>"
        }
	}
	function get_branch_list(gelen)
	{
		checkedValues_b = $("#comp_id").multiselect("getChecked");
		var comp_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(comp_id_list == '')
				comp_id_list = checkedValues_b[kk].value;
			else
				comp_id_list = comp_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&comp_id="+comp_id_list;
		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
	}
	function get_department_list(gelen)
	{
		checkedValues_b = $("#branch_id").multiselect("getChecked");
		var branch_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(branch_id_list == '')
				branch_id_list = checkedValues_b[kk].value;
			else
				branch_id_list = branch_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department&branch_id="+branch_id_list;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
	function get_training_secs()
	{
		for (i=document.getElementById("training_sec_id").options.length-1;i>-1;i--)
		{
			document.getElementById("training_sec_id").options.remove(i);
		}	
	
		var get_training_sec = wrk_query("SELECT TRAINING_SEC_ID, SECTION_NAME FROM TRAINING_SEC WHERE TRAINING_CAT_ID = " + document.getElementById("training_cat_id").value+" ORDER BY SECTION_NAME","dsn");
	
		if(get_training_sec.recordcount > 0)
		{
			document.getElementById("training_sec_id").options.add(new Option("<cf_get_lang dictionary_id ='57995.Bölüm'>", ''));
			for(i = 1;i<=get_training_sec.recordcount;++i)
			{
				document.getElementById("training_sec_id").options.add(new Option(get_training_sec.SECTION_NAME[i-1], get_training_sec.TRAINING_SEC_ID[i-1]));
			}
		}
	}
</script>

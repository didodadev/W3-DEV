<!--- form generator formları sonuç raporu SG 20140715--->
<cfsetting showdebugoutput="no" >
<cfparam default="" name="keyword">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.title_id" default="">
<cfparam name="attributes.survey_id" default="">
<cfparam name="attributes.inout_statue" default="2">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="0">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfparam name="attributes.startdate" default="#date_add('m',-1,bu_ay_basi)#">
<cfparam name="attributes.finishdate" default="#Createdate(year(bu_ay_basi),month(bu_ay_basi),bu_ay_sonu)#">
<cfquery name="get_zone" datasource="#dsn#">
	SELECT ZONE_ID,ZONE_NAME FROM ZONE WHERE ZONE_STATUS = 1 ORDER BY ZONE_NAME
</cfquery>
<cfquery name="get_our_company" datasource="#dsn#">
	SELECT 
		COMP_ID,
		COMPANY_NAME,
		NICK_NAME 
	FROM 
		OUR_COMPANY 
	<cfif not session.ep.ehesap>
        WHERE COMP_ID IN (SELECT DISTINCT B.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH B ON B.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
    </cfif>
	ORDER BY 
		COMPANY_NAME
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH 
    WHERE
        <cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
            COMPANY_ID IN(#attributes.comp_id#) 
            <cfif not session.ep.ehesap>
                AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
            </cfif>
        <cfelse>
            1=0
        </cfif>
    ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="get_departments" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>BRANCH_ID IN(#attributes.branch_id#)<cfelse>1=0</cfif> AND DEPARTMENT_STATUS = 1 ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfquery name="get_position_cat" datasource="#dsn#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT
</cfquery>
<cfquery name="get_title" datasource="#dsn#">
	SELECT TITLE_ID,TITLE FROM SETUP_TITLE ORDER BY TITLE
</cfquery>
<cfif isdefined("attributes.is_form_submitted")>
<cf_date tarih="attributes.startdate">
	<cf_date tarih="attributes.finishdate">
	<!--- seçilen kriterlere göre çalışan kayıtları---->
	<cfquery name="get_employee" datasource="#dsn#">
		SELECT 
			E.EMPLOYEE_ID,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			E.EMPLOYEE_EMAIL,
			SPC.POSITION_CAT,
			T.TITLE,
			OC.NICK_NAME,
			B.BRANCH_NAME,
			D.DEPARTMENT_HEAD,
			ZONE.ZONE_NAME,
			EP.POSITION_NAME
		FROM 
			EMPLOYEES E INNER JOIN EMPLOYEES_IN_OUT EI
			ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
			INNER JOIN BRANCH B ON EI.BRANCH_ID = B.BRANCH_ID 
			INNER JOIN DEPARTMENT D ON EI.DEPARTMENT_ID = D.DEPARTMENT_ID 
			INNER JOIN OUR_COMPANY OC ON B.COMPANY_ID = OC.COMP_ID 
			INNER JOIN ZONE ON ZONE.ZONE_ID = B.ZONE_ID 
			INNER JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID 
			INNER JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID 
			INNER JOIN SETUP_TITLE T ON T.TITLE_ID = EP.TITLE_ID
		WHERE
			EP.IS_MASTER = 1
			<cfif isdefined('attributes.zone_id') and len(attributes.zone_id)>
				AND ZONE.ZONE_ID  IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#" list = "yes">)
			</cfif>
			<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
				AND OC.COMP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">)
			</cfif>	
			<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
				AND B.BRANCH_ID IN(#attributes.branch_id#)
			</cfif>
			<cfif not session.ep.ehesap>
				AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
				AND OC.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
			<cfif isdefined('attributes.department_id') and len(trim(attributes.department_id))>
				AND D.DEPARTMENT_ID IN(#attributes.department_id#)
			</cfif>
			<cfif isdefined('attributes.position_cat_id') and len(attributes.position_cat_id)>
				AND SPC.POSITION_CAT_ID IN(#attributes.position_cat_id#)
			</cfif>
			<cfif isdefined('attributes.title_id') and len(attributes.title_id)>
				AND EP.TITLE_ID IN(#attributes.title_id#)
			</cfif>
            <cfif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 1><!--- Girişler --->
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					AND EI.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					AND EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
				</cfif>
			<cfelseif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 0><!--- Çıkışlar --->
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					AND EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					AND EI.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> 
				</cfif>
				AND	EI.FINISH_DATE IS NOT NULL
			<cfelseif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 2><!--- aktif calisanlar --->
				AND 
				(
					<cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
						<cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
						(
							(
							EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
							)
							OR
							(
							EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EI.FINISH_DATE IS NULL
							)
						)
						<cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
						(
							(
							EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
							EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
							)
							OR
							(
							EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
							EI.FINISH_DATE IS NULL
							)
						)
						<cfelse>
						(
							(
							EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
							)
							OR
							(
							EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EI.FINISH_DATE IS NULL
							)
							OR
							(
							EI.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
							)
							OR
							(
							EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EI.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
							)
						)
						</cfif>
					<cfelse>
						EI.FINISH_DATE IS NULL
					</cfif>
				)
			</cfif>	
       	UNION
        SELECT 
			E.EMPLOYEE_ID,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			E.EMPLOYEE_EMAIL,
			SPC.POSITION_CAT,
			T.TITLE,
			OC.NICK_NAME,
			B.BRANCH_NAME,
			D.DEPARTMENT_HEAD,
			ZONE.ZONE_NAME,
			EP.POSITION_NAME
       	FROM 
			EMPLOYEES E INNER JOIN EMPLOYEES_IN_OUT EI
			ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
			INNER JOIN BRANCH B ON EI.BRANCH_ID = B.BRANCH_ID 
			INNER JOIN DEPARTMENT D ON EI.DEPARTMENT_ID = D.DEPARTMENT_ID 
			INNER JOIN OUR_COMPANY OC ON B.COMPANY_ID = OC.COMP_ID 
			INNER JOIN ZONE ON ZONE.ZONE_ID = B.ZONE_ID 
			INNER JOIN EMPLOYEE_POSITIONS_CHANGE_HISTORY EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID 
			INNER JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID 
			INNER JOIN SETUP_TITLE T ON T.TITLE_ID = EP.TITLE_ID
       	WHERE
        	E.EMPLOYEE_ID NOT IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID IS NOT NULL)
            <cfif isdefined('attributes.zone_id') and len(attributes.zone_id)>
				AND ZONE.ZONE_ID  IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#" list = "yes">)
			</cfif>
			<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
				AND OC.COMP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">)
			</cfif>	
			<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
				AND B.BRANCH_ID IN(#attributes.branch_id#)
			</cfif>
			<cfif not session.ep.ehesap>
				AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
				AND OC.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
			<cfif isdefined('attributes.department_id') and len(trim(attributes.department_id))>
				AND D.DEPARTMENT_ID IN(#attributes.department_id#)
			</cfif>
			<cfif isdefined('attributes.position_cat_id') and len(attributes.position_cat_id)>
				AND SPC.POSITION_CAT_ID IN(#attributes.position_cat_id#)
			</cfif>
			<cfif isdefined('attributes.title_id') and len(attributes.title_id)>
				AND EP.TITLE_ID IN(#attributes.title_id#)
			</cfif>
            <cfif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 1><!--- Girişler --->
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					AND EI.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					AND EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
				</cfif>
			<cfelseif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 0><!--- Çıkışlar --->
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					AND EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					AND EI.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> 
				</cfif>
				AND	EI.FINISH_DATE IS NOT NULL
			<cfelseif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 2><!--- aktif calisanlar --->
				AND 
				(
					<cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
						<cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
						(
							(
							EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
							)
							OR
							(
							EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EI.FINISH_DATE IS NULL
							)
						)
						<cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
						(
							(
							EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
							EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
							)
							OR
							(
							EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
							EI.FINISH_DATE IS NULL
							)
						)
						<cfelse>
						(
							(
							EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
							)
							OR
							(
							EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EI.FINISH_DATE IS NULL
							)
							OR
							(
							EI.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
							)
							OR
							(
							EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EI.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
							)
						)
						</cfif>
					<cfelse>
						EI.FINISH_DATE IS NULL
					</cfif>
				)
			</cfif>	
	</cfquery>

	
	<cfset anketi_dolduranlar_result_id = "0">
	<cfset anketi_dolduranlar_emp_id = "0">
	<cfquery name="get_survey_result_" datasource="#dsn#">
		SELECT 
			SURVEY_MAIN_RESULT_ID,
			ISNULL(EMP_ID,ACTION_ID) EMP_ID,
			RECORD_DATE
		FROM 
			SURVEY_MAIN_RESULT	
		WHERE
			SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> 
			AND (EMP_ID IS NOT NULL OR ACTION_ID IS NOT NULL)
	</cfquery>
	<cfloop query="get_survey_result_">
		<cfset emp_id = "#get_survey_result_.survey_main_result_id#"&":"&"#get_survey_result_.emp_id#">
		<cfset anketi_dolduranlar_result_id = listappend(anketi_dolduranlar_result_id,get_survey_result_.survey_main_result_id,',')>
		<cfset anketi_dolduranlar_emp_id = listappend(anketi_dolduranlar_emp_id,get_survey_result_.emp_id,',')>
	</cfloop>	
	<cfquery name="get_survey_result" datasource="#dsn#">
		<cfif attributes.report_type eq 1><!--- Soru Bazında--->
			SELECT 
				  SQ.SURVEY_QUESTION_ID,
				  SQ.QUESTION_HEAD,
				  SO.OPTION_HEAD,
                  SC.SURVEY_CHAPTER_HEAD,
				  COUNT(SQR.SURVEY_OPTION_ID) AS SAYAC
			FROM 
				  SURVEY_QUESTION_RESULT SQR INNER JOIN SURVEY_QUESTION SQ
				  ON SQR.SURVEY_QUESTION_ID = SQ.SURVEY_QUESTION_ID
				  INNER JOIN SURVEY_OPTION SO ON SO.SURVEY_OPTION_ID = SQR.SURVEY_OPTION_ID
                  LEFT JOIN SURVEY_CHAPTER SC ON SO.SURVEY_CHAPTER_ID = SC.SURVEY_CHAPTER_ID
			WHERE
				  SQR.SURVEY_MAIN_ID = #attributes.survey_id# AND
				  SQR.SURVEY_OPTION_ID IS NOT NULL AND
				  SQR.SURVEY_MAIN_RESULT_ID IN (#anketi_dolduranlar_result_id#) AND
				  SQ.QUESTION_TYPE <> 5
			GROUP BY
				  SQ.QUESTION_HEAD,
				  SO.OPTION_HEAD,
				  SQ.SURVEY_QUESTION_ID,
                  SURVEY_CHAPTER_HEAD
			ORDER BY
				  SQ.SURVEY_QUESTION_ID			
		<cfelseif attributes.report_type eq 2> <!---sonuç bazında --->
			SELECT 
				SURVEY_MAIN_RESULT_ID,
                SURVEY_MAIN_ID,
				SCORE_RESULT,
                EMPLOYEE_EMAIL,
                RECORD_IP
			FROM 
				SURVEY_MAIN_RESULT
			WHERE
				SURVEY_MAIN_ID = #attributes.survey_id# AND
				SURVEY_MAIN_RESULT_ID IN(#anketi_dolduranlar_result_id#)		
		<cfelseif attributes.report_type eq 3><!---metin tipinde soru bazında --->
			SELECT 
				  SQR.SURVEY_MAIN_RESULT_ID,
				  SQ.SURVEY_QUESTION_ID,
				  SQ.QUESTION_HEAD,
				  SQR.OPTION_HEAD
			FROM 
				  SURVEY_QUESTION_RESULT SQR INNER JOIN SURVEY_QUESTION SQ
				  ON SQR.SURVEY_QUESTION_ID = SQ.SURVEY_QUESTION_ID
				  INNER JOIN SURVEY_OPTION SO ON SO.SURVEY_OPTION_ID = SQR.SURVEY_OPTION_ID
			WHERE
				  SQR.SURVEY_MAIN_ID = 6 AND
				  SQR.SURVEY_OPTION_ID IS NOT NULL AND
				  SQ.QUESTION_TYPE = 5 AND
				  SQR.OPTION_HEAD IS NOT NULL AND SQR.OPTION_HEAD <>' '	AND
				  SQR.SURVEY_MAIN_RESULT_ID IN(#anketi_dolduranlar_result_id#)				  		
		</cfif>
	</cfquery>
<cfelse>
	<cfset get_survey_result.recordcount = 0>
</cfif>
<!-- sil -->
<cfsavecontent variable="head"><cf_get_lang no='1530.Anket Raporu' ></cfsavecontent>
<cfform name="search_report" method="post" action="#request.self#?fuseaction=report.survey_report">
	<cf_report_list_search title="#head#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang_main no='162.Şirket'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<div class="multiselect-z2">
													<cf_multiselect_check 
													query_name="get_our_company"  
													name="comp_id"
													option_value="COMP_ID"
													option_name="NICK_NAME"
													option_text="#getLang('main',322)#"
													value="#attributes.comp_id#"
													onchange="get_branch_list(this.value)">
												</div>											
											</div>	
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang_main no='580.Bölge'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<div class="multiselect-z2">
													<cf_multiselect_check 
													query_name="get_zone"  
													name="zone_id"
													option_value="ZONE_ID"
													option_name="ZONE_NAME"
													option_text="#getLang('main',322)#"
													value="#attributes.zone_id#">
												</div>											
											</div>	
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang_main no='41.Şube'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<div id="BRANCH_PLACE" class="multiselect-z2">
													<cf_multiselect_check 
													query_name="get_branch"  
													name="branch_id"
													option_value="BRANCH_ID"
													option_name="BRANCH_NAME"
													option_text="#getLang('main',322)#"
													value="#attributes.branch_id#"
													onChange="get_department_list(this.value)">
												</div>											
											</div>	
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang_main no='160.Departman'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<div class="multiselect-z2" id="DEPARTMENT_PLACE">
													<cf_multiselect_check 
													query_name="get_departments"  
													name="department"
													option_text="#getLang('main',322)#" 
													option_value="department_id"
													option_name="department_head"
													value="#iif(isdefined("attributes.department"),"attributes.department",DE(""))#">
												</div>												
											</div>	
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang_main no='1250.Anket'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<cfquery name="get_survey_main" datasource="#dsn#">
													SELECT
														SURVEY_MAIN_ID,
														SURVEY_MAIN_HEAD,
														TYPE 
													FROM 
														SURVEY_MAIN
													WHERE
														--TYPE = 8 AND
														IS_ACTIVE = 1	
													ORDER BY
														SURVEY_MAIN_HEAD				
													</cfquery>
													<select name="survey_id" id="survey_id" style="width:150px;">
														<cfoutput query="get_survey_main">
															<option value="#survey_main_id#"<cfif attributes.survey_id eq survey_main_id>selected</cfif>>#survey_main_head#</option>
														</cfoutput>
													</select>
											</div>	
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang_main no='1592.Pozisyon Tipi'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<div class="multiselect-z1">
													<cf_multiselect_check 
													query_name="get_position_cat"  
													name="position_cat_id"
													option_value="POSITION_CAT_ID"
													option_name="POSITION_CAT"
													option_text="#getLang('main',322)#"
													value="#attributes.position_cat_id#">
												</div>									
											</div>	
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang_main no='1548.Rapor Tipi'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<select name="report_type" id="report_type" style="width:150px;">
													<option value="1"<cfif isdefined('attributes.report_type') and attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='64909.Soru Bazında'></option>
													<option value="2"<cfif isdefined('attributes.report_type') and attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id='64910.Sonuç Bazında'></option>
													<option value="3"<cfif isdefined('attributes.report_type') and attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id='64911.Metin Tipinde Soru Bazında'></option>
												</select>
											</div>	
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang_main no='159.Ünvan'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<div class="multiselect-z1">
													<cf_multiselect_check 
													query_name="get_title"  
													name="title_id"
													option_value="TITLE_ID"
													option_name="TITLE"
													option_text="#getLang('main',322)#"
													value="#attributes.title_id#">
												</div>
											</div>	
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='50669'></label>
												<div class="col col-12 col-md-12 col-xs-12">
													<select name="inout_statue" id="inout_statue">
														<option value=""><cf_get_lang dictionary_id='55904.Giriş ve Çıkışlar'></option>
														<option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang_main no='1123.Girişler'></option>
														<option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang_main no='1124.Çıkışlar'></option>
														<option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang dictionary_id='42953.Aktif Çalışanlar'></option>
													</select>
												</div>
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='50669'><cf_get_lang_main no='1278.Tarih Aralığı'></label>
												<div class="col col-6 col-md-6">
													<div class="input-group">
														<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='641.Başlangıç Tarihi'></cfsavecontent>
														<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
															<cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" message="#message#"  value="#dateformat(attributes.startdate,dateformat_style)#">
														<cfelse>
															<cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" message="#message#" >
														</cfif>
														<span class="input-group-addon">
														<cf_wrk_date_image date_field="startdate">
														</span>
													</div>
												</div>
												<div class="col col-6 col-md-6">
													<div class="input-group">
														<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='288.Bitiş Tarihi'></cfsavecontent>
														<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
															<cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
														<cfelse>
															<cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" message="#message#" >
														</cfif>
														<span class="input-group-addon">
														<cf_wrk_date_image date_field="finishdate">
														</span>
													</div>
												</div>
											</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang_main no='446.Excel Getir'></label>
							<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<input name="is_form_submitted" id="is_form_submitted" value="1" type="hidden">
							<cf_wrk_report_search_button button_type="1" is_excel='1' search_function="control()">
						</div>
					</div>
				</div>
			</div> 
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<cfset type_ = 1>
<cfelse>
	<cfset type_ = 0>
</cfif>

<cfif isdefined("attributes.is_form_submitted")>
	<cfif attributes.is_excel eq 1>
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows = get_employee.recordcount>
	</cfif>	  
	<cf_report_list>
		<thead>
			<tr>
				<th><cf_get_lang_main no='75.no'></th>
				<cfif attributes.report_type eq 1>
					<th class="form-title"><cf_get_lang_main no='583.Bölüm'></th>
					<th class="form-title"><cf_get_lang_main no='1398.Soru'></th>
					<th class="form-title"><cf_get_lang_main no='1242.Cevap'></th>
					<th class="form-title"><cf_get_lang dictionary_id='49403'></th>
					<th class="form-title"><cf_get_lang_main no='1044.Oran'>(%)</th>	
				<cfelseif attributes.report_type eq 2 or attributes.report_type eq 3>
					<th class="form-title"><cf_get_lang_main no='162.Şirket'></th>
					<th class="form-title"><cf_get_lang_main no='41.Şube'></th>
					<th class="form-title"><cf_get_lang_main no='160.Departman'></th>
					<th class="form-title"><cf_get_lang_main no='580.Bölge'></th>
					<th class="form-title"><cf_get_lang_main no='1592.Pozisyon Tipi'></th>
					<th class="form-title"><cf_get_lang_main no='159.Ünvan'></th>
					<cfif attributes.report_type eq 2>
						<th class="form-title"><cf_get_lang_main no='272.Sonuç'></th>	
					<cfelseif attributes.report_type eq 3>
						<th class="form-title"><cf_get_lang_main no='1398.Soru'></th>
						<th class="form-title" style="width:400px;"><cf_get_lang_main no='359.Detay'><cf_get_lang_main no='163.Görüşler'>/</th>
					</cfif>
				</cfif>
			</tr>
		</thead>
		<tbody>
		<cfif get_survey_result.recordcount>
			<cfset all_result_total = 0>
			<cfset attributes.totalrecords = get_survey_result.recordcount>
			<cfoutput query="get_survey_result" maxrows=#attributes.maxrows# startrow=#attributes.startrow#>
			<tr class="color-row" height="22">
				<td>#currentrow#</td>
				<cfif attributes.report_type eq 1>
					<td>#survey_chapter_head#</td>
					<td>#question_head#</td>
					<td>#option_head#</td>
					<td>#sayac#</td>
					<td style='mso-number-format:"0\.00"'>
						<cfquery name="get_all_count" dbtype="query">
							SELECT 
								SURVEY_QUESTION_ID, QUESTION_HEAD, SURVEY_CHAPTER_HEAD, SUM(SAYAC) AS TOTAL
							FROM
								get_survey_result
							GROUP BY 
								SURVEY_QUESTION_ID, QUESTION_HEAD, SURVEY_CHAPTER_HEAD
						</cfquery>
						#wrk_round(sayac / get_all_count.TOTAL * 100)#
					</td>
				<cfelseif attributes.report_type eq 2 or attributes.report_type eq 3>
					<cfset employee_id_ = 0>
					<cfloop list="#anketi_dolduranlar_emp_id#" delimiters="," index="result_id">
						<cfif listgetat(result_id,1,":") eq survey_main_result_id>
							<cfset employee_id_ = listgetat(result_id,1,":")>
						</cfif>
					</cfloop>
					<cfset employee_id_ = listgetat(anketi_dolduranlar_emp_id,listfind(anketi_dolduranlar_result_id,survey_main_result_id,','),',')>
					<cfquery name="get_emp_det" dbtype="query">
						SELECT * FROM get_employee WHERE EMPLOYEE_ID = #employee_id_#
					</cfquery>
					<td>#get_emp_det.nick_name#</td>
					<td>#get_emp_det.branch_name#</td>
					<td>#get_emp_det.department_head#</td>
					<td>#get_emp_det.zone_name#</td>
					<td>#get_emp_det.position_name#</td> 
					<td>#get_emp_det.title#</td>
					<cfif attributes.report_type eq 2>
						<td style="text-align:right"><cfif len(score_result)>#TlFormat(score_result)# <cfset all_result_total = all_result_total+score_result></cfif></td>
						<!--- <td style="text-align:right">#TlFormat(score_result)#<cfset all_result_total = all_result_total+score_result></td> --->
					<cfelseif attributes.report_type eq 3>
						<td>#question_head#</td>
						<td style="width:400px;">#option_head#</td>
					</cfif>
				</cfif>	
			</tr>
			</cfoutput>
			<cfif attributes.report_type eq 2><!--- sonuç bazında raporda sonuç puanları ortalaması--->
			<tr height="30" class="color-list">
				<td colspan="7" style="text-align:right" class="txtbold">Ortalama</td>
				<td style="text-align:right" class="txtbold"><cfoutput>#TlFormat(all_result_total/get_survey_result.recordcount)#</cfoutput></td>
			</tr>
			</cfif>
		<cfelse>
			<tr class="color-row">
				<td colspan="9"><cfif isdefined('attributes.is_form_submitted')><cf_get_lang_main no='72.Kayıt Yok'>!<cfelse><cf_get_lang_main no ='289.Filtre Ediniz'>!</cfif></td>
			</tr>
		</cfif>
		</tbody>
	</cf_report_list>
	<br/>
	<cfif attributes.totalrecords gt attributes.maxrows>
            <cfset url_str = "">
            <cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
                <cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
            </cfif>
			<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
                <cfset url_str = "#url_str#&comp_id=#attributes.comp_id#">
            </cfif>
            <cfif isdefined("attributes.zone_id") and len(attributes.zone_id)>
                <cfset url_str = "#url_str#&zone_id=#attributes.zone_id#">
            </cfif>
			<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
                <cfset url_str = "#url_str#&department_id=#attributes.department_id#">
            </cfif>
            <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
                <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
            </cfif>
			<cfif isdefined("attributes.survey_id") and len(attributes.survey_id)>
                <cfset url_str = "#url_str#&survey_id=#attributes.survey_id#">
            </cfif>
			<cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
                <cfset url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#">
            </cfif>
			<cfif isdefined("attributes.report_type") and len(attributes.report_type)>
                <cfset url_str = "#url_str#&report_type=#attributes.report_type#">
            </cfif>
			<cfif isdefined("attributes.title_id") and len(attributes.title_id)>
                <cfset url_str = "#url_str#&title_id=#attributes.title_id#">
            </cfif>
			<cfif isdefined("attributes.inout_statue") and len(attributes.inout_statue)>
                <cfset url_str = "#url_str#&inout_statue=#attributes.inout_statue#">
            </cfif>
			<cfif len(attributes.startdate)>
				<cfset url_str = "#url_str#&startdate=#attributes.startdate#">
			</cfif>
			<cfif len(attributes.finishdate)>
				<cfset url_str = "#url_str#&finishdate=#attributes.finishdate#">
			</cfif>
            <cfif attributes.is_excel eq 0>
				<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#attributes.fuseaction#&#url_str#"> 
            </cfif>
    </cfif>
</cfif>
<script>
			function control(){
				
				if(!date_check(search_report.startdate,search_report.finishdate,"<cf_get_lang no ='1589.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
					return false;
				}
				if(!$("#survey_id").val().length)
				{
					alertObject({message: "<cf_get_lang dictionary_id='62202.Anket Seçiniz'>"})    
					return false;
				}
				if(document.search_report.is_excel.checked==false)
				{
					document.search_report.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
					return true;
				}
				else
					document.search_report.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_survey_report</cfoutput>"
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
</script>

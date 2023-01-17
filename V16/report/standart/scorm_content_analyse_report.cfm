<cfsetting showdebugoutput="yes">
<cfparam name="attributes.module_id_control" default="34">
<cfinclude template="report_authority_control.cfm">
<cfprocessingdirective suppresswhitespace="yes">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.order_type" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.class_id" default="">
<cfparam name="attributes.is_completed" default="">
<cfparam name="attributes.is_excel" default="">
<cfif isdefined("attributes.is_submitted")>
	<cfquery name="get_main_scorm" datasource="#dsn#">
	<cfif attributes.report_type eq 1 or attributes.report_type eq 2 or attributes.report_type eq 5>
	SELECT 
		TC.CLASS_NAME AS ETKNLK,
		SCO.NAME AS CLASS_NAME,
		TC.CLASS_ID AS CLASS_ID,
		SCO.SCO_ID AS SCO_ID,
		SCD.USER_ID AS USER_ID,
		<cfif attributes.report_type eq 5>
		(SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = CP.CITY) AS CITY_NAME,
		</cfif>
		CP.COMPANY_PARTNER_NAME+' '+CP.COMPANY_PARTNER_SURNAME AS CALISAN_NAME,
		C.NICKNAME AS FIRMA,
		C.COMPANY_ID AS FIRMA_ID,
		ROUND((SELECT CASE 
			WHEN ISNUMERIC(CAST(VAR_VALUE AS varchar(50))) = 1 THEN CAST(VAR_VALUE AS varchar(50))
			ELSE '0'
			END  
		FROM 
			TRAINING_CLASS_SCO_DATA 
		WHERE 
			USER_ID = SCD.USER_ID AND USER_TYPE = 1 AND VAR_NAME = 'cmi.progress_measure' AND SCO_ID = SCD.SCO_ID
		),6)*100 AS PROGRESS,
		ROUND((SELECT CASE 
			WHEN ISNUMERIC(CAST(VAR_VALUE AS varchar(50))) = 1 THEN CAST(VAR_VALUE AS varchar(50))
			ELSE '0'
			END  
		FROM 
			TRAINING_CLASS_SCO_DATA WHERE USER_ID = SCD.USER_ID AND USER_TYPE = 1 AND (VAR_NAME = 'cmi.score.scaled' OR VAR_NAME = 'cmi.score.scaled') AND SCO_ID = SCD.SCO_ID
		),6)*100 AS SCORE
		,(SELECT VAR_VALUE FROM TRAINING_CLASS_SCO_DATA WHERE USER_ID = SCD.USER_ID AND USER_TYPE = 1 AND SCO_ID = SCD.SCO_ID AND (VAR_NAME LIKE 'cmi.completion_status' OR VAR_NAME LIKE 'cmi.core.lesson_status')) AS COMPLETED
	FROM 
		TRAINING_CLASS_SCO SCO
		INNER JOIN TRAINING_CLASS TC ON SCO.CLASS_ID = TC.CLASS_ID
		INNER JOIN TRAINING_CLASS_SCO_DATA SCD ON SCO.SCO_ID = SCD.SCO_ID
		INNER JOIN COMPANY_PARTNER CP ON SCD.USER_ID = CP.PARTNER_ID 
		INNER JOIN COMPANY C ON CP.COMPANY_ID = C.COMPANY_ID
	WHERE
		SCD.USER_TYPE = 1
		AND (SCD.VAR_NAME = 'cmi.learner_id' OR SCD.VAR_NAME = 'cmi.core.student_id')
		<cfif len(attributes.keyword)>
		AND (
			SCO.NAME LIKE '%#attributes.keyword#%'
			OR
			TC.CLASS_NAME LIKE '%#attributes.keyword#%'
			)
		</cfif>	
		<cfif len(attributes.class_id) and len(attributes.class_name)>
		AND TC.CLASS_ID = #attributes.class_id#
		</cfif>
		<cfif isdefined("attributes.emp_par_name") and len(attributes.emp_par_name) and isdefined("attributes.par_id") and len(attributes.par_id)>
		AND SCD.USER_ID = #attributes.par_id#
		<cfelseif isdefined("attributes.emp_par_name") and len(attributes.emp_par_name) and not len(attributes.par_id)>
		AND 0=1
		</cfif>
		<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
		AND C.COMPANY_ID = #attributes.company_id#
		</cfif>
	</cfif>
	<cfif attributes.report_type eq 3 or attributes.report_type eq 5>
	<cfif attributes.report_type eq 5>
	UNION ALL
	</cfif>
	SELECT 
		TC.CLASS_NAME AS ETKNLK,
		SCO.NAME AS CLASS_NAME,
		TC.CLASS_ID AS CLASS_ID,
		SCO.SCO_ID AS SCO_ID,
		SCD.USER_ID AS USER_ID,		
		<cfif attributes.report_type eq 5>
		(SELECT SC.CITY_NAME FROM SETUP_CITY SC,EMPLOYEES_DETAIL ED WHERE SC.CITY_ID = ED.HOMECITY AND ED.EMPLOYEE_ID = E.EMPLOYEE_ID) AS CITY_NAME, 
		</cfif>
		E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS CALISAN_NAME,
		(SELECT C.COMPANY_NAME FROM EMPLOYEE_POSITIONS EP,DEPARTMENT D,BRANCH B,OUR_COMPANY C WHERE EP.EMPLOYEE_ID = SCD.USER_ID AND EP.DEPARTMENT_ID=D.DEPARTMENT_ID AND D.BRANCH_ID = B.BRANCH_ID AND B.COMPANY_ID = C.COMP_ID AND EP.IS_MASTER = 1) AS FIRMA,
		(SELECT C.COMP_ID FROM EMPLOYEE_POSITIONS EP,DEPARTMENT D,BRANCH B,OUR_COMPANY C WHERE EP.EMPLOYEE_ID = SCD.USER_ID AND EP.DEPARTMENT_ID=D.DEPARTMENT_ID AND D.BRANCH_ID = B.BRANCH_ID AND B.COMPANY_ID = C.COMP_ID AND EP.IS_MASTER = 1) AS FIRMA_ID,
		ROUND((SELECT CASE 
			WHEN ISNUMERIC(CAST(VAR_VALUE AS varchar(50))) = 1 THEN CAST(VAR_VALUE AS varchar(50))
			ELSE '0'
			END  
		FROM 
			TRAINING_CLASS_SCO_DATA WHERE USER_ID = SCD.USER_ID AND USER_TYPE = 0 AND VAR_NAME = 'cmi.progress_measure' AND SCO_ID = SCD.SCO_ID
		),6)*100 AS PROGRESS,
		ROUND((SELECT CASE 
			WHEN ISNUMERIC(CAST(VAR_VALUE AS varchar(50))) = 1 THEN CAST(VAR_VALUE AS varchar(50))
			ELSE '0'
			END  
		FROM 
			TRAINING_CLASS_SCO_DATA WHERE USER_ID = SCD.USER_ID AND USER_TYPE = 0 AND (VAR_NAME = 'cmi.score.scaled' OR VAR_NAME = 'cmi.score.scaled') AND SCO_ID = SCD.SCO_ID
		),6)*100 AS SCORE
		,(SELECT VAR_VALUE FROM TRAINING_CLASS_SCO_DATA WHERE USER_ID = SCD.USER_ID AND USER_TYPE = 0 AND SCO_ID = SCD.SCO_ID AND (VAR_NAME LIKE 'cmi.completion_status' OR VAR_NAME LIKE 'cmi.core.lesson_status')) AS COMPLETED
	FROM 
		TRAINING_CLASS_SCO SCO
		INNER JOIN TRAINING_CLASS TC ON SCO.CLASS_ID = TC.CLASS_ID
		INNER JOIN TRAINING_CLASS_SCO_DATA SCD ON SCO.SCO_ID = SCD.SCO_ID
		INNER JOIN EMPLOYEES E ON SCD.USER_ID = E.EMPLOYEE_ID 
	WHERE  
		SCD.USER_TYPE = 0
		AND (SCD.VAR_NAME = 'cmi.learner_id' OR SCD.VAR_NAME = 'cmi.core.student_id')
		<cfif len(attributes.keyword)>
		AND (
			SCO.NAME LIKE '%#attributes.keyword#%'
			OR
			TC.CLASS_NAME LIKE '%#attributes.keyword#%'
			)
		</cfif>	
		<cfif len(attributes.class_id) and len(attributes.class_name)>
		AND TC.CLASS_ID = #attributes.class_id#
		</cfif>
		<cfif isdefined("attributes.emp_par_name") and len(attributes.emp_par_name) and isdefined("attributes.emp_id") and len(attributes.emp_id)>
		AND SCD.USER_ID = #attributes.emp_id#
		<cfelseif isdefined("attributes.emp_par_name") and len(attributes.emp_par_name) and not len(attributes.emp_id)>
		AND 0=1
		</cfif>
	</cfif>
	<cfif attributes.report_type eq 4 or attributes.report_type eq 5>
	<cfif attributes.report_type eq 5>
	UNION ALL
	</cfif>
	SELECT 
		TC.CLASS_NAME AS ETKNLK,
		SCO.NAME AS CLASS_NAME,
		TC.CLASS_ID AS CLASS_ID,
		SCO.SCO_ID AS SCO_ID,
		SCD.USER_ID AS USER_ID,
		<cfif attributes.report_type eq 5>
		(SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = C.HOME_CITY_ID) AS CITY_NAME,
		</cfif>
		C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS CALISAN_NAME,
		'' AS FIRMA,
		0 AS FIRMA_ID,
		ROUND((SELECT CASE 
			WHEN ISNUMERIC(CAST(VAR_VALUE AS varchar(50))) = 1 THEN CAST(VAR_VALUE AS varchar(50))
			ELSE '0'
			END  
		FROM 
			TRAINING_CLASS_SCO_DATA WHERE USER_ID = SCD.USER_ID AND USER_TYPE = 2 AND VAR_NAME = 'cmi.progress_measure' AND SCO_ID = SCD.SCO_ID
		),6)*100 AS PROGRESS,
		ROUND((SELECT CASE 
			WHEN ISNUMERIC(CAST(VAR_VALUE AS varchar(50))) = 1 THEN CAST(VAR_VALUE AS varchar(50))
			ELSE '0'
			END  
		FROM 
			TRAINING_CLASS_SCO_DATA WHERE USER_ID = SCD.USER_ID AND USER_TYPE = 2 AND (VAR_NAME = 'cmi.score.scaled' OR VAR_NAME = 'cmi.score.scaled') AND SCO_ID = SCD.SCO_ID
		),6)*100 AS SCORE
		,(SELECT VAR_VALUE FROM TRAINING_CLASS_SCO_DATA WHERE USER_ID = SCD.USER_ID AND USER_TYPE = 2 AND SCO_ID = SCD.SCO_ID AND (VAR_NAME LIKE 'cmi.completion_status' OR VAR_NAME LIKE 'cmi.core.lesson_status')) AS COMPLETED
	FROM 
		TRAINING_CLASS_SCO SCO
		INNER JOIN TRAINING_CLASS TC ON SCO.CLASS_ID = TC.CLASS_ID
		INNER JOIN TRAINING_CLASS_SCO_DATA SCD ON SCO.SCO_ID = SCD.SCO_ID
		INNER JOIN CONSUMER C ON SCD.USER_ID = C.CONSUMER_ID 
	WHERE
		SCD.USER_TYPE = 2
		AND (SCD.VAR_NAME = 'cmi.learner_id' OR SCD.VAR_NAME = 'cmi.core.student_id')
		<cfif len(attributes.keyword)>
		AND (
			SCO.NAME LIKE '%#attributes.keyword#%'
			OR
			TC.CLASS_NAME LIKE '%#attributes.keyword#%'
			)
		</cfif>	
		<cfif len(attributes.class_id) and len(attributes.class_name)>
		AND TC.CLASS_ID = #attributes.class_id#
		</cfif>
		<cfif isdefined("attributes.emp_par_name") and len(attributes.emp_par_name) and isdefined("attributes.cons_id") and len(attributes.cons_id)>
		AND SCD.USER_ID = #attributes.cons_id#
		<cfelseif isdefined("attributes.emp_par_name") and len(attributes.emp_par_name) and not len(attributes.cons_id)>
		AND 0=1
		</cfif>
	</cfif>
	</cfquery>
		<cfquery name="get_distinct_name" dbtype="query">
		SELECT 	
			<cfif attributes.report_type eq 1>
			ETKNLK,
			CLASS_NAME,
			CLASS_ID,
			SCO_ID,
			FIRMA,
			FIRMA_ID
			,COUNT(USER_ID) AS KATILIMCI
			,(SUM(PROGRESS) / COUNT(USER_ID)) AS PROGRES
			,(SUM(SCORE) / COUNT(USER_ID)) AS SCORE_
			<cfelseif attributes.report_type eq 2 or attributes.report_type eq 3 or attributes.report_type eq 4>
			ETKNLK,
			CLASS_NAME,
			CLASS_ID,
			SCO_ID,
			FIRMA,
			FIRMA_ID,
			SUM(PROGRESS) PROGRES,
			SUM(SCORE) SCORE_
			,USER_ID
			,CALISAN_NAME
			,COMPLETED
			<cfelse>
			CITY_NAME,
			COUNT(USER_ID) AS KATILIMCI
			,(SUM(PROGRESS) / COUNT(USER_ID)) as PROGRES
			,(SUM(SCORE) / COUNT(USER_ID)) AS SCORE_
			</cfif>
		FROM  
			get_main_scorm
		<cfif isdefined("attributes.is_completed") and len(attributes.is_completed)>
		WHERE
			<cfif attributes.is_completed eq 1>
			COMPLETED = 'completed'			
			<cfelse>
			COMPLETED <> 'completed'			
			</cfif>
		</cfif>
		GROUP BY
			<cfif attributes.report_type eq 2 or attributes.report_type eq 3 or attributes.report_type eq 4>
			ETKNLK,
			CLASS_NAME,
			CLASS_ID,
			SCO_ID,
			FIRMA,
			FIRMA_ID
			,USER_ID
			,CALISAN_NAME
			,COMPLETED
			<cfelseif attributes.report_type eq 1>
			ETKNLK,
			CLASS_NAME,
			CLASS_ID,
			SCO_ID,
			FIRMA,
			FIRMA_ID
			<cfelse>
			CITY_NAME
			</cfif>
		ORDER BY
		<cfif attributes.report_type neq 5>
			<cfif attributes.order_type eq 1>
                KATILIMCI ASC
            <cfelseif attributes.order_type eq 2> 	
                KATILIMCI DESC		
            <cfelseif attributes.order_type eq 3> 
            	<cfif attributes.report_type eq 1>	
                	PROGRES ASC
                <cfelse>
                	PROGRES ASC
                </cfif>
            <cfelseif attributes.order_type eq 4> 	
                <cfif attributes.report_type eq 1>	
                	PROGRES DESC
                <cfelse>
                	PROGRES DESC
                </cfif>
            <cfelseif attributes.order_type eq 5> 	
                SCORE_ ASC
            <cfelseif attributes.order_type eq 6> 	
                SCORE_ DESC
            <cfelse>
                ETKNLK,
                CLASS_NAME		
            </cfif>
		<cfelse>
			<cfif attributes.order_type eq 1>
                KATILIMCI ASC
            <cfelseif attributes.order_type eq 2> 	
                KATILIMCI DESC		
            <cfelse>
                CITY_NAME
            </cfif>
		</cfif>
	</cfquery>
<cfelse>
	<cfset get_distinct_name.recordcount = 0>
</cfif>
<cfquery name="get_class" datasource="#dsn#">
	SELECT 
		CLASS_ID,
		CLASS_NAME
	FROM 
		TRAINING_CLASS
	WHERE 
		IS_ACTIVE = 1
	ORDER BY
		CLASS_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_distinct_name.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfform name="form" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
<input type="hidden" name="is_submitted" id="is_submitted" value="1">
    <cf_report_list_search title="#getLang('report',904)#">
        <cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='48.Filtre'></label>
										<div class="col col-12 col-xs-12">
											<cfinput type="text" name="keyword" value="#attributes.keyword#">
										</div>
									</div>
								</div>
								<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no="7.Eğitim"></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="class_id" value="<cfif len(attributes.class_id) and len(attributes.class_name)><cfoutput>#attributes.class_id#</cfoutput></cfif>" id="class_id">
												<input type="text" name="class_name" value="<cfif len(attributes.class_id) and len(attributes.class_name)><cfoutput>#attributes.class_name#</cfoutput></cfif>" id="class_name" onfocus="AutoComplete_Create('class_name','CLASS_NAME','CLASS_NAME','get_training_class','','CLASS_ID','class_id','','3','200');">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen(<cfoutput>'#request.self#</cfoutput>?fuseaction=objects.popup_list_classes&field_id=form.class_id&field_name=form.class_name','list');return false"></span>	
											</div>
										</div>
									</div>
								</div>
								<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no="1548.Rapor Tipi"></label>
										<div class="col col-12 col-xs-12">
											 <select name="report_type" onchange="order_kontrol(this.value);">
											 	<option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<option value="1"<cfif isdefined('attributes.report_type') and (attributes.report_type is 1)>selected</cfif>><cf_get_lang_main no="173.Kurumsal Üye"></option>
												<option value="2"<cfif isdefined('attributes.report_type') and (attributes.report_type is 2)>selected</cfif>><cf_get_lang no="920.Kurumsal Üye Çalışanları"></option>
												<option value="3"<cfif isdefined('attributes.report_type') and (attributes.report_type is 3)>selected</cfif>><cf_get_lang no="1001.Çalışan Bazında"></option>
												<option value="4"<cfif isdefined('attributes.report_type') and (attributes.report_type is 4)>selected</cfif>><cf_get_lang_main no="174.Bireysel Üye"></option>
												<option value="5"<cfif isdefined('attributes.report_type') and (attributes.report_type is 5)>selected</cfif>><cf_get_lang no="754.İl Bazında"></option>
											</select>
										</div>
									</div>
								</div>
								<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='874.Tamamlanma Tipi'></label>
										<div class="col col-12 col-xs-12">
											<select name="is_completed" id="is_completed">
												<option value=""><cf_get_lang_main no="296.Tümü"></option>
												<option value="1"<cfif attributes.is_completed eq 1>selected</cfif>><cf_get_lang no="921.Tamamlayanlar"></option>
												<option value="0"<cfif attributes.is_completed eq 0>selected</cfif>><cf_get_lang no="933.Tamamlamayanlar"></option>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no="173.Kurumsal Üye"></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<cfoutput>
													<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>#attributes.company_id#</cfif>">
													<input type="text" name="company" id="company" style="width:120px;" value="<cfif isdefined("attributes.company") and len(attributes.company)>#URLDecode(attributes.company)#</cfif>" autocomplete="on" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','150');">
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_member_name=form.company&field_comp_id=form.company_id&select_list=2&keyword='+encodeURIComponent(document.form.company.value),'list');"></span>	
												</cfoutput>
											</div>
										</div>
									</div>
								</div>
								<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no="1983.Katılımcı"></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="emp_id" id="emp_id" value="<cfif isdefined("attributes.emp_id") and len(attributes.emp_id) and isdefined("attributes.emp_par_name") and len(attributes.emp_par_name)><cfoutput>#attributes.emp_id#</cfoutput></cfif>">
												<input type="hidden" name="par_id" id="par_id" value="<cfif isdefined("attributes.par_id") and len(attributes.par_id) and isdefined("attributes.emp_par_name") and len(attributes.emp_par_name)><cfoutput>#attributes.par_id#</cfoutput></cfif>">
												<input type="hidden" name="cons_id" id="cons_id" value="<cfif isdefined("attributes.cons_id") and len(attributes.cons_id) and isdefined("attributes.emp_par_name") and len(attributes.emp_par_name)><cfoutput>#attributes.cons_id#</cfoutput></cfif>">
												<input type="text" name="emp_par_name" id="emp_par_name" value="<cfif isdefined("attributes.emp_par_name") and len(attributes.emp_par_name)><cfoutput>#attributes.emp_par_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('emp_par_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',0,0,0','EMPLOYEE_ID,PARTNER_ID,CONSUMER_ID','EMP_ID,PAR_ID,CONS_ID','','3','120');" autocomplete="on"/>
												<span class="input-group-addon btnPointer icon-ellipsis"  onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form.emp_id&field_name=form.emp_par_name&field_partner=form.par_id&field_consumer=form.cons_id&select_list=1<cfif get_module_user(4)>,2,8</cfif></cfoutput>','list');"></span>	
											</div>
										</div>
									</div>
								</div>
								<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang no="905.Sıralama Şekli"></label>
										<div class="col col-12 col-xs-12">
											<select name="order_type" style="width:150px;" id="order_type">
												<option value=""<cfif isdefined('attributes.order_type') and not len(attributes.order_type)>selected</cfif>><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<option id="type1" <cfif attributes.report_type neq 1 and attributes.report_type neq 5>disabled="disabled"</cfif> value="1"<cfif isdefined('attributes.order_type') and (attributes.order_type is 1)>selected</cfif>><cf_get_lang_main no="1983.Katılımcı"> <cf_get_lang no="1131.Sayısı"> <cf_get_lang_main no="2029.Artan"></option>
												<option id="type2" <cfif attributes.report_type neq 1 and attributes.report_type neq 5>disabled="disabled"</cfif> value="2"<cfif isdefined('attributes.order_type') and (attributes.order_type is 2)>selected</cfif>><cf_get_lang_main no="1983.Katılımcı"> <cf_get_lang no="1131.Sayısı"> <cf_get_lang_main no="2030.Azalan"></option>
												<option value="3"<cfif isdefined('attributes.order_type') and (attributes.order_type is 3)>selected</cfif>><cf_get_lang no="912.Tamamlanma Oranı Artan"></option>
												<option value="4"<cfif isdefined('attributes.order_type') and (attributes.order_type is 4)>selected</cfif>><cf_get_lang no="913.Tamamlanma Oranı Azalan"></option>
												<option value="5"<cfif isdefined('attributes.order_type') and (attributes.order_type is 5)>selected</cfif>><cf_get_lang_main no="1975.Skor"> <cf_get_lang_main no="2029.Artan"></option>
												<option value="6"<cfif isdefined('attributes.order_type') and (attributes.order_type is 6)>selected</cfif>><cf_get_lang_main no="1975.Skor"> <cf_get_lang_main no="2030.Azalan"></option>
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
                                <cf_wrk_report_search_button  search_function='control()' insert_info='#message#' button_type='1' is_excel="1">   
                        </div>
                    </div>
				</div>
            </div>
         </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset filename="scorm_content_analyse_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="content-type" content="text/plain; charset=utf-16">
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_distinct_name.recordcount>
	<cfset type_ = 1>
	<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.is_submitted")>
	<cf_report_list>
			
				<thead>
					<tr>
						<cfif attributes.report_type neq 5>
						<th><cf_get_lang_main no="7.Eğitim"></th>
						<th><cf_get_lang_main no="241.İçerik"></th>
						<th><cf_get_lang_main no="1195.Firma"></th>
						<cfelse>
						<th><cf_get_lang_main no="1196.İl"></th>
						</cfif>
						<th><cfif attributes.report_type eq 1 or attributes.report_type eq 5><cf_get_lang_main no="1983.Katılımcı"> <cf_get_lang no="1131.Sayısı"><cfelseif attributes.report_type eq 2 or attributes.report_type eq 3 or attributes.report_type eq 4><cf_get_lang_main no="164.Çalışan"></cfif></th>
						<cfif attributes.report_type neq 5>
						<cfif attributes.report_type eq 2 or attributes.report_type eq 3 or attributes.report_type eq 4>
						<th><cf_get_lang no="941.Tamamlanma Durumu"></th>
						</cfif>		
						<th><cf_get_lang no="942.Tamamlanma Oranı"> (%)</th>
						<th><cf_get_lang_main no="1975.Skor"></th>
						</cfif>
					</tr>
				</thead>
			
				<tbody>
					<cfif get_distinct_name.recordcount>
						<cfoutput query="get_distinct_name" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
								<cfif attributes.report_type neq 5>
								<td>#ETKNLK#</td>	
								<td>#CLASS_NAME#</td>	
								<td>#FIRMA#</td>
								<cfelse>
								<td>#city_name#</td>
								</cfif>
								<td>
									<cfif attributes.report_type eq 1 or attributes.report_type eq 5>#KATILIMCI#
									<cfelseif attributes.report_type eq 2 or attributes.report_type eq 3 or attributes.report_type eq 4>#CALISAN_NAME#
									</cfif>
								</td>
								<cfif attributes.report_type eq 2 or attributes.report_type eq 3 or attributes.report_type eq 4>
								<td><cfif COMPLETED eq 'incomplete'><cf_get_lang_main no="2068.Tamamlanmadı"><cfelseif COMPLETED eq 'completed'><cf_get_lang_main no="1374.Tamamlandı"></cfif></td>
								</cfif>
								<cfif attributes.report_type neq 5>
								<td>
									<cfif isdefined("KATILIMCI") and PROGRES gt 0>
										% #round(PROGRES)#
									<cfelse>
										<cfif PROGRES gt 0>
										% #round(PROGRES)#
										</cfif>
									</cfif>
									<!--- <cfset tamamlanma_oran_total = 0>
									<cfquery name="get_oran" dbtype="query">
										SELECT PROGRESS FROM get_main_scorm WHERE SCO_ID = #SCO_ID# <cfif attributes.report_type eq 2 or attributes.report_type eq 3>AND USER_ID = #user_id#<cfelseif attributes.report_type eq 1> AND FIRMA_ID = #firma_id#</cfif>
									</cfquery>
									<cfloop query="get_oran">
										<cfif isnumeric(PROGRESS)>
											<cfset tamamlanma_oran_total = tamamlanma_oran_total+round(PROGRESS*100)>
										</cfif>
									</cfloop>
									<cfif isdefined("KATILIMCI")>
									<cfset sonuc = tamamlanma_oran_total/KATILIMCI>
									#TlFormat(sonuc,2)#
									<cfelse>
									#Tlformat(tamamlanma_oran_total,2)#
									</cfif> --->
								</td>
								<td>
									<cfif isdefined("KATILIMCI") and SCORE_ gt 0>
										#round(SCORE_)#
									<cfelse>
										<cfif SCORE_ gt 0>
											#round(SCORE_)#
										</cfif>
									</cfif>
									<!--- <cfset score_total = 0>
									<cfquery name="get_score" dbtype="query">
										SELECT SCORE FROM get_main_scorm WHERE SCO_ID = #SCO_ID# <cfif attributes.report_type eq 2 or attributes.report_type eq 3>AND USER_ID = #user_id#<cfelseif attributes.report_type eq 1> AND FIRMA_ID = #firma_id#</cfif>
									</cfquery>
									<cfloop query="get_score">
										<cfif isnumeric(SCORE)>
											<cfset score_total = score_total+round(SCORE*100)>
										</cfif>
									</cfloop>
									<cfif isdefined("KATILIMCI")>
									<cfset sonuc_ = score_total/KATILIMCI>
									#TlFormat(sonuc_,2)#
									<cfelse>
									#TlFormat(score_total,2)#
									</cfif> --->
								</td>
								</cfif>
							</tr>
						</cfoutput>
						<cfelse>
							<tr>
								<td colspan="13"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '></cfif></td>
							</tr>
					</cfif>
				</tbody>
					
	</cf_report_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfset url_str = "">
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#&is_submitted=#attributes.is_submitted#">
		<cfif len(attributes.order_type)>
			<cfset url_str = "#url_str#&order_type=#attributes.order_type#">
		</cfif>
		<cfif len(attributes.report_type)>
			<cfset url_str = "#url_str#&report_type=#attributes.report_type#">
		</cfif>
		<cfif len(attributes.class_id) and len(attributes.class_name)>
			<cfset url_str = "#url_str#&class_id=#attributes.class_id#&class_name=#attributes.class_name#">
		</cfif>
		<cfif isdefined("attributes.is_completed") and len(attributes.is_completed)>
			<cfset url_str = "#url_str#&is_completed=#attributes.is_completed#">
		</cfif>
		<cfif isdefined("attributes.emp_par_name") and len(attributes.emp_par_name)>
			<cfset url_str = "#url_str#&emp_par_name=#attributes.emp_par_name#">
		</cfif>
		<cfif isdefined("attributes.emp_id") and len(attributes.emp_id)>
			<cfset url_str = "#url_str#&emp_id=#attributes.emp_id#">
		</cfif>
		<cfif isdefined("attributes.cons_id") and len(attributes.cons_id)>
			<cfset url_str = "#url_str#&cons_id=#attributes.cons_id#">
		</cfif>
		<cfif isdefined("attributes.par_id") and len(attributes.par_id)>
			<cfset url_str = "#url_str#&par_id=#attributes.par_id#">
		</cfif>
		<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
			<cfset url_str = "#url_str#&company_id=#attributes.company_id#&company=#attributes.company#">
		</cfif>
		<table width="100%" cellpadding="2" cellspacing="1" border="0" align="center">
			<tr>
			<td><cf_pages page="#attributes.page#" 
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#attributes.fuseaction#&#url_str#">
			</td>
			<!-- sil --><td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
			</tr>
		</table>
	</cfif>
</cfif>
</cfprocessingdirective>

<script type="text/javascript">
	{ 
		document.form.keyword.select();
	}
	function order_kontrol(deger)
	{
		if(deger != 1 && deger != 5)
		{
			var x=document.getElementById("type1");
			x.disabled=true;
			var x2=document.getElementById("type2");
			x2.disabled=true;
			document.getElementById("order_type").value = "";
		}
		else
		{
			var x=document.getElementById("type1");
			x.disabled=false;
			var x2=document.getElementById("type2");
			x2.disabled=false;
		}
	}
	function control(){
		if(document.form.is_excel.checked==false)
        {
            document.form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.scorm_content_analyse_report"
            return true;
        }
        else{
            document.form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_scorm_content_analyse_report</cfoutput>"
        }
	}
</script>

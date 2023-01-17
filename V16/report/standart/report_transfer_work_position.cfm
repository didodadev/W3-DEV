<cf_xml_page_edit fuseact='report.report_transfer_work_position'>
<cfset cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps")>
<cfset cmp_org_step.dsn = dsn>
<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch_name" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.in_out_id" default="">
<cfparam name="attributes.reason_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'> 
<cfsavecontent variable="ay1"><cf_get_lang dictionary_id='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id='57593.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id='57596.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id='57599.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id='57602.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id='57603.Aralık'></cfsavecontent>
<cfset ay_listesi = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
<cfparam name="attributes.years" default="">
<cfparam name="attributes.months" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfif len(attributes.startdate) and isdate(attributes.startdate)><cf_date tarih = "attributes.startdate"></cfif>
<cfif len(attributes.finishdate) and isdate(attributes.finishdate)><cf_date tarih = "attributes.finishdate"></cfif>
<cfparam name="kvar" default="0">
<cfset emp_list="">
<cfquery name="get_branches" datasource="#dsn#">
	SELECT DISTINCT
		RELATED_COMPANY,COMPANY_ID
	FROM 
		BRANCH 
	WHERE 
		RELATED_COMPANY IS NOT NULL AND
		BRANCH_ID IS NOT NULL 
		<cfif not session.ep.ehesap>
			AND BRANCH_ID IN (SELECT EMPLOYEE_POSITION_BRANCHES.BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
		</cfif>
	ORDER BY 
		RELATED_COMPANY
</cfquery>
<cfquery name="get_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>BRANCH_ID IN(#attributes.branch_id#)<cfelse>1=0</cfif> AND DEPARTMENT_STATUS = 1 ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfif isdefined("is_submitted")>
	<cfquery name="get_emp_in_out" datasource="#dsn#">
		SELECT 
        	XXX.EMPLOYEE_NO,
       		XXX.EMPLOYEE_NO,
			XXX.POSITION_CAT,
			XXX.TC_IDENTY_NO,
			XXX.HISTORY_ID,
			XXX.POSITION_ID,
			XXX.POSITION_CAT_ID,
			XXX.EMPLOYEE_ID,
			XXX.RECORD_DATE,
			XXX.IN_COMPANY_REASON_ID,
			XXX.DEPARTMENT_HEAD,
			XXX.EMPLOYEE_NAME,
			XXX.EMPLOYEE_SURNAME,
			XXX.BRANCH_NAME,
			XXX.RELATED_COMPANY,
			XXX.BRANCH_ID,
			XXX.DEPARTMENT_ID,
			XXX.START_DATE,
          	YYY.EMPLOYEE_NO AS EMPLOYEE_NO1 ,
            YYY.POSITION_CAT AS POSITION_CAT1 ,
            YYY.TC_IDENTY_NO AS TC_IDENTY_NO1 ,
            YYY.HISTORY_ID AS HISTORY_ID1,
            YYY.POSITION_ID AS POSITION_ID1,
            YYY.POSITION_CAT_ID AS  POSITION_CAT_ID1,
            YYY.EMPLOYEE_ID AS EMPLOYEE_ID1,
            YYY.RECORD_DATE AS RECORD_DATE1,
            YYY.IN_COMPANY_REASON_ID AS IN_COMPANY_REASON_ID1,
            YYY.DEPARTMENT_HEAD AS DEPARTMENT_HEAD1,
            YYY.EMPLOYEE_NAME AS EMPLOYEE_NAME1, 
            YYY.EMPLOYEE_SURNAME AS EMPLOYEE_SURNAME1,
            YYY.BRANCH_NAME AS BRANCH_NAME1,
            YYY.RELATED_COMPANY RELATED_COMPANY1,
            YYY.BRANCH_ID AS BRANCH_ID1,
            YYY.DEPARTMENT_ID AS DEPARTMENT_ID1,
			YYY.START_DATE AS START_DATE1,
			YYY.HIERARCHY_DEP_ID AS HIERARCHY_DEP_ID1
        FROM 
        (SELECT 
			E.EMPLOYEE_NO,
			SPC.POSITION_CAT,
			EI.TC_IDENTY_NO,
			EP.HISTORY_ID,
			EP.POSITION_ID,
			EP.POSITION_CAT_ID,
			EP.EMPLOYEE_ID,
			EP.RECORD_DATE,
			EP.IN_COMPANY_REASON_ID,
			DEPARTMENT.DEPARTMENT_HEAD,
			EP.EMPLOYEE_NAME,
			EP.EMPLOYEE_SURNAME,
			BRANCH.BRANCH_NAME,
			BRANCH.RELATED_COMPANY,
			BRANCH.BRANCH_ID,
			DEPARTMENT.DEPARTMENT_ID,
			EPCH.START_DATE,
			CASE 
				WHEN E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE START_DATE <= GETDATE() AND (FINISH_DATE >= GETDATE() OR FINISH_DATE IS NULL))
			THEN    
				DEPARTMENT.HIERARCHY_DEP_ID
			ELSE 
				CASE WHEN 
					DEPARTMENT.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID))
				THEN
					(SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC)
				ELSE
					DEPARTMENT.HIERARCHY_DEP_ID
					END
			END AS HIERARCHY_DEP_ID
		FROM
			EMPLOYEES_IDENTY EI,
			DEPARTMENT,
			BRANCH,
			SETUP_POSITION_CAT SPC,
			EMPLOYEE_POSITIONS_HISTORY EP,
			EMPLOYEES E
			LEFT JOIN EMPLOYEE_POSITIONS_CHANGE_HISTORY EPCH ON E.EMPLOYEE_ID=EPCH.EMPLOYEE_ID
		WHERE
			SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID AND
			SPC.POSITION_CAT_ID = EPCH.POSITION_CAT_ID AND
			E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
			EI.EMPLOYEE_ID = EP.EMPLOYEE_ID 
			AND DEPARTMENT.DEPARTMENT_ID=EP.DEPARTMENT_ID
			AND DEPARTMENT.DEPARTMENT_ID=EPCH.DEPARTMENT_ID
			AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
			<cfif session.ep.isBranchAuthorization>
				AND BRANCH.BRANCH_ID IN (
							SELECT
								BRANCH_ID
							FROM
								EMPLOYEE_POSITION_BRANCHES
							WHERE
								EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
						)
			</cfif>
			<cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and (attributes.branch_id is not 'all')>
				AND BRANCH.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
			</cfif>
			<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and len(employee_name)>
				AND E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
			</cfif>
			<cfif isdefined('attributes.department') and len(attributes.department)>
				AND DEPARTMENT.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#" list = "yes">)
			</cfif>
			<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
				AND BRANCH.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#" list = "yes">)
			</cfif>
			<cfif not session.ep.ehesap>
				AND BRANCH.BRANCH_ID IN (
							SELECT
								BRANCH_ID
							FROM
								EMPLOYEE_POSITION_BRANCHES
							WHERE
								EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
						)
			</cfif>
			<cfif isdefined('attributes.reason_id') and len(attributes.reason_id)>AND EP.IN_COMPANY_REASON_ID IN (#attributes.reason_id#)</cfif>
			<cfif len(attributes.years)>
				<cfif database_type eq "MSSQL">
					AND 
					(
                        DATEPART("yyyy",EPCH.START_DATE)=#attributes.years#
                    <cfif len(attributes.months)>
						AND DATEPART("mm",EPCH.START_DATE)=#attributes.months# 
                    </cfif>
					)
				<cfelseif database_type eq "DB2">
					AND 
					(
					YEAR(EPCH.START_DATE)=#attributes.years#
					<cfif len(attributes.months)>
						AND MONTH(EPCH.START_DATE)=#attributes.months#
                    </cfif>
					)
				</cfif>
			</cfif>
			<cfif len(attributes.startdate) and len(attributes.finishdate)>
				AND EPCH.START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
			<cfelseif len(attributes.startdate)>
				AND EPCH.START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			</cfif>
				) AS XXX  OUTER APPLY 
                
                (
                	SELECT  TOP 1
                        E.EMPLOYEE_NO,
                        SPC.POSITION_CAT,
                        EI.TC_IDENTY_NO,
                        EP.HISTORY_ID,
                        EP.POSITION_ID,
                        EP.POSITION_CAT_ID,
                        EP.EMPLOYEE_ID,
                        EP.RECORD_DATE,
                        EP.IN_COMPANY_REASON_ID,
                        DEPARTMENT.DEPARTMENT_HEAD,
                        EP.EMPLOYEE_NAME,
                        EP.EMPLOYEE_SURNAME,
                        BRANCH.BRANCH_NAME,
                        BRANCH.RELATED_COMPANY,
                        BRANCH.BRANCH_ID,
                        DEPARTMENT.DEPARTMENT_ID,
						EPCH.START_DATE,
						CASE 
							WHEN E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE START_DATE <= GETDATE() AND (FINISH_DATE >= GETDATE() OR FINISH_DATE IS NULL))
						THEN    
							DEPARTMENT.HIERARCHY_DEP_ID
						ELSE 
							CASE WHEN 
								DEPARTMENT.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID))
							THEN
								(SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC)
							ELSE
								DEPARTMENT.HIERARCHY_DEP_ID
								END
						END AS HIERARCHY_DEP_ID
                    FROM
                        EMPLOYEES_IDENTY EI,
                        DEPARTMENT,
                        BRANCH,
                        SETUP_POSITION_CAT SPC,
						EMPLOYEE_POSITIONS_HISTORY EP,
						EMPLOYEES E
						LEFT JOIN EMPLOYEE_POSITIONS_CHANGE_HISTORY EPCH ON E.EMPLOYEE_ID=EPCH.EMPLOYEE_ID
                    WHERE
                        SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID AND
						EP.POSITION_CAT_ID = EPCH.POSITION_CAT_ID AND
                        E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
						EI.EMPLOYEE_ID = EP.EMPLOYEE_ID 
                        AND DEPARTMENT.DEPARTMENT_ID=EP.DEPARTMENT_ID
						AND DEPARTMENT.DEPARTMENT_ID=EPCH.DEPARTMENT_ID
                        AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND 
                        HISTORY_ID < XXX.HISTORY_ID  AND
					 	E.EMPLOYEE_ID =  XXX.EMPLOYEE_ID
                        ORDER BY EP.HISTORY_ID	DESC
                ) AS YYY
              <!---   WHERE
                     XXX.BRANCH_ID <> YYY.BRANCH_ID
                     (
                     	
                     )--->
              ORDER BY 
              		CASE   WHEN XXX.POSITION_CAT_ID <>  YYY.POSITION_CAT_ID OR XXX.BRANCH_ID <>  YYY.BRANCH_ID OR XXX.DEPARTMENT_HEAD <>  YYY.DEPARTMENT_HEAD THEN 0 ELSE 1 END ASC
    </cfquery>
   
    <cfquery name="get_emp_in_out" dbtype="query">
    	SELECT * FROM get_emp_in_out WHERE BRANCH_ID1 <>  BRANCH_ID OR POSITION_CAT_ID1 <>  POSITION_CAT_ID OR DEPARTMENT_HEAD <>  DEPARTMENT_HEAD1
    </cfquery>
<cfelse>
	<cfset get_emp_in_out.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1> 
<cfparam name="attributes.totalrecords" default='#get_emp_in_out.recordcount#'> 
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1> 
<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
	<cfset attributes.startrow=1>
    <cfset attributes.maxrows_=get_emp_in_out.recordcount>
</cfif>
<cfquery datasource="#dsn#" name="fire_reasons">
	SELECT * FROM SETUP_EMPLOYEE_FIRE_REASONS WHERE IS_POSITION = 1 ORDER BY REASON
</cfquery>
<cfinclude template="../../hr/ehesap/query/get_all_departments.cfm">
<cfinclude template="../../hr/ehesap/query/get_conditional_dep.cfm">
<cfsavecontent variable="head"><cf_get_lang dictionary_id='39034.Görev Değişiklikleri Pozisyon'></cfsavecontent>
<cfform name="search_form" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
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
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38955.İlgili Şirket'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<div  class="multiselect-z2">
													<cf_multiselect_check 
													query_name="get_branches"  
													name="company_id"
													option_value="COMPANY_ID"
													option_name="RELATED_COMPANY"
													option_text="#getLang('main',322)#"
													value="#attributes.company_id#"
													onchange="get_branch_list(this.value)">
												</div>	
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38957.Şirket İçi Gerekçe'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<cf_multiselect_check 
												query_name="fire_reasons"  
												name="REASON_ID"
												option_name="REASON" 
												option_value="REASON_ID"
												data_source="#dsn#"
												value="#attributes.reason_id#">
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
											<div class="col col-12">
												<div id="BRANCH_PLACE" class="multiselect-z2">
													<cf_multiselect_check 
													query_name="DEPARTMENTS"  
													name="branch_id"
													option_value="BRANCH_ID"
													option_name="BRANCH_NAME"
													option_text="#getLang('main',322)#"
													value="#attributes.branch_id#"
													onchange="get_department_list(this.value)">
												</div>											
											</div>
										</div>
										<div class="form-group" id="DEPARTMENT_PLACE">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
											<div class="col col-12">
												<div class="multiselect-z2" id="DEPARTMENT_PLACE">
													<cf_multiselect_check 
													query_name="get_department"  
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
											<div class="col col-12 col-md-12 col-xs-12 paddingNone">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="58472.dönem"></label>
												<div class="col col-6 col-md-6">
													<select name="months" id="months">
														<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
														<cfoutput>
														<cfloop index="i" from="1" to="#ListLen(ay_listesi)#">
															<option value="#i#" <cfif attributes.months eq i>selected</cfif>>#ListGetAt(ay_listesi,i)#</option>
														</cfloop>
														</cfoutput>
													</select>
												</div>
												<div class="col col-6 col-md-6">
													<select name="years" id="years">
														<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
														<cfoutput>
														<cfloop index="i" from="#dateFormat(now(),'yyyy')#" to="2000" step="-1">
															<option value="#i#" <cfif attributes.years eq i>selected</cfif>>#i#</option>
														</cfloop>
														</cfoutput>
													</select>
												</div>	
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
											<div class="col col-12 col-xs-12">
												<cfif len(attributes.employee_name)>
													<cf_wrk_employee_in_out emp_id_value="#attributes.employee_id#" in_out_id_fieldname="in_out_id" in_out_value = "attributes.in_out_id" form_name="search_form">
												<cfelse>
													<cf_wrk_employee_in_out emp_id_value="" in_out_id_fieldname="in_out_id" in_out_value = "attributes.in_out_id" form_name="search_form">
												</cfif>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-6 col-xs-12">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></label>
											<div class="col col-12 col-xs-12">
												<div class="input-group">
													<cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" maxlength="10">
													<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
												</div>
											</div>
										</div>
											<div class="col col-6 col-xs-12">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></label>
													<div class="col col-12 col-xs-12">
														<div class="input-group">
															<cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, dateformat_style)#" validate="#validate_style#" maxlength="10">
															<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
														</div>
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
						    <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
							<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'></cfsavecontent>
							<cfinput type="text" name="maxrows" style="width:30px;" value="#ATTRIBUTES.MAXROWS#" range="1,250" message="#message#" disabled="disabled">
							<cfelse>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'></cfsavecontent>
								<cfinput type="text" name="maxrows" style="width:30px;" value="#ATTRIBUTES.MAXROWS#" range="1,250" message="#message#">
							</cfif>
							<cfinput type="hidden" name="is_submitted" id="is_submitted" value="1">
							<cf_wrk_report_search_button button_type='1' search_function='kontrol()' is_excel="1">
						</div>
					</div>
				</div>
			</div> 
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
		<cfset type_ = 1>
		<cfset filename = "#createuuid()#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-8">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<cfelse>
		<cfset type_ = 0>
</cfif>
<cfif isdefined("is_submitted")>
<cf_report_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='58487.Çalışan No'></th>
			<th><cf_get_lang dictionary_id='58025.TC Kimlik'></th>
			<th><cf_get_lang dictionary_id='57576.Çalışan'></th>
			<th><cf_get_lang dictionary_id='38959.Eski Şube'></th>
			<th><cf_get_lang dictionary_id='38960.Eski Departman'></th>
			<th><cf_get_lang dictionary_id='38961.Eski Görev'></th>
			<th><cf_get_lang dictionary_id='38962.Yeni Şube'></th>
			<th><cf_get_lang dictionary_id='38963.Yeni Departman'></th>
			<th><cf_get_lang dictionary_id='38964.Yeni Görev'></th>
			<th><cf_get_lang dictionary_id='38965.Değişim Tarihi'></th>
			<th><cf_get_lang dictionary_id='38957.Şirket İçi Gerekçe'></th>
			<cfif isDefined("x_show_level") and x_show_level eq 1><th><cf_get_lang dictionary_id='62040.Kademeli Departman'></th></cfif>
		</tr>
	</thead>
    <tbody>
		
			<cfif get_emp_in_out.recordcount>
				<cfif isdefined("attributes.maxrows_")>
					<cfset maxrows = attributes.maxrows_>
				<cfelse>
					<cfset maxrows = attributes.maxrows>
				</cfif>
				<cfoutput query="get_emp_in_out" startrow="#attributes.startrow#" maxrows="#maxrows#">
					<cfset bas_ = 0>
					<cfif (POSITION_CAT_ID1 neq POSITION_CAT_ID or DEPARTMENT_HEAD1 neq DEPARTMENT_HEAD or BRANCH_ID1 neq BRANCH_ID)>
						<cfset bas_ = 1>
					</cfif>
					<cfif bas_ eq 1>
						<tr>
							<td>#employee_no#</td>
							<td>#tc_identy_no#</td>
							<td>#employee_name# #employee_surname#</td>
							<td>#BRANCH_NAME1#</td>
							<td>#DEPARTMENT_HEAD1#</td>
							<td>#POSITION_CAT1#</td>
							<td>#BRANCH_NAME#</td>
							<td>#DEPARTMENT_HEAD#</td>
							<td>#POSITION_CAT#</td>
							<td>#dateformat(START_DATE,dateformat_style)#</td>
							<td>
								<cfif len(IN_COMPANY_REASON_ID)>
									<cfquery name="get_emp_reason" dbtype="query">
										SELECT REASON FROM fire_reasons WHERE REASON_ID = #IN_COMPANY_REASON_ID#
									</cfquery>
									#get_emp_reason.REASON#
								</cfif>
							</td>
							<cfif isDefined("x_show_level") and x_show_level eq 1>
								<td>                            
									<cfset up_dep_len = listlen(HIERARCHY_DEP_ID1,'.')>
									<cfif up_dep_len gt 0>
										<cfset temp = up_dep_len> 
										<cfloop from="1" to="#up_dep_len#" index="i" step="1">
											<cfif isdefined("HIERARCHY_DEP_ID1") and listlen(HIERARCHY_DEP_ID1,'.') gt temp>
												<cfset up_dep_id = ListGetAt(HIERARCHY_DEP_ID1, listlen(HIERARCHY_DEP_ID1,'.')-temp,".")>
												<cfquery name="get_upper_departments" datasource="#dsn#">
													SELECT DEPARTMENT_HEAD, LEVEL_NO FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#up_dep_id#">
												</cfquery>
												<cfset up_dep_head = get_upper_departments.department_head>
												#up_dep_head# 
													<cfset get_org_level = cmp_org_step.get_organization_step(level_no : get_upper_departments.LEVEL_NO)>
													<cfif get_org_level.recordcount>
														(#get_org_level.ORGANIZATION_STEP_NAME#)
													</cfif>
												<cfif up_dep_len neq i>
													>
												</cfif>
											<cfelse>
												<cfset up_dep_head = ''>
											</cfif>
											<cfset temp = temp - 1>
										</cfloop>
									</cfif>​
								</td>
							</cfif>
						</tr>
					</cfif>
				</cfoutput>
			<cfelse>
				<tr><td colspan="11"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td></tr>
			</cfif>
    </tbody>
</cf_report_list>
</cfif>
<cfset adres = "">
<cfif attributes.totalrecords gt attributes.maxrows and attributes.is_excel neq 1>
	<cfset adres = "report.report_transfer_work_position&is_submitted=#attributes.is_submitted#">	
	<cfif isdefined('attributes.related_company') and len(attributes.related_company)>
		<cfset adres = "#adres#&related_company=#attributes.related_company#">
	</cfif>
	<cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and isdefined('attributes.branch_name') and len(attributes.branch_name)>
		<cfset adres = "#adres#&branch_id=#attributes.branch_id#&branch_name=#attributes.branch_name#">
	</cfif>
	<cfif isdefined('attributes.department_id') and len(attributes.department_id) and isdefined('attributes.department_name') and len(attributes.department_name)>
		<cfset adres = "#adres#&department_id=#attributes.department_id#&branch_name=#attributes.branch_name#">
	</cfif>
	<cfif isdefined('attributes.reason_id') and len(attributes.reason_id)>
		<cfset adres = "#adres#&reason_id=#attributes.reason_id#">
	</cfif>
	<cfif isdefined('attributes.months') and len(attributes.months)>
		<cfset adres = "#adres#&months=#attributes.months#">
	</cfif>
	<cfif isdefined('attributes.years') and len(attributes.years)>
		<cfset adres = "#adres#&years=#attributes.years#">
	</cfif>
	<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
		<cfset adres = "#adres#&startdate=#Dateformat(attributes.startdate,dateformat_style)#">
	</cfif>
	<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
		<cfset adres = "#adres#&finishdate=#Dateformat(attributes.finishdate,dateformat_style)#">
	</cfif>
<!-- sil -->
		<cf_paging page="#attributes.page#" 
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="#adres#">
<!-- sil -->
</cfif> 

<script type="text/javascript">
function check_maxrow()
{
	if(document.getElementById('is_excel').checked == true)
		document.getElementById('maxrows').setAttribute('disabled','true');
	else
		document.getElementById('maxrows').removeAttribute('disabled');
}
function kontrol()
{  
	if(document.search_form.is_excel.checked==false)
		{
			document.search_form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			return true;
		}
		else
			document.search_form.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_report_transfer_work_position</cfoutput>"
}
function get_branch_list(gelen)
	{
		checkedValues_b = $("#company_id").multiselect("getChecked");
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
	<cfif not isdefined("attributes.branch_id") and GET_BRANCHES.recordcount>
		showDepartment(<cfoutput>#GET_BRANCHES.branch_id[1]#</cfoutput>);
	</cfif>

</script>

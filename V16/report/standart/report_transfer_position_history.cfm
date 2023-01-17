<!--- pozisyon detayında pozisyon değiştirildiginde gorev basl.bitis tarihi ile görev degisiklik kartina atilan kayitlarin raporlanması.
(görev degisikligi calisan kartinda gosterilen bilgilerdir:not:gorev degisikligi pronet icin yapildi.)
SG 20120725
--->
<cfparam name="attributes.module_id_control" default="3">
<cfinclude template="report_authority_control.cfm">
<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch_name" default="">
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.inout_statue" default="2">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfif len(attributes.startdate) and isdate(attributes.startdate) >
	<cf_date tarih="attributes.startdate">
<cfelse>
	<cfset attributes.startdate = "">
</cfif>
<cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
<cfelse>
	<cfset attributes.finishdate="">
</cfif>
<cfquery name="get_branches" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cfif isdefined("is_submitted")>
	<cfquery name="get_emp_change_position" datasource="#dsn#">
		WITH CTE1 AS (
		SELECT DISTINCT
			CASE WHEN ECH.EMPLOYEE_ID IS NULL THEN EPOS.POSITION_ID ELSE NULL END POSITION_ID,
			CASE WHEN ECH.EMPLOYEE_ID IS NOT NULL THEN ECH.ID ELSE NULL END ECH_POSITION_ID,
			E.EMPLOYEE_ID,
			E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS ADSOYAD,
			CASE WHEN ECH.EMPLOYEE_ID IS NULL THEN EPOS.POSITION_NAME ELSE ECH.POSITION_NAME END AS POSITION_NAME,
			CASE WHEN ECH.EMPLOYEE_ID IS NULL THEN NULL ELSE ECH.START_DATE END AS START_DATE,
			CASE WHEN ECH.EMPLOYEE_ID IS NULL THEN NULL ELSE ECH.FINISH_DATE END AS FINISH_DATE,
			CASE WHEN ECH.EMPLOYEE_ID IS NULL THEN EPOS.COLLAR_TYPE ELSE ECH.COLLAR_TYPE END AS COLLAR_TYPE,
			D.DEPARTMENT_HEAD,
			D2.DEPARTMENT_HEAD AS UPPER_DEPARTMENT_HEAD,
			D.DEPARTMENT_ID,
			B.BRANCH_NAME,
			OC.NICK_NAME,
			Z.ZONE_NAME,
			EI.TC_IDENTY_NO AS TC_NO,
			SPC.POSITION_CAT,
			ST.TITLE
			<cfif isdefined('attributes.is_func') and attributes.is_func eq 1>
				,SCV.UNIT_NAME
			</cfif>
			<cfif isdefined('attributes.is_reason') and attributes.is_reason eq 1>
				,EFR.REASON
			</cfif>
			<cfif isdefined('attributes.is_grade') and attributes.is_grade eq 1>
				,SOS.ORGANIZATION_STEP_NAME
			</cfif>
			<cfif isdefined('attributes.is_up_pos') and attributes.is_up_pos eq 1>
				,EP.EMPLOYEE_NAME+' '+EP.EMPLOYEE_SURNAME AS UPPOS
			</cfif>
			<cfif isdefined('attributes.is_up_pos') and attributes.is_up_pos eq 1>
				,EP2.EMPLOYEE_NAME+' '+EP2.EMPLOYEE_SURNAME AS UPPOS2
			</cfif>
			,E.EMPLOYEE_NO
		FROM
			EMPLOYEES E
			LEFT JOIN EMPLOYEE_POSITIONS_CHANGE_HISTORY ECH ON ECH.EMPLOYEE_ID = E.EMPLOYEE_ID
			LEFT JOIN EMPLOYEE_POSITIONS EPOS ON EPOS.EMPLOYEE_ID = E.EMPLOYEE_ID AND EPOS.IS_MASTER = 1
			LEFT JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID
			LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = (CASE WHEN ECH.EMPLOYEE_ID IS NULL THEN EPOS.DEPARTMENT_ID ELSE ECH.DEPARTMENT_ID END)
			LEFT JOIN DEPARTMENT as D2 ON D.HIERARCHY_DEP_ID  = CONCAT(D2.HIERARCHY_DEP_ID,'.',D.DEPARTMENT_ID)
			LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
			LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
			LEFT JOIN ZONE Z ON Z.ZONE_ID = B.ZONE_ID
			LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = (CASE WHEN ECH.EMPLOYEE_ID IS NULL THEN EPOS.POSITION_CAT_ID ELSE ECH.POSITION_CAT_ID END)
			LEFT JOIN SETUP_TITLE ST ON ST.TITLE_ID = (CASE WHEN ECH.EMPLOYEE_ID IS NULL THEN EPOS.TITLE_ID ELSE ECH.TITLE_ID END)
			<cfif isdefined('attributes.is_func') and attributes.is_func eq 1>
			LEFT JOIN SETUP_CV_UNIT SCV ON SCV.UNIT_ID = (CASE WHEN ECH.EMPLOYEE_ID IS NULL THEN EPOS.FUNC_ID ELSE ECH.FUNC_ID END)
			</cfif>
			<cfif isdefined('attributes.is_reason') and attributes.is_reason eq 1>
				LEFT JOIN SETUP_EMPLOYEE_FIRE_REASONS EFR ON EFR.REASON_ID = ECH.REASON_ID
			</cfif>
			<cfif isdefined('attributes.is_grade') and attributes.is_grade eq 1>
				LEFT JOIN SETUP_ORGANIZATION_STEPS SOS ON SOS.ORGANIZATION_STEP_ID = (CASE WHEN ECH.ORGANIZATION_STEP_ID IS NULL THEN EPOS.ORGANIZATION_STEP_ID ELSE ECH.ORGANIZATION_STEP_ID END)
			</cfif>
			<cfif isdefined('attributes.is_up_pos') and attributes.is_up_pos eq 1>
				LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = (CASE WHEN ECH.EMPLOYEE_ID IS NULL THEN EPOS.UPPER_POSITION_CODE ELSE ECH.UPPER_POSITION_CODE END)
			</cfif>
			<cfif isdefined('attributes.is_up_pos') and attributes.is_up_pos eq 1>
				LEFT JOIN EMPLOYEE_POSITIONS EP2 ON EP2.POSITION_CODE = (CASE WHEN ECH.EMPLOYEE_ID IS NULL THEN EPOS.UPPER_POSITION_CODE2 ELSE ECH.UPPER_POSITION_CODE2 END)
			</cfif>
		WHERE 
			E.EMPLOYEE_ID IS NOT NULL
			AND ((ECH.EMPLOYEE_ID IS NOT NULL
				<cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>AND
            	<cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
                	(
                    	(
                        	ECH.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                           	ECH.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
                       	)
                      	OR
                       	(
                    		ECH.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                          	ECH.FINISH_DATE IS NULL
                       	)
                  	)
               	<cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
                  	(
                      	(
                         	ECH.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
                           	ECH.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                      	)
                       	OR
                      	(
                         	ECH.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
                          	ECH.FINISH_DATE IS NULL
                      	)
                  	)
              	<cfelse>
                  	(
                     	(
                         	ECH.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                         	ECH.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                       	)
                       	OR
                       	(
                          	ECH.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                          	ECH.FINISH_DATE IS NULL
                       	)
                       	OR
                       	(
                          	ECH.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                          	ECH.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                       	)
                      	OR
                      	(
                          	ECH.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                          	ECH.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                     	)
               		)
             	</cfif>
         	</cfif>) OR (ECH.EMPLOYEE_ID IS NULL AND EPOS.EMPLOYEE_ID IS NOT NULL AND EPOS.IS_MASTER = 1)
			)
			<cfif len(attributes.keyword)>
            	AND ((E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) LIKE '%#attributes.keyword#%')
        	</cfif>
        	<cfif len(attributes.branch_id)>
        		AND B.BRANCH_ID IN (#attributes.branch_id#)
        	</cfif>
        	<cfif len(attributes.comp_id)>
        		AND B.COMPANY_ID IN (#attributes.comp_id#)
        	</cfif>
			<cfif not session.ep.ehesap>
				AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
				AND B.COMPANY_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
        	<cfif len(attributes.department)>
        		AND D.DEPARTMENT_ID IN (#attributes.department#)
        	</cfif>
			<cfif isdefined('attributes.inout_statue')>AND ((
				<cfif attributes.inout_statue eq 1><!--- Girişler --->
               		E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EMPIO WHERE 1=1
                   	<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                    	AND EMPIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
                	</cfif>
                    <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                    	AND EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                    </cfif> )
        		<cfelseif attributes.inout_statue eq 0><!--- Çıkışlar --->
                	E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EMPIO WHERE EMPIO.FINISH_DATE IS NOT NULL
                    <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                    	AND EMPIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
                   	</cfif>
                    <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                    	AND EMPIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                 	</cfif> )
           		<cfelseif attributes.inout_statue eq 2><!--- aktif calisanlar --->
                	E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EMPIO WHERE
                    (
                    	<cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
                        	<cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
                            (
                            	(
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                                    EMPIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
                             	)
                            	OR
                         		(
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                                    EMPIO.FINISH_DATE IS NULL
                             	)
                        	)
                    		<cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
                            (
                            	(
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
                                    EMPIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                              	)
                                    OR
                            	(
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
                                    EMPIO.FINISH_DATE IS NULL
                             	)
                         	)
                       		<cfelse>
                           	(
                             	(
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                                    EMPIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                              	)
                              	OR
                            	(
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                                    EMPIO.FINISH_DATE IS NULL
                             	)
                             	OR
                           		(
                                    EMPIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                              	)
                              	OR
                             	(
                                    EMPIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                                    EMPIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                              	)
                        	)
                          	</cfif>
                     	<cfelse>
                       		EMPIO.FINISH_DATE IS NULL
                     	</cfif>
                 	) )
            	<cfelse><!--- giriş ve çıkışlar Seçili ise --->
               		E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EMPIO WHERE
                 	(
                    	(
                         	EMPIO.START_DATE IS NOT NULL
                          	<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                            	AND EMPIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
                           	</cfif>
                         	<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                              	AND EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                           	</cfif>
                    	)
                     	OR
                    	(
                        	EMPIO.START_DATE IS NOT NULL
                         	<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                             	AND EMPIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
                          	</cfif>
                          	<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                             	AND EMPIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                          	</cfif>
                      	)
                	))
            	</cfif>
        	))
        	</cfif>
        ),
            CTE2 AS (
            	SELECT
                	CTE1.*,
                    	ROW_NUMBER() OVER (	ORDER BY
                        	ADSOYAD
                      	) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
               	FROM
                	CTE1
           		)
                SELECT
                    CTE2.*
               	FROM
                	CTE2
              	<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                    WHERE
                        RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
              	</cfif>
	</cfquery>
<cfelse>
	<cfset get_emp_change_position.recordcount = 0>
	<cfset get_emp_change_position.query_count = 0>
</cfif>
<cfquery name="get_company_name" datasource="#dsn#">
	SELECT 
		NICK_NAME,
		COMP_ID,
		COMPANY_NAME 
	FROM 
		OUR_COMPANY 
	<cfif not session.ep.ehesap>
	WHERE 
		COMP_ID IN 
		(SELECT 
			O.COMP_ID
		FROM 
			BRANCH B,OUR_COMPANY O 
		WHERE 
			B.COMPANY_ID = O.COMP_ID AND
			B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
		)
	</cfif>
</cfquery>
<cfquery name="get_branches" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME
	FROM 
		BRANCH
	<cfif not session.ep.ehesap>
	WHERE
		BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	</cfif>
	ORDER BY
		BRANCH_NAME
</cfquery>
<cfquery name="get_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>AND BRANCH_ID IN (#attributes.branch_id#)</cfif> ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfparam name="attributes.totalrecords" default='#get_emp_change_position.query_count#'>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='39149.Görev Değişiklikleri'></cfsavecontent>
<cfform name="search_form" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
	<cf_report_list_search title="#head#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-12">
								<div class="col col-12 col-xs-12">
									<div class="col col-12 col-xs-12">
										<div class="form-group">
											<div class="col col-12">
												<label class="col col-12 col-md-12"><cf_get_lang dictionary_id="57460.Filtre"></label>
												<div class="col col-12 col-md-12">
													<input type="text" id="keyword" name="keyword" <cfoutput>value="#attributes.keyword#"</cfoutput>>
												</div>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='50669.Kriter'></label>
												<div class="col col-12">
													<select name="inout_statue" id="inout_statue">
														<option value=""><cf_get_lang dictionary_id='55904.Giriş ve Çıkışlar'></option>
														<option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang dictionary_id='58535.Girişler'></option>
														<option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang dictionary_id='58536.Çıkışlar'></option>
														<option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang dictionary_id='55905.Aktif Çalışanlar'></option>
													</select>
												</div>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='50669.Kriter'><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
												<div class="col col-6 col-md-6">
													<div class="input-group">
														<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
														<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
															<cfinput type="text" name="startdate" id="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#"  value="#dateformat(attributes.startdate,dateformat_style)#">
														<cfelse>
															<cfinput type="text" name="startdate" id="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" >
														</cfif>
														<span class="input-group-addon">
															<cf_wrk_date_image date_field="startdate">
														</span>
													</div>
												</div>
												<div class="col col-6 col-md-6">
													<div class="input-group">
														<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
														<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
															<cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
														<cfelse>
															<cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" >
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
							<div class="col col-4 col-md-12">
								<div class="col col-12 col-md-12">
									<div class="col col-12 col-xs-12">
										<div class="form-group">
											<div class="col col-12">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
												<div class="col col-12">
													<div class="multiselect-z2">
														<cf_multiselect_check 
														query_name="get_company_name"  
														name="comp_id"
														width="140" 
														option_value="COMP_ID"
														option_name="COMPANY_NAME"
														option_text="#getLang('main',322)#"
														value="#attributes.comp_id#"
														onchange="get_branch_list(this.value)">
													</div>
												</div>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
												<div class="col col-12">
													<div id="BRANCH_PLACE" class="multiselect-z2">
														<cf_multiselect_check 
														query_name="get_branches"  
														name="branch_id"
														width="140" 
														option_value="BRANCH_ID"
														option_name="BRANCH_NAME"
														option_text="#getLang('main',322)#"
														value="#attributes.branch_id#"
														onchange="get_department_list(this.value)">
													</div>
												</div>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
												<div class="col col-12">
													<div class="multiselect-z2" id="DEPARTMENT_PLACE">
														<cf_multiselect_check 
														query_name="get_department"  
														name="department"
														width="140" 
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
							</div>
							<div class="col col-4 col-md-12">
								<div class="col col-12 col-md-12">
									<div class="col col-12 col-xs-12">
											<div class="form-group">
												<label><input type="checkbox" name="is_func" id="is_func" value="1" <cfif isdefined('attributes.is_func') and attributes.is_func eq 1>checked</cfif>><cf_get_lang dictionary_id='58701.Fonksiyon'></label>
											</div>
											<div class="form-group">
												<label><input type="checkbox" name="is_reason" id="is_reason" value="1" <cfif isdefined('attributes.is_reason') and attributes.is_reason eq 1>checked</cfif>><cf_get_lang dictionary_id='39081.Gerekçe'></label>
											</div>
											<div class="form-group">
												<label><input type="checkbox" name="is_collar_type" id="is_collar_type" value="1" <cfif isdefined('attributes.is_collar_type') and attributes.is_collar_type eq 1>checked</cfif>><cf_get_lang dictionary_id='38908.Yaka Tipi'></label>
											</div>
											<div class="form-group">
												<label><input type="checkbox" name="is_grade" id="is_grade" value="1" <cfif isdefined('attributes.is_grade') and attributes.is_grade eq 1>checked</cfif>><cf_get_lang dictionary_id='58710.Kademe'></label>
											</div>
											<div class="form-group">
												<label><input type="checkbox" name="is_up_pos" id="is_up_pos" value="1" <cfif isdefined('attributes.is_up_pos') and attributes.is_up_pos eq 1>checked</cfif>><cf_get_lang dictionary_id='38934.Birinci Amir'></label>
											</div>
											<div class="form-group">
												<label><input type="checkbox" name="is_up_pos2" id="is_up_pos2" value="1" <cfif isdefined('attributes.is_up_pos2') and attributes.is_up_pos2 eq 1>checked</cfif>><cf_get_lang dictionary_id='38936.İkinci Amir'></label>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
							<input type="hidden" name="is_submitted" id="is_submitted" value="1">
							<cf_wrk_report_search_button button_type='1' search_function='control()'>
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
<cfif isdefined("attributes.is_submitted")>
	<cf_report_list>
		<thead>
			<tr height="22">
				<th><cf_get_lang dictionary_id='58577.Sıra'></th>
				<th><cf_get_lang dictionary_id='32328.Sicil No'></th>
				<th><cf_get_lang dictionary_id='58025.Tc kimlik no'></th>
				<th><cf_get_lang dictionary_id='57570.Ad soyad'></th>
				<th><cf_get_lang dictionary_id='57574.Şirket'></th>
				<th><cf_get_lang dictionary_id='57992.Bölge'></th>
				<th><cf_get_lang dictionary_id='57453.Şube'></th>
				<th><cf_get_lang dictionary_id='39710.Üst Departman'></th>
				<th><cf_get_lang dictionary_id='57572.Departman'></th>
				<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
				<th><cf_get_lang dictionary_id='59004.Pozisyon tipi'></th>
				<th><cf_get_lang dictionary_id='57571.Ünvan'></th>
				<cfif isdefined('attributes.is_func') and attributes.is_func eq 1>
					<th><cf_get_lang dictionary_id='58701.Fonksion'></th>
				</cfif>
				<cfif isdefined('attributes.is_collar_type') and attributes.is_collar_type eq 1>
					<th><cf_get_lang dictionary_id='38908.Yaka Tipi'></th>
				</cfif>
				<cfif isdefined('attributes.is_grade') and attributes.is_grade eq 1>
					<th><cf_get_lang dictionary_id='58710.Kademe'></th>
				</cfif>
				<cfif isdefined('attributes.is_up_pos') and attributes.is_up_pos eq 1>
					<th><cf_get_lang dictionary_id='38934.Birinci Amir'></th>
				</cfif>
				<cfif isdefined('attributes.is_up_pos2') and attributes.is_up_pos2 eq 1>
					<th><cf_get_lang dictionary_id='38936.İkinci Amir'></th>
				</cfif>
				<cfif isdefined('attributes.is_reason') and attributes.is_reason eq 1>
					<th><cf_get_lang dictionary_id='39081.Gerekçe'></th>
				</cfif>
				<th><cf_get_lang dictionary_id='58467.Başlama'></th>
				<th><cf_get_lang dictionary_id='57502.Bitiş'></th>
				<th><cf_get_lang dictionary_id='65028.Son Pozisyon'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_emp_change_position.recordcount>
				<cfoutput query="get_emp_change_position">
					<tr height="22">
						<td>#rownum#</td>
						<td>#employee_no#</td>
						<td>#tc_no#</td>
						<td>#adsoyad#</td>
						<td>#nick_name#</td>
						<td>#zone_name#</td>
						<td>#branch_name#</td>
						<td>#upper_department_head#</td>
						<td>#department_head#</td>
						<td>#position_name#</td>
						<td>#position_cat#</td>
						<td>#title#</td>
						<cfif isdefined('attributes.is_func') and attributes.is_func eq 1>
							<td>#unit_name#</td>
						</cfif>
						<cfif isdefined('attributes.is_collar_type') and attributes.is_collar_type eq 1>
							<td><cfif collar_type eq 1><cf_get_lang dictionary_id='38910.Mavi Yaka'><cfelseif collar_type eq 2><cf_get_lang dictionary_id='38911.Beyaz Yaka'></cfif></td>
						</cfif>
						<cfif isdefined('attributes.is_grade') and attributes.is_grade eq 1>
							<td>#organization_step_name#</td>
						</cfif>
						<cfif isdefined('attributes.is_up_pos') and attributes.is_up_pos eq 1>
							<td>#uppos#</td>
						</cfif>
						<cfif isdefined('attributes.is_up_pos2') and attributes.is_up_pos2 eq 1>
							<td>#uppos2#</td>
						</cfif>
						<cfif isdefined('attributes.is_reason') and attributes.is_reason eq 1>
							<td>#reason#</td>
						</cfif>
						<td><cfif len(start_date)>#dateformat(start_date,dateformat_style)#</cfif></td>
						<td><cfif len(finish_date)>#dateformat(finish_date,dateformat_style)#</cfif></td>
						<td>
							<cfquery name="get_last_position" datasource="#dsn#">
								SELECT
									TOP 1
									POSITION_NAME
								FROM 
									EMPLOYEE_POSITIONS_HISTORY
								WHERE
									EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EMPLOYEE_ID#">
									AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#">
									<cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
									AND
									(
										(
											START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
											FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
										)
										OR
										(
											START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
											FINISH_DATE IS NULL
										)
									)
								<cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
								AND
									(
										(
											START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
											FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
										)
										OR
										(
											START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
											FINISH_DATE IS NULL
										)
									)
								</cfif>
								ORDER BY 
									START_DATE DESC
							</cfquery>
							<cfif get_last_position.recordcount>#get_last_position.position_name#</cfif>
						</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr height="22">
					<td colspan="18"><cfif not isdefined("is_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'><cfelse><cf_get_lang dictionary_id='57484.kayıt yok'></cfif>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_report_list>
	<cfset adres = "">
	<cfif isdefined("attributes.is_submitted") and attributes.totalrecords gt attributes.maxrows>
	<cfset adres = "report.report_transfer_position_history&is_submitted=1">
	<cfif len(attributes.keyword)>
		<cfset adres = "#adres#&keyword=#attributes.keyword#">
	</cfif>
	<cfif len(attributes.inout_statue)>
		<cfset adres = "#adres#&inout_statue=#attributes.inout_statue#">
	</cfif>
	<cfif len(attributes.startdate) and isdate(attributes.startdate)>
		<cfset adres = "#adres#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
	</cfif>
	<cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
		<cfset adres = "#adres#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
	</cfif>
	<cfif len(attributes.comp_id)>
		<cfset adres = "#adres#&comp_id=#attributes.comp_id#">
	</cfif>
	<cfif len(attributes.branch_id)>
		<cfset adres = "#adres#&branch_id=#attributes.branch_id#">
	</cfif>
	<cfif len(attributes.department)>
		<cfset adres = "#adres#&department=#attributes.department#">
	</cfif>
	<cfif isdefined('attributes.is_func') and len(attributes.is_func)>
		<cfset adres = "#adres#&is_func=#attributes.is_func#">
	</cfif>
	<cfif isdefined('attributes.is_reason') and len(attributes.is_reason)>
		<cfset adres = "#adres#&is_reason=#attributes.is_reason#">
	</cfif>
	<cfif isdefined('attributes.is_collar_type') and len(attributes.is_collar_type)>
		<cfset adres = "#adres#&is_collar_type=#attributes.is_collar_type#">
	</cfif>
	<cfif isdefined('attributes.is_grade') and len(attributes.is_grade)>
		<cfset adres = "#adres#&is_grade=#attributes.is_grade#">
	</cfif>
	<cfif isdefined('attributes.is_up_pos') and len(attributes.is_up_pos)>
		<cfset adres = "#adres#&is_up_pos=#attributes.is_up_pos#">
	</cfif>
	<cfif isdefined('attributes.is_up_pos2') and len(attributes.is_up_pos2)>
		<cfset adres = "#adres#&is_up_pos2=#attributes.is_up_pos2#">
	</cfif>
	<cf_paging page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="#adres#">
	</cfif>
</cfif>
<script type="text/javascript">
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
	function control()	
	{
		   if(!date_check(search_form.startdate,search_form.finishdate,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
					return false;
				}
			if(document.search_form.is_excel.checked==false)
				{
					document.search_form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
					return true;
				}
				else
					document.search_form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_report_transfer_position_history</cfoutput>"
    }
</script>

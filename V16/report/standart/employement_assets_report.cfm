<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.asset_cat" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.unit_id" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.startassetdate" default="">
<cfparam name="attributes.finishassetdate" default="">
<cfparam name="attributes.startassetfndate" default="">
<cfparam name="attributes.finishassetfndate" default="">
<cfparam name="attributes.inout_statue" default="2">
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.asset_statue" default="1">
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
<cfif len(attributes.startassetdate) and isdate(attributes.startassetdate) >
	<cf_date tarih="attributes.startassetdate">
<cfelse>
	<cfset attributes.startassetdate = "">
</cfif>
<cfif len(attributes.finishassetdate) and isdate(attributes.finishassetdate)>
	<cf_date tarih="attributes.finishassetdate">
<cfelse>
	<cfset attributes.finishassetdate="">
</cfif>
<cfif len(attributes.startassetfndate) and isdate(attributes.startassetfndate) >
	<cf_date tarih="attributes.startassetfndate">
<cfelse>
	<cfset attributes.startassetfndate = "">
</cfif>
<cfif len(attributes.finishassetfndate) and isdate(attributes.finishassetfndate)>
	<cf_date tarih="attributes.finishassetfndate">
<cfelse>
	<cfset attributes.finishassetfndate="">
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfif isdefined("is_submitted")>
    <cfquery name="get_assets" datasource="#dsn#">
		WITH CTE1 AS ((SELECT 
			DISTINCT
			AC.ASSET_CAT,
			EER.ASSET_DATE,
			EER.ASSET_FINISH_DATE,
			EER.ASSET_NO,
			EER.ASSET_NAME,
			EER.ASSET_FILE,
			E.EMPLOYEE_ID,
			E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS NAMESURNAME,
			E.EMPLOYEE_NO,
			EP.POSITION_NAME,
			SPC.POSITION_CAT,
			D.DEPARTMENT_HEAD,
			B.BRANCH_NAME,
			OC.COMPANY_NAME,
			CU.UNIT_NAME
		FROM 
			SETUP_EMPLOYMENT_ASSET_CAT AC CROSS JOIN 
			EMPLOYEES E LEFT JOIN EMPLOYEE_EMPLOYMENT_ROWS EER ON EER.EMPLOYEE_ID = E.EMPLOYEE_ID AND EER.ASSET_CAT_ID = AC.ASSET_CAT_ID
			LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
			LEFT JOIN EMPLOYEES_IN_OUT EIO ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
			LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
			LEFT JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID
			LEFT JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
			LEFT JOIN SETUP_CV_UNIT CU ON CU.UNIT_ID = EP.FUNC_ID
			LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
		WHERE
			E.EMPLOYEE_ID IS NOT NULL
			AND EP.IS_MASTER = 1
			<cfif len(attributes.keyword)>
				AND ((E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) LIKE '%#attributes.keyword#%')
			</cfif>
			<cfif len(attributes.asset_cat)>
				AND AC.ASSET_CAT_ID IN(#attributes.asset_cat#) 
			</cfif>
			<cfif len(attributes.asset_statue)>
			<cfif attributes.asset_statue eq 1>
				AND EER.ASSET_FILE IS NOT NULL
			<cfelseif attributes.asset_statue eq 2>
				AND EER.ASSET_FILE IS NULL
			</cfif>
			</cfif>
			<cfif len(attributes.comp_id)>
				AND OC.COMP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">)
			</cfif>
			<cfif len(attributes.branch_id)>
				AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
			</cfif>
			<cfif len(attributes.department)>
				AND D.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#" list = "yes">)
			</cfif>
			<cfif len(attributes.position_cat_id)>
				AND SPC.POSITION_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#" list = "yes">)
			</cfif>
			<cfif len(attributes.unit_id)>
				AND CU.UNIT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#" list = "yes">)
			</cfif>
			<cfif isdefined('attributes.startassetdate') and isdate(attributes.startassetdate)>
				AND ASSET_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startassetdate#">
			</cfif>
			<cfif isdefined('attributes.finishassetdate') and isdate(attributes.finishassetdate)>
				AND ASSET_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishassetdate#">
			</cfif>
			<cfif isdefined('attributes.startassetfndate') and isdate(attributes.startassetfndate)>
				AND ASSET_FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startassetfndate#">
			</cfif>
			<cfif isdefined('attributes.finishassetfndate') and isdate(attributes.finishassetfndate)>
				AND ASSET_FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishassetfndate#">
			</cfif>
			<cfif not session.ep.ehesap>
				AND EIO.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# )
			</cfif>
			<cfif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 1><!--- Girişler --->
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                    AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                </cfif>
                <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                    AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                </cfif>
			<cfelseif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 0><!--- Çıkışlar --->
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                    AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                </cfif>
                <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                    AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                </cfif>
                AND	EIO.FINISH_DATE IS NOT NULL
			<cfelseif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 2><!--- aktif calisanlar --->
				AND E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE
                (
                    <cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
                        <cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
                        (
                            (
                            EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                            EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                            )
                            OR
                            (
                            EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                            EIO.FINISH_DATE IS NULL
                            )
                        )
                        <cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
                        (
                            (
                            EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
                            EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                            )
                            OR
                            (
                           	EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
                            EIO.FINISH_DATE IS NULL
                            )
                        )
                        <cfelse>
                        (
                            (
                            EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                            EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                            )
                            OR
                            (
                            EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                            EIO.FINISH_DATE IS NULL
                            )
                            OR
                            (
                            EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                            EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                            )
                            OR
                            (
                            EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                            EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                            )
                        )
                        </cfif>
                    <cfelse>
                        EIO.FINISH_DATE IS NULL
                    </cfif>
                ) )
			<cfelse><!--- giriş ve çıkışlar Seçili ise --->
				AND 
				(
					(
						EIO.START_DATE IS NOT NULL
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
						</cfif>
					)
					OR
					(
						EIO.START_DATE IS NOT NULL
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
						</cfif>
					)
				)
			</cfif>
        <cfif not len(attributes.comp_id) and not len(attributes.branch_id) and not len(attributes.department) and not len(attributes.position_cat_id)>
        UNION ALL
        SELECT 
			DISTINCT
			AC.ASSET_CAT,
			EER.ASSET_DATE,
			EER.ASSET_FINISH_DATE,
			EER.ASSET_NO,
			EER.ASSET_NAME,
			EER.ASSET_FILE,
			E.EMPLOYEE_ID,
			E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS NAMESURNAME,
			E.EMPLOYEE_NO,
			'' AS POSITION_NAME,
			'' AS POSITION_CAT,
			'' AS DEPARTMENT_HEAD,
			'' AS BRANCH_NAME,
			'' AS COMPANY_NAME,
			'' AS UNIT_NAME
		FROM 
			SETUP_EMPLOYMENT_ASSET_CAT AC CROSS JOIN 
			EMPLOYEES E LEFT JOIN EMPLOYEE_EMPLOYMENT_ROWS EER ON EER.EMPLOYEE_ID = E.EMPLOYEE_ID AND EER.ASSET_CAT_ID = AC.ASSET_CAT_ID
			LEFT JOIN EMPLOYEES_IN_OUT EIO ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
		WHERE
			E.EMPLOYEE_ID IS NOT NULL
            AND E.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID IS NOT NULL)
			<cfif len(attributes.keyword)>
				AND ((E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) LIKE '%#attributes.keyword#%')
			</cfif>
			<cfif len(attributes.asset_cat)>
				AND AC.ASSET_CAT_ID IN(#attributes.asset_cat#) 
			</cfif>
			<cfif len(attributes.asset_statue)>
			<cfif attributes.asset_statue eq 1>
				AND EER.ASSET_FILE IS NOT NULL
			<cfelseif attributes.asset_statue eq 2>
				AND EER.ASSET_FILE IS NULL
			</cfif>
			</cfif>
			<cfif isdefined('attributes.startassetdate') and isdate(attributes.startassetdate)>
				AND ASSET_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startassetdate#">
			</cfif>
			<cfif isdefined('attributes.finishassetdate') and isdate(attributes.finishassetdate)>
				AND ASSET_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishassetdate#">
			</cfif>
			<cfif isdefined('attributes.startassetfndate') and isdate(attributes.startassetfndate)>
				AND ASSET_FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startassetfndate#">
			</cfif>
			<cfif isdefined('attributes.finishassetfndate') and isdate(attributes.finishassetfndate)>
				AND ASSET_FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishassetfndate#">
			</cfif>
			<cfif not session.ep.ehesap>
				AND EIO.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# )
			</cfif>
			<cfif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 1><!--- Girişler --->
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                    AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                </cfif>
                <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                    AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                </cfif>
			<cfelseif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 0><!--- Çıkışlar --->
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                    AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                </cfif>
                <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                    AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                </cfif>
                AND	EIO.FINISH_DATE IS NOT NULL
			<cfelseif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 2><!--- aktif calisanlar --->
				AND E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE
                (
                    <cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
                        <cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
                        (
                            (
                            EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                            EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                            )
                            OR
                            (
                            EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                            EIO.FINISH_DATE IS NULL
                            )
                        )
                        <cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
                        (
                            (
                            EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
                            EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                            )
                            OR
                            (
                           	EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
                            EIO.FINISH_DATE IS NULL
                            )
                        )
                        <cfelse>
                        (
                            (
                            EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                            EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                            )
                            OR
                            (
                            EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                            EIO.FINISH_DATE IS NULL
                            )
                            OR
                            (
                            EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                            EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                            )
                            OR
                            (
                            EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                            EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                            )
                        )
                        </cfif>
                    <cfelse>
                        EIO.FINISH_DATE IS NULL
                    </cfif>
                ) )
			<cfelse><!--- giriş ve çıkışlar Seçili ise --->
				AND 
				(
					(
						EIO.START_DATE IS NOT NULL
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
						</cfif>
					)
					OR
					(
						EIO.START_DATE IS NOT NULL
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
						</cfif>
					)
				)
			</cfif>
            </cfif>
            )),
				
				CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (  
				ORDER BY 
				NAMESURNAME 
			) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 0>
				WHERE RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
		    </cfif>
    </cfquery>
	<cfif get_assets.recordcount>
		<cfparam name="attributes.totalrecords" default="#get_assets.query_count#">
	<cfelse>
		<cfparam name="attributes.totalrecords" default="0">
	</cfif>
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cfquery name="get_asset_cats" datasource="#dsn#">
	SELECT ASSET_CAT_ID,ASSET_CAT FROM SETUP_EMPLOYMENT_ASSET_CAT ORDER BY ASSET_CAT 
</cfquery>
<cfquery name="get_company" datasource="#dsn#">
	SELECT 
		COMP_ID,
		NICK_NAME 
	FROM 
		OUR_COMPANY  	
	WHERE 
		<cfif not session.ep.ehesap>
			COMP_ID IN (SELECT B.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EP, BRANCH B WHERE EP.BRANCH_ID = B.BRANCH_ID AND POSITION_CODE = #session.ep.position_code#) 
		<cfelse>
			1=1
		</cfif>  
	ORDER BY NICK_NAME
</cfquery>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME 
	FROM 
		BRANCH 
	WHERE  		
		<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
			COMPANY_ID IN(#attributes.comp_id#)
		<cfelse>
			1=0
		</cfif>
		<cfif not session.ep.ehesap>
			AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)  
		</cfif>	
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfquery name="get_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>BRANCH_ID IN(#attributes.branch_id#)<cfelse>1=0</cfif> AND DEPARTMENT_STATUS = 1 ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfquery name="get_position_cats" datasource="#dsn#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<cfquery name="get_units" datasource="#dsn#">
	SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT ORDER BY UNIT_NAME 
</cfquery>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='55312.Özlük Belgeleri'></cfsavecontent>
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
											<div class="col col-12 col-md-12 col-xs-12">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57460.Filtre"></label>
												<div class="col col-12 col-md-12 col-xs-12 paddingNone">
													<cfinput type="Text" maxlength="255" value="#attributes.keyword#" name="keyword" id="keyword">
												</div>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12 col-md-12 col-xs-12">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="58578.Belge Türü"></label>
												<div style="position:relative; z-index:1;">
													<cf_multiselect_check
													name="asset_cat"
													query_name="get_asset_cats"
													option_text="#getLang('main',322)#"
													option_value="ASSET_CAT_ID"
													option_name="ASSET_CAT"
													value="#iif(isdefined("attributes.asset_cat"),"attributes.asset_cat",DE(""))#">
												</div>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12 col-md-12 col-xs-12">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'><cf_get_lang dictionary_id='30111.Durumu'>(<cf_get_lang dictionary_id='30055.Olanlar'> /<cf_get_lang dictionary_id='30056.Olmayanlar'>)</label>
												<select name="asset_statue" id="asset_statue">
													<option value="1" <cfif isdefined("attributes.asset_statue") and attributes.asset_statue eq 1>selected</cfif>><cf_get_lang dictionary_id='60708.Belgesi Olanlar'></option>
													<option value="2" <cfif isdefined("attributes.asset_statue") and attributes.asset_statue eq 2>selected</cfif>><cf_get_lang dictionary_id='60709.Belgesi Olmayanlar'></option>
												</select>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12 col-md-12 col-xs-12">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58701.Fonksiyon'></label>
												<div class="col col-12 col-md-12 col-xs-12">
													<div class="multiselect-z1">
														<cf_multiselect_check 
														query_name="get_units"  
														name="unit_id"
														option_value="UNIT_ID"
														option_name="UNIT_NAME"
														option_text="#getLang('main',322)#"
														value="#attributes.unit_id#">
													</div>
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
											<div class="col col-12 col-md-12 col-xs-12">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='50669.Kriter'></label>
												<select name="inout_statue" id="inout_statue">
													<option value=""><cf_get_lang dictionary_id='55904.Giriş ve Çıkışlar'></option>
													<option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang dictionary_id='58535.Girişler'></option>
													<option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang dictionary_id='58536.Çıkışlar'></option>
													<option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang dictionary_id='55905.Aktif Çalışanlar'></option>
												</select>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='50669.Kriter'><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
											</div>
											<div class="col col-6 col-md-6">
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
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
													<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
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
										<div class="form-group">
											<div class="col col-12 col-md-12 col-xs-12">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
												<div class="col col-12 col-md-12 col-xs-12">
													<div class="multiselect-z2">
														<cf_multiselect_check 
														query_name="get_company"  
														name="comp_id"
														option_value="COMP_ID"
														option_name="NICK_NAME"
														option_text="#getLang('main',322)#"
														value="#attributes.comp_id#"
														onchange="get_branch_list(this.value)">
													</div>
												</div>												
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12 col-md-12 col-xs-12">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
												<div id="BRANCH_PLACE" class="multiselect-z2">
													<cf_multiselect_check 
													query_name="get_branchs"  
													name="branch_id"
													option_value="BRANCH_ID"
													option_name="BRANCH_NAME"
													option_text="#getLang('main',322)#"
													value="#attributes.branch_id#"
													onchange="get_department_list(this.value)">
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
											<div class="col col-12 col-md-12">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
											</div>
											<div id="DEPARTMENT_PLACE">
												<div class="col col-12 col-md-12 col-xs-12">
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
										<div class="form-group">
											<div class="col col-12 col-md-12 col-xs-12">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
												<div class="multiselect-z1">
													<cf_multiselect_check 
													query_name="get_position_cats"  
													name="position_cat_id"
													option_value="POSITION_CAT_ID"
													option_name="POSITION_CAT"
													option_text="#getLang('main',322)#"
													value="#attributes.position_cat_id#">
												</div>										
											</div>
										</div>
										<div class="form-group">
												<div class="col col-12 col-md-12">
													<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='48856.Veriliş'><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
												</div>
												<div class="col col-6 col-md-6">
													<div class="input-group">
														<cfif isdefined("attributes.startassetdate") and isdate(attributes.startassetdate)>
															<cfinput type="text" name="startassetdate" id="startassetdate" maxlength="10" validate="#validate_style#" message="#alert#" value="#dateformat(attributes.startassetdate,dateformat_style)#">
														<cfelse>
															<cfinput type="text" name="startassetdate" id="startassetdate" maxlength="10" validate="#validate_style#" message="#alert#" >
														</cfif>
														<span class="input-group-addon">
															<cf_wrk_date_image date_field="startassetdate">
														</span>
													</div>
												</div>
												<div class="col col-6 col-md-6">
													<div class="input-group">
														<cfif isdefined("attributes.finishassetdate") and isdate(attributes.finishassetdate)>
															<cfinput type="text" name="finishassetdate" id="finishassetdate" maxlength="10" validate="#validate_style#" message="#alert#" value="#dateformat(attributes.finishassetdate,dateformat_style)#">
														<cfelse>
															<cfinput type="text" name="finishassetdate" id="finishassetdate" maxlength="10" validate="#validate_style#" message="#alert#" >
														</cfif>
														<span class="input-group-addon">
															<cf_wrk_date_image date_field="finishassetdate">
														</span>
													</div>
												</div>
										</div>
										<div class="form-group">
											<div class="col col-12 col-md-12 col-xs-12">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
											</div>
											<div class="col col-6 col-md-6">
												<div class="input-group">
													<cfif isdefined("attributes.startassetfndate") and isdate(attributes.startassetfndate)>
														<cfinput type="text" name="startassetfndate" id="startassetfndate" maxlength="10" validate="#validate_style#" message="#alert#" value="#dateformat(attributes.startassetfndate,dateformat_style)#">
													<cfelse>
														<cfinput type="text" name="startassetfndate" id="startassetfndate" maxlength="10" validate="#validate_style#" message="#alert#" >
													</cfif>
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="startassetfndate">
													</span>
												</div>
											</div>
											<div class="col col-6 col-md-6">
												<div class="input-group">
													<cfif isdefined("attributes.finishassetfndate") and isdate(attributes.finishassetfndate)>
														<cfinput type="text" name="finishassetfndate" id="finishassetfndate" maxlength="10" validate="#validate_style#" message="#alert#" value="#dateformat(attributes.finishassetfndate,dateformat_style)#">
													<cfelse>
														<cfinput type="text" name="finishassetfndate" id="finishassetfndate" maxlength="10" validate="#validate_style#" message="#alert#" >
													</cfif>
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="finishassetfndate">
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
							<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<input name="is_submitted" id="is_submitted" value="1" type="hidden">
                            <cf_wrk_report_search_button button_type='1' is_excel="1" search_function="control()">
						</div>
					</div>
				</div>
			</div> 
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_assets.recordCount>
</cfif>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<cfset type_ = 1>
<cfelse>
	<cfset type_ = 0>
</cfif>	
<cfif isdefined("is_submitted")>
	<cf_report_list>
			<thead>
				<tr>
					<th></th>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='57572.Departman'></th>
					<th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
					<th><cf_get_lang dictionary_id='58701.Fonksiyon'></th>
					<th><cf_get_lang dictionary_id='58578.Belge Türü'></th>
					<th><cf_get_lang dictionary_id='55652.Belge Adı'></th>
					<th><cf_get_lang dictionary_id='57880.Belge No'></th>
					<th><cf_get_lang dictionary_id='53125.Veriliş T.'></th>
					<th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
					<th><cf_get_lang dictionary_id='57468.Belge'></th>
				</tr>
			</thead>
			<tbody>
				<cfif isdefined('attributes.is_submitted') and get_assets.recordcount>
					<cfoutput query="get_assets">
						<tr height="22">
							<td>#RowNum#</td>
							<td>#EMPLOYEE_NO#</td>
							<td>#NAMESURNAME#</td>
							<td>#COMPANY_NAME#</td>
							<td>#BRANCH_NAME#</td>
							<td>#DEPARTMENT_HEAD#</td>
							<td>#POSITION_CAT#</td>
							<td>#UNIT_NAME#</td>
							<td>#ASSET_CAT#</td>
							<td>#ASSET_NAME#</td>
							<td>#ASSET_NO#</td>
							<td>#dateformat(ASSET_DATE,dateformat_style)#</td>
							<td>#dateformat(ASSET_FINISH_DATE, dateformat_style)#</td>
							<cfif attributes.is_excel eq 0>
							<td><!-- sil --><cfif len(ASSET_FILE)><a href="javascript://" onclick="windowopen('/documents/hr/#ASSET_FILE#','list');"><img src="/images/file.gif" title="<cf_get_lang dictionary_id='47902.Ekli Belge'>" align="absmiddle"></a></cfif><!-- sil --></td>
							<cfelse><td></td>
							</cfif>
						</tr>
					</cfoutput>
				<cfelse>
					<tr height="22">
						<td colspan="15"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
	</cf_report_list>
</cfif>
<cfset adres = "">
<cfif isdefined("attributes.is_submitted") and attributes.totalrecords gt attributes.maxrows>
<cfset adres = "report.employement_assets_report&is_submitted=1">
<cfif len(attributes.keyword)>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>	
<cfif len(attributes.asset_cat)>
	<cfset adres = "#adres#&asset_cat=#attributes.asset_cat#">
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
<cfif len(attributes.position_cat_id)>
	<cfset adres = "#adres#&position_cat_id=#attributes.position_cat_id#">
</cfif>
<cfif len(attributes.unit_id)>
	<cfset adres = "#adres#&unit_id=#attributes.unit_id#">
</cfif>
<cfif len(attributes.startdate) and isdate(attributes.startdate)>
	<cfset adres = "#adres#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
</cfif>
<cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cfset adres = "#adres#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
</cfif>
<cfif len(attributes.startassetdate) and isdate(attributes.startassetdate)>
	<cfset adres = "#adres#&startassetdate=#dateformat(attributes.startassetdate,dateformat_style)#">
</cfif>
<cfif len(attributes.finishassetdate) and isdate(attributes.finishassetdate)>
	<cfset adres = "#adres#&finishassetdate=#dateformat(attributes.finishassetdate,dateformat_style)#">
</cfif>
<cfif len(attributes.startassetfndate) and isdate(attributes.startassetfndate)>
	<cfset adres = "#adres#&startassetfndate=#dateformat(attributes.startassetfndate,dateformat_style)#">
</cfif>
<cfif len(attributes.finishassetfndate) and isdate(attributes.finishassetfndate)>
	<cfset adres = "#adres#&finishassetfndate=#dateformat(attributes.finishassetfndate,dateformat_style)#">
</cfif>
<cfif len(attributes.inout_statue)>
	<cfset adres = "#adres#&inout_statue=#attributes.inout_statue#">
</cfif>
<cfif len(attributes.asset_statue)>
	<cfset adres = "#adres#&asset_statue=#attributes.asset_statue#">
</cfif>
	<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">
</cfif>
<script type="text/javascript">
	function control()	
	{
		if(!date_check(search_form.startdate,search_form.finishdate,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
			return false;
		}
		if(!date_check(search_form.startassetdate,search_form.finishassetdate,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
			return false;
		}
		if(!date_check(search_form.startassetfndate,search_form.finishassetfndate,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
			return false;
		}
		if(document.search_form.is_excel.checked==false)
		{
			document.search_form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			return true;
		}
		else
			document.search_form.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_employement_assets_report</cfoutput>"
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
</script>

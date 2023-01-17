<cfscript>
	cmp_company = createObject("component","V16.hr.cfc.get_our_company");
	cmp_company.dsn = dsn;
	get_company = cmp_company.get_company();
	cmp_branch = createObject("component","V16.hr.cfc.get_branches");
	cmp_branch.dsn = dsn;
	get_branches = cmp_branch.get_branch(comp_id : '#iif(isdefined("attributes.comp_id"),"attributes.comp_id",DE(""))#');
	cmp_department = createObject("component","V16.hr.cfc.get_departments");
	cmp_department.dsn = dsn;
	get_department = cmp_department.get_department(branch_id : '#iif(isdefined("attributes.branch_id"),"attributes.branch_id",DE(""))#');
	cmp_department_all = createObject("component","V16.hr.cfc.get_departments");
	cmp_department_all.dsn = dsn;
	get_department_all = cmp_department_all.get_department();
	cmp_pos_cat = createObject("component","V16.hr.cfc.get_position_cat");
	cmp_pos_cat.dsn = dsn;
	get_position_cat = cmp_pos_cat.get_position_cat();
	cmp_func = createObject("component","V16.hr.cfc.get_functions");
	cmp_func.dsn = dsn;
	get_func = cmp_func.get_function();
	cmp_title = createObject("component","V16.hr.cfc.get_titles");
	cmp_title.dsn = dsn;
	get_title = cmp_title.get_title();
	cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps");
	cmp_org_step.dsn = dsn;
	get_org_step = cmp_org_step.get_organization_step();
	collar_type = QueryNew("COLLAR_TYPE_ID, COLLAR_TYPE_NAME");
	QueryAddRow(collar_type,2);
	QuerySetCell(collar_type,"COLLAR_TYPE_ID",1,1);
	QuerySetCell(collar_type,"COLLAR_TYPE_NAME","#getLang('hr',980)#",1);
	QuerySetCell(collar_type,"COLLAR_TYPE_ID",2,2);
	QuerySetCell(collar_type,"COLLAR_TYPE_NAME","#getLang('hr',981)#",2);
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfparam name="attributes.work_startdate" default="">
<cfparam name="attributes.inout_statue" default="2">
<cfparam name="attributes.startdate" default="1/#month(now())#/#year(now())#">
<cfparam name="attributes.finishdate" default="#bu_ay_sonu#/#month(now())#/#year(now())#">
<cfif isdate(attributes.startdate)><cf_date tarih = "attributes.startdate"></cfif>
<cfif isdate(attributes.finishdate)><cf_date tarih = "attributes.finishdate"></cfif>
<cfif isdefined('attributes.work_startdate') and isdate(attributes.work_startdate)><cf_date tarih = "attributes.work_startdate"></cfif>
<cfset cmp_process = createObject('component','V16.workdata.get_process')>
<cfset get_process = cmp_process.GET_PROCESS_TYPES(faction_list : 'hr.update_positions')>
<cfquery name="fire_reasons" datasource="#dsn#">
	SELECT REASON_ID,REASON FROM SETUP_EMPLOYEE_FIRE_REASONS WHERE IS_POSITION = 1 ORDER BY REASON
</cfquery>
<cfquery name="get_xml_detail" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="hr.form_add_position"> AND
		(PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_upd_in_out"> OR
		PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_position_change_control"> OR
		PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_position_change_reason_control">)
</cfquery>
<cfif isDefined("attributes.gp_id") and len(attributes.gp_id)>
	<cfquery name="get_positions" datasource="#dsn#">
		SELECT DISTINCT
			EP.POSITION_ID,
			EP.POSITION_NAME,
			EP.POSITION_STAGE,
			EP.EMPLOYEE_ID,
			EP.EMPLOYEE_NAME,
			EP.EMPLOYEE_SURNAME,
			EP.POSITION_CAT_ID,
			EP.TITLE_ID,
			EP.FUNC_ID,
			EP.ORGANIZATION_STEP_ID,
			EP.COLLAR_TYPE,
			EP.IN_COMPANY_REASON_ID,
			D.DEPARTMENT_ID,
			B.BRANCH_ID,
			B.BRANCH_NAME,
			(
				SELECT
					TOP 1
					GENERAL_PAPER.GENERAL_PAPER_NO
				FROM
					#dsn#.GENERAL_PAPER
					LEFT JOIN #dsn#.PAGE_WARNINGS ON PAGE_WARNINGS.GENERAL_PAPER_ID = GENERAL_PAPER.GENERAL_PAPER_ID
				WHERE
					EP.POSITION_ID IN (SELECT * FROM #dsn#.fnSplit((GENERAL_PAPER.ACTION_LIST_ID), ','))
					AND GENERAL_PAPER.STAGE_ID = EP.POSITION_STAGE
					AND PAGE_WARNINGS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
					AND PAGE_WARNINGS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				ORDER BY
					GENERAL_PAPER.GENERAL_PAPER_ID DESC
			) AS GENERAL_PAPER_NO
		FROM
			EMPLOYEE_POSITIONS EP
			INNER JOIN EMPLOYEES_IN_OUT EIO ON EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID
			LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
			LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
		WHERE
			EP.IS_MASTER = 1
			AND EP.POSITION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.action_list_id#">)
			<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
				AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.comp_id#">)
			</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.branch_id#">)
			</cfif>
			<cfif isdefined("attributes.department") and len(attributes.department)>
				AND D.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.department#">)
			</cfif>
			<cfif isdefined("attributes.pos_cat_id") and len(attributes.pos_cat_id)>
				AND EP.POSITION_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.pos_cat_id#">)
			</cfif>
			<cfif isdefined("attributes.title_id") and len(attributes.title_id)>
				AND EP.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.title_id#">)
			</cfif>
			<cfif isdefined("attributes.func_id") and len(attributes.func_id)>
				AND EP.FUNC_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.func_id#">)
			</cfif>
			<cfif isdefined("attributes.org_step_id") and len(attributes.org_step_id)>
				AND EP.ORGANIZATION_STEP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.org_step_id#">)
			</cfif>
			<cfif isdefined("attributes.collar_type") and len(attributes.collar_type)>
				AND EP.COLLAR_TYPE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.collar_type#">)
			</cfif>
			<cfif isdefined("attributes.work_startdate") and len(attributes.work_startdate)>
				AND EP.POSITION_ID IN (SELECT DISTINCT POSITION_ID FROM EMPLOYEE_POSITIONS_HISTORY WHERE START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.work_startdate#">)
			</cfif>
			<cfif isdefined("attributes.inout_statue") and attributes.inout_statue eq 1><!--- Girişler --->
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
				</cfif>
			<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 0><!--- Çıkışlar --->
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
				</cfif>
				AND	EIO.FINISH_DATE IS NOT NULL
			<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 2><!--- aktif calisanlar --->
				AND 
				(
					<cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
						<cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE IS NULL
							)
						)
						<cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
							EIO.FINISH_DATE IS NULL
							)
						)
						<cfelse>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE IS NULL
							)
							OR
							(
							EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
							OR
							(
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
						)
						</cfif>
					<cfelse>
						EIO.FINISH_DATE IS NULL
					</cfif>
				)
			<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 3><!--- giriş ve çıkışlar Seçili ise --->
				AND 
				(
					(
						EIO.START_DATE IS NOT NULL
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
					)
					OR
					(
						EIO.START_DATE IS NOT NULL
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
					)
				)
			</cfif>
		ORDER BY
			EP.EMPLOYEE_NAME,
			EP.EMPLOYEE_SURNAME
	</cfquery>
</cfif>
<cfif isdefined("attributes.is_submitted")>
	<cfquery name="get_positions" datasource="#dsn#">
		SELECT DISTINCT
			EP.POSITION_ID,
			EP.POSITION_NAME,
			EP.POSITION_STAGE,
			EP.EMPLOYEE_ID,
			EP.EMPLOYEE_NAME,
			EP.EMPLOYEE_SURNAME,
			EP.POSITION_CAT_ID,
			EP.TITLE_ID,
			EP.FUNC_ID,
			EP.ORGANIZATION_STEP_ID,
			EP.COLLAR_TYPE,
			EP.IN_COMPANY_REASON_ID,
			D.DEPARTMENT_ID,
			B.BRANCH_ID,
			B.BRANCH_NAME,
			(
				SELECT
					TOP 1
					GENERAL_PAPER.GENERAL_PAPER_NO
				FROM
					#dsn#.GENERAL_PAPER
					LEFT JOIN #dsn#.PAGE_WARNINGS ON PAGE_WARNINGS.GENERAL_PAPER_ID = GENERAL_PAPER.GENERAL_PAPER_ID
				WHERE
					EP.POSITION_ID IN (SELECT * FROM #dsn#.fnSplit((GENERAL_PAPER.ACTION_LIST_ID), ','))
					AND GENERAL_PAPER.STAGE_ID = EP.POSITION_STAGE
					AND PAGE_WARNINGS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
					AND PAGE_WARNINGS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				ORDER BY
					GENERAL_PAPER.GENERAL_PAPER_ID DESC
			) AS GENERAL_PAPER_NO
		FROM
			EMPLOYEE_POSITIONS EP
			INNER JOIN EMPLOYEES_IN_OUT EIO ON EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID
			LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
			LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
		WHERE
			EP.IS_MASTER = 1
			<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
				AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.comp_id#">)
			</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.branch_id#">)
			</cfif>
			<cfif isdefined("attributes.department") and len(attributes.department)>
				AND D.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.department#">)
			</cfif>
			<cfif isdefined("attributes.pos_cat_id") and len(attributes.pos_cat_id)>
				AND EP.POSITION_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.pos_cat_id#">)
			</cfif>
			<cfif isdefined("attributes.title_id") and len(attributes.title_id)>
				AND EP.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.title_id#">)
			</cfif>
			<cfif isdefined("attributes.func_id") and len(attributes.func_id)>
				AND EP.FUNC_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.func_id#">)
			</cfif>
			<cfif isdefined("attributes.org_step_id") and len(attributes.org_step_id)>
				AND EP.ORGANIZATION_STEP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.org_step_id#">)
			</cfif>
			<cfif isdefined("attributes.collar_type") and len(attributes.collar_type)>
				AND EP.COLLAR_TYPE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.collar_type#">)
			</cfif>
			<cfif isdefined("attributes.work_startdate") and len(attributes.work_startdate)>
				AND EP.POSITION_ID IN (SELECT DISTINCT POSITION_ID FROM EMPLOYEE_POSITIONS_HISTORY WHERE START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.work_startdate#">)
			</cfif>
			<cfif isdefined("attributes.inout_statue") and attributes.inout_statue eq 1><!--- Girişler --->
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
				</cfif>
			<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 0><!--- Çıkışlar --->
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
				</cfif>
				AND	EIO.FINISH_DATE IS NOT NULL
			<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 2><!--- aktif calisanlar --->
				AND 
				(
					<cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
						<cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE IS NULL
							)
						)
						<cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
							EIO.FINISH_DATE IS NULL
							)
						)
						<cfelse>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE IS NULL
							)
							OR
							(
							EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
							OR
							(
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
						)
						</cfif>
					<cfelse>
						EIO.FINISH_DATE IS NULL
					</cfif>
				)
			<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 3><!--- giriş ve çıkışlar Seçili ise --->
				AND 
				(
					(
						EIO.START_DATE IS NOT NULL
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
					)
					OR
					(
						EIO.START_DATE IS NOT NULL
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
					)
				)
			</cfif>
		ORDER BY
			EP.EMPLOYEE_NAME,
			EP.EMPLOYEE_SURNAME
	</cfquery>
<cfelse>
	<cfset get_positions.recordcount=0>
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.is_submitted")>
		row_count=<cfoutput>#get_positions.recordcount#</cfoutput>;
	<cfelse>
		row_count=0;
	</cfif>
</script>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_pos" action="#request.self#?fuseaction=hr.update_positions" method="post">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cf_box_search>
				<div class="form-group col col-2 col-md-6 col-sm-6 col-xs-12">
					<label><cf_get_lang dictionary_id='57574.Şirket'></label>
					<cf_multiselect_check
						query_name="get_company"
						name="comp_id"
						width="140"
						option_value="COMP_ID"
						option_name="COMPANY_NAME"
						option_text="#getLang('main',322)#"
						value="#iif(isdefined('attributes.comp_id'),'attributes.comp_id',DE(''))#"
						onchange="get_branch_list(this.value)">
				</div>
				<div class="form-group col col-2 col-md-6 col-sm-6 col-xs-12">
					<label><cf_get_lang dictionary_id='57453.Şube'></label>
					<cf_multiselect_check 
						query_name="get_branches"  
						name="branch_id"
						width="140" 
						option_value="BRANCH_ID"
						option_name="BRANCH_NAME"
						option_text="#getLang('main',322)#"
						value="#iif(isdefined('attributes.branch_id'),'attributes.branch_id',DE(''))#"
						onchange="get_department_list(this.value)">
					
				</div>
				<div class="form-group col col-2 col-md-6 col-sm-6 col-xs-12">
					<label><cf_get_lang dictionary_id='57572.Departman'></label>
					<cf_multiselect_check 
						query_name="get_department"  
						name="department"
						width="140" 
						option_value="DEPARTMENT_ID"
						option_name="DEPARTMENT_HEAD"
						option_text="#getLang('main',322)#"
						value="#iif(isdefined('attributes.department'),'attributes.department',DE(''))#">
				</div>
				<div class="form-group col col-2 col-md-6 col-sm-6 col-xs-12">
					<label><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
					<cf_multiselect_check
						query_name="get_position_cat"
						name="pos_cat_id"
						width="140"
						option_value="POSITION_CAT_ID"
						option_name="POSITION_CAT"
						option_text="#getLang('main',322)#"
						value="#iif(isdefined('attributes.pos_cat_id'),'attributes.pos_cat_id',DE(''))#">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group col col-3 col-md-6 col-sm-6 col-xs-12">
						<label><cf_get_lang dictionary_id='58701.Fonksiyon'></label>
						<cf_multiselect_check
							query_name="get_func"
							name="func_id"
							width="140"
							option_value="unit_id"
							option_name="unit_name"
							option_text="#getLang('main',322)#"
							value="#iif(isdefined('attributes.func_id'),'attributes.func_id',DE(''))#">
					</div>
					<div class="form-group col col-3 col-md-6 col-sm-6 col-xs-12">
						<label><cf_get_lang dictionary_id='57571.Ünvan'></label>
						<cf_multiselect_check
							query_name="get_title"
							name="title_id"
							width="140"
							option_value="TITLE_ID"
							option_name="TITLE"
							option_text="#getLang('main',322)#"
							value="#iif(isdefined('attributes.title_id'),'attributes.title_id',DE(''))#">
					</div>
					<div class="form-group col col-3 col-md-6 col-sm-6 col-xs-12">
						<label><cf_get_lang dictionary_id='58710.Kademe'></label>
						<cf_multiselect_check
							query_name="get_org_step"
							name="org_step_id"
							width="140"
							option_value="ORGANIZATION_STEP_ID"
							option_name="ORGANIZATION_STEP_NAME"
							option_text="#getLang('main',322)#"
							value="#iif(isdefined('attributes.org_step_id'),'attributes.org_step_id',DE(''))#">
					</div>
					<div class="form-group col col-3 col-md-6 col-sm-6 col-xs-12">
						<label><cf_get_lang dictionary_id='56063.Yaka Tipi'></label>
						<cf_multiselect_check
							query_name="collar_type"
							name="collar_type"
							width="140"
							option_value="COLLAR_TYPE_ID"
							option_name="COLLAR_TYPE_NAME"
							option_text="#getLang('main',322)#"
							value="#iif(isdefined('attributes.collar_type'),'attributes.collar_type',DE(''))#">
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
						<label><cf_get_lang dictionary_id='55438.Görev Başlangıç Tarihi'></label>
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='55438.Görev Başlangıç Tarihi'></cfsavecontent>
							<cfinput type="text" name="work_startdate" id="work_startdate" message="#message#" validate="#validate_style#" maxlength="10" value="#dateformat(attributes.work_startdate,dateformat_style)#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="work_startdate"></span>
						</div>
					</div>
					<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
						<label><cf_get_lang dictionary_id='55539.Çalışma Durumu'></label>
						<select name="inout_statue" id="inout_statue">
							<option value="3"><cf_get_lang dictionary_id='29518.Girişler ve Çıkışlar'></option>
							<option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang dictionary_id='58535.Girişler'></option>
							<option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang dictionary_id='58536.Çıkışlar'></option>
							<option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang dictionary_id="39083.Aktif Çalışanlar"></option>
						</select>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
						<label><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
							<cfinput type="text" name="startdate" id="startdate" style="width:120px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.startdate,dateformat_style)#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
						</div>
					</div>
					<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
						<label><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
							<cfinput type="text" name="finishdate" id="finishdate" style="width:120px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cfform name="upd_position" action="#request.self#?fuseaction=hr.emptypopup_upd_positions_all" method="post">
		<cf_box title="#getLang('','Toplu Pozisyon Değişikliği',62516)#" uidrop="1" hide_table_column="1">
			<cf_grid_list>
				<cfquery name="get_xml_pos_chng" dbtype="query">
					SELECT PROPERTY_VALUE FROM get_xml_detail WHERE PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_position_change_control">
				</cfquery>
				<cfquery name="get_xml_chng_reason" dbtype="query">
					SELECT PROPERTY_VALUE FROM get_xml_detail WHERE PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_position_change_reason_control">
				</cfquery>
				<thead>
					<tr>
						<th width="20"><a onClick="add_row2();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
						<th><cf_get_lang dictionary_id='57487.No'></th>
						<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
						<th><cf_get_lang dictionary_id='57453.Şube'></th>
						<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
						<th nowrap><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'>*</th>
						<th nowrap><cf_get_lang dictionary_id='57572.Departman'>*</th>
						<th nowrap><cf_get_lang dictionary_id='55168.Ünvanlar'>*</th>
						<th><cf_get_lang dictionary_id='58701.Fonksiyon'></th>
						<th><cf_get_lang dictionary_id='58710.Kademe'></th>
						<th><cf_get_lang dictionary_id='56063.Yaka Tipi'></th>
						<cfif get_xml_pos_chng.property_value eq 1>
							<th width="140"><cf_get_lang dictionary_id="57569.Görevli"><cf_get_lang dictionary_id="55602.Başl/Bitiş Tarihi"></th>
							<th><cf_get_lang dictionary_id='55550.Gerekçe'></th>
						</cfif>
						<th><input class="checkControl" type="checkbox" id="checkAll" name="checkAll" onclick="wrk_select_all('checkAll','action_list_id');" value="0" /></th>
					</tr>
				</thead>
				<tbody>
					<cfif get_positions.recordcount>
						<tr>
							<cfquery name="get_xml_inout" dbtype="query">
								SELECT PROPERTY_VALUE FROM get_xml_detail WHERE PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_upd_in_out">
							</cfquery>
							<td></td>
							<td colspan="12"><cf_get_lang dictionary_id='63074.Değişiklik yapmak istediğiniz çalışanları seçiniz'></td>
							<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_positions.recordcount#</cfoutput>">
							<input type="hidden" name="x_upd_in_out" id="x_upd_in_out" value="<cfoutput>#get_xml_inout.property_value#</cfoutput>">
							<input type="hidden" name="x_position_change_control" id="x_position_change_control" value="<cfoutput>#get_xml_pos_chng.property_value#</cfoutput>">
							<input type="hidden" name="x_position_change_reason_control" id="x_position_change_reason_control" value="<cfoutput>#get_xml_chng_reason.property_value#</cfoutput>">
						</tr>
						</tbody>
						<tbody id="link_table">
						<cfoutput query="get_positions">
							<tr id="my_row_#currentrow#">
								<input type="hidden" name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#" value="1">
								<input type="hidden" name="action_type_id" id="action_type_id" value="#position_id#">
								<input type="hidden" name="pos_id_#currentrow#" id="pos_id_#currentrow#" value="#position_id#">
								<input type="hidden" name="emp_id#currentrow#" id="emp_id#currentrow#" value="#employee_id#">
								<input type="hidden" name="is_change_pos#currentrow#" id="is_change_pos#currentrow#" value="0">
								<input type="hidden" name="old_dep#currentrow#" id="old_dep#currentrow#" value="#department_id#">
								<input type="hidden" name="old_title#currentrow#" id="old_title#currentrow#" value="#title_id#">
								<input type="hidden" name="old_pos_cat#currentrow#" id="old_pos_cat#currentrow#" value="#position_cat_id#">
								<input type="hidden" name="old_func#currentrow#" id="old_func#currentrow#" value="#func_id#">
								<input type="hidden" name="old_collar#currentrow#" id="old_collar#currentrow#" value="#collar_type#">
								<input type="hidden" name="old_org_step#currentrow#" id="old_org_step#currentrow#" value="#organization_step_id#">
								<input type="hidden" name="employee#currentrow#" id="employee#currentrow#" value="#employee_name# #employee_surname#">
								<td><a onclick="sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
								<td>#currentrow#</td>
								<td>#employee_name# #employee_surname#</td>
								<td>#branch_name#</td>
								<td>
									<div class="input-group">
										<cfinput maxlength="50"  type="Text" name="POSITION_NAME#currentrow#" id="position_name#currentrow#" value="#POSITION_NAME#">
										<span class="input-group-addon btnPointer icon-ellipsis" onClick="javascript:openBoxDraggable('#request.self#?fuseaction=hr.popup_list_position_names&field_name=upd_position.POSITION_NAME#currentrow#');"></span>              
									</div>   
								</td>
								<td>
									<div class="form-group">
										<select name="pos_cat#currentrow#" id="pos_cat#currentrow#" style="width:100px;">
											<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
											<cfloop query="get_position_cat">
												<option value="#position_cat_id#"<cfif get_positions.position_cat_id eq position_cat_id>selected</cfif>>#position_cat#</option>
											</cfloop>
										</select>
									</div>
								</td>
								<td>
									<cfif get_xml_inout.property_value eq 1>
										<input type="hidden" name="branch_id#currentrow#" id="branch_id#currentrow#" value="#branch_id#">
									</cfif>
									<div class="form-group">
										<select name="pos_dep#currentrow#" id="pos_dep#currentrow#" style="width:100px;">
											<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
											<cfloop query="get_department_all">
												<option value="#department_id#"<cfif get_positions.department_id eq department_id>selected</cfif>>#department_head#</option>
											</cfloop>
										</select>
									</div>
								</td>
								<td>
									<div class="form-group">
										<select name="pos_title#currentrow#" id="pos_title#currentrow#" style="width:100px;">
											<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
											<cfloop query="get_title">
												<option value="#title_id#"<cfif get_positions.title_id eq title_id>selected</cfif>>#title#</option>
											</cfloop>
										</select>
									</div>
								</td>
								<td>
									<div class="form-group">
										<select name="pos_func#currentrow#" id="pos_func#currentrow#" style="width:100px;">
											<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
											<cfloop query="get_func">
												<option value="#unit_id#"<cfif get_positions.func_id eq unit_id>selected</cfif>>#unit_name#</option>
											</cfloop>
										</select>
									</div>
								</td>
								<td>
									<div class="form-group">
										<select name="pos_org_step_id#currentrow#" id="pos_org_step_id#currentrow#" style="width:100px;">
											<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
											<cfloop query="get_org_step">
												<option value="#organization_step_id#"<cfif get_positions.organization_step_id eq organization_step_id>selected</cfif>>#organization_step_name#</option>
											</cfloop>
										</select>
									</div>
								</td>
								<td>
									<div class="form-group">
										<select name="pos_collar_type#currentrow#" id="pos_collar_type#currentrow#" style="width:100px;">
											<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
											<option value="1"<cfif collar_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='56065.Mavi Yaka'></option>
											<option value="2"<cfif collar_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='56066.Beyaz Yaka'></option>
										</select>
									</div>
								</td>
								<cfif get_xml_pos_chng.property_value eq 1>
									<td nowrap class="text-right">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id="57569.Görevli"><cf_get_lang dictionary_id="55602.Başl/Bitiş Tarihi"></cfsavecontent>
										<cfif get_xml_chng_reason.property_value eq 1>
		                                    <cfinput type="text" name="pos_in_out_date#currentrow#" id="pos_in_out_date#currentrow#" onChange="reset_reason(#currentrow#);" style="width:80px;" value="" validate="#validate_style#" maxlength="10">
		                                <cfelse>
		                                    <cfinput type="text" name="pos_in_out_date#currentrow#" id="pos_in_out_date#currentrow#" style="width:80px;" value="" validate="#validate_style#" maxlength="10">
		                                </cfif>
										<cf_wrk_date_image date_field="pos_in_out_date#currentrow#">
									</td>
									<td>
										<div class="form-group">
											<select name="reason_id#currentrow#" id="reason_id#currentrow#" style="width:100px;">
												<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
												<cfloop query="fire_reasons">
													<option value="#reason_id#"<cfif get_positions.in_company_reason_id eq reason_id>selected</cfif>>#reason#</option>
												</cfloop>
											</select>
										</div>
									</td>
									<td>
										<input class="checkControl" type="checkbox" name="action_list_id" id="action_list_id" value="#position_id#" />
									</td>
								</cfif>
							</tr>
						</cfoutput>
					</cfif>
				</tbody>
			</cf_grid_list>
		</cf_box>
		<cfif isDefined("form.is_submitted") or isdefined("attributes.gp_id")>
			<cf_box title="#getLang('','Kayıt Bilgileri',62517)#">
				<cf_box_elements>
					 <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-6 col-xs-12">
							<cfset cmp_process = createObject('component','V16.workdata.get_process')>
							<cfset get_process_f = cmp_process.GET_PROCESS_TYPES(
								faction_list : 'hr.update_positions')>
							<cfif isDefined("attributes.gp_id")>
								<cf_workcube_general_process is_termin_date="0" general_paper_id = "#attributes.gp_id#" print_type="311">
							<cfelse>
								<cf_workcube_general_process is_termin_date="0" is_template_view="false" select_value="#get_positions.position_stage#">
							</cfif>
							
							<!--- <cf_workcube_general_process is_template_view="false" select_value="#get_positions.position_stage#"> --->
						</div>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<div class="ui-form-list-btn">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57535.Kaydetmek istediğinize emin misiniz'></cfsavecontent>
								<input type="hidden" id="paper_submit" name="paper_submit" value="0">
								<cf_workcube_buttons is_upd='0'add_function='setPositionsProcess() && control()'>
								<!--- <div>
									<input type="submit" name="setPositionProcess" id="setPositionProcess" onclick="if(confirm('<cf_get_lang dictionary_id='57535.Kaydetmek istediğinize emin misiniz'>')) return setPositionsProcess() && control(); else return false;" value="<cf_get_lang dictionary_id='57461.Kaydet'>">
								</div> --->
							</div>
						</div>
					</div> 	
				</cf_box_elements>
			</cf_box>
		</cfif>
	</cfform>
</div>
<script type="text/javascript">
function setPositionsProcess(){
		var checkboxes = $('input[name="action_list_id"]:checked').length;
        
		if(checkboxes <= 0){
			alert("<cf_get_lang dictionary_id='30942.Listeden Satır Seçmelisiniz'>");
			return false;
		}
		
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
			alert("<cf_get_lang dictionary_id='62954.Lütfen Belge Tarihi Giriniz'>!");
			return false;
		}
		if( $.trim($('#general_paper_notice').val()) == '' ){
			alert("<cf_get_lang dictionary_id='62955.Lütfen Ek Açıklama Giriniz'>!");
			return false;
		}
		document.getElementById("paper_submit").value = 1;
		$('#setProcessForm').submit();
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
		AjaxPageLoad(send_address,1,'İlişkili Şubeler');
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
		AjaxPageLoad(send_address,1,'İlişkili Departmanlar');
	}
	
	function hepsi(satir,nesne,baslangic)
	{
		deger=$('#'+nesne);
		if(!baslangic){baslangic=1;}
		for(var i=baslangic;i<=satir;i++)
		{
			nesne_=$('#'+nesne+i);
			nesne_.val(deger.val());
		}
	}
	
	function sil(sy)
	{
		var my_element = $('#row_kontrol_' + sy);
		my_element.val(0);
		var my_element = $('#my_row_' +sy);
		my_element.css("display","none");
	}
	
	function control()
	{
		deger = $('#record_num').val();
		if (deger > 0)
		{
			for (i=1; i<=deger; i++)
			{
				if ($('#row_kontrol_'+i).val() == 1)
				{
					$('#is_change_pos'+i).val(0);
					if($('#emp_id'+i).val() != "")
					{
						if($('#x_position_change_control').val() == 1 && ($('#old_dep'+i).val() != $('#pos_dep'+i).val() || $('#old_title'+i).val() != $('#pos_title'+i).val() || $('#old_pos_cat'+i).val() != $('#pos_cat'+i).val() || $('#old_func'+i).val() != $('#pos_func'+i).val() || $('#old_collar'+i).val() != $('#pos_collar_type'+i).val() || $('#old_org_step'+i).val() != $('#pos_org_step_id').val()))
						{
							$('#is_change_pos'+i).val(1);
							if($('#pos_in_out_date'+i).val() == "")
							{
								alert(i+ "<cf_get_lang dictionary_id='56054.pozisyon bilgilerinde değişiklik yaptınız. Lütfen Görev Değişiklik tarihini giriniz!'>");
								return false;
							}
							if($('#reason_id'+i).val() == "")
							{
								alert(i+ "<cf_get_lang dictionary_id='56055.pozisyon bilgilerinde değişiklik yaptınız. Lütfen Gerekçe seçiniz!'>");
								return false;
							}
						}
					}
					if(trim($('#pos_cat'+i).val()) == "")
					{
						alert("<cf_get_lang dictionary_id='41518.Pozisyon tipi alanlarını doldurunuz'>.");
						return false;
					}
					if(trim($('#pos_dep'+i).val()) == "")
					{
						alert("<cf_get_lang dictionary_id='41517.Departman alanlarını doldurunuz'>.");
						return false;
					}
					if(trim($('#pos_title'+i).val()) == "")
					{
						alert("<cf_get_lang dictionary_id='41515.Ünvan alanlarını doldurunuz.'>.");
						return false;
					}
				}
			}
		}
	}
	
	function reset_reason(i)
	{
		if($('#emp_id'+i).val() != "")
		{
			if($('#x_position_change_control').val() == 1 && ($('#old_dep'+i).val() != $('#pos_dep'+i).val() || $('#old_title'+i).val() != $('#pos_title'+i).val() || $('#old_pos_cat'+i).val() != $('#pos_cat'+i).val() || $('#old_func'+i).val() != $('#pos_func'+i).val() || $('#old_collar'+i).val() != $('#pos_collar_type'+i).val() || $('#old_org_step'+i).val() != $('#pos_org_step_id').val()))
			{
				$('#reason_id'+i).val("");
			}
		}
	}
	
	function add_row2()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
		newRow.setAttribute("name","my_row_" + row_count);
		newRow.setAttribute("id","my_row_" + row_count);
		newRow.setAttribute("NAME","my_row_" + row_count);
		newRow.setAttribute("ID","my_row_" + row_count);
		
		$('#record_num').val(row_count);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol_'+row_count+'" id="row_kontrol_'+row_count+'" value="1"><input type="hidden" name="old_org_step'+row_count+'" id="old_org_step'+row_count+'" value=""><input type="hidden" name="old_collar'+row_count+'" id="old_collar'+row_count+'" value=""><input type="hidden" name="old_func'+row_count+'" id="old_func'+row_count+'" value=""><input type="hidden" name="old_pos_cat'+row_count+'" id="old_pos_cat'+row_count+'" value=""><input type="hidden" name="old_title'+row_count+'" id="old_title'+row_count+'" value=""><input type="hidden" name="old_dep'+row_count+'" id="old_dep'+row_count+'" value=""><input type="hidden" name="is_change_pos' + row_count +'" id="is_change_pos' + row_count +'" value="0"><a onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" id="pos_id_'+row_count+'" name="pos_id_'+row_count+'" style="width:10px;" value=""><div class="form-group"><div class="input-group"><input type="text" id="employee' + row_count +'" name="employee' + row_count +'" style="width:120px;" value=""><input type="hidden" name="emp_id' + row_count +'" id="emp_id' + row_count +'" value=""><span class="input-group-addon icon-ellipsis" onclick="javascript:opage(' + row_count +');"></span></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" readonly id="branch_name' + row_count +'" name="branch_name' + row_count +'" style="width:120px;" value="">';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group"><input maxlength="50"  type="Text" name="POSITION_NAME' + row_count + '" id="position_name' + row_count +'" value=""><span class="input-group-addon btnPointer icon-ellipsis" onClick="javascript:openBoxDraggable('+"'"+'<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_names&field_name=upd_position.POSITION_NAME' + row_count +"'"+');"></span></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="pos_cat' + row_count + '" id="pos_cat'+row_count+'" style="width:100px;"><option value=""><cf_get_lang_main no ='322.Seçiniz'></option><cfoutput query="get_position_cat"><option value="#position_cat_id#">#position_cat#</option></cfoutput></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="pos_dep' + row_count + '" id="pos_dep' + row_count + '" style="width:100px;"><option value=""><cf_get_lang_main no ='322.Seçiniz'></option><cfoutput query="get_department_all"><option value="#department_id#">#department_head#</option></cfoutput></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="pos_title' + row_count + '" id="pos_title' + row_count + '" style="width:100px;"><option value=""><cf_get_lang_main no ='322.Seçiniz'></option><cfoutput query="get_title"><option value="#title_id#">#title#</option></cfoutput></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="pos_func' + row_count + '" id="pos_func' + row_count + '" style="width:100px;"><option value=""><cf_get_lang_main no ='322.Seçiniz'></option><cfoutput query="get_func"><option value="#unit_id#">#unit_name#</option></cfoutput></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="pos_org_step_id' + row_count + '" id="pos_org_step_id' + row_count + '" style="width:100px;"><option value=""><cf_get_lang_main no ='322.Seçiniz'></option><cfoutput query="get_org_step"><option value="#organization_step_id#">#organization_step_name#</option></cfoutput></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="pos_collar_type' + row_count + '" id="pos_collar_type' + row_count + '" style="width:100px;"><option value=""><cf_get_lang_main no ='322.Seçiniz'></option><option value="1"><cf_get_lang no ='980.Mavi Yaka'></option><option value="2"><cf_get_lang no ='981.Beyaz Yaka'></option></select></div>';
		<cfif get_xml_pos_chng.property_value eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","pos_in_out_date" + row_count + "_td");
			newCell.setAttribute("class","text-right");
			newCell.innerHTML = '<cfif get_xml_chng_reason.property_value eq 1><input type="text" name="pos_in_out_date' + row_count + '" id="pos_in_out_date' + row_count + '" onChange="reset_reason(' + row_count + ');" style="width:80px;" value="" maxlength="10"> <cfelse><input type="text" name="pos_in_out_date' + row_count + '" id="pos_in_out_date' + row_count + '" style="width:80px;" value=""  maxlength="10"></cfif>';
			wrk_date_image('pos_in_out_date' + row_count);

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><select name="reason_id' + row_count + '" id="reason_id' + row_count + '" style="width:100px;"><option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option><cfloop query="fire_reasons"><cfoutput><option value="#reason_id#">#reason#</option></cfoutput></cfloop></select></div>';
		</cfif>
		}
	
	function opage(deger)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&select_list=1&field_name=employee' + deger + '&field_id=pos_id_' + deger + '&field_emp_id=emp_id' + deger + '&field_branch_name=branch_name' + deger + '&field_pos_cat_id=pos_cat' + deger + '&field_dep_id=pos_dep' + deger + '&field_title_id=pos_title' + deger + '&field_func_id=pos_func' + deger + '&field_org_step_id=pos_org_step_id' + deger + '&call_function=change_old(' + deger +')');
	}
	
	function change_old(i)
	{
		$('#old_dep'+i).val($('#pos_dep'+i).val());
		$('#old_title'+i).val($('#pos_title'+i).val());
		$('#old_pos_cat'+i).val($('#pos_cat'+i).val());
		$('#old_func'+i).val($('#pos_func'+i).val());
		$('#old_collar'+i).val($('#pos_collar_type'+i).val());
		$('#old_org_step'+i).val($('#pos_org_step_id'+i).val());
	}
</script>
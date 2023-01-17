<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfscript>
	cmp_company = createObject("component","V16.hr.cfc.get_our_company");
	cmp_company.dsn = dsn;
    get_company = cmp_company.get_company(is_control : 1);
    
	cmp_branch = createObject("component","V16.hr.cfc.get_branches");
	cmp_branch.dsn = dsn;
    get_branches = cmp_branch.get_branch(comp_id : '#iif(len(attributes.comp_id),"attributes.comp_id",DE(""))#', ehesap_control : 1);
    
	cmp_department = createObject("component","V16.hr.cfc.get_departments");
	cmp_department.dsn = dsn;
	get_department = cmp_department.get_department(branch_id : '#iif(len(attributes.branch_id),"attributes.branch_id",DE(""))#');
</cfscript>

<cfquery name="get_employees" datasource="#dsn#">
	SELECT
		E.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_NO,
		B.BRANCH_NAME,
		D.DEPARTMENT_HEAD,
		D.HIERARCHY_DEP_ID,
		EP.POSITION_NAME,
		EP.POSITION_CAT_ID,
		SETUP_POSITION_CAT.POSITION_CAT
	FROM
		EMPLOYEES_IN_OUT EIO,
		DEPARTMENT D,
		BRANCH B,
		EMPLOYEES E
			LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
			LEFT JOIN SETUP_POSITION_CAT ON SETUP_POSITION_CAT.POSITION_CAT_ID = EP.POSITION_CAT_ID
	WHERE
		E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
		<cfif len(attributes.keyword)>
		AND
		(
			E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
			OR
			E.EMPLOYEE_NO = '#attributes.keyword#'
		)
		</cfif>
		<cfif not session.ep.ehesap>
			AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
			AND B.COMPANY_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		</cfif>
		<cfif len(attributes.branch_id)> 
			AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list="yes">)
		</cfif>
		<cfif len(attributes.department_id)> 
			AND D.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#" list="yes">)
		</cfif>
		<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
			AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list="yes">)
		</cfif>
		AND EIO.DEPARTMENT_ID = D.DEPARTMENT_ID
		AND D.BRANCH_ID = B.BRANCH_ID
		AND EIO.FINISH_DATE IS NULL
		AND 
		(
			ISNULL(E.EXT_OFFTIME_MINUTES,0) > 0
			OR
			E.EMPLOYEE_ID IN 
			(
				SELECT O.EMPLOYEE_ID FROM EMPLOYEES_EXT_WORKTIMES O WHERE VALID = 1 AND WORKTIME_WAGE_STATU = 1
			)
		)
	ORDER BY
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
</cfquery>
<cfparam name="attributes.totalrecords" default="#get_employees.recordcount#">

<cfquery name="get_departmant" datasource="#dsn#">
	SELECT * FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 ORDER BY HIERARCHY_DEP_ID ASC
</cfquery>

<cfset dept_list = valuelist(get_departmant.department_head,'*')>
<cfset dept_id_list = valuelist(get_departmant.department_id)>

<cfsavecontent variable="title"><cf_get_lang dictionary_id='60424.Serbest Zaman Raporu'></cfsavecontent>
<div class="row">
<cf_report_list_search title="#title#">
<cf_report_list_search_area>
	<cfform name="search_form" method="post" action="#request.self#?fuseaction=report.free_time_report">
	<cf_box_elements>
    <div class="row">
        <div class="col col-12 col-xs-12">
            <div class="row formContent">               
                <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
				<div class="row" type="row">
					<div class="col col-2 col-md-2 col-xs-12">
						<div class="form-group">
							<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57460.filtre'></label>
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
								<cfinput type="text" name="keyword" style="width: 225px;" value="#attributes.keyword#" maxlength="50" placeholder="#message#">
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-3 col-xs-12">
						<div class="form-group">										  
							<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29531.Şirketler'></label>
							<div class="col col-12 col-xs-12">
								<div class="multiselect-z5">
									<cf_multiselect_check
										query_name="get_company"
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
					<div class="col col-3 col-md-3 col-xs-12">
						<div class="form-group">										  
							<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
							<div class="col col-12 col-xs-12">
								<div id="BRANCH_PLACE" class="multiselect-z5">                                           
									<cf_multiselect_check 
										query_name="get_branches"  
										name="branch_id"
										width="140" 
										option_value="BRANCH_ID"
										option_name="branch_name"
										option_text="#getLang('main',322)#"
										value="#attributes.branch_id#"
										onchange="get_department_list(this.value)">
								</div>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-3 col-xs-12">
						<div class="form-group">										  
							<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
							<div class="col col-12 col-xs-12">
								<div id="DEPARTMENT_PLACE" class="multiselect-z4">
									<cf_multiselect_check 
										query_name="get_department"  
										name="department_id"
										width="140" 
										option_value="DEPARTMENT_ID"
										option_name="DEPARTMENT_HEAD"
										option_text="#getLang('main',322)#"
										value="#attributes.department_id#"
										onchange="alt_departman_chckbx(this.value);">
								</div>
							</div>
						</div>
					</div>                            
				</div>
			</div>
            <div class="row ReportContentBorder">
				<div class="ReportContentFooter">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <input type="checkbox" name="is_excel" id="is_excel" value="1"><cf_get_lang dictionary_id='29737.Excel Üret'>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">                    
                    <cf_wrk_report_search_button search_function='kontrol()' button_type="1" >
                </div>
            </div>
         </div>   
    </div>
</cf_box_elements>
</cfform> 
</cf_report_list_search_area>
</cf_report_list_search>
</div>

<cfif isdefined("attributes.is_excel")>
	<cfset attributes.maxrows = attributes.totalrecords>
	<cfset filename="free_time_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#GetHttpTimeString(Now())#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="content-type" content="text/html; charset=utf-16">
</cfif>

<cf_box title="#getLang('','main',41580)#">
<cf_grid_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id="58577.Sıra"></th>
			<th><cf_get_lang dictionary_id="56542.Sicil No"></th>
			<th><cf_get_lang dictionary_id="30368.Çalışan"></th>
			<th><cf_get_lang dictionary_id="57453.Şube"></th>
			<th><cf_get_lang dictionary_id="42335.Üst Departman"></th>
			<th><cf_get_lang dictionary_id="35449.Departman"></th>
			<th><cf_get_lang dictionary_id="59004.Pozisyon Tipi"></th>
			<th><cf_get_lang dictionary_id="58497.Pozisyon"></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id="39288.Hakedilen"></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id="32551.Kullanılan"></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id="58444.Kalan"></th>
		</tr>
	</thead>
	<tbody>
	<cfif get_employees.recordcount>
	<cfoutput query="get_employees" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfset free_time_cmp = createObject("component","V16.myhome.cfc.free_time")>
		<cfset calc_var_query = free_time_cmp.CALC_FREE_TIME(employee_id:employee_id)>
		<tr>
			<td>#currentrow#</td>
			<td>#employee_no#</td>
			<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
			<td>#BRANCH_NAME#</td>
			<td>
				<cfif listlen(HIERARCHY_DEP_ID,'.') gt 1>
					<cfset up_dep = ListGetAt(HIERARCHY_DEP_ID,evaluate("#listlen(HIERARCHY_DEP_ID,".")#-1"),".")>
					<cfset sira_ = listfind(dept_id_list,up_dep)>
					#listgetat(dept_list,sira_,'*')#
				</cfif>
			</td>
			<td>#DEPARTMENT_HEAD#</td>
			<td>#POSITION_CAT#</td>
			<td>#POSITION_NAME#</td>
			<td style="text-align:right;">#wrk_round(calc_var_query.FM_DAY)#</td>
			<td style="text-align:right;">#wrk_round(calc_var_query.used_days)#</td>
			<td style="text-align:right;">#wrk_round(calc_var_query.unused_days)#</td>
		</tr>
	</cfoutput>
	</cfif>
</tbody>
</cf_grid_list>
<cfif attributes.totalrecords gt attributes.maxrows>
    <cfset adres="report.free_time_report">
    <cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
        <cfset adres = "#adres#&comp_id=#attributes.comp_id#">
    </cfif> 
    <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
        <cfset adres = "#adres#&branch_id=#attributes.branch_id#">
    </cfif>
    <cfif isdefined("attributes.form_submitted")>
        <cfset adres = "#adres#&form_submitted=#attributes.form_submitted#" >
    </cfif>
	<cfif isdefined("attributes.keyword")>
        <cfset adres = "#adres#&keyword=#attributes.keyword#" >
    </cfif>
    <cfif isdefined("attributes.department_id") and len(attributes.department_id)>
        <cfset adres="#adres#&department_id=#attributes.department_id#">
    </cfif>
    <cf_paging page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="#adres#">
</cfif>
</cf_box>
<script type="text/javascript">
	function kontrol()
	{
		if(document.form.is_excel.checked==false)
		{
			document.form.action="<cfoutput>#request.self#?fuseaction=report.free_time_report</cfoutput>";
			return true;
		
		}
		else
		{
			document.form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_free_time_report</cfoutput>";
		}
	}
</script>
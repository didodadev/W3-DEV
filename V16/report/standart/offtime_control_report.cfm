<!---
File: 
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date:24.01.2020
Description: İzin listesi
Controller: -
Description: İzin raporudur
--->
<cf_xml_page_edit fuseact='report.offtime_control_report'>
<cfset cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps")>
<cfset cmp_org_step.dsn = dsn>
<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfset get_employee_shift = createObject("component","V16.hr.cfc.get_employee_shift")>
<cfset offtime_control = createObject("component","V16.hr.cfc.get_offtime_calc_control")>
<cfparam name="attributes.startdate" default="1/#month(now())#/#session.ep.period_year#">
<cfparam name="attributes.finishdate" default="#bu_ay_sonu#/#month(now())#/#session.ep.period_year#">
<cf_date tarih='attributes.startdate'>
<cf_date tarih='attributes.finishdate'>
<cfparam name='attributes.process_stage' default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.titles" default="">
<cfparam name="attributes.position_cats" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.offtime_cat" default="">

<cfset genel_izin_toplam = 0>
<cfset genel_dk_toplam = 0>
<cfset kisi_izin_toplam = 0>
<cfset kisi_izin_sayilmayan = 0>

<cffunction name="GET_OFFTIME" access="public" returntype="query">
    <cfargument name="startdate" default="">
    <cfargument name="finishdate" default="">
    <cfargument name="employee_list" default="">
    <cfargument name="process_stage" default="">
    <cfargument name="position_cat_id" default="">
    <cfargument name="offtime_cat" default="">
    <cfquery name="GET_OFFTIME" datasource="#dsn#">
        SELECT 
            OFFTIME.*,
			EMPLOYEES.EMPLOYEE_NO,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
            EMPLOYEE_POSITIONS.POSITION_NAME,
            EMPLOYEE_POSITIONS.POSITION_CAT_ID,
            SETUP_POSITION_CAT.POSITION_CAT,
            IN_OUT_TABLE.BRANCH_NAME,
            IN_OUT_TABLE.DEPARTMENT_HEAD,
            SETUP_OFFTIME.OFFTIMECAT,
			SETUP_OFFTIME.IS_PAID,
            PROCESS_TYPE_ROWS.STAGE,
			SETUP_OFFTIME.EBILDIRGE_TYPE_ID,
			SETUP_OFFTIME.CALC_CALENDAR_DAY,
            SO2.OFFTIMECAT SUB_OFFTIMECAT,
            ST.TITLE,
            IN_OUT_TABLE.HIERARCHY_DEP_ID AS HIERARCHY_DEP_ID1,
            CASE 
                WHEN EMPLOYEES.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE START_DATE <= GETDATE() AND (FINISH_DATE >= GETDATE() OR FINISH_DATE IS NULL))
            THEN	
                IN_OUT_TABLE.HIERARCHY_DEP_ID
            ELSE 
                CASE WHEN 
                    IN_OUT_TABLE.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID))
                THEN
                    (SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = IN_OUT_TABLE.DEPARTMENT_ID AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC)
                ELSE
                    IN_OUT_TABLE.HIERARCHY_DEP_ID
                END
            END AS HIERARCHY_DEP_ID,
            (SELECT TOP 1 IS_VARDIYA FROM EMPLOYEES_IN_OUT WHERE EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID ORDER BY IS_VARDIYA DESC) IS_VARDIYA
        FROM 
            OFFTIME
				INNER JOIN EMPLOYEES ON OFFTIME.EMPLOYEE_ID =  EMPLOYEES.EMPLOYEE_ID
				INNER JOIN SETUP_OFFTIME ON SETUP_OFFTIME.OFFTIMECAT_ID =  OFFTIME.OFFTIMECAT_ID
				LEFT JOIN SETUP_OFFTIME SO2 ON SO2.OFFTIMECAT_ID =  OFFTIME.SUB_OFFTIMECAT_ID
				LEFT JOIN
				(
					SELECT
						BRANCH.BRANCH_NAME,
						EMPLOYEES_IN_OUT.IN_OUT_ID,
						EMPLOYEES_IN_OUT.BRANCH_ID,
						DEPARTMENT.DEPARTMENT_HEAD,
						DEPARTMENT.HIERARCHY_DEP_ID,
						DEPARTMENT.DEPARTMENT_ID,
						BRANCH.COMPANY_ID
					FROM
						EMPLOYEES_IN_OUT 
						INNER JOIN BRANCH ON EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
						INNER JOIN DEPARTMENT ON EMPLOYEES_IN_OUT.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
				) IN_OUT_TABLE ON OFFTIME.IN_OUT_ID = IN_OUT_TABLE.IN_OUT_ID
				LEFT JOIN PROCESS_TYPE_ROWS ON PROCESS_TYPE_ROWS.PROCESS_ROW_ID = OFFTIME.OFFTIME_STAGE
				LEFT JOIN EMPLOYEE_POSITIONS ON EMPLOYEE_POSITIONS.EMPLOYEE_ID = OFFTIME.EMPLOYEE_ID AND EMPLOYEE_POSITIONS.IS_MASTER = 1
                LEFT JOIN SETUP_TITLE ST ON EMPLOYEE_POSITIONS.TITLE_ID = ST.TITLE_ID
				LEFT JOIN SETUP_POSITION_CAT ON SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID
        WHERE 
            (
                (
                    OFFTIME.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#">  AND
                    OFFTIME.STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.finishdate)#">
                )
            OR
                (
                    OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                    OFFTIME.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
                )
            OR
                (
                    OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
                    OFFTIME.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                )
            )
            <cfif len(arguments.employee_list)>
                AND OFFTIME.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_list#" list="yes">)
            </cfif>
            <cfif len(arguments.offtime_cat)>
                AND (
                    OFFTIME.OFFTIMECAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.offtime_cat#">)
                    OR OFFTIME.SUB_OFFTIMECAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.offtime_cat#">)
                    )
            </cfif>
            <cfif len(arguments.process_stage)>
                AND OFFTIME.OFFTIME_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#" list="yes">)
            </cfif>
            <cfif len(attributes.position_cats)>
                AND EMPLOYEE_POSITIONS.POSITION_CAT_ID  IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#attributes.position_cats#">)
            </cfif>
            <cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
                AND IN_OUT_TABLE.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">)
            </cfif>
            <cfif len(attributes.branch_id)>
                AND IN_OUT_TABLE.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
            </cfif>
            <cfif not session.ep.ehesap>
                AND IN_OUT_TABLE.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
                AND IN_OUT_TABLE.COMPANY_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
            </cfif>
            <cfif isdefined('attributes.department') and len(attributes.department)>
                AND IN_OUT_TABLE.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#" list = "yes">)
            </cfif>
			<cfif len(attributes.titles)>
                AND EMPLOYEE_POSITIONS.TITLE_ID IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#attributes.titles#">)
            </cfif>	
        ORDER BY FINISHDATE DESC
    </cfquery>
    <cfreturn GET_OFFTIME>
</cffunction>
<cfquery name="GET_OFFTIME_CATS" datasource="#DSN#">
    SELECT 
        SO.OFFTIMECAT,
        SO.OFFTIMECAT_ID,
        CASE 
            WHEN ISNULL(SO.UPPER_OFFTIMECAT_ID,0) <> 0 THEN SO.UPPER_OFFTIMECAT_ID
            WHEN ISNULL(SO.UPPER_OFFTIMECAT_ID,0) = 0 THEN SO.OFFTIMECAT_ID
        END AS NEW_CAT_ID,
        SO.UPPER_OFFTIMECAT_ID,
        SO2.OFFTIMECAT UPPER_OFFTIMECAT
    FROM 
        SETUP_OFFTIME SO
        LEFT JOIN SETUP_OFFTIME SO2 ON SO2.OFFTIMECAT_ID = SO.UPPER_OFFTIMECAT_ID
    ORDER BY
        NEW_CAT_ID,
        SO.OFFTIMECAT_ID
</cfquery>
<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%ehesap.offtimes%">
</cfquery>
<cfquery name="get_emp_branch" datasource="#DSN#">
	SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfquery name="get_department" datasource="#dsn#">
    SELECT * FROM DEPARTMENT WHERE <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>BRANCH_ID IN(#attributes.branch_id#)<cfelse>1=0</cfif> AND DEPARTMENT_STATUS =1 AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfinclude template="../../assetcare/query/get_positions_cats.cfm">
<cfset emp_branch_list=valuelist(get_emp_branch.branch_id)>
<cfscript>
	cmp = createObject("component","V16.hr.cfc.get_our_company");
	cmp.dsn = dsn;
	get_our_company = cmp.get_company(is_control : 1);
	cmp_branch = createObject("component","V16.hr.cfc.get_branches");
	cmp_branch.dsn = dsn;
	get_branches = cmp_branch.get_branch(ehesap_control : 1);
    cmp_title = createObject("component","V16.hr.cfc.get_titles");
	cmp_title.dsn = dsn;
	titles = cmp_title.get_title();
</cfscript>
<cfquery name="get_branch" dbtype="query">
    SELECT BRANCH_ID,BRANCH_NAME FROM get_branches WHERE <cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
            COMPANY_ID IN(#attributes.comp_id#) 
            <cfif not session.ep.ehesap>
                AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
            </cfif>
        <cfelse>
            1=0
        </cfif> ORDER BY BRANCH_NAME
</cfquery>
<cfif isdefined("attributes.is_submit")>
    <cfset GET_OFFTIMES = GET_OFFTIME(
        startdate : len(attributes.startdate) ? "#attributes.startdate#" : "",
        finishdate :  len(attributes.finishdate) ? "#attributes.finishdate#" : "",
        employee_list : "",
        process_stage : len(attributes.process_stage) ? "#attributes.process_stage#" : "",
        offtime_cat : len(attributes.offtime_cat) ? "#attributes.offtime_cat#" : ""
    )>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_OFFTIMES.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
</cfif>
<cfsavecontent variable = "title"><cf_get_lang dictionary_id="31157.İzin Raporu"></cfsavecontent>
<cfform name="search_scale" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
	<cf_report_list_search title="#title#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç tarihi'> * </label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.başlangıç tarihi girmelisiniz'></cfsavecontent>
                                                <cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.startdate,dateformat_style)#">                                                    
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş tarihi'> * </label>
                                    <div class="col col-12 col-md-12 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.bitiş tarihi girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">                                                    
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='54109.İzin Kategorisi'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <cf_multiselect_check
                                                query_name = "GET_OFFTIME_CATS"
                                                table_name="SETUP_OFFTIME"  
                                                name="offtime_cat"
                                                width="150" 
                                                option_name="OFFTIMECAT" 
                                                option_value="OFFTIMECAT_ID">
                                            <!--- <select name="offtime_cat" id="offtime_cat" style="width:110px;">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <cfoutput query="GET_OFFTIME_CATS">
                                                    <option value="#OFFTIMECAT_ID#" <cfif isdefined("attributes.offtime_cat") and attributes.offtime_cat eq OFFTIMECAT_ID >selected</cfif>><cfif len(UPPER_OFFTIMECAT)>#UPPER_OFFTIMECAT# - </cfif>#OFFTIMECAT#</option>
                                                </cfoutput>
                                            </select> --->
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <cf_multiselect_check 
                                                query_name="get_process_stage"  
                                                name="process_stage"
                                                value="#attributes.process_stage#"  
                                                width="150" 
                                                height="100"
                                                option_value="process_row_id"
                                                option_name="stage">
                                        </div>
                                    </div>
                                </div>
                            </div>    
                        </div>
                        <div class="row" type="row">
                            <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">

                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29531.Şirketler'></label>
                                        <div class="multiselect-z2">
                                            <cf_multiselect_check 
                                            query_name="get_our_company"  
                                            name="comp_id"
                                            option_value="COMP_ID"
                                            option_name="company_name"
                                            option_text="#getLang('main',322)#"
                                            value="#attributes.comp_id#"
                                            onchange="get_branch_list(this.value)">
                                        </div>					
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                        <div id="BRANCH_PLACE">
                                            <cf_multiselect_check 
                                            query_name="get_branch"  
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
                            <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                                        <div id="DEPARTMENT_PLACE">
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
                                <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                                    <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
                                        <div class="col col-12 col-xs-12">
                                            <cf_multiselect_check 
                                                query_name="titles"  
                                                name="titles"
                                                value="#attributes.titles#"  
                                                width="150" 
                                                height="100"
                                                option_value="title_id"
                                                option_name="title">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row" type="row">
                            <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">										  
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
                                        <div class="col col-12 col-xs-12">
                                            <cf_multiselect_check 
                                                query_name="get_position_cats"
                                                value="#attributes.position_cats#"  
                                                name="position_cats"
                                                width="150" 
                                                height="100"
                                                option_value="position_cat_id"
                                                option_name="position_cat">
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
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
							<input name="is_submit" id="is_submit" value="1" type="hidden">
							<cf_wrk_report_search_button button_type='1' is_excel='1' search_function="kontrol()">
						</div>
					</div>
                </div>
            </div>
        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
<cfif isdefined("attributes.is_submit")>
    <cfif attributes.is_excel eq 1>
        <cfset attributes.startrow=1>
        <cfset attributes.maxrows=GET_OFFTIMES.recordcount>	
        <cfset type_ = 1>
        <cfset filename = "#createuuid()#">
        <cfheader name="Expires" value="#Now()#">
        <cfcontent type="application/vnd.msexcel;charset=utf-16">
        <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-16">
    <cfelse>
        <cfset type_ = 0>
    </cfif>	
</cfif>


<cfquery name="GET_GENERAL_OFFTIMES" datasource="#dsn#">
	SELECT START_DATE,FINISH_DATE,IS_HALFOFFTIME FROM SETUP_GENERAL_OFFTIMES
</cfquery>
<cfset offday_list_ = ''>
<cfset halfofftime_list = ''><!--- yarım gunluk izin kayıtları--->
<cfset halfofftime_list2 = ''>
<cfset halfofftime_list3 = ''>
<cfoutput query="GET_GENERAL_OFFTIMES">
	<cfscript>
		offday_gun = datediff('d',GET_GENERAL_OFFTIMES.start_date,GET_GENERAL_OFFTIMES.finish_date)+1;
		offday_startdate = date_add("h", session.ep.time_zone, GET_GENERAL_OFFTIMES.start_date); 
		offday_finishdate = date_add("h", session.ep.time_zone, GET_GENERAL_OFFTIMES.finish_date);
		for (mck=0; mck lt offday_gun; mck=mck+1)
		{
			temp_izin_gunu = date_add("d",mck,offday_startdate);
			daycode = '#dateformat(temp_izin_gunu,dateformat_style)#';
			if(not listfindnocase(offday_list_,'#daycode#'))
			offday_list_ = listappend(offday_list_,'#daycode#');
			if(GET_GENERAL_OFFTIMES.is_halfofftime is 1 and dayofweek(temp_izin_gunu) neq 1) //pazar haricindeki yarım günlük izin günleri sayılsın
			{
				halfofftime_list = listappend(halfofftime_list,'#daycode#');
			}
		}
		
	</cfscript>
</cfoutput>	

<cfquery name="get_hours" datasource="#dsn#">
	SELECT		
		OUR_COMPANY_HOURS.*
	FROM
		OUR_COMPANY_HOURS
	WHERE
		OUR_COMPANY_HOURS.DAILY_WORK_HOURS > 0 AND
		OUR_COMPANY_HOURS.SSK_MONTHLY_WORK_HOURS > 0 AND
		OUR_COMPANY_HOURS.SSK_WORK_HOURS > 0 AND
		OUR_COMPANY_HOURS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfif len(get_hours.recordcount) and len(get_hours.weekly_offday)>
	<cfset this_week_rest_day_ = get_hours.weekly_offday>
<cfelse>
	<cfset this_week_rest_day_ = 1>
</cfif>

<cfquery name="get_work_time" datasource="#dsn#">
SELECT 
	PROPERTY_VALUE,
	PROPERTY_NAME
FROM
	FUSEACTION_PROPERTY
WHERE
	OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
	FUSEACTION_NAME = 'ehesap.form_add_offtime_popup' AND
	(PROPERTY_NAME = 'start_hour_info' OR
	PROPERTY_NAME = 'start_min_info' OR
	PROPERTY_NAME = 'finish_hour_info' OR
	PROPERTY_NAME = 'finish_min_info' OR
	PROPERTY_NAME = 'finish_am_hour_info' OR
	PROPERTY_NAME = 'finish_am_min_info' OR
	PROPERTY_NAME = 'start_pm_hour_info' OR
	PROPERTY_NAME = 'start_pm_min_info' OR
	PROPERTY_NAME = 'x_min_control'
	)	
</cfquery>
<cfif get_work_time.recordcount>
<cfloop query="get_work_time">	
	<cfif PROPERTY_NAME eq 'start_hour_info'>
		<cfset start_hour = PROPERTY_VALUE>
	<cfelseif PROPERTY_NAME eq 'start_min_info'>
		<cfset start_min = PROPERTY_VALUE>
	<cfelseif PROPERTY_NAME eq 'finish_hour_info'>
		<cfset finish_hour = PROPERTY_VALUE>
	<cfelseif PROPERTY_NAME eq 'finish_min_info'>
		<cfset finish_min = PROPERTY_VALUE>
	<cfelseif PROPERTY_NAME eq 'finish_am_hour_info'>
		<cfset finish_am_hour = PROPERTY_VALUE>
	<cfelseif PROPERTY_NAME eq 'finish_am_min_info'>
		<cfset finish_am_min = PROPERTY_VALUE>
	<cfelseif PROPERTY_NAME eq 'start_pm_hour_info'>
		<cfset start_pm_hour = PROPERTY_VALUE>
	<cfelseif PROPERTY_NAME eq 'start_pm_min_info'>
		<cfset start_pm_min = PROPERTY_VALUE>
	<cfelseif PROPERTY_NAME eq 'x_min_control'>
		<cfset x_min_control = PROPERTY_VALUE>
	</cfif>
</cfloop>
<cfelse>
<cfset start_hour = '00'>
<cfset start_min = '00'>
<cfset finish_hour = '00'>
<cfset finish_min = '00'>
<cfset finish_am_hour = '00'>
<cfset finish_am_min = '00'>
<cfset start_pm_hour = '00'>
<cfset start_pm_min = '00'>
<cfset x_min_control = 0>
</cfif>	
<cfif not isdefined("x_min_control")>
	<cfset x_min_control = 0>
</cfif>
<cfif isdefined("attributes.is_submit")>
<cf_report_list id="report_table">
        <thead>
            <tr>
                <th width="25"><cf_get_lang dictionary_id='58577.Sira'></th>
				<th><cf_get_lang dictionary_id='56542.Sicil No'></th>
                <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                <th><cf_get_lang dictionary_id='57453.Şube'></th>
                <th><cf_get_lang dictionary_id='35449.Departman'></th>
                <th><cf_get_lang dictionary_id='57571.Ünvan'></th>
                <th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
                <th><cf_get_lang dictionary_id='60780.Üst İzin Kategorisi'></th>
                <th><cf_get_lang dictionary_id='54109.İzin Kategorisi'></th>
				<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                <th><cf_get_lang dictionary_id='58859.Süreç'></th>
                <th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th> 
                <th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
				<th width="15"><cf_get_lang dictionary_id="57490.Gün"></th>
                <cfif x_min_control eq 1><th width="30"><cf_get_lang dictionary_id="57491.Saat"></th></cfif>
                <th><cf_get_lang dictionary_id='53036.İzinde Geçirilecek Adres'></th>
                <th><cf_get_lang dictionary_id='56638.Kalan İzin'></th>
                <cfif isDefined("x_show_level") and x_show_level eq 1><th><cf_get_lang dictionary_id='62040.Kademeli Departman'></th></cfif>
            </tr>
            <cfif x_min_control eq 1>
                <cfset colspan_ = 16>
            <cfelse>
                <cfset colspan_ = 15>
            </cfif>
        </thead>
        <tbody>
            <cfif GET_OFFTIMES.recordcount>
                <cfoutput query = "GET_OFFTIMES" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <tr>
                        <td>#currentrow#</td>
						<td>#EMPLOYEE_NO#</td>
                        <td>#employee_name# #employee_surname#</td>
                        <td>#BRANCH_NAME#</td>
                        <td>#DEPARTMENT_HEAD#</td>
                        <td>#title#</td>
                        <td>#position_cat#</td>
                        <td>#OFFTIMECAT#</td>
                        <td>#SUB_OFFTIMECAT#</td>
						<td>#DETAIL#</td>
                        <td>#STAGE#</td>
                        <td>#dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,startdate),timeformat_style)#)</td>
                        <td>#dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,finishdate),timeformat_style)#)</td>
						<td>
							<cfquery name="get_emp_group_ids" datasource="#dsn#">
								SELECT
									E.EMPLOYEE_ID,
									(SELECT TOP 1 PUANTAJ_GROUP_IDS FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ORDER BY START_DATE DESC) AS PUANTAJ_GROUP_IDS
								FROM
									EMPLOYEES E
								WHERE
									E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#employee_id#">
							</cfquery>
							<cfquery name="get_puantaj_group_id" dbtype="query">
								SELECT PUANTAJ_GROUP_IDS FROM get_emp_group_ids WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">
							</cfquery>
							<cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
								SELECT LIMIT_ID,SATURDAY_ON,DAY_CONTROL,DAY_CONTROL_AFTERNOON,SUNDAY_ON,PUBLIC_HOLIDAY_ON FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> AND
								<cfif len(get_puantaj_group_id.PUANTAJ_GROUP_IDS)>
									(
									<cfloop from="1" to="#listlen(get_puantaj_group_id.puantaj_group_ids)#" index="i">
										','+PUANTAJ_GROUP_IDS+',' LIKE '%,#listgetat(get_puantaj_group_id.PUANTAJ_GROUP_IDS,i,',')#,%' <cfif listlen(get_puantaj_group_id.PUANTAJ_GROUP_IDS) neq i>OR</cfif> 
									</cfloop>
								)
								<cfelse>
									PUANTAJ_GROUP_IDS IS NULL
								</cfif>
							</cfquery>
							<!--- Çalışanın vardiyalı çalışma saatleri --->
                            <cfset finishdate_ = dateadd("d", 1, finishdate)>
							<cfset get_shift = get_employee_shift.get_emp_shift(employee_id : employee_id, start_date : startdate, finish_date : finishdate_)>
							<cfif get_offtime_cat.recordcount and len(get_offtime_cat.saturday_on)>
								<cfset saturday_on = get_offtime_cat.saturday_on>
							<cfelse>
								<cfset saturday_on = 1>
							</cfif>
							<cfif get_offtime_cat.recordcount and len(get_offtime_cat.day_control)>
								<cfset day_control_ = get_offtime_cat.day_control>
							<cfelse>
								<cfset day_control_ = 0>
							</cfif>
							<cfif  get_offtime_cat.recordcount and len(get_offtime_cat.day_control)>
								<cfset day_control_afternoon = get_offtime_cat.day_control_afternoon>
							<cfelse>
								<cfset day_control_afternoon = 0>
							</cfif>
							<cfif  get_offtime_cat.recordcount and len(get_offtime_cat.day_control)>
								<cfset day_control = get_offtime_cat.day_control>
							<cfelse>
								<cfset day_control = 0>
							</cfif>
							<cfif get_offtime_cat.recordcount and len(get_offtime_cat.sunday_on)>
								<cfset sunday_on = get_offtime_cat.sunday_on>
							<cfelse>
								<cfset sunday_on = 0>
							</cfif>
							<cfif get_offtime_cat.recordcount and len(get_offtime_cat.public_holiday_on)>
								<cfset public_holiday_on = get_offtime_cat.public_holiday_on>
							<cfelse>
								<cfset public_holiday_on = 0>
							</cfif>
							<!--- İzin Hesapları bu dosyada yapılıyor ---->
							
                            <cfif x_min_control eq 1>
                                <cfif get_shift.recordcount>
                                    <cfinclude template="/V16/hr/ehesap/display/offtime_calc_shift.cfm">
                                <cfelse>
                                    <cfinclude template="../../hr/ehesap/display/offtime_calc.cfm">
                                </cfif>
                                #TLFormat(total_day_calc,2)# 
                            <cfelse>
                                <cfif get_shift.recordcount gt 0 and IS_VARDIYA eq 2>
                                    <cfif len(get_shift.WEEK_OFFDAY)>
                                        <cfset this_week_rest_day_ = get_shift.WEEK_OFFDAY>
                                    <cfelse>
                                        <cfset this_week_rest_day_ = 1>
                                    </cfif>
                                <cfelse>
                                    <cfset this_week_rest_day_ = this_week_rest_day_>
                                </cfif>
                                <cfinclude template="../../hr/ehesap/display/offtime_calc_day.cfm">
                                #izin_gun# 
                            </cfif>
						</td>
                        <cfif x_min_control eq 1>
                            <td  align="center">
                                <cfsavecontent variable = "day">
                                    <cf_get_lang dictionary_id ="57490.Gün">
                                </cfsavecontent>
                                <cfsavecontent variable = "hour">
                                    <cf_get_lang dictionary_id ="57491.Saat">
                                </cfsavecontent>
                                <cfsavecontent variable = "min">
                                    <cf_get_lang dictionary_id ="58827.Dk">
                                </cfsavecontent>
                                <cfif days neq 0>#days##left(day,1)# </cfif>
                                <cfif hours neq 0>#hours##left(hour,1)# </cfif>
                                <cfif minutes neq 0>#minutes##min# </cfif>
                            </td>
                        </cfif>
                        <td>#ADDRESS#</td>
                        <td>#offtime_control.get_hakedis(employee_id : employee_id, talep_tarihi : len(startdate) ? startdate : now())#</td>
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
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="<cfoutput>#colspan_#</cfoutput>"><cfif isdefined('attributes.is_submit') and GET_OFFTIMES.recordcount eq 0><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                </tr>
            </cfif>
        </tbody>
</cf_report_list>
<cfset adres="#attributes.fuseaction#&is_submit=1">
<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
    <cfset adres="#adres#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
    <cfset adres="#adres#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
</cfif>
<cfif isdefined("attributes.titles") and len(attributes.titles)>
    <cfset adres="#adres#&titles=#attributes.titles#">
</cfif>
<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
    <cfset adres="#adres#&branch_id=#attributes.branch_id#">
</cfif>
<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
    <cfset adres="#adres#&comp_id=#attributes.comp_id#">
</cfif>
<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
    <cfset adres="#adres#&process_stage=#attributes.process_stage#">
</cfif>
<cfif isdefined("attributes.position_cats") and len(attributes.position_cats)>
    <cfset adres="#adres#&position_cats=#attributes.position_cats#">
</cfif>
<cfif isdefined("attributes.offtime_cat") and len(attributes.offtime_cat)>
    <cfset adres="#adres#&offtime_cat=#attributes.offtime_cat#">
</cfif>
<cfif isdefined("attributes.is_submit") and attributes.totalrecords gt attributes.maxrows>
    <cf_paging
        page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="#adres#">
</cfif>
</cfif>
<script type="text/javascript">
function kontrol()	
{
    
	if(document.search_scale.is_excel.checked==false)
			{
				document.search_scale.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.offtime_control_report"
				return true;
			}
			else{
				document.search_scale.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_offtime_control_report</cfoutput>"}
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
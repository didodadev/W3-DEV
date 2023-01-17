<cfsetting showdebugoutput="no">
<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">

<cfset dashboard_cmp = createObject("component","V16.hr.cfc.health_dashboard") />
<cfset get_period_years = dashboard_cmp.GET_PERIOD_YEARS() />

<cfparam name="attributes.employee_name" default="" />
<cfparam name="attributes.employee_id" default="" />
<cfparam name="attributes.in_out_id" default="" />
<cfparam name="attributes.assurance_id" default="" />
<cfparam name="attributes.relative_level" default="" />
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.period_year" default="#year(now())#">

<cfset cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps")>
<cfset cmp_org_step.dsn = dsn>

<cfset HealthExpense= createObject("component","V16.myhome.cfc.health_expense") />
<cfset get_assurance = HealthExpense.GetAssurance() />

<cfset relative_name_list = "#getLang(dictionary_id:31962)#,#getLang(dictionary_id:31963)#,
                            #getLang(dictionary_id:31329)#,#getLang(dictionary_id:31330)#,
                            #getLang(dictionary_id:31331)#,#getLang(dictionary_id:31449)#">

<cfif len(attributes.employee_id) and find("_", attributes.employee_id) neq 0>
    <cfset attributes.employee_id = listfirst(attributes.employee_id,'_')>
</cfif>

<cfif isdefined('attributes.is_form_submit')>
    <cfset dsn2_new = "#dsn#_#attributes.period_year#_#session.ep.company_id#">
    <cfquery name="get_data" datasource="#dsn2_new#">
        SELECT
            XT.*,
            E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMP_FULLNAME,
            E.EMPLOYEE_NO,
            ER.RELATIVE_LEVEL,
            ER.NAME + ' ' + ER.SURNAME AS REL_FULLNAME,
            SHAT.ASSURANCE,
            ISNULL(SHATS.MIN,0) AS MIN,
            ISNULL(SHATS.MAX,9999999) AS MAX,
            SHATS.RATE,
            D.HIERARCHY_DEP_ID AS HIERARCHY_DEP_ID1,
            D.DEPARTMENT_HEAD,
            B.BRANCH_NAME,
            CASE 
                WHEN E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM #dsn#.EMPLOYEES_IN_OUT WHERE START_DATE <= GETDATE() AND (FINISH_DATE >= GETDATE() OR FINISH_DATE IS NULL))
            THEN	
                D.HIERARCHY_DEP_ID
            ELSE 
                CASE WHEN 
                    D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn#.DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM #dsn#.EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID))
                THEN
                    (SELECT TOP 1 HIERARCHY_DEP_ID FROM #dsn#.DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D.DEPARTMENT_ID AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM #dsn#.EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC)
                ELSE
                    D.HIERARCHY_DEP_ID
                END
            END AS HIERARCHY_DEP_ID
        FROM
            (
                SELECT 
                    EMP_ID,
                    ASSURANCE_ID,
                    TREATED,
                    RELATIVE_ID,
                    SUM(NET_TOTAL_AMOUNT) AS NET_TOTAL_AMOUNT
                FROM
                    EXPENSE_ITEM_PLAN_REQUESTS
                WHERE
                    TREATED IS NOT NULL AND
                    IS_APPROVE = 1
                    <cfif len(attributes.employee_name) and len(attributes.employee_id)>
                        AND EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
                    </cfif>
                    <cfif len(attributes.assurance_id)>
                        AND ASSURANCE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assurance_id#" list="true">)
                    </cfif>
                GROUP BY
                    EMP_ID,
                    TREATED,
                    RELATIVE_ID,
                    ASSURANCE_ID
            ) XT
            LEFT JOIN #dsn#.EMPLOYEES E ON E.EMPLOYEE_ID = XT.EMP_ID
            LEFT JOIN #dsn#.EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
            LEFT JOIN #dsn#.DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
            LEFT JOIN #dsn#.BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
            LEFT JOIN #dsn#.EMPLOYEES_RELATIVES ER ON ER.RELATIVE_ID = XT.RELATIVE_ID
            LEFT JOIN #dsn#.SETUP_HEALTH_ASSURANCE_TYPE SHAT ON SHAT.ASSURANCE_ID = XT.ASSURANCE_ID
            LEFT JOIN #dsn#.SETUP_HEALTH_ASSURANCE_TYPE_SUPPORT SHATS ON SHATS.ASSURANCE_ID = SHAT.ASSURANCE_ID
        WHERE
            SHAT.IS_ACTIVE = 1 AND
            SHATS.IS_ACTIVE = 1 AND
            XT.NET_TOTAL_AMOUNT > ISNULL(SHATS.MIN,0)
            <cfif len(attributes.relative_level)>
                <cfif attributes.relative_level eq -1>
                    AND XT.TREATED = 1
                    AND (XT.RELATIVE_ID IS NULL OR XT.RELATIVE_ID = 0)
                    AND ER.RELATIVE_LEVEL IS NULL
                <cfelse>
                    AND XT.TREATED = 2
                    AND XT.RELATIVE_ID IS NOT NULL
                    AND ER.RELATIVE_LEVEL = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.relative_level#">
                </cfif>
            </cfif>
        ORDER BY
            XT.EMP_ID,
            XT.TREATED,
            XT.RELATIVE_ID,
            XT.ASSURANCE_ID,
            ISNULL(SHATS.MIN,0)
    </cfquery>
<cfelse>
	<cfset get_data.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_data.recordcount#">
<cfsavecontent variable="head"><cf_get_lang dictionary_id='61425.Sağlık Limit Raporu'></cfsavecontent>
<cfform name="search_form" method="post" action="#request.self#?fuseaction=report.health_expense_limits">
    <cf_report_list_search title="#head#">
        <cf_report_list_search_area>
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="col col-3 col-md-6 col-xs-12">
                            <div class="form-group" id="item-employee">
                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57576.Çalışan"></label>
                                <div class="col col-12 col-xs-12">
                                    <div class="input-group">
                                        <cf_wrk_employee_in_out
                                            form_name="search_form"
                                            emp_id_fieldname="employee_id"
                                            in_out_id_fieldname="in_out_id"
                                            emp_id_value="#attributes.employee_id#"
                                            in_out_value="#attributes.in_out_id#"
                                            emp_name_fieldname="employee_name"
                                            call_function = "get_deserve_date()">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-6 col-xs-12">
                            <div class="form-group" id="item-assurance_type">
                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="58689.Teminat"><cf_get_lang dictionary_id="38937.Tipi"></label>
                                <div class="col col-12 col-xs-12">
                                    <cf_multiselect_check
                                        name="assurance_id"
                                        option_name="ASSURANCE"
                                        option_value="assurance_id"
                                        width="130"
                                        value="#attributes.assurance_id#"
                                        query_name="get_assurance">
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-6 col-xs-12">
                            <div class="form-group" id="item-relative">
                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id = "53143.Yakınlığı"></label>
                                <div class="col col-12 col-xs-12">
                                    <select name="relative_level" id="relative_level">
                                        <option value=""><cf_get_lang dictionary_id = "57734.Seçiniz"></option>
                                        <option value="-1" <cfif attributes.relative_level eq -1>selected</cfif>><cf_get_lang dictionary_id = "40429.Kendisi"></option>
                                        <cfloop list="#relative_name_list#" item="name" index="i">
                                            <cfoutput>
                                                <option value="#i#" <cfif attributes.relative_level eq i>selected</cfif>>#name#</option>
                                            </cfoutput>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-6 col-xs-12">
                            <div class="form-group">
                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="58455.Yıl"></label>
                                <div class="col col-12 col-xs-12">
                                    <select name="period_year" id="period_year">
                                        <cfoutput query="get_period_years">
                                            <option value="#PERIOD_YEAR#" <cfif PERIOD_YEAR eq attributes.period_year>selected</cfif>>#PERIOD_YEAR#</option>
                                        </cfoutput>
                                    </select>
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
                            <input type="hidden" name="is_form_submit" id="is_form_submit" value="1">
                            <cf_wrk_report_search_button button_type='1' is_excel='1' search_function="control()">
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
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">
<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.is_form_submit")>
    <cf_report_list>
        <cfif attributes.is_excel eq 1>
            <cfset type_ = 1>
            <cfset attributes.startrow = 1>
            <cfset attributes.maxrows = get_data.recordcount>
        <cfelse>
            <cfset type_ = 0>
        </cfif>
        <thead>
            <tr>
                <!-- sil --> <th width="20"></th> <!-- sil -->
                <th><cf_get_lang dictionary_id = "51231.Sicil No"></th>
                <th><cf_get_lang dictionary_id = "57576.Çalışan"></th>
                <th><cf_get_lang dictionary_id = "57453.Şube"></th>
                <th><cf_get_lang dictionary_id='62040.Kademeli Departman'></th>
                <th><cf_get_lang dictionary_id = "34712.Tedavi Gören"></th>
                <th><cf_get_lang dictionary_id = "53143.Yakınlığı"></th>
                <th><cf_get_lang dictionary_id = "58689.Teminat"><cf_get_lang dictionary_id = "216.Tipi"></th>
                <th><cf_get_lang dictionary_id = "40460.Tutar Aralığı"></th>
                <th><cf_get_lang dictionary_id = "61027.Ödeme Oranı">(%)</th>
                <th><cf_get_lang dictionary_id = "51390.Kullanılan Limit"></th>
                <th><cf_get_lang dictionary_id = "61465.Kalan Limit"></th>
            <tr>
        </thead>
        <tbody>
            <cfif get_data.recordcount>
                <cfoutput query="get_data" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <!-- sil -->
                        <td class="iconL">
                            <a href="javascript:void(0)" id="row#currentrow#"  onclick="gizle_goster(row#currentrow#);connectAjax('#currentrow#','#EMP_ID#','#ASSURANCE_ID#','#len(RELATIVE_ID) ? RELATIVE_ID : -1#');"><i class="fa fa-caret-right"></i></a>
                        </td>
                        <!-- sil -->
                        <td>#EMPLOYEE_NO#</td>
                        <td>#EMP_FULLNAME#</td>
                        <td>#BRANCH_NAME#</td>
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
                        <td>#REL_FULLNAME#</td>
                        <td>
                            <cfif len(RELATIVE_LEVEL) and len(RELATIVE_ID)>
                                #ListGetAt(relative_name_list,RELATIVE_LEVEL)#
                            <cfelse>
                                <cf_get_lang dictionary_id = "40429.Kendisi">
                            </cfif>
                        </td>
                        <td>#ASSURANCE#</td>
                        <td class="text-right">#TLFormat(MIN)# - #TLFormat(MAX)#</td>
                        <td class="text-right">#TLFormat(RATE)#</td>
                        <td class="text-right">
                            <cfif NET_TOTAL_AMOUNT gt MAX>
                                #TLFormat(MAX - MIN)#
                            <cfelse>
                                #TLFormat(NET_TOTAL_AMOUNT - MIN)#
                            </cfif>
                        </td>
                        <td class="text-right">
                            <cfif NET_TOTAL_AMOUNT gt MAX>
                                #TLFormat(0)#
                            <cfelse>
                                #TLFormat(MAX - NET_TOTAL_AMOUNT)#
                            </cfif>
                        </td>
                    </tr>
                    <!-- sil -->
						<tr id="row#currentrow#" class="table_detail">
							<td colspan="20">
								<div align="left" id="DISPLAY_LIMITS_INFO#currentrow#"></div>
							</td>
						</tr>
                    <!-- sil -->
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="12"><cf_get_lang dictionary_id='57484.kayıt yok'>!</td>
                </tr>
            </cfif>
        </tbody>
    </cf_report_list>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "report.health_expense_limits">
	<cfif isdefined('attributes.is_form_submit')>
		<cfset url_str = '#url_str#&is_form_submit=1'>
    </cfif>
    <cfif len(attributes.employee_id)>
        <cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
    </cfif>
    <cfif len(attributes.employee_name)>
        <cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
    </cfif>
    <cfif len(attributes.assurance_id)>
        <cfset url_str = "#url_str#&assurance_id=#attributes.assurance_id#">
    </cfif>
    <cfif len(attributes.relative_level)>
        <cfset url_str = "#url_str#&relative_level=#attributes.relative_level#">
    </cfif>
    <cf_paging 
        page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="#url_str#">
</cfif>
<script type="text/javascript">
    function control() {
        if(document.search_form.is_excel.checked==false){
            document.search_form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
            return true;
        }
        else
            document.search_form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_health_expense_limits</cfoutput>";
    }

    function connectAjax(crtrow, employee_id, assurance_id, relative_id) {
		var load_url_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=report.emptypopup_health_expense_limits_detail&employee_id=' + employee_id + '&assurance_id=' + assurance_id + '&relative_id=' + relative_id;
		AjaxPageLoad(load_url_,'DISPLAY_LIMITS_INFO'+crtrow,1);
	}
</script>
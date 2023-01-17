<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch_name" default="">
<cfparam name="attributes.keyword" default="">
<!--- <cfparam name="attributes.page" default=1> --->
<!--- <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'> --->
<!--- <cfparam name="attributes.totalrecords" default="0"> --->
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
<cfparam name="kvar" default="0">
<!--- <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1> --->
<cfset emp_list="">

<cfquery name="get_branches" datasource="#dsn#">
	SELECT DISTINCT
        COMPANY_ID,RELATED_COMPANY
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
            E.EMPLOYEE_NO,
            EI.TC_IDENTY_NO,
            EMPLOYEES_IN_OUT.IN_OUT_ID,
            EMPLOYEES_IN_OUT.EMPLOYEE_ID,
            EMPLOYEES_IN_OUT.START_DATE,
            EMPLOYEES_IN_OUT.FINISH_DATE,
            EMPLOYEES_IN_OUT.IN_COMPANY_REASON_ID,
            DEPARTMENT.DEPARTMENT_HEAD,
            EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
            EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
            EMPLOYEE_POSITIONS.POSITION_CAT_ID,
            BRANCH.BRANCH_NAME,
            BRANCH.RELATED_COMPANY,
            BRANCH.COMPANY_ID,
            BRANCH.BRANCH_ID,
            DEPARTMENT.DEPARTMENT_ID
        FROM
            EMPLOYEES_IN_OUT,
            EMPLOYEES E,
            EMPLOYEES_IDENTY EI,
            DEPARTMENT,
            BRANCH,
            EMPLOYEE_POSITIONS
        WHERE
            E.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
            EI.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
            EMPLOYEE_POSITIONS.EMPLOYEE_ID=EMPLOYEES_IN_OUT.EMPLOYEE_ID
            AND DEPARTMENT.DEPARTMENT_ID=EMPLOYEES_IN_OUT.DEPARTMENT_ID
            AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
        <!---  <cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and (attributes.branch_id is not 'all')>
                AND BRANCH.BRANCH_ID = #attributes.branch_id#
            </cfif>
            <cfif isdefined('attributes.department') and len(attributes.department)>
                AND DEPARTMENT.DEPARTMENT_ID = #attributes.department#
            </cfif>--->
            <cfif isdefined("attributes.reason_id") and len(attributes.reason_id)>AND EMPLOYEES_IN_OUT.IN_COMPANY_REASON_ID = #attributes.reason_id#</cfif>
            AND (EMPLOYEES_IN_OUT.EXPLANATION_ID IS NULL OR EMPLOYEES_IN_OUT.EXPLANATION_ID = 18)
            <cfif len(attributes.months) AND len(attributes.years)>
                <cfif database_type eq "MSSQL">
                    AND 
                    (DATEPART("mm",EMPLOYEES_IN_OUT.START_DATE)=#attributes.months# 
                    AND DATEPART("yyyy",EMPLOYEES_IN_OUT.START_DATE)=#attributes.years#
                    OR  
                    DATEPART("mm",EMPLOYEES_IN_OUT.FINISH_DATE)=#attributes.months# 
                    AND DATEPART("yyyy",EMPLOYEES_IN_OUT.FINISH_DATE)=#attributes.years#)
                <cfelseif database_type eq "DB2">
                    AND (
                    MONTH(EMPLOYEES_IN_OUT.START_DATE)=#attributes.months#
                    AND YEAR(EMPLOYEES_IN_OUT.START_DATE)=#attributes.years#
                    OR
                    MONTH(EMPLOYEES_IN_OUT.FINISH_DATE)=#attributes.months#
                    AND YEAR(EMPLOYEES_IN_OUT.FINISH_DATE)=#attributes.years#)
                </cfif>
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
        ORDER BY
            IN_OUT_ID DESC
    </cfquery>
    <cfoutput query="get_emp_in_out">
        <cfif not listfind(emp_list,get_emp_in_out.EMPLOYEE_ID)>
            <cfset emp_list=listappend(emp_list,get_emp_in_out.EMPLOYEE_ID)>
        </cfif>
    </cfoutput>
</cfif>
<cfquery datasource="#dsn#" name="fire_reasons">
	SELECT * FROM SETUP_EMPLOYEE_FIRE_REASONS ORDER BY REASON
</cfquery>
<cfinclude template="../../hr/ehesap/query/get_all_departments.cfm">
<cfinclude template="../../hr/ehesap/query/get_conditional_dep.cfm">
<cfsavecontent variable="head"><cf_get_lang dictionary_id='39042.Görev Değişiklikleri Giriş-Çıkış'></cfsavecontent>
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
                                            <div class="col col-12">
                                                <label class="col col-12"><cf_get_lang dictionary_id='38955.İlgili Şirket'></label>
                                                <div class="col col-12">
                                                    <div  class="multiselect-z2">
                                                        <cf_multiselect_check 
                                                        query_name="get_branches"  
                                                        name="company_id"
                                                        option_value="COMPANY_ID"
                                                        option_name="RELATED_COMPANY"
                                                        option_text="#getLang('main',322)#"
                                                        value="#attributes.branch_id#"
                                                        onchange="get_branch_list(this.value)">
                                                    </div>                                                
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="col col-12">
                                                <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
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
                                        </div>
                                    </div>
                                </div>
							</div>
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                                            <div class="col col-12">
                                                <div id="DEPARTMENT_PLACE">
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
                                        <div class="form-group">
                                            <div class="col col-12">
                                                <label class="col col-12"><cf_get_lang dictionary_id="58472.dönem">*</label>
                                                <div class="col col-12 paddingNone">
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
                                        </div>
                                    </div>
                                </div>
                            </div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
                            <input type="hidden" name="is_submitted" id="is_submitted" value="1">
                             <input type="hidden" name="maxrows" id="maxrows" value="#session.ep.maxrows#" />
                             <cf_wrk_report_search_button button_type='1' search_function='kontrol()'>
						</div>
					</div>
				</div>
			</div> 
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif isdefined("attributes.is_submitted")>
    <cf_report_list>
        <thead>
            <tr height="22">
                <th><cf_get_lang dictionary_id='58487.Çalışan No'></th>
                <th><cf_get_lang dictionary_id='58025.TC Kimlik'></th>
                <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                <th width="65"><cf_get_lang dictionary_id='38959.Eski Şube'></th>
                <th width="65"><cf_get_lang dictionary_id='38960.Eski Departman'></th>
                <th width="65"><cf_get_lang dictionary_id='57652.Eski Görev'></th>
                <th width="65"><cf_get_lang dictionary_id='38962.Yeni Şube'></th>
                <th width="65"><cf_get_lang dictionary_id='38963.Yeni Departman'></th>
                <th width="65"><cf_get_lang dictionary_id='38964.Yeni Görev'></th>
                <th width="65"><cf_get_lang dictionary_id='38965.Değişim Tarihi'></th>
                <th width="75"><cf_get_lang dictionary_id='38957.Şirket İçi Gerekçe'></th>
            </tr>
        </thead>
        <tbody>
        </tbody>
            <cfif len(emp_list)>
            <cfloop list="#emp_list#" index="i">
                <cfquery dbtype="query" name="get_emp_old" maxrows="1">
                    SELECT
                        IN_OUT_ID,
                        EMPLOYEE_ID,
                        START_DATE,
                        FINISH_DATE,
                        DEPARTMENT_HEAD,
                        EMPLOYEE_NAME,
                        EMPLOYEE_SURNAME,
                        POSITION_CAT_ID,
                        IN_COMPANY_REASON_ID,
                        BRANCH_NAME,
                        BRANCH_ID
                    FROM
                        get_emp_in_out
                    WHERE
                        EMPLOYEE_ID=#i# AND
                        FINISH_DATE IS NOT NULL
                    ORDER BY
                        IN_OUT_ID DESC,
                        FINISH_DATE DESC
                </cfquery>
                <cfif get_emp_old.recordcount>
                    <cfquery datasource="#dsn#" name="get_pos_cat_name_old">
                        SELECT POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = #get_emp_old.POSITION_CAT_ID#
                    </cfquery>
                    <cfset old_branch = get_emp_old.BRANCH_NAME>
                    <cfset old_position = get_pos_cat_name_old.POSITION_CAT>
                    <cfset old_department = get_emp_old.DEPARTMENT_HEAD>
                </cfif>
                <cfquery dbtype="query" name="get_emp_new" maxrows="1">
                    SELECT
                        IN_OUT_ID,
                        EMPLOYEE_ID,
                        EMPLOYEE_NO,
                        TC_IDENTY_NO,
                        START_DATE,
                        FINISH_DATE,
                        DEPARTMENT_HEAD,
                        EMPLOYEE_NAME,
                        EMPLOYEE_SURNAME,
                        POSITION_CAT_ID,
                        BRANCH_NAME,
                        BRANCH_ID,
                        DEPARTMENT_ID
                    FROM
                        get_emp_in_out
                    WHERE
                        EMPLOYEE_ID=#i# AND
                        FINISH_DATE IS NULL
                        <cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and (attributes.branch_id is not 'all')>
                            AND BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
                        </cfif>
                        <cfif isdefined('attributes.department') and len(attributes.department)>
                            AND DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#" list = "yes">)
                        </cfif>
                        <cfif isdefined('attributes.company_id') and len(attributes.company_id)>
                            AND COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#" list = "yes">)
                        </cfif>
                    ORDER BY
                        IN_OUT_ID DESC
                </cfquery>
                <cfif get_emp_new.recordcount>
                    <cfquery datasource="#dsn#" name="get_pos_cat_name_new">
                        SELECT POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = #get_emp_new.POSITION_CAT_ID#
                    </cfquery>
                    <cfset new_branch = get_emp_new.BRANCH_NAME>
                    <cfset new_position = get_pos_cat_name_new.POSITION_CAT>					
                    <cfset new_department = get_emp_new.DEPARTMENT_HEAD>
                </cfif>
                <cfif (get_emp_new.recordcount) and (get_emp_old.recordcount)>
                    <cfoutput>
                    <tr>
                        <cfset emp_name = #get_emp_new.employee_name#>
                        <cfset emp_sname =  #get_emp_new.employee_surname#>
                        <cfset emp_no =  #get_emp_new.employee_no#>
                        <cfset tc_no =  #get_emp_new.tc_identy_no#>
                        <td>#emp_no#</td>
                        <td>#tc_no#</td>
                        <td>#emp_name# #emp_sname#</td>
                        <td>#old_branch#</td>
                        <td>#old_department#</td>
                        <td>#old_position#</td>
                        <td>#new_branch#</td>
                        <td>#new_department#</td>
                        <td>#new_position#</td>
                        <cfif len(get_emp_new.START_DATE)>
                            <td>#dateformat(get_emp_new.START_DATE,dateformat_style)#</td>
                        <cfelse>
                            <td>#dateformat(get_emp_old.FINISH_DATE,dateformat_style)#</td>
                        </cfif>
                        <td>
                            <cfif len(get_emp_old.IN_COMPANY_REASON_ID)>
                                <cfquery name="get_emp_reason" dbtype="query">
                                    SELECT REASON FROM fire_reasons WHERE REASON_ID = #get_emp_old.IN_COMPANY_REASON_ID#
                                </cfquery>
                                #get_emp_reason.REASON#
                            </cfif>
                        </td>
                    </tr>
                    <cfset kvar="1">
                    </cfoutput>
                </cfif>
            </cfloop>
            </cfif>
            <cfif not isdefined("is_submitted")>
            <tr height="22"><td colspan="11"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td></tr>
            <cfelseif kvar eq 0>
                <tr height="22"><td colspan="11"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td></tr>
            </cfif>
        </tbody>
    </cf_report_list>
</cfif>
<script type="text/javascript">
function kontrol()
{  
	if(document.search_form.years.value=="" || document.search_form.months.value=="" )
	{ 
		alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58472.Dönem'>");
		return false;
	}
	return true;
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
        console.log(comp_id_list);
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

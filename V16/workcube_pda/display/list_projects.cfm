<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.currency" default="">
<cfparam name="attributes.priority_cat" default="">
<cfparam name="attributes.special_definition" default="">
<cfif isDefined('xml_all_project') and xml_all_project eq 1>
	<cfparam name="attributes.project_status" default="0">
<cfelse>
	<cfparam name="attributes.project_status" default="1">
</cfif>
<cfparam name="attributes.project_status" default="1">
<cfparam name="attributes.process_catid" default="">
<cfparam name="attributes.pro_employee" default="">
<cfparam name="attributes.pro_employee_id" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.expense_code" default="">
<cfparam name="attributes.expense_code_name" default="">
<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfset attributes.is_form_submitted = 1>
<cfif isdefined("attributes.is_form_submitted")>
    <cfquery name="GET_PROJECTS" datasource="#DSN#">
        SELECT 
        	* 
        FROM
        (
            SELECT 
                DISTINCT(PRO_PROJECTS.PROJECT_ID),
                PRO_PROJECTS.PROJECT_HEAD,
                PRO_PROJECTS.CONSUMER_ID,
                PRO_PROJECTS.COMPANY_ID,
                PRO_PROJECTS.PARTNER_ID,
                PRO_PROJECTS.PROJECT_EMP_ID,
                PRO_PROJECTS.OUTSRC_CMP_ID,
                PRO_PROJECTS.OUTSRC_PARTNER_ID,
                PRO_PROJECTS.TARGET_FINISH,
                PRO_PROJECTS.TARGET_START,
                PRO_PROJECTS.AGREEMENT_NO,
                PRO_PROJECTS.PRO_CURRENCY_ID,
                PRO_PROJECTS.EXPENSE_CODE,
                PRO_PROJECTS.PROCESS_CAT,
                PRO_PROJECTS.PROJECT_NUMBER,
                SETUP_PRIORITY.COLOR,
                SETUP_PRIORITY.PRIORITY,
                (
                    (
                        SELECT
                            SUM(ISNULL(TO_COMPLETE,0))
                        FROM
                            PRO_WORKS PW
                        WHERE
                            PW.PROJECT_ID = PRO_PROJECTS.PROJECT_ID
                    )/
                    (
                        SELECT
                            COUNT(WORK_ID)
                        FROM
                            PRO_WORKS PW2
                        WHERE
                            PW2.PROJECT_ID = PRO_PROJECTS.PROJECT_ID
                    )
                ) COMPLETE_RATE
            FROM 
                PRO_PROJECTS,
                SETUP_PRIORITY 
                <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
                    ,PRO_HISTORY
                </cfif>
            WHERE 
                <cfif isDefined('attributes.company_id') and len(attributes.company_id)>
                    (
                        PRO_PROJECTS.OUTSRC_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> OR
                        PRO_PROJECTS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                    ) AND
                </cfif>
                ((SELECT TOP 1 WEP.EMPLOYEE_ID FROM WORKGROUP_EMP_PAR WEP WHERE WEP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#"> AND PRO_PROJECTS.PROJECT_ID = WEP.PROJECT_ID) IS NOT NULL OR PRO_PROJECTS.PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#">)AND
                <cfif isDefined('attributes.company_id') and len(attributes.company_id)>
                    PRO_PROJECTS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
                </cfif>
                PRO_PROJECTS.PRO_PRIORITY_ID=SETUP_PRIORITY.PRIORITY_ID
                <cfif isDefined('attributes.keyword') and len(attributes.keyword) and attributes.keyword gte 1>
                    AND PRO_PROJECTS.PROJECT_ID = PRO_HISTORY.PROJECT_ID
                    AND (
                        PRO_PROJECTS.PROJECT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        PRO_PROJECTS.PROJECT_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        PRO_PROJECTS.AGREEMENT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR
                        PRO_PROJECTS.PROJECT_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                        )
                <cfelseif isDefined('attributes.keyword') and len(attributes.keyword) and attributes.keyword eq 1>
                    AND PRO_PROJECTS.PROJECT_ID = PRO_HISTORY.PROJECT_ID
                    AND PRO_PROJECTS.PROJECT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
                </cfif>
		)T1
	</cfquery>
<cfelse>
	<cfset get_projects.recordcount=0>
</cfif>
<cfquery name="GET_SPECIAL_DEF" datasource="#DSN#">
	SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 6
</cfquery>
<cfquery name="GET_PROCESS_CAT" datasource="#DSN#">
	SELECT
	   DISTINCT 
	   SMC.MAIN_PROCESS_CAT_ID,
	   SMC.MAIN_PROCESS_CAT
	FROM 
	   SETUP_MAIN_PROCESS_CAT SMC,
	   SETUP_MAIN_PROCESS_CAT_ROWS SMR,
	   EMPLOYEE_POSITIONS
	WHERE
	   SMC.MAIN_PROCESS_CAT_ID = SMR.MAIN_PROCESS_CAT_ID AND
	   EMPLOYEE_POSITIONS.POSITION_CODE =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#"> AND 
	   (EMPLOYEE_POSITIONS.POSITION_CAT_ID = SMR.MAIN_POSITION_CAT_ID OR EMPLOYEE_POSITIONS.POSITION_CODE = SMR.MAIN_POSITION_CODE)
</cfquery>
<cfquery name="GET_PROCURRENCY" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.projects%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="GET_WORKGROUPS" datasource="#DSN#">
	SELECT 
		WORKGROUP_ID,
		WORKGROUP_NAME
	FROM 
		WORK_GROUP
	WHERE
		STATUS = 1
		AND HIERARCHY IS NOT NULL
	ORDER BY 
		HIERARCHY
</cfquery>
<cfinclude template="../../objects2/project/query/get_priority.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.pda.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_projects.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
<table cellpadding="0" cellspacing="0" align="center" style="width:98%">
	<tr style="height:35px;">
		<td class="headbold">Projeler</td>
	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" align="center" style="width:98%" class="color-border">	
    <!-- sil -->
    <tr class="color-header">
        <td class="form-title" style="text-align:center; width:20px"><cf_get_lang_main no='75.no'></th>
        <td class="form-title" nowrap="nowrap">P.<cf_get_lang_main no='75.No'></td>
        <cfif isDefined('xml_agreement_no') and xml_agreement_no eq 1><td class="form-title" nowrap="nowrap">S.<cf_get_lang_main no='75.No'></td></cfif>
        <td class="form-title"><cf_get_lang_main no='603.projeler'></td>
        <cfif isDefined('xml_is_show_category') and xml_is_show_category eq 1>
        	<td class="form-title"><cf_get_lang_main no='74.Kategori'></td>
        </cfif>
        <td class="form-title"><cf_get_lang_main no='162.şirket'></td>
        <td class="form-title"><cf_get_lang_main no='73.Öncelik'></td>
        <td class="form-title"><cf_get_lang_main no='641.bitiş tarihi'></td>
        <td class="form-title"><cf_get_lang_main no='288.bitiş tarihi'></td>
    </tr>
	<cfif get_projects.recordcount>
        <cfset company_id_list="">
        <cfset consumer_id_list="">
        <cfset emp_id_list="">
        <cfset out_partner_id_list="">
        <cfset project_stage_list = "">
        <cfset project_cat_list ="">
        <cfoutput query="get_projects" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <cfif len(partner_id) and not listfind(company_id_list,partner_id)>
                <cfset company_id_list=listappend(company_id_list,partner_id)>
            <cfelseif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
                <cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
            </cfif>
            <cfif len(project_emp_id) and not listfind(emp_id_list,project_emp_id)>
                <cfset emp_id_list=listappend(emp_id_list,project_emp_id)>
            </cfif>
            <cfif len(process_cat) and not listfind(project_cat_list,process_cat)>
                <cfset project_cat_list=listappend(project_cat_list,process_cat)>
            </cfif>
            <cfif len(outsrc_partner_id) and not listfind(company_id_list,outsrc_partner_id)>
                <cfset company_id_list=listappend(company_id_list,outsrc_partner_id)>
            </cfif>
            <cfif len(pro_currency_id) and not listfind(project_stage_list,pro_currency_id)>
                <cfset project_stage_list=listappend(project_stage_list,pro_currency_id)>
            </cfif>
        </cfoutput>
        <cfif len(company_id_list)>
            <cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
                SELECT
                    C.NICKNAME,
                    CP.COMPANY_PARTNER_NAME,
                    CP.COMPANY_PARTNER_SURNAME,
                    CP.PARTNER_ID
                FROM 
                    COMPANY_PARTNER CP,
                    COMPANY C
                WHERE 
                    CP.PARTNER_ID IN (#company_id_list#) 
                    AND CP.COMPANY_ID = C.COMPANY_ID
                ORDER BY
                    CP.PARTNER_ID
            </cfquery>
            <cfset company_id_list=listsort(listdeleteduplicates(valuelist(GET_PARTNER_DETAIL.PARTNER_ID,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(consumer_id_list)>
            <cfquery name="GET_CONSUMER_DETAIL" datasource="#DSN#">
                SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
            </cfquery>
            <cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(GET_CONSUMER_DETAIL.CONSUMER_ID,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(emp_id_list)>
            <cfquery name="GET_EMP_DETAIL" datasource="#DSN#">
                SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#emp_id_list#) ORDER BY EMPLOYEE_ID
            </cfquery>
            <cfset emp_id_list=listsort(listdeleteduplicates(valuelist(GET_EMP_DETAIL.EMPLOYEE_ID,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(project_stage_list)>
            <cfquery name="get_currency_name" datasource="#dsn#">
                SELECT PROCESS_ROW_ID,STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#project_stage_list#) ORDER BY PROCESS_ROW_ID
            </cfquery>
            <cfset project_stage_list = listsort(listdeleteduplicates(valuelist(get_currency_name.PROCESS_ROW_ID,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(project_cat_list)>
            <cfset project_cat_list = listsort(project_cat_list,'numeric','ASC',',')>
            <cfquery name="get_pro_cat" datasource="#dsn#">
                SELECT MAIN_PROCESS_CAT_ID, MAIN_PROCESS_CAT FROM SETUP_MAIN_PROCESS_CAT WHERE MAIN_PROCESS_CAT_ID IN(#project_cat_list#)
            </cfquery>
            <cfset project_cat_list = listsort(listdeleteduplicates(valuelist(get_pro_cat.MAIN_PROCESS_CAT_ID,',')),'numeric','ASC',',')>
        </cfif>
        <cfoutput query="get_projects" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr class="color-row">
                <td style="text-align:center">#currentrow#</td>
                <td nowrap="nowrap">#project_number#</td>
                <cfif isDefined('xml_agreement_no') and xml_agreement_no eq 1><td>#agreement_no#</td></cfif>
                <td><a href="#request.self#?fuseaction=pda.detail_project&project_id=#project_id#&is_form_submitted=1" class="tableyazi">#project_head#</a></td>
                <cfif isDefined('xml_is_show_category') and xml_is_show_category eq 1>
                <td>#get_pro_cat.main_process_cat[listfind(project_cat_list,process_cat,',')]#</td>
                </cfif>
                <td>
                    <cfif len(company_id) and len(company_id_list)>
                        <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects2.popup_com_det&company_id=#company_id#','medium');" class="tableyazi">#get_partner_detail.nickname[listfind(company_id_list,partner_id,',')]#</a>-
                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_par_det&par_id=#PARTNER_ID#','medium');" class="tableyazi">#get_partner_detail.company_partner_name[listfind(company_id_list,partner_id,',')]# #get_partner_detail.company_partner_surname[listfind(company_id_list,partner_id,',')]#</a>
                    <cfelseif len(consumer_id) and len(consumer_id_list)>
                        <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects2.popup_con_det&con_id=#consumer_id#','medium');" class="tableyazi">#get_consumer_detail.consumer_name[listfind(consumer_id_list,consumer_id,',')]# #get_consumer_detail.consumer_surname[listfind(consumer_id_list,consumer_id,',')]#</a>
                    </cfif>
                </td>
                <td><font color="#get_projects.color#">#get_projects.priority#</font></td>
                <td>#dateformat(get_projects.target_start,"dd/mm/yyyy")#</td>
                <td>#dateformat(get_projects.target_finish,"dd/mm/yyyy")#</td>
            </tr>
        </cfoutput>
    <cfelse>
        <cfset colspan=11>
        <cfif isDefined('xml_is_show_category') and xml_is_show_category eq 1>
            <cfset colspan=colspan+1>
        </cfif>
        <cfif isDefined('xml_agreement_no') and xml_agreement_no eq 1>
            <cfset colspan=colspan+1>
        </cfif>
        <tr class="color-row">
            <td colspan=" <cfoutput>#colspan#</cfoutput>"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '>!</cfif></td>
        </tr>
    </cfif>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "is_form_submitted=1">
	<cfif Len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>
	<cfif Len(attributes.currency)><cfset url_str = "#url_str#&currency=#attributes.currency#"></cfif>
	<cfif Len(attributes.priority_cat)><cfset url_str = "#url_str#&priority_cat=#attributes.priority_cat#"></cfif>
	<cfif Len(attributes.project_status)><cfset url_str = "#url_str#&project_status=#attributes.project_status#"></cfif>
	<cfif Len(attributes.process_catid)><cfset url_str = "#url_str#&process_catid=#attributes.process_catid#"></cfif>
	<cfif Len(attributes.start_date)><cfset url_str = "#url_str#&start_date=#attributes.start_date#"></cfif>
	<cfif Len(attributes.finish_date)><cfset url_str = "#url_str#&finish_date=#attributes.finish_date#"></cfif>
	<cfif Len(attributes.ordertype)><cfset url_str = "#url_str#&ordertype=#attributes.ordertype#"></cfif>
	<cfif Len(attributes.special_definition)><cfset url_str = "#url_str#&special_definition=#attributes.special_definition#"></cfif>
	<cfif Len(attributes.expense_code) and Len(attributes.expense_code_name)>
		<cfset url_str = "#url_str#&expense_code=#attributes.expense_code#&expense_code_name=#attributes.expense_code_name#">
	</cfif>
	<cfif Len(attributes.pro_employee_id) and Len(attributes.pro_employee)>
		<cfset url_str = "#url_str#&pro_employee_id=#attributes.pro_employee_id#&pro_employee=#attributes.pro_employee#">
	</cfif>
	<cfif Len(attributes.company_id) and Len(attributes.company)>
		<cfset url_str = "#url_str#&company_id=#attributes.company_id#&company=#attributes.company#">
	</cfif>
	<cfif Len(attributes.consumer_id) and Len(attributes.company)>
		<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
	</cfif>
	<cfif isdefined("attributes.workgroup_id") and len(attributes.workgroup_id)>
		<cfset url_str="#url_str#&workgroup_id=#attributes.workgroup_id#">
	</cfif>
	<table align="center" style="width:99%;">
    	<tr>
			<td><cf_pages page="#attributes.page#"
				  maxrows="#attributes.maxrows#"
				  totalrecords="#attributes.totalrecords#"
				  startrow="#attributes.startrow#"
				  adres="project.projects&#url_str#">
			</td>
			<!-- sil -->
			<td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#get_projects.recordcount#&nbsp;- &nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
			<!-- sil -->
    	</tr>
	</table>
</cfif>
<br>

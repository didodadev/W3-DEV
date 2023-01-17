<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_get_lang_set module_name="hr">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.branch_id" default="">
	<cfparam name="attributes.department" default="">
	<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
	<cfparam name="attributes.sal_mon" default="#month(now())#">
	<cfscript>
		bu_ay_basi = createdate(attributes.sal_year,attributes.sal_mon, 1);
		bu_ay_sonu = date_add('s',-1,date_add('m',1,bu_ay_basi));
	</cfscript>
	<cfquery name="GET_MY_BRANCHES" datasource="#DSN#">
		SELECT
			BRANCH_ID
		FROM
			EMPLOYEE_POSITION_BRANCHES
		WHERE
			POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
	</cfquery>
	<cfif isdefined('attributes.is_form_submit')>	
		<cfset branch_list = valuelist(get_my_branches.branch_id)>
		<cfquery name="GET_NORM_POSITIONS" datasource="#DSN#">
			SELECT 
				ENP.EMPLOYEE_COUNT#attributes.sal_mon#,
				ENP.POSITION_CAT_ID,
				D.DEPARTMENT_ID,
				D.DEPARTMENT_HEAD,
				B.BRANCH_NAME,
				B.BRANCH_ID,
				O.NICK_NAME,
				SP.POSITION_CAT
			FROM 
				EMPLOYEE_NORM_POSITIONS ENP
				INNER JOIN DEPARTMENT D ON ENP.DEPARTMENT_ID = D.DEPARTMENT_ID
				INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
				INNER JOIN OUR_COMPANY O ON B.COMPANY_ID = O.COMP_ID
				INNER JOIN SETUP_POSITION_CAT SP ON SP.POSITION_CAT_ID = ENP.POSITION_CAT_ID
			WHERE 
				<cfif not session.ep.ehesap>B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#branch_list#">) AND</cfif>
				ENP.NORM_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
				ENP.EMPLOYEE_COUNT#attributes.sal_mon# IS NOT NULL
				<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
					AND O.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#">
				</cfif>
				<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
					AND ENP.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
				</cfif>
				<cfif isDefined("attributes.department") and len(attributes.department)>
					AND ENP.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
				</cfif>
				<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
					AND SP.POSITION_CAT LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
				</cfif>
			ORDER BY
				O.NICK_NAME ASC,
				BRANCH_NAME ASC,
				DEPARTMENT_HEAD ASC
		</cfquery>
	<cfelse>
		<cfset get_norm_positions.recordcount = 0>
	</cfif>
	
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default='#get_norm_positions.recordcount#'>
	
	<cfscript>
		attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1;
		if (fuseaction contains "popup")
			is_popup = 1;
		else
			is_popup = 0;
		cmp_company = createObject("component","hr.cfc.get_our_company");
		cmp_company.dsn = dsn;
		get_our_company = cmp_company.get_company();
		cmp_org_step = createObject("component","hr.cfc.get_organization_steps");
		cmp_org_step.dsn = dsn;
		get_organization_steps = cmp_org_step.get_organization_step();
		cmp_branch = createObject("component","hr.cfc.get_branches");
		cmp_branch.dsn = dsn;
		get_branch = cmp_branch.get_branch(comp_id : '#iif(isdefined("attributes.comp_id") and len(attributes.comp_id),"attributes.comp_id",DE(""))#');
		
		top_gereken = 0;
		top_varolan = 0;
		top_fark = 0;
		total_gereken = 0;
		total_varolan = 0;
		total_fark = 0;
		
		url_str = "";
		if (isdefined("attributes.comp_id") and len(attributes.comp_id))
			url_str = "#url_str#&comp_id=#attributes.comp_id#";
		if (isdefined("attributes.branch_id") and len(attributes.branch_id))
			url_str = "#url_str#&branch_id=#attributes.branch_id#";
		if (isdefined("attributes.department") and len(attributes.department))
			url_str = "#url_str#&department=#attributes.department#";
		if (isdefined("attributes.keyword") and len(attributes.keyword))
			url_str = "#url_str#&keyword=#attributes.keyword#";
		if (isdefined("attributes.sal_year") and len(attributes.sal_year))
			url_str = "#url_str#&sal_year=#attributes.sal_year#";
		if (isdefined("attributes.sal_mon") and len(attributes.sal_mon))
			url_str = "#url_str#&sal_mon=#attributes.sal_mon#";
		if (isdefined("attributes.is_form_submit") and len(attributes.is_form_submit))
			url_str = "#url_str#&is_form_submit=#attributes.is_form_submit#";
	</cfscript>
	<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
		<cfquery name="get_department" datasource="#dsn#">
            SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND DEPARTMENT_STATUS =1 AND IS_STORE<>1 ORDER BY DEPARTMENT_HEAD
        </cfquery>
	</cfif>
	<cfif attributes.page neq 1 and get_norm_positions.recordcount>
       <cfoutput query="get_norm_positions" startrow="1" maxrows="#attributes.startrow-1#">
            <cfquery name="GET_EMP_POSITIONS" datasource="#DSN#">
                SELECT DISTINCT
                    EP.EMPLOYEE_ID
                FROM
                    EMPLOYEE_POSITIONS EP
                    INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND E.EMPLOYEE_STATUS = 1
                WHERE
                    EP.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_norm_positions.department_id#"> AND
					EP.EMPLOYEE_ID > 0 AND
					EP.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_norm_positions.position_cat_id#"> AND
					(E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE
					(
						(START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#">)
						OR
						(START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#"> AND FINISH_DATE IS NULL)
						OR
						(START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#"> AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#">)
						OR
						(FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#"> AND FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#">)
					)) OR E.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT))
            </cfquery>
            <cfset deger_ = get_emp_positions.recordcount - evaluate("get_norm_positions.employee_count#attributes.sal_mon#")><!--- #bu_ay# --->
            <cfset total_gereken = total_gereken + evaluate("get_norm_positions.employee_count#attributes.sal_mon#")><!--- #bu_ay# --->
            <cfset total_varolan = total_varolan + get_emp_positions.recordcount>
            <cfset total_fark = total_fark + deger_>						
        </cfoutput>
    </cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
		
		function showDepartment(branch_id)	
		{
			var branch_id = $('#branch_id').val();
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
			}
			else
			{
				var myList = document.getElementById("department");
				myList.options.length = 0;
				var txtFld = document.createElement("option");
				txtFld.value='';
				txtFld.appendChild(document.createTextNode('<cf_get_lang_main no="160.Departman">'));
				myList.appendChild(txtFld);
			}
			
		}
		function showBranch(comp_id)	
		{
			var comp_id = $('#comp_id').val();
			if (comp_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&comp_id="+comp_id;
				AjaxPageLoad(send_address,'BRANCH_PLACE',1,'<cf_get_lang no="684.İlişkili Şubeler">');
			}
			else {document.getElementById('branch_id').value = "";document.getElementById('department').value ="";}
			//departman bilgileri sıfırla
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id=0";
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'<cf_get_lang no="685.İlişkili Departmanlar">');
		}
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_norm_staff_minus';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_norm_staff_minus.cfm';
</cfscript>

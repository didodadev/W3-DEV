<cf_get_lang_set module_name="hr">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfinclude template="../hr/query/get_position_cats2.cfm">
<cfif isdefined("attributes.is_form_submitted")>
	<cfset arama_yapilmali = 0>
<cfelse>
	<cfset arama_yapilmali = 1>
</cfif>
<cfparam name="attributes.empty_position" default="1">
<cfinclude template="../hr/query/get_all_department_branches.cfm">
<cfif arama_yapilmali neq 1>
	<cfquery name="get_standby" datasource="#dsn#">
		SELECT POSITION_CODE,CHIEF1_CODE,CHIEF2_CODE,CHIEF3_CODE FROM EMPLOYEE_POSITIONS_STANDBY
	</cfquery>
	<cfset my_position_codes = valuelist(get_standby.position_code,',')>
	<cfquery name="GET_POSITIONS" datasource="#dsn#">
		SELECT DISTINCT
			EMPLOYEE_POSITIONS.EMPLOYEE_ID,
			EMPLOYEE_POSITIONS.POSITION_CODE,
			EMPLOYEE_POSITIONS.POSITION_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
			DEPARTMENT.DEPARTMENT_ID,
			DEPARTMENT.DEPARTMENT_HEAD,
			BRANCH.COMPANY_ID,
			BRANCH.BRANCH_NAME
		FROM
			EMPLOYEE_POSITIONS,
			DEPARTMENT,
			BRANCH
		WHERE
			EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND
			DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND
			<cfif len(attributes.position_cat_id) and attributes.position_cat_id gt 0>
				EMPLOYEE_POSITIONS.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#"> AND
			</cfif>
			<cfif len(attributes.branch_id) and len(attributes.branch_id) and attributes.branch_id is not "all">
				DEPARTMENT.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND
			</cfif>
			<cfif len(attributes.department) and attributes.department gt 0>
				DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#"> AND
			</cfif>
			EMPLOYEE_POSITIONS.POSITION_STATUS = 1
		ORDER BY 
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
			EMPLOYEE_POSITIONS.POSITION_NAME
	</cfquery>	
	<cfset position_code_list = valuelist(GET_POSITIONS.POSITION_CODE,',')>
<cfelse>
	<cfset GET_POSITIONS.recordcount=0>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_positions.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfscript>
	url_string = '';
	if (isdefined("attributes.url_param")) url_string = "#url_string#&url_param=#url_param#";
</cfscript>
<cfquery name="get_branch" datasource="#dsn#">
    SELECT 
        BRANCH_STATUS, 
        COMPANY_ID, 
        BRANCH_ID, 
        BRANCH_NAME, 
        USER_NAME, 
        POSITION_NAME, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
        BRANCH 
    WHERE 
        BRANCH_STATUS =1 
    ORDER BY 
        BRANCH_NAME
</cfquery>
<cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and attributes.branch_id is not "all">
    <cfquery name="get_department" datasource="#dsn#">
        SELECT 
            DEPARTMENT_STATUS, 
            BRANCH_ID, 
            DEPARTMENT_ID, 
            DEPARTMENT_HEAD, 
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            UPDATE_DATE, 
            UPDATE_EMP, 
            UPDATE_IP
        FROM 
            DEPARTMENT 
        WHERE 
            BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND DEPARTMENT_STATUS =1 AND IS_STORE <> 1 
        ORDER BY 
            DEPARTMENT_HEAD
    </cfquery>
</cfif>
<script>
	function set_amir_1()
	{
		for(yerel_i=1 ; yerel_i <= <cfoutput>#get_positions.recordcount#</cfoutput> ; yerel_i++)
		{
			eval("document.add_.chief1_code_"+yerel_i).value = document.getElementById('chief1_code').value;
			eval("document.add_.chief1_emp_"+yerel_i).value = document.getElementById('chief1_emp').value;
			eval("document.add_.chief1_name_"+yerel_i).value = document.getElementById('chief1_name').value;
		}
	}
	
	function set_amir_2()
	{
		for(yerel_i=1 ; yerel_i <= <cfoutput>#get_positions.recordcount#</cfoutput> ; yerel_i++)
		{
			eval("document.add_.chief2_code_"+yerel_i).value = document.getElementById('chief2_code').value;
			eval("document.add_.chief2_emp_"+yerel_i).value = document.getElementById('chief2_emp').value;
			eval("document.add_.chief2_name_"+yerel_i).value = document.getElementById('chief2_name').value;
		}
	}
	
	function set_amir_3()
	{
		for(yerel_i=1 ; yerel_i <= <cfoutput>#get_positions.recordcount#</cfoutput> ; yerel_i++)
		{
			eval("document.add_.chief3_code_"+yerel_i).value = document.getElementById('chief3_code').value;
			eval("document.add_.chief3_emp_"+yerel_i).value = document.getElementById('chief3_emp').value;
			eval("document.add_.chief3_name_"+yerel_i).value = document.getElementById('chief3_name').value;
		}
	}
	
	function kontrol_amir()
	{
		if((document.getElementById('branch_id').value == '' || document.getElementById('branch_id').value == '0') && document.getElementById('position_cat_id').value == '')
		{
			alert('<cf_get_lang no="552.Şube veya Pozisyon Tipi Seçmelisiniz">!');
			return false;
		}
		return true;
	}
	
	function showamirDepartment()	
	{
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "" && branch_id != "0")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
		}
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.popup_upd_all_amir';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/upd_all_amir.cfm';
	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.popup_upd_all_amir';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/display/upd_all_amir.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/upd_all_amir.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.popup_upd_all_amir';

</cfscript>

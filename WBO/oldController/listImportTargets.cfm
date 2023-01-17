<cf_get_lang_set module_name='hr'>
<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset url_str = "">
    <cfif isdefined("attributes.import_type") and len(attributes.import_type)>
        <cfset url_str = "#url_str#&import_type=#attributes.import_type#">
    </cfif>
    <cfif isdefined('attributes.form_submit')>
        <cfquery name="get_imports" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                EMPLOYEES_PERFORMANCE_FILES 
            WHERE
                1=1
                <cfif isdefined("attributes.import_type") and len(attributes.import_type)>
                    AND PROCESS_TYPE = #attributes.import_type#
                </cfif>
            ORDER BY 
                RECORD_DATE DESC
        </cfquery>
    <cfelse>
        <cfset get_imports.recordcount = 0>
    </cfif>
    <cfset emp_list=''>
    <cfif isdefined("attributes.form_submit") and get_imports.recordcount>
        <cfoutput query="get_imports">
            <cfif len(record_emp) and not listfind(emp_list,record_emp)>
                <cfset emp_list=listappend(emp_list,record_emp)>
            </cfif>
        </cfoutput>
    </cfif>
    <cfif len(emp_list)>
        <cfset emp_list=listsort(emp_list,"numeric","ASC",",")>
        <cfquery name="get_employee" datasource="#dsn#">
            SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#emp_list#) ORDER BY EMPLOYEE_ID
        </cfquery>
    </cfif>
    <cfparam name="attributes.totalrecords" default="#get_imports.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif isdefined("attributes.form_submit") and len(attributes.form_submit)>
        <cfset url_str = '#url_str#&form_submit=#attributes.form_submit#'>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cfparam name="attributes.process_type" default="1">
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.event") and attributes.event is 'add'>
		function import_et()
		{
			if(document.getElementById('uploaded_file').value == "")
			{
				alert("<cf_get_lang no ='849.Lütfen İmport Edilecek Belge Giriniz'> !");
				return false;
			}
			
			//windowopen('','small','cc_paym');
			 <!---if (document.getElementById('process_type').value == 2)
			{
				import_worktimes.action='<cfoutput>#request.self#?fuseaction=hr.emptypopup_add_import_target</cfoutput>';}--->
			return true;
		}
		function formatGoster(type,text)
		{
			document.getElementById('tdImport').innerHTML = "";
			document.getElementById('tdImport').innerHTML = "<strong>" + text + ":</strong><br /><br />";
		
			if (type == "")
				document.getElementById('tdImport').innerHTML = "";
			else if (type == 2)
				document.getElementById('tdImport').innerHTML += document.getElementById('td7').innerHTML;
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_import_targets';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_import_targets.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.import_targets';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/display/import_targets.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_import_target.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.targets';
	
	if(isdefined("attributes.event") and attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.list_import_targets';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/query/del_import_targets.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/query/del_import_targets.cfm';
		WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'action_id=##ISLEM_ID##';		
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_import_targets';
	}

</cfscript>

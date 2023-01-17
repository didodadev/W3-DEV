<!--- Listeleme bölümü--->
<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event eq 'list')>
	<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
        <cf_date tarih = "attributes.startdate">
    </cfif>
    <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
        <cf_date tarih = "attributes.finishdate">
    </cfif>
    <cfif isdefined('attributes.form_submit')>
        <cfquery name="get_file_imports" datasource="#dsn#">
            SELECT
                FI.I_ID,
                FI.BRANCH_ID,
                FI.IMPORTED,
                FI.REAL_NAME,
                FI.LINE_COUNT,
                FI.FILE_NAME,
                FI.FILE_SIZE,
                FI.RECORD_DATE,
                B.BRANCH_NAME,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME
            FROM
                FILE_IMPORTS_MAIN AS FI INNER JOIN 
                EMPLOYEES E ON FI.RECORD_EMP = E.EMPLOYEE_ID
                LEFT JOIN BRANCH B ON B.BRANCH_ID = FI.BRANCH_ID
            WHERE
                FI.PROCESS_TYPE = -1  <!--- pdks --->
                <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
                 AND  FI.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.BRANCH_ID#">
                <cfelseif session.ep.ehesap neq 1>
               	AND  (
                FI.BRANCH_ID IN (
                                SELECT
                                    BRANCH_ID
                                FROM
                                    EMPLOYEE_POSITION_BRANCHES
                                WHERE
                                    POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
                                    DEPARTMENT_ID IS NULL
                                )
                OR
                FI.BRANCH_ID IS NULL
                )
                </cfif>
                <cfif isdefined('attributes.startdate') and len(attributes.startdate) and isdefined ('attributes.finishdate') and len(attributes.finishdate)>
                    AND FI.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.finishdate)#"> 
                    AND FI.RECORD_DATE >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> 
                <cfelseif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
                    AND FI.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.finishdate)#">
                <cfelseif isdefined('attributes.startdate') and len(attributes.startdate)>
                    AND FI.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
                </cfif>
            ORDER BY
                FI.IMPORTED,
                FI.RECORD_DATE DESC
        </cfquery>
    <cfelse>
		<cfset get_file_imports.recordcount = 0>
    </cfif>
    <cfquery name="GET_BRANCH" datasource="#dsn#">
        SELECT 
            BRANCH_ID,
            BRANCH_NAME
        FROM 
            BRANCH
        WHERE 
            BRANCH_STATUS = 1
            <cfif session.ep.ehesap neq 1>
            AND
            BRANCH_ID IN (
                            SELECT
                                BRANCH_ID
                            FROM
                                EMPLOYEE_POSITION_BRANCHES
                            WHERE
                                POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                            )
            </cfif>
        ORDER BY
            BRANCH_NAME
    </cfquery>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_file_imports.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfset url_string = ''>
    <cfif isdefined("attributes.form_submit") and len(attributes.form_submit)>
        <cfset url_string = '&form_submit=#attributes.form_submit#'>
    </cfif>
    <cfif isdefined("attributes.startdate") and len(attributes.startdate)>
        <cfset url_string = "#url_string#&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#">
    </cfif>
    <cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
        <cfset url_string = "#url_string#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#">
    </cfif>
    <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
        <cfset url_string = '#url_string#&branch_id=#attributes.branch_id#'>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cfparam name="attributes.is_puantaj_off" default="">
    <cfparam name="attributes.paper_type" default="">
    <cfscript>
        cmp_branch = createObject("component","hr.cfc.get_branches");
        cmp_branch.dsn = dsn;
        get_branch = cmp_branch.get_branch(status:1);
    </cfscript>
	<script type="text/javascript">
        function form_chk()
        {	
            if (document.getElementById('uploaded_file').value == '')
            {
                alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='56.Belge'>");
                return false;
            }
            if (document.getElementById('paper_type').value.length == 0)
            {
                alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='1166.Belge Türü'>");
                return false;
            }
            return true;	
        }
    
        function type_gizle()
        {
            if (document.getElementById('paper_type').value == 5)
            {
                puantaj_off.style.display = "";
                is_time_choice.style.display = "";
            }
            else
            {
                puantaj_off.style.display = "none";
                is_time_choice.style.display = "none";
            }
        }
    
        function formatGoster(type, text)
        {
            document.getElementById('tdFormat').innerHTML = "";
            document.getElementById('tdFormat').innerHTML = "<strong>" + text + ":</strong><br /><br />";
    
            if (type == "")
                document.getElementById('tdFormat').innerHTML = "";
            else if (type == 1)
                document.getElementById('tdFormat').innerHTML += document.getElementById('t1').innerHTML;
            else if (type == 2)
                document.getElementById('tdFormat').innerHTML += document.getElementById('t2').innerHTML;
            else if (type == 3)
                document.getElementById('tdFormat').innerHTML += document.getElementById('t3').innerHTML;
            else if (type == 4)
                document.getElementById('tdFormat').innerHTML += document.getElementById('t4').innerHTML;
            else if (type == 5)
                document.getElementById('tdFormat').innerHTML += document.getElementById('t5').innerHTML;
            else if (type == 6)
                document.getElementById('tdFormat').innerHTML += document.getElementById('t6').innerHTML;
            else if (type == 7)
                document.getElementById('tdFormat').innerHTML += document.getElementById('t7').innerHTML;
            else if (type == 8)
                document.getElementById('tdFormat').innerHTML += document.getElementById('t8').innerHTML;
            else if (type == 9)
                document.getElementById('tdFormat').innerHTML += document.getElementById('t8').innerHTML;
            else if (type == 10)
                document.getElementById('tdFormat').innerHTML += document.getElementById('t9').innerHTML;
            else if (type == 11)
                document.getElementById('tdFormat').innerHTML += document.getElementById('t10').innerHTML;
        }
    </script>
</cfif>


<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_emp_daily_in_out';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_emp_daily_in_out.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.form_import_file_pdks';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/add_import_file_pdks.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_import_file_pdks.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_emp_daily_in_out';	
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'pdksDailyInoutController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'FILE_IMPORTS_MAIN';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-uploaded_file','item-paper_type']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.

</cfscript>
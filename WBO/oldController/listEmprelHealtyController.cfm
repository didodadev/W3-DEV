<cf_get_lang_set module_name="hr">
<cfif not isdefined("attributes.event") or isdefined("attributes.event") and attributes.event is 'list'>
    <cfinclude template="../hr/ehesap/query/get_branch_name.cfm">
    <cfparam name="attributes.startdate" default="#dateformat(date_add('m',-1,CreateDate(year(now()),month(now()),1)),'dd/mm/yyyy')#">
    <cfparam name="attributes.finishdate" default="#dateformat(CreateDate(year(now()),month(now()),DaysInMonth(now())),'dd/mm/yyyy')#"> 
	<cfif isdefined('attributes.is_submit')>
        <cfif len(attributes.startdate)>
            <cf_date tarih = "attributes.startdate">
        </cfif>
        <cfif len(attributes.finishdate)>
            <cf_date tarih = "attributes.finishdate">
        </cfif>
        <cfquery name="get_emp_healty" datasource="#dsn#" cachedwithin="#fusebox.general_cached_time#">
            SELECT 
                EMPLOYEES_RELATIVE_HEALTY.ARRANGEMENT_DATE,
                EMPLOYEES_RELATIVE_HEALTY.BRANCH_ID,
                EMPLOYEES_RELATIVE_HEALTY.ILL_NAME,
                EMPLOYEES_RELATIVE_HEALTY.ILL_SURNAME,
                EMPLOYEES_RELATIVE_HEALTY.DOC_ID,
                EMPLOYEES_RELATIVE_HEALTY.IN_OUT_ID,
                EMPLOYEES.EMPLOYEE_ID,
                EMPLOYEES.EMPLOYEE_NAME,
                EMPLOYEES.EMPLOYEE_SURNAME,
                B.BRANCH_NAME	
            FROM 
                EMPLOYEES_RELATIVE_HEALTY INNER JOIN EMPLOYEES
                ON EMPLOYEES_RELATIVE_HEALTY.EMP_ID = EMPLOYEES.EMPLOYEE_ID
                LEFT JOIN BRANCH B ON B.BRANCH_ID = EMPLOYEES_RELATIVE_HEALTY.BRANCH_ID
            WHERE
            	EMPLOYEES_RELATIVE_HEALTY.DOC_ID IS NOT NULL
            <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
                AND 
                (
                    EMPLOYEES_RELATIVE_HEALTY.ILL_NAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' OR 
                    EMPLOYEES_RELATIVE_HEALTY.ILL_SURNAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' OR
                    EMPLOYEES.EMPLOYEE_NO = '#attributes.keyword#' OR
                    <cfif database_type is "MSSQL">
                        EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' 		
                    <cfelseif database_type is "DB2">
                        EMPLOYEES.EMPLOYEE_NAME||' '||EMPLOYEES.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
                    </cfif>
                )
            </cfif>
            <cfif isdate(attributes.startdate) and isdate(attributes.finishdate)>
                AND EMPLOYEES_RELATIVE_HEALTY.ARRANGEMENT_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
            </cfif>
            <cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
                AND EMPLOYEES_RELATIVE_HEALTY.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
            </cfif>
            <cfif not session.ep.ehesap>
                AND EMPLOYEES_RELATIVE_HEALTY.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
            </cfif>
            ORDER BY
                EMPLOYEES_RELATIVE_HEALTY.ARRANGEMENT_DATE DESC
        </cfquery>
    <cfelse>
    	<cfset get_emp_healty.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default=#get_emp_healty.recordcount#>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>	
<cfelseif isdefined('attributes.event') and attributes.event is "add">
    <cf_get_lang_set module_name="ehesap">
<cfelseif isdefined('attributes.event') and attributes.event is "upd">
    <cf_get_lang_set module_name="ehesap">
    <cfquery name="get_healty" datasource="#dsn#">
        SELECT 
            RH.DOC_ID, 
            RH.EMP_ID, 
            RH.ILL_NAME, 
            RH.ILL_SURNAME, 
            RH.ILL_BIRTHDATE, 
            RH.ILL_BIRTHPLACE, 
            RH.ILL_RELATIVE, 
            RH.ARRANGEMENT_DATE, 
            RH.ADDRESS, 
            RH.BRANCH_ID, 
            RH.TC_IDENTY_NO, 
            RH.IN_OUT_ID, 
            RH.DOCUMENT_NO, 
            RH.DETAIL, 
            RH.UPDATE_EMP, 
            RH.UPDATE_DATE, 
            RH.UPDATE_IP, 
            RH.RECORD_EMP,
            RH.RECORD_DATE, 
            RH.RECORD_IP, 
            RH.ILL_SEX,
            B.BRANCH_NAME,		
            B.SSK_OFFICE,
            B.SSK_NO,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME
        FROM 
            EMPLOYEES_RELATIVE_HEALTY RH INNER JOIN EMPLOYEES E
            ON E.EMPLOYEE_ID = RH.EMP_ID
            LEFT JOIN BRANCH B 
            ON RH.BRANCH_ID = B.BRANCH_ID 
        WHERE 
            RH.DOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.DOC_ID#">
    </cfquery>
</cfif>
<script>
	<cfif not isdefined('attributes.event')>
		$( document ).ready(function() {
		document.getElementById('keyword').focus();
		});
		function kontrol()
			{
				if( !date_check(document.getElementById('startdate'),document.getElementById('finishdate'), "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
					return false;
				else
					return true;
			}
	<cfelseif isdefined('attributes.event') and listfind('add,upd',attributes.event,',')>
		function kontrol()
		{
			if (document.getElementById('employee_id').value == "")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no ='164.Çalışan'>");
				return false;
			}
			if (document.getElementById('in_out_id').value == "")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no ='164.Çalışan'>");
				return false;
			}
			if (document.getElementById('emp_name').value == "")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no ='164.Çalışan'>");
				return false;
			}
			if (document.getElementById('ill_name').value == "")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no ='1395.Vizite Alacak Kişinin Adı'>");
				return false;
			}
			if (document.getElementById('ill_surname').value == "")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no ='1396.Vizite Alacak Kişinin Soyadı'>");
				return false;
			}
			if (document.getElementById('ill_relative').value == "")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no ='1397.Vizite Alacak Kişinin Yakınlığı'>");
				return false;
			}
			if (document.getElementById('TC_IDENTY_NO').value == "")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no ='1398.Vizite Alacak Kişinin TC Kimlik Numarası'>");
				return false;
			}
			return true;
		}
	</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];

	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.list_emp_rel_healty';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/ssk_healty.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_emp_relative_healty.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_emp_rel_healty';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.list_emp_rel_healty';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/ssk_healty_upd.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_emp_rel_healty.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_emp_rel_healty';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'doc_id=##attributes.doc_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.doc_id##';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_emp_rel_healty';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_emp_rel_healty.cfm';
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.emptypopup_emp_relative_healty_del&doc_id=#attributes.doc_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_emp_rel_healty.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_emp_rel_healty.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_emp_rel_healty';
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listEmprelHealtyController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEES_RELATIVE_HEALTY';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-emp_name','item-ill_name','item-ill_surname','item-ill_relative','item-TC_IDENTY_NO']";
</cfscript>

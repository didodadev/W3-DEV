<cf_get_lang_set module_name="hr">
<cfif not isdefined("attributes.event") or isdefined("attributes.event") and attributes.event is 'list'>
    <cfparam name="attributes.status" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.report_type" default="1">
    <cfparam name="attributes.date_selection" default="1">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
        <cf_date tarih = "attributes.start_date">
    </cfif>
    <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
        <cf_date tarih = "attributes.finish_date">
    </cfif>
    <cfif isdefined('attributes.form_submit')>
        <cfinclude template="../hr/query/get_emp_healty_all.cfm">	
    <cfelse>
        <cfset get_healty.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#GET_HEALTY.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
    <cf_xml_page_edit fuseact='hr.popup_add_employee_healty'>
    <cf_papers paper_type="EMPLOYEE_HEALTY">
    <cfset system_paper_no=paper_code & '-' & paper_number>
    <cfset system_paper_no_add=paper_number>
    <cfif len(paper_number)>
        <cfset asset_no = system_paper_no>
    <cfelse>
        <cfset asset_no = ''>
    </cfif>
<cfelseif isdefined('attributes.event') and attributes.event is 'upd'>
    <cf_xml_page_edit fuseact='hr.popup_add_employee_healty'>
    <cfinclude template="../hr/query/get_emp_healty.cfm">
    <cfif len(get_healty.relative_id)>
        <cfquery name="get_rel_name" datasource="#dsn#">
            SELECT NAME +' '+ SURNAME NAME FROM EMPLOYEES_RELATIVES WHERE RELATIVE_ID = #get_healty.relative_id# <!---AND EMPLOYEE_ID = #attributes.EMPLOYEE_ID#--->
        </cfquery>
    </cfif>
<cfelseif isdefined('attributes.event') and attributes.event is 'updEmp'>
<cf_xml_page_edit fuseact='hr.popup_add_employee_healty'>
    <cfquery name="get_healty" datasource="#DSN#" >
        SELECT
            EH.*,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            E.EMPLOYEE_STATUS,
            E.PHOTO,
            E.PHOTO_SERVER_ID,
            ED.SEX,
            EI.BLOOD_TYPE,
            EI.BIRTH_DATE,
            EI.TC_IDENTY_NO,
            EP.POSITION_NAME,
            (SELECT D.DEPARTMENT_HEAD FROM DEPARTMENT D,EMPLOYEE_POSITIONS EP WHERE D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EP.IS_MASTER = 1) DEPARTMENT_HEAD,
            (SELECT B.BRANCH_NAME FROM BRANCH B,DEPARTMENT D,EMPLOYEE_POSITIONS EP WHERE B.BRANCH_ID = D.BRANCH_ID AND D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EP.IS_MASTER = 1) BRANCH_NAME,
            (SELECT O.NICK_NAME FROM BRANCH B,DEPARTMENT D,EMPLOYEE_POSITIONS EP,OUR_COMPANY O WHERE B.BRANCH_ID = D.BRANCH_ID AND D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EP.IS_MASTER = 1 AND O.COMP_ID = B.COMPANY_ID) NICK_NAME,
            (SELECT ER.NAME +' '+ ER.SURNAME NAME FROM EMPLOYEES_RELATIVES ER WHERE EH.RELATIVE_ID = ER.RELATIVE_ID) RELATIVE_NAME
        FROM
            EMPLOYEE_HEALTY EH,
            EMPLOYEES_IDENTY EI,
            EMPLOYEES_DETAIL ED,
            EMPLOYEES E
            LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
        WHERE
            ED.EMPLOYEE_ID = E.EMPLOYEE_ID AND
            EI.EMPLOYEE_ID = E.EMPLOYEE_ID AND
            EH.EMPLOYEE_ID = E.EMPLOYEE_ID 
            <cfif isdefined("attributes.EMPLOYEE_ID") and len(attributes.EMPLOYEE_ID)>
                AND E.EMPLOYEE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">
            </cfif>
        ORDER BY
            INSPECTION_DATE DESC
    </cfquery>
</cfif>

<script type="text/javascript">
	<cfif not isdefined("attributes.event") or isdefined("attributes.event") and attributes.event is 'list'>
		$( document ).ready(function() {
			document.getElementById('keyword').focus();
		});	
		is_relative_name.style.display = '';
	<cfelseif isdefined('attributes.event') and listfind('add,upd',attributes.event,',')>
		<cfif attributes.event is 'add'>
			$( document ).ready(function() {
				document.getElementById('is_relative_name').style.display = 'none';
			});	
		<cfelseif attributes.event is 'upd'>
			<cfif not len(get_healty.relative_id)>
				$( document ).ready(function() {
					document.getElementById('is_relative_name').style.display = 'none';
				});
			</cfif>
		</cfif>
		function chanege_()
		{
			is_relative_name.style.display = '';
			return true;
		}
		function kontrol()
		{
			if(document.getElementById('emp_name_').value == '' && document.getElementById('employee_id').value == '')
			{
				alert("<cf_get_lang no='1564.Çalışan Seçiniz'> !");
				return false;
			}
			select_all('decisionmecidine2');
			select_all('complaint2');
			<cfif xml_complaint eq 1>
			x = (200 - document.getElementById('complaint').value.length);
			if ( x < 0 )
			{ 
				alert (" <cf_get_lang no ='166.Tanı'> "+ ((-1) * x) +"<cf_get_lang_main no='1741.Karakter Uzun'>!");
				return false;
			}
			</cfif>
			x = (200 - document.getElementById('inspection_result').value.length);
			if ( x < 0 )
			{ 
				alert (" <cf_get_lang no ='165.Bulgular/Lab. İncelemeleri'> "+ ((-1) * x) +"<cf_get_lang_main no='1741.Karakter Uzun'>!");
				return false;
			}
			<cfif xml_decisionmecidine eq 1>
			x = (500 - document.getElementById('decisionmecidine').value.length);
			if ( x < 0 )
			{ 
				alert (" <cf_get_lang no ='374.Karar ve Verilen İlaçlar'> "+ ((-1) * x) +"<cf_get_lang_main no='1741.Karakter Uzun'>!");
				return false;
			}
			</cfif>
			<cfif xml_detail eq 1>
			x = (500 - document.getElementById('detail').value.length);
			if ( x < 0 )
			{ 
				alert ("<cf_get_lang no ='375.Düşünceler'>  "+ ((-1) * x) +"<cf_get_lang_main no='1741.Karakter Uzun'>!");
				return false;
			}
			</cfif>
			return true;
		
		}
		function select_all(selected_field)
		{
			var m = eval("document.healty." + selected_field + ".length");
			for(i=0;i<m;i++)
			{
				eval("document.healty."+selected_field+"["+i+"].selected=true");
			}
			return true;
		}
		function medicine_remove()
		{
			for (i=document.getElementById('decisionmecidine2').options.length-1;i>-1;i--)
			{
				if (document.getElementById('decisionmecidine2').options[i].selected==true)
				{
					document.getElementById('decisionmecidine2').options.remove(i);
				}	
			}
			return true;
		}
		function complaint2_remove()
		{
			for (i=document.getElementById('complaint2').options.length-1;i>-1;i--)
			{
				if (document.getElementById('complaint2').options[i].selected==true)
				{
					document.getElementById('complaint2').options.remove(i);
				}	
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
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_employee_healty_all';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_employee_healty_all.cfm';

	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.list_employee_healty_all&event=add';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/add_employee_healty.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_employee_healty.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_employee_healty_all';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.list_employee_healty_all';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/upd_employee_healty.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_employee_healty.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_employee_healty_all&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'healty_id=##attributes.healty_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.healty_id##';
	
	WOStruct['#attributes.fuseaction#']['updEmp'] = structNew();
	WOStruct['#attributes.fuseaction#']['updEmp']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['updEmp']['fuseaction'] = 'hr.list_employee_healty_all';
	WOStruct['#attributes.fuseaction#']['updEmp']['filePath'] = 'hr/form/upd_active_employee_healty.cfm';
	WOStruct['#attributes.fuseaction#']['updEmp']['queryPath'] = 'hr/query/upd_employee_healty.cfm';
	WOStruct['#attributes.fuseaction#']['updEmp']['nextEvent'] = 'hr.list_employee_healty_all&event=updEmp';
	WOStruct['#attributes.fuseaction#']['updEmp']['parameters'] = 'healty_id=##attributes.healty_id##';
	WOStruct['#attributes.fuseaction#']['updEmp']['Identity'] = '##attributes.healty_id##';
	
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.emptypopup_del_emp_healty&healty_id=#attributes.healty_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/query/del_emp_healty.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/query/del_emp_healty.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_employee_healty_all';
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onclick'] = "windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_add_employee_healty</cfoutput>','page');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listHealtyAllController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEE_HEALTY';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-emp_name_','item-employee_healty_no']";

</cfscript>

<cf_get_lang_set module_name="assetcare">
<cfif not isdefined("attributes.event") or attributes.event is 'list'>
	<cf_xml_page_edit fuseact="assetcare.form_add_care_period">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfparam name="attributes.branch" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.department" default="">
    <cfparam name="attributes.asset_cat" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.station_id" default="">
    <cfparam name="attributes.station_name" default="">
    <cfparam name="attributes.asset_id" default="">
    <cfparam name="attributes.asset_name" default="">
    <cfparam name="attributes.official_emp_id" default="">
    <cfparam name="attributes.official_emp" default="">
    <cfparam name="attributes.form_submitted" default="">
    <cfif isdate(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
    <cfif isdate(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
    <cfquery name="GET_BRANCH" datasource="#dsn#">
        SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
    </cfquery>
    <cfquery name="GET_ASSET_CAT" datasource="#dsn#">
        SELECT ASSET_CARE_ID, ASSET_CARE FROM ASSET_CARE_CAT ORDER BY ASSET_CARE
    </cfquery>
    <cfif len(attributes.form_submitted)>
        <cfinclude template="../assetcare/query/list_failure_info.cfm">
        <cfparam name="attributes.totalrecords" default='#get_asset_failure_list.recordcount#'>
    <cfelse>
        <cfparam name="attributes.totalrecords" default='0'>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.startrow" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cfparam name="attributes.station_id" default="">
    <cfparam name="attributes.station_name" default="">
    <cf_xml_page_edit fuseact="assetcare.form_add_asset_failure">
    <cf_papers paper_type="asset_failure">
    <cfset system_paper_no=paper_code & '-' & paper_number>
    <cfset system_paper_no_add=paper_number>
    <cfif len(paper_number)>
        <cfset asset_failure_no = system_paper_no>
    <cfelse>
        <cfset asset_failure_no = ''>
    </cfif>
    <cfif isDefined("attributes.assetp_id")>
        <cfquery name="GET_ASSETP" datasource="#DSN#">
            SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
        </cfquery>
    </cfif>
    <cfquery  name="GET_EMPLOYEE" datasource="#DSN#">
        SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
    </cfquery>
    <cfquery name="GET_SERVICE_CODE" datasource="#DSN3#">
        SELECT 
            SERVICE_CODE_ID,
            SERVICE_CODE 
        FROM 
            SETUP_SERVICE_CODE
        ORDER BY
            SERVICE_CODE
    </cfquery>
    <cfif LEN(send_to_pos_id)>
        <cfquery name="GET_EMP_INFO" datasource="#DSN#">
            SELECT 
                EMPLOYEE_NAME + ' '+ EMPLOYEE_SURNAME AS 'EMP_NAME' 
            FROM 
                EMPLOYEES
            WHERE
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#send_to_pos_id#">
        </cfquery>
    </cfif>
    <cfquery name="GET_MODULE_TEMP" datasource="#DSN#">
        SELECT TEMPLATE_ID,TEMPLATE_HEAD FROM TEMPLATE_FORMS WHERE TEMPLATE_MODULE = 40
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cf_xml_page_edit fuseact="assetcare.form_add_care_period">
    <cfparam name="attributes.station_id" default="">
    <cfparam name="attributes.station_name" default="">
    <cfset list_level="#session.ep.power_user_level_id#">
    <cfquery name="get_service_code" datasource="#DSN3#">
        SELECT 
            SERVICE_CODE_ID,
            SERVICE_CODE 
        FROM 
            SETUP_SERVICE_CODE
        ORDER BY
            SERVICE_CODE
    </cfquery>
    <cfquery name="get_failure_using_code" datasource="#dsn3#">
        SELECT
            SETUP_SERVICE_CODE.SERVICE_CODE_ID,
            SETUP_SERVICE_CODE.SERVICE_CODE
        FROM 
            #dsn_alias#.FAILURE_CODE_ROWS FAILURE_CODE_ROWS,
            SETUP_SERVICE_CODE
        WHERE 
            FAILURE_CODE_ROWS.FAILURE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.failure_id#"> AND
            FAILURE_CODE_ROWS.FAILURE_CODE_ID = SETUP_SERVICE_CODE.SERVICE_CODE_ID
    </cfquery>
    <cfset get_failure_code=valuelist(get_failure_using_code.SERVICE_CODE_ID)>
    <cfquery name="GET_ASSET_FAILURE" datasource="#DSN#">
        SELECT 
            ASSET_FAILURE_NOTICE.*,
            AP.ASSETP,
            AP.ASSETP_ID,
            ASSET_CARE_CAT.ASSET_CARE,
            ASSET_CARE_CAT.IS_YASAL,
            EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME AS EMP_NAME
        FROM
            ASSET_FAILURE_NOTICE
            LEFT JOIN EMPLOYEES EMP ON EMP.EMPLOYEE_ID = ASSET_FAILURE_NOTICE.SEND_TO_ID
            LEFT JOIN ASSET_P AP ON AP.ASSETP_ID = ASSET_FAILURE_NOTICE.ASSETP_ID,
            ASSET_CARE_CAT
        WHERE
            FAILURE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.failure_id#"> AND
            ASSET_FAILURE_NOTICE.ASSET_CARE_ID = ASSET_CARE_CAT.ASSET_CARE_ID 
    </cfquery>
    <cfif isdefined("get_asset_failure.project_id") and  len(get_asset_failure.project_id)>
        <cfquery name="GET_PROJECT" datasource="#DSN#">
            SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_asset_failure.project_id#">
        </cfquery>
    </cfif>
    <cfquery name="get_relation_care" datasource="#dsn#">
        SELECT CARE_ID FROM CARE_STATES WHERE FAILURE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.failure_id#">
    </cfquery>
    <cfquery name="get_relation_report" datasource="#dsn#">
        SELECT CARE_REPORT_ID FROM ASSET_CARE_REPORT WHERE FAILURE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.failure_id#">
    </cfquery>
    <cfif len(get_asset_failure.failure_date)>
		<cfset finish_hour = hour(get_asset_failure.failure_date)>					
        <cfset finish_minute = minute(get_asset_failure.failure_date)>
    <cfelse>
        <cfset finish_hour = ''>					
        <cfset finish_minute = ''>						
    </cfif>	
    <cfquery name="GET_MODULE_TEMP" datasource="#DSN#">
        SELECT TEMPLATE_ID,TEMPLATE_HEAD FROM TEMPLATE_FORMS WHERE TEMPLATE_MODULE = 40
    </cfquery>
</cfif>
<script type="text/javascript">
<cfif not isdefined("attributes.event") or attributes.event is 'list'>
	$(document).ready(function()
	{
		$('#keyword').focus();
	});
	function control_()
	{	
		if(datediff($('#start_date').val(),$('#finish_date').val(),0)<0)
		{
			alert("<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden  Büyük olmaz'>");
			return  false;
		}
		return true;
	}

<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	$(document).ready(function()
	{
		
	});
	function kontrol()
	{
		if($('#care_type').val() == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='42.Bakım Tipi'>!");
			return false;
		}
		if($('#head').val() == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='68.Konu'>!");
			return false;
		}
		if($('#failure_date').val() == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>: Arıza Tarihi!");
			return false;
		}
		if(!CheckEurodate($('#failure_date').val(),"<cf_get_lang no='41.Bakım Tarihi'>"))
		{
			return false;
		}
		if($('#document_no').val() == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>: Belge Numarası!");
			return false;
		}
		return process_cat_control();
	}
	function pencere_ac()
	{
	
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_care_type&field_id=formFailure.care_type_id&field_name=formFailure.care_type&asset_id=' + formFailure.assetp_id.value,'list','popup_list_care_type');
	}
	function find_value()
	{
		getAssetCat=wrk_query('SELECT TOP 1  ASSET_P_CAT.MOTORIZED_VEHICLE,ASSET_P_KM_CONTROL.KM_FINISH,ASSET_P_KM_CONTROL.FINISH_DATE FROM  ASSET_P,ASSET_P_CAT,ASSET_P_KM_CONTROL WHERE ASSET_P_CAT.ASSETP_CATID = ASSET_P.ASSETP_CATID AND ASSET_P.ASSETP_ID=ASSET_P_KM_CONTROL.ASSETP_ID AND ASSET_P.ASSETP_ID='+document.getElementById('assetp_id').value+' ORDER BY KM_CONTROL_ID DESC','dsn');
		if(getAssetCat.MOTORIZED_VEHICLE==1)
		{
			document.getElementById('motorized_vehicle1').style.display='';
			document.getElementById('motorized_vehicle2').style.display='';
			//İlk önce boşaltılır..
			$('#m_v_previous_km').val("");
			$('#m_v_previous_date').val("");
			//query de ki değerler okutulur.
			$('#m_v_previous_km').val(getAssetCat.KM_FINISH);
			document.getElementById('m_v_previous_date').value=getAssetCat.FINISH_DATE;
			document.getElementById('m_v_previous_date').value=document.getElementById('m_v_previous_date').value.substring(8,10)+"/"+document.getElementById('m_v_previous_date').value.substring(5,7)+"/"+document.getElementById('m_v_previous_date').value.substring(0,4);
			// son km girilen textbox
		}
		else
		{
			document.getElementById('motorized_vehicle1').style.display='none';
			document.getElementById('motorized_vehicle2').style.display='none';
		}
	}
	function control_value()
	{
	//parselleme yaparak al jquer ile.!!
		if(parseInt(document.getElementById('m_v_last_km').value) < parseInt(document.getElementById('m_v_previous_km').value))
		{
			alert("Son Km Önceki Km Büyük Olmalıdır!");
			$('#m_v_last_km').val("");
		}
	}
	function _load(template_id)
	{
		if(template_id != undefined)
		{
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=call.popup_get_template&width=557&template_id='+template_id+'','fckedit',1);
		}
	}
	
	
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	function kontrol()
	{
		
		if($('#care_type').val() == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='42.Bakım Tipi'>!");
			return false;
		}
		if($('#head').val() == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='68.Konu'>!");
			return false;
		}
		if($('#failure_date').val() == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>: Arıza Tarihi!");
			return false;
		}
		if(!CheckEurodate($('#failure_date').val(),"<cf_get_lang no='41.Bakım Tarihi'>"))
		{
			return false;
		}
		return process_cat_control();
	}
	
	function pencere_ac()
	{
		if (document.formFailure.assetp_id == undefined || document.formFailure.assetp_id.value == "")
			alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no='73.öncelik'>-varlık");
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_care_type&field_id=formFailure.care_type_id&field_name=formFailure.care_type&asset_id=' + formFailure.assetp_id.value,'list','popup_list_care_type');
	}
	function bakim_plani_yap(type)
	{
		if(type == 1)
			{
			window.location.href ='<cfoutput>#request.self#?fuseaction=assetcare.list_assetp_period&event=add&failure_id=#attributes.failure_id#</cfoutput>';
			}
		else if (type == 2)
			{
			window.location.href ='<cfoutput>#request.self#?fuseaction=assetcare.list_asset_care&event=add&failure_id=#attributes.failure_id#</cfoutput>';
			}
	}
		function _load(template_id)
	{
		if(template_id != undefined)
		{
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=call.popup_get_template&width=557&template_id='+template_id+'','fckedit',1);
		}
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.list_asset_failure';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'assetcare/display/list_asset_failure.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.list_asset_failure';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'assetcare/form/form_add_asset_failure.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'assetcare/query/add_asset_failue.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_asset_failure&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.list_asset_failure';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'assetcare/form/form_upd_asset_failure.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'assetcare/query/upd_asset_failure.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_asset_failure&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'failure_id=##attributes.failure_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.failure_id##';
		
	if(isdefined('attributes.event') and attributes.event is 'upd')	
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=assetcare.list_asset_failure&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.failure_id#&print_type=254','page','workcube_print')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		if(fusebox.circuit eq 'assetcare')
			url_del="#request.self#?fuseaction=assetcare.emptypopup_del_asset_failure&failure_id=#attributes.failure_id#";
		else
			url_del="#request.self#?fuseaction=assetcare.emptypopup_del_asset_failure&failure_id=#attributes.failure_id#&correspondence=1";

		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#url_del#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'assetcare/query/del_asset_failure.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'assetcare/query/del_asset_failure.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_asset_failure';
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'assetCareFailure';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ASSET_FAILURE_NOTICE';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-care_type','item-head','item-failure_date','item-document_no','item-process_stage']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
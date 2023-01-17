<cf_get_lang_set module_name ="settings">
<cfif not isdefined("attributes.event") or attributes.event is 'list'>
    <cf_xml_page_edit fuseact="settings.list_quality_control_types">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.process_cat_id" default="">
    <cfparam name="attributes.is_active" default="1">
    <cfparam name="attributes.search_type" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="quality_control_type" datasource="#dsn3#">
            SELECT
                0 SORT_TYPE,
                '' AS RESULT_ID,
                TYPE_ID,
                QUALITY_CONTROL_TYPE,
                TYPE_DESCRIPTION,
                STANDART_VALUE,
                QUALITY_MEASURE,
                TOLERANCE,
                IS_ACTIVE
            FROM
                QUALITY_CONTROL_TYPE
            WHERE
                <cfif ListFind("1,0",attributes.is_active)>
                    IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_active#"> AND
                </cfif>
                <cfif len(attributes.keyword)>
                    (
                        QUALITY_CONTROL_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        TYPE_DESCRIPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    ) AND
                </cfif>
                <cfif Len(attributes.process_cat_id)>
                    PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat_id#"> AND
                </cfif>
                1= 1
        <cfif attributes.search_type eq 2>
        UNION ALL
            SELECT
                1 SORT_TYPE,
                QUALITY_CONTROL_ROW.QUALITY_CONTROL_ROW_ID RESULT_ID,
                QUALITY_CONTROL_ROW.QUALITY_CONTROL_TYPE_ID TYPE_ID,
                QUALITY_CONTROL_ROW.QUALITY_CONTROL_ROW QUALITY_CONTROL_TYPE,
                QUALITY_CONTROL_ROW.QUALITY_ROW_DESCRIPTION TYPE_DESCRIPTION,
                QUALITY_CONTROL_TYPE.STANDART_VALUE,
                QUALITY_CONTROL_TYPE.QUALITY_MEASURE,
                QUALITY_CONTROL_TYPE.TOLERANCE,
                QUALITY_CONTROL_TYPE.IS_ACTIVE
            FROM
                QUALITY_CONTROL_ROW,
                QUALITY_CONTROL_TYPE
            WHERE
                <cfif ListFind("1,0",attributes.is_active)>
                    IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_active#"> AND
                </cfif>
                <cfif len(attributes.keyword)>
                    (	QUALITY_CONTROL_TYPE.QUALITY_CONTROL_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        QUALITY_CONTROL_TYPE.TYPE_DESCRIPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        QUALITY_CONTROL_ROW.QUALITY_CONTROL_ROW LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    ) AND
                </cfif>
                <cfif Len(attributes.process_cat_id)>
                    QUALITY_CONTROL_TYPE.PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat_id#"> AND
                </cfif>
                QUALITY_CONTROL_ROW.QUALITY_CONTROL_TYPE_ID = QUALITY_CONTROL_TYPE.TYPE_ID	
        </cfif>
            ORDER BY
                TYPE_ID,
                SORT_TYPE
        </cfquery>
    <cfelse>
        <cfset quality_control_type.recordcount = 0>
    </cfif>
    <cfparam name="attributes.totalrecords" default="#quality_control_type.recordcount#">
<cfelseif isdefined("attributes.event") and listfind('upd,add',attributes.event)>
    <cfif isdefined("attributes.type_id")>
        <cfquery name="get_control_type" datasource="#dsn3#">
            SELECT 
                TYPE_ID, 
                IS_ACTIVE, 
                QUALITY_CONTROL_TYPE, 
                TYPE_DESCRIPTION, 
                STANDART_VALUE, 
                TOLERANCE, 
                QUALITY_MEASURE, 
                TOLERANCE_2, 
                PROCESS_CAT_ID, 
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP 
            FROM 
                QUALITY_CONTROL_TYPE 
            WHERE 
                TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#">
        </cfquery>
        <cfscript>
            type_id = get_control_type.type_id;
            control_type = get_control_type.quality_control_type;
            detail= get_control_type.type_description;
            default_value=get_control_type.standart_value;
            meausure_value=get_control_type.quality_measure;
            tolerans_value=get_control_type.tolerance;	
            status=	get_control_type.is_active;
            process_cat_id = get_control_type.process_cat_id;
        </cfscript>
        <cfquery name="get_all_rows" datasource="#dsn3#">
            SELECT 
                QUALITY_CONTROL_ROW_ID, 
                QUALITY_CONTROL_ROW, 
                QUALITY_CONTROL_TYPE_ID, 
                QUALITY_ROW_DESCRIPTION, 
                QUALITY_VALUE, 
                TOLERANCE, 
                TOLERANCE_2, 
                RESULT_TYPE, 
                RECORD_DATE,
                RECORD_IP, 
                RECORD_EMP, 
                UPDATE_DATE, 
                UPDATE_IP, 
                UPDATE_EMP 
            FROM 
                QUALITY_CONTROL_ROW 
            WHERE 
                QUALITY_CONTROL_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#">
        </cfquery>
    <cfelse>
        <cfscript>
            type_id = '';
            control_type = '';
            detail= '';
            default_value='';
            meausure_value='';
            tolerans_value='';
            status=1;
            process_cat_id='';
        </cfscript>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add_relation'>
    <cfif isdefined("attributes.result_id")>
        <cfquery name="get_control_result" datasource="#dsn3#">
            SELECT 
                QUALITY_CONTROL_ROW_ID, 
                QUALITY_CONTROL_ROW, 
                QUALITY_CONTROL_TYPE_ID, 
                QUALITY_ROW_DESCRIPTION, 
                QUALITY_VALUE, 
                TOLERANCE,
                TOLERANCE_2, 
                RESULT_TYPE, 
                RECORD_DATE, 
                RECORD_IP, 
                RECORD_EMP, 
                UPDATE_DATE, 
                UPDATE_IP, 
                UPDATE_EMP 
            FROM 
                QUALITY_CONTROL_ROW 
            WHERE 
                QUALITY_CONTROL_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
        </cfquery>
        <cfquery name="upd_quality_type" datasource="#dsn3#"> 
            SELECT 
                TYPE_ID, 
                IS_ACTIVE, 
                QUALITY_CONTROL_TYPE, 
                TYPE_DESCRIPTION, 
                STANDART_VALUE, 
                TOLERANCE, 
                QUALITY_MEASURE, 
                TOLERANCE_2, 
                PROCESS_CAT_ID, 
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP 
            FROM 
                QUALITY_CONTROL_TYPE 
            WHERE 
                TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_control_result.quality_control_type_id#">
        </cfquery>
        <cfscript>
            result_id = attributes.result_id;
            type_id = get_control_result.QUALITY_CONTROL_TYPE_ID;
            type_name = upd_quality_type.QUALITY_CONTROL_TYPE;
            control_type= get_control_result.QUALITY_CONTROL_ROW;
            result_type= get_control_result.RESULT_TYPE;
            detail=get_control_result.QUALITY_ROW_DESCRIPTION;
            default_value=get_control_result.QUALITY_VALUE;
            tolerance=get_control_result.TOLERANCE;
            tolerance_2=get_control_result.TOLERANCE_2;
        </cfscript>
    <cfelse>
        <cfquery name="upd_quality_type" datasource="#dsn3#"> 
            SELECT 
                TYPE_ID, 
                IS_ACTIVE, 
                QUALITY_CONTROL_TYPE, 
                TYPE_DESCRIPTION, 
                STANDART_VALUE, 
                TOLERANCE, 
                QUALITY_MEASURE, 
                TOLERANCE_2, 
                PROCESS_CAT_ID, 
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP 
            FROM 
                QUALITY_CONTROL_TYPE 
            WHERE 
                TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#">
        </cfquery>
        <cfscript>
            result_id = '';
            type_id = upd_quality_type.TYPE_ID;
            type_name = upd_quality_type.QUALITY_CONTROL_TYPE;
            control_type='';
            result_type= "";
            detail='';
            default_value='';
            tolerance='';
            tolerance_2='';
        </cfscript>
    </cfif>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.event") or attributes.event is 'list'>
		<cfif attributes.search_type eq 1>
			function connectAjax(crtrow,type_id)
			{
				var load_url_ = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.emptypopupajax_list_quality_control_results&type_id="+type_id+"&keyword="+document.getElementById("keyword").value;
				AjaxPageLoad(load_url_,'display_quality_type_results'+crtrow,1);
			}
		</cfif>
	<cfelseif isdefined("attributes.event") and attributes.event is 'add_relation'>
		function control()
		{
			if(document.getElementById("result_type") != undefined && document.getElementById("result_type").value == 0)
			{
				if(document.getElementById("default_value").value == "")
				{
					alert("<cf_get_lang no='1720.Sonuç-Değer'><cf_get_lang no ='1756.Değerini Giriniz'>");	
					return false;
				}
				if(document.getElementById("tolerance").value == "")
				{
					alert("<cf_get_lang_main no='1646.Tolerans'><cf_get_lang no ='1756.Değerini Giriniz'>");	
					return false;
				}
				if(document.getElementById("tolerance_2").value == "")
				{
					alert("<cf_get_lang_main no='1646.Tolerans'> 2<cf_get_lang no ='1756.Değerini Giriniz'>");	
					return false;
				}
			}
			return true;
		}
		function show_values(x)
		{
			if(x == 1)
			{
				document.getElementById("item-default_value").style.display = "none";
				document.getElementById("item-tolerance").style.display = "none";
				document.getElementById("item-tolerance_2").style.display = "none";
			}
			else
			{
				document.getElementById("item-default_value").style.display = "";
				document.getElementById("item-tolerance").style.display = "";
				document.getElementById("item-tolerance_2").style.display = "";
			}
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.list_quality_control_types';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'settings/display/list_quality_control_types.cfm';
	WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'settings/query/add_gelenh.cfm';
	WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'settings.form_add_gelenh&event=upd';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.popup_add_qualty_control_types';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'settings/form/add_qualty_control_type.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'settings/query/add_quality_type.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.list_quality_control_types';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.popup_add_qualty_control_types';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'settings/form/add_qualty_control_type.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'settings/query/add_quality_type.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.list_quality_control_types';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'type_id=##attributes.type_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.type_id##';
	
	WOStruct['#attributes.fuseaction#']['add_relation'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_relation']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_relation']['fuseaction'] = 'settings.popup_add_quality_control_result';
	WOStruct['#attributes.fuseaction#']['add_relation']['filePath'] = 'settings/form/add_quality_control_result.cfm';
	WOStruct['#attributes.fuseaction#']['add_relation']['queryPath'] = 'settings/query/add_quality_control_result.cfm';
	WOStruct['#attributes.fuseaction#']['add_relation']['nextEvent'] = 'settings.list_quality_control_types';
	if(isdefined("attributes.result_id"))
	{
		WOStruct['#attributes.fuseaction#']['add_relation']['parameters'] = 'result_id=##attributes.result_id##';
		WOStruct['#attributes.fuseaction#']['add_relation']['Identity'] = '##attributes.result_id##';
	}

	
	if(isdefined("attributes.event") and attributes.event is 'add_relation' and isdefined("attributes.result_id"))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=settings.emptypopup_del_q_control_result&id=#attributes.result_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'settings/query/del_quality_control_result.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'settings/query/del_quality_control_result.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'settings.list_quality_control_types';
	}
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=settings.emptypopup_del_q_control_type&id=#attributes.type_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'settings/query/del_quality_control_type.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'settings/query/del_quality_control_type.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'settings.list_quality_control_types';
	}
	if(listfind("add,upd",attributes.event)){
		WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
		WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'prodQualityControlTypes';
		WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'QUALITY_CONTROL_TYPE';
		WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-control_type']";
	}
	if(listfind("add_relation",attributes.event)){
		WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
		WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'prodQualityControlTypes';
		WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add_relation';
		WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'QUALITY_CONTROL_ROW';
		WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-default_value','item-tolerance','item-tolerance_2']";
	}

</cfscript>

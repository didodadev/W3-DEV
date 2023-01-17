<cf_xml_page_edit fuseact="assetcare.form_add_care_period"> 
<cf_get_lang_set module_name="assetcare">
<cfif not isdefined("attributes.event") or attributes.event is 'list'>
    <cfinclude template="../assetcare/form/care_period_options.cfm">
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
    <cfparam name="attributes.period" default="">
    <cfif isdate(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
    <cfif isdate(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
    <cfquery name="GET_BRANCH" datasource="#dsn#">
        SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
    </cfquery>
    <cfquery name="GET_ASSET_CAT" datasource="#dsn#">
        SELECT ASSET_CARE_ID, ASSET_CARE FROM ASSET_CARE_CAT ORDER BY ASSET_CARE
    </cfquery>
    <cfif len(attributes.form_submitted)>
        <cfinclude template="../assetcare/query/list_care_info.cfm">
        <cfparam name="attributes.totalrecords" default='#get_work_asset_care.recordcount#'>
    <cfelse>
        <cfparam name="attributes.totalrecords" default='0'>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.startrow" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
    <cfinclude template="../assetcare/form/care_period_options.cfm">
    <cfif isdefined("attributes.failure_id")>
        <cfquery name="GET_ASSET_FAILURE" datasource="#DSN#">
            SELECT 
                ASSET_FAILURE_NOTICE.STATION_ID,
                ASSET_FAILURE_NOTICE.ASSET_CARE_ID,
                ASSET_P.ASSETP_ID,
                ASSET_CARE_CAT.ASSET_CARE
            FROM
                ASSET_FAILURE_NOTICE,
                ASSET_P,
                ASSET_CARE_CAT
            WHERE
                FAILURE_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.failure_id#"> AND
                ASSET_P.ASSETP_ID = ASSET_FAILURE_NOTICE.ASSETP_ID AND
                ASSET_FAILURE_NOTICE.ASSET_CARE_ID = ASSET_CARE_CAT.ASSET_CARE_ID
        </cfquery>
        <cfif len(get_asset_failure.assetp_id)>
            <cfquery name="GET_ASSETP" datasource="#DSN#">
                SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_asset_failure.assetp_id#"> 
            </cfquery>
        </cfif>
        <cfif len(get_asset_failure.asset_care_id)>
            <cfquery name="GET_CARE" datasource="#DSN#">
                SELECT 
                    CS.OUR_COMPANY_ID,
                    ACC.ASSET_CARE,
                    CS.CARE_STATE_ID
                FROM
                    CARE_STATES CS,
                    ASSET_CARE_CAT ACC
                WHERE
                    ACC.ASSET_CARE_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_asset_failure.asset_care_id#"> AND
                    CS.CARE_ID = ACC.ASSET_CARE_ID AND
                    CS.CARE_STATE_ID = ACC.ASSET_CARE_ID
            </cfquery>
        </cfif>
    </cfif>
    <cfset i=0>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cfinclude template="../assetcare/form/care_period_options.cfm">
    <cfquery name="GET_CARE" datasource="#DSN#">
        SELECT 
            CARE_STATES.CARE_ID,
            CARE_STATES.ASSET_ID,
            CARE_STATES.CARE_STATE_ID,
            CARE_STATES.DETAIL,
            CARE_STATES.PERIOD_ID,
            CARE_STATES.CARE_KM,
            CARE_STATES.PERIOD_TIME,
            CARE_STATES.OFFICIAL_EMP_ID,
            CARE_STATES.CARE_DAY,
            CARE_STATES.CARE_HOUR,
            CARE_STATES.CARE_MINUTE,
            CARE_STATES.STATION_ID,
            CARE_STATES.OUR_COMPANY_ID,
            ASSET_P.ASSETP,
            ASSET_P.ASSETP_ID,
            ASSET_CARE_CAT.ASSET_CARE,
            ASSET_CARE_CAT.IS_YASAL,
            CARE_STATES.PROCESS_STAGE,
            CARE_STATES.RECORD_EMP,
            CARE_STATES.UPDATE_EMP,
            CARE_STATES.RECORD_DATE,
            CARE_STATES.UPDATE_DATE
        FROM
            CARE_STATES,
            ASSET_P,
            ASSET_CARE_CAT
        WHERE
            CARE_ID = #attributes.care_id# AND
            ASSET_P.ASSETP_ID = CARE_STATES.ASSET_ID AND
            CARE_STATES.CARE_STATE_ID = ASSET_CARE_CAT.ASSET_CARE_ID
    </cfquery>
    <cfquery name="get_asset_report" datasource="#dsn#">
        SELECT CARE_REPORT_ID FROM ASSET_CARE_REPORT WHERE CARE_ID = #attributes.care_id#
    </cfquery>
    <cfquery name="get_asset_care_cat" datasource="#dsn#">
        SELECT 
            ACC.ASSET_CARE_ID, 
            ACC.ASSET_CARE,
            ACC.IS_YASAL
        FROM 
            ASSET_CARE_CAT ACC, 
            ASSET_P A 
        WHERE 
            <cfif len(get_care.asset_id)>A.ASSETP_ID = #get_care.asset_id#</cfif>
            <cfif len(get_care.is_yasal)>AND ACC.IS_YASAL = #get_care.is_yasal# AND</cfif>
            A.ASSETP_CATID = ACC.ASSETP_CAT
    </cfquery>
    <cfif get_care.is_yasal eq 1>
        <cfset son_deger=1>
    <cfelse>
        <cfset son_deger=0>
    </cfif>
    <cfset i=0>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.event") or attributes.event is 'list'>
		$(document).ready(function(){
				$('#keyword').focus();
			});
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		function unformat_fields()
		{
			if(document.getElementById('care_km_period') != undefined) document.getElementById('care_km_period').value = filterNum(document.getElementById('care_km_period').value);
			return process_cat_control();
		}
		function kontrol()
		{
			if(document.getElementById('assetp_name').value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1655.Varlık'>!");
				return false;
			}
			if(document.getElementById('care_type_id').value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='42.Bakım Tipi'>!");
				return false;
			}
			if(document.getElementById('care_date').value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='41.Bakım Tarihi'>!");
				return false;
			}
			if(!CheckEurodate(document.getElementById('care_date').value,"<cf_get_lang no='41.Bakım Tarihi'>"))
			{
				return false;
			}
			unformat_fields();
			return true;
		}
		
		function pencere_ac()
		{
			if (document.getElementById('assetp_id') == undefined || document.getElementById('assetp_id').value == "")
				alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no='73.öncelik'>-<cf_get_lang_main no='1068.Araç'>");
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_care_type&field_id=formCare.care_type_id&field_name=formCare.care_type&asset_id=' + formCare.assetp_id.value,'list','popup_list_care_type');
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		function unformat_fields()
		{
			if(document.getElementById('care_km_period') != undefined) document.getElementById('care_km_period').value = filterNum(document.getElementById('care_km_period').value);
			return process_cat_control();
		}
		function pencere_ac()
		{
			
			assetp_id_ = $('#assetp_id').val();
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_care_type&field_id=formCare.care_type_id&field_name=formCare.care_type&asset_id=' + assetp_id_+ '&is_yasal=' + <cfoutput>#son_deger#</cfoutput> ,'list','popup_list_care_type');
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'assetcare.list_assetp_period';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'assetcare/display/list_assetp_period.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.list_assetp_period&event=add';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'assetcare/form/add_care_period.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'assetcare/query/add_care_period.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'assetcare.list_assetp_period&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.list_assetp_period&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'assetcare/form/upd_care_period.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'assetcare/query/upd_care_period.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'assetcare.list_assetp_period&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'care_id=##attributes.care_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.care_id##';
	
	if(attributes.event is 'upd' or attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=assetcare.emptypopup_del_asset_report&care_id=#attributes.care_id#&event=del';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'assetcare/query/del_asset_report.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'assetcare/query/del_asset_report.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'assetcare.list_assetp_period';
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'assetCarePeriod';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CARE_STATES';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-assetp_id','item-care_type_id','item-care_date']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
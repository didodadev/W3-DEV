<cfif not isdefined("attributes.event") or attributes.event is 'list'>
	<cf_get_lang_set module_name ="prod">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.start_dates" default="">
    <cfparam name="attributes.finish_dates" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.is_filter" default="">
    <cfquery name="GET_BRANCH" datasource="#DSN#">
        SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> ORDER BY BRANCH_NAME
    </cfquery>
    <cfif len(attributes.branch_id)>
        <cfquery name="get_departmens" datasource="#dsn#">
            SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID = #attributes.branch_id#
        </cfquery>
    </cfif>
    <cfif isdefined("attributes.start_dates") and isdate(attributes.start_dates)>
        <cf_date tarih = "attributes.start_dates">
    </cfif>
    <cfif isdefined("attributes.finish_dates") and isdate(attributes.finish_dates)>
        <cf_date tarih = "attributes.finish_dates">
    </cfif>
    <cfif isdefined('attributes.is_filter') and attributes.is_filter eq 1>
        <cfquery name="get_shifts" datasource="#dsn#">
            SELECT
                S.*,
                B.BRANCH_NAME,
                D.DEPARTMENT_HEAD
            FROM
                SETUP_SHIFTS S
                LEFT JOIN BRANCH B ON B.BRANCH_ID = S.BRANCH_ID
                LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = S.DEPARTMENT_ID
            WHERE
                 S.IS_PRODUCTION = 1
                <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
                    AND S.SHIFT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar"  value="%#attributes.keyword#%">
                </cfif>
                <cfif isdefined('attributes.start_dates') and len(attributes.start_dates)>AND S.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_dates#"></cfif>
                <cfif isdefined('attributes.finish_dates') and len(attributes.finish_dates)>AND S.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_dates#"></cfif>
                <cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>AND S.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> </cfif>
                <cfif isdefined('attributes.DEPARTMENT_ID') and len(attributes.DEPARTMENT_ID)>AND S.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> </cfif>
        </cfquery>
    <cfelse>
        <cfset get_shifts.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_shifts.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cf_get_lang_set module_name ="ehesap">
    <cfquery name="GET_BRANCH" datasource="#DSN#">
        SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cf_get_lang_set module_name ="ehesap">
	<cfinclude template="../hr/ehesap/query/get_shift.cfm">
	<cfif isdefined('attributes.is_production') or get_shift.is_production eq 1>
        <cfquery name="GET_BRANCH" datasource="#DSN#">
            SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> ORDER BY BRANCH_NAME
        </cfquery>
    </cfif>
    <cfset xfa.del = "ehesap.emptypopup_del_shift">
    <cfif len(get_shift.branch_id)>
        <cfquery name="GET_DEP" datasource="#dsn#">
            SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND IS_STORE <> 1 AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_shift.branch_id#">
        </cfquery>
    </cfif>
</cfif>
<script type="text/javascript">
function get_departments(branch_id)
	{
		var get_dep = wrk_safe_query('prdp_get_dep','dsn',0,branch_id)
		document.getElementById('department_id').options.length=0;
		document.getElementById('department_id').options[0] = new Option('Departman','');
		if (get_dep.recordcount)
		{
			for(var jj=0;jj<get_dep.recordcount;jj++)
			document.getElementById('department_id').options[jj+1] = new Option(get_dep.DEPARTMENT_HEAD[jj],get_dep.DEPARTMENT_ID[jj]);
		}
	}
<cfif not isdefined("attributes.event") or attributes.event is 'list'>
	function kontrol()
	{
		if(document.getElementById('finish_dates').value != '' && document.getElementById('start_dates').value != '')
		{
			if( !date_check(document.getElementById('start_dates'),document.getElementById('finish_dates'), "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			else
				return true;
		}
		else
			return true;
	}
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	function control()
	{
		if(document.getElementById('branch_id').value == 0)
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='41.Şube'>");
				return false;
			}
		if (!time_check(document.getElementById('startdate'), document.getElementById('start_hour'), document.getElementById('start_min'), document.getElementById('finishdate'), document.getElementById('end_hour'), document.getElementById('end_min'), "Geçerlilik Tarihi / Vardiya Aralığı Değerlerini Kontrol Ediniz. Başlama Değeri, Bitiş Değerinden Büyük Olamaz !"))
		return false;
		document.getElementById('control_hour_1').value = filterNum(document.getElementById('control_hour_1').value);
		document.getElementById('control_hour_2').value = filterNum(document.getElementById('control_hour_2').value);
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.list_ws_time';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'production_plan/display/list_ws_time.cfm';
	WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'production_plan/display/list_ws_time.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.list_ws_time&event=add&is_production=1';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/form_add_shift.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_shift.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.list_ws_time&event=upd&is_production=1';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'prod.list_ws_time&event=upd&is_production=1';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/form_upd_shift.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_shift.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'prod.list_ws_time';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'shift_id=##attributes.shift_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.shift_id##';
			
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#xfa.del#&SHIFT_ID=#attributes.shift_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_shift.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_shift.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'prod.list_ws_time';

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=prod.list_ws_time&event=add&is_production=1&window=popup";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

</cfscript>
<cfsetting showdebugoutput="yes">
<cf_get_lang_set module_name="settings">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.is_active" default=1>
	<cfparam name="attributes.keyword" default=''>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfif isdefined("attributes.form_submitted")>
		<cfquery name="get_zones" datasource="#dsn#">
			SELECT
				HIERARCHY,
				ZONE_STATUS,
				ZONE_ID,
				ZONE_NAME
			FROM
				ZONE
			WHERE
				ZONE_ID IS NOT NULL
				<cfif len(attributes.keyword) and (len(attributes.keyword) eq 1)>
					AND ZONE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
				<cfelseif len(attributes.keyword) and (len(attributes.keyword) gt 1)>
					AND ZONE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				</cfif>
				<cfif attributes.is_active neq 2>
					AND ZONE_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_active#">
				</cfif>
			ORDER BY
				ZONE_NAME
		</cfquery>
	<cfelse>
		<cfset get_zones.recordcount = 0>
	</cfif>
	<cfparam name="attributes.totalrecords" default="#get_zones.recordcount#">
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfinclude template="../settings/query/get_zone_branch_count.cfm">
	<cfquery name="CATEGORY" datasource="#dsn#">
		SELECT 
	        Z.ZONE_STATUS, 
            Z.ZONE_ID, 
            Z.ZONE_NAME, 
            Z.ZONE_DETAIL, 
            Z.ADMIN1_POSITION_CODE, 
            Z.ADMIN2_POSITION_CODE,
            Z.ZONE_TELCODE, 
            Z.ZONE_TEL1, 
            Z.ZONE_TEL2, 
            Z.ZONE_TEL3, 
            Z.ZONE_FAX, 
            Z.ZONE_EMAIL, 
            Z.ZONE_ADDRESS, 
            Z.POSTCODE, 
            Z.COUNTY, 
            Z.CITY, 
            Z.COUNTRY, 
            Z.RECORD_DATE, 
            Z.RECORD_EMP, 
            Z.RECORD_IP, 
            Z.UPDATE_DATE, 
            Z.UPDATE_IP, 
            Z.UPDATE_EMP, 
            Z.IS_ORGANIZATION, 
            Z.HIERARCHY,
            EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS ADMIN1_NAME,
			EP2.EMPLOYEE_NAME + ' ' + EP2.EMPLOYEE_SURNAME AS ADMIN2_NAME
        FROM 
            ZONE Z
            LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = Z.ADMIN1_POSITION_CODE AND EP.POSITION_STATUS = 1
			LEFT JOIN EMPLOYEE_POSITIONS EP2 ON EP2.POSITION_CODE = Z.ADMIN2_POSITION_CODE AND EP2.POSITION_STATUS = 1
        WHERE 
        	Z.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
	</cfquery>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function(){
	   		$('#keyword').focus();
	   	});
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_zones';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'settings/display/list_zones.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.list_zones';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'settings/form/add_zone.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'settings/query/add_zone.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_zones&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.list_zones';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'settings/form/upd_zone.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'settings/query/upd_zone.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_zones&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##category.zone_name##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.list_zones';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'settings/query/del_zone.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'settings/query/del_zone.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_zones';
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array.item[545]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_zones&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	if ((isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event"))
	{
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
		url_str = "";
		if (isdefined("attributes.form_submitted") and len(attributes.form_submitted))
			url_str = "#url_str#&form_submitted=#attributes.form_submitted#";
		if (isdefined("attributes.keyword") and len(attributes.keyword))
			url_str = "#url_str#&keyword=#attributes.keyword#";
		if (isdefined("attributes.is_active") and len(attributes.is_active))
			url_str = "#url_str#&is_active=#attributes.is_active#";
	}
	
</cfscript>

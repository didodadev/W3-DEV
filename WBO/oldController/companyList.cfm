<cfif isdefined("attributes.event") and attributes.event is 'det'>
	<cfquery name="check" datasource="#dsn#">
		SELECT
	    	COMP_ID,
	        COMPANY_NAME,
	        NICK_NAME,
	        TAX_OFFICE,
	        TAX_NO,
	        TEL_CODE,
	        TEL,
	        FAX,
	        MANAGER,
	        MANAGER_POSITION_CODE,
	        MANAGER_POSITION_CODE2,
	        WEB,
	        EMAIL,
	        ADDRESS,
	        ADMIN_MAIL,
	        TEL2,
	        TEL3,
	        TEL4,
	        FAX2,
	        T_NO,
	        SERMAYE,
	        CHAMBER,
	        CHAMBER_NO,
	        CHAMBER2,
	        CHAMBER2_NO,
	        ASSET_FILE_NAME1,
	        ASSET_FILE_NAME1_SERVER_ID,
	        ASSET_FILE_NAME2,
	        ASSET_FILE_NAME2_SERVER_ID,
	        ASSET_FILE_NAME3,
	        ASSET_FILE_NAME3_SERVER_ID,
	        IS_ORGANIZATION
	    FROM
		    OUR_COMPANY
	    WHERE
	    	COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#">
	</cfquery>
</cfif>
<cfscript>
	if ((isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event"))
	{
		cmp_company = createObject("component","hr.cfc.get_our_company");
		cmp_company.dsn = dsn;
		get_company = cmp_company.get_company();
		formun_adresi = 'hr.company_info_list&hr=1';
	}
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.company_info_list';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/company_info_list.cfm';
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'hr.company_info_list';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'hr/form/form_add_company_info.cfm';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'comp_id=##attributes.comp_id##';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##check.nick_name##';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = '';
</cfscript>

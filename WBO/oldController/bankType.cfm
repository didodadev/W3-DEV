<cfif not isDefined('attributes.event') or attributes.event is 'list'>
	<cfif isdefined("attributes.form_submitted")>
        <cfquery name="GET_BANK_TYPES" datasource="#DSN#">
            SELECT
            	BANK_CODE,
                BANK_ID,
                BANK_NAME,
                DETAIL,
                RECORD_DATE
            FROM 
                SETUP_BANK_TYPES
            WHERE 
                BANK_ID IS NOT NULL 
                <cfif len(attributes.keyword)>
                    AND 
                    (BANK_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                     BANK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
                </cfif>
            ORDER BY
                BANK_NAME
        </cfquery>
    <cfelse>
        <cfset get_bank_types.recordcount=0>
    </cfif>
    <cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfparam name="attributes.totalrecords" default="#get_bank_types.recordcount#">
	<cfset url_str = "#iif(fusebox.circuit eq 'ehesap',DE('ehesap'),DE('finance'))#.list_bank_types">
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
		<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
	</cfif>
<cfelseif isDefined('attributes.event') and attributes.event is 'upd'>
    <cfquery name="GET_BANK_TYPE" datasource="#DSN#">
        SELECT 
            BANK_ID, 
            BANK_NAME, 
            DETAIL, 
            COMPANY_ID, 
            RECORD_EMP, 
            RECORD_DATE, 
            RECORD_IP, 
            UPDATE_EMP, 
            UPDATE_DATE, 
            UPDATE_IP, 
            EXPORT_TYPE, 
            BANK_CODE, 
            FTP_SERVER_NAME, 
            FTP_FILE_PATH, 
            FTP_USERNAME, 
            FTP_PASSWORD 
        FROM 
            SETUP_BANK_TYPES 
        WHERE 
            BANK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
    </cfquery>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.popup_add_bank_type';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'finance/form/add_bank_type.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'finance/query/add_bank_types.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#iif(fusebox.circuit eq "ehesap",DE("ehesap"),DE("finance"))#.list_bank_types&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'finance.popup_upd_bank_type';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'finance/form/upd_bank_type.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'finance/query/upd_bank_type.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#iif(fusebox.circuit eq "ehesap",DE("ehesap"),DE("finance"))#.list_bank_types&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_bank_type.bank_name##';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.popup_add_bank_type';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'finance/display/list_bank_types.cfm';
	
	if(isDefined('attributes.event') and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=finance.list_bank_types&event=add";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'bankType.cfm';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SETUP_BANK_TYPES';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-bank_type']";
</cfscript>

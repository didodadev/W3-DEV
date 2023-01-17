<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
	<cfparam name="attributes.sal_year" default="#year(now())#">
	
	<cfscript>
		include "../hr/ehesap/query/get_ssk_offices.cfm";
	</cfscript>
	
	<cfif isDefined("attributes.print")>
		<script type="text/javascript">
			function waitfor(){
			  window.close();
			}
			setTimeout("waitfor()",3000);
			window.opener.close();
			window.print();
		</script>
	</cfif>
	
	<cfif isdefined("attributes.ssk_office")>
		<cfquery name="GET_COMPANY_INFO" datasource="#dsn#">
			SELECT COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		</cfquery>
		
		<cfquery name="GET_BRANCH_INFO" datasource="#dsn#">
			SELECT * FROM BRANCH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_office#">
		</cfquery>
		
		<cfparam name="attributes.maxrows" default=16>
		<cfparam name="attributes.mode" default=16>
		<cfinclude template="../hr/ehesap/query/get_ssk_employees_full.cfm">
	</cfif>
</cfif>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hesap.popup_ssk_worker_notify';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/ssk_worker_notify.cfm';
</cfscript>

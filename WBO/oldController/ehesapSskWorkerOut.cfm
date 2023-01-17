<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
	<cfparam name="attributes.sal_year" default="#year(now())#">
	<cfscript>
		include "../hr/ehesap/query/get_ssk_offices.cfm";
	</cfscript>
	<cfparam name="attributes.SSK_OFFICE" default="">
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
	
	<cfif isdefined("attributes.ssk_office") and len(attributes.ssk_office)>
		<cfquery name="GET_BRANCH_INFO" datasource="#dsn#">
			SELECT * FROM BRANCH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_office#">
			<!--- <cfif database_type is "MSSQL">
				SSK_OFFICE + '-' + SSK_NO = '#attributes.SSK_OFFICE#'
			<cfelseif database_type is "DB2">
				SSK_OFFICE || '-' || SSK_NO = '#attributes.SSK_OFFICE#'
			</cfif> --->
		</cfquery>
		
		<cfset first_day_of_month = CreateDate(session.ep.period_year,attributes.sal_mon,1)>
		<cfset last_day_of_month = date_add("d",1,createDate(session.ep.period_year,attributes.sal_mon,daysInMonth(first_day_of_month)))>
		<cfinclude template="../hr/ehesap/query/get_employees_out.cfm">
		<cfparam name="attributes.maxrows" default=15>
		<cfparam name="attributes.mode" default=15>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.popup_ssk_worker_out';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/ssk_worker_out.cfm';
</cfscript>

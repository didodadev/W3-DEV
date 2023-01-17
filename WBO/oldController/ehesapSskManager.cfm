<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfinclude template="../hr/ehesap/query/get_ssk_offices.cfm">
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
		<cfinclude template="../hr/ehesap/query/get_branch.cfm">
		<cfset attributes.position_code = get_branch.admin1_position_code>
		<cfinclude template="../hr/ehesap/query/get_hr_homeadress.cfm">
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.popup_ssk_manager';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/ssk_manager.cfm';
</cfscript>

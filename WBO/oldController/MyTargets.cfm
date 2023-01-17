<cf_get_lang_set module_name="myhome">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.page" default=1>
    <cfif isdefined('attributes.is_submit')>
        <cfinclude template="../myhome/query/get_targets.cfm">
    <cfelse>
        <cfset get_targets.recordcount = 0>
    </cfif>
    <cfinclude template="../myhome/query/get_departments.cfm">
    <cfparam name="attributes.totalrecords" default=#get_targets.recordcount#>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$( document ).ready(function() {
			document.getElementById('keyword').focus();
		});
	</cfif>
</script>


<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.my_targets';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/my_targets.cfm';
</cfscript>

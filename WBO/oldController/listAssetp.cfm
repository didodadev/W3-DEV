<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.asset_cat" default="">
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
	SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT ORDER BY ASSETP_CAT
</cfquery>
<cfif isdefined("is_form_submitted")>
	<cfinclude template="../myhome/query/get_assetps.cfm">
	<cfparam name='attributes.totalrecords' default="#get_assetps.recordcount#">
<cfelse>
	<cfparam name='attributes.totalrecords' default="0">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfif isdefined("attributes.is_form_submitted")>
	<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
</cfif>
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.asset_cat)>
	<cfset url_str = "#url_str#&asset_cat=#attributes.asset_cat#">
</cfif>
<script type="text/javascript">
	$(document).ready(function(){
		document.getElementById('keyword').focus();
	});
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_assetp';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_assetp.cfm';

</cfscript>

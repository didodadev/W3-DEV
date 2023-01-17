<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.process_cat" default="">
<cfparam name="attributes.headx" default="aa">
<cf_catalystHeader>
    <cfparam name="attributes.headx" default="aa">
<cfset postaction = "dev.emptypopup_upd_fuseaction">
<cfset list_wbo = createObject("component", "WDO.development.cfc.list_wbo")>
<cfset WBO_TYPES = list_wbo.getWboList()>
<cfset process_type_list = list_wbo.getProcessTypes()>
<cfif not isdefined("attributes.woid")>
    <cfset attributes.woid = 0>
    <cfset postaction = "dev.emptypopup_add_fuseaction">
</cfif>
<cfset GET_WRK_FUSEACTIONS = list_wbo.getWrkFuesactions('#DSN#','#attributes.woid#')>
<cfset RELATED_PROCESS_CAT = list_wbo.getRelatedProcessCat('#DSN#','#attributes.woid#')>
<cfset getSolution = list_wbo.getSolution()>
<cfset getWatomicSol = list_wbo.getWatomicSolution()>
<cfset getWatFamily = list_wbo.getWatomicFamily()>

<!--- <cf_catalystHeader> --->
<cfinclude template="catalogs/designers/wrkdesigner/model.cfm">
<cfinclude template="catalogs/designers/wrkdesigner/layout.cfm">

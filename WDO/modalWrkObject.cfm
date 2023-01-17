<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.process_cat" default="">
<cfset list_wbo = createObject("component", "development.cfc.list_wbo")>
<cfset WBO_TYPES = list_wbo.getWboList()>
<cfset process_type_list = list_wbo.getProcessTypes()>
<cfif not isdefined("attributes.woid")>
	<cfif not isdefined("attributes.fuseactExternal")>
	    <cfset attributes.fuseactExternal = ''>
    </cfif>
    <cfset attributes.woid = list_wbo.getWrkObjectsId('#DSN#','#attributes.fuseact#','#attributes.fuseactExternal#')>
</cfif>

<cfset GET_WRK_FUSEACTIONS = list_wbo.getWrkFuesactions('#DSN#','#attributes.woid#')>
<cfset RELATED_PROCESS_CAT = list_wbo.getRelatedProcessCat('#DSN#','#attributes.woid#')>
<cfset GET_MODULES = list_wbo.getWbo('#dsn#')>
<cfset wbo_type_list = list_wbo.getWboTypeList('#GET_WRK_FUSEACTIONS.TYPE#','#GET_WRK_FUSEACTIONS.IS_ADD#','#GET_WRK_FUSEACTIONS.IS_UPDATE#','#GET_WRK_FUSEACTIONS.IS_DELETE#')>
<cfset getSolution = list_wbo.getSolution()>
<cfset  postaction = "dev.emptypopup_upd_fuseaction" >
<cfinclude template="catalogs/designers/wrkdesigner/model.cfm">
<cfinclude template="catalogs/designers/wrkdesigner/layout.cfm">
<div class="col col-12">
<cfif get_wrk_fuseactions.is_legacy eq 0 or get_wrk_fuseactions.is_legacy eq 1>
	<cfinclude template = "catalogs/designers/wrkdesigner/_controller_and_list.cfm" />
<cfelseif get_wrk_fuseactions.is_legacy eq 2>
	<cfinclude template = "catalogs/designers/wrkdesigner/_widget.cfm" />
	<cfinclude template = "catalogs/designers/wrkdesigner/_event.cfm" />

</cfif>
</div>
<cfinclude template="catalogs/designers/wrkdesigner/scripts.cfm">

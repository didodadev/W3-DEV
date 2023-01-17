<cfsetting showdebugoutput="no">
<cfset result = false>
<cfif isDefined('attributes.qry')>
	<cfinclude template="../../workdata/#attributes.qry#.cfm">
	<cfset get_js_query = evaluate("#attributes.qry#()")>
	<cfset result = true>
</cfif>
var get_js_query=new Object();
get_js_query.result = <cfoutput>#get_js_query#</cfoutput>;

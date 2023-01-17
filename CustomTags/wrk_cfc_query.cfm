<cfset degerim_ = thisTag.GeneratedContent>
<cfset thisTag.GeneratedContent =''>
<cfparam name="attributes.query_name" default="">
<cfparam name="attributes.datasource" default="">
<cfparam name="attributes.order_by" default="">
<cfparam name="attributes.sql_str" default="">
<cfparam name="attributes.maxrows" default="">
<cfparam name="attributes.startrow" default="">
<cfif thisTag.executionMode neq "start">
	<cfinvoke component="cfc.wrk_query" method="get_main_query" returnvariable="get_main_result">
		<cfinvokeargument name="sql_str" value="#degerim_#">
		<cfinvokeargument name="query_name" value="#attributes.query_name#">
		<cfinvokeargument name="order_by" value="#attributes.order_by#">
		<cfinvokeargument name="datasource" value="#attributes.datasource#">
		<cfinvokeargument name="startrow" value="#attributes.startrow#">
		<cfinvokeargument name="maxrows" value="#attributes.maxrows#">
	</cfinvoke>
	<cfset 'caller.#attributes.query_name#' = get_main_result>
<cfelse>
</cfif>

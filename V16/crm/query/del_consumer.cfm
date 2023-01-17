<!--- del_consumer.cfm --->
<cfquery name="del_consumer" datasource="#dsn#">
	DELETE 
		CONSUMER 
	WHERE 
		CONSUMER_ID = #URL.CID#
</cfquery>
<cfif isdefined("url.pot")>
	<cflocation addtoken="no" url="#request.self#?fuseaction=crm.list_consumer_app">
<cfelse>
	<cflocation addtoken="no" url="#request.self#?fuseaction=crm.consumer_list">
</cfif>

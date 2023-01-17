<cffunction name="get_consumer_pos">
	<cfargument name="con_id_f" >
	<cfquery name="get_c" datasource="#DSN#">
		SELECT
			CONSUMER.TITLE,
			CONSUMER_NAME,
			CONSUMER_SURNAME,
			COMPANY
		FROM
			CONSUMER
		WHERE
			CONSUMER_ID=#con_id_f#
	</cfquery>
	<cfif len(get_c.TITLE)><cfset position = get_c.TITLE><cfelse><cfset position = " "></cfif>
	<cfset strd_con=" #get_c.COMPANY#/ / |#position#">
	<cfreturn #strd_con#>
</cffunction>

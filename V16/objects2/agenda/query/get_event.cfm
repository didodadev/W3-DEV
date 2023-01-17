<!--- <cfif (not len(attributes.event_id)) or (not isnumeric(attributes.event_id))>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır!'>");
		history.back(-1);
	</script>
	<cfabort>
</cfif> --->
<cfquery name="GET_EVENT" datasource="#DSN#">
	SELECT 
		*	
	FROM 
		EVENT
	WHERE 
		EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
</cfquery>
<cfquery name="GET_EVENT_RELATED" datasource="#DSN#">
	SELECT 
		*	
	FROM 
		EVENTS_RELATED
	WHERE 
		EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
</cfquery>

<cfif len(get_event.link_id)>
	<cfquery name="GET_EVENT_COUNT" datasource="#DSN#">
		SELECT
			COUNT(EVENT_ID) AS EVENT_COUNT
		FROM
			EVENT
		WHERE
			LINK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_event.link_id#">
	</cfquery>
	<cfquery name="DATE_DIFF" datasource="#DSN#" maxrows="2">
		SELECT
			STARTDATE
		FROM
			EVENT
		WHERE
			LINK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_event.link_id#">
		ORDER BY
			STARTDATE ASC
	</cfquery>
	<cfset fark = datediff("d",date_diff.startdate[1],date_diff.startdate[2])>
	<cfif fark gt 7>
		<cfset fark = 30>
	</cfif>
<cfelse>
	<cfset fark = 0>
</cfif>

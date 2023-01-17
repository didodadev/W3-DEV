<cfquery name="GET_TITLE" datasource="#dsn#">
	SELECT 
		TITLE_ID,
		TITLE
	<cfif isDefined("attributes.DETAIL")>
		, TITLE_DETAIL
	</cfif>
	FROM 
		SETUP_TITLE	
	<cfif isDefined("attributes.TITLE_ID")>
	WHERE 
		TITLE_ID = #attributes.TITLE_ID#
	</cfif>
</cfquery>
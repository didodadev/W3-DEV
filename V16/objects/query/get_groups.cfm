<cfquery name="GET_GROUPS" datasource="#DSN#">
	SELECT 
		GROUP_ID,
		GROUP_NAME
	FROM 
		USERS
	WHERE
		(RECORD_MEMBER = #session.ep.userid# OR TO_ALL = 1)
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND
	  <cfif len(attributes.keyword) eq 1>
		GROUP_NAME LIKE '%#attributes.keyword#'
	  <cfelse>
		GROUP_NAME LIKE '%#attributes.keyword#%'
	  </cfif>
	</cfif>
	ORDER BY
		GROUP_NAME
</cfquery>

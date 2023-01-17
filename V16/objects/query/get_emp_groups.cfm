<cfquery name="EMP_GROUPS" datasource="#dsn#">
	SELECT
		*
	FROM
		USERS
	WHERE
	<cfif isdefined("SESSION.EP.USERID")>
		RECORD_MEMBER = #SESSION.EP.USERID#
	<cfelse>
		RECORD_MEMBER = #SESSION.PP.USERID#
	</cfif>
	    OR 
		TO_ALL = 1	
</cfquery>

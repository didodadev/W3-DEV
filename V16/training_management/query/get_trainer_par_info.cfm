<cffunction name="get_par_company">
	<cfargument name="par_id_f" >
	<cfquery name="get_p" datasource="#DSN#">
		SELECT
			COMPANY.FULLNAME
		FROM
			COMPANY
		WHERE
			COMPANY.COMPANY_ID=#par_id_f#
	</cfquery>
	<cfset position = " ">
	<cfset strd_par=" #get_p.FULLNAME#/ / |#position#">
	<cfreturn #strd_par#>
</cffunction>

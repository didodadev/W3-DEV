<cfquery name="get_com_branch" datasource="#DSN#">
	SELECT
		OC.NICK_NAME,
		B.BRANCH_NAME,
		BRANCH_ID,
		COMPANY_NAME
	FROM
		BRANCH B,
		OUR_COMPANY OC
	WHERE
		B.COMPANY_ID=OC.COMP_ID
	<cfif isdefined("my_comp_branch_id") and LEN(my_comp_branch_id)>
		AND
			BRANCH_ID=#my_comp_branch_id#
	</cfif>
</cfquery>

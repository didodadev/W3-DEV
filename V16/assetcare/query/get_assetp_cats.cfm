<cfquery name="GET_BRANCHS_DEPS" datasource="#DSN#">
	SELECT 
		DEPARTMENT.DEPARTMENT_ID, 
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME
	FROM 
		DEPARTMENT,
		BRANCH
	WHERE
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
	ORDER BY 
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
	SELECT 
		ASSETP_CATID, 
		ASSETP_CAT 
	FROM 
		ASSET_P_CAT 
	<cfif isDefined("attributes.assetp_catid")>
	WHERE 
		ASSETP_CATID = #attributes.assetp_catid#
	</cfif>
	ORDER BY 
		ASSETP_CAT
</cfquery>
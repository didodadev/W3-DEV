<cfquery name="GET_AUDITS" datasource="#DSN#">
	SELECT 
		AU.*,
		BR.BRANCH_NAME,
		D.DEPARTMENT_HEAD
	FROM 
		EMPLOYEES_AUDIT AS AU INNER JOIN BRANCH AS BR 
		ON BR.BRANCH_ID = AU.AUDIT_BRANCH_ID
		LEFT JOIN DEPARTMENT D ON AU.AUDIT_DEPARTMENT_ID = D.DEPARTMENT_ID
	WHERE
		1=1
		<cfif len(attributes.keyword)>
			AND (BR.BRANCH_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR AU.AUDITOR LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
		</cfif>
		<cfif len(attributes.startdate)>
			AND AU.AUDIT_DATE >= #attributes.startdate#
		</cfif>
		<cfif len(attributes.finishdate)>
			AND AU.AUDIT_DATE <= #attributes.finishdate#
		</cfif>
		<cfif len(attributes.audit_type)>
			AND AU.AUDIT_TYPE = #attributes.audit_type#
		</cfif>
		<cfif isdefined('attributes.branch_id') and attributes.branch_id neq 0>
			AND BR.BRANCH_ID = #attributes.branch_id#
		</cfif>
		<cfif isdefined('attributes.department') and len(attributes.department)>
			AND D.DEPARTMENT_ID = #attributes.department#
		</cfif>
	ORDER BY
		AUDIT_DATE DESC
</cfquery>

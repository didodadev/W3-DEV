<cfif isdefined("attributes.date_interval")>
	<cfset date_=attributes.date_interval>
<cfelse>
	<cfset date_=8>
</cfif>
<cfquery name="get_all_organizations" datasource="#dsn#">
	SELECT 
		ORGANIZATION_ID,
		ORGANIZATION_HEAD,
		START_DATE,
		FINISH_DATE,
		IS_VIEW_DEPARTMENT,
		IS_VIEW_BRANCH,
		VIEW_TO_ALL
	FROM 
		ORGANIZATION
	WHERE
		(
			(START_DATE >= #attributes.to_day# AND START_DATE < #DATEADD("#add_format_#",date_,attributes.to_day)#) OR
			(FINISH_DATE >= #attributes.to_day# AND FINISH_DATE < #DATEADD("#add_format_#",date_,attributes.to_day)#)
		)
        AND IS_ACTIVE = 1
		<cfif isdefined('attributes.view_agenda')>
			<cfif isdefined('attributes.view_agenda') and listfindnocase('1',attributes.view_agenda)><!--- departman gorsun --->
				AND	(VIEW_TO_ALL = 1 AND IS_VIEW_BRANCH = #get_all_agenda_department_branch.branch_id# AND IS_VIEW_DEPARTMENT = #get_all_agenda_department_branch.department_id# )
			</cfif>
			<cfif isdefined('attributes.view_agenda') and listfindnocase('2',attributes.view_agenda)><!--- şube görsün --->
				AND	( VIEW_TO_ALL = 1 AND IS_VIEW_DEPARTMENT IS NULL AND IS_VIEW_BRANCH = #get_all_agenda_department_branch.branch_id# )
			</cfif>
			<cfif isdefined('attributes.view_agenda') and attributes.view_agenda eq 3><!--- herkes gorsun --->
				AND	(IS_VIEW_BRANCH IS NULL AND IS_VIEW_DEPARTMENT IS NULL AND VIEW_TO_ALL = 1)
			</cfif>
		</cfif>
</cfquery>


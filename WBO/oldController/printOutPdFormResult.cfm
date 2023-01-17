<cfparam name="attributes.perform_year" default="#year(now())-1#">
<cfquery name="ALL_BRANCHES" datasource="#DSN#">
	SELECT 
		BRANCH_NAME,
		BRANCH_ID
	FROM
		BRANCH
	WHERE
		SSK_NO IS NOT NULL AND
		SSK_OFFICE IS NOT NULL AND
		SSK_BRANCH IS NOT NULL AND
		SSK_NO <> '' AND
		SSK_OFFICE <> '' AND
		SSK_BRANCH <> ''
	<cfif not session.ep.ehesap>
		AND BRANCH_ID IN 
		(
			SELECT
				BRANCH_ID
			FROM
				EMPLOYEE_POSITION_BRANCHES
			WHERE
				POSITION_CODE = #SESSION.EP.POSITION_CODE#
		)
	</cfif>
	ORDER BY
		BRANCH_NAME
</cfquery>

<cfif isdefined("attributes.branch_id")>
	<cfquery name="get_performances" datasource="#dsn#">
		SELECT 
			EPER.*,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
		FROM 
			EMPLOYEE_PERFORMANCE EPER,
			EMPLOYEE_POSITIONS EP,
			DEPARTMENT D,
			EMPLOYEES E
		WHERE
			EP.EMPLOYEE_ID = EPER.EMP_ID
			AND E.EMPLOYEE_ID = EPER.EMP_ID
			AND EP.DEPARTMENT_ID = D.DEPARTMENT_ID
			AND (EPER.RECORD_TYPE IS NULL OR EPER.RECORD_TYPE = 1)
			AND D.BRANCH_ID = #attributes.branch_id#
			AND EPER.USER_POINT_OVER_5 = #attributes.performance_note#
			AND YEAR(EPER.START_DATE) = #attributes.perform_year#
	</cfquery>
	<cfif get_performances.recordcount>
		<cfquery name="get_manager_1s" dbtype="query">
			SELECT DISTINCT MANAGER_1_EMP_ID FROM get_performances WHERE MANAGER_1_EMP_ID IS NOT NULL 
		</cfquery>
		<cfset get_manager_ids = valuelist(get_manager_1s.MANAGER_1_EMP_ID)>
		<cfquery name="get_manager_2s" dbtype="query">
			SELECT DISTINCT MANAGER_2_EMP_ID FROM get_performances WHERE MANAGER_2_EMP_ID IS NOT NULL <cfif listlen(get_manager_ids)>AND MANAGER_2_EMP_ID NOT IN (#get_manager_ids#)</cfif>
		</cfquery>
		<cfset get_manager2_ids = valuelist(get_manager_2s.MANAGER_2_EMP_ID)>
		<cfset get_manager_ids = listappend(get_manager_ids,get_manager2_ids)>
		<cfset get_manager_ids = listsort(get_manager_ids,'numeric','desc')>
		<cfif listlen(get_manager_ids)>
			<cfquery name="get_employee_names" datasource="#dsn#">
				SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#get_manager_ids#)
			</cfquery>
		</cfif>
	</cfif>
    <!---<cfloop query="get_performances">
            <cfinclude template="../hr/display/print_out_pd_form_result_note2.cfm">
    </cfloop>--->
</cfif>
<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.popup_print_out_pd_form_result';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/print_out_pd_form_result.cfm';
	
</cfscript>
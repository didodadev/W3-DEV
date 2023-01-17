<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME 
	FROM 
		BRANCH
	WHERE
		BRANCH_ID IN (
                        SELECT
                            BRANCH_ID
                        FROM
                            EMPLOYEE_POSITION_BRANCHES
                        WHERE
                            POSITION_CODE = #SESSION.EP.POSITION_CODE#	
					)
	ORDER BY BRANCH_ID
</cfquery>
<cfset branch_id_list = listsort(valuelist(get_branchs.branch_id,','),"Numeric","Desc")>
<cfquery name="get_class_costs" datasource="#dsn#">
	SELECT
		*
	FROM
		TRAINING_CLASS_COST
	WHERE
	<cfif isDefined("attributes.class_id") and len(attributes.class_id)>
		CLASS_ID IS NOT NULL
		AND CLASS_ID = #attributes.class_id#
	<cfelseif isdefined("attributes.training_class_cost_id")>
		TRAINING_CLASS_COST_ID = #attributes.training_class_cost_id#
	</cfif>
</cfquery>
<cfif get_class_costs.recordcount>
	<cfquery name="get_class_cost_rows" datasource="#dsn#">
		SELECT
			*
		FROM
			TRAINING_CLASS_COST_ROWS
		WHERE
			TRAINING_CLASS_COST_ID = #get_class_costs.training_class_cost_id# AND
			(BRANCH_ID IN (#branch_id_list#) OR BRANCH_ID IS NULL)
	</cfquery>
<cfelse>
	<cfset get_class_cost_rows.recordcount = 0>
</cfif>


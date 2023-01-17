<cfquery name="GET_QUESTIONS" datasource="#dsn#">
	SELECT 
		*
	FROM 
		QUESTION
	WHERE
		QUESTION_ID IS NOT NULL
    <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
        AND
            (
            QUESTION LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI 
        OR
            QUESTION_INFO LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI 
            )
    </cfif>
    <cfif isdefined("attributes.status") and len(attributes.status) >
        AND 
            STATUS = #attributes.status#
    </cfif>
    <cfif isdefined("attributes.training_cat_id") and len(attributes.training_cat_id) and (attributes.training_cat_id neq 0)>
        AND TRAINING_CAT_ID = #attributes.training_cat_id#
    </cfif>
    <cfif isdefined("attributes.training_sec_id") and len(attributes.training_sec_id) and (attributes.training_sec_id neq 0)>
        AND TRAINING_SEC_ID = #attributes.training_sec_id#
    </cfif>
    <cfif isdefined("attributes.training_subject_id") and len(attributes.training_subject_id) and (attributes.training_subject_id neq 0)>
        AND
            TRAINING_ID = #attributes.training_subject_id#
    </cfif>
	ORDER BY
		QUESTION
</cfquery>
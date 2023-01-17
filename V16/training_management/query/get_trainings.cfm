<cfquery name="GET_TRAININGS" datasource="#dsn#">
	SELECT 
		T.TRAIN_ID, 
		T.TRAIN_OBJECTIVE,
		T.TRAIN_HEAD,
		T.TRAINING_SEC_ID,
		T.TRAIN_PARTNERS,
		T.TRAIN_CONSUMERS,
		T.TRAIN_DEPARTMENTS,
		T.RECORD_DATE,
		T.RECORD_EMP,
		T.SUBJECT_CURRENCY_ID,
		T.RECORD_PAR,
		T.TRAINING_CAT_ID,
		TC.TRAINING_CAT,
		TS.SECTION_NAME,
		ST.TRAINING_STYLE,
		ST.TRAINING_STYLE_ID
	FROM 
		TRAINING T LEFT JOIN TRAINING_CAT TC ON T.TRAINING_CAT_ID = TC.TRAINING_CAT_ID
		LEFT JOIN TRAINING_SEC TS ON T.TRAINING_SEC_ID = TS.TRAINING_SEC_ID
		LEFT JOIN SETUP_TRAINING_STYLE ST ON T.TRAINING_STYLE = ST.TRAINING_STYLE_ID
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id) and len(attributes.branch_head)>
		INNER JOIN RELATION_SEGMENT_TRAINING RST
		ON RST.RELATION_FIELD_ID = T.TRAIN_ID
		</cfif>
	WHERE
	<cfif isDefined("attributes.ATTENDERS") and attributes.ATTENDERS gt 0><!--- konularin detayindaki segmantasyonla iliskisi --->
		T.TRAIN_ID IN
			(
				SELECT
					RELATION_FIELD_ID
				FROM
					RELATION_SEGMENT_TRAINING
				WHERE
				<cfif attributes.ATTENDERS EQ 1>
					RELATION_ACTION IN (1,2,3,5,6,7)
				<cfelseif attributes.ATTENDERS EQ 2>
					RELATION_ACTION = 4
				<cfelseif attributes.ATTENDERS EQ 3>
					RELATION_ACTION = 8
				</cfif>
			)
	<cfelse>
		T.TRAIN_ID <> 0
	</cfif>
	<!--- PARTNER DA UYARLA --->
	<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
	AND 
	(
		T.TRAIN_OBJECTIVE LIKE '%#attributes.KEYWORD#%' OR
		T.TRAIN_HEAD LIKE '%#attributes.KEYWORD#%'
	)
	</cfif>
	<cfif isDefined("attributes.TRAINING_CAT_ID") and len(attributes.TRAINING_CAT_ID) and (attributes.TRAINING_CAT_ID NEQ 0)>AND T.TRAINING_CAT_ID = #attributes.TRAINING_CAT_ID#</cfif>
	<cfif isDefined("attributes.TRAINING_SEC_ID") and len(attributes.TRAINING_SEC_ID) and (attributes.TRAINING_SEC_ID NEQ 0)>AND T.TRAINING_SEC_ID = #attributes.TRAINING_SEC_ID#</cfif>
	<cfif isdefined("attributes.status") and len(attributes.status)>AND T.SUBJECT_STATUS = #attributes.STATUS#</cfif>
	<cfif isdefined("attributes.CURRENCY_ID") and len(attributes.CURRENCY_ID)>AND T.SUBJECT_CURRENCY_ID = #attributes.CURRENCY_ID#</cfif>
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id) and len(attributes.branch_head)>
		AND 
			(
			RST.RELATION_ACTION = 7 AND
			RST.RELATION_ACTION_ID = #attributes.branch_id# AND
			RST.RELATION_FIELD_ID = T.TRAIN_ID
			)
	</cfif>
	ORDER BY
		 T.TRAIN_HEAD 
</cfquery>


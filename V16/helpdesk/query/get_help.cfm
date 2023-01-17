

	<cfquery name="GET_HELP_LANGUAGE" datasource="#DSN#">
		SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE ORDER BY LANGUAGE_SET
	</cfquery>
	<cfquery name="GET_CONTENT_PROCESS_STAGES" datasource="#DSN#">
		SELECT 
			PTR.PROCESS_ROW_ID AS STAGE_ID,
			PTR.STAGE STAGE_NAME 
		FROM 
			PROCESS_TYPE PT, 
			PROCESS_TYPE_ROWS PTR 
		WHERE
			PT.IS_ACTIVE = 1 AND
			PT.FACTION LIKE 'content.%' AND
			PT.PROCESS_ID = PTR.PROCESS_ID
	</cfquery>
	<cfquery name="GET_HELP" datasource="#DSN#">
		SELECT
			*
		FROM 
			CONTENT_CHAPTER CCH,
			CONTENT_CAT CC,
			CONTENT C
			LEFT JOIN	META_DESCRIPTIONS M ON M.ACTION_ID=C.CONTENT_ID
			LEFT JOIN CONTENT_PROPERTY CP ON CP.CONTENT_PROPERTY_ID=C.CONTENT_PROPERTY_ID
		WHERE 
			CC.CONTENTCAT_ID = CCH.CONTENTCAT_ID AND
			CCH.CHAPTER_ID = C.CHAPTER_ID AND
			C.STAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="-2"> AND
			C.CONTENT_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
		ORDER BY
			<cfif isdefined("attributes.is_order_by") and attributes.is_order_by eq 0>
				CONT_HEAD
			<cfelse>
				ISNULL(C.UPDATE_DATE,C.RECORD_DATE) DESC
			</cfif>
			
	</cfquery>
	<!--- <cfquery name="GET_HELP" datasource="#DSN#">
		SELECT
			*
		FROM 
			CONTENT_CHAPTER CCH,
			CONTENT_CAT CC,
			CONTENT C
			LEFT JOIN META_DESCRIPTIONS M on M.ACTION_ID=C.CONTENT_ID
		WHERE 
		 	CC.CONTENTCAT_ID = CCH.CONTENTCAT_ID AND
			CCH.CHAPTER_ID = C.CHAPTER_ID 
			<cfif isDefined("content_cat_id") and len(content_cat_id)>
				AND CC.CONTENTCAT_ID IN (#content_cat_id#)
			</cfif>
			<cfif isDefined("attributes.keyword") and (len(attributes.keyword) eq 1)>
                AND CONT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
            <cfelseif isDefined("attributes.keyword") and (len(attributes.keyword) gt 1)>
                AND
                (
                    CONT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 				
                    CONT_SUMMARY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					META_KEYWORDS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                )
			</cfif>
			<cfif isDefined("attributes.stage_id") and len(attributes.stage_id)>
				AND PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stage_id#">
			</cfif>
			<cfif isdefined('attributes.help_language') and len(attributes.help_language)>
				AND C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.help_language#">

			</cfif>
		ORDER BY
			<cfif isdefined("attributes.is_order_by") and attributes.is_order_by eq 0>
                CONT_HEAD
            <cfelse>
                ISNULL(C.UPDATE_DATE,C.RECORD_DATE) DESC
            </cfif>
	</cfquery>
 --->
 <cfquery name="get_content" datasource="#dsn#">           
    SELECT
        CTNT.CONTENT_ID,
        CTNT.CONT_HEAD,
        CTNT.CONT_SUMMARY,
        CTNT.CONT_BODY,
        CPT.CONTENTCAT_ID,
        CCAT.CONTENTCAT,
        CPT.CHAPTER_ID,
        CPT.CHAPTER,
        MD.META_KEYWORDS
    FROM
        CONTENT AS CTNT
        LEFT JOIN CONTENT_CHAPTER AS CPT ON CTNT.CHAPTER_ID = CPT.CHAPTER_ID
        LEFT JOIN CONTENT_CAT AS CCAT ON CPT.CONTENTCAT_ID = CCAT.CONTENTCAT_ID
        LEFT JOIN META_DESCRIPTIONS MD ON MD.ACTION_ID = CTNT.CONTENT_ID AND MD.ACTION_TYPE = 'CONTENT_ID' AND MD. LANGUAGE_SHORT = 'tr'
    WHERE
        CPT.CONTENTCAT_ID IN (49) AND
        CPT.CONTENT_CHAPTER_STATUS = 1 AND
        INTERNET_VIEW = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> AND 
        CCAT.LANGUAGE_ID = 'tr' AND 
        CTNT.STAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="-2"> AND
        CTNT.PROCESS_STAGE = 157 AND
        CTNT.CONTENT_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    ORDER BY CPT.CONTENTCAT_ID ASC, CPT.CHAPTER_ID ASC, CTNT.PRIORITY ASC
</cfquery>
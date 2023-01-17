<!--- form doldurulmamislar siline biliyor ancak yinede daha sonra dğişe bilir diyerek puanlama tablolarındanda silmeyi yaptik koyduk--->
<cflock name="CreateUUID()" timeout="30">
	<cftransaction>
		<!---<cfquery name="del_target" datasource="#dsn#">
			DELETE FROM TARGET WHERE PER_ID=#attributes.per_id#
		</cfquery>--->
		
		<cfquery name="DEL_RESULT_DETAIL_CHAPTER" datasource="#dsn#">
			DELETE FROM
				EMPLOYEE_QUIZ_RESULTS_DETAILS
			WHERE	
				RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
		</cfquery>
		
		<cfquery name="get_result_detail_chapter" datasource="#dsn#">
			DELETE FROM
				EMPLOYEE_QUIZ_CHAPTER_EXPL
			WHERE	
				RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
		</cfquery>
		
		<!---<cfquery name="get_result_detail_chapter" datasource="#dsn#">
			DELETE FROM
				EMPLOYEE_PERFORMANCE_TARGET
			WHERE	
				PER_ID = #attributes.per_id#
		</cfquery>--->
		
		<cfquery name="get_result_detail_chapter" datasource="#dsn#">
			DELETE FROM
				EMPLOYEE_QUIZ_RESULTS
			WHERE	
				RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
		</cfquery>
		
		<cfquery name="get_result_detail_chapter" datasource="#dsn#">
			DELETE FROM
				EMPLOYEE_PERFORMANCE
			WHERE	
				PER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.per_id#">
		</cfquery>
        
        <cfquery name="GET_QUIZ_CHAPTERS" datasource="#dsn#">
            SELECT 
                CHAPTER_ID,
                REQ_TYPE_ID
            FROM 
                EMPLOYEE_QUIZ_CHAPTER
            WHERE
                REQ_TYPE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.all_req_type_id#">)
        </cfquery>
        <cfloop query="get_quiz_chapters">
        	<cfset sayac = 0>
            <cfquery name="GET_QUIZ_QUESTIONS" datasource="#dsn#">
                SELECT 
                    QUESTION_ID
                FROM 
                    EMPLOYEE_QUIZ_QUESTION
                WHERE
                    CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#chapter_id#">
            </cfquery>
            <cfloop query="GET_QUIZ_QUESTIONS">
            	<cfif sayac eq 0>
                    <cfquery name="GET_QUIZ_RESULTS" datasource="#dsn#">
                        SELECT 
                            RESULT_DETAIL_ID
                        FROM 
                            EMPLOYEE_QUIZ_RESULTS_DETAILS
                        WHERE
                            QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#question_id#">
                    </cfquery>
                    <cfif GET_QUIZ_RESULTS.recordcount>
                        <cfset sayac = sayac + 1>
                    </cfif>
                </cfif>
            </cfloop>
            <cfif sayac eq 0>
                <cfquery name="UPD_RELATION_SEG" datasource="#dsn#">
                    UPDATE 
                        RELATION_SEGMENT 
                    SET 
                        IS_FILL=0 
                    WHERE 
                        RELATION_TABLE='POSITION_REQ_TYPE' AND
                        RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#req_type_id#">
                </cfquery>
            </cfif>
        </cfloop>
        <cfquery name="upd_target_res" datasource="#dsn#">
        	UPDATE
        		TARGET
        	SET
        		EMP_TARGET_RESULT = NULL,
        		UPPER_POSITION_TARGET_RESULT = NULL,
        		UPPER_POSITION2_TARGET_RESULT = NULL,
        		TARGET_RESULT = NULL,
        		PERFORM_COMMENT = NULL
        	WHERE
        		EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> AND
        		YEAR(FINISHDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.finishdate)#"> AND
        		YEAR(STARTDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.startdate)#">
        </cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=hr.list_target_perf" addtoken="no">

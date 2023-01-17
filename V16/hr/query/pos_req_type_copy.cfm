<cfquery name="copy_pos_req_type" datasource="#dsn#">
	INSERT INTO
		POSITION_REQ_TYPE
      	(
           REQ_TYPE,
           IS_ACTIVE,
           IS_GROUP,
           PERFECTION_YEAR,
           IS_COACH,
           IS_DEP_ADMIN,
           IS_STANDART,
           RECORD_EMP,
           RECORD_DATE,
           RECORD_IP,
           DETAIL
     	)
      	SELECT
      		REQ_TYPE,
           	IS_ACTIVE,
           	IS_GROUP,
           	PERFECTION_YEAR,
           	IS_COACH,
           	IS_DEP_ADMIN,
           	IS_STANDART,
           	#session.ep.userid#,
           	#now()#,
           	'#cgi.remote_addr#',
           	DETAIL
       	FROM
        	POSITION_REQ_TYPE
      	WHERE
        	REQ_TYPE_ID = #attributes.req_type_id#
</cfquery>
<cfquery name="get_relations" datasource="#dsn#">
	SELECT RELATION_ID FROM RELATION_SEGMENT WHERE RELATION_TABLE = 'POSITION_REQ_TYPE' AND RELATION_FIELD_ID = #attributes.req_type_id#
</cfquery>
<cfquery name="GET_MAX_ID" datasource="#dsn#">
	SELECT MAX(REQ_TYPE_ID) AS REQ_TYPE_ID FROM POSITION_REQ_TYPE
</cfquery>
<cfif get_relations.recordcount>
	<cfloop query="get_relations">
    	<cfquery name="copy_relations" datasource="#dsn#">
            INSERT INTO
                RELATION_SEGMENT
                (
                   RELATION_TABLE,
                   RELATION_FIELD_ID,
                   RELATION_ACTION,
                   RELATION_ACTION_ID,
                   RELATION_YEAR
                )
                SELECT
                    RELATION_TABLE,
                    #GET_MAX_ID.REQ_TYPE_ID#,
                    RELATION_ACTION,
                    RELATION_ACTION_ID,
                    RELATION_YEAR
                FROM
                    RELATION_SEGMENT
                WHERE
                    RELATION_ID = #RELATION_ID#
      	</cfquery>
    </cfloop>
</cfif>
<cfquery name="get_chapter" datasource="#dsn#">
	SELECT CHAPTER_ID FROM EMPLOYEE_QUIZ_CHAPTER WHERE REQ_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.req_type_id#">
</cfquery>
<cfif get_chapter.recordcount>
	<cfloop query="get_chapter">
    	<cfquery name="copy_chapters" datasource="#dsn#">
            INSERT INTO
                EMPLOYEE_QUIZ_CHAPTER
                (
                   QUIZ_ID,
                   REQ_TYPE_ID,
                   CHAPTER,
                   CHAPTER_INFO,
                   CHAPTER_WEIGHT,
                   ANSWER_TYPE,
                   ANSWER_NUMBER,
                   <cfloop FROM="0" TO="19" INDEX="I">
                    ANSWER#EVALUATE(I+1)#_TEXT,
                    ANSWER#EVALUATE(I+1)#_PHOTO,
                    ANSWER#EVALUATE(I+1)#_PHOTO_SERVER_ID,
                    ANSWER#EVALUATE(I+1)#_POINT,
                   </cfloop>
                   RECORD_EMP,
                   RECORD_DATE,
                   RECORD_IP,
                   IS_EXP1,
                   IS_EXP2,
                   IS_EXP3,
                   IS_EXP4,
                   EXP1_NAME,
                   EXP2_NAME,
                   EXP3_NAME,
                   EXP4_NAME,
                   IS_EMP_EXP1,
                   IS_CHIEF3_EXP1,
                   IS_CHIEF1_EXP1,
                   IS_CHIEF2_EXP1,
                   IS_EMP_EXP2,
                   IS_CHIEF3_EXP2,
                   IS_CHIEF1_EXP2,
                   IS_CHIEF2_EXP2,
                   IS_EMP_EXP3,
                   IS_CHIEF3_EXP3,
                   IS_CHIEF1_EXP3,
                   IS_CHIEF2_EXP3,
                   IS_EMP_EXP4,
                   IS_CHIEF3_EXP4,
                   IS_CHIEF1_EXP4,
                   IS_CHIEF2_EXP4
                )
                SELECT
                    QUIZ_ID,
                    #GET_MAX_ID.REQ_TYPE_ID#,
                    CHAPTER,
                    CHAPTER_INFO,
                    CHAPTER_WEIGHT,
                    ANSWER_TYPE,
                    ANSWER_NUMBER,
                    <cfloop FROM="0" TO="19" INDEX="I">
                    ANSWER#EVALUATE(I+1)#_TEXT,
                    ANSWER#EVALUATE(I+1)#_PHOTO,
                    ANSWER#EVALUATE(I+1)#_PHOTO_SERVER_ID,
                    ANSWER#EVALUATE(I+1)#_POINT,
                   </cfloop>
                   #session.ep.userid#,
                   #now()#,
                   '#cgi.remote_addr#',
                   IS_EXP1,
                   IS_EXP2,
                   IS_EXP3,
                   IS_EXP4,
                   EXP1_NAME,
                   EXP2_NAME,
                   EXP3_NAME,
                   EXP4_NAME,
                   IS_EMP_EXP1,
                   IS_CHIEF3_EXP1,
                   IS_CHIEF1_EXP1,
                   IS_CHIEF2_EXP1,
                   IS_EMP_EXP2,
                   IS_CHIEF3_EXP2,
                   IS_CHIEF1_EXP2,
                   IS_CHIEF2_EXP2,
                   IS_EMP_EXP3,
                   IS_CHIEF3_EXP3,
                   IS_CHIEF1_EXP3,
                   IS_CHIEF2_EXP3,
                   IS_EMP_EXP4,
                   IS_CHIEF3_EXP4,
                   IS_CHIEF1_EXP4,
                   IS_CHIEF2_EXP4
                FROM
                    EMPLOYEE_QUIZ_CHAPTER
                WHERE
                    CHAPTER_ID = #CHAPTER_ID#
      	</cfquery>
        <cfquery name="GET_QUIZ_QUESTIONS" datasource="#dsn#">
            SELECT QUESTION_ID FROM EMPLOYEE_QUIZ_QUESTION WHERE CHAPTER_ID=#CHAPTER_ID#
        </cfquery>
        <cfif GET_QUIZ_QUESTIONS.recordcount>
        	<cfquery name="GET_MAX_CHAPTER_ID" datasource="#dsn#">
                SELECT MAX(CHAPTER_ID) AS MAX_CHAPTER_ID FROM EMPLOYEE_QUIZ_CHAPTER
            </cfquery>
        	<cfloop query="GET_QUIZ_QUESTIONS">
            	<cfquery name="copy_questions" datasource="#dsn#">
                    INSERT INTO
                        EMPLOYEE_QUIZ_QUESTION
                        (
                           CHAPTER_ID,
                           QUESTION,
                           QUESTION_INFO,
                           ANSWER_TYPE,
                           ANSWER_NUMBER,
                           <cfloop FROM="0" TO="19" INDEX="I">
                            ANSWER#EVALUATE(I+1)#_TEXT,
                            ANSWER#EVALUATE(I+1)#_PHOTO,
                            ANSWER#EVALUATE(I+1)#_PHOTO_SERVER_ID,
                            ANSWER#EVALUATE(I+1)#_POINT,
                           </cfloop>
                           RECORD_EMP,
                           RECORD_DATE,
                           RECORD_IP,
                           OPEN_ENDED
                        )
                        SELECT
                            #GET_MAX_CHAPTER_ID.MAX_CHAPTER_ID#,
                            QUESTION,
                            QUESTION_INFO,
                            ANSWER_TYPE,
                            ANSWER_NUMBER,
                            <cfloop FROM="0" TO="19" INDEX="I">
                             ANSWER#EVALUATE(I+1)#_TEXT,
                             ANSWER#EVALUATE(I+1)#_PHOTO,
                             ANSWER#EVALUATE(I+1)#_PHOTO_SERVER_ID,
                             ANSWER#EVALUATE(I+1)#_POINT,
                            </cfloop>
                            #session.ep.userid#,
                            #now()#,
                            '#cgi.remote_addr#',
                            OPEN_ENDED
                        FROM
                            EMPLOYEE_QUIZ_QUESTION
                        WHERE
                            QUESTION_ID = #QUESTION_ID#
                </cfquery>
            </cfloop>
        </cfif>
    </cfloop>
</cfif>
<cflocation url="#request.self#?fuseaction=hr.list_position_req_type&event=upd&req_type_id=#GET_MAX_ID.REQ_TYPE_ID#" addtoken="no">

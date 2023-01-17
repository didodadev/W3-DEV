<cfquery name="GET_CONSUMER_ANSWER" datasource="#DSN#">
	SELECT ANSWER_ID FROM MEMBER_SECRET_ANSWER WHERE CONSUMER_ID = #attributes.consumer_id#
</cfquery>
<cfif get_consumer_answer.recordcount>
    <cfquery name="UPD_ANSWER" datasource="#DSN#">
        UPDATE
           MEMBER_SECRET_ANSWER
        SET
            ANSWER = '#attributes.secret_answer#',
            QUESTION_ID = #attributes.secret_question#,
            UPDATE_DATE = #now()#,
            UPDATE_EMP = #session.ep.userid#,
            UPDATE_IP = '#cgi.remote_addr#'
        WHERE
            CONSUMER_ID = #attributes.consumer_id#
    </cfquery>
<cfelse>
    <cfquery name="INS_ANSWER" datasource="#DSN#">
        INSERT INTO
            MEMBER_SECRET_ANSWER
        	(
                ANSWER,
                QUESTION_ID,
                CONSUMER_ID,
                RECORD_DATE,
                RECORD_EMP,
				RECORD_IP 
			)
            VALUES
            (
                '#attributes.secret_answer#',
                #attributes.secret_question#,
                #attributes.consumer_id#,
                #now()#,
                #session.ep.userid#,
                '#cgi.remote_addr#'
            )
    </cfquery>
</cfif>
<script type="text/javascript">
	self.close();
</script>

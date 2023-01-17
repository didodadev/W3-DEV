<cfif isdefined("attributes.del") and attributes.del eq 1 and len(attributes.question_id)>
	<cfquery name="CHECK_COUNT" datasource="#DSN#">
		SELECT COUNT(ANSWER_ID) COUNT FROM MEMBER_SECRET_ANSWER WHERE QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_id#">
	</cfquery>
	<cfif check_count.count eq 0>
		<cfquery name="DEL_QUESTION" datasource="#DSN#">
			DELETE FROM 
				SECRET_QUESTION
			WHERE
				QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_id#">
		</cfquery>
      <cflocation url="#request.self#?fuseaction=settings.add_secret_question" addtoken="no">
	<cfelse>
		<script type="text/javascript">
			alert("Soru ile Iliskili Cevaplar Oldugu I�in Silemezsiniz");
			history.back();
		</script>
	</cfif>
    
<cfelseif isdefined("attributes.question_id") and len(attributes.question_id)>
    <cfquery name="INSERT_QUESTION" datasource="#DSN#">
		UPDATE SECRET_QUESTION
            SET
            	QUESTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.question#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_HOST#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			WHERE
            	QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_id#">
    </cfquery>
    <cflocation url="#request.self#?fuseaction=settings.add_secret_question&question_id=#attributes.question_id#" addtoken="no">
<cfelse>
    <cfquery name="INSERT_QUESTION" datasource="#DSN#">
		INSERT INTO
			SECRET_QUESTION
            (
            	QUESTION,
                RECORD_IP,
                RECORD_EMP,
                RECORD_DATE
            )
            VALUES
            (
            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.question#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_HOST#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            )
    </cfquery>

    <cfquery name="GET_LAST_QUESTION" datasource="#DSN#">
		SELECT MAX(QUESTION_ID) QUESTION_ID FROM SECRET_QUESTION
	</cfquery>
    
    <cflocation url="#request.self#?fuseaction=settings.add_secret_question&question_id=#get_last_question.question_id#" addtoken="no">
</cfif>


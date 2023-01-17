<cfquery name="ADD_QUIZ_RESULT" datasource="#dsn#">
	INSERT INTO
		QUIZ_RESULTS
		(
		QUIZ_ID,
		<cfif isdefined('session.ep')>
			EMP_ID,
		<cfelseif isdefined('session.pp')>
			PARTNER_ID,
		</cfif>
		<cfif isdefined("attributes.class_id") and len(attributes.class_id)>
		CLASS_ID,
		</cfif>
		USER_POINT,
		USER_RIGHT_COUNT,
		USER_WRONG_COUNT,
 		START_DATE,
		<cfif isdefined('session.ep')>
			RECORD_EMP,
		<cfelseif isdefined('session.pp')>
			RECORD_PAR,
		</cfif>
		RECORD_IP,
		RECORD_DATE
		)
	VALUES
		(
		#SESSION.QUIZ_ID#,
		<cfif isdefined('session.ep')>
			#SESSION.EP.USERID#,
		<cfelseif isdefined('session.pp')>
			#SESSION.PP.USERID#,
		</cfif>
		<cfif isdefined("attributes.class_id") and len(attributes.class_id)>
		#attributes.class_id#,
		</cfif>
		0,
		0,
		0,
 		#now()#,
		<cfif isdefined('session.ep')>
			#SESSION.EP.USERID#,
		<cfelseif isdefined('session.pp')>
			#SESSION.PP.USERID#,
		</cfif>
		'#CGI.REMOTE_USER#',
		#NOW()#
		)
</cfquery>	

<cfquery name="GET_RESULT_ID" datasource="#dsn#">
	SELECT
		MAX(RESULT_ID) AS MAX_ID
	FROM
		QUIZ_RESULTS
	WHERE
		<cfif isdefined('session.ep')>
			EMP_ID=#SESSION.EP.USERID#
		<cfelseif isdefined('session.pp')>
			PARTNER_ID=#SESSION.PP.USERID#
		</cfif>
		AND QUIZ_ID = #SESSION.QUIZ_ID#
</cfquery>
<cfset SESSION.RESULT_ID = GET_RESULT_ID.MAX_ID>
<cfoutput>#SESSION.RESULT_ID#</cfoutput>

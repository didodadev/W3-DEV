<cfset rights = 0>
<cfset wrongs = 0>
<cfset point = 0>
<cfloop from="1" to="#attributes.counter#" index="i">
	<cfif evaluate("user_right_#i#") eq 1>
		<cfset rights = rights +1>
		<cfif len(evaluate("attributes.point_#i#"))>
			<cfset point = point+evaluate("attributes.point_#i#")>
		</cfif>
	<cfelseif evaluate("user_right_#i#") eq -1>
		<cfset wrongs = wrongs +1>
	</cfif>
</cfloop>

<!--- toplam puan üzerinden puaný hesapla --->
<cfif point eq 0>
	<cfinclude template="get_quiz_point.cfm">
	<cfif attributes.counter eq 0>
		<cfset point = 0>
	<cfelse>
		<cfset point = Round(get_quiz_point.total_points*(rights/attributes.counter))>
	</cfif>
</cfif>

<cfquery name="UPD_RESULT" datasource="#dsn#">
	UPDATE
		QUIZ_RESULTS
	SET
		USER_RIGHT_COUNT = #RIGHTS#,
		USER_WRONG_COUNT = #WRONGS#,
		USER_POINT = #POINT#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_EMP = #SESSION.EP.USERID#
	WHERE
		RESULT_ID=#attributes.RESULT_ID#
</cfquery>
<cflocation addtoken="No" url="#request.self#?fuseaction=training_management.quiz_results&quiz_id=#attributes.quiz_id#">

<cfinclude template="get_question.cfm">
<cfloop from="1" to="20" index="i">
	<cfif len(evaluate("get_question.ANSWER#i#_photo"))>
		<cftry>
			<cffile action="DELETE" file="#upload_folder#training#dir_seperator##evaluate("get_question.ANSWER#i#_photo")#">
			<cfcatch type="Any">
				<cfoutput><cf_get_lang no='282.Dosya Bulunamadı Ama Veritabanından Silindi !'></cfoutput>
			</cfcatch>
		</cftry>
	</cfif>
</cfloop>

<cfquery name="DEL_QUESTION" datasource="#dsn#">
	DELETE 
		FROM 
	QUESTION 
		WHERE QUESTION_ID=#attributes.QUESTION_ID#
</cfquery>

<script type="text/javascript">
location.href = document.referrer;
</script>

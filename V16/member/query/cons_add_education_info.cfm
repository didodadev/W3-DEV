<cftransaction>
<cfquery name="del_cons_education_info" datasource="#dsn#">
	DELETE FROM CONSUMER_EDUCATION_INFO WHERE CONS_ID = #attributes.CONSUMER_ID#
</cfquery>
<cfquery name="add_cons_education_info" datasource="#dsn#">
INSERT INTO 
	CONSUMER_EDUCATION_INFO
	(
		CONS_ID,
		EDU1,
		EDU1_START,
		EDU1_FINISH,
		EDU2,
		EDU2_START,
		EDU2_FINISH,
		EDU3,
		EDU3_START,
		EDU3_FINISH,
		EDU4_ID,
		EDU4_START,
		EDU4_FINISH,
		EDU5,
		EDU5_START,
		EDU5_FINISH,
		EDU4,
        EDU4_PART_ID,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	)
	VALUES
	(
		#attributes.CONSUMER_ID#,
		<cfif len(attributes.EDU1)>'#attributes.EDU1#'<cfelse>NULL</cfif>,
		<cfif len(attributes.EDU1_START)>#attributes.EDU1_START#<cfelse>NULL</cfif>,
		<cfif len(attributes.EDU1_FINISH)>#attributes.EDU1_FINISH#<cfelse>NULL</cfif>,
		<cfif len(attributes.EDU2)>'#attributes.EDU2#'<cfelse>NULL</cfif>,
		<cfif len(attributes.EDU2_START)>#attributes.EDU2_START#<cfelse>NULL</cfif>,
		<cfif len(attributes.EDU2_FINISH)>#attributes.EDU2_FINISH#<cfelse>NULL</cfif>,
		<cfif len(attributes.EDU3)>'#attributes.EDU3#'<cfelse>NULL</cfif>,
		<cfif len(attributes.EDU3_START)>#attributes.EDU3_START#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.EDU3_FINISH') and len(attributes.EDU3_FINISH)>#attributes.EDU3_FINISH#<cfelse>NULL</cfif>,
		<cfif len(attributes.EDU4_ID)>#attributes.EDU4_ID#<cfelse>NULL</cfif>,
		<cfif len(attributes.EDU4_START)>#attributes.EDU4_START#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.EDU4_FINISH') and len(attributes.EDU4_FINISH)>#attributes.EDU4_FINISH#<cfelse>NULL</cfif>,
		<cfif len(attributes.EDU5)>'#attributes.EDU5#'<cfelse>NULL</cfif>,
		<cfif len(attributes.EDU5_START)>#attributes.EDU5_START#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.EDU5_FINISH') and len(attributes.EDU5_FINISH)>#attributes.EDU5_FINISH#<cfelse>NULL</cfif>,
		<cfif len(attributes.EDU4)>'#attributes.EDU4#'<cfelse>NULL</cfif>,
        <cfif len(attributes.edu_part_id)>#attributes.edu_part_id#<cfelse>NULL</cfif>,
		#SESSION.EP.USERID#, 
		#now()#, 
		'#CGI.REMOTE_ADDR#'

	)
</cfquery>
</cftransaction>
<script type="text/javascript">
	location.href= document.referrer;
</script>

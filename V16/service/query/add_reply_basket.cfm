<cfset row=arraylen(session.service_reply)+1>
<cfif row eq 0>
	<cfset row=1>
</cfif>
<cfif isdefined("attributes.reply_text")>
	<cfset session.service_reply[row][1]=attributes.reply_text>
</cfif>
<cfif isdefined("attributes.reply_head")>
	<cfset session.service_reply[row][5]=attributes.reply_head>
</cfif>
<cfif isdefined("attributes.reply_type")>
	<cfset session.service_reply[row][2]=attributes.reply_type>
	<cfset session.service_reply[row][7]=attributes.reply_type_name>
<cfelse>
	<cfset session.service_reply[row][2]="">
	<cfset session.service_reply[row][7]="">
</cfif>
<cfset emp_id=session.ep.userid>
<cfinclude template="../query/get_emp_detail.cfm">
<cfset frommail=get_emp_detail.EMPLOYEE_EMAIL>
<cfset session.service_reply[row][3]=session.ep.userid>
<cfset session.service_reply[row][4]=now()>
<cfset session.service_reply[row][6]="#get_emp_detail.EMPLOYEE_NAME# #get_emp_detail.EMPLOYEE_SURNAME#">

<cfif session.service_reply[row][2] eq 1>
	<cfmail from="#frommail#" to="#url.tomail#" subject="Workcube Servis Basvuru Cevabý" type="HTML" >
		#session.service_reply[row][1]#
	</cfmail>
</cfif>

<cfquery name="ADD_REPLY" datasource="#dsn3#">
	INSERT INTO
		SERVICE_REPLY(
			SERVICE_ID,
			REPLY_DETAIL,
			REPLY_HEAD,
			UPDATE_DATE,
			UPDATE_MEMBER,
			RECORD_DATE,
			RECORD_MEMBER,
			REPLY_TYPE
		)
		VALUES(
			#URL.ID#,
			'#SESSION.SERVICE_REPLY[ROW][1]#',
			'#SESSION.SERVICE_REPLY[ROW][5]#',
			#NOW()#,
			#SESSION.EP.USERID#,
			#NOW()#,
			#SESSION.EP.USERID#,
			#SESSION.SERVICE_REPLY[ROW][2]#
		)
</cfquery>
<cfquery name="GET_LAST_ID" datasource="#dsn3#">
	SELECT
		MAX(SERVICEREPLY_ID) AS SERVICEREPLY_ID
	FROM
		SERVICE_REPLY
</cfquery>
<cfset session.service_reply[row][8]=get_last_id.SERVICEREPLY_ID>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>


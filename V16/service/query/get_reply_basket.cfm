<cfif isdefined("session.service_reply")>
	<cfscript>
		structdelete(session,"service_reply");
	</cfscript>
</cfif>
	<cfset session.service_reply=arraynew(2)>
<cfset i=1>

<cfif get_service_reply.recordcount>
	<cfloop  query="get_service_reply" startrow="1" endrow="#get_service_reply.recordcount#">	
		<cfset session.service_reply[i][5]=get_service_reply.reply_head>
		<cfset session.service_reply[i][1]=get_service_reply.reply_detail>
		<cfset session.service_reply[i][4]=dateformat(get_service_reply.record_date,dateformat_style)>
		<cfset session.service_reply[i][8]=get_service_reply.servicereply_id>
		<cfset emp_id=get_service_reply.record_emp>
		<cfif len(get_service_reply.record_emp)>
			<cfset session.service_reply[i][3]=get_service_reply.record_emp>
			<cfquery name="GET_EMP_TEL" datasource="#DSN#">
				SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,MOBILCODE,MOBILTEL FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_reply.record_emp#">
			</cfquery>
			<cfset member="#get_emp_tel.employee_name# #get_emp_tel.employee_surname#">
			<cfset session.service_reply[i][9] = "#get_emp_tel.mobilcode# #get_emp_tel.mobiltel#">
		<cfelseif len(get_service_reply.record_par)>
			<cfset session.service_reply[i][3]=get_service_reply.record_par>
			<cfquery name="GET_PAR" datasource="#DSN#">
				SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME,MOBIL_CODE,MOBIL_TEL FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_reply.record_par#">
			</cfquery>
			<cfset member="#get_par.company_partner_name# #get_par.company_partner_surname#">
			<cfset session.service_reply[i][9] = "#get_par.mobil_code# #get_par.mobil_tel#">
		</cfif>
		
		<cfset session.service_reply[i][6]=member>
		<cfif get_service_reply.reply_type eq 1 or get_service_reply.reply_type eq "">
			<cfset session.service_reply[i][2]=1>
			<cfset session.service_reply[i][7]="MAIL">
		</cfif>			
		<cfif get_service_reply.reply_type eq 0>
			<cfset session.service_reply[i][2]=0>
			<cfset session.service_reply[i][7]="SMS">
		</cfif>
		<cfset i=i+1>			
	</cfloop>
</cfif>			 

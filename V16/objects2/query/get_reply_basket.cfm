<cfif isdefined("session.service_reply")>
	<cfscript>
		structdelete(session,"service_reply");
	</cfscript>
</cfif>

	<cfset session.service_reply=arraynew(2)>

<cfset i=1>

<cfif get_service_reply.recordcount>
 <cfloop  query="get_service_reply" startrow="1" endrow="#get_service_reply.recordcount#">	
	<cfset session.service_reply[i][5]=get_service_reply.REPLY_HEAD>
	<cfset session.service_reply[i][1]=get_service_reply.REPLY_DETAIL>
	<cfset session.service_reply[i][4]=dateformat(get_service_reply.RECORD_DATE,"dd/mm/yyyy")>
	<cfset session.service_reply[i][8]=get_service_reply.SERVICEREPLY_ID>
	<cfset emp_id=get_service_reply.RECORD_MEMBER>
	<cfif len(get_service_reply.RECORD_MEMBER)>
		<cfset session.service_reply[i][3]=get_service_reply.RECORD_MEMBER>
		<cfinclude template="../query/get_emp_detail.cfm">
		<cfset member="#get_emp_detail.EMPLOYEE_NAME# #get_emp_detail.EMPLOYEE_SURNAME#">
	</cfif>
	<cfif len(get_service_reply.RECORD_PAR)>
		<cfset session.service_reply[i][3]=get_service_reply.RECORD_PAR>
		<cfquery name="GET_PAR" datasource="#dsn#">
		SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_reply.record_par#">
		</cfquery>
		<cfset member="#get_par.COMPANY_PARTNER_NAME# #get_par.COMPANY_PARTNER_SURNAME#">
	</cfif>
	<cfset session.service_reply[i][6]=member>
	<cfif get_service_reply.REPLY_TYPE EQ 1 or get_service_reply.REPLY_TYPE eq "">
		<cfset session.service_reply[i][2]=1>
		<cfset session.service_reply[i][7]="MAIL">
	</cfif>			
	<cfif get_service_reply.REPLY_TYPE EQ 0>
		<cfset session.service_reply[i][2]=0>
		<cfset session.service_reply[i][7]="SMS">
	</cfif>
	<cfset i=i+1>			
</cfloop>
</cfif>			 

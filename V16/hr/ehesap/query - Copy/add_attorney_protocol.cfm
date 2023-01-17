<cfif LEN(attributes.PROTOCOL_DATE)>
	<cf_date tarih='attributes.PROTOCOL_DATE'>
</cfif>
<cfquery NAME="ADD_ATTORNEY_PROTOCOL" DATASOURCE="#DSN#">
	INSERT 
	INTO
		EMPLOYEE_EVENT_ATTORNEY_PROTOCOL
		(
		PROTOCOL_HEAD,
		PROTOCOL_DATE,
		DETAIL,
		IS_ATTORNEY,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP,
		EVENT_ID
		)
	VALUES
		(
		'#attributes.PROTOCOL_HEAD#',
		<cfif LEN(attributes.PROTOCOL_DATE)>#attributes.PROTOCOL_DATE#,<cfelse>NULL,</cfif>
		<cfif LEN(attributes.DETAIL)>'#attributes.DETAIL#',<cfelse>NULL,</cfif>
		<cfif isDefined("attributes.IS_ATTORNEY")>1,<cfelse>0,</cfif>
		#SESSION.EP.USERID#,
		#NOW()#,
		'#CGI.REMOTE_ADDR#',
		#attributes.EVENT_ID#
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=ehesap.popup_attorney_protocol_report&event_id=#attributes.event_id#" addtoken="no">

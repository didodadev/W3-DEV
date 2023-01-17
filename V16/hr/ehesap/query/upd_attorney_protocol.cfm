<cfif LEN(attributes.PROTOCOL_DATE)>
	<cf_date tarih='attributes.PROTOCOL_DATE'>
</cfif>
<cfquery NAME="UPD_ATTORNEY_PROTOCOL" DATASOURCE="#DSN#">
	UPDATE
		EMPLOYEE_EVENT_ATTORNEY_PROTOCOL
	SET
		PROTOCOL_HEAD='#attributes.PROTOCOL_HEAD#',
		PROTOCOL_DATE=<cfif LEN(attributes.PROTOCOL_DATE)>#attributes.PROTOCOL_DATE#,<cfelse>NULL,</cfif>
		DETAIL=<cfif LEN(attributes.DETAIL)>'#attributes.DETAIL#',<cfelse>NULL,</cfif>
		IS_ATTORNEY=<cfif isDefined("attributes.IS_ATTORNEY")>1,<cfelse>0,</cfif>
		RECORD_EMP=#SESSION.EP.USERID#,
		RECORD_DATE=#NOW()#,
		RECORD_IP='#CGI.REMOTE_ADDR#',
		EVENT_ID=#attributes.EVENT_ID#
	WHERE
		ATTORNEY_PROTOCOL_ID=#attributes.ATTORNEY_PROTOCOL_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=ehesap.popup_attorney_protocol_report&event_id=#attributes.event_id#" addtoken="no">


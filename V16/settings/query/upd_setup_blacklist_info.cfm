<cfquery name="UPD_SETUP_BLACKLIST_INFO" datasource="#DSN#">
	UPDATE
		SETUP_BLACKLIST_INFO
		SET
			BLACKLIST_INFO_NAME = '#attributes.blacklist_info_name#',
			BLACKLIST_INFO_DETAIL = <cfif len(attributes.blacklist_info_detail)>'#(attributes.blacklist_info_detail)#',<cfelse>NULL,</cfif>
			UPDATE_EMP =#SESSION.EP.USERID#,
			UPDATE_IP ='#CGI.REMOTE_ADDR#',
			UPDATE_DATE =#NOW()#
			
		WHERE
			BLACKLIST_INFO_ID = #attributes.id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_setup_blacklist_info" addtoken="no">

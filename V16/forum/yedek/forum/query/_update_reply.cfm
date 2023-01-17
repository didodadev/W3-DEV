<cfquery name="UPD_REPLY" datasource="#dsn#">
	UPDATE
		FORUM_REPLYS 
	SET
		IS_ACTIVE = <cfif is_active eq 1>1<cfelse>0</cfif>
	WHERE
		REPLYID = #attributes.REPLYID#
</cfquery>

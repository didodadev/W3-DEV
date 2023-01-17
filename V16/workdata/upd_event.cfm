<cffunction name="upd_event" access="public" returnType="boolean" output="no">
	<cfset attributes.start_date = DateAdd('h',-1*session.ep.time_zone,attributes.start_date)>
	<cfset attributes.end_date = DateAdd('h',-1*session.ep.time_zone,attributes.end_date)>
	
	<cfset start_date = "#DateFormat(attributes.start_date, "yyyy-mm-dd")# #TimeFormat(attributes.start_date, "HH:mm:00")#">
	<cfset end_date = "#DateFormat(attributes.end_date, "yyyy-mm-dd")# #TimeFormat(attributes.end_date, "HH:mm:00")#">
	<cfquery name="upd_event_" datasource="#dsn#">
			UPDATE 
				EVENT 
			SET 
				EVENT_HEAD = '#attributes.text#',
				STARTDATE = '#start_date#',
				FINISHDATE = '#end_date#',
				UPDATE_DATE = #now()#, 
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_EMP = #SESSION.EP.USERID#
			WHERE
				EVENT_ID=#attributes.id#
	</cfquery>
	<cfreturn true>
</cffunction>

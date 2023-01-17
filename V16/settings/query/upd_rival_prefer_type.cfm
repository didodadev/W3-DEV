<cfquery name="upd_rival_prefer_type" datasource="#DSN#">
	UPDATE
    	SETUP_RIVAL_PREFERENCE_REASONS
   SET
	    PREFERENCE_REASON = '#attributes.preference_reason#',
		DETAIL = '#attributes.detail#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#		
   WHERE 
		PREFERENCE_REASON_ID = #url.preference_reason_id#	 
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_rival_prefer_type" addtoken="no">

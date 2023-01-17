<cfquery name="add_rival_prefer_type" datasource="#DSN#">
   INSERT INTO 
    SETUP_RIVAL_PREFERENCE_REASONS
	(
		PREFERENCE_REASON,
		DETAIL,
		RECORD_DATE,
		RECORD_EMP
	 ) 
	 VALUES 
	 (
		'#PREFERENCE_REASON#',
		'#DETAIL#',
		#now()#,
		#session.ep.userid#
	  )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_rival_prefer_type" addtoken="no">

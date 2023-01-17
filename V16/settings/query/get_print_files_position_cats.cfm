<cfquery name="GET_PRINT_FILES_POSITION_CATS" datasource="#DSN#">
	SELECT 
		SPFP.POS_CAT_ID, 
		#dsn#.Get_Dynamic_Language(POSITION_CAT_ID,'#session.ep.language#','SETUP_POSITION_CAT','POSITION_CAT',NULL,NULL,POSITION_CAT) AS POSITION_CAT
	FROM 
		SETUP_PRINT_FILES_POSITION SPFP,
		SETUP_POSITION_CAT SPC
	WHERE
		SPFP.FORM_ID = #attributes.form_id# AND
		SPC.POSITION_CAT_ID = SPFP.POS_CAT_ID AND
        SPFP.OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>

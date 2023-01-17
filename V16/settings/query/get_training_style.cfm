<cfquery name="GET_TRAIN" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_TRAINING_STYLE
	<cfif isdefined("attributes.training_sytle_id")>
		WHERE
			TRAINING_STYLE_ID=#attributes.training_sytle_id#
	</cfif>
</cfquery>

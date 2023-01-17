<cfsetting showdebugoutput="no">
<cfquery name="DEL_CAMP_SURVEY" datasource="#DSN3#">
	DELETE FROM 
   		CAMPAIGN_SURVEYS 
    WHERE 
    	CAMP_ID = #attributes.camp_id# AND 
		SURVEY_ID = #attributes.survey_id#
</cfquery>
<script type="text/javascript">
	document.getElementById('camp_surv_info_<cfoutput>#survey_id#</cfoutput>').innerHTML = '<font color="red">Silindi!</font>';
</script>

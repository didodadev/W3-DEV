<cfquery name="del_pars" datasource="#DSN3#">
   DELETE FROM
     CAMPAIGN_TARGET_PEOPLE
   WHERE
      CAMP_ID = #attributes.camp_id#
	   AND
	  PAR_ID = #attributes.par_id#
</cfquery>
<!--- PARTNER IN NOTLARINI SILIYORUZ --->
<cfquery name="DEL_NOTES" datasource="#DSN3#">
    DELETE FROM
	  CAMPAIGN_NOTES
	WHERE
	  CAMPAIGN_ID = #attributes.camp_id#
	    AND
	  PAR_ID = #attributes.par_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

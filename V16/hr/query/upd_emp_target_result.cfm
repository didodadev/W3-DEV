<cfquery name="GET_TARGET" datasource="#dsn#">
	SELECT 
		COUNT(TARGET_ID) AS TARGET_COUNT
	FROM 
		TARGET TC
	WHERE 
		TC.PER_ID=#attributes.targetperid#
</cfquery>
<cfif GET_TARGET.TARGET_COUNT gt 0>
	<cfloop from="1" to="#GET_TARGET.TARGET_COUNT#" index="i">
    	<cfquery name="GET_TARGET" datasource="#dsn#">
    		UPDATE
            	TARGET
          	SET
            	PERFORM_COMMENT = '#evaluate("attributes.target_comment#i#")#',
                TARGET_RESULT = <cfif len(evaluate("attributes.target_result#i#"))>#evaluate("attributes.target_result#i#")#<cfelse>NULL</cfif>
          	WHERE
            	TARGET_ID = #evaluate("attributes.targetid#i#")#
        </cfquery>
    </cfloop>
</cfif>
<script type="text/javascript">
	history.back();
</script>

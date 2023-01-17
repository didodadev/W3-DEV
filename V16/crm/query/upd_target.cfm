<!--- upd_partner.cfm --->
<cfoutput>
#listlen(form.fieldnames,",")#<br/>
<cfloop from="1" to="#listlen(form.fieldnames,",")#" index="indexer">
	#listgetat(form.fieldnames,indexer,",")#-#evaluate("form."&listgetat(form.fieldnames,indexer,","))#-<br/>
</cfloop>
</cfoutput>
<cfquery name="TARGET" DATASOURCE ="#DSN#">
		UPDATE 
			TARGET 
		SET 
			TARGETCAT_ID = #TARGETCAT_ID#,
			STARTDATE = #STARTDATE#,
			FINISHDATE = #FINISHDATE#,
			TARGET_HEAD = '#TARGET_HEAD#',
			TARGET_NUMBER = #TARGET_NUMBER#, 
			TARGET_DETAIL = '#TARGET_DETAIL#',
			UPDATE_EMP = #SESSION.EP.USERID#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#'		
		WHERE 
		TARGET_ID = #attributes.TARGET_ID#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>



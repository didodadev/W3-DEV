<cfquery name="UPD_ANALYSIS" datasource="#dsn#">
	UPDATE
		MEMBER_ANALYSIS
	SET
		COMMENT1 = '#COMMENT1#', 
		COMMENT2 = '#COMMENT2#', 
		COMMENT3 = '#COMMENT3#', 
		COMMENT4 = '#COMMENT4#', 
		COMMENT5 = '#COMMENT5#', 
	<cfif isDefined("attributes.analysis_product_id") and len(attributes.analysis_product_id)>
	   PRODUCT_ID = #attributes.analysis_product_id#,
	</cfif>
	<cfif len(SCORE1)>
		SCORE1 = #SCORE1#,
	<cfelse>
		SCORE1 = NULL,
	</cfif> 
	<cfif len(SCORE2)>
		SCORE2 = #SCORE2#,
	<cfelse>
		SCORE2 = NULL,
	</cfif> 
	<cfif len(SCORE3)>
		SCORE3 = #SCORE3#,
	<cfelse>
		SCORE3 = NULL,
	</cfif> 
	<cfif len(SCORE4)>
		SCORE4 = #SCORE4#,
	<cfelse>
		SCORE4 = NULL,
	</cfif> 
	<cfif len(SCORE5)>
		SCORE5 = #SCORE5#,
	<cfelse>
		SCORE5 = NULL,
	</cfif> 
	<cfif isDefined("ANALYSIS_PARTNERS")>
		ANALYSIS_PARTNERS = ',#ANALYSIS_PARTNERS#,', 
	<cfelse>
		ANALYSIS_PARTNERS = NULL, 
	</cfif>
	<cfif isDefined("ANALYSIS_CONSUMERS")>
		ANALYSIS_CONSUMERS = ',#ANALYSIS_CONSUMERS#,',  
	<cfelse>
		ANALYSIS_CONSUMERS = NULL,  
	</cfif>
	<cfif isDefined("ANALYSIS_OBJECTIVE")>
		ANALYSIS_OBJECTIVE = '#ANALYSIS_OBJECTIVE#',  
	<cfelse>
		ANALYSIS_OBJECTIVE = NULL,  
	</cfif>
	<cfif isDefined("TOTAL_POINTS")>
		TOTAL_POINTS = #TOTAL_POINTS#, 
	</cfif>
		ANALYSIS_AVERAGE = #ANALYSIS_AVERAGE#, 
		ANALYSIS_HEAD = '#ANALYSIS_HEAD#', 
		IS_ACTIVE = <cfif IsDefined("attributes.IS_ACTIVE")>1<cfelse>0</cfif>,
		IS_PUBLISHED = <cfif IsDefined("attributes.IS_PUBLISHED")>1<cfelse>0</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #SESSION.EP.USERID#, 
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		LANGUAGE_SHORT='#LANGUAGE_SHORT#'
	WHERE
		ANALYSIS_ID = #ANALYSIS_ID#
</cfquery>
<script type="text/javascript">
<!--
	wrk_opener_reload();
	window.close();
-->	
</script>

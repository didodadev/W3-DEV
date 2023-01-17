<CFTRANSACTION>
<cfquery name="ADD_ANALYSIS" datasource="#dsn#">
	INSERT INTO
		MEMBER_ANALYSIS
		(
	<cfif LEN(attributes.analysis_product_id)>
	    PRODUCT_ID,
	</cfif>
	<cfif len(SCORE1)>
 		SCORE1, 
	</cfif>
	<cfif len(SCORE2)>
		SCORE2, 
	</cfif>
	<cfif len(SCORE3)>
		SCORE3, 
	</cfif>
	<cfif len(SCORE4)>
		SCORE4, 
	</cfif>
	<cfif len(SCORE5)>
		SCORE5, 
	</cfif>
	<cfif len(COMMENT1)>
		COMMENT1, 
	</cfif>
	<cfif len(COMMENT2)>
		COMMENT2, 
	</cfif>
	<cfif len(COMMENT3)>
		COMMENT3, 
	</cfif>
	<cfif len(COMMENT4)>
		COMMENT4, 
	</cfif>
	<cfif len(COMMENT5)>
		COMMENT5, 
	</cfif>
	<cfif isDefined("ANALYSIS_PARTNERS")>
		ANALYSIS_PARTNERS, 
	</cfif>
	<cfif isDefined("ANALYSIS_CONSUMERS")>
		ANALYSIS_CONSUMERS,  
	</cfif>
	<cfif len(ANALYSIS_OBJECTIVE) >
		ANALYSIS_OBJECTIVE,  
	</cfif>
		IS_ACTIVE,
		IS_PUBLISHED,
		ANALYSIS_AVERAGE, 
		TOTAL_POINTS, 
		ANALYSIS_HEAD, 
		RECORD_EMP, 
		RECORD_DATE, 
		RECORD_IP,
		LANGUAGE_SHORT
	)
	VALUES
	(
	 <cfif LEN(attributes.analysis_product_id)>
	    #attributes.analysis_product_id#,
	</cfif>
	<cfif len(SCORE1)>
		#SCORE1#, 
	</cfif>
	<cfif len(SCORE2)>
		#SCORE2#, 
	</cfif>
	<cfif len(SCORE3)>
		#SCORE3#, 
	</cfif>
	<cfif len(SCORE4)>
		#SCORE4#, 
	</cfif>
	<cfif len(SCORE5)>
		#SCORE5#, 
	</cfif>
	<cfif len(COMMENT1)>
		'#COMMENT1#', 
	</cfif>
	<cfif len(COMMENT2)>
		'#COMMENT2#', 
	</cfif>
	<cfif len(COMMENT3)>
		'#COMMENT3#', 
	</cfif>
	<cfif len(COMMENT4)>
		'#COMMENT4#', 
	</cfif>
	<cfif len(COMMENT5)>
		'#COMMENT5#', 
	</cfif>
	<cfif isDefined("ANALYSIS_PARTNERS")>
		',#ANALYSIS_PARTNERS#,', 
	</cfif>
	<cfif isDefined("ANALYSIS_CONSUMERS")>
		',#ANALYSIS_CONSUMERS#,',  
	</cfif>
	<cfif len(ANALYSIS_OBJECTIVE)>
		'#ANALYSIS_OBJECTIVE#',  
	</cfif>
	<cfif isDefined("IS_ACTIVE")>
		1,
	<cfelse>
		0,
	</cfif>
	<cfif isDefined("IS_PUBLISHED")>
		1,
	<cfelse>
		0,
	</cfif>
		#FORM.ANALYSIS_AVERAGE#, 
		#TOTAL_POINTS#, 
		'#ANALYSIS_HEAD#', 
		#SESSION.EP.USERID#, 
		#now()#,
		'#CGI.REMOTE_ADDR#',
		<cfif LEN(attributes.LANGUAGE_SHORT)>'#attributes.LANGUAGE_SHORT#'<cfelse>NULL</cfif>
		)
</cfquery>
<cfquery name="get_ANALYSIS" datasource="#dsn#">
	SELECT
		MAX(ANALYSIS_ID) AS MAX_ID
	FROM
		MEMBER_ANALYSIS
</cfquery>
</CFTRANSACTION>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script> 

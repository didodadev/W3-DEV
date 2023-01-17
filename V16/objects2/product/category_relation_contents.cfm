<cfif isDefined('attributes.product_catid') and len(attributes.product_catid)>
<cfquery name="GET_CAT_CONTENT" datasource="#DSN#">
	SELECT 
		C.CONTENT_ID,
		C.CONT_HEAD,
		C.CONT_BODY,
		C.USER_FRIENDLY_URL,
		C.CONT_SUMMARY,
		C.PRIORITY
	FROM 
		CONTENT_RELATION CCR,
		CONTENT C
	WHERE 
		CCR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
		<cfif isdefined("session.pp.company_category")>
			C.COMPANY_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.company_category#,%"> AND
		<cfelseif isdefined("session.ww.consumer_category")>
			C.CONSUMER_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ww.consumer_category#,%"> AND
		<cfelseif isdefined("session.cp")>
			C.CAREER_VIEW = 1  AND
		<cfelse>
			C.INTERNET_VIEW = 1  AND
		</cfif>     
		CCR.CONTENT_ID = C.CONTENT_ID AND
		CCR.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#"> AND
		CCR.ACTION_TYPE = 'PRODUCT_CATID'
</cfquery>

<cfif get_cat_content.recordcount>
	<cfoutput query="get_cat_content">
    	#cont_body#
    </cfoutput>
</cfif>
</cfif>


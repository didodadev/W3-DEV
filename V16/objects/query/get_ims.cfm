<cfquery name="GET_IMS" datasource="#dsn#">
	SELECT
		IMS_CODE_ID,
		IMS_CODE,
		IMS_CODE_NAME
	FROM
		SETUP_IMS_CODE
	WHERE
	 1 = 1
	<cfif isdefined("attributes.keyword")>
	AND ((IMS_CODE LIKE '%#attributes.keyword#%') or (IMS_CODE_NAME LIKE '%#attributes.keyword#%'))
	</cfif>
    AND IMS_CODE_ID NOT IN (SELECT IMS_ID FROM #dsn3#.SALES_ZONES_IMS_RELATION WHERE SZ_ID = #attributes.sz_id#) 

	ORDER BY 
		IMS_CODE_NAME
</cfquery>


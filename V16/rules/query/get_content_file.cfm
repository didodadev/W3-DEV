<cfquery name="GET_ASSET" datasource="#DSN#">
	SELECT
		*
	FROM
		ASSET,
		CONTENT_PROPERTY AS CP
	WHERE
		ASSET.ACTION_SECTION = 'CONTENT_ID' AND
        <cfif listlen(attributes.cntid) eq 1>
			ASSET.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cntid#"> AND
        <cfelse>
			ASSET.ACTION_ID  IN (#attributes.cntid#) AND        
        </cfif>
		ASSET.PROPERTY_ID = CP.CONTENT_PROPERTY_ID
		AND (ASSET.IS_IMAGE = 0 OR ASSET.IS_IMAGE IS NULL)
		AND 
		(
			ASSET.IS_SPECIAL = 0 OR
		  	ASSET.IS_SPECIAL IS NULL 
			OR (ASSET.IS_SPECIAL = 1 AND (ASSET.RECORD_EMP = 15 OR ASSET.UPDATE_EMP = 15))
		)
	ORDER BY 
		ASSET.ASSET_NAME,
		ASSET.ACTION_ID
</cfquery>

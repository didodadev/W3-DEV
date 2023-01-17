<cfquery name="GET_COUNTRY" datasource="#DSN#">
	SELECT
		COUNTRY_ID,
		CASE
			WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
			ELSE COUNTRY_NAME
		END AS COUNTRY_NAME,
		COUNTRY_PHONE_CODE,
		COUNTRY_CODE,
		IS_DEFAULT
	FROM
		SETUP_COUNTRY
		LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_COUNTRY.COUNTRY_ID
        AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="COUNTRY_NAME">
        AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_COUNTRY">
        AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	ORDER BY
		COUNTRY_NAME
</cfquery>

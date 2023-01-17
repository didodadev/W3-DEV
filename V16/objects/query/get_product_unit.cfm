<cfif isDefined("attributes.pid")>
	<cfquery name="GET_PRODUCT_UNIT" datasource="#dsn3#">
		SELECT 
			CASE
            WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
            ELSE ADD_UNIT
        	END AS ADD_UNIT,
			ADD_UNIT AS TR_UNIT,
			PRODUCT_UNIT_ID 
		FROM 
			PRODUCT_UNIT 
			LEFT JOIN #dsn_alias#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PRODUCT_UNIT.UNIT_ID
			AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="UNIT">
			AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_UNIT">
			AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
		WHERE 
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
			AND PRODUCT_UNIT_STATUS = 1 
		ORDER BY ADD_UNIT
	</cfquery>
<cfelseif isDefined("attributes.unit_id")>
	<cfquery name="GET_PRODUCT_UNIT" datasource="#dsn3#">
		SELECT 
			CASE
            WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
            ELSE ADD_UNIT
        	END AS ADD_UNIT,
			ADD_UNIT AS TR_UNIT
		FROM 
			PRODUCT_UNIT 
			LEFT JOIN #dsn_alias#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PRODUCT_UNIT.UNIT_ID
			AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="UNIT">
			AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_UNIT">
			AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
		WHERE 
			PRODUCT_UNIT_ID = #attributes.unit_id# 
		ORDER BY ADD_UNIT
	</cfquery>
	<cfquery name="get_product" datasource="#dsn3#">
		SELECT 
			P.PRODUCT_ID,
			CASE
            WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
            ELSE ADD_UNIT
        	END AS ADD_UNIT,
			PU.ADD_UNIT AS TR_UNIT,
			PU.MAIN_UNIT,
			P.PRODUCT_NAME,
			PU.UNIT_MULTIPLIER,
			PU.UNIT_MULTIPLIER_STATIC
		FROM 
			PRODUCT P, 
			PRODUCT_UNIT PU
			LEFT JOIN #dsn_alias#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PU.UNIT_ID
			AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="UNIT">
			AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_UNIT">
			AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
		WHERE  
			P.PRODUCT_ID = PU.PRODUCT_ID AND 
			PU.PRODUCT_UNIT_ID = #attributes.unit_id#
	</cfquery>
</cfif>

<cfif isDefined("attributes.pid")>
	<cfquery name="GET_PRODUCT_UNIT" datasource="#DSN3#">
		SELECT 
			PRODUCT_UNIT_ID,IS_MAIN,
			CASE
            	WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
				ELSE MAIN_UNIT
			END AS MAIN_UNIT,
			MAIN_UNIT_ID,UNIT_ID,
			CASE
            	WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
				ELSE ADD_UNIT
			END AS ADD_UNIT,MULTIPLIER,DIMENTION,VOLUME,WEIGHT,UNIT_MULTIPLIER,UNIT_MULTIPLIER_STATIC,IS_SHIP_UNIT,IS_ADD_UNIT 
			FROM 
				PRODUCT_UNIT 
				LEFT JOIN #DSN#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PRODUCT_UNIT.UNIT_ID
				AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="UNIT">
				AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_UNIT">
				AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
			WHERE 
				PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND PRODUCT_UNIT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> 
			ORDER BY 
				ADD_UNIT
    </cfquery>
<cfelseif isDefined("attributes.unit_id")>
	<cfquery name="GET_PRODUCT_UNIT" datasource="#DSN3#">
		SELECT 
        	PRODUCT_UNIT_ID, 
            CASE
            	WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
				ELSE ADD_UNIT
			END AS ADD_UNIT,
            IS_MAIN,
            UNIT_ID,
            MULTIPLIER,
            QUANTITY,
            DIMENTION, 
            VOLUME, 
            WEIGHT,
            UNIT_MULTIPLIER, 
            UNIT_MULTIPLIER_STATIC, 
            IS_SHIP_UNIT, 
            IS_ADD_UNIT,
            CASE
            	WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
				ELSE MAIN_UNIT
			END AS MAIN_UNIT, 
            MAIN_UNIT_ID,
			PACKAGES,
			PATH,
			PACKAGE_CONTROL_TYPE,
			INSTRUCTION 
        FROM 
			PRODUCT_UNIT 
				LEFT JOIN #DSN#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PRODUCT_UNIT.UNIT_ID
				AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="UNIT">
				AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_UNIT">
				AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
        WHERE 
        	PRODUCT_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#"> 
        ORDER BY 
        	ADD_UNIT
	</cfquery>
	<cfquery name="GET_PRODUCT" datasource="#DSN3#">
		SELECT 
			P.PRODUCT_ID,
			PU.IS_ADD_UNIT,
			PU.ADD_UNIT,
			PU.MAIN_UNIT,
			P.PRODUCT_NAME,
			PU.UNIT_MULTIPLIER,
			PU.UNIT_MULTIPLIER_STATIC,
			PU.IS_SHIP_UNIT,
            PU.RECORD_EMP,
            PU.UPDATE_EMP,
            PU.RECORD_DATE,
            PU.UPDATE_DATE
		FROM 
			PRODUCT P, 
			PRODUCT_UNIT PU
		WHERE  
			P.PRODUCT_ID = PU.PRODUCT_ID AND 
			PU.PRODUCT_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#">
	</cfquery>
</cfif>

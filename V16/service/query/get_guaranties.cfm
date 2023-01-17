<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfquery name="GET_CONSUMER_GUARANTIES" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
	WITH CTE1 AS (
    SELECT
		SERVICE_GUARANTY_NEW.GUARANTY_ID,
		SERVICE_GUARANTY_NEW.IN_OUT,
		SERVICE_GUARANTY_NEW.STOCK_ID,
		SERVICE_GUARANTY_NEW.SERIAL_NO,
		SERVICE_GUARANTY_NEW.LOT_NO,
		SERVICE_GUARANTY_NEW.CERTIFICA_NO,
		SERVICE_GUARANTY_NEW.SALE_START_DATE,
		SERVICE_GUARANTY_NEW.SALE_FINISH_DATE,
		SERVICE_GUARANTY_NEW.PROCESS_NO,
		SERVICE_GUARANTY_NEW.PURCHASE_START_DATE,
		SERVICE_GUARANTY_NEW.PURCHASE_FINISH_DATE,
		SERVICE_GUARANTY_NEW.PURCHASE_GUARANTY_CATID,
		SERVICE_GUARANTY_NEW.SALE_GUARANTY_CATID
		<cfif database_type is 'MSSQL'>
			,DATEDIFF(DAY,SERVICE_GUARANTY_NEW.SALE_START_DATE,SERVICE_GUARANTY_NEW.SALE_FINISH_DATE) AS TIME
		<cfelseif database_type is 'DB2'>
			,DAY(SERVICE_GUARANTY_NEW.SALE_FINISH_DATE-SERVICE_GUARANTY_NEW.SALE_START_DATE) AS TIME
		</cfif>
		<!---<cfif database_type is 'MSSQL'>
			,DATEDIFF(DAY,SERVICE_GUARANTY_NEW.PURCHASE_START_DATE,SERVICE_GUARANTY_NEW.PURCHASE_FINISH_DATE) AS TIME
		<cfelseif database_type is 'DB2'>
			,DAY(SERVICE_GUARANTY_NEW.PURCHASE_FINISH_DATE-SERVICE_GUARANTY_NEW.PURCHASE_START_DATE) AS TIME
		</cfif>--->
	FROM
		SERVICE_GUARANTY_NEW WITH (NOLOCK)
	WHERE
		SERVICE_GUARANTY_NEW.GUARANTY_ID IS NOT NULL
		<cfif isDefined("attributes.category") and len(attributes.category)>
			AND
			(
				SERVICE_GUARANTY_NEW.SALE_GUARANTY_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.category#"> OR
				SERVICE_GUARANTY_NEW.PURCHASE_GUARANTY_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.category#">
			)
		</cfif>
		<cfif isDefined("attributes.stock_id") and Len(attributes.stock_id) and len(attributes.product_name)>
			AND	SERVICE_GUARANTY_NEW.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND SERVICE_GUARANTY_NEW.SERIAL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		</cfif>
		<cfif isDefined("attributes.lot_no") and len(attributes.lot_no)>
			AND SERVICE_GUARANTY_NEW.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.lot_no#">
		</cfif>
		<cfif isDefined("attributes.belge_no") and len(attributes.belge_no)>
			AND SERVICE_GUARANTY_NEW.PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.belge_no#">
		</cfif>
		<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
			AND (
				SERVICE_GUARANTY_NEW.SALE_START_DATE >= #attributes.start_date# OR
				SERVICE_GUARANTY_NEW.PURCHASE_START_DATE >= #attributes.start_date#
				)
		</cfif>
		<cfif  isdefined("attributes.finish_date") and  len(attributes.finish_date)>
			AND (
				SERVICE_GUARANTY_NEW.SALE_START_DATE <= #attributes.finish_date# OR
				SERVICE_GUARANTY_NEW.PURCHASE_START_DATE <= #attributes.finish_date#
				)
		</cfif>
        ),
        CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (	<cfif attributes.oby eq 1>
											ORDER BY purchase_start_date DESC
										<cfelseif attributes.oby eq 2>
											ORDER BY purchase_start_date asc
										<cfelse>
											ORDER BY SERIAL_NO ASC
										</cfif>
									) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
</cfquery>

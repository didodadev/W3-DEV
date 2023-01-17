<cfquery name="GET_STOCK_RESERVED" datasource="#DSN3#"><!--- siparisler stoktan dusulecek veya eklenecekse toplamını alalım--->
	SELECT
		SUM(STOCK_AZALT) AS AZALAN,
		SUM(STOCK_ARTIR) AS ARTAN
	FROM
		<cfif (isdefined("attributes.dept_loc_info_stock_") and len(attributes.dept_loc_info_stock_)) or (isdefined("attributes.department_id") and len(attributes.department_id))>
			GET_STOCK_RESERVED_ROW_LOCATION
		<cfelse>	
			GET_STOCK_RESERVED 
		</cfif>		
	WHERE
		<cfif isdefined('attributes.sid') and len(attributes.sid)>
			STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
		<cfelse>
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> 
		</cfif>
		<cfif isdefined("attributes.dept_loc_info_stock_") and len(attributes.dept_loc_info_stock_)>
			AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.dept_loc_info_stock_,'-')#">
			<cfif listlen(attributes.dept_loc_info_,'-') eq 2>
				AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.dept_loc_info_stock_,'-')#">
			</cfif>
		<cfelseif isdefined("attributes.department_id") and len(attributes.department_id)>
			AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
			<cfif isdefined("attributes.location_id") and len(attributes.location_id)>
				AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#">
			</cfif>
		</cfif>
</cfquery>
<cfquery name="GET_PROD_RESERVED" datasource="#DSN3#"><!--- üretim emrinden gelen stok rezerv --->
	SELECT
		SUM(STOCK_AZALT) AS AZALAN,
		SUM(STOCK_ARTIR) AS ARTAN
	FROM
		<cfif (isdefined("attributes.dept_loc_info_stock_") and len(attributes.dept_loc_info_stock_)) or (isdefined("attributes.department_id") and len(attributes.department_id))>
			GET_PRODUCTION_RESERVED_LOCATION
		<cfelse>	
			GET_PRODUCTION_RESERVED 
		</cfif>		
	WHERE
    	<cfif isdefined('attributes.sid') and len(attributes.sid)>
			STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
		<cfelse>
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
		</cfif>
		<cfif isdefined("attributes.dept_loc_info_stock_") and len(attributes.dept_loc_info_stock_)>
			AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.dept_loc_info_stock_,'-')#">
			<cfif listlen(attributes.dept_loc_info_,'-') eq 2>
				AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.dept_loc_info_stock_,'-')#">
			</cfif>
		<cfelseif isdefined("attributes.department_id") and len(attributes.department_id)>
			AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
			<cfif isdefined("attributes.location_id") and len(attributes.location_id)>
				AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#">
			</cfif>
		</cfif>
</cfquery>
<cfquery name="LOCATION_BASED_TOTAL_STOCK" datasource="#DSN2#">
	SELECT
		SUM(STOCK_IN - SR.STOCK_OUT) AS TOTAL_LOCATION_STOCK
	FROM
		STOCKS_ROW SR,
		#dsn_alias#.STOCKS_LOCATION SL 
	WHERE
    	<cfif isdefined('attributes.sid') and len(attributes.sid)>
        	SR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
		<cfelse>
        	SR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
		</cfif> AND
		SR.STORE = SL.DEPARTMENT_ID AND
		SR.STORE_LOCATION = SL.LOCATION_ID AND
		NO_SALE = 1
		<cfif isdefined("attributes.dept_loc_info_stock_") and len(attributes.dept_loc_info_stock_)>
			AND SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.dept_loc_info_stock_,'-')#">
			<cfif listlen(attributes.dept_loc_info_,'-') eq 2>
				AND SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.dept_loc_info_stock_,'-')#">
			</cfif>
		<cfelseif isdefined("attributes.department_id") and len(attributes.department_id)>
			AND SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
			<cfif isdefined("attributes.location_id") and len(attributes.location_id)>
				AND SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#">
			</cfif>
		</cfif>
</cfquery>
<cfquery name="SCRAP_NOSALE_LOCATION_TOTAL_STOCK" datasource="#DSN2#">
	SELECT
		SUM(STOCK_IN - SR.STOCK_OUT) AS TOTAL_LOCATION_STOCK
	FROM
		STOCKS_ROW SR,
		#dsn_alias#.STOCKS_LOCATION SL 
	WHERE
    	<cfif isdefined('attributes.sid') and len(attributes.sid)>
        	SR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
		<cfelse>
        	SR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
		</cfif> AND
		SR.STORE = SL.DEPARTMENT_ID AND
		SR.STORE_LOCATION = SL.LOCATION_ID AND
		NO_SALE = 1 AND
        ISNULL(SL.IS_SCRAP,0) = 1
		<cfif isdefined("attributes.dept_loc_info_stock_") and len(attributes.dept_loc_info_stock_)>
			AND SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.dept_loc_info_stock_,'-')#">
			<cfif listlen(attributes.dept_loc_info_,'-') eq 2>
				AND SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.dept_loc_info_stock_,'-')#">
			</cfif>
		<cfelseif isdefined("attributes.department_id") and len(attributes.department_id)>
			AND SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
			<cfif isdefined("attributes.location_id") and len(attributes.location_id)>
				AND SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#">
			</cfif>
		</cfif>
</cfquery>
<cfquery name="SCRAP_LOCATION_TOTAL_STOCK" datasource="#DSN2#">
	SELECT
		SUM(STOCK_IN - SR.STOCK_OUT) AS TOTAL_SCRAP_STOCK
	FROM
		STOCKS_ROW SR,
		#dsn_alias#.STOCKS_LOCATION SL 
	WHERE
    	<cfif isdefined('attributes.sid') and len(attributes.sid)>
        	SR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
		<cfelse>
       	    SR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
		</cfif> AND
		SR.STORE = SL.DEPARTMENT_ID AND
		SR.STORE_LOCATION = SL.LOCATION_ID AND
		ISNULL(SL.IS_SCRAP,0) = 1
		<cfif isdefined("attributes.dept_loc_info_stock_") and len(attributes.dept_loc_info_stock_)>
			AND SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.dept_loc_info_stock_,'-')#">
			<cfif listlen(attributes.dept_loc_info_,'-') eq 2>
				AND SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.dept_loc_info_stock_,'-')#">
			</cfif>
		<cfelseif isdefined("attributes.department_id") and len(attributes.department_id)>
			AND SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
			<cfif isdefined("attributes.location_id") and len(attributes.location_id)>
				AND SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#">
			</cfif>
		</cfif>
</cfquery>

<cfquery name="GET_NOSALE_LOCATION_RESERVE_STOCK" datasource="#DSN3#"><!--- satış yapılamaz lokasyonlarda rezerve edilen satınalma siparişleri --->
	SELECT
		SUM(STOCK_ARTIR) AS NOSALE_RESERVE_STOCK
	FROM
	(
		SELECT 
			SUM(
				CASE WHEN SR.SPECT_ID IS NOT NULL AND  SR.IS_SEVK = 1  THEN (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)* SR.AMOUNT_VALUE * PU.MULTIPLIER 
																	   ELSE  (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER END 
			)AS STOCK_ARTIR,
			S.STOCK_ID,
			S.PRODUCT_ID
		 FROM
			#DSN1#.STOCKS S
			JOIN GET_ORDER_ROW_RESERVED ORR ON S.STOCK_ID = ORR.STOCK_ID
			JOIN ORDERS ORDS ON  ORR.ORDER_ID = ORDS.ORDER_ID
			LEFT JOIN SPECTS_ROW SR ON SR.SPECT_ID = ORR.SPECT_VAR_ID
			JOIN #dsn_alias#.STOCKS_LOCATION SL  ON ORDS.DELIVER_DEPT_ID = SL.DEPARTMENT_ID AND ORDS.LOCATION_ID = SL.LOCATION_ID 
			JOIN #DSN1#.PRODUCT_UNIT PU ON PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID
		 WHERE
			
			ORDS.RESERVED = 1 AND
			ORDS.ORDER_STATUS = 1 AND
			ORDS.PURCHASE_SALES = 0 AND
			ORDS.ORDER_ZONE = 0 AND
			ORDS.DELIVER_DEPT_ID IS NOT NULL AND 
			SL.NO_SALE = 1 AND		
			(ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0
			<cfif isdefined('attributes.dept_loc_info_stock_') and len(attributes.dept_loc_info_stock_)>
				AND ORDS.DELIVER_DEPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.dept_loc_info_stock_,'-')#">
				<cfif listlen(attributes.dept_loc_info_stock_,'-') eq 2>
					AND ORDS.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.dept_loc_info_stock_,'-')#">
				</cfif>
			<cfelseif isdefined("attributes.department_id") and len(attributes.department_id)>
				AND ORDS.DELIVER_DEPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
				<cfif isdefined("attributes.location_id") and len(attributes.location_id)>
					AND ORDS.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#">
				</cfif>
			</cfif>
		GROUP BY 			
			S.STOCK_ID,
			S.PRODUCT_ID
	)
		AS NOSALE_LOCATION_RESERVE
	WHERE
	<cfif isdefined('attributes.sid') and len(attributes.sid)>
		STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
	<cfelse>
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
	</cfif>
</cfquery>

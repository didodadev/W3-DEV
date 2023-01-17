<!--- asagıdaki queryler satış yapılabilir stok miktarı hesaplamalarında kullanıyor OZDEN20060530--->
<cfscript>
	azalan_stock_list="";
	artan_stock_list="";
	prod_reserved_list="";
	location_stock_list="";
</cfscript>
<cfif not isdefined("new_dsn3")>
	<cfset new_dsn3 =  dsn3>
</cfif>
<cfif not isdefined("new_dsn2")>
	<cfset new_dsn2 =  dsn2>
</cfif>
<cfif basket_prod_list.PRODUCT_SELECT_TYPE neq 6><!--- specli urun listesinden cagrılmamıssa --->
	<cfquery name="GET_STOCK_AZALAN" datasource="#new_dsn3#"><!--- alınan siparis icin rezerve edilen miktar --->
		SELECT
			SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS AZALAN,
			S.STOCK_ID		
		FROM
			#dsn1_alias#.STOCKS S,
			GET_ORDER_ROW_RESERVED ORR, 
			ORDERS ORDS,
			PRODUCT_UNIT PU
		WHERE
			ORR.STOCK_ID = S.STOCK_ID AND 
			ORDS.RESERVED = 1 AND 
			ORDS.ORDER_STATUS = 1 AND	
			ORR.ORDER_ID = ORDS.ORDER_ID AND
			(	
				(
					ORDS.PURCHASE_SALES = 1 AND
					ORDS.ORDER_ZONE = 0
				 )  
				OR
				(	ORDS.PURCHASE_SALES = 0 AND
					ORDS.ORDER_ZONE = 1
				)
			)
			AND S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
			AND (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0
			AND S.STOCK_ID IN (#stock_list#)
			<cfif isdefined("attributes.departmen_location_info") and len(attributes.departmen_location_info)>
				AND ORDS.DELIVER_DEPT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.departmen_location_info,'-')#">
				AND ORDS.LOCATION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.departmen_location_info,'-')#">
			</cfif>
		GROUP BY S.STOCK_ID
	</cfquery>
	<cfquery name="GET_STOCK_ARTAN" datasource="#new_dsn3#"><!--- verilen sipariş  sonucu beklenen miktar--->
		SELECT
			SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS ARTAN,
			S.STOCK_ID
		FROM
			#dsn1_alias#.STOCKS S,
			GET_ORDER_ROW_RESERVED ORR, 
			#dsn_alias#.STOCKS_LOCATION SL,
			ORDERS ORDS,
			PRODUCT_UNIT PU
		WHERE
			ORR.STOCK_ID = S.STOCK_ID AND 
			ORDS.RESERVED = 1 AND 
			ORDS.ORDER_STATUS = 1 AND	
			ORR.ORDER_ID = ORDS.ORDER_ID AND
			ORDS.PURCHASE_SALES = 0 AND
			ORDS.ORDER_ZONE = 0  AND
			ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND
			ORDS.LOCATION_ID=SL.LOCATION_ID AND
			SL.NO_SALE =0 AND
			S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID  AND
			(ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 AND 
			S.STOCK_ID IN (#stock_list#)
			<cfif isdefined("attributes.departmen_location_info") and len(attributes.departmen_location_info)>
				AND ORDS.DELIVER_DEPT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.departmen_location_info,'-')#">
				AND ORDS.LOCATION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.departmen_location_info,'-')#">
			</cfif>
		GROUP BY S.STOCK_ID
	</cfquery>
<cfelse>
	<cfquery name="GET_STOCK_AZALAN" datasource="#new_dsn3#"><!--- alınan siparis icin rezerve edilen miktar --->
		SELECT
			SUM(AZALAN) AS AZALAN,
			STOCK_ID,
			SPECT_VAR_ID
		FROM
		(
			SELECT
				((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS AZALAN,
				S.STOCK_ID,		
				ORR.SPECT_VAR_ID
			FROM
				#dsn1_alias#.STOCKS S,
				GET_ORDER_ROW_RESERVED ORR, 
				ORDERS ORDS,
				PRODUCT_UNIT PU
			WHERE
				ORR.STOCK_ID = S.STOCK_ID AND 
				ORDS.RESERVED = 1 AND 
				ORDS.ORDER_STATUS = 1 AND	
				ORR.SPECT_VAR_ID IS NULL AND
				ORR.ORDER_ID = ORDS.ORDER_ID AND
				(	
					(
						ORDS.PURCHASE_SALES = 1 AND
						ORDS.ORDER_ZONE = 0
					 )  
					OR
					(	ORDS.PURCHASE_SALES = 0 AND
						ORDS.ORDER_ZONE = 1
					)
				)
				AND S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
				AND (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0
				AND S.STOCK_ID IN (#stock_list#)
				<cfif isdefined("attributes.departmen_location_info") and len(attributes.departmen_location_info)>
					AND ORDS.DELIVER_DEPT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.departmen_location_info,'-')#">
					AND ORDS.LOCATION_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.departmen_location_info,'-')#">
				</cfif>
			UNION ALL
			
			SELECT
				((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS AZALAN,
				S.STOCK_ID,		
				SPECTS.SPECT_MAIN_ID AS SPECT_VAR_ID
			FROM
				#dsn1_alias#.STOCKS S,
				GET_ORDER_ROW_RESERVED ORR, 
				ORDERS ORDS,
				PRODUCT_UNIT PU,
				SPECTS
			WHERE
				ORR.STOCK_ID = S.STOCK_ID AND 
				ORDS.RESERVED = 1 AND 
				ORDS.ORDER_STATUS = 1 AND	
				ORR.SPECT_VAR_ID IS NOT NULL AND
				SPECTS.SPECT_VAR_ID=ORR.SPECT_VAR_ID AND
				ORR.ORDER_ID = ORDS.ORDER_ID AND
				(	
					(
						ORDS.PURCHASE_SALES = 1 AND
						ORDS.ORDER_ZONE = 0
					 )  
					OR
					(	ORDS.PURCHASE_SALES = 0 AND
						ORDS.ORDER_ZONE = 1
					)
				)
				AND S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
				AND (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0
				AND S.STOCK_ID IN (#stock_list#)
				<cfif isdefined("attributes.departmen_location_info") and len(attributes.departmen_location_info)>
					AND ORDS.DELIVER_DEPT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.departmen_location_info,'-')#">
					AND ORDS.LOCATION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.departmen_location_info,'-')#">
				</cfif>
		) AS A1
		GROUP BY
			STOCK_ID,
			SPECT_VAR_ID
	</cfquery>
	<cfquery name="GET_STOCK_ARTAN" datasource="#new_dsn3#"><!--- verilen sipariş  sonucu beklenen miktar--->
		SELECT
			SUM(ARTAN) AS ARTAN,
			STOCK_ID,
			SPECT_VAR_ID
		FROM
		(
		SELECT
			((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS ARTAN,
			S.STOCK_ID,
			ORR.SPECT_VAR_ID
		FROM
			#dsn1_alias#.STOCKS S,
			GET_ORDER_ROW_RESERVED ORR, 
			#dsn_alias#.STOCKS_LOCATION SL,
			ORDERS ORDS,
			PRODUCT_UNIT PU
		WHERE
			ORR.STOCK_ID = S.STOCK_ID AND 
			ORDS.RESERVED = 1 AND 
			ORDS.ORDER_STATUS = 1 AND	
			ORR.ORDER_ID = ORDS.ORDER_ID AND
			ORR.SPECT_VAR_ID IS NULL AND
			ORDS.PURCHASE_SALES = 0 AND
			ORDS.ORDER_ZONE = 0  AND
			ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND
			ORDS.LOCATION_ID=SL.LOCATION_ID AND
			SL.NO_SALE =0 AND
			S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID  AND
			(ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 AND 
			S.STOCK_ID IN (#stock_list#)
			<cfif isdefined("attributes.departmen_location_info") and len(attributes.departmen_location_info)>
				AND ORDS.DELIVER_DEPT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.departmen_location_info,'-')#">
				AND ORDS.LOCATION_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.departmen_location_info,'-')#">
			</cfif>
		UNION ALL
		SELECT
			((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS ARTAN,
			S.STOCK_ID,
			SPECTS.SPECT_MAIN_ID AS SPECT_VAR_ID
		FROM
			#dsn1_alias#.STOCKS S,
			GET_ORDER_ROW_RESERVED ORR, 
			#dsn_alias#.STOCKS_LOCATION SL,
			ORDERS ORDS,
			PRODUCT_UNIT PU,
			SPECTS
		WHERE
			ORR.STOCK_ID = S.STOCK_ID AND 
			ORDS.RESERVED = 1 AND 
			ORDS.ORDER_STATUS = 1 AND	
			ORR.ORDER_ID = ORDS.ORDER_ID AND
			ORR.SPECT_VAR_ID IS NOT NULL AND
			SPECTS.SPECT_VAR_ID=ORR.SPECT_VAR_ID AND
			ORDS.PURCHASE_SALES = 0 AND
			ORDS.ORDER_ZONE = 0  AND
			ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND
			ORDS.LOCATION_ID=SL.LOCATION_ID AND
			SL.NO_SALE =0 AND
			S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID  AND
			(ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 AND 
			S.STOCK_ID IN (#stock_list#)
			<cfif isdefined("attributes.departmen_location_info") and len(attributes.departmen_location_info)>
				AND ORDS.DELIVER_DEPT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.departmen_location_info,'-')#">
				AND ORDS.LOCATION_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.departmen_location_info,'-')#">
			</cfif>
		) AS A2
		GROUP BY
			STOCK_ID,
			SPECT_VAR_ID
	</cfquery>
</cfif>

<cfquery name="GET_PROD_RESERVED" datasource="#new_dsn3#"><!--- üretim emrinden gelen stok rezerv --->
	SELECT
		SUM(STOCK_ARTIR-STOCK_AZALT) AS FARK,
		STOCK_ID
		<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 6>
		,SPECT_MAIN_ID
		</cfif>
	FROM
		<cfif isdefined("attributes.departmen_location_info") and len(attributes.departmen_location_info)>
			<cfif basket_prod_list.PRODUCT_SELECT_TYPE neq 6>
				GET_PRODUCTION_RESERVED_LOCATION
			<cfelse>
				GET_PRODUCTION_RESERVED_SPECT_LOCATION
			</cfif>
		<cfelse>
			<cfif basket_prod_list.PRODUCT_SELECT_TYPE neq 6>
				GET_PRODUCTION_RESERVED
			<cfelse>
				GET_PRODUCTION_RESERVED_SPECT
			</cfif>
		</cfif>
	WHERE
		STOCK_ID IN (#stock_list#)
		<cfif isdefined("attributes.departmen_location_info") and len(attributes.departmen_location_info)>
			AND DEPARTMENT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.departmen_location_info,'-')#">
			AND LOCATION_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.departmen_location_info,'-')#">
		</cfif>
	GROUP BY STOCK_ID <cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 6>,SPECT_MAIN_ID</cfif>
</cfquery>
<!--- kullanılabilir lokasyonlardaki (servis ve 3.parti kurumlara ait lokasyonlar haricindeki) urun toplam miktarı --->
<cfquery name="LOCATION_BASED_STOCK" datasource="#new_dsn2#">
	SELECT 
		<cfif isdefined("attributes.departmen_location_info") and len(attributes.departmen_location_info)>
			SUM(SR.STOCK_IN - SR.STOCK_OUT) TOTAL_STOCK, 
		<cfelse>
			SUM(TOTAL_STOCK) TOTAL_STOCK, 
		</cfif>
		PRODUCT_ID, 
		STOCK_ID
		<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 6>
		,SPECT_VAR_ID
		</cfif>
	FROM
		<cfif isdefined("attributes.departmen_location_info") and len(attributes.departmen_location_info)>
			#dsn_alias#.STOCKS_LOCATION SL,
			STOCKS_ROW SR
		<cfelse>
			<cfif basket_prod_list.PRODUCT_SELECT_TYPE neq 6>
				GET_STOCK_LOCATION
			<cfelse>
				GET_STOCK_LOCATION_SPECT
			</cfif>
		</cfif>
	WHERE
		STOCK_ID IN (#stock_list#)
		<cfif isdefined("attributes.departmen_location_info") and len(attributes.departmen_location_info)>
			AND SR.STORE =SL.DEPARTMENT_ID
			AND SR.STORE_LOCATION=SL.LOCATION_ID
			AND SL.NO_SALE = 0
			AND SR.STORE=<cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.departmen_location_info,'-')#">
			AND SR.STORE_LOCATION=<cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.departmen_location_info,'-')#">
		</cfif>
	GROUP BY
		PRODUCT_ID, 
		STOCK_ID
		<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 6>
		,SPECT_VAR_ID
		</cfif>
	ORDER BY 
		STOCK_ID
</cfquery>
<cfif basket_prod_list.PRODUCT_SELECT_TYPE neq 6>
	<cfset azalan_stock_list=valuelist(get_stock_azalan.STOCK_ID,',')>
	<cfset artan_stock_list=valuelist(get_stock_artan.STOCK_ID,',')>
	<cfset prod_reserved_list=valuelist(get_prod_reserved.STOCK_ID,',')>
	<cfset location_stock_list = valuelist(location_based_stock.STOCK_ID,',')>
<cfelse>
	<cfoutput query="get_stock_azalan">
		<cfset azalan_stock_list=ListAppend(azalan_stock_list,'#get_stock_azalan.STOCK_ID#-#get_stock_azalan.SPECT_VAR_ID#',',')>
	</cfoutput>
	<cfoutput query="get_stock_artan">
		<cfset artan_stock_list=ListAppend(artan_stock_list,'#get_stock_artan.STOCK_ID#-#get_stock_azalan.SPECT_VAR_ID#',',')>
	</cfoutput>
	<cfoutput query="get_prod_reserved">
		<cfset prod_reserved_list=ListAppend(prod_reserved_list,'#get_prod_reserved.STOCK_ID#-#get_prod_reserved.SPECT_MAIN_ID#',',')>
	</cfoutput>
	<cfoutput query="location_based_stock">
		<cfset location_stock_list=ListAppend(location_stock_list,'#location_based_stock.STOCK_ID#-#location_based_stock.SPECT_VAR_ID#',',')>
	</cfoutput>
</cfif>


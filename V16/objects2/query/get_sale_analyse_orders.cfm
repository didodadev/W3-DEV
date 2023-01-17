<cfif isdate(attributes.date1)>
	<cf_date tarih = "attributes.date1">
</cfif>
<cfif isdate(attributes.date2)>
	<cf_date tarih = "attributes.date2">
</cfif>	
<cfquery name="GET_COMP_PERIOD" datasource="#dsn#">
	SELECT PERIOD_YEAR,PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
</cfquery>
<cfset krmsl_uye = ''>
<cfset brysl_uye = ''>
<cfquery name="T1" datasource="#dsn3#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
	<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
		<cfif attributes.is_kdv eq 0>
			ORD_R.QUANTITY*ORD_R.PRICE  GROSSTOTAL,
			ORD_R.QUANTITY*ORD_R.PRICE / OM.RATE2  GROSSTOTAL_DOVIZ,
			(1- O.SA_DISCOUNT/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT)) * ORD_R.NETTOTAL  AS PRICE,
			( (1- O.SA_DISCOUNT/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT)) * ORD_R.NETTOTAL ) / OM.RATE2 AS PRICE_DOVIZ,
		<cfelse>
			ORD_R.QUANTITY*ORD_R.PRICE*(100+ORD_R.TAX)/100 GROSSTOTAL,
			ORD_R.QUANTITY*ORD_R.PRICE*(100+ORD_R.TAX)/100 / OM.RATE2 GROSSTOTAL_DOVIZ,
			(1- (O.SA_DISCOUNT)/((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT)) * (ORD_R.NETTOTAL) + (((((1- (O.SA_DISCOUNT)/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT))*( ORD_R.NETTOTAL)*ORD_R.TAX)/100))) AS PRICE,
		    ((1- (O.SA_DISCOUNT)/((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT)) * (ORD_R.NETTOTAL) + (((((1- (O.SA_DISCOUNT)/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT))*( ORD_R.NETTOTAL)*ORD_R.TAX)/100)))) / OM.RATE2 AS PRICE_DOVIZ,
		</cfif>
		<cfif attributes.is_other_money eq 1>
			ORD_R.OTHER_MONEY,
		</cfif>
	<cfelse>
		<cfif attributes.is_kdv eq 0>
			ORD_R.QUANTITY*ORD_R.PRICE GROSSTOTAL,
			(1- O.SA_DISCOUNT/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT)) * ORD_R.NETTOTAL AS PRICE,
		<cfelse>
			ORD_R.QUANTITY*ORD_R.PRICE*(100+ORD_R.TAX)/100 GROSSTOTAL,
			(1- (O.SA_DISCOUNT)/((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT)) * (ORD_R.NETTOTAL) + (((((1- (O.SA_DISCOUNT)/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT))*( ORD_R.NETTOTAL)*ORD_R.TAX)/100))) AS PRICE,
		</cfif>
	</cfif>
		O.CANCEL_DATE,
		O.ORDER_STATUS,
		O.ORDER_DATE,
	<cfif attributes.report_type eq 1>
		PC.PRODUCT_CAT,
		PC.HIERARCHY,
		PC.PRODUCT_CATID
	<cfelseif attributes.report_type eq 2>
		PC.PRODUCT_CAT,
		PC.HIERARCHY,
		PC.PRODUCT_CATID,
		S.PRODUCT_ID,
		P.PRODUCT_NAME,
		P.PRODUCT_CODE,
		P.BARCOD,
		ORD_R.QUANTITY AS PRODUCT_STOCK,
		ORD_R.UNIT AS BIRIM
	<cfelseif attributes.report_type eq 3>
		PC.PRODUCT_CAT,
		PC.HIERARCHY,
		PC.PRODUCT_CATID,
		P.PRODUCT_NAME,
		P.PRODUCT_CODE,
		S.PRODUCT_ID,
		S.PROPERTY,
		S.BARCOD,
		S.STOCK_ID,
		ORD_R.QUANTITY AS PRODUCT_STOCK,
		ORD_R.UNIT AS BIRIM
	<cfelseif attributes.report_type eq 9>
		PB.BRAND_NAME,
		P.BRAND_ID,
		ORD_R.QUANTITY AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 17>
		CAST(O.ORDER_DETAIL AS VARCHAR(200)) AS ORDER_DETAIL,
		ORD_R.ORDER_ROW_CURRENCY,
		O.ORDER_NUMBER,
		O.ORDER_ID,
		O.IS_INSTALMENT,
		C.NICKNAME AS MUSTERI,
		C.COMPANY_ID,
		O.ORDER_DATE,
		PC.PRODUCT_CAT,
		PC.HIERARCHY,
		PC.PRODUCT_CATID,
		S.PRODUCT_ID,
		S.STOCK_ID,
		P.PRODUCT_NAME,
		P.PRODUCT_CODE,
		P.MANUFACT_CODE,
		ORD_R.QUANTITY AS PRODUCT_STOCK,
		ORD_R.UNIT AS BIRIM
	</cfif>
	FROM
		ORDERS O,
		ORDER_ROW ORD_R,
	<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
		ORDER_MONEY OM,
	</cfif>
		STOCKS S,
	<cfif listfind('1,2,3',attributes.report_type)>
		PRODUCT_CAT PC,
	<cfelseif attributes.report_type eq 9>
		PRODUCT_BRANDS PB,
	<cfelseif attributes.report_type eq 17>
		#dsn_alias#.COMPANY C,
		PRODUCT_CAT PC,
	</cfif>
		PRODUCT P
	WHERE
		P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
		(
			(	O.PURCHASE_SALES = 1 AND
				O.ORDER_ZONE = 0
			 )  
			OR
			(	O.PURCHASE_SALES = 0 AND
				O.ORDER_ZONE = 1
			)
		)
		AND
			O.NETTOTAL > 0 AND		
		<!--- Faturalanmis - faturalanmamis hareketleri filtreler FBS 20080508 --->
		<cfif isdefined("attributes.fatura_kontrol") and attributes.fatura_kontrol eq 1>
			( 
				(
					ORDER_ID IN (
					<cfset count=0>
					<cfloop query="GET_COMP_PERIOD">
						<cfset count=count+1>
						SELECT 
							OS.ORDER_ID 
						FROM 
							ORDERS_INVOICE OS
						WHERE 
							OS.ORDER_ID=ORDERS.ORDER_ID
							AND OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_comp_period.period_id#">
						<cfif count lt GET_COMP_PERIOD.RECORDCOUNT>UNION ALL</cfif>
					</cfloop>
						)
				)
			AND
				(
					ORDER_ID IN (
					<cfset count=0>
					<cfloop query="GET_COMP_PERIOD">
						<cfset count=count+1>
						SELECT 
							OS.ORDER_ID 
						FROM 
							ORDERS_SHIP OS,
							<cfif database_type is 'MSSQL'>
								#dsn#_#GET_COMP_PERIOD.PERIOD_YEAR#_#session.pp.company_id#.INVOICE_SHIPS AS I_S 
							<cfelse>
								#dsn#_#Right(GET_COMP_PERIOD.PERIOD_YEAR,2)#_#session.pp.company_id#.INVOICE_SHIPS AS I_S 
							</cfif>
						WHERE 
							OS.ORDER_ID = ORDERS.ORDER_ID
							AND OS.SHIP_ID = I_S.SHIP_ID 
							AND OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_comp_period.period_id#">
						<cfif count lt GET_COMP_PERIOD.RECORDCOUNT>UNION ALL</cfif>
					</cfloop>
						)	
				)
			) AND	
		<cfelseif isdefined("attributes.fatura_kontrol") and attributes.fatura_kontrol eq 0>
			( 
				(
					O.ORDER_ID NOT IN (
					<cfset count=0>
					<cfloop query="GET_COMP_PERIOD">
						<cfset count=count+1>
						SELECT 
							OS.ORDER_ID 
						FROM 
							ORDERS_INVOICE OS
						WHERE 
							OS.ORDER_ID=O.ORDER_ID
							AND OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_comp_period.period_id#">
						<cfif count lt GET_COMP_PERIOD.RECORDCOUNT>UNION ALL</cfif>
					</cfloop>
						)
				)
			AND
				(
					O.ORDER_ID NOT IN (
					<cfset count=0>
					<cfloop query="GET_COMP_PERIOD">
						<cfset count=count+1>
						SELECT 
							OS.ORDER_ID 
						FROM 
							ORDERS_SHIP OS,
							<cfif database_type is 'MSSQL'>
								#dsn#_#GET_COMP_PERIOD.PERIOD_YEAR#_#session.pp.company_id#.INVOICE_SHIPS AS I_S 
							<cfelse>
								#dsn#_#Right(GET_COMP_PERIOD.PERIOD_YEAR,2)#_#session.pp.company_id#.INVOICE_SHIPS AS I_S 
							</cfif>
						WHERE 
							OS.ORDER_ID = O.ORDER_ID
							AND OS.SHIP_ID = I_S.SHIP_ID 
							AND OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_comp_period.period_id#">
						<cfif count lt GET_COMP_PERIOD.RECORDCOUNT>UNION ALL</cfif>
					</cfloop>
						)	
				)
			) AND		
		</cfif>
		<cfif attributes.is_prom eq 0>
			ORD_R.IS_PROMOTION <> 1 AND
		</cfif>
		<cfif attributes.is_other_money eq 1>
			OM.ACTION_ID = O.ORDER_ID AND
			OM.MONEY_TYPE = ORD_R.OTHER_MONEY AND
		<cfelseif attributes.is_money2 eq 1>
			OM.ACTION_ID = O.ORDER_ID AND
			OM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.money2#"> AND
		</cfif>
		O.ORDER_ID = ORD_R.ORDER_ID AND
		<cfif listfind('1,2,3',attributes.report_type)>
			PC.PRODUCT_CATID = P.PRODUCT_CATID AND
		<cfelseif attributes.report_type eq 9>
			P.BRAND_ID = PB.BRAND_ID AND
		<cfelseif attributes.report_type eq 17>
			PC.PRODUCT_CATID = P.PRODUCT_CATID AND
			O.COMPANY_ID = C.COMPANY_ID AND
		</cfif>
			S.PRODUCT_ID = P.PRODUCT_ID AND
			ORD_R.STOCK_ID = S.STOCK_ID
		<cfif isdefined("krmsl_uye") and listlen(krmsl_uye)>
			AND O.COMPANY_ID IN
				(
				SELECT 
					C.COMPANY_ID 
				FROM 
					#dsn_alias#.COMPANY C,
					#dsn_alias#.COMPANY_CAT CAT 
				WHERE 
					C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND 
					(
					  <cfloop list="#krmsl_uye#" delimiters="," index="comp_i">
						  (CAT.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(comp_i,'-')#">)
						  <cfif comp_i neq listlast(krmsl_uye,',') and listlen(krmsl_uye,',') gte 1> OR</cfif>
					  </cfloop>  
					)
				)
		</cfif>
		<cfif isDefined("attributes.status") and len(attributes.status)>
			AND O.ORDER_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.status#">
		</cfif>
</cfquery>
<cfif listfind('17',attributes.report_type)>
	<cfquery name="T2" datasource="#dsn3#" cachedwithin="#fusebox.general_cached_time#">
		SELECT
		<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
			<cfif attributes.is_kdv eq 0>
				ORD_R.QUANTITY*ORD_R.PRICE  GROSSTOTAL,
				ORD_R.QUANTITY*ORD_R.PRICE / OM.RATE2  GROSSTOTAL_DOVIZ,
				(1- O.SA_DISCOUNT/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT)) * ORD_R.NETTOTAL AS PRICE,
				((1- O.SA_DISCOUNT/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT)) * ORD_R.NETTOTAL ) / OM.RATE2 AS PRICE_DOVIZ,
			<cfelse>
				ORD_R.QUANTITY*ORD_R.PRICE*(100+ORD_R.TAX)/100 GROSSTOTAL,
				ORD_R.QUANTITY*ORD_R.PRICE*(100+ORD_R.TAX)/100 / OM.RATE2 GROSSTOTAL_DOVIZ,
				(1- (O.SA_DISCOUNT)/((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT)) * (ORD_R.NETTOTAL) + (((((1- (O.SA_DISCOUNT)/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT))*( ORD_R.NETTOTAL)*ORD_R.TAX)/100))) AS PRICE,
				((1- (O.SA_DISCOUNT)/((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT)) * (ORD_R.NETTOTAL) + (((((1- (O.SA_DISCOUNT)/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT))*( ORD_R.NETTOTAL)*ORD_R.TAX)/100)))) / OM.RATE2 AS PRICE_DOVIZ,
			</cfif>
			<cfif attributes.is_other_money eq 1>
				ORD_R.OTHER_MONEY,
			</cfif>
		<cfelse>
			<cfif attributes.is_kdv eq 0>
				ORD_R.QUANTITY*ORD_R.PRICE GROSSTOTAL,
				(1- O.SA_DISCOUNT/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT)) * ORD_R.NETTOTAL AS PRICE,
			<cfelse>
				ORD_R.QUANTITY*ORD_R.PRICE*(100+ORD_R.TAX)/100 GROSSTOTAL,
				(1- (O.SA_DISCOUNT)/((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT)) * (ORD_R.NETTOTAL) + (((((1- (O.SA_DISCOUNT)/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT))*( ORD_R.NETTOTAL)*ORD_R.TAX)/100))) AS PRICE,
			</cfif>
		</cfif>
		O.CANCEL_DATE,
		O.ORDER_STATUS,
		O.ORDER_DATE,
		<cfif attributes.report_type eq 1>
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID
		<cfelseif attributes.report_type eq 2>
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID,
			S.PRODUCT_ID,
			P.PRODUCT_NAME,
			P.PRODUCT_CODE,
			P.BARCOD,
			ORD_R.QUANTITY AS PRODUCT_STOCK,
			ORD_R.UNIT AS BIRIM
		<cfelseif attributes.report_type eq 3>
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID,
			P.PRODUCT_NAME,
			P.PRODUCT_CODE,
			S.PRODUCT_ID,
			S.PROPERTY,
			S.BARCOD,
			S.STOCK_ID,
			ORD_R.QUANTITY AS PRODUCT_STOCK,
			ORD_R.UNIT AS BIRIM
		<cfelseif attributes.report_type eq 9>
			PB.BRAND_NAME,
			P.BRAND_ID,
			ORD_R.QUANTITY AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 17>
			CAST(O.ORDER_DETAIL AS VARCHAR(200)) AS ORDER_DETAIL,
			ORD_R.ORDER_ROW_CURRENCY,
			O.ORDER_NUMBER,
			O.ORDER_ID,
			O.IS_INSTALMENT,
			C.CONSUMER_NAME+' ' +C.CONSUMER_SURNAME AS MUSTERI,
			C.CONSUMER_ID,
			O.ORDER_DATE,
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID,
			S.PRODUCT_ID,
			S.STOCK_ID,
			P.PRODUCT_NAME,
			P.PRODUCT_CODE,
			P.MANUFACT_CODE,
			ORD_R.QUANTITY AS PRODUCT_STOCK,
			ORD_R.UNIT AS BIRIM
		</cfif>
		FROM
			ORDERS O,
			ORDER_ROW ORD_R,
		<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
			ORDER_MONEY OM,
		</cfif>
			STOCKS S,
		<cfif listfind('1,2,3',attributes.report_type)>
			PRODUCT_CAT PC,
		<cfelseif attributes.report_type eq 9>
			PRODUCT_BRANDS PB,
		<cfelseif attributes.report_type eq 17>
			#dsn_alias#.CONSUMER C,
			PRODUCT_CAT PC,
		</cfif>
			PRODUCT P
		WHERE
			P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
			(
				(	
					O.PURCHASE_SALES = 1 AND
					O.ORDER_ZONE = 0
				)  
				OR
				(	O.PURCHASE_SALES = 0 AND
					O.ORDER_ZONE = 1
				)
			)
			AND
				O.NETTOTAL > 0 AND
			<cfif attributes.is_prom eq 0>
				ORD_R.IS_PROMOTION <> 1 AND
			</cfif>
			<cfif attributes.is_other_money eq 1>
				OM.ACTION_ID = O.ORDER_ID AND
				OM.MONEY_TYPE = ORD_R.OTHER_MONEY AND
			<cfelseif attributes.is_money2 eq 1>
				OM.ACTION_ID = O.ORDER_ID AND
				OM.MONEY_TYPE = '#session.pp.money2#' AND
			</cfif>
			<cfif listfind('1,2,3',attributes.report_type)>
				PC.PRODUCT_CATID = P.PRODUCT_CATID AND
			<cfelseif attributes.report_type eq 9>
				P.BRAND_ID = PB.BRAND_ID AND
			<cfelseif attributes.report_type eq 17>
				PC.PRODUCT_CATID = P.PRODUCT_CATID AND
				O.CONSUMER_ID = C.CONSUMER_ID AND
			</cfif>	
			S.PRODUCT_ID = P.PRODUCT_ID AND
			ORD_R.STOCK_ID = S.STOCK_ID	AND
			O.ORDER_ID = ORD_R.ORDER_ID
			<cfif isdefined("brysl_uye") and listlen(brysl_uye)>
				AND O.CONSUMER_ID IN
					(
					SELECT 
						C.CONSUMER_ID 
					FROM 
						#dsn_alias#.CONSUMER C,
						#dsn_alias#.CONSUMER_CAT CAT 
					WHERE 
						C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
						(
							<cfloop list="#brysl_uye#" delimiters="," index="cons_j">
								(CAT.CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(cons_j,'-')#">)
								<cfif cons_j neq listlast(brysl_uye,',') and listlen(brysl_uye,',') gte 1> OR</cfif>
							</cfloop>  
						) 
					)
			</cfif>
			<cfif isDefined("attributes.status") and len(attributes.status)>
				AND O.ORDER_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.status#">
			</cfif>
	</cfquery>
</cfif>
<!--- Burdan sonra queryleri birleştirm vs yapılıyor --->
<cfquery name="get_total_purchase_1" dbtype="query">
	SELECT
	<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
		<cfif attributes.is_kdv eq 0>
			SUM(GROSSTOTAL) GROSSTOTAL,
			SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
			SUM(PRICE) AS PRICE,
			SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
		<cfelse>
			SUM(GROSSTOTAL) GROSSTOTAL,
			SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
			SUM(PRICE) AS PRICE,
			SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
		</cfif>
		<cfif attributes.is_other_money eq 1>
			OTHER_MONEY,
		</cfif>
	<cfelse>
		<cfif attributes.is_kdv eq 0>
			SUM(GROSSTOTAL) GROSSTOTAL,
			SUM(PRICE) AS PRICE,
		<cfelse>
			SUM(GROSSTOTAL) GROSSTOTAL,
			SUM(PRICE) AS PRICE,
		</cfif>
	</cfif>
	<cfif attributes.report_type eq 1>
		PRODUCT_CAT,
		HIERARCHY,
		PRODUCT_CATID
	<cfelseif attributes.report_type eq 2>
		PRODUCT_CAT,
		HIERARCHY,
		PRODUCT_CATID,
		PRODUCT_ID,
		PRODUCT_NAME,
		PRODUCT_CODE,
		BARCOD,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
		BIRIM
	<cfelseif attributes.report_type eq 3>
		PRODUCT_CAT,
		HIERARCHY,
		PRODUCT_CATID,
		PRODUCT_NAME,
		PRODUCT_CODE,
		PRODUCT_ID,
		PROPERTY,
		BARCOD,
		STOCK_ID,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
		BIRIM
	<cfelseif attributes.report_type eq 9>
		BRAND_NAME,
		BRAND_ID,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 17>
		ORDER_DETAIL,
		ORDER_ROW_CURRENCY,
		ORDER_NUMBER,
		ORDER_ID,
		IS_INSTALMENT,
		MUSTERI,
		COMPANY_ID,
		ORDER_DATE,
		PRODUCT_CAT,
		HIERARCHY,
		PRODUCT_CATID,
		PRODUCT_ID,
		STOCK_ID,
		PRODUCT_NAME,
		PRODUCT_CODE,
		MANUFACT_CODE,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
		BIRIM
	</cfif>
	FROM
		T1
	WHERE
		ORDER_DATE BETWEEN #attributes.date1# AND #attributes.date2#
	GROUP BY
		<cfif attributes.is_other_money eq 1>
			OTHER_MONEY,
		</cfif>	
		<cfif attributes.report_type eq 1 >
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID
		<cfelseif attributes.report_type eq 2 >
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			BARCOD,
			BIRIM
		<cfelseif attributes.report_type eq 3 >
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			PRODUCT_ID,
			PROPERTY,
			BARCOD,
			STOCK_ID,
			BIRIM
		<cfelseif attributes.report_type eq 9 >
			BRAND_NAME,
			BRAND_ID
		<cfelseif attributes.report_type eq 17>
			ORDER_DETAIL,
			ORDER_ROW_CURRENCY,
			ORDER_NUMBER,
			ORDER_ID,
			IS_INSTALMENT,
			MUSTERI,
			COMPANY_ID,
			ORDER_DATE,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			MANUFACT_CODE,
			BIRIM
		</cfif>
	<cfif (not len(attributes.status)) and attributes.is_iptal eq 1>
		UNION ALL
		SELECT
		<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
			<cfif attributes.is_kdv eq 0>
				SUM(-1*GROSSTOTAL) GROSSTOTAL,
				SUM(-1*GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
				SUM(-1*PRICE) AS PRICE,
				SUM(-1*PRICE_DOVIZ) AS PRICE_DOVIZ,
			<cfelse>
				SUM(-1*GROSSTOTAL) GROSSTOTAL,
				SUM(-1*GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
				SUM(-1*PRICE) AS PRICE,
				SUM(-1*PRICE_DOVIZ) AS PRICE_DOVIZ,
			</cfif>
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
		<cfelse>
			<cfif attributes.is_kdv eq 0>
				SUM(-1*GROSSTOTAL) GROSSTOTAL,
				SUM(-1*PRICE) AS PRICE,
			<cfelse>
				SUM(-1*GROSSTOTAL) GROSSTOTAL,
				SUM(-1*PRICE) AS PRICE,
			</cfif>
		</cfif>
		<cfif attributes.report_type eq 1>
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID
		<cfelseif attributes.report_type eq 2>
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			BARCOD,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK,
			BIRIM
		<cfelseif attributes.report_type eq 3>
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			PRODUCT_ID,
			PROPERTY,
			BARCOD,
			STOCK_ID,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK,
			BIRIM
		<cfelseif attributes.report_type eq 9>
			BRAND_NAME,
			BRAND_ID,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 17>
			ORDER_DETAIL,
			ORDER_ROW_CURRENCY,
			ORDER_NUMBER,
			ORDER_ID,
			IS_INSTALMENT,
			MUSTERI,
			COMPANY_ID,
			ORDER_DATE,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			MANUFACT_CODE,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK,
			BIRIM
		</cfif>
		FROM
			T1
		WHERE
			ORDER_STATUS = 0
			AND CANCEL_DATE BETWEEN #attributes.date1# AND #attributes.date2#
		GROUP BY
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>	
			<cfif attributes.report_type eq 1 >
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID
			<cfelseif attributes.report_type eq 2 >
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_ID,
				PRODUCT_NAME,
				PRODUCT_CODE,
				BARCOD,
				BIRIM
			<cfelseif attributes.report_type eq 3 >
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_NAME,
				PRODUCT_CODE,
				PRODUCT_ID,
				PROPERTY,
				BARCOD,
				STOCK_ID,
				BIRIM
			<cfelseif attributes.report_type eq 9 >
				BRAND_NAME,
				BRAND_ID
			<cfelseif attributes.report_type eq 17>
				ORDER_DETAIL,
				ORDER_ROW_CURRENCY,
				ORDER_NUMBER,
				ORDER_ID,
				IS_INSTALMENT,
				MUSTERI,
				COMPANY_ID,
				ORDER_DATE,
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_ID,
				STOCK_ID,
				PRODUCT_NAME,
				PRODUCT_CODE,
				MANUFACT_CODE,
				BIRIM
			</cfif>	
	</cfif>
	<cfif listfind('4,16,17',attributes.report_type)>
		UNION ALL
			SELECT
			<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
				<cfif attributes.is_kdv eq 0>
					SUM(GROSSTOTAL) GROSSTOTAL,
					SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
					SUM(PRICE) AS PRICE,
					SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
				<cfelse>
					SUM(GROSSTOTAL) GROSSTOTAL,
					SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
					SUM(PRICE) AS PRICE,
					SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
				</cfif>
				<cfif attributes.is_other_money eq 1>
					OTHER_MONEY,
				</cfif>
			<cfelse>
				<cfif attributes.is_kdv eq 0>
					SUM(GROSSTOTAL) GROSSTOTAL,
					SUM(PRICE) AS PRICE,
				<cfelse>
					SUM(GROSSTOTAL) GROSSTOTAL,
					SUM(PRICE) AS PRICE,
				</cfif>
			</cfif>
			<cfif attributes.report_type eq 1>
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID
			<cfelseif attributes.report_type eq 2>
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_ID,
				PRODUCT_NAME,
				PRODUCT_CODE,
				BARCOD,
				SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
				BIRIM
			<cfelseif attributes.report_type eq 3>
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_NAME,
				PRODUCT_CODE,
				PRODUCT_ID,
				PROPERTY,
				BARCOD,
				STOCK_ID,
				SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
				BIRIM
			<cfelseif attributes.report_type eq 9>
				BRAND_NAME,
				BRAND_ID,
				SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 17>
				ORDER_DETAIL,
				ORDER_ROW_CURRENCY,
				ORDER_NUMBER,
				ORDER_ID,
				IS_INSTALMENT,
				MUSTERI,
				CONSUMER_ID,
				ORDER_DATE,
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_ID,
				STOCK_ID,
				PRODUCT_NAME,
				PRODUCT_CODE,
				MANUFACT_CODE,
				SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
				BIRIM
			</cfif>
		FROM
			T2
		WHERE
			ORDER_DATE BETWEEN #attributes.date1# AND #attributes.date2#
		GROUP BY
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>	
			<cfif attributes.report_type eq 1 >
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID
			<cfelseif attributes.report_type eq 2 >
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_ID,
				PRODUCT_NAME,
				PRODUCT_CODE,
				BARCOD,
				BIRIM,
				UNIT
			<cfelseif attributes.report_type eq 3 >
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_NAME,
				PRODUCT_CODE,
				PRODUCT_ID,
				PROPERTY,
				BARCOD,
				STOCK_ID,
				BIRIM,
				UNIT
			<cfelseif attributes.report_type eq 9 >
				BRAND_NAME,
				BRAND_ID
			<cfelseif attributes.report_type eq 17>
				ORDER_DETAIL,
				ORDER_ROW_CURRENCY,
				ORDER_NUMBER,
				ORDER_ID,
				IS_INSTALMENT,
				MUSTERI,
				CONSUMER_ID,
				ORDER_DATE,
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_ID,
				STOCK_ID,
				PRODUCT_NAME,
				PRODUCT_CODE,
				MANUFACT_CODE,
				BIRIM
			</cfif>
		<cfif (not len(attributes.status)) and attributes.is_iptal eq 1>
			UNION ALL
			SELECT
			<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
				<cfif attributes.is_kdv eq 0>
					SUM(-1*GROSSTOTAL) GROSSTOTAL,
					SUM(-1*GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
					SUM(-1*PRICE) AS PRICE,
					SUM(-1*PRICE_DOVIZ) AS PRICE_DOVIZ,
				<cfelse>
					SUM(-1*GROSSTOTAL) GROSSTOTAL,
					SUM(-1*GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
					SUM(-1*PRICE) AS PRICE,
					SUM(-1*PRICE_DOVIZ) AS PRICE_DOVIZ,
				</cfif>
				<cfif attributes.is_other_money eq 1>
					OTHER_MONEY,
				</cfif>
			<cfelse>
				<cfif attributes.is_kdv eq 0>
					SUM(-1*GROSSTOTAL) GROSSTOTAL,
					SUM(-1*PRICE) AS PRICE,
				<cfelse>
					SUM(-1*GROSSTOTAL) GROSSTOTAL,
					SUM(-1*PRICE) AS PRICE,
				</cfif>
			</cfif>
			<cfif attributes.report_type eq 1>
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID
			<cfelseif attributes.report_type eq 2>
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_ID,
				PRODUCT_NAME,
				PRODUCT_CODE,
				BARCOD,
				SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK,
				BIRIM
			<cfelseif attributes.report_type eq 3>
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_NAME,
				PRODUCT_CODE,
				PRODUCT_ID,
				PROPERTY,
				BARCOD,
				STOCK_ID,
				SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK,
				BIRIM
			<cfelseif attributes.report_type eq 9>
				BRAND_NAME,
				BRAND_ID,
				SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 17>
				ORDER_DETAIL,
				ORDER_ROW_CURRENCY,
				ORDER_NUMBER,
				ORDER_ID,
				IS_INSTALMENT,
				MUSTERI,
				CONSUMER_ID,
				ORDER_DATE,
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_ID,
				STOCK_ID,
				PRODUCT_NAME,
				PRODUCT_CODE,
				MANUFACT_CODE,
				SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK,
				BIRIM
			</cfif>
		FROM
			T2
		WHERE
			ORDER_STATUS = 0
			AND CANCEL_DATE BETWEEN #attributes.date1# AND #attributes.date2#
		GROUP BY
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>	
			<cfif attributes.report_type eq 1 >
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID
			<cfelseif attributes.report_type eq 2 >
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_ID,
				PRODUCT_NAME,
				PRODUCT_CODE,
				BARCOD,
				BIRIM,
				UNIT
			<cfelseif attributes.report_type eq 3 >
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_NAME,
				PRODUCT_CODE,
				PRODUCT_ID,
				PROPERTY,
				BARCOD,
				STOCK_ID,
				BIRIM,
				UNIT
			<cfelseif attributes.report_type eq 9 >
				BRAND_NAME,
				BRAND_ID
			<cfelseif attributes.report_type eq 17>
				ORDER_DETAIL,
				ORDER_ROW_CURRENCY,
				ORDER_NUMBER,
				ORDER_ID,
				IS_INSTALMENT,
				MUSTERI,
				CONSUMER_ID,
				ORDER_DATE,
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_ID,
				STOCK_ID,
				PRODUCT_NAME,
				PRODUCT_CODE,
				MANUFACT_CODE,
				BIRIM
			</cfif>
		</cfif>
	</cfif>
</cfquery>
<cfif isdefined("get_total_purchase_1")>
	<cfquery name="get_total_purchase_3"  dbtype="query" >
		SELECT * FROM get_total_purchase_1
	</cfquery>
<cfelse>
	<cfset get_total_purchase_3.recordcount=0>
</cfif>
<cfif get_total_purchase_3.recordcount>
	<cfquery name="get_total_purchase" dbtype="query">
		SELECT 
			SUM(GROSSTOTAL) GROSSTOTAL,
			SUM(PRICE) AS PRICE,
		<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
			SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
			SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
		</cfif>
		<cfif attributes.report_type eq 1>
			PRODUCT_CAT,
			HIERARCHY
		<cfelseif attributes.report_type eq 2>
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_ID,
			PRODUCT_NAME,
			BARCOD,
			PRODUCT_CODE,
			BIRIM,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 3>
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_ID,
			PRODUCT_NAME,
			PROPERTY,
			BARCOD,
			PRODUCT_CODE,
			STOCK_ID,
			BIRIM,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 9 >
			BRAND_NAME,
			BRAND_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 17>
			ORDER_DETAIL,
			ORDER_ROW_CURRENCY,
			ORDER_NUMBER,
			ORDER_ID,
			IS_INSTALMENT,
			MUSTERI,
			COMPANY_ID,
			ORDER_DATE,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			MANUFACT_CODE,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		</cfif>
		FROM 
			get_total_purchase_3
		GROUP BY
		<cfif attributes.is_other_money eq 1>
			OTHER_MONEY,
		</cfif>
		<cfif attributes.report_type eq 1>
			PRODUCT_CAT,
			HIERARCHY
		<cfelseif attributes.report_type eq 2>
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			BARCOD,
			BIRIM
		<cfelseif attributes.report_type eq 3>
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			PROPERTY,
			STOCK_ID,
			BARCOD,
			BIRIM
		<cfelseif attributes.report_type eq 9 >
			BRAND_NAME,
			BRAND_ID
		<cfelseif attributes.report_type eq 17>
			ORDER_DETAIL,
			ORDER_ROW_CURRENCY,
			ORDER_NUMBER,
			ORDER_ID,
			IS_INSTALMENT,
			MUSTERI,
			COMPANY_ID,
			ORDER_DATE,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			MANUFACT_CODE,
			BIRIM
		</cfif>
		<cfif attributes.kontrol eq 1>
			ORDER BY ORDER_NUMBER
		<cfelseif attributes.report_sort eq 1>
			ORDER BY  PRICE DESC
		<cfelseif attributes.report_type neq 1>
			ORDER BY PRODUCT_STOCK DESC
		</cfif>
	</cfquery>
	<cfquery name="get_all_total" dbtype="query">
		SELECT SUM(PRICE) AS PRICE FROM get_total_purchase
	</cfquery>
	<cfif len(get_all_total.PRICE) >
		<cfset butun_toplam = get_all_total.PRICE >
	<cfelse>
		<cfset butun_toplam = 1 >
	</cfif>
<cfelse>
	<cfset get_total_purchase.recordcount=0>
	<cfset butun_toplam = 1 >
</cfif>

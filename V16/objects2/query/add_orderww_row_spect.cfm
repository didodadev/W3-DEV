<cfif IsStruct(session.basketww[i][19]) and isdefined('spect_id') and len(evaluate('spect_id'))>
<!--- spect varsa sessiondan alıp degerleri kaydediyor--->
<cfloop from="1" to="#StructCount(session.basketww[i][19].spect_row)#" index="s">	
	<cfquery name="ADD_ROW" datasource="#dsn3#">
		INSERT
		INTO
			ORDER_ROW_SPECT
			(
				SPECT_ID,
				ORDER_ID,
				ORDER_ROW_ID,
				PRODUCT_ID,
				STOCK_ID,
				AMOUNT_VALUE,
				TOTAL_VALUE,
				MONEY_CURRENCY,
				PRODUCT_NAME,
				IS_PROPERTY,
				IS_CONFIGURE,
				DIFF_PRICE,
				PRODUCT_COST,
				PRODUCT_COST_MONEY,
				PRODUCT_COST_ID,
				IS_SEVK,
				PROPERTY_ID,
				VARIATION_ID
			)
			VALUES
			(
				#spect_id#,
				#GET_MAX_ORDER.MAX_ID#,
				#GET_MAX_ORDER_ROW.ORDER_ROW_ID#,
				<cfif len(session.basketww[i][19].spect_row[s][1])>#session.basketww[i][19].spect_row[s][1]#<cfelse>NULL</cfif>,
				<cfif len(session.basketww[i][19].spect_row[s][2])>#session.basketww[i][19].spect_row[s][2]#<cfelse>NULL</cfif>,
				<cfif len(session.basketww[i][19].spect_row[s][4])>#session.basketww[i][19].spect_row[s][4]#<cfelse>0</cfif>,
				<cfif len(session.basketww[i][19].spect_row[s][5])>#session.basketww[i][19].spect_row[s][5]#<cfelse>0</cfif>,
				'#session.basketww[i][19].spect_row[s][6]#',
				<cfif len(session.basketww[i][19].spect_row[s][3])>'#session.basketww[i][19].spect_row[s][3]#'<cfelse>NULL</cfif>,
				<cfif session.basketww[i][19].spect_row[s][9] eq 1>1<cfelse>0</cfif>,
				<cfif session.basketww[i][19].spect_row[s][7] eq 1>1<cfelse>0</cfif>,
				<cfif len(session.basketww[i][19].spect_row[s][8])>#session.basketww[i][19].spect_row[s][8]#<cfelse>0</cfif>,
				#session.basketww[i][19].spect_row[s][13]#,
				<cfif len(session.basketww[i][19].spect_row[s][14])>'#session.basketww[i][19].spect_row[s][14]#'<cfelse>NULL</cfif>,
				<cfif len(session.basketww[i][19].spect_row[s][15])>#session.basketww[i][19].spect_row[s][15]#<cfelse>NULL</cfif>,
				<cfif session.basketww[i][19].spect_row[s][10] eq 1>#session.basketww[i][19].spect_row[s][10]#<cfelse>0</cfif>,
				<cfif len(session.basketww[i][19].spect_row[s][11])>#session.basketww[i][19].spect_row[s][11]#<cfelse>NULL</cfif>,
				<cfif len(session.basketww[i][19].spect_row[s][12])>#session.basketww[i][19].spect_row[s][12]#<cfelse>NULL</cfif>
			)
	</cfquery>
</cfloop>
<cfelse>
<!--- spect yok ancak ürün agaci var --->
	<cfquery name="GET_SPECT_ROW" datasource="#dsn3#">
		SELECT 
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.PRODUCT_NAME,
			STOCKS.PROPERTY,
			PRODUCT_TREE.IS_CONFIGURE,
			PRODUCT_TREE.IS_SEVK,
			PRODUCT_TREE.AMOUNT AMOUNT_VALUE,
			0 IS_PROPERTY
		FROM
			STOCKS,
			PRODUCT_TREE,
			PRODUCT_UNIT
		WHERE
			PRODUCT_UNIT.PRODUCT_UNIT_ID = PRODUCT_TREE.UNIT_ID AND
			PRODUCT_TREE.RELATED_ID = STOCKS.STOCK_ID AND
			PRODUCT_TREE.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.basketww[i][8]#">
	</cfquery>
	<cfif isdefined('GET_SPECT_ROW') and GET_SPECT_ROW.RECORDCOUNT>
		<cfif MEMBER_TYPE eq 'PARTNER' and isdefined("attributes.company_id") and len(attributes.company_id)>
			<cfquery name="GET_PRICE_CAT_CREDIT" datasource="#dsn3#">
				SELECT
					PRICE_CAT
				FROM
					#dsn_alias#.COMPANY_CREDIT
				WHERE
					COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
					OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
			</cfquery>
			<cfif GET_PRICE_CAT_CREDIT.RECORDCOUNT and len(GET_PRICE_CAT_CREDIT.PRICE_CAT)>
				<cfset attributes.price_catid=GET_PRICE_CAT_CREDIT.PRICE_CAT>
			<cfelse>
				<cfquery name="GET_COMP_CAT" datasource="#dsn3#">
					SELECT COMPANYCAT_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfquery>
				<cfquery name="GET_PRICE_CAT_COMP" datasource="#dsn3#">
					SELECT 
						PRICE_CATID
					FROM
						PRICE_CAT
					WHERE
						COMPANY_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.companycat_id#,%">
				</cfquery>
				<cfset attributes.price_catid=GET_PRICE_CAT_COMP.PRICE_CATID>
			</cfif>
		<cfelseif MEMBER_TYPE eq 'CONSUMER' and isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			<cfquery name="GET_COMP_CAT" datasource="#DSN3#">
				SELECT CONSUMER_CAT_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			</cfquery>
			<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
				SELECT PRICE_CATID FROM PRICE_CAT WHERE CONSUMER_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.consumer_cat_id#,%">
			</cfquery>
			<cfset attributes.price_catid=get_price_cat.PRICE_CATID>
		</cfif>
		
		<cfset product_id_list=valuelist(GET_SPECT_ROW.PRODUCT_ID,',')>
		<cfset product_id_list=ListDeleteDuplicates(product_id_list)>
		<cfif listlen(product_id_list,',')>
			<!--- tum sayfadaki urunler icin fiyatları aliyor sonra query of query ile cekecek--->
			<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
				<cfquery name="GET_PRICE" datasource="#dsn3#">
					SELECT
						PRICE_STANDART.PRODUCT_ID,
						SM.MONEY,
						PRICE_STANDART.PRICE,
						(PRICE_STANDART.PRICE*(SM.RATE2/SM.RATE1)) AS PRICE_STDMONEY,
						(PRICE_STANDART.PRICE_KDV*(SM.RATE2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
						SM.RATE2,
						SM.RATE1
					FROM
						PRICE PRICE_STANDART,	
						PRODUCT_UNIT,
						#dsn_alias#.SETUP_MONEY AS SM
					WHERE
						PRICE_STANDART.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
						PRICE_STANDART.STARTDATE< <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND 
						(PRICE_STANDART.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR PRICE_STANDART.FINISHDATE IS NULL) AND
						PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
						(PRICE_STANDART.STOCK_ID,0)=0 AND 
						(PRICE_STANDART.SPECT_VAR_ID,0)=0 AND 
						PRICE_STANDART.PRODUCT_ID IN (#product_id_list#) AND 
						PRODUCT_UNIT.IS_MAIN = 1 AND
						SM.MONEY = PRICE_STANDART.MONEY AND
						SM.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#">
				</cfquery>
			</cfif>
			<cfquery name="GET_PRICE_STANDART" datasource="#dsn3#">
				SELECT
					PRICE_STANDART.PRODUCT_ID,
					SM.MONEY,
					PRICE_STANDART.PRICE,
					(PRICE_STANDART.PRICE*(SM.RATE2/SM.RATE1)) AS PRICE_STDMONEY,
					(PRICE_STANDART.PRICE_KDV*(SM.RATE2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
					SM.RATE2,
					SM.RATE1,
					PRICE_STANDART.START_DATE
				FROM
					PRODUCT,
					PRICE_STANDART,
					#dsn_alias#.SETUP_MONEY AS SM
				WHERE
					PRODUCT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
					PURCHASESALES = 1 AND
					<!--- PRICESTANDART_STATUS = 1 AND --->
					START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
					SM.MONEY = PRICE_STANDART.MONEY AND
					SM.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#"> AND
					PRODUCT.PRODUCT_ID IN (#product_id_list#)
			</cfquery>
			<!--- //tum sayfadaki urunler icin fiyatları aliyor sonra query of query ile cekecek--->
		</cfif>
		<cfoutput query="GET_SPECT_ROW">
			<cfset satir_maliyet=0>
			<cfset GET_COST.MONEY="">
			<cfset GET_COST.PRODUCT_COST_ID="">
			<cfif listlen(product_id_list,',')>
				<cfif isdefined("GET_PRICE")>
					 <cfquery name="GET_PRICE_MAIN" dbtype="query">
						SELECT
							*
						FROM
							GET_PRICE
						WHERE
							PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
					  </cfquery>
				  </cfif>
				  <cfif not isdefined("GET_PRICE_MAIN") or  GET_PRICE_MAIN.RECORDCOUNT eq 0>
					<cfquery name="GET_PRICE_MAIN" dbtype="query" maxrows="1">
						SELECT
							*
						FROM
							GET_PRICE_STANDART
						WHERE
							PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
						ORDER BY
							START_DATE DESC
					</cfquery>
				  </cfif>
		
				<cfquery name="GET_COST" datasource="#dsn3#" maxrows="1">
					SELECT  
						PRODUCT_COST,
						PRODUCT_COST_ID,
						MONEY
					FROM
						#dsn1_alias#.PRODUCT_COST
					WHERE    
						PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
						START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					ORDER BY
						START_DATE DESC,
						RECORD_DATE DESC
				</cfquery>
				<cfif len(GET_COST.PRODUCT_COST)><cfset satir_maliyet=GET_COST.PRODUCT_COST></cfif>
			</cfif>
		
			<cfquery name="ADD_ROW" datasource="#dsn3#">
				INSERT
				INTO
					ORDER_ROW_SPECT
					(
						SPECT_ID,
						ORDER_ID,
						ORDER_ROW_ID,
						PRODUCT_ID,
						STOCK_ID,
						AMOUNT_VALUE,
						TOTAL_VALUE,
						MONEY_CURRENCY,
						PRODUCT_NAME,
						IS_PROPERTY,
						IS_CONFIGURE,
						DIFF_PRICE,
						PRODUCT_COST,
						PRODUCT_COST_MONEY,
						PRODUCT_COST_ID,
						IS_SEVK
					)
					VALUES
					(
						NULL,
						#GET_MAX_ORDER.MAX_ID#,
						#GET_MAX_ORDER_ROW.ORDER_ROW_ID#,
						<cfif len(PRODUCT_ID)>#PRODUCT_ID#<cfelse>NULL</cfif>,
						<cfif len(STOCK_ID)>#STOCK_ID#<cfelse>NULL</cfif>,
						<cfif len(GET_SPECT_ROW.AMOUNT_VALUE)>#GET_SPECT_ROW.AMOUNT_VALUE#<cfelse>0</cfif>,
						<cfif isdefined("GET_PRICE_MAIN.PRICE") and listlen(product_id_list,',')>
							<cfif len(GET_PRICE_MAIN.PRICE)>#GET_PRICE_MAIN.PRICE#<cfelse>0</cfif>,
							'#GET_PRICE_MAIN.MONEY#',
						<cfelse>
							0,
							#int_money#,
						</cfif>
						<cfif len(GET_SPECT_ROW.PRODUCT_NAME)>'#GET_SPECT_ROW.PRODUCT_NAME#'<cfelse>NULL</cfif>,
						<cfif GET_SPECT_ROW.IS_PROPERTY eq 1>1<cfelse>0</cfif>,
						<cfif GET_SPECT_ROW.IS_CONFIGURE eq 1>1<cfelse>0</cfif>,
						0,
						#satir_maliyet#,
						<cfif len(GET_COST.MONEY)>'#GET_COST.MONEY#'<cfelse>NULL</cfif>,
						<cfif len(GET_COST.PRODUCT_COST_ID)>#GET_COST.PRODUCT_COST_ID#<cfelse>NULL</cfif>,
						<cfif IS_SEVK eq 1>#IS_SEVK#<cfelse>0</cfif>
					)
			</cfquery>
		</cfoutput>
	</cfif>
</cfif>

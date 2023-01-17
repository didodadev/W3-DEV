<!--- Sayfa:harcama kayıtlarını fatura,sipariş,teklif ve ithal mal girişi satırlarına dagıtır. OZDEN20060503 ---> 
<!--- TolgaS 20070126 satırda fiyat 0 sa dağılım yapılmaz ancak 0 degil ve 100 iskonto varsa maliyet üzerinden dağılım yapılır --->
<cfif isdefined("attributes.page_type") and listfind('1,4,5',attributes.page_type,',')>
	<cfif deletedRowCount eq attributes.record_num>
        <cfquery name="GET_COST_TOTAL" datasource="#dsn2#">
            SELECT 0 AS COST_TOTAL, 0 DISTRIBUTE_TYPE
        </cfquery>
    <cfelse>
        <cfquery name="GET_COST_TOTAL" datasource="#dsn2#">
            SELECT 
                SUM(INVOICE_COST) AS COST_TOTAL,
                ISNULL(DISTRIBUTE_TYPE,0) DISTRIBUTE_TYPE
            FROM
                INVOICE_COST
            WHERE
                <cfif attributes.page_type eq 1>
                INVOICE_ID = #attributes.cost_page_id#
                <cfelse>
                SHIP_ID = #attributes.cost_page_id#
                </cfif>
            GROUP BY
                ISNULL(DISTRIBUTE_TYPE,0)
        </cfquery>
    </cfif>
	<cfif GET_COST_TOTAL.recordcount and attributes.page_type eq 1>
		<cfquery name="UPDATE_INVOICE" datasource="#dsn2#">
			UPDATE 
				INVOICE_ROW 
			SET 
				EXTRA_COST=0
			WHERE
				INVOICE_ID = #attributes.cost_page_id#
		</cfquery>
		<cfloop query="GET_COST_TOTAL">
			<cfquery name="GET_INVOICE_DETAIL" datasource="#dsn2#">
				SELECT 
					(INV.NETTOTAL-INV.TAXTOTAL-INV.OTV_TOTAL+ISNULL(INV.SA_DISCOUNT,0))<cfif x_inventory_products eq 0>-ISNULL((SELECT SUM(IRR.AMOUNT*IRR.PRICE) FROM INVOICE_ROW IRR WHERE IRR.INVOICE_ID =INV.INVOICE_ID AND IRR.PRODUCT_ID IN(SELECT P.PRODUCT_ID FROM #dsn3_alias#.PRODUCT P WHERE P.PRODUCT_ID = IRR.PRODUCT_ID AND P.IS_INVENTORY=0)),0)</cfif> AS BELGE_TOPLAM,
					INV_R.NETTOTAL AS SATIR_TOPLAM,
					INV_R.AMOUNT AS SATIR_MIKTAR,
					INV.INVOICE_ID,
					INV_R.INVOICE_ROW_ID,
					INV_R.PRODUCT_ID,
					INV.INVOICE_DATE ACTION_DATE,
					INV_R.SPECT_VAR_ID,
					ISNULL(PU.VOLUME,0)*INV_R.AMOUNT VOLUME,
					ISNULL(PU.WEIGHT,0)*INV_R.AMOUNT WEIGHT
				FROM
					INVOICE INV,
					INVOICE_ROW INV_R,
					#dsn3_alias#.PRODUCT_UNIT PU
				WHERE
					INV.INVOICE_ID= INV_R.INVOICE_ID
					AND INV.INVOICE_ID = #attributes.cost_page_id#
					<cfif GET_COST_TOTAL.DISTRIBUTE_TYPE eq 0><!--- parasal dağılım --->
						AND INV_R.PRICE > 0
					<cfelseif GET_COST_TOTAL.DISTRIBUTE_TYPE eq 1><!--- ağılığa göre dağılım --->
						AND ISNULL(PU.WEIGHT,0)*INV_R.AMOUNT > 0
					<cfelseif GET_COST_TOTAL.DISTRIBUTE_TYPE eq 2><!--- hacime göre dağılım --->
						AND ISNULL(PU.VOLUME,0)*INV_R.AMOUNT > 0
					</cfif>
					<cfif x_inventory_products eq 0>
						AND INV_R.PRODUCT_ID NOT IN(SELECT P.PRODUCT_ID FROM #dsn3_alias#.PRODUCT P WHERE P.PRODUCT_ID = INV_R.PRODUCT_ID AND P.IS_INVENTORY=0)
					</cfif>
					AND PU.PRODUCT_UNIT_ID = INV_R.UNIT_ID
			</cfquery>
			<cfset cost_total=0>
			<cfset volume_total=0>
			<cfset weight_total=0>
			<cfoutput query="GET_INVOICE_DETAIL">
				<cfset volume_total=volume_total+volume>
				<cfset weight_total=weight_total+weight>
				<cfif SATIR_TOPLAM eq 0>
					<cfif len(SPECT_VAR_ID)>
						<cfquery name="GET_SPEC" datasource="#DSN2#">
							SELECT 
								SPECT_MAIN_ID
							FROM 
								#dsn3_alias#.SPECTS
							WHERE
								SPECT_VAR_ID=#SPECT_VAR_ID#
						</cfquery>
					</cfif>
					<cfquery name="GET_COST" datasource="#DSN2#" maxrows="1">
						SELECT 
							PURCHASE_NET_SYSTEM
						FROM
							#dsn3_alias#.PRODUCT_COST
						WHERE
							PRODUCT_ID=#PRODUCT_ID# AND
							START_DATE<=<cfif len(ACTION_DATE)>#createodbcdatetime(ACTION_DATE)#<cfelse>#NOW()#</cfif> AND
							ACTION_ID <> #INVOICE_ID#
							<cfif len(SPECT_VAR_ID) and GET_SPEC.RECORDCOUNT>
								AND SPECT_MAIN_ID=#GET_SPEC.SPECT_MAIN_ID#
							</cfif>
						ORDER BY
							START_DATE DESC,
							RECORD_DATE DESC
					</cfquery>
					<cfif GET_COST.RECORDCOUNT and GET_COST.PURCHASE_NET_SYSTEM gt 0>
						<cfset cost_total=cost_total+GET_COST.PURCHASE_NET_SYSTEM*SATIR_MIKTAR>
						<cfif len(SPECT_VAR_ID)>
							<cfset 'prod_cost_#PRODUCT_ID#_#SPECT_VAR_ID#'=GET_COST.PURCHASE_NET_SYSTEM*SATIR_MIKTAR>
						<cfelse>
							<cfset 'prod_cost_#PRODUCT_ID#'=GET_COST.PURCHASE_NET_SYSTEM*SATIR_MIKTAR>
						</cfif>
					</cfif>
				</cfif>
			</cfoutput>
			<cfoutput query="GET_INVOICE_DETAIL">
				<cfif GET_COST_TOTAL.DISTRIBUTE_TYPE eq 0><!--- parasal dağılım --->
					<cfset action_total=BELGE_TOPLAM+cost_total>
					<cfif action_total gt 0 and SATIR_TOPLAM gt 0>
						<cfset sat_top=SATIR_TOPLAM/action_total>
					<cfelse>
						<cfif len(SPECT_VAR_ID) and isdefined('prod_cost_#PRODUCT_ID#_#SPECT_VAR_ID#')>
							<cfset sat_top=evaluate('prod_cost_#PRODUCT_ID#_#SPECT_VAR_ID#')/action_total>
						<cfelseif isdefined('prod_cost_#PRODUCT_ID#')>
							<cfset sat_top=evaluate('prod_cost_#PRODUCT_ID#')/action_total>
						<cfelse>
							<cfset sat_top=0>
						</cfif>
					</cfif>
					<cfset birim_maliyet = wrk_round(((GET_COST_TOTAL.COST_TOTAL*sat_top)/SATIR_MIKTAR),8,1) >
				<cfelseif GET_COST_TOTAL.DISTRIBUTE_TYPE eq 1><!--- ağılığa göre dağılım --->
					<cfset action_total=weight_total>
					<cfif action_total gt 0 and weight gt 0>
						<cfset sat_top=weight/action_total>
					<cfelse>
						<cfset sat_top = 0>
					</cfif>
					<cfset birim_maliyet = wrk_round(((GET_COST_TOTAL.COST_TOTAL*sat_top)/SATIR_MIKTAR),8,1)>
				<cfelseif GET_COST_TOTAL.DISTRIBUTE_TYPE eq 2><!--- hacime göre dağılım --->
					<cfset action_total=volume_total>
					<cfif action_total gt 0 and volume gt 0>
						<cfset sat_top=volume/action_total>
					<cfelse>
						<cfset sat_top = 0>
					</cfif>
					<cfset birim_maliyet = wrk_round(((GET_COST_TOTAL.COST_TOTAL*sat_top)/SATIR_MIKTAR),8,1)>
				</cfif>
				<cfquery name="UPD_INVOICE_ROW" datasource="#dsn2#">
					UPDATE 
						INVOICE_ROW
					SET
						<cfif GET_COST_TOTAL.currentrow eq 1>
							EXTRA_COST = #birim_maliyet#
						<cfelse>
							EXTRA_COST = EXTRA_COST + #birim_maliyet#
						</cfif>
					WHERE
						INVOICE_ID = #GET_INVOICE_DETAIL.INVOICE_ID# AND
						INVOICE_ROW_ID = #GET_INVOICE_DETAIL.INVOICE_ROW_ID#
				</cfquery>
			</cfoutput>
		</cfloop>
	<cfelseif GET_COST_TOTAL.recordcount and (attributes.page_type eq 4 or attributes.page_type eq 5)>
		<cfquery name="UPDATE_SHIP" datasource="#dsn2#">
			UPDATE 
				SHIP_ROW 
			SET 
				EXTRA_COST=0
			WHERE
				SHIP_ID = #attributes.cost_page_id#
		</cfquery>
		<cfloop query="GET_COST_TOTAL">
			<cfquery name="GET_SHIP_DETAIL" datasource="#dsn2#">
				SELECT 
					<cfif attributes.page_type eq 5>
						SR.AMOUNT AS BELGE_TOPLAM,
						SR.AMOUNT AS SATIR_TOPLAM,
					<cfelse>
						(S.NETTOTAL-S.TAXTOTAL) AS BELGE_TOPLAM,
						SR.NETTOTAL AS SATIR_TOPLAM,
					</cfif>
					SR.AMOUNT AS SATIR_MIKTAR,
					S.SHIP_ID,
					SR.SHIP_ROW_ID,
					SR.STOCK_ID,
					SR.PRODUCT_ID,
					SR.IMPORT_INVOICE_ID,
					SR.IMPORT_PERIOD_ID,
					S.SHIP_DATE ACTION_DATE,
					SR.SPECT_VAR_ID,
					S.IS_DELIVERED,
					ISNULL(PU.VOLUME,0)*SR.AMOUNT VOLUME,
					ISNULL(PU.WEIGHT,0)*SR.AMOUNT WEIGHT
				FROM
					SHIP S,
					SHIP_ROW SR,
					#dsn3_alias#.PRODUCT_UNIT PU
				WHERE
					S.SHIP_ID= SR.SHIP_ID
					AND S.SHIP_ID = #attributes.cost_page_id#
					<cfif attributes.page_type neq 5>
						<cfif GET_COST_TOTAL.DISTRIBUTE_TYPE eq 0><!--- parasal dağılım --->
							AND SR.PRICE > 0
						<cfelseif GET_COST_TOTAL.DISTRIBUTE_TYPE eq 1><!--- ağılığa göre dağılım --->
							AND ISNULL(PU.WEIGHT,0)*SR.AMOUNT > 0
						<cfelseif GET_COST_TOTAL.DISTRIBUTE_TYPE eq 2><!--- hacime göre dağılım --->
							AND ISNULL(PU.VOLUME,0)*SR.AMOUNT > 0
						</cfif>
					</cfif>
					AND PU.PRODUCT_UNIT_ID = SR.UNIT_ID
			</cfquery>
			<cfif GET_SHIP_DETAIL.recordcount>
				<cfset cost_total=0>
				<cfset volume_total=0>
				<cfset weight_total=0>
				<cfoutput query="GET_SHIP_DETAIL">
					<cfset volume_total=volume_total+volume>
					<cfset weight_total=weight_total+weight>
					<cfif SATIR_TOPLAM eq 0>
						<cfif len(SPECT_VAR_ID)>
							<cfquery name="GET_SPEC" datasource="#DSN2#">
								SELECT 
									SPECT_MAIN_ID
								FROM 
									#dsn3_alias#.SPECTS
								WHERE
									SPECT_VAR_ID=#SPECT_VAR_ID#
							</cfquery>
						</cfif>
						<cfquery name="GET_COST" datasource="#DSN2#" maxrows="1">
							SELECT 
								PURCHASE_NET_SYSTEM
							FROM
								#dsn3_alias#.PRODUCT_COST
							WHERE
								PRODUCT_ID=#PRODUCT_ID# AND
								START_DATE<=<cfif len(ACTION_DATE)>#createodbcdatetime(ACTION_DATE)#<cfelse>#NOW()#</cfif> AND
								ACTION_ID <> #SHIP_ID#
								<cfif len(SPECT_VAR_ID) and GET_SPEC.RECORDCOUNT>
									AND SPECT_MAIN_ID=#GET_SPEC.SPECT_MAIN_ID#
								</cfif>
							ORDER BY
								START_DATE DESC,
								RECORD_DATE DESC
						</cfquery>
						<cfif GET_COST.RECORDCOUNT and GET_COST.PURCHASE_NET_SYSTEM gt 0>
							<cfset cost_total=cost_total+GET_COST.PURCHASE_NET_SYSTEM*SATIR_MIKTAR>
							<cfif len(SPECT_VAR_ID)>
								<cfset 'prod_cost_#PRODUCT_ID#_#SPECT_VAR_ID#'=GET_COST.PURCHASE_NET_SYSTEM*SATIR_MIKTAR>
							<cfelse>
								<cfset 'prod_cost_#PRODUCT_ID#'=GET_COST.PURCHASE_NET_SYSTEM*SATIR_MIKTAR>
							</cfif>
						</cfif>
					</cfif>
				</cfoutput>
				<cfoutput query="GET_SHIP_DETAIL">
					<cfif GET_COST_TOTAL.DISTRIBUTE_TYPE eq 0><!--- parasal dağılım --->
						<cfset action_total=BELGE_TOPLAM+cost_total>
						<cfif action_total gt 0 and SATIR_TOPLAM gt 0>
							<cfset sat_top=SATIR_TOPLAM/action_total>
						<cfelse>
							<cfif len(SPECT_VAR_ID) and isdefined('prod_cost_#PRODUCT_ID#_#SPECT_VAR_ID#')>
								<cfset sat_top=evaluate('prod_cost_#PRODUCT_ID#_#SPECT_VAR_ID#')/action_total>
							<cfelseif isdefined('prod_cost_#PRODUCT_ID#')>
								<cfset sat_top=evaluate('prod_cost_#PRODUCT_ID#')/action_total>
							<cfelse>
								<cfset sat_top=0>
							</cfif>
						</cfif>
						<cfset birim_maliyet = wrk_round(((GET_COST_TOTAL.COST_TOTAL*sat_top)/SATIR_MIKTAR),8,1)>
					<cfelseif GET_COST_TOTAL.DISTRIBUTE_TYPE eq 1><!--- ağırlığa göre dağılım --->
						<cfset action_total=weight_total>
						<cfif action_total gt 0 and weight gt 0>
							<cfset sat_top=weight/action_total>
						<cfelse>
							<cfset sat_top = 0>
						</cfif>
						<cfset birim_maliyet = wrk_round(((GET_COST_TOTAL.COST_TOTAL*sat_top)/SATIR_MIKTAR),8,1)>
					<cfelseif GET_COST_TOTAL.DISTRIBUTE_TYPE eq 2><!--- hacime göre dağılım --->
						<cfset action_total=volume_total>
						<cfif action_total gt 0 and volume gt 0>
							<cfset sat_top=volume/action_total>
						<cfelse>
							<cfset sat_top = 0>
						</cfif>
						<cfset birim_maliyet = wrk_round(((GET_COST_TOTAL.COST_TOTAL*sat_top)/SATIR_MIKTAR),8,1)>
					</cfif>
					<cfif len(GET_SHIP_DETAIL.IMPORT_PERIOD_ID) and GET_SHIP_DETAIL.IMPORT_PERIOD_ID eq session.ep.period_id>
						<cfquery name="GET_ITHALAT_INV" datasource="#dsn2#">
							SELECT
								EXTRA_COST
							FROM
								INVOICE_ROW
							WHERE
								INVOICE_ID=#GET_SHIP_DETAIL.IMPORT_INVOICE_ID#
								AND STOCK_ID=#GET_SHIP_DETAIL.STOCK_ID#
								AND PRODUCT_ID=#GET_SHIP_DETAIL.PRODUCT_ID#
						</cfquery>
						<cfif len(GET_ITHALAT_INV.EXTRA_COST)>	
							<cfset birim_maliyet =birim_maliyet + wrk_round(GET_ITHALAT_INV.EXTRA_COST,8,1)>
						</cfif>
					<cfelse>
						<cfif len(GET_SHIP_DETAIL.IMPORT_PERIOD_ID)>
							<cfquery name="GET_PERIOD" datasource="#dsn2#">
								SELECT
									*
								FROM
									#dsn_alias#.SETUP_PERIOD
								WHERE
									PERIOD_ID= #GET_SHIP_DETAIL.IMPORT_PERIOD_ID#
									AND OUR_COMPANY_ID = #session.ep.company_id#
							</cfquery>
						<cfelse>
							<cfset get_period.recordcount = 0>
						</cfif>
						<cfif get_period.recordcount>
							<cfset onceki_donem = '#dsn#_#GET_PERIOD.PERIOD_YEAR#_#GET_PERIOD.OUR_COMPANY_ID#'>
							<cfquery name="GET_ITHALAT_INV" datasource="#dsn2#">
								SELECT
									EXTRA_COST
								FROM
									#onceki_donem#.INVOICE_ROW
								WHERE
									INVOICE_ID=#GET_SHIP_DETAIL.IMPORT_INVOICE_ID#
									AND STOCK_ID=#GET_SHIP_DETAIL.STOCK_ID#
									AND PRODUCT_ID=#GET_SHIP_DETAIL.PRODUCT_ID#
							</cfquery>
							<cfif len(GET_ITHALAT_INV.EXTRA_COST)>	
								<cfset birim_maliyet =birim_maliyet + GET_ITHALAT_INV.EXTRA_COST>
							</cfif>
						</cfif>
					</cfif>
					<cfquery name="UPD_SHIP_ROW" datasource="#dsn2#">
						UPDATE 
							SHIP_ROW
						SET
							<cfif GET_COST_TOTAL.currentrow eq 1>
								EXTRA_COST = #birim_maliyet#
							<cfelse>
								EXTRA_COST = EXTRA_COST + #birim_maliyet#
							</cfif>
						WHERE
							SHIP_ID = #GET_SHIP_DETAIL.SHIP_ID# AND
							SHIP_ROW_ID = #GET_SHIP_DETAIL.SHIP_ROW_ID#
					</cfquery>
				</cfoutput>
			</cfif>
		</cfloop>
	</cfif>
<cfelseif isdefined("attributes.page_type") and attributes.page_type eq 2> <!---siparis satırları icin ek maliyet alanı update ediliyor --->
	<cfquery name="GET_COST_TOTAL" datasource="#dsn2#">
		SELECT 
			SUM(COST) AS COST_TOTAL,
			ISNULL(DISTRIBUTE_TYPE,0) DISTRIBUTE_TYPE
		FROM 
			#dsn3_alias#.ORDER_OFFER_COST 
		WHERE 
			ORDER_OFFER_ID = #attributes.cost_page_id# 
			AND IS_ORDER = 1
		GROUP BY
			ISNULL(DISTRIBUTE_TYPE,0)
	</cfquery>
	<cfif GET_COST_TOTAL.recordcount>
		<cfquery name="UPDATE_ORDER" datasource="#dsn2#">
			UPDATE 
				#dsn3_alias#.ORDER_ROW
			SET 
				EXTRA_COST=0
			WHERE
				ORDER_ID = #attributes.cost_page_id#
		</cfquery>
		<cfloop query="GET_COST_TOTAL">
			<cfquery name="GET_ORDER_DETAIL" datasource="#dsn2#">
				SELECT 
					ISNULL(ORD.NETTOTAL-ORD.TAXTOTAL,0) AS BELGE_TOPLAM,
					ORD_R.NETTOTAL AS SATIR_TOPLAM,
					ORD_R.QUANTITY AS SATIR_MIKTAR,
					ORD.ORDER_ID,
					ORD_R.ORDER_ROW_ID,
					ORD.ORDER_DATE ACTION_DATE,
					ORD_R.SPECT_VAR_ID,
					ORD_R.PRODUCT_ID,
					ISNULL(PU.VOLUME,0)*ORD_R.QUANTITY VOLUME,
					ISNULL(PU.WEIGHT,0)*ORD_R.QUANTITY WEIGHT
				FROM
					#dsn3_alias#.ORDERS ORD,
					#dsn3_alias#.ORDER_ROW ORD_R,
					#dsn3_alias#.PRODUCT_UNIT PU
				WHERE
					ORD.ORDER_ID= ORD_R.ORDER_ID
					AND ORD.ORDER_ID = #attributes.cost_page_id#
					<cfif GET_COST_TOTAL.DISTRIBUTE_TYPE eq 0><!--- parasal dağılım --->
						AND ORD_R.PRICE > 0
					<cfelseif GET_COST_TOTAL.DISTRIBUTE_TYPE eq 1><!--- ağılığa göre dağılım --->
						AND ISNULL(PU.WEIGHT,0)*ORD_R.QUANTITY > 0
					<cfelseif GET_COST_TOTAL.DISTRIBUTE_TYPE eq 2><!--- hacime göre dağılım --->
						AND ISNULL(PU.VOLUME,0)*ORD_R.QUANTITY > 0
					</cfif>
					AND PU.PRODUCT_UNIT_ID = ORD_R.UNIT_ID
			</cfquery>
			<cfset cost_total=0>
			<cfset volume_total=0>
			<cfset weight_total=0>
			<cfoutput query="GET_ORDER_DETAIL">
				<cfset volume_total=volume_total+volume>
				<cfset weight_total=weight_total+weight>
				<cfif SATIR_TOPLAM eq 0>
					<cfif len(SPECT_VAR_ID)>
						<cfquery name="GET_SPEC" datasource="#DSN2#">
							SELECT 
								SPECT_MAIN_ID
							FROM 
								#dsn3_alias#.SPECTS
							WHERE
								SPECT_VAR_ID=#SPECT_VAR_ID#
						</cfquery>
					</cfif>
					<cfquery name="GET_COST" datasource="#DSN2#" maxrows="1">
						SELECT 
							PURCHASE_NET_SYSTEM
						FROM
							#dsn3_alias#.PRODUCT_COST
						WHERE
							PRODUCT_ID=#PRODUCT_ID# AND
							START_DATE<=<cfif len(ACTION_DATE)>#createodbcdatetime(ACTION_DATE)#<cfelse>#NOW()#</cfif> AND
							ACTION_ID <> #ORDER_ID#
							<cfif len(SPECT_VAR_ID) and GET_SPEC.RECORDCOUNT>
								AND SPECT_MAIN_ID=#GET_SPEC.SPECT_MAIN_ID#
							</cfif>
						ORDER BY
							START_DATE DESC,
							RECORD_DATE DESC
					</cfquery>
					<cfif GET_COST.RECORDCOUNT and GET_COST.PURCHASE_NET_SYSTEM gt 0>
						<cfset cost_total=cost_total+GET_COST.PURCHASE_NET_SYSTEM*SATIR_MIKTAR>
						<cfif len(SPECT_VAR_ID)>
							<cfset 'prod_cost_#PRODUCT_ID#_#SPECT_VAR_ID#'=GET_COST.PURCHASE_NET_SYSTEM*SATIR_MIKTAR>
						<cfelse>
							<cfset 'prod_cost_#PRODUCT_ID#'=GET_COST.PURCHASE_NET_SYSTEM*SATIR_MIKTAR>
						</cfif>
					</cfif>
				</cfif>
			</cfoutput>
			<cfoutput query="GET_ORDER_DETAIL">
				<cfif GET_COST_TOTAL.DISTRIBUTE_TYPE eq 0><!--- parasal dağılım --->		
					<cfset action_total=BELGE_TOPLAM+cost_total>
					<cfif action_total gt 0 and SATIR_TOPLAM gt 0>
						<cfset sat_top=SATIR_TOPLAM/action_total>
					<cfelseif SATIR_TOPLAM eq 0>
						<cfif len(SPECT_VAR_ID) and isdefined('prod_cost_#PRODUCT_ID#_#SPECT_VAR_ID#')>
							<cfset sat_top=evaluate('prod_cost_#PRODUCT_ID#_#SPECT_VAR_ID#')/action_total>
						<cfelseif isdefined('prod_cost_#PRODUCT_ID#')>
							<cfset sat_top=evaluate('prod_cost_#PRODUCT_ID#')/action_total>
						<cfelse>
							<cfset sat_top=0>
						</cfif>
					<cfelse>
						<cfset sat_top=0>
					</cfif>
					<cfset birim_maliyet = wrk_round(((GET_COST_TOTAL.COST_TOTAL*sat_top)/SATIR_MIKTAR),8,1) >
				<cfelseif GET_COST_TOTAL.DISTRIBUTE_TYPE eq 1><!--- ağılığa göre dağılım --->
					<cfset action_total=weight_total>
					<cfif action_total gt 0 and weight gt 0>
						<cfset sat_top=weight/action_total>
					<cfelse>
						<cfset sat_top = 0>
					</cfif>
					<cfset birim_maliyet = wrk_round(((GET_COST_TOTAL.COST_TOTAL*sat_top)/SATIR_MIKTAR),8,1)>
				<cfelseif GET_COST_TOTAL.DISTRIBUTE_TYPE eq 2><!--- hacime göre dağılım --->
					<cfset action_total=volume_total>
					<cfif action_total gt 0 and volume gt 0>
						<cfset sat_top=volume/action_total>
					<cfelse>
						<cfset sat_top = 0>
					</cfif>
					<cfset birim_maliyet = wrk_round(((GET_COST_TOTAL.COST_TOTAL*sat_top)/SATIR_MIKTAR),8,1)>
				</cfif>
				<cfquery name="UPD_ORDER_ROW" datasource="#dsn2#">
					UPDATE 
						#dsn3_alias#.ORDER_ROW
					SET
						<cfif GET_COST_TOTAL.currentrow eq 1>
							EXTRA_COST = #birim_maliyet#
						<cfelse>
							EXTRA_COST = EXTRA_COST + #birim_maliyet#
						</cfif>
					WHERE
						ORDER_ID = #GET_ORDER_DETAIL.ORDER_ID# AND
						ORDER_ROW_ID = #GET_ORDER_DETAIL.ORDER_ROW_ID#
				</cfquery>
			</cfoutput>
		</cfloop>
	</cfif>
</cfif>

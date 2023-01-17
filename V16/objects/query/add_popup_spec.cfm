<!--- satir eklerken ürün popuplarından specli secili ise main spec id ile ilişkili bir spec oluşturup onu baskete atıyor--->
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfif not isdefined('attributes.search_process_date') or not len(attributes.search_process_date)>
			<cfset action_spect_date=#now()#>
		<cfelse>
			<cfset action_spect_date=attributes.search_process_date>
		</cfif>
		<cfif not find('ts',action_spect_date)>
			<cf_date tarih="action_spect_date">
		</cfif>
		<cfset attributes.main_spect_id=attributes.spec_id>
		<cfquery name="GET_PROD_ID_ALL" datasource="#DSN3#">
			SELECT 
				SMR.PRODUCT_ID,
				SMR.STOCK_ID,
				SMR.PRODUCT_NAME
			FROM 
				SPECT_MAIN_ROW SMR
			WHERE 
				SMR.SPECT_MAIN_ID = #attributes.main_spect_id#
		</cfquery>
		
		<cfset product_id_list=valuelist(GET_PROD_ID_ALL.PRODUCT_ID,',')><!--- AGAC VEYA MASTER SPECTEKI TUM URUNLERIN PRODUCT_ID ALIYORUZ--->
		<cfset product_id_list=ListAppend(product_id_list,attributes.product_id,',')>
		<!--- uyenin fiyat listesini bulmak icin--->
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			<cfquery name="GET_PRICE_CAT_CREDIT" datasource="#dsn3#">
				SELECT
					PRICE_CAT
				FROM
					#dsn_alias#.COMPANY_CREDIT
				WHERE
					COMPANY_ID = #attributes.company_id#  AND
					OUR_COMPANY_ID = #session.ep.company_id#
			</cfquery>
			<cfif GET_PRICE_CAT_CREDIT.RECORDCOUNT and len(GET_PRICE_CAT_CREDIT.PRICE_CAT)>
				<cfset attributes.price_catid=GET_PRICE_CAT_CREDIT.PRICE_CAT>
			<cfelse>
				<cfquery name="GET_COMP_CAT" datasource="#dsn3#">
					SELECT COMPANYCAT_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_ID = #attributes.company_id#
				</cfquery>
				<cfquery name="GET_PRICE_CAT_COMP" datasource="#dsn3#">
					SELECT 
						PRICE_CATID
					FROM
						PRICE_CAT
					WHERE
						COMPANY_CAT LIKE '%,#GET_COMP_CAT.COMPANYCAT_ID#,%'
				</cfquery>
				<cfset attributes.price_catid=GET_PRICE_CAT_COMP.PRICE_CATID>
			</cfif>
		</cfif>
		<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			<cfquery name="GET_COMP_CAT" datasource="#DSN3#">
				SELECT CONSUMER_CAT_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_ID = #attributes.consumer_id#
			</cfquery>
			<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
				SELECT PRICE_CATID FROM PRICE_CAT WHERE CONSUMER_CAT LIKE '%,#get_comp_cat.consumer_cat_id#,%'
			</cfquery>
			<cfset attributes.price_catid=get_price_cat.PRICE_CATID>
		</cfif>
		<!--- //uyenin fiyat listesini bulmak icin--->
		
		<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
			<cfquery name="GET_PRICE" datasource="#dsn3#">
				SELECT
					PRICE_STANDART.PRODUCT_ID,
					PRICE_STANDART.MONEY,
					PRICE_STANDART.PRICE
				FROM
					PRICE PRICE_STANDART,	
					PRODUCT_UNIT
				WHERE
					PRICE_STANDART.PRICE_CATID=#attributes.price_catid# AND
					PRICE_STANDART.STARTDATE< #action_spect_date# AND 
					(PRICE_STANDART.FINISHDATE >= #action_spect_date# OR PRICE_STANDART.FINISHDATE IS NULL) AND
					PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
					PRICE_STANDART.PRODUCT_ID IN (#product_id_list#) AND 
					ISNULL(PRICE_STANDART.STOCK_ID,0)=0 AND
					ISNULL(PRICE_STANDART.SPECT_VAR_ID,0)=0 AND
					PRODUCT_UNIT.IS_MAIN = 1
			</cfquery>
		</cfif>
		<cfquery name="GET_PRICE_STANDART" datasource="#dsn3#">
			SELECT
				PRICE_STANDART.PRODUCT_ID,
				PRICE_STANDART.MONEY,
				PRICE_STANDART.PRICE
			FROM
				PRODUCT,
				PRICE_STANDART
			WHERE
				PRODUCT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
				PURCHASESALES = 1 AND
				PRICESTANDART_STATUS = 1 AND
				PRODUCT.PRODUCT_ID IN (#product_id_list#)
		</cfquery>
		<!--- //tum sayfadaki urunler icin fiyatları aliyor sonra query of query ile cekecek--->
		
		<cfquery name="GET_MAIN_SPECT" datasource="#DSN3#">
			SELECT 
				SPECT_MAIN.SPECT_MAIN_NAME,
				SPECT_MAIN.SPECT_TYPE,
				SPECT_MAIN.STOCK_ID MAIN_STOCK_ID,
				SPECT_MAIN.PRODUCT_ID MAIN_PRODUCT_ID,
				SPECT_MAIN.IS_TREE,
				SPECT_MAIN_ROW.* 
			FROM 
				SPECT_MAIN,
				SPECT_MAIN_ROW
			WHERE
				SPECT_MAIN.SPECT_MAIN_ID=#attributes.main_spect_id#
				AND SPECT_MAIN.SPECT_MAIN_ID=SPECT_MAIN_ROW.SPECT_MAIN_ID
		</cfquery>
		
		<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
			<cfquery name="GET_PRICE_MAIN_PROD" dbtype="query">
				SELECT
					*
				FROM
					GET_PRICE
				WHERE
					PRODUCT_ID=#GET_MAIN_SPECT.MAIN_PRODUCT_ID#
			  </cfquery>
		</cfif>
		<cfif not isdefined("GET_PRICE_MAIN_PROD") or GET_PRICE_MAIN_PROD.RECORDCOUNT eq 0>
			<cfquery name="GET_PRICE_MAIN_PROD" dbtype="query">
		
				SELECT
					*
				FROM
					GET_PRICE_STANDART
				WHERE
					PRODUCT_ID=#GET_MAIN_SPECT.MAIN_PRODUCT_ID#
			</cfquery>
		</cfif>
		<cfquery name="ADD_VAR_SPECT" datasource="#dsn3#" result="MAX_ID">
			INSERT
			INTO
				SPECTS
				(
					SPECT_MAIN_ID,
					SPECT_VAR_NAME,
					SPECT_TYPE,
					PRODUCT_ID,
					STOCK_ID,
					PRODUCT_AMOUNT,
					PRODUCT_AMOUNT_CURRENCY,
					IS_TREE,
					RECORD_IP,
					RECORD_EMP,
					RECORD_DATE
				)
				VALUES
				(
					#attributes.main_spect_id#,
					'#GET_MAIN_SPECT.SPECT_MAIN_NAME#',
					#GET_MAIN_SPECT.SPECT_TYPE#,
					#GET_MAIN_SPECT.MAIN_PRODUCT_ID#,
					#GET_MAIN_SPECT.MAIN_STOCK_ID#,
					<cfif len(GET_PRICE_MAIN_PROD.PRICE)>#GET_PRICE_MAIN_PROD.PRICE#,<cfelse>0,</cfif>
					<cfif len(GET_PRICE_MAIN_PROD.MONEY)>'#GET_PRICE_MAIN_PROD.MONEY#',<cfelse>'#session.ep.money#',</cfif>
					<cfif len(GET_MAIN_SPECT.IS_TREE)>#GET_MAIN_SPECT.IS_TREE#<cfelse>0</cfif>,
					'#cgi.remote_addr#',
					#session.ep.userid#,
					#now()#
				)
		</cfquery>
		<cfset max_spect_id=MAX_ID.IDENTITYCOL>
		<cfquery name="get_money_for_spect" datasource="#dsn3#">
			SELECT MONEY AS MONEY_TYPE FROM #dsn_alias#.SETUP_MONEY WHERE COMPANY_ID=#session.ep.company_id# AND PERIOD_ID=#session.ep.period_id# AND MONEY_STATUS=1
		</cfquery>
		<cfloop query="get_money_for_spect">
			<cfquery name="add_money_spec" datasource="#dsn3#">
				INSERT INTO SPECT_MONEY
				(
					ACTION_ID,
					MONEY_TYPE,
					RATE2,
					RATE1,
					IS_SELECTED
				)
				VALUES
				(
					#max_spect_id#,
					'#MONEY_TYPE#',
					#evaluate("attributes.#MONEY_TYPE#")#,
					1,
				<cfif session.ep.money2 is MONEY_TYPE>
					1
				<cfelse>
					0
				</cfif>					
				)
			</cfquery>
		</cfloop>
		<cfquery name="GET_MONEY" datasource="#dsn3#">
			SELECT * FROM SPECT_MONEY WHERE ACTION_ID=#max_spect_id#
		</cfquery>
		<cfset toplam_spect_tutar=0>
		<cfset toplam_spect_maliyet=0>
		<cfloop query="GET_MAIN_SPECT">
			<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
				<cfquery name="GET_PRICE_PROD" dbtype="query">
					SELECT
						*
					FROM
						GET_PRICE
					WHERE
						PRODUCT_ID=#GET_MAIN_SPECT.PRODUCT_ID#
				  </cfquery>
			</cfif>
			<cfif not isdefined("GET_PRICE_PROD") or GET_PRICE_PROD.RECORDCOUNT eq 0>
				<cfquery name="GET_PRICE_PROD" dbtype="query">
					SELECT
						*
					FROM
						GET_PRICE_STANDART
					WHERE
						PRODUCT_ID=#GET_MAIN_SPECT.PRODUCT_ID#
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
					PRODUCT_ID = #GET_MAIN_SPECT.PRODUCT_ID# AND
					START_DATE <= #action_spect_date#
				ORDER BY
					START_DATE DESC,
					RECORD_DATE DESC
			</cfquery>
			<cfif len(GET_COST.PRODUCT_COST)><cfset satir_maliyet=GET_COST.PRODUCT_COST><cfelse><cfset satir_maliyet=0></cfif>
			<cfquery name="ADD_ROW" datasource="#dsn3#">
				INSERT
				INTO
					SPECTS_ROW
					(
						SPECT_ID,
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
						#max_spect_id#,
						<cfif len(GET_MAIN_SPECT.PRODUCT_ID)>#GET_MAIN_SPECT.PRODUCT_ID#<cfelse>NULL</cfif>,
						<cfif len(GET_MAIN_SPECT.STOCK_ID)>#GET_MAIN_SPECT.STOCK_ID#<cfelse>NULL</cfif>,
						<cfif len(GET_MAIN_SPECT.AMOUNT)>#GET_MAIN_SPECT.AMOUNT#<cfelse>0</cfif>,
						<cfif len(GET_PRICE_PROD.PRICE)>#GET_PRICE_PROD.PRICE#<cfelse>0</cfif>,
						'#GET_PRICE_PROD.MONEY#',
						<cfif len(GET_MAIN_SPECT.PRODUCT_NAME)>'#GET_MAIN_SPECT.PRODUCT_NAME#'<cfelse>NULL</cfif>,
						<cfif GET_MAIN_SPECT.IS_PROPERTY eq 1>1<cfelse>0</cfif>,
						<cfif GET_MAIN_SPECT.IS_CONFIGURE eq 1>1<cfelse>0</cfif>,
						0,
						#satir_maliyet#,
						<cfif len(GET_COST.MONEY)>'#GET_COST.MONEY#'<cfelse>NULL</cfif>,
						<cfif len(GET_COST.PRODUCT_COST_ID)>#GET_COST.PRODUCT_COST_ID#<cfelse>NULL</cfif>,
						<cfif GET_MAIN_SPECT.IS_SEVK eq 1>1<cfelse>0</cfif>
					)
			</cfquery>
			<cfset GET_PRICE_PROD.RECORDCOUNT=0>
			
			<cfif len(GET_COST.MONEY) and GET_PRICE_MAIN_PROD.MONEY neq GET_COST.MONEY>
				<!--- ana urun fiyatla satir maliyet para birimi farkli ise once ana para birimine ordanda ana urun fiyat cinsine cevirir--->
				<cfquery name="GET_ROW_MONEY_COST" dbtype="query">
					SELECT	MONEY_TYPE,RATE2 RATE FROM GET_MONEY WHERE MONEY_TYPE='#GET_COST.MONEY#'
				</cfquery>
				<cfset satir_maliyet=satir_maliyet*GET_ROW_MONEY_COST.RATE>
				<cfif GET_PRICE_MAIN_PROD.MONEY neq session.ep.money>
					<cfquery name="GET_ROW_MONEY_COST_2" dbtype="query">
						SELECT	MONEY_TYPE,RATE2 RATE FROM GET_MONEY WHERE MONEY_TYPE='#GET_PRICE_MAIN_PROD.MONEY#'
					</cfquery>
					<cfif GET_ROW_MONEY_COST_2.RECORDCOUNT>
						<cfset satir_maliyet=satir_maliyet/GET_ROW_MONEY_COST_2.RATE>
					</cfif>
				</cfif>
			</cfif>
			<cfif GET_MAIN_SPECT.AMOUNT gt 1>
				<cfset satir_maliyet=satir_maliyet*GET_MAIN_SPECT.AMOUNT>
			</cfif>
			<cfset toplam_spect_maliyet=toplam_spect_maliyet+satir_maliyet>
		
			<cfset satir_urun_tutar=0>
			<cfif len(GET_PRICE_PROD.PRICE)>
				<cfset satir_urun_tutar=GET_PRICE_PROD.PRICE>
				<cfif GET_PRICE_MAIN_PROD.MONEY neq GET_PRICE_PROD.MONEY>
				<!--- ana urun fiyatla satir fiyat birimi farkli ise once ana para birimine ordanda ana urun fiyat cinsine cevirir--->
					<cfquery name="GET_ROW_MONEY" dbtype="query">
						SELECT	MONEY_TYPE, RATE2 RATE FROM GET_MONEY WHERE MONEY_TYPE='#GET_PRICE_PROD.MONEY#'
					</cfquery>
					<cfif GET_ROW_MONEY.RECORDCOUNT and len(GET_ROW_MONEY.RATE)>
						<cfset satir_urun_tutar=GET_PRICE_PROD.PRICE*GET_ROW_MONEY.RATE>
					</cfif>
					<cfquery name="GET_ROW_MONEY_2" dbtype="query">
						SELECT	MONEY_TYPE,RATE2 RATE FROM GET_MONEY WHERE MONEY_TYPE='#GET_PRICE_MAIN_PROD.MONEY#'
					</cfquery>
					<cfif GET_ROW_MONEY_2.RECORDCOUNT>
						<cfset satir_urun_tutar=satir_urun_tutar/GET_ROW_MONEY_2.RATE>
					</cfif>
				</cfif>
				<cfif GET_MAIN_SPECT.AMOUNT gt 1>
					<cfset satir_urun_tutar=satir_urun_tutar*GET_MAIN_SPECT.AMOUNT>
				</cfif>
				<cfset toplam_spect_tutar=toplam_spect_tutar+satir_urun_tutar>
			</cfif>
		</cfloop>
		<cfset toplam_spect_tutar_ep_money=0>
		<cfif GET_PRICE_MAIN_PROD.MONEY neq session.ep.money>
			<cfquery name="GET_ROW_MONEY_TOTAL" dbtype="query">
				SELECT	MONEY_TYPE,RATE2 RATE FROM GET_MONEY WHERE MONEY_TYPE='#GET_PRICE_MAIN_PROD.MONEY#'
			</cfquery>
			<cfif GET_ROW_MONEY_TOTAL.RECORDCOUNT>
				<cfset toplam_spect_tutar_ep_money=toplam_spect_tutar*GET_ROW_MONEY_TOTAL.RATE>
			</cfif>
		<cfelse>
			<cfset toplam_spect_tutar_ep_money=toplam_spect_tutar>
		</cfif>
			
		<cfquery name="UPD_SPEC_COST" datasource="#dsn3#">
			UPDATE 
				SPECTS 
			SET 
				SPECT_COST=#toplam_spect_maliyet#,
				SPECT_COST_CURRENCY=<cfif len(GET_PRICE_MAIN_PROD.MONEY)>'#GET_PRICE_MAIN_PROD.MONEY#'<cfelse>'#session.ep.money#'</cfif>,
				OTHER_MONEY_CURRENCY=<cfif len(GET_PRICE_MAIN_PROD.MONEY)>'#GET_PRICE_MAIN_PROD.MONEY#'<cfelse>'#session.ep.money#'</cfif>,
				OTHER_TOTAL_AMOUNT=#toplam_spect_tutar#, 
				TOTAL_AMOUNT=#toplam_spect_tutar_ep_money#
			WHERE 
				SPECT_VAR_ID=#max_spect_id#
		</cfquery>
		
		<cfif isdefined('max_spect_id') and len(max_spect_id)>
			<cfset attributes.spec_id=max_spect_id>
			<cfif len(GET_MAIN_SPECT.SPECT_MAIN_NAME)>
				<cfset attributes.spec_name=GET_MAIN_SPECT.SPECT_MAIN_NAME>
			<cfelse>
				<cfset attributes.spec_name=attributes.product_name>
			</cfif>
		</cfif>
	</cftransaction>
</cflock>

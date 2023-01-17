<cfset attributes.action_detail = 'Eğitim ödeme tutarı.'>

<!--- sanal pos --->
<cfinclude template="../query/add_online_pos.cfm">
<!--- sanal pos --->

<cfif response_code eq 00>
	<cfset order_warning = 0>
	<cftry>
		<!--- default parametreler --->
		<cfquery name="getOrdersProcess" datasource="#DSN#" maxrows="1">
			SELECT TOP 1
				PTR.PROCESS_ROW_ID 
			FROM
				PROCESS_TYPE_ROWS PTR,
				PROCESS_TYPE_OUR_COMPANY PTO,
				PROCESS_TYPE PT
			WHERE
				PT.IS_ACTIVE = 1 AND
				PT.PROCESS_ID = PTR.PROCESS_ID AND
				PT.PROCESS_ID = PTO.PROCESS_ID AND
				<cfif isdefined("session.pp")>
					PTR.IS_PARTNER = 1 AND
					PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
				<cfelseif isdefined("session.ww.userid")>
					PTR.IS_CONSUMER = 1 AND
					PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
				</cfif>
				PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.form_add_order%">
			ORDER BY 
				PTR.PROCESS_ROW_ID
		</cfquery>

		<cfset stock_id = listfirst(attributes.stock_id,';')>
		<cfset order_stage_id = getOrdersProcess.PROCESS_ROW_ID>
		<cfset card_paymethod_id = payment_type_id>
		<cfset attributes.order_head = "Eğitim satın alma">
		
		
		<!--- urun bilgileri cekiliyor --->
		<cfquery name="getProduct_" datasource="#dsn3#">
			SELECT 
				S.STOCK_ID,
				S.PRODUCT_ID,
				S.PRODUCT_NAME +' - '+ S.PROPERTY AS PRODUCT_NAME,
				S.PRODUCT_UNIT_ID UNIT_ID,
				PU.MAIN_UNIT UNIT,
				S.TAX
			FROM 
				STOCKS S
				RIGHT JOIN PRODUCT_UNIT PU ON PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID 
			WHERE 
				STOCK_ID = #stock_id#
		</cfquery>
	
		
		<!--- siparis kaydi atiliyor --->
			<!--- siparis no --->
			<cfquery name="get_gen_paper" datasource="#dsn3#">
				SELECT 
                	GENERAL_PAPERS_ID, 
                    OFFER_NO, 
                    OFFER_NUMBER, 
                    ORDER_NO, 
                    ORDER_NUMBER, 
                    PAPER_TYPE, 
                    ZONE_TYPE, 
                    CAMPAIGN_NO, 
                    CAMPAIGN_NUMBER, 
                    PROMOTION_NO, 
                    PROMOTION_NUMBER, 
                    CATALOG_NO, 
                    CATALOG_NUMBER, 
                    TARGET_MARKET_NO, 
                    TARGET_MARKET_NUMBER, 
                    CAT_PROM_NO, 
                    CAT_PROM_NUMBER, 
                    PROD_ORDER_NO,
                    PROD_ORDER_NUMBER, 
                    SUPPORT_NO, 
                    SUPPORT_NUMBER, 
                    OPPORTUNITY_NO, 
                    OPPORTUNITY_NUMBER, 
                    SERVICE_APP_NO, 
                    SERVICE_APP_NUMBER, 
                    STOCK_FIS_NO, 
                    STOCK_FIS_NUMBER, 
                    SHIP_FIS_NO, 
                    SHIP_FIS_NUMBER, 
                    SUBSCRIPTION_NO, 
                    SUBSCRIPTION_NUMBER, 
                    PRODUCTION_RESULT_NO, 
                    PRODUCTION_RESULT_NUMBER, 
                    PRODUCTION_LOT_NO, 
                    PRODUCTION_LOT_NUMBER, 
                    CREDIT_NO, CREDIT_NUMBER, 
                    PRO_MATERIAL_NO, 
                    PRO_MATERIAL_NUMBER, 
                    INTERNAL_NO, 
                    INTERNAL_NUMBER, 
                    VIRMAN_NO, 
                    VIRMAN_NUMBER, 
                    INCOMING_TRANSFER_NO, 
                    INCOMING_TRANSFER_NUMBER, 
                    OUTGOING_TRANSFER_NO, 
                    OUTGOING_TRANSFER_NUMBER, 
                    PURCHASE_DOVIZ_NO, 
                    PURCHASE_DOVIZ_NUMBER, 
                    SALE_DOVIZ_NO, 
                    SALE_DOVIZ_NUMBER, 
                    CREDITCARD_REVENUE_NO, 
                    CREDITCARD_REVENUE_NUMBER, 
                    CREDITCARD_PAYMENT_NO, 
                    CREDITCARD_PAYMENT_NUMBER, 
                    CARI_TO_CARI_NO, 
                    CARI_TO_CARI_NUMBER, 
                    DEBIT_CLAIM_NO, 
                    DEBIT_CLAIM_NUMBER, 
                    CASH_TO_CASH_NO, 
                    CASH_TO_CASH_NUMBER, 
                    CASH_PAYMENT_NO, 
                    CASH_PAYMENT_NUMBER, 
                    EXPENSE_COST_NO, 
                    EXPENSE_COST_NUMBER, 
                    INCOME_COST_NO, 
                    INCOME_COST_NUMBER, 
                    BUDGET_PLAN_NO, 
                    BUDGET_PLAN_NUMBER, 
                    CORRESPONDENCE_NO, 
                    CORRESPONDENCE_NUMBER, 
                    PURCHASEDEMAND_NO, 
                    PURCHASEDEMAND_NUMBER, 
                    EXPENDITURE_REQUEST_NO, 
                    EXPENDITURE_REQUEST_NUMBER, 
                    QUALITY_CONTROL_NO, 
                    QUALITY_CONTROL_NUMBER
                FROM 
                	GENERAL_PAPERS 
                WHERE 
                	ZONE_TYPE = 0 
                AND 
                	PAPER_TYPE = 0
			</cfquery>
			<cfset paper_code = evaluate('get_gen_paper.ORDER_NO')>
			<cfset paper_number = evaluate('get_gen_paper.ORDER_NUMBER') +1>
			<cfset paper_full = '#paper_code#-#paper_number#'>
			<cfquery name="SET_MAX_PAPER" datasource="#dsn3#">
				UPDATE
					GENERAL_PAPERS
				SET
					ORDER_NUMBER = ORDER_NUMBER+1
				WHERE
					PAPER_TYPE = 0 AND
					ZONE_TYPE = 0
			</cfquery>
			<!--- siparis no --->
			
			<cfset price_kdvsiz = attributes.sales_credit*(100/(100+getProduct_.tax))>
			<cfset price_kdvli = attributes.sales_credit>
			
			<cfquery name="ADD_ORDER" datasource="#dsn3#" result="MAX_ID">
				INSERT INTO
					ORDERS
				(
					WRK_ID,
					COMPANY_ID,
					PARTNER_ID,
					CONSUMER_ID,
					ORDER_NUMBER,
					ORDER_STAGE,
					ORDER_DATE,
					DELIVERDATE,
					ORDER_STATUS,
					ORDER_HEAD,
					INCLUDED_KDV,
					PURCHASE_SALES,
					ORDER_ZONE,
					CARD_PAYMETHOD_ID,
					IS_PAID,
					GROSSTOTAL,
					NETTOTAL,
					TAXTOTAL,
					RECORD_DATE,
					RECORD_IP,
					RECORD_CON
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
					<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
						#attributes.company_id#,
						<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
						NULL,
					<cfelse>
						NULL,
						NULL,
						#attributes.consumer_id#,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#paper_full#">,
					#order_stage_id#,
					#now()#,
					#now()#,
					1,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.order_head#">,
					0,
					1,
					0,
					#card_paymethod_id#,
					1,
					#attributes.sales_credit#,
					#attributes.sales_credit#,
					#price_kdvli-price_kdvsiz#,
					#now()#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					#session.ww.userid#
				)
			</cfquery>
			<cfquery name="ADD_ORDER_ROW" datasource="#dsn3#">
				INSERT INTO
					ORDER_ROW
				(
					ORDER_ID,
					PRODUCT_ID, 
					STOCK_ID,
					QUANTITY,
					UNIT,
					UNIT_ID,
					PRICE,
					TAX,
					NETTOTAL,
					PRODUCT_NAME,
					DELIVER_DATE,
					OTHER_MONEY,
					OTHER_MONEY_VALUE,
					PRICE_OTHER,
					IS_PROMOTION,
					IS_COMMISSION,
					ORDER_ROW_CURRENCY,
					PRICE_CAT
				)
				VALUES
				(
					#MAX_ID.IDENTITYCOL#,
					#getProduct_.product_id#, 
					#getProduct_.stock_id#,
					1,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('getProduct_.unit')#">,
					#getProduct_.unit_id#,
					#price_kdvsiz#,
					#getProduct_.tax#,
					#price_kdvsiz#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('getProduct_.product_name')#">,
					#now()#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="TL">,
					#attributes.sales_credit#,
					NULL,
					0,
					0,
					-6,
					1
				)
			</cfquery>
			<!--- kredi karti siparis ile iliskilendiriliyor--->
			<cfquery name="UPD_BANK_ORDER" datasource="#dsn3#">
				UPDATE
					CREDIT_CARD_BANK_PAYMENTS
				SET
					ORDER_ID = #MAX_ID.IDENTITYCOL#
				WHERE
					CREDITCARD_PAYMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#cc_paym_id_info#">
			</cfquery>
		<cfcatch>
			<cfset order_warning = 1>
		</cfcatch>
	</cftry>
	<cfif order_warning eq 1>
		<cflocation addtoken="no" url="#request.self#?fuseaction=worknet.warning_page&order_warning=#order_warning#">
	<cfelseif credit_cart_warning eq 1>
		<!--- Burada sistem yonetisine mail gönderilebilir para hesaba gecti fakat sisteme kredi kartı tahsilat kaydı atmadı --->
		<cflocation addtoken="no" url="#request.self#?fuseaction=worknet.warning_page">
	<cfelse>
		 <cfquery name="getConsumerEmail" datasource="#dsn#">
		 	SELECT CONSUMER_EMAIL,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = #session.ww.userid#
		 </cfquery>
		 <cfset subject = "Style Turkish Bilgilendirme">
		 <cfoutput>
			<cfsavecontent variable="message">
				<p class="yazilar">Sayın #session.ww.name# #session.ww.surname#,</p>
				<p class="yazilar">
					Sitemiz üzerinden #dateFormat(now(),dateformat_style)# #timeformat(now(),timeformat_style)# tarihinde yaptığınız işlem 
					sonucunda ödeme işleminiz gerçekleşmiş olup bu mesaj bilgilendirme amaçlı gönderilmiştir.
				</p>
				<p class="yazilar">Ürün : #getProduct_.product_name#</p>
				<p class="yazilar">Tutar : #TLFormat(attributes.sales_credit,2)# TL</p>
			</cfsavecontent>
		</cfoutput>
		<cfset sendMail = createObject("component","worknet.objects.worknet_objects").getMailTemplate(
					is_status:1,
					mail_to:getConsumerEmail.CONSUMER_EMAIL,
					message:message,
					subject:subject
				)>
		<script language="javascript">
			alert('İşleminiz onay almıştır ! Eğitimi izleyebilirsiniz.');
			window.location.href = '<cfoutput>#request.self#?fuseaction=worknet.dsp_training&id=#attributes.training_id#</cfoutput>';
		</script>
	</cfif>
</cfif>


<cfif isdefined("arguments.watalogy_partner")><cfset get_functions = createObject('component','AddOns/Yazilimsa/Protein/reactor/cfc/functions') /><cfelse><cfset get_functions = createObject('component','AddOns/Yazilimsa/Protein/reactor/cfc/functions') /></cfif>

	<cfset wrk_round = get_functions.wrk_round >
	
	<cfset get_rows = this.get_pre_order_products(
													consumer_id:'#arguments.consumer_id#',
													partner_id:'#arguments.partner_id#'
												)>
	<cfset dsn3_alias = dsn3>
	<cfset dsn2_alias = dsn2>
	<cfset dsn_alias = dsn> 
	
	<cfif len(get_rows.ACCOUNT_ID)>
		<cfquery name="get_bank_account" datasource="#DSN#">
			SELECT 
				ACCOUNT_ID,
				ACCOUNT_NAME,
				ACCOUNT_NO,
				ACCOUNT_OWNER_CUSTOMER_NO,
				BANK_CODE,
				BRANCH_CODE,
				(SELECT BANK_IMAGE_PATH FROM SETUP_BANK_TYPES SB WHERE SB.BANK_CODE = AC.BANK_CODE) AS BANK_IMAGE
			FROM  
				#dsn3#.ACCOUNTS AC
			WHERE 
				IS_PUBLIC = 1 AND 
				IS_INTERNET = 1 AND
				ACCOUNT_ID = #get_rows.ACCOUNT_ID#
		</cfquery>
		<cfset attributes.account_name = get_bank_account.account_name>
	<cfelse>
		<cfset attributes.account_name = "">
	</cfif>
	
	<cfquery name="GET_OUR_EMAIL" datasource="#DSN#">
		SELECT
			COMPANY_NAME,
			EMAIL
		FROM
			OUR_COMPANY
		WHERE
			<cfif isDefined('session.pp.userid')>
				COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
			<cfelseif isDefined('session.ww')>
				COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">   
			<cfelseif isdefined("session_base.our_company_id")>             
				COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#">   
			</cfif>
	</cfquery>
	
	<cfquery name="get_total" dbtype="query">
		SELECT SUM(PRICE_KDV_TL) AS T_TL_PRICE,SUM(PRICE_TL) AS T_TL_PRICE_KDVSIZ FROM get_rows
	</cfquery>
	
	<cfif isdefined("session.ww.userid")>
		<cfset get_consumer=this.get_consumer_func(
																consumer_id:'#arguments.consumer_id#'
															)>
	<cfelseif isdefined("session.pp.company_id")>
		<cfset get_consumer=this.get_company_func(
																company_id:'#session.pp.company_id#'
															)>
	<cfelseif isdefined("session_base.our_company_id")> 
		<cfset get_consumer=this.get_company_func(
																company_id:'#session_base.our_company_id#'
															)>            
	</cfif>
		
	
	<cfscript>
		attributes.consumer_id='';
		attributes.partner_id='';
		attributes.company_id='';
		
		if(isdefined("session.pp.userid"))
		{
			attributes.partner_id=session.pp.userid;
			attributes.company_id=session.pp.company_id;
		}
		else if(isdefined("session.ww.userid") )
			attributes.consumer_id=session.ww.userid;
			
	</cfscript>
	
	<cfif isdefined("session_base.company_id")>
		<cfquery name="GET_WORK_POS" datasource="#DSN#">
			SELECT
				WEP.CONSUMER_ID,
				WEP.OUR_COMPANY_ID,
				WEP.POSITION_CODE,
				EMP.EMPLOYEE_ID,
				WEP.IS_MASTER
			FROM
				WORKGROUP_EMP_PAR WEP,
				EMPLOYEE_POSITIONS EMP
			WHERE
				WEP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> AND
				WEP.COMPANY_ID IS NOT NULL AND
				WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
				WEP.POSITION_CODE = EMP.POSITION_CODE AND
				WEP.IS_MASTER = 1
		</cfquery>
	</cfif>
	<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#iif(isdefined("session_base.userid"),"session_base.userid",0)#_'&round(rand()*100)>
	
	
	
	<cfset attributes.SHIP_ADDRESS_ROW = "">
	<cfif not len(get_rows.DELIVER_ID)>
		<cfset attributes.ship_address_id = -1>
	<cfelse>
		<cfset attributes.ship_address_id = get_rows.DELIVER_ID>
	</cfif>
	<cfset attributes.havale_banka = get_rows.havale_banka>
	<cfset attributes.havale_tarih = get_rows.havale_tarih>
	<cfset attributes.havale_no = get_rows.havale_no>
	<cfset attributes.order_detail = get_rows.order_detail>
	
	
	
	<cfif get_rows.DELIVER_ID eq '-1'>
		<cfset attributes.ship_address = GET_CONSUMER.WORKADDRESS & '/' &GET_CONSUMER.WORK_COUNTY_NAME & '/' &GET_CONSUMER.WORK_CITY_NAME>
		<cfset attributes.city_id = GET_CONSUMER.WORK_CITY_ID >
		<cfset attributes.county_id = GET_CONSUMER.WORK_COUNTY_ID>
	<cfelseif get_rows.DELIVER_ID eq '-2'>
		<cfset attributes.ship_address = GET_CONSUMER.HOMEADDRESS & '/' &GET_CONSUMER.HOME_COUNTY_NAME & '/' &GET_CONSUMER.HOME_CITY_NAME>
		<cfset attributes.city_id = GET_CONSUMER.HOME_CITY_ID>
		<cfset attributes.county_id= GET_CONSUMER.HOME_COUNTY_ID>
	<cfelse>
		<cfif isdefined("session.ww.userid")>
			<cfquery name="GET_CONSUMER_BRANCH" datasource="#DSN#">
				SELECT 
					SC.CITY_NAME,SC.CITY_ID,SCO.COUNTY_NAME,SCO.COUNTY_ID,CB.CONTACT_ADDRESS,CB.CONTACT_NAME,CB.CONTACT_ID,CB.CONTACT_POSTCODE
				FROM 
					CONSUMER_BRANCH CB
					LEFT JOIN SETUP_CITY SC ON CB.CONTACT_CITY_ID=SC.CITY_ID
					LEFT JOIN SETUP_COUNTY SCO ON CB.CONTACT_COUNTY_ID=SCO.COUNTY_ID
				WHERE 
					CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
					AND
					CONTACT_ID = #attributes.ship_address_id#
			</cfquery>
		<cfelse>
			<cfquery name="GET_CONSUMER_BRANCH" datasource="#DSN#">
				SELECT 
					SC.CITY_NAME,SC.CITY_ID,SCO.COUNTY_NAME,SCO.COUNTY_ID,CB.COMPBRANCH_ADDRESS AS CONTACT_ADDRESS,CB.COMPBRANCH__NAME AS CONTACT_NAME,CB.COMPBRANCH_ID AS CONTACT_ID,CB.COMPBRANCH_POSTCODE AS CONTACT_POSTCODE
					FROM 
						COMPANY_BRANCH CB
						LEFT JOIN SETUP_CITY SC ON CB.CITY_ID=SC.CITY_ID
						LEFT JOIN SETUP_COUNTY SCO ON CB.COUNTY_ID=SCO.COUNTY_ID
					WHERE 
						COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">
						AND
						COMPBRANCH_ID = #attributes.ship_address_id#
			</cfquery>
		</cfif>
		<cfset attributes.ship_address = GET_CONSUMER_BRANCH.CONTACT_ADDRESS & '/' & GET_CONSUMER_BRANCH.COUNTY_NAME & '/'& GET_CONSUMER_BRANCH.CITY_NAME>
		<cfset attributes.city_id = GET_CONSUMER_BRANCH.CITY_ID>
		<cfset attributes.county_id = GET_CONSUMER_BRANCH.COUNTY_ID>
	</cfif>
	<cfif not len(get_rows.INVOICE_DELIVER_ID)>
		<cfset attributes.tax_address_id = -1>
	<cfelse>
		<cfset attributes.tax_address_id = get_rows.INVOICE_DELIVER_ID>
	</cfif>
	<cfif get_rows.INVOICE_DELIVER_ID eq '-1'>
		<cfset attributes.tax_address = GET_CONSUMER.WORKADDRESS>
	<cfelseif get_rows.INVOICE_DELIVER_ID eq '-2'>
		<cfset attributes.tax_address = GET_CONSUMER.HOMEADDRESS>
	<cfelse>
		<cfif isdefined("session.ww.userid")>
			<cfquery name="GET_CONSUMER_BRANCH" datasource="#DSN#">
				SELECT 
					SC.CITY_NAME,SC.CITY_ID,SCO.COUNTY_NAME,SCO.COUNTY_ID,CB.CONTACT_ADDRESS,CB.CONTACT_NAME,CB.CONTACT_ID,CB.CONTACT_POSTCODE
				FROM 
					CONSUMER_BRANCH CB
					LEFT JOIN SETUP_CITY SC ON CB.CONTACT_CITY_ID=SC.CITY_ID
					LEFT JOIN SETUP_COUNTY SCO ON CB.CONTACT_COUNTY_ID=SCO.COUNTY_ID
				WHERE 
					CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
					AND
					CONTACT_ID = #attributes.tax_address_id#
			</cfquery>
		<cfelse>
			<cfquery name="GET_CONSUMER_BRANCH" datasource="#DSN#">
				SELECT 
					SC.CITY_NAME,SC.CITY_ID,SCO.COUNTY_NAME,SCO.COUNTY_ID,CB.COMPBRANCH_ADDRESS AS CONTACT_ADDRESS,CB.COMPBRANCH__NAME AS CONTACT_NAME,CB.COMPBRANCH_ID AS CONTACT_ID,CB.COMPBRANCH_POSTCODE AS CONTACT_POSTCODE
					FROM 
						COMPANY_BRANCH CB
						LEFT JOIN SETUP_CITY SC ON CB.CITY_ID=SC.CITY_ID
						LEFT JOIN SETUP_COUNTY SCO ON CB.COUNTY_ID=SCO.COUNTY_ID
					WHERE 
						COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">
						AND
						COMPBRANCH_ID = #attributes.tax_address_id#
			</cfquery>
		</cfif>
		<cfset attributes.tax_address= GET_CONSUMER_BRANCH.CONTACT_ADDRESS>
		<cfset attributes.city_id = GET_CONSUMER_BRANCH.CITY_ID>
		<cfset attributes.county_id = GET_CONSUMER_BRANCH.COUNTY_ID>
	</cfif>
	<cfset attributes.shipment_id = get_rows.SHIPMENT_ID>
	<cfset attributes.payment_id = get_rows.PAYMENT_ID>
	<cfset gross_total_ = len(get_total.T_TL_PRICE_KDVSIZ)?get_total.T_TL_PRICE_KDVSIZ:0>
	<cfset discount_total_ = 0>
	<cfset net_total_ = len(get_total.T_TL_PRICE)?get_total.T_TL_PRICE:0>
	<cfset tax_total_ = net_total_ - gross_total_>
	<cfset new_date = now()>
	<cfset indirim_total_ = 0>
	<cfset attributes.ship_method_id = 1>
	<!--- <cfset attributes.PROCESS_STAGE = session_base.PROCESS_STAGE> --->
	<cfif isdefined("attributes.order_detail") and len(attributes.order_detail)>
		<cfset attributes.order_detail = attributes.order_detail>
	</cfif>
	<cfif isdefined("attributes.payment_id") and attributes.payment_id eq 3>
		<cfset attributes.order_detail = attributes.order_detail&' - '&attributes.account_name>
	</cfif>
	
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="SET_GENERAL_PAPERS" datasource="#DSN#">
				UPDATE
					#dsn3#.GENERAL_PAPERS
				SET
					ORDER_NUMBER = ORDER_NUMBER+1
				WHERE
					PAPER_TYPE = 0 AND
					ZONE_TYPE = 1
			</cfquery>
			<cfquery name="GET_GENERAL_PAPERS"  datasource="#DSN#">
				SELECT 
					ORDER_NO,
					ORDER_NUMBER 
				FROM 
					#dsn3#.GENERAL_PAPERS 
				WHERE 
					PAPER_TYPE = 0 AND
					ZONE_TYPE = 1
			</cfquery>
			
			<cfset temp_order_number = '#get_general_papers.order_no#-#get_general_papers.order_number#'>
			<cfquery name="ADD_ORDER" datasource="#DSN#" result="GET_MAX_ORDER">
				INSERT INTO
					#dsn3#.ORDERS
					(
						WRK_ID,
						ORDER_NUMBER,
						ORDER_CURRENCY,
						ORDER_STATUS,
						PRIORITY_ID, 
						COMMETHOD_ID,
						<cfif isdefined("attributes.deliverdate") and len(attributes.deliverdate)>
							DELIVERDATE,
						</cfif>
						<cfif isdefined("session.pp.userid")>
							PARTNER_ID,
							COMPANY_ID,
						<cfelseif isdefined("session.ww.userid")>
							CONSUMER_ID,
						<cfelseif isdefined("arguments.watalogy_partner") and  isdefined("arguments.company_id")>
							PARTNER_ID,
							COMPANY_ID,
						</cfif>
						<cfif isdefined("attributes.payment_id") and len(attributes.payment_id)>
							PAYMETHOD,
						<cfelseif isdefined("card_paymethod_id") and len(card_paymethod_id)>
							CARD_PAYMETHOD_ID,
							CARD_PAYMETHOD_RATE,
						</cfif>
						SHIP_ADDRESS,
						SHIP_ADDRESS_ID,
						TAX_ADDRESS,
						TAX_ADDRESS_ID,
						COUNTY_ID,
						CITY_ID,
						ORDER_HEAD,
						ORDER_DETAIL,
						GROSSTOTAL,
						TAXTOTAL,
						OTV_TOTAL,
						DISCOUNTTOTAL,
						NETTOTAL,
						INCLUDED_KDV,
						OTHER_MONEY,
						OTHER_MONEY_VALUE,
						PURCHASE_SALES,
						RECORD_DATE,
						RECORD_IP,
						RECORD_CON,
						RECORD_PAR,
						RECORD_EMP,
						ORDER_ZONE
						,SHIP_METHOD
						,RESERVED
						,PROJECT_ID
						,ORDER_DATE
						,ORDER_STAGE
						,ORDER_EMPLOYEE_ID,
						DUE_DATE,
						REF_NO,
						SA_DISCOUNT,
						GENERAL_PROM_ID,
						GENERAL_PROM_LIMIT,
						GENERAL_PROM_AMOUNT,
						GENERAL_PROM_DISCOUNT, 
						FREE_PROM_ID,
						FREE_PROM_LIMIT,
						FREE_PROM_AMOUNT,
						FREE_PROM_STOCK_ID,
						FREE_STOCK_PRICE,
						FREE_STOCK_MONEY,
						FREE_PROM_COST,
						IS_ENDUSER_PRICE,
						IS_MEMBER_RISK,
						DELIVER_DEPT_ID,
						REF_COMPANY_ID,
						REF_PARTNER_ID,
						LOCATION_ID,
						ORDER_PAYMENT_VALUE 
					)
				VALUES
					(
						'#wrk_id#',
						'#temp_order_number#',
						-1,
						1,
						1, 
						'',
						<cfif isdefined("attributes.deliverdate") and len(attributes.deliverdate)>#attributes.deliverdate#,</cfif>
						<cfif isdefined("session.pp.userid")>
							#session.pp.userid#,
							#session.pp.company_id#,
						<cfelseif isdefined("session.ww.userid")>
							#session.ww.userid#,
						<cfelseif isdefined("arguments.partner_id") and  isdefined("arguments.company_id")>
							#arguments.partner_id#,
							#arguments.company_id#,
						</cfif>
						<cfif isdefined("attributes.payment_id") and len(attributes.payment_id)>
							#attributes.payment_id#,
						<cfelseif isdefined("card_paymethod_id") and len(card_paymethod_id)>
							#listfirst(card_paymethod_id)#,
							<cfif listlen(card_paymethod_id) gt 1>#listgetat(card_paymethod_id,2,',')#<cfelse>NULL</cfif>,
						</cfif>
						'#attributes.ship_address#',
						#attributes.ship_address_id#,
						'#attributes.tax_address#',
						#attributes.tax_address_id#,
						<cfif isdefined("attributes.county_id") and len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.city_id") and len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.order_head_') and len(attributes.order_head_)>'#attributes.order_head_#'<cfelseif isdefined("session.ep")>'B2B İnternetten Sipariş'<cfelse>'B2B İnternetten Sipariş'</cfif>,
						<cfif isdefined("attributes.order_detail")>'#attributes.order_detail#'<cfelse>NULL</cfif>,
						#gross_total_#,
						#tax_total_#,
						0,
						#discount_total_#,
						#net_total_#,
						1,
						'TL',
						NULL,
						1,
						#now()#,
						'#CGI.REMOTE_ADDR#',
						<cfif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
						<cfif isdefined("session.pp.userid")>#session.pp.userid#<cfelse>NULL</cfif>,
						<cfif isdefined("session.ep.userid")>#session.ep.userid#<cfelse>NULL</cfif>,
						0
						<cfif isdefined("attributes.shipment_id") and len(attributes.shipment_id)>,#attributes.shipment_id#<cfelse>,NULL</cfif>
						,1
						,NULL
						,#new_date#
						,''
						,<cfif isdefined("GET_WORK_POS") and GET_WORK_POS.recordcount and len(GET_WORK_POS.EMPLOYEE_ID)>#GET_WORK_POS.employee_id#<cfelse>88</cfif>,
						<cfif isdefined("order_due_date") and len(order_due_date)>#order_due_date#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.ref_no") and len(attributes.ref_no)>'#attributes.ref_no#'<cfelse>NULL</cfif>,
						#indirim_total_#,
						<cfif isdefined("attributes.general_prom_id") and len(attributes.general_prom_id)>#attributes.general_prom_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.general_prom_limit") and len(attributes.general_prom_limit)>#attributes.general_prom_limit#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.general_prom_amount") and len(attributes.general_prom_amount)>#attributes.general_prom_amount#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.general_prom_discount") and len(attributes.general_prom_discount)>#attributes.general_prom_discount#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.free_prom_id") and len(attributes.free_prom_id)>#attributes.free_prom_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.free_prom_limit") and len(attributes.free_prom_limit)>#attributes.free_prom_limit#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.free_prom_amount") and len(attributes.free_prom_amount)>#attributes.free_prom_amount#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.free_prom_stock_id") and len(attributes.free_prom_stock_id)>#attributes.free_prom_stock_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.free_stock_price") and len(attributes.free_stock_price)>#attributes.free_stock_price#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.free_stock_money") and len(attributes.free_stock_money)>'#attributes.free_stock_money#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.free_prom_cost") and len(attributes.free_prom_cost)>#attributes.free_prom_cost#<cfelse>NULL</cfif>,
						<cfif isDefined("attributes.is_price_standart")>1<cfelse>0</cfif>,<!--- son kullanıcı fiyatı bilgisi --->
						1,
						<cfif isdefined("attributes.sale_department_id") and len(attributes.sale_department_id)>#attributes.sale_department_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.ref_company_id") and len(attributes.ref_company_id)>#attributes.ref_company_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.ref_partner_id") and len(attributes.ref_partner_id)>#attributes.ref_partner_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.sale_location_id") and len(attributes.sale_location_id)>#attributes.sale_location_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.paymethod_type") and listfind("2,4",attributes.paymethod_type) and isdefined("cc_paym_id_info")><!--- kredi kartı ile ödemişse ödeyeceği tutar 0'dır --->
							0
						<cfelse>
							<cfif isdefined('attributes.order_payment_value') and len(attributes.order_payment_value)>#attributes.order_payment_value#<cfelse>NULL</cfif>
						</cfif> 
					)
			</cfquery> 
			<cfset get_max_order.max_id = get_max_order.identitycol>
			
			<cfquery name="get_setup_money" datasource="#DSN#">
				SELECT * FROM #dsn2#.SETUP_MONEY
			</cfquery>
			<cfif get_setup_money.recordcount>
				<cfoutput query="get_setup_money">
					<cfquery name="ADD_MONEY_CREDIT_USED" datasource="#DSN#">
						INSERT INTO
							#dsn3#.ORDER_MONEY
							(
								MONEY_TYPE,
								ACTION_ID,
								RATE1,
								RATE2,
								IS_SELECTED
							)
							VALUES
							(
								'#get_setup_money.money#',
								#get_max_order.max_id#,
								#get_setup_money.rate1#,
								#get_setup_money.rate2#,
								<cfif get_setup_money.money is 'TL'>1<cfelse>0</cfif>
							)
					</cfquery>				
				</cfoutput>
			</cfif>
			<cfoutput query="get_rows">
						<cf_date tarih="attributes.deliver_date">
						
						<cfset satir_fiyati = PRICE_TL / (quantity*prom_stock_amount)>
						<cfset oth_m_val = PRICE_TL / (quantity*prom_stock_amount)>
						
						
						<cfset 'net_maliyet#currentrow#' = ''>
						<cfset 'extra_cost#currentrow#' = ''>
						<cfset 'row_spect_id#currentrow#' = ''>
						<cfquery name="GET_PRODUCTION" datasource="#DSN#">
							SELECT IS_PRODUCTION,MANUFACT_CODE,ISNULL(IS_GIFT_CARD,0) IS_GIFT_CARD,GIFT_VALID_DAY FROM #dsn3#.PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
						</cfquery>
						<cfif not (len(get_rows.spec_var_id) and len(get_rows.spec_var_name))>
							<cfif is_spec eq 1>
								<cfset this_spec_ = 1>
								<cfset this_row_ = currentrow>
								<cfinclude template="add_orderww_spect.cfm">
							<cfelse>
								<cfif get_production.is_production and len(get_rows.spec_var_id)>
									<cfif is_spec eq 1>
										<cfset this_spec_ = 1>
									<cfelse>
										<cfset this_spec_ = 0>
									</cfif>
									<cfset this_row_ = currentrow>
									<cfinclude template="add_orderww_spect.cfm">
								</cfif>
							</cfif>
						</cfif>
						<cfif (not isdefined('row_spect_id#currentrow#') or not len(evaluate('row_spect_id#currentrow#')))>				
							<cfquery name="GET_PRODUCT_COST" datasource="#DSN#" maxrows="1">
								SELECT 
									PC.PURCHASE_NET_SYSTEM,
									PC.PURCHASE_EXTRA_COST_SYSTEM
								FROM 
									#dsn3#.PRODUCT_COST PC,
									#dsn3#.PRODUCT P
								WHERE 
									P.PRODUCT_ID = PC.PRODUCT_ID AND
									PC.PRODUCT_COST IS NOT NULL AND
									PC.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,now())#"> AND 
									PC.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
									P.IS_COST = 1
								ORDER BY 
									PC.START_DATE DESC,
									PC.RECORD_DATE DESC
							</cfquery>
							<cfif get_product_cost.recordcount>
								<cfset 'net_maliyet#currentrow#' = get_product_cost.purchase_net_system>
								<!--- <cfset 'cost_id#currentrow#' = get_product_cost.product_cost_id> --->
								<cfset 'extra_cost#currentrow#' = get_product_cost.purchase_extra_cost_system>
							</cfif>
						</cfif>
						<cfscript>
							if(len(discount1)) row_disc1=discount1; else row_disc1=0;
							if(len(discount2)) row_disc2=discount2; else row_disc2=0;
							if(len(discount3)) row_disc3=discount3; else row_disc3=0;
							if(len(discount4)) row_disc4=discount4; else row_disc4=0;
							if(len(discount5)) row_disc5=discount5; else row_disc5=0;
							order_disc_rate_=((100-row_disc1) * (100-row_disc2) * (100-row_disc3) * (100-row_disc4) * (100-row_disc5));
							satir_indirimli_fiyat=((satir_fiyati*order_disc_rate_)/10000000000);
							row_nettotal = satir_indirimli_fiyat * quantity * prom_stock_amount;
							if (isDefined("attributes.is_price_standart") and isDefined("attributes.consumer_info"))
							{
								if(len(prom_amount_discount))
									for(k=1;k lte attributes.kur_say;k=k+1)
										if(price_standard_money eq evaluate("hidden_rd_money_#k#"))
											row_nettotal = row_nettotal - (prom_amount_discount * evaluate("txt_rate2_#k#")/evaluate("txt_rate1_#k#") * quantity * prom_stock_amount);
								if(len(prom_discount))
									row_nettotal = row_nettotal * (100-prom_discount) /100;
								
								row_taxtotal = wrk_round(row_nettotal * (tax/100));
								row_lasttotal = row_nettotal + row_taxtotal;
								other_money_value = row_nettotal;
								for(k=1;k lte attributes.kur_say;k=k+1)
									if(price_standard_money eq evaluate("hidden_rd_money_#k#"))
										other_money_value = other_money_value / evaluate("txt_rate2_#k#");
							}
							else
							{
								if(len(prom_amount_discount))
									for(k=1;k lte attributes.kur_say;k=k+1)
										if(price_money eq evaluate("hidden_rd_money_#k#"))
											row_nettotal = row_nettotal - (prom_amount_discount * evaluate("txt_rate2_#k#")/evaluate("txt_rate1_#k#") * quantity * prom_stock_amount);
								if(len(prom_discount))
									row_nettotal = row_nettotal * (100-prom_discount) /100;
								row_taxtotal = wrk_round(row_nettotal * (tax/100));
								row_lasttotal = row_nettotal + row_taxtotal;
								other_money_value = row_nettotal;
							}
						</cfscript>
						
						<cfif isDefined('attributes.is_spect_control') and attributes.is_spect_control eq 1>
							<cfif (len(get_rows.spec_var_id) and len(get_rows.spec_var_name)) or (isdefined('row_spect_id#currentrow#') and len(evaluate('row_spect_id#currentrow#')))>
								<cfquery name="GET_SPEC_STAT" dbtype="query">
									SELECT 
										* 
									FROM 
										GET_SPECT_MAIN 
									WHERE 
										<cfif len(get_rows.spec_var_id) and len(get_rows.spec_var_name)>
											SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_rows.spec_var_id#">
										<cfelse>
											SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('row_spect_id#currentrow#')#">
										</cfif>
								</cfquery> 
								
								<cfif get_spec_stat.spect_status eq 0>
									<script language="javascript"> 
										alert('#get_spec_stat.spect_main_name# spect ürünü aktif değil!');
										window.history.back(-1);
									</script>
								</cfif>  
							</cfif>
						</cfif>
						
						<cfquery name="ADD_ORDER_ROW" datasource="#DSN#" result="GET_MAX_ROW">
							INSERT INTO
								#dsn3#.ORDER_ROW
								(
									WRK_ROW_ID,
									CATALOG_ID,
									UNIQUE_RELATION_ID,
									ORDER_ROW_CURRENCY,
									ORDER_ID,
									PRODUCT_ID,
									STOCK_ID,
									QUANTITY,
									UNIT,
									UNIT_ID,
									PRICE,
									LIST_PRICE,
									TAX,
									DUEDATE,
									PRODUCT_NAME,
									PRODUCT_NAME2,
									BASKET_EXTRA_INFO_ID,
									DELIVER_DATE,
									DELIVER_DEPT,
									DELIVER_LOCATION,
									DISCOUNT_1,
									DISCOUNT_2,
									DISCOUNT_3,
									DISCOUNT_4,
									DISCOUNT_5,	
									DISCOUNT_6,
									DISCOUNT_7,
									DISCOUNT_8,
									DISCOUNT_9,
									DISCOUNT_10,
									OTHER_MONEY,
									OTHER_MONEY_VALUE,
									<cfif len(get_rows.spec_var_id) and len(get_rows.spec_var_name)>
										SPECT_VAR_ID,
										SPECT_VAR_NAME,
									<cfelseif isdefined('row_spect_id#currentrow#') and len(evaluate('row_spect_id#currentrow#'))>
										SPECT_VAR_ID,
										SPECT_VAR_NAME,
									</cfif>
									PRICE_OTHER,
									COST_PRICE,
									EXTRA_COST,
									MARJ,
									NETTOTAL,
									PROM_COMISSION,
									PROM_COST,
									DISCOUNT_COST,
									PROM_ID,
									IS_PROMOTION,
									IS_COMMISSION,
									PRODUCT_MANUFACT_CODE,
									RESERVE_TYPE,
									OTV_ORAN,
									OTVTOTAL,
									IS_PRODUCT_PROMOTION_NONEFFECT,
									IS_GENERAL_PROM,
									PROM_STOCK_ID,
									PRICE_CAT,
									LOT_NO
									<cfif isdefined("get_rows.version_no")>,VERSION_NO</cfif>
								)
							VALUES
								(
									<cfif isdefined("session.pp.userid")>
										'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.pp.userid##round(rand()*100)##currentrow#',
									<cfelseif isdefined("session.ww.userid")>
										'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ww.userid##round(rand()*100)##currentrow#',
									<cfelseif isdefined("session.ep.userid")>
										'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##currentrow#',
									<cfelse>
										'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')#0#round(rand()*100)##currentrow#',
									</cfif>
									NULL,
									NULL,
									-1,
									#get_max_order.max_id#,
									#product_id#,
									#stock_id#,
									#quantity*prom_stock_amount#,
									'#main_unit#',
									#product_unit_id#,
									#satir_fiyati#,
									#satir_fiyati#,
									#tax#,
									<cfif isdefined("attributes.duedate#currentrow#") and len(evaluate("attributes.duedate#currentrow#"))>
										#evaluate("attributes.duedate#currentrow#")#,
									<cfelseif isdefined("order_row_due_date") and len(order_row_due_date)>
										#order_row_due_date#,
									<cfelse>
										0,
									</cfif>
									'#product_name#',
									<cfif isdefined('attributes.order_row_detail_#currentrow#') and len(evaluate("attributes.order_row_detail_#currentrow#"))>
										'#wrk_eval("attributes.order_row_detail_#currentrow#")#',
									<cfelse>
										<cfif isdefined("attributes.serial_no_#currentrow#")>
											'#wrk_eval("attributes.serial_no_#currentrow#")#',
										<cfelse>
											NULL,
										</cfif>
									</cfif>
									<cfif isdefined('attributes.basket_info_type_id_#currentrow#') and len(evaluate("attributes.basket_info_type_id_#currentrow#"))>
										#evaluate("attributes.basket_info_type_id_#currentrow#")#,
									<cfelse>
										NULL,
									</cfif>
									<cfif isdefined("attributes.deliver_date") and isdate(evaluate('attributes.deliver_date'))>#attributes.deliver_date#<cfelse>NULL</cfif>,
									<cfif isdefined("attributes.deliver_dept#currentrow#") and len(trim(evaluate("attributes.deliver_dept#currentrow#"))) and len(listfirst(evaluate("attributes.deliver_dept#currentrow#"),"-"))>
										#listfirst(evaluate("attributes.deliver_dept#currentrow#"),"-")#,
									<cfelse>
										NULL,
									</cfif>
									<cfif isdefined("attributes.deliver_dept#currentrow#") and listlen(trim(evaluate("attributes.deliver_dept#currentrow#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#currentrow#"),"-"))>
										#listlast(evaluate("attributes.deliver_dept#currentrow#"),"-")#,
									<cfelse>
										NULL,
									</cfif>
									<cfif len(discount1)>#discount1#<cfelse>0</cfif>,
									<cfif len(discount2)>#discount2#<cfelse>0</cfif>,
									<cfif len(discount3)>#discount3#<cfelse>0</cfif>,
									<cfif len(discount4)>#discount4#<cfelse>0</cfif>,
									<cfif len(discount5)>#discount5#<cfelse>0</cfif>,
									0,
									0,
									0,
									0,
									0,
									'TL',
									#other_money_value#,
									<cfif len(get_rows.spec_var_id) and len(get_rows.spec_var_name)>
										#get_rows.spec_var_id#,
										'#get_rows.spec_var_name#',
									<cfelseif isdefined('row_spect_id#currentrow#') and len(evaluate('row_spect_id#currentrow#'))>
										#evaluate('row_spect_id#currentrow#')#,
										'#product_name#',
									</cfif>
									#satir_fiyati#,
									<cfif len(evaluate('net_maliyet#currentrow#'))>#evaluate('net_maliyet#currentrow#')#<cfelse>0</cfif>,
									<cfif len(evaluate('extra_cost#currentrow#'))>#evaluate('extra_cost#currentrow#')#<cfelse>0</cfif>,
									<cfif isdefined('attributes.marj#currentrow#') and len(evaluate('attributes.marj#currentrow#'))>#evaluate('attributes.marj#currentrow#')#<cfelse>0</cfif>,
									#row_nettotal#,
									<cfif len(prom_discount)>#prom_discount#,<cfelse>NULL,</cfif>
									<cfif len(prom_cost)>#prom_cost#,<cfelse>0,</cfif>
									<cfif len(prom_amount_discount)>#prom_amount_discount#,<cfelse>0,</cfif>
									<cfif len(prom_id)>#prom_id#,<cfelse>null,</cfif>
									<cfif len(is_prom_asil_hediye)>#is_prom_asil_hediye#,<cfelse>NULL,</cfif>				
									<cfif len(is_commission) and is_commission eq 1>1,<cfelse>0,</cfif>
									'#get_production.manufact_code#',
									-1,
									0,
									0,
									<cfif len(is_product_promotion_noneffect)>#is_product_promotion_noneffect#<cfelse>NULL</cfif>,
									<cfif len(is_general_prom)>#is_general_prom#<cfelse>NULL</cfif>,
									<cfif len(is_prom_asil_hediye) and is_prom_asil_hediye and len(prom_main_stock_id)>#prom_main_stock_id#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.prj_discount_price_cat') and len(attributes.prj_discount_price_cat)>#attributes.prj_discount_price_cat#<cfelse>NULL</cfif>,
									<cfif len(lot_no)>'#lot_no#'<cfelse>NULL</cfif>
									<cfif isdefined("get_rows.version_no")>,'#get_rows.version_no#'</cfif>
								)
						</cfquery>
	
						<cfif IsDefined("arguments.subscription_id") and len(arguments.subscription_id)>
							<cfquery name="ADD_CONTRACT_ROW" datasource="#DSN#">
								INSERT INTO
									#DSN3#.SUBSCRIPTION_CONTRACT_ROW
								(
									SUBSCRIPTION_ID,
									PRODUCT_NAME,
									STOCK_ID,
									PRODUCT_ID,
									AMOUNT,
									UNIT,
									UNIT_ID,					
									TAX,
									PRICE,
									DISCOUNT1,					
									DISCOUNT2,
									DISCOUNT3,
									DISCOUNT4,
									DISCOUNT5,
									DISCOUNT6,
									DISCOUNT7,
									DISCOUNT8,
									DISCOUNT9,
									DISCOUNT10,
									DISCOUNTTOTAL,
									GROSSTOTAL,
									NETTOTAL,
									TAXTOTAL,
									SPECT_VAR_ID,
									SPECT_VAR_NAME,
									LOT_NO,
									OTHER_MONEY,
									OTHER_MONEY_VALUE,					
									PRICE_OTHER,
									DISCOUNT_COST,
									DELIVER_DATE,
									OTV_ORAN,
									OTVTOTAL,
									EXTRA_COST,
									LIST_PRICE
								)
								VALUES
								(
									<cfif len(arguments.subscription_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#"><cfelse>NULL</cfif>,
									<cfif len(product_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#product_name#"><cfelse>NULL</cfif>,
									<cfif len(stock_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"><cfelse>NULL</cfif>,
									<cfif len(product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"><cfelse>NULL</cfif>,
									<cfqueryparam cfsqltype="cf_sql_float" value="#quantity*prom_stock_amount#">,
									<cfif len(main_unit)><cfqueryparam cfsqltype="cf_sql_varchar" value="#main_unit#"><cfelse>NULL</cfif>,
									<cfif len(product_unit_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#product_unit_id#"><cfelse>NULL</cfif>,
									<cfif len(tax)><cfqueryparam cfsqltype="cf_sql_float" value="#tax#"><cfelse>NULL</cfif>,
									<cfif len(satir_fiyati)><cfqueryparam cfsqltype="cf_sql_float" value="#satir_fiyati#"><cfelse>NULL</cfif>,
									<cfif len(discount1)><cfqueryparam cfsqltype="cf_sql_float" value="#discount1#"><cfelse>NULL</cfif>,					
									<cfif len(discount2)><cfqueryparam cfsqltype="cf_sql_float" value="#discount2#"><cfelse>NULL</cfif>,
									<cfif len(discount3)><cfqueryparam cfsqltype="cf_sql_float" value="#discount3#"><cfelse>NULL</cfif>,
									<cfif len(discount4)><cfqueryparam cfsqltype="cf_sql_float" value="#discount4#"><cfelse>NULL</cfif>,
									<cfif len(discount5)><cfqueryparam cfsqltype="cf_sql_float" value="#discount5#"><cfelse>NULL</cfif>,
									0,
									0,
									0,
									0,
									0,
									<cfif len(satir_indirimli_fiyat)><cfqueryparam cfsqltype="cf_sql_float" value="#satir_indirimli_fiyat#"><cfelse>NULL</cfif>,
									<cfif len(row_lasttotal)><cfqueryparam cfsqltype="cf_sql_float" value="#row_lasttotal#"><cfelse>NULL</cfif>,
									<cfif len(row_nettotal)><cfqueryparam cfsqltype="cf_sql_float" value="#row_nettotal#"><cfelse>NULL</cfif>,
									<cfif len(row_taxtotal)><cfqueryparam cfsqltype="cf_sql_float" value="#row_taxtotal#"><cfelse>NULL</cfif>,
									<cfif len(get_rows.spec_var_id) and len(get_rows.spec_var_name)>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#get_rows.spec_var_id#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_rows.spec_var_name#">,
									<cfelseif isdefined('row_spect_id#currentrow#') and len(evaluate('row_spect_id#currentrow#'))>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('row_spect_id#currentrow#')#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#product_name#">,
									<cfelse>
										NULL,
										NULL,
									</cfif>
									<cfif isdefined('lot_no') and len(lot_no)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#lot_no#"><cfelse>NULL</cfif>,
									'TL',
									<cfif isdefined("other_money_value") and len(other_money_value)><cfqueryparam cfsqltype="cf_sql_float" value="#other_money_value#"><cfelse>NULL</cfif>,					
									<cfif isdefined('satir_fiyati') and len(satir_fiyati)><cfqueryparam cfsqltype="cf_sql_float" value="#satir_fiyati#"><cfelse>NULL</cfif>,
									<cfif isdefined('prom_amount_discount') and len(prom_amount_discount)><cfqueryparam cfsqltype="cf_sql_float" value="#prom_amount_discount#"><cfelse>NULL</cfif>,
									<cfif isdefined("attributes.deliver_date") and isdate('attributes.deliver_date')><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.deliver_date#"><cfelse>NULL</cfif>,
									0,
									0,
									<cfif len(evaluate('extra_cost#currentrow#'))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('extra_cost#currentrow#')#"><cfelse>0</cfif>,
									<cfif isdefined('satir_fiyati') and len(satir_fiyati)><cfqueryparam cfsqltype="cf_sql_float" value="#satir_fiyati#"><cfelse>NULL</cfif>
								)
							</cfquery>
	
							<cfif len( COUNTER_TYPE_ID )> <!--- Sayaç tipi tanımlanmış bir ürün satın alınmışsa aboneye sayaç tanımlanır --->
								<cfset counter_number = "#randRange(1000, 9999, 'CFMX_COMPAT')#_#randRange(1000, 9999, 'CFMX_COMPAT')#_#randRange(1000, 9999, 'CFMX_COMPAT')#"  />
								
								<cfset counter = createObject("component", "V16.sales.cfc.counter") />
								<cfset counter.insert(
									subscription_id: arguments.subscription_id,
									counter_number: counter_number,
									counter_type: COUNTER_TYPE_ID,
									product_id: product_id,
									stock_id: stock_id,
									amount: quantity*prom_stock_amount,
									unit_id: product_unit_id,
									unit_name: main_unit,
									price_catid: ( isdefined('attributes.prj_discount_price_cat') and len(attributes.prj_discount_price_cat) ) ? attributes.prj_discount_price_cat : '',
									price: satir_fiyati,
									money: other_money_value
								) />
							</cfif>
	
						</cfif>
	
						<cfset get_max_row.max_id = get_max_row.identitycol>
						<cfif len(demand_id)>
							<cfquery name="UPD_DEMAND" datasource="#DSN#">
								UPDATE #dsn3#.ORDER_DEMANDS SET GIVEN_AMOUNT = GIVEN_AMOUNT + #quantity# WHERE DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#demand_id#">
							</cfquery>
							<cfquery name="ADD_DEMAND_ROW" datasource="#DSN#">
								INSERT INTO
									#dsn3#.ORDER_DEMANDS_ROW
									(
										DEMAND_ID,
										ORDER_ID,
										ORDER_ROW_ID,
										QUANTITY
									)
								VALUES
									(
										#demand_id#,
										#get_max_order.max_id#,
										#get_max_row.max_id#,
										#quantity#
									)
							</cfquery>
						</cfif>
						<cfif get_production.is_gift_card eq 1><!--- hediye kartı ise hediye kartı kaydı atılıyor --->
							<cfloop from="1" to="#quantity#" index="kk">
								<cfset letters = "1,2,3,4,5,6,7,8,9,0">
								<cfset gift_card_no_last = ''>
								<cfif isdefined('session.pp.userid')>
									<cfset gift_card_no = '#dateformat(now(),'YYYY')-622##dateformat(now(),'MMDD')##timeformat(now(),'HH')##GET_MAX_ROW.MAX_ID#'>
								<cfelseif isdefined('session.ww.userid')>
									<cfset gift_card_no = '#dateformat(now(),'YYYY')-622##dateformat(now(),'MMDD')##timeformat(now(),'HH')##GET_MAX_ROW.MAX_ID#'>
								</cfif>
								<cfset gift_card_no = left(gift_card_no,11)>
								<cfset remain_len = 16-len(gift_card_no)>
								<cfloop from="1" to="#remain_len#" index="ind">				     
									 <cfset random = RandRange(1, 10)>
									 <cfset gift_card_no_last = "#gift_card_no_last##ListGetAt(letters,random,',')#">
								</cfloop>
								<cfset gift_card_no = "#gift_card_no##gift_card_no_last#">
								<cfquery name="ADD_MONEY_CREDIT" datasource="#DSN#">
									INSERT INTO
										#dsn3#.ORDER_MONEY_CREDITS
										(
											ORDER_ID,
											CREDIT_RATE,
											MONEY_CREDIT,
											VALID_DATE,
											MONEY_CREDIT_STATUS,
											USE_CREDIT,
											IS_TYPE,
											GIFT_CARD_NO,
											RECORD_IP,
											RECORD_DATE
											<cfif isdefined('session.pp.userid')>
												,COMPANY_ID
											<cfelseif isdefined('session.ww.userid')>
												,RECORD_CONS
												,CONSUMER_ID
											</cfif>
										)
										VALUES
										(
											#get_max_order.max_id#,
											0,
											#row_lasttotal/quantity#,
											#dateadd('d',get_production.gift_valid_day,new_date)#,
											0,
											0,
											1,
											'#left(gift_card_no,16)#',
											'#cgi.remote_addr#',
											#now()#
											<cfif isdefined('session.pp.userid')>
												,#attributes.company_id#
											<cfelseif isdefined('session.ww.userid')>
												,#session.ww.userid#
												,#attributes.consumer_id#
											</cfif>
										)
								</cfquery>								
							</cfloop>
						</cfif>
			</cfoutput>
			<!--- kazanılan parapuanlar kaydediliyor --->
			<cfif isdefined("attributes.order_money_credit_count") and attributes.order_money_credit_count gt 0>
				 <cfloop from="1" to="#order_money_credit_count#" index="crdt_indx">
					<cfset credit_value = evaluate("attributes.order_total_money_credit_#crdt_indx#")>
					<cfset credit_rate = evaluate("attributes.credit_rate_#crdt_indx#")>
					<cfset valid_date = evaluate("attributes.credit_valid_date_#crdt_indx#")>
					<cfif len(valid_date)><cf_date tarih="valid_date"></cfif>
					<cfif len(credit_value) and credit_value gt 0>
					<cfquery name="ADD_MONEY_CREDIT" datasource="#DSN#">
						INSERT INTO
							#dsn3#.ORDER_MONEY_CREDITS
							(
								ORDER_ID,
								CREDIT_RATE,
								MONEY_CREDIT,
								VALID_DATE,
								MONEY_CREDIT_STATUS,
								USE_CREDIT,
								IS_TYPE,
								RECORD_IP,
								RECORD_DATE
								<cfif isdefined('session.pp.userid')>
									,COMPANY_ID
								<cfelseif isdefined('session.ww.userid')>
									,RECORD_CONS
									,CONSUMER_ID
								</cfif>
							)
							VALUES
							(
								#get_max_order.max_id#,
								#credit_rate#,
								#credit_value#,
								<cfif len(valid_date)>#valid_date#<cfelse>NULL</cfif>,
								0,
								0,
								0,
								'#cgi.remote_addr#',
								#now()#
								<cfif isdefined('session.pp.userid')>
									,#attributes.company_id#
								<cfelseif isdefined('session.ww.userid')>
									,#session.ww.userid#
									,#attributes.consumer_id#
								</cfif>
							)
					</cfquery>
					</cfif>
				</cfloop>
			</cfif>
			<cfquery name="GET_INV_ACC" datasource="#DSN#">
				SELECT * FROM #dsn3#.SETUP_INVOICE
			</cfquery>
			
			<!--- Kullanılan hediye çeki kapatılıyor --->
			<cfif isdefined('attributes.gift_money_credit_id') and len(attributes.gift_money_credit_id) and len(attributes.gift_card_value)>
				<cfset used_money_credit_ = filterNum(attributes.gift_card_value)>
				<cfquery name="UPD_CREDIT" datasource="#DSN#">
					UPDATE
						#dsn3#.ORDER_MONEY_CREDITS
					SET
						USE_CREDIT = MONEY_CREDIT,
						UPDATE_IP = '#cgi.remote_addr#',
						UPDATE_DATE =  #now()#,
						UPDATE_CONS = #session.ww.userid#
					WHERE
						ORDER_CREDIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gift_money_credit_id#">
				</cfquery>
				<cfquery name="GET_MONEY_CREDIT" datasource="#DSN#">
					SELECT USE_CREDIT FROM #dsn3#.ORDER_MONEY_CREDITS WHERE ORDER_CREDIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gift_money_credit_id#">
				</cfquery>
				<cfquery name="ADD_MONEY_CREDIT_USED" datasource="#DSN#">
					INSERT INTO
						#dsn3#.ORDER_MONEY_CREDIT_USED
						(
							ORDER_CREDIT_ID,
							ORDER_ID,
							USED_VALUE,
							USED_DATE
						)
						VALUES
						(
							#attributes.gift_money_credit_id#,
							#get_max_order.max_id#,
							#get_money_credit.use_credit#,
							#now()#
						)
				</cfquery>
				<cfset net_total_ = net_total_ - used_money_credit_>
				<cf_papers paper_type="debit_claim">
				<cfquery name="GET_MONEY_INFO" datasource="#DSN#">
					SELECT 
						MONEY,
						RATE1,
						<cfif isDefined("session.pp")>
							RATEPP2 RATE2
						<cfelseif isDefined("session.ww")>
							RATEWW2 RATE2
						<cfelse>
							RATE2
						</cfif>
					FROM
						#dsn2#.SETUP_MONEY
				</cfquery>
				<cfquery name="GET_PROCESS_CAT_CLAIM_NOTE" datasource="#DSN#">
					SELECT 
						PROCESS_CAT_ID,
						IS_CARI,
						IS_ACCOUNT,
						PROCESS_CAT,
						ACTION_FILE_NAME,
						ACTION_FILE_FROM_TEMPLATE 
					FROM 
						#dsn3#.SETUP_PROCESS_CAT 
					WHERE 
						PROCESS_TYPE = 42
						<cfif isdefined("attributes.company_id") and len(attributes.company_id)>AND IS_PARTNER = 1<cfelse>AND IS_PUBLIC = 1</cfif>
				</cfquery>
				<cfif get_process_cat_claim_note.recordcount>
					<cfscript>
						process_type = 42;
						form.process_cat = get_process_cat_claim_note.process_cat_id;
						is_cari = get_process_cat_claim_note.is_cari;
						is_account = get_process_cat_claim_note.is_account;
						get_process_type.action_file_name = get_process_cat_claim_note.action_file_name;
						get_process_type.action_file_from_template = get_process_cat_claim_note.action_file_from_template;
						action_currency_id = session_base.money;
						attributes.action_value = used_money_credit_;
						attributes.money_type = session_base.money;
						form.money_type = session_base.money;
						process_money_type = session_base.money;
						attributes.project_name = '';
						attributes.project_id = '';
						attributes.other_cash_act_value = used_money_credit_;
						attributes.company_id = attributes.company_id;
						attributes.consumer_id = attributes.consumer_id;
						attributes.employee_id = '';
						attributes.action_detail = '#temp_order_number# Hediye Çeki Karşılığı';
						attributes.action_account_code = '#get_inv_acc.GIFT_CARD#';
						attributes.action_date = new_date;
						attributes.paper_number = '#paper_code & '-' & paper_number#';
						attributes.system_amount = used_money_credit_;
						attributes.expense_center_1 = '';
						attributes.expense_center_2 = '';
						attributes.expense_center_id_1 = '';
						attributes.expense_item_id_1 = '';
						attributes.expense_item_name_1 = '';
						new_dsn_2 = dsn3;
					</cfscript>
					<cfinclude template="../../ch/query/add_debit_claim_note_ic.cfm">
				</cfif>
			</cfif>
	
			<!--- İndirim Kuponu kapatılıyor --->
			<cfif isdefined('attributes.disc_coup_money_credit_id1') and len(attributes.disc_coup_money_credit_id1) and len(attributes.disc_coup_value)>
				<cfloop from="1" to="#attributes.record_num#" index="i">
					<cfset used_money_credit_ = filterNum(attributes.disc_coup_value)>
					<cfquery name="UPD_DISCOUNT_COUP" datasource="#DSN#">
						UPDATE
							#dsn3#.ORDER_MONEY_CREDITS
						SET
							USE_CREDIT = MONEY_CREDIT     
						WHERE
							ORDER_CREDIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.disc_coup_money_credit_id#i#')#">
					</cfquery>
					<cfquery name="GET_MONEY_CREDIT" datasource="#DSN#">
						SELECT USE_CREDIT FROM #dsn3#.ORDER_MONEY_CREDITS WHERE ORDER_CREDIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.disc_coup_money_credit_id#i#')#">
					</cfquery>
					<cfquery name="ADD_MONEY_CREDIT_USED" datasource="#DSN#">
						INSERT INTO
							#dsn3#.ORDER_MONEY_CREDIT_USED
							(
								ORDER_CREDIT_ID,
								ORDER_ID,
								USED_VALUE,
								USED_DATE
							)
							VALUES
							(
								#evaluate('attributes.disc_coup_money_credit_id#i#')#,
								#get_max_order.max_id#,
								#get_money_credit.use_credit#,
								#now()#
							)
					</cfquery>
					<cfset net_total_ = net_total_ - used_money_credit_>
					<cf_papers paper_type="debit_claim">
					<cfquery name="GET_MONEY_INFO" datasource="#DSN#">
						SELECT 
							MONEY,
							RATE1,
							<cfif isDefined("session.pp")>
								RATEPP2 RATE2
							<cfelseif isDefined("session.ww")>
								RATEWW2 RATE2
							<cfelse>
								RATE2
							</cfif>
						FROM
							#dsn2#.SETUP_MONEY
					</cfquery>
					<cfquery name="GET_PROCESS_CAT_CLAIM_NOTE" datasource="#DSN#">
						SELECT 
							PROCESS_CAT_ID,
							IS_CARI,
							IS_ACCOUNT,
							PROCESS_CAT,
							ACTION_FILE_NAME,
							ACTION_FILE_FROM_TEMPLATE 
						FROM 
							#dsn3#.SETUP_PROCESS_CAT 
						WHERE 
							PROCESS_TYPE = 42
							<cfif isdefined("attributes.company_id") and len(attributes.company_id)>AND IS_PARTNER = 1<cfelse>AND IS_PUBLIC = 1</cfif>
					</cfquery>
					<cfif get_process_cat_claim_note.recordcount>
						<cfscript>
							process_type = 42;
							form.process_cat = get_process_cat_claim_note.process_cat_id;
							is_cari = get_process_cat_claim_note.is_cari;
							is_account = get_process_cat_claim_note.is_account;
							get_process_type.action_file_name = get_process_cat_claim_note.action_file_name;
							get_process_type.action_file_from_template = get_process_cat_claim_note.action_file_from_template;
							action_currency_id = session_base.money;
							attributes.action_value = used_money_credit_;
							attributes.money_type = session_base.money;
							form.money_type = session_base.money;
							process_money_type = session_base.money;
							attributes.project_name = '';
							attributes.project_id = '';
							attributes.other_cash_act_value = used_money_credit_;
							attributes.company_id = attributes.company_id;
							attributes.consumer_id = attributes.consumer_id;
							attributes.employee_id = '';
							attributes.action_detail = '#temp_order_number# Hediye Çeki Karşılığı';
							attributes.action_account_code = '#get_inv_acc.GIFT_CARD#';
							attributes.action_date = new_date;
							attributes.paper_number = '#temp_order_number#';
							attributes.system_amount = used_money_credit_;
							attributes.expense_center_1 = '';
							attributes.expense_center_2 = '';
							attributes.expense_center_id_1 = '';
							attributes.expense_item_id_1 = '';
							attributes.expense_item_name_1 = '';
							new_dsn_2 = dsn3;
						</cfscript>
						<cfinclude template="../../ch/query/add_debit_claim_note_ic.cfm">
					</cfif>
				</cfloop>
			</cfif>
			<!--- İndirim Kuponu kapatılıyor --->
			
			<!--- kazanılan parapuanların kullanılması --->
			<cfif isdefined('attributes.money_credit_id') and attributes.money_credit_id eq 1 and len(attributes.money_credit_value)>
				<cfset used_money_credit_ = Replace(attributes.money_credit_value,',','.')>
				<cfquery name="GET_MONEY_CREDITS" datasource="#DSN#">
					SELECT
						ORDER_CREDIT_ID,
						MONEY_CREDIT,
						VALID_DATE
					FROM
						#dsn3#.ORDER_MONEY_CREDITS
					WHERE
						MONEY_CREDIT_STATUS = 1 AND
						MONEY_CREDIT <> 0 AND
						ISNULL(IS_TYPE,0) = 0 AND
						VALID_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
						<cfif isdefined('session.pp.userid')>
							COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
						<cfelse>
							CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
						</cfif>
					ORDER BY
						VALID_DATE
				</cfquery>
				<cfset used_total_ = 0>
				<cfloop query="get_money_credits">
					<cfif used_money_credit_ lte net_total_><cfset row_use_total = get_money_credits.money_credit><cfelse><cfset row_use_total = net_total_></cfif>
					<cfif row_use_total gt 0>
						<cfset used_money_credit_ = used_money_credit_ - row_use_total>
						<cfset used_total_ = used_total_ + row_use_total>
						<cfquery name="ADD_MONEY_CREDIT_USED" datasource="#DSN#">
							INSERT INTO
								#dsn3#.ORDER_MONEY_CREDIT_USED
								(
									ORDER_CREDIT_ID,
									ORDER_ID,
									USED_VALUE,
									USED_DATE
								)
								VALUES
								(
									#get_money_credits.order_credit_id#,
									#get_max_order.max_id#,
									#row_use_total#,
									#now()#
								)
						</cfquery>
						<cfquery name="UPD_MONEY_CREDIT" datasource="#DSN#">
							UPDATE 
								#dsn3#.ORDER_MONEY_CREDITS 
							SET
								USE_CREDIT = USE_CREDIT + #row_use_total#,
								UPDATE_IP = '#cgi.remote_addr#',
								UPDATE_DATE =  #now()#,
								UPDATE_CONS = #session.ww.userid#
								<cfif row_use_total eq get_money_credits.money_credit>
									,MONEY_CREDIT_STATUS = 0 
								</cfif>
							WHERE 
								ORDER_CREDIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_money_credits.order_credit_id#">
						</cfquery>
					</cfif>
				</cfloop>
				<cfif used_total_ gt 0>
					<cf_papers paper_type="debit_claim">
					<cfquery name="GET_MONEY_INFO" datasource="#DSN#">
						SELECT 
							MONEY,
							RATE1,
							<cfif isDefined("session.pp")>
								RATEPP2 RATE2
							<cfelseif isDefined("session.ww")>
								RATEWW2 RATE2
							<cfelse>
								RATE2
							</cfif>
						FROM
							#dsn2#.SETUP_MONEY
					</cfquery>
					<cfquery name="GET_PROCESS_CAT_CLAIM_NOTE" datasource="#DSN#">
						SELECT 
							PROCESS_CAT_ID,
							IS_CARI,
							IS_ACCOUNT,
							PROCESS_CAT,
							ACTION_FILE_NAME,
							ACTION_FILE_FROM_TEMPLATE 
						FROM 
							#dsn3#.SETUP_PROCESS_CAT 
						WHERE 
							PROCESS_TYPE = 42
							<cfif isdefined("attributes.company_id") and len(attributes.company_id)>AND IS_PARTNER = 1<cfelse>AND IS_PUBLIC = 1</cfif>
					</cfquery>
					<cfif get_process_cat_claim_note.recordcount>
						<cfscript>
							process_type = 42;
							form.process_cat = get_process_cat_claim_note.process_cat_id;
							is_cari = get_process_cat_claim_note.is_cari;
							is_account = get_process_cat_claim_note.is_account;
							get_process_type.action_file_name = get_process_cat_claim_note.action_file_name;
							get_process_type.action_file_from_template = get_process_cat_claim_note.action_file_from_template;
							action_currency_id = session_base.money;
							attributes.action_value = used_total_;
							attributes.money_type = session_base.money;
							form.money_type = session_base.money;
							process_money_type = session_base.money;
							attributes.project_name = '';
							attributes.project_id = '';
							attributes.other_cash_act_value = used_total_;
							attributes.company_id = attributes.company_id;
							attributes.consumer_id = attributes.consumer_id;
							attributes.employee_id = '';
							attributes.action_detail = '#temp_order_number# Para Puan Karşılığı';
							attributes.action_account_code = '#get_inv_acc.money_credit#';
							attributes.action_date = new_date;
							attributes.paper_number = '#temp_order_number#';
							attributes.system_amount = used_total_;
							attributes.expense_center_1 = '';
							attributes.expense_center_2 = '';
							attributes.expense_center_id_1 = '';
							attributes.expense_item_id_1 = '';
							attributes.expense_item_name_1 = '';
							new_dsn_2 = dsn3;
						</cfscript>
						<cfinclude template="../../ch/query/add_debit_claim_note_ic.cfm">
					</cfif>
				</cfif>
			</cfif>
			
			
			<cfquery name="UPD_PRE_ROWS" datasource="#DSN#">
				UPDATE 
					#dsn3#.ORDER_PRE_ROWS 
				SET
					ORDER_ID = #GET_MAX_ORDER.MAX_ID# 
				WHERE 
					<cfif isdefined("session.pp.userid")>
						RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
					<cfelseif isdefined("session.ww.userid")>
						RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
					<cfelseif isdefined("session.ep.userid")>
						RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
					</cfif>
					PRODUCT_ID IS NOT NULL
			</cfquery>
			<cfscript>
				attributes.basket_money = 'TL';
			</cfscript>	
				<cfinclude template="../../../V16/objects/functions/add_order_row_reserved_stock.cfm">
			<cfscript>
				add_reserve_row(
					reserve_order_id:get_max_order.max_id,
					reserve_action_type:0,
					is_order_process:0,
					order_from_partner:1,
					is_purchase_sales:1,
					process_db:'#dsn#',
					session_base: session_base
					);
			</cfscript>
			
			<!--- sepet boşaltılıyor --->	
			<cfquery name="DEL_ROWS" datasource="#DSN#">
				DELETE FROM
					#dsn3#.ORDER_PRE_ROWS
				WHERE
					<cfif isdefined("session.pp.userid")>
						RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
					<cfelseif isdefined("session.ww.userid")>
						RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
					<cfelseif isdefined("session.ep.userid")>
						RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
					<cfelseif isdefined("arguments.partner_id")>
						RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#"> AND
					</cfif>
					PRODUCT_ID IS NOT NULL
			</cfquery>
			<cfif len(attributes.havale_banka)>
				<cfmail
					to= "#GET_OUR_EMAIL.email#"
					from= "WEB PORTAL<#GET_OUR_EMAIL.email#>"
					subject= "Sipariş Havale Bildirimi "
					type= "HTML">
					<style type="text/css">
						.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
						.headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
					</style>
					<table align="center" style="width:590px;">
						<tr>
							<td><strong>Sayın Yetkili,</strong><br>
							<font color="FF0000">#temp_order_number#</font>
							Nolu Sipariş için Havale bilgileri aşağıdaki gibidir ;
							</td>
						</tr>
						<tr>
							<td>
								BANKA ADI : #attributes.havale_banka# <BR>TARİH : #attributes.havale_tarih# <BR> DEKONT NO: #attributes.havale_no#						
							</td>
						</tr>
					</table>
				</cfmail>
			</cfif>
			
			<cfif isdefined("session.ww") and len(GET_OUR_EMAIL.email)>
				<cfquery name="GET_MAIL_ORDERS" datasource="#DSN#">
					SELECT ORDER_NUMBER,RECORD_DATE,RECORD_PAR FROM #dsn3#.ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_order.max_id#">
				</cfquery>
				<cfmail to="#get_consumer.CONSUMER_EMAIL#" from="#GET_OUR_EMAIL.email#"
					subject="Sipariş" type="HTML">
					
						<font color="FF0000">#DateFormat(DATEADD("h",session_base.time_zone,get_mail_orders.record_date),"dd/mm/yyyy")#&nbsp;#TimeFormat(DATEADD("h",session_base.time_zone,get_mail_orders.record_date),"HH:mm")#</font>
						&nbsp;tarihinde <font color="FF0000">#session_base.name# #session_base.surname#</font> kullanıcısı tarafından 
						<font color="FF0000">#get_mail_orders.order_number#</font>
						nolu sipariş sisteme eklenmiştir.<br/><br/>
						
				</cfmail>
				<cfmail to="#get_consumer.CONSUMER_EMAIL#" from="#GET_OUR_EMAIL.email#"
					subject="Siparişiniz İşleme Alındı" type="HTML">
					Sayın #session_base.name# #session_base.surname#;<br><br>
					
					<font color="FF0000">#get_mail_orders.order_number# No'lu siparişiniz Bize ulaşmıştır.</font> 
						
						<br><br>Saygılarımızla <br>#get_our_email.company_name#
					
				</cfmail>
				
			</cfif>
		
			
			<cfif isdefined("session.pp.userid") and isdefined("attributes.is_save_adresss")>
				<cfif isdefined("attributes.ship_address_row") and attributes.ship_address_row eq 0>
					<cfquery name="ADD_COMPANY_CONTACT" datasource="#DSN#">
						INSERT INTO
							#dsn#.COMPANY_BRANCH
						(
							COMPANY_ID,
							COMPBRANCH_STATUS,
							COMPBRANCH__NAME,
							COMPBRANCH_ADDRESS,
							COMPBRANCH_POSTCODE,
							COUNTY_ID,
							CITY_ID,
							COUNTRY_ID,
							SEMT,		
							RECORD_DATE,	
							RECORD_PAR,
							RECORD_IP
						)
							VALUES
						(
							<cfif isDefined("attributes.company_id") and len(attributes.company_id)>#attributes.company_id#<cfelse>#session.pp.company_id#</cfif>,
							1,
							<cfif isDefined("attributes.ship_contact_name0") and len(attributes.ship_contact_name0)>'#attributes.ship_contact_name0#'<cfelse>NULL</cfif>,
							<cfif isDefined("attributes.ship_address0") and len(attributes.ship_address0)>'#attributes.ship_address0#'<cfelse>NULL</cfif>,
							<cfif len('attributes.ship_address_postcode0')>'#attributes.ship_address_postcode0#'<cfelse>NULL</cfif>,
							<cfif len(county_id1)>#county_id1#<cfelse>NULL</cfif>,
							<cfif len(city_id1)>#city_id1#<cfelse>NULL</cfif>,
							<cfif len(attributes.ship_address_country0)>#attributes.ship_address_country0#<cfelse>NULL</cfif>,
							<cfif len(attributes.ship_address_semt0)>'#attributes.ship_address_semt0#'<cfelse>NULL</cfif>,
							#now()#,
							#session.pp.userid#,
							'#cgi.remote_addr#'
						)
					</cfquery>
					<cfquery name="GET_MAX_CONT_ADDR" datasource="#DSN#">
						SELECT
							MAX(COMPBRANCH_ID) AS CONTACT_ID
						FROM
							#dsn#.COMPANY_BRANCH
					</cfquery>
					<cfquery name="UPD_ORDER" datasource="#DSN#">
						UPDATE
							#dsn3#.ORDERS
						SET
							SHIP_ADDRESS_ID = #get_max_cont_addr.contact_id#
						WHERE
							ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_order.max_id#">
					</cfquery>
				</cfif>
				<cfif isdefined("attributes.tax_address_row") and attributes.tax_address_row eq 0>
					<cfquery name="ADD_COMPANY_CONTACT" datasource="#DSN#">
						INSERT INTO
							#dsn#.COMPANY_BRANCH
							(
								COMPANY_ID,
								COMPBRANCH_STATUS,
								COMPBRANCH__NAME,
								COMPBRANCH_ADDRESS,
								COMPBRANCH_POSTCODE,
								COUNTY_ID,
								CITY_ID,
								COUNTRY_ID,
								SEMT,		
								RECORD_DATE,	
								RECORD_PAR,
								RECORD_IP
							)
								VALUES
							(
								<cfif isDefined("attributes.company_id") and len(attributes.company_id)>#attributes.company_id#<cfelse>#session.pp.company_id#</cfif>,
								1,
								<cfif isDefined("attributes.tax_contact_name0") and len(attributes.tax_contact_name0)>'#attributes.tax_contact_name0#'<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.tax_address0") and len(attributes.tax_address0)>'#attributes.tax_address0#'<cfelse>NULL</cfif>,
								<cfif len('attributes.tax_address_postcode0')>'#attributes.tax_address_postcode0#'<cfelse>NULL</cfif>,
								<cfif isDefined('county_id2') and len(county_id2)>#county_id2#<cfelse>NULL</cfif>,
								<cfif isDefined('city_id2') and len(city_id2)>#city_id2#<cfelse>NULL</cfif>,
								<cfif len(attributes.tax_address_country0)>#attributes.tax_address_country0#<cfelse>NULL</cfif>,
								<cfif len(attributes.tax_address_semt0)>'#attributes.tax_address_semt0#'<cfelse>NULL</cfif>,
								#now()#,
								#session.pp.userid#,
								'#cgi.remote_addr#'
							)
					</cfquery>
					<cfquery name="GET_MAX_CONTACT" datasource="#DSN#">
						SELECT
							MAX(COMPBRANCH_ID) AS CONTACT_ID
						FROM
							#dsn#.COMPANY_BRANCH
					</cfquery>
					<cfquery name="UPD_ORDER" datasource="#DSN#">
						UPDATE
							#dsn3#.ORDERS
						SET
							TAX_ADDRESS_ID = #get_max_contact.contact_id#
						WHERE
							ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_order.max_id#">
					</cfquery>
				</cfif>
			</cfif>
			<cfif isdefined("session.ww.userid") and isdefined("attributes.is_save_adresss")>
				<cfif isdefined("attributes.ship_address_row") and attributes.ship_address_row eq 0>
					<cfif not (isdefined('attributes.is_same_tax_ship') and len(attributes.is_same_tax_ship))>
						<cfquery name="ADD_CONSUMER_CONTACT" datasource="#DSN#">
							INSERT INTO
								#dsn#.CONSUMER_BRANCH
								(
									CONSUMER_ID,
									STATUS,
									CONTACT_NAME,
									CONTACT_ADDRESS,
									CONTACT_TELCODE,
									CONTACT_TEL1,
									CONTACT_DELIVERY_NAME,
									CONTACT_POSTCODE,
									CONTACT_COUNTY_ID,
									CONTACT_CITY_ID,
									CONTACT_COUNTRY_ID,
									CONTACT_SEMT,		
									CONTACT_DISTRICT,
									CONTACT_DISTRICT_ID,
									CONTACT_MAIN_STREET,
									CONTACT_STREET,
									CONTACT_DOOR_NO,
									RECORD_DATE,	
									RECORD_CONS,
									RECORD_IP
								)
									VALUES
								(
									<cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>#session.ww.userid#</cfif>,
									1,
									<cfif isDefined("attributes.ship_contact_name0") and len(attributes.ship_contact_name0)>'#attributes.ship_contact_name0#'<cfelse>NULL</cfif>,
									<cfif isDefined("attributes.ship_address0") and len(attributes.ship_address0)>'#attributes.ship_address0#'<cfelse>NULL</cfif>,
									<cfif isdefined("attributes.ship_contact_telcode0") and len(attributes.ship_contact_telcode0)>'#attributes.ship_contact_telcode0#'<cfelse>NULL</cfif>,
									<cfif isdefined("attributes.ship_contact_tel0") and len(attributes.ship_contact_tel0)>'#attributes.ship_contact_tel0#'<cfelse>NULL</cfif>,
									<cfif isdefined("attributes.ship_contact_delivery0") and len(attributes.ship_contact_delivery0)>'#attributes.ship_contact_delivery0#'<cfelse>NULL</cfif>,
									<cfif len('attributes.ship_address_postcode0')>'#attributes.ship_address_postcode0#'<cfelse>NULL</cfif>,
									<!---<cfif len(county_id)>#county_id#<cfelse>NULL</cfif>,
									<cfif len(city_id)>#city_id#<cfelse>NULL</cfif>,--->
									<cfif len(attributes.ship_address_county0)>#attributes.ship_address_county0#<cfelse>NULL</cfif>,
									<cfif len(attributes.ship_address_city0)>'#attributes.ship_address_city0#'<cfelse>NULL</cfif>,
									<cfif len(attributes.ship_address_country0)>#attributes.ship_address_country0#<cfelse>NULL</cfif>,
									<cfif len(attributes.ship_address_semt0)>'#attributes.ship_address_semt0#'<cfelse>NULL</cfif>,
									<cfif isdefined("attributes.ship_district0") and len(attributes.ship_district0)>'#attributes.ship_district0#'<cfelse>NULL</cfif>,
									<cfif isdefined("attributes.ship_district_id0") and len(attributes.ship_district_id0)>#attributes.ship_district_id0#<cfelse>NULL</cfif>,
									<cfif isdefined("attributes.ship_main_street0") and len(attributes.ship_main_street0)>'#attributes.ship_main_street0#'<cfelse>NULL</cfif>,
									<cfif isdefined("attributes.ship_street0") and len(attributes.ship_street0)>'#attributes.ship_street0#'<cfelse>NULL</cfif>,
									<cfif isdefined("attributes.ship_work_doorno0") and len(attributes.ship_work_doorno0)>'#attributes.ship_work_doorno0#'<cfelse>NULL</cfif>,
									#now()#,
									#session.ww.userid#,
									'#cgi.remote_addr#'
								)
						</cfquery>
						<cfquery name="GET_MAX_CONT_ADDR" datasource="#DSN#">
							SELECT
								MAX(CONTACT_ID) AS CONTACT_ID
							FROM
								#dsn#.CONSUMER_BRANCH
						</cfquery>
						<cfquery name="UPD_ORDER" datasource="#DSN#">
							UPDATE
								#dsn3#.ORDERS
							SET
								CITY_ID = <cfif len(attributes.ship_address_city0)>'#attributes.ship_address_city0#'<cfelse>NULL</cfif>,
								COUNTY_ID = <cfif len(attributes.ship_address_county0)>#attributes.ship_address_county0#<cfelse>NULL</cfif>,
								COUNTRY_ID = <cfif len(attributes.ship_address_country0)>#attributes.ship_address_country0#<cfelse>NULL</cfif>,
								SHIP_ADDRESS_ID = #get_max_cont_addr.contact_id#
							WHERE
								ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_order.max_id#">
						</cfquery>
					</cfif>
				</cfif>
				<cfif isdefined("attributes.tax_address_row") and attributes.tax_address_row eq 0>
					<cfquery name="ADD_CONSUMER_CONTACT_" datasource="#DSN#">
						INSERT INTO
							#dsn#.CONSUMER_BRANCH
							(
								CONSUMER_ID,
								STATUS,
								CONTACT_NAME,
								CONTACT_ADDRESS,
								CONTACT_POSTCODE,
								CONTACT_COUNTY_ID,
								CONTACT_CITY_ID,
								CONTACT_COUNTRY_ID,
								CONTACT_SEMT,		
								CONTACT_DISTRICT,
								CONTACT_DISTRICT_ID,
								CONTACT_MAIN_STREET,
								CONTACT_STREET,
								CONTACT_DOOR_NO,
								IS_COMPANY,
								COMPANY_NAME,
								TAX_NO,
								TAX_OFFICE,
								RECORD_DATE,	
								RECORD_CONS,
								RECORD_IP
							)
								VALUES
							(
								<cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>#session.ww.userid#</cfif>,
								1,
								'Diğer Adres',
								<cfif isDefined("attributes.tax_address0") and len(attributes.tax_address0)>'#attributes.tax_address0#'<cfelse>NULL</cfif>,
								<cfif len('attributes.tax_address_postcode0')>'#attributes.tax_address_postcode0#'<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.tax_address_county0") and len(attributes.tax_address_county0)>'#attributes.tax_address_county0#'<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.tax_address_city0") and len(attributes.tax_address_city0)>'#attributes.tax_address_city0#'<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.tax_address_country0") and len(attributes.tax_address_country0)>'#attributes.tax_address_country0#'<cfelse>NULL</cfif>,
								<cfif len(attributes.tax_address_semt0)>'#attributes.tax_address_semt0#'<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.tax_district0") and len(attributes.tax_district0)>'#attributes.tax_district0#'<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.tax_district_id0") and len(attributes.tax_district_id0)>#attributes.tax_district_id0#<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.tax_main_street0") and len(attributes.tax_main_street0)>'#attributes.tax_main_street0#'<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.tax_street0") and len(attributes.tax_street0)>'#attributes.tax_street0#'<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.tax_work_doorno0") and len(attributes.tax_work_doorno0)>'#attributes.tax_work_doorno0#'<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.is_company0") and len(attributes.is_company0)>1<cfelse>0</cfif>,
								<cfif isdefined("attributes.company_name0") and len(attributes.company_name0)>'#attributes.company_name0#'<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.tax_no0") and len(attributes.tax_no0)>'#attributes.tax_no0#'<cfelse>NULL</cfif>,
								<cfif isdefined("attributes.tax_office0") and len(attributes.tax_office0)>'#attributes.tax_office0#'<cfelse>NULL</cfif>,
								#now()#,
								#session.ww.userid#,
								'#cgi.remote_addr#'
							)
					</cfquery>
					<cfquery name="GET_MAX_CONTACT" datasource="#DSN#">
						SELECT
							MAX(CONTACT_ID) AS CONTACT_ID
						FROM
							#dsn#.CONSUMER_BRANCH
					</cfquery>
					<cfquery name="UPD_ORDER" datasource="#DSN#">
						UPDATE
							#dsn3#.ORDERS
						SET
							TAX_ADDRESS_ID = #get_max_contact.contact_id#
						WHERE
							ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_order.max_id#">
					</cfquery>
				</cfif>
			</cfif>
			
			<cfif isdefined("session.pp.cc_paym_id_info")>
				<cfset cc_paym_id_info = session.pp.cc_paym_id_info>
			<cfelseif isdefined("session.ww.cc_paym_id_info")>
				<cfset cc_paym_id_info = session.ww.cc_paym_id_info>
			<cfelse>
				<cfset cc_paym_id_info = "">
			</cfif>
			
			<cfif len(cc_paym_id_info)>
				<cfquery name="UPD_BANK_ORDER" datasource="#DSN#">
					UPDATE
						#dsn3#.CREDIT_CARD_BANK_PAYMENTS
					SET
						ORDER_ID = #get_max_order.max_id#
					WHERE
						CREDITCARD_PAYMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#cc_paym_id_info#">
				</cfquery>
				<cfquery name="PAID_INFO" datasource="#DSN#">
					UPDATE #dsn3#.ORDERS SET IS_PAID = 1 WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_order.max_id#">
				</cfquery>
			</cfif>
			
			<!--- sipariş bilgileriyle ödeme ler ilişkilendirliyor --->
			<cfif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 1 and isdefined('attributes.is_add_bank_order') and attributes.is_add_bank_order eq 1><!---havale yöntemi--->
				<cfquery name="UPD_BANK_ORDER" datasource="#DSN#">
					UPDATE
						#dsn2#.BANK_ORDERS
					SET
						ORDER_ID = #get_max_order.max_id#
					WHERE
						BANK_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#bank_order_id_info#">
				</cfquery>
			<cfelseif isdefined("attributes.paymethod_type") and listfind("2,4",attributes.paymethod_type) and isdefined("cc_paym_id_info")><!---tamamını kredi kartı veya limit aşımında kredi kartı durumu--->
				<cfquery name="UPD_BANK_ORDER" datasource="#DSN#">
					UPDATE
						#dsn3#.CREDIT_CARD_BANK_PAYMENTS
					SET
						ORDER_ID = #get_max_order.max_id#
					WHERE
						CREDITCARD_PAYMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#cc_paym_id_info#">
				</cfquery>
				<cfquery name="PAID_INFO" datasource="#DSN#">
					UPDATE #dsn3#.ORDERS SET IS_PAID = 1 WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_order.max_id#">
				</cfquery>
			</cfif>
		</cftransaction>
	</cflock>
	
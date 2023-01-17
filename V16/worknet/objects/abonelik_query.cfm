<cfset attributes.action_detail = 'Abonelik ödeme tutarı.'>
<!--- sanal pos --->
<cfinclude template="../query/add_online_pos.cfm">
<!--- sanal pos --->

<cfif response_code eq 00>
	<cfset subs_warning = 0>
	<cftry>
		<!--- default parametreler --->
		<cfquery name="getSubsProcess" datasource="#DSN#" maxrows="1">
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
				PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.add_subscription_contract%">
			ORDER BY 
				PTR.PROCESS_ROW_ID
		</cfquery>
		<cfquery name="getSubsPaymentProcess" datasource="#DSN#" maxrows="1">
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
				PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.popup_subscription_payment_plan%">
			ORDER BY 
				PTR.PROCESS_ROW_ID
		</cfquery>
		
		<cfset stock_id = listfirst(attributes.stock_id,';')>
		<cfset payment_period = listlast(attributes.stock_id,';')>
		<cfset subs_cat_id = 1>
		<cfset subs_stage_id = getSubsProcess.PROCESS_ROW_ID>
		<cfset paym_stage_id = getSubsPaymentProcess.PROCESS_ROW_ID>
		<cfset card_paymethod_id = payment_type_id>
		
		<!--- urun bilgileri cekiliyor --->
		<cfquery name="getProduct_" datasource="#dsn3#">
			SELECT 
				S.STOCK_ID,
				S.PRODUCT_ID,
				S.PRODUCT_NAME +' - '+ S.PROPERTY AS PRODUCT_NAME,
				S.PRODUCT_UNIT_ID UNIT_ID,
				PU.MAIN_UNIT UNIT,
				S.STOCK_CODE_2 AS USERS_NUMBER,
				S.TAX
			FROM 
				STOCKS S
				RIGHT JOIN PRODUCT_UNIT PU ON PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID 
			WHERE 
				STOCK_ID = #stock_id#
		</cfquery>
	
		<!--- abonelik --->
		<cfquery name="getMemberSubs" datasource="#dsn3#"><!--- sistemde kayitli aktif abone kaydi varmi? --->
			SELECT TOP 1 SUBSCRIPTION_ID,COMPANY_ID FROM SUBSCRIPTION_CONTRACT WHERE COMPANY_ID = #session.pp.company_id# AND IS_ACTIVE = 1 ORDER BY RECORD_DATE DESC
		</cfquery>
		<cfif getMemberSubs.recordcount eq 0><!--- abonelik kaydi yok --->
			<cfset contract_date = now()><!--- sozlesme tarihi --->
			<cfset payment_date = dateformat(now(),dateformat_style)><!--- odeme baslangic tarihi --->
			<cf_date tarih="payment_date">
			<cfset payment_finish_date = date_add('m',payment_period,payment_date)>
			<cf_date tarih="payment_finish_date">
			<cfset payment_finish_date = date_add('h',23,date_add('n',59,date_add('s',59,payment_finish_date)))><!--- odeme bitis tarihi --->
			
			<!--- abone adresleri eklemek icin uye bilgileri cekiliyor --->
			<cfquery name="getMember" datasource="#dsn#">
				SELECT
					C.MANAGER_PARTNER_ID AS PARTNER_ID,
					C.COMPANY_ID,
					C.FULLNAME,
					C.COMPANY_POSTCODE AS POSTCODE,
					C.COMPANY_ADDRESS AS ADDRESS,
					C.SEMT AS SEMT,
					C.COUNTY AS COUNTY,
					C.COUNTRY AS COUNTRY,
					C.CITY AS CITY,
					C.COORDINATE_1 AS COORDINATE_1,
					C.COORDINATE_2 AS COORDINATE_2
				FROM 
					COMPANY C
				WHERE 
					C.COMPANY_ID = #session.pp.company_id# AND
					C.COMPANY_STATUS = 1
			</cfquery>
			
			<!--- abone numarası olusturuluyor. --->
			<cf_papers paper_type="subscription">
			<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
				UPDATE 
					GENERAL_PAPERS
				SET
					SUBSCRIPTION_NUMBER = #paper_number#
				WHERE
					SUBSCRIPTION_NUMBER IS NOT NULL
			</cfquery>
			
			<!--- abonelik kaydi --->
			<cfquery name="add_member_subs" datasource="#dsn3#" result="addSubs">
				INSERT INTO
					SUBSCRIPTION_CONTRACT
					(
						WRK_ID,
						IS_ACTIVE,
						SUBSCRIPTION_NO,
						SUBSCRIPTION_HEAD,
						PARTNER_ID,
						COMPANY_ID,
						SUBSCRIPTION_TYPE_ID,				
						SUBSCRIPTION_STAGE,
						INVOICE_COMPANY_ID,
						INVOICE_PARTNER_ID,
						PRODUCT_ID,
						STOCK_ID,
						START_DATE,<!---sozlesme tarihi --->
						SHIP_ADDRESS,
						SHIP_POSTCODE,
						SHIP_SEMT,
						SHIP_COUNTY_ID,
						SHIP_CITY_ID,
						SHIP_COUNTRY_ID,
						SHIP_COORDINATE_1,
						SHIP_COORDINATE_2,
						INVOICE_ADDRESS,
						INVOICE_POSTCODE,
						INVOICE_SEMT,
						INVOICE_COUNTY_ID,
						INVOICE_CITY_ID,
						INVOICE_COUNTRY_ID,								
						INVOICE_COORDINATE_1,
						INVOICE_COORDINATE_2,
						CONTACT_ADDRESS,
						CONTACT_POSTCODE,
						CONTACT_SEMT,
						CONTACT_COUNTY_ID,
						CONTACT_CITY_ID,
						CONTACT_COUNTRY_ID,
						CONTACT_COORDINATE_1,
						CONTACT_COORDINATE_2,
						RECORD_PAR,
						RECORD_IP,
						RECORD_DATE							
					)
					VALUES
					(
						'#wrk_id#',
						1,
						'#paper_code & '-' & paper_number#',
						<cfif len(getMember.fullname)>'#getMember.fullname#'<cfelse>NULL</cfif>,
						<cfif len(getMember.partner_id)>#getMember.partner_id#<cfelse>NULL</cfif>,
						<cfif len(getMember.company_id)>#getMember.company_id#<cfelse>NULL</cfif>,
						<cfif len(subs_cat_id)>#subs_cat_id#<cfelse>NULL</cfif>,
						<cfif len(subs_stage_id)>#subs_stage_id#<cfelse>NULL</cfif>,
						<cfif len(getMember.company_id)>#getMember.company_id#<cfelse>NULL</cfif>,
						<cfif len(getMember.partner_id)>#getMember.partner_id#<cfelse>NULL</cfif>,
						<cfif len(getProduct_.product_id)>#getProduct_.product_id#<cfelse>NULL</cfif>,
						<cfif len(getProduct_.stock_id)>#getProduct_.stock_id#<cfelse>NULL</cfif>,
						<cfif len(contract_date)>#contract_date#<cfelse>NULL</cfif>,
						<cfif len(getMember.address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.address#"><cfelse>NULL</cfif>,
						<cfif len(getMember.postcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.postcode#"><cfelse>NULL</cfif>,
						<cfif len(getMember.semt)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.semt#"><cfelse>NULL</cfif>,
						<cfif len(getMember.county)>#getMember.county#<cfelse>NULL</cfif>,
						<cfif len(getMember.city)>#getMember.city#<cfelse>NULL</cfif>,
						<cfif len(getMember.country)>#getMember.country#<cfelse>NULL</cfif>,
						<cfif len(getMember.COORDINATE_1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.COORDINATE_1#"><cfelse>NULL</cfif>,
						<cfif len(getMember.COORDINATE_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.COORDINATE_2#"><cfelse>NULL</cfif>,
						<cfif len(getMember.address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.address#"><cfelse>NULL</cfif>,
						<cfif len(getMember.postcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.postcode#"><cfelse>NULL</cfif>,
						<cfif len(getMember.semt)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.semt#"><cfelse>NULL</cfif>,
						<cfif len(getMember.county)>#getMember.county#<cfelse>NULL</cfif>,
						<cfif len(getMember.city)>#getMember.city#<cfelse>NULL</cfif>,
						<cfif len(getMember.country)>#getMember.country#<cfelse>NULL</cfif>,
						<cfif len(getMember.COORDINATE_1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.COORDINATE_1#"><cfelse>NULL</cfif>,
						<cfif len(getMember.COORDINATE_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.COORDINATE_2#"><cfelse>NULL</cfif>,
						<cfif len(getMember.address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.address#"><cfelse>NULL</cfif>,
						<cfif len(getMember.postcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.postcode#"><cfelse>NULL</cfif>,
						<cfif len(getMember.semt)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.semt#"><cfelse>NULL</cfif>,
						<cfif len(getMember.county)>#getMember.county#<cfelse>NULL</cfif>,
						<cfif len(getMember.city)>#getMember.city#<cfelse>NULL</cfif>,
						<cfif len(getMember.country)>#getMember.country#<cfelse>NULL</cfif>,
						<cfif len(getMember.COORDINATE_1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.COORDINATE_1#"><cfelse>NULL</cfif>,
						<cfif len(getMember.COORDINATE_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#getMember.COORDINATE_2#"><cfelse>NULL</cfif>,
						#session.pp.userid#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
						#now()#
					)
			</cfquery>
			
			<!--- odeme plani --->
			<cfquery name="ADD_PAYMENT_PLAN" datasource="#dsn3#">
				INSERT INTO
					SUBSCRIPTION_PAYMENT_PLAN
					(
						SUBSCRIPTION_ID,
						PRODUCT_ID,
						STOCK_ID,
						UNIT,
						UNIT_ID,
						QUANTITY,
						AMOUNT,
						MONEY_TYPE,
						PERIOT,
						START_DATE,
						CARD_PAYMETHOD_ID,
						PROCESS_STAGE,
						RECORD_DATE,
						RECORD_IP
					)
					VALUES
					(
						#addSubs.identityCol#,
						<cfif len(getProduct_.product_id)>#getProduct_.product_id#<cfelse>NULL</cfif>,
						<cfif len(getProduct_.stock_id)>#getProduct_.stock_id#<cfelse>NULL</cfif>,
						<cfif len(getProduct_.unit)>'#getProduct_.unit#',<cfelse>NULL,</cfif>
						<cfif len(getProduct_.unit_id)>#getProduct_.unit_id#,<cfelse>NULL,</cfif>
						1,
						#attributes.sales_credit#,
						'TL',
						#payment_period#,
						#contract_date#,
						<cfif len(card_paymethod_id)>#card_paymethod_id#,<cfelse>NULL,</cfif>
						<cfif len(paym_stage_id)>#paym_stage_id#,<cfelse>NULL,</cfif>
						#now()#,
						'#cgi.remote_addr#'
					)
			</cfquery>
			
		<cfelse><!--- abonelik kaydi var --->
			<!--- son guncel odeme plan satiri cekilir --->
			<cfquery name="get_payment_plan_row" datasource="#dsn3#">
				SELECT TOP 1
					SPPR.SUBSCRIPTION_PAYMENT_ROW_ID,
					ISNULL(SPPR.PAYMENT_FINISH_DATE ,GETDATE()) PAYMENT_FINISH_DATE,
					S.STOCK_CODE_2 AS USERS_NUMBER
				FROM 
					SUBSCRIPTION_PAYMENT_PLAN_ROW SPPR
					LEFT JOIN STOCKS S ON S.STOCK_ID = SPPR.STOCK_ID 
				WHERE 
					SPPR.SUBSCRIPTION_ID = #getMemberSubs.SUBSCRIPTION_ID# AND
					SPPR.IS_PAID = 1 AND
					SPPR.IS_ACTIVE = 1 AND
					SPPR.PAYMENT_FINISH_DATE >= #now()#
				ORDER BY
					SPPR.RECORD_DATE DESC
			</cfquery>
			<!--- odeme baslangic tarihi --->
			<cfif get_payment_plan_row.recordcount and get_payment_plan_row.users_number lt getProduct_.users_number>
				<cfset payment_date = dateformat(now(),dateformat_style)>
				<cfquery name="updPlanRowFinishDate" datasource="#dsn3#">
					UPDATE SUBSCRIPTION_PAYMENT_PLAN_ROW SET PAYMENT_FINISH_DATE = #now()# WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #get_payment_plan_row.SUBSCRIPTION_PAYMENT_ROW_ID#
				</cfquery>
			<cfelseif get_payment_plan_row.recordcount>
				<cfset payment_date = dateformat(get_payment_plan_row.PAYMENT_FINISH_DATE,dateformat_style)>
			<cfelse>
				<cfset payment_date = dateformat(now(),dateformat_style)>
			</cfif>
			<cf_date tarih="payment_date">
			<cfset payment_finish_date = date_add('m',payment_period,payment_date)>
			<cf_date tarih="payment_finish_date">
			<cfset payment_finish_date = date_add('h',23,date_add('n',59,date_add('s',59,payment_finish_date)))><!--- odeme bitis tarihi --->
		</cfif>
		
		<!--- cari_rows bilgileri odeme planı satırı ile iliskilendirmek icin cekiliyor --->
		<cfif isdefined('get_max_payment.max_id') and len(get_max_payment.max_id)>
			<cfquery name="getCariInfo" datasource="#dsn2#">
				SELECT
					CARI_ACTION_ID,
					ACTION_DATE,
					ACTION_ID,
					ACTION_TYPE_ID,
					ACTION_TABLE
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID = 241 AND
					ACTION_ID = #get_max_payment.max_id#
			</cfquery>
		<cfelse>
			<cfset getCariInfo.recordcount = 0>
		</cfif>
		
		<cfset price_kdvsiz = attributes.sales_credit*(100/(100+getProduct_.tax))>
		<cfset price_kdvli = attributes.sales_credit>
		
		<!--- odeme plani satirlari --->
		<cfquery name="add_payment_plan_row" datasource="#dsn3#">
			INSERT INTO
				SUBSCRIPTION_PAYMENT_PLAN_ROW
				(
					SUBSCRIPTION_ID,
					PRODUCT_ID,
					STOCK_ID,
					DETAIL,
					PAYMENT_DATE,
					PAYMENT_FINISH_DATE,
					QUANTITY,
					UNIT_ID,
					UNIT,
					AMOUNT,
					MONEY_TYPE,
					ROW_TOTAL,
					ROW_NET_TOTAL,
					DISCOUNT,
					DISCOUNT_AMOUNT,
					IS_COLLECTED_INVOICE,
					IS_GROUP_INVOICE,
					CARD_PAYMETHOD_ID,
					IS_PAID,
					IS_BILLED,
					IS_COLLECTED_PROVISION,
					IS_ACTIVE,
					PERIOD_ID,
					<cfif getCariInfo.recordcount>
						CARI_ACTION_ID,
						CARI_PERIOD_ID,
						CARI_ACT_TYPE,
						CARI_ACT_ID,
						CARI_ACT_TABLE,
					</cfif>
					RECORD_DATE,
					RECORD_IP
				)
			VALUES
				(
					<cfif getMemberSubs.recordcount>#getMemberSubs.subscription_id#<cfelse>#addSubs.identityCol#</cfif>,
					<cfif len(getProduct_.product_id)>#getProduct_.product_id#<cfelse>NULL</cfif>,
					<cfif len(getProduct_.stock_id)>#getProduct_.stock_id#<cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(getProduct_.product_name,50)#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#payment_date#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#payment_finish_date#">,
					1,
					<cfif len(getProduct_.unit_id)>#getProduct_.unit_id#,<cfelse>NULL,</cfif>
					<cfif len(getProduct_.unit)>'#getProduct_.unit#',<cfelse>NULL,</cfif>
					#price_kdvsiz#,
					'TL',
					#price_kdvsiz#,
					#price_kdvsiz#,
					0,
					0,
					1,
					0,
					<cfif len(card_paymethod_id)>#card_paymethod_id#,<cfelse>NULL,</cfif>
					1,
					0,
					0,
					1,
					#session_base.period_id#,
					<cfif getCariInfo.recordcount>
						#getCariInfo.CARI_ACTION_ID#,
						#session_base.period_id#,
						#getCariInfo.ACTION_TYPE_ID#,
						#getCariInfo.ACTION_ID#,
						'#getCariInfo.ACTION_TABLE#',
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
				)
		</cfquery>
		
		<!--- abonelik --->
		<cfcatch>
			<cfset subs_warning = 1>
		</cfcatch>
	</cftry>
	<cfif subs_warning eq 1>
		<cflocation addtoken="no" url="#request.self#?fuseaction=worknet.warning_page&subs_warning=#subs_warning#">
	<cfelseif credit_cart_warning eq 1>
		<!--- Burada sistem yonetisine mail gönderilebilir para hesaba gecti fakat sisteme kredi kartı tahsilat kaydı atmadı --->
		<cflocation addtoken="no" url="#request.self#?fuseaction=worknet.warning_page">
	<cfelse>
		<cflocation addtoken="no" url="#request.self#?fuseaction=worknet.warning_page">
	</cfif>
</cfif>

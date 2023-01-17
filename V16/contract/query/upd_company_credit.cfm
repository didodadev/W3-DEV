<cfquery name="GET_CREDIT_LIMIT" datasource="#DSN#">
	SELECT
		COMPANY_CREDIT_ID
	FROM
		COMPANY_CREDIT
	WHERE
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		COMPANY_ID = #attributes.company_id# AND
	<cfelse>
		CONSUMER_ID = #attributes.consumer_id# AND
	</cfif>
		OUR_COMPANY_ID = #attributes.our_company_id# AND
		COMPANY_CREDIT_ID <> #attributes.company_credit_id#
</cfquery>
<cfset other_money_value = listfirst(attributes.other_money, ',')>
<cfif isdate(attributes.blacklist_date)>
	<cf_date tarih="attributes.blacklist_date">
</cfif>
<cfif get_credit_limit.recordcount eq 0>
	<cfif isdefined("attributes.open_account_risk_limit") and len(attributes.open_account_risk_limit)>
		<cfquery name="hist_credit" datasource="#dsn#">
			SELECT
				*
			FROM
				COMPANY_CREDIT
			WHERE
				<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
					COMPANY_ID = #attributes.company_id#
				<cfelse>
					CONSUMER_ID = #attributes.consumer_id#
				</cfif>
		</cfquery>
		<cfif 	hist_credit.open_account_risk_limit neq attributes.open_account_risk_limit or
				hist_credit.open_account_risk_limit_other neq attributes.open_account_risk_limit_other_cash or
				hist_credit.forward_sale_limit neq attributes.forward_sale_limit or
				hist_credit.forward_sale_limit_other neq attributes.forward_sale_limit_other_cash or
				hist_credit.first_payment_interest neq attributes.first_payment_interest or
				hist_credit.last_payment_interest neq attributes.last_payment_interest or
				hist_credit.price_cat neq attributes.price_cat or hist_credit.PRICE_CAT_PURCHASE neq attributes.price_cat_purchase>
				<cfoutput query="hist_credit">
					<cfquery name="add_credit_history_info" datasource="#dsn#">
						INSERT INTO
							COMPANY_CREDIT_HISTORY
						(
							CREDIT_ID,
							COMPANY_ID,
							CONSUMER_ID,
							OPEN_ACCOUNT_RISK_LIMIT,
							OPEN_ACCOUNT_RISK_LIMIT_OTHER,
							FORWARD_SALE_LIMIT,
							FORWARD_SALE_LIMIT_OTHER,
							FIRST_PAYMENT_INTEREST ,
							LAST_PAYMENT_INTEREST,
							TOTAL_RISK_LIMIT,
							MONEY,
							PRICE_CAT,
                            PRICE_CAT_PURCHASE,
							IS_BLACKLIST,
							BLACKLIST_INFO,
							BLACKLIST_DATE,
							RECORD_EMP,
							RECORD_DATE,
							RECORD_IP	
						)
						VALUES
						(
							#company_credit_id#,
							<cfif len(company_id)>#company_id#<cfelse>NULL</cfif>,
							<cfif len(consumer_id)>#consumer_id#<cfelse>NULL</cfif>,
							<cfif len(open_account_risk_limit)>#open_account_risk_limit#<cfelse>NULL</cfif>,
							<cfif len(open_account_risk_limit_other)>#open_account_risk_limit_other#<cfelse>NULL</cfif>,
							<cfif len(forward_sale_limit)>#forward_sale_limit#<cfelse>NULL</cfif>,
							<cfif len(forward_sale_limit_other)>#forward_sale_limit_other#<cfelse>NULL</cfif>,
							<cfif len(first_payment_interest)>#first_payment_interest#<cfelse>NULL</cfif>,
							<cfif len(last_payment_interest)>#last_payment_interest#<cfelse>NULL</cfif>,
							<cfif len(total_risk_limit)>#total_risk_limit#<cfelse>NULL</cfif>,
							<cfif len(money)>'#money#'<cfelse>NULL</cfif>,
							<cfif len(price_cat)>#price_cat#<cfelse>NULL</cfif>,
                            <cfif len(price_cat_purchase)>#price_cat_purchase#<cfelse>NULL</cfif>,
							<cfif len(is_blacklist)>#is_blacklist#<cfelse>NULL</cfif>,
							<cfif len(blacklist_info)>#blacklist_info#<cfelse>NULL</cfif>,
							<cfif len(blacklist_date)>#createodbcdatetime(blacklist_date)#<cfelse>NULL</cfif>,
							#session.ep.userid#,
							#now()#,
							'#cgi.remote_addr#'
						)
					</cfquery>
				</cfoutput>
		</cfif>
		<cfscript>
			StructInsert(attributes,"total_risk_limit","0");	
			StructInsert(attributes,"total_risk_limit_other","0");
			attributes.total_risk_limit = attributes.open_account_risk_limit + attributes.forward_sale_limit;	
			attributes.total_risk_limit_other = attributes.open_account_risk_limit_other_cash + attributes.forward_sale_limit_other_cash;				
		</cfscript>
		<cfquery name="UPD_COMPANY_CREDIT" datasource="#DSN#">
			UPDATE
				COMPANY_CREDIT
			SET
				PROCESS_STAGE = #attributes.process_stage#,
				COMPANY_ID = <cfif isdefined("attributes.company_id") and len(attributes.company_id)>#attributes.company_id#,<cfelse>NULL,</cfif>
				CONSUMER_ID = <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>
				OPEN_ACCOUNT_RISK_LIMIT = <cfif len(attributes.open_account_risk_limit)>#attributes.open_account_risk_limit#<cfelse>NULL</cfif>,
				FORWARD_SALE_LIMIT = <cfif len(attributes.forward_sale_limit)>#attributes.forward_sale_limit#<cfelse>NULL</cfif>,
				FORWARD_SALE_LIMIT_OTHER = <cfif len(attributes.forward_sale_limit_other_cash)>#attributes.forward_sale_limit_other_cash#<cfelse>NULL</cfif>,
				OPEN_ACCOUNT_RISK_LIMIT_OTHER = <cfif len(attributes.open_account_risk_limit_other_cash)>#attributes.open_account_risk_limit_other_cash#<cfelse>NULL</cfif>,
				LAST_PAYMENT_INTEREST = <cfif len(attributes.last_payment_interest)>#attributes.last_payment_interest#<cfelse>NULL</cfif>,
				PAYMENT_BLOKAJ = <cfif len(attributes.payment_blokaj)>#attributes.payment_blokaj#<cfelse>NULL</cfif>,
                PAYMENT_BLOKAJ_TYPE =<cfif len(attributes.blokaj_type)>#attributes.blokaj_type#<cfelse>NULL</cfif>,
				PAYMENT_RATE_TYPE =<cfif len(attributes.rate_type)>#attributes.rate_type#<cfelse>NULL</cfif>,
				FIRST_PAYMENT_INTEREST = <cfif len(attributes.first_payment_interest)>#attributes.first_payment_interest#<cfelse>NULL</cfif>,
				PAYMETHOD_ID = <cfif len(form.paymethod_id) and len(form.paymethod_name)>#form.paymethod_id#<cfelse>NULL</cfif>,
				CARD_PAYMETHOD_ID = <cfif len(form.card_paymethod_id) and len(form.paymethod_name)>#form.card_paymethod_id#<cfelse>NULL</cfif>,
				REVMETHOD_ID = <cfif len(form.revmethod_id) and len(form.revmethod_name)>#attributes.revmethod_id#<cfelse>NULL</cfif>,
				CARD_REVMETHOD_ID =  <cfif len(form.card_revmethod_id) and len(form.revmethod_name)>#form.card_revmethod_id#<cfelse>NULL</cfif>,
				MONEY = <cfif len(attributes.other_money)>'#'#listgetat(attributes.other_money,1)#'#'<cfelse>NULL</cfif>,
				TOTAL_RISK_LIMIT = <cfif len(attributes.total_risk_limit)>#attributes.total_risk_limit#<cfelse>NULL</cfif>,
				TOTAL_RISK_LIMIT_OTHER = <cfif len(attributes.total_risk_limit_other)>#attributes.total_risk_limit_other#<cfelse>NULL</cfif>,
				OUR_COMPANY_ID = #attributes.our_company_id#,
				SHIP_METHOD_ID = <cfif len(attributes.ship_method_id) and len(attributes.ship_method_name)>#attributes.ship_method_id#<cfelse>NULL</cfif>,
				PRICE_CAT = <cfif len(attributes.price_cat)>#attributes.price_cat#<cfelse>NULL</cfif>,
                PRICE_CAT_PURCHASE = <cfif len(attributes.price_cat_purchase)>#attributes.price_cat_purchase#<cfelse>NULL</cfif>,
				IS_INSTALMENT_INFO = <cfif isdefined('attributes.instalment')>1<cfelse>0</cfif>,
				TRANSPORT_COMP_ID = <cfif len(attributes.transport_comp_id) and Len(attributes.transport_comp_name)>#attributes.transport_comp_id#<cfelse>NULL</cfif>,
				TRANSPORT_DELIVER_ID = <cfif Len(attributes.transport_comp_name) and len(attributes.transport_deliver_id)>#attributes.transport_deliver_id#<cfelse>NULL</cfif>,
				IS_BLACKLIST = <cfif isdefined("attributes.is_blacklist")>1<cfelse>0</cfif>,
				BLACKLIST_INFO = <cfif isdefined("attributes.is_blacklist") and len(attributes.blacklist_info)>#attributes.blacklist_info#<cfelse>NULL</cfif>,
				BLACKLIST_DATE = <cfif isdefined("attributes.is_blacklist") and len(attributes.blacklist_date)>#attributes.blacklist_date#<cfelse>NULL</cfif>,	
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE 
				COMPANY_CREDIT_ID = #attributes.company_credit_id#
		</cfquery>
		<cfif len(attributes.price_cat) and isdefined("attributes.company_id") and len(attributes.company_id)>
			<cfquery name="get_price_list" datasource="#dsn#">
				SELECT 
					* 
				FROM 
					#dsn#_#FORM.OUR_COMPANY_ID#.PRICE_CAT_EXCEPTIONS 
				WHERE 
					PRICE_CATID = #attributes.price_cat#
					AND COMPANY_ID = #attributes.company_id#
					AND ACT_TYPE = 2
                    AND PURCHASE_SALES = 1
			</cfquery>
			<cfif get_price_list.recordcount>
				<cfquery name="upd_price_list_for_company" datasource="#DSN#">
					UPDATE
						#dsn#_#FORM.OUR_COMPANY_ID#.PRICE_CAT_EXCEPTIONS
					SET
						IS_DEFAULT = 0
					WHERE
						COMPANY_ID = #attributes.company_id#
						AND ACT_TYPE = 2
                        AND PURCHASE_SALES = 1
				</cfquery>
				<cfquery name="upd_price_list_for_company" datasource="#DSN#">
					UPDATE
						#dsn#_#FORM.OUR_COMPANY_ID#.PRICE_CAT_EXCEPTIONS
					SET
						IS_DEFAULT = 1
					WHERE
						PRICE_CATID = #attributes.price_cat#
						AND COMPANY_ID = #attributes.company_id#
						AND ACT_TYPE = 2
                        AND PURCHASE_SALES = 1
				</cfquery>
			<cfelse>
				<cfquery name="upd_price_list_for_company" datasource="#DSN#">
					UPDATE
						#dsn#_#FORM.OUR_COMPANY_ID#.PRICE_CAT_EXCEPTIONS
					SET
						IS_DEFAULT = 0
					WHERE
						COMPANY_ID = #attributes.company_id#
						AND ACT_TYPE = 2
                        AND PURCHASE_SALES = 1
				</cfquery>
				<cfquery name="add_price_list_for_company" datasource="#DSN#">
					INSERT INTO
						#dsn#_#FORM.OUR_COMPANY_ID#.PRICE_CAT_EXCEPTIONS
					(
						COMPANY_ID,
						PRICE_CATID,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE,
						ACT_TYPE,
						IS_DEFAULT,
						PURCHASE_SALES
					)
					VALUES
					(
						#attributes.company_id#,
						#attributes.price_cat#,
						#session.ep.userid#,
						'#remote_addr#',
						#now()#,
						2,
						1,
						1
					)
				</cfquery>				
			</cfif>	
		</cfif>
        <cfif len(attributes.price_cat_purchase) and isdefined("attributes.company_id") and len(attributes.company_id)>
        	<cfquery name="get_price_list_pur" datasource="#dsn#">
				SELECT 
					* 
				FROM 
					#dsn#_#FORM.OUR_COMPANY_ID#.PRICE_CAT_EXCEPTIONS 
				WHERE 
					PRICE_CATID = #attributes.price_cat_purchase#
					AND COMPANY_ID = #attributes.company_id#
					AND ACT_TYPE = 2
                    AND PURCHASE_SALES = 0
			</cfquery>
			<cfif get_price_list_pur.recordcount>
				<cfquery name="upd_price_list_for_company" datasource="#DSN#">
					UPDATE
						#dsn#_#FORM.OUR_COMPANY_ID#.PRICE_CAT_EXCEPTIONS
					SET
						IS_DEFAULT = 0
					WHERE
						COMPANY_ID = #attributes.company_id#
						AND ACT_TYPE = 2
                        AND PURCHASE_SALES = 0
				</cfquery>
				<cfquery name="upd_price_list_for_company" datasource="#DSN#">
					UPDATE
						#dsn#_#FORM.OUR_COMPANY_ID#.PRICE_CAT_EXCEPTIONS
					SET
						IS_DEFAULT = 1
					WHERE
						PRICE_CATID = #attributes.price_cat_purchase#
						AND COMPANY_ID = #attributes.company_id#
						AND ACT_TYPE = 2
                        AND PURCHASE_SALES = 0
				</cfquery>
			<cfelse>
				<cfquery name="upd_price_list_for_company" datasource="#DSN#">
					UPDATE
						#dsn#_#FORM.OUR_COMPANY_ID#.PRICE_CAT_EXCEPTIONS
					SET
						IS_DEFAULT = 0
					WHERE
						COMPANY_ID = #attributes.company_id#
						AND ACT_TYPE = 2
                        AND PURCHASE_SALES = 0
				</cfquery>
				<cfquery name="add_price_list_for_company" datasource="#DSN#">
					INSERT INTO
						#dsn#_#FORM.OUR_COMPANY_ID#.PRICE_CAT_EXCEPTIONS
					(
						COMPANY_ID,
						PRICE_CATID,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE,
						ACT_TYPE,
						IS_DEFAULT,
						PURCHASE_SALES
					)
					VALUES
					(
						#attributes.company_id#,
						#attributes.price_cat_purchase#,
						#session.ep.userid#,
						'#remote_addr#',
						#now()#,
						2,
						1,
						0
					)
				</cfquery>				
			</cfif>				
        </cfif>
		<cfquery name="del_credit_money" datasource="#dsn#">
			DELETE FROM COMPANY_CREDIT_MONEY WHERE ACTION_ID = #attributes.company_credit_id#
		</cfquery>
		<cfloop from="1" to="#attributes.deger_get_money#" index="i">
			<cfquery name="ADD_CREDIT_MONEY" datasource="#DSN#">
                INSERT INTO
                    COMPANY_CREDIT_MONEY
                (
                    MONEY_TYPE,
                    ACTION_ID,
                    RATE2,
                    RATE1,
                    IS_SELECTED
                )
                VALUES
                (
                    '#wrk_eval("attributes.hidden_rd_money_#i#")#',
                    <cfif IsDefined("attributes.company_credit_id") and len(attributes.company_credit_id)>#attributes.company_credit_id#<cfelse>NULL</cfif>, 
                    <cfif len(evaluate('attributes.value_rate2#i#'))>#evaluate("attributes.value_rate2#i#")#<cfelse>NULL</cfif>,
                    <cfif len(evaluate('attributes.txt_rate1_#i#'))>#evaluate("attributes.txt_rate1_#i#")#<cfelse>NULL</cfif>,
                    <cfif evaluate("attributes.hidden_rd_money_#i#") is other_money_value>1<cfelse>0</cfif>
                )
			</cfquery>
		</cfloop>
	</cfif>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		<cfset member_id_=attributes.company_id>
		<cfset member_url_='company_id=#attributes.company_id#'>
	<cfelse>
		<cfset member_id_=attributes.consumer_id>
		<cfset member_url_='consumer_id=#attributes.consumer_id#'>
	</cfif>
	<cf_workcube_process is_upd='1' 
		data_source='#dsn#' 
		old_process_line='#attributes.old_process_line#'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_table='COMPANY_CREDIT'
		action_column='COMPANY_CREDIT_ID'
		action_id='#member_id_#'
		action_page='#request.self#?fuseaction=contract.list_contracts&event=upd&#member_url_#' 
		warning_description='Üye : #member_id_#'>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='335.Bir Üyeye Aynı Dönem İçin İki Farklı Risk Durumu Giremezsiniz'>!");
	</script>
	<cfabort>
</cfif>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#?fuseaction=contract.list_contracts&event=upd&company_id=#attributes.company_id#</cfoutput>';
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#?fuseaction=contract.list_contracts&event=upd&consumer_id=#attributes.consumer_id#</cfoutput>';
	</script>
</cfif>
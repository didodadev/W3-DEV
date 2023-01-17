<cfquery name="GET_CREDIT_LIMIT" datasource="#dsn#">
	SELECT 
		COMPANY_CREDIT_ID 
	FROM 
		COMPANY_CREDIT
	WHERE 
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			COMPANY_ID = #attributes.company_id#
		<cfelse>
			CONSUMER_ID = #attributes.consumer_id#
		</cfif>
		AND OUR_COMPANY_ID = #ATTRIBUTES.OUR_COMPANY_ID#
</cfquery>
<cfset other_money_value = listfirst(attributes.other_money,',')>
<cfif len(attributes.blacklist_date)>
	<cf_date tarih="attributes.blacklist_date">
</cfif>
<cflock timeout="60" name="#CreateUUID()#">
 <cftransaction>	
  <cfif get_credit_limit.recordcount eq 0>
	<cfif isdefined("form.OPEN_ACCOUNT_RISK_LIMIT") and len(form.OPEN_ACCOUNT_RISK_LIMIT)>
		<cfscript>
			StructInsert(form,"TOTAL_RISK_LIMIT","0");
			StructInsert(form,"TOTAL_RISK_LIMIT_OTHER","0");
			form.TOTAL_RISK_LIMIT = form.OPEN_ACCOUNT_RISK_LIMIT + FORWARD_SALE_LIMIT;		
			form.TOTAL_RISK_LIMIT_OTHER = form.OPEN_ACCOUNT_RISK_LIMIT_OTHER_CASH + FORWARD_SALE_LIMIT_OTHER_CASH;				
		</cfscript>
		<cfquery name="ADD_COMPANY_CREDIT" datasource="#dsn#" result="MAX_ID">
			INSERT INTO
				COMPANY_CREDIT
					(
						PROCESS_STAGE,
						COMPANY_ID,
						CONSUMER_ID,
						OPEN_ACCOUNT_RISK_LIMIT,
						OPEN_ACCOUNT_RISK_LIMIT_OTHER,
						FORWARD_SALE_LIMIT,
						FORWARD_SALE_LIMIT_OTHER,
						PAYMENT_BLOKAJ,
                        PAYMENT_BLOKAJ_TYPE,
						PAYMENT_RATE_TYPE,
						LAST_PAYMENT_INTEREST,
						FIRST_PAYMENT_INTEREST,
						PAYMETHOD_ID,
						CARD_PAYMETHOD_ID,
						REVMETHOD_ID,
						CARD_REVMETHOD_ID,
						MONEY,
						TOTAL_RISK_LIMIT ,
						TOTAL_RISK_LIMIT_OTHER,
						OUR_COMPANY_ID,
						SHIP_METHOD_ID,
						PRICE_CAT,
                        PRICE_CAT_PURCHASE,
						IS_INSTALMENT_INFO,
						TRANSPORT_COMP_ID,
						TRANSPORT_DELIVER_ID,
						IS_BLACKLIST,
						BLACKLIST_INFO,
						BLACKLIST_DATE,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP 
					)
				VALUES
					(
						#attributes.process_stage#,
						<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
							#attributes.company_id#,
							NULL,
						<cfelse>
							NULL,
							#attributes.consumer_id#,
						</cfif>
						<cfif LEN(FORM.OPEN_ACCOUNT_RISK_LIMIT)>#FORM.OPEN_ACCOUNT_RISK_LIMIT#<cfelse>NULL</cfif>,
						<cfif LEN(FORM.OPEN_ACCOUNT_RISK_LIMIT_OTHER_CASH)>#FORM.OPEN_ACCOUNT_RISK_LIMIT_OTHER_CASH#<cfelse>NULL</cfif>,
						<cfif LEN(FORM.FORWARD_SALE_LIMIT)>#FORM.FORWARD_SALE_LIMIT#<cfelse>NULL</cfif>,
						<cfif LEN(FORM.FORWARD_SALE_LIMIT_OTHER_CASH)>#FORM.FORWARD_SALE_LIMIT_OTHER_CASH#<cfelse>NULL</cfif>,
						<cfif LEN(FORM.PAYMENT_BLOKAJ)>#FORM.PAYMENT_BLOKAJ#,<cfelse>NULL,</cfif>
                        <cfif LEN(FORM.blokaj_type)>#form.blokaj_type#,<cfelse>NULL,</cfif>
						<cfif isdefined("FORM.rate_type") and LEN(FORM.rate_type)>#form.rate_type#,<cfelse>NULL,</cfif>
						<cfif LEN(FORM.LAST_PAYMENT_INTEREST)>#FORM.LAST_PAYMENT_INTEREST#<cfelse>NULL</cfif>,
						<cfif LEN(FORM.FIRST_PAYMENT_INTEREST)>#FORM.FIRST_PAYMENT_INTEREST#<cfelse>NULL</cfif>,
						<cfif len(form.paymethod_id) and len(form.paymethod_name)>#form.paymethod_id#<cfelse>NULL</cfif>,
						<cfif len(form.card_paymethod_id) and len(form.paymethod_name)>#form.card_paymethod_id#<cfelse>NULL</cfif>,
						<cfif len(form.revmethod_id) and len(form.revmethod_name)>#form.revmethod_id#<cfelse>NULL</cfif>,
						<cfif len(form.card_revmethod_id) and len(form.revmethod_name)>#form.card_revmethod_id#<cfelse>NULL</cfif>,
						<cfif LEN(FORM.OTHER_MONEY)>'#listgetat(FORM.OTHER_MONEY,1)#'<cfelse>NULL</cfif>,
						<cfif LEN(FORM.TOTAL_RISK_LIMIT)>#FORM.TOTAL_RISK_LIMIT#<cfelse>NULL</cfif>,
						<cfif LEN(FORM.TOTAL_RISK_LIMIT_OTHER)>#FORM.TOTAL_RISK_LIMIT_OTHER#<cfelse>NULL</cfif>,
						#FORM.OUR_COMPANY_ID#,
						<cfif isdefined("FORM.SHIP_METHOD_ID") and LEN(FORM.SHIP_METHOD_ID)>#FORM.SHIP_METHOD_ID#<cfelse>NULL</cfif>,
						<cfif isdefined("FORM.PRICE_CAT") and LEN(FORM.PRICE_CAT)>#FORM.PRICE_CAT#<cfelse>NULL</cfif>,
						<cfif isdefined("FORM.PRICE_CAT_PURCHASE") and LEN(FORM.PRICE_CAT_PURCHASE)>#FORM.PRICE_CAT_PURCHASE#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.instalment')>1<cfelse>0</cfif>,
						<cfif isdefined("attributes.transport_comp_id") and len(attributes.transport_comp_id) and isdefined("attributes.transport_comp_name") and len(attributes.transport_comp_name)>#attributes.transport_comp_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.transport_deliver_id") and len(attributes.transport_deliver_id) and isdefined("attributes.transport_comp_name") and len(attributes.transport_comp_name)>#attributes.transport_deliver_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.is_blacklist")>1<cfelse>0</cfif>,
						<cfif isdefined("attributes.is_blacklist") and len(attributes.blacklist_info)>#attributes.blacklist_info#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.is_blacklist") and len(attributes.blacklist_date)>#attributes.blacklist_date#<cfelse>NULL</cfif>,
						#now()#,
						#session.ep.userid#,
						'#cgi.remote_addr#'
					)
		</cfquery>
		<cfif isdefined("FORM.PRICE_CAT") and LEN(FORM.PRICE_CAT) and isdefined("attributes.company_id") and len(attributes.company_id)>
			<cfquery name="get_price_list" datasource="#dsn#">
				SELECT 
					* 
				FROM 
					#dsn#_#FORM.OUR_COMPANY_ID#.PRICE_CAT_EXCEPTIONS 
				WHERE 
					PRICE_CATID = #FORM.PRICE_CAT#
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
						PRICE_CATID = #FORM.PRICE_CAT#
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
						#FORM.PRICE_CAT#,
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
        <cfif isdefined("FORM.PRICE_CAT_PURCHASE") and LEN(FORM.PRICE_CAT_PURCHASE) and isdefined("attributes.company_id") and len(attributes.company_id)>
			<cfquery name="get_price_list" datasource="#dsn#">
				SELECT 
					* 
				FROM 
					#dsn#_#FORM.OUR_COMPANY_ID#.PRICE_CAT_EXCEPTIONS 
				WHERE 
					PRICE_CATID = #FORM.PRICE_CAT_PURCHASE#
					AND COMPANY_ID = #attributes.company_id#
					AND ACT_TYPE = 2
                    AND PURCHASE_SALES = 0
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
                        AND PURCHASE_SALES = 0
				</cfquery>
				<cfquery name="upd_price_list_for_company" datasource="#DSN#">
					UPDATE
						#dsn#_#FORM.OUR_COMPANY_ID#.PRICE_CAT_EXCEPTIONS
					SET
						IS_DEFAULT = 1
					WHERE
						PRICE_CATID = #FORM.PRICE_CAT_PURCHASE#
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
						#FORM.PRICE_CAT_PURCHASE#,
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
                     #MAX_ID.IDENTITYCOL#,
                     #evaluate("attributes.value_rate2#i#")#,
                     #evaluate("attributes.txt_rate1_#i#")#,
                     <cfif evaluate("attributes.hidden_rd_money_#i#") is other_money_value>1<cfelse>0</cfif>
                )
			</cfquery>
		</cfloop>
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			<cfset member_id_=attributes.company_id>
			<cfset member_url_='company_id=#attributes.company_id#'>
		<cfelse>
			<cfset member_id_=attributes.consumer_id>
			<cfset member_url_='consumer_id=#attributes.consumer_id#'>
		</cfif>
		<cf_workcube_process
			is_upd='1' 
			data_source='#dsn#' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='COMPANY_CREDIT'
			action_column='COMPANY_CREDIT_ID'
			action_id='#member_id_#'
			action_page='#request.self#?fuseaction=contract.list_contracts&event=upd&#member_url_#' 
			warning_description='Üye : #member_id_#'>
	</cfif>
	<cfelse>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='51035.Bir Üyeye Aynı Dönem İçin İki Farklı Risk Durumu Giremezsiniz'>!");
				history.go(0)
		</script>
		<cfabort>
	</cfif>
		
 </cftransaction>
</cflock>
<cfif not isdefined("attributes.is_popup")>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		<script type="text/javascript">
			window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=finance.list_credits&event=upd&company_id=<cfoutput>#attributes.company_id#&our_company_id=#attributes.our_company_id#</cfoutput>';
		</script>
	<cfelse>
		<script type="text/javascript">
			window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=finance.list_credits&event=upd&consumer_id=<cfoutput>#attributes.consumer_id#&our_company_id=#attributes.our_company_id#</cfoutput>';
		</script>
	</cfif>
<cfelse>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>


 
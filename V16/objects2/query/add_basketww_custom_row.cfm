<cfscript>
	if (listfindnocase(partner_url,'#cgi.http_host#',';'))
	{
		int_userid = session.pp.userid;
		int_money = session.pp.money;
		int_comp_id = session.pp.our_company_id;
		int_period_id = session.pp.period_id;
		int_money2 = session.pp.money2;
	}
	else if (listfindnocase(server_url,'#cgi.http_host#',';') )
	{	
		int_userid = session.ww.userid;
		int_money = session.ww.money;
		int_comp_id = session.ww.our_company_id;
		int_period_id = session.ww.period_id;
		int_money2 = session.ww.money2;
	}
</cfscript>
<cfquery name="GET_PRODUCT_CUST" datasource="#DSN3#">
	SELECT
		PRODUCT_ID,
		PRODUCT_NAME,
		TAX,
		PROPERTY,
		PRODUCT_UNIT_ID,
		STOCK_ID
	FROM
		STOCKS
	WHERE
		STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_stock_id#">
</cfquery>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT
		COMPANY_ID,
		PERIOD_ID,
		MONEY,
		RATE1,
		<cfif isDefined("session.pp")>
            RATEPP2 RATE2
        <cfelse>
            RATEWW2 RATE2
        </cfif>
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#"> AND
		MONEY_STATUS = 1
</cfquery>
	
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_MAIN_PRODUCT_" datasource="#DSN3#">
			INSERT INTO
				ORDER_PRE_ROWS
				(
					PRODUCT_ID,
					PRODUCT_NAME,
					QUANTITY,
					PRICE,
					PRICE_KDV,
					PRICE_MONEY,
					TAX,
					STOCK_ID,
					PRODUCT_UNIT_ID,
					PROM_ID,
					PROM_DISCOUNT,
					PROM_AMOUNT_DISCOUNT,
					PROM_COST,
					PROM_MAIN_STOCK_ID,
					PROM_STOCK_AMOUNT,
					IS_PROM_ASIL_HEDIYE,
					PROM_FREE_STOCK_ID,
					PRICE_OLD,
					IS_COMMISSION,
					PRICE_STANDARD,
					PRICE_STANDARD_KDV,
					PRICE_STANDARD_MONEY,
                    IS_NONDELETE_PRODUCT,
					RECORD_PERIOD_ID,
					RECORD_PAR,
					RECORD_CONS,
					RECORD_GUEST,
					COOKIE_NAME,
					RECORD_IP,
					RECORD_DATE
                )
                VALUES
                (
					#get_product_cust.product_id#,
					<cfif get_product_cust.property is '-'>'#get_product_cust.product_name#'<cfelse>'#get_product_cust.product_name# #get_product_cust.property#'</cfif>,
					1,
					#attributes.total_price_stdmoney_other#,
					#attributes.total_price_kdvli_stdmoney_other#,
					'#money_type#',
					#get_product_cust.tax#,
					#get_product_cust.stock_id#,
					#get_product_cust.product_unit_id#,
					NULL,
					NULL,
					0,
					NULL,
					NULL,
					1,
					0,
					0,
					NULL,
					0,
					#attributes.total_price_standart#,
					#attributes.total_price_standart_kdv#,
					'#attributes.price_standard_money#',
					0,
                    #session_base.period_id#,
					<cfif isdefined("session.pp")>#session.pp.userid#<cfelse>NULL</cfif>,
					<cfif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
					<cfif not isdefined("session.pp") and not isdefined("session.ww.userid")>1<cfelse>0</cfif>,
					<cfif isdefined("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>'#wrk_eval("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#'<cfelse>NULL</cfif>,
					'#cgi.remote_addr#',
					#now()#
				)
		</cfquery>
		<cfquery name="GET_LAST" datasource="#DSN3#">
			SELECT MAX(ORDER_ROW_ID) AS LATEST_ORDER_ROW_ID FROM ORDER_PRE_ROWS
		</cfquery>
	</cftransaction>
</cflock>
	
<cfif attributes.is_change eq 1>
	<cfquery name="UPD_" datasource="#DSN3#">
		UPDATE 
			ORDER_PRE_ROWS 
		SET
			IS_SPEC = 1,
			SPEC_TYPE = 1,
			SPEC_TOTAL_AMOUNT = #attributes.total_price_stdmoney#,
			SPEC_OTHER_MONEY = '#int_money2#',
			SPEC_OTHER_TOTAL_AMOUNT = #attributes.total_price_stdmoney_other#,
			SPEC_PRODUCT_AMOUNT = #attributes.total_amount#,
			SPEC_PRODUCT_AMOUNT_MONEY = '#attributes.money_type#'
		WHERE
			ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_last.latest_order_row_id#">
	</cfquery>
	
	<cfscript>
		toplam_spect_maliyet = 0;
		satir_tree=0;
	</cfscript>
	
	<cfif len(attributes.tree_product_num)>
		<cfloop from="1" to="#attributes.tree_product_num#" index="sr">
			<cfif listlen(evaluate("attributes.tree_product_id#sr#"))>
				<cfquery name="GET_COST" datasource="#DSN1#">
					SELECT 
						PRODUCT_COST,
						PRODUCT_COST_ID,
						MONEY 
					FROM 
						PRODUCT_COST 
					WHERE 
						PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(evaluate("attributes.tree_product_id#sr#"),1,',')#"> AND
						START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					ORDER BY 
						START_DATE DESC,
						RECORD_DATE DESC
				</cfquery>
				
				<cfif get_cost.recordcount and len(get_cost.product_cost)>
					<cfset satir_maliyet=get_cost.product_cost>
				<cfelse>
					<cfset satir_maliyet=0>
				</cfif>
				
				<cfquery name="ADD_SPEC_ROWS" datasource="#DSN3#">
					INSERT INTO
						ORDER_PRE_ROWS_SPECS
						(
							MAIN_ORDER_ROW_ID,
							PRODUCT_ID,
							STOCK_ID,
							PRODUCT_NAME,
							AMOUNT,
							TOTAL_VALUE,
							MONEY_CURRENCY,
							IS_CONFIGURE,
							DIFF_PRICE,
							IS_PROPERTY,
							IS_SEVK,
							PROPERTY_ID,
							VARIATION_ID,
							ROW_MONEY,
							PRODUCT_COST_ID,
							ROW_COST
						)
						VALUES
						(
							#get_last.latest_order_row_id#,
							#listgetat(evaluate("attributes.tree_product_id#sr#"),1,',')#,
							#listgetat(evaluate("attributes.tree_product_id#sr#"),2,',')#,
							'#left(evaluate("attributes.tree_product_name#sr#"),250)#',
							#evaluate("attributes.tree_amount#sr#")#,
							#listgetat(evaluate("attributes.tree_product_id#sr#"),3,',')#,
							'#listgetat(evaluate("attributes.tree_product_id#sr#"),4,',')#',
							<cfif isdefined('attributes.tree_is_configure#sr#')>1,<cfelse>0,</cfif>
							<cfif len(evaluate('attributes.tree_total_amount#sr#'))>#evaluate('attributes.tree_total_amount#sr#')#,<cfelse>0,</cfif>
							0,
							<cfif isdefined("attributes.tree_is_sevk#sr#") and evaluate('attributes.tree_is_sevk#sr#') eq 1>1,<cfelse>0,</cfif>
							NULL,
							NULL,
							<cfif get_cost.recordcount and len(get_cost.money)>'#get_cost.money#',<cfelse>NULL,</cfif>
							<cfif get_cost.recordcount and len(get_cost.product_cost_id)>#get_cost.product_cost_id#,<cfelse>NULL,</cfif>
							#satir_maliyet#							
							)
				</cfquery>
				<cfscript>
					money_=listgetat(evaluate("attributes.tree_product_id#sr#"),4,',');
					if(get_cost.recordcount and len(get_cost.money) and attributes.money_type neq get_cost.money)
					{
						GET_ROW_MONEY=cfquery(SQLString:"SELECT	MONEY,(RATE1/RATE2) RATE FROM GET_MONEY WHERE MONEY='#money_#'",datasource:'',dbtype:"query");
						satir_maliyet=satir_maliyet*GET_ROW_MONEY.RATE;
					}
					toplam_spect_maliyet=toplam_spect_maliyet+satir_maliyet;
				</cfscript>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfquery name="UPD_" datasource="#DSN3#">
		UPDATE 
			ORDER_PRE_ROWS 
		SET
			SPEC_COST = #toplam_spect_maliyet#,
			SPEC_COST_MONEY = '#attributes.money_type#'
		WHERE
			ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_last.latest_order_row_id#">
	</cfquery>
</cfif>
<script type="text/javascript">
	window.opener.location = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.list_basket";
	window.close();
</script>
<cfabort>

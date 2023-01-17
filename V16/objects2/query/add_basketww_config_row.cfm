<cfscript>
	if(listfindnocase(partner_url,'#cgi.http_host#',';'))
	{
		int_userid = session.pp.userid;
		int_money = session.pp.money;
		int_comp_id = session.pp.our_company_id;
		int_period_id = session.pp.period_id;
		int_money2 = session.pp.money2;
	}
	else if(listfindnocase(server_url,'#cgi.http_host#',';') and isdefined("session.ww.userid") )
	{	
		int_userid = session.ww.userid;
		int_money = session.ww.money;
		int_comp_id = session.ww.our_company_id;
		int_period_id = session.ww.period_id;
		int_money2 = session.ww.money2;
	}
	else
	{
		int_money = session.ww.money;
		int_comp_id = session.ww.our_company_id;
		int_period_id = session.ww.period_id;
		int_money2 = session.ww.money2;
	}
</cfscript>
<cfquery name="GET_SPECT_NAME" datasource="#DSN3#">
	SELECT CONFIGURATOR_NAME FROM SETUP_PRODUCT_CONFIGURATOR WHERE PRODUCT_CONFIGURATOR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_configurator_id#">
</cfquery>
<cfquery name="GET_PRODUCT_CONF" datasource="#DSN3#">
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
		STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.get_key_product1')#">
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
					IS_SPEC,
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
					#get_product_conf.product_id#,
					'#get_spect_name.configurator_name#',
					1,
					#attributes.main_total_price#,
					#attributes.main_total_price_kdv#,
					'#int_money#',
					#get_product_conf.tax#,
					#get_product_conf.stock_id#,
					#get_product_conf.product_unit_id#,
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
					NULL,
					NULL,
					NULL,
					1,
                    0,
					#session_base.period_id#,
					<cfif isdefined("session.pp")>#session.pp.userid#<cfelse>NULL</cfif>,
					<cfif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
					<cfif not isdefined("session.pp") and not isdefined("session.ww.userid")>1<cfelse>0</cfif>,
					<cfif isdefined("cookie.wrk_basket_#cgi.http_host#")>'#wrk_eval("cookie.wrk_basket_#cgi.http_host#")#'<cfelse>NULL</cfif>,
					'#cgi.remote_addr#',
					#now()#
				)
		</cfquery>
		<cfquery name="GET_LAST" datasource="#DSN3#">
			SELECT MAX(ORDER_ROW_ID) AS LATEST_ORDER_ROW_ID FROM ORDER_PRE_ROWS
		</cfquery>
		<cfif len(attributes.record_num)>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfscript>
					form_stock_id = evaluate("attributes.get_key_product#i#");
					form_amount = evaluate("attributes.amount#i#");
					form_value_total_price = evaluate("attributes.value_total_price#i#");
					form_money_type = evaluate("attributes.money_type#i#");
					form_property_id = evaluate("attributes.property_id#i#");
				</cfscript>
				<cfquery name="GET_PRODUCT_ID" datasource="#DSN3#">
					SELECT PRODUCT_ID, PRODUCT_NAME,TAX FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form_stock_id#">
				</cfquery>
				<cfif get_product_id.recordcount>				
                    <cfquery name="GET_COST" datasource="#DSN3#">
                        SELECT 
                            PRODUCT_COST,
                            PRODUCT_COST_ID,
                            MONEY 
                        FROM 
                            #dsn1_alias#.PRODUCT_COST 
                        WHERE 
                            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_id.product_id#"> AND 
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
                                #get_product_id.product_id#,
                                #form_stock_id#,
                                '#get_product_id.product_name#',
                                #form_amount#,
                                #form_value_total_price#,
                                '#form_money_type#',
                                1,
                                0,
                                0,
                                0,
                                NULL,
                                NULL,
                                <cfif get_cost.recordcount and len(get_cost.money)>'#get_cost.money#',<cfelse>NULL,</cfif>
                                <cfif get_cost.recordcount and len(get_cost.product_cost_id)>#get_cost.product_cost_id#,<cfelse>NULL,</cfif>
                                #satir_maliyet#							
                       		)
                    </cfquery>
				</cfif>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=objects2.list_basket" addtoken="no">

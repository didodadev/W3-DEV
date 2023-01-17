<cfif isdefined("attributes.consumer_id")>
	<cfset session.ww.basket_cons_id = attributes.consumer_id>
</cfif>

<cfif not isdefined("ajax")>
	<form name="pop_gonder" action="<cfoutput>#request.self#?fuseaction=objects2.form_add_orderww</cfoutput>" method="post">
		<cfoutput>
			<cfif isdefined("attributes.paymethod_id_com") and len(attributes.paymethod_id_com)><input type="hidden" name="paymethod_id_com" id="paymethod_id_com" value="#attributes.paymethod_id_com#"></cfif>
			<cfif isdefined('attributes.order_from_basket_express') and attributes.order_from_basket_express eq 1>
				<input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
				<input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
				<input type="hidden" name="partner_id" id="partner_id" value="#attributes.partner_id#">
				<input type="hidden" name="order_from_basket_express" id="order_from_basket_express" value="1">
			</cfif>
		</cfoutput>
	</form>
</cfif>
<cfif not isdefined("session.pp") and not isdefined("session.ww.userid") and not IsDefined("Cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
	<cfset cookie_name_ = createUUID()>
	<cfcookie name="wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#cookie_name_#" expires="1">
</cfif>
<cfquery name="DEL_COM_ROWS" datasource="#DSN3#">
	DELETE FROM 
		ORDER_PRE_ROWS
	WHERE
	<cfif isdefined("session.pp")>
		RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
	<cfelseif isdefined("session.ww.userid")>
		RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
	<cfelseif isdefined("session.ep")>
		RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
	<cfelseif not isdefined("session_base.userid")>
		RECORD_GUEST = 1 AND
		RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
		COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#"> AND
	</cfif>
		IS_COMMISSION = 1
</cfquery>

<cfif isDefined("attributes.is_cargo") and attributes.is_cargo eq 1>
	<cfquery name="DEL_COM_ROWS" datasource="#DSN3#">
		DELETE FROM ORDER_PRE_ROWS
		WHERE
			<cfif isdefined("session.pp")>
				RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
			<cfelseif isdefined("session.ww.userid")>
				RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
			<cfelseif isdefined("session.ep")>
				RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
			<cfelseif not isdefined("session_base.userid")>
				RECORD_GUEST = 1 AND 
				RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
				COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#"> AND
			</cfif>
			(IS_CARGO = 1 OR IS_DISCOUNT = 1 OR IS_DISCOUNT = 2)
	</cfquery>
</cfif>
<cfif fusebox.use_stock_speed_reserve and not (isDefined("attributes.is_commission") or isdefined("attributes.is_cargo"))><!---kargo ve komisyon satırı haricinde urun ekleme buraya yonlendiriliyor  --->
	<cfset attributes.add_stock_id=attributes.sid>
	<cfset attributes.add_stock_amount=attributes.istenen_miktar>
	<cfinclude template="add_basket_row_expres.cfm"> <!--- hızlı sipariş ekleme sayfası, stok stratejilerine gore urun ekliyor --->
	<cfquery name="GET_LAST" datasource="#DSN3#">
		SELECT MAX(ORDER_ROW_ID) AS LATEST_ORDER_ROW_ID FROM ORDER_PRE_ROWS
	</cfquery>
<cfelse>
	<cfif isDefined('attributes.sid') and attributes.sid gt 0>
		<cfquery datasource="#DSN3#" name="GET_STOCK" maxrows="1">
			SELECT
				IS_KARMA,
				IS_PROTOTYPE,
				PRODUCT_ID,
				PRODUCT_NAME,
				TAX,
				PROPERTY,
				PRODUCT_UNIT_ID
			FROM
				STOCKS
			WHERE
				STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
		</cfquery>
	<cfelse>
		<cfscript>
			get_stock.is_karma = 0;
			get_stock.is_prototype = 0;
			get_stock.product_id = -1;
			if(attributes.is_discount eq 1)
				get_stock.product_name = 'Para Puan İndirimi';
			else if(attributes.is_discount eq 2)
				get_stock.product_name = 'Hediye Çeki İndirimi';
			else if(attributes.is_discount eq 3)
				get_stock.product_name = 'İndirim Kuponu İndirimi';
			get_stock.tax = '0';
			get_stock.property = '';
			get_stock.product_unit_id = '1';
		</cfscript>
	</cfif>
	<!--- ana urun kayit --->
	<cfset attributes.is_prom_asil_hediye = 0>
	<cftransaction>
		<cfquery name="ADD_MAIN_PRODUCT_" datasource="#DSN3#">
			INSERT INTO
				ORDER_PRE_ROWS
                (
                    PRODUCT_ID,
                    CATALOG_ID,
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
                    IS_CARGO,
                    IS_DISCOUNT,
                    PRICE_STANDARD,
                    PRICE_STANDARD_KDV,
                    PRICE_STANDARD_MONEY,
                    <cfif isdefined("attributes.is_from_seri_sonu") and attributes.is_from_seri_sonu eq 1>
                        IS_FROM_SERI_SONU,
                        SERI_SONU_DEPARTMENT_ID,
                        SERI_SONU_LOCATION_ID,
                    <cfelse>
                        IS_FROM_SERI_SONU,
                    </cfif>
                    RECORD_PERIOD_ID,
                    RECORD_PAR,
                    RECORD_CONS,
                    RECORD_GUEST,
                    RECORD_EMP,
                    COOKIE_NAME,
                    TO_CONS,
                    TO_PAR,
                    TO_COMP,
                    IS_PART,
                    SPEC_VAR_NAME,
                    SPEC_VAR_ID,
                    ORDER_ROW_DETAIL,
                    ORDER_INFO_TYPE_ID,
                    LOT_NO,
                    DIFF_RATE_ID,
                    DISCOUNT1,
                    IS_NONDELETE_PRODUCT,
                    RECORD_IP,
                    RECORD_DATE
                )
                VALUES
                (
                    #get_stock.product_id#,
                    <cfif isdefined("attributes.catalog_id") and len(attributes.catalog_id)>#attributes.catalog_id#,<cfelse>NULL,</cfif>
                    <cfif trim(get_stock.property) is '-'>'#get_stock.product_name#'<cfelse>'#get_stock.product_name# #get_stock.property#'</cfif>,
                    #attributes.istenen_miktar#,
                    #attributes.price#,
                    #attributes.price_kdv#,
                    '#attributes.price_money#',
                    #get_stock.tax#,
                    <cfif isDefined('attributes.sid') and len(attributes.sid)>#attributes.sid#<cfelse>NULL</cfif>,
                    #get_stock.product_unit_id#,
                    <cfif len(attributes.prom_free_stock_id) and attributes.is_no_prom eq 1>
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                    <cfelse>
                        <cfif len(attributes.prom_id)>#attributes.prom_id#<cfelse>NULL</cfif>,
                        <cfif len(attributes.prom_discount)>#attributes.prom_discount#<cfelse>NULL</cfif>,
                        <cfif len(attributes.prom_amount_discount)>#attributes.prom_amount_discount#<cfelse>NULL</cfif>,
                        <cfif len(attributes.prom_cost)>#attributes.prom_cost#<cfelse>NULL</cfif>,
                    </cfif>
                    <cfif isDefined('attributes.sid') and len(attributes.sid)>#attributes.sid#<cfelse>NULL</cfif>,
                    #attributes.prom_stock_amount#,
                    #attributes.is_prom_asil_hediye#,
                    <cfif len(attributes.prom_free_stock_id) and attributes.is_no_prom neq 1>1<cfelse>0</cfif>,
                    <cfif len(attributes.price_old)>#attributes.price_old#<cfelse>NULL</cfif>,
                    <cfif isDefined("attributes.is_commission") and attributes.is_commission eq 1>1<cfelse>0</cfif>,
                    <cfif isDefined("attributes.is_cargo") and attributes.is_cargo eq 1>1<cfelse>0</cfif>,
                    <cfif isDefined("attributes.is_discount") and len(attributes.is_discount)>#attributes.is_discount#<cfelse>0</cfif>,
                    #attributes.price_standard#,
                    #attributes.price_standard_kdv#,
                    '#attributes.price_standard_money#',
                    <cfif isdefined("attributes.is_from_seri_sonu") and attributes.is_from_seri_sonu eq 1>
                        1,
                        #attributes.seri_sonu_department_id#,
                        #attributes.seri_sonu_location_id#,
                    <cfelse>
                        0,
                    </cfif>
                    #session_base.period_id#,
                    <cfif isdefined("session.pp")>#session.pp.userid#<cfelse>NULL</cfif>,
                    <cfif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
                    <cfif not isdefined("session_base.userid")>1<cfelse>0</cfif>,
                    <cfif isdefined("session.ep")>#session.ep.userid#<cfelse>NULL</cfif>,
                    <cfif isdefined("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>'#wrk_eval("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#'<cfelse>NULL</cfif>,
                    <cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>
                    <cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#,<cfelse>NULL,</cfif>
                    <cfif isDefined("attributes.company_id") and len(attributes.company_id)>#attributes.company_id#,<cfelse>NULL,</cfif>
                    <cfif isdefined('attributes.is_part') and attributes.is_part eq 1>1<cfelse>0</cfif>,
                    <cfif isdefined('attributes.spec_var_name') and len(attributes.spec_var_name)>'#attributes.spec_var_name#'<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.spec_var_id') and len(attributes.spec_var_id)>#attributes.spec_var_id#<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.basket_row_detail') and len(attributes.basket_row_detail)>'#attributes.basket_row_detail#'<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.basket_info_id') and len(attributes.basket_info_id)>#attributes.basket_info_id#<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.basket_lot_no') and len(attributes.basket_lot_no)>'#attributes.basket_lot_no#'<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.diff_rate_values') and len(attributes.diff_rate_values)>'#attributes.diff_rate_values#'<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.discount1') and len(attributes.discount1)>#attributes.discount1#<cfelse>NULL</cfif>,
                    0,
                    '#cgi.remote_addr#',
                    #now()#
                )
		</cfquery>
		<cfquery name="GET_LAST" datasource="#DSN3#">
			SELECT MAX(ORDER_ROW_ID) AS LATEST_ORDER_ROW_ID FROM ORDER_PRE_ROWS
		</cfquery>
	</cftransaction>
	<!--- ana urun kayit --->
	<cfif len(attributes.prom_free_stock_id) and attributes.is_no_prom neq 1>
		<cfquery name="GET_PROM_FREE_STOCK" datasource="#DSN3#">
			SELECT 
				PRODUCT_ID, 
				PRODUCT_NAME, 
				TAX, 
				PRODUCT_UNIT_ID, 
				PROPERTY
			FROM 
				STOCKS
			WHERE 
				STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_free_stock_id#">
		</cfquery>
		<cfif get_prom_free_stock.recordcount>
			<cfset attributes.is_prom_asil_hediye = 1>
			<cfset attributes.is_prom_free_stock = 1>
			<cftransaction>
				<cfquery name="ADD_MAIN_PRODUCT_" datasource="#DSN3#">
					INSERT INTO
						ORDER_PRE_ROWS
							(
								MAIN_ORDER_ROW_ID,
								PRODUCT_ID,
								PRODUCT_NAME,
								QUANTITY,
								PROM_PRODUCT_PRICE,
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
								RECORD_PERIOD_ID,
								RECORD_PAR,
								RECORD_CONS,
								RECORD_GUEST,
								RECORD_EMP,
								COOKIE_NAME,
								TO_CONS,
								TO_PAR,
								TO_COMP,
								IS_PART,
								SPEC_VAR_NAME,
								SPEC_VAR_ID,
								ORDER_ROW_DETAIL,
								ORDER_INFO_TYPE_ID,
								LOT_NO,
								DIFF_RATE_ID,
								DISCOUNT1,
                                IS_NONDELETE_PRODUCT,
								RECORD_IP,
								RECORD_DATE
							)
							VALUES
							(
								#get_last.latest_order_row_id#,
								#get_prom_free_stock.product_id#,
								<cfif trim(get_prom_free_stock.property) is '-'>'#get_prom_free_stock.product_name#'<cfelse>'#get_prom_free_stock.product_name# #get_prom_free_stock.property#'</cfif>,
								#attributes.istenen_miktar#,
								#attributes.prom_free_stock_price#,
								#attributes.prom_free_stock_price#,
								#attributes.prom_free_stock_price * (1 + (get_prom_free_stock.tax / 100))#,
								'#attributes.prom_free_stock_money#',
								#get_prom_free_stock.tax#,
								#attributes.prom_free_stock_id#,
								#get_prom_free_stock.product_unit_id#,
								#attributes.prom_id#,
								NULL,
								NULL,
								NULL,
								<cfif isDefined('attributes.sid') and len(attributes.sid)>#attributes.sid#<cfelse>NULL</cfif>,
								#attributes.prom_free_stock_amount#,
								#attributes.is_prom_asil_hediye#,
								1,
								NULL,
								<cfif isDefined("attributes.is_commission") and attributes.is_commission eq 1>1<cfelse>0</cfif>,
								0,
								0,
								NULL,
								#session_base.period_id#,
								<cfif isdefined("session.pp")>#session.pp.userid#<cfelse>NULL</cfif>,
								<cfif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
								<cfif not isdefined("session_base.userid")>1<cfelse>0</cfif>,
								<cfif isdefined("session.ep")>#session.ep.userid#<cfelse>NULL</cfif>,
								<cfif isdefined("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>'#wrk_eval("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#'<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>
								<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#,<cfelse>NULL,</cfif>
								<cfif isDefined("attributes.company_id") and len(attributes.company_id)>#attributes.company_id#,<cfelse>NULL,</cfif>
								<cfif isdefined('attributes.is_part') and attributes.is_part eq 1>1<cfelse>0</cfif>,
								<cfif isdefined('attributes.spec_var_name') and len(attributes.spec_var_name)>'#attributes.spec_var_name#'<cfelse>NULL</cfif>,
								<cfif isdefined('attributes.spec_var_id') and len(attributes.spec_var_id)>#attributes.spec_var_id#<cfelse>NULL</cfif>,
								<cfif isdefined('attributes.basket_row_detail') and len(attributes.basket_row_detail)>'#attributes.basket_row_detail#'<cfelse>NULL</cfif>,
								<cfif isdefined('attributes.basket_info_id') and len(attributes.basket_info_id)>#attributes.basket_info_id#<cfelse>NULL</cfif>,
								<cfif isdefined('attributes.basket_lot_no') and len(attributes.basket_lot_no)>'#attributes.basket_lot_no#'<cfelse>NULL</cfif>,
								<cfif isdefined('attributes.diff_rate_values') and len(attributes.diff_rate_values)>'#attributes.diff_rate_values#'<cfelse>NULL</cfif>,
								<cfif isdefined('attributes.discount1') and len(attributes.discount1)>#attributes.discount1#<cfelse>NULL</cfif>,
								0,
                                '#cgi.remote_addr#',
								#now()#
							)
				</cfquery>
			</cftransaction>
		<cfelse>
			<script type="text/javascript">
				alert("<cf_get_lang no ='1397.Promosyonda bedava verilen ürün ile ilgili bir sorun olduğu için sepete eklenmeyecektir'>.");
			</script>
		</cfif>
	</cfif>
</cfif>
<cfif not isdefined("ajax")>
	<script type="text/javascript">
		if(parent.form_basket_ww) 
			parent.form_basket_ww.location.reload();
		else if(parent.form_basket_list_base) 
			parent.form_basket_list_base.submit();
		else
		{ 
			//Hızlı siparişten geldiği için arka sayfayı yeniliyoruz
			<cfif isdefined('is_from_popup')> 
				if(parent.window.opener.form_basket_list_base)
					parent.window.opener.form_basket_list_base.submit();
			</cfif> 
		}

		<cfif isDefined("attributes.is_commission")>
			pop_gonder.submit();
		<cfelse>
			window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_iframe_form_basket';
			//history.back();
		</cfif>

		<cfif isDefined('session.ww.userid') or isDefined('session.pp.userid')>
			foundO_ = parent.document.getElementById('show_special_basket');
			if(foundO_)
			{
				parent.run_special_basket();
			}
			found1_ = parent.document.getElementById('show_special_popup_basket');
			if(found1_)
			{
				parent.run_special_popup_basket();
			}
		</cfif>
	</script>
</cfif>

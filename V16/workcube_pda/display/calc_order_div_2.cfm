<cfsetting showdebugoutput="no">

<cfif isdefined('attributes.price_list_id') and attributes.price_list_id gt 0>
	<cfset attributes.price_catid = attributes.price_list_id>
</cfif>

<cfif isdefined('attributes.basket_products')>
	<cf_date tarih='attributes.price_date'>
	<cfset attributes.search_process_date = attributes.price_date><!--- indirimler için --->	
	<cfquery name="GET_BARCODE_INFO" datasource="#DSN3#">
		SELECT STOCK_ID,BARCODE FROM STOCKS_BARCODES WHERE BARCODE IN (#listqualify(attributes.basket_products,"'")#)
	</cfquery>
	<cfset problem_barcodes = ''>
	<cfloop list="#attributes.basket_products#" index="brcd">
		<cfif not listfind(valuelist(get_barcode_info.barcode),brcd)>
			<cfset problem_barcodes = listappend(problem_barcodes,brcd)>
		</cfif>
	</cfloop>

	<cfquery name="GET_BARCODE_INFO_W_OUT_STOCK" datasource="#DSN3#">        
        	SELECT 
        		GSL.SALEABLE_STOCK,
			SB.BARCODE,
			GSL.STOCK_ID,
			STOCKS.PRODUCT_NAME
        	FROM 
			<cfoutput>#dsn2_alias#</cfoutput>.GET_STOCK_LAST GSL, 
			STOCKS_BARCODES SB,STOCKS
	        WHERE 
        		STOCKS.STOCK_ID = SB.STOCK_ID AND 
        		GSL.STOCK_ID = SB.STOCK_ID AND 
        		SB.BARCODE IN (#listqualify(attributes.basket_products,"'")#) AND 
        	    	SALEABLE_STOCK <= 0       
	</cfquery>
	
    <cfif isdefined("attributes.order_id") and len(attributes.order_id) AND get_barcode_info_w_out_stock.recordcount>
		<cfquery name="GET_ORDER_ROW_STOCK" datasource="#DSN3#">
			SELECT 
				QUANTITY,
				STOCK_ID
			FROM 
				ORDER_ROW
			WHERE 
				ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> 
        	</cfquery>

		<cfif cgi.http_host eq 'pdacube3.timesaat.com'>
			<cfset stocks_id_list = ''>
			<cfloop query="GET_ORDER_ROW_STOCK">
				<cfif not listfind(stocks_id_list,stock_id)>
					<cfset stocks_id_list = listappend(stocks_id_list,stock_id)>
				</cfif>
			</cfloop>

			<cfquery name="GET_STOCKOUT_BARCODE" dbtype="query">
				SELECT
					GET_BARCODE_INFO_W_OUT_STOCK.*
				FROM
					GET_BARCODE_INFO_W_OUT_STOCK
				WHERE
					GET_BARCODE_INFO_W_OUT_STOCK.STOCK_ID NOT IN (#stocks_id_list#)
			</cfquery>
		</cfif>
		
		<cfquery name="GET_BARCODE_INFO_W_OUT_STOCK" dbtype="query">        
				SELECT 
					GET_BARCODE_INFO_W_OUT_STOCK.*
				FROM 
						GET_BARCODE_INFO_W_OUT_STOCK,
					GET_ORDER_ROW_STOCK
				WHERE 
					GET_BARCODE_INFO_W_OUT_STOCK.STOCK_ID = GET_ORDER_ROW_STOCK.STOCK_ID AND
					GET_BARCODE_INFO_W_OUT_STOCK.SALEABLE_STOCK + GET_ORDER_ROW_STOCK.QUANTITY <= 0  
					<cfif cgi.http_host eq 'pdacube3.timesaat.com'>
						UNION
							SELECT
								GET_BARCODE_INFO_W_OUT_STOCK.*
							FROM
								GET_BARCODE_INFO_W_OUT_STOCK
							WHERE
								GET_BARCODE_INFO_W_OUT_STOCK.STOCK_ID NOT IN (#stocks_id_list#)
					</cfif>
		</cfquery>
	</cfif>

	<!---<cfif cgi.http_host eq 'pdacube3.timesaat.com'>	
		<cfset stocks_id_list = ''>
		<cfloop query="GET_ORDER_ROW_STOCK">
			<cfif not listfind(stocks_id_list,stock_id)>
				<cfset stocks_id_list = listappend(stocks_id_list,stock_id)>
			</cfif>
		</cfloop>
		<cfquery name="GET_PROB_BARCODE" datasource="#DSN3#">        
        		SELECT 
        			GSL.SALEABLE_STOCK,
				SB.BARCODE,
				GSL.STOCK_ID,
				STOCKS.PRODUCT_NAME
        		FROM 
				<cfoutput>#dsn2_alias#</cfoutput>.GET_STOCK_LAST GSL, 
				STOCKS_BARCODES SB,STOCKS
	       		 WHERE 
        			STOCKS.STOCK_ID = SB.STOCK_ID AND 
        			GSL.STOCK_ID = SB.STOCK_ID AND 
        			SB.BARCODE IN (#listqualify(attributes.basket_products,"'")#) AND 
				GSL.STOCK_ID NOT IN (#stocks_id_list#) AND
        	    		SALEABLE_STOCK <= 0       
		</cfquery>
		<cfloop query="get_prob_barcode">
			<cfif not listfind(problem_barcodes,barcode)>
				<cfset problem_barcodes = listappend(problem_barcodes,barcode)>
			</cfif>
		</cfloop>
	</cfif>--->
	<cfif len(valuelist(get_barcode_info.stock_id))>
		<cfquery name="GET_PRODUCT_INFO" datasource="#DSN3#">
			SELECT
				DISTINCT
				SB.BARCODE,
				STOCKS.PRODUCT_ID,
				STOCKS.PRODUCT_NAME,
				STOCKS.PRODUCT_CODE,
				STOCKS.BARCOD,
				STOCKS.PROPERTY,		
				STOCKS.STOCK_ID,
				STOCKS.TAX,
				STOCKS.MANUFACT_CODE,
				PU.ADD_UNIT,
				PU.PRODUCT_UNIT_ID,
				PU.MULTIPLIER
				<cfif isdefined('attributes.price_list_id') and attributes.price_list_id gt 0>
					,
					PRICE.PRICE,
					PRICE.MONEY		
				<cfelseif isdefined('attributes.price_list_id') and attributes.price_list_id is 0>
					,
					PRICE_STANDART.PRICE,
					PRICE_STANDART.MONEY
				<cfelse>
					,
					PRICE_STANDART.PRICE,
					PRICE_STANDART.MONEY
				</cfif>		
			FROM
				STOCKS,
				PRODUCT_UNIT AS PU,
				STOCKS_BARCODES SB
				<cfif isdefined('attributes.price_list_id') and attributes.price_list_id gt 0>
					,PRICE
				<cfelseif isdefined('attributes.price_list_id') and attributes.price_list_id is 0>
					,PRICE_STANDART
				<cfelse>
					,PRICE_STANDART
				</cfif>		
			WHERE
				STOCKS.PRODUCT_STATUS = 1 AND
				STOCKS.STOCK_STATUS = 1 AND
				STOCKS.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
				STOCKS.PRODUCT_ID = PU.PRODUCT_ID AND
				PU.MAIN_UNIT = PU.ADD_UNIT AND
				SB.STOCK_ID = STOCKS.STOCK_ID AND
				<cfif isdefined('attributes.price_list_id') and attributes.price_list_id gt 0>
					STOCKS.PRODUCT_ID = PRICE.PRODUCT_ID AND
					PRICE.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_list_id#"> AND
					(
						PRICE.STARTDATE <= #attributes.price_date# AND
						(PRICE.FINISHDATE >= #attributes.price_date# OR PRICE.FINISHDATE IS NULL)
					)
				<cfelseif isdefined('attributes.price_list_id') and attributes.price_list_id is 0>
					STOCKS.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
					PRICE_STANDART.PURCHASESALES = 1 AND
					PRICE_STANDART.PRICESTANDART_STATUS = 1 
				<cfelse>
					STOCKS.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
					PRICE_STANDART.PURCHASESALES = 1 AND
					PRICE_STANDART.PRICESTANDART_STATUS = 1 
				</cfif>
					AND SB.STOCK_ID IN (#valuelist(GET_BARCODE_INFO.STOCK_ID)#)
				<cfif GET_BARCODE_INFO_W_OUT_STOCK.recordcount>
					AND SB.STOCK_ID NOT IN (#valuelist(GET_BARCODE_INFO_W_OUT_STOCK.STOCK_ID)#)
				</cfif>
			ORDER BY
				STOCKS.PRODUCT_NAME, STOCKS.PROPERTY
		</cfquery>
		<!--- <cfset toplam = 0> --->
		<cfset toplam_ytl = 0>
		<cfset toplam_adet = 0>
		<cfset toplam_cesit = 0>
		<cfif get_product_info.recordcount>
			<cfoutput query="get_product_info">
				<cfscript>
                			// indirimler default 0
                    d1 = 0;
                    d2 = 0;
                    d3 = 0;
                    d4 = 0;
                    d5 = 0;
                    d6 = 0;
                    d7 = 0;
                    d8 = 0;
                    d9 = 0;
                    d10= 0;
                    disc_amount = 0;
                </cfscript>
				<cfset attributes.product_id = get_product_info.product_id><!--- indirimler için --->
				<cfset attributes.stock_id = get_product_info.stock_id><!--- indirimler için --->
				<cfset attributes.str_money_currency = get_product_info.money><!--- indirimler için --->

                <cfquery name="GET_SALEABLE_STOCK" datasource="#DSN3#">        
                    SELECT 
                        GSL.SALEABLE_STOCK,
						SB.BARCODE,
						GSL.STOCK_ID,
						STOCKS.PRODUCT_NAME
                    FROM 
                        #dsn2_alias#.GET_STOCK_LAST GSL, 
						STOCKS_BARCODES SB,STOCKS
                    WHERE 
                        STOCKS.STOCK_ID = SB.STOCK_ID AND 
                        GSL.STOCK_ID = SB.STOCK_ID AND 
                        <!--- SB.BARCODE IN (#listqualify(attributes.basket_products,"'")#) AND  --->
                        GSL.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> 
                </cfquery>
				<cfif get_saleable_stock.saleable_stock>
                	<cfset satilabilir_stok = get_saleable_stock.saleable_stock>
				<cfelse>	
                	<cfset satilabilir_stok = 0>
				</cfif>
                <cfif isdefined('attributes.order_id')>
                    <cfquery name="GET_ORDER_ROW_STOCK" datasource="#DSN3#">        
                        SELECT 
                            QUANTITY
                        FROM 
                            ORDER_ROW
                        WHERE 
                            ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND
                            STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
                    </cfquery>
                    			<cfif get_order_row_stock.recordcount and get_order_row_stock.quantity>
                        			<cfset satilabilir_stok = satilabilir_stok + get_order_row_stock.quantity>
                    			</cfif>
				</cfif>
				<!--- ANLAŞMA ŞARTLARI --->
				<cfquery name="GET_CONTRACTS" datasource="#DSN3#" maxrows="1">
					SELECT
						DISCOUNT1,
						DISCOUNT2,
						DISCOUNT3,
						DISCOUNT4,
						DISCOUNT5,
						DISCOUNT_CASH,
						DISCOUNT_CASH_MONEY
					FROM
						CONTRACT_SALES_PROD_DISCOUNT
					WHERE
						PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> 
					<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.price_catid") and len(attributes.price_catid)>
						AND (COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
						OR (COMPANY_ID IS NULL AND C_S_PROD_DISCOUNT_ID IN (SELECT C_S_PROD_DISCOUNT_ID FROM CONTRACT_SALES_PROD_PRICE_LIST CSPPL WHERE CSPPL.C_S_PROD_DISCOUNT_ID = CONTRACT_SALES_PROD_DISCOUNT.C_S_PROD_DISCOUNT_ID AND PRICE_CAT_ID IN (#attributes.price_catid#))) )
					<cfelseif isdefined("attributes.price_catid") and len(attributes.price_catid)>
						AND COMPANY_ID IS NULL AND C_S_PROD_DISCOUNT_ID IN (SELECT C_S_PROD_DISCOUNT_ID FROM CONTRACT_SALES_PROD_PRICE_LIST CSPPL WHERE CSPPL.C_S_PROD_DISCOUNT_ID = CONTRACT_SALES_PROD_DISCOUNT.C_S_PROD_DISCOUNT_ID AND PRICE_CAT_ID IN (#attributes.price_catid#))
					<cfelseif isdefined("attributes.company_id") and len(attributes.company_id)>
						AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
					</cfif>
					<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
						AND (
								START_DATE <= #attributes.search_process_date#
								AND ( FINISH_DATE >= #attributes.search_process_date# OR FINISH_DATE IS NULL )
							)
					<cfelse>
						AND START_DATE <= #now()#
						AND FINISH_DATE >= #now()#
					</cfif>
					ORDER BY
						START_DATE DESC,
						RECORD_DATE DESC
				</cfquery>
				<cfif not get_contracts.recordcount>
					<cfquery name="GET_CONTRACTS" datasource="#DSN3#" maxrows="1">
						SELECT
							DISCOUNT1,
							DISCOUNT2,
							DISCOUNT3,
							DISCOUNT4,
							DISCOUNT5,
							DISCOUNT_CASH,
							DISCOUNT_CASH_MONEY
						FROM
							CONTRACT_SALES_PROD_DISCOUNT
						WHERE
							PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
							COMPANY_ID IS NULL AND
							C_S_PROD_DISCOUNT_ID NOT IN (SELECT C_S_PROD_DISCOUNT_ID FROM CONTRACT_SALES_PROD_PRICE_LIST )  AND
						<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
							(
								START_DATE <= #attributes.search_process_date# AND
								(FINISH_DATE >= #attributes.search_process_date# OR FINISH_DATE IS NULL)			
							)
						<cfelse>
							START_DATE <= #now()# AND
							FINISH_DATE >= #now()#
						</cfif>
						ORDER BY
							START_DATE DESC,
							RECORD_DATE DESC
					</cfquery>
				</cfif>
				<cfscript>// indirimler anlaşma varsa
					if(get_contracts.recordcount)
					{
						if(len(trim(get_contracts.discount1))) d1 = get_contracts.discount1;
						if(len(trim(get_contracts.discount2))) d2 = get_contracts.discount2;
						if(len(trim(get_contracts.discount3))) d3 = get_contracts.discount3;
						if(len(trim(get_contracts.discount4))) d4 = get_contracts.discount4;
						if(len(trim(get_contracts.discount5))) d5 = get_contracts.discount5;
						if(len(get_contracts.discount_cash))
						{
							if( attributes.str_money_currency is get_contracts.discount_cash_money) //urunun para birimi ile retabe para birimi aynı ise tutar aynen alınır yoksa urun para birimine cevirilir
								disc_amount = get_contracts.discount_cash;
							else
								disc_amount = wrk_round( ( (get_contracts.discount_cash * evaluate("attributes.#get_contracts.discount_cash_money#"))/evaluate("attributes.#attributes.str_money_currency#") ),4);
						}
					}
				</cfscript>
				<cfif len(trim(listgetat(session.pda.user_location,2,'-')))><!--- indirimler için --->
					<cfset attributes.branch_id = trim(listgetat(session.pda.user_location,2,'-'))>
				</cfif>
				<cfif IsDefined("attributes.branch_id") and isnumeric(attributes.branch_id) and isdefined('attributes.company_id') and len(attributes.company_id)><!--- // indirimler anlaşmada genel indirimler tanımlı ise --->
					<cfquery name="GET_SALES_GENERAL_DISCOUNTS" datasource="#DSN3#" maxrows="5">
						SELECT
							DISCOUNT
						FROM
							CONTRACT_SALES_GENERAL_DISCOUNT AS CS_GD,
							CONTRACT_SALES_GENERAL_DISCOUNT_BRANCHES CS_GDB
						WHERE
							CS_GD.GENERAL_DISCOUNT_ID = CS_GDB.GENERAL_DISCOUNT_ID
							AND CS_GDB.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
							AND CS_GD.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
						<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
							AND CS_GD.START_DATE <= #attributes.search_process_date#
							AND CS_GD.FINISH_DATE >= #attributes.search_process_date#
						<cfelse>
							AND CS_GD.START_DATE <= #now()#
							AND CS_GD.FINISH_DATE >= #now()#
						</cfif>
						ORDER BY
							CS_GD.GENERAL_DISCOUNT_ID
					</cfquery>
                    			<cfloop query="get_sales_general_discounts">
                        			<cfset 'd#currentrow+5#' = get_sales_general_discounts.discount>
                    			</cfloop>
				</cfif>
				<!--- ANLAŞMA ŞARTLARI --->
				<cfset price_ytl = price * evaluate('attributes.txt_rate2_#money#') / evaluate('attributes.txt_rate1_#money#')>
				
				<!--- ANLAŞMA ŞARTLARI --->
				<cfset indirim_carpan = (100-d1) * (100-d2) * (100-d3) * (100-d4) * (100-d5) * (100-d6) * (100-d7) * (100-d8) * (100-d9) * (100-d10)>
				<cfset price_ytl = wrk_round(price_ytl*indirim_carpan/100000000000000000000,2)>
				<!--- ANLAŞMA ŞARTLARI --->
				
				<!--- <cfset 'price_#attributes.basket_money#' = price_ytl / evaluate('attributes.txt_rate2_#attributes.basket_money#') * evaluate('attributes.txt_rate1_#attributes.basket_money#')> --->

				<cfset sira = listfind(attributes.basket_products_all,barcode)> 
 				<cfset product_amount = 0>
				<cfloop from="1" to="#listlen(attributes.basket_products_all,',')#" index="aa">
					<cfif barcode eq listgetat(attributes.basket_products_all,aa,',')>
						<cfset product_amount = product_amount + listgetat(attributes.basket_products_amount_all,aa)>
					</cfif>	
				</cfloop>
				<cfif sira>
					<script language="javascript">
						eval('document.add_order.amount'+#sira#).style.backgroundColor = "white";
					</script>
					<cfif listgetat(attributes.basket_products_amount_all,sira) gt satilabilir_stok>
						<cfset product_amount = satilabilir_stok>
						<script language="javascript">
							eval('document.add_order.amount'+#sira#).value = '#product_amount#';
							eval('document.add_order.amount'+#sira#).style.backgroundColor = "CCFF33";
						</script>
					<cfelse>
						<script language="javascript">
							eval('document.add_order.amount'+#sira#).style.backgroundColor = "white";
						</script>
					</cfif>
					
					<cfset toplam_ytl = toplam_ytl + (price_ytl * (1+(TAX/100)) * product_amount)>
					<cfset toplam_adet = toplam_adet + product_amount>
					<cfset toplam_cesit = toplam_cesit + 1>
				</cfif>
			</cfoutput>
			<cfset nettotal = tlformat(toplam_ytl,2)>
			<script language="javascript">
				//document.add_order.nettotal_usd.value = '<!--- <cfoutput>#nettotal_usd#</cfoutput> --->';
				document.add_order.nettotal.value = '<cfoutput>#nettotal#</cfoutput>';
				document.add_order.net_adet.value = '<cfoutput>#toplam_adet#</cfoutput>';//ArraySum(ListToArray(attributes.basket_products_amount))
				document.add_order.net_cesit.value = '<cfoutput>#toplam_cesit#</cfoutput>';//listlen(valuelist(GET_BARCODE_INFO.STOCK_ID))
				//fill_basket_fields();
			</script>
		<cfelse>
			<script language="javascript">
			alert('Gönderdiğiniz değerlere ait sistemde kayıt bulunamadı veya stoklarda yok!');
			</script>
		</cfif>
	<cfelse>
		<script language="javascript">
			alert('Gönderdiğiniz değerlere ait hiçbir kayıt bulunamadı.(1)');
		</script>
	</cfif>
</cfif>				
<script language="javascript">
	document.getElementById('problem_barcodes_td').innerHTML = '';
</script>

<cfif listlen(problem_barcodes) or get_barcode_info_w_out_stock.recordcount>
	<script language="javascript">
		var problem_barcodes = '<cfoutput>#problem_barcodes#</cfoutput>';
		goster(problem_barcodes_div);
		document.getElementById('problem_barcodes_td').innerHTML = '<strong>Problem Ürünler</strong><br/><cfloop list="#problem_barcodes#" index="pr_brc_index_2"><cfoutput>#pr_brc_index_2# - ÜRÜN SİSTEMDE KAYITLI DEĞİL<br/></cfoutput></cfloop><cfoutput query="get_barcode_info_w_out_stock"> #barcode# - #product_name#<br/></cfoutput>';				
		<cfloop list="#problem_barcodes#" index="pr_brc_index">
			var sy = <cfoutput>#listfind(attributes.basket_products_all,pr_brc_index)#</cfoutput>;
			alert("sy: " + sy + "attributes.basket_products_all : <cfoutput>#attributes.basket_products_all#  pr_brc_index : #pr_brc_index#</cfoutput>");
			eval('n_my_div' + sy).style.display = 'none';
			document.getElementById('row_kontrol'+sy).value = 0;///alanın silindiğini tutuyoruz. toplam hesaplamada ve kayıt ederken kullanılıyor
		</cfloop>

		<cfloop query="get_barcode_info_w_out_stock">
			<cfloop from="1" to="#listlen(attributes.basket_products_all,',')#" index="i">
				var sy = <cfoutput>#listgetat(attributes.basket_products_all,i,',')#</cfoutput>
				if (sy == <cfoutput>#get_barcode_info_w_out_stock.barcode#</cfoutput>)
				{
					var j = <cfoutput>#i#</cfoutput>
					//var sy = <cfoutput>#listfind(attributes.basket_products_all,get_barcode_info_w_out_stock.barcode)#</cfoutput>
					eval('n_my_div' + j).style.display = 'none';
					document.getElementById('row_kontrol'+j).value = 0;///alanın silindiğini tutuyoruz. toplam hesaplamada ve kayıt ederken kullanılıyor
				}
			</cfloop>
		</cfloop>
	</script>
</cfif>



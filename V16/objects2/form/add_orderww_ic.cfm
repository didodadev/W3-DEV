<cfinclude template="../login/send_login.cfm">
<cfif isdefined('session.ww.userid') or isdefined('session.pp.userid') or isdefined('session.ep.userid')>
	<cfquery name="DEL_COM_ROWS" datasource="#DSN3#">
		DELETE FROM 
			ORDER_PRE_ROWS
		WHERE
			<cfif isdefined("session.pp")>
				RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
			<cfelseif isdefined("session.ww.userid")>
				RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
			<cfelseif isdefined("session.ep")>
				RECORD_EMP =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
			<cfelseif not isdefined("session_base.userid")>
				RECORD_GUEST = 1 AND 
				RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
				COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#"> AND
			</cfif>
			(IS_CARGO = 1 OR IS_DISCOUNT = 1 OR IS_DISCOUNT = 2 OR IS_COMMISSION = 1)
	</cfquery>
	<cfif not isdefined('attributes.is_add_orderww') and isdefined('attributes.is_order_direct_to_use') and attributes.is_order_direct_to_use eq 0>
		<cflocation url="#request.self#?fuseaction=objects2.list_basket" addtoken="no">
	</cfif>
	<cfset session_base.is_order_closed = 0><!--- yeniden sipariş verdigndede ödeme yapılmadı 0 olsunki kaydetsin --->
	<cfif isdefined('attributes.is_order_type_')>
		<cfset x_is_order_type_ = attributes.is_order_type_>
	</cfif>
	<cfinclude template="../query/get_basket_rows.cfm">
    
	<cfif not isdefined("attributes.is_control_zero_stock")>
		<cfset attributes.is_control_zero_stock = 1>
	</cfif>
		<cfscript> 
		//uye kontrolu
		basket_express_cons_list=listsort(listdeleteduplicates(valuelist(get_rows.to_cons)),'numeric','asc');
		basket_express_partner_list=listsort(listdeleteduplicates(valuelist(get_rows.to_par)),'numeric','asc');
		basket_express_comp_list=listsort(listdeleteduplicates(valuelist(get_rows.to_comp)),'numeric','asc');
		attributes.consumer_id='';
		attributes.partner_id='';
		attributes.company_id='';
		hata = '';
		
		if(len(basket_express_cons_list))//session ep deyken her durumda user seçildiği için bu alanlar dolu gelir
		{
			attributes.consumer_id=listfirst(basket_express_cons_list);
			attributes.order_from_basket_express=1;
		}
		else if(len(basket_express_partner_list) and len(basket_express_comp_list))
		{
			attributes.partner_id=listfirst(basket_express_partner_list);
			attributes.company_id=listfirst(basket_express_comp_list);
			attributes.order_from_basket_express=1;
		}
		else if(isdefined("session.pp.userid"))
		{
			attributes.partner_id=session.pp.userid;
			attributes.company_id=session.pp.company_id;
		}
		else if(isdefined("session.ww.userid") )
			attributes.consumer_id=session.ww.userid;
		
		if(attributes.is_control_zero_stock eq 1)
		{
			stock_id_list='';
			stock_amount_list='';
			spect_list = '';
			
			for(brw=1;brw lte get_rows.recordcount;brw=brw+1)
			{
				if(get_rows.is_zero_stock[brw] eq 0)  //0 stok kontrolü
				{
					yer=listfind(stock_id_list,get_rows.stock_id[brw],',');
					if(yer eq 0)
					{
						stock_id_list=listappend(stock_id_list,get_rows.stock_id[brw],',');
						stock_amount_list=listappend(stock_amount_list,get_rows.quantity[brw],',');
						if(len(get_rows.spec_var_id[brw]))
							spect_list = listappend(spect_list,get_rows.spec_var_id[brw],',');
					}
					else
					{
						total_stock_miktar=get_rows.quantity[brw]+listgetat(stock_amount_list,yer,',');
						stock_amount_list=listsetat(stock_amount_list,yer,total_stock_miktar,',');
					}
				}
			}
			
			if(not listlen(stock_id_list,','))
			{
				stock_id_list=0;
				stock_id_count = 0;
			}
			else
				stock_id_count = listlen(stock_id_list,',');
				
			if(not listlen(stock_amount_list,','))
				stock_amount_list=0;
			//stock kontrolleri

			//stock_id_count = listlen(stock_id_list,',');
			if(isDefined('attributes.is_zero_stock_dept') and len(attributes.is_zero_stock_dept))
				get_total_stocks = cfquery(SQLString:"get_stock_last_location_function '#stock_id_list#'",Datasource:dsn2);
			else		
				get_total_stocks = cfquery(SQLString:"get_stock_last_function '#stock_id_list#'",Datasource:dsn2);
			get_product_names = cfquery(SQLString:'SELECT S.STOCK_ID, S.PRODUCT_NAME FROM STOCKS S WHERE S.STOCK_ID IN (#stock_id_list#)',Datasource:dsn3);
			get_stock_names = cfquery(SQLString:'SELECT S.STOCK_ID, S.PRODUCT_NAME, P.IS_ZERO_STOCK, S.IS_PRODUCTION FROM STOCKS S, PRODUCT P WHERE P.PRODUCT_ID = S.PRODUCT_ID AND P.IS_ZERO_STOCK = 0 AND S.STOCK_ID IN (#stock_id_list#)',Datasource:dsn3);
			
			if(stock_id_count gt 0)
			{
				for(jj=1;jj lte stock_id_count;jj=jj+1)
				{
					stock_id=listgetat(stock_id_list,jj,',');
					stock_amount=listgetat(stock_amount_list,jj,',');
					if(isdefined('attributes.is_zero_stock_dept') and len(attributes.is_zero_stock_dept))
					{
                        get_total_stock_ = new Query(sql="SELECT SUM(SALEABLE_STOCK) SALEABLE_STOCK, STOCK_ID FROM GET_TOTAL_STOCKS WHERE STOCK_ID = #stock_id# AND DEPARTMENT_ID = #listgetat(attributes.is_zero_stock_dept,1,'-')# AND LOCATION_ID = #listgetat(attributes.is_zero_stock_dept,2,'-')# GROUP BY STOCK_ID", dbtype="query", GET_TOTAL_STOCKS = GET_TOTAL_STOCKS);
						get_total_stock = get_total_stock_.execute().getResult();  
					}
                    else if(isdefined('session.ww.department_ids') and len(session.ww.department_ids))
                        get_total_stock = cfquery(SQLString:'SELECT SUM(SALEABLE_STOCK) AS SALEABLE_STOCK, S.STOCK_ID, S.PRODUCT_NAME FROM GET_STOCK_LAST_LOCATION GS,#dsn3_alias#.STOCKS S WHERE GS.DEPARTMENT_ID IN (#session.ww.department_ids#) AND S.STOCK_ID = GS.STOCK_ID AND S.STOCK_ID = #stock_id# GROUP BY S.STOCK_ID, S.PRODUCT_NAME',Datasource:dsn2);
                    else if(isdefined('session.pp.department_ids') and len(session.pp.department_ids))
                        get_total_stock = cfquery(SQLString:'SELECT SUM(SALEABLE_STOCK) AS SALEABLE_STOCK, S.STOCK_ID, S.PRODUCT_NAME FROM GET_STOCK_LAST_LOCATION GS,#dsn3_alias#.STOCKS S WHERE GS.DEPARTMENT_ID IN (#session.pp.department_ids#) AND S.STOCK_ID = GS.STOCK_ID AND S.STOCK_ID = #stock_id# GROUP BY S.STOCK_ID, S.PRODUCT_NAME',Datasource:dsn2);
					else
					{
						get_total_stock_ = new Query(sql="SELECT * FROM GET_TOTAL_STOCKS WHERE STOCK_ID = #stock_id#", dbtype="query", GET_TOTAL_STOCKS = GET_TOTAL_STOCKS);
						get_total_stock = get_total_stock_.execute().getResult();  
					}
					//get_total_stock = cfquery(SQLString:'get_stock_last_function "#stock_id#"',Datasource:dsn2);
					if(get_total_stock.recordcount)
					{
						//hiç giriş veya çıkış yoksa o üründe yoksayılır
						get_stock_name_ = new Query(sql="SELECT * FROM GET_STOCK_NAMES WHERE STOCK_ID = #get_total_stock.STOCK_ID#", dbtype="query", GET_STOCK_NAMES = GET_STOCK_NAMES);
						get_stock_name = get_stock_name_.execute().getResult();  							

						if(get_total_stock.SALEABLE_STOCK lt stock_amount and get_stock_name.recordcount)
						{
							get_product_name_ = new Query(sql="SELECT * FROM GET_PRODUCT_NAMES WHERE STOCK_ID = #get_total_stock.STOCK_ID#", dbtype="query", GET_PRODUCT_NAMES = GET_PRODUCT_NAMES);
							get_product_name = get_product_name_.execute().getResult();  
														
							hata = '#hata# Ürün: #get_product_name.PRODUCT_NAME#\n';
						}
					}
					else
					{
						//hiç giriş veya çıkış yoksa o üründe yoksayılır
						get_stock_name_ = new Query(sql="SELECT * FROM GET_STOCK_NAMES WHERE STOCK_ID = #stock_id#", dbtype="query", GET_STOCK_NAMES = GET_STOCK_NAMES);
						get_stock_name = get_stock_name_.execute().getResult();  							
						
						hata = '#hata# Ürün: #get_stock_name.PRODUCT_NAME#\n';
					}
				}
			}
		}	
	</cfscript>
	<cfif len(hata) and attributes.is_control_zero_stock eq 1>
		<script type="text/javascript">
			alert("<cfoutput>#hata#</cfoutput>\n\n <cf_get_lang no ='150.Yukarıdaki ürünlerde satılabilir stok miktarı yeterli değildir Lütfen miktarları kontrol ediniz !'>");		
			window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.list_basket";
		</script>
		<cfabort>
	</cfif>

    <cfif get_ins_products.recordcount>
        <script language="javascript">
            alert('UYARI\n\nSayın Temsilcimiz, 02.01.2014 tarihinde yürürlüğe giren Banka Kartları ve Kredi Kartları Hakkında Yönetmelikte değişiklik yapılmasına ilişkin yönetmelik\'in 1. Maddesi gereğince gıda alımlarında taksit uygulanamamaktadır. Bu nedenle alışverişinize devam edebilmeniz için; gıda ürünlerini sepetinizden çıkartınız veya ödemenizi kredi kartından tek çekim yaptırabilirsiniz.\n\nİlgili Ürünler :\n\n<cfoutput query="get_ins_products">#product_name#\n</cfoutput>');
        </script>
    </cfif>
            
 	<cfif isDefined('session.pp.userid') and isDefined('attributes.is_spect_control') and attributes.is_spect_control eq 1>
        <cfif len(spect_list)>   
            <cfquery name="GET_SPECT_MAIN" datasource="#DSN3#">
                SELECT 
                    SM.SPECT_STATUS,
                    S.SPECT_VAR_ID,
                    SM.IS_LIMITED_STOCK,
                    SM.SPECT_MAIN_ID,
                    SM.SPECT_MAIN_NAME  
                FROM 
                    SPECTS S,
                    SPECT_MAIN SM
                WHERE 
                    S.SPECT_MAIN_ID = SM.SPECT_MAIN_ID AND
                    S.SPECT_VAR_ID IN (#spect_list#)            
            </cfquery>
        <cfelse>
            <cfset get_spect_main.recordcount = 0>
        </cfif> 

		<cfif len(spect_list)>
            <cfquery name="GET_SPECT_MAIN_LIM" dbtype="query">
                SELECT 
                    SPECT_MAIN_ID
                FROM
                    GET_SPECT_MAIN
                WHERE 
                    SPECT_VAR_ID IN (#spect_list#)
            </cfquery>
        <cfelse>
            <cfset get_spect_main_lim.recordcount = 0>
        </cfif>
        
        <cfif listlen(spect_list,',')>
            <cfquery name="GET_SPECTS_STOCKS" datasource="#DSN2#">
                get_stock_last_spect_location_function_with_spect_main_id '#ValueList(get_spect_main_lim.spect_main_id)#'
            </cfquery>
        <cfelse>
            <cfset get_spects_stocks.recordcount = 0>
        </cfif> 

		<cfoutput query="get_rows">
			<cfif ((len(get_rows.spec_var_id) and len(get_rows.spec_var_name)) or (isdefined('row_spect_id#currentrow#') and len(evaluate('row_spect_id#currentrow#')))) and get_spect_main.recordcount>  
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
				<cfif get_spects_stocks.recordcount and len(get_spec_stat.spect_main_id)>                   
                    <cfquery name="GET_SPECTS_STOCK" dbtype="query">
                        SELECT 
                            * 
                        FROM 
                            GET_SPECTS_STOCKS 
                        WHERE 
                            SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_spec_stat.spect_main_id#">
                    </cfquery>
                <cfelse>
                    <cfset get_spects_stock.recordcount = 0>
                </cfif>
                <cfif get_spects_stock.recordcount and get_spec_stat.is_limited_stock eq 1>
                    <cfset spect_saleable = get_spects_stock.saleable_stock - (quantity*prom_stock_amount)>
                    <cfif spect_saleable lte 0>
                        <script language="javascript"> 
                            alert('#product_name# - #get_spec_stat.spect_main_id# - #get_spec_stat.spect_main_name# spect ürününün satılabilir miktarı bulunmamaktadır!');
                        </script>
                    </cfif>
                </cfif>
            </cfif>
        </cfoutput>
    </cfif>
	<!--- //0 stok kontrolü --->
	<cfscript>
		session_basket_kur_ekle(process_type:0);
		if(isDefined("session.ep"))
			int_comp_id = session_base.company_id;
		else
			int_comp_id = session_base.our_company_id;
		int_period_id = session_base.period_id;
		int_money = session_base.money;
		int_money2 = session_base.other_money;
		if (listfindnocase(partner_url,'#cgi.http_host#',';') and not (isDefined("attributes.company_id") and len(attributes.company_id)))
			attributes.company_id = session.pp.company_id;
		else if (listfindnocase(server_url,'#cgi.http_host#',';') and not (isDefined("attributes.consumer_id") and len(attributes.consumer_id)) and isdefined('session.ww.userid'))
			attributes.consumer_id = session.ww.userid;
	</cfscript>
	<cfinclude template="../query/get_order_detail_money.cfm">
	<cfinclude template="../query/get_order_detail_account.cfm">
	<cfinclude template="../query/get_order_detail.cfm">
	<cfset claim_info = 0>
	<cfif isdefined("attributes.is_change_revenue") and attributes.is_change_revenue eq 1>
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			<cfquery name="GET_CLAIM_INFO" datasource="#DSN2#">
				SELECT BAKIYE FROM COMPANY_REMAINDER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			</cfquery>
		<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			<cfquery name="GET_CLAIM_INFO" datasource="#DSN2#">
				SELECT BAKIYE FROM CONSUMER_REMAINDER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			</cfquery>
		</cfif>
		<cfif isDefined("get_claim_info") and get_claim_info.recordcount and get_claim_info.bakiye lt 0>
			<cfset claim_info = abs(get_claim_info.bakiye)>
		</cfif>
	</cfif>
	<cfif use_https>
		<cfset url_link = https_domain>
	<cfelse>
		<cfset url_link = "">
	</cfif>
	<cfset url_link_last = "objects2.add_orderww">

	<cfform name="list_basketww" action="#url_link##request.self#?fuseaction=#url_link_last#" method="post" onsubmit="return (unformat_fields());">
		<input type="hidden" name="required_prom_id_list" id="required_prom_id_list" value="<cfif isDefined('required_prom_id_list') and len(required_prom_id_list)><cfoutput>#required_prom_id_list#</cfoutput></cfif>">
		<cfif isdefined("attributes.is_order_last_editable") and attributes.is_order_last_editable eq 2>
			<cfset is_editable = 2>
		<cfelseif isdefined("attributes.is_order_last_editable") and attributes.is_order_last_editable eq 1>
			<cfset is_editable = 1>
		<cfelse>
			<cfset is_editable = 0>
		</cfif>
		<div id="sale_basket_rows_list" style="position:relative;"></div>
        <input type="hidden" name="is_cargo_city" id="is_cargo_city" value="<cfif isdefined("attributes.is_cargo_city") and len(attributes.is_cargo_city)><cfoutput>#attributes.is_cargo_city#</cfoutput></cfif>">
		<input type="hidden" name="sale_department_id" id="sale_department_id" value="<cfif isdefined("attributes.sale_department_id")><cfoutput>#attributes.sale_department_id#</cfoutput></cfif>">
		<input type="hidden" name="sale_location_id" id="sale_location_id" value="<cfif isdefined("attributes.sale_location_id")><cfoutput>#attributes.sale_location_id#</cfoutput></cfif>">
		<input type="hidden" name="first_time" id="first_time" value="1">
		<input type="hidden" name="kredi_karti_indirim_orani" id="kredi_karti_indirim_orani" value="0">
		<input type="hidden" name="project_str" id="project_str" value="">
		<input type="hidden" name="project_id_new_" id="project_id_new_" value="">
		<input type="hidden" name="sepet_adres" id="sepet_adres" value="<cfoutput>#request.self#?fuseaction=objects2.emptypopup_sale_basket_rows&is_editable=#is_editable#<cfif isdefined("attributes.company_id") and isNumeric('attributes.company_id')>&company_id=#attributes.company_id#</cfif><cfif isdefined("attributes.consumer_id") and isNumeric('attributes.consumer_id')>&consumer_id=#attributes.consumer_id#</cfif><cfif isdefined('attributes.is_special_code') and attributes.is_special_code eq 1>&is_special_code=#attributes.is_special_code#</cfif><cfif isdefined('attributes.is_prod_special_code') and attributes.is_prod_special_code eq 1>&is_prod_special_code=#attributes.is_prod_special_code#</cfif><cfif isdefined('attributes.is_manufact_code') and attributes.is_manufact_code eq 1>&is_manufact_code=#attributes.is_manufact_code#</cfif><cfif isdefined('attributes.is_stock_barcode') and attributes.is_stock_barcode eq 1>&is_stock_barcode=#attributes.is_stock_barcode#</cfif><cfif isdefined("attributes.is_product_assort") and attributes.is_product_assort eq 1>&is_product_assort=1<cfelse>&is_product_assort=0</cfif><cfif isdefined("attributes.is_vat_column") and attributes.is_vat_column eq 1>&is_vat_column=1<cfelse>&is_vat_column=0</cfif><cfif isdefined("attributes.is_prices_kdvli") and attributes.is_prices_kdvli eq 1>&is_prices_kdvli=#attributes.is_prices_kdvli#</cfif><cfif isdefined("attributes.is_prices_kdvsiz") and attributes.is_prices_kdvsiz eq 1>&is_prices_kdvsiz=#attributes.is_prices_kdvsiz#</cfif><cfif isdefined("attributes.price_cat_id") and len(attributes.price_cat_id)>&price_cat_id=#attributes.price_cat_id#</cfif><cfif isdefined("attributes.is_order_row_info_type")>&is_order_row_info_type=#attributes.is_order_row_info_type#</cfif><cfif isdefined("attributes.is_last_price") and attributes.is_last_price eq 1>&is_last_price=#attributes.is_last_price#</cfif><cfif isdefined('attributes.is_risc_currency') and len(attributes.is_risc_currency)>&is_risc_currency=#attributes.is_risc_currency#</cfif><cfif isdefined("attributes.is_basket_prices_session_money") and len(attributes.is_basket_prices_session_money)>&is_basket_prices_session_money=#attributes.is_basket_prices_session_money#</cfif><cfif isdefined("attributes.is_view_kur") and len(attributes.is_view_kur)>&is_view_kur=#attributes.is_view_kur#</cfif><cfif isdefined("attributes.is_view_basket_other") and len(attributes.is_view_basket_other)>&is_view_basket_other=#attributes.is_view_basket_other#</cfif><cfif isdefined("attributes.is_order_checked") and len(attributes.is_order_checked)>&is_order_checked=#attributes.is_order_checked#</cfif><cfif isdefined('attributes.is_attachment') and attributes.is_attachment eq 1>&is_attachment=1</cfif><cfif isdefined("attributes.default_ship_method_id")>&default_ship_method_id=#attributes.default_ship_method_id#</cfif><cfif isdefined('attributes.is_order_row_detail') and attributes.is_order_row_detail eq 1>&is_order_row_detail=1</cfif><cfif isdefined("attributes.is_view_basket_total")>&is_view_basket_total=#attributes.is_view_basket_total#</cfif><cfif isdefined('attributes.is_order_type_')>&x_is_order_type_=#x_is_order_type_#</cfif></cfoutput>">
		<input type="hidden" name="cargo_kontrol" id="cargo_kontrol" value="1">
		<input type="hidden" name="invoice_kontrol" id="invoice_kontrol" value="<cfif isdefined("attributes.is_invoice") and attributes.is_invoice eq 1>1<cfelse>0</cfif>">
		<input type="hidden" name="invoice_process_cat" id="invoice_process_cat" value="<cfif isdefined("attributes.invoice_process_cat")><cfoutput>#attributes.invoice_process_cat#</cfoutput></cfif>">
		<input type="hidden" name="invoice_department_id" id="invoice_department_id" value="<cfif isdefined("attributes.invoice_department_id")><cfoutput>#attributes.invoice_department_id#</cfoutput></cfif>">
		<input type="hidden" name="invoice_location_id" id="invoice_location_id" value="<cfif isdefined("attributes.invoice_location_id")><cfoutput>#attributes.invoice_location_id#</cfoutput></cfif>">        
        <input type="hidden" name="cargo_toplam_kdvli" id="cargo_toplam_kdvli" value="">        
		<input type="hidden" name="tum_toplam_kdvli" id="tum_toplam_kdvli" value="">
		<input type="hidden" name="tum_toplam_kdvli_risk" id="tum_toplam_kdvli_risk" value="">
		<input type="hidden" name="tum_toplam_komisyonsuz" id="tum_toplam_komisyonsuz" value="">
		<input type="hidden" name="my_temp_tutar"  id="my_temp_tutar" value="">
		<input type="hidden" name="order_payment_value"  id="order_payment_value" value=""><!--- alacagima istinaden kullanılmis ise siparise ödeme tutarı yazilir FA --->
		<input type="hidden" name="my_temp_tutar_price_standart" id="my_temp_tutar_price_standart" value="">
		<input type="hidden" name="toplam_desi" id="toplam_desi" value="">
		<input type="hidden" name="joker_vada_control" id="joker_vada_control" value="0"><!--- Bu değişken joker vada sayfasının açıldığının kontrolünü yapmak için eklendi,silmeyiniz! --->
		<cfif not isdefined('attributes.is_add_bank_order')>
			<input type="hidden" name="is_add_bank_order" id="is_add_bank_order" value="0" />
		<cfelseif isdefined('attributes.is_add_bank_order') and attributes.is_add_bank_order eq 1>
			<input type="hidden" name="is_add_bank_order" id="is_add_bank_order" value="1" />
		</cfif>
		<input type="hidden" name="is_order_type_form" id="is_order_type_form" value="<cfif isdefined('attributes.is_order_type_')><cfoutput>#attributes.is_order_type_#</cfoutput></cfif>">
		<cfif isdefined("cargo_product_id") and len(cargo_product_id)>
			<input type="hidden" name="cargo_product_id" id="cargo_product_id" value="<cfoutput>#cargo_product_id#</cfoutput>">
			<input type="hidden" name="cargo_product_price" id="cargo_product_price" value="<cfoutput>#cargo_product_price#</cfoutput>">
			<input type="hidden" name="cargo_product_tax" id="cargo_product_tax" value="<cfoutput>#cargo_product_tax#</cfoutput>">
		</cfif>
		<cfif isdefined("attributes.order_money_credit_count") and attributes.order_money_credit_count gt 0>
			<input type="hidden" name="order_money_credit_count" id="order_money_credit_count" value="<cfoutput>#attributes.order_money_credit_count#</cfoutput>">
			<cfloop from="1" to="#attributes.order_money_credit_count#" index="crdt_indx">
				<cfoutput>
					<input type="hidden" name="credit_rate_#crdt_indx#" id="credit_rate_#crdt_indx#" value="#evaluate("attributes.credit_rate_#crdt_indx#")#">
					<input type="hidden" name="order_total_money_credit_#crdt_indx#" id="order_total_money_credit_#crdt_indx#" value="#evaluate("attributes.order_total_money_credit_#crdt_indx#")#">
					<input type="hidden" name="credit_valid_date_#crdt_indx#" id="credit_valid_date_#crdt_indx#" value="#evaluate("attributes.credit_valid_date_#crdt_indx#")#">
				</cfoutput>
			</cfloop>
		</cfif>
		<script src="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_add_orderww_js"></script>
		<cfinclude template="address_payment_info.cfm">
	</cfform>
	
	<!--- 3d icin gerekli silmeyin fatih --->
	<div id="ajax_form_3d" style="display:none;"></div>
    
	<script type="text/javascript">
		var sepet_adres_ = document.getElementById('sepet_adres').value;
		if(document.getElementById('first_time').value == '1')
		{  
			<cfif isdefined('attributes.is_invoice_address') and attributes.is_invoice_address eq 1>
				if(document.getElementById('tax_address_country0') != undefined)
				{
					var country_id_ = document.getElementById('tax_address_country0').value;
					if(country_id_.length)
						LoadCity(country_id_,'tax_address_city0','tax_address_county0',0);
				}
			</cfif> 					
			if(document.getElementById('ship_address_country0') != undefined)
			{
				var country_id2_ = document.getElementById('ship_address_country0').value;
				if(country_id2_.length)
				{
					LoadCity(country_id2_,'ship_address_city0','ship_address_county0',0);
				}
			}

			AjaxPageLoad(sepet_adres_,'sale_basket_rows_list','1',"Ürünler Listeleniyor!");
			document.getElementById('first_time').value = '0';
		}

		function risk_hesapla()
		{
			tum_toplam_kdvli = parseFloat(document.getElementById('tum_toplam_kdvli').value-document.getElementById('tum_toplam_kdvli_risk').value);
			<cfif ((get_company_risk.recordcount and get_company_risk.bakiye lte 0) or (get_credit.recordcount and get_credit.open_account_risk_limit gt 0))>
				// Limit kullanimi icin kontrol eklendi. BK 20140721
				<cfoutput>
					tot_bak = #get_credit.open_account_risk_limit-get_company_risk.bakiye#;
				</cfoutput>
				if(tum_toplam_kdvli > tot_bak)
				{
					risk_table.style.display = 'none'; 
					risk_tutar_ = <cfoutput>(#get_company_risk.total_risk_limit# - #get_company_risk.bakiye# - (#get_company_risk.cek_odenmedi# + #get_company_risk.senet_odenmedi# + #get_company_risk.cek_karsiliksiz# + #get_company_risk.senet_karsiliksiz#))</cfoutput>;
					kalan_risk_ = parseFloat(risk_tutar_ - tum_toplam_kdvli);
				}
				else
					kalan_risk_ = -1;
			<cfelse>
				kalan_risk_ = -1;
			</cfif>
			
			if(document.getElementById('risk_credit_table') != undefined)
				document.getElementById('risk_credit_table').style.display = 'none';
				
			if(kalan_risk_ >= 0)
			{
				<cfif get_order_bakiye.recordcount and len(get_order_bakiye.nettotal)>
					kalan_risk_ = parseFloat(kalan_risk_ - <cfoutput>#get_order_bakiye.nettotal#</cfoutput>);
				</cfif>
				if(kalan_risk_ >= 0)
				{
					<cfif ((get_company_risk.recordcount and get_company_risk.bakiye lt 0) or (get_credit.recordcount and get_credit.open_account_risk_limit gt 0)) and get_company_bakiye.total_bakiye lt 0>
						risk_table.style.display = '';
						document.getElementById('kalan_risk_info').value = kalan_risk_;
						goster(risk_table);
					<cfelse>
						document.getElementById('kalan_risk_info').value = 0;
					</cfif>
				}
				<cfif isdefined("attributes.is_dsp_risk_info") and attributes.is_dsp_risk_info eq 1>
					else if(risk_credit_table != undefined)
					{
						goster(risk_credit_table);
						find_risk();
					}
				</cfif>
			}			                
			<cfif isdefined("attributes.is_dsp_risk_info") and attributes.is_dsp_risk_info eq 1>
				else if(risk_credit_table != undefined)
				{
					<cfif get_company_risk.recordcount and get_company_risk.bakiye eq 0 and get_credit.recordcount and get_credit.open_account_risk_limit eq 0>
						gizle(risk_credit_table);
					<cfelse>					
						goster(risk_credit_table);
					</cfif>
					find_risk();
					/*goster(risk_credit_table);
					find_risk();*/
				}
			</cfif>
		}
		<cfif get_havale.recordcount>
			function havale_hesapla()
			{
				tum_toplam_kdvli = document.getElementById('tum_toplam_kdvli').value;
				cargo_toplam_kdvli = document.getElementById('cargo_toplam_kdvli').value;
				havale_temp_tutar = parseFloat(tum_toplam_kdvli-cargo_toplam_kdvli);

				<cfif len(get_havale.first_interest_rate)>
					havale_tutar_ = havale_temp_tutar * (1 - <cfoutput>#get_havale.first_interest_rate#</cfoutput> / 100);
					havale_tutar_ = havale_tutar_ + parseFloat(document.getElementById('cargo_toplam_kdvli').value);
				<cfelse>
					havale_tutar_ = tum_toplam_kdvli;
				</cfif>
				
				document.getElementById('order_amount').value = wrk_round(havale_tutar_,2);
				document.getElementById('order_amount_dsp').value = commaSplit(wrk_round(havale_tutar_,2));

				<cfif isdefined('attributes.is_basis_of_receiving') and attributes.is_basis_of_receiving eq 1>
					var memberBakiye_ = <cfoutput>#get_company_risk.bakiye#</cfoutput>;
					var xx = memberBakiye_ <cfif len(get_order_bakiye.nettotal)>+ <cfoutput>#get_order_bakiye.nettotal#</cfoutput></cfif>;
					if(xx < 0)
					{
						var amount_paid_ = parseFloat(havale_tutar_ -  Math.abs(xx));
						if(amount_paid_ > 0)
						{
							document.getElementById('order_amount_dsp').value = commaSplit(wrk_round(amount_paid_,2));
							document.getElementById('order_payment_value').value = wrk_round(amount_paid_,2);
						}
						else
						{
							document.getElementById('order_amount_dsp').value = 0;
							document.getElementById('order_payment_value').value = 0;
						}
					} 
					else
						document.getElementById('order_payment_value').value = wrk_round(havale_tutar_);
				</cfif>
			}
		</cfif>
		<cfif get_door_paymethod.recordcount>
			function door_paymethod_hesapla()
			{
				tum_toplam_kdvli = document.getElementById('tum_toplam_kdvli').value;
				<cfif len(get_door_paymethod.first_interest_rate)>
					door_pay_tutar_ = tum_toplam_kdvli * (1 - <cfoutput>#get_door_paymethod.first_interest_rate#</cfoutput> / 100);
				<cfelse>
					door_pay_tutar_ = tum_toplam_kdvli;
				</cfif>
				document.list_basketww.door_pay_amount.value = commaSplit(wrk_round(door_pay_tutar_,2));
					
				<cfif isdefined('attributes.is_basis_of_receiving') and attributes.is_basis_of_receiving eq 1>
					<cfif get_company_risk.recordcount>
						var memberBakiye_ = <cfoutput>#get_company_risk.bakiye#</cfoutput>;
					<cfelse>
						var memberBakiye_ = 0;
					</cfif>
					var xx = memberBakiye_ <cfif len(get_order_bakiye.nettotal)>+ <cfoutput>#get_order_bakiye.nettotal#</cfoutput></cfif>;
					if(xx < 0)
					{
						var amount_paid_ = parseFloat(door_pay_tutar_ -  Math.abs(xx));
						if(amount_paid_ > 0)
						{
							document.getElementById('door_pay_amount').value = commaSplit(wrk_round(amount_paid_,2));
							document.getElementById('order_payment_value').value = wrk_round(amount_paid_,2);
						}
						else
						{
							document.getElementById('door_pay_amount').value = 0;
							document.getElementById('order_payment_value').value = 0;
						}
					}
					else
						document.getElementById('order_payment_value').value = wrk_round(door_pay_tutar_);
				</cfif>
			}
		</cfif>
		function unformat_fields()
		{   
			<cfif get_accounts.recordcount>
				<cfif isDefined("session.pp")>
					<cfif isdefined("attributes.is_view_last_user_price") and attributes.is_view_last_user_price eq 1>
						document.getElementById('price_standart_last').value = filterNum(document.getElementById('price_standart_dsp').value);
					</cfif>
				</cfif>
			</cfif>
		}
		function yeni_adres(nesne)
		{
			
			if(document.getElementById('ship_method_id').disabled == false)
				document.getElementById('ship_method_id').value = '';
			kargo_info_td.innerHTML = '';
			kargo_info_tr.style.display = 'none';
			//clear_cargo_row();
			document.getElementById('cargo_kontrol').value = '1';
			if(nesne.checked==true && nesne.value==0)
			{
				shipaddress0.style.display='';
			}
			else
			{
				shipaddress0.style.display='none';
			}
		}
		
		function yeni_fatura_adres(nesne)
		{
			if(document.getElementById('ship_method_id').disabled == false)
				document.getElementById('ship_method_id').value = '';
			kargo_info_td.innerHTML = '';
			kargo_info_tr.style.display = 'none';
			//clear_cargo_row();
			document.getElementById('cargo_kontrol').value = '1';
			if(nesne.checked==true && nesne.value==0)
			{
				taxaddress0.style.display='';
			}
			else
			{
				taxaddress0.style.display='none';
			}
		}
		
		function add_consumer(add_consumer_param)
		{
			if(add_consumer_param.checked == true)
				add_consumer_table.style.display='';
			else
				add_consumer_table.style.display='none';
		}
		
		function pencere_ac2(no)
		
		{
			if (document.list_basketww.city[document.list_basketww.city.selectedIndex].value == "")
				alert("<cf_get_lang no ='32.İl Seçiniz'>!");
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=list_basketww.county_id&field_name=list_basketww.county&city_id=' + document.list_basketww.city.value,'small');
		}
		function odemeyontemi(type)
		{	
			if(document.getElementById('ship_method_id').value == '')
			{
				alert("<cf_get_lang no ='4.Önce Sevkiyat Şekli Seçmelisiniz'>");
				if(document.getElementById('paymethod_type')[0]) document.getElementById('paymethod_type')[0].checked = false;
				if(document.getElementById('paymethod_type')[1]) document.getElementById('paymethod_type')[1].checked = false;
				if(document.getElementById('paymethod_type')[2]) document.getElementById('paymethod_type')[2].checked = false;
				if(document.getElementById('paymethod_type')[3]) document.getElementById('paymethod_type')[3].checked = false;
				if(document.getElementById('paymethod_type')[7]) document.getElementById('paymethod_type')[7].checked = false;
				return false;
			}

			if(type==1)
			{	
				pay_type_1.style.display='';
				if(document.getElementById('pay_type_2'))
					pay_type_2.style.display='none';
				if(document.getElementById('pay_type_4'))
					pay_type_4.style.display='none';
				if(document.getElementById('risk_info'))	
					risk_info.style.display='none';
				if(document.getElementById('pay_type_door'))	
					pay_type_door.style.display='none';
		
				clear_pos_row();
				
				<!--- <cfif isdefined('attributes.is_money_credit_use') and attributes.is_money_credit_use eq 1>	
					if(document.getElementById('money_credit_id').checked)
						comp_money_cred(); // para puan kullanılsın demişse
				</cfif> --->
			}
			else if(type==2)
			{	 
				pay_type_2.style.display='';
				if(document.getElementById('pay_type_1'))
					pay_type_1.style.display='none';
				if(document.getElementById('pay_type_4'))
					pay_type_4.style.display='none';
				if(document.getElementById('risk_info'))	
					risk_info.style.display='none';
				if(document.getElementById('pay_type_door'))	
					pay_type_door.style.display='none';
					
				<cfif isdefined("attributes.is_credit_card_select") and attributes.is_credit_card_select eq 1>
					<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_dsp_credit_card</cfoutput>&consumer_cc_id='+document.getElementById('member_credit_card').value,'SHOW_MEMBER_CARD');
					<cfelse>
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_dsp_credit_card</cfoutput>&company_cc_id='+document.getElementById('member_credit_card').value,'SHOW_MEMBER_CARD');
					</cfif>
				</cfif>
				
				<!--- <cfif isdefined('attributes.is_money_credit_use') and attributes.is_money_credit_use eq 1>	
					if(document.getElementById('money_credit_id').checked)
					{
						comp_money_cred(); // para puan kullanılsın demişse
						if(document.getElementById('pos_type_id').value != '')listAccounts();
					}
				</cfif> --->
			}
			else if(type==3)
			{  
				if(document.getElementById('pay_type_1'))
					pay_type_1.style.display='none';
				if(document.getElementById('pay_type_2'))	
					pay_type_2.style.display='none';
				if(document.getElementById('pay_type_4'))	
					pay_type_4.style.display='none';
				if(document.getElementById('risk_info'))	
					risk_info.style.display='';
				<cfif isdefined("attributes.is_dsp_risk_info") and attributes.is_dsp_risk_info eq 1>
					find_risk();
				</cfif>
				if(document.getElementById('pay_type_door'))	
					pay_type_door.style.display='none';
					
				clear_pos_row();
			}
			else if(type==4)
			{
				pay_type_4.style.display='';
				if(document.getElementById('risk_info'))
					risk_info.style.display='';
				if(document.getElementById('pay_type_1'))
					pay_type_1.style.display='none';
				if(document.getElementById('pay_type_2'))	
					pay_type_2.style.display='none';
				if(document.getElementById('pay_type_door'))	
					pay_type_door.style.display='none';
				
				<cfif isdefined("attributes.is_credit_card_select") and attributes.is_credit_card_select eq 1>
					<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_dsp_credit_card</cfoutput>&limit_info=1&consumer_cc_id='+document.getElementById('lim_member_credit_card').value,'SHOW_MEMBER_CARD');
					<cfelse>
						AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_dsp_credit_card</cfoutput>&limit_info=1&company_cc_id='+document.getElementById('lim_member_credit_card').value,'SHOW_MEMBER_CARD');
					</cfif>
				</cfif>
				<cfif isdefined("attributes.is_credit_card_select") and attributes.is_credit_card_select eq 1>
					document.getElementById('lim_member_credit_card').value = filterNum(document.getElementById('limit_diff_value').value);
				</cfif>
					document.getElementById('lim_sales_credit_dsp').value = document.getElementById('limit_diff_value').value;
				clear_pos_row();
			}
			else if(type==7)
			{
				pay_type_door.style.display='';
				if(document.getElementById('pay_type_1'))
					pay_type_1.style.display='none';
				if(document.getElementById('pay_type_2'))
					pay_type_2.style.display='none';
				if(document.getElementById('pay_type_4'))
					pay_type_4.style.display='none';
				if(document.getElementById('risk_info'))	
					risk_info.style.display='none';
		
				clear_pos_row();
			}
		}
		
		function check_member_project_risk_limit(project_id_)
		{  
			if(project_id_!=undefined && project_id_ !='')
			{
				var check_prj_disc =wrk_safe_query("obj2_check_prj_disc",'dsn3',0,project_id_);
				if(check_prj_disc.IS_CHECK_PRJ_LIMIT == 1)
				{
					var prj_total_risk_=0;
					<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
						var listParam = "<cfoutput>#attributes.company_id#</cfoutput>" + "*" + project_id_;
						var str_member_prj_risk_ = 'obj2_get_member_prj_risk';
						
						var listParam2 = project_id_ + "*" + "<cfoutput>#attributes.company_id#</cfoutput>" + "*" + "<cfoutput>#dsn3_alias#</cfoutput>";
						var str_prj_order_risk_='obj2_get_prj_order_risk';
				
						var listParam3 = "<cfoutput>#attributes.company_id#</cfoutput>" + "*" + project_id_ + "*" + "<cfoutput>#dsn2_alias#</cfoutput>";
						var str_prj_ship_total_ = 'obj2_get_prj_ship_total';
						
					<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
					
						var listParam = "<cfoutput>#attributes.consumer_id#</cfoutput>" + "*" + project_id_;
						var str_member_prj_risk_ = 'obj2_get_member_prj_risk_2';
						
						var listParam2 = project_id_ + "*" + "<cfoutput>#attributes.consumer_id#</cfoutput>" + "*" + "<cfoutput>#dsn3_alias#</cfoutput>";
						var str_prj_order_risk_='obj2_get_prj_order_risk_2';
						
						var listParam3 = "<cfoutput>#attributes.consumer_id#</cfoutput>" + "*" + project_id_ + "*" + "<cfoutput>#dsn2_alias#</cfoutput>";
						var str_prj_ship_total_ = 'obj2_get_prj_ship_total_2';
					</cfif>
					if(str_member_prj_risk_!=undefined)
					{
						var get_member_prj_risk = wrk_safe_query(str_member_prj_risk_,'dsn2',0,listParam);
						if(get_member_prj_risk.recordcount!= 0 && get_member_prj_risk.BAKIYE!='')
							prj_total_risk_=(-1)*wrk_round(get_member_prj_risk.BAKIYE);
					}
					if(str_prj_order_risk_!=undefined)
					{
						var get_prj_order_risk_=wrk_safe_query(str_prj_order_risk_,'dsn2',0,listParam2);
						if(get_prj_order_risk_.recordcount!= 0 && get_prj_order_risk_.NETTOTAL!='')
							prj_total_risk_=parseFloat(prj_total_risk_)-parseFloat(get_prj_order_risk_.NETTOTAL);
					}
					if(str_prj_ship_total_!=undefined)
					{
						var get_prj_ship_total_=wrk_safe_query(str_prj_ship_total_,'dsn2',0,listParam3);
						if(get_prj_ship_total_.recordcount!= 0 && get_prj_ship_total_.NETTOTAL!='' )
							prj_total_risk_=parseFloat(prj_total_risk_)-parseFloat(get_prj_ship_total_.NETTOTAL);
					}
					if(prj_total_risk_<=0 || ( prj_total_risk_ < parseFloat(document.getElementById('nettotal').value)) )
					{
						alert("<cf_get_lang no='49.Cari Alacak Bakiyesi Siparişi Kaydetmek İçin Yeterli Değil'> \n <cf_get_lang no='50.Siparişi Kaydedemezsiniz'>"+"\n <cf_get_lang no='52.Proje Bakiyesi'>:"+commaSplit(prj_total_risk_));
						return false;
					}
				}
			}
			return true;
		}
		
		if(list_basketww.joker_vada != undefined)
			document.getElementById('joker_vada').checked = false;
		if(list_basketww.lim_joker_vada != undefined)
			document.getElementById('lim_joker_vada').checked = false;
		
		function clear_cargo_row()
		{
			<cfif isdefined("attributes.xml_reload") and attributes.xml_reload eq 1>
				adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_del_basketww&is_delete_cargo=1';
				AjaxPageLoad(adres_,'sale_basket_rows_list','1','Hesaplanıyor!');
			</cfif>
			clear_paymethod();
		}
		
		function isDefined(variable)
		{
			//return (!(!(eval("document.all."+variable))));
			return (!(!(eval("document.getElementById('"+variable+"')"))));
		}

		function clear_paymethod()
		{
			if(document.list_basketww.paymethod_type != undefined)
			{
				if(document.list_basketww.paymethod_type[0]) document.list_basketww.paymethod_type[0].checked = false;
				if(document.list_basketww.paymethod_type[1]) document.list_basketww.paymethod_type[1].checked = false;
				if(document.list_basketww.paymethod_type[2]) document.list_basketww.paymethod_type[2].checked = false;
				if(document.list_basketww.paymethod_type[3]) document.list_basketww.paymethod_type[3].checked = false;
			}
			<cfif get_accounts.recordcount>
				pay_type_2.style.display='none';
				pay_type_4.style.display='none';
			</cfif>

			if(document.getElementById('pay_type_door') != undefined) pay_type_door.style.display='none';
			if(document.getElementById('risk_info'))
			{
				document.getElementById('paymethod_type').checked = false;
				risk_info.style.display='none';
			}
			clear_pos_row();
		}
		
		function clear_pos_row(pay_info)
		{
			<cfif get_accounts.recordcount>
				joker_info.style.display='none';
				document.getElementById('joker_vada').checked = false;
			</cfif>
			if(document.getElementById('lim_joker_vada'))
			{
				lim_joker_info.style.display='none';
				document.getElementById('lim_joker_vada').checked = false;
			}
			<cfif isdefined("attributes.xml_reload") and attributes.xml_reload eq 1>
				adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_del_basketww&is_delete_info2=1';
				AjaxPageLoad(adres_,'sale_basket_rows_list','1','Hesaplanıyor!');
			</cfif>
		}
		
		<cfif isDefined("session.pp")>
			function use_price_standart()
			{
				if(document.getElementById('is_price_standart').checked)
				{
					document.getElementById('price_standart_old').value = document.getElementById('price_standart_dsp').value;
					price_standart_info.style.display='';
					<cfif is_order_to_directcustomer eq 1>price_standart_info2.style.display='';</cfif>
				}
				else{
					price_standart_info.style.display='none';
					<cfif is_order_to_directcustomer eq 1>price_standart_info2.style.display='none';</cfif>
				}
			}
		</cfif>
		//pay_type_general();
		<cfif use_https>
			window.defaultStatus="<cf_get_lang no='1054.Bu sayfada SSL Kullanılmaktadır'>."
		</cfif>
		function show_cvv_info()
		{
			gizle_goster(show_message_cvv);
			if(document.getElementById('show_message_cvv').innerHTML =="")
				document.getElementById('show_message_cvv').innerHTML ="<cf_get_lang no ='1108.Güvenlik Kodu(CVV), Tüm Kredi Kartlarının Arka Yüzünde Bulunan 3 Haneli Numaradır Kredi Kartı İşlemlerinizde Güvenliğinizi Arttırmak İçin Bu Numarayı Girmek Zorundasınız'>.";
			else
				document.getElementById('show_message_cvv').innerHTML ="";	
		}
		function open_joker_vada()
		{
			goster(joker_info);
			goster(_show_joker_vada_);
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_show_joker_vada&card_no='+document.getElementById('card_no').value+'','_show_joker_vada_');
		}
	</script>
	<form action="" method="post" name="satir_gonder">
		<input type="hidden" name="price_catid_2" id="price_catid_2" value="">
		<input type="hidden" name="istenen_miktar" id="istenen_miktar" value="">
		<input type="hidden" name="sid" id="sid" value="">
		<input type="hidden" name="price" id="price" value="">
		<input type="hidden" name="price_old" id="price_old" value="">
		<input type="hidden" name="price_kdv" id="price_kdv" value="">
		<input type="hidden" name="price_money" id="price_money" value="">
		<input type="hidden" name="prom_id" id="prom_id" value="">
		<input type="hidden" name="prom_discount" id="prom_discount" value="">
		<input type="hidden" name="prom_amount_discount" id="prom_amount_discount" value="">
		<input type="hidden" name="prom_cost" id="prom_cost" value="">
		<input type="hidden" name="prom_free_stock_id" id="prom_free_stock_id" value="">
		<input type="hidden" name="prom_stock_amount" id="prom_stock_amount" value="1">
		<input type="hidden" name="prom_free_stock_amount" id="prom_free_stock_amount" value="1">
		<input type="hidden" name="prom_free_stock_price" id="prom_free_stock_price" value="0">
		<input type="hidden" name="prom_free_stock_money" id="prom_free_stock_money" value="">
		<input type="hidden" name="is_cargo" id="is_cargo" value="0">
		<input type="hidden" name="is_discount" id="is_discount" value="0">
		<input type="hidden" name="is_commission" id="is_commission" value="0">
		<input type="hidden" name="paymethod_id_com" id="paymethod_id_com" value="0">
		<input type="hidden" name="price_standard" id="price_standard" value="">
		<input type="hidden" name="price_standard_kdv" id="price_standard_kdv" value="">
		<input type="hidden" name="price_standard_money" id="price_standard_money" value="">
		<cfif isdefined('attributes.order_from_basket_express') and attributes.order_from_basket_express eq 1>
			<input type="hidden" name="consumer_id" id="consumer_id" value="">
			<input type="hidden" name="company_id" id="company_id" value="">
			<input type="hidden" name="partner_id" id="partner_id" value="">
			<input type="hidden" name="order_from_basket_express" id="order_from_basket_express" value="1">
		</cfif>
	</form>
</cfif>


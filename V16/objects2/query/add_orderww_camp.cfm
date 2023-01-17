<!--- form elemanları kontrolleri--->
<cfif not isdefined('attributes.ship_address_row') or (attributes.ship_address_row eq 0 and (not len(attributes.ship_address0) or not len(attributes.ship_address_city0)))>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1435.Adres Bilgilerini Eksiksiz Doldurunuz'>!");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfif (attributes.paymethod_type eq 2 and (not len(attributes.action_to_account_id) or not len(attributes.card_no) or not len(attributes.cvv_no))) or not isdefined("attributes.paymethod_type") or (attributes.paymethod_type eq 1 and not len(attributes.account_id))>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1436.Ödeme Yönemini Eksiksiz Doldurunuz'>!");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfif not (isDefined("attributes.process_stage") and len(attributes.process_stage))>
	<script type="text/javascript">
		alert("<cf_get_lang_main no ='564.Lütfen Süreçlerinizi Tanımlayınız ve/veya Tanımlanan Süreçler Üzerinde Yetkiniz Yok'>!");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<!--- //form elemanları kontrolleri--->

<cfif isdefined("attributes.FREE_PROM_STOCK_ID") and len(attributes.FREE_PROM_STOCK_ID) and isdefined("attributes.FREE_PROM_AMOUNT") and len(attributes.FREE_PROM_AMOUNT)>
	<cfquery datasource="#dsn3#" name="get_stock" maxrows="1">
	SELECT
		PRODUCT_ID,
		PRODUCT_NAME,
		TAX,
		PROPERTY,
		PRODUCT_UNIT_ID
	FROM
		STOCKS
	WHERE
		STOCK_ID = #attributes.FREE_PROM_STOCK_ID#
	</cfquery>
	<cfset urun_onceden_eklenmismi = 0>
	<cfif not urun_onceden_eklenmismi>
		<cfset attributes.is_prom_asil_hediye = 0>
		<cfscript>
			new_row_no = arraylen(session.basketww_camp)+1;
			//ÜRÜN BİLGİLERİ	
			session.basketww_camp[new_row_no][1] = get_stock.PRODUCT_ID; //ürün id si
			if (trim(get_stock.PROPERTY) is '-')
				{session.basketww_camp[new_row_no][2] = '#get_stock.PRODUCT_NAME#';} //ürün adı 
			else
				{session.basketww_camp[new_row_no][2] = '#get_stock.PRODUCT_NAME# #get_stock.PROPERTY#';} //ürün adı 
			session.basketww_camp[new_row_no][3] = 1; // miktar 
			session.basketww_camp[new_row_no][4] = attributes.FREE_STOCK_PRICE; // kdv siz birim fiyat 
			session.basketww_camp[new_row_no][5] = attributes.FREE_STOCK_PRICE * (1 + (get_stock.TAX / 100)); // kdv li birim fiyat 
			session.basketww_camp[new_row_no][6] = attributes.FREE_STOCK_MONEY; // para birimi 
			session.basketww_camp[new_row_no][7] = get_stock.TAX; // kdv oranı
			session.basketww_camp[new_row_no][8] = attributes.FREE_PROM_STOCK_ID; //ürün stock id si
			session.basketww_camp[new_row_no][9] = get_stock.PRODUCT_UNIT_ID; //ürün ANA birim id si
			//PROMOSYON BİLGİLERİ
			session.basketww_camp[new_row_no][10] = attributes.FREE_PROM_ID; //Promosyon id si
			session.basketww_camp[new_row_no][11] = ''; //Promosyon yüzde indirimi
			session.basketww_camp[new_row_no][12] = attributes.FREE_STOCK_PRICE; //Promosyon iskonto tutarı
			session.basketww_camp[new_row_no][13] = attributes.FREE_PROM_COST; //Promosyon maliyeti		
			session.basketww_camp[new_row_no][14] = ''; //Promosyonun asıl ürününün STOK id si
			session.basketww_camp[new_row_no][15] = attributes.FREE_PROM_AMOUNT; //asıl ürününün Promosyonun gerçekleşmesi için gerekli olan adedi
			session.basketww_camp[new_row_no][16] = 1;//0:asıl ürün 1:hediye ürün
			session.basketww_camp[new_row_no][17] = 1;//1:Hediyeli promosyon 0:Hediyesiz			
			session.basketww_camp[new_row_no][18] = ''; // kdv siz birim fiyat (eğer promosyonda yüzde veya tutar tanımlı ise üstünü çizmek için gelir)
			session.basketww_camp[new_row_no][19] = ''; // Spec id				
			session.basketww_camp[new_row_no][20] = '0';//komisyon bilgisi			
			//son kullanici fiyatlari (=price_standart) AK 20060822
			session.basketww_camp[new_row_no][21] = '0'; // kdv siz birim fiyat (son kullanici)
			session.basketww_camp[new_row_no][22] = '0';// kdv li birim fiyat (son kullanici)
			session.basketww_camp[new_row_no][23] = ''; // para birimi (son kullanici) 
		</cfscript>
	</cfif>
</cfif>

<cfscript>
	if (listfindnocase(employee_url,'#cgi.http_host#',';'))
	{
		int_comp_id = session.ep.company_id;
		int_period_id = session.ep.period_id;
		int_money2 = session.ep.money2;
		MEMBER_TYPE = "EMPLOYEE";
	}
	else if (listfindnocase(partner_url,'#cgi.http_host#',';'))
	{
		int_comp_id = session.pp.our_company_id;
		int_period_id = session.pp.period_id;
		int_money2 = session.pp.money2;
			MEMBER_TYPE = "PARTNER";
			MEMBER_ID = session.pp.userid;
			attributes.COMPANY_ID = session.pp.company_id;
		
	}
	else if (listfindnocase(server_url,'#cgi.http_host#',';') )
	{	
		int_comp_id = session.ww.our_company_id;
		int_period_id = session.ww.period_id;
		int_money2 = session.ww.money2;
			MEMBER_TYPE = "CONSUMER";
			MEMBER_ID = "";
			attributes.consumer_id = session.ww.userid;
	}
</cfscript>

<cfif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 1>
	<cfset paymethod_id=evaluate("attributes.paymethod_id_#attributes.paymethod_type#")>
<cfelseif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 2>
	<cfset attributes.paymethod_id_2 = listgetat(action_to_account_id,3,";")>
	<cfset card_paymethod_id=evaluate("attributes.paymethod_id_#attributes.paymethod_type#")>
<cfelseif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 3>
	<cfset paymethod_id=attributes.risk_paymethod>
</cfif>

<cfif isdefined("paymethod_id") and attributes.paymethod_type eq 2>
	<cfset order_due_date = date_add("d",listgetat(paymethod_id,6),now())>
<cfelseif isdefined("paymethod_id") and isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 3>
	<cfif len(attributes.risk_due_day)>
		<cfset order_due_date = date_add("d",attributes.risk_due_day,now())>
	</cfif>
<cfelse>
	<cfset order_due_date = "">
</cfif>

<cfif isdefined("attributes.ship_address_row") and attributes.ship_address_row eq 0>
	<cfif len('attributes.ship_address0')>
		<cfset ship_adres=attributes.ship_address0>
	</cfif>
	<cfif len('attributes.ship_address_postcode0')>
		<cfset ship_adres=ship_adres&' '&attributes.ship_address_postcode0>
	</cfif>
	<cfif len('attributes.ship_address_semt0')>
		<cfset ship_adres=ship_adres&' '&attributes.ship_address_semt0>
	</cfif>
	<cfif len('attributes.ship_address_county0') and len('attributes.ship_address_county_name0')>
		<cfset ship_adres=ship_adres&' '&attributes.ship_address_county_name0>
		<cfset county_id=attributes.ship_address_county0>
	</cfif>
	<cfif listlen(attributes.ship_address_city0,',') eq 2>
		<cfset city_id=listgetat(attributes.ship_address_city0,1,',')>
		<cfset ship_adres=ship_adres&' '&listgetat(attributes.ship_address_city0,2,',')>
	</cfif>
	<cfif listlen(attributes.ship_address_country0,',') eq 2>
		<cfset ship_adres=ship_adres&' '&listgetat(attributes.ship_address_country0,2,',')>
	</cfif>
<cfelse>
	<cfif isdefined("attributes.ship_address#attributes.ship_address_row#") and len(evaluate('attributes.ship_address#attributes.ship_address_row#'))>
		<cfset ship_adres=evaluate('attributes.ship_address#attributes.ship_address_row#')>
	</cfif>
	<cfif len(evaluate('attributes.ship_address_county#attributes.ship_address_row#'))>
		<cfset county_id=evaluate('attributes.ship_address_county#attributes.ship_address_row#')>
	</cfif>
	<cfif len(evaluate('attributes.ship_address_city#attributes.ship_address_row#'))>
		<cfset city_id=evaluate('attributes.ship_address_city#attributes.ship_address_row#')>
	</cfif>
</cfif>
<cfif len(attributes.deliverdate)><cf_date tarih="attributes.deliverdate"></cfif>
<cf_papers paper_type="order" paper_type2="0">

<cfif MEMBER_TYPE IS "PARTNER">
	<cfquery name="GET_MEMBER_INFO" datasource="#dsn#"><!--- ayrı olarak tekrar çektim cunku positions a baglanıyordu --->
		SELECT SALES_COUNTY,COMPANY_VALUE_ID CUSTOMER_VALUE_ID,RESOURCE_ID,IMS_CODE_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	</cfquery>
 	<cfquery name="get_sales_manager" datasource="#dsn#">
		SELECT
			EP.EMPLOYEE_ID
		FROM
			WORKGROUP_EMP_PAR WEP,
			EMPLOYEE_POSITIONS EP
		WHERE
			WEP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
			EP.POSITION_CODE = WEP.POSITION_CODE AND
			WEP.IS_MASTER = 1 AND
			WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
	</cfquery>
 	<cfset employee_id = get_sales_manager.employee_id>
<cfelseif MEMBER_TYPE IS "CONSUMER">
	<cfquery name="GET_MEMBER_INFO" datasource="#dsn#">
		SELECT SALES_COUNTY,CUSTOMER_VALUE_ID,RESOURCE_ID,IMS_CODE_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfquery>
 	<cfquery name="get_sales_manager" datasource="#dsn#">
		SELECT
			EP.EMPLOYEE_ID
		FROM
			WORKGROUP_EMP_PAR WEP,
			EMPLOYEE_POSITIONS EP
		WHERE
			WEP.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
			EP.POSITION_CODE = WEP.POSITION_CODE AND
			WEP.IS_MASTER = 1 AND
			WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
	</cfquery>
 	<cfset employee_id=get_sales_manager.employee_id>
</cfif>

<cfif isdefined("attributes.tc_identy_no") and isdefined("session.ww.userid")>
	<cfquery name="upd_tc_" datasource="#dsn#">
		UPDATE CONSUMER SET TC_IDENTY_NO = '#attributes.tc_identy_no#' WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfquery>
</cfif>

<cfif isdefined("attributes.tc_identy_no") and isdefined("session.pp.userid")>
	<cfquery name="upd_tc_" datasource="#dsn#">
		UPDATE 
			COMPANY 
		SET 
			TAXOFFICE = '#attributes.tax_office#',
			TAXNO = '#attributes.tax_no#'
		WHERE 
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
	</cfquery>
</cfif>

<cfif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 1 and isdefined("attributes.first_interest_rate") and len(attributes.first_interest_rate)>
	<cfset havale_indirim_orani_ = 1-(attributes.first_interest_rate/100)>
<cfelseif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 2 and isdefined("attributes.kredi_karti_indirim_orani") and attributes.kredi_karti_indirim_orani gt 0>
	<cfset havale_indirim_orani_ = 1-(attributes.kredi_karti_indirim_orani/100)>
<cfelse>
	<cfset havale_indirim_orani_ = 1>
</cfif>

<cfif isdefined("form.genel_indirim") and len(form.genel_indirim)>
	<cfset indirim_total_ = form.genel_indirim>
<cfelse>
	<cfset indirim_total_ = 0>
</cfif>
<cfif isDefined("attributes.is_price_standart") and isDefined("attributes.consumer_info")>
	<cfset discount_total_ = DISCOUNTTOTAL_PS>
<cfelse>
	<cfset discount_total_ = DISCOUNTTOTAL>
</cfif>
<cfif isDefined("attributes.is_price_standart") and isDefined("attributes.consumer_info")>
	<cfset tax_total_ = TAXTOTAL_PS>
<cfelse>
	<cfset tax_total_ = TAXTOTAL>
</cfif>
<cfif isDefined("attributes.is_price_standart") and isDefined("attributes.consumer_info")>
	<cfset net_total_ = NETTOTAL_PS>
<cfelse>
	<cfset net_total_ = NETTOTAL>
</cfif>
<cfif isDefined("attributes.is_price_standart") and isDefined("attributes.consumer_info")>
	<cfset gross_total_ = GROSSTOTAL_PS>
<cfelse>
	<cfset gross_total_ = GROSSTOTAL>
</cfif>
<cfif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 1 and isdefined("attributes.first_interest_rate") and len(attributes.first_interest_rate)>
	<cfset havale_indirim_ = gross_total_ * attributes.first_interest_rate/100>
<cfelseif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 2 and isdefined("attributes.kredi_karti_indirim_orani") and attributes.kredi_karti_indirim_orani gt 0>
	<cfset havale_indirim_ = gross_total_ * attributes.kredi_karti_indirim_orani / 100>
<cfelse>
	<cfset havale_indirim_ = 0>
</cfif>
<cfif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 1 and isdefined("attributes.first_interest_rate") and len(attributes.first_interest_rate)>
	<cfset tax_indirim_ = tax_total_ * attributes.first_interest_rate/100>
<cfelse>
	<cfset tax_indirim_ = 0>
</cfif>
<cfset tax_total_ = tax_total_ - tax_indirim_>
<cfset net_total_ = net_total_ - havale_indirim_ - tax_indirim_>
<cfset indirim_total_ = indirim_total_ + havale_indirim_>
<cfset discount_total_ = discount_total_ + havale_indirim_>

<CFLOCK name="#CREATEUUID()#" timeout="60">
	<CFTRANSACTION>
		<cfquery name="SET_MAX_PAPER" datasource="#DSN3#">
			UPDATE
				GENERAL_PAPERS
			SET
				ORDER_NUMBER = ORDER_NUMBER+1
			WHERE
				PAPER_TYPE = 0 AND
				ZONE_TYPE = 1
		</cfquery>
		<cfquery name="ADD_ORDER" datasource="#DSN3#" result="MAX_ID">
			INSERT INTO
				ORDERS
				(
				ORDER_NUMBER,
			<cfif isdefined("POSITION_CODE") and len(POSITION_CODE) AND len(POSITION)>
				VALIDATOR_POSITION_CODE,
			</cfif>
				ORDER_CURRENCY,
				ORDER_STATUS,
				PRIORITY_ID, 
				COMMETHOD_ID,
			<cfif isdefined("attributes.deliverdate") and len(attributes.deliverdate)>
				DELIVERDATE,
			</cfif>
			<cfif MEMBER_TYPE IS "PARTNER">
				PARTNER_ID,
				COMPANY_ID,
			<cfelseif MEMBER_TYPE IS "CONSUMER">
				CONSUMER_ID,
			</cfif>
			<cfif isdefined("PAYMETHOD_ID") and len(PAYMETHOD_ID)>
				PAYMETHOD,
			<cfelseif isdefined("card_paymethod_id") and len(card_paymethod_id)>
				CARD_PAYMETHOD_ID,
				CARD_PAYMETHOD_RATE,
			</cfif>
			<cfif isdefined("OFFER_ID") and len(OFFER_ID) and len(OFFER_HEAD)>
				OFFER_ID,
			</cfif>
			<cfif isdefined("SALES_POSITION_CODE") and len(SALES_POSITION_CODE) AND len(SALES_POSITION)>
				SALES_POSITION_CODE,
			</cfif>
			<cfif isdefined("SALES_PARTNER_ID") and len(SALES_PARTNER_ID) AND len(SALES_PARTNER)>
				SALES_PARTNER_ID,
			</cfif>
				SHIP_ADDRESS,
				COUNTY_ID,
				CITY_ID,
				ORDER_HEAD,
				ORDER_DETAIL,
				ZONE_ID,
				RESOURCE_ID,
				IMS_CODE_ID,
				CUSTOMER_VALUE_ID,
				GROSSTOTAL,
				TAXTOTAL,
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
				ORDER_ZONE
				<cfif isdefined("attributes.ship_method_id") and len(attributes.ship_method_id)>,SHIP_METHOD</cfif>
				,RESERVED
				<cfif isdefined("attributes.project_id") and len(attributes.project_id)>,PROJECT_ID</cfif>
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
				CAMPAIGN_ID
				)
			VALUES
				(
				'#paper_full#',
			<cfif isdefined("POSITION_CODE") and len(POSITION_CODE) AND len(POSITION)>
				#POSITION_CODE#,
			</cfif>
				-1,
				1,
				1, 
			<cfif isDefined("session.pp.company_id")>7,<cfelseif isDefined("session.ww.userid")>6,</cfif>
			<cfif isdefined("attributes.deliverdate") and len(attributes.deliverdate)>#attributes.deliverdate#,</cfif>
			<cfif MEMBER_TYPE IS "PARTNER">
				<cfif len(MEMBER_ID)>#MEMBER_ID#<cfelse>NULL</cfif>,
				#attributes.COMPANY_ID#,
			<cfelseif MEMBER_TYPE IS "CONSUMER">
				#SESSION.WW.USERID#,
			</cfif>
			<cfif isdefined("PAYMETHOD_ID") and len(PAYMETHOD_ID)>
				#listfirst(PAYMETHOD_ID)#,
			<cfelseif isdefined("card_paymethod_id") and len(card_paymethod_id)>
				#listfirst(card_paymethod_id)#,
				<cfif listlen(card_paymethod_id) gt 1>#listgetat(card_paymethod_id,2,',')#<cfelse>NULL</cfif>,
			</cfif>
			<cfif isdefined("OFFER_ID") and len(OFFER_ID) AND len(OFFER_HEAD)>#OFFER_ID#,</cfif>
			<cfif isdefined("SALES_POSITION_CODE") and len(SALES_POSITION_CODE) AND len(SALES_POSITION)>#SALES_POSITION_CODE#,</cfif>
			<cfif isdefined("SALES_PARTNER_ID") and len(SALES_PARTNER_ID) AND len(SALES_PARTNER)>
				#SALES_PARTNER_ID#,
			</cfif>
			<cfif isdefined('ship_adres') and len(ship_adres)>'#ship_adres#'<cfelse>NULL</cfif>,
			<cfif isdefined('county_id') and len(county_id)>#county_id#<cfelse>NULL</cfif>,
			<cfif isdefined('city_id') and len(city_id)>#city_id#<cfelse>NULL</cfif>,
			'İnternetten Sipariş',
			<cfif isdefined("attributes.order_detail")>'#order_detail#'<cfelse>NULL</cfif>,
			<cfif len(GET_MEMBER_INFO.SALES_COUNTY)>#GET_MEMBER_INFO.SALES_COUNTY#,<cfelse>NULL,</cfif>
			<cfif len(GET_MEMBER_INFO.RESOURCE_ID)>#GET_MEMBER_INFO.RESOURCE_ID#,<cfelse>NULL,</cfif>
			<cfif len(GET_MEMBER_INFO.IMS_CODE_ID)>#GET_MEMBER_INFO.IMS_CODE_ID#,<cfelse>NULL,</cfif>
			<cfif len(GET_MEMBER_INFO.CUSTOMER_VALUE_ID)>#GET_MEMBER_INFO.CUSTOMER_VALUE_ID#,<cfelse>NULL,</cfif>
				#gross_total_#,
				#tax_total_#,
				#discount_total_#,
				#net_total_#,
				<cfif isdefined("included_kdv")>1<cfelse>0</cfif>,
				'#OTHER_MONEY#',
				#OTHER_MONEY_VALUE#,
				0,
				#NOW()#,
				'#CGI.REMOTE_ADDR#',
			<cfif MEMBER_TYPE IS "PARTNER">
				NULL,
				#MEMBER_ID#,
			<cfelseif MEMBER_TYPE IS "CONSUMER">
				#session.ww.userid#,
				NULL,
			</cfif>
				<!--- #SESSION.WW.USERID#,
				#SESSION.EP.USERID#, --->
				1
				<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id)>
				,#attributes.ship_method_id#	
				</cfif>
				,1
				<!--- <cfif isdefined('reserved')>
				,1
				<cfelse>
				,0
				</cfif> --->
				<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
					,#attributes.PROJECT_ID#
				</cfif>
				,#now()#
				,#attributes.process_stage#
				,<cfif isdefined("employee_id") and len(employee_id)>#employee_id#<cfelse>NULL</cfif>,
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
			<cfif isDefined("attributes.campaign_id") and len(attributes.campaign_id)>#attributes.campaign_id#<cfelse>NULL</cfif><!---kampanyadan sipariş  --->
				)
		</cfquery>
		<cfloop from="1" to="#ArrayLen(session.basketww_camp)#" index="i"><!--- #attributes.rows_# --->
			<cf_date tarih="attributes.deliver_date#i#">
			<cfloop from="1" to="#attributes.kur_say#" index="int_tr">
				<cfif session.basketww_camp[i][6] eq evaluate("hidden_rd_money_#int_tr#")>
					<cfset satir_fiyati= session.basketww_camp[i][4]*evaluate("txt_rate2_#int_tr#")/evaluate("txt_rate1_#int_tr#") >
					<cfset oth_m_val = evaluate("txt_rate2_#int_tr#")/evaluate("txt_rate1_#int_tr#")>
				</cfif>
			</cfloop>
			<cfset 'net_maliyet#i#' = ''>
			<!--- <cfset 'cost_id#i#' = ''> --->
			<cfset 'extra_cost#i#' = ''>
			<cfset 'row_spect_id#i#' = ''>
			<!--- 
			Tolga kapattım burayı ben şimdilik, sen function düzenlemelerine göre açarsın
			RECORD_CONS - session.ww.userid    eklencek
			Ayrıca rate lerle işlem yapıyosan pp ve ww rate lerinide eklemek lazım  Aysenur20061020--->
			<cfquery name="GET_PRODUCTION" datasource="#dsn3#">
				SELECT IS_PRODUCTION FROM PRODUCT WHERE PRODUCT_ID=#session.basketww_camp[i][1]#
			</cfquery>
			<cfif GET_PRODUCTION.IS_PRODUCTION>
				<cfinclude template="add_orderww_spect_camp.cfm">
			</cfif>
			<cfif not isdefined('row_spect_id#i#') or not len(evaluate('row_spect_id#i#'))>				
				<cfquery name="GET_PRODUCT_COST" datasource="#dsn3#" maxrows="1">
					SELECT 
						<!--- PC.PRODUCT_COST_ID, --->
						PC.PURCHASE_NET_SYSTEM,
						PC.PURCHASE_EXTRA_COST_SYSTEM
					FROM 
						PRODUCT_COST PC,
						PRODUCT P
					WHERE 
						P.PRODUCT_ID = PC.PRODUCT_ID AND
						PC.PRODUCT_COST IS NOT NULL AND
						PC.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,now())#"> AND 
						PC.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.basketww_camp[i][1]#"> AND
						P.IS_COST = 1
					ORDER BY 
						PC.START_DATE DESC,PC.RECORD_DATE DESC
				</cfquery>
				<cfif GET_PRODUCT_COST.recordcount>
					<cfset 'net_maliyet#i#' = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM>
					<!--- <cfset 'cost_id#i#' = GET_PRODUCT_COST.PRODUCT_COST_ID> --->
					<cfset 'extra_cost#i#' = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM>
				</cfif>
			</cfif>
			<cfscript>
				row_nettotal = satir_fiyati * session.basketww_camp[i][3] * session.basketww_camp[i][15];
				if(len(session.basketww_camp[i][12]))
					for(k=1;k lte attributes.kur_say;k=k+1)
						if(session.basketww_camp[i][6] eq evaluate("hidden_rd_money_#k#"))
							row_nettotal = row_nettotal - (session.basketww_camp[i][12] * evaluate("txt_rate2_#k#")/evaluate("txt_rate1_#k#") * session.basketww_camp[i][3] * session.basketww_camp[i][15]);
				if(len(session.basketww_camp[i][11]))
					row_nettotal = row_nettotal * (100-session.basketww_camp[i][11]) /100;
				//row_taxtotal = wrk_round(row_nettotal * (session.basketww_camp[i][7]/100));
				//row_lasttotal = row_nettotal + row_taxtotal;
				other_money_value = row_nettotal;
				for(k=1;k lte attributes.kur_say;k=k+1)
					if(session.basketww_camp[i][6] eq evaluate("hidden_rd_money_#k#"))
						other_money_value = other_money_value / evaluate("txt_rate2_#k#");
			</cfscript>
			<cfquery name="ADD_ORDER_ROW" datasource="#DSN3#">
				INSERT INTO
					ORDER_ROW
					(
					WRK_ROW_ID,
					CATALOG_ID,
					ORDER_ROW_CURRENCY,
					ORDER_ID,
					PRODUCT_ID,
					STOCK_ID,
					QUANTITY,
					UNIT,
					UNIT_ID,
					PRICE,
					TAX,
					DUEDATE,
					PRODUCT_NAME,
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
				<cfif isdefined('row_spect_id#i#') and len(evaluate('row_spect_id#i#'))><!--- IsStruct(session.basketww_camp[i][19]) and isdefined('spect_id') and len(spect_id) --->
					SPECT_VAR_ID,
					SPECT_VAR_NAME,
				</cfif>
					<!--- LOT_NO, --->
					PRICE_OTHER,
					<!--- COST_ID, --->
					COST_PRICE,
					EXTRA_COST,
					MARJ,
					NETTOTAL,
					<!--- Yeni Eklenen Alanlar. Promosyon İle İlgili --->
					PROM_COMISSION,
					PROM_COST,
					DISCOUNT_COST,
					PROM_ID,
					IS_PROMOTION,
					IS_COMMISSION,
					RESERVE_TYPE,
					PROM_STOCK_ID,
					WIDTH_VALUE,
					DEPTH_VALUE,
					HEIGHT_VALUE,
					ROW_PROJECT_ID
					)
				VALUES
					(
					<cfif isdefined("session.pp.userid")>
						'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.pp.userid##round(rand()*100)#',
					<cfelseif isdefined("session.ww.userid")>
						'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ww.userid##round(rand()*100)#',
					<cfelse>
						'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#',
					</cfif>
					<cfif len(session.basketww_camp[i][25])>#session.basketww_camp[i][25]#<cfelse>NULL</cfif>,
					-1,
					#MAX_ID.IDENTITYCOL#,
					#session.basketww_camp[i][1]#,
					#session.basketww_camp[i][8]#,
					#session.basketww_camp[i][3]*session.basketww_camp[i][15]#,
					'Adet',
					#session.basketww_camp[i][9]#,
					#satir_fiyati#,
					#session.basketww_camp[i][7]#,
				<cfif isdefined("attributes.duedate#i#") and len(evaluate("attributes.duedate#i#"))>#evaluate("attributes.duedate#i#")#,<cfelse>0,</cfif>
					'#session.basketww_camp[i][2]#',
				<cfif isdefined("attributes.deliver_date") and isdate(evaluate('attributes.deliver_date'))>#attributes.deliver_date#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
					#listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
				<cfelse>
					NULL,
				</cfif>
				<cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
					#listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
				<cfelse>
					NULL,
				</cfif>
				<cfif isdefined('attributes.indirim1#i#')>#evaluate('attributes.indirim1#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.indirim2#i#')>#evaluate('attributes.indirim2#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.indirim3#i#')>#evaluate('attributes.indirim3#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.indirim4#i#')>#evaluate('attributes.indirim4#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.indirim5#i#')>#evaluate('attributes.indirim5#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.indirim6#i#')>#evaluate('attributes.indirim6#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.indirim7#i#')>#evaluate('attributes.indirim7#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.indirim8#i#')>#evaluate('attributes.indirim8#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.indirim9#i#')>#evaluate('attributes.indirim9#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.indirim10#i#')>#evaluate('attributes.indirim10#i#')#<cfelse>0</cfif>,
				'#session.basketww_camp[i][6]#',
				#other_money_value#,
				<cfif isdefined('row_spect_id#i#') and len(evaluate('row_spect_id#i#'))>
					#evaluate('row_spect_id#i#')#,
					'#session.basketww_camp[i][2]#',
				</cfif>
				<!--- <cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>#evaluate('attributes.lot_no#i#')#<cfelse>NULL</cfif>, --->
				#session.basketww_camp[i][4]#,
				<!--- <cfif len(evaluate('cost_id#i#'))>#evaluate('cost_id#i#')#<cfelse>NULL</cfif>, --->
				<cfif len(evaluate('net_maliyet#i#'))>#evaluate('net_maliyet#i#')#<cfelse>0</cfif>,
				<cfif len(evaluate('extra_cost#i#'))>#evaluate('extra_cost#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.marj#i#') and len(evaluate('attributes.marj#i#'))>#evaluate('attributes.marj#i#')#<cfelse>0</cfif>,
				#row_nettotal#,
				<cfif len(session.basketww_camp[i][11])>#session.basketww_camp[i][11]#,<cfelse>NULL,</cfif>
				<cfif len(session.basketww_camp[i][13])>#session.basketww_camp[i][13]#,<cfelse>0,</cfif>
				<cfif len(session.basketww_camp[i][12])>#session.basketww_camp[i][12]#,<cfelse>NULL,</cfif>
				<cfif len(session.basketww_camp[i][10])>#session.basketww_camp[i][10]#,<cfelse>NULL,</cfif>
				<cfif len(session.basketww_camp[i][16])>#session.basketww_camp[i][16]#,<cfelse>NULL,</cfif>				
				<cfif len(session.basketww_camp[i][20]) and session.basketww_camp[i][20] eq 1>#session.basketww_camp[i][20]#,<cfelse>0,</cfif>
				-1,
				<cfif len(session.basketww_camp[i][16]) and session.basketww_camp[i][16] and len(session.basketww_camp[i][14])>#session.basketww_camp[i][14]#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>
				)
			</cfquery>

			<!---  urun asortileri --->			
			<cfquery name="get_max_order_row" datasource="#DSN3#">
				SELECT MAX(ORDER_ROW_ID) AS ORDER_ROW_ID FROM ORDER_ROW
			</cfquery>
			<!---TolgaS 20060624 <cfinclude template="add_orderww_row_spect.cfm"> --->
			<cfset attributes.ROW_MAIN_ID = get_max_order_row.ORDER_ROW_ID>
			<cfset row_id = I>
			<cfset ACTION_TYPE_ID = 2>
			<cfset attributes.product_id = session.basketww_camp[i][1]>
			<!--- <cfinclude template="add_assortment_textile_js.cfm"> sonra düşünülecek.. a.selam --->
			<!--- //  urun asortileri --->
		</cfloop>
		<cfscript>
			attributes.BASKET_MONEY = OTHER_MONEY;
			basket_kur_ekle(action_id:MAX_ID.IDENTITYCOL,table_type_id:3,process_type:0);
			include('add_order_row_reserved_stock.cfm','\objects\functions'); //rezerve edilen satırlar icin ORDER_ROW_RESERVED'a kayıt atıyor.
			add_reserve_row(
				reserve_order_id:MAX_ID.IDENTITYCOL,
				reserve_action_type:0,
				is_order_process:0,
				order_from_partner:1,
				is_purchase_sales:1
				);
			</cfscript>
	</CFTRANSACTION>
</CFLOCK>
<cfscript>
	structdelete(session,'basketww_camp');
</cfscript>
<script type="text/javascript">
	alert("<cf_get_lang no ='1437.Siparişiniz başarıyla kaydedilmiştir'> !");
</script>
<cfif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 1><!---havale yöntemi--->
	<cfinclude template="../query/add_inc_bankorder_from_orders.cfm">
<cfelseif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 2><!---kredi kartıyla ödeme--->
	<form name="pop_gonder" action="" method="post">
		<cfoutput>
			<input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
			<input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
			<input type="hidden" name="order_id" id="order_id" value="#MAX_ID.IDENTITYCOL#">
			<input type="hidden" name="action_to_account_id" id="action_to_account_id" value="#attributes.action_to_account_id#">
			<input type="hidden" name="process_cat_rev" id="process_cat_rev" value="#attributes.process_cat_rev#">
			<input type="hidden" name="process_type" id="process_type" value="#attributes.process_type#">
			<input type="hidden" name="action_from_company_id" id="action_from_company_id" value="#attributes.action_from_company_id#">
			<input type="hidden" name="action_date" id="action_date" value="#attributes.action_date#">
			<input type="hidden" name="card_no" id="card_no" value="#attributes.card_no#">
			<input type="hidden" name="cvv_no" id="cvv_no" value="#attributes.cvv_no#">
			<input type="hidden" name="exp_month" id="exp_month" value="#attributes.exp_month#">
			<input type="hidden" name="exp_year" id="exp_year" value="#attributes.exp_year#">
			<input type="hidden" name="sales_credit" id="sales_credit" value="#attributes.sales_credit#">
			<input type="hidden" name="card_owner" id="card_owner" value="#attributes.card_owner#">
			<input type="hidden" name="action_detail" id="action_detail" value="<cfif isdefined("attributes.order_detail")>#attributes.order_detail#</cfif>">
			<cfif isDefined("attributes.joker_vada")>
				<input type="hidden" name="joker_vada" id="joker_vada" value="#attributes.joker_vada#">
			</cfif>
			<cfif isDefined("attributes.is_price_standart")>
				<input type="hidden" name="is_price_standart" id="is_price_standart" value="#attributes.is_price_standart#">
				<input type="hidden" name="price_standart_last" id="price_standart_last" value="#attributes.price_standart_last#">
			</cfif>
			<cfif isDefined("attributes.campaign_id")>
				<input type="hidden" name="campaign_id" id="campaign_id" value="#attributes.campaign_id#">
			</cfif>
		</cfoutput>
	</form>
	<script type="text/javascript">
		pop_gonder.action='<cfoutput><cfif use_https>#https_domain#</cfif>#request.self#?fuseaction=objects2.popup_add_online_pos_kontrol</cfoutput>';
		pop_gonder.target='kredi_window';
		pop_gonder.submit();
		window.location.href='<cfoutput>#request.self#?fuseaction=objects2.view_list_order&zone=1&form_submitted=1</cfoutput>';
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.href='<cfoutput>#request.self#?fuseaction=objects2.view_list_order&zone=1&form_submitted=1</cfoutput>';
	</script>
</cfif>

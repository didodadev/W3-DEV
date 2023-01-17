<!--- timesaat --->

<cf_date tarih="attributes.order_date">
<cfset attributes.price_date = attributes.order_date>
<cfquery name="get_adres" datasource="#DSN#">
SELECT 
	C.CITY, C.COUNTY, C.COMPANY_ADDRESS, C.SEMT,	
	SETUP_CITY.CITY_NAME,
	SETUP_COUNTY.COUNTY_NAME
FROM 
	COMPANY C, SETUP_CITY, SETUP_COUNTY 
WHERE 
	C.COMPANY_ID = #attributes.company_id# AND
	C.CITY = SETUP_CITY.CITY_ID AND
	C.COUNTY = SETUP_COUNTY.COUNTY_ID 
</cfquery>
<cfset attributes.ship_address_city_id = get_adres.CITY>
<cfset attributes.ship_address_county_id = get_adres.COUNTY>
<cfset attributes.ship_address = '#get_adres.COMPANY_ADDRESS# #get_adres.SEMT# #get_adres.COUNTY_NAME# #get_adres.CITY_NAME#'>
<cfset attributes.process_stage = 15>
<cfset attributes.reserved = 1>
<cfif not len(attributes.ship_date)>
	<cfset attributes.ship_date = dateformat(date_add('d',1,attributes.order_date),'dd/mm/yyyy')>	
</cfif>
<cf_date tarih="attributes.ship_date">
<cfset attributes.deliverdate = dateformat(date_add('d',1,attributes.ship_date),'dd/mm/yyyy')>

<cfset attributes.order_date = dateformat(attributes.order_date,"dd/mm/yyyy")>
<cfset attributes.ship_date = dateformat(attributes.ship_date,"dd/mm/yyyy")>	
<!--- //timesaat --->

<cfscript>
	wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.pda.userid#_'&round(rand()*100);
	form.active_period = session.pda.period_id;
	attributes.process_cat = attributes.process_stage;
	form.process_cat = attributes.process_stage;
	'ct_process_type_#attributes.process_cat#'= 76;
	//attributes.deliver_date_frm = attributes.action_date;
	//attributes.ship_date = attributes.action_date;
	//attributes.deliver_date = attributes.action_date;
	//attributes.department_id = ListGetAt(attributes.dept_in_id,1,';');
	//attributes.location_id = ListGetAt(attributes.dept_in_id,2,';');
	//attributes.basket_due_value_date_ = attributes.action_date;
	//attributes.deliverdate = attributes.action_date;
	//attributes.ship_date = attributes.action_date;
	//attributes.company_id = attributes.member_id;
	//attributes.partner_id = '';
	/*
	GET_SETUP_MONEY=cfquery(SQLString:"SELECT RATE2,RATE1, MONEY MONEY_TYPE,PERIOD_ID FROM SETUP_MONEY",Datasource:dsn2,is_select:1);//kurlar alınıyor
	//kurlar ile ilgili değişkenler oluşuyor		
	for(stp_mny=1;stp_mny lte GET_SETUP_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
	{
		GET_MONEY_HISTORY=cfquery(SQLString:"SELECT RATE2,RATE1,MONEY MONEY_TYPE FROM MONEY_HISTORY WHERE VALIDATE_DATE >=#createodbcdatetime(attributes.order_date)# AND MONEY ='#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#' AND PERIOD_ID = #session.pda.period_id# ORDER BY VALIDATE_DATE ",Datasource:dsn,is_select:1);
		if(GET_MONEY_HISTORY.RECORDCOUNT)
			'#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'='#GET_MONEY_HISTORY.RATE1#;#GET_MONEY_HISTORY.RATE2#';
		else
			'#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'='#GET_SETUP_MONEY.RATE1[stp_mny]#;#GET_SETUP_MONEY.RATE2[stp_mny]#';
		'attributes.hidden_rd_money_#stp_mny#'=GET_SETUP_MONEY.MONEY_TYPE[stp_mny];
		'attributes.txt_rate1_#stp_mny#'=listfirst(evaluate('#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'),';');				
		'attributes.txt_rate2_#stp_mny#'=listlast(evaluate('#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'),';');
	}
	if(isdefined('session.pda.money2') and len(trim(session.pda.money2)))
	{
		form.basket_money=session.pda.money2;
		attributes.basket_money=session.pda.money2;
	}
	else
	{
		form.basket_money=session.pda.money;
		attributes.basket_money=session.pda.money;
	}
	form.basket_rate1=listfirst(evaluate('#form.basket_money#_rate'),';');
	form.basket_rate2=listlast(evaluate('#form.basket_money#_rate'),';');
	*/
	//attributes.kur_say=GET_SETUP_MONEY.RECORDCOUNT;
	//attributes.detail = '';
	//attributes.reserved = 0;
	attributes.paper_number = '';
	ship_number = '';
	
	form.active_company = session.pda.our_company_id;
	attributes.consumer_id = '';
	attributes.currency_multiplier = '';
	attributes.subscription_id = '';
	attributes.deliver_dept_id = '';
	attributes.deliver_loc_id = '';
	attributes.deliver_dept_name = '';
	attributes.record_emp = session.pda.userid;
	attributes.sales_emp = session.pda.userid;
	attributes.ref_company_id = "";
	attributes.ref_member_type = "";
	attributes.ref_member_id = "";
	attributes.ref_company = "";
	//attributes.paymethod_id = "";
	attributes.order_employee_id = session.pda.userid;
	attributes.order_employee = get_emp_info(attributes.order_employee_id,0,0);
	attributes.project_id = '';
	attributes.ref_no = '';
	attributes.sales_add_option = '';
	attributes.order_head = 'PDA Siparişiniz';

	form.genel_indirim = 0;
	attributes.general_prom_limit=0;
	attributes.general_prom_discount=0;
	attributes.general_prom_amount=0;
	attributes.free_prom_limit=0;
	attributes.free_prom_amount=0;
	attributes.free_prom_cost=0;

	xml_basket_net_total=0;
	xml_basket_gross_total=0;
	xml_basket_tax_total=0;
	error_flag=0;

	for(row_i=1;row_i lte attributes.row_count;row_i=row_i+1)
	{
		if (evaluate('attributes.row_kontrol#row_i#'))
		{
		product_sql_str='SELECT DISTINCT 
							SB.BARCODE,
							S.STOCK_ID,
							S.PRODUCT_ID,
							S.STOCK_CODE,
							S.PRODUCT_NAME,
							S.PROPERTY,
							S.IS_INVENTORY,
							S.MANUFACT_CODE,
							S.TAX,
							S.IS_PRODUCTION,
							PU.ADD_UNIT,
							PU.PRODUCT_UNIT_ID,
							PU.MULTIPLIER,
							PP.ACCOUNT_CODE,
							PP.ACCOUNT_CODE_PUR,
							PP.ACCOUNT_IADE';
			if (isdefined('attributes.price_cat_id') and attributes.price_cat_id gt 0)
				product_sql_str=product_sql_str&'
				,
				PRICE.PRICE,
				PRICE.MONEY
				';
			else if (isdefined('attributes.price_cat_id') and attributes.price_cat_id is 0)
				product_sql_str=product_sql_str&'
				,
				PRICE_STANDART.PRICE,
				PRICE_STANDART.MONEY
				';
			else
				product_sql_str=product_sql_str&'
				,
				PRICE_STANDART.PRICE,
				PRICE_STANDART.MONEY
				';
				product_sql_str=product_sql_str&'
						FROM
							STOCKS AS S,
							PRODUCT_UNIT AS PU,
							PRODUCT_PERIOD PP,
							STOCKS_BARCODES SB
				';
			if (isdefined('attributes.price_cat_id') and attributes.price_cat_id gt 0)
				product_sql_str=product_sql_str&'
				,PRICE
				';
			else if (isdefined('attributes.price_cat_id') and attributes.price_cat_id is 0)
				product_sql_str=product_sql_str&'
				,PRICE_STANDART
				';
			else
				product_sql_str=product_sql_str&'
				,PRICE_STANDART
				';
				product_sql_str=product_sql_str&'
						WHERE
							SB.STOCK_ID = S.STOCK_ID AND
							S.PRODUCT_STATUS = 1 AND
							S.STOCK_STATUS = 1 AND
							S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
							S.PRODUCT_ID = PU.PRODUCT_ID AND
							PP.PRODUCT_ID=S.PRODUCT_ID AND
							PP.PERIOD_ID = #session.pda.period_id# AND
							PU.MAIN_UNIT = PU.ADD_UNIT AND
				';
			if (isdefined('attributes.price_cat_id') and attributes.price_cat_id gt 0)
				product_sql_str=product_sql_str&'
				S.PRODUCT_ID = PRICE.PRODUCT_ID AND
				PRICE.PRICE_CATID = #attributes.price_cat_id# AND
				(
					PRICE.STARTDATE <= #attributes.price_date# AND
					(PRICE.FINISHDATE >= #attributes.price_date# OR PRICE.FINISHDATE IS NULL)
				)
				';
			else if (isdefined('attributes.price_cat_id') and attributes.price_cat_id is 0)
				product_sql_str=product_sql_str&'
				S.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
				PRICE_STANDART.PURCHASESALES = 1 AND
				PRICE_STANDART.PRICESTANDART_STATUS = 1 
				';
			else
				product_sql_str=product_sql_str&'
				S.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
				PRICE_STANDART.PURCHASESALES = 1 AND
				PRICE_STANDART.PRICESTANDART_STATUS = 1 
				';
		GET_PRODUCT_ID=cfquery(SQLString:"#product_sql_str# AND SB.BARCODE = '#evaluate("attributes.barcode#row_i#")#'",Datasource:dsn3,is_select:1);
		/*  STOCK VS KONTROLLERNDEN SONRA DEĞİŞECEK
		if(GET_PRODUCT_ID.RECORDCOUNT eq 1)
		{*/
			'attributes.price_cat#row_i#' = attributes.price_cat_id;
			//'attributes.row_total#row_i#' = filterNum(evaluate("attributes.row_total#row_i#"));
			//'attributes.row_last_total#row_i#' = filterNum(evaluate("attributes.row_last_total#row_i#"));
			//'attributes.row_lasttotal#row_i#' = filterNum(evaluate("attributes.row_last_total#row_i#"));
			//'attributes.row_taxtotal#row_i#' = 0;//bakılckk
			//'attributes.quantity#row_i#' = filterNum(evaluate("attributes.amount#row_i#"));
			'attributes.is_inventory#row_i#' = GET_PRODUCT_ID.IS_INVENTORY;
			'attributes.product_id#row_i#'=GET_PRODUCT_ID.PRODUCT_ID;
			'attributes.stock_id#row_i#'=GET_PRODUCT_ID.STOCK_ID;
			//'attributes.amount#row_i#' = evaluate("attributes.amount#row_i#");
			'attributes.unit#row_i#'= GET_PRODUCT_ID.ADD_UNIT;
			'attributes.unit_id#row_i#'= GET_PRODUCT_ID.PRODUCT_UNIT_ID;
			for(i=1;i lte attributes.kur_say;i=i+1)
			{
				if (evaluate("attributes.hidden_rd_money_#i#") is GET_PRODUCT_ID.MONEY)
					'attributes.price#row_i#' = wrk_round(GET_PRODUCT_ID.PRICE*evaluate("attributes.txt_rate2_#i#")/evaluate("attributes.txt_rate1_#i#"),2);
					
			}
			'attributes.list_price#row_i#' = evaluate("attributes.price#row_i#");
			'attributes.price_other#row_i#'= GET_PRODUCT_ID.PRICE;
			'attributes.tax#row_i#'=GET_PRODUCT_ID.TAX;							
			'attributes.row_nettotal#row_i#' = wrk_round(evaluate("attributes.price#row_i#")*evaluate("attributes.amount#row_i#"),2);
			'attributes.row_tax_total#row_i#'= wrk_round(evaluate("attributes.row_nettotal#row_i#")*(evaluate("attributes.tax#row_i#")/100),2);
			'attributes.product_name#row_i#' = GET_PRODUCT_ID.PRODUCT_NAME;
			'attributes.other_money_#row_i#' = GET_PRODUCT_ID.MONEY;
			//'attributes.other_money_gross_total#row_i#' = evaluate("attributes.row_total#row_i#");
			'attributes.other_money_value_#row_i#' = wrk_round(GET_PRODUCT_ID.PRICE*evaluate("attributes.amount#row_i#"),2);
			'attributes.order_currency#row_i#' = -1;
			'attributes.reserve_type#row_i#' = -1;
			'attributes.spect_id#row_i#' = "";
			'attributes.is_production#row_i#' = GET_PRODUCT_ID.IS_PRODUCTION;
		
			//xml_basket_net_total = wrk_round(xml_basket_net_total+(evaluate("attributes.row_total#row_i#")*evaluate("attributes.amount#row_i#")));
			xml_basket_gross_total = wrk_round(xml_basket_gross_total+evaluate("attributes.row_nettotal#row_i#"));
			xml_basket_tax_total = wrk_round(xml_basket_tax_total+evaluate("attributes.row_tax_total#row_i#"));
			
			'attributes.indirim1#row_i#'=0;
			'attributes.indirim2#row_i#'=0;
			'attributes.indirim3#row_i#'=0;
			'attributes.indirim4#row_i#'=0;
			'attributes.indirim5#row_i#'=0;
			'attributes.indirim6#row_i#'=0;
			'attributes.indirim7#row_i#'=0;
			'attributes.indirim8#row_i#'=0;
			'attributes.indirim9#row_i#'=0;
			'attributes.indirim10#row_i#'=0;
			'attributes.iskonto_tutar#row_i#'=0;
			'attributes.ek_tutar_price#row_i#'=0;
			'attributes.ek_tutar#row_i#'=0;
			'attributes.ek_tutar_other_total#row_i#'=0;
			'attributes.ek_tutar_total#row_i#'=0;
			'attributes.extra_cost#row_i#'=0;
			'attributes.otv_oran#row_i#'=0;
			'attributes.row_otvtotal#row_i#'=0;
		/*}
		else
			abort('Seçtiğiniz Ürün Sistemde Bulunamadı<br/>');*/
		}
	}
	attributes.rows_ = attributes.row_count;
	form.basket_discount_total = form.sa_discount;
	form.basket_gross_total = xml_basket_gross_total;
	form.basket_net_total = xml_basket_gross_total+xml_basket_tax_total-form.sa_discount;
	form.basket_tax_total = xml_basket_tax_total;

</cfscript>

<!--- <cfif isDefined('attributes.kur_say') and len(attributes.kur_say)>
	<cfloop from="1" to="#attributes.kur_say#" index="mon">
		<cfif evaluate("attributes.hidden_rd_money_#mon#") is session.pda.money2>
			<cfset attributes.currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#')>
		</cfif>
	</cfloop>	
</cfif> --->

	<!--- <cftry> --->
		<cfinclude template="../../sales/query/add_order.cfm">
		<!--- <cfcatch>
			Sipariş Kayıt İşleminizde Hata Oluştu.İşlemlerinizi Kontrol Ediniz!<br/><br/>
		</cfcatch>
	</cftry> --->
	

<cfquery name="UPD_ORDER" datasource="#DSN3#">
UPDATE ORDERS SET ORDER_HEAD = '#session.pda.name# #session.pda.surname# - #dateformat(now(),"dd/mm/yyyy")# - #paper_full#' WHERE ORDER_ID = #GET_MAX_ORDER.MAX_ID#
</cfquery>
<!---<cfquery name="DEL_ROW_RESERVE" datasource="#dsn3#">
	DELETE FROM 
		ORDER_ROW_RESERVED 
	WHERE 
		PRE_ORDER_ID='#CFTOKEN#'
</cfquery>--->
<cfstoredproc procedure="DEL_ORDER_ROW_RESERVED" datasource="#DSN3#">
    <cfprocparam cfsqltype="cf_sql_varchar" value="#cftoken#">
</cfstoredproc>

<script type="text/javascript">
	alert('<cfoutput>#paper_full#</cfoutput> no lu siparişiniz başarıyla kaydedilmiştir !');
	window.location.href = '<cfoutput>#request.self#?fuseaction=pda.list_order&cpid=#attributes.company_id#</cfoutput>';
</script>

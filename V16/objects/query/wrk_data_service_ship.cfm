<!--- dataservice irsaliye --->
<cfquery name="GET_WRKXML" datasource="#dsn#">
	SELECT 
		WORKXML_OUR_COMPANY,
		WORKXML_NAME,
		WORKXML_MEMBER_NO,
		WORKXML_USER,
		WORKXML_IP,
		WORKXML_ADRESS,
		WORKXML_PASSWORD,
		WORKXML_ID
	FROM 
		WORKXML_SERVICE
	WHERE 
		WORKXML_ID = #attributes.wrk_data_service#
</cfquery>
<cfparam name="product_match_type" default="1">
<cfscript>
	ws = CreateObject('webservice',GET_WRKXML.WORKXML_ADRESS);
	if(ws.password_control(member_code:GET_WRKXML.WORKXML_MEMBER_NO,user_name:GET_WRKXML.WORKXML_USER,user_password:GET_WRKXML.WORKXML_PASSWORD))
	{
		query_text="SELECT SHIP_ID,SHIP_DATE,DELIVER_DATE FROM SHIP WHERE SHIP_NUMBER = '#attributes.paper_no#'";
		call_function_string='wrk_xml(query_string:"#query_text#",query_string_datasource:"##DSN2##",query_string_xml_tag_name:"SHIP")';
		wrkxml_data=ws.wrk_call_function(comp_id:GET_WRKXML.WORKXML_OUR_COMPANY,process_date:"#attributes.processdate#",call_function:"#call_function_string#");
		wrk_xml_read(xml_data:wrkxml_data);
		
		if(isdefined('SHIP_SHIP_ID_2'))
		{
			//ship_row cekilliyor
			
			query_text="SELECT 
						(SELECT BARCOD FROM ##dsn3_alias##.STOCKS STOCKS WHERE STOCKS.STOCK_ID=SHIP_ROW.STOCK_ID) BARCOD,
						(SELECT STOCK_CODE FROM ##dsn3_alias##.STOCKS STOCKS WHERE STOCKS.STOCK_ID=SHIP_ROW.STOCK_ID) STOCK_CODE,
						PRODUCT_MANUFACT_CODE,
						NAME_PRODUCT,
						UNIT,
						PRICE,
						PRICE_OTHER,
						TAX,
						DISCOUNT,
						DISCOUNT2,
						DISCOUNT3,
						DISCOUNT4,
						DISCOUNT5,
						DISCOUNT6,
						DISCOUNT7,
						DISCOUNT8,
						DISCOUNT9,
						DISCOUNT10,
						LOT_NO,
						OTHER_MONEY,
						AMOUNT,
						DISCOUNTTOTAL,
						OTV_ORAN,
						PRODUCT_NAME2,
						AMOUNT2,
						UNIT2,
						UNIQUE_RELATION_ID
			FROM SHIP_ROW WHERE SHIP_ID IN (#evaluate('SHIP_SHIP_ID_2')#)";
			call_function_string='wrk_xml(query_string:"#query_text#",query_string_datasource:"##DSN2##",query_string_xml_tag_name:"SHIP_ROW")';
			wrkxml_data_2=ws.wrk_call_function(comp_id:GET_WRKXML.WORKXML_OUR_COMPANY,process_date:"#attributes.processdate#",call_function:"#call_function_string#");
			wrk_xml_read(xml_data:wrkxml_data_2);
		
			//ship_money cekilliyor
			query_text="SELECT MONEY_TYPE,RATE2,RATE1,IS_SELECTED FROM SHIP_MONEY WHERE ACTION_ID IN (#evaluate('SHIP_SHIP_ID_2')#)";
			call_function_string= 'wrk_xml(query_string:"#query_text#",query_string_datasource:"##DSN2##",query_string_xml_tag_name:"SHIP_MONEY")';
			wrkxml_data_3=ws.wrk_call_function(comp_id:GET_WRKXML.WORKXML_OUR_COMPANY,process_date:"#attributes.processdate#",call_function:"#call_function_string#");
			wrk_xml_read(xml_data:wrkxml_data_3);
			if(not isdefined('SHIP_MONEY_MONEY_TYPE_2'))
			{
				//ship_money de kayıt yoksa yani irsaliyeli fatura ise kurlar faturadan alınıyor cekilliyor
				query_text="SELECT MONEY_TYPE,RATE1,RATE2,IS_SELECTED FROM INVOICE_MONEY,INVOICE_SHIPS WHERE INVOICE_SHIPS.INVOICE_ID = INVOICE_MONEY.ACTION_ID AND INVOICE_SHIPS.SHIP_ID IN (#evaluate('SHIP_SHIP_ID_2')#)";
				call_function_string= 'wrk_xml(query_string:"#query_text#",query_string_datasource:"##DSN2##",query_string_xml_tag_name:"SHIP_MONEY")';
				wrkxml_data_4=ws.wrk_call_function(comp_id:GET_WRKXML.WORKXML_OUR_COMPANY,process_date:"#attributes.processdate#",call_function:"#call_function_string#");
				wrk_xml_read(xml_data:wrkxml_data_4);		
			}
		}
		else
		{
			abort('İrsaliye Bulunamadı!');
		}
	}else
	{
		abort('Workcube Dataservisde tanımladığınız şifre veya kullanıcı adı hatalı!');
	}
</cfscript>
<script type="text/javascript">
	// irsaliye ana bolumu ile ilgili veriler forma dolduruluyor
	var params = new Array("document.form_basket","ship_date,deliver_date_frm","<cfoutput>#dateformat(evaluate('SHIP_SHIP_DATE_2'),dateformat_style)#,#dateformat(evaluate('SHIP_DELIVER_DATE_2'),dateformat_style)#</cfoutput>");
	opener.wrk_call_function_js("wrk_form_set_js",params);
	// irsaliye satırlar icin xmlden okunan satırlar dondurulerek satırlar add_basket_row fonksiyonu cagrılarak satırlar ekleniyor
	<cfset row_ind=2><!---2 den baslıyor cunku xmlde ilk gelen bolge acıklama satırları--->
	<cfloop condition="isdefined('SHIP_ROW_BARCOD_#row_ind#')">
		//satırlar eklenirken urun stock code veya barcod ile kıyaslanıyor birimde isme göre bulamaz ise o satır eklenmiyor
		<cfif product_match_type>
			<!---
			<cfquery name="GET_PRODUCT" datasource="#dsn3#">
				SELECT STOCKS.PRODUCT_ID, STOCKS.STOCK_ID, STOCKS.STOCK_CODE, STOCKS.IS_INVENTORY, STOCKS.IS_PRODUCTION FROM #dsn1_alias#.SETUP_COMPANY_STOCK_CODE SETUP_COMPANY_STOCK_CODE, STOCKS  STOCKS WHERE SETUP_COMPANY_STOCK_CODE.COMPANY_STOCK_CODE = '#evaluate("SHIP_ROW_PRODUCT_MANUFACT_CODE_#row_ind#")#' AND SETUP_COMPANY_STOCK_CODE.STOCK_ID = STOCKS.STOCK_ID
			</cfquery>
			--->
			<cfquery name="GET_PRODUCT" datasource="#dsn3#">
				SELECT STOCKS.PRODUCT_ID, STOCKS.STOCK_ID, STOCKS.STOCK_CODE, STOCKS.IS_INVENTORY, STOCKS.IS_PRODUCTION FROM #dsn1_alias#.SETUP_COMPANY_STOCK_CODE SETUP_COMPANY_STOCK_CODE, STOCKS  STOCKS WHERE SETUP_COMPANY_STOCK_CODE.COMPANY_STOCK_CODE = '#evaluate("SHIP_ROW_STOCK_CODE_#row_ind#")#' AND SETUP_COMPANY_STOCK_CODE.STOCK_ID = STOCKS.STOCK_ID
			</cfquery>
		<cfelse>
			<cfquery name="GET_PRODUCT" datasource="#dsn3#">
				SELECT PRODUCT_ID,STOCK_ID,STOCK_CODE,IS_INVENTORY,IS_PRODUCTION FROM STOCKS WHERE BARCOD = '#evaluate("SHIP_ROW_BARCOD_#row_ind#")#'
			</cfquery>
		</cfif>
		<cfif GET_PRODUCT.RECORDCOUNT>
			<cfquery name="GET_UNIT" datasource="#dsn3#">
				SELECT PRODUCT_UNIT_ID,MAIN_UNIT FROM PRODUCT_UNIT WHERE MAIN_UNIT = '#evaluate("SHIP_ROW_UNIT_#row_ind#")#'
			</cfquery>
			<cfif GET_UNIT.RECORDCOUNT>
			<cfoutput>
			<!--- add_basket_row( ) fonksiyonu kullanılıyor satırların eklenmesi için --->
			var params = new Array("#GET_PRODUCT.PRODUCT_ID#","#GET_PRODUCT.STOCK_ID#","#GET_PRODUCT.STOCK_CODE#","#evaluate('SHIP_ROW_BARCOD_#row_ind#')#","#evaluate('SHIP_ROW_PRODUCT_MANUFACT_CODE_#row_ind#')#","#evaluate('SHIP_ROW_NAME_PRODUCT_#row_ind#')#","#GET_UNIT.PRODUCT_UNIT_ID#","#evaluate('SHIP_ROW_UNIT_#row_ind#')#","","","#evaluate('SHIP_ROW_PRICE_#row_ind#')#","#evaluate('SHIP_ROW_PRICE_OTHER_#row_ind#')#","#evaluate('SHIP_ROW_TAX_#row_ind#')#","","#evaluate('SHIP_ROW_DISCOUNT_#row_ind#')#","#evaluate('SHIP_ROW_DISCOUNT2_#row_ind#')#","#evaluate('SHIP_ROW_DISCOUNT3_#row_ind#')#","#evaluate('SHIP_ROW_DISCOUNT4_#row_ind#')#","#evaluate('SHIP_ROW_DISCOUNT5_#row_ind#')#","#evaluate('SHIP_ROW_DISCOUNT6_#row_ind#')#","#evaluate('SHIP_ROW_DISCOUNT7_#row_ind#')#","#evaluate('SHIP_ROW_DISCOUNT8_#row_ind#')#","#evaluate('SHIP_ROW_DISCOUNT9_#row_ind#')#","#evaluate('SHIP_ROW_DISCOUNT10_#row_ind#')#","","","","#evaluate('SHIP_ROW_LOT_NO_#row_ind#')#","#evaluate('SHIP_ROW_OTHER_MONEY_#row_ind#')#",0,"#evaluate('SHIP_ROW_AMOUNT_#row_ind#')#","","#GET_PRODUCT.IS_INVENTORY#","#GET_PRODUCT.IS_PRODUCTION#",0,0,0,0,0,0,"#evaluate('SHIP_ROW_DISCOUNTTOTAL_#row_ind#')#",0,0,"#evaluate('SHIP_ROW_OTV_ORAN_#row_ind#')#","#evaluate('SHIP_ROW_PRODUCT_NAME2_#row_ind#')#","#evaluate('SHIP_ROW_AMOUNT2_#row_ind#')#","#evaluate('SHIP_ROW_UNIT2_#row_ind#')#",0,"","#evaluate('SHIP_ROW_UNIQUE_RELATION_ID_#row_ind#')#","",1,0,"","","");
			opener.wrk_call_function_js("add_basket_row",params);
<!---add_basket_row parametreler 
var params = new Array("#GET_PRODUCT.PRODUCT_ID#","#GET_PRODUCT.STOCK_ID#","#GET_PRODUCT.STOCK_CODE#","#evaluate('SHIP_ROW_BARCOD_#row_ind#')#","#evaluate('SHIP_ROW_PRODUCT_MANUFACT_CODE_#row_ind#')#","#evaluate('SHIP_ROW_NAME_PRODUCT_#row_ind#')#","#GET_UNIT.PRODUCT_UNIT_ID#","#evaluate('SHIP_ROW_UNIT_#row_ind#')#",<!---#evaluate('SHIP_ROW_SPECT_VAR_ID_#row_ind#')#--->"",""<!---#evaluate('SHIP_ROW_SPECT_VAR_NAME_#row_ind#')#--->,"#evaluate('SHIP_ROW_PRICE_#row_ind#')#","#evaluate('SHIP_ROW_PRICE_OTHER_#row_ind#')#","#evaluate('SHIP_ROW_TAX_#row_ind#')#",<!---#evaluate('SHIP_ROW_DUEDATE_#row_ind#')#--->"","#evaluate('SHIP_ROW_DISCOUNT_#row_ind#')#","#evaluate('SHIP_ROW_DISCOUNT2_#row_ind#')#","#evaluate('SHIP_ROW_DISCOUNT3_#row_ind#')#","#evaluate('SHIP_ROW_DISCOUNT4_#row_ind#')#","#evaluate('SHIP_ROW_DISCOUNT5_#row_ind#')#","#evaluate('SHIP_ROW_DISCOUNT6_#row_ind#')#","#evaluate('SHIP_ROW_DISCOUNT7_#row_ind#')#","#evaluate('SHIP_ROW_DISCOUNT8_#row_ind#')#","#evaluate('SHIP_ROW_DISCOUNT9_#row_ind#')#","#evaluate('SHIP_ROW_DISCOUNT10_#row_ind#')#",<!---#dateformat(evaluate('SHIP_ROW_DELIVER_DATE_#row_ind#'),dateformat_style)#--->"",""<!---#evaluate('SHIP_ROW_DELIVER_DEPT_#row_ind#')#--->,<!--- #evaluate('SHIP_ROW_DEPARTMENT_HEAD_#row_ind#')#--->"","#evaluate('SHIP_ROW_LOT_NO_#row_ind#')#","#evaluate('SHIP_ROW_OTHER_MONEY_#row_ind#')#",<!---#evaluate('SHIP_ROW_ROW_SHIP_ID_#row_ind#')#--->"","#evaluate('SHIP_ROW_AMOUNT_#row_ind#')#",<!---#evaluate('SHIP_ROW_PRODUCT_ACCOUNT_CODE_#row_ind#')#--->"","#GET_PRODUCT.IS_INVENTORY#","#GET_PRODUCT.IS_PRODUCTION#",<!---#evaluate('SHIP_ROW_COST_PRICE_#row_ind#')#--->0,<!---#evaluate('SHIP_ROW_MARGIN_#row_ind#')#--->0,<!---#evaluate('SHIP_ROW_EXTRA_COST_#row_ind#')#--->0,<!---#evaluate('SHIP_ROW_PROMOTION_ID_#row_ind#')#--->0,<!---#evaluate('SHIP_ROW_PROMOSYON_YUZDE_#row_ind#')#--->0,<!---#evaluate('SHIP_ROW_PROM_COST_#row_ind#')#--->0,"#evaluate('SHIP_ROW_DISCOUNTTOTAL_#row_ind#')#",<!---#evaluate('SHIP_ROW_IS_PROMOTION_#row_ind#')#--->0,<!---#evaluate('SHIP_ROW_PROM_STOCK_ID_#row_ind#')#--->0,"#evaluate('SHIP_ROW_OTV_ORAN_#row_ind#')#","#evaluate('SHIP_ROW_PRODUCT_NAME2_#row_ind#')#","#evaluate('SHIP_ROW_AMOUNT2_#row_ind#')#","#evaluate('SHIP_ROW_UNIT2_#row_ind#')#",<!---#evaluate('SHIP_ROW_EXTRA_PRICE_#row_ind#')#--->0,<!---#evaluate('SHIP_ROW_SHELF_NUMBER_#row_ind#')#--->"","#evaluate('SHIP_ROW_UNIQUE_RELATION_ID_#row_ind#')#",1,<!---#evaluate('SHIP_ROW_IS_COMMISSION_#row_ind#')#--->0);
--->
			</cfoutput>
			<cfelse>	
				alert("<cfoutput>#row_ind-1#. satırdaki #evaluate('SHIP_ROW_BARCOD_#row_ind#')#</cfoutput> barkodlu ürünün birimi sistemde eşlenemedi");
			</cfif>
		<cfelse>
			alert("<cfoutput>#row_ind-1#. satırdaki #evaluate('SHIP_ROW_BARCOD_#row_ind#')#</cfoutput> barkodlu ürün sistemde eşlenemedi");
		</cfif>
	<cfset row_ind=row_ind+1>
	</cfloop>

	<cfset row_ind=2><!---2 den baslıyor cunku xmlde ilk gelen bolge acıklama satırları--->
	<cfloop condition="isdefined('SHIP_MONEY_MONEY_TYPE_#row_ind#')">
		for(var kr_ix=1;kr_ix <= opener.document.form_basket.kur_say.value;kr_ix++)
		{
			if(eval('opener.document.form_basket.hidden_rd_money_'+kr_ix).value==<cfoutput>'#evaluate('SHIP_MONEY_MONEY_TYPE_#row_ind#')#'</cfoutput>)
			{
				eval('opener.document.form_basket.txt_rate1_'+kr_ix).value = opener.commaSplit(<cfoutput>#evaluate('SHIP_MONEY_RATE1_#row_ind#')#,'#session.ep.our_company_info.rate_round_num#'</cfoutput>);
				eval('opener.document.form_basket.txt_rate2_'+kr_ix).value = opener.commaSplit(<cfoutput>#evaluate('SHIP_MONEY_RATE2_#row_ind#')#,'#session.ep.our_company_info.rate_round_num#'</cfoutput>);
				if(<cfoutput>#evaluate('SHIP_MONEY_IS_SELECTED_#row_ind#')#</cfoutput> == 1)
					eval('opener.document.form_basket.rd_money['+(kr_ix-1)+']').checked = true;
				break;
			}
		}
		<cfset row_ind=row_ind+1>
	</cfloop>
</script>

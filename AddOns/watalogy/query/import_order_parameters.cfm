<cfset attributes.order_date = dateformat(now(),'dd/mm/yyyy')>
<cfset ATTRIBUTES.deliverdate = attributes.order_date>
<cfset period_year_ = w_tarih>

<cfquery name="GET_PERIOD" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #company_id_# AND PERIOD_YEAR = #period_year_#
</cfquery>
<cfset period_id_ = GET_PERIOD.period_id>


<cfset dsn2 = "#dsn#_#period_year_#_#company_id_#">
<cfset dsn3 = "#dsn#_#company_id_#">
<cfset ATTRIBUTES.FUSEACTION = "sales.form_add_sale">
<cfset dsn_alias = "#dsn#">
<cfset dsn2_alias = "#dsn#_#period_year_#_#company_id_#">
<cfset dsn1_alias = "#dsn#_product">
<cfset dsn3_alias = "#dsn#_#company_id_#">

<cfset urun_hata = 0>
<cfset DEFAULT_STOCK_ID = 555>

<cfset session.ep.userid = user_id_>
<cfset session.EP.OUR_COMPANY_INFO.WORKCUBE_SECTOR = 'it'>
<cfset session.ep.money2 = 'TL'>
<cfset session.ep.our_company_info.project_followup = 0>
<cfset session.ep.our_company_info.spect_type = 0>
<cfset session.ep.period_id = period_id_>
<cfset session.ep.USER_LOCATION = "1-1">
<cfset request.self = "index.cfm">
<cfset session.ep.POSITION_CODE  ="0">
<cfset session.ep.company_id = company_id_>
<cfset session.ep.language = 'tr'>
<cfset session.EP.PERIOD_IS_INTEGRATED = 1>
<cfset xml_import = 1>
<cfset session.ep.money = 'TL'>
<cfset session.EP.OUR_COMPANY_INFO.IS_COST = 0>
<cfset is_from_import = 1>
<cfset attributes.is_web_service = 1>
		

<cfset attributes.company_id = get_member.company_id>
<cfset attributes.partner_id = get_member.MANAGER_PARTNER_ID>
<cfset attributes.comp_name = get_member.fullname>
<cfset attributes.consumer_id = "">

<cfset attributes.PARTNER_NAME = "P">
<cfset attributes.PARTNER_NAMEO = "P">

<cfset attributes.ADRES = "-">

<cfset attributes.ADRES = "#SevkAdr1# #SevkAdr2# #SevkPosta# #SevkSehir#">

<cfset vatlist = listdeleteduplicates(valuelist(get_rows.KDV_ORN))>

<cfset k = 0>
<cfloop query="get_rows">	
	<cfset k = k + 1>
	<cfif get_rows.MIKTAR[k] eq 0><cfset row_miktar = 999><cfelse><cfset row_miktar = get_rows.MIKTAR[k]></cfif>
	<cfset "attributes.ACTION_ROW_ID#k#" =  0>	
	<cfset "attributes.AMOUNT#k#" = row_miktar>
	<cfset "attributes.AMOUNT_OTHER#k#" = row_miktar>
	<cfset "attributes.BASKET_EMPLOYEE#k#" = "">
	<cfset "attributes.BASKET_EMPLOYEE_ID#k#" = "">
	<cfset "attributes.BASKET_EXTRA_INFO#k#" = -1>
	<cfset "attributes.BASKET_ROW_DEPARTMAN#k#" = "">
	<cfset "attributes.DARA#k#" = 0>
	<cfset "attributes.DARALI#k#" = 1>
	<cfset "attributes.DELIVER_DATE#k#" = "">
	<cfset "attributes.DELIVER_DEPT#k#" = "">
	<cfset "attributes.DUEDATE#k#" = 0>
	<cfset "attributes.EK_TUTAR#k#" = 0>
	<cfset "attributes.EK_TUTAR_COST#k#" = "">
	<cfset "attributes.EK_TUTAR_MARJ#k#" = "">
	<cfset "attributes.EK_TUTAR_OTHER_TOTAL#k#" = 0>
	<cfset "attributes.EK_TUTAR_PRICE#k#" = "">
	<cfset "attributes.EK_TUTAR_TOTAL#k#" = 0>
</cfloop>


<cfset attributes.order_number = 'ET-' & w_evrak_no>

<cfset attributes.BASKET_TAX_COUNT = listlen(vatlist,',')>
<cfset attributes.ASSETP_SERVICE_OPERATION_ID = "">
<cfset attributes.ASSET_ID = "">
<cfset attributes.ASSET_NAME = "">
<cfset attributes.BASKET_DUE_VALUE = 0>



<cfset attributes.BASKET_DUE_VALUE_DATE_ = attributes.order_date>
	
	
<cfset k = 0>
<cfloop query="get_rows">
	<cfset k = k + 1>
	<cfquery name="GETPRODUCT" datasource="#dsn3#">
		SELECT PRODUCT_ID,STOCK_ID,BARCOD,PRODUCT_NAME,STOCK_CODE FROM STOCKS WHERE STOCK_CODE_2 = '#get_rows.STOK_KOD[k]#'
	</cfquery>
	<cfif getproduct.recordcount eq 0>
		<cfoutput>#w_evrak_no# nolu evrak için #get_rows.STOK_KOD[k]# Kodlu Ürün Bulunamadı!</cfoutput><br />
		
		<cfquery name="GETPRODUCT" datasource="#dsn3#">
			SELECT PRODUCT_ID,STOCK_ID,BARCOD,PRODUCT_NAME,STOCK_CODE FROM STOCKS WHERE STOCK_ID = #DEFAULT_STOCK_ID#
		</cfquery>
		<cfset urun_hata = 0>
	</cfif>
	
	<cfset "attributes.BARCOD#k#" = GETPRODUCT.BARCOD>
	<cfquery name="GETUNIT" datasource="#dsn1#">
		SELECT PRODUCT_UNIT_ID, MAIN_UNIT FROM PRODUCT_UNIT WHERE PRODUCT_ID = #getproduct.product_id# AND PRODUCT_UNIT_STATUS = 1 AND MULTIPLIER = 1 AND IS_MAIN = 1
	</cfquery>
	<cfset "attributes.UNIT#k#" = GETUNIT.MAIN_UNIT>
	<cfset "attributes.UNIT_ID#k#" = GETUNIT.PRODUCT_UNIT_ID>
	<cfset "attributes.PRODUCT_ID#k#" = GETPRODUCT.PRODUCT_ID>
	<cfset "attributes.PRODUCT_NAME#k#" = GETPRODUCT.PRODUCT_NAME>
	<cfset "attributes.STOCK_CODE#k#" = GETPRODUCT.STOCK_CODE>
	<cfset "attributes.STOCK_ID#k#" = GETPRODUCT.STOCK_ID>
	
</cfloop>

<cfset attributes.BASKET_GROSS_TOTAL = 0>			
<cfset attributes.BASKET_NET_TOTAL = 0>	
<cfset attributes.BASKET_TAX_TOTAL = 0>

<cfset k = 0>
<cfloop query="get_rows">
	<cfset k = k + 1>
	<cfif get_rows.MIKTAR[k] eq 0><cfset row_miktar = 999><cfelse><cfset row_miktar = get_rows.MIKTAR[k]></cfif>
	<cfset satir_toplam_net = row_miktar * get_rows.BIRIM_FIYAT[k]>
	<cfset satir_kdv = get_rows.KDV_ORN[k]>
	
	<cfset satir_toplam_net = row_miktar * get_rows.BIRIM_FIYAT[k]>
	<cfset satir_toplam = satir_toplam_net * ((100 + satir_kdv) / 100)>
	<cfset satir_toplam_kdv = satir_toplam - satir_toplam_net>
	
	<cfset attributes.BASKET_GROSS_TOTAL = attributes.BASKET_GROSS_TOTAL + satir_toplam_net>
	<cfset attributes.BASKET_NET_TOTAL = attributes.BASKET_NET_TOTAL + satir_toplam>
	<cfset attributes.BASKET_TAX_TOTAL = attributes.BASKET_TAX_TOTAL + satir_toplam_kdv>
		
	<cfset "attributes.OTHER_MONEY_GROSS_TOTAL#k#" = satir_toplam>
	<cfset "attributes.OTHER_MONEY_VALUE_#k#" = satir_toplam_net>
	<cfset "attributes.PRICE#k#" = get_rows.BIRIM_FIYAT[k]><!---  / ((100 + satir_kdv) / 100) --->
	<cfset "attributes.PRICE_NET#k#" = get_rows.BIRIM_FIYAT[k]>
	<cfset "attributes.PRICE_NET_DOVIZ#k#" = get_rows.BIRIM_FIYAT[k]>
	<cfset "attributes.PRICE_OTHER#k#" = get_rows.BIRIM_FIYAT[k]>
	<cfset "attributes.ROW_LASTTOTAL#k#" = satir_toplam>
	
	<cfset "attributes.ROW_NETTOTAL#k#" = satir_toplam_net>
	<cfset "attributes.ROW_TAXTOTAL#k#" = satir_toplam_kdv>
	<cfset "attributes.ROW_TOTAL#k#" = satir_toplam>
	<cfset "attributes.TAX#k#" = satir_kdv>
	<cfset "attributes.TAX_PRICE#k#" = satir_kdv>
</cfloop>
		
<cfset attributes.OLD_NET_TOTAL = attributes.BASKET_NET_TOTAL>
<cfset attributes.BASKET_DISCOUNT_TOTAL = 0>

<cfset attributes.BASKET_ID = 2>
<cfset attributes.BASKET_MEMBER_PRICECAT = "">
<cfset attributes.BASKET_MONEY = 'TL'>
<cfset attributes.BASKET_OTV_1 = 0>
<cfset attributes.BASKET_OTV_COUNT = 1>
<cfset attributes.BASKET_OTV_FROM_TAX_PRICE = 0>
<cfset attributes.BASKET_OTV_TOTAL = 0>
<cfset attributes.BASKET_OTV_VALUE_1 = 0>
<cfset attributes.BASKET_PRICE_ROUND_NUMBER = 4>
<cfset attributes.BASKET_RATE1 = 1>
<cfset attributes.BASKET_RATE2 = 1>
<cfset attributes.BASKET_RATE_ROUND_NUMBER_ = 4>
<cfset attributes.BASKET_SPECT_TYPE = 0>
<cfset attributes.BASKET_TOTAL_ROUND_NUMBER_ = 2>
<cfloop from="1" to="#listlen(vatlist,',')#" index="k">
	<cfset "attributes.BASKET_TAX_VALUE_#k#" = attributes.BASKET_TAX_TOTAL>
	<cfset "attributes.BASKET_TAX_VALUE_INDIRIM_#k#" = 0>
</cfloop>
<cfquery name="GET_LOC" datasource="#dsn#">
	SELECT 
		SL.LOCATION_ID,
		SL.DEPARTMENT_ID,
		D.BRANCH_ID
	FROM 
		STOCKS_LOCATION SL,
		DEPARTMENT D
	WHERE 
		SL.ID = 1 AND
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID
</cfquery>
<cfset attributes.BRANCH_ID = get_loc.BRANCH_ID>
<cfset attributes.DEPARTMENT_ID = get_loc.DEPARTMENT_ID>
<cfset attributes.LOCATION_ID = get_loc.LOCATION_ID>

<cfset attributes.CARD_PAYMETHOD_ID = "">


<cfset attributes.CITY_ID = "">
<cfset attributes.COMMETHOD_ID = "13">
<cfset attributes.COMMISSION_RATE = "">
<cfset attributes.COMP_NAME = "">
<cfset attributes.CONSUMER_REFERENCE_CODE = "">
<cfset attributes.CONTRACT_ROW_IDS = "">
<cfset attributes.CONTROL_FIELD_VALUE = 1>
<cfset "attributes.CT_PROCESS_TYPE_36" = 52>
<cfset attributes.DELIVER_GET = "">
<cfset attributes.DEPARTMENT_NAME = "Department">
<cfset DELIVER_GET = "">
<cfset attributes.DELIVER_GET_ID = "">
<cfset attributes.DELIVER_GET_ID_CONSUMER = "">
<cfset attributes.EMPLOYEE_ID = "">
<cfset attributes.EMPO_ID = "">
<cfset attributes.EXTRA_COST_RATE = "">
<cfset attributes.FREE_PROM_LIMIT = "">
<cfset attributes.IS_NEW = 0>
<cfset attributes.GENEL_INDIRIM = 0>
<cfset attributes.GENEL_INDIRIM_ = 0>
<cfset attributes.GENEL_INDIRIM_KDVLI_HESAP_ = 0>
<cfset attributes.GENERAL_PROM_AMOUNT = "">
<cfset attributes.GENERAL_PROM_DISCOUNT = "">
<cfset attributes.GENERAL_PROM_LIMIT = "">
<cfset attributes.COUNTY_ID = "">

<cfset k = 0>
<cfloop query="get_rows">
	<cfset k = k + 1>
		<cfset "attributes.WRK_ROW_ID#k#" = "WRK#k##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##user_id_##round(rand()*100)##k#">
		<cfset "attributes.EXTRA_COST#k#" = 0>
		<cfset "attributes.EXTRA_COST#k#" = 0>
		<cfset "attributes.ISKONTO_TUTAR#k#" = 0>
		<cfset "attributes.IS_COMMISSION#k#" = 0>
		<cfset "attributes.IS_INVENTORY#k#" = 0>
		<cfset "attributes.KARMA_PRODUCT_ID#k#" = "">
		<cfset "attributes.IS_PRODUCTION#k#" = 0>
		<cfset "attributes.IS_PROMOTION#k#" = 0>
		<cfset "attributes.LIST_PRICE#k#" = 0>
		<cfset "attributes.LIST_PRICE_DISCOUNT#k#" = "">
		<cfset "attributes.LOT_NO#k#" = "">
		<cfset "attributes.MANUFACT_CODE#k#" = "">
		<cfset "attributes.MARJ#k#" = "">
		<cfset "attributes.NET_MALIYET#k#" = "">
		<cfset "attributes.NUMBER_OF_INSTALLMENT#k#" = 0>
		<cfset "attributes.ORDER_CURRENCY#k#" = -1>
		<cfset "attributes.OTHER_MONEY_#k#" = 'TL'>
		<cfset "attributes.OTV_ORAN#k#" = 0>
		<cfset "attributes.PBS_CODE#k#" = "">
		<cfset "attributes.PBS_ID#k#" = "">
		<cfset "attributes.PRICE_CAT#k#" = "">
		<cfset "attributes.PRODUCT_NAME_OTHER#k#" = "">
		<cfset "attributes.PROMOSYON_MALIYET#k#" = "">
		<cfset "attributes.PROMOSYON_YUZDE#k#" = "">
		<cfset "attributes.PROM_RELATION_ID#k#" = "">
		<cfset "attributes.PROM_STOCK_ID#k#" = "">
		<cfset "attributes.RELATED_ACTION_ID#k#" = "">
		<cfset "attributes.RELATED_ACTION_TABLE#k#" = "">
		<cfset "attributes.RESERVE_DATE#k#" = "">
		<cfset "attributes.RESERVE_TYPE#k#" = -1>
		<cfset "attributes.ROW_CATALOG_ID#k#" = "">
		<cfset "attributes.ROW_DEPTH#k#" = "">
		<cfset "attributes.ROW_HEIGHT#k#" = "">
		<cfset "attributes.ROW_OTVTOTAL#k#" = 0>
		<cfset "attributes.ROW_PAYMETHOD_ID#k#" = "">
		<cfset "attributes.ROW_PROJECT_ID#k#" = "">
		<cfset "attributes.ROW_PROJECT_NAME#k#" = "">
		<cfset "attributes.ROW_PROMOTION_ID#k#" = "">
		<cfset "attributes.ROW_SERVICE_ID#k#" = "">
		<cfset "attributes.ROW_SHIP_ID#k#" = 0>
		<cfset "attributes.ROW_UNIQUE_RELATION_ID#k#" = "">
		<cfset "attributes.ROW_WIDTH#k#" = "">
		<cfset "attributes.SET_ROW_DISC_OUNT#k#" = "0,00">
		<cfset "attributes.SHELF_NUMBER#k#" = "">
		<cfset "attributes.SHELF_NUMBER_TXT#k#" = "">
		<cfset "attributes.SPECIAL_CODE#k#" = "">
		<cfset "attributes.SPECT_ID#k#" = "">
		<cfset "attributes.SPECT_NAME#k#" = "">
		<cfset "attributes.TO_SHELF_NUMBER#k#" = "">
		<cfset "attributes.TO_SHELF_NUMBER_TXT#k#" = "">
		<cfset "attributes.WRK_ROW_RELATION_ID#k#" = "">
		<cfset "attributes.UNIT_OTHER#k#" = "">
</cfloop>


<cfquery name="GETMONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE COMPANY_ID = #company_id_# AND PERIOD_ID = #period_id_# AND MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>
<cfoutput query="getmoney">
	<cfset "attributes.TXT_RATE1_#currentrow#" = GETMONEY.rate1>
	<cfset "attributes.TXT_RATE2_#currentrow#" = GETMONEY.rate2>
	<cfset "attributes.HIDDEN_RD_MONEY_#currentrow#" = GETMONEY.money>
	<cfif GETMONEY.rate1 eq GETMONEY.rate2>
		<cfset attributes.RD_MONEY = currentrow>
	</cfif>
</cfoutput>
<cfset attributes.KUR_SAY = getmoney.recordcount>
<cfloop from="1" to="10" index="s">
	<cfloop from="1" to="#get_rows.recordcount#" index="k">
		<cfset "attributes.INDIRIM#s##k#" = 0>
	</cfloop>
</cfloop>
<cfset attributes.INDIRIM_TOTAL = "">
<cfset k = 0>
<cfloop query="get_rows">
	<cfset k = k + 1>
		<cfif k eq 1>
			<cfset attributes.INDIRIM_TOTAL = attributes.INDIRIM_TOTAL & "100000000000000000000">
		<cfelse>
			<cfset attributes.INDIRIM_TOTAL = attributes.INDIRIM_TOTAL & ",100000000000000000000">
		</cfif>
</cfloop>
<cfset attributes.INVOICE_CONTROL_ID = "">
<cfset attributes.INVOICE_COUNTER_NUMBER = "">
<cfset attributes.IRSALIYE = "">
<cfset attributes.IRSALIYE_DATE_LISTESI = "">
<cfset attributes.IRSALIYE_ID_LISTESI = "">
<cfset attributes.IRSALIYE_PROJECT_ID_LISTESI = "">
<cfset attributes.IS_BASKET_HIDDEN = 0>
<cfset attributes.IS_GENERAL_PROM = 0>
<cfset attributes.LIST_PAYMENT_ROW_ID = "">
<cfset attributes.NOTE = "#uye_kod#">
<cfset attributes.OLD_GENERAL_PROM_AMOUNT = "">
<cfset attributes.PAPER_PRINTER_ID = "">
<cfset attributes.PAPER = 21>
<cfset attributes.PARTNER_REFERENCE_CODE = "">
<cfset attributes.PARTO_ID = "">
<cfset attributes.PAYMETHOD = "">
<cfset attributes.PAYMETHOD_ID = "">
<cfset attributes.PAYMETHOD_VEHICLE = "">
<cfset attributes.PROJECT_HEAD = "">
<cfset attributes.PROJECT_ID = "">
<cfset attributes.REF_NO = w_evrak_no>
<cfset attributes.ROWS_ = get_rows.recordcount>
<cfset attributes.ROW_COST_TOTAL = "">
<cfset attributes.SALES_MEMBER = "">
<cfset attributes.SALES_MEMBER_ID = "">
<cfset attributes.SALES_MEMBER_TYPE = "">
<cfset attributes.SALE_PRODUCT = 1>
<cfset attributes.SEARCH_PROCESS_DATE = "order_date">
<cfset attributes.SERVICE_OPERATION_IDS = "">
<cfset attributes.SHIP_DATE = attributes.order_date>
<cfset attributes.SHIP_METHOD = "">
<cfset attributes.SHIP_METHOD_NAME = "">
<cfset attributes.STOPAJ = 0>
<cfset attributes.STOPAJ_RATE_ID = 0>
<cfset attributes.STOPAJ_YUZDE = 0>
<cfset attributes.TEVKIFAT_ORAN = "">
<cfset attributes.USE_BASKET_PROJECT_DISCOUNT_ = 0>
<cfset attributes.XML_CALC_DUE_DATE = 0>
<cfset attributes.XML_KONTROL_DUE_DATE = 0>
<cfset attributes.PROCESS_CAT = 36>
<cfset attributes.TODAY_DATE_ = now()>
<cfset attributes.MEMBER_ACCOUNT_CODE = "">

<cfset attributes.REF_MEMBER_TYPE = "">
<cfset attributes.PROCESS_STAGE = 164><!---sevk edildi: 80--->
<cfset attributes.ORDER_EMPLOYEE_ID = "1">
<cfset attributes.ORDER_EMPLOYEE = "admin admin">
<cfset attributes.ORDER_head = attributes.order_number>

<cfset attributes.reserved = 1>

<cfloop collection="#attributes#" item="p">
	<cfset "form.#p#" = evaluate("attributes.#p#")>
</cfloop>


<cfif not isdefined("new_dsn2_group")><cfset new_dsn2_group = dsn2></cfif>
<cfif not isdefined("new_dsn3_group")><cfset new_dsn3_group = dsn3></cfif>

<cfquery name="get_curr_order" datasource="#dsn#">
	SELECT * FROM workcube_atombilisim_1.ORDERS WHERE IMPORT_CODE = #w_evrak_id#
</cfquery>

<cfif urun_hata eq 0 and not get_curr_order.recordcount>
	<cfinclude template="../../../../sales/query/add_order.cfm">

	<cfquery name="upd_" datasource="#dsn#">
		UPDATE
			workcube_atombilisim_1.ORDERS
		SET
			IMPORT_CODE = #w_evrak_id#
		WHERE
			ORDER_ID = #last_order_id#
	</cfquery>
	<cfquery name="del_info" datasource="#dsn#">
		DELETE FROM workcube_atombilisim_1.ORDER_INFO_PLUS WHERE ORDER_ID = #last_order_id#
	</cfquery>
	<cfquery name="add_extra_info" datasource="#dsn#">
		INSERT INTO
			workcube_atombilisim_1.ORDER_INFO_PLUS
			(
				ORDER_ID,
				PROPERTY1,
				PROPERTY2,
				PROPERTY3,
				PROPERTY4,
				PROPERTY5,
				RECORD_IP,
				RECORD_EMP,
				RECORD_DATE
			)
			VALUES
			(
				#last_order_id#,
				'#cargo_no#',
				'#cargo_company#',
				'GITTIGIDIYOR',
				'',
				'',
				'#cgi.remote_addr#',
				#session.ep.userid#,
				#now()#
			)
	</cfquery>
	<cfquery name="UPD_info" datasource="#dsn#">
		UPDATE
			workcube_atombilisim_1.ORDER_INFO_PLUS
		SET
			PROPERTY3 = 'N11'
		WHERE
			PROPERTY3 LIKE 'N11%' AND
			ORDER_ID = #last_order_id#
	</cfquery>
</cfif>

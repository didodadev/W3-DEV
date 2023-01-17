<cfquery name="GET_PUAN_ROWS" datasource="#DSN3#">
	SELECT
		SEGMENT_ID,
        PROM_POINT
	FROM
		ORDER_PRE_ROWS_SPECIAL
	WHERE
		RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND 
		RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"><!--- AND
		COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#">--->
</cfquery>
<cfoutput query="get_puan_rows">
	<cfif len(segment_id)>
		<cfset this_segment_ = segment_id> 
	</cfif>
</cfoutput>
<cfif isdefined("this_segment_")>
	<cfquery name="GET_PUAN" dbtype="query">
		SELECT SUM(PROM_POINT) AS TOTAL_PUAN FROM GET_PUAN_ROWS
	</cfquery>
	<cfset total_puan_ = get_puan.total_puan>
	
	<cfquery name="GET_HEDEF_ARALIK" datasource="#DSN1#"><!--- #dsn3# fs 20090506 --->
		SELECT 
        	MIN_POINT_1, 
            MIN_POINT_2, 
            MIN_POINT_3, 
            MAX_POINT_1, 
            MAX_POINT_2, 
            MAX_POINT_3 
        FROM 
        	PRODUCT_SEGMENT 
        WHERE 
        	PRODUCT_SEGMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this_segment_#">
	</cfquery>
    
	<cfoutput query="get_hedef_aralik">
		<cfif min_point_1 lte total_puan_ and total_puan_ lte max_point_1>
			<cfset case_point_ = 1>
		<cfelseif min_point_2 lte total_puan_ and total_puan_ lte max_point_2>
			<cfset case_point_ = 2>
		<cfelseif min_point_3 lte total_puan_ and total_puan_ lte max_point_3>
			<cfset case_point_ = 3>
		<cfelse>
			<cfset case_point_ = 1>
		</cfif>
	</cfoutput>
<cfelse>
	<cfset case_point_ = 1>
</cfif>
<cfset attributes.promotion_stock_list = "">
<cfset attributes.promotion_adet_list = "">

<cfif case_point_ eq 1>
	<cfoutput query="get_puan_rows">
		<cfset attributes.promotion_stock_list = listappend(attributes.promotion_stock_list,stock_id)>
		<cfset attributes.promotion_adet_list = listappend(attributes.promotion_adet_list,quantity)>
	</cfoutput>
<cfelse>
	<cfoutput query="get_puan_rows">
		<cfquery name="GET_P" datasource="#DSN3#" maxrows="1">
			SELECT 
				S.STOCK_ID 
			FROM 
				STOCKS S,
				ALTERNATIVE_PRODUCTS AP
			WHERE
				AP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
				AP.ALTERNATIVE_PRODUCT_NO = <cfqueryparam cfsqltype="cf_sql_integer" value="#case_point_#"> AND
				S.PRODUCT_ID = AP.ALTERNATIVE_PRODUCT_ID
		</cfquery>
		<cfif get_p.recordcount eq 1>
			<cfset attributes.promotion_stock_list = listappend(attributes.promotion_stock_list,get_p.stock_id)>
			<cfset attributes.promotion_adet_list = listappend(attributes.promotion_adet_list,quantity)>
		<cfelse>
			<cfset attributes.promotion_stock_list = listappend(attributes.promotion_stock_list,stock_id)>
			<cfset attributes.promotion_adet_list = listappend(attributes.promotion_adet_list,quantity)>
		</cfif>
	</cfoutput>
</cfif>

<cfquery name="DEL_ROWS" datasource="#DSN3#">
	DELETE 
	FROM 
		ORDER_PRE_ROWS
	WHERE
		RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
		RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
<!---		COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#"> AND--->
		PRODUCT_ID IS NOT NULL AND
		(IS_COMMISSION IS NULL OR IS_COMMISSION = 0)
</cfquery>

<cfif get_puan_rows.recordcount>
	<cfinclude template="../query/get_price_cats_moneys.cfm">
	<cfquery name="GET_HOMEPAGE_PRODUCTS" datasource="#DSN3#">
		SELECT
			PR.PRICE_CATID,
			STOCKS.STOCK_ID,
			PRODUCT.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			STOCKS.PROPERTY,
			PRODUCT.PRODUCT_NAME,
			STOCKS.PROPERTY,
			STOCKS.BARCOD,
			PRODUCT.TAX,
			PRODUCT.IS_ZERO_STOCK,
			PRODUCT.BRAND_ID,
			PRODUCT.PRODUCT_CODE,
			PRODUCT.PRODUCT_DETAIL,
			PRODUCT.PRODUCT_CATID,
			PRODUCT.RECORD_DATE,
			PRODUCT.IS_PRODUCTION,
			STOCKS.PRODUCT_UNIT_ID,
			PR.PRICE,
			PR.MONEY AS PRICE_MONEY,
			PR.IS_KDV,
			PR.PRICE_KDV,			
			PRICE_STANDART.PRICE PRICE_STANDART,
			PRICE_STANDART.MONEY MONEY_STANDART,
			PRICE_STANDART.IS_KDV IS_KDV_STANDART,
			PRICE_STANDART.PRICE_KDV PRICE_KDV_STANDART,
			PRODUCT.PRODUCT_DETAIL2
		FROM
			PRICE PR,
			PRODUCT,
			PRODUCT_CAT,
			#dsn1_alias#.PRODUCT_CAT_OUR_COMPANY AS PRODUCT_CAT_OUR_COMPANY,
			STOCKS,
			PRICE_STANDART,
			PRODUCT_UNIT			
		WHERE
			PR.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
			ISNULL(PR.STOCK_ID,0)=0 AND
			ISNULL(PR.SPECT_VAR_ID,0)=0 AND
			PR.PRICE_CATID = <cfqueryparam value="#attributes.price_catid#" cfsqltype="cf_sql_integer"> AND
			PR.STARTDATE <= #now()# AND 
			(PR.FINISHDATE >= #now()# OR PR.FINISHDATE IS NULL) AND
			PRODUCT_CAT.PRODUCT_CATID = PRODUCT_CAT_OUR_COMPANY.PRODUCT_CATID AND
			PRODUCT_CAT_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam value="#session_base.our_company_id#" cfsqltype="cf_sql_integer"> AND
			PRICE_STANDART.PRICE > <cfqueryparam value="0" cfsqltype="cf_sql_float"> AND
			PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND
			PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			STOCKS.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
			PRODUCT_UNIT.IS_MAIN = 1 AND			
			<cfif isdefined("attributes.promotion_stock_list")>STOCKS.STOCK_ID IN (#attributes.promotion_stock_list#) AND</cfif>
			PRODUCT.IS_EXTRANET = <cfqueryparam value="1" cfsqltype="cf_sql_smallint"> AND
			PRODUCT.PRODUCT_STATUS = 1
			AND PRICE_STANDART.PRICESTANDART_STATUS = 1	
			AND PRICE_STANDART.PURCHASESALES = 1
			AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
			AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
		ORDER BY
			PRODUCT.PRODUCT_NAME
	</cfquery>
	
	<cfoutput query="get_homepage_products">
		<cfset sira_ = listfindnocase(attributes.promotion_stock_list,stock_id)>
		<cfset miktar_ = listgetat(attributes.promotion_adet_list,sira_)>
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
                    PROM_MAIN_STOCK_ID,
                    IS_PROM_ASIL_HEDIYE,
                    PROM_FREE_STOCK_ID,
                    PRICE_OLD,
                    IS_COMMISSION,
                    PRICE_STANDARD,
                    PRICE_STANDARD_KDV,
                    PRICE_STANDARD_MONEY,
                    PROM_STOCK_AMOUNT,
                    IS_NONDELETE_PRODUCT,
                    RECORD_PERIOD_ID,
                    RECORD_PAR,
                    COOKIE_NAME,
                    RECORD_IP,
                    RECORD_DATE
                )
                VALUES
                (
                    #product_id#,
                    <cfif trim(property) is '-'>'#product_name#'<cfelse>'#product_name# #property#'</cfif>,
                    #miktar_#,
                    #price#,
                    #price_kdv#,
                    '#price_money#',
                    #tax#,
                    #stock_id#,
                    #product_unit_id#,
                    #stock_id#,
                    0,
                    0,
                    NULL,
                    0,
                    #price_standart#,
                    #price_kdv_standart#,
                    '#money_standart#',
                    1,
                    0,
                    #session_base.period_id#,
                    #session.pp.userid#,
                    '#wrk_eval("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#',
                    '#cgi.remote_addr#',
                    #now()#
                )
        </cfquery>
    </cfoutput>
</cfif>

<cfquery name="GET_ROWS" datasource="#DSN3#">
    SELECT 
        OPRS.PRODUCT_ID,
        P.IS_SERIAL_NO
    FROM
        ORDER_PRE_ROWS OPRS,
        PRODUCT P
    WHERE
        OPRS.PRODUCT_ID = P.PRODUCT_ID AND
        OPRS.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
        OPRS.RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
<!---        OPRS.COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#"> AND --->
        OPRS.PRODUCT_ID IS NOT NULL
    ORDER BY OPRS.ORDER_ROW_ID
</cfquery>

<cfscript>
    session_basket_kur_ekle(process_type:0);
    if (listfindnocase(partner_url,'#cgi.http_host#',';'))
    {
        int_comp_id = session.pp.our_company_id;
        int_period_id = session.pp.period_id;
        int_money = session.pp.money;
        int_money2 = session.pp.money2;
        attributes.company_id = session.pp.company_id;
        attributes.partner_id=session.pp.userid;
    }
    else if (listfindnocase(server_url,'#cgi.http_host#',';') )
    {	
        int_comp_id = session.ww.our_company_id;
        int_period_id = session.ww.period_id;
        int_money = session.ww.money;
        int_money2 = session.ww.money2;
        attributes.consumer_id = session.ww.userid;
        attributes.partner_id='';
    }
</cfscript>
<cfinclude template="../query/get_order_detail_money.cfm">
<cfinclude template="../query/get_order_detail_account.cfm">
<cfinclude template="../query/get_order_detail.cfm">

<table border="0" cellspacing="0" cellpadding="0" align="center" style="width:98%;">
    <tr style="height:35px;">
        <td class="headbold">Sipariş</td>
        <td  class="txtbold" style="text-align:right;"><cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput></td>
    </tr>
</table>
<cfif use_https>
    <cfset url_link = https_domain>
<cfelse>
    <cfset url_link = "">
</cfif>
<cfform name="list_basketww" action="#url_link##request.self#?fuseaction=objects2.emptypopup_add_orderww" method="post" onsubmit="return (_CF_checklist_basketww(this) && unformat_fields());">
    <table align="center" class="color-border" cellpadding="2" cellspacing="1" style="width:98%;">
        <input type="hidden" name="is_order_info" id="is_order_info" value="1">
        <cfoutput>
            <cfloop query="get_money_bskt">
                <cfif str_money_bskt_func eq money_type>
                    <input type="hidden" name="rd_money" id="rd_money" value="#currentrow#" >
                </cfif>
                <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money_type#">
                <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                <input type="hidden" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#rate2#">
            </cfloop>
            <input type="hidden" name="kur_say" id="kur_say" value="#get_money_bskt.RecordCount#">
            <input type="hidden" name="basket_money" id="basket_money" value="#str_money_bskt_func#">
        </cfoutput>
        <cfif get_rows.recordcount>
            <tr class="color-header" style="height:22px;">
                <td class="form-title" style="width:25px;">No</td>
                <td class="form-title">Ürün</td>
                <td class="form-title">Seri No</td>
                <td class="form-title" style="width:45px;">Miktar</td>
                <td class="form-title" style="text-align:right; width:120px;">Son Kullanıcı Fiyatı</td>
                <td class="form-title" style="text-align:right; width:80px;">Birim Fiyat</td>
                <td class="form-title" style="text-align:right; width:100px;">Satır Toplam</td>
            </tr>
            <cfscript>
                genel_toplam = 0; /*promosyon bilgisinin goruntulenmesi bu toplama gore kontrol ediliyor*/
                tum_toplam = 0;
                tum_toplam_ps = 0;
                tum_toplam_kdvli = 0;
                tum_toplam_kdvli_ps = 0;
                tum_toplam_komisyonsuz = 0;
                kdv_toplam = 0;
                kdv_toplam_ps = 0;
                my_temp_tutar = 0;
                my_temp_tutar_price_standard = 0;
            </cfscript>
            <cfoutput query="get_rows">
                <cfquery dbtype="query" name="GET_MONEY_RATE2">
                    SELECT 
                        <cfif isDefined("session.pp")>
                            RATEPP2 RATE2
                        <cfelseif isDefined("session.ww")>
                            RATEWW2 RATE2
                        <cfelse>
                            RATE2
                        </cfif>	
                    FROM 
                        GET_MONEY
                    WHERE 
                        MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#price_money#"> AND
                        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
                </cfquery>
                <cfquery dbtype="query" name="GET_MONEY_RATE2_PRICE_STANDARD">
                    SELECT 
                        <cfif isDefined("session.pp")>
                            RATEPP2 RATE2
                        <cfelseif isDefined("session.ww")>
                            RATEWW2 RATE2
                        <cfelse>
                            RATE2
                        </cfif>	
                    FROM 
                        GET_MONEY
                    WHERE 
                        MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#price_standard_money#"> AND
                        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
                </cfquery>
                <tr class="color-row" style="height:20px; vertical-align:top;">
                    <td>#currentrow#</td>
                    <td>#product_name#</td>
                    <td>
                        <cfif is_serial_no eq 1>
                            <cfinput type="text" name="serial_no_#currentrow#" id="serial_no_#currentrow#" value="" style="width:100px;" required="yes" message="Seri No Girmelisiniz!">
                        <cfelse>
                            <input type="text" name="serial_no_#currentrow#" id="serial_no_#currentrow#" value="" style="width:100px;">
                        </cfif>
                    </td>
                    <td  style="text-align:right;">#quantity * prom_stock_amount#</td>
                    <td  style="text-align:right;">#TLFormat(price_standard)#  #price_standard_money# + KDV</td>
                    <td  style="text-align:right;">
                        <cfif len(price_old)>
                            <strike>#TLFormat(price)# #price_money#</strike><br/>
                        </cfif>
                        #TLFormat(price)# #price_money#
                    </td>
                    <td  style="text-align:right;">
                        <cfif is_prom_asil_hediye>
                            0
                        <cfelse>
                            #TLFormat(price * quantity * prom_stock_amount)#
                        </cfif>
                        #price_money#
                    </td>
                </tr>
                <cfscript>
                    if(not is_prom_asil_hediye)
                    {
                        if(not len(price_standard_kdv))
                        {
                            this_price_standart_kdv = 0;
                            this_price_standart = 0;
                        }
                        else
                        {
                            this_price_standart_kdv = price_standard_kdv;
                            this_price_standart = price_standard;
                        }
                        if(not get_money_rate2_price_standard.recordcount)
                            my_money = 1;
                        else
                            my_money = get_money_rate2_price_standard.rate2;
                        satir_toplam_std = price * quantity * prom_stock_amount * get_money_rate2.rate2;
                        satir_toplam_std_ps = this_price_standart * quantity * prom_stock_amount * my_money;
                        tum_toplam = tum_toplam + satir_toplam_std;
                        tum_toplam_ps = tum_toplam_ps + satir_toplam_std_ps;
                        satir_toplam_std_kdvli = price_kdv * quantity * prom_stock_amount * get_money_rate2.rate2;
                        satir_toplam_std_kdvli_ps = this_price_standart_kdv * quantity * prom_stock_amount * my_money;
                        if(Is_commission neq 1)
                            satir_toplam_komisyonsuz = price_kdv * quantity * prom_stock_amount * get_money_rate2.rate2;
                        tum_toplam_kdvli = tum_toplam_kdvli + satir_toplam_std_kdvli;
                        tum_toplam_kdvli_ps = tum_toplam_kdvli_ps + satir_toplam_std_kdvli_ps;
                        if(is_commission neq 1)
                            tum_toplam_komisyonsuz = tum_toplam_komisyonsuz + satir_toplam_komisyonsuz;
                        kdv_miktari = satir_toplam_std * (tax/100);
                        kdv_miktari_ps = satir_toplam_std_ps * (tax/100);
                        kdv_toplam = kdv_toplam + kdv_miktari;
                        kdv_toplam_ps = kdv_toplam_ps + kdv_miktari_ps;
                        if(is_commission neq 1)
                        {
                            my_temp_tutar = my_temp_tutar + price_kdv * quantity * prom_stock_amount * get_money_rate2.rate2;
                            my_temp_tutar_price_standard = my_temp_tutar_price_standard + this_price_standart_kdv * quantity * prom_stock_amount * my_money;					
                        }
                    }
                </cfscript>
            </cfoutput>
            <!--- satir dongusu burada bitti --->
            <cfset toplam_indirim = 0>
            <cfset toplam_indirim_ps = 0>
        </table>
        
        <cfif isdefined("session.pp.userid")>
            <cfquery name="GET_KUR" dbtype="query">
                SELECT * FROM GET_MONEY WHERE MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.money#"> ORDER BY MONEY
            </cfquery>
        <cfelse>
            <cfset get_kur.recordcount = 0>
        </cfif>
        <table cellpadding="0" cellspacing="0" align="center" style="width:98%;">
            <cfoutput>
            <tr style="height:20px;">
                <cfif get_kur.recordcount>
                    <td rowspan="3">
                        <table>
                            <tr>
                                <td class="txtbold"><cf_get_lang no ='140.Kurlar'></td>
                            </tr>
                            <cfloop query="get_kur">
                                <tr>
                                    <td class="txtbold">#money#</td>
                                    <td  style="text-align:right;">
                                        <cfif isDefined("session.pp")>
                                            #TLFormat(ratepp2,4)#
                                        <cfelseif isDefined("session.ww")>
                                            #TLFormat(rateww2,4)#
                                        <cfelse>
                                            #TLFormat(rate2,4)#
                                        </cfif>	
                                    </td>
                                </tr>
                            </cfloop>
                        </table>
                    </td>
                </cfif>
                <td  class="formbold" style="text-align:right;">TOPLAM (KDV Hariç)</td>
                <td  style="text-align:right; width:100px;">#TLFormat(tum_toplam)# #get_stdmoney.money#</td>
                <td style="text-align:right; width:100px;">#TLFormat(tum_toplam/get_money_money2.rate2/get_money_money2.rate1)# #int_money2#</td>
            </tr>
            <cfif (len(get_general_prom.limit_value) and len(get_general_prom.discount) and get_general_prom.limit_value lte genel_toplam)>
                <tr style="height:20px;">
                    <td class="formbold">"GENEL PROMOSYON" İSKONTOSU</td>
                    <td style="text-align:right;">#TLFormat(toplam_indirim)# #get_stdmoney.money#</td>
                    <td style="text-align:right;">#TLFormat(toplam_indirim/get_money_money2.rate2/get_money_money2.rate1)# #int_money2#</td>
                </tr>
            </cfif>
            <tr style="height:20px;">
                <td class="formbold">TOPLAM (KDV Dahil)</td>
                <td style="text-align:right;">#TLFormat(tum_toplam_kdvli)# #get_stdmoney.money#</td>
                <td style="text-align:right;">#TLFormat(tum_toplam_kdvli/get_money_money2.rate2/get_money_money2.rate1)# #int_money2#</td>
            </tr>
            <input type="hidden" name="grosstotal" id="grosstotal" value="#tum_toplam_kdvli#">
            <input type="hidden" name="grosstotal_ps" id="grosstotal_ps" value="#tum_toplam_kdvli_ps#">
            <input type="hidden" name="taxtotal" id="taxtotal" value="#kdv_toplam#">
            <input type="hidden" name="taxtotal_ps" id="taxtotal_ps" value="#kdv_toplam_ps#">
            <input type="hidden" name="discounttotal" id="discounttotal" value="#toplam_indirim#">
            <input type="hidden" name="discounttotal_ps" id="discounttotal_ps" value="#toplam_indirim_ps#">
            <input type="hidden" name="nettotal" id="nettotal" value="#tum_toplam#">
            <input type="hidden" name="nettotal_ps" id="nettotal_ps" value="#tum_toplam_ps#">
            <input type="hidden" name="other_money" id="other_money" value="#int_money2#">
            <input type="hidden" name="other_money_value" id="other_money_value" value="#tum_toplam_kdvli/(get_money_money2.rate2/get_money_money2.rate1)#">
            <input type="hidden" name="other_money_value_ps" id="other_money_value_ps" value="#tum_toplam_kdvli_ps/(get_money_money2.rate2/get_money_money2.rate1)#">
            <input type="hidden" name="tum_toplam_kdvli" id="tum_toplam_kdvli" value="#tum_toplam_kdvli#">
            <input type="hidden" name="tum_toplam_komisyonsuz" id="tum_toplam_komisyonsuz" value="#tum_toplam_komisyonsuz#">
            <input type="hidden" name="my_temp_tutar" id="my_temp_tutar" value="#tum_toplam_kdvli#">
            <input type="hidden" name="my_temp_tutar_price_standart" id="my_temp_tutar_price_standart" value="#tum_toplam_kdvli#">
            <input type="hidden" name="toplam_desi" id="toplam_desi" value="0">
            </cfoutput>
        </table>
        <cfset attributes.is_puan_basket = 1>
        <cfset is_order_to_directcustomer = 0>
        <cfinclude template="address_payment_info.cfm">
    <cfelse>
        <table align="center" cellpadding="2" cellspacing="1" style="width:96%;">
            <tr class="color-header" style="height:22px;">
                <td class="form-title">No</td>
                <td class="form-title">Ürünler</td>
                <td class="form-title" style="width:50px;">Miktar</td>
                <td class="form-title" style="text-align:right; width:125px;">Birim Fiyat</td>
                <td class="form-title" style="text-align:right; width:150px;">Fiyat</td>
            </tr>
            <tr class="color-row" style="height:20px;">
                <td colspan="5"><cf_get_lang no='134.Sepette Ürün Yok'>!</td>
            </tr>
        </table>
    </cfif>
</cfform>
<script type="text/javascript">
	function unformat_fields()
	{
		<cfif isDefined("session.pp")>
			document.getElementById('price_standart_last').value = filterNum(document.getElementById('price_standart_dsp').value);
		</cfif>
	}
	function remove_adress(parametre)
	{
		if(parametre==1)
		{
			document.getElementById('ship_address_city0').value = '';
			document.getElementByıd('ship_address_county0').value = '';
			document.getElementById('ship_address_county_name0').value = '';
		}
		else
		{
			document.getElementById('ship_address_county0').value = '';
			document.getElementById('ship_address_county_name0').value = '';
		}	
	}
	function yeni_adres(nesne)
	{
		if(nesne.checked==true && nesne.value==0)
		{
			shipaddress0.style.display='';
		}else
		{
			shipaddress0.style.display='none';
		}
	}
	function add_consumer(add_consumer_param)
	{
		if(add_consumer_param.checked == true)
			add_consumer_table.style.display='';
		else
			add_consumer_table.style.display='none';
	}
	function pencere_ac(no)
	{
		x = document.list_basketww.ship_address_country0.selectedIndex;
		if (document.list_basketww.ship_address_country0[x].value == "")
		{
			alert("İlk Olarak Ülke Seçiniz.");
		}	
		else if(document.getElementById('ship_address_city0').value == "")
		{
			alert("İl Seçiniz !");
		}
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_dsp_county&field_id=list_basketww.ship_address_county0&field_name=list_basketww.ship_address_county_name0&city_id=' + list_getat(document.getElementById('ship_address_city0').value,1,","),'small');
			return remove_adress();
		}
	}
	function pencere_ac2(no)
	
	{
		if (document.list_basketww.city[document.list_basketww.city.selectedIndex].value == "")
			alert("İl Seçiniz!");
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=list_basketww.county_id&field_name=list_basketww.county&city_id=' + document.getElementById('city').value,'small');
	}
	function odemeyontemi(){
		<cfif isDefined("attributes.company_id")>
			if(document.list_basketww.paymethod_type[0] != undefined && document.list_basketww.paymethod_type[0].checked==true)
			{
				pay_type_1.style.display='';
				pay_type_2.style.display='none';
				if(document.pay_type_3 != undefined)
					pay_type_3.style.display='none';
			}else if(document.list_basketww.paymethod_type[1] != undefined && document.list_basketww.paymethod_type[1].checked==true)
			{
				pay_type_1.style.display='none';
				pay_type_2.style.display='';
				if(document.pay_type_3 != undefined)
					pay_type_3.style.display='none';	
			}else if(document.list_basketww.paymethod_type[2] != undefined && document.list_basketww.paymethod_type[2].checked==true)
			{
				pay_type_1.style.display='none';
				pay_type_2.style.display='none';
				if(document.pay_type_3 != undefined)
					pay_type_3.style.display='';
			}
		<cfelse>
				pay_type_2.style.display='';
		</cfif>
	}
	
	function kontrol() 
	{
		var kontrol=0;
		if(document.list_basketww.ship_address_row!=undefined && document.list_basketww.ship_address_row.length>1)
		{
			for(var j=0;j<document.list_basketww.ship_address_row.length;j++)
			{
				if(document.list_basketww.ship_address_row[j].checked==true)
				{
						if(document.list_basketww.ship_address_row[document.list_basketww.ship_address_row.length-1].checked==true)
						{
							if(document.getElementById('ship_address_city0').value.length==0 || (document.getElementById('ship_address_county0').value.length==0 && document.getElementById('ship_address_semt0').value.length==0) || document.getElementById('ship_address0').value.length==0)
							{
								alert('Adres Bilgilerini Giriniz!');
								return false;
							}
						}
					kontrol=1;
					break;
				}
			}
		}
		else if(document.list_basketww.ship_address_row!=undefined && document.list_basketww.ship_address_row.length == undefined)
		{
			if(document.list_basketww.ship_address_row.checked==true)
			{
				if(document.getElementById('ship_address_city0').value.length==0 || (document.getElementById('ship_address_county0').value.length==0 && document.getElementById('ship_address_semt0').value.length==0) || document.getElementById('ship_address0').value.length==0)
				{
					alert('Adres Bilgilerini Giriniz!');
					return false;
				}
				kontrol=1;
			}
		}
		if(kontrol==0)
		{
			alert('Adres Seçiniz!');
			return false;
		}
		kontrol=0;
		if(document.list_basketww.paymethod_type != undefined && document.list_basketww.paymethod_type.checked==true)
			kontrol=1;
			<cfif isDefined("attributes.company_id")>
				if(document.getElementById('paymethod_type').value != undefined)//tek ödeme yöntemli ve çoklular için 2 blok yapıldı.
				{
					if(document.list_basketww.paymethod_type.checked==true)
					{
						if(document.getElementById('paymethod_type').value == 2)//Kredi kartı ile ödeme yaparsa
						{
							if(document.list_basketww.action_to_account_id == undefined)
							{
								alert('Ödeme Yöntemi Seçiniz!');
								return false;
							}
							if(document.getElementById('card_no').value == "")
							{
								alert('Kredi Kartı No Giriniz!');
								return false;
							}
							if(document.getElementById('cvv_no').value == "")
							{
								alert('CVV No Giriniz!');
								return false;
							}
							if(document.getElementById('process_cat').value == "" || document.getElementById('process_type').value == "")
							{
								alert('Kredi Kartı Tahsilat İşlem Tipi Tanımlayınız!');
								return false;
							}
							temp_xxx=0;
							for(var t=0; t <'<cfoutput>#get_accounts.recordcount#</cfoutput>'; t++)
							{
								if (eval('list_basketww.action_to_account_id[t].checked'))
									temp_xxx=1;
							}
							if(temp_xxx==0)				
							{
								alert('Ödeme Yöntemi Seçiniz!');
								return false;
							}
			
						}
						if(document.list_basketww.paymethod_type.value == 1)//Havale ile ödeme yaparsa
						{
							x = document.list_basketww.account_id.selectedIndex;
							if (document.list_basketww.account_id[x].value == "")
							{
								alert('Hesap Seçiniz!');
								return false;
							}
							if(document.getElementById('process_type_talimat').value == "" || document.getElementById('process_cat_talimat').value == "")
							{
								alert('Havale İşlem Tipi Tanımlayınız!');
								return false;
							}
						kontrol=1;
						}
						if(document.getElementById('paymethod_type').value == 3)//Risk limiti ile ödeme yaparsa
						{
							if(document.getElementById('kalan_risk_info').value < 0)
								alert('Risk Limitiniz: ' +commaSplit(document.getElementById('kalan_risk_info').value));
						}
						kontrol=1;
					}
				}
				else
				{
					for(var j=0;j<document.list_basketww.paymethod_type.length;j++)
					{
						if(document.list_basketww.paymethod_type[j].checked==true)
						{
							if(document.list_basketww.paymethod_type[j].value == 2)//Kredi kartı ile ödeme yaparsa
							{
								if(document.list_basketww.action_to_account_id == undefined)
								{
									alert('Ödeme Yöntemi Seçiniz!');
									return false;
								}
								if(document.getElementById('card_no').value == "")
								{
									alert('Kredi Kartı No Giriniz!');
									return false;
								}
								if(document.getElementById('cvv_no').value == "")
								{
									alert('CVV No Giriniz!');
									return false;
								}
								if(document.getElementById('process_cat').value == "" || document.getElementById('process_type').value == "")
								{
									alert('Kredi Kartı Tahsilat İşlem Tipi Tanımlayınız!');
									return false;
								}
								temp_xxx=0;
								for(var t=0; t <'<cfoutput>#get_accounts.recordcount#</cfoutput>'; t++)
								{
									if (eval('document.getElementById("action_to_account_id")[t].checked'))
										temp_xxx=1;
								}
								if(temp_xxx==0)				
								{
									alert('Ödeme Yöntemi Seçiniz!');
									return false;
								}
							//kontrol=1;
							}
							if(document.getElementById('paymethod_type')[j].value == 1)//Havale ile ödeme yaparsa
							{
								x = document.list_basketww.account_id.selectedIndex;
								if (document.list_basketww.account_id[x].value == "")
								{
									alert('Hesap Seçiniz!');
									return false;
								}
								if(document.getElementById('process_type_talimat').value == "" || document.getElementById('process_cat_talimat').value == "")
								{
									alert('Havale İşlem Tipi Tanımlayınız!');
									return false;
								}
							//kontrol=1;
							}
							if(document.getElementById('paymethod_type')[j].value == 3)//Risk limiti ile ödeme yaparsa
							{
								if(document.getElementById('kalan_risk_info').value < 0)
									alert('Risk Limitiniz: ' +commaSplit(document.getElementById('kalan_risk_info').value));
							}
							kontrol=1;
							break
						}
					}
				}
			<cfelse>
				if(document.list_basketww.paymethod_type.checked==true)
				{
					if(document.getElementById('paymethod_type').value == 2)//Kredi kartı ile ödeme yaparsa
					{
						if(document.list_basketww.action_to_account_id == undefined)
						{
							alert('Ödeme Yöntemi Seçiniz!');
							return false;
						}
						if(document.getElementById('card_no').value == "")
						{
							alert('Kredi Kartı No Giriniz!');
							return false;
						}
						if(document.getElementById('cvv_no').value == "")
						{
							alert('CVV No Giriniz!');
							return false;
						}
						if(document.getElementById('process_cat').value == "" || document.getElementById('process_type').value == "")
						{
							alert('Kredi Kartı Tahsilat İşlem Tipi Tanımlayınız!');
							return false;
						}
						temp_xxx=0;
						if(document.list_basketww.action_to_account_id != undefined && document.list_basketww.action_to_account_id.checked)
							temp_xxx=1;
						else
						{
							for(var t=0; t <'<cfoutput>#get_accounts.recordcount#</cfoutput>'; t++)
							{
								eval('document.getElementById("action_to_account_id")[t].checked')
									temp_xxx=1;
							}
							if(temp_xxx==0)				
							{
								alert('Ödeme Yöntemi Seçiniz!');
								return false;
							}
						}
					}
					kontrol=1;
				}
			</cfif>
		if(kontrol==0)
		{
			alert('Ödeme Yöntemi Seçiniz!');
			return false;
		}
		<cfif isDefined("session.pp")>
			if(document.list_basketww.is_price_standart.checked && document.list_basketww.consumer_info.checked)
			{
				if(document.getElementById('member_name').value=="" || document.getElementById('member_surname').value=="" || document.getElementById('address').value=="")
				{
					alert("Müşteri İçin Ad Soyad ve Adres Bilgilerini Giriniz!");
					return false;
				}
				if(document.getElementById('consumer_stage').value=="")
				{
					alert("Bireysel Üye Süreçlerinizi Kontrol Ediniz!");
					return false;
				}
			}
		</cfif>
		return true;
	}
	document.list_basketww.joker_vada.checked = false;
	function get_paymnt_type_info(sira,tutar,tutar_price_standard)
	{
		<cfif get_accounts.recordcount eq 1>
			paym_type_id = list_basketww.action_to_account_id.value.split(';')[2];
		<cfelse>
			paym_type_id = eval('document.list_basketww.action_to_account_id[sira-1]').value.split(';')[2];
		</cfif>
		var get_comp_prod = wrk_safe_query("obj2_get_comp_prod",'dsn3',0,paym_type_id);
		bb = get_comp_prod.COMMISSION_MULTIPLIER;
		if(get_comp_prod.COMMISSION_MULTIPLIER != '' && get_comp_prod.COMMISSION_MULTIPLIER > 0 && get_comp_prod.COMMISSION_STOCK_ID != '' && get_comp_prod.COMMISSION_PRODUCT_ID != '')
		{
				document.getElementById('price_catid_2').value = -2;
				var aa_temp = wrk_round((tutar * get_comp_prod.COMMISSION_MULTIPLIER)/100);
				var aa_temp_price_standard = wrk_round((tutar_price_standard * get_comp_prod.COMMISSION_MULTIPLIER)/100);
				document.getElementById('price').value = wrk_round((aa_temp*100)/(100 + parseFloat(get_comp_prod.TAX)));
				document.getElementById('price_old').value = '';
				document.getElementById('istenen_miktar').value = 1;
				document.getElementById('sid').value = get_comp_prod.COMMISSION_STOCK_ID; 
				document.getElementById('price_kdv').value = aa_temp;
				<cfif isDefined("session.pp.money")>
					document.getElementById('price_money').value = '<cfoutput>#session.pp.money#</cfoutput>';
					document.getElementById('price_standard_money').value = '<cfoutput>#session.pp.money#</cfoutput>';
				<cfelse>
					document.getElementById('price_money').value = '<cfoutput>#session.ww.money#</cfoutput>';
					document.getElementById('price_standard_money').value = '<cfoutput>#session.ww.money#</cfoutput>';
				</cfif>
				document.getElementById('prom_id').value = '';
				document.getElementById('prom_discount').value = '';
				document.getElementById('prom_amount_discount').value = '';
				document.getElementById('prom_cost').value = '';
				document.getElementById('prom_free_stock_id').value = '';
				document.getElementById('prom_stock_amount').value = 1;
				document.getElementById('prom_free_stock_amount').value = 1;
				document.getElementById('prom_free_stock_price').value = 0;
				document.getElementById('prom_free_stock_money').value = '';
				document.getElementById('is_commission').value = 1;
				document.getElementById('paymethod_id_com').value = paym_type_id;
				//son kullanici
				document.getElementById('price_standard').value = wrk_round((aa_temp_price_standard*100)/(100 + parseFloat(get_comp_prod.TAX)));
				document.getElementById('price_standard_kdv').value = aa_temp_price_standard;
				
				satir_gonder.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_add_basketww_row';
				satir_gonder.submit();
		}
		else
		{
			<cfif get_accounts.recordcount eq 1>
				if(document.getElementById('action_to_account_id').value.split(';')[3] == 9 && document.getElementById('action_to_account_id').value.split(';')[4] != undefined && document.getElementById('action_to_account_id').value.split(';')[4] > 0)
				{//pos type i alır,Yapıkredi taksitlide işlem olur sadece
					joker_info.style.display='';
					document.list_basketww.joker_vada.checked = true;//joker vada seçili gelsin
				}
				else
			{
				joker_info.style.display='none';
				document.list_basketww.joker_vada.checked = false;
			}
		<cfelse>
			if(eval('document.getElementById("action_to_account_id")[sira-1]').value.split(';')[3] == 9 && eval('document.getElementById("action_to_account_id")[sira-1]').value.split(';')[4] != undefined && eval('document.getElementById("action_to_account_id")[sira-1]').value.split(';')[4] > 0)
			{//pos type i alır,Yapıkredi taksitlide işlem olur sadece
				joker_info.style.display='';
				document.list_basketww.joker_vada.checked = true;//joker vada seçili gelsin
			}
			else
			{
				joker_info.style.display='none';
				document.list_basketww.joker_vada.checked = false;
			}
		</cfif>
		<cfoutput query="get_rows">
			<cfif is_commission eq 1>
				window.location.href='#request.self#?fuseaction=objects2.emptypopup_del_basketww&is_delete_info=1&paymethod_id_com='+eval('document.getElementById("action_to_account_id")[sira-1]').value.split(';')[2]+'';
			</cfif>
		</cfoutput>
		}
	}
	function pay_type_general()
	{
		<cfif isDefined("attributes.paymethod_id_com")>
			var get_pay_mtd = wrk_safe_query("obj2_get_pay_mtd",'dsn3',0,<cfoutput>#attributes.paymethod_id_com#</cfoutput>);
			if( get_pay_mtd.POS_TYPE == 9 && get_pay_mtd.NUMBER_OF_INSTALMENT != '' && get_pay_mtd.NUMBER_OF_INSTALMENT > 0)
			{//pos type i alır,Yapıkredi taksitlide işlem olur sadece
				joker_info.style.display='';
				document.list_basketww.joker_vada.checked = true;//joker vada seçili gelsin
			}
			else
			{
				joker_info.style.display='none';
				document.list_basketww.joker_vada.checked = false;
			}
		</cfif>
	}
	function clear_pos_row(pay_info)
	{
		<cfoutput query="get_rows">
			<cfif is_commission eq 1>
				<cfif isDefined("pay_info") and pay_info eq 1>
					window.location.href='#request.self#?fuseaction=objects2.emptypopup_del_basketww&is_delete_info2=1';
				<cfelse>
					window.location.href='#request.self#?fuseaction=objects2.emptypopup_del_basketww&is_delete_info2=1';
				</cfif>
			</cfif>
		</cfoutput>
	}
	<cfif isDefined("session.pp")>
		function use_price_standart()
		{
			if(document.list_basketww.is_price_standart.checked)
			{
				price_standart_info.style.display='';
				<cfif isDefined('is_order_to_directcustomer') and is_order_to_directcustomer eq 1>price_standart_info2.style.display='';</cfif>
			}
			else{
				price_standart_info.style.display='none';
				<cfif isDefined('is_order_to_directcustomer') and is_order_to_directcustomer eq 1>price_standart_info2.style.display='none';</cfif>
			}
		}
	</cfif>
	pay_type_general();
	window.defaultStatus="Bu sayfada SSL Kullanılmaktadır."
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
	<input type="hidden" name="is_commission" id="is_commission" value="0">
	<input type="hidden" name="paymethod_id_com" id="paymethod_id_com" value="0">
	<input type="hidden" name="price_standard" id="price_standard" value="">
	<input type="hidden" name="price_standard_kdv" id="price_standard_kdv" value="">
	<input type="hidden" name="price_standard_money" id="price_standard_money" value="">
</form>

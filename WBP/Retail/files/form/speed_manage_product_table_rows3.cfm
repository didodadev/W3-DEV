<cfparam name="attributes.is_from_order" default="0">
<cfset last_cat_id_ = "">
<cfset group_miktar_total = 0>
<cfset group_tutar_total = 0>
<cfset ort_sat = 0>
<cfset is_purchase_type = 1>

<cfset bugun_deger_ = day(now()) + (month(now()) * 30) + (year(now()) * 365)>
<cfset p_count = 0>
<cfset r_number = 0>
<cfset all_p_list = listdeleteduplicates(valuelist(get_products.product_id))>
<cfif isdefined("session.ep.userid")>
    <cfset userid_ = session.ep.userid>
<cfelse>
    <cfset userid_ = session.pp.userid>
</cfif>
<cfquery name="ortalama_liste_satis_tutar" dbtype="query">
    SELECT SUM(ROW_ORT_STOK_SATIS_MIKTARI * LISTE_FIYATI) TOTAL_SALE FROM get_products WHERE ROW_ORT_STOK_SATIS_MIKTARI IS NOT NULL
</cfquery>
<cfset ort_liste_satis_tutar = ortalama_liste_satis_tutar.total_sale>

<cfset attributes.action_code_list_all = ''>


	<cfif isdefined("attributes.action_code_type") and attributes.action_code_type eq 2>
        <cfif isdefined("attributes.action_code_list") and not isdefined("attributes.p_action_code_list")>
            <cfset attributes.action_code_type = 0>
        </cfif>
        <cfif not isdefined("attributes.action_code_list") and isdefined("attributes.p_action_code_list")>
            <cfset attributes.action_code_type = 1>
        </cfif>
    </cfif>
    <cfif isdefined("attributes.action_code_type") and attributes.action_code_type eq 0>
    	<cfset attributes.action_code_list_all = attributes.action_code_list>
    </cfif>
    <cfif isdefined("attributes.action_code_type") and attributes.action_code_type eq 1>
        <cfset attributes.action_code_list_all = attributes.p_action_code_list>
    </cfif>
    
    <cfif isdefined("attributes.action_code_type") and attributes.action_code_type eq 2>
    	<cfif isdefined("attributes.action_code_list") and len(attributes.action_code_list)>
			<cfset attributes.action_code_list_all = listappend(attributes.action_code_list_all,attributes.action_code_list)>
        </cfif>
        <cfif isdefined("attributes.p_action_code_list") and len(attributes.p_action_code_list)>
            <cfset attributes.action_code_list_all = listappend(attributes.action_code_list_all,attributes.p_action_code_list)>
        </cfif>
    </cfif>

<cfif isdefined("attributes.is_from_price_change") and isdefined("attributes.selected_product_id") and listlen(attributes.selected_product_id)>
	<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
        <cf_date tarih='attributes.finishdate'>
    <cfelse>
        <cfset attributes.finishdate = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>	
    </cfif>
    <cfquery name="get_price_rows" datasource="#dsn_dev#">
    	SELECT 
            *
        FROM 
            PRICE_TABLE 
        WHERE 
            (
               (IS_ACTIVE_S = 1 AND DATEADD("d",-1,FINISHDATE) = #attributes.finishdate#) OR
               (IS_ACTIVE_P = 1 AND DATEADD("d",-1,P_FINISHDATE) = #attributes.finishdate#)
            )
            AND
            PRODUCT_ID IN (#attributes.selected_product_id#)
    </cfquery>
<cfelseif isdefined("attributes.action_code") and len(attributes.action_code)>
	<cfquery name="get_price_rows" datasource="#dsn_dev#">
    	SELECT 
            *
        FROM 
            PRICE_TABLE 
        WHERE 
            ACTION_CODE = '#attributes.action_code#'
    </cfquery>
<cfelseif isdefined("attributes.action_code_list_all") and len(attributes.action_code_list_all)>
	<cfquery name="get_price_rows" datasource="#dsn_dev#">
    	SELECT 
            *
        FROM 
            PRICE_TABLE 
        WHERE 
            ACTION_CODE IN ('#replace(attributes.action_code_list_all,",","','","all")#')
    </cfquery>
<cfelseif isdefined("attributes.wrk_id") and len(attributes.wrk_id)>
	<cfquery name="get_price_rows" datasource="#dsn_dev#">
    	SELECT 
            *
        FROM 
            PRICE_TABLE 
        WHERE 
            WRK_ID = '#attributes.wrk_id#'
    </cfquery>
</cfif>

<cfif isdefined("get_price_rows.recordcount") and get_price_rows.recordcount>
    <cfquery name="get_price_rows_departments" datasource="#dsn_dev#">
        SELECT 
            *
        FROM 
            PRICE_TABLE_DEPARTMENTS
        WHERE 
            ROW_ID IN (#valuelist(get_price_rows.row_id)#)
    </cfquery>
</cfif>

<cfset name_list = "
id,
price_control,
product_color,
product_code,
product_cat,
row_type,
sira_no,
product_name,
stock_id,
stock_count,
product_id,
active_row,
list_price,
list_price_kdv,
product_stock_list,
p_ss_marj,
s_profit,
info_standart_alis,
is_purchase,
is_purchase_c,
is_purchase_m,
is_sales,
barcode,
product_code_r,
product_price_change_lastrowid,
product_price_change_count,
product_price_change_detail,
price_type,
price_type_id,
standart_alis,
standart_alis_liste,
standart_alis_kdv,
standart_alis_kdvli,
c_standart_alis_kdvli,
p_discount_manuel,
new_alis_start,
new_alis,
new_alis_kdvli,
c_new_alis_kdvli,
is_active_p,
p_startdate,
p_finishdate,
first_satis_price,
c_first_satis_price,
is_active_s,
avantaj_oran,
first_satis_price_kdv,
alistan_maliyetli_marjli_fiyat,
sales_discount,
avg_rival,
ortalama_satis_gunu,
stok_yeterlilik_suresi,
stok_yeterlilik_suresi_order,
genel_stok_tutar,
dueday,
add_stock_gun,
gun_total,
stok_devir_hizi,
urun_stok,
depo_stok,
magaza_stok,
yoldaki_stok,
oneri_siparis,
oneri_siparis2,
carpan,
carpan2,
siparis_onay,
siparis_sevk,
siparis_miktar,
siparis_miktar_k,
siparis_miktar_p,
siparis_tutar_1,
siparis_tutar_kdv_1,
siparis_tarih_1,
siparis_onay_2,
siparis_sevk_2,
siparis_miktar_2,
siparis_miktar_k_2,
siparis_miktar_p_2,
siparis_tutar_2,
siparis_tutar_kdv_2,
siparis_tarih_2,
company_code,
company_name,
startdate,
finishdate,
satis_kdv,
standart_satis,
c_standart_satis_kdv,
c_standart_satis,
standart_satis_kdv,
c_is_standart_satis_aktif,
is_standart_satis_aktif,
maliyet,
satis_standart_satis_oran,
stok_dagitim,
seviye_bilgisi,
standart_alis_indirim_tutar,
standart_alis_indirim_yuzde,
standart_alis_baslangic,
standart_satis_baslangic,
alis_kar,
standart_alis_kar,
standart_satis_kar,
standart_satis_oran,
standart_alis_oran,
eski_standart_alis_kdvli,
eski_standart_satis_kdvli,
eski_kar,
liste_oran,
donem_satis,
donem_satis_tutar,
ReportsTo,
p_product_type,
sub_rows_count,
product_info,
price_departments,
std_p_control,
unit_price
">

<cfset myQuery = QueryNew("#name_list#"
, 
"
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar,
varchar
"
)>
<cfset query_count = 0>
<cfoutput query="get_products" group="product_id">
	<cfif len(add_stock_day)>
    	<cfset add_stock_gun_ = add_stock_day>
    <cfelse>
		<cfset add_stock_gun_ = attributes.add_stock_gun>
    </cfif>
	<cfif len(OZEL_PRICE_TYPE)>
        <cfset price_style = "color:red;">
        <cfset PRICE_CONTROL = -1 * OZEL_PRICE_ROW_ID>
        
        <cfquery name="get_active_price" datasource="#dsn_dev#">
        	SELECT
            	*,
                (SELECT PT.TYPE_NAME FROM PRICE_TYPES PT WHERE PT.TYPE_ID = PRICE_TABLE.PRICE_TYPE) AS FIYAT_TIPI
            FROM
            	PRICE_TABLE
            WHERE
            	ROW_ID = #OZEL_PRICE_ROW_ID#
        </cfquery>
        
        <cfquery name="get_next_price" datasource="#dsn_dev#">
        	SELECT 
                *,
                (SELECT PT.TYPE_NAME FROM PRICE_TYPES PT WHERE PT.TYPE_ID = PT1.PRICE_TYPE) AS FIYAT_TIPI
            FROM
                PRICE_TABLE PT1
            WHERE
                PT1.PRODUCT_ID = #get_active_price.PRODUCT_ID# AND
                PT1.ROW_ID <> #OZEL_PRICE_ROW_ID# AND
                PT1.FINISHDATE > #createodbcdatetime(get_active_price.FINISHDATE)# AND
                PT1.IS_ACTIVE_S = #get_active_price.IS_ACTIVE_S#
        </cfquery>

		<cfset product_info = "">
		<cfset product_info = "#product_info#<b>Geçerli Fiyat</b><br><br><table border='1' cellpadding='4' cellspacing='0'>">
		<cfset product_info = "#product_info#<tr><td height='30'>&nbsp;<i>Fiyat Tipi</i>&nbsp;</td><td>&nbsp;<i>Alış Tarih</i>&nbsp;</td><td>&nbsp;<i>Satış Tarih</i>&nbsp;</td><td>&nbsp;<i>Alış H.</i>&nbsp;</td><td>&nbsp;<i>Satış H.</i>&nbsp;</td></tr>">
        <cfset product_info = "#product_info#<tr><td height='25'>&nbsp;#get_active_price.FIYAT_TIPI#&nbsp;</td><td>&nbsp;#dateformat(get_active_price.P_STARTDATE,'dd/mm/yyyy')#-#dateformat(get_active_price.P_FINISHDATE,'dd/mm/yyyy')#&nbsp;</td><td>&nbsp;#dateformat(get_active_price.STARTDATE,'dd/mm/yyyy')#-#dateformat(get_active_price.FINISHDATE,'dd/mm/yyyy')#&nbsp;</td><td>&nbsp;<i>#tlformat(get_active_price.new_alis)#</i>&nbsp;</td><td>&nbsp;<i>#tlformat(get_active_price.new_price)#</i>&nbsp;</td></tr>">
		<cfset product_info = "#product_info#</table>">
        <cfif get_next_price.recordcount>
        	<cfset PRICE_CONTROL = get_next_price.ROW_ID>
            <cfset product_info = "#product_info#<br><br><b>Sonraki Fiyat</b><br><br><table border='1' cellpadding='4' cellspacing='0'>">
			<cfset product_info = "#product_info#<tr><td height='30'>&nbsp;<i>Fiyat Tipi</i>&nbsp;</td><td>&nbsp;<i>Alış Tarih</i>&nbsp;</td><td>&nbsp;<i>Satış Tarih</i>&nbsp;</td><td>&nbsp;<i>Alış H.</i>&nbsp;</td><td>&nbsp;<i>Satış H.</i>&nbsp;</td></tr>">
            <cfset product_info = "#product_info#<tr><td height='25'>&nbsp;#get_next_price.FIYAT_TIPI#&nbsp;</td><td>&nbsp;#dateformat(get_next_price.P_STARTDATE,'dd/mm/yyyy')#-#dateformat(get_next_price.P_FINISHDATE,'dd/mm/yyyy')#&nbsp;</td><td>&nbsp;#dateformat(get_next_price.STARTDATE,'dd/mm/yyyy')#-#dateformat(get_next_price.FINISHDATE,'dd/mm/yyyy')#&nbsp;</td><td>&nbsp;<i>#tlformat(get_next_price.new_alis)#</i>&nbsp;</td><td>&nbsp;<i>#tlformat(get_next_price.new_price)#</i>&nbsp;</td></tr>">
            <cfset product_info = "#product_info#</table>">
        </cfif>
    <cfelse>
        <cfset price_style = "color:##000;">
        <cfset PRICE_CONTROL = 0>
        <cfset product_info = "Fiyatlandırma Bulunamadı!">
    </cfif>
    
    <cfset code_ = "#product_id#_0_0">
    
	<cfif isdefined("attributes.print_action") and get_price_all.recordcount>
        <cfquery name="get_action_price" dbtype="query">
            SELECT * FROM get_price_all WHERE PRODUCT_ID = #product_id#
        </cfquery>
    </cfif>

	<cfset ss_price_ = STANDART_SALE_PRICE_KDV>
    
    <cfif isdefined("get_table_info.READ_FIRST_SATIS_PRICE_KDV_#product_id#")>
        <cfset ssn_price_ = evaluate("get_table_info.READ_FIRST_SATIS_PRICE_KDV_#product_id#")>
    <cfelse>
        <cfset ssn_price_ = STANDART_SALE_PRICE_KDV>
    </cfif>

	<cfif ssn_price_ neq ss_price_>
        <cfset ssn_active_ = 1>
    <cfelse>
        <cfset ssn_active_ = 0>
    </cfif>

	<cfset ssa_price_ = wrk_round(price_standart_kdv,2)>
    <cfif isdefined("get_table_info.STANDART_ALIS_KDVLI_#product_id#")>
        <cfset ssna_price_ = filterNum(evaluate("get_table_info.STANDART_ALIS_KDVLI_#product_id#"))>
    <cfelse>
        <cfset ssna_price_ = price_standart_kdv>
    </cfif>

	<cfif ssna_price_ neq ssa_price_>
        <cfset ssa_active_ = 1>
    <cfelse>
        <cfset ssa_active_ = 0>
    </cfif>

	<cfset p_count = p_count + 1>
    <cfset r_number = r_number + 1>
    <cfif isdefined("product_id_list")>
        <cfset product_id_list = listappend(product_id_list,product_id)>
    <cfelse>
        <cfset product_id_list = product_id>
    </cfif>
    
    <cfquery name="get_total_yoldaki" dbtype="query">
        SELECT SUM(PURCHASE_ORDER_QUANTITY) TOTAL_STOCK FROM get_products WHERE PRODUCT_ID = #product_id#
    </cfquery>
    <cfquery name="get_stocks" dbtype="query">
        SELECT STOCK_ID FROM get_products WHERE PRODUCT_ID = #product_id#
    </cfquery>
    <cfquery name="get_total_yoldaki_tutar" dbtype="query">
        SELECT SUM(PURCHASE_ORDER_TUTAR) TOTAL_STOCK FROM get_products WHERE PRODUCT_ID = #product_id#
    </cfquery>
    
    <cfquery name="toplam_siparis" dbtype="query">
        SELECT SUM(ROW_SIPARISLER) TOTAL FROM get_products WHERE PRODUCT_ID = #product_id#
    </cfquery>
    
    <cfif listlen(attributes.search_department_id) gt 1 and listfind(attributes.search_department_id,merkez_depo_id)>
    	<cfquery name="ortalama_satis" dbtype="query">
            SELECT 
                ROW_ORT_STOK_SATIS_MIKTARI TOTAL_STOCK 
            FROM 
                get_products 
            WHERE 
                PRODUCT_ID = #product_id# AND
                DEPARTMENT_ID = #merkez_depo_id#
        </cfquery>
    <cfelse>
        <cfquery name="ortalama_satis" dbtype="query">
            SELECT 
                SUM(ROW_ORT_STOK_SATIS_MIKTARI) TOTAL_STOCK 
            FROM 
                get_products 
            WHERE 
                PRODUCT_ID = #product_id#
        </cfquery>
    </cfif>
    <cfquery name="ortalama_satis_tutar" dbtype="query">
        SELECT SUM(ROW_ORT_STOK_SATIS_MIKTARI * LISTE_FIYATI) TOTAL_SALE FROM get_products WHERE PRODUCT_ID = #product_id# AND ROW_ORT_STOK_SATIS_MIKTARI IS NOT NULL
    </cfquery>
    
   

	<cfset product_total_stock = URUN_STOCK>
    <cfset yoldaki_stok = get_total_yoldaki.TOTAL_STOCK>
    <cfset yoldaki_stok_tutar = get_total_yoldaki_tutar.TOTAL_STOCK>
    
    <cfset ORT_SATIS_MIKTARI = ROW_ORT_STOK_SATIS_MIKTARI>
    <cfset stock_count_ = listlen(listdeleteduplicates(valuelist(get_stocks.STOCK_ID)))>
    <cfset last_cat_id_ = product_catid>
    
    <cfset liste_fiyati_kdvli_ = wrk_round(LISTE_FIYATI)>
    <cfset liste_fiyati_ = wrk_round(liste_fiyati_kdvli_ / ((100 + get_products.tax_purchase) / 100))>
    
    <cfset unit_price = liste_fiyati / UNIT_MUTP>
    
    <cfsavecontent variable="sub_rows_count_">
		<cfif stock_count_ eq 1 and dept_count_ eq 1>
            0
        <cfelseif  stock_count_ eq 1 and dept_count_ gt 1>
            #dept_count_#
        <cfelseif stock_count_ gt 1 and dept_count_ gt 1>
            #stock_count_ + (stock_count_ * dept_count_)#
        <cfelse>
            #stock_count_#
        </cfif>
    </cfsavecontent>
    <cfif dept_count_ eq 1 and stock_count_ eq 1 and sub_rows_count_ eq 0  and urun_stock_sayisi gt 1
		and (
			(isdefined("attributes.order_id") and len(attributes.order_id))
			or
			(isdefined("attributes.order_stock_list") and listlen(attributes.order_stock_list))
			)
		>
		<cfset sub_rows_count_ = 1>
    </cfif>
    
    <cfset siparis_miktari_p = 0>
    <cfset siparis_miktari_p2 = 0>
    
    <cfif stock_count_ eq 1 and dept_count_ eq 1 and sub_rows_count_ eq 0>
		<cfset old_deger_ = "">
        <cfset siparis_miktari_p = 0>
        <cfif isdefined("attributes.calc_type") and attributes.calc_type eq 1>
            <cfif not len(ROW_ORT_STOK_SATIS_MIKTARI)>
                <cfset siparis_miktari_p = 0>
            <cfelse>
                <cfset siparis_miktari_p = Ceiling(ROW_ORT_STOK_SATIS_MIKTARI * attributes.order_day)>
                
                <cfif isdefined("attributes.real_stock") and row_stock gt 0>
                    <cfset siparis_miktari_p = siparis_miktari_p - row_stock>
                </cfif>		
                <cfif isdefined("attributes.way_stock")>
                    <cfset siparis_miktari_p = siparis_miktari_p - PURCHASE_ORDER_QUANTITY> 
                </cfif>
                
                <cfif siparis_miktari_p lt 0>
					<cfset siparis_miktari_p = 0>
                </cfif> 
            </cfif>
            
        </cfif>
    </cfif>
    
    <cfif stock_count_ eq 1 and dept_count_ eq 1 and sub_rows_count_ eq 0>
		<cfset old_deger_ = "">
        <cfset siparis_miktari_p2 = 0>
        <cfif isdefined("attributes.calc_type") and attributes.calc_type eq 1>
            <cfif not len(ROW_ORT_STOK_SATIS_MIKTARI)>
                <cfset siparis_miktari_p2 = 0>
            <cfelse>
                <cfif not len(attributes.order2_day)>
                    <cfset attributes.order2_day = 15>
                </cfif>
                <cfset siparis_miktari_p2 = ROW_ORT_STOK_SATIS_MIKTARI * attributes.order2_day>
                <cfset siparis_miktari_p2 = siparis_miktari_p2 - PURCHASE_ORDER_QUANTITY2 - siparis_miktari_p>
                
                <cfif isdefined("attributes.real_stock") and row_stock gt 0>
					<cfset siparis_miktari_p2 = siparis_miktari_p2 - row_stock>
                </cfif>
                <cfif isdefined("attributes.way_stock")>
                    <cfset siparis_miktari_p2 = siparis_miktari_p2 - PURCHASE_ORDER_QUANTITY>                            
                </cfif>
                
                <cfif siparis_miktari_p gte 0 and attributes.order_day eq attributes.order2_day>
                	<cfset siparis_miktari_p2  = 0>
                </cfif>
                  
                <cfif siparis_miktari_p2 lt 0>
                    <cfset siparis_miktari_p2 = 0>
                </cfif>
            </cfif>
        </cfif>
   </cfif>
    
    <cfif isdefined("get_table_info.product_price_change_count_#product_id#")>
		<cfset product_price_change_count_ = evaluate("get_table_info.product_price_change_count_#product_id#")>
    <cfelse>
        <cfset product_price_change_count_ = 0>
    </cfif>
    
    <cfif isdefined("get_table_info.product_price_change_detail_#product_id#")>
		<cfset product_price_change_detail_ = evaluate("get_table_info.product_price_change_detail_#product_id#")>
    <cfelse>
        <cfset product_price_change_detail_ = "">
    </cfif>
    
    <cfset p_type_ = 0>
	<cfif len(OZEL_PRICE_TYPE)>
        <cfset p_type_ = OZEL_PRICE_TYPE>
    </cfif>
    
    <cfif isdefined("get_table_info.standart_alis_#code_#")>
		<cfset standart_alis_ = evaluate("get_table_info.standart_alis_#code_#")>
    <cfelse>
        <cfset standart_alis_ = wrk_round(price_standart)>
    </cfif>
    
    
    <cfif isdefined("get_table_info.standart_alis_kdvli_#code_#")>
		<cfset standart_alis_kdvli_ = evaluate("get_table_info.standart_alis_kdvli_#code_#")>
    <cfelse>
        <cfset standart_alis_kdvli_ = wrk_round(price_standart_kdv)>
    </cfif>
	
    <cfif not len(standart_alis_kdvli_)>
    	<cfset standart_alis_kdvli_ = 0>
    </cfif>
    
    
    <cfif isdefined("get_table_info.standart_alis_liste_#code_#")>
		<cfset standart_alis_liste_ = evaluate("get_table_info.standart_alis_liste_#code_#")>
    <cfelse>
        <cfset standart_alis_liste_ = wrk_round(standart_alis_kdvli_ / ((100 + get_products.tax_purchase) / 100))>
    </cfif>
    
    
    
    <cfset new_alis_kdv = wrk_round(price_standart_kdv)>
    
    <cfset alistan_maliyetli_marjli_fiyat_ = wrk_round(SON_MALIYET+SON_MALIYET*(MAX_MARGIN_DEGER/100),session.ep.our_company_info.purchase_price_round_num)>
    
    <cfset p_name_ = replace(product_name,'&','','all')>
    
    <cfif stock_count_ eq 1>
    	<cfset p_name_ = replace(property,'&','','all')>
    </cfif>
    
	<cfif stock_count_ eq 1 and dept_count_ eq 1>
		<cfif department_id eq merkez_depo_id>
        	<cfif URUN_STOCK gt 0 and ROW_ORT_STOK_SATIS_MIKTARI gt 0>
                <cfset stockta_yeterlilik_suresi = wrk_round(URUN_STOCK / ortalama_satis.total_stock)>
            <cfelse>
                <cfset stockta_yeterlilik_suresi = 0>
            </cfif>
        <cfelse>
        	<cfif row_stock gt 0 and ROW_ORT_STOK_SATIS_MIKTARI gt 0>
                <cfset stockta_yeterlilik_suresi = wrk_round(row_stock / ROW_ORT_STOK_SATIS_MIKTARI)>
            <cfelse>
                <cfset stockta_yeterlilik_suresi = 0>
            </cfif>
       </cfif>
    <cfelse>
    	<cfif URUN_STOCK gt 0 and ortalama_satis.total_stock gt 0>
            <cfset stockta_yeterlilik_suresi = wrk_round(URUN_STOCK / ortalama_satis.total_stock)>
        <cfelse>
            <cfset stockta_yeterlilik_suresi = 0>
        </cfif>
    </cfif>
    
    <cfif stock_count_ eq 1 and dept_count_ eq 1>
    	<cfif ROW_SIPARISLER gt 0 and ROW_ORT_STOK_SATIS_MIKTARI gt 0>
			<cfset stockta_yeterlilik_suresi_order = wrk_round(ROW_SIPARISLER / ROW_ORT_STOK_SATIS_MIKTARI)>
        <cfelse>
        	<cfset stockta_yeterlilik_suresi_order = 0>
        </cfif>
	<cfelse>
    	<cfif toplam_siparis.total gt 0 and ortalama_satis.total_stock gt 0>
            <cfset stockta_yeterlilik_suresi_order = wrk_round(toplam_siparis.total / ortalama_satis.total_stock)>
        <cfelse>
            <cfset stockta_yeterlilik_suresi_order = 0>
        </cfif>
    </cfif>
    <cfif PRODUCT_TOTAL_STOCK gt 0>
        <cfset genel_stok_tutar = (PRODUCT_TOTAL_STOCK * LISTE_FIYATI)>
    <cfelse>
        <cfset genel_stok_tutar = 0>
    </cfif>

    <cfset gun_total = wrk_round((P_DUEDAY + add_stock_gun_) - stockta_yeterlilik_suresi)>
    
    <cfset group_miktar_total = group_miktar_total + genel_stok_tutar>
    <cfset group_tutar_total = group_tutar_total + gun_total>
    
    <cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_#product_id#") and len(evaluate("get_table_info.STOCK_SATIS_AMOUNT_#product_id#")) and (not isdefined("attributes.calc_type") or listfind('0,3',attributes.calc_type))>
		<cfset sip_1_miktar = evaluate("get_table_info.STOCK_SATIS_AMOUNT_#product_id#")>
    <cfelseif stock_count_ eq 1 and dept_count_ eq 1 and sub_rows_count_ eq 0>
        <cfset sip_1_miktar = siparis_miktari_p>
    <cfelse>
        <cfset sip_1_miktar = 0>
    </cfif>
    
    <cfif len(attributes.order_code) or len(attributes.order_id) or len(attributes.order_company_code)>
		<cfif stock_count_ eq 1 and dept_count_ eq 1 and sub_rows_count_ eq 0>
            <cfif isdefined("attributes.order_siparis_miktari_1_#product_id#_#department_id#")>
                <cfset sip_1_miktar = evaluate("attributes.order_siparis_miktari_1_#product_id#_#department_id#")>
            <cfelse>
            	<cfset sip_1_miktar = 0>
            </cfif>
        <cfelse>
        	<cfset sip_1_miktar = 0>
        </cfif>
    </cfif>
    

    <cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_KOLI_#product_id#") and len(evaluate("get_table_info.STOCK_SATIS_AMOUNT_KOLI_#product_id#")) and (not isdefined("attributes.calc_type") or listfind('0,3',attributes.calc_type))>
		<cfset siparis_miktar_k = evaluate("get_table_info.STOCK_SATIS_AMOUNT_KOLI_#product_id#")>
    <cfelseif stock_count_ eq 1 and dept_count_ eq 1 and sub_rows_count_ eq 0 and len(multiplier) and multiplier gt 0>
        <cfset siparis_miktar_k = sip_1_miktar / multiplier>
    <cfelse>
        <cfset siparis_miktar_k = "0">
    </cfif>
    
    
    
    <cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_PALET_#product_id#") and len(evaluate("get_table_info.STOCK_SATIS_AMOUNT_PALET_#product_id#")) and (not isdefined("attributes.calc_type") or listfind('0,3',attributes.calc_type))>
		<cfset siparis_miktar_p = evaluate("get_table_info.STOCK_SATIS_AMOUNT_PALET_#product_id#")>
    <cfelseif stock_count_ eq 1 and dept_count_ eq 1 and sub_rows_count_ eq 0 and len(P_MULTIPLIER)>
        <cfset siparis_miktar_p = filternum(sip_1_miktar) / P_MULTIPLIER>
    <cfelse>
        <cfset siparis_miktar_p = "0">
    </cfif>
    
    <cfset siparis_tutar_1 = tlformat(liste_fiyati_ * sip_1_miktar)>
    <cfset siparis_tutar_kdv_1 = tlformat(liste_fiyati_kdvli_ * sip_1_miktar)>
    
    <cfif isdefined("get_table_info.order_date_1_#product_id#") and (not isdefined("attributes.calc_type")  or listfind('0,3',attributes.calc_type))>
		<cfset siparis_tarih_1 = evaluate("get_table_info.order_date_1_#product_id#")>
    <cfelseif isdefined("attributes.order_order_date1_#product_id#")>
    	<cfset siparis_tarih_1 = evaluate("attributes.order_order_date1_#product_id#")>
    <cfelse>
        <cfset siparis_tarih_1 = dateformat(now(),'dd/MM/yyyy')>
    </cfif>
    
    <!--- 2.siparis --->
    <cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_2_#product_id#") and len(evaluate("get_table_info.STOCK_SATIS_AMOUNT_2_#product_id#")) and (not isdefined("attributes.calc_type")  or listfind('0,3',attributes.calc_type))>
		<cfset sip_2_miktar = evaluate("get_table_info.STOCK_SATIS_AMOUNT_2_#product_id#")>
    <cfelseif stock_count_ eq 1 and dept_count_ eq 1 and sub_rows_count_ eq 0>
        <cfset sip_2_miktar = siparis_miktari_p2>
    <cfelse>
        <cfset sip_2_miktar = "0">
    </cfif>
    <cfif len(attributes.order_code) or len(attributes.order_id) or len(attributes.order_company_code)>
		<cfif stock_count_ eq 1 and dept_count_ eq 1 and sub_rows_count_ eq 0>
            <cfif isdefined("attributes.order_siparis_miktari_2_#product_id#_#department_id#")>
                <cfset sip_2_miktar = evaluate("attributes.order_siparis_miktari_2_#product_id#_#department_id#")>
            <cfelse>
            	<cfset sip_2_miktar = 0>
            </cfif>
        <cfelse>
        	<cfset sip_2_miktar = 0>
        </cfif>
    </cfif>
    
    <cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_KOLI_2_#product_id#") and len(evaluate("get_table_info.STOCK_SATIS_AMOUNT_KOLI_2_#product_id#")) and (not isdefined("attributes.calc_type") or listfind('0,3',attributes.calc_type))>
		<cfset siparis_miktar_k_2 = evaluate("get_table_info.STOCK_SATIS_AMOUNT_KOLI_2_#product_id#")>
    <cfelseif stock_count_ eq 1 and dept_count_ eq 1 and sub_rows_count_ eq 0 and len(multiplier) and multiplier gt 0>
        <cfset siparis_miktar_k_2 = sip_2_miktar / multiplier>
    <cfelse>
        <cfset siparis_miktar_k_2 = "0">
    </cfif>
    
    <cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_PALET_2_#product_id#") and len(evaluate("get_table_info.STOCK_SATIS_AMOUNT_PALET_2_#product_id#")) and (not isdefined("attributes.calc_type") or listfind('0,3',attributes.calc_type))>
		<cfset siparis_miktar_p_2 = evaluate("get_table_info.STOCK_SATIS_AMOUNT_PALET_2_#product_id#")>
    <cfelseif stock_count_ eq 1 and dept_count_ eq 1 and sub_rows_count_ eq 0 and len(P_MULTIPLIER)>
        <cfset siparis_miktar_p_2 = sip_2_miktar / P_MULTIPLIER>
    <cfelse>
        <cfset siparis_miktar_p_2 = "0">
    </cfif>
    
    <cfset siparis_tutar_2 = tlformat(liste_fiyati_ * sip_2_miktar)>
    <cfset siparis_tutar_kdv_2 = tlformat(liste_fiyati_kdvli_ * sip_2_miktar)>
    
    <cfif isdefined("get_table_info.order_date_2_#product_id#") and (not isdefined("attributes.calc_type")  or listfind('0,3',attributes.calc_type))>
		<cfset siparis_tarih_2 = evaluate("get_table_info.order_date_2_#product_id#")>
    <cfelseif isdefined("attributes.order_order_date2_#product_id#")>
    	<cfset siparis_tarih_2 = evaluate("attributes.order_order_date2_#product_id#")>
    <cfelse>
        <cfset siparis_tarih_2 = dateformat(dateadd('d',15,now()),'dd/MM/yyyy')>
    </cfif>
    <!--- 2.siparis --->
    
    <cfif isdefined("get_table_info.standart_satis_#code_#")>
		<cfset standart_satis = evaluate("get_table_info.standart_satis_#code_#")>
    <cfelse>
        <cfset standart_satis = STANDART_SALE_PRICE>
    </cfif>
    
    <cfif isdefined("get_table_info.standart_satis_kdv_#code_#")>
		<cfset standart_satis_kdv = evaluate("get_table_info.standart_satis_kdv_#code_#")>
    <cfelse>
        <cfset standart_satis_kdv = STANDART_SALE_PRICE_KDV>
    </cfif>
    
    <cfif isdefined("get_table_info.standart_alis_indirim_tutar_#code_#") and len(evaluate("get_table_info.standart_alis_indirim_tutar_#code_#"))>
		<cfset standart_alis_indirim_tutar = evaluate("get_table_info.standart_alis_indirim_tutar_#code_#")>
    <cfelse>
        <cfset standart_alis_indirim_tutar = "0">
    </cfif>
    
   	<cfif isdefined("get_table_info.standart_alis_indirim_yuzde_#code_#")>
		<cfset standart_alis_indirim_yuzde = evaluate("get_table_info.standart_alis_indirim_yuzde_#code_#")>
    <cfelse>
        <cfset standart_alis_indirim_yuzde = "">
    </cfif>
    
    <cfif isdefined("get_table_info.standart_alis_baslangic_#code_#")>
		<cfset standart_alis_baslangic = evaluate("get_table_info.standart_alis_baslangic_#code_#")>
    <cfelse>
        <cfset standart_alis_baslangic = "">
    </cfif>
    <cfif standart_alis_baslangic contains 'T'>
    	<cfset standart_alis_baslangic = left(listgetat(standart_alis_baslangic,3,'-'),2) & '/' & listgetat(standart_alis_baslangic,2,'-') & '/' & listgetat(standart_alis_baslangic,1,'-')>
    </cfif>
    
    
    <cfif isdefined("get_table_info.standart_satis_baslangic_#code_#")>
		<cfset standart_satis_baslangic = evaluate("get_table_info.standart_satis_baslangic_#code_#")>
    <cfelse>
        <cfset standart_satis_baslangic = "">
    </cfif>
    <cfif standart_satis_baslangic contains 'T'>
    	<cfset standart_satis_baslangic = left(listgetat(standart_satis_baslangic,3,'-'),2) & '/' & listgetat(standart_satis_baslangic,2,'-') & '/' & listgetat(standart_satis_baslangic,1,'-')>
    </cfif>

    <cfif isdefined("get_table_info.standart_satis_kar_#code_#")>
		<cfset standart_satis_kar = evaluate("get_table_info.standart_satis_kar_#code_#")>
    <cfelse>
        <cfif not (isnumeric(price_standart_kdv) and isnumeric(STANDART_SALE_PRICE_KDV))>
            <cfset standart_satis_kar = 0>
        <cfelse>
			<cfif STANDART_SALE_PRICE_KDV gt 0>
				<cfset standart_satis_kar = wrk_round(100 - (wrk_round(price_standart_kdv / STANDART_SALE_PRICE_KDV * 100)),2)>
            <cfelse>
            	<cfset standart_satis_kar = 0>
            </cfif>
        </cfif>
    </cfif>
    
    <cfif isnumeric(standart_alis_liste_) and isnumeric(standart_satis_kdv) and standart_satis_kdv gt 0 and standart_alis_liste_ gt 0>
		<cfset kar_icin_alis = wrk_round(standart_alis_liste_ * ((100 + get_products.tax) /100))>
        <cfset standart_satis_kar = wrk_round(100 - (kar_icin_alis / standart_satis_kdv * 100),2)>
   	<cfelse>
    	<cfset standart_satis_kar = 0>
    </cfif>
    
    
    <cfif isdefined("get_table_info.standart_alis_kar_#code_#")>
		<cfset standart_alis_kar = evaluate("get_table_info.standart_alis_kar_#code_#")>
    <cfelseif len(standart_satis_kar) and isnumeric(standart_satis_kar) and standart_satis_kar eq 100>
    	<cfset standart_alis_kar = standart_satis_kar>
    <cfelseif len(standart_satis_kar) and isnumeric(standart_satis_kar) and standart_satis_kar neq 100>
    	<cfset standart_alis_kar = wrk_round(standart_satis_kar / (100 - standart_satis_kar) * 100,2)>
    <cfelse>
        <cfset standart_alis_kar = p_profit>
    </cfif>
    
    <cfif isdefined("get_table_info.standart_satis_oran_#code_#") and len(evaluate("get_table_info.standart_satis_oran_#code_#")) and evaluate("get_table_info.standart_satis_oran_#code_#") is not 'null'>
		<cfset standart_satis_oran = evaluate("get_table_info.standart_satis_oran_#code_#")>
    <cfelse>
        <cfset standart_satis_oran = "0">
    </cfif>
    
    <cfif isdefined("get_table_info.standart_alis_oran_#code_#") and len(evaluate("get_table_info.standart_alis_oran_#code_#")) and evaluate("get_table_info.standart_alis_oran_#code_#") is not 'null'>
		<cfset standart_alis_oran = evaluate("get_table_info.standart_alis_oran_#code_#")>
    <cfelse>
        <cfset standart_alis_oran = "0">
    </cfif>
    
    <cfset urun_ort_satis = ortalama_satis_tutar.TOTAL_SALE>
	<cfif ort_liste_satis_tutar gt 0>
        <cfset total_urun_ort_satis = wrk_round(urun_ort_satis / ort_liste_satis_tutar * 100,2)>
        <!---<cfset total_urun_ort_satis = urun_ort_satis>--->
    <cfelse>
        <cfset total_urun_ort_satis = 0>
    </cfif>
    
    <cfif isdefined("get_table_info.company_name_#code_#")>
		<cfset company_name = evaluate("get_table_info.company_name_#code_#")>
    <cfelse>
        <cfset company_name = NICKNAME>
        <cfif len(project)>
            <cfset company_name = company_name & ' - ' & project>
        </cfif>
    </cfif>
    
    <cfif isdefined("attributes.order_company_#product_id#")>
    	<cfset company_name = evaluate("attributes.order_company_#product_id#")>
    </cfif>
	
    <cfif isdefined("get_table_info.company_code_#code_#")>
		<cfset comp_code_ = evaluate("get_table_info.company_code_#code_#")>
    <cfelse>
        <cfset comp_code_ = COMPANY_CODE>
    </cfif>
    
    <cfif isdefined("attributes.order_company_code_#product_id#")>
    	<cfset comp_code_ = evaluate("attributes.order_company_code_#product_id#")>
    </cfif>
    
    <cfset company_name_ = company_name>
    <cfset company_name_ = replace(company_name_,'&','','all')>
    
    
	<cfset p_startdate = "">
    <cfset p_finishdate = "">
	<cfset startdate = "">
    <cfset finishdate = "">
    
    <cfset new_alis_start = standart_alis_>
    <cfset new_alis = price_standart>
    <cfset new_alis_kdvli = price_standart_kdv>
    
    <cfif len(standart_alis_indirim_tutar)>
		<cfset p_discount_manuel = standart_alis_indirim_tutar>
    <cfelse>
    	<cfset p_discount_manuel = 0>
    </cfif>
    
    <cfset sales_discount = standart_alis_indirim_yuzde>
    <cfset is_active_s = "false">
    <cfset is_active_p = "false">
    <cfset alis_kar = p_profit>
    <cfset p_ss_marj = s_profit>
    <cfset price_departments = "">
    
    <cfif not len(p_ss_marj)>
    	<cfset p_ss_marj = 20>
    </cfif>
    
    <cfif not len(alis_kar)>
    	<cfset alis_kar = 20>
    </cfif>

    <cfset first_satis_price = wrk_round(standart_sale_price,2)>
    <cfset first_satis_price_kdv = standart_sale_price_kdv>
    <cfset satis_standart_satis_oran = 0>
    <cfset avantaj_oran = 0>
    <cfset lastrowid = "0">
    
    <cfset p_product_type_ = 1>
    
	<cfif isdefined("get_price_rows")>
    	<cfquery name="get_row_price" dbtype="query" maxrows="1">
        	SELECT * FROM get_price_rows WHERE PRODUCT_ID = #product_id# ORDER BY FINISHDATE DESC
        </cfquery>
        <cfif get_row_price.recordcount>
        	<cfset lastrowid = get_row_price.row_id>
            <cfset p_startdate = dateformat(get_row_price.p_startdate,'dd/MM/yyyy')>
			<cfset p_finishdate = dateformat(get_row_price.p_finishdate,'dd/MM/yyyy')>
            <cfset startdate = dateformat(get_row_price.startdate,'dd/MM/yyyy')>
            <cfset finishdate = dateformat(get_row_price.finishdate,'dd/MM/yyyy')>
            <cfset p_type_ = get_row_price.price_type>
            <cfset p_type_id_ = get_row_price.price_type>
            <cfset p_discount_manuel = get_row_price.manuel_discount>
            <cfset sales_discount = "">
            
            <cfset new_alis_start = get_row_price.brut_alis>
			<cfset new_alis = get_row_price.new_alis>
            <cfset new_alis_kdvli = get_row_price.new_alis_kdv>
            
            <cfif get_row_price.is_active_s eq 1><cfset is_active_s = "true"></cfif>
			<cfif get_row_price.is_active_p eq 1><cfset is_active_p = "true"></cfif>
            
            <cfset alis_kar = get_row_price.p_margin>
            <cfset p_ss_marj = get_row_price.margin>
            
            <cfset kar_ = 100 - (wrk_round(get_row_price.new_alis_kdv / get_row_price.new_price_kdv * 100))>
			<cfset kar_ = wrk_round(kar_,2)>
            <cfset p_ss_marj = kar_>
            
            <cfset first_satis_price = get_row_price.new_price>
			<cfset first_satis_price_kdv = get_row_price.new_price_kdv>
            
            <cfif len(standart_sale_price) and standart_sale_price gt 0>
				<cfset satis_standart_satis_oran = wrk_round(((100 * first_satis_price) / standart_sale_price) - 100)>
            <cfelse>
            	<cfset satis_standart_satis_oran = 0>
            </cfif>
            
            <cfset fiyat_fark = standart_sale_price_kdv - first_satis_price_kdv>
			<cfif len(standart_sale_price_kdv) and standart_sale_price_kdv gt 0>
				<cfset avantaj_oran = wrk_round(fiyat_fark / standart_sale_price_kdv * 100,1)>
            <cfelse>
            	<cfset avantaj_oran = 0>
            </cfif>
            
            <cfif get_row_price.p_product_type eq 1>
            	<cfset p_product_type_ = 1>
            <cfelse>
            	<cfset p_product_type_ = 0>
            </cfif>
            
			<cfloop from="1" to="10" index="ccc">
            	<cfset disc_ = evaluate("get_row_price.discount#ccc#")>
				<cfif len(disc_) and disc_ neq 0 and len(sales_discount)>
                    <cfset sales_discount = "#sales_discount#+#tlformat(disc_)#">
                <cfelseif len(disc_) and disc_ neq 0>
                	<cfset sales_discount = "#tlformat(disc_)#">
                </cfif>
            </cfloop>
            
            <cfquery name="get_row_price_departments" dbtype="query">
                SELECT * FROM get_price_rows_departments WHERE ROW_ID = #lastrowid#
            </cfquery>
            <cfif get_row_price_departments.recordcount>    
            	<cfset price_departments = valuelist(get_row_price_departments.department_id)>
            <cfelse>
            	<cfset price_departments = "">
            </cfif>
        </cfif>
    </cfif>
    
   
    
	<cfset r_number = '0' & round(rand()*100) & '#product_id#00' & dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'#userid_#'&round(rand()*100)>
    
    <cfset query_count = query_count + 1>
	<cfset newRow = QueryAddRow(MyQuery,1)>
    
    <cfset temp = QuerySetCell(myQuery,"id","#r_number#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"price_control","#PRICE_CONTROL#",query_count)>
    
	<cfsavecontent variable="p_color_"><cfif ortalama_satis.total_stock lte min_stock_deger>red<cfelseif ortalama_satis.total_stock lte min_stock_deger_warning>orange</cfif></cfsavecontent>
	<cfset temp = QuerySetCell(myQuery,"product_color","#p_color_#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"product_code","#product_id#_0_0",query_count)>
    <cfset temp = QuerySetCell(myQuery,"product_cat","#product_cat#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"row_type","1",query_count)>
    
    <cfset temp = QuerySetCell(myQuery,"sira_no","#p_count#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"product_name","#p_name_#",query_count)>
    
    <cfsavecontent variable="stock_id_"><cfif stock_count_ eq 1>#stock_id#</cfif></cfsavecontent>
    <cfset temp = QuerySetCell(myQuery,"stock_id","#stock_id_#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"stock_count","#stock_count_#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"product_id","#product_id#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"active_row","true",query_count)>

	<cfset temp = QuerySetCell(myQuery,"list_price","#liste_fiyati_#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"list_price_kdv","#liste_fiyati_kdvli_#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"product_stock_list","#listdeleteduplicates(valuelist(get_stocks.STOCK_ID))#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"p_ss_marj","#p_ss_marj#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"s_profit","#s_profit#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"info_standart_alis","#price_standart#",query_count)>

	<cfif is_purchase eq 1>
		<cfset temp = QuerySetCell(myQuery,"is_purchase","true",query_count)>
    <cfelse>
   		<cfset temp = QuerySetCell(myQuery,"is_purchase","false",query_count)>
    </cfif>
    
    <cfif is_purchase_c eq 1>
		<cfset temp = QuerySetCell(myQuery,"is_purchase_c","true",query_count)>
    <cfelse>
   		<cfset temp = QuerySetCell(myQuery,"is_purchase_c","false",query_count)>
    </cfif>
    
    <cfif is_purchase_m eq 1>
		<cfset temp = QuerySetCell(myQuery,"is_purchase_m","true",query_count)>
    <cfelse>
   		<cfset temp = QuerySetCell(myQuery,"is_purchase_m","false",query_count)>
    </cfif>
    
    <cfif is_sales eq 1>
		<cfset temp = QuerySetCell(myQuery,"is_sales","true",query_count)>
    <cfelse>
   		<cfset temp = QuerySetCell(myQuery,"is_sales","false",query_count)>
    </cfif>

	<cfset temp = QuerySetCell(myQuery,"barcode","#barcod#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"product_code_r","#listlast(product_code,'.')#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"product_price_change_lastrowid","#lastrowid#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"product_price_change_count","#product_price_change_count_#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"product_price_change_detail","#product_price_change_detail_#",query_count)>

	<cfif p_type_ neq 0>
		<cfset temp = QuerySetCell(myQuery,"price_type","#p_type_#",query_count)>
    <cfelse>
   		<cfset temp = QuerySetCell(myQuery,"price_type","",query_count)>
    </cfif>
    
    <cfif p_type_ neq 0>
		<cfset temp = QuerySetCell(myQuery,"price_type_id","#p_type_#",query_count)>
    <cfelse>
   		<cfset temp = QuerySetCell(myQuery,"price_type_id","",query_count)>
    </cfif>

	<cfset temp = QuerySetCell(myQuery,"standart_alis","#standart_alis_#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"standart_alis_liste","#standart_alis_liste_#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"standart_alis_kdv","#get_products.tax_purchase#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"standart_alis_kdvli","#standart_alis_kdvli_#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"c_standart_alis_kdvli","#standart_alis_kdvli_#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"p_discount_manuel","#p_discount_manuel#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"new_alis_start","#new_alis_start#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"new_alis","#new_alis#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"new_alis_kdvli","#new_alis_kdvli#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"c_new_alis_kdvli","#new_alis_kdvli#",query_count)>

	<cfset temp = QuerySetCell(myQuery,"is_active_p","#is_active_p#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"p_startdate","#p_startdate#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"p_finishdate","#p_finishdate#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"first_satis_price","#first_satis_price#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"c_first_satis_price","#first_satis_price#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"is_active_s","#is_active_s#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"avantaj_oran","#avantaj_oran#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"first_satis_price_kdv","#first_satis_price_kdv#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"alistan_maliyetli_marjli_fiyat","#alistan_maliyetli_marjli_fiyat_#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"sales_discount","#sales_discount#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"avg_rival","#avg_rival#",query_count)>

	
    <cfset temp = QuerySetCell(myQuery,"ortalama_satis_gunu","#ortalama_satis.total_stock#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"stok_yeterlilik_suresi","#stockta_yeterlilik_suresi#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"stok_yeterlilik_suresi_order","#stockta_yeterlilik_suresi_order#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"genel_stok_tutar","#genel_stok_tutar#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"dueday","#P_DUEDAY#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"add_stock_gun","#add_stock_gun_#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"gun_total","#gun_total#",query_count)>
    
    <cfif stock_count_ eq 1 and dept_count_ eq 1 and sub_rows_count_ eq 0>
    	<cfset temp = QuerySetCell(myQuery,"stok_devir_hizi","#ROW_STOK_DEVIR_HIZI#",query_count)> 
    <cfelse>
    	<cfset temp = QuerySetCell(myQuery,"stok_devir_hizi","",query_count)> 
    </cfif>
    
    <cfset temp = QuerySetCell(myQuery,"urun_stok","#URUN_STOCK#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"depo_stok","#DEPO_STOCK#",query_count)>
    	
	<cfif attributes.search_department_id eq merkez_depo_id>
    	<cfset temp = QuerySetCell(myQuery,"magaza_stok","#MAGAZA_STOK#",query_count)>
    <cfelse>
		<cfset temp = QuerySetCell(myQuery,"magaza_stok","#ROW_STOCK_MAGAZALAR#",query_count)>
    </cfif>
    <cfset temp = QuerySetCell(myQuery,"yoldaki_stok","#yoldaki_stok#",query_count)>

	<cfsavecontent variable="oneri_siparis_">
    	<cfif stock_count_ eq 1 and dept_count_ eq 1 and sub_rows_count_ eq 0>
			<cfif isdefined("attributes.calc_type") and attributes.calc_type eq 1>
                #siparis_miktari_p#
            </cfif>
       	</cfif>
    </cfsavecontent>
    <cfif len(trim(oneri_siparis_))>
    	<cfset temp = QuerySetCell(myQuery,"oneri_siparis","#oneri_siparis_#",query_count)>
    <cfelse>
		<cfset temp = QuerySetCell(myQuery,"oneri_siparis","0",query_count)>
	</cfif>

	<cfsavecontent variable="oneri_siparis2_">
		<cfif stock_count_ eq 1 and dept_count_ eq 1 and sub_rows_count_ eq 0>
			<cfif isdefined("attributes.calc_type") and attributes.calc_type eq 1>
                #siparis_miktari_p2#
            </cfif>
        </cfif>
    </cfsavecontent>
    <cfif len(trim(oneri_siparis2_))>
    	<cfset temp = QuerySetCell(myQuery,"oneri_siparis2","#oneri_siparis2_#",query_count)>
    <cfelse>
		<cfset temp = QuerySetCell(myQuery,"oneri_siparis2","0",query_count)>
	</cfif>
    
	<cfset temp = QuerySetCell(myQuery,"carpan","#multiplier#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"carpan2","#P_MULTIPLIER#",query_count)>
    
    <cfsavecontent variable="siparis_onay_"><cfif stock_count_ eq 1 and dept_count_ eq 1 and sub_rows_count_ eq 0><cfif isdefined("attributes.calc_type") and attributes.calc_type eq 1 and siparis_miktari_p gt 0>false<cfelse>false</cfif><cfelse>false</cfif></cfsavecontent>
	<cfset temp = QuerySetCell(myQuery,"siparis_onay","#siparis_onay_#",query_count)>
        
    <cfif (len(attributes.order_code) or len(attributes.order_id) or len(attributes.order_company_code)) and sip_1_miktar gt 0>
    	<cfset temp = QuerySetCell(myQuery,"siparis_onay","1",query_count)>
    </cfif>
    
    <cfif (len(attributes.order_code) or len(attributes.order_id) or len(attributes.order_company_code)) and sip_1_miktar gt 0 and isdefined('attributes.order_siparis_sevk_1_#product_id#_#department_id#') and evaluate('attributes.order_siparis_sevk_1_#product_id#_#department_id#')>
    	<cfset temp = QuerySetCell(myQuery,"siparis_sevk","1",query_count)>
    <cfelse>
    	<cfset temp = QuerySetCell(myQuery,"siparis_sevk","0",query_count)>
    </cfif>

	<cfset temp = QuerySetCell(myQuery,"siparis_miktar","#sip_1_miktar#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"siparis_miktar_k","#siparis_miktar_k#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"siparis_miktar_p","#siparis_miktar_p#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"siparis_tutar_1","#siparis_tutar_1#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"siparis_tutar_kdv_1","#siparis_tutar_kdv_1#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"siparis_tarih_1","#siparis_tarih_1#",query_count)>
    
    <cfsavecontent variable="siparis_onay_2_"><cfif stock_count_ eq 1 and dept_count_ eq 1 and sub_rows_count_ eq 0><cfif isdefined("attributes.calc_type") and attributes.calc_type eq 1 and siparis_miktari_p2 gt 0>false<cfelse>false</cfif><cfelse>false</cfif></cfsavecontent>
    <cfset temp = QuerySetCell(myQuery,"siparis_onay_2","#siparis_onay_2_#",query_count)>
    
    <cfif (len(attributes.order_code) or len(attributes.order_id) or len(attributes.order_company_code)) and sip_2_miktar gt 0>
		<cfset temp = QuerySetCell(myQuery,"siparis_onay_2","1",query_count)>
    </cfif>
    
    <cfif (len(attributes.order_code) or len(attributes.order_id) or len(attributes.order_company_code)) and sip_2_miktar gt 0 and isdefined('attributes.order_siparis_sevk_2_#product_id#_#department_id#') and evaluate('attributes.order_siparis_sevk_2_#product_id#_#department_id#')>
    	<cfset temp = QuerySetCell(myQuery,"siparis_sevk_2","true",query_count)>
    <cfelse>
    	<cfset temp = QuerySetCell(myQuery,"siparis_sevk_2","false",query_count)>
    </cfif>

    <cfset temp = QuerySetCell(myQuery,"siparis_miktar_2","#sip_2_miktar#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"siparis_miktar_k_2","#siparis_miktar_k_2#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"siparis_miktar_p_2","#siparis_miktar_p_2#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"siparis_tutar_2","#siparis_tutar_2#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"siparis_tutar_kdv_2","#siparis_tutar_kdv_2#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"siparis_tarih_2","#siparis_tarih_2#",query_count)>

	<cfset temp = QuerySetCell(myQuery,"company_code","#comp_code_#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"company_name","#company_name_#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"startdate","#startdate#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"finishdate","#finishdate#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"satis_kdv","#get_products.tax#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"standart_satis","#standart_satis#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"c_standart_satis","#standart_satis#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"c_standart_satis_kdv","#standart_satis_kdv#",query_count)>

	<cfset temp = QuerySetCell(myQuery,"standart_satis_kdv","#standart_satis_kdv#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"c_is_standart_satis_aktif","false",query_count)>
    <cfset temp = QuerySetCell(myQuery,"is_standart_satis_aktif","false",query_count)>
    <cfset temp = QuerySetCell(myQuery,"maliyet","#SON_MALIYET#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"satis_standart_satis_oran","#satis_standart_satis_oran#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"stok_dagitim","",query_count)>
    <cfset temp = QuerySetCell(myQuery,"seviye_bilgisi","#maximum_stock#-#order_limit#-#minimum_stock#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"standart_alis_indirim_tutar","#standart_alis_indirim_tutar#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"standart_alis_indirim_yuzde","#standart_alis_indirim_yuzde#",query_count)>
    
    <cfset temp = QuerySetCell(myQuery,"standart_alis_baslangic","#standart_alis_baslangic#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"standart_satis_baslangic","#standart_satis_baslangic#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"alis_kar","#alis_kar#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"standart_alis_kar","#standart_alis_kar#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"standart_satis_kar","#standart_satis_kar#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"standart_satis_oran","#standart_satis_oran#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"standart_alis_oran","#standart_alis_oran#",query_count)>
    
    <cfset temp = QuerySetCell(myQuery,"eski_standart_alis_kdvli","#wrk_round(price_standart_kdv,2)#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"eski_standart_satis_kdvli","#wrk_round(STANDART_SALE_PRICE_KDV,2)#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"eski_kar","#wrk_round(0)#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"liste_oran","#wrk_round(total_urun_ort_satis,2)#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"donem_satis","",query_count)>
    <cfset temp = QuerySetCell(myQuery,"donem_satis_tutar","",query_count)>
    <cfset temp = QuerySetCell(myQuery,"ReportsTo","#product_id#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"p_product_type","#p_product_type_#",query_count)>
   	
    <cfset temp = QuerySetCell(myQuery,"sub_rows_count","#sub_rows_count_#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"product_info","#product_info#",query_count)>
	<cfset temp = QuerySetCell(myQuery,"price_departments","#price_departments#",query_count)>
    
    <cfif len(STD_SON_DURUM)>
		<cfset degisim_ = listfirst(STD_SON_DURUM,'*')>
        <cfset degisim_marj_1 = listlast(STD_SON_DURUM,'*')>
        
        <cfif len(STD_DURUM)>
        	<cfset degisim_marj_2 = listlast(STD_DURUM,'*')>
        <cfelse>
        	<cfset degisim_marj_2 = 0>
        </cfif>
        <cfset degisim_marj = degisim_marj_1 - degisim_marj_2>
    <cfelse>
    	<cfset degisim_ = 0>
        <cfset degisim_marj = 0>
    </cfif>
    
    <cfset temp = QuerySetCell(myQuery,"std_p_control","#degisim_marj#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"unit_price","#unit_price#",query_count)>
    
        <cfset last_stock_id = ''>
        <cfoutput>
        <cfif stock_id neq last_stock_id>
            <cfset last_stock_id = stock_id>
            <cfset merkez_depo_stock_total = 0>
            <cfquery name="get_magaza_stock" dbtype="query">
                SELECT SUM(ROW_STOCK) MAGAZA_STOCK FROM get_products WHERE STOCK_ID = #last_stock_id# AND DEPARTMENT_ID NOT IN (#merkez_depo_id#)
            </cfquery>
            <cfquery name="get_depo_stock" dbtype="query">
                SELECT SUM(ROW_STOCK) DEPO_STOCK FROM get_products WHERE STOCK_ID = #last_stock_id# AND DEPARTMENT_ID IN (#merkez_depo_id#)
            </cfquery>
            <cfquery name="get_total_stock" dbtype="query">
                SELECT SUM(ROW_STOCK) TOTAL_STOCK FROM get_products WHERE STOCK_ID = #last_stock_id#
            </cfquery>
            <cfquery name="get_total_yoldaki" dbtype="query">
                SELECT SUM(PURCHASE_ORDER_QUANTITY) TOTAL_STOCK FROM get_products WHERE STOCK_ID = #last_stock_id#
            </cfquery>
            <cfset magaza_stock = get_magaza_stock.MAGAZA_STOCK>
            <cfset depo_stock = get_depo_stock.DEPO_STOCK>
            <cfset product_total_stock = get_total_stock.TOTAL_STOCK>
            <cfset yoldaki_stok = get_total_yoldaki.TOTAL_STOCK>
            <cfif isdefined("attributes.is_hide_one_stocks") and (stock_count_ eq 1 or dept_count_ eq 1)>
                <cfset product_group_info = "p_#product_id#_out">
            <cfelse>
                <cfset product_group_info = 'p_#product_id#'>
            </cfif>
            
            <cfset row_show_ = 1>
            
            <cfif stock_count_ eq 1 or dept_count_ eq 1>
            	<cfset row_show_ = 0>
            </cfif>
            
            <cfset property_ = replace(property,'&','','all')>
            
            <cfif row_show_>
                <cfset r_number = '1' & '#product_id##stock_id#' & dateformat(now(),'YYYYMMDD')& timeformat(now(),'HHmmssL')&'#userid_#'&round(rand()*100)>
                
                <cfset query_count = query_count + 1>
				<cfset newRow = QueryAddRow(MyQuery,1)>
                
                <cfset temp = QuerySetCell(myQuery,"id","#r_number#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"price_control","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"product_color","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"product_code","#product_id#_#stock_id#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"product_cat","#product_cat#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"row_type","2",query_count)>
                <cfset temp = QuerySetCell(myQuery,"sira_no","",query_count)>

				<cfset temp = QuerySetCell(myQuery,"product_name","#property_#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"stock_id","#stock_id#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"stock_count","0",query_count)>
                <cfset temp = QuerySetCell(myQuery,"product_id","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"active_row","true",query_count)>
                <cfset temp = QuerySetCell(myQuery,"list_price","#liste_fiyati_#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"list_price_kdv","#liste_fiyati_kdvli_#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"product_stock_list","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"p_ss_marj","0",query_count)>
                <cfset temp = QuerySetCell(myQuery,"s_profit","0",query_count)>
                <cfset temp = QuerySetCell(myQuery,"info_standart_alis","#price_standart#",query_count)>
                
                <cfif stock_is_purchase eq 1>
					<cfset temp = QuerySetCell(myQuery,"is_purchase","true",query_count)>
                <cfelse>
                    <cfset temp = QuerySetCell(myQuery,"is_purchase","false",query_count)>
                </cfif>
                
                <cfif stock_is_purchase_c eq 1>
                    <cfset temp = QuerySetCell(myQuery,"is_purchase_c","true",query_count)>
                <cfelse>
                    <cfset temp = QuerySetCell(myQuery,"is_purchase_c","false",query_count)>
                </cfif>
                
                <cfif stock_is_purchase_m eq 1>
                    <cfset temp = QuerySetCell(myQuery,"is_purchase_m","true",query_count)>
                <cfelse>
                    <cfset temp = QuerySetCell(myQuery,"is_purchase_m","false",query_count)>
                </cfif>
                
                <cfif stock_is_sales eq 1>
                    <cfset temp = QuerySetCell(myQuery,"is_sales","true",query_count)>
                <cfelse>
                    <cfset temp = QuerySetCell(myQuery,"is_sales","false",query_count)>
                </cfif>
                
                <cfset temp = QuerySetCell(myQuery,"barcode","#S_BARCOD#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"product_code_r","#listlast(STOCK_CODE,'.')#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"product_price_change_lastrowid","0",query_count)>

				<cfset temp = QuerySetCell(myQuery,"product_price_change_count","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"product_price_change_detail","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"price_type","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"standart_alis","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"standart_alis_liste","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"standart_alis_kdv","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"standart_alis_kdvli","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"c_standart_alis_kdvli","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"p_discount_manuel","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"new_alis_start","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"new_alis","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"new_alis_kdvli","",query_count)>
                
                <cfset temp = QuerySetCell(myQuery,"c_new_alis_kdvli","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"is_active_p","false",query_count)>
                <cfset temp = QuerySetCell(myQuery,"p_startdate","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"p_finishdate","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"first_satis_price","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"c_first_satis_price","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"is_active_s","false",query_count)>
                <cfset temp = QuerySetCell(myQuery,"avantaj_oran","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"first_satis_price_kdv","",query_count)>

				<cfset temp = QuerySetCell(myQuery,"alistan_maliyetli_marjli_fiyat","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"sales_discount","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"avg_rival","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"ortalama_satis_gunu","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"stok_yeterlilik_suresi","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"stok_yeterlilik_suresi_order","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"genel_stok_tutar","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"dueday","#P_DUEDAY#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"add_stock_gun","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"gun_total","",query_count)>

				<cfsavecontent variable="stok_devir_hizi_">
                	<cfif stock_count_ eq 1 and dept_count_ eq 1>
                        #wrk_round(ROW_STOK_DEVIR_HIZI)#
                    </cfif>
                </cfsavecontent>
                <cfset temp = QuerySetCell(myQuery,"stok_devir_hizi","#stok_devir_hizi_#",query_count)>

				<cfset temp = QuerySetCell(myQuery,"urun_stok","#ROW_STOCK_GENEL#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"depo_stok","#ROW_STOCK_DEPO#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"magaza_stok","#ROW_STOCK_MAGAZALAR#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"yoldaki_stok","#yoldaki_stok#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"oneri_siparis","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"oneri_siparis2","",query_count)>
				
                <cfset temp = QuerySetCell(myQuery,"carpan","#multiplier#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"carpan2","#P_MULTIPLIER#",query_count)>
                
                <cfset temp = QuerySetCell(myQuery,"siparis_onay","false",query_count)>
                <cfset temp = QuerySetCell(myQuery,"siparis_sevk","false",query_count)>
                <cfset temp = QuerySetCell(myQuery,"siparis_miktar","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"siparis_miktar_k","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"siparis_miktar_p","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"siparis_tutar_1","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"siparis_tutar_kdv_1","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"siparis_tarih_1","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"siparis_onay_2","false",query_count)>
                <cfset temp = QuerySetCell(myQuery,"siparis_sevk_2","false",query_count)>
                <cfset temp = QuerySetCell(myQuery,"siparis_miktar_2","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"siparis_miktar_k_2","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"siparis_miktar_p_2","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"siparis_tutar_2","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"siparis_tutar_kdv_2","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"siparis_tarih_2","",query_count)>

				<cfset temp = QuerySetCell(myQuery,"company_code","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"company_name","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"startdate","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"finishdate","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"satis_kdv","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"standart_satis","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"c_standart_satis","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"c_standart_satis_kdv","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"standart_satis_kdv","",query_count)>
                
                <cfset temp = QuerySetCell(myQuery,"c_is_standart_satis_aktif","false",query_count)>
                <cfset temp = QuerySetCell(myQuery,"is_standart_satis_aktif","false",query_count)>
                <cfset temp = QuerySetCell(myQuery,"maliyet","#SON_MALIYET#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"satis_standart_satis_oran","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"stok_dagitim","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"seviye_bilgisi","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"standart_alis_indirim_tutar","",query_count)>
                
                <cfset temp = QuerySetCell(myQuery,"standart_alis_indirim_yuzde","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"standart_alis_baslangic","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"standart_satis_baslangic","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"alis_kar","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"standart_alis_kar","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"standart_satis_kar","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"standart_satis_oran","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"standart_alis_oran","",query_count)>

				<cfset temp = QuerySetCell(myQuery,"eski_standart_alis_kdvli","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"eski_standart_satis_kdvli","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"eski_kar","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"liste_oran","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"donem_satis","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"donem_satis_tutar","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"ReportsTo","#product_id#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"p_product_type","#p_product_type_#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"sub_rows_count","0",query_count)>
                <cfset temp = QuerySetCell(myQuery,"product_info","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"price_departments","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"std_p_control","0",query_count)>
                <cfset temp = QuerySetCell(myQuery,"unit_price","#unit_price#",query_count)>
            </cfif>
        </cfif>
        
        <cfset row_show_ = 1>

        <cfif dept_count_ eq 1 and stock_count_ eq 1>
        	<cfset row_show_ = 0>
        </cfif>
        
        <cfif dept_count_ eq 1 and stock_count_ eq 1 and row_show_ eq 0 and urun_stock_sayisi gt 1 and 
			(
			(isdefined("attributes.order_id") and len(attributes.order_id))
			or
			(isdefined("attributes.order_stock_list") and listlen(attributes.order_stock_list))
			)
		>
			<cfset row_show_ = 1>
		</cfif>
        	<cfif row_show_ eq 1>
                <cfset r_number = '2' & '#product_id##stock_id##department_id#' & round(rand()*100) & dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'#userid_#'&round(rand()*100)>
                
                <cfset query_count = query_count + 1>
				<cfset newRow = QueryAddRow(MyQuery,1)>
                
                <cfset temp = QuerySetCell(myQuery,"id","#r_number#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"price_control","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"product_color","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"product_code","#product_id#_#stock_id#_#department_id#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"product_cat","#product_cat#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"row_type","3",query_count)>
                <cfset temp = QuerySetCell(myQuery,"sira_no","",query_count)>

				<cfsavecontent variable="product_name_"><cfif dept_count_ eq 1>#property_#<cfelse>#department_head#</cfif></cfsavecontent>
				<cfset temp = QuerySetCell(myQuery,"product_name","#product_name_#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"stock_id","#stock_id#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"stock_count","0",query_count)>
                <cfset temp = QuerySetCell(myQuery,"product_id","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"active_row","true",query_count)>
                <cfset temp = QuerySetCell(myQuery,"list_price","#liste_fiyati_#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"list_price_kdv","#liste_fiyati_kdvli_#",query_count)>
                
                <cfset temp = QuerySetCell(myQuery,"product_stock_list","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"p_ss_marj","0",query_count)>
                <cfset temp = QuerySetCell(myQuery,"s_profit","0",query_count)>
                <cfset temp = QuerySetCell(myQuery,"info_standart_alis","#price_standart#",query_count)>

				<cfif stock_is_purchase eq 1>
					<cfset temp = QuerySetCell(myQuery,"is_purchase","true",query_count)>
                <cfelse>
                    <cfset temp = QuerySetCell(myQuery,"is_purchase","false",query_count)>
                </cfif>
                
                <cfif stock_is_purchase_c eq 1>
                    <cfset temp = QuerySetCell(myQuery,"is_purchase_c","true",query_count)>
                <cfelse>
                    <cfset temp = QuerySetCell(myQuery,"is_purchase_c","false",query_count)>
                </cfif>
                
                <cfif stock_is_purchase_m eq 1>
                    <cfset temp = QuerySetCell(myQuery,"is_purchase_m","true",query_count)>
                <cfelse>
                    <cfset temp = QuerySetCell(myQuery,"is_purchase_m","false",query_count)>
                </cfif>
                
                <cfif stock_is_sales eq 1>
                    <cfset temp = QuerySetCell(myQuery,"is_sales","true",query_count)>
                <cfelse>
                    <cfset temp = QuerySetCell(myQuery,"is_sales","false",query_count)>
                </cfif>
                
                <cfset temp = QuerySetCell(myQuery,"barcode","#S_BARCOD#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"product_code_r","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"product_price_change_lastrowid","0",query_count)>
                <cfset temp = QuerySetCell(myQuery,"product_price_change_count","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"product_price_change_detail","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"price_type","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"standart_alis","",query_count)>
                
                <cfset temp = QuerySetCell(myQuery,"standart_alis_liste","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"standart_alis_kdv","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"standart_alis_kdvli","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"c_standart_alis_kdvli","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"p_discount_manuel","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"new_alis_start","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"new_alis","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"new_alis_kdvli","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"c_new_alis_kdvli","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"is_active_p","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"p_startdate","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"p_finishdate","",query_count)>
                
                <cfset temp = QuerySetCell(myQuery,"first_satis_price","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"c_first_satis_price","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"is_active_s","false",query_count)>
                <cfset temp = QuerySetCell(myQuery,"avantaj_oran","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"first_satis_price_kdv","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"alistan_maliyetli_marjli_fiyat","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"sales_discount","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"avg_rival","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"ortalama_satis_gunu","#ROW_ORT_STOK_SATIS_MIKTARI#",query_count)>

				<cfsavecontent variable="stok_yeterlilik_suresi_"><cfif row_stock gt 0 and ROW_ORT_STOK_SATIS_MIKTARI gt 0>#wrk_round(row_stock / ROW_ORT_STOK_SATIS_MIKTARI)#<cfelse>0</cfif></cfsavecontent>
				<cfsavecontent variable="stok_yeterlilik_suresi_order_"><cfif ROW_SIPARISLER gt 0 and ROW_ORT_STOK_SATIS_MIKTARI gt 0>#wrk_round(ROW_SIPARISLER / ROW_ORT_STOK_SATIS_MIKTARI)#<cfelse>0</cfif></cfsavecontent>
				<cfset temp = QuerySetCell(myQuery,"stok_yeterlilik_suresi","#stok_yeterlilik_suresi_#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"stok_yeterlilik_suresi_order","#stok_yeterlilik_suresi_order_#",query_count)>
				<cfset temp = QuerySetCell(myQuery,"genel_stok_tutar","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"dueday","#P_DUEDAY#",query_count)>
                <cfset temp = QuerySetCell(myQuery,"add_stock_gun","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"gun_total","",query_count)>
                <cfset temp = QuerySetCell(myQuery,"stok_devir_hizi","#wrk_round(ROW_STOK_DEVIR_HIZI)#",query_count)>

				<cfset temp = QuerySetCell(myQuery,"urun_stok","#ROW_STOCK_GENEL#",query_count)>
                
                <cfif department_id eq merkez_depo_id>
                	<cfset temp = QuerySetCell(myQuery,"depo_stok","#ROW_STOCK_DEPO#",query_count)>
                <cfelse>
                	<cfset temp = QuerySetCell(myQuery,"depo_stok","",query_count)>
                </cfif>
                
                <cfif department_id neq merkez_depo_id>
                	<cfset temp = QuerySetCell(myQuery,"magaza_stok","#ROW_STOCK_MAGAZA#",query_count)>
                <cfelse>
                	<cfset temp = QuerySetCell(myQuery,"magaza_stok","",query_count)>
                </cfif>
				<cfset temp = QuerySetCell(myQuery,"yoldaki_stok","#PURCHASE_ORDER_QUANTITY#",query_count)>

                <cfsavecontent variable="oneri_siparis_">
					<cfset old_deger_ = "">
                    <cfset siparis_miktari = 0>
                    <cfif isdefined("attributes.calc_type") and attributes.calc_type eq 1>
                        <cfif not len(ROW_ORT_STOK_SATIS_MIKTARI)>
                            <cfset siparis_miktari = 0>
                        <cfelse>
                            <cfset siparis_miktari = Ceiling(ROW_ORT_STOK_SATIS_MIKTARI * attributes.order_day)>
                            <cfif isdefined("attributes.real_stock") and row_stock gt 0>
                                <cfset siparis_miktari = siparis_miktari - row_stock>
                            </cfif>
                            <cfif isdefined("attributes.way_stock")>
                                <cfset siparis_miktari = siparis_miktari - PURCHASE_ORDER_QUANTITY>                            
                            </cfif>    
                            <cfif siparis_miktari lt 0>
                                <cfset siparis_miktari = 0>
                            </cfif>
                        </cfif>
                        #wrk_round(siparis_miktari)#
                    <cfelse>
                        #wrk_round(old_deger_)#
                    </cfif>
               </cfsavecontent>
               <cfset temp = QuerySetCell(myQuery,"oneri_siparis","#oneri_siparis_#",query_count)>
               
               <cfsavecontent variable="oneri_siparis2_">
                    	<cfif isdefined("get_table_info.lead_order_2_#product_id#_#stock_id#_#department_id#")>
							<cfset old_deger_ = evaluate("get_table_info.lead_order_2_#product_id#_#stock_id#_#department_id#")>
                        <cfelse>
                            <cfset old_deger_ = "">
                        </cfif>
                        <cfset siparis_miktari_2 = 0>
                        <cfif isdefined("attributes.calc_type") and attributes.calc_type eq 1>
                            <cfif not len(ROW_ORT_STOK_SATIS_MIKTARI)>
                                <cfset siparis_miktari_2 = 0>
                            <cfelse>
                                <cfif not len(attributes.order2_day)>
                                    <cfset attributes.order2_day = 15>
                                </cfif>
                                <cfset siparis_miktari_2 = Ceiling(ROW_ORT_STOK_SATIS_MIKTARI * attributes.order2_day)>
                                <cfset siparis_miktari_2 = siparis_miktari_2 - PURCHASE_ORDER_QUANTITY2 - siparis_miktari>
                                <cfif isdefined("attributes.real_stock") and row_stock gt 0>
                                    <cfset siparis_miktari_2 = siparis_miktari_2 - row_stock>
                                </cfif>
                                <cfif isdefined("attributes.way_stock")>
                                    <cfset siparis_miktari_2 = siparis_miktari_2 - PURCHASE_ORDER_QUANTITY>                            
                                </cfif>
                                 
                                <cfif siparis_miktari_2 gte 0 and attributes.order_day eq attributes.order2_day>
									<cfset siparis_miktari_2  = 0>
                                </cfif> 
                                
                                <cfif siparis_miktari_2 lt 0>
                                    <cfset siparis_miktari_2 = 0>
                                </cfif>
                            </cfif>
                            #wrk_round(siparis_miktari_2)#
                        <cfelse>
                            #old_deger_#
                        </cfif>
             </cfsavecontent>
             <cfset temp = QuerySetCell(myQuery,"oneri_siparis2","#oneri_siparis2_#",query_count)>
             
			<cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_#product_id#_#stock_id#_#department_id#") and (not isdefined("attributes.calc_type")  or listfind('0,3',attributes.calc_type))>
                <cfset deger_sip1 = evaluate("get_table_info.STOCK_SATIS_AMOUNT_#product_id#_#stock_id#_#department_id#")>
            <cfelse>
                <cfset deger_sip1 = wrk_round(siparis_miktari)>
            </cfif>
            <cfif len(attributes.order_code) or len(attributes.order_id) or len(attributes.order_company_code)>
				<cfif isdefined("attributes.order_siparis_miktari_1_#product_id#_#stock_id#_#department_id#")>
                    <cfset deger_sip1 = evaluate("attributes.order_siparis_miktari_1_#product_id#_#stock_id#_#department_id#")>
                <cfelse>
                	<cfset deger_sip1 = 0>
                </cfif>
            </cfif>
            
            <cfset temp = QuerySetCell(myQuery,"carpan","#multiplier#",query_count)>
            <cfset temp = QuerySetCell(myQuery,"carpan2","#P_MULTIPLIER#",query_count)>

			<cfsavecontent variable="siparis_onay_"><cfif stock_count_ eq 1 and dept_count_ eq 1>false<cfelse><cfif isdefined("attributes.calc_type") and attributes.calc_type eq 1 and deger_sip1 gt 0>false<cfelse>false</cfif></cfif></cfsavecontent>
            <cfset temp = QuerySetCell(myQuery,"siparis_onay","#siparis_onay_#",query_count)>
            
			<cfif (len(attributes.order_code) or len(attributes.order_id) or len(attributes.order_company_code)) and deger_sip1 gt 0>
				<cfset temp = QuerySetCell(myQuery,"siparis_onay","1",query_count)>
            </cfif>
            
			<cfif (len(attributes.order_code) or len(attributes.order_id) or len(attributes.order_company_code)) and deger_sip1 gt 0 and isdefined('attributes.order_siparis_sevk_1_#product_id#_#stock_id#_#department_id#') and evaluate('attributes.order_siparis_sevk_1_#product_id#_#stock_id#_#department_id#') eq 1>
				<cfset temp = QuerySetCell(myQuery,"siparis_sevk","true",query_count)>
            <cfelse>
                <cfset temp = QuerySetCell(myQuery,"siparis_sevk","false",query_count)>
            </cfif>
            
			<cfset temp = QuerySetCell(myQuery,"siparis_miktar","#deger_sip1#",query_count)>
            
            <cfif len(MULTIPLIER)>
            	<cfset temp = QuerySetCell(myQuery,"siparis_miktar_k","#wrk_round(deger_sip1 / MULTIPLIER)#",query_count)>
            <cfelse>
            	<cfset temp = QuerySetCell(myQuery,"siparis_miktar_k","",query_count)>
            </cfif>
            
            <cfif len(P_MULTIPLIER)>
            	<cfset temp = QuerySetCell(myQuery,"siparis_miktar_p","#wrk_round(deger_sip1 / P_MULTIPLIER)#",query_count)>
            <cfelse>
            	<cfset temp = QuerySetCell(myQuery,"siparis_miktar_p","",query_count)>
            </cfif>
			<cfset temp = QuerySetCell(myQuery,"siparis_tutar_1","#wrk_round(deger_sip1 * liste_fiyati_)#",query_count)>
            <cfset temp = QuerySetCell(myQuery,"siparis_tutar_kdv_1","#wrk_round(deger_sip1 * liste_fiyati_kdvli_)#",query_count)>
			<cfset temp = QuerySetCell(myQuery,"siparis_tarih_1","",query_count)>

			<cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#_#department_id#") and (not isdefined("attributes.calc_type") or listfind('0,3',attributes.calc_type))>
                <cfset deger_sip2 = evaluate("get_table_info.STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#_#department_id#")>
            <cfelse>
                <cfset deger_sip2 = wrk_round(siparis_miktari_2)>
            </cfif>

            <cfif len(attributes.order_code) or len(attributes.order_id) or len(attributes.order_company_code)>
				<cfif isdefined("attributes.order_siparis_miktari_2_#product_id#_#stock_id#_#department_id#")>
                    <cfset deger_sip2 = evaluate("attributes.order_siparis_miktari_2_#product_id#_#stock_id#_#department_id#")>
                <cfelse>
                	<cfset deger_sip2 = 0>
                </cfif>
            </cfif>
            
            <cfsavecontent variable="siparis_onay_2_"><cfif stock_count_ eq 1 and dept_count_ eq 1>false<cfelse><cfif isdefined("attributes.calc_type") and attributes.calc_type eq 1 and deger_sip2 gt 0>false<cfelse>false</cfif></cfif></cfsavecontent>
			<cfset temp = QuerySetCell(myQuery,"siparis_onay_2","#siparis_onay_2_#",query_count)>
            
            <cfif (len(attributes.order_code) or len(attributes.order_id) or len(attributes.order_company_code)) and deger_sip2 gt 0>
				<cfset temp = QuerySetCell(myQuery,"siparis_onay_2","1",query_count)>
            </cfif>
            
            <cfif (len(attributes.order_code) or len(attributes.order_id) or len(attributes.order_company_code)) and deger_sip2 gt 0 and isdefined('attributes.order_siparis_sevk_2_#product_id#_#stock_id#_#department_id#') and evaluate('attributes.order_siparis_sevk_2_#product_id#_#stock_id#_#department_id#') eq 1>
				<cfset temp = QuerySetCell(myQuery,"siparis_sevk_2","true",query_count)>
            <cfelse>
                <cfset temp = QuerySetCell(myQuery,"siparis_sevk_2","false",query_count)>
            </cfif>
            
            <cfset temp = QuerySetCell(myQuery,"siparis_miktar_2","#deger_sip2#",query_count)>
            
            <cfif len(MULTIPLIER)>
            	<cfset temp = QuerySetCell(myQuery,"siparis_miktar_k_2","#wrk_round(deger_sip2 / MULTIPLIER)#",query_count)>
            <cfelse>
            	<cfset temp = QuerySetCell(myQuery,"siparis_miktar_k_2","",query_count)>
            </cfif>
            
            <cfif len(P_MULTIPLIER)>
            	<cfset temp = QuerySetCell(myQuery,"siparis_miktar_p_2","#wrk_round(deger_sip2 / P_MULTIPLIER)#",query_count)>
            <cfelse>
            	<cfset temp = QuerySetCell(myQuery,"siparis_miktar_p_2","",query_count)>
            </cfif>
			<cfset temp = QuerySetCell(myQuery,"siparis_tutar_2","#wrk_round(deger_sip2 * liste_fiyati_)#",query_count)>
            <cfset temp = QuerySetCell(myQuery,"siparis_tutar_kdv_2","#wrk_round(deger_sip2 * liste_fiyati_kdvli_)#",query_count)>
			<cfset temp = QuerySetCell(myQuery,"siparis_tarih_2","",query_count)>
            
            <cfset temp = QuerySetCell(myQuery,"company_code","",query_count)>
			<cfset temp = QuerySetCell(myQuery,"company_name","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"startdate","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"finishdate","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"satis_kdv","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"standart_satis","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"c_standart_satis","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"c_standart_satis_kdv","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"standart_satis_kdv","",query_count)>
            
            <cfset temp = QuerySetCell(myQuery,"c_is_standart_satis_aktif","false",query_count)>
            <cfset temp = QuerySetCell(myQuery,"is_standart_satis_aktif","false",query_count)>
            <cfset temp = QuerySetCell(myQuery,"maliyet","#SON_MALIYET#",query_count)>
            <cfset temp = QuerySetCell(myQuery,"satis_standart_satis_oran","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"stok_dagitim","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"seviye_bilgisi","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"standart_alis_indirim_tutar","",query_count)>
            
            <cfset temp = QuerySetCell(myQuery,"standart_alis_indirim_yuzde","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"standart_alis_baslangic","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"standart_satis_baslangic","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"alis_kar","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"standart_alis_kar","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"standart_satis_kar","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"standart_satis_oran","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"standart_alis_oran","",query_count)>

            <cfset temp = QuerySetCell(myQuery,"eski_standart_alis_kdvli","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"eski_standart_satis_kdvli","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"eski_kar","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"liste_oran","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"donem_satis","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"donem_satis_tutar","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"ReportsTo","#product_id#",query_count)>
            <cfset temp = QuerySetCell(myQuery,"p_product_type","#p_product_type_#",query_count)>
            <cfset temp = QuerySetCell(myQuery,"sub_rows_count","0",query_count)>
            <cfset temp = QuerySetCell(myQuery,"product_info","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"price_departments","",query_count)>
            <cfset temp = QuerySetCell(myQuery,"std_p_control","0",query_count)>
            <cfset temp = QuerySetCell(myQuery,"unit_price","#unit_price#",query_count)>
            
			<cfset ort_sat = ort_sat + ROW_ORT_STOK_SATIS_MIKTARI>
          </cfif>
        </cfoutput>
</cfoutput>

<cfquery name="get_para_kol_list" datasource="#dsn_dev#">
	SELECT * FROM SEARCH_TABLES_COLOUMS WHERE KOLON_FORMAT = 'c2' or KOLON_FORMAT = 'c3'
</cfquery>
<cfset para_kolon_list = valuelist(get_para_kol_list.kolon_ad)>

<cfquery name="get_yuzde_kol_list" datasource="#dsn_dev#">
	SELECT * FROM SEARCH_TABLES_COLOUMS WHERE KOLON_FORMAT = 'p'
</cfquery>
<cfset yuzde_kolon_list = valuelist(get_yuzde_kol_list.kolon_ad)>

<cfif attributes.is_from_order eq 1>
	<cfquery name="myQuery" dbtype="query">
    	SELECT
        	*
        FROM
        	myQuery
        WHERE
        	ROW_TYPE = '1'
            OR
            ROW_TYPE = '2'
            OR
            (
            ROW_TYPE = '3' AND 
            	(
                	(SIPARIS_MIKTAR IS NOT NULL AND SIPARIS_MIKTAR <> '0')
                    OR 
                    (SIPARIS_MIKTAR_2 IS NOT NULL AND SIPARIS_MIKTAR_2 <> '0')
                )
            )
    </cfquery>
    <cfoutput query="myQuery">
    	<cfset pid = product_id>
        <cfset sira = currentrow>
        <cfif row_type eq 1>
        	<cfquery name="get_subs" dbtype="query">
            	SELECT PRODUCT_ID FROM myQuery WHERE PRODUCT_CODE LIKE '#pid#%' AND ROW_TYPE <> '1'
            </cfquery>
            <cfset temp = QuerySetCell(myQuery,"sub_rows_count","#get_subs.recordcount#",sira)>
        </cfif>
    </cfoutput>
</cfif>


<cfset CRLF = Chr(13) & Chr(10)>
<cfset dataset = "">
<cfoutput query="myQuery">
	<cfset row_ = "">
	<cfloop list="#name_list#" index="columns">
    <cfif isdefined("attributes.add_action")>
    	<cfset kolon_deger_ = trim(evaluate(columns))>
    	<cfif listfind(para_kolon_list,trim(lcase(columns))) and kolon_deger_ contains ','>
        	<cfset deger_ = '"#trim(lcase(columns))#":#filternum(kolon_deger_)#'>
            <cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfelseif listfind(yuzde_kolon_list,trim(lcase(columns))) and kolon_deger_ contains ','>
        	<cfset deger_ = '"#trim(lcase(columns))#":#filternum(kolon_deger_)#'>
            <cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfelseif (listfind(para_kolon_list,trim(lcase(columns))) or listfind(yuzde_kolon_list,trim(lcase(columns)))) and len(kolon_deger_) and kolon_deger_ is not ''>
        	<cfset deger_ = '"#trim(lcase(columns))#":#kolon_deger_#'>
            <cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfelseif (listfind(para_kolon_list,trim(lcase(columns))) or listfind(yuzde_kolon_list,trim(lcase(columns)))) and not len(kolon_deger_)>
        	<cfset deger_ = '"#trim(lcase(columns))#":0'>
            <cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfelse>
			<cfset deger_ = '"#trim(lcase(columns))#":"#trim(evaluate(columns))#"'>
            <cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        </cfif>
    <cfelse>
    	<cfset deger_ = '"#trim(lcase(columns))#":"#trim(evaluate(columns))#"'>
        <cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    </cfif>
    </cfloop>
    <cfset dataset = listappend(dataset,"{#row_##CRLF#}")>
</cfoutput>

<cfset dataset = "[" & dataset & "]">
<cfset dataset = replace(dataset,"reportsto","ReportsTo","all")>
<cfif not directoryexists('#upload_folder#retail\xml\')>
    <cfdirectory action="create" directory="#upload_folder#retail#dir_seperator#xml">
</cfif>
<cfif isdefined("attributes.add_action")>
	<textarea id="add_icerik_area" name="add_icerik_area" style="display:none;"><cfoutput>#dataset#</cfoutput></textarea>
    <cffile action="write" file="#upload_folder#retail\xml\add_tables_#attributes.table_code#_#userid_#.txt" output="#dataset#" charset="utf-8">
<cfelse>
    <cffile action="write" file="#upload_folder#retail\xml\tables_#attributes.table_code#_#userid_#.txt" output="#dataset#" charset="utf-8">
</cfif>
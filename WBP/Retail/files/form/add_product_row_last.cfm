<cfset attributes.add_product_id = attributes.product_id>
<cfset genel_fiyat_listesi = 1>
<cfset merkez_depo_id = 13>
<cfset merkez_lokasyon_id = 1>

<cfquery name="GET_COMPETITIVE_LIST" datasource="#DSN3#">
	SELECT COMPETITIVE_ID FROM PRODUCT_COMP_PERM WHERE POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfset COMPETITIVE_LIST = ValueList(get_competitive_list.competitive_id)>
<cfinclude template="../query/get_price_cat.cfm">
<cfinclude template="/product/query/get_kdv.cfm">

<cfset hide_col_list = "">
<cfif FileExists("#upload_folder#personal_settings/xml_emp_#session.ep.userid#.xml")>
	<cfset myXmlDoc= XmlParse("#upload_folder#personal_settings/xml_emp_#session.ep.userid#.xml")>
    <cfset selectedElements = XmlSearch(myXmlDoc, "/Employee/XmlAction/")>
    <cfloop index="aa" from="1" to="#ArrayLen(selectedElements)#">
	   <cfset fuseaction_ = selectedElements[aa].XmlChildren[1].XmlText>
       <cfset action_value_ = selectedElements[aa].XmlChildren[4].XmlText>
       <cfif fuseaction_ is 'retail.speed_manage_product' and action_value_ eq 0>
		   <cfset div_id_ = selectedElements[aa].XmlChildren[2].XmlText>
           <cfset hide_col_list = listappend(hide_col_list,div_id_)>
        </cfif>
    </cfloop>
</cfif>

<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.search_startdate") and isdate(attributes.search_startdate)>
	<cf_date tarih = "attributes.search_startdate">
<cfelse>
	<cfset attributes.search_startdate = dateadd("m",-3,now())>
</cfif>
<cfif isdefined("attributes.search_finishdate") and isdate(attributes.search_finishdate)>
	<cf_date tarih = "attributes.search_finishdate">
<cfelse>
	<cfset attributes.search_finishdate = now()>
</cfif>


<cfinclude template="../query/get_products.cfm">
<script>
icerik_ = '';

<cfoutput query="get_products" group="product_id">
    <cfquery name="get_magaza_stock" dbtype="query">
        SELECT SUM(ROW_STOCK) MAGAZA_STOCK FROM get_products WHERE PRODUCT_ID = #product_id# AND DEPARTMENT_ID NOT IN (#merkez_depo_id#)
    </cfquery>
    <cfquery name="get_depo_stock" dbtype="query">
        SELECT SUM(ROW_STOCK) DEPO_STOCK FROM get_products WHERE PRODUCT_ID = #product_id# AND DEPARTMENT_ID IN (#merkez_depo_id#)
    </cfquery>
    <cfquery name="get_total_stock" dbtype="query">
        SELECT SUM(ROW_STOCK) TOTAL_STOCK FROM get_products WHERE PRODUCT_ID = #product_id#
    </cfquery>
    <cfquery name="get_total_yoldaki" dbtype="query">
        SELECT SUM(PURCHASE_ORDER_QUANTITY) TOTAL_STOCK FROM get_products WHERE PRODUCT_ID = #product_id#
    </cfquery>
    <cfquery name="get_stocks" dbtype="query">
        SELECT STOCK_ID FROM get_products WHERE PRODUCT_ID = #product_id#
    </cfquery>
    <cfset magaza_stock = get_magaza_stock.MAGAZA_STOCK>
    <cfset depo_stock = get_depo_stock.DEPO_STOCK>
    <cfset product_total_stock = get_total_stock.TOTAL_STOCK>
    <cfset yoldaki_stok = get_total_yoldaki.TOTAL_STOCK>
    
	
    icerik_ += '<tr class="color-list" id="product_row_#product_id#" onclick="get_row_active(\'#product_id#\');" onclick="get_row_active(\'#product_id#\');">';
	
    icerik_ += '<td rel="kolon_1" style="height:20px;<cfif listfind(hide_col_list,'kolon_1')>display:none;</cfif>">';
    icerik_ += '<input type="hidden" name="product_stock_list_#product_id#" id="product_stock_list_#product_id#" value="#listdeleteduplicates(valuelist(get_stocks.STOCK_ID))#"/>';
    icerik_ += '<input type="checkbox" name="is_selected_#product_id#" id="is_selected_#product_id#" value="1" onclick="select_row(\'#product_id#\');"/>';
    icerik_ += '</td>';
	
    icerik_ += '<td rel="kolon_2" style=" <cfif  listfind(hide_col_list,'kolon_2')>display:none;</cfif>" nowrap>';
    icerik_ += '<a href="javascript://" onclick="del_manage_row(\'#product_id#\');"><img src="/images/delete12.gif" /></a>';
    icerik_ += '<a href="javascript://" onclick="add_manage_row(\'#product_id#\');"><img src="/images/plus_small.gif" /></a>';
    icerik_ += '<input type="text" name="line_number_#product_id#" id="line_number_#product_id#" value="#attributes.yeni_siram#" style="width:25px;" readonly/>';
    icerik_ += '</td>';
	
	
    icerik_ += '<td rel="kolon_3" style=" <cfif listfind(hide_col_list,'kolon_3')>display:none;</cfif>" nowrap>';
    icerik_ += '<input type="text" name="product_name_#product_id#" id="product_name_#product_id#" value="#product_name#" style="width:150px;" readonly/>';
    icerik_ += '<a href="javascript://" onclick="get_product_detail(\'#product_id#\');"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
    icerik_ += ' <a href="javascript://" onclick="get_product_stock_row(\'#product_id#\');"><img src="/images/listele.gif" id="p_image_#product_id#"/></a>';
    icerik_ += ' <a href="javascript://" onclick="get_out_product_stock_row(\'#product_id#\');"><img src="/images/listele_down.gif" id="p_image2_#product_id#" style="display:none;"/></a>';
    icerik_ += '</td>';
	
	
    icerik_ += '<td rel="kolon_4" style=" <cfif listfind(hide_col_list,'kolon_4')>display:none;</cfif>"><input type="checkbox" name="is_purchase_#product_id#" id="is_purchase_#product_id#" value="1" <cfif is_purchase eq 1>checked</cfif>></td>';
	
    icerik_ += '<td rel="kolon_5" style=" <cfif listfind(hide_col_list,'kolon_5')>display:none;</cfif>"><input type="checkbox" name="is_sales_#product_id#" id="is_sales_#product_id#" value="1" <cfif is_sales eq 1>checked</cfif>></td>';
    
	icerik_ += '<td rel="kolon_7" style=" <cfif listfind(hide_col_list,'kolon_7')>display:none;</cfif>">';
    icerik_ += '<input type="text" name="barcode_#product_id#" id="barcode_#product_id#" value="#barcod#" style="width:90px;">';
    icerik_ += '</td>';
	
    icerik_ += '<td rel="kolon_8" style=" <cfif listfind(hide_col_list,'kolon_8')>display:none;</cfif>">';
    icerik_ += '<input type="text" name="product_code_#product_id#" id="product_code_#product_id#" value="#product_code#" style="width:75px;" readonly="readonly">';
    icerik_ += '</td>';
	
    icerik_ += '<td rel="kolon_9" style=" <cfif listfind(hide_col_list,'kolon_9')>display:none;</cfif>">';
    icerik_ += '<input type="text" name="STANDART_ALIS_#product_id#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="#TLFormat(price_standart,session.ep.our_company_info.purchase_price_round_num)#" style="width:63px;">';
    icerik_ += '</td>';
	
	icerik_ += '<td rel="kolon_14" style=" <cfif listfind(hide_col_list,'kolon_14')>display:none;</cfif>">';
    icerik_ += '<select name="STANDART_ALIS_KDV_#product_id#" id="STANDART_ALIS_KDV_#product_id#" style="width:40px;">';
                <cfloop query="get_kdv">
                    icerik_ += '<option value="#tax#" <cfif get_products.tax_purchase is get_kdv.TAX> selected</cfif>>#get_kdv.tax#</option>';
                </cfloop>
    icerik_ += '</select>';
    icerik_ += '</td>';
	
	
    icerik_ += '<td rel="kolon_15" style=" <cfif listfind(hide_col_list,'kolon_15')>display:none;</cfif>">';
    icerik_ += '<input type="text" name="STANDART_ALIS_KDVLI_#product_id#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="#TLFormat(price_standart_kdv,session.ep.our_company_info.purchase_price_round_num)#" style="width:63px;">';
    icerik_ += '</td>';
	
    icerik_ += '<td rel="kolon_28" style=" <cfif listfind(hide_col_list,'kolon_28')>display:none;</cfif>">';
    icerik_ += '<input type="text" name="NEW_ALIS_#product_id#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="#TLFormat(price_standart,session.ep.our_company_info.purchase_price_round_num)#" style="width:63px;">';
    icerik_ += '</td>';
	
	icerik_ += '<td rel="kolon_29" style=" <cfif listfind(hide_col_list,'kolon_29')>display:none;</cfif>">';
    icerik_ += '<input type="text" name="NEW_ALIS_KDVLI_#product_id#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="#TLFormat(price_standart_kdv,session.ep.our_company_info.purchase_price_round_num)#" style="width:63px;">';
    icerik_ += '</td>';
	
	icerik_ += '<td rel="kolon_12" style=" <cfif listfind(hide_col_list,'kolon_12')>display:none;</cfif>">';
    icerik_ += '<input type="text" name="FIRST_SATIS_PRICE_#product_id#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="#TLFormat(STANDART_SALE_PRICE,session.ep.our_company_info.purchase_price_round_num)#" style="width:63px;">';
    icerik_ += '</td>';
	
    icerik_ += '<td rel="kolon_19" style=" <cfif listfind(hide_col_list,'kolon_19')>display:none;</cfif>">';
    icerik_ += '<select name="STANDART_SATIS_KDV_#product_id#" id="STANDART_SATIS_KDV_#product_id#" style="width:40px;">';
                <cfloop query="get_kdv">
                    icerik_ += '<option value="#tax#" <cfif get_products.tax is get_kdv.TAX> selected</cfif>>#get_kdv.tax#</option>';
                </cfloop>
    icerik_ += '</select>';
    icerik_ += '</td>';
	
	
	
    icerik_ += '<td rel="kolon_26" style=" <cfif listfind(hide_col_list,'kolon_26')>display:none;</cfif>">';
    icerik_ += '<input type="text" name="FIRST_SATIS_PRICE_KDV_#product_id#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="#TLFormat(STANDART_SALE_PRICE_KDV,session.ep.our_company_info.purchase_price_round_num)#" style="width:63px;">';
    icerik_ += '</td>';
	
    icerik_ += '<td rel="kolon_27" style=" <cfif listfind(hide_col_list,'kolon_26')>display:none;</cfif> text-qlign:right;">';
    icerik_ += '<input type="text" name="SATIS_LIST_PRICE_#product_id#" class="moneybox" value="#TLFormat(SON_MALIYET+SON_MALIYET*(max_margin/100),session.ep.our_company_info.purchase_price_round_num)#" readonly="yes" style="width:63px;">';
    icerik_ += '</td>';
	
    icerik_ += '<td rel="kolon_10" style="<cfif listfind(hide_col_list,'kolon_10')>display:none;</cfif>">';
    icerik_ += '<input type="text" name="discount1_#product_id#" id="discount1_#product_id#" style="width:17px;" value="0" onBlur="discount_calc(#product_id#,this.value);">';
    icerik_ += '<input type="text" name="discount2_#product_id#" onBlur="discount_calc(#product_id#,this.value);" id="discount2_#product_id#"  style="width:17px;display:none;" value="0">';
    icerik_ += '<input type="text" name="discount3_#product_id#" onBlur="discount_calc(#product_id#,this.value);" id="discount3_#product_id#" style="width:17px;display:none;" value="0">';
    icerik_ += '<input type="text" name="discount4_#product_id#" onBlur="discount_calc(#product_id#,this.value);" id="discount4_#product_id#" style="width:17px;display:none;" value="0">';
    icerik_ += '<input type="text" name="discount5_#product_id#" onBlur="discount_calc(#product_id#,this.value);" id="discount5_#product_id#" style="width:17px;display:none;" value="0">';
    icerik_ += '</td>';
	
    icerik_ += '<td rel="kolon_6" style="<cfif listfind(hide_col_list,'kolon_6')>display:none;</cfif>">';
    icerik_ += '<input type="text" name="SATIS_PRICE_#product_id#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="#TLFormat(SON_MALIYET+SON_MALIYET*(max_margin/100),session.ep.our_company_info.purchase_price_round_num)#" style="width:63px;">';
    icerik_ += '</td>';
	
    icerik_ += '<td rel="kolon_13" style="<cfif listfind(hide_col_list,'kolon_13')>display:none;</cfif> text-align:right;">';
    icerik_ += '<a href="javascript://" class="tableyazi" onclick="get_rival_price_list(\'#product_id#\');">#TLFormat(avg_rival,2)#</a>';
    icerik_ += '</td>';
	
	
    icerik_ += '<td rel="kolon_11" style=" text-align:right;  <cfif listfind(hide_col_list,'kolon_11')>display:none;</cfif>">#TLFormat(ORT_SATIS_MIKTARI,2)#</td>';
    icerik_ += '<td rel="kolon_30" style=" text-align:right;  <cfif listfind(hide_col_list,'kolon_30')>display:none;</cfif>"><cfif PRODUCT_TOTAL_STOCK gt 0 and ORT_SATIS_MIKTARI gt 0>#TLFormat(PRODUCT_TOTAL_STOCK / ORT_SATIS_MIKTARI)#<cfelse>-</cfif></td>';
    icerik_ += '<td rel="kolon_31" style=" text-align:right;  <cfif listfind(hide_col_list,'kolon_31')>display:none;</cfif>">#TLFormat(STOK_DEVIR_HIZI,2)#</td>';
    icerik_ += '<td rel="kolon_16" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_16')>display:none;</cfif>"><a href="javascript://" class="tableyazi" onclick="get_stock_list(\'#product_id#\');">#PRODUCT_TOTAL_STOCK#</a></td>';
    icerik_ += '<td rel="kolon_17" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_17')>display:none;</cfif>">#magaza_stock#</td>';
    icerik_ += '<td rel="kolon_18" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_18')>display:none;</cfif>">#depo_stock#</td>';
    icerik_ += '<td rel="kolon_33" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_33')>display:none;</cfif>">#yoldaki_stok#</td>';
    icerik_ += '<td rel="kolon_32" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_32')>display:none;</cfif>">---</td>';
    icerik_ += '<td rel="kolon_40" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_40')>display:none;</cfif>">#multiplier#</td>';
    icerik_ += '<td rel="kolon_34" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_34')>display:none;</cfif>">---</td>';
    icerik_ += '<td rel="kolon_35" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_35')>display:none;</cfif>">---</td>';
    icerik_ += '<td rel="kolon_36" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_36')>display:none;</cfif>">---</td>';
    icerik_ += '<td rel="kolon_37" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_37')>display:none;</cfif>">---</td>';
    icerik_ += '<td rel="kolon_38" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_38')>display:none;</cfif>">---</td>';
    icerik_ += '<td rel="kolon_39" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_39')>display:none;</cfif>">---</td>';
    icerik_ += '<td rel="kolon_41" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_41')>display:none;</cfif>"><cfif isdefined('attributes.company_id') and len(attributes.company_id)>#attributes.company#<cfelse>#NICKNAME#</cfif></td>';
    	
	icerik_ += '<td rel="kolon_20" style=" <cfif listfind(hide_col_list,'kolon_20')>display:none;</cfif>" nowrap>';
    icerik_ += '<input type="text" name="startdate_#product_id#" id="startdate_#product_id#" maxlength="10" value="#dateformat(PRICE_START,'dd/mm/yyyy')#" style="width:65px;">';
    icerik_ += '</td>';
	
    icerik_ += '<td rel="kolon_21" style=" <cfif listfind(hide_col_list,'kolon_21')>display:none;</cfif>" nowrap>';
    icerik_ += '<input type="text" name="finishdate_#product_id#" id="finishdate_#product_id#" maxlength="10" value="#dateformat(PRICE_FINISH,'dd/mm/yyyy')#" style="width:65px;">';
    icerik_ += '</td>';
	
    icerik_ += '<td rel="kolon_22" style=" <cfif listfind(hide_col_list,'kolon_22')>display:none;</cfif>" nowrap>';
    icerik_ += '<input type="text" name="dueday_#product_id#" id="dueday_#product_id#" maxlength="3" value="" style="width:30px;">';
    icerik_ += '</td>';
	
    icerik_ += '<td rel="kolon_23" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_23')>display:none;</cfif>"><a href="javascript://" class="tableyazi" onclick="get_cost_list(\'#product_id#\');">#SON_MALIYET#</a></td>';
    
	icerik_ += '<td rel="kolon_24" style=" <cfif listfind(hide_col_list,'kolon_24')>display:none;</cfif>" nowrap>';
    icerik_ += '<input type="text" name="p_startdate_#product_id#" id="p_startdate_#product_id#" maxlength="10" value="" style="width:65px;">';
    icerik_ += '</td>';
	
    icerik_ += '<td rel="kolon_25" style=" <cfif listfind(hide_col_list,'kolon_25')>display:none;</cfif>" nowrap>';
    icerik_ += '<input type="text" name="p_finishdate_#product_id#" id="p_finishdate_#product_id#" maxlength="10" value="" style="width:65px;">';
    icerik_ += '</td>';
	
    icerik_ += '</tr>';
	
	<cfset last_stock_id = ''>
    <cfoutput>
    <cfif stock_id neq last_stock_id>
        <cfset last_stock_id = stock_id>
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
        icerik_ += '<tr bgcolor="FFFF99" style="display:none;" product="p_#product_id#">';
		icerik_ += '<td>&nbsp;</td>';
		icerik_ += '<td>&nbsp;</td>';
		icerik_ += '<td class="txtbold">';
		icerik_ += '<input type="hidden" name="stock_name_#product_id#_#stock_id#" id="stock_name_#product_id#_#stock_id#" value="#property#" />#property#';
		icerik_ += '</td>';
		icerik_ += '<td rel="kolon_4" style=" <cfif listfind(hide_col_list,'kolon_4')>display:none;</cfif>"><cfif is_purchase eq 1><img src="/images/ok_list.gif" /><cfelse><img src="/images/ok_list_empty.gif" /></cfif></td>';
		icerik_ += '<td rel="kolon_5" style=" <cfif listfind(hide_col_list,'kolon_5')>display:none;</cfif>"><cfif is_sales eq 1><img src="/images/ok_list.gif" /><cfelse><img src="/images/ok_list_empty.gif" /></cfif></td>';
		icerik_ += '<td rel="kolon_7" style=" <cfif listfind(hide_col_list,'kolon_7')>display:none;</cfif>">#S_BARCOD#</td>';
		icerik_ += '<td rel="kolon_8" style=" <cfif listfind(hide_col_list,'kolon_8')>display:none;</cfif>">#STOCK_CODE#</td>';
		icerik_ += '<td rel="kolon_9" style=" <cfif listfind(hide_col_list,'kolon_9')>display:none;</cfif>">#TLFormat(price_standart,session.ep.our_company_info.purchase_price_round_num)#</td>';
		icerik_ += '<td rel="kolon_14" style=" <cfif listfind(hide_col_list,'kolon_14')>display:none;</cfif>">#get_products.tax_purchase#</td>';
		icerik_ += '<td rel="kolon_15" style=" <cfif listfind(hide_col_list,'kolon_15')>display:none;</cfif>">#TLFormat(price_standart_kdv,session.ep.our_company_info.purchase_price_round_num)#</td>';
		icerik_ += '<td rel="kolon_28" style=" <cfif listfind(hide_col_list,'kolon_28')>display:none;</cfif>">';
		icerik_ += '<input type="text" name="NEW_ALIS_#product_id#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="" style="width:63px;">';
		icerik_ += '</td>';
		icerik_ += '<td rel="kolon_29" style=" <cfif listfind(hide_col_list,'kolon_29')>display:none;</cfif>">';
		icerik_ += '<input type="text" name="NEW_ALIS_KDVLI_#product_id#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="" style="width:63px;">';
		icerik_ += '</td>';
		icerik_ += '<td rel="kolon_12" style=" <cfif listfind(hide_col_list,'kolon_12')>display:none;</cfif>">#TLFormat(STANDART_SALE_PRICE,session.ep.our_company_info.purchase_price_round_num)#</td>';
		icerik_ += '<td rel="kolon_19" style=" <cfif listfind(hide_col_list,'kolon_19')>display:none;</cfif>">#get_products.tax#</td>';
		icerik_ += '<td rel="kolon_26" style=" <cfif listfind(hide_col_list,'kolon_26')>display:none;</cfif>">#TLFormat(STANDART_SALE_PRICE_KDV,session.ep.our_company_info.purchase_price_round_num)#</td>';
		icerik_ += '<td rel="kolon_27" style=" <cfif listfind(hide_col_list,'kolon_26')>display:none;</cfif> text-align:right;">';
		icerik_ += '#TLFormat(SON_MALIYET+SON_MALIYET*(max_margin/100),session.ep.our_company_info.purchase_price_round_num)#';
		icerik_ += '</td>';
		icerik_ += '<td rel="kolon_10" style="<cfif listfind(hide_col_list,'kolon_10')>display:none;</cfif>">&nbsp;</td>';
		icerik_ += '<td rel="kolon_6" style="<cfif listfind(hide_col_list,'kolon_6')>display:none;</cfif>">';
		icerik_ += '<input type="text" name="SATIS_PRICE_#product_id#_#stock_id#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="" style="width:63px;">';
		icerik_ += '</td>';
		icerik_ += '<td rel="kolon_13" style="<cfif listfind(hide_col_list,'kolon_13')>display:none;</cfif> text-align:right;">';
		icerik_ += '<a href="javascript://" class="tableyazi" onclick="get_rival_price_list(\'#product_id#\');">#TLFormat(avg_rival,2)#</a>';
		icerik_ += '</td>';
		icerik_ += '<td rel="kolon_11" style=" text-align:right;  <cfif listfind(hide_col_list,'kolon_11')>display:none;</cfif>">#TLFormat(ORT_SATIS_MIKTARI,2)#</td>';
		icerik_ += '<td rel="kolon_30" style=" text-align:right;  <cfif listfind(hide_col_list,'kolon_30')>display:none;</cfif>"><cfif row_stock gt 0 and ORT_SATIS_MIKTARI gt 0>#TLFormat(row_stock / ORT_SATIS_MIKTARI)#<cfelse>-</cfif></td>';
		icerik_ += '<td rel="kolon_31" style=" text-align:right;  <cfif listfind(hide_col_list,'kolon_31')>display:none;</cfif>">#TLFormat(STOK_DEVIR_HIZI,2)#</td>';
		icerik_ += '<td rel="kolon_16" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_16')>display:none;</cfif>"><a href="javascript://" class="tableyazi" onclick="get_stock_list(\'#product_id#\');">#row_stock#</a></td>';
		icerik_ += '<td rel="kolon_17" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_17')>display:none;</cfif>">#magaza_stock#</td>';
		icerik_ += '<td rel="kolon_18" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_18')>display:none;</cfif>">#depo_stock#</td>';
		icerik_ += '<td rel="kolon_33" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_33')>display:none;</cfif>">#yoldaki_stok#</td>';
		icerik_ += '<td rel="kolon_32" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_32')>display:none;</cfif>">---</td>';
		icerik_ += '<td rel="kolon_40" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_40')>display:none;</cfif>">#multiplier#</td>';
		icerik_ += '<td rel="kolon_34" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_34')>display:none;</cfif>">---</td>';
		icerik_ += '<td rel="kolon_35" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_35')>display:none;</cfif>">---</td>';
		icerik_ += '<td rel="kolon_36" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_36')>display:none;</cfif>">---</td>';
		icerik_ += '<td rel="kolon_37" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_37')>display:none;</cfif>">---</td>';
		icerik_ += '<td rel="kolon_38" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_38')>display:none;</cfif>">---</td>';
		icerik_ += '<td rel="kolon_39" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_39')>display:none;</cfif>">---</td>';
		icerik_ += '<td rel="kolon_41" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_41')>display:none;</cfif>">';
		icerik_ += '<input type="text" name="company_name_#stock_id#" id="company_name_#stock_id#" value="<cfif isdefined('attributes.company') and len(attributes.company)>#attributes.company#<cfelse>#NICKNAME#</cfif>" style="width:100px;" readonly/>';
		icerik_ += '<input type="hidden" name="company_id_#stock_id#" id="company_id_#stock_id#" value="<cfif isdefined('attributes.company_id') and len(attributes.company_id)>#attributes.company_id#<cfelse>#company_id#</cfif>" style="width:100px;" readonly/>';
		icerik_ += '<a href="javascript://" onclick="windowopen(\'#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=info_form.company_name_#stock_id#&field_comp_id=info_form.company_id_#stock_id#\',\'list\',\'popup_list_pars\');"><img src="/images/plus_thin.gif"></a>';
		icerik_ += '</td>';
		icerik_ += '<td rel="kolon_20" style=" <cfif listfind(hide_col_list,'kolon_20')>display:none;</cfif>" nowrap>';
		icerik_ += '<input type="text" name="startdate_#product_id#_#stock_id#" id="startdate_#product_id#_#stock_id#" maxlength="10" value="" style="width:65px;">';
		icerik_ += '</td>';
		icerik_ += '<td rel="kolon_21" style=" <cfif listfind(hide_col_list,'kolon_21')>display:none;</cfif>" nowrap>';
		icerik_ += '<input type="text" name="finishdate_#product_id#_#stock_id#" id="finishdate_#product_id#_#stock_id#" maxlength="10" value="" style="width:65px;">';
		icerik_ += '</td>';
		icerik_ += '<td rel="kolon_22" style=" <cfif listfind(hide_col_list,'kolon_22')>display:none;</cfif>" nowrap>';
		icerik_ += '<input type="text" name="dueday_#product_id#_#stock_id#" id="dueday_#product_id#_#stock_id#" maxlength="3" value="" style="width:30px;" validate="integer" message="Vade Hatalı!">';
		icerik_ += '</td>';
		icerik_ += '<td rel="kolon_23" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_23')>display:none;</cfif>"><a href="javascript://" class="tableyazi" onclick="get_cost_list(\'#product_id#\');">#SON_MALIYET#</a></td>';
		icerik_ += '<td rel="kolon_24" style=" <cfif listfind(hide_col_list,'kolon_24')>display:none;</cfif>" nowrap>';
		icerik_ += '<input type="text" name="p_startdate_#product_id#_#stock_id#" id="p_startdate_#product_id#_#stock_id#" maxlength="10" value="" style="width:65px;" validate="eurodate" message="Tarih Hatalı!">';
		icerik_ += '</td>';
		icerik_ += '<td rel="kolon_25" style=" <cfif listfind(hide_col_list,'kolon_25')>display:none;</cfif>" nowrap>';
		icerik_ += '<input type="text" name="p_finishdate_#product_id#_#stock_id#" id="p_finishdate_#product_id#_#stock_id#" maxlength="10" value="" style="width:65px;">';
		icerik_ += '</td>';
        icerik_ += '</tr>';
    </cfif>
		icerik_ += '<tr class="color-row" style="display:none;" product="p_#product_id#">';
		icerik_ += '<td rel="kolon_1" style="height:20px;<cfif  listfind(hide_col_list,'kolon_1')>display:none;</cfif>">&nbsp;</td>';
		icerik_ += '<td rel="kolon_2" style=" <cfif  listfind(hide_col_list,'kolon_2')>display:none;</cfif>" nowrap>&nbsp;</td>';
		icerik_ += '<td rel="kolon_3" style=" <cfif listfind(hide_col_list,'kolon_3')>display:none;</cfif>" nowrap>#department_head#</td>';
		icerik_ += '<td rel="kolon_4" style=" <cfif listfind(hide_col_list,'kolon_4')>display:none;</cfif>">&nbsp;</td>';
		icerik_ += '<td rel="kolon_5" style=" <cfif listfind(hide_col_list,'kolon_5')>display:none;</cfif>">&nbsp;</td>';
		icerik_ += '<td rel="kolon_7" style=" <cfif listfind(hide_col_list,'kolon_7')>display:none;</cfif>">&nbsp;</td>';
		icerik_ += '<td rel="kolon_8" style=" <cfif listfind(hide_col_list,'kolon_8')>display:none;</cfif>">&nbsp;</td>';
		icerik_ += '<td rel="kolon_9" style=" <cfif listfind(hide_col_list,'kolon_9')>display:none;</cfif>">&nbsp;</td>';
		icerik_ += '<td rel="kolon_14" style=" <cfif listfind(hide_col_list,'kolon_14')>display:none;</cfif>">&nbsp;</td>';
		icerik_ += '<td rel="kolon_15" style=" <cfif listfind(hide_col_list,'kolon_15')>display:none;</cfif>">&nbsp;</td>';
		icerik_ += '<td rel="kolon_28" style=" <cfif listfind(hide_col_list,'kolon_28')>display:none;</cfif>">&nbsp;</td>';
		icerik_ += '<td rel="kolon_29" style=" <cfif listfind(hide_col_list,'kolon_29')>display:none;</cfif>">&nbsp;</td>';
		icerik_ += '<td rel="kolon_12" style=" <cfif listfind(hide_col_list,'kolon_12')>display:none;</cfif>">&nbsp;</td>';
		icerik_ += '<td rel="kolon_19" style=" <cfif listfind(hide_col_list,'kolon_19')>display:none;</cfif>">&nbsp;</td>';
		icerik_ += '<td rel="kolon_26" style=" <cfif listfind(hide_col_list,'kolon_26')>display:none;</cfif>">&nbsp;</td>';
		icerik_ += '<td rel="kolon_27" style=" <cfif listfind(hide_col_list,'kolon_27')>display:none;</cfif> text-align:right;">&nbsp;</td>';
		icerik_ += '<td rel="kolon_10" style="<cfif listfind(hide_col_list,'kolon_10')>display:none;</cfif>">&nbsp;</td>';
		icerik_ += '<td rel="kolon_6" style="<cfif listfind(hide_col_list,'kolon_6')>display:none;</cfif>">&nbsp;</td>';
		icerik_ += '<td rel="kolon_13" style="<cfif listfind(hide_col_list,'kolon_13')>display:none;</cfif> text-align:right;">&nbsp;</td>';
		icerik_ += '<td rel="kolon_11" style=" text-align:right;  <cfif listfind(hide_col_list,'kolon_11')>display:none;</cfif>">#tlformat(ROW_ORT_STOK_SATIS_MIKTARI)#</td>';
		icerik_ += '<td rel="kolon_30" style=" text-align:right;  <cfif listfind(hide_col_list,'kolon_30')>display:none;</cfif>"><cfif row_stock gt 0 and ROW_ORT_STOK_SATIS_MIKTARI gt 0>#TLFormat(row_stock / ROW_ORT_STOK_SATIS_MIKTARI)#<cfelse>-</cfif></td>';
		icerik_ += '<td rel="kolon_31" style=" text-align:right;  <cfif listfind(hide_col_list,'kolon_31')>display:none;</cfif>">#tlformat(ROW_STOK_DEVIR_HIZI)#</td>';
		icerik_ += '<td rel="kolon_16" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_16')>display:none;</cfif>">&nbsp;</td>';
		icerik_ += '<td rel="kolon_17" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_17')>display:none;</cfif>"><cfif not listfindnocase(merkez_depo_id,department_id)>#row_stock#</cfif></td>';
		icerik_ += '<td rel="kolon_18" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_18')>display:none;</cfif>"><cfif listfindnocase(merkez_depo_id,department_id)>#row_stock#</cfif></td>';
		icerik_ += '<td rel="kolon_33" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_33')>display:none;</cfif>">';
		icerik_ += '#PURCHASE_ORDER_QUANTITY#';
		icerik_ += '</td>';
		icerik_ += '<td rel="kolon_32" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_32')>display:none;</cfif>">';
			<cfif not len(ROW_ORT_STOK_SATIS_MIKTARI)>
				<cfset siparis_miktari = 0>
			<cfelse>
				<cfset siparis_miktari = ceiling(attributes.gun*ROW_ORT_STOK_SATIS_MIKTARI-row_stock-PURCHASE_ORDER_QUANTITY)>
				<cfif siparis_miktari lt 0>
					<cfset siparis_miktari = 0>
				</cfif>
			</cfif>
		icerik_ += '<input type="text" readonly="yes" name="STOCK_SATIS_AMOUNT_ILK_#product_id#_#stock_id#_#department_id#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="#siparis_miktari#" style="width:40px;">';
		icerik_ += '</td>';
		icerik_ += '<td rel="kolon_40" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_40')>display:none;</cfif>">#multiplier#</td>';
		icerik_ += '<td rel="kolon_34" style=" <cfif listfind(hide_col_list,'kolon_34')>display:none;</cfif>" nowrap>';
		icerik_ += '<input type="text" name="STOCK_SATIS_AMOUNT_#product_id#_#stock_id#_#department_id#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="" style="width:40px;">';
		icerik_ += '</td>';
		icerik_ += '<td rel="kolon_35" style=" <cfif listfind(hide_col_list,'kolon_35')>display:none;</cfif>" nowrap>&nbsp;</td>';
		icerik_ += '<td rel="kolon_36" style=" <cfif listfind(hide_col_list,'kolon_36')>display:none;</cfif>" nowrap>';
		icerik_ += '<input type="text" name="order_date_1_#stock_id#_#department_id#" id="order_date_1_#stock_id#_#department_id#" maxlength="10" value="#dateformat(dateadd('d',1,now()),'dd/mm/yyyy')#" style="width:65px;">';
		icerik_ += '</td>';
		icerik_ += '<td rel="kolon_37" style=" <cfif listfind(hide_col_list,'kolon_37')>display:none;</cfif>" nowrap>';
		icerik_ += '<input type="text" name="STOCK_SATIS_AMOUNT_KOLI_#product_id#_#stock_id#_#department_id#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="" style="width:40px;">';
		icerik_ += '</td>';
		icerik_ += '<td rel="kolon_38" style=" <cfif listfind(hide_col_list,'kolon_38')>display:none;</cfif>" nowrap>&nbsp;</td>';
		icerik_ += '<td rel="kolon_39" style=" <cfif listfind(hide_col_list,'kolon_39')>display:none;</cfif>" nowrap>';
		icerik_ += '<input type="text" name="order_date_2_#stock_id#_#department_id#" id="order_date_2_#stock_id#_#department_id#" maxlength="10" value="#dateformat(dateadd('d',15,now()),'dd/mm/yyyy')#" style="width:65px;">';
		icerik_ += '</td>';
		icerik_ += '<td rel="kolon_41" style=" <cfif listfind(hide_col_list,'kolon_41')>display:none;</cfif>" nowrap>';
		icerik_ += '<input type="text" name="company_name_#stock_id#_#department_id#" id="company_name_#stock_id#_#department_id#" value="<cfif isdefined('attributes.company_id') and len(attributes.company_id)>#attributes.company#<cfelse>#NICKNAME#</cfif>" style="width:100px;" readonly/>';
		icerik_ += '<input type="hidden" name="company_id_#stock_id#_#department_id#" id="company_id_#stock_id#_#department_id#" value="<cfif isdefined('attributes.company_id') and len(attributes.company_id)>#attributes.company_id#<cfelse>#company_id#</cfif>" style="width:100px;" readonly/>';
		icerik_ += '<a href="javascript://" onclick="windowopen(\'#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=info_form.company_name_#stock_id#_#department_id#&field_comp_id=info_form.company_id_#stock_id#_#department_id#&select_list=2\',\'list\',\'popup_list_pars\');"><img src="/images/plus_thin.gif"></a>';
		icerik_ += '</td>';
		icerik_ += '<td rel="kolon_20" style=" <cfif listfind(hide_col_list,'kolon_20')>display:none;</cfif>" nowrap>&nbsp;</td>';
		icerik_ += '<td rel="kolon_21" style=" <cfif listfind(hide_col_list,'kolon_21')>display:none;</cfif>" nowrap>&nbsp;</td>';
		icerik_ += '<td rel="kolon_22" style=" <cfif listfind(hide_col_list,'kolon_22')>display:none;</cfif>" nowrap>&nbsp;</td>';
		icerik_ += '<td rel="kolon_23" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_23')>display:none;</cfif>">&nbsp;</td>';
		icerik_ += '<td rel="kolon_24" style=" <cfif listfind(hide_col_list,'kolon_24')>display:none;</cfif>" nowrap>&nbsp;</td>';
		icerik_ += '<td rel="kolon_25" style=" <cfif listfind(hide_col_list,'kolon_25')>display:none;</cfif>" nowrap>&nbsp;</td>';
        icerik_ += '</tr>';
    </cfoutput>
</cfoutput>

id_ = document.getElementById('product_row_<cfoutput>#attributes.old_product_id#</cfoutput>');
$(icerik_).insertAfter(id_);
</script>

<cfset p_count = 0>
<cfset last_cat_id_ = "">
<cfset group_miktar_total = 0>
<cfset group_tutar_total = 0>
<cfset ort_sat = 0>
<cfset all_p_list = listdeleteduplicates(valuelist(get_products.product_id))>
<cfset bugun_deger_ = day(now()) + (month(now()) * 30) + (year(now()) * 365)>

<cfquery name="ortalama_liste_satis_tutar" dbtype="query">
    SELECT SUM(ROW_ORT_STOK_SATIS_MIKTARI * LISTE_FIYATI) TOTAL_SALE FROM get_products 
</cfquery>
<cfset ort_liste_satis_tutar = #ortalama_liste_satis_tutar.total_sale#>

<cfoutput query="get_products" group="product_id">
<cfsavecontent variable="product_icerik_#product_id#">

<cfif len(OZEL_PRICE_TYPE) or len(P_OZEL_PRICE_TYPE)>
	<cfset price_style = "color:red;">
    <cfset PRICE_CONTROL = -1>
<cfelse>
    <cfset price_style = "color:##000;">
    <cfset PRICE_CONTROL = 1>
</cfif>

<cfif isdefined("attributes.print_action") and get_price_all.recordcount>
	<cfquery name="get_action_price" dbtype="query">
    	SELECT * FROM get_price_all WHERE PRODUCT_ID = #product_id#
    </cfquery>
</cfif>

<cfset ss_price_ = TLFormat(STANDART_SALE_PRICE_KDV,session.ep.our_company_info.purchase_price_round_num)>

<cfif isdefined("get_table_info.READ_FIRST_SATIS_PRICE_KDV_#product_id#")>
	<cfset ssn_price_ = evaluate("get_table_info.READ_FIRST_SATIS_PRICE_KDV_#product_id#")>
<cfelse>
    <cfset ssn_price_ = TLFormat(STANDART_SALE_PRICE_KDV,session.ep.our_company_info.purchase_price_round_num)>
</cfif>

<cfif ssn_price_ neq ss_price_>
	<cfset ssn_active_ = 1>
<cfelse>
	<cfset ssn_active_ = 0>
</cfif>

<cfset ssa_price_ = TLFormat(price_standart_kdv,2)>
<cfif isdefined("get_table_info.STANDART_ALIS_KDVLI_#product_id#")>
	<cfset ssna_price_ = TLFormat(filterNum(evaluate("get_table_info.STANDART_ALIS_KDVLI_#product_id#")),2)>
<cfelse>
    <cfset ssna_price_ = TLFormat(price_standart_kdv,2)>
</cfif>

<cfif ssna_price_ neq ssa_price_>
	<cfset ssa_active_ = 1>
<cfelse>
	<cfset ssa_active_ = 0>
</cfif>

<cfset p_count = p_count + 1>
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
    <cfquery name="ortalama_satis" dbtype="query">
        SELECT SUM(ROW_ORT_STOK_SATIS_MIKTARI) TOTAL_STOCK FROM get_products WHERE PRODUCT_ID = #product_id#
    </cfquery>
    <cfquery name="ortalama_satis_tutar" dbtype="query">
        SELECT SUM(ROW_ORT_STOK_SATIS_MIKTARI * LISTE_FIYATI) TOTAL_SALE FROM get_products WHERE PRODUCT_ID = #product_id#
    </cfquery>
    <cfset product_total_stock = URUN_STOCK>
	<cfset yoldaki_stok = get_total_yoldaki.TOTAL_STOCK>
    <cfset yoldaki_stok_tutar = get_total_yoldaki_tutar.TOTAL_STOCK>
    
    <cfset ORT_SATIS_MIKTARI = ROW_ORT_STOK_SATIS_MIKTARI>
    
    
    <cfset stock_count_ = listlen(listdeleteduplicates(valuelist(get_stocks.STOCK_ID)))>
        <cfif (p_count neq 1 and last_cat_id_ neq product_catid)>
            <cfif not isdefined("attributes.print_action")>
            <tr row_type="total_row" id="total_row_#product_catid#">
                <cfloop from="1" to="#listlen(kolon_sira)#" index="ccc">
					<cfif listfind(hide_col_list,'kolon_#ccc#')>
                        <td rel="kolon_#ccc#" style="display:none;"></td>
                    <cfelse>
                        <td rel="kolon_#ccc#" style="color:white;">
							<cfset mmm_ = listgetat(kolon_sira,ccc)>
                            <cfif mmm_ eq 42>#tlformat(group_miktar_total)#</cfif>
                            <cfif mmm_ eq 46>
                                <cfif group_tutar_total lte 0>
                                    <span style="color:red; font-weight:700;">#tlformat(group_tutar_total)#</span>
                                <cfelse>
                                    #tlformat(group_tutar_total)#
                                </cfif>
                            </cfif>
                        </td>
                    </cfif>
                </cfloop>
            </tr>
            </cfif>
            <cfset group_miktar_total = 0>
            <cfset group_tutar_total = 0>
        </cfif>
        <cfset last_cat_id_ = product_catid>
        <cfif isdefined("get_table_info.product_price_change_#product_id#")>
            <cfset is_price_change_ = evaluate("get_table_info.product_price_change_#product_id#")>
        <cfelse>
            <cfset is_price_change_ = 0>
        </cfif>
        
        <tr class="color-list" id="product_row_#product_id#" ondblclick="get_row_passive('#product_id#');" onclick="get_row_active('#product_id#');" p_id="#product_id#" row_code="p_row_#product_id#">
            <cfsavecontent variable="icerik_1">
            <td rel="kolon_1" style="height:20px;<cfif listfind(hide_col_list,'kolon_1')>display:none;</cfif>">
            <cfset liste_fiyati_kdvli_ = wrk_round(LISTE_FIYATI)>
            <cfset liste_fiyati_ = wrk_round(liste_fiyati_kdvli_ / ((100 + get_products.tax_purchase) / 100))>
			<cfif not isdefined("attributes.print_action")>
                <input type="hidden" name="product_stock_list_#product_id#" id="product_stock_list_#product_id#" value="#listdeleteduplicates(valuelist(get_stocks.STOCK_ID))#"/>
                <div id="liste_fiyati_kdvli_#product_id#" style="display:none;">#tlformat(liste_fiyati_kdvli_)#</div>
                <div id="liste_fiyati_#product_id#" style="display:none;">#tlformat(liste_fiyati_)#</div>
                <div id="s_profit_p_#product_id#" style="display:none;">#s_profit#</div>
				
				<cfif isdefined("get_table_info.upper_product_id_#product_id#")>
                    <cfset upper_product_id_ = evaluate("get_table_info.upper_product_id_#product_id#")>
                <cfelse>
                    <cfset upper_product_id_ = "">
                </cfif>
                <input type="hidden" name="upper_product_id_#product_id#" id="upper_product_id_#product_id#" value="#upper_product_id_#"/>
                
                <cfif isdefined("get_table_info.is_upper_#product_id#")>
                    <cfset is_upper_ = evaluate("get_table_info.is_upper_#product_id#")>
                <cfelse>
                    <cfset is_upper_ = "">
                </cfif>
                <input type="hidden" name="is_upper_#product_id#" id="is_upper_#product_id#" value="#is_upper_#"/>
                
                <cfset deger_ = TLFormat(price_standart,session.ep.our_company_info.purchase_price_round_num)>
                <cfinput type="hidden" name="INFO_STANDART_ALIS_#product_id#" class="moneybox" value="#deger_#" style="width:63px;" readonly="yes">
            </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_2">
            <td rel="kolon_2" style="width:25px; text-align:right; <cfif listfind(hide_col_list,'kolon_2')>display:none;</cfif>" onmouseover="show('row_action_div_#product_id#');" onmouseout="hide('row_action_div_#product_id#');" nowrap>
                <cfif not isdefined("attributes.print_action")>
                    <div id="row_action_div_#product_id#" style="position:absolute; margin-left:5px; padding:5px; display:none; height:15px; background:##FF0">
                        <a href="javascript://" onclick="del_manage_row('#product_id#');"><img src="/images/delete12.gif" /></a>
                        <a href="javascript://" onclick="connect_product('#product_id#');"><img src="/images/pod_edit.gif" /></a>
                    </div>
                    <div id="attach_div_#product_id#" style="position:absolute;<cfif not len(upper_product_id_)>display:none;</cfif>"><img src="/images/attach.gif" /></div>
                    <div id="up_attach_div_#product_id#" style="position:absolute;<cfif not len(is_upper_)>display:none;</cfif>"><img src="/images/attach_green.gif" /></div>
                </cfif>
                <cfset deger_ = p_count>
                #deger_#
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_3">
            <td rel="kolon_3" style=" <cfif listfind(hide_col_list,'kolon_3')>display:none;</cfif>" onmouseover="show('row_view_product_div_#product_id#');" onmouseout="hide('row_view_product_div_#product_id#');" nowrap>
            <cfif not isdefined("attributes.print_action")>
                <cfif isdefined("get_table_info.is_selected_#product_id#")>
                    <cfset deger_ = 1>
                <cfelse>
                    <cfset deger_ = 0>
                </cfif>
                
                <cfif deger_ eq 1>
                	<cfif isdefined("selected_product_id_list")>
						<cfset selected_product_id_list = listappend(selected_product_id_list,product_id)>
                    <cfelse>
                        <cfset selected_product_id_list = product_id>
                    </cfif>
                </cfif>
                <input type="checkbox" name="is_selected_#product_id#" id="is_selected_#product_id#" value="1" onclick="select_row('#product_id#');" <cfif deger_ eq 1>checked</cfif>/>
            </cfif>
			<cfif not isdefined("attributes.print_action")>
                <input type="text" name="product_name_#product_id#" id="product_name_#product_id#" value="#product_name#" style="width:300px;<cfif PRICE_CONTROL eq -1>background-color:#EDDA74;</cfif> <cfif ortalama_satis.total_stock lte min_stock_deger>color:red;<cfelseif ortalama_satis.total_stock lte min_stock_deger_warning>color:##F6F; font-weight:bold;</cfif>"/>
                <div id="row_view_product_div_#product_id#" style=" position:absolute; margin-left:280px; padding:1px; margin-top:1px; display:none; width:25px; height:15px; background:##FF0">
                    <a href="javascript://" onclick="get_product_detail('#product_id#');"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>
                    <cfif listlen(listdeleteduplicates(valuelist(get_stocks.STOCK_ID))) eq 1>                	
                        <a href="#request.self#?fuseaction=stock.detail_stock&pid=#product_id#" target="_blank" class="tableyazi"><img src="/images/plus_thin_p.gif" style="width:7px; height:15px;"   align="absbottom"/></a>                                                  
                    <cfelse>
                        <a href="#request.self#?fuseaction=stock.detail_stock&pid=#product_id#" target="_blank" class="tableyazi"><img src="/images/plus_thin_p.gif" style="width:7px; height:15px;"   align="absbottom"/></a>                                              
                    </cfif>
                </div>
                <cfif listlen(listdeleteduplicates(valuelist(get_stocks.STOCK_ID))) eq 1>          
                	<a href="javascript://" onclick="get_product_stock_row('#product_id#');"><img src="/images/listele.gif" id="p_image_#product_id#" align="absbottom"/></a>      	
                    <a href="javascript://" onclick="get_out_product_stock_row('#product_id#');"><img src="/images/listele_down.gif" id="p_image2_#product_id#" style="display:none;"/></a>
                <cfelse>
                	<a href="javascript://" onclick="get_out_product_stock_row('#product_id#');"><img src="/images/listele_down.gif" id="p_image2_#product_id#" style="display:none;"/></a>
                    <a href="javascript://" onclick="get_product_stock_row('#product_id#');"><img src="/images/listele.gif" id="p_image_#product_id#" align="absbottom"/></a>
                </cfif>
            <cfelse>
            	#product_name#
            </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_50">
            <td rel="kolon_50" style="height:20px;<cfif  listfind(hide_col_list,'kolon_50')>display:none;</cfif>">&nbsp;</td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_4">
                <td rel="kolon_4" style=" <cfif listfind(hide_col_list,'kolon_4')>display:none;</cfif>">
                    <div rel="is_purchase_div" style="<cfif is_purchase_type neq 0>display:none;</cfif>"><input type="checkbox" name="is_purchase_#product_id#" id="is_purchase_#product_id#" value="1" <cfif is_purchase eq 1>checked</cfif>></div>
                    <div rel="is_purchase_c_div" style="<cfif is_purchase_type neq 1>display:none;</cfif>"><input type="checkbox" name="is_purchase_c_#product_id#" id="is_purchase_c_#product_id#" value="1" <cfif is_purchase_c eq 1>checked</cfif>></div>
                    <div rel="is_purchase_m_div" style="<cfif is_purchase_type neq 2>display:none;</cfif>"><input type="checkbox" name="is_purchase_m_#product_id#" id="is_purchase_m_#product_id#" value="1" <cfif is_purchase_m eq 1>checked</cfif>></div>
			    </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_5"><td rel="kolon_5" style=" <cfif listfind(hide_col_list,'kolon_5')>display:none;</cfif>"><input type="checkbox" name="is_sales_#product_id#" id="is_sales_#product_id#" value="1" <cfif is_sales eq 1>checked</cfif>></td></cfsavecontent>
            <cfsavecontent variable="icerik_7">
            <td rel="kolon_7" style="<cfif listfind(hide_col_list,'kolon_7')>display:none;</cfif>" id="barcode_#product_id#">#barcod#</td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_8">
            <td rel="kolon_8" style="<cfif listfind(hide_col_list,'kolon_8')>display:none;</cfif>" id="product_code_#product_id#">#listlast(product_code,'.')#</td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_45">
            <td rel="kolon_45" style="white-space:nowrap; width:55px;<cfif listfind(hide_col_list,'kolon_45')>display:none;</cfif>" nowrap>
            	<input type="hidden" name="product_price_change_lastrowid_#product_id#" id="product_price_change_lastrowid_#product_id#" value="0"/>
				<cfif isdefined("get_table_info.product_price_change_count_#product_id#")>
                    <cfset deger_ = evaluate("get_table_info.product_price_change_count_#product_id#")>
                <cfelse>
                    <cfset deger_ = 0>
                </cfif>
                <input type="hidden" name="product_price_change_count_#product_id#" id="product_price_change_count_#product_id#" value="#deger_#"/>
                
                <cfif isdefined("get_table_info.product_price_change_detail_#product_id#")>
                    <cfset deger_ = evaluate("get_table_info.product_price_change_detail_#product_id#")>
                <cfelse>
                    <cfset deger_ = "">
                </cfif>
                <input type="hidden" name="product_price_change_detail_#product_id#" id="product_price_change_detail_#product_id#" value="#deger_#"/>
                <cfset deger_ = 0>
				<cfif deger_ eq 1>
                    <b id="fiyat_div_a_#product_id#" style="display:inline-block;"><a href="javascript://" onclick="get_pro_prices('#product_id#');"><img src="/images/fiyatlar.gif" alt="Fiyatlandırıldı"/></a></b>
                    <b id="fiyat_div_p_#product_id#" style="display:none;"><a href="javascript://" onclick="get_pro_prices('#product_id#');"><img src="/images/fiyatlar_gray.gif" alt="Fiyatlandırılmadı"/></a></b>
                <cfelse>
                    <b id="fiyat_div_a_#product_id#" style="display:none;"><a href="javascript://" onclick="get_pro_prices('#product_id#');"><img src="/images/fiyatlar.gif" alt="Fiyatlandırıldı"/></a></b>
                    <b id="fiyat_div_p_#product_id#" style="display:inline-block;"><a href="javascript://" onclick="get_pro_prices('#product_id#');"><img src="/images/fiyatlar_gray.gif" alt="Fiyatlandırılmadı"/></a></b>
                </cfif>
            <cfset deger_ = 0>
            <cfif len(OZEL_PRICE_TYPE)>
            	<cfset deger_ = OZEL_PRICE_TYPE>
            </cfif>
            <cfif not isdefined("attributes.print_action")>
                <select name="price_type_#product_id#" id="price_type_#product_id#">
                    <option value="">Seç</option>
                    <cfloop query="get_price_types">
                        <option value="#get_price_types.type_id#" <cfif deger_ eq get_price_types.type_id>selected</cfif>>#get_price_types.TYPE_code#</option>
                    </cfloop>
                </select>
                <a href="javascript://" onclick="get_row_active('#product_id#');set_new_price('#product_id#','3');"><img src="/images/menu_shop.gif" alt="Yeni Fiyat Yap"/></a>
            <cfelse>
            	<cfif isdefined("attributes.print_action") and get_price_all.recordcount and get_action_price.recordcount>
                	<cfset deger_ = get_action_price.price_type>
                <cfelse>
                	<cfset deger_ = "">
                </cfif>
            	<cfloop query="get_price_types">
                    <cfif deger_ eq get_price_types.type_id>#get_price_types.TYPE_NAME#-#get_price_types.TYPE_code#</cfif>
                </cfloop>
            </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_9">
            <td rel="kolon_9" style=" <cfif listfind(hide_col_list,'kolon_9')>display:none;</cfif>" nowrap>
                <cfif isdefined("get_table_info.STANDART_ALIS_#product_id#")>
                    <cfset deger_ = evaluate("get_table_info.STANDART_ALIS_#product_id#")>
                <cfelse>
                    <cfset deger_ = TLFormat(price_standart,session.ep.our_company_info.purchase_price_round_num)>
                </cfif>
            <cfif not isdefined("attributes.print_action")>
                <cfinput type="text" name="STANDART_ALIS_#product_id#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="#deger_#" style="width:63px;" onblur="std_p_discount_calc('#product_id#');"> <!--- hesapla_standart_alis('#product_id#','kdvsiz'); --->
                <a href="javascript://" onclick="get_product_price_detail('#product_id#');"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>
            <cfelse>
            	#deger_#
            </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_71">
            <td rel="kolon_71" style=" <cfif listfind(hide_col_list,'kolon_71')>display:none;</cfif>" nowrap>
                <cfif isdefined("get_table_info.STANDART_ALIS_LISTE_#product_id#")>
                    <cfset deger_ = evaluate("get_table_info.STANDART_ALIS_LISTE_#product_id#")>
                <cfelse>
                    <cfset deger_ = TLFormat(price_standart,session.ep.our_company_info.purchase_price_round_num)>
                </cfif>
            <cfif not isdefined("attributes.print_action")>
                <cfinput type="text" name="STANDART_ALIS_LISTE_#product_id#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="#deger_#" style="width:63px;" readonly="yes">
            <cfelse>
            	#deger_#
            </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_14">
            <cfset deger_ = get_products.tax_purchase>
            <td rel="kolon_14" style="<cfif listfind(hide_col_list,'kolon_14')>display:none;</cfif>" id="STANDART_ALIS_KDV_#product_id#">#deger_#</td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_15"><td rel="kolon_15" class="<cfif ssa_active_ eq 1>ssatis_back_active</cfif>" style=" <cfif listfind(hide_col_list,'kolon_15')>display:none;</cfif>">
                <cfif isdefined("get_table_info.STANDART_ALIS_KDVLI_#product_id#")>
                    <cfset deger_ = evaluate("get_table_info.STANDART_ALIS_KDVLI_#product_id#")>
                <cfelse>
                    <cfset deger_ = TLFormat(price_standart_kdv,session.ep.our_company_info.purchase_price_round_num)>
                </cfif>
            <cfif not isdefined("attributes.print_action")>
                <cfinput type="hidden" name="C_STANDART_ALIS_KDVLI_#product_id#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="#deger_#">
                <cfinput type="text" name="STANDART_ALIS_KDVLI_#product_id#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="#deger_#" style="width:63px;" onBlur="hesapla_standart_alis('#product_id#','kdvli');">
            <cfelse>
            	#deger_#
            </cfif>
            </td>
            </cfsavecontent>
            
            <cfsavecontent variable="icerik_43">
            <td rel="kolon_43" style="<cfif listfind(hide_col_list,'kolon_43')>display:none;</cfif>" class="alis_back">
            <cfset deger_ = "">
			<cfif not isdefined("attributes.print_action")>
                <cfinput type="text" name="p_discount_manuel_#product_id#" class="moneybox" onBlur="p_discount_calc(#product_id#);" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="#deger_#" style="width:63px;">
            <cfelse>
            	<cfif isdefined("attributes.print_action") and get_price_all.recordcount and get_action_price.recordcount>
                	<cfset deger_ = get_action_price.manuel_discount>
                </cfif>
                #deger_#
            </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_72">
            <td rel="kolon_72" style="<cfif listfind(hide_col_list,'kolon_72')>display:none;</cfif>" nowrap class="alis_back">
            <cfset deger_ = TLFormat(price_standart,session.ep.our_company_info.purchase_price_round_num)>
            <cfif not isdefined("attributes.print_action")>
                <cfinput type="text" name="NEW_ALIS_START_#product_id#" class="moneybox" value="#deger_#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" onBlur="p_discount_calc(#product_id#);" style="width:63px;">
            	<a href="javascript://" onclick="get_product_price_detail('#product_id#');"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>
            <cfelse>
            	<cfif isdefined("attributes.print_action") and get_price_all.recordcount and get_action_price.recordcount>
                	<cfset deger_ = tlformat(get_action_price.brut_alis)>
                </cfif>
            	#deger_#
            </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_28">
            <td rel="kolon_28" style="<cfif listfind(hide_col_list,'kolon_28')>display:none;</cfif>" nowrap class="alis_back">
            <cfset deger_ = TLFormat(price_standart,session.ep.our_company_info.purchase_price_round_num)>
			<cfif not isdefined("attributes.print_action")> 
                <cfinput type="text" name="NEW_ALIS_#product_id#" class="moneybox" readonly="yes" value="#deger_#" style="width:63px;">
            <cfelse>
            	<cfif isdefined("attributes.print_action") and get_price_all.recordcount and get_action_price.recordcount>
                	<cfset deger_ = tlformat(get_action_price.new_alis)>
                </cfif>
                #deger_#
            </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_29">
            <td rel="kolon_29" style="<cfif listfind(hide_col_list,'kolon_29')>display:none;</cfif>" nowrap class="alis_back">
            <cfset deger_ = 0>
            <cfif not isdefined("attributes.print_action")>
                <input type="checkbox" value="1" name="is_active_p_#product_id#" id="is_active_p_#product_id#" <cfif deger_ eq 1>checked</cfif>/>
            <cfelse>
            </cfif>
            
            <cfset new_alis_kdv = TLFormat(price_standart_kdv,session.ep.our_company_info.purchase_price_round_num)>
            <cfif not isdefined("attributes.print_action")>
                <cfinput type="text" name="NEW_ALIS_KDVLI_#product_id#" class="moneybox" readonly="yes" passthrough="onkeyup=""return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));""" value="#new_alis_kdv#" style="width:63px;">
            <cfelse>
            	<cfif isdefined("attributes.print_action") and get_price_all.recordcount and get_action_price.recordcount>
                	<cfset deger_ = tlformat(get_action_price.new_alis_kdv)>
                </cfif>
                #new_alis_kdv#
            </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_68">
            	<td rel="kolon_68" style="text-align:right;<cfif listfind(hide_col_list,'kolon_68')>display:none;</cfif>" class="alis_back">&nbsp;</td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_24">
            <td rel="kolon_24" style="<cfif listfind(hide_col_list,'kolon_24')>display:none;</cfif>" nowrap id="p_startdate_#product_id#_td" class="alis_back">
            <cfset deger_ = "">
            <cfif not isdefined("attributes.print_action")>
                <input type="text" name="p_startdate_#product_id#" id="p_startdate_#product_id#" maxlength="10" value="#deger_#" style="width:65px;" onBlur="set_startdate('#product_id#')">
                <cfif not isdefined("attributes.add_action")><cf_wrk_date_image date_field="p_startdate_#product_id#" call_function="set_startdate" call_parameter="#product_id#"></cfif>
            <cfelse>
            	<cfif isdefined("attributes.print_action") and get_price_all.recordcount and get_action_price.recordcount>
                	<cfset deger_ = dateformat(get_action_price.p_startdate,'dd/mm/yyyy')>
                </cfif>
                #deger_#            
            </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_25">
            <td rel="kolon_25" style="<cfif listfind(hide_col_list,'kolon_25')>display:none;</cfif>" nowrap id="p_finishdate_#product_id#_td" class="alis_back">
            <cfset deger_ = "">
            <cfif not isdefined("attributes.print_action")>
                <input type="text" name="p_finishdate_#product_id#" id="p_finishdate_#product_id#" maxlength="10" value="#deger_#" style="width:65px;" onBlur="set_finishdate('#product_id#')">
                <cfif not isdefined("attributes.add_action")><cf_wrk_date_image date_field="p_finishdate_#product_id#" call_function="set_finishdate" call_parameter="#product_id#"></cfif>
            <cfelse>
				<cfif isdefined("attributes.print_action") and get_price_all.recordcount and get_action_price.recordcount>
                	<cfset deger_ = dateformat(get_action_price.p_finishdate,'dd/mm/yyyy')>
                </cfif>
                #deger_#            
            </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_44">
            <td rel="kolon_44" class="satis_back" style="<cfif listfind(hide_col_list,'kolon_44')>display:none;</cfif>" nowrap>
            <cfset deger_ = s_profit>
			<cfif not isdefined("attributes.print_action")>
                <cfinput type="text" name="p_ss_marj_#product_id#" id="p_ss_marj_#product_id#" maxlength="10" value="#deger_#" onBlur="hesapla_first_sales('#product_id#','3');" style="width:30px;">
            <cfelse>
            	 <cfif isdefined("attributes.print_action") and get_price_all.recordcount and get_action_price.recordcount>
                	<cfset deger_ = get_action_price.margin>
                </cfif>
                 #deger_#
            </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_12">
            <td rel="kolon_12" class="satis_back" style="<cfif listfind(hide_col_list,'kolon_12')>display:none;</cfif>" nowrap>
            <cfset deger_ = TLFormat(STANDART_SALE_PRICE,session.ep.our_company_info.purchase_price_round_num)>
			<cfif not isdefined("attributes.print_action")>
                <a href="javascript://" onclick="open_calc_price_window('#product_id#');"><img src="/images/pod_edit.gif" /></a>
                <cfinput type="text" name="FIRST_SATIS_PRICE_#product_id#" style="width:63px;#price_style#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="#deger_#" readonly="yes">
            <cfelse>
            	<cfif isdefined("attributes.print_action") and get_price_all.recordcount and get_action_price.recordcount>
                	<cfset deger_ = tlformat(get_action_price.new_price)>
                </cfif>
            	#deger_#
            </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_26">
            <td rel="kolon_26" class="satis_back" style="<cfif listfind(hide_col_list,'kolon_26')>display:none;</cfif>" nowrap>
			<cfset deger_ = 0>
            <cfif not isdefined("attributes.print_action")>
                <input type="checkbox" value="1" name="is_active_s_#product_id#" id="is_active_s_#product_id#" <cfif deger_ eq 1>checked</cfif>/>
            <cfelse>
            </cfif>     
            <cfset deger_ = TLFormat(STANDART_SALE_PRICE_KDV,session.ep.our_company_info.purchase_price_round_num)>
            
            <cfif isdefined("get_table_info.READ_FIRST_SATIS_PRICE_KDV_#product_id#")>
                <cfset deger__ = evaluate("get_table_info.READ_FIRST_SATIS_PRICE_KDV_#product_id#")>
            <cfelse>
                <cfset deger__ = TLFormat(STANDART_SALE_PRICE_KDV,session.ep.our_company_info.purchase_price_round_num)>
            </cfif>
            <cfset fark = filternum(deger__)-filternum(deger_)>
           	<cfif fark gt 0>
            	<cfif deger__ gt 0>	
                	<cfset oran = tlformat(fark/filternum(deger__)*100)>
                <cfelse>
                	<cfset oran = ''>            	
            	</cfif> 
            <cfelse>
            	<cfset oran = ''>      
            </cfif>   
            <input type="text" name="AVANTAJ_ORAN_#product_id#" id="AVANTAJ_ORAN_#product_id#" value="#oran#" style="background-color:##F1ECEC;width:25px;color:##000000;" readonly > 
            
			<cfif not isdefined("attributes.print_action")>
                <cfinput type="text" name="FIRST_SATIS_PRICE_KDV_#product_id#" class="moneybox" style="width:43px;#price_style#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" onBlur="hesapla_satis('#product_id#','kdvli');" value="#deger_#">
            <cfelse>
            	<cfif isdefined("attributes.print_action") and get_price_all.recordcount and get_action_price.recordcount>
                	<cfset deger_ = tlformat(get_action_price.new_price_kdv)>
                </cfif>
            	#deger_#
            </cfif>            
            
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_27">
            <cfif isdefined("get_table_info.SATIS_LIST_PRICE_#product_id#")>
				<cfset deger_ = evaluate("get_table_info.SATIS_LIST_PRICE_#product_id#")>
            <cfelse>
                <cfset deger_ = TLFormat(SON_MALIYET+SON_MALIYET*(MAX_MARGIN_DEGER/100),session.ep.our_company_info.purchase_price_round_num)>
            </cfif>
            <td rel="kolon_27" style="<cfif listfind(hide_col_list,'kolon_27')>display:none;</cfif> text-align:right;" id="SATIS_LIST_PRICE_#product_id#">#deger_#</td>
            </cfsavecontent>
            
            <cfsavecontent variable="icerik_10">
            <td rel="kolon_10" style="<cfif listfind(hide_col_list,'kolon_10')>display:none;</cfif>" class="alis_back">
            <cfset deger_ = "">
            <cfif not isdefined("attributes.print_action")>
           		<input type="text" name="sales_discount_#product_id#" id="sales_discount_#product_id#" style="width:100px;" value="#deger_#" onblur="p_discount_calc('#product_id#');">
            <cfelse>
            	<cfif isdefined("attributes.print_action") and get_price_all.recordcount and get_action_price.recordcount>
                	<cfset deger_ = "">
                    <cfloop from="1" to="10" index="ddd">
                    	<cfif len(evaluate("get_action_price.discount#ddd#")) and evaluate("get_action_price.discount#ddd#") neq 0>
                        	<cfset deger_ = listappend(deger_,evaluate("get_action_price.discount#ddd#"),'+')>
                        </cfif>
                    </cfloop>
                </cfif>
                #deger_#
            </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_13">
            <td rel="kolon_13" style="<cfif listfind(hide_col_list,'kolon_13')>display:none;</cfif> text-align:right;">
            <cfif not isdefined("attributes.print_action")>
                <a href="javascript://" class="tableyazi" onclick="get_rival_price_list('#product_id#');">#TLFormat(avg_rival,2)#</a>
            <cfelse>
            	#TLFormat(avg_rival,2)#
            </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_11"><td rel="kolon_11" class="style="text-align:right;  <cfif listfind(hide_col_list,'kolon_11')>display:none;</cfif>">#TLFormat(ortalama_satis.total_stock,2)#</td></cfsavecontent>
            <cfsavecontent variable="icerik_30">
                <td rel="kolon_30" class="sinfo_back" style="text-align:right;  <cfif listfind(hide_col_list,'kolon_30')>display:none;</cfif>">
                    <cfif URUN_STOCK gt 0 and ORT_SATIS_MIKTARI gt 0>
                        <cfset stockta_yeterlilik_suresi = URUN_STOCK / ORT_SATIS_MIKTARI>
                    <cfelse>
                        <cfset stockta_yeterlilik_suresi = 0>
                    </cfif>
                    <!--- #TLFormat(ortalama_satis.total_stock * URUN_STOCK)# --->
                    #TLFormat(stockta_yeterlilik_suresi)#
                </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_42">
                <td rel="kolon_42" class="sinfo_back" style="white-space:nowrap;<cfif listfind(hide_col_list,'kolon_42')>display:none;</cfif>" nowrap onmouseover="show('product_stock_add_div_#product_id#');" onmouseout="hide('product_stock_add_div_#product_id#');">
                    <cfif PRODUCT_TOTAL_STOCK gt 0>
                        <cfset genel_stok_tutar = (PRODUCT_TOTAL_STOCK * filternum(new_alis_kdv)) + yoldaki_stok_tutar>
                        #TLFormat(genel_stok_tutar)#
                        <cfif not isdefined("attributes.print_action")>
                            <div id="product_stock_add_div_#product_id#" style="background-color:white; position:absolute; display:none; margin-top:-35px;">
                            </div>
                        </cfif>
                    <cfelse>
                        <cfset genel_stok_tutar = 0>
                    </cfif>
                </td>
            </cfsavecontent>
            
             <cfsavecontent variable="icerik_70">
            <td rel="kolon_70" class="satis_back" style="text-align:right;<cfif listfind(hide_col_list,'kolon_70')>display:none;</cfif>">
            <cfset dueday_ = P_DUEDAY>
            <cfif not isdefined("attributes.print_action")>
                <cfinput type="text" name="p_dueday_#product_id#" class="moneybox" maxlength="3" value="#dueday_#" style="width:35px;">
            <cfelse>
            	<cfif isdefined("attributes.print_action") and get_price_all.recordcount and get_action_price.recordcount>
                	<cfset dueday_ = get_action_price.DUEDAY>
                </cfif>
            	#dueday_#
            </cfif>
            </td>
            </cfsavecontent> 
            
            <cfsavecontent variable="icerik_22">
            <cfif isdefined("get_table_info.add_stock_gun_#product_id#") and len(evaluate("get_table_info.add_stock_gun_#product_id#"))>
				<cfset add_stock_gun_ = listfirst(evaluate("get_table_info.add_stock_gun_#product_id#"))>
            <cfelse>
                <cfset add_stock_gun_ = attributes.add_stock_gun>
            </cfif>
            <td rel="kolon_22" class="sip1_back" style="<cfif listfind(hide_col_list,'kolon_22')>display:none;</cfif>" nowrap id="add_stock_gun_#product_id#">#add_stock_gun_#</td>
            </cfsavecontent>
            
            <cfsavecontent variable="icerik_46">
                <cfset gun_total = (dueday_ + add_stock_gun_) - stockta_yeterlilik_suresi>
                <td rel="kolon_46" class="sinfo_back" style="<cfif gun_total lte 0>color:red; font-weight:700;</cfif> <cfif listfind(hide_col_list,'kolon_46')>display:none;</cfif>" nowrap>
                        #TLFormat(gun_total)#
                </td>
            </cfsavecontent>
            <cfset group_miktar_total = group_miktar_total + genel_stok_tutar>
            <cfset group_tutar_total = group_tutar_total + gun_total>
            <cfsavecontent variable="icerik_31">
            	<td rel="kolon_31"  class="sinfo_back" style="text-align:right;  <cfif listfind(hide_col_list,'kolon_31')>display:none;</cfif>">
                	<cfif stock_count_ eq 1 and dept_count_ eq 1>
                    	#tlformat(ROW_STOK_DEVIR_HIZI)#
                    </cfif>
                </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_16"><td rel="kolon_16" class="genel_stock_back" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_16')>display:none;</cfif>">
            	<cfif isdefined("attributes.is_hide_one_stocks") and stock_count_ eq 1>
                    <a href="javascript://" class="tableyazi" onclick="get_stock_list('#stock_id#','stock');">#tlformat(URUN_STOCK,2)#</a>
                <cfelse>
                	#tlformat(URUN_STOCK,2)#
                </cfif>
                </td>
            </cfsavecontent>
           
            <cfsavecontent variable="icerik_17"><td rel="kolon_17" class="magaza_stock_back" style="text-align:right; <cfif listfind(hide_col_list,'kolon_17')>display:none;</cfif>">#tlformat(MAGAZA_STOK,2)#</td></cfsavecontent>
            <cfsavecontent variable="icerik_18"><td rel="kolon_18" class="depo_stock_back" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_18')>display:none;</cfif>">#tlformat(DEPO_STOCK,2)#</td></cfsavecontent>
            <cfsavecontent variable="icerik_33">
            <td rel="kolon_33" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_33')>display:none;</cfif>">
                #yoldaki_stok#
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_32">
            <td rel="kolon_32" class="sip1_back" style="text-align:right; <cfif listfind(hide_col_list,'kolon_32')>display:none;</cfif>">
                <cfif stock_count_ eq 1 and dept_count_ eq 1>
                    <cfset old_deger_ = "">
                    <cfset siparis_miktari_p = 0>
					<cfif isdefined("attributes.calc_type") and attributes.calc_type eq 1>
                    	<cfif not len(ROW_ORT_STOK_SATIS_MIKTARI)>
                            <cfset siparis_miktari_p = 0>
                        <cfelse>
                            <cfset siparis_miktari_p = Ceiling(ROW_ORT_STOK_SATIS_MIKTARI * attributes.order_day)>
                            
							<cfif isdefined("attributes.real_stock")>
                                <cfset siparis_miktari_p = siparis_miktari_p - row_stock>
                            </cfif>		
                            <cfif isdefined("attributes.way_stock")>
                            	<cfset siparis_miktari_p = siparis_miktari_p - PURCHASE_ORDER_QUANTITY> 
                            </cfif>                             
                            <cfif siparis_miktari_p lt 0>
                                <cfset siparis_miktari_p = 0>
                            </cfif>
                        </cfif>
                        #tlformat(siparis_miktari_p)#
                    <cfelse>
                    	#old_deger_#
                    </cfif>
               </cfif>
            </td>
            </cfsavecontent>
            
            
            <cfsavecontent variable="icerik_56">
            <td rel="kolon_56" class="sip2_back" style="text-align:right; <cfif listfind(hide_col_list,'kolon_56')>display:none;</cfif>">
                <cfif stock_count_ eq 1 and dept_count_ eq 1>
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
                               
                            <cfif siparis_miktari_p2 lt 0>
                                <cfset siparis_miktari_p2 = 0>
                            </cfif>
                        </cfif>
                        #tlformat(siparis_miktari_p2)#
                    <cfelse>
                    	#old_deger_#
                    </cfif>
               </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_40">
            <td rel="kolon_40" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_40')>display:none;</cfif>" id="multiplier_#product_id#"><cfif len(multiplier)>#multiplier#</cfif></td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_34">
            <td rel="kolon_34" class="sip1_back" style="text-align:right; <cfif listfind(hide_col_list,'kolon_34')>display:none;</cfif>" nowrap>
                <cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_#product_id#") and len(evaluate("get_table_info.STOCK_SATIS_AMOUNT_#product_id#")) and (not isdefined("attributes.calc_type") or listfind('0,3',attributes.calc_type))>
                    <cfset sip_1_miktar = evaluate("get_table_info.STOCK_SATIS_AMOUNT_#product_id#")>
                <cfelseif stock_count_ eq 1 and dept_count_ eq 1>
                    <cfset sip_1_miktar = tlformat(siparis_miktari_p)>
                <cfelse>
                    <cfset sip_1_miktar = "0">
                </cfif>
                <cfif not isdefined("attributes.print_action")>
                    <cfinput type="text" name="STOCK_SATIS_AMOUNT_#product_id#" class="moneybox" onkeyup="hesapla_koli('STOCK_SATIS_AMOUNT_#product_id#','STOCK_SATIS_AMOUNT_KOLI_#product_id#','multiplier_#product_id#');" onBlur="duzenle_adet_koli('STOCK_SATIS_AMOUNT_#product_id#','STOCK_SATIS_AMOUNT_KOLI_#product_id#','multiplier_#product_id#','liste_fiyati_#product_id#','liste_fiyati_kdvli_#product_id#','STOCK_SATIS_AMOUNT_TUTAR_#product_id#','STOCK_SATIS_AMOUNT_TUTAR_KDVLI_#product_id#','0','#product_id#');" value="#sip_1_miktar#" style="width:70px;">
                    <a href="javascript://" onclick="set_down_object('product_group_name','STOCK_SATIS_AMOUNT_#product_id#','STOCK_SATIS_AMOUNT_#product_id#');set_down_object('product_group_name','STOCK_SATIS_AMOUNT_KOLI_#product_id#','STOCK_SATIS_AMOUNT_KOLI_#product_id#');"><img src="/images/listele_down.gif" /></a>
            	<cfelse>
                	#sip_1_miktar#
                </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_35">
            <td rel="kolon_35" class="sip1_back" style="text-align:right; <cfif listfind(hide_col_list,'kolon_35')>display:none;</cfif>" nowrap>
                <cfif len(multiplier)>
                    <cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_KOLI_#product_id#") and len(evaluate("get_table_info.STOCK_SATIS_AMOUNT_KOLI_#product_id#")) and (not isdefined("attributes.calc_type") or listfind('0,3',attributes.calc_type))>
                        <cfset deger_ = evaluate("get_table_info.STOCK_SATIS_AMOUNT_KOLI_#product_id#")>
                    <cfelseif stock_count_ eq 1 and dept_count_ eq 1>
                        <cfset deger_ = tlformat(siparis_miktari_p / multiplier)>
                    <cfelse>
                        <cfset deger_ = "">
                    </cfif>
                    <cfif not isdefined("attributes.print_action")>
                        <cfinput type="text" name="STOCK_SATIS_AMOUNT_KOLI_#product_id#" class="moneybox" onkeyup="hesapla_adet('STOCK_SATIS_AMOUNT_#product_id#','STOCK_SATIS_AMOUNT_KOLI_#product_id#','multiplier_#product_id#');" onBlur="duzenle_adet_koli('STOCK_SATIS_AMOUNT_#product_id#','STOCK_SATIS_AMOUNT_KOLI_#product_id#','multiplier_#product_id#','liste_fiyati_#product_id#','liste_fiyati_kdvli_#product_id#','STOCK_SATIS_AMOUNT_TUTAR_#product_id#','STOCK_SATIS_AMOUNT_TUTAR_KDVLI_#product_id#','0','#product_id#');" value="#deger_#" style="width:60px;">
                        <a href="javascript://" onclick="set_down_object('product_group_name','STOCK_SATIS_AMOUNT_#product_id#','STOCK_SATIS_AMOUNT_#product_id#');set_down_object('product_group_name','STOCK_SATIS_AMOUNT_KOLI_#product_id#','STOCK_SATIS_AMOUNT_KOLI_#product_id#');"><img src="/images/listele_down.gif" /></a>
                	<cfelse>
                    	#deger_#
                    </cfif>
                </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_51">
                <cfset deger_ = tlformat(liste_fiyati_ * filternum(sip_1_miktar))>
                <td rel="kolon_51" class="sip1_back" style="text-align:right; <cfif listfind(hide_col_list,'kolon_51')>display:none;</cfif>" id="STOCK_SATIS_AMOUNT_TUTAR_#product_id#">#deger_#</td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_53">
                <cfset deger_ = tlformat(liste_fiyati_kdvli_ * filternum(sip_1_miktar))>
                <td rel="kolon_53" class="sip1_back" style="text-align:right; <cfif listfind(hide_col_list,'kolon_53')>display:none;</cfif>" id="STOCK_SATIS_AMOUNT_TUTAR_KDVLI_#product_id#">#deger_#</td>
            </cfsavecontent>
                          
            <cfsavecontent variable="icerik_36">
            <td rel="kolon_36" class="sip1_back" style="text-align:right; <cfif listfind(hide_col_list,'kolon_36')>display:none;</cfif>" nowrap id="order_date_1_#product_id#_td">
                <cfif isdefined("get_table_info.order_date_1_#product_id#") and (not isdefined("attributes.calc_type")  or listfind('0,3',attributes.calc_type))>
                    <cfset deger_ = evaluate("get_table_info.order_date_1_#product_id#")>
                <cfelse>
                    <cfset deger_ = dateformat(now(),'dd/mm/yyyy')>
                </cfif>
                <cfif not isdefined("attributes.print_action")>
                    <input type="text" name="order_date_1_#product_id#" id="order_date_1_#product_id#" maxlength="10" value="#deger_#" style="width:65px;">
                    <cfif not isdefined("attributes.add_action")><cf_wrk_date_image date_field="order_date_1_#product_id#"></cfif>
                <cfelse>
                	#deger_#
                </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_37">
            <td rel="kolon_37" class="sip2_back" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_37')>display:none;</cfif>" nowrap>
                <cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_2_#product_id#") and (not isdefined("attributes.calc_type")  or listfind('0,3',attributes.calc_type))>
                    <cfset deger_ = evaluate("get_table_info.STOCK_SATIS_AMOUNT_2_#product_id#")>
                <cfelseif stock_count_ eq 1 and dept_count_ eq 1>
                    <cfset deger_ = tlformat(siparis_miktari_p2)>
                <cfelse>
                    <cfset deger_ = "">
                </cfif>
                <cfif not isdefined("attributes.print_action")>
                    <cfinput type="text" name="STOCK_SATIS_AMOUNT_2_#product_id#" class="moneybox" onkeyup="hesapla_koli('STOCK_SATIS_AMOUNT_2_#product_id#','STOCK_SATIS_AMOUNT_KOLI_2_#product_id#','multiplier_#product_id#');" onBlur="duzenle_adet_koli('STOCK_SATIS_AMOUNT_2_#product_id#','STOCK_SATIS_AMOUNT_KOLI_2_#product_id#','multiplier_#product_id#','liste_fiyati_#product_id#','liste_fiyati_kdvli_#product_id#','STOCK_SATIS_AMOUNT_TUTAR_2_#product_id#','STOCK_SATIS_AMOUNT_TUTAR_KDVLI_2_#product_id#','0','#product_id#');" value="#deger_#" style="width:70px;">
                    <a href="javascript://" onclick="set_down_object('product_group_name','STOCK_SATIS_AMOUNT_2_#product_id#','STOCK_SATIS_AMOUNT_2_#product_id#');set_down_object('product_group_name','STOCK_SATIS_AMOUNT_KOLI_2_#product_id#','STOCK_SATIS_AMOUNT_KOLI_2_#product_id#');"><img src="/images/listele_down.gif" /></a>
            	<cfelse>
                	#deger_#
                </cfif>
            </td>
            </cfsavecontent>
            
            <cfsavecontent variable="icerik_52">
            	<cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_TUTAR_2_#product_id#")>
					<cfset deger_ = evaluate("get_table_info.STOCK_SATIS_AMOUNT_TUTAR_2_#product_id#")>
                <cfelseif stock_count_ eq 1 and dept_count_ eq 1>
                    <cfset deger_ = tlformat(liste_fiyati_ * siparis_miktari_p2)>
                <cfelse>
                    <cfset deger_ = "">
                </cfif>
                <td rel="kolon_52" class="sip2_back" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_52')>display:none;</cfif>" id="STOCK_SATIS_AMOUNT_TUTAR_2_#product_id#">#deger_#</td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_54">
            	<cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_TUTAR_KDVLI_2_#product_id#")>
					<cfset deger_ = evaluate("get_table_info.STOCK_SATIS_AMOUNT_TUTAR_KDVLI_2_#product_id#")>
                <cfelseif stock_count_ eq 1 and dept_count_ eq 1>
                    <cfset deger_ = tlformat(liste_fiyati_kdvli_ * siparis_miktari_p2)>
                <cfelse>
                    <cfset deger_ = "">
                </cfif>
                <td rel="kolon_54" class="sip2_back" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_54')>display:none;</cfif>" id="STOCK_SATIS_AMOUNT_TUTAR_KDVLI_2_#product_id#">#deger_#</td>
            </cfsavecontent>
            
            <cfsavecontent variable="icerik_38">
            <td rel="kolon_38" class="sip2_back" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_38')>display:none;</cfif>" nowrap>
                <cfif len(multiplier)>
                    <cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_KOLI_2_#product_id#") and (not isdefined("attributes.calc_type") or listfind('0,3',attributes.calc_type))>
                        <cfset deger_ = evaluate("get_table_info.STOCK_SATIS_AMOUNT_KOLI_2_#product_id#")>
                    <cfelseif stock_count_ eq 1 and dept_count_ eq 1>
                        <cfset deger_ = tlformat(siparis_miktari_p2 / multiplier)>
                    <cfelse>
                        <cfset deger_ = "">
                    </cfif>
                    <cfif not isdefined("attributes.print_action")>
                        <cfinput type="text" name="STOCK_SATIS_AMOUNT_KOLI_2_#product_id#" class="moneybox" onkeyup="hesapla_adet('STOCK_SATIS_AMOUNT_2_#product_id#','STOCK_SATIS_AMOUNT_KOLI_2_#product_id#','multiplier_#product_id#');" onBlur="duzenle_adet_koli('STOCK_SATIS_AMOUNT_2_#product_id#','STOCK_SATIS_AMOUNT_KOLI_2_#product_id#','multiplier_#product_id#','liste_fiyati_#product_id#','liste_fiyati_kdvli_#product_id#','STOCK_SATIS_AMOUNT_TUTAR_2_#product_id#','STOCK_SATIS_AMOUNT_TUTAR_KDVLI_2_#product_id#','0','#product_id#');" value="#deger_#" style="width:60px;">
                        <a href="javascript://" onclick="set_down_object('product_group_name','STOCK_SATIS_AMOUNT_2_#product_id#','STOCK_SATIS_AMOUNT_2_#product_id#');set_down_object('product_group_name','STOCK_SATIS_AMOUNT_KOLI_2_#product_id#','STOCK_SATIS_AMOUNT_KOLI_2_#product_id#');"><img src="/images/listele_down.gif" /></a>
                	<cfelse>
                    	#deger_#
                    </cfif>
                </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_39">
            <td rel="kolon_39" class="sip2_back" style="text-align:right; <cfif listfind(hide_col_list,'kolon_39')>display:none;</cfif>" nowrap id="order_date_2_#product_id#_td">
                <cfif isdefined("get_table_info.order_date_2_#product_id#") and (not isdefined("attributes.calc_type") or listfind('0,3',attributes.calc_type))>
                    <cfset deger_ = evaluate("get_table_info.order_date_2_#product_id#")>
                <cfelse>
                    <cfset deger_ = dateformat(dateadd('d',15,now()),'dd/mm/yyyy')>
                </cfif>
                <cfif not isdefined("attributes.print_action")>
                    <input type="text" name="order_date_2_#product_id#" id="order_date_2_#product_id#" maxlength="10" value="#deger_#" style="width:65px;">
                    <cfif not isdefined("attributes.add_action")><cf_wrk_date_image date_field="order_date_2_#product_id#"></cfif>
                    <!--- <a href="javascript://" onclick="set_down_object('product_group_name','order_date_2_#product_id#','order_date_2_#product_id#');"><img src="/images/listele_down.gif" /></a> --->
            	<cfelse>
                	#deger_#
                </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_41">
            	<td rel="kolon_41" nowrap style=" text-align:right; <cfif listfind(hide_col_list,'kolon_41')>display:none;</cfif>">
					<cfif isdefined("get_table_info.company_name_#product_id#")>
                        <cfset deger_ = evaluate("get_table_info.company_name_#product_id#")>
                    <cfelse>
                        <cfset deger_ = NICKNAME>
                        <cfif len(project)>
                        	<cfset deger_ = deger_ & ' - ' & project>
                        </cfif>
                    </cfif>
                    <cfif not isdefined("attributes.print_action")>
                    	<input type="text" name="company_name_#product_id#" id="company_name_#product_id#" value="<cfif isdefined('attributes.company') and len(attributes.company)>#attributes.company#<cfelse>#deger_#</cfif>" style="width:100px;" readonly/>
                    <cfelse>
                    	#deger_#
                    </cfif>
                    
                    <cfif isdefined("get_table_info.company_id_#product_id#")>
                        <cfset deger_ = evaluate("get_table_info.company_id_#product_id#")>
                    <cfelse>
                        <cfset deger_ = company_id>
                    </cfif>
                    <cfif not isdefined("attributes.print_action")>
                    	<input type="hidden" name="company_id_#product_id#" id="company_id_#product_id#" value="<cfif isdefined('attributes.company_id') and len(attributes.company_id)>#attributes.company_id#<cfelse>#deger_#</cfif>" style="width:100px;" readonly/>
                    </cfif>
                    
                    <cfif isdefined("get_table_info.project_id_#product_id#")>
                        <cfset deger_ = evaluate("get_table_info.project_id_#product_id#")>
                    <cfelse>
                        <cfset deger_ = project_id>
                    </cfif>
                    
                    <cfif not isdefined("attributes.print_action")>          
                        <input type="hidden" name="project_id_#product_id#" id="project_id_#product_id#" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)>#attributes.project_id#<cfelse>#deger_#</cfif>" style="width:100px;" readonly/>
                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_manufact_comps&field_project_id=info_form.project_id_#product_id#&field_comp_name=info_form.company_name_#product_id#&field_comp_id=info_form.company_id_#product_id#','list','popup_list_pars');"><img src="/images/plus_thin.gif"></a>
                        <!--- <a href="javascript://" onclick="set_down_object('product_group_name','company_name_#product_id#','company_name_#product_id#');set_down_object('product_group_name','project_id_#product_id#','project_id_#product_id#');set_down_object('product_group_name','company_id_#product_id#','company_id_#product_id#');"><img src="/images/listele_down.gif" /></a> --->
                    </cfif>
                </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_20">
            <td rel="kolon_20" class="satis_back" style="<cfif listfind(hide_col_list,'kolon_20')>display:none;</cfif>" nowrap id="startdate_#product_id#_td">
            <!---
                <cfif isdefined("get_table_info.startdate_#product_id#")>
                    <cfset deger_ = evaluate("get_table_info.startdate_#product_id#")>
                <cfelseif len(PRICE_START)>
                	<cfset deger_ = dateformat(PRICE_START,'dd/mm/yyyy')>
                <cfelse>
                    <cfset deger_ = dateformat(dateadd("d",1,now()),'dd/mm/yyyy')>
                </cfif>
            --->
            <cfset deger_ = "">
			<cfif not isdefined("attributes.print_action")>
                <input type="text" name="startdate_#product_id#" id="startdate_#product_id#" maxlength="10" value="#deger_#" style="width:65px;">
                <cfif not isdefined("attributes.add_action")><cf_wrk_date_image date_field="startdate_#product_id#"></cfif>
            <cfelse>
            	<cfif isdefined("attributes.print_action") and get_price_all.recordcount and get_action_price.recordcount>
                	<cfset deger_ = dateformat(get_action_price.startdate,'dd/mm/yyyy')>
                </cfif>
            	#deger_#
            </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_21">
            <td rel="kolon_21" class="satis_back" style="<cfif listfind(hide_col_list,'kolon_21')>display:none;</cfif>" nowrap id="finishdate_#product_id#_td">
             <!---
                <cfif isdefined("get_table_info.finishdate_#product_id#")>
                    <cfset deger_ = evaluate("get_table_info.finishdate_#product_id#")>
                <cfelse>
                    <cfset deger_ = dateformat(PRICE_FINISH,'dd/mm/yyyy')>
                </cfif>
			--->
            <cfset deger_ = "">
            <cfif not isdefined("attributes.print_action")>
                <input type="text" name="finishdate_#product_id#" id="finishdate_#product_id#" maxlength="10" value="#deger_#" style="width:65px;">
                <cfif not isdefined("attributes.add_action")><cf_wrk_date_image date_field="finishdate_#product_id#"></cfif>
            <cfelse>
            	<cfif isdefined("attributes.print_action") and get_price_all.recordcount and get_action_price.recordcount>
                	<cfset deger_ = dateformat(get_action_price.finishdate,'dd/mm/yyyy')>
                </cfif>
            	#deger_#
            </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_47">
            <td rel="kolon_47" class="ssatis_back" style="text-align:right;<cfif listfind(hide_col_list,'kolon_47')>display:none;</cfif>">
                <cfif isdefined("get_table_info.READ_FIRST_SATIS_PRICE_#product_id#")>
    
                    <cfset deger_ = evaluate("get_table_info.READ_FIRST_SATIS_PRICE_#product_id#")>
                <cfelse>
                    <cfset deger_ = TLFormat(STANDART_SALE_PRICE,session.ep.our_company_info.purchase_price_round_num)>
                </cfif>
            <cfif not isdefined("attributes.print_action")>
                <cfinput type="text" name="READ_FIRST_SATIS_PRICE_#product_id#" class="moneybox" value="#deger_#" style="width:63px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" onBlur="hesapla_standart_satis('#product_id#','kdvsiz');">
            <cfelse>
           		#deger_#
            </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_19">
            <cfset deger_ = get_products.tax>
            <td rel="kolon_19" class="ssatis_back" style="<cfif listfind(hide_col_list,'kolon_19')>display:none;</cfif>" id="STANDART_SATIS_KDV_#product_id#">#deger_#</td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_6">
            <td rel="kolon_6" class="<cfif ssn_active_ eq 1>ssatis_back_active<cfelse>ssatis_back</cfif>" style="<cfif listfind(hide_col_list,'kolon_6')>display:none;</cfif>" nowrap>
              <cfset deger_ = 0>              
            <cfif not isdefined("attributes.print_action")>
                <input type="hidden" name="c_is_active_ss_#product_id#" id="c_is_active_ss_#product_id#" value="#deger_#"/>
                <input type="checkbox" value="1" name="is_active_ss_#product_id#" id="is_active_ss_#product_id#" <cfif deger_ eq 1>checked</cfif>/>
            <cfelse>
            </cfif>
			<cfif isdefined("get_table_info.READ_FIRST_SATIS_PRICE_KDV_#product_id#")>
                <cfset deger_ = evaluate("get_table_info.READ_FIRST_SATIS_PRICE_KDV_#product_id#")>
            <cfelse>
                <cfset deger_ = TLFormat(STANDART_SALE_PRICE_KDV,session.ep.our_company_info.purchase_price_round_num)>
            </cfif>
            <cfif not isdefined("attributes.print_action")>
                <cfinput type="hidden" name="C_READ_FIRST_SATIS_PRICE_KDV_#product_id#" class="moneybox" value="#deger_#">
                <cfinput type="text" name="READ_FIRST_SATIS_PRICE_KDV_#product_id#" class="moneybox" value="#deger_#" style="width:63px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" onBlur="hesapla_standart_satis('#product_id#','kdvli');oran_hesapla('#product_id#');">
            <cfelse>
            	#deger_#
            </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_23">
            <td rel="kolon_23" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_23')>display:none;</cfif>">
            	<cfif stock_count_ eq 1>
                    <a href="javascript://" class="tableyazi" onclick="get_cost_list('#product_id#','#stock_id#');">#TLFormat(SON_MALIYET)#</a>
                </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_48">
            <td rel="kolon_48" class="satis_back" style="text-align:right;<cfif listfind(hide_col_list,'kolon_48')>display:none;</cfif>">
            <cfset deger_ = "% #tlformat(0)#">
            <cfif not isdefined("attributes.print_action")>
                <cfinput type="text" name="READ_FIRST_SATIS_PRICE_RATE_#product_id#" class="moneybox" value="#deger_#" style="width:63px;" readonly>
            <cfelse>
            	<cfif isdefined("attributes.print_action") and get_price_all.recordcount and get_action_price.recordcount>
                	<cfset deger_ = get_action_price.change_rate>
                </cfif>
            	#deger_#
            </cfif>
            </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_69">
            	<td rel="kolon_69" class="satis_back" style="text-align:right;<cfif listfind(hide_col_list,'kolon_69')>display:none;</cfif>">&nbsp;</td>
            </cfsavecontent>
           
            <cfsavecontent variable="icerik_49"><td rel="kolon_49" style="text-align:right; <cfif listfind(hide_col_list,'kolon_49')>display:none;</cfif>"></td></cfsavecontent>
            <cfsavecontent variable="icerik_55">
            <td rel="kolon_55" class="sip2_back" style="<cfif listfind(hide_col_list,'kolon_55')>display:none;</cfif>" nowrap>#maximum_stock#-#order_limit#-#minimum_stock#</td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_57">
                <td rel="kolon_57" style="<cfif listfind(hide_col_list,'kolon_57')>display:none;</cfif>" nowrap>
                    <cfif isdefined("get_table_info.std_p_discount_manuel_#product_id#")>
                        <cfset deger_ = evaluate("get_table_info.std_p_discount_manuel_#product_id#")>
                    <cfelse>
                        <cfset deger_ = "">
                    </cfif>
                <cfif not isdefined("attributes.print_action")>
                    <cfinput type="text" name="std_p_discount_manuel_#product_id#" class="moneybox" onBlur="std_p_discount_calc(#product_id#);" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" value="#deger_#" style="width:63px;">
                <cfelse>
                	#deger_#
                </cfif>
                </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_58">
                <td rel="kolon_58" style="<cfif listfind(hide_col_list,'kolon_58')>display:none;</cfif>" nowrap>
                    <cfif isdefined("get_table_info.std_sales_discount_#product_id#")>
                        <cfset deger_ = evaluate("get_table_info.std_sales_discount_#product_id#")>
                    <cfelse>
                        <cfset deger_ = "">
                    </cfif>
                <cfif not isdefined("attributes.print_action")>
                    <input type="text" name="std_sales_discount_#product_id#" id="std_sales_discount_#product_id#" style="width:50px;" value="#deger_#" onblur="std_p_discount_calc('#product_id#');">
                <cfelse>
                	#deger_#
                </cfif>
                </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_59">
                <td rel="kolon_59" style="<cfif listfind(hide_col_list,'kolon_59')>display:none;</cfif>" nowrap id="std_p_startdate_#product_id#_td">
                    <cfif isdefined("get_table_info.std_p_startdate_#product_id#")>
                        <cfset deger_ = evaluate("get_table_info.std_p_startdate_#product_id#")>
                    <cfelse>
                        <cfset deger_ = "">
                    </cfif>
                <cfif not isdefined("attributes.print_action")>
                    <input type="text" name="std_p_startdate_#product_id#" id="std_p_startdate_#product_id#" maxlength="10" value="#deger_#" style="width:65px;">
                    <cfif not isdefined("attributes.add_action")><cf_wrk_date_image date_field="std_p_startdate_#product_id#"></cfif>
                <cfelse>
                	#deger_#
                </cfif>
                </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_73">
                <td rel="kolon_73" class="ssatis_back" style="<cfif listfind(hide_col_list,'kolon_73')>display:none;</cfif>" nowrap id="std_s_startdate_#product_id#_td">
                    <cfif isdefined("get_table_info.std_s_startdate_#product_id#")>
                        <cfset deger_ = evaluate("get_table_info.std_s_startdate_#product_id#")>
                    <cfelse>
                        <cfset deger_ = "">
                    </cfif>
            <cfif not isdefined("attributes.print_action")>
                <input type="text" name="std_s_startdate_#product_id#" id="std_s_startdate_#product_id#" maxlength="10" value="#deger_#" style="width:65px;">
                <cfif not isdefined("attributes.add_action")><cf_wrk_date_image date_field="std_s_startdate_#product_id#"></cfif>
            <cfelse>
            	#deger_#
            </cfif>
                </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_60">
                <td rel="kolon_60" style="<cfif listfind(hide_col_list,'kolon_60')>display:none;</cfif>" nowrap class="alis_back">
                    <cfif isdefined("get_table_info.p_marj_#product_id#")>
                    <cfset deger_ = evaluate("get_table_info.p_marj_#product_id#")>
                <cfelse>
                    <cfset deger_ = p_profit>
                </cfif>
            <cfif not isdefined("attributes.print_action")>
                <cfinput type="text" name="p_marj_#product_id#" id="p_marj_#product_id#" maxlength="10" value="#deger_#" style="width:30px;" onBlur="hesapla_profit_p_to_s('#product_id#')">
            <cfelse>
            	<cfif isdefined("attributes.print_action") and get_price_all.recordcount and get_action_price.recordcount>
                	<cfset deger_ = get_action_price.p_margin>
                </cfif>
            	#deger_#
            </cfif>
                </td>
            </cfsavecontent>
            
            <cfsavecontent variable="icerik_61">
                <td rel="kolon_61" style=" <cfif listfind(hide_col_list,'kolon_61')>display:none;</cfif>" nowrap>
                <cfif isdefined("get_table_info.p_profit_#product_id#")>
                    <cfset deger_ = evaluate("get_table_info.p_profit_#product_id#")>
                <cfelse>
                    <cfset deger_ = p_profit>
                </cfif>
           <cfif not isdefined("attributes.print_action")>
                <cfinput type="text" name="p_profit_#product_id#" id="p_profit_#product_id#" maxlength="10" value="#deger_#" style="width:30px;" onBlur="hesapla_std_profit_p_to_s('#product_id#')">
           <cfelse>
           		#deger_#
           </cfif>
                </td>
            </cfsavecontent>
            
            <cfsavecontent variable="icerik_62">
                <td rel="kolon_62" class="ssatis_back" style="<cfif listfind(hide_col_list,'kolon_62')>display:none;</cfif>" nowrap>
                <cfif isdefined("get_table_info.s_profit_#product_id#")>
                    <cfset deger_ = evaluate("get_table_info.s_profit_#product_id#")>
                <cfelse>
                    <cfif isnumeric(price_standart_kdv) and isnumeric(STANDART_SALE_PRICE_KDV)>
                    	<cfset deger_ = 0>
					<cfelse>
						<cfset deger_ = tlformat(100 - (wrk_round(price_standart_kdv / STANDART_SALE_PRICE_KDV * 100)),4)>
                	</cfif>
                </cfif>
           <cfif not isdefined("attributes.print_action")>
                <cfinput type="text" name="s_profit_#product_id#" id="s_profit_#product_id#" maxlength="10" value="#deger_#" style="width:30px;" onBlur="hesapla_first_sales_std('#product_id#','3')">
           <cfelse>
           		#deger_#
           </cfif>
                </td>
            </cfsavecontent>
            
            <cfsavecontent variable="icerik_63">
                <td rel="kolon_63" class="ssatis_back" style="text-align:right;<cfif listfind(hide_col_list,'kolon_63')>display:none;</cfif>">
                    <cfif isdefined("get_table_info.STANDART_SATIS_PRICE_RATE_#product_id#")>
                        <cfset deger_ = evaluate("get_table_info.STANDART_SATIS_PRICE_RATE_#product_id#")>
                    <cfelse>
                        <cfset deger_ = "% #tlformat(0)#">
                    </cfif>
             <cfif not isdefined("attributes.print_action")>
                    <cfinput type="text" name="STANDART_SATIS_PRICE_RATE_#product_id#" class="moneybox" value="#deger_#" style="width:63px;" readonly>
             <cfelse>
             	#deger_#
             </cfif>
                </td>
            </cfsavecontent>
            
            <cfsavecontent variable="icerik_64">
                <td rel="kolon_64" style="text-align:right;<cfif listfind(hide_col_list,'kolon_64')>display:none;</cfif>">
                    <cfif isdefined("get_table_info.STANDART_ALIS_PRICE_RATE_#product_id#")>
                        <cfset deger_ = evaluate("get_table_info.STANDART_ALIS_PRICE_RATE_#product_id#")>
                    <cfelse>
                        <cfset deger_ = "% #tlformat(0)#">
                    </cfif>
               <cfif not isdefined("attributes.print_action")>
                    <cfinput type="text" name="STANDART_ALIS_PRICE_RATE_#product_id#" class="moneybox" value="#deger_#" style="width:63px;" readonly>
               <cfelse>
               		#deger_#
               </cfif>
                </td>
            </cfsavecontent>
            
            <cfsavecontent variable="icerik_65">
                <cfset deger_ = TLFormat(price_standart_kdv,session.ep.our_company_info.purchase_price_round_num)>
                <td rel="kolon_65" class="ealis_back" style="text-align:right;<cfif listfind(hide_col_list,'kolon_65')>display:none;</cfif>" id="INFO_STANDART_ALIS_KDV_#product_id#">#deger_#</td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_66">
                <td rel="kolon_66" class="ealis_back" style="text-align:right;<cfif listfind(hide_col_list,'kolon_66')>display:none;</cfif>">
				   <cfset deger_ = TLFormat(STANDART_SALE_PRICE_KDV,session.ep.our_company_info.purchase_price_round_num)>
				   <cfif not isdefined("attributes.print_action")> 
                        <!--- <cfinput type="text" name="INFO_STANDART_SATIS_KDVLI_#product_id#" class="moneybox" value="#deger_#" style="width:63px;" readonly="yes"> --->
                   </cfif>                    
                    <cfset deger2_ = TLFormat(STANDART_SALE_PRICE,session.ep.our_company_info.purchase_price_round_num)>
               <cfif not isdefined("attributes.print_action")>
                    <div id="INFO_STANDART_SATIS_#product_id#" style="display:none;">#deger2_#</div>
                    #deger_#
               <cfelse>
               		#deger_#
               </cfif>
                </td>
            </cfsavecontent>
            <cfsavecontent variable="icerik_67">
            <cfset deger_ = "%#tlformat(0)#">
                <td rel="kolon_67" class="ealis_back" style="text-align:right;<cfif listfind(hide_col_list,'kolon_67')>display:none;</cfif>" id="INFO_STANDART_ALIS_PRICE_RATE_#product_id#" nowrap>#deger_#</td>
            </cfsavecontent>
            
            <cfsavecontent variable="icerik_74">
            	<td rel="kolon_74" style="text-align:right;<cfif listfind(hide_col_list,'kolon_74')>display:none;</cfif> color:##FF8C00;" class="list_oran_back">
                <cfset urun_ort_satis = ortalama_satis_tutar.TOTAL_SALE>
                <cfif ort_liste_satis_tutar gt 0>
                	
						<cfset total_urun_ort_satis = urun_ort_satis / ort_liste_satis_tutar*100>
                    
                <cfelse>
                	<cfset total_urun_ort_satis = 0>
                </cfif>
                
                #tlformat(total_urun_ort_satis,2)#
                </td>
            </cfsavecontent>
            
            <cfsavecontent variable="icerik_75">
            	<td rel="kolon_75" style="text-align:right;<cfif listfind(hide_col_list,'kolon_75')>display:none;</cfif>">&nbsp;</td>
            </cfsavecontent>
            
            <cfsavecontent variable="icerik_76">
            	<td rel="kolon_76" style="text-align:right;<cfif listfind(hide_col_list,'kolon_76')>display:none;</cfif>">&nbsp;</td>
            </cfsavecontent>
   			<cfif not isdefined("attributes.print_action")>
                <cfloop from="1" to="#listlen(kolon_sira)#" index="ccc">
                    <cfset mmm_ = listgetat(kolon_sira,ccc)>
                    <cfset icerik_ = evaluate("icerik_#mmm_#")>
                    <cfset icerik_ = replace(icerik_,'<td ','<td title="#product_name# - #listgetat(kolon_names,mmm_)#" ','one')>
                    <!--- #icerik_# --->
                    <cfif listfind(hide_col_list,'kolon_#mmm_#') and isdefined("attributes.is_only_related_areas")>
                        <td rel="kolon_#mmm_#" style="display:none;"></td>
                    <cfelse>
                        #icerik_#
                    </cfif>
                </cfloop>
        	<cfelse>
            	<cfloop from="1" to="#listlen(kolon_sira)#" index="ccc">
                    <cfset mmm_ = listgetat(kolon_sira,ccc)>
                    <cfif not listfind(hide_col_list,'kolon_#mmm_#') and mmm_ neq 1><!--- printte 1.kolon cikmaz --->
						<cfset icerik_ = evaluate("icerik_#mmm_#")>
                        <cfset icerik_ = replace(icerik_,'<td ','<td title="#product_name# - #listgetat(kolon_names,mmm_)#" ','one')>
                        #icerik_#
                    </cfif>
                </cfloop>
            </cfif>
        </tr>
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
            
            <cfif isdefined("attributes.print_action") and (stock_count_ eq 1 or not listfind(hide_col_list,'kolon_34'))>
            	<cfset row_show_ = 0>
            </cfif>
            
            <cfif row_show_>
            <tr bgcolor="FFFF99" id="p_s_#product_id#_#stock_id#" style="<cfif not isdefined("attributes.print_action")>display:none;</cfif>" product="#product_group_info#" p_id="#product_id#">
                <cfsavecontent variable="icerik_50"><td rel="kolon_50" style=" <cfif listfind(hide_col_list,'kolon_50')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_1"><td>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_2"><td>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_3">
                <td class="txtbold">
                    <cfif isdefined("attributes.is_hide_one_stocks") and dept_count_ eq 1 and stock_count_ gt 1>
                        #property#
                    <cfelseif isdefined("attributes.is_hide_one_stocks") and stock_count_ eq 1 and dept_count_ eq 1>
                        #property#
                    <cfelse>
                    	<input type="text" name="stock_name_#product_id#_#stock_id#" id="stock_name_#product_id#_#stock_id#" value="#property#" style="width:300px;"/>
                    </cfif>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_4"><td rel="kolon_4" style=" <cfif listfind(hide_col_list,'kolon_4')>display:none;</cfif>"><cfif is_purchase eq 1><img src="/images/ok_list.gif" /><cfelse><img src="/images/ok_list_empty.gif" /></cfif></td></cfsavecontent>
                <cfsavecontent variable="icerik_5"><td rel="kolon_5" style=" <cfif listfind(hide_col_list,'kolon_5')>display:none;</cfif>"><cfif is_sales eq 1><img src="/images/ok_list.gif" /><cfelse><img src="/images/ok_list_empty.gif" /></cfif></td></cfsavecontent>
                <cfsavecontent variable="icerik_7"><td rel="kolon_7" style=" <cfif listfind(hide_col_list,'kolon_7')>display:none;</cfif>">#S_BARCOD#</td></cfsavecontent>
                <cfsavecontent variable="icerik_8"><td rel="kolon_8" style=" <cfif listfind(hide_col_list,'kolon_8')>display:none;</cfif>">#listlast(STOCK_CODE,'.')#</td></cfsavecontent>
                <cfsavecontent variable="icerik_45"><td rel="kolon_45" style=" <cfif listfind(hide_col_list,'kolon_45')>display:none;</cfif>"></td></cfsavecontent>
                <cfsavecontent variable="icerik_9"><td rel="kolon_9" style=" <cfif listfind(hide_col_list,'kolon_9')>display:none;</cfif>">#TLFormat(price_standart,session.ep.our_company_info.purchase_price_round_num)#</td></cfsavecontent>
                <cfsavecontent variable="icerik_14"><td rel="kolon_14" style=" <cfif listfind(hide_col_list,'kolon_14')>display:none;</cfif>">#get_products.tax_purchase#</td></cfsavecontent>
                <cfsavecontent variable="icerik_15"><td rel="kolon_15" style=" <cfif listfind(hide_col_list,'kolon_15')>display:none;</cfif>">#TLFormat(price_standart_kdv,session.ep.our_company_info.purchase_price_round_num)#</td></cfsavecontent>
                <cfsavecontent variable="icerik_42"><td rel="kolon_42" style=" <cfif listfind(hide_col_list,'kolon_42')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_43"><td rel="kolon_43" style=" <cfif listfind(hide_col_list,'kolon_43')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_28">
                <td rel="kolon_28" style=" <cfif listfind(hide_col_list,'kolon_28')>display:none;</cfif>">
                    <cfif isdefined("get_table_info.NEW_ALIS_#product_id#_#stock_id#")>
                        <cfset deger_ = evaluate("get_table_info.NEW_ALIS_#product_id#_#stock_id#")>
                    <cfelse>
                        <cfset deger_ = "">
                    </cfif>
                    <cfif not isdefined("attributes.print_action")>
                    	<!--- <cfinput type="text" name="NEW_ALIS_#product_id#_#stock_id#" class="moneybox" passthrough="onkeyup=""return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));""" value="#deger_#" style="width:63px;"> --->
                		#deger_#
                    <cfelse>
                    	&nbsp;
                    </cfif>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_29">
                <td rel="kolon_29" style=" <cfif listfind(hide_col_list,'kolon_29')>display:none;</cfif>">
                    <cfif isdefined("get_table_info.NEW_ALIS_KDVLI_#product_id#_#stock_id#")>
                        <cfset deger_ = evaluate("get_table_info.NEW_ALIS_KDVLI_#product_id#_#stock_id#")>
                    <cfelse>
                        <cfset deger_ = "">
                    </cfif>
                    <cfif not isdefined("attributes.print_action")>
                    	<!--- <cfinput type="text" name="NEW_ALIS_KDVLI_#product_id#_#stock_id#" class="moneybox" passthrough="onkeyup=""return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));""" value="#deger_#" style="width:63px;">--->4
                        #deger_#
                	<cfelse>
                    	&nbsp;
                    </cfif>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_24">
                <td rel="kolon_24" style=" <cfif listfind(hide_col_list,'kolon_24')>display:none;</cfif>" nowrap id="p_startdate_#product_id#_#stock_id#_td">
                    <cfif isdefined("get_table_info.p_startdate_#product_id#_#stock_id#")>
                        <cfset deger_ = evaluate("get_table_info.p_startdate_#product_id#_#stock_id#")>
                    <cfelse>
                        <cfset deger_ = "">
                    </cfif>
                    <cfif not isdefined("attributes.print_action")>
                        <!---
                        <cfinput type="text" name="p_startdate_#product_id#_#stock_id#" id="p_startdate_#product_id#_#stock_id#" maxlength="10" value="#deger_#" style="width:65px;" validate="eurodate" message="Tarih Hatalı!">
                        <cfif not isdefined("attributes.add_action")><cf_wrk_date_image date_field="p_startdate_#product_id#_#stock_id#"></cfif>
                		--->
                        #deger_#
					<cfelse>
                    	&nbsp;
                    </cfif>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_25">
                <td rel="kolon_25" style=" <cfif listfind(hide_col_list,'kolon_25')>display:none;</cfif>" nowrap id="p_finishdate_#product_id#_#stock_id#_td">
                    <cfif isdefined("get_table_info.p_finishdate_#product_id#_#stock_id#")>
                        <cfset deger_ = evaluate("get_table_info.p_finishdate_#product_id#_#stock_id#")>
                    <cfelse>
                        <cfset deger_ = "">
                    </cfif>
                    <cfif not isdefined("attributes.print_action")>
                        <!---
                        <cfinput type="text" name="p_finishdate_#product_id#_#stock_id#" id="p_finishdate_#product_id#_#stock_id#" maxlength="10" value="#deger_#" style="width:65px;" validate="eurodate" message="Tarih Hatalı!">
                        <cfif not isdefined("attributes.add_action")><cf_wrk_date_image date_field="p_finishdate_#product_id#_#stock_id#"></cfif>
                		--->
                        #deger_#
					<cfelse>
                    	&nbsp;
                    </cfif>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_44"><td rel="kolon_44" style=" <cfif listfind(hide_col_list,'kolon_44')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_12">
                <td rel="kolon_12" style="background-color:##FF6; <cfif listfind(hide_col_list,'kolon_12')>display:none;</cfif>" nowrap>
                    <cfif isdefined("get_table_info.FIRST_SATIS_PRICE_#product_id#_#stock_id#")>
                        <cfset deger_ = evaluate("get_table_info.FIRST_SATIS_PRICE_#product_id#_#stock_id#")>
                    <cfelse>
                        <cfset deger_ = TLFormat(STANDART_SALE_PRICE,session.ep.our_company_info.purchase_price_round_num)>
                    </cfif>
                <cfif not isdefined("attributes.print_action")>
                    <!--- <cfinput type="text" name="FIRST_SATIS_PRICE_#product_id#_#stock_id#" class="moneybox" onkeyup="hesapla_first_sales_stock('#product_id#','#stock_id#','0');" onBlur="duzenle_first_sales_stock('#product_id#','#stock_id#')" value="#deger_#" style="width:63px;"> --->
                	#deger_#
                <cfelse>
                    &nbsp;
                </cfif>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_26">
                <td rel="kolon_26" style="background-color:##FF6; <cfif listfind(hide_col_list,'kolon_26')>display:none;</cfif>">
                    <cfif isdefined("get_table_info.FIRST_SATIS_PRICE_KDV_#product_id#_#stock_id#")>
                        <cfset deger_ = evaluate("get_table_info.FIRST_SATIS_PRICE_KDV_#product_id#_#stock_id#")>
                    <cfelse>
                        <cfset deger_ = TLFormat(STANDART_SALE_PRICE_KDV,session.ep.our_company_info.purchase_price_round_num)>
                    </cfif>
                <cfif not isdefined("attributes.print_action")>
                    <!--- <cfinput type="text" name="FIRST_SATIS_PRICE_KDV_#product_id#_#stock_id#" class="moneybox"  onkeyup="hesapla_first_sales_stock('#product_id#','#stock_id#','1');" onBlur="duzenle_first_sales_stock('#product_id#','#stock_id#')" value="#deger_#" style="width:63px;"> --->
                    #deger_#
                <cfelse>
                    &nbsp;
                </cfif>
                </td>
                </cfsavecontent>
                
                
                <cfsavecontent variable="icerik_19"><td rel="kolon_19" style=" <cfif listfind(hide_col_list,'kolon_19')>display:none;</cfif>">#get_products.tax#</td></cfsavecontent>
                <cfsavecontent variable="icerik_27">
                <td rel="kolon_27" style=" <cfif listfind(hide_col_list,'kolon_27')>display:none;</cfif> text-align:right;">
                    #TLFormat(SON_MALIYET+SON_MALIYET*(MAX_MARGIN_DEGER/100),session.ep.our_company_info.purchase_price_round_num)#
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_46"><td rel="kolon_46" style=" <cfif listfind(hide_col_list,'kolon_46')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_10"><td rel="kolon_10" style="<cfif listfind(hide_col_list,'kolon_10')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_6">
                <td rel="kolon_6" style="<cfif listfind(hide_col_list,'kolon_6')>display:none;</cfif>">#TLFormat(STANDART_SALE_PRICE_KDV,session.ep.our_company_info.purchase_price_round_num)#.</td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_13">
                <td rel="kolon_13" style="<cfif listfind(hide_col_list,'kolon_13')>display:none;</cfif> text-align:right;">
                    <a href="javascript://" class="tableyazi" onclick="get_rival_price_list('#product_id#');">#TLFormat(avg_rival,2)#</a>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_11"><td rel="kolon_11" style=" text-align:right;  <cfif listfind(hide_col_list,'kolon_11')>display:none;</cfif>">
                	#TLFormat(ORT_SATIS_MIKTARI,2)#</td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_30"><td rel="kolon_30" style=" text-align:right;  <cfif listfind(hide_col_list,'kolon_30')>display:none;</cfif>"><cfif row_stock gt 0 and ORT_SATIS_MIKTARI gt 0>#TLFormat(row_stock / ORT_SATIS_MIKTARI)#<cfelse>-</cfif></td></cfsavecontent>
                <cfsavecontent variable="icerik_31">
                	<td rel="kolon_31" style=" text-align:right;  <cfif listfind(hide_col_list,'kolon_31')>display:none;</cfif>">
                    	<cfif stock_count_ eq 1 and dept_count_ eq 1>
                            #tlformat(ROW_STOK_DEVIR_HIZI)#
                        </cfif>
                    </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_16">
                	<td rel="kolon_16" class="genel_stock_back" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_16')>display:none;</cfif>">
                    	<a href="javascript://" class="tableyazi" onclick="get_stock_list('#stock_id#','stock');">#row_stock#</a>
                    </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_17"><td rel="kolon_17" class="magaza_stock_back" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_17')>display:none;</cfif>">#magaza_stock#</td></cfsavecontent>
                <cfsavecontent variable="icerik_18"><td rel="kolon_18" class="depo_stock_back" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_18')>display:none;</cfif>">#depo_stock#</td></cfsavecontent>
                <cfsavecontent variable="icerik_33">
                	<td rel="kolon_33" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_33')>display:none;</cfif>">
                         #yoldaki_stok#
                    </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_32"><td rel="kolon_32" class="sip1_back" style="text-align:right; <cfif listfind(hide_col_list,'kolon_32')>display:none;</cfif>">---</td></cfsavecontent>
                <cfsavecontent variable="icerik_40">
                <td rel="kolon_40" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_40')>display:none;</cfif>" id="multiplier_#product_id#_#stock_id#"><cfif len(multiplier)>#multiplier#</cfif></td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_34">
                <td rel="kolon_34" class="sip1_back" style=" text-align:right;<cfif listfind(hide_col_list,'kolon_34')>display:none;</cfif>" nowrap>
                    <cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_#product_id#_#stock_id#")>
                        <cfset deger_ = evaluate("get_table_info.STOCK_SATIS_AMOUNT_#product_id#_#stock_id#")>
                    <cfelse>
                        <cfset deger_ = "">
                    </cfif>
                <cfif not isdefined("attributes.print_action")>
                    <cfinput type="text" name="STOCK_SATIS_AMOUNT_#product_id#_#stock_id#" class="moneybox" onkeyup="hesapla_koli('STOCK_SATIS_AMOUNT_#product_id#_#stock_id#','STOCK_SATIS_AMOUNT_KOLI_#product_id#_#stock_id#','multiplier_#product_id#_#stock_id#');" onBlur="duzenle_adet_koli('STOCK_SATIS_AMOUNT_#product_id#_#stock_id#','STOCK_SATIS_AMOUNT_KOLI_#product_id#_#stock_id#','multiplier_#product_id#_#stock_id#','liste_fiyati_#product_id#','liste_fiyati_kdvli_#product_id#','STOCK_SATIS_AMOUNT_TUTAR_#product_id#_#stock_id#','STOCK_SATIS_AMOUNT_TUTAR_KDVLI_#product_id#_#stock_id#','1','#stock_id#');" value="#deger_#" style="width:70px;">
                    <a href="javascript://" onclick="set_down_object('stock_group_name','STOCK_SATIS_AMOUNT_#product_id#_#stock_id#','STOCK_SATIS_AMOUNT_#product_id#_#stock_id#');set_down_object('stock_group_name','STOCK_SATIS_AMOUNT_KOLI_#product_id#_#stock_id#','STOCK_SATIS_AMOUNT_KOLI_#product_id#_#stock_id#');"><img src="/images/listele_down.gif" /></a>
                <cfelse>
                    &nbsp;
                </cfif>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_35">
                <td rel="kolon_35" class="sip1_back" style=" text-align:right;<cfif listfind(hide_col_list,'kolon_35')>display:none;</cfif>" nowrap>
                    <cfif len(multiplier)>
                        <cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_KOLI_#product_id#_#stock_id#")>
                            <cfset deger_ = evaluate("get_table_info.STOCK_SATIS_AMOUNT_KOLI_#product_id#_#stock_id#")>
                        <cfelse>
                            <cfset deger_ = "">
                        </cfif>
               		<cfif not isdefined("attributes.print_action")>
                        <cfinput type="text" name="STOCK_SATIS_AMOUNT_KOLI_#product_id#_#stock_id#" class="moneybox" onkeyup="hesapla_adet('STOCK_SATIS_AMOUNT_#product_id#_#stock_id#','STOCK_SATIS_AMOUNT_KOLI_#product_id#_#stock_id#','multiplier_#product_id#_#stock_id#');" onBlur="duzenle_adet_koli('STOCK_SATIS_AMOUNT_#product_id#_#stock_id#','STOCK_SATIS_AMOUNT_KOLI_#product_id#_#stock_id#','multiplier_#product_id#_#stock_id#','liste_fiyati_#product_id#','liste_fiyati_kdvli_#product_id#','STOCK_SATIS_AMOUNT_TUTAR_#product_id#_#stock_id#','STOCK_SATIS_AMOUNT_TUTAR_KDVLI_#product_id#_#stock_id#','1','#stock_id#');" value="#deger_#" style="width:60px;">
                        <a href="javascript://" onclick="set_down_object('stock_group_name','STOCK_SATIS_AMOUNT_#product_id#_#stock_id#','STOCK_SATIS_AMOUNT_#product_id#_#stock_id#');set_down_object('stock_group_name','STOCK_SATIS_AMOUNT_KOLI_#product_id#_#stock_id#','STOCK_SATIS_AMOUNT_KOLI_#product_id#_#stock_id#');"><img src="/images/listele_down.gif" /></a>
                    <cfelse>
                        &nbsp;
                    </cfif>
                    </cfif>
                </td>
                </cfsavecontent>
                
                
                <cfsavecontent variable="icerik_51">
					<cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_TUTAR_#product_id#_#stock_id#")>
                        <cfset deger_ = evaluate("get_table_info.STOCK_SATIS_AMOUNT_TUTAR_#product_id#_#stock_id#")>
                    <cfelse>
                        <cfset deger_ = "">
                    </cfif>
                    <td rel="kolon_51" class="sip1_back" style=" text-align:right;<cfif listfind(hide_col_list,'kolon_51')>display:none;</cfif>" id="STOCK_SATIS_AMOUNT_TUTAR_#product_id#_#stock_id#">#deger_#</td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_53">
                    <td rel="kolon_53" class="sip1_back" style=" text-align:right;<cfif listfind(hide_col_list,'kolon_53')>display:none;</cfif>" id="STOCK_SATIS_AMOUNT_TUTAR_KDVLI_#product_id#_#stock_id#">#deger_#</td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_52">
                	<cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_TUTAR_2_#product_id#_#stock_id#")>
						<cfset deger_ = evaluate("get_table_info.STOCK_SATIS_AMOUNT_TUTAR_2_#product_id#_#stock_id#")>
                    <cfelse>
                        <cfset deger_ = "">
                    </cfif>
                    <td rel="kolon_52" class="sip2_back" style="text-align:right; <cfif listfind(hide_col_list,'kolon_52')>display:none;</cfif>" id="STOCK_SATIS_AMOUNT_TUTAR_2_#product_id#_#stock_id#">#deger_#</td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_54">
				<cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_TUTAR_KDVLI_2_#product_id#_#stock_id#")>
                    <cfset deger_ = evaluate("get_table_info.STOCK_SATIS_AMOUNT_TUTAR_KDVLI_2_#product_id#_#stock_id#")>
                <cfelse>
                    <cfset deger_ = "">
                </cfif>
                    <td rel="kolon_54" class="sip2_back" style="text-align:right; <cfif listfind(hide_col_list,'kolon_54')>display:none;</cfif>" id="STOCK_SATIS_AMOUNT_TUTAR_KDVLI_2_#product_id#_#stock_id#">#deger_#</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_36">
                <td rel="kolon_36" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_36')>display:none;</cfif>" id="s_order_date_1_#product_id#_#stock_id#_td">
                    <cfif isdefined("get_table_info.s_order_date_1_#product_id#") and (not isdefined("attributes.calc_type") or listfind('0,3',attributes.calc_type))>
                        <cfset deger_ = evaluate("get_table_info.order_date_1_#product_id#")>
                    <cfelse>
                        <cfset deger_ = dateformat(now(),'dd/mm/yyyy')>
                    </cfif>
                    <cfif not isdefined("attributes.print_action")> 
                        <!---
                        <input type="text" name="s_order_date_1_#product_id#_#stock_id#" maxlength="10" value="#deger_#" style="width:65px;">
                        <cfif not isdefined("attributes.add_action")><cf_wrk_date_image date_field="s_order_date_1_#product_id#_#stock_id#"></cfif>
                        <a href="javascript://" onclick="set_down_object('stock_group_name','order_date_1_#product_id#_#stock_id#','s_order_date_1_#product_id#_#stock_id#');"><img src="/images/listele_down.gif" /></a>
                		--->
					<cfelse>
                    	&nbsp;
                    </cfif>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_37">
                <td rel="kolon_37" class="sip2_back" style=" text-align:right;<cfif listfind(hide_col_list,'kolon_37')>display:none;</cfif>" nowrap>
					<cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#")>
                        <cfset deger_ = evaluate("get_table_info.STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#")>
                    <cfelse>
                        <cfset deger_ = "">
                    </cfif>
                    <cfif not isdefined("attributes.print_action")> 
                        <cfinput type="text" name="STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#" class="moneybox" onkeyup="hesapla_koli('STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#','STOCK_SATIS_AMOUNT_KOLI_2_#product_id#_#stock_id#','multiplier_#product_id#_#stock_id#');" onBlur="duzenle_adet_koli('STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#','STOCK_SATIS_AMOUNT_KOLI_2_#product_id#_#stock_id#','multiplier_#product_id#_#stock_id#','liste_fiyati_#product_id#','liste_fiyati_kdvli_#product_id#','STOCK_SATIS_AMOUNT_TUTAR_2_#product_id#_#stock_id#','STOCK_SATIS_AMOUNT_TUTAR_KDVLI_2_#product_id#_#stock_id#','1','#stock_id#');" value="#deger_#" style="width:70px;">
                        <a href="javascript://" onclick="set_down_object('stock_group_name','STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#','STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#');set_down_object('stock_group_name','STOCK_SATIS_AMOUNT_KOLI_2_#product_id#_#stock_id#','STOCK_SATIS_AMOUNT_KOLI_2_#product_id#_#stock_id#');"><img src="/images/listele_down.gif" /></a>
                	<cfelse>
                    	&nbsp;
                    </cfif>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_38">
                <td rel="kolon_38" class="sip2_back" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_38')>display:none;</cfif>" nowrap>
                    <cfif len(multiplier)>
                        <cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_KOLI_2_#product_id#_#stock_id#")>
                            <cfset deger_ = evaluate("get_table_info.STOCK_SATIS_AMOUNT_KOLI_2_#product_id#_#stock_id#")>
                        <cfelse>
                            <cfset deger_ = "">
                        </cfif>
                    <cfif not isdefined("attributes.print_action")>
                        <cfinput type="text" name="STOCK_SATIS_AMOUNT_KOLI_2_#product_id#_#stock_id#" class="moneybox" onkeyup="hesapla_adet('STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#','STOCK_SATIS_AMOUNT_KOLI_2_#product_id#_#stock_id#','multiplier_#product_id#_#stock_id#');" onBlur="duzenle_adet_koli('STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#','STOCK_SATIS_AMOUNT_KOLI_2_#product_id#_#stock_id#','multiplier_#product_id#_#stock_id#','liste_fiyati_#product_id#','liste_fiyati_kdvli_#product_id#','STOCK_SATIS_AMOUNT_TUTAR_2_#product_id#_#stock_id#','STOCK_SATIS_AMOUNT_TUTAR_KDVLI_2_#product_id#_#stock_id#','1','#stock_id#');" value="#deger_#" style="width:60px;">
                        <a href="javascript://" onclick="set_down_object('stock_group_name','STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#','STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#');set_down_object('stock_group_name','STOCK_SATIS_AMOUNT_KOLI_2_#product_id#_#stock_id#','STOCK_SATIS_AMOUNT_KOLI_2_#product_id#_#stock_id#');"><img src="/images/listele_down.gif" /></a>
                    <cfelse>
                    	&nbsp;
                    </cfif>
                    </cfif>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_39">
                <td rel="kolon_39" class="sip2_back" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_39')>display:none;</cfif>" id="s_order_date_2_#product_id#_#stock_id#_td">
                    <cfif isdefined("get_table_info.s_order_date_2_#product_id#") and (not isdefined("attributes.calc_type")  or listfind('0,3',attributes.calc_type))>
                        <cfset deger_ = evaluate("get_table_info.s_order_date_2_#product_id#")>
                    <cfelse>
                        <cfset deger_ = dateformat(dateadd('d',15,now()),'dd/mm/yyyy')>
                    </cfif>
                    <cfif not isdefined("attributes.print_action")>
                        <!---
                        <input type="text" name="s_order_date_2_#product_id#_#stock_id#" maxlength="10" value="#deger_#" style="width:65px;">
                        <cfif not isdefined("attributes.add_action")><cf_wrk_date_image date_field="s_order_date_2_#product_id#_#stock_id#"></cfif>
                        <a href="javascript://" onclick="set_down_object('stock_group_name','order_date_2_#product_id#_#stock_id#','s_order_date_2_#product_id#_#stock_id#');"><img src="/images/listele_down.gif" /></a>
                		--->
					<cfelse>
                    	&nbsp;
                    </cfif>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_41">
                <td rel="kolon_41" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_41')>display:none;</cfif>">&nbsp;</td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_20">
                <td rel="kolon_20" style=" <cfif listfind(hide_col_list,'kolon_20')>display:none;</cfif>" nowrap id="startdate_#product_id#_#stock_id#_td">
                <cfif not isdefined("attributes.print_action")>
                    <cfif isdefined("get_table_info.startdate_#product_id#_#stock_id#")>
                        <cfset deger_ = evaluate("get_table_info.startdate_#product_id#_#stock_id#")>
                    <cfelse>
                        <cfset deger_ = "">
                    </cfif>
                    <input type="text" name="startdate_#product_id#_#stock_id#" id="startdate_#product_id#_#stock_id#" maxlength="10" value="#deger_#" style="width:65px;">
                    <cfif not isdefined("attributes.add_action")><cf_wrk_date_image date_field="startdate_#product_id#_#stock_id#"></cfif>
                </cfif>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_21">
                <td rel="kolon_21" style=" <cfif listfind(hide_col_list,'kolon_21')>display:none;</cfif>" nowrap id="finishdate_#product_id#_#stock_id#_td">
                <cfif not isdefined("attributes.print_action")>
                    <cfif isdefined("get_table_info.finishdate_#product_id#_#stock_id#")>
                        <cfset deger_ = evaluate("get_table_info.finishdate_#product_id#_#stock_id#")>
                    <cfelse>
                        <cfset deger_ = "">
                    </cfif>
                    <input type="text" name="finishdate_#product_id#_#stock_id#" id="finishdate_#product_id#_#stock_id#" maxlength="10" value="#deger_#" style="width:65px;">
                    <cfif not isdefined("attributes.add_action")><cf_wrk_date_image date_field="finishdate_#product_id#_#stock_id#"></cfif>
                </cfif>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_22">
                <td rel="kolon_22" class="sip1_back" style="<cfif listfind(hide_col_list,'kolon_22')>display:none;</cfif>" nowrap>
                <!---
				<cfif not isdefined("attributes.print_action")>
                    <cfif isdefined("get_table_info.dueday_#product_id#_#stock_id#")>
                        <cfset deger_ = evaluate("get_table_info.dueday_#product_id#_#stock_id#")>
                    <cfelse>
                        <cfset deger_ = "">
                    </cfif>
                    <cfinput type="text" name="dueday_#product_id#_#stock_id#" id="dueday_#product_id#_#stock_id#" maxlength="3" value="#deger_#" style="width:30px;" validate="integer" message="Vade Hatalı!">
                </cfif>
				--->
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_47">
                <td rel="kolon_47" style=" <cfif listfind(hide_col_list,'kolon_47')>display:none;</cfif>" nowrap>#TLFormat(STANDART_SALE_PRICE,session.ep.our_company_info.purchase_price_round_num)#</td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_23">
                <td rel="kolon_23" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_23')>display:none;</cfif>">
                	<a href="javascript://" class="tableyazi" onclick="get_cost_list('#product_id#','#stock_id#');">#TLFormat(SON_MALIYET)#</a>
                </td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_48">
                <td rel="kolon_48" style=" <cfif listfind(hide_col_list,'kolon_48')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_49">
                <td rel="kolon_49" style=" <cfif listfind(hide_col_list,'kolon_49')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_55">
                <td rel="kolon_55" style=" <cfif listfind(hide_col_list,'kolon_55')>display:none;</cfif>" nowrap>
                <!---
				<cfif not isdefined("attributes.print_action")>
                    <cfif isdefined("get_table_info.dueday2_#product_id#_#stock_id#")>
                        <cfset deger_ = evaluate("get_table_info.dueday2_#product_id#_#stock_id#")>
                    <cfelse>
                        <cfset deger_ = "">
                    </cfif>
                    <cfinput type="text" name="dueday2_#product_id#_#stock_id#" id="dueday2_#product_id#_#stock_id#" maxlength="3" value="#deger_#" style="width:30px;" validate="integer" message="Vade Hatalı!">
                </cfif>
				--->
                </td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_56">
                <td rel="kolon_56" class="sip2_back" style="<cfif listfind(hide_col_list,'kolon_56')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_57">
                <td rel="kolon_57" style=" <cfif listfind(hide_col_list,'kolon_57')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_58">
                <td rel="kolon_58" style=" <cfif listfind(hide_col_list,'kolon_58')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_59">
                <td rel="kolon_59" style=" <cfif listfind(hide_col_list,'kolon_59')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_73">
                <td rel="kolon_73" style=" <cfif listfind(hide_col_list,'kolon_73')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_60">
                <td rel="kolon_60" style=" <cfif listfind(hide_col_list,'kolon_60')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_61">
                <td rel="kolon_61" style=" <cfif listfind(hide_col_list,'kolon_61')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_62">
                <td rel="kolon_62" style=" <cfif listfind(hide_col_list,'kolon_62')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_63">
                <td rel="kolon_63" style=" <cfif listfind(hide_col_list,'kolon_63')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_64">
                <td rel="kolon_64" style=" <cfif listfind(hide_col_list,'kolon_64')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_65">
                <td rel="kolon_65" style=" <cfif listfind(hide_col_list,'kolon_65')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_66">
                <td rel="kolon_66" style=" <cfif listfind(hide_col_list,'kolon_66')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_67">
                <td rel="kolon_67" style=" <cfif listfind(hide_col_list,'kolon_67')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_68">
                <td rel="kolon_68" style=" <cfif listfind(hide_col_list,'kolon_68')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_69">
                <td rel="kolon_69" style=" <cfif listfind(hide_col_list,'kolon_69')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_70">
                <td rel="kolon_70" style=" <cfif listfind(hide_col_list,'kolon_70')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_71">
                <td rel="kolon_71" style=" <cfif listfind(hide_col_list,'kolon_71')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_72">
                <td rel="kolon_72" style=" <cfif listfind(hide_col_list,'kolon_72')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_74">
                <td rel="kolon_74" style=" <cfif listfind(hide_col_list,'kolon_74')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_75">
                <td rel="kolon_75" style=" <cfif listfind(hide_col_list,'kolon_75')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_76">
                <td rel="kolon_76" style=" <cfif listfind(hide_col_list,'kolon_76')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
    			<cfif not isdefined("attributes.print_action")>
                    <cfloop from="1" to="#listlen(kolon_sira)#" index="ccc">
                        <cfset mmm_ = listgetat(kolon_sira,ccc)>
                        <cfset icerik_ = evaluate("icerik_#mmm_#")>
                        <cfset icerik_ = replace(icerik_,'<td ','<td title="#product_name# - #property# - #listgetat(kolon_names,mmm_)#" ','one')>
                        <!--- #icerik_# --->
                        <cfif listfind(hide_col_list,'kolon_#mmm_#') and isdefined("attributes.is_only_related_areas")>
                            <td rel="kolon_#mmm_#" style="display:none;"></td>
                        <cfelse>
                            #icerik_#
                        </cfif>
                    </cfloop>
                <cfelse>
                	<cfloop from="1" to="#listlen(kolon_sira)#" index="ccc">
                        <cfset mmm_ = listgetat(kolon_sira,ccc)>
                        <cfset icerik_ = evaluate("icerik_#mmm_#")>
                        <cfset icerik_ = replace(icerik_,'<td ','<td title="#product_name# - #property# - #listgetat(kolon_names,mmm_)#" ','one')>
                        <cfif mmm_ neq 1>#icerik_#</cfif>
                    </cfloop>
                </cfif>
            </tr>
            </cfif>
        </cfif>
        <cfset row_show_ = 1>
		<cfif isdefined("attributes.print_action") and ((dept_count_ eq 1 and stock_count_ eq 1) or listfind(hide_col_list,'kolon_34'))>
            <cfset row_show_ = 0>
        </cfif>
        
        <cfif row_show_ eq 1 and isdefined("attributes.order_type") and attributes.order_type eq 1>
        	<cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_#product_id#_#stock_id#_#department_id#")>
				<cfset deger_sip1 = filternum(evaluate("get_table_info.STOCK_SATIS_AMOUNT_#product_id#_#stock_id#_#department_id#"))>
            <cfelse>
                <cfset deger_sip1 = 0>
            </cfif>
            
            <cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#_#department_id#")>
                <cfset deger_sip2 = filternum(evaluate("get_table_info.STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#_#department_id#"))>
            <cfelse>
                <cfset deger_sip2 = 0>
            </cfif>
            <cfif (isnumeric(deger_sip1) and deger_sip1 gt 0) or (isnumeric(deger_sip2) and deger_sip2 gt 0)>
            	<cfset row_show_ = 1>
            <cfelse>
            	<cfset row_show_ = 0>
            </cfif>
        </cfif>
        	<cfif row_show_ eq 1>
            <tr class="color-row" style="<cfif not isdefined("attributes.print_action")>display:none;</cfif>" onclick="get_row_active_dept('#product_id#','#stock_id#','#department_id#');" id="p_s_d_#product_id#_#stock_id#_#department_id#" product="p_#product_id#" p_id="#product_id#" row_code="dept_row_#product_id#_#stock_id#_#department_id#">
                <cfsavecontent variable="icerik_50"><td rel="kolon_50" style=" <cfif listfind(hide_col_list,'kolon_50')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_1"><td rel="kolon_1" style="height:20px;<cfif  listfind(hide_col_list,'kolon_1')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_2"><td rel="kolon_2" style=" <cfif  listfind(hide_col_list,'kolon_2')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_3">
                    <td rel="kolon_3" style=" <cfif listfind(hide_col_list,'kolon_3')>display:none;</cfif>" onmouseover="show('row_view_div_#product_id#');" onmouseout="hide('row_view_div_#product_id#');" nowrap>
                        <cfif isdefined("attributes.is_hide_one_stocks") and dept_count_ eq 1 and stock_count_ gt 1>
                        	<input type="text" name="stock_name_#product_id#_#stock_id#" id="stock_name_#product_id#_#stock_id#" value="#property#" style="width:300px; <cfif ROW_ORT_STOK_SATIS_MIKTARI lte min_stock_deger>color:red;<cfelseif ROW_ORT_STOK_SATIS_MIKTARI lte min_stock_deger_warning>color:##F6F; font-weight:bold;</cfif>"/>
						<cfelseif isdefined("attributes.is_hide_one_stocks") and stock_count_ eq 1 and dept_count_ eq 1>
                           	<input type="text" name="stock_name_#product_id#_#stock_id#" id="stock_name_#product_id#_#stock_id#" value="#property#" style="width:300px; <cfif ROW_ORT_STOK_SATIS_MIKTARI lte min_stock_deger>color:red;<cfelseif ROW_ORT_STOK_SATIS_MIKTARI lte min_stock_deger_warning>color:##F6F; font-weight:bold;</cfif>"/>
                        <cfelse>
                            #department_head# <cfif isdefined("attributes.print_action") and stock_count_ neq 1>#property#</cfif>
                        </cfif>    
                        <div id="row_view_div_#product_id#" style="position:absolute; margin-left:290px; padding:5px; display:none; height:25px; background:##FF0">                    
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_stock&pid=#product_id#&stock_id=#stock_id#&pcode=#product_code#&is_terazi=#is_terazi#&is_inventory=#is_inventory#','page')"><img src="/images/plus_thin.gif" style="width:7px; height:15px;" title="Stok Kartı"  align="absbottom"/></a>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=stock.detail_stock_popup&pid=#product_id#&stock_id=#stock_id#','wide')"><img src="/images/plus_thin_p.gif" style="width:7px; height:15px;"  align="absbottom" title="Stok Hareketler"/></a>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.form_upd_popup_options&pid=#product_id#&stock_id=#stock_id#&pcode=#product_code#&is_terazi=#is_terazi#&is_inventory=#is_inventory#','page')"><img src="/images/plus_thin_m.gif" style="width:7px; height:15px;" title="Stok Taşı"  align="absbottom"/></a>
                        </div>
                    </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_4"><td rel="kolon_4" style=" <cfif listfind(hide_col_list,'kolon_4')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_5"><td rel="kolon_5" style=" <cfif listfind(hide_col_list,'kolon_5')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_7"><td rel="kolon_7" style=" <cfif listfind(hide_col_list,'kolon_7')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_8"><td rel="kolon_8" style=" <cfif listfind(hide_col_list,'kolon_8')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_45"><td rel="kolon_45" style=" <cfif listfind(hide_col_list,'kolon_45')>display:none;</cfif>"></td></cfsavecontent>
                <cfsavecontent variable="icerik_9"><td rel="kolon_9" style=" <cfif listfind(hide_col_list,'kolon_9')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_14"><td rel="kolon_14" style=" <cfif listfind(hide_col_list,'kolon_14')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_15"><td rel="kolon_15" style=" <cfif listfind(hide_col_list,'kolon_15')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_42"><td rel="kolon_42" style=" <cfif listfind(hide_col_list,'kolon_42')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_43"><td rel="kolon_43" style=" <cfif listfind(hide_col_list,'kolon_43')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_28"><td rel="kolon_28" style=" <cfif listfind(hide_col_list,'kolon_28')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_29"><td rel="kolon_29" style=" <cfif listfind(hide_col_list,'kolon_29')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_24"><td rel="kolon_24" style=" <cfif listfind(hide_col_list,'kolon_24')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_25"><td rel="kolon_25" style=" <cfif listfind(hide_col_list,'kolon_25')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_44"><td rel="kolon_44" style=" <cfif listfind(hide_col_list,'kolon_44')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_12"><td rel="kolon_12" style=" <cfif listfind(hide_col_list,'kolon_12')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_19"><td rel="kolon_19" style=" <cfif listfind(hide_col_list,'kolon_19')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_26"><td rel="kolon_26" style=" <cfif listfind(hide_col_list,'kolon_26')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_27"><td rel="kolon_27" style=" <cfif listfind(hide_col_list,'kolon_27')>display:none;</cfif> text-align:right;">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_46"><td rel="kolon_46" style=" <cfif listfind(hide_col_list,'kolon_46')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_10"><td rel="kolon_10" style="<cfif listfind(hide_col_list,'kolon_10')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_6"><td rel="kolon_6" style="<cfif listfind(hide_col_list,'kolon_6')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_13"><td rel="kolon_13" style="<cfif listfind(hide_col_list,'kolon_13')>display:none;</cfif> text-align:right;">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_11"><td rel="kolon_11" style=" text-align:right;  <cfif listfind(hide_col_list,'kolon_11')>display:none;</cfif>">#tlformat(ROW_ORT_STOK_SATIS_MIKTARI)#<cfset ort_sat = ort_sat + #ROW_ORT_STOK_SATIS_MIKTARI#></td></cfsavecontent>
                <cfsavecontent variable="icerik_30"><td rel="kolon_30" style=" text-align:right;  <cfif listfind(hide_col_list,'kolon_30')>display:none;</cfif>"><cfif row_stock gt 0 and ROW_ORT_STOK_SATIS_MIKTARI gt 0>#TLFormat(row_stock / ROW_ORT_STOK_SATIS_MIKTARI)#<cfelse>-</cfif></td></cfsavecontent>
                <cfsavecontent variable="icerik_31"><td rel="kolon_31" style=" text-align:right;  <cfif listfind(hide_col_list,'kolon_31')>display:none;</cfif>">#tlformat(ROW_STOK_DEVIR_HIZI)#</td></cfsavecontent>
                <cfsavecontent variable="icerik_16"><td rel="kolon_16" class="genel_stock_back" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_16')>display:none;</cfif>">#tlformat(ROW_STOCK_GENEL,2)#</td></cfsavecontent>
                <cfsavecontent variable="icerik_17"><td rel="kolon_17" class="magaza_stock_back" style=" text-align:right;<cfif listfind(hide_col_list,'kolon_17')>display:none;</cfif>"><cfif not listfindnocase(merkez_depo_id,department_id)>#row_stock#<cfelse>#tlformat(ROW_STOCK_MAGAZA,2)#</cfif></td></cfsavecontent>
                <cfsavecontent variable="icerik_18"><td rel="kolon_18" class="depo_stock_back" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_18')>display:none;</cfif>"><cfif listfindnocase(merkez_depo_id,department_id)><cfset merkez_depo_stock_total = row_stock>#row_stock#</cfif></td></cfsavecontent>
                <cfsavecontent variable="icerik_33">
                <td rel="kolon_33" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_33')>display:none;</cfif>">
                	<cfif department_id eq merkez_depo_id>
                        #PURCHASE_ORDER_QUANTITY#
                    <cfelse>
                        #PURCHASE_ORDER_QUANTITY#
                    </cfif>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_32">
                <td rel="kolon_32" class="sip1_back" style="text-align:right; <cfif listfind(hide_col_list,'kolon_32')>display:none;</cfif>">
					<!---
					<cfif isdefined("get_table_info.lead_order_#product_id#_#stock_id#_#department_id#")>
                        <cfset old_deger_ = evaluate("get_table_info.lead_order_#product_id#_#stock_id#_#department_id#")>
                    <cfelse>
                        <cfset old_deger_ = "">
                    </cfif>
					--->
                    <cfset old_deger_ = "">
                    <cfset siparis_miktari = 0>
                    <cfif isdefined("attributes.calc_type") and attributes.calc_type eq 1>
                        <cfif not len(ROW_ORT_STOK_SATIS_MIKTARI)>
                            <cfset siparis_miktari = 0>
                        <cfelse>
                            <cfset siparis_miktari = Ceiling(ROW_ORT_STOK_SATIS_MIKTARI * attributes.order_day)>
                            <cfif isdefined("attributes.real_stock")>
                                <cfset siparis_miktari = siparis_miktari - row_stock>
                            </cfif>
                            <cfif isdefined("attributes.way_stock")>
                            	<cfset siparis_miktari = siparis_miktari - PURCHASE_ORDER_QUANTITY>                            
                            </cfif>    
                            <cfif siparis_miktari lt 0>
                                <cfset siparis_miktari = 0>
                            </cfif>
                        </cfif>
                    	#tlformat(siparis_miktari)#
                    <cfelse>
                        <cfif not isdefined("attributes.print_action")>
                            #tlformat(old_deger_)#
                    	<cfelse>
                        	#old_deger_#
                        </cfif>
                    </cfif>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_40">
                <td rel="kolon_40" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_40')>display:none;</cfif>">#multiplier#</td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_34">
                <td rel="kolon_34" class="sip1_back" style="<cfif listfind(hide_col_list,'kolon_34')>display:none;</cfif>" nowrap>
                    <cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_#product_id#_#stock_id#_#department_id#") and (not isdefined("attributes.calc_type")  or listfind('0,3',attributes.calc_type))>
						<cfset deger_sip1 = evaluate("get_table_info.STOCK_SATIS_AMOUNT_#product_id#_#stock_id#_#department_id#")>
                    <cfelse>
                        <cfset deger_sip1 = tlformat(siparis_miktari)>
                    </cfif>
                    <cfif not isdefined("attributes.print_action")>
                    	<cfif isdefined("get_table_info.is_order_#product_id#_#stock_id#_#department_id#") or (isdefined("attributes.calc_type") and attributes.calc_type neq 0)>
                            <input type="checkbox" name="is_order_#product_id#_#stock_id#_#department_id#" id="is_order_#product_id#_#stock_id#_#department_id#" rel_name="is_order_dept" value="1" checked="checked">
                        <cfelse>
                        	<input type="checkbox" name="is_order_#product_id#_#stock_id#_#department_id#" id="is_order_#product_id#_#stock_id#_#department_id#" rel_name="is_order_dept" value="1">
                        </cfif>
                        <cfinput type="text" name="STOCK_SATIS_AMOUNT_#product_id#_#stock_id#_#department_id#" class="moneybox" stock_group_name="STOCK_SATIS_AMOUNT_#product_id#_#stock_id#" product_group_name="STOCK_SATIS_AMOUNT_#product_id#" onkeyup="hesapla_koli('STOCK_SATIS_AMOUNT_#product_id#_#stock_id#_#department_id#','STOCK_SATIS_AMOUNT_KOLI_#product_id#_#stock_id#_#department_id#','multiplier_#product_id#');" onBlur="duzenle_adet_koli('STOCK_SATIS_AMOUNT_#product_id#_#stock_id#_#department_id#','STOCK_SATIS_AMOUNT_KOLI_#product_id#_#stock_id#_#department_id#','multiplier_#product_id#','liste_fiyati_#product_id#','liste_fiyati_kdvli_#product_id#','STOCK_SATIS_AMOUNT_TUTAR_#product_id#_#stock_id#_#department_id#','STOCK_SATIS_AMOUNT_TUTAR_KDVLI_#product_id#_#stock_id#_#department_id#','2','#department_id#');" value="#deger_sip1#" style="width:70px;">
                    <cfelse>
                        #deger_sip1#
                    </cfif>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_35">
                <td rel="kolon_35" class="sip1_back" style="<cfif listfind(hide_col_list,'kolon_35')>display:none;</cfif>" nowrap>
                <cfif len(multiplier)>
                    <cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_#product_id#_#stock_id#_#department_id#") and (not isdefined("attributes.calc_type") or listfind('0,3',attributes.calc_type))>
						<cfset deger_ = evaluate("get_table_info.STOCK_SATIS_AMOUNT_#product_id#_#stock_id#_#department_id#")>
                    <cfelse>
                        <cfset deger_ = tlformat(siparis_miktari / multiplier)>
                    </cfif>
                    <cfif not isdefined("attributes.print_action")>
                    	<cfinput type="text" name="STOCK_SATIS_AMOUNT_KOLI_#product_id#_#stock_id#_#department_id#" class="moneybox" stock_group_name="STOCK_SATIS_AMOUNT_KOLI_#product_id#_#stock_id#" product_group_name="STOCK_SATIS_AMOUNT_KOLI_#product_id#" onkeyup="hesapla_adet('STOCK_SATIS_AMOUNT_#product_id#_#stock_id#_#department_id#','STOCK_SATIS_AMOUNT_KOLI_#product_id#_#stock_id#_#department_id#','multiplier_#product_id#');" onBlur="duzenle_adet_koli('STOCK_SATIS_AMOUNT_#product_id#_#stock_id#_#department_id#','STOCK_SATIS_AMOUNT_KOLI_#product_id#_#stock_id#_#department_id#','multiplier_#product_id#','liste_fiyati_#product_id#','liste_fiyati_kdvli_#product_id#','STOCK_SATIS_AMOUNT_TUTAR_#product_id#_#stock_id#_#department_id#','STOCK_SATIS_AMOUNT_TUTAR_KDVLI_#product_id#_#stock_id#_#department_id#','2','#department_id#');" onChange="checked_true('is_order_#product_id#_#stock_id#_#department_id#')" value="#deger_#" style="width:60px;">
                    <cfelse>
                        #deger_#
                    </cfif>
                </cfif><!---ilhan--->
                </td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_51">
					<cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_TUTAR_#product_id#_#stock_id#_#department_id#")>
                        <cfset deger_ = evaluate("get_table_info.STOCK_SATIS_AMOUNT_TUTAR_#product_id#_#stock_id#_#department_id#")>
                    <cfelse>
                        <cfset deger_ = tlformat(liste_fiyati_ * siparis_miktari)>
                    </cfif>
                    <td rel="kolon_51" class="sip1_back" style="text-align:right; <cfif listfind(hide_col_list,'kolon_51')>display:none;</cfif>" id="STOCK_SATIS_AMOUNT_TUTAR_#product_id#_#stock_id#_#department_id#">#deger_#</td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_53">
					<cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_TUTAR_KDVLI_#product_id#_#stock_id#_#department_id#")>
                        <cfset deger_ = evaluate("get_table_info.STOCK_SATIS_AMOUNT_TUTAR_KDVLI_#product_id#_#stock_id#_#department_id#")>
                    <cfelse>
                        <cfset deger_ = tlformat(liste_fiyati_kdvli_ * siparis_miktari)>
                    </cfif>
                	<td rel="kolon_53" class="sip1_back" style="text-align:right; <cfif listfind(hide_col_list,'kolon_53')>display:none;</cfif>" id="STOCK_SATIS_AMOUNT_TUTAR_KDVLI_#product_id#_#stock_id#_#department_id#">#deger_#</td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_36">
                <td rel="kolon_36" class="sip1_back" style="<cfif listfind(hide_col_list,'kolon_36')>display:none;</cfif>" nowrap id="order_date_1_#product_id#_#stock_id#_#department_id#_td">
                    <cfif isdefined("get_table_info.order_date_1_#product_id#") and (not isdefined("attributes.calc_type")  or listfind('0,3',attributes.calc_type))>
                        <cfset deger_ = evaluate("get_table_info.order_date_1_#product_id#")>
                    <cfelse>
                        <cfset deger_ = dateformat(now(),'dd/mm/yyyy')>
                    </cfif>
                    <cfif not isdefined("attributes.print_action")>
                        <!---
                        <input type="text" name="order_date_1_#product_id#_#stock_id#_#department_id#" stock_group_name="order_date_1_#stock_id#" product_group_name="order_date_1_#product_id#" maxlength="10" value="#deger_#" style="width:65px;">
                        <cfif not isdefined("attributes.add_action")><cf_wrk_date_image date_field="order_date_1_#product_id#_#stock_id#_#department_id#"></cfif>
                		--->
					<cfelse>
                    	#deger_#
                    </cfif>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_56"><td rel="kolon_56" class="sip2_back" style=" <cfif listfind(hide_col_list,'kolon_56')>display:none;</cfif>" nowrap>
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
                               
                            <cfif siparis_miktari_2 lt 0>
                                <cfset siparis_miktari_2 = 0>
                            </cfif>
                        </cfif>
                    <cfif not isdefined("attributes.print_action")> 
                    	#tlformat(siparis_miktari_2)#
                    <cfelse>
                    	#tlformat(siparis_miktari_2)#
                    </cfif>
                    <cfelse>
                        #old_deger_#
                    </cfif>
                </td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_52">
				<cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_TUTAR_2_#product_id#_#stock_id#_#department_id#")>
                    <cfset deger_ = evaluate("get_table_info.STOCK_SATIS_AMOUNT_TUTAR_2_#product_id#_#stock_id#_#department_id#")>
                <cfelse>
                    <cfset deger_ = tlformat(liste_fiyati_ * siparis_miktari_2)>
                </cfif>
                    <td rel="kolon_52" class="sip2_back" style="text-align:right; <cfif listfind(hide_col_list,'kolon_52')>display:none;</cfif>" id="STOCK_SATIS_AMOUNT_TUTAR_2_#product_id#_#stock_id#_#department_id#">#deger_#</td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_54">
                <cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_TUTAR_KDVLI_2_#product_id#_#stock_id#_#department_id#")>
					<cfset deger_ = evaluate("get_table_info.STOCK_SATIS_AMOUNT_TUTAR_KDVLI_2_#product_id#_#stock_id#_#department_id#")>
                <cfelse>
                    <cfset deger_ = tlformat(liste_fiyati_kdvli_ * siparis_miktari_2)>
                </cfif>
                    <td rel="kolon_54" class="sip2_back" style="text-align:right; <cfif listfind(hide_col_list,'kolon_54')>display:none;</cfif>" id="STOCK_SATIS_AMOUNT_TUTAR_KDVLI_2_#product_id#_#stock_id#_#department_id#">#deger_#</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_37">
                <td rel="kolon_37" class="sip2_back" style="<cfif listfind(hide_col_list,'kolon_37')>display:none;</cfif>" nowrap>
                    <cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#_#department_id#") and (not isdefined("attributes.calc_type") or listfind('0,3',attributes.calc_type))>
						<cfset deger_sip2 = evaluate("get_table_info.STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#_#department_id#")>
                    <cfelse>
                        <cfset deger_sip2 = tlformat(siparis_miktari_2)>
                    </cfif>
                    <cfif not isdefined("attributes.print_action")>
                    	<cfif isdefined("get_table_info.is_order2_#product_id#_#stock_id#_#department_id#") or (isdefined("attributes.calc_type") and attributes.calc_type neq 0)>
                            <input type="checkbox" name="is_order2_#product_id#_#stock_id#_#department_id#" id="is_order2_#product_id#_#stock_id#_#department_id#" value="1" rel_name="is_order2_dept">
                        <cfelse>
                        	<input type="checkbox" name="is_order2_#product_id#_#stock_id#_#department_id#" id="is_order2_#product_id#_#stock_id#_#department_id#" value="1" rel_name="is_order2_dept">
                        </cfif>
                        <cfinput type="text" name="STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#_#department_id#" class="moneybox" stock_group_name="STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#" product_group_name="STOCK_SATIS_AMOUNT_2_#product_id#" onkeyup="hesapla_koli('STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#_#department_id#','STOCK_SATIS_AMOUNT_KOLI_2_#product_id#_#stock_id#_#department_id#','multiplier_#product_id#');" onBlur="duzenle_adet_koli('STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#_#department_id#','STOCK_SATIS_AMOUNT_KOLI_2_#product_id#_#stock_id#_#department_id#','multiplier_#product_id#','liste_fiyati_#product_id#','liste_fiyati_kdvli_#product_id#','STOCK_SATIS_AMOUNT_TUTAR_2_#product_id#_#stock_id#_#department_id#','STOCK_SATIS_AMOUNT_TUTAR_KDVLI_2_#product_id#_#stock_id#_#department_id#','2','#department_id#');" value="#deger_sip2#" style="width:70px;">
                    <cfelse>
                        #deger_sip2#
                    </cfif>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_38">
                <td rel="kolon_38" class="sip2_back" style="text-align:right; <cfif listfind(hide_col_list,'kolon_38')>display:none;</cfif>" nowrap>
                <cfif len(multiplier)>
                    <cfif isdefined("get_table_info.STOCK_SATIS_AMOUNT_KOLI_2_#product_id#_#stock_id#_#department_id#") and (not isdefined("attributes.calc_type") or listfind('0,3',attributes.calc_type))>
                        <cfset deger_ = evaluate("get_table_info.STOCK_SATIS_AMOUNT_KOLI_2_#product_id#_#stock_id#_#department_id#")>
                    <cfelse>
                        <cfset deger_ = tlformat(siparis_miktari_2 / multiplier)>
                    </cfif>
                    <cfif not isdefined("attributes.print_action")>
                    	<cfinput type="text" name="STOCK_SATIS_AMOUNT_KOLI_2_#product_id#_#stock_id#_#department_id#" class="moneybox" stock_group_name="STOCK_SATIS_AMOUNT_KOLI_2_#product_id#_#stock_id#" product_group_name="STOCK_SATIS_AMOUNT_KOLI_2_#product_id#" onkeyup="hesapla_adet('STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#_#department_id#','STOCK_SATIS_AMOUNT_KOLI_2_#product_id#_#stock_id#_#department_id#','multiplier_#product_id#');" onBlur="duzenle_adet_koli('STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#_#department_id#','STOCK_SATIS_AMOUNT_KOLI_2_#product_id#_#stock_id#_#department_id#','multiplier_#product_id#','liste_fiyati_#product_id#','liste_fiyati_kdvli_#product_id#','STOCK_SATIS_AMOUNT_TUTAR_2_#product_id#_#stock_id#_#department_id#','STOCK_SATIS_AMOUNT_TUTAR_KDVLI_2_#product_id#_#stock_id#_#department_id#','2','#department_id#');" value="#deger_#" style="width:60px;">
                    <cfelse>
                    	#deger_#
                    </cfif>
                </cfif>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_39">
                <td rel="kolon_39" class="sip2_back" style="<cfif listfind(hide_col_list,'kolon_39')>display:none;</cfif>" nowrap id="order_date_2_#product_id#_#stock_id#_#department_id#_td">
                    <cfif isdefined("get_table_info.order_date_2_#product_id#") and (not isdefined("attributes.calc_type") or listfind('0,3',attributes.calc_type))>
                        <cfset deger_ = evaluate("get_table_info.order_date_2_#product_id#")>
                    <cfelse>
                        <cfset deger_ = dateformat(dateadd('d',15,now()),'dd/mm/yyyy')>
                    </cfif>
                    <cfif not isdefined("attributes.print_action")>
                        <!---
                        <input type="text" name="order_date_2_#product_id#_#stock_id#_#department_id#" stock_group_name="order_date_2_#stock_id#" product_group_name="order_date_2_#product_id#"  maxlength="10" value="#deger_#" style="width:65px;">
                        <cfif not isdefined("attributes.add_action")><cf_wrk_date_image date_field="order_date_2_#product_id#_#stock_id#_#department_id#"></cfif>
                		--->
					<cfelse>
                    	#deger_#
                	</cfif>
                </td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_41"><td rel="kolon_41" style=" <cfif listfind(hide_col_list,'kolon_41')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_20"><td rel="kolon_20" style=" <cfif listfind(hide_col_list,'kolon_20')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_21"><td rel="kolon_21" style=" <cfif listfind(hide_col_list,'kolon_21')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_22"><td rel="kolon_22" class="sip1_back" style="<cfif listfind(hide_col_list,'kolon_22')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_23"><td rel="kolon_23" style=" text-align:right; <cfif listfind(hide_col_list,'kolon_23')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_47">
                <td rel="kolon_47" style=" <cfif listfind(hide_col_list,'kolon_47')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_48">
                <td rel="kolon_48" style=" <cfif listfind(hide_col_list,'kolon_48')>display:none;</cfif>" nowrap>&nbsp;</td>
                </cfsavecontent> 
                <cfsavecontent variable="icerik_49">
                <td rel="kolon_49" style=" <cfif listfind(hide_col_list,'kolon_49')>display:none;</cfif>" nowrap>
                <cfif not isdefined("attributes.print_action")>
		    	<cfif 
                        row_stock gt 0 and ROW_ORT_STOK_SATIS_MIKTARI gt 0 and
                        (row_stock / ROW_ORT_STOK_SATIS_MIKTARI) gt dueday_
                    >
                        <cfset rakam_ = int(row_stock - ROW_ORT_STOK_SATIS_MIKTARI * DUEDAY_)>
                        <a href="javascript://" onclick="sevk_islemi_baslat('#stock_id#','#department_id#','#rakam_#');"><img src="/images/ship.gif" alt="Stok Dağıt"/></a>
                    </cfif>
                    <cfinput type="hidden" name="sevk_islemi_#stock_id#_#department_id#" value=""/>
                    <br />
                    <cfinput type="hidden" name="sevk_islemi_gelen_#stock_id#_#department_id#" value=""/>
                </cfif>
		</td>
                </cfsavecontent>
                
                <cfsavecontent variable="icerik_55"><td rel="kolon_55" style=" <cfif listfind(hide_col_list,'kolon_55')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_57"><td rel="kolon_57" style=" <cfif listfind(hide_col_list,'kolon_57')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_58"><td rel="kolon_58" style=" <cfif listfind(hide_col_list,'kolon_58')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_59"><td rel="kolon_59" style=" <cfif listfind(hide_col_list,'kolon_59')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_60"><td rel="kolon_60" style=" <cfif listfind(hide_col_list,'kolon_60')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_61"><td rel="kolon_61" style=" <cfif listfind(hide_col_list,'kolon_61')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_62"><td rel="kolon_62" style=" <cfif listfind(hide_col_list,'kolon_62')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_63"><td rel="kolon_63" style=" <cfif listfind(hide_col_list,'kolon_63')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_64"><td rel="kolon_64" style=" <cfif listfind(hide_col_list,'kolon_64')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_65"><td rel="kolon_65" style=" <cfif listfind(hide_col_list,'kolon_65')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_66"><td rel="kolon_66" style=" <cfif listfind(hide_col_list,'kolon_66')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_67"><td rel="kolon_67" style=" <cfif listfind(hide_col_list,'kolon_67')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_68"><td rel="kolon_68" style=" <cfif listfind(hide_col_list,'kolon_68')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_69"><td rel="kolon_69" style=" <cfif listfind(hide_col_list,'kolon_69')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_70"><td rel="kolon_70" style=" <cfif listfind(hide_col_list,'kolon_70')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent> 
                <cfsavecontent variable="icerik_71"><td rel="kolon_71" style=" <cfif listfind(hide_col_list,'kolon_71')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_72"><td rel="kolon_72" style=" <cfif listfind(hide_col_list,'kolon_72')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_73"><td rel="kolon_73" style=" <cfif listfind(hide_col_list,'kolon_73')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_74">
                	<td rel="kolon_74" style=" <cfif listfind(hide_col_list,'kolon_74')>display:none;</cfif>color:##FF8C00; text-align:right;" class="list_oran_back" nowrap>
                		<cfset stok_ort_satis = ROW_ORT_STOK_SATIS_MIKTARI * LISTE_FIYATI>
						<cfif ort_liste_satis_tutar gt 0>                            
                                <cfset total_stok_ort_satis = stok_ort_satis / ort_liste_satis_tutar*100>                            
                        <cfelse>
                            <cfset total_stok_ort_satis = 0>
                        </cfif>
                        
                        #tlformat(total_stok_ort_satis,2)#
                        
						<!---#tlformat(ROW_ORT_STOK_SATIS_MIKTARI * LISTE_FIYATI)#--->
                	</td>
                </cfsavecontent>
                <cfsavecontent variable="icerik_75"><td rel="kolon_75" style=" <cfif listfind(hide_col_list,'kolon_75')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfsavecontent variable="icerik_76"><td rel="kolon_76" style=" <cfif listfind(hide_col_list,'kolon_76')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                <cfloop from="1" to="#listlen(kolon_sira)#" index="ccc">
                    <cfset mmm_ = listgetat(kolon_sira,ccc)>
                    <cfset icerik_ = evaluate("icerik_#mmm_#")>
                    <cfset icerik_ = replace(icerik_,'<td ','<td title="#department_head# - #listgetat(kolon_names,mmm_)#" ','one')>
                    <cfif not isdefined("attributes.print_action")>
                    	<!--- #icerik_# --->
                        <cfif listfind(hide_col_list,'kolon_#mmm_#') and isdefined("attributes.is_only_related_areas")>
                            <td rel="kolon_#mmm_#" style="display:none;"></td>
                        <cfelse>
                            #icerik_#
                        </cfif>
                    <cfelse>
						<cfif mmm_ neq 1>#icerik_#</cfif> 
					</cfif>
                </cfloop>
            </tr>
            </cfif>
            <!---
			<cfif not listfindnocase(merkez_depo_id,department_id)>
                <cfif row_stock lt merkez_depo_stock_total>
                    <cfset newRow = QueryAddRow(depo_ceza_query,1)>
                    <cfset temp = QuerySetCell(depo_ceza_query, "DEPT_ID",department_id,depo_ceza_query.recordcount)>
                    <cfset temp = QuerySetCell(depo_ceza_query, "STOCK_ID",stock_id,depo_ceza_query.recordcount)>
                    <cfset temp = QuerySetCell(depo_ceza_query, "PRODUCT_ID",product_id,depo_ceza_query.recordcount)>
                    <cfset temp = QuerySetCell(depo_ceza_query, "POINT",1,depo_ceza_query.recordcount)>
                    <cfset temp = QuerySetCell(depo_ceza_query, "DEPT_HEAD",department_head,depo_ceza_query.recordcount)>
                    <cfset temp = QuerySetCell(depo_ceza_query, "TOTAL_PRODUCT",get_stocks_only.recordcount,depo_ceza_query.recordcount)>
                    <cfset temp = QuerySetCell(depo_ceza_query, "POINT_MULTIPLIER",POINT_MULTIPLIER,depo_ceza_query.recordcount)>
                </cfif>
            </cfif>
			--->
        </cfoutput>
        <cfif p_count eq listlen(all_p_list)>
         <cfif not isdefined("attributes.print_action")>
            <tr row_type="total_row" id="total_row_#product_catid#">
                <cfloop from="1" to="#listlen(kolon_sira)#" index="ccc">
                    <td rel="kolon_#ccc#" style="<cfif listfind(hide_col_list,'kolon_#ccc#')>display:none;</cfif> color:white;">
                        <cfset mmm_ = listgetat(kolon_sira,ccc)>
                        <cfif mmm_ eq 42>#tlformat(group_miktar_total)#</cfif>
                        <cfif mmm_ eq 46>
                            <cfif group_tutar_total lte 0>
                                <span style="color:red; font-weight:700;">#tlformat(group_tutar_total)#</span>
                            <cfelse>
                                #tlformat(group_tutar_total)#
                            </cfif>
                        </cfif>
                    </td>
                </cfloop>
            </tr>
         </cfif>
            <cfset group_miktar_total = 0>
            <cfset group_tutar_total = 0>
        </cfif>
</cfsavecontent>
</cfoutput>
<cfif not isdefined("attributes.add_action")>
	<cfloop list="#product_id_list#" index="ccc"><cfoutput>#evaluate("product_icerik_#ccc#")#</cfoutput></cfloop>
<cfelse>
	<cfoutput>
        <br />
        <br />
        İşlem Yapılıyor. Lütfen Bekleyiniz!
        <br />
        <br />
        ÜRÜN LİSTESİ : #product_id_list#
        <BR />
        <cfloop list="#product_id_list#" index="ccc">
            <textarea id="product_icerik_#ccc#" name="product_icerik_#ccc#" style="display:none;"><cfoutput>#evaluate("product_icerik_#ccc#")#</cfoutput></textarea>
            <script>
                veri = document.getElementById('product_icerik_#ccc#').value;
                window.opener.add_row_pop('#ccc#',veri);
            </script>
        </cfloop>
        <cfif not isdefined("attributes.is_excel")>
			<script>
                window.opener.set_key_up_down();
                window.location.href = '#request.self#?fuseaction=retail.popup_add_row_to_speed_manage_product&layout_id=#attributes.layout_id#&search_startdate=#dateformat(attributes.search_startdate,"dd/mm/yyyy")#&search_finishdate=#dateformat(attributes.search_finishdate,"dd/mm/yyyy")#';
            </script>
        <cfelse>
        	<script>
                window.opener.set_key_up_down();
                window.location.href = '#request.self#?fuseaction=retail.popup_add_row_to_speed_manage_product_excel&layout_id=#attributes.layout_id#&search_startdate=#dateformat(attributes.search_startdate,"dd/mm/yyyy")#&search_finishdate=#dateformat(attributes.search_finishdate,"dd/mm/yyyy")#';
            </script>
        </cfif>
    </cfoutput>
</cfif>
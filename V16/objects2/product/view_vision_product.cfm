<cfif not isdefined("attributes.is_vision_product_detail2")>
	<cfset attributes.is_vision_product_detail2 = 0>
</cfif>
<cfoutput>
<!--- burasi urun blogu ayirmayin--->
<div align="center">
<table align="center">
	<cfif isdefined("attributes.vision_image_display") and attributes.vision_image_display eq 1>
		<tr>
			<td align="center" style="vertical-align:bottom;">
				<cfif get_image.recordcount>
					<cfif isDefined('attributes.vision_image_width') and len(attributes.vision_image_width)>
                        <cfset my_image_width = attributes.vision_image_width>
                    </cfif>
                    <cfif isDefined('attributes.vision_image_height') and len(attributes.vision_image_height)>
                        <cfset my_image_height = attributes.vision_image_height>
                    </cfif>
                    <a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#','#user_friendly_url#')#">
                        <cfif isDefined('attributes.vision_image_width') and len(attributes.vision_image_width) and isDefined('attributes.vision_image_height') and len(attributes.vision_image_height)>
                            <cf_get_server_file output_file="product/#get_image.path#" output_server="#get_image.path_server_id#" title="#get_image.detail#" alt="#get_image.detail#" output_type="0" image_width="#my_image_width#" image_height="#my_image_height#" image_link="0">
                        <cfelseif not (isDefined('attributes.vision_image_height') and len(attributes.vision_image_height))>
                            <cf_get_server_file output_file="product/#get_image.path#" output_server="#get_image.path_server_id#" title="#get_image.detail#" alt="#get_image.detail#" output_type="0" image_width="#my_image_width#" image_link="0">
                        <cfelse>
                            <cf_get_server_file output_file="product/#get_image.path#" output_server="#get_image.path_server_id#" title="#get_image.detail#" alt="#get_image.detail#" output_type="0" image_height="#my_image_height#" image_link="0">
                        </cfif>
                    </a>
                </cfif>
			</td>
		</tr>
	</cfif>
	<cfif (isdefined('attributes.is_vision_product_detail') and attributes.is_vision_product_detail eq 1) and (len(vision_detail))>
		<tr>
			<td align="center" class="vision_detail" style="vertical-align:bottom;">
				<a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#','#user_friendly_url#')#" class="vision_detail">#vision_detail#</a>
			</td>
		</tr>
	</cfif>
	<cfif isdefined('attributes.is_vision_product_name') and attributes.is_vision_product_name eq 1>
        <tr>
            <td align="center" style="vertical-align:top;">
                <a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#','#user_friendly_url#')#" class="vision_name">
                    <cfif attributes.is_vision_product_detail2 eq 1>#product_detail2#<cfelse>#product_name# #property#</cfif>
                </a>
            </td>
        </tr>
	</cfif>
	<cfif isdefined("attributes.is_vision_prices") and attributes.is_vision_prices neq 0>
		<cfif get_pro.recordcount>
            <tr>
                <td align="center">
                 <cfscript>
                    prom_id = '';
                    prom_discount = '';
                    prom_amount_discount = '';
                    prom_cost = '';
                    prom_free_stock_id = '';
                    prom_stock_amount = 1;
                    prom_free_stock_amount = 1;
                    prom_free_stock_price = 0;
                    prom_free_stock_money = '';
                 </cfscript>
                <cfif get_pro.recordcount>
                    <cfscript>
                        prom_id = get_pro.prom_id;
                        prom_discount = get_pro.discount;
                        prom_amount_discount = get_pro.amount_discount;
                        prom_cost = get_pro.total_promotion_cost;
                        prom_free_stock_id =  get_pro.free_stock_id;
                        if(len(get_pro.limit_value)) prom_stock_amount = get_pro.limit_value;
                        if(len(get_pro.free_stock_amount)) prom_free_stock_amount = get_pro.free_stock_amount;
                        if(len(get_pro.free_stock_price)) prom_free_stock_price = get_pro.free_stock_price;
                        if(len(get_pro.amount_1_money)) prom_free_stock_money = get_pro.amount_1_money;
                    </cfscript>
                    <cfscript>
                        prom_id = get_pro.prom_id;
                        prom_discount = get_pro.discount;
                        prom_amount_discount = get_pro.amount_discount;
                        if(len(get_pro.amount_discount_money_1))
                            prom_amount_discount_money = trim(get_pro.amount_discount_money_1);
                        else
                            prom_amount_discount_money = row_money;
                        prom_cost = get_pro.total_promotion_cost;
                        prom_free_stock_id =  get_pro.free_stock_id;
                        prom_stok_id = get_pro.stock_id; //promosyonu olan urunun stok_id si
                        if(len(get_pro.limit_value)) prom_stock_amount = get_pro.limit_value;
                        if(len(get_pro.free_stock_amount)) prom_free_stock_amount = get_pro.free_stock_amount;
                        if(len(get_pro.free_stock_price)) prom_free_stock_price = get_pro.free_stock_price;
                        if(len(get_pro.amount_1_money)) 
                            prom_free_stock_money = get_pro.amount_1_money;
                        else
                            prom_free_stock_money = row_money;
                    </cfscript>
                    <cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
                        SELECT
                            (RATE2/RATE1) RATE
                        FROM 
                            SETUP_MONEY
                        WHERE
                            MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#prom_free_stock_money#">
                    </cfquery>
                    <cfif len(get_pro.icon_id) and (get_pro.icon_id gt 0)>
                        <cfquery name="GET_ICON" datasource="#DSN3#">
                        	SELECT ICON, ICON_SERVER_ID FROM SETUP_PROMO_ICON WHERE ICON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pro.icon_id#">
                        </cfquery>
                        <cf_get_server_file output_file="sales/#get_icon.icon#" output_server="#get_icon.icon_server_id#" output_type="0" image_width="15" image_height="15"  alt="#getLang('main',617)#" title="#getLang('main',617)#">
                    </cfif>
                    <font color="FF0000">
                    <cfif len(prom_free_stock_id)>
                        #get_product_name(stock_id:prom_free_stock_id,with_property:1)# <strong><cf_get_lang no='131.Hediye'></strong>
                    <cfelseif len(prom_discount)>
                        #wrk_round((musteri_flt_other_money_value_kdv - (musteri_flt_other_money_value_kdv * ((100 - prom_discount) / 100)))*get_money_info.rate)# #session_base.money# (% #prom_discount#) <strong><cf_get_lang_main no ='1148.İndirim'></strong>
                    <cfelseif len(prom_amount_discount)>
                        #prom_amount_discount# #prom_amount_discount_money# (% #wrk_round(100-((musteri_flt_other_money_value-prom_amount_discount)*100/musteri_flt_other_money_value))#) <strong><cf_get_lang_main no ='1148.İndirim'></strong>
                    </cfif>
                    </font>
                <cfelse>
                    &nbsp;
                </cfif>
                <input type="hidden" name="vision_prom_id_#currentrow#_#this_row_id_#" id="vision_prom_id_#currentrow#_#this_row_id_#" value="#prom_id#">
                <input type="hidden" name="vision_prom_discount_#currentrow#_#this_row_id_#" id="vision_prom_discount_#currentrow#_#this_row_id_#" value="#prom_discount#">
                <input type="hidden" name="vision_prom_amount_discount_#currentrow#_#this_row_id_#" id="vision_prom_amount_discount_#currentrow#_#this_row_id_#" value="#prom_amount_discount#">
                <input type="hidden" name="vision_prom_cost_#currentrow#_#this_row_id_#" id="vision_prom_cost_#currentrow#_#this_row_id_#" value="#prom_cost#">
                <input type="hidden" name="vision_prom_free_stock_id_#currentrow#_#this_row_id_#" id="vision_prom_free_stock_id_#currentrow#_#this_row_id_#" value="#prom_free_stock_id#">				
                <input type="hidden" name="vision_prom_stock_amount_#currentrow#_#this_row_id_#" id="vision_prom_stock_amount_#currentrow#_#this_row_id_#" value="#prom_stock_amount#">
                <input type="hidden" name="vision_prom_free_stock_amount_#currentrow#_#this_row_id_#" id="vision_prom_free_stock_amount_#currentrow#_#this_row_id_#" value="#prom_free_stock_amount#">
                <input type="hidden" name="vision_prom_free_stock_price_#currentrow#_#this_row_id_#" id="vision_prom_free_stock_price_#currentrow#_#this_row_id_#" value="#prom_free_stock_price#">
                <input type="hidden" name="vision_prom_free_stock_money_#currentrow#_#this_row_id_#" id="vision_prom_free_stock_money_#currentrow#_#this_row_id_#" value="#prom_free_stock_money#">	
                </td>
            </tr>
        <cfelse>
            <input type="hidden" name="vision_prom_id_#currentrow#_#this_row_id_#" id="vision_prom_id_#currentrow#_#this_row_id_#" value="">
            <input type="hidden" name="vision_prom_discount_#currentrow#_#this_row_id_#"  id="vision_prom_discount_#currentrow#_#this_row_id_#" value="">
            <input type="hidden" name="vision_prom_amount_discount_#currentrow#_#this_row_id_#" id="vision_prom_amount_discount_#currentrow#_#this_row_id_#" value="">
            <input type="hidden" name="vision_prom_cost_#currentrow#_#this_row_id_#" id="vision_prom_cost_#currentrow#_#this_row_id_#" value="">
            <input type="hidden" name="vision_prom_free_stock_id_#currentrow#_#this_row_id_#" id="vision_prom_free_stock_id_#currentrow#_#this_row_id_#" value="">				
            <input type="hidden" name="vision_prom_stock_amount_#currentrow#_#this_row_id_#" id="vision_prom_stock_amount_#currentrow#_#this_row_id_#" value="1">
            <input type="hidden" name="vision_prom_free_stock_amount_#currentrow#_#this_row_id_#"  id="vision_prom_free_stock_amount_#currentrow#_#this_row_id_#" value="">
            <input type="hidden" name="vision_prom_free_stock_price_#currentrow#_#this_row_id_#" id="vision_prom_free_stock_price_#currentrow#_#this_row_id_#" value="">
            <input type="hidden" name="vision_prom_free_stock_money_#currentrow#_#this_row_id_#" id="vision_prom_free_stock_money_#currentrow#_#this_row_id_#" value="">
        </cfif>
		<tr>
		 	<td align="center" class="vision_fiyat">
			<cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
				SELECT
					(RATE2/RATE1) RATE
				FROM 
					SETUP_MONEY
				WHERE
					MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#musteri_row_money#">
			</cfquery>
			<cfif get_pro.recordcount>
				<cfif len(get_pro.discount) and get_pro.discount>
					<cfset musteri_flt_other_money_value_with_prom = musteri_flt_other_money_value * ((100-get_pro.discount)/100)>
				<cfelseif len(get_pro.amount_discount) and get_pro.amount_discount>
					<cfset musteri_flt_other_money_value_with_prom = musteri_flt_other_money_value - get_pro.amount_discount>
				<cfelse>
					<cfset musteri_flt_other_money_value_with_prom = musteri_flt_other_money_value>
				</cfif>
				<cfset musteri_flt_other_money_value_with_prom_kdv = musteri_flt_other_money_value_with_prom * ((100+tax)/100)>

				<cfif isdefined("attributes.is_vision_prices") and attributes.is_vision_prices eq 2>
					<cfif (len(get_pro.discount) and get_pro.discount) or (len(get_pro.amount_discount) and get_pro.amount_discount)>
						<font class="strike">#TLFormat(musteri_flt_other_money_value)# #musteri_row_money#</font><br/>
					</cfif>
					#TLFormat(musteri_flt_other_money_value_with_prom)# #musteri_row_money# + KDV
				<cfelseif isdefined("attributes.is_vision_prices") and attributes.is_vision_prices eq 3>
					<cfif (len(get_pro.discount) and get_pro.discount) or (len(get_pro.amount_discount) and get_pro.amount_discount)>
						<font class="strike">#TLFormat(musteri_flt_other_money_value * get_money_info.RATE)# #session_base.money#</font><br/>
					</cfif>
					#TLFormat(musteri_flt_other_money_value_with_prom * get_money_info.rate)# #session_base.money# + KDV
				<cfelseif isdefined("attributes.is_vision_prices") or attributes.is_vision_prices eq 4>
					<cfif (len(get_pro.discount) and get_pro.discount) or (len(get_pro.amount_discount) and get_pro.amount_discount)>
						<font class="strike">#TLFormat(musteri_flt_other_money_value_kdv * get_money_info.rate)# #session_base.money#</font><br/>
					</cfif>
					#TLFormat(musteri_flt_other_money_value_with_prom_kdv * get_money_info.rate)# #session_base.money#
				<cfelse>
					#TLFormat(musteri_flt_other_money_value_with_prom_kdv)# #musteri_row_money#
				</cfif>

				<cfset price_form = musteri_flt_other_money_value_with_prom>
				<cfset price_form_kdv = musteri_flt_other_money_value_with_prom_kdv>
			<cfelse>
				<cfif isdefined("attributes.is_vision_prices") and attributes.is_vision_prices eq 2>
					#TLFormat(musteri_flt_other_money_value)# #musteri_row_money# + KDV
				<cfelseif isdefined("attributes.is_vision_prices") and attributes.is_vision_prices eq 3>
					#TLFormat(musteri_flt_other_money_value * get_money_info.rate)# #session_base.money# + KDV
				<cfelseif isdefined("attributes.is_vision_prices") and attributes.is_vision_prices eq 4>
					#TLFormat(musteri_flt_other_money_value_kdv * get_money_info.rate)# #session_base.money#
				<cfelse>
					#TLFormat(musteri_flt_other_money_value_kdv)# #musteri_row_money#
				</cfif>
				<cfset price_form = musteri_flt_other_money_value>
				<cfset price_form_kdv = musteri_flt_other_money_value * ((100+tax)/100)>
			</cfif>
			<input type="hidden" name="vision_price_old_#currentrow#_#this_row_id_#" id="vision_price_old_#currentrow#_#this_row_id_#" value="<cfif GET_PRO.recordcount>#musteri_flt_other_money_value#</cfif>">
			<input type="hidden" name="vision_price_#currentrow#_#this_row_id_#" id="vision_price_#currentrow#_#this_row_id_#" value="#price_form#">
			<input type="hidden" name="vision_price_kdv_#currentrow#_#this_row_id_#" id="vision_price_kdv_#currentrow#_#this_row_id_#" value="#price_form*(1+(tax/100))#">
			<input type="hidden" name="vision_price_money_#currentrow#_#this_row_id_#" id="vision_price_money_#currentrow#_#this_row_id_#" value="#musteri_row_money#">
		  	</td>
		</tr>
		<cfif get_havale.recordcount>
			<tr>
				<cfif not len(get_havale.first_interest_rate)>
                    <cfset get_havale.first_interest_rate = 0> 
                </cfif>
           		<td align="center" class="prodFiyat" style="vertical-align:bottom;">
                	<font color="red">
                    #TLFormat((price_form_kdv * get_money_info.rate) - (price_form_kdv * get_money_info.rate) * get_havale.first_interest_rate / 100)# #session_base.money# <br/>Havale (% #get_havale.first_interest_rate# İndirimli)
                 	</font>
                </td>
			</tr>
		</cfif>
	<cfelse>
		<cfif isdefined('musteri_flt_other_money_value')>
			<input type="hidden" name="vision_price_old_#currentrow#_#this_row_id_#" id="vision_price_old_#currentrow#_#this_row_id_#" value="<cfif isdefined('GET_PRO') and GET_PRO.recordcount>#musteri_flt_other_money_value#</cfif>">
		</cfif>
		<cfif isdefined('musteri_flt_other_money_value')>	
			<input type="hidden" name="vision_price_#currentrow#_#this_row_id_#" id="vision_price_#currentrow#_#this_row_id_#" value="#musteri_flt_other_money_value#">
			<input type="hidden" name="vision_price_kdv_#currentrow#_#this_row_id_#" id="vision_price_kdv_#currentrow#_#this_row_id_#" value="#musteri_flt_other_money_value*(1+(tax/100))#">
		</cfif>
		<cfif isdefined('musteri_row_money')>		
			<input type="hidden" name="vision_price_money_#currentrow#_#this_row_id_#" id="vision_price_money_#currentrow#_#this_row_id_#" value="#musteri_row_money#">
		</cfif>
	</cfif>
	<cfif isdefined('product_id')>
		<tr>
			<td align="center" style="vertical-align:top;">
				<a href="#url_friendly_request('objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#','#user_friendly_url#')#"<!---href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#"---> class="vision_product_detail_image"></a>
			</td>
		</tr>
	</cfif>
	<cfif (isdefined('attributes.is_sale') and attributes.is_sale eq 1) or (isdefined('attributes.is_sale') and attributes.is_sale eq 2 and isdefined('session_base.userid'))>
		<cfif (is_zero_stock eq 1 or is_zero_stock neq 1)>
			<tr>
				<td align="center" style="vertical-align:bottom;">
					<input type="text" name="miktar_#currentrow#_#this_row_id_#" id="miktar_#currentrow#_#this_row_id_#" value="1" style="width:30px;">
					<a href="##" onclick="vision_urun_gonder_#this_row_id_#('#currentrow#');return PROCTest2();" class="HeaderSepet"></a> 
				</td>
			</tr>
		</cfif>
	</cfif>
</table>
</div>
<!--- burasi urun blogu ayirmayin--->
</cfoutput>


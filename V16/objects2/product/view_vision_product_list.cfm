<table cellspacing="1" cellpadding="2" align="center" border="0" class="color-border" style="width:100%;">
	<tr class="color-header" style="height:22px;">
		<cfif isdefined("attributes.vision_image_display") and attributes.vision_image_display eq 1>
			<td class="form-title">Görsel</td>
		</cfif>
		<cfif isdefined('attributes.is_vision_product_name') and attributes.is_vision_product_name eq 1>
			<td class="form-title" align="left">Ürün</td>
		</cfif>
		<cfif isdefined('attributes.is_vision_product_detail') and attributes.is_vision_product_detail eq 1>
			<td class="form-title" style="text-align:left;">Açıklama</td>
		</cfif>
		<td class="form-title" align="center" style="width:65px;">Ürün Kodu</td>
		<cfif isdefined("attributes.is_vision_prices") and attributes.is_vision_prices neq 0>
			<td class="form-title" align="center" style="width:100px;">Fiyat</td>
		</cfif>
		<cfif ((attributes.is_sale eq 1) or ((attributes.is_sale eq 2) and isdefined('session_base.userid')))>
			<td class="form-title" align="center" style="width:55px;">Miktar</td>
			<td class="form-title" style="text-align:right;" style="width:50px;"></td>
		</cfif>
	</tr>
	<cfoutput query="get_vision_product" startrow="1" maxrows="#attributes.dongu#">
		<cfif isdefined("attributes.is_vision_prices") and attributes.is_vision_prices neq 0>
			<cfif isDefined("money")>
				<cfset attributes.money = money>
			</cfif>
			<cfloop query="moneys">
				<cfif moneys.money is attributes.money>
					<cfset row_money = money >
					<cfset row_money_rate1 = moneys.rate1>
					<cfset row_money_rate2 = moneys.rate2>
				</cfif>
			</cfloop>
			<cfset pro_price = price>
			<cfset pro_price_kdv = price_kdv>
			<cfif attributes.price_catid neq -2>
				<cfquery name="GET_P" dbtype="query">
					SELECT * FROM GET_PRICE_ALL WHERE UNIT = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_unit_id[currentrow]#"> AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
				</cfquery>
				<cfscript>
					if(get_p.recordcount and len(get_p.price))
					{
						musteri_pro_price = get_p.price;
						musteri_pro_price_kdv = get_p.price_kdv; 
						musteri_row_money=get_p.money; 
					}
					else
					{
						musteri_pro_price = pro_price;
						musteri_pro_price_kdv = pro_price_kdv;
						musteri_row_money=attributes.money;
					}
					//musteriye ozel fiyat yoksa son kullanici gecerli
					//{musteri_pro_price = 0;musteri_row_money=default_money.money;}
				</cfscript>
				<cfloop query="moneys">
					<cfif moneys.money is musteri_row_money>
						<cfset musteri_row_money_rate1 = moneys.rate1>
						<cfset musteri_row_money_rate2 = moneys.rate2>
					</cfif>
				</cfloop>				
				<cfscript>
					if(musteri_row_money is default_money.money)
					{
						musteri_str_other_money = musteri_row_money; 
						musteri_flt_other_money_value = musteri_pro_price;
						musteri_flt_other_money_value_kdv = musteri_pro_price_kdv;
						musteri_flag_prc_other = 0;
					}
					else
					{
						musteri_flag_prc_other = 1 ;
						{
							musteri_str_other_money = musteri_row_money; 
							musteri_flt_other_money_value = musteri_pro_price;
							musteri_flt_other_money_value_kdv = musteri_pro_price_kdv;
						}
						musteri_pro_price = musteri_pro_price*(musteri_row_money_rate2/musteri_row_money_rate1);
					}
				</cfscript>
			<cfelse>
				<cfscript>
					musteri_flt_other_money_value = pro_price;
					musteri_str_other_money = row_money;
					musteri_row_money = row_money;
					
					musteri_flag_prc_other = 1;
					musteri_pro_price = pro_price*(row_money_rate2/row_money_rate1);
					musteri_pro_price_kdv = pro_price_kdv*(row_money_rate2/row_money_rate1);
					musteri_str_other_money = default_money.money;
					musteri_flt_other_money_value_kdv = musteri_pro_price_kdv;
				</cfscript>
			</cfif>
		</cfif>
			<cfquery name="GET_PRO" dbtype="query" maxrows="1">
				SELECT 
					* 
				FROM 
					GET_PROM_ALL 
				WHERE 
					STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
			<cfif attributes.price_catid neq -2>
				<cfif len(get_p.price_catid)>
					AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_p.price_catid#">
				</cfif>
			<cfelse>
				AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#">
			</cfif>
				ORDER BY
					PROM_ID DESC
			</cfquery>
		<cfif isdefined("attributes.vision_image_display") and attributes.vision_image_display eq 1>
			<cfquery name="GET_IMAGE" datasource="#DSN3#" maxrows="1">
				SELECT PATH,PATH_SERVER_ID,PRODUCT_ID,DETAIL FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0 AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> ORDER BY PRODUCT_IMAGEID DESC
			</cfquery>
		</cfif>
		<input type="hidden" name="vision_sid_#currentrow#_#this_row_id_#" id="vision_sid_#currentrow#_#this_row_id_#" value="#stock_id#">
		<input type="hidden" name="vision_pid_#currentrow#_#this_row_id_#" id="vision_pid_#currentrow#_#this_row_id_#" value="#product_id#">
		<tr <cfif currentrow mod 2>bgcolor="efefef"<cfelse>bgcolor="ffffff"</cfif>>
			<cfif get_pro.recordcount>
				<td>
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
					<cfif len(get_pro.icon_id) and (get_pro.icon_id gt 0)>
						<cfquery name="GET_ICON" datasource="#DSN3#">
							SELECT * FROM SETUP_PROMO_ICON WHERE ICON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pro.icon_id#">
						</cfquery>
						<cf_get_server_file output_file="sales/#get_icon.icon#" output_server="#get_icon.icon_server_id#" output_type="0" image_width="15" image_height="15"  alt="#getLang('main',617)#" title="#getLang('main',617)#">
					<cfelse>
					</cfif>
					<font color="FF0000">
					<cfif len(prom_free_stock_id)>
						<strong><cf_get_lang no='131.Hediye'>:</strong> #get_product_name(stock_id:prom_free_stock_id,with_property:1)#
					<cfelseif  len(prom_discount)>
						<strong><cf_get_lang no='132.Yüzde İndirim'>:</strong> % #prom_discount#
					<cfelseif  len(prom_amount_discount)>
						<strong><cf_get_lang no='133.Tutar Indirimi'>:</strong> #prom_amount_discount# #get_pro.amount_1_money#
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
			<cfelse>
				<cfif isdefined("attributes.vision_image_display") and attributes.vision_image_display eq 1>
					<td width="100">
						<cfif get_image.recordcount>
							<cfif len(attributes.vision_image_width)>
								<cfset my_image_width = attributes.vision_image_width>
							</cfif>
							<cfif len(attributes.vision_image_height)>
								<cfset my_image_height = attributes.vision_image_height>
							</cfif>
							<a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#">
								<cf_get_server_file output_file="product/#get_image.path#" title="#get_image.detail#" alt="#get_image.detail#" output_server="#get_image.path_server_id#" output_type="0" image_width="#my_image_width#" image_height="#my_image_height#" image_link="0">
							</a>
						</cfif>
					</td>
				</cfif>
				<td>
					<cfif isdefined('attributes.is_vision_product_name') and attributes.is_vision_product_name eq 1>
						<a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi">
							<cfif attributes.is_vision_product_detail2 eq 1>#product_detail2#<cfelse>#product_name# #property#</cfif>
						</a><br />
					</cfif>
					<cfif (attributes.is_vision_product_detail eq 1) and (len(vision_detail))>
						<a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi">#vision_detail#</a>
					</cfif>
				</td>
				<input type="hidden" name="vision_prom_id_#currentrow#_#this_row_id_#" id="vision_prom_id_#currentrow#_#this_row_id_#" value="">
				<input type="hidden" name="vision_prom_discount_#currentrow#_#this_row_id_#" id="vision_prom_discount_#currentrow#_#this_row_id_#" value="">
				<input type="hidden" name="vision_prom_amount_discount_#currentrow#_#this_row_id_#" id="vision_prom_amount_discount_#currentrow#_#this_row_id_#" value="">
				<input type="hidden" name="vision_prom_cost_#currentrow#_#this_row_id_#" id="vision_prom_cost_#currentrow#_#this_row_id_#" value="">
				<input type="hidden" name="vision_prom_free_stock_id_#currentrow#_#this_row_id_#" id="vision_prom_free_stock_id_#currentrow#_#this_row_id_#" value="">				
				<input type="hidden" name="vision_prom_stock_amount_#currentrow#_#this_row_id_#" id="vision_prom_stock_amount_#currentrow#_#this_row_id_#" value="1">
				<input type="hidden" name="vision_prom_free_stock_amount_#currentrow#_#this_row_id_#" id="vision_prom_free_stock_amount_#currentrow#_#this_row_id_#" value="">
				<input type="hidden" name="vision_prom_free_stock_price_#currentrow#_#this_row_id_#" id="vision_prom_free_stock_price_#currentrow#_#this_row_id_#" value="">
				<input type="hidden" name="vision_prom_free_stock_money_#currentrow#_#this_row_id_#" id="vision_prom_free_stock_money_#currentrow#_#this_row_id_#" value="">
			</cfif>
			<td align="center">#product_code_2#</td>
			<cfif isdefined("attributes.is_vision_prices") and attributes.is_vision_prices neq 0>
				<td class="prodFiyat" align="center">
					<cfif isdefined("attributes.is_vision_prices") and attributes.is_vision_prices eq 2>
						#TLFormat(musteri_flt_other_money_value)# #musteri_row_money# + KDV
					<cfelse>
						#TLFormat(musteri_flt_other_money_value_kdv)# #musteri_row_money#
					</cfif>
					<cfset price_form = musteri_flt_other_money_value>
					<input type="hidden" name="vision_price_old_#currentrow#_#this_row_id_#" id="vision_price_old_#currentrow#_#this_row_id_#" value="<cfif get_pro.recordcount>#musteri_flt_other_money_value#</cfif>">
					<input type="hidden" name="vision_price_#currentrow#_#this_row_id_#" id="vision_price_#currentrow#_#this_row_id_#" value="#price_form#">
					<input type="hidden" name="vision_price_kdv_#currentrow#_#this_row_id_#" id="vision_price_kdv_#currentrow#_#this_row_id_#" value="#price_form*(1+(tax/100))#">
					<input type="hidden" name="vision_price_money_#currentrow#_#this_row_id_#" id="vision_price_money_#currentrow#_#this_row_id_#" value="#musteri_row_money#">
				</td>
			</cfif>
			<cfif (is_zero_stock eq 1 or is_zero_stock neq 1) and ((attributes.is_sale eq 1) or ((attributes.is_sale eq 2) and isdefined('session_base.userid')))>
				<td align="center"><input type="text" name="miktar_#currentrow#_#this_row_id_#" id="miktar_#currentrow#_#this_row_id_#" value="1" style="width:40px;" class="moneybox" maxlength="2" onkeyup="return(FormatCurrency(isNumber(this,event),0));"></td>
				<td style="text-align:right;">
					<a href="##" onclick="vision_urun_gonder_#this_row_id_#('#currentrow#')" class="prod_sepet"></a> 
				</td>
			</cfif>
		</tr>
	</cfoutput>
</table>

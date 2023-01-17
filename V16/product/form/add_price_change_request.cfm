<cfinclude template="../query/get_product.cfm">
<cfinclude template="../query/get_price_cat.cfm">
<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_product_unit.cfm">
<cfif len(GET_PRODUCT.PROD_COMPETITIVE)>
  <cfset attributes.COMPETITIVE_ID=GET_PRODUCT.PROD_COMPETITIVE>
  <cfinclude template="../query/get_competitive_name.cfm">
  <cfset COMPETITIVE_NAME=GET_COMPETITIVE_NAME.COMPETITIVE>
<cfelse>
  <cfset COMPETITIVE_NAME="">
</cfif>
<!---<cf_catalystHeader>--->
<cf_box title="#getLang('','Satış Fiyatları',37117)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform action="#request.self#?fuseaction=product.emptypopup_add_price_change" method="post" name="price">
		<cfoutput>
			<input type="Hidden" name="pid" id="pid" value="#attributes.pid#">
			<input type="Hidden" name="alis_kdv" id="alis_kdv" value="#GET_PRODUCT.TAX_PURCHASE#">
			<input type="Hidden" name="satis_kdv" id="satis_kdv" value="#GET_PRODUCT.TAX#">
		</cfoutput>
		<cf_box_elements>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-product_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
					<div class="col col-8 col-xs-12"> 
						<cfoutput>#get_product.product_name# - #COMPETITIVE_NAME#</cfoutput>
					</div>
				</div>
				<div class="form-group" id="item-unit_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37307.Ürün Birimi'> *</label>
					<div class="col col-8 col-xs-12"> 
						<select name="unit_id" id="unit_id">
							<cfoutput query="get_product_unit">
								<option value="#PRODUCT_UNIT_ID#">#add_unit# 
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-date">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58053.Baslangic Tarihi'> *</label>
					<div class="col col-4 col-xs-12"> 
						<div class="input-group">
							<cfinput required="Yes" validate="#validate_style#" message="#getLang('','Baslangic Tarihi Girmelisiniz',57738)#" type="text" name="startdate">
							<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
						</div>
					</div>
					<div class="col col-2 col-xs-12"> 
						<cf_wrkTimeFormat name="start_clock" value="0">
					</div>
					<div class="col col-2 col-xs-12"> 
						<select name="start_min" id="start_min">
							<cfloop from="0" to="55" index="i" step="5">
								<cfif i lt 10>
									<cfoutput><option value="#i#">0#i#</option></cfoutput>
								<cfelse>
									<cfoutput><option value="#i#">#i#</option></cfoutput>
								</cfif>
							</cfloop>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-reason">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37311.Gerekçe'></label>
					<div class="col col-8 col-xs-12"> 
						<textarea name="REASON" id="REASON" style="width:310px;height=70;"></textarea>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_grid_list id="fiyat_listeleri">
			<thead>
				<tr>
					<th colspan="2"><cf_get_lang dictionary_id='37028.Fiyat Listeleri'></th>
					<th><cf_get_lang dictionary_id='37348.Mevcut Fiyat'></th>
					<th width="45"><cf_get_lang dictionary_id='58716.KDV li'></th>
					<th><cf_get_lang dictionary_id='37306.Yeni Fiyat'></th>
					<th><cf_get_lang dictionary_id='57489.Para Br'></th>				
				</tr>
			</thead>
			<tbody>
				<cfset pricecatid = -1>
				<cfinclude template="../query/get_product_prices.cfm">
				<tr>
					<td><input name="price_cat_list" id="price_cat_list" <cfif isDefined("attributes.price_catid") and attributes.price_catid eq -1>checked</cfif> type="checkbox" value="-1"></td>
					<td><cf_get_lang dictionary_id='58722.Standart Alış'></td>
					<td><cfoutput query="get_product_prices">#TLFormat(PRICE)# #MONEY# - (#ADD_UNIT#)<cfif currentrow neq get_product_prices.RecordCount>,</cfif></cfoutput></td>
					<td class="text-center"><input type="checkbox" name="is_kdv" id="is_kdv" value="-1" checked></td>
					<td>
						<div class="form-group">
							<cfinput type="text" name="price_minus_1" message="#getLang('','Yeni Fiyat girmelisiniz',37347)#" validate="float" range="0.0001," onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" class="moneybox">
						</div>
					</td>
					<td>
						<div class="form-group">
							<select name="money_minus_1" id="money_minus_1">
								<cfoutput query="get_money">
									<option value="#get_money.money#" <cfif SESSION.EP.MONEY eq get_money.money>Selected</cfif>> #get_money.money# 
								</cfoutput>
							</select>
						</div>
					</td>                  
				</tr>
				<cfset pricecatid = -2>
				<cfinclude template="../query/get_product_prices.cfm">
				<tr>
					<td><input name="price_cat_list" id="price_cat_list" <cfif isDefined("attributes.price_catid") and attributes.price_catid eq -2>checked</cfif> type="checkbox" value="-2"></td>
					<td><cf_get_lang dictionary_id='58721.Standart Satış'></td>
					<td><cfoutput query="get_product_prices">#TLFormat(PRICE)# #MONEY# - (#ADD_UNIT#)<cfif currentrow neq get_product_prices.RecordCount>,</cfif></cfoutput></td>
					<td class="text-center"><input type="checkbox" name="is_kdv" id="is_kdv" value="-2" checked></td>
					<td>
						<div class="form-group">
							<cfinput type="text" name="price_minus_2" message="#getLang('','Yeni Fiyat girmelisiniz',37347)#" validate="float" range="0.0001," onkeyup="if (FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#)) {return true;} else {updOtherLists(); return false;}" class="moneybox"><!--- return(FormatCurrency(this,event)); --->
						</div>
					</td>
					<td>
						<div class="form-group">
							<select name="money_minus_2" id="money_minus_2">
								<cfoutput query="get_money">
									<option value="#get_money.money#" <cfif SESSION.EP.MONEY eq get_money.money>Selected</cfif>> #get_money.money# 
								</cfoutput>
							</select>
						</div>
					</td>
				</tr>
				<cfoutput query="get_price_cat">
					<cfset pricecatid = price_catid>
					<cfinclude template="../query/get_product_prices.cfm">
					<tr>
						<td><input name="price_cat_list" id="price_cat_list" <cfif isDefined("attributes.price_catid") and attributes.price_catid eq price_catid>checked</cfif> type="checkbox" value="#price_catid#"></td>
						<td>#price_cat# </td>
						<td><cfloop query="get_product_prices">#TLFormat(PRICE)# #MONEY# - (#ADD_UNIT#)<cfif currentrow neq get_product_prices.RecordCount>,&nbsp;</cfif></cfloop></td>
						<td class="text-center"><input type="checkbox" name="is_kdv" id="is_kdv" value="#price_catid#" checked></td>
						<td>
							<div class="form-group">
								<cfinput type="text" name="price_#price_catid#" message="#getLang('','Yeni Fiyat girmelisiniz',37347)#" validate="float" range="0.0001," onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" class="moneybox">
							</div>
						</td>
						<td>
							<div class="form-group">
								<select name="money_#price_catid#" id="money_#price_catid#">
									<cfloop query="get_money">
										<option value="#get_money.money#" <cfif SESSION.EP.MONEY eq get_money.money>Selected</cfif>> #get_money.money# 
									</cfloop>
								</select>
							</div>
						</td>                   	
					</tr>				 
				</cfoutput>
				<tr>
					<td> 
						<input type="checkbox" name="herkes" id="herkes" value="1" onClick="check_all(this.checked);">
						
					</td>  
					<td><cf_get_lang dictionary_id='37305.Tüm Listeler'></td>
					<td colspan="4"></td>
				</tr>
			</tbody>
		</cf_grid_list>
		<cf_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0' add_function='unformat_fields()'>
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
	function check_all(deger)
	{
		<cfif get_price_cat.recordcount gt 1>
			for(i=0; i<price.price_cat_list.length; i++)
				price.price_cat_list[i].checked = deger;
		<cfelseif get_price_cat.recordcount eq 1>
			price.price_cat_list.checked = deger;
		</cfif>
	}
		function unformat_fields()
		{
			if
			(
				document.price.price_cat_list[0].checked == false 
				&&
				document.price.price_cat_list[1].checked == false
				<cfoutput query="get_price_cat">
				&&
				document.price.price_cat_list[#currentrow+1#].checked == false
				</cfoutput>
			)
			{
				window.alert("<cf_get_lang dictionary_id='37346.En az bir liste seçmelisiniz'> !");
				return false;		
			}
			
			if(document.price.price_cat_list[0].checked == true)
			{
				if(document.price.price_minus_1.value == 0 || document.price.price_minus_1.value == '')
				{
					window.alert("<cf_get_lang dictionary_id='37347.Seçili listeler için yeni fiyat girmelisiniz'> !");
					return false;
				}
			}
			price.price_minus_1.value = filterNum(price.price_minus_1.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			if(document.price.price_cat_list[1].checked == true)
			{
				if(document.price.price_minus_2.value == 0 || document.price.price_minus_2.value == '')
				{
					window.alert("<cf_get_lang dictionary_id='37347.Seçili listeler için yeni fiyat girmelisiniz'> !");
					return false;
				}
			}
			price.price_minus_2.value = filterNum(price.price_minus_2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			<cfoutput query="get_price_cat">
				if(document.price.price_cat_list[#currentrow+1#].checked == true)
				{
					if(document.price.price_#price_catid#.value == 0 || document.price.price_#price_catid#.value == '')
					{
						window.alert('<cf_get_lang dictionary_id="37347.Seçili listeler için yeni fiyat girmelisiniz"> !');
						return false;
					}
				}
				price.price_#price_catid#.value = filterNum(price.price_#price_catid#.value,#session.ep.our_company_info.purchase_price_round_num#);
			</cfoutput>
			return true;
		}	
	
		function updOtherLists()
		{	
			<cfoutput query="get_price_cat">
				price.price_#price_catid#.value = price.price_minus_2.value;
			</cfoutput>
		}
</script>

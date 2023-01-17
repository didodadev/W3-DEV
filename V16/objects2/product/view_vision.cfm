<cfparam name="attributes.price_catid" default="-2">
<cfparam name="attributes.price_catid_2" default="-2">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.get_company_id" default="">
<cfparam name="attributes.get_company" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.is_promotion" default="0">
<cfparam name="attributes.catalog_id" default="">
<cfinclude template="../query/get_price_cats_moneys.cfm">
<cfquery name="GET_HAVALE" datasource="#DSN#" maxrows="1">
	SELECT PAYMETHOD_ID,PAYMETHOD,DUE_DAY,FIRST_INTEREST_RATE FROM SETUP_PAYMETHOD WHERE IN_ADVANCE = 100 AND DUE_DAY = 0 AND PAYMENT_VEHICLE = 3
</cfquery>
<cfquery name="GET_VISION_PRODUCT" datasource="#DSN3#" maxrows="#attributes.dongu#">
	SELECT 
		STOCKS.STOCK_ID,
		STOCKS.PRODUCT_ID,
		STOCKS.STOCK_CODE,
		<cfif isdefined("attributes.sellable_stock_control") and attributes.sellable_stock_control eq 1>GS.PRODUCT_STOCK,</cfif>
		PRODUCT.PRODUCT_NAME,
		STOCKS.PROPERTY,
		STOCKS.BARCOD,
		PRODUCT.IS_ZERO_STOCK,
		PRODUCT.TAX,
		PRODUCT.BRAND_ID,
		PRODUCT.PRODUCT_CODE,
		PRODUCT.PRODUCT_DETAIL,
		PRODUCT.PRODUCT_DETAIL2,
		PRODUCT.USER_FRIENDLY_URL,
		PRODUCT.PRODUCT_CATID,
		PRODUCT.RECORD_DATE,
		PRODUCT.MANUFACT_CODE,
		PRODUCT.PRODUCT_CODE_2,
		STOCKS.PRODUCT_UNIT_ID,
		PRICE_STANDART.PRICE PRICE,
		PRICE_STANDART.MONEY MONEY,
		PRICE_STANDART.IS_KDV IS_KDV,
		PRICE_STANDART.PRICE_KDV PRICE_KDV,
		PV.DETAIL VISION_DETAIL
	FROM 
		PRODUCT,
		<cfif isdefined("attributes.is_vision_category") and len(attributes.is_vision_category)>
			PRODUCT_CAT,
		</cfif>
		STOCKS,
		<cfif isdefined("attributes.last_user_price_list") and isnumeric(attributes.last_user_price_list)>
			PRICE AS PRICE_STANDART,
		<cfelse>
			PRICE_STANDART,
		</cfif>
		<cfif isdefined("attributes.sellable_stock_control") and attributes.sellable_stock_control eq 1>
			#dsn2_alias#.GET_STOCK_LAST GS,
		</cfif> 
		PRODUCT_UNIT,
		PRODUCT_VISION PV		
	WHERE
		PV.PRODUCT_ID = STOCKS.PRODUCT_ID AND
		PV.STOCK_ID = STOCKS.STOCK_ID AND
		PV.IS_ACTIVE = 1 AND
		<cfif isdefined("session.pp.userid")>
			PV.IS_PARTNER = 1 AND
		<cfelse>
			PV.IS_PUBLIC = 1 AND
		</cfif>
		PV.STARTDATE <= #now()# AND
		PV.FINISHDATE >= #now()# AND
		PRICE > 0 AND
		PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
		<cfif isdefined("attributes.is_vision_category") and len(attributes.is_vision_category)>
			PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND
		</cfif>
		PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
		STOCKS.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
		<cfif isdefined("attributes.sellable_stock_control") and attributes.sellable_stock_control eq 1>
            GS.STOCK_ID = STOCKS.STOCK_ID AND
        </cfif> 
      	PRODUCT_UNIT.IS_MAIN = 1 AND
        <cfif isdefined("attributes.is_vision_category") and len(attributes.is_vision_category)>
            PRODUCT_CAT.PRODUCT_CATID IN (#attributes.is_vision_category#) AND 
        </cfif>
        <cfif isdefined("attributes.is_vision_brand") and len(attributes.is_vision_brand)>
            PRODUCT.BRAND_ID IN (#attributes.is_vision_brand#) AND 
        </cfif>
        <cfif len(attributes.is_property_vision)>
            (
                <cfloop from="1" to="#listlen(attributes.is_property_vision)#" index="vcat">
                    ','+PV.VISION_TYPE+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#listgetat(attributes.is_property_vision,vcat)#,%">    
                    <cfif vcat neq listlen(attributes.is_property_vision)>OR</cfif>
                </cfloop>
             ) AND
        </cfif>
        <cfif isdefined("session.pp")>
            PRODUCT.IS_EXTRANET = 1 AND
        <cfelse>
            PRODUCT.IS_INTERNET = 1 AND
        </cfif>
        <cfif isdefined("attributes.last_user_price_list") and isnumeric(attributes.last_user_price_list)>
            PRICE_STANDART.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.last_user_price_list#"> AND
            PRICE_STANDART.PRICE > 0 AND
            PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
            ISNULL(PRICE_STANDART.STOCK_ID,0) = 0 AND
            ISNULL(PRICE_STANDART.SPECT_VAR_ID,0) = 0 AND
            PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT AND
        <cfelse>
            PRICE_STANDART.PRICE > 0 AND
            PRICE_STANDART.PRICESTANDART_STATUS = 1	AND
            PRICE_STANDART.PURCHASESALES = 1 AND
            PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
            PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND
        </cfif>
     	PRODUCT.PRODUCT_STATUS = 1
        <cfif isdefined("attributes.sellable_stock_control") and attributes.sellable_stock_control eq 1> 
            AND ((GS.SALEABLE_STOCK <= 0 AND PRODUCT.IS_ZERO_STOCK = 1) OR GS.SALEABLE_STOCK > 0)
        </cfif>
        <cfif isdefined('attributes.product_catid') and len(attributes.product_catid)>
            AND PRODUCT.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
        </cfif>
</cfquery>
<cfif get_vision_product.recordcount>
	<cfset stock_list = valuelist(get_vision_product.stock_id,',')>
	<cfif len(stock_list)>
		<cfquery name="GET_PROM_ALL" datasource="#DSN3#">
			SELECT
				PROMOTIONS.DISCOUNT,
				PROMOTIONS.AMOUNT_DISCOUNT,
				PROMOTIONS.TOTAL_PROMOTION_COST,
				PROMOTIONS.PROM_HEAD,
				PROMOTIONS.FREE_STOCK_ID,
				PROMOTIONS.PROM_ID,
				PROMOTIONS.LIMIT_VALUE,
				PROMOTIONS.FREE_STOCK_AMOUNT,
				PROMOTIONS.COMPANY_ID,
				PROMOTIONS.FREE_STOCK_PRICE,
				PROMOTIONS.AMOUNT_1_MONEY,
				PROMOTIONS.AMOUNT_DISCOUNT_MONEY_1,
				PROMOTIONS.PRICE_CATID,
				PROMOTIONS.ICON_ID,			
				STOCKS.STOCK_ID
				<cfif isdefined("attributes.sellable_stock_control") and attributes.sellable_stock_control eq 1> ,GS.PRODUCT_STOCK </cfif> 
			FROM
				STOCKS,
				PROMOTIONS 
				<cfif isdefined("attributes.sellable_stock_control") and attributes.sellable_stock_control eq 1>
				,#dsn2_alias#.GET_STOCK GS
				</cfif>
			WHERE
				PROMOTIONS.PROM_STATUS = 1 AND 	
				PROMOTIONS.PROM_TYPE = 1 AND 	<!--- Satira Uygulanir --->
				PROMOTIONS.LIMIT_TYPE = 1 AND 	<!--- Birim  --->
				<cfif isdefined("attributes.sellable_stock_control") and attributes.sellable_stock_control eq 1> GS.STOCK_ID = STOCKS.STOCK_ID AND </cfif>
				STOCKS.STOCK_ID IN (#stock_list#) AND
				(
					STOCKS.STOCK_ID = PROMOTIONS.STOCK_ID OR
					STOCKS.BRAND_ID = PROMOTIONS.BRAND_ID OR
					STOCKS.PRODUCT_CATID = PROMOTIONS.PRODUCT_CATID
				) AND 
				PROMOTIONS.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
				PROMOTIONS.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		</cfquery>
	</cfif>
	<cfinclude template="../query/get_price_all.cfm">
	<cfset brand_list = valuelist(get_vision_product.brand_id,',')>
	<cfset brand_list=listsort(brand_list,"numeric","ASC",",")>
	<cfif listlen(brand_list)>
		<cfquery name="GET_BRANDS" datasource="#DSN3#">
			SELECT BRAND_NAME,BRAND_ID FROM PRODUCT_BRANDS WHERE BRAND_ID IN (#brand_list#)
		</cfquery>
		<cfset main_brand_list = listsort(listdeleteduplicates(valuelist(get_brands.brand_id,',')),'numeric','ASC',',')>
	</cfif>
	<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
    <cfif isdefined("attributes.vision_position") and attributes.vision_position eq 0> <!--- yanyana gosteriyor --->
		<cfoutput query="get_vision_product" startrow="1" maxrows="#attributes.dongu#">
            <cfquery name="GET_IMAGE" datasource="#DSN3#" maxrows="1">
                SELECT PATH,PATH_SERVER_ID,PRODUCT_ID,DETAIL FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0 AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> ORDER BY PRODUCT_IMAGEID DESC
            </cfquery>
            <cfquery name="GET_P" dbtype="query">
                SELECT * FROM GET_PRICE_ALL WHERE UNIT = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_unit_id[currentrow]#"> AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
            </cfquery>
            <cfquery name="GET_PRO" dbtype="query" maxrows="1">
                SELECT * FROM GET_PROM_ALL WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
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
			<cfif isdefined('attributes.view_vision_discount_rate') and len(attributes.view_vision_discount_rate)>
				<cfset pro_price = price - (price * attributes.view_vision_discount_rate /100)>
				<cfset pro_price_kdv = price_kdv - (price_kdv * attributes.view_vision_discount_rate /100)>
			<cfelse>
				<cfset pro_price = price>
				<cfset pro_price_kdv = price_kdv>
			</cfif>
			<cfif attributes.price_catid neq -2>
				<cfscript>
					if(get_p.recordcount and len(get_p.price))
					{
						attributes.catalog_id=get_p.catalog_id;
						musteri_pro_price = get_p.price; 
						musteri_pro_price_kdv = get_p.price_kdv; 
						musteri_row_money=get_p.money; 
					}
					else
					{
						attributes.catalog_id='';
						musteri_pro_price = pro_price;
						musteri_pro_price_kdv = pro_price_kdv;
						musteri_row_money=attributes.money;
					} //musteriye ozel fiyat yoksa son kullanici gecerli
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
					attributes.catalog_id='';
					musteri_flt_other_money_value = pro_price;
					musteri_flt_other_money_value_kdv = pro_price_kdv;
					musteri_str_other_money = row_money;
					musteri_row_money = row_money;
					{
						musteri_flag_prc_other = 1;
						musteri_pro_price = pro_price*(row_money_rate2/row_money_rate1);
						musteri_pro_price_kdv = pro_price_kdv*(row_money_rate2/row_money_rate1);
						musteri_str_other_money = default_money.money;
					}
				</cfscript>
			</cfif>
			<cfif attributes.mode gt 1>
                <input type="hidden" name="vision_sid_#currentrow#_#this_row_id_#" id="vision_sid_#currentrow#_#this_row_id_#" value="#stock_id#">
                <input type="hidden" name="vision_catalog_id_#currentrow#_#this_row_id_#" id="vision_catalog_id_#currentrow#_#this_row_id_#" value="#attributes.catalog_id#">
                <input type="hidden" name="vision_pid_#currentrow#_#this_row_id_#" id="vision_pid_#currentrow#_#this_row_id_#" value="#product_id#">
				<cfif ((currentrow mod attributes.mode eq 1)) or (currentrow eq 1)>
                    <tr style="height:50px;">  
                        <td align="center" class="vision_td" style="vertical-align:top; width:#100/attributes.mode#%;">
                            <cfinclude template="view_vision_product.cfm">
                        </td>
                <cfelseif (currentrow mod attributes.mode eq 0)>
                        <td align="center" class="vision_td" style="vertical-align:top; width:#100/attributes.mode#%;">
                            <cfinclude template="view_vision_product.cfm">
                        </td>
                    </tr>
                    <tr>
                    	<td colspan="#attributes.mode#" align="center">
                        	<hr style="height:0.3px; color:cccccc">
                        </td>
                    </tr>
                <cfelseif currentrow eq attributes.dongu>
                    <td align="center" class="vision_td" style="vertical-align:top; width:#100/attributes.mode#%;">
                        <cfinclude template="view_vision_product.cfm">
                    </td>
                <cfelse>
                    <td align="center" class="vision_td" style="vertical-align:top; width:#100/attributes.mode#%;">
                        <cfinclude template="view_vision_product.cfm">
                    </td>
                </cfif>
               	<cfif currentrow eq attributes.dongu>
                    <cfif currentrow mod attributes.mode>
                        <cfloop from="1" to="#attributes.mode - (currentrow mod attributes.mode)#" index="ccc">
                                <td align="center">&nbsp;</td>
                            </tr>
                        </cfloop>
                    </cfif>                    
                </cfif>
            <cfelse>
                <tr style="height:50px;">  
                    <td align="center" class="vision_td" style="vertical-align:top;">
                        <cfinclude template="view_vision_product.cfm">
                    </td>
                </tr>
            </cfif>
         </cfoutput>
	<cfelse><!--- listeye geciyor --->
		<tr>
			<td><cfinclude template="view_vision_product_list.cfm"></td>
		</tr>
	</cfif>
	</table>
</cfif>
<cfif (attributes.is_sale eq 1) or (attributes.is_sale eq 2 and isdefined('session_base.userid'))>
	<form action="" method="post" name="vision_satir_gonder_<cfoutput>#this_row_id_#</cfoutput>">
		<input type="hidden" name="price_catid_2" id="price_catid_2" value="">
		<input type="hidden" name="istenen_miktar" id="istenen_miktar" value="1">
		<input type="hidden" name="sid" id="sid" value="">
		<input type="hidden" name="catalog_id" id="catalog_id" value="">
		<input type="hidden" name="pid" id="pid" value="">
		<input type="hidden" name="product_id" id="product_id" value="">
		<input type="hidden" name="price" id="price" value="">
		<input type="hidden" name="price_standard" id="price_standard" value="">
		<input type="hidden" name="price_standard_kdv" id="price_standard_kdv" value="">
		<input type="hidden" name="price_standard_money" id="price_standard_money" value="">
		<input type="hidden" name="price_old" id="price_old" value="">
		<input type="hidden" name="price_kdv" id="price_kdv" value="">
		<input type="hidden" name="price_money" id="price_money" value="">
		<input type="hidden" name="prom_id" id="prom_id" value="">
		<input type="hidden" name="prom_discount" id="prom_discount" value="">
		<input type="hidden" name="prom_amount_discount" id="prom_amount_discount" value="">
		<input type="hidden" name="prom_cost" id="prom_cost" value="">
		<input type="hidden" name="prom_free_stock_id" id="prom_free_stock_id" value="">
		<input type="hidden" name="prom_stock_amount" id="prom_stock_amount" value="">
		<input type="hidden" name="prom_free_stock_amount" id="prom_free_stock_amount" value="">
		<input type="hidden" name="prom_free_stock_price" id="prom_free_stock_price" value="">
		<input type="hidden" name="prom_free_stock_money" id="prom_free_stock_money" value="">	
	</form>
	<cfoutput>
		<script type="text/javascript">
            function vision_urun_gonder2_#this_row_id_#(satir_no)
            {
                vision_satir_gonder_#this_row_id_#.price_catid_2.value = '#attributes.price_catid_2#';
                vision_satir_gonder_#this_row_id_#.sid.value = eval("document.getElementById('vision_sid_"+satir_no+"_#this_row_id_#')").value;
                vision_satir_gonder_#this_row_id_#.catalog_id.value = eval("document.getElementById('vision_catalog_id_"+satir_no+"_#this_row_id_#')").value;
                vision_satir_gonder_#this_row_id_#.pid.value = eval("document.getElementById('vision_pid_"+satir_no+"_#this_row_id_#')").value;
                vision_satir_gonder_#this_row_id_#.product_id.value = eval("document.getElementById('vision_pid_"+satir_no+"_#this_row_id_#')").value;
                vision_satir_gonder_#this_row_id_#.price.value = eval("document.getElementById('vision_price_"+satir_no+"_#this_row_id_#')").value;
                vision_satir_gonder_#this_row_id_#.price_standard.value = eval("document.getElementById('vision_price_"+satir_no+"_#this_row_id_#')").value;
                vision_satir_gonder_#this_row_id_#.price_standard_kdv.value = eval("document.getElementById('vision_price_kdv_"+satir_no+"_#this_row_id_#')").value;
                vision_satir_gonder_#this_row_id_#.price_standard_money.value = eval("document.getElementById('vision_price_money_"+satir_no+"_#this_row_id_#')").value;
                vision_satir_gonder_#this_row_id_#.price_kdv.value = eval("document.getElementById('vision_price_kdv_"+satir_no+"_#this_row_id_#')").value;
                vision_satir_gonder_#this_row_id_#.price_money.value = eval("document.getElementById('vision_price_money_"+satir_no+"_#this_row_id_#')").value;
                vision_satir_gonder_#this_row_id_#.prom_id.value = eval("document.getElementById('vision_prom_id_"+satir_no+"_#this_row_id_#')").value;
                vision_satir_gonder_#this_row_id_#.prom_discount.value = eval("document.getElementById('vision_prom_discount_"+satir_no+"_#this_row_id_#')").value;
                vision_satir_gonder_#this_row_id_#.prom_amount_discount.value = eval("document.getElementById('vision_prom_amount_discount_"+satir_no+"_#this_row_id_#')").value;
                vision_satir_gonder_#this_row_id_#.prom_cost.value = eval("document.getElementById('vision_prom_cost_"+satir_no+"_#this_row_id_#')").value;
                vision_satir_gonder_#this_row_id_#.prom_free_stock_id.value = eval("document.getElementById('vision_prom_free_stock_id_"+satir_no+"_#this_row_id_#')").value;
                vision_satir_gonder_#this_row_id_#.prom_stock_amount.value = eval("document.getElementById('vision_prom_stock_amount_"+satir_no+"_#this_row_id_#')").value;
                vision_satir_gonder_#this_row_id_#.prom_free_stock_amount.value = eval("document.getElementById('vision_prom_free_stock_amount_"+satir_no+"_#this_row_id_#')").value;
                vision_satir_gonder_#this_row_id_#.prom_free_stock_price.value = eval("document.getElementById('vision_prom_free_stock_price_"+satir_no+"_#this_row_id_#')").value;
                vision_satir_gonder_#this_row_id_#.prom_free_stock_money.value = eval("document.getElementById('vision_prom_free_stock_money_"+satir_no+"_#this_row_id_#')").value;
                if ((vision_satir_gonder_#this_row_id_#.prom_discount.value.length) || (vision_satir_gonder_#this_row_id_#.prom_amount_discount.value.length))
                    vision_satir_gonder_#this_row_id_#.price_old.value = eval("document.getElementById('vision_price_old_"+satir_no+"_#this_row_id_#')").value;
                vision_satir_gonder_#this_row_id_#.action = '#request.self#?fuseaction=objects2.detail_product';
                vision_satir_gonder_#this_row_id_#.submit();
            }
        </script>
		<iframe name="form_basket_ww_vision_<cfoutput>#this_row_id_#</cfoutput>" id="form_basket_ww_vision_<cfoutput>#this_row_id_#</cfoutput>" src="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_iframe_form_basket" width="0" height="0" scrolling="no" frameborder="0"></iframe>
		<script type="text/javascript">
			function vision_urun_gonder_#this_row_id_#(satir_no)
			{ 	
				if(findObj("istenen_miktar",window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder))
					{
					//
					}
				else
					{
						alert('Sayfa Yükleniyor! Lütfen Bekleyiniz!!');
						return false;
					}
	
				_miktar = filterNum(eval("document.getElementById('miktar_"+satir_no+"_#this_row_id_#')").value);
				if(_miktar.length==0 || _miktar =='')
				{
					alert("<cf_get_lang no ='1147.Miktar Giriniz'>!");
					return false;
				}
				
				window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.istenen_miktar.value = _miktar;
				window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.price_catid_2.value = '#attributes.price_catid_2#';
				window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.sid.value = eval("document.getElementById('vision_sid_"+satir_no+"_#this_row_id_#')").value;
				if ((window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.catalog_id.value.length))
					window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.catalog_id.value = eval("document.getElementById('vision_catalog_id_"+satir_no+"_#this_row_id_#')").value;
				else
					window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.catalog_id.value = '';
				
				window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.price.value = eval("document.getElementById('vision_price_"+satir_no+"_#this_row_id_#')").value;
				window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.price_kdv.value = eval("document.getElementById('vision_price_kdv_"+satir_no+"_#this_row_id_#')").value;
				window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.price_money.value = eval("document.getElementById('vision_price_money_"+satir_no+"_#this_row_id_#')").value;
				window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.price_standard.value = eval("document.getElementById('vision_price_"+satir_no+"_#this_row_id_#')").value;
				window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.price_standard_kdv.value = eval("document.getElementById('vision_price_kdv_"+satir_no+"_#this_row_id_#')").value;
				window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.price_standard_money.value = eval("document.getElementById('vision_price_money_"+satir_no+"_#this_row_id_#')").value;
				window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.prom_id.value = eval("document.getElementById('vision_prom_id_"+satir_no+"_#this_row_id_#')").value;
				window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.prom_discount.value = eval("document.getElementById('vision_prom_discount_"+satir_no+"_#this_row_id_#')").value;
				window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.prom_amount_discount.value = eval("document.getElementById('vision_prom_amount_discount_"+satir_no+"_#this_row_id_#')").value;
				window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.prom_cost.value = eval("document.getElementById('vision_prom_cost_"+satir_no+"_#this_row_id_#')").value;
				window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.prom_free_stock_id.value = eval("document.getElementById('vision_prom_free_stock_id_"+satir_no+"_#this_row_id_#')").value;
				window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.prom_stock_amount.value = eval("document.getElementById('vision_prom_stock_amount_"+satir_no+"_#this_row_id_#')").value;
				window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.prom_free_stock_amount.value = eval("document.getElementById('vision_prom_free_stock_amount_"+satir_no+"_#this_row_id_#')").value;
				window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.prom_free_stock_price.value = eval("document.getElementById('vision_prom_free_stock_price_"+satir_no+"_#this_row_id_#')").value;
				window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.prom_free_stock_money.value = eval("document.getElementById('vision_prom_free_stock_money_"+satir_no+"_#this_row_id_#')").value;
				
				if (document.getElementById('basket_expres_consumer_id') != undefined)
					window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.consumer_id.value = document.getElementById('basket_expres_consumer_id').value;	
	
				if ((window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.prom_discount.value.length) || (window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.prom_amount_discount.value.length))
					window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.price_old.value = eval("document.getElementById('vision_price_old_"+satir_no+"_#this_row_id_#')").value;
				else
					window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.price_old.value = '';
				
				window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.action = '#request.self#?fuseaction=objects2.emptypopup_add_basketww_row';
				window.frames['form_basket_ww_vision_#this_row_id_#'].document.satir_gonder.submit();
		
			}
			function PROCTest2()
			{    
				_working_.style.left=(document.body.clientWidth-400)/2;
				_working_.style.top=(document.body.clientHeight-120)/2;
				goster(_working_);
				setTimeout("gizle(_working_)",2000);
			}
		</script>
	</cfoutput>
</cfif>

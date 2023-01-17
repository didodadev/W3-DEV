<!---20060418 ürün açıklamaları geliyor ürün fiyat farkından buluyor
*** ağaç veya özelleştirilen ürünlerde değişiklik yoksa spec kaydetmeden ana ürünü baskete atıyor--->
<cfscript>
	if (listfindnocase(partner_url,'#cgi.http_host#',';'))
	{
		int_comp_id = session.pp.our_company_id;
		int_period_id = session.pp.period_id;
		attributes.company_id = session.pp.company_id;
	}
	else if (listfindnocase(server_url,'#cgi.http_host#',';') )
	{	
		int_comp_id = session.ww.our_company_id;
		int_period_id = session.ww.period_id;
		if(isdefined('session.ww.company_id'))
			attributes.company_id = session.ww.company_id;
		else if(isdefined('session.ww.userid'))
			attributes.consumer_id = session.ww.userid;
	}
</cfscript>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT
		COMPANY_ID,
		PERIOD_ID,
		MONEY,
		RATE1,
		<cfif isDefined("session.pp")>
            RATEPP2 RATE2
        <cfelse>
            RATEWW2 RATE2
        </cfif>
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#">
</cfquery>

<!--- üyenin fiyat listesini bulmak için--->
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfquery name="GET_PRICE_CAT_CREDIT" datasource="#DSN#">
		SELECT 
			PRICE_CAT 
		FROM 
			COMPANY_CREDIT 
		WHERE 
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND 
			OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
	</cfquery>
	<cfif get_price_cat_credit.recordcount and len(get_price_cat_credit.price_cat)>
		<cfset attributes.price_catid = get_price_cat_credit.price_cat>
	<cfelse>
		<cfquery name="GET_COMP_CAT" datasource="#DSN#">
			SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfquery>
		<cfquery name="GET_PRICE_CAT_COMP" datasource="#DSN3#">
			SELECT 
				PRICE_CATID
			FROM
				PRICE_CAT
			WHERE
				COMPANY_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.companycat_id#,%">
		</cfquery>
		<cfset attributes.price_catid = get_price_cat_comp.price_catid>
	</cfif>
</cfif>
<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfquery name="GET_COMP_CAT" datasource="#DSN#">
		SELECT CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
	</cfquery>
	<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
		SELECT PRICE_CATID FROM PRICE_CAT WHERE CONSUMER_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.consumer_cat_id#,%">
	</cfquery>
	<cfset attributes.price_catid=get_price_cat.price_catid>
</cfif>
<!--- //üyenin fiyat listesini bulmak için--->
<cfquery name="GET_PRODUCT" datasource="#DSN1#">
	SELECT 
		PRODUCT.IS_PROTOTYPE,
		PRODUCT.PRODUCT_NAME,
		PRODUCT.PRODUCT_ID,
		STOCKS.STOCK_ID,
		STOCKS.PROPERTY
	FROM 
		PRODUCT,
		STOCKS
	WHERE 
		STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#"> AND
		STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID
</cfquery>
<cfquery name="GET_LANGUAGE_INFOS" datasource="#DSN#">
    SELECT
        ITEM,
        UNIQUE_COLUMN_ID
    FROM
        SETUP_LANGUAGE_INFO
    WHERE
        <cfif isdefined('session.pp')>
            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#"> AND
        <cfelse>
            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#"> AND
        </cfif>
        COLUMN_NAME = 'PROPERTY' AND
        TABLE_NAME = 'PRODUCT_PROPERTY'
</cfquery>
<cfquery name="GET_LANGUAGE_INFOS2" datasource="#DSN#">
    SELECT
        ITEM,
        UNIQUE_COLUMN_ID
    FROM
        SETUP_LANGUAGE_INFO
    WHERE
        <cfif isdefined('session.pp')>
            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#"> AND
        <cfelse>
            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#"> AND
        </cfif>
        COLUMN_NAME = 'PROPERTY_DETAIL' AND
        TABLE_NAME = 'PRODUCT_PROPERTY_DETAIL'
</cfquery>
<cfset product_id_list = get_product.product_id>
<cfset tree_product_id_list="">
<cfquery name="GET_PROD_TREE" datasource="#DSN3#">
	SELECT 
		STOCKS.PRODUCT_NAME,
		STOCKS.PRODUCT_ID,
		STOCKS.IS_PRODUCTION,
		STOCKS.STOCK_ID,
		STOCKS.STOCK_CODE,
		STOCKS.PROPERTY,
		PRODUCT_TREE.AMOUNT,
		PRODUCT_TREE.PRODUCT_TREE_ID,
		<!--- PRODUCT_TREE.SPECT_MAIN_NAME, --->
		PRODUCT_UNIT.MAIN_UNIT,
		PRODUCT_TREE.IS_CONFIGURE,
		PRODUCT_TREE.IS_SEVK,
		STOCKS.PRODUCT_DETAIL
	FROM
		STOCKS,
		PRODUCT_TREE,
		PRODUCT_UNIT
	WHERE
		PRODUCT_UNIT.PRODUCT_UNIT_ID = PRODUCT_TREE.UNIT_ID AND
		PRODUCT_TREE.RELATED_ID = STOCKS.STOCK_ID AND
		PRODUCT_TREE.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
</cfquery>
<cfif get_prod_tree.recordcount>
	<cfoutput query="get_prod_tree">
		<cfset product_id_list=ListAppend(product_id_list,get_prod_tree.product_id,',')>
		<cfset tree_product_id_list=ListAppend(tree_product_id_list,get_prod_tree.product_id,',')>
	</cfoutput>
</cfif>

<cfquery name="GET_SPECTS_VARIATION" datasource="#DSN1#">
	SELECT
		PRODUCT_DT_PROPERTIES.PRODUCT_ID,
		PRODUCT_DT_PROPERTIES.TOTAL_MIN,
		PRODUCT_DT_PROPERTIES.TOTAL_MAX,
		PRODUCT_DT_PROPERTIES.AMOUNT,
		PRODUCT_PROPERTY.PROPERTY,
		PRODUCT_PROPERTY.PROPERTY_ID,
		PRODUCT_PROPERTY_DETAIL.PROPERTY_DETAIL,
		PRODUCT_PROPERTY_DETAIL.PROPERTY_DETAIL_ID
	FROM
		PRODUCT_DT_PROPERTIES,
		PRODUCT_PROPERTY,
		PRODUCT_PROPERTY_DETAIL
	WHERE
		PRODUCT_DT_PROPERTIES.VARIATION_ID = PRODUCT_PROPERTY_DETAIL.PROPERTY_DETAIL_ID AND
		PRODUCT_DT_PROPERTIES.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_id#"> AND
		PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_DT_PROPERTIES.PROPERTY_ID AND
		PRODUCT_PROPERTY_DETAIL.PRPT_ID = PRODUCT_PROPERTY.PROPERTY_ID AND
		PRODUCT_DT_PROPERTIES.IS_OPTIONAL = 1
</cfquery>
<cfset varition_product_id_list="">
<cfset varition_property_id_list=0>
<cfset varition_property_detail_id_list=0>
<cfif get_spects_variation.recordcount>
	<cfoutput query="get_spects_variation">
		<cfset product_id_list=ListAppend(product_id_list,get_spects_variation.product_id,',')>
		<cfset varition_product_id_list=ListAppend(varition_product_id_list,get_spects_variation.product_id,',')>
		<cfset varition_property_id_list=ListAppend(varition_property_id_list,get_spects_variation.property_id,',')>
		<cfset varition_property_detail_id_list=ListAppend(varition_property_detail_id_list,get_spects_variation.property_detail_id,',')>
	</cfoutput>
</cfif>

<cfquery name="GET_STOCK_PROPERTY_ALL" datasource="#DSN1#">
	SELECT
		STOCKS.STOCK_ID,
		PRODUCT.PRODUCT_ID,
		PRODUCT.PRODUCT_NAME,
		STOCKS_PROPERTY.TOTAL_MAX,
		STOCKS_PROPERTY.TOTAL_MIN,
		STOCKS_PROPERTY.PROPERTY_ID,
		STOCKS_PROPERTY.PROPERTY_DETAIL_ID,
		PRODUCT.PRODUCT_DETAIL
	FROM
		STOCKS,
		PRODUCT,
		STOCKS_PROPERTY,
		PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES
	WHERE
		PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND 
		STOCKS_PROPERTY.STOCK_ID = STOCKS.STOCK_ID AND
		STOCKS_PROPERTY.PROPERTY_ID IN (#varition_property_id_list#) AND
		STOCKS_PROPERTY.PROPERTY_DETAIL_ID IN (#varition_property_detail_id_list#) AND
		PRODUCT_DT_PROPERTIES.PROPERTY_ID =STOCKS_PROPERTY.PROPERTY_ID AND
		PRODUCT_DT_PROPERTIES.VARIATION_ID = STOCKS_PROPERTY.PROPERTY_DETAIL_ID AND
		PRODUCT.IS_SALES = 1 AND
		PRODUCT.IS_INTERNET = 1 AND
		PRODUCT.PRODUCT_STATUS = 1 AND
		<cfif isdefined("total_max") and len(total_max)>STOCKS_PROPERTY.TOTAL_MAX <= <cfqueryparam cfsqltype="cf_sql_integer" value="#total_max#"> AND</cfif> 
		<cfif isdefined("total_min") and len(total_min)>STOCKS_PROPERTY.TOTAL_MIN >= <cfqueryparam cfsqltype="cf_sql_integer" value="#total_min#"> AND</cfif>
		PRODUCT_DT_PROPERTIES.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
		PRODUCT_DT_PROPERTIES.IS_EXIT=1
</cfquery>
<cfif get_stock_property_all.recordcount>
	<cfoutput query="get_stock_property_all">
		<cfset product_id_list=ListAppend(product_id_list,get_stock_property_all.product_id,',')>
	</cfoutput>
</cfif>

<cfif listlen(tree_product_id_list,',')>
	<cfquery name="GET_ALTERNATE_PRODUCT" datasource="#DSN3#">
		SELECT
			AP.PRODUCT_ID ASIL_PRODUCT,
			AP.ALTERNATIVE_PRODUCT_ID,
			S.PRODUCT_NAME, 
			S.PRODUCT_ID,
			S.STOCK_ID,
			S.PROPERTY,
			S.PRODUCT_DETAIL
		FROM
			STOCKS AS S,
			ALTERNATIVE_PRODUCTS AS AP
		WHERE
			S.PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM ALTERNATIVE_PRODUCTS_EXCEPT WHERE ALTERNATIVE_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_id#">) AND
			(
				(
					S.PRODUCT_ID=AP.PRODUCT_ID AND
					AP.ALTERNATIVE_PRODUCT_ID IN (#tree_product_id_list#)
				)
			OR
				(
					S.PRODUCT_ID = AP.ALTERNATIVE_PRODUCT_ID AND
					AP.PRODUCT_ID IN (#tree_product_id_list#)
				)
			)
	</cfquery>
	<cfoutput query="get_alternate_product">
		<cfset product_id_list=ListAppend(product_id_list,get_alternate_product.product_id,',')>
	</cfoutput>
</cfif>

<cfset product_id_list=ListDeleteDuplicates(product_id_list)>
<!--- tüm sayfadaki ürünler için fiyatları alıyor sonra query of query ile çekecek--->
<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
	<cfquery name="GET_PRICE" datasource="#DSN3#">
		SELECT
			PRICE_STANDART.PRODUCT_ID,
			SM.MONEY,
			PRICE_STANDART.PRICE,
			<cfif isDefined("session.pp")>
                (PRICE_STANDART.PRICE*(SM.RATEPP2/SM.RATE1)) AS PRICE_STDMONEY,
                (PRICE_STANDART.PRICE_KDV*(SM.RATEPP2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
            <cfelse>
                (PRICE_STANDART.PRICE*(SM.RATEWW2/SM.RATE1)) AS PRICE_STDMONEY,
                (PRICE_STANDART.PRICE_KDV*(SM.RATEWW2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
            </cfif>
			SM.RATE2,
			SM.RATE1
		FROM
			PRICE PRICE_STANDART,	
			PRODUCT_UNIT,
			#dsn_alias#.SETUP_MONEY AS SM
		WHERE
			PRICE_STANDART.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
			PRICE_STANDART.STARTDATE< #now()# AND 
			(PRICE_STANDART.FINISHDATE >= #now()# OR PRICE_STANDART.FINISHDATE IS NULL) AND
			PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
			PRICE_STANDART.PRODUCT_ID IN (#product_id_list#) AND 
			ISNULL(PRICE_STANDART.STOCK_ID,0)=0 AND
			ISNULL(PRICE_STANDART.SPECT_VAR_ID,0)=0 AND
			PRODUCT_UNIT.IS_MAIN = 1 AND
			SM.MONEY = PRICE_STANDART.MONEY AND
			SM.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#">
	</cfquery>
</cfif>
<cfquery name="GET_PRICE_STANDART" datasource="#DSN3#">
	SELECT
		PRICE_STANDART.PRODUCT_ID,
		SM.MONEY,
		PRICE_STANDART.PRICE,
		<cfif isDefined("session.pp")>
            (PRICE_STANDART.PRICE*(SM.RATEPP2/SM.RATE1)) AS PRICE_STDMONEY,
            (PRICE_STANDART.PRICE_KDV*(SM.RATEPP2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
        <cfelse>
            (PRICE_STANDART.PRICE*(SM.RATEWW2/SM.RATE1)) AS PRICE_STDMONEY,
            (PRICE_STANDART.PRICE_KDV*(SM.RATEWW2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
        </cfif>
		SM.RATE2,
		SM.RATE1
	FROM
		PRODUCT,
		PRICE_STANDART,
		#dsn_alias#.SETUP_MONEY AS SM
	WHERE
		PRODUCT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
		PURCHASESALES = 1 AND
		PRICESTANDART_STATUS = 1 AND
		SM.MONEY = PRICE_STANDART.MONEY AND
		SM.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#"> AND
		PRODUCT.PRODUCT_ID IN (#product_id_list#)
</cfquery>
<!--- //tüm sayfadaki ürünler için fiyatları alıyor sonra query of query ile çekecek--->
<table border="0" cellspacing="1" cellpadding="2" align="center" style="width:98%; height:35px;">
	<tr>
		<td class="headbold"><cf_get_lang no='364.Ürünü Özelleştir'>: <cfoutput>#get_product.product_name#</cfoutput></td>
		<td  style="text-align:right;"></td>
	</tr>
</table>
<table cellspacing="1" cellpadding="2" align="center" style="width:98%;">
	<tr class="color-header" style="height:22px;">
		<td class="form-title"><cf_get_lang no='139.Bileşenler'></td>
		<td class="form-title" style="width:300px;"><cf_get_lang_main no='152.Ürünler'></td>
		<td class="form-title" style="width:60px;"><cf_get_lang_main no='223.Miktar'>*</td>
		<td  class="form-title" style="text-align:right; width:90px;"><cf_get_lang_main no='261.Tutar'>*</td>
		<td class="form-title" style="width:50px;"><cf_get_lang_main no='77.Para Br'></td>
	</tr>
    <cfform name="product_customization" action="#request.self#?fuseaction=objects2.popup_product_customize" method="post">
	  	<input type="hidden" name="is_change" id="is_change" value="0">
	  	<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_spects_variation.recordcount#</cfoutput>">
	  	<!--- istisna fiyat varsa diye sadece main ürün için get_product_fiyat.cfm sayfası çağrılıyor--->
		<cfset fiyat_product_id = get_product.product_id>
		<cfset fiyat_stock_id = get_product.stock_id>
		<cfinclude template="get_product_fiyat.cfm">
		<cfset attributes.main_price_money =attributes.price_money>
		<cfquery name="GET_MAIN_PRICE" dbtype="query">
			SELECT RATE2, RATE1 FROM GET_MONEY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.main_price_money#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#">
		</cfquery>
		<cfset attributes.main_price = attributes.price>
		<cfset attributes.std_main_price = attributes.price*(get_main_price.rate2/get_main_price.rate1)>
		<cfset attributes.std_main_price_kdv = attributes.price_kdv*(get_main_price.rate2/get_main_price.rate1)>
		<!--- son kullanici fiyati icin --->
		<cfquery name="GET_STD_PRICE" dbtype="query">
			SELECT RATE2, RATE1 FROM GET_MONEY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.price_standard_money#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#">
		</cfquery>
		<cfset attributes.price_standard = attributes.price_standard*(get_std_price.rate2/get_std_price.rate1)>
		<cfset attributes.price_standard_kdv = attributes.price_standard_kdv*(get_std_price.rate2/get_std_price.rate1)>
		
		<cfquery name="GET_OTHER_MONEY" dbtype="query">
			SELECT RATE2, RATE1 FROM GET_MONEY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.main_price_money#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#">
		</cfquery>
		<input type="hidden" name="other_money_rate" id="other_money_rate" value="<cfoutput>#(get_other_money.rate1/get_other_money.rate2)#</cfoutput>">
	  	<tr class="color-row" style="height:20px;">
            <td class="txtbold"><cf_get_lang no='403.Özelleştirilen Ürün'></td>
            <td class="txtbold"><cfoutput>#get_product.product_name# #get_product.property#</cfoutput><input type="hidden" name="main_product_name" id="main_product_name" value="<cfoutput>#get_product.product_name# #get_product.property#</cfoutput>"></td>
            <td><input type="text" name="main_amount" id="main_amount" value="1" style="width:60px;" readonly="yes" onblur="hesapla();" class="boxtext"/></td>
            <td><input type="text" name="total_amount" id="total_amount" readonly="yes" style="width:90px;" class="box" value="<cfoutput>#attributes.main_price#</cfoutput>" onblur="hesapla();" onkeyup='return(FormatCurrency(this,event,4));'/></td>
            <td><input type="text" name="money_type" id="money_type" readonly="yes" class="box" style="width:50px;" value="<cfoutput>#attributes.main_price_money#</cfoutput>"/>
                <input type="hidden" name="main_std_money" id="main_std_money" value="<cfoutput>#attributes.std_main_price#</cfoutput>">
                <input type="hidden" name="main_kdvstd_money" id="main_kdvstd_money" value="<cfoutput>#attributes.std_main_price_kdv#</cfoutput>">
                <input type="hidden" name="main_product_id" id="main_product_id" value="<cfoutput>#get_product.product_id#</cfoutput>">
                <input type="hidden" name="main_stock_id" id="main_stock_id" value="<cfoutput>#get_product.stock_id#</cfoutput>">
            </td>
	  	</tr>
	  	<input type="hidden" name="tree_product_num" id="tree_product_num" value="<cfoutput>#get_prod_tree.recordcount#</cfoutput>">
	  	<cfoutput query="get_prod_tree">
	  		<tr class="color-row">
				<td></td>
	  			<td>
                    <cfquery name="GET_PRICE_MAIN" dbtype="query">
                       	SELECT
     						*
                        FROM
                            GET_PRICE
                        WHERE
                            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                    </cfquery>
                  	<cfif get_price_main.recordcount eq 0>
                        <cfquery name="GET_PRICE_MAIN" dbtype="query">
                            SELECT
                                *
                            FROM
                                GET_PRICE_STANDART
                            WHERE
                                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                        </cfquery>
					</cfif>
                    <cfquery name="GET_ALTERNATIVE" dbtype="query">
						SELECT * FROM GET_ALTERNATE_PRODUCT WHERE ASIL_PRODUCT = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> OR ALTERNATIVE_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
		  			</cfquery>
					<cfif is_configure and get_alternative.recordcount>
						<input type="hidden" name="tree_is_configure#currentrow#" id="tree_is_configure#currentrow#" value="1">
						<select name="tree_product_id#currentrow#" id="tree_product_id#currentrow#" style="width:300px;" onChange="UrunDegis(this,'#currentrow#');">
							<option value="#product_id#,#stock_id#,#get_price_main.price#,#get_price_main.money#,#get_price_main.price_stdmoney#,#get_price_main.price_kdv_stdmoney#,#product_detail# ">#product_detail#</option>
							<cfloop query="get_alternative">
								<cfquery name="GET_PRICE_ALTER#get_alternative.currentrow#" dbtype="query">
                                    SELECT
                                        *
                                    FROM
                                        GET_PRICE
                                    WHERE
                                        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_alternative.product_id#">
                       			</cfquery>
					  			<cfif evaluate('get_price_alter#get_alternative.currentrow#.recordcount') eq 0 or evaluate('get_price_alter#get_alternative.currentrow#.price') eq 0>
                                    <cfquery name="GET_PRICE_ALTER#get_alternative.currentrow#" dbtype="query">
                                        SELECT
                                            *
                                        FROM
                                            GET_PRICE_STANDART
                                        WHERE
                                            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_alternative.product_id#">
                                    </cfquery>
					  			</cfif>
								<option value="#get_alternative.product_id#,#get_alternative.stock_id#,#evaluate('get_price_alter#get_alternative.currentrow#.price')#,#evaluate('get_price_alter#get_alternative.currentrow#.money')#,#evaluate('get_price_alter#get_alternative.currentrow#.price_stdmoney')#,#evaluate('get_price_alter#get_alternative.currentrow#.price_kdv_stdmoney')#,#get_alternative.product_detail#">#get_alternative.product_detail#</option>
							</cfloop>
						</select>
					<cfelse>
						#product_detail#
						<input type="hidden" name="tree_product_id#currentrow#" id="tree_product_id#currentrow#" value="#product_id#,#stock_id#,#get_price_main.price#,#get_price_main.money#,#get_price_main.price_stdmoney#,#get_price_main.price_kdv_stdmoney#,#product_detail# ">
					</cfif>
					<input type="hidden" name="tree_product_name#currentrow#" id="tree_product_name#currentrow#" value="#product_detail#"></td>
                    <td><input type="text" name="tree_amount#currentrow#" id="tree_amount#currentrow#" value="#amount#" style="width:60px;" readonly="yes" onblur="hesapla();" class="boxtext"></td>
                    <td><input type="text" name="tree_total_amount#currentrow#" id="tree_total_amount#currentrow#" readonly="yes" style="width:90px;" class="box" value=""></td>
                    <td><input type="hidden" name="tree_total_amount_kdvli#currentrow#" id="tree_total_amount_kdvli#currentrow#" value="">
                        <input type="hidden" name="tree_std_money_hidden#currentrow#" id="tree_std_money_hidden#currentrow#" value="">
                        <input type="hidden" name="tree_std_money#currentrow#" id="tree_std_money#currentrow#" value="#get_price_main.price_stdmoney#">
                        <input type="hidden" name="tree_kdvstd_money#currentrow#" id="tree_kdvstd_money#currentrow#" value="#get_price_main.price_kdv_stdmoney#">
                        <input type="hidden" name="tree_is_sevk#currentrow#" id="tree_is_sevk#currentrow#" value="<cfif is_sevk>1<cfelse>0</cfif>">
                    </td>
	  			</tr>
		  		<cfif is_production eq 1>
					<cfquery name="GET_SUB_PROD_TREE" datasource="#DSN3#">
                        SELECT 
                            STOCKS.PRODUCT_NAME,
                            STOCKS.PRODUCT_ID,
                            STOCKS.IS_PRODUCTION,
                            STOCKS.STOCK_ID,
                            STOCKS.STOCK_CODE,
                            STOCKS.PROPERTY,
                            PRODUCT_TREE.AMOUNT,
                            PRODUCT_TREE.PRODUCT_TREE_ID,
                            <!--- PRODUCT_TREE.SPECT_MAIN_NAME, --->
                            PRODUCT_UNIT.MAIN_UNIT,
                            PRODUCT_TREE.IS_CONFIGURE,
                            PRODUCT_TREE.IS_SEVK,
                            STOCKS.PRODUCT_DETAIL
                        FROM
                            STOCKS,
                            PRODUCT_TREE,
                            PRODUCT_UNIT
                        WHERE
                            PRODUCT_UNIT.PRODUCT_UNIT_ID = PRODUCT_TREE.UNIT_ID AND
                            PRODUCT_TREE.RELATED_ID = STOCKS.STOCK_ID AND
                            PRODUCT_TREE.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
                    </cfquery>
                    <cfloop query="get_sub_prod_tree">
                        <tr class="color-row">
                            <td>&nbsp;</td>
                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#get_sub_prod_tree.product_detail#</td>
                            <td>&nbsp;#get_sub_prod_tree.amount#</td>
                            <td colspan="2"></td>
                        </tr>
                    </cfloop>
		  		</cfif>
	  		</cfoutput>
	 		<cfoutput query="get_spects_variation">
                <cfquery name="GET_STOCK_PROPERTY" dbtype="query">
                    SELECT
                        STOCK_ID,
                        PRODUCT_ID,
                        PRODUCT_NAME,
                        PRODUCT_DETAIL,
                        TOTAL_MAX,
                        TOTAL_MIN
                    FROM
                        GET_STOCK_PROPERTY_ALL
                    WHERE
                        PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_spects_variation.property_id#"> AND
                        PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#property_detail_id#"> AND
                        PRODUCT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                        <cfif isdefined("total_max") and len(total_max)>AND TOTAL_MAX <= <cfqueryparam cfsqltype="cf_sql_integer" value="#total_max#"></cfif> 
                        <cfif isdefined("total_min") and len(total_min)>AND TOTAL_MIN >= <cfqueryparam cfsqltype="cf_sql_integer" value="#total_min#"></cfif>
                </cfquery>
				<input type="hidden" name="property_id#currentrow#" id="property_id#currentrow#" value="#property_id#">
				<input type="hidden" name="variation_id#currentrow#" id="variation_id#currentrow#" value="#property_detail_id#">
                <cfquery name="GET_LANGUAGE_INFO" dbtype="query">
                    SELECT
                        *
                    FROM
                        GET_LANGUAGE_INFOS
                    WHERE
                        UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#property_id#">
                </cfquery>
                <cfquery name="GET_LANGUAGE_INFO2" dbtype="query">
                    SELECT
                        *
                    FROM
                        GET_LANGUAGE_INFOS2
                    WHERE
                        UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#property_detail_id#">
                </cfquery>
                <tr class="color-row" style="height:20px;">
                	<td><input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                    <cfif get_language_info.recordcount>#get_language_info.item#<cfelse>#property#</cfif>
                   	/ 
                    <cfif get_language_info2.recordcount>#get_language_info2.item#<cfelse>#property_detail#</cfif> -                	
					<cfif get_product.is_prototype eq 1>
                		#total_min# - #total_max# 
                		<input type="hidden" name="total_min#currentrow#" id="total_min#currentrow#" value="#total_min#">
                		<input type="hidden" name="total_max#currentrow#" id="total_max#currentrow#" value="#total_max#">
                	</cfif>
                </td>
                <td>
				<cfif get_product.is_prototype eq 1>
                    <select name="product_id#currentrow#" id="product_id#currentrow#" style="width:300px;" onchange="hesapla();">
                    	<option value=""><cf_get_lang_main no ='245.Ürün'></option>
                    	<cfloop query="get_stock_property">
                            <cfquery name="GET_BAREBONE_PRODUCT_PRICE#get_stock_property.currentrow#" dbtype="query">
                                SELECT
                                    *
                                FROM
                                    GET_PRICE
                                WHERE
                                    PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock_property.product_id#">
                            </cfquery>
                            <cfif evaluate('get_barebone_product_price#get_stock_property.currentrow#.recordcount') eq 0>
                                <cfquery name="GET_BAREBONE_PRODUCT_PRICE#get_stock_property.currentrow#" dbtype="query">
                                    SELECT
                                        *
                                    FROM
                                        GET_PRICE_STANDART
                                    WHERE
                                        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock_property.product_id#">
                                </cfquery>
                            </cfif>
                            <cfscript>
                                value_price = evaluate('get_barebone_product_price#get_stock_property.currentrow#.price');
                                value_price_normal = evaluate('get_barebone_product_price#get_stock_property.currentrow#.price_stdmoney');
                                value_price_kdv = evaluate('get_barebone_product_price#get_stock_property.currentrow#.price_kdv_stdmoney');
                                value_price_money = evaluate('get_barebone_product_price#get_stock_property.currentrow#.money');
                            </cfscript>			
                            <option value="#product_id#,#stock_id#,#product_detail# ,#value_price_kdv#,#value_price_normal#,#value_price#,#value_price_money#">#product_detail#</option>
						</cfloop>
					</select>
				</cfif>
            </td>
			<td>
				<cfif get_product.is_prototype eq 1>
                    <select name="amount#currentrow#" id="amount#currentrow#" class="box" style="width:60px;" onchange="hesapla();">
                        <option value=""><cf_get_lang_main no='223.Miktar'></option>
                        <cfloop from="1" to="#amount#" index="i">
                        <option value="#i#" <cfif i eq 1>selected</cfif>>#i#</option>
                        </cfloop>
                    </select>
                <cfelse>
                    <input type="text" name="amount#currentrow#" id="amount#currentrow#" value="0" style="width:60px;" onblur="hesapla();"/>
                </cfif>
            </td>
			<td><input type="text" name="total_amount#currentrow#" id="total_amount#currentrow#" style="width:90px;" readonly="yes" class="box" value="0" onblur="hesapla();" onkeyup='return(FormatCurrency(this,event,4));'/></td>
			<td><input type="text" name="money_type#currentrow#" id="money_type#currentrow#" readonly="yes" class="box" style="width:50px;"></td>
		</tr>		
	</cfoutput>
	<cfquery name="GET_KUR" dbtype="query">
		SELECT RATE2, RATE1,MONEY FROM GET_MONEY WHERE MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.money#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#">
	</cfquery>
	<cfoutput>
	<tr class="color-row" style="height:20px;">
		<td rowspan="4">
			<table>
				<tr>
			  		<td class="txtbold"><cf_get_lang no='140.Döviz Kurları'></td>
			  	</tr>
			  	<cfloop query="get_kur">
			  		<tr>
			  			<td>#money#</td>
						<td>#TLFormat(rate2/rate1,4)#</td>
			  		</tr>
			  	</cfloop>
			</table>
		</td>
		<td colspan="2"  class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.TOPLAM'> (#session_base.money#)</td>
		<td  class="txtbold" style="text-align:right;"><input type="text" name="total_price_stdmoney" id="total_price_stdmoney" value="<cfoutput>#tlformat(attributes.std_main_price)#</cfoutput>" class="box" style="width:90px;" readonly="yes"></td>
		<td  style="text-align:right;">#session_base.money#</td>
	</tr>
	<tr class="color-row" style="height:20px;">
		<td colspan="2"  class="txtbold" style="text-align:right;"><cf_get_lang no='137.TOPLAM KDV li'> (#session_base.money#)</td>
		<td  class="txtbold" style="text-align:right;"><input type="text" name="total_price_kdvli_stdmoney" id="total_price_kdvli_stdmoney" value="<cfoutput>#tlformat(attributes.std_main_price_kdv)#</cfoutput>" class="box" style="width:90px;" readonly="yes"></td>
		<td  style="text-align:right;">#session_base.money#</td>
	</tr>
	<tr class="color-row" style="height:20px;">
		<td colspan="2"  class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.TOPLAM'> (#attributes.main_price_money#)</td>
		<td  class="txtbold" style="text-align:right;"><input type="text" name="total_price_stdmoney_other" id="total_price_stdmoney_other" value="<cfoutput>#tlformat((attributes.std_main_price*(get_other_money.rate1/get_other_money.rate2)))#</cfoutput>" class="box" style="width:90px;" readonly="yes"></td>
		<td  style="text-align:right;">#attributes.main_price_money#</td>
	</tr>
	<tr height="20" class="color-row">
		<td colspan="2"  class="txtbold" style="text-align:right;"><cf_get_lang no='137.TOPLAM KDV li'> (#attributes.main_price_money#)</td>
		<td  class="txtbold" style="text-align:right;"><input type="text" name="total_price_kdvli_stdmoney_other" id="total_price_kdvli_stdmoney_other" value="<cfoutput>#tlformat((attributes.std_main_price_kdv*(get_other_money.rate1/get_other_money.rate2)))#</cfoutput>" class="box" style="width:90px;" readonly="yes"></td>
		<td  style="text-align:right;">#attributes.main_price_money#</td>
	</tr>
	<input type="hidden" name="total_price_standart" id="total_price_standart" value="<cfoutput>#attributes.price_standard#</cfoutput>">
	<input type="hidden" name="total_price_standart_kdv" id="total_price_standart_kdv" value="<cfoutput>#attributes.price_standard_kdv#</cfoutput>">
	<input type="hidden" name="price_standard_money" id="price_standard_money" value="<cfoutput>#attributes.price_standard_money#</cfoutput>">
	
	</cfoutput>
		  <tr class="color-row" style="height:30px;">
			<td colspan="5"  style="text-align:right;">
				<a href="javascript://" onClick="addBasket()"><img src="../objects2/image/basket.gif" border="0" title="<cf_get_lang_main no='1376.Sepete At'>" align="absmiddle" style="cursor:pointer"></a>
			</td>
		  </tr>
	</cfform>
</table>
<script type="text/javascript">
	function changeAction()
	{
		document.product_customization.action='<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_order_print&pid=<cfoutput>#get_product.product_id#</cfoutput>';
		document.product_customization.submit();
	}
	
	function addBasket()
	{
		document.getElementById('total_price_stdmoney').value = filterNum(document.getElementById('total_price_stdmoney').value);
		document.getElementById('total_price_kdvli_stdmoney').value = filterNum(document.getElementById('total_price_kdvli_stdmoney').value);
		document.getElementById('total_price_stdmoney_other').value = filterNum(document.getElementById('total_price_stdmoney_other').value);
		document.getElementById('total_price_kdvli_stdmoney_other').value = filterNum(document.getElementById('total_price_kdvli_stdmoney_other').value);
		document.product_customization.action='<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_add_basketww_custom_row';
		document.product_customization.submit();
	}
	
	function UrunDegis(nesne,no)
	{
	
		main_product_rate=<cfoutput>#get_main_price.rate1/get_main_price.rate2#</cfoutput>;
		degerler=nesne.value.split(',');
		price=wrk_round(degerler[2],2);
		money=degerler[3];
		std_price=wrk_round(degerler[4],2);
		std_kdvli_price=wrk_round(degerler[5],2);
		product_name=degerler[6];
		eval('document.getElementById("tree_total_amount'+no+'")').value=wrk_round(parseFloat(eval('document.getElementById("tree_total_amount'+no+'")').value-main_product_rate*(eval('document.getElementById("tree_std_money'+no+'")').value-std_price)),2);
		eval('document.getElementById("tree_total_amount_kdvli'+no+'")').value=wrk_round(parseFloat(eval('document.getElementById("tree_total_amount_kdvli'+no+'")').value-main_product_rate*(eval('document.getElementById("tree_kdvstd_money'+no+'")').value-std_kdvli_price)),2);
		eval('document.getElementById("tree_std_money_hidden'+no+'")').value=wrk_round(parseFloat(eval('document.getElementById("tree_std_money_hidden'+no+'")').value-(eval('document.getElementById("tree_std_money'+no+'")').value-std_price)),2);
		eval('document.getElementById("tree_std_money'+no+'")').value=std_price;
		eval('document.getElementById("tree_kdvstd_money'+no+'")').value=std_kdvli_price;
		eval('document.getElementById("tree_product_name'+no+'")').value=product_name;
		hesapla();
	}
	
	function hesapla()
	{	
		var is_change=0; //spect üzerinde değişiklik yapılıp yapılmadığını tutmak için
		toplam_deger = 0;
		toplam_deger_diger = 0;
		for (var r=1;r<=document.getElementById('record_num').value;r++)
		{
			
			form_amount = eval('document.getElementById("amount'+r+'")');
			form_total_amount = eval('document.getElementById("total_amount'+r+'")');
			form_money_type = eval('document.getElementById("money_type'+r+'")');
			form_product_id = eval('document.getElementById("product_id'+r+'")');
			form_money_type = eval('document.getElementById("money_type'+r+'")');
			
			if(form_product_id.value != "")
			{
				value_product_id_value = form_product_id.value.split(',');
				value_product_id_son = value_product_id_value[3];
				value_product_id_en_son = value_product_id_value[4];
				value_product_id_en_normal = value_product_id_value[5];
				value_product_id_en_money = value_product_id_value[6];
				if(form_product_id.selectedIndex>0 && is_change!=1) is_change=1;
			}
			else
			{
				value_product_id_son = 0;
				value_product_id_en_son = 0;
				value_product_id_en_normal = 0;
				value_product_id_en_money = "";
			}
			
			form_money_type.value = value_product_id_en_money;
			form_total_amount.value = commaSplit(value_product_id_en_normal);
			
			if(form_amount.value == "")
				value_form_amount = 0;
			else
				value_form_amount = form_amount.value;
			
			toplam_deger = toplam_deger + (value_form_amount*value_product_id_son);
			toplam_deger_diger = toplam_deger_diger + (value_form_amount*value_product_id_en_son);		
		}
		var tree_toplam=0;
		var tree_toplam_kdvli=0;
		for(var i=1;i<=<cfoutput>#get_prod_tree.recordcount#</cfoutput>;i++)
		{
			if(eval('document.getElementById("tree_product_id'+i+'")').selectedIndex>0 && is_change!=1)is_change=1;
			adet=parseFloat(eval('document.getElementById("tree_amount'+i+'")').value);
			if(eval('document.getElementById("tree_total_amount'+i+'")').value!="")
				tree_toplam=parseFloat(tree_toplam)+parseFloat(eval('document.getElementById("tree_total_amount'+i+'")').value)*adet;
			if(eval('document.getElementById("tree_total_amount_kdvli'+i+'")').value!="")
				tree_toplam_kdvli=parseFloat(tree_toplam_kdvli)+parseFloat(eval('document.getElementById("tree_total_amount_kdvli'+i+'")').value)*adet;
		}
	
		var product_rate=<cfoutput>#get_main_price.rate2/get_main_price.rate1#</cfoutput>;
		tree_toplam=parseFloat(tree_toplam*product_rate);
		tree_toplam_kdvli=parseFloat(tree_toplam_kdvli*product_rate);
	
		if(document.getElementById('main_amount').value == "")
		{
			document.getElementById('main_amount').value = 1;
		}
		document.getElementById('is_change').value=is_change;
		toplam=parseFloat(document.getElementById('main_std_money').value)+parseFloat(tree_toplam);
		toplam_kdv=parseFloat(document.getElementById('main_kdvstd_money').value)+parseFloat(tree_toplam_kdvli);
		toplam_deger = toplam_deger + (parseFloat(toplam_kdv)*parseFloat(document.getElementById('main_amount').value));
		toplam_deger_diger = toplam_deger_diger + (parseFloat(toplam)*parseFloat(document.getElementById('main_amount').value));
		
		document.getElementById('total_price_stdmoney').value = commaSplit(toplam_deger_diger);
		document.getElementById('total_price_kdvli_stdmoney').value = commaSplit(toplam_deger);
		
		document.getElementById('total_price_stdmoney_other').value = commaSplit((toplam_deger_diger * parseFloat(document.getElementById('other_money_rate').value)));
		document.getElementById('total_price_kdvli_stdmoney_other').value = commaSplit((toplam_deger * parseFloat(document.getElementById('other_money_rate').value)));
		
		//<!--- son kullanici fiyati icin --->		
		document.getElementById('total_price_standart').value = wrk_round( (parseFloat(<cfoutput>#attributes.price_standard#</cfoutput>) + parseFloat(tree_toplam)) * parseFloat(<cfoutput>#(GET_STD_PRICE.rate1/GET_STD_PRICE.rate2)#</cfoutput>),4);
		document.getElementById('total_price_standart_kdv').value = wrk_round( (parseFloat(<cfoutput>#attributes.price_standard_kdv#</cfoutput>) + parseFloat(tree_toplam)) * parseFloat(<cfoutput>#(GET_STD_PRICE.rate1/GET_STD_PRICE.rate2)#</cfoutput>),4);
	}
</script>

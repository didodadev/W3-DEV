<cfinclude template="../query/get_price_cats_moneys.cfm">

<cfif isDefined("attributes.price_catid") and len(attributes.price_catid)>
	<cfquery name="GET_CATALOGS" datasource="#DSN3#">
		SELECT DISTINCT
			PROD.PRODUCT_NAME,
			PROD.PRODUCT_ID,
			P.PRICE PRICE,
			P.MONEY MONEY,
			P.MONEY PRICE_MONEY,
			P.IS_KDV IS_KDV,
			P.PRICE_KDV PRICE_KDV,
			P.STARTDATE,
			P.FINISHDATE
		FROM
			STOCKS S,
			PRODUCT PROD,
			PRICE P,
			PRODUCT_UNIT,
			#dsn1_alias#.KARMA_PRODUCTS KP
		WHERE
        	KP.KARMA_PRODUCT_ID = PROD.PRODUCT_ID AND
			S.PRODUCT_STATUS = 1 AND 
			S.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
			PRODUCT_UNIT.IS_MAIN = 1 AND
			PRODUCT_UNIT.PRODUCT_ID = S.PRODUCT_ID AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = P.UNIT AND
			PROD.PRODUCT_ID=S.PRODUCT_ID AND
			<cfif isdefined("session.pp")>
            	PROD.IS_EXTRANET = 1 AND
            <cfelse>
            	PROD.IS_INTERNET = 1 AND
            </cfif>
			S.IS_KARMA = 1 AND
			ISNULL(P.STOCK_ID,0)=0 AND
			ISNULL(P.SPECT_VAR_ID,0)=0 AND
			P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
			(P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR P.FINISHDATE IS NULL) AND
             KP.KARMA_PRODUCT_ID IN (SELECT
                                        KPP.KARMA_PRODUCT_ID
                                    FROM 
                                        #dsn3_alias#.KARMA_PRODUCTS_PRICE KPP
                                    WHERE
                                        KPP.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#">
                                   ) AND
			P.PRICE > 0
			<cfif isDefined("attributes.price_catid") and len(attributes.price_catid)>
				AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#">
			</cfif>
	</cfquery>
</cfif>
<table align="center" style="width:98%;">
	<tr class="color-header" style="height:22px;">
		<td class="form-title"><cf_get_lang_main no='809.Ürün Adı'></td>
		<!--- <td class="form-title">Katalog Adı</td> --->
		<td class="form-title"><cf_get_lang no='412.Size Özel Fiyat'></td>
		<td class="form-title"><cf_get_lang_main no='89.Başlangıç'></td>
		<td class="form-title"><cf_get_lang_main no='90.Bitiş'></td>
		<td style="width:25px;"></td>
		<td style="width:20px;"></td>
	</tr>
	<cfif isDefined("attributes.price_catid") and len(attributes.price_catid) and get_catalogs.recordcount>
        <cfset product_list_ = valuelist(get_catalogs.product_id)>
        <cfquery name="GET_ALL_KARMA_PRODUCT" datasource="#DSN1#">
            SELECT DISTINCT
                KP.PRODUCT_AMOUNT,
                KP.KARMA_PRODUCT_ID,
                KP.PRODUCT_NAME,
                KPP.SALES_PRICE,
                KPP.MONEY,
                KPP.STOCK_ID,
                KPP.PRODUCT_ID
            FROM 
                KARMA_PRODUCTS AS KP,
                #dsn3_alias#.KARMA_PRODUCTS_PRICE KPP
            WHERE
                KP.KARMA_PRODUCT_ID=KPP.KARMA_PRODUCT_ID AND
                KP.STOCK_ID = KPP.STOCK_ID AND
                KPP.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
                KP.KARMA_PRODUCT_ID IN (#product_list_#) 
            <!--- ORDER BY
                KP.PRODUCT_ID --->
        </cfquery>
        <cfoutput query="get_catalogs">
            <cfquery name="GET_KARMA_STOCKS_" datasource="#DSN3#">
                SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
            </cfquery>
            <cfquery name="GET_THIS_PRODUCTS" dbtype="query">
                SELECT * FROM GET_ALL_KARMA_PRODUCT WHERE KARMA_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
            </cfquery>
            <cfset total_ = 0>
            <cfloop query="get_this_products">
                <cfset total_ = total_ + (get_this_products.SALES_PRICE*get_this_products.product_amount)>
            </cfloop>
            <tr>
                <td><a href="javascript://" onclick="gizle_goster(koli_#currentrow#)" class="tableyazi">#product_name# <!--- #property# ---></a></td>
                <!--- <td><!--- #catalog_head# ---></td> --->
                <td>#tlformat(total_)# #money#</td>
                <td>#dateformat(startdate,'dd/mm/yyyy')#  #timeformat(startdate,'HH:SS')#</td>
                <td>#dateformat(finishdate,'dd/mm/yyyy')#  #timeformat(finishdate,'HH:SS')#</td>
                <td><input type="text" value="1" name="satir_istenen_#currentrow#" id="satir_istenen_#currentrow#" style="width:25px;"></td>
                <td><a href="##" onclick="koli_gonder(#get_karma_stocks_.stock_id#,#product_id#,#attributes.price_catid#,#currentrow#);"><img src="../../images/online_basket.gif" title="<cf_get_lang_main no='1376.Sepete At'>" border="0"></a></td>
            </tr>
            <tr id="koli_#currentrow#" style="display:none;">
                <td colspan="5">
                    <table style="width:60%;">
                        <tr class="txtbold">
                            <td style="width:15px;"></td>
                            <td><cf_get_lang_main no='809.Ürün Adı'></td>
                            <td><cf_get_lang_main no='223.Miktar'></td>
                            <td style="text-align:right;"><cf_get_lang_main no='261.Tutar'></td>
                            <td style="text-align:right;"><cf_get_lang_main no='80.Toplam'></td>
                        </tr>
                        <cfloop query="get_this_products">
                            <tr>
                                <td></td>
                                <td><a href="#request.self#?fuseaction=objects.detail_product&product_id=#get_this_products.product_id#&stock_id=#get_this_products.stock_id#" class="tableyazi">#get_this_products.product_name#</a></td>
                                <td>#get_this_products.product_amount#</td>
                                <td style="text-align:right;">#tlformat(get_this_products.sales_price,2)# #get_this_products.money#</td>
                                <td style="text-align:right;">#tlformat(get_this_products.sales_price*get_this_products.product_amount,2)# #get_this_products.MONEY#</td>
                            </tr>
                        </cfloop>
                    </table>
                </td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr style="height:22px;">
            <td colspan="5"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
        </tr>
    </cfif>
</table>
<form action="" method="post" name="koli_gonder_form">
	<input type="hidden" name="istenen_miktar" id="istenen_miktar" value="1">
	<input type="hidden" name="stock_id" id="stock_id" value="">
	<input type="hidden" name="product_id" id="product_id" value="">
	<input type="hidden" name="price_catid" id="price_catid" value="">
</form>
<iframe name="form_basket_bundle" id="form_basket_bundle" src="" width="0" height="0" scrolling="yes" frameborder="1"></iframe>
<script type="text/javascript">
	function koli_gonder(stock_id,product_id,price_cat,satir_no)
	{  
		istenen = eval("document.getElementById('satir_istenen_"+satir_no+"')").value;
		istenen = parseInt(istenen);
		if(!parseInt(istenen))
		{
			istenen = 1;
			eval("document.getElementById('satir_istenen_"+satir_no+"')").value = 1;
		}
		document.getElementById('istenen_miktar').value = istenen;
		document.getElementById('stock_id').value = stock_id;
		document.getElementById('product_id').value = product_id;
		document.getElementById('price_catid').value = price_cat;
		
		document.koli_gonder_form.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_add_basket_row_bundle';
		document.koli_gonder_form.target = 'form_basket_bundle';
		document.koli_gonder_form.submit();
		PROCTest(satir_no);
	}
	
	function PROCTest(sno)
	{
		_working_.style.left=(document.body.clientWidth-400)/2;
		_working_.style.top=(document.body.clientHeight-120)/2;
		
		goster(_working_);
		setTimeout("gizle(_working_)",2000); 
	}
</script>


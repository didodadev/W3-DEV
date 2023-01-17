<cfsetting showdebugoutput="no">
<cfif not isdefined("attributes.is_change_spect_name")><cfset attributes.is_change_spect_name = 0></cfif>
<cfset xml_str=''>
<!--- Burada sadece 4 tane değişken için xml_str belirleniyor,çünkü sadece ağaç gösterimi yapılıyor ajax sayfada. --->
<cfscript>
	if(isdefined('attributes.is_show_cost')) xml_str = "#xml_str#&is_show_cost=#attributes.is_show_cost#";
	if(isdefined('attributes.is_show_diff_price')) xml_str = "#xml_str#&is_show_diff_price=#attributes.is_show_diff_price#";
	if(isdefined('attributes.is_show_price')) xml_str = "#xml_str#&is_show_price=#attributes.is_show_price#";
	if(isdefined('attributes.is_show_line_number')) xml_str = "#xml_str#&is_show_line_number=#attributes.is_show_line_number#";
	if(isdefined('attributes.is_show_configure')) xml_str = "#xml_str#&is_show_configure=#attributes.is_show_configure#";
	if(isdefined('attributes.is_change_spect_name')) xml_str = "#xml_str#&is_change_spect_name=#attributes.is_change_spect_name#";
</cfscript>
<script type="text/javascript">
	var form_field_list ='';
</script>
<cfset product_id_list=''>
<cfset tree_product_id_list=''>
<cfquery name="GET_PROD_TREE" datasource="#dsn3#">
	<!--- Ürün detayında tıklanan ürünün bir main_spect_id'si var ise onun bileşenlerini getirsin,yoksa stock_id'sine göre ağaçtan getirsin --->
	<cfif isdefined('attributes.is_spect_or_tree') and len(attributes.is_spect_or_tree)>
	SELECT 
		S.PRODUCT_NAME,
		S.PRODUCT_ID,
		S.IS_PRODUCTION,
		S.STOCK_ID,
		S.STOCK_CODE,
		S.PROPERTY,
		SPR.AMOUNT,
		SPR.RELATED_MAIN_SPECT_ID AS SPECT_MAIN_ID,
		CASE WHEN SPR.IS_CONFIGURE = 0 THEN 1 ELSE 0 END AS IS_CONFIGURE,
		SPR.IS_SEVK,
        SPR.LINE_NUMBER,
		(SELECT SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.SPECT_MAIN_ID = SPR.RELATED_MAIN_SPECT_ID) SPECT_MAIN_NAME
	FROM 
		STOCKS S,
		SPECT_MAIN SP,
		SPECT_MAIN_ROW SPR
	WHERE
	S.STOCK_ID = SPR.STOCK_ID AND
	SP.SPECT_MAIN_ID = SPR.SPECT_MAIN_ID AND
	SP.SPECT_MAIN_ID = #attributes.is_spect_or_tree#
    ORDER BY 
    	SPR.LINE_NUMBER,S.PRODUCT_NAME
	<cfelse>
	SELECT 
		STOCKS.PRODUCT_NAME,
		STOCKS.PRODUCT_ID,
		STOCKS.IS_PRODUCTION,
		STOCKS.STOCK_ID,
		STOCKS.STOCK_CODE,
		STOCKS.PROPERTY,
		PRODUCT_TREE.AMOUNT,
		PRODUCT_TREE.SPECT_MAIN_ID,
		PRODUCT_TREE.IS_CONFIGURE,
		PRODUCT_TREE.IS_SEVK,
        PRODUCT_TREE.LINE_NUMBER,
		(SELECT SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.SPECT_MAIN_ID = PRODUCT_TREE.SPECT_MAIN_ID) SPECT_MAIN_NAME
	FROM
		STOCKS,
		PRODUCT_TREE,
		PRODUCT_UNIT
	WHERE
		PRODUCT_UNIT.PRODUCT_UNIT_ID = PRODUCT_TREE.UNIT_ID AND
		PRODUCT_TREE.RELATED_ID = STOCKS.STOCK_ID AND
		PRODUCT_TREE.STOCK_ID = #attributes.stock_id#
    ORDER BY 
    	PRODUCT_TREE.LINE_NUMBER,STOCKS.PRODUCT_NAME
	</cfif>
</cfquery>
<cfif GET_PROD_TREE.RECORDCOUNT>
	<cfoutput query="GET_PROD_TREE">
		<cfset product_id_list=ListAppend(product_id_list,GET_PROD_TREE.PRODUCT_ID,',')>
		<cfset tree_product_id_list=ListAppend(tree_product_id_list,GET_PROD_TREE.PRODUCT_ID,',')>
	</cfoutput>
</cfif>
<cfif listlen(tree_product_id_list,',')>
	<cfquery name="GET_ALTERNATE_PRODUCT" datasource="#dsn3#">
		SELECT
			DISTINCT 
			AP.PRODUCT_ID ASIL_PRODUCT,
			AP.ALTERNATIVE_PRODUCT_ID,
			P.PRODUCT_NAME, 
			P.PRODUCT_ID as _PRODUCT_ID_,
			P.STOCK_ID,
			P.PROPERTY,
			P.IS_PRODUCTION
		FROM
			STOCKS AS P,
			ALTERNATIVE_PRODUCTS AS AP
		WHERE
			P.PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM ALTERNATIVE_PRODUCTS_EXCEPT WHERE ALTERNATIVE_PRODUCT_ID=#attributes.product_id#) AND
			((
				P.PRODUCT_ID=AP.PRODUCT_ID AND
				AP.ALTERNATIVE_PRODUCT_ID IN (#tree_product_id_list#)
			)
			OR
			(
				P.PRODUCT_ID=AP.ALTERNATIVE_PRODUCT_ID AND
				AP.PRODUCT_ID IN (#tree_product_id_list#)
			))
	</cfquery>
	<cfoutput query="GET_ALTERNATE_PRODUCT">
		<cfset product_id_list=ListAppend(product_id_list,GET_ALTERNATE_PRODUCT._PRODUCT_ID_,',')>
	</cfoutput>
</cfif>
<cfif listlen(product_id_list)>
	<cfquery name="GET_PRICE_STANDART" datasource="#dsn3#">
		SELECT
			PRICE_STANDART.PRODUCT_ID,
			SM.MONEY,
			PRICE_STANDART.PRICE,
			(PRICE_STANDART.PRICE*(SM.RATE2/SM.RATE1)) AS PRICE_STDMONEY,
			(PRICE_STANDART.PRICE_KDV*(SM.RATE2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
			SM.RATE2,
			SM.RATE1
		FROM
			PRODUCT,
			PRICE_STANDART,
			#dsn_alias#.SETUP_MONEY AS SM
		WHERE
			PRODUCT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
			PURCHASESALES = <cfif spec_purchasesales eq 1>1<cfelse>0</cfif> AND
			PRICESTANDART_STATUS = 1 AND
			SM.MONEY = PRICE_STANDART.MONEY AND
			SM.PERIOD_ID = #session.ep.period_id# AND
			PRODUCT.PRODUCT_ID IN (#product_id_list#)
	</cfquery>
</cfif>
<!---Maliyet Kısmı  --->
<cfif not isdefined('attributes.is_show_cost') or (isdefined('attributes.is_show_cost') and attributes.is_show_cost eq 1)>
<cfif listlen(product_id_list)>
	<cfquery name="get_product_cost_all" datasource="#dsn1#"><!--- Maliyetler geliyor. --->
		SELECT  
			PRODUCT_ID,
			PURCHASE_NET_SYSTEM,
			PURCHASE_EXTRA_COST_SYSTEM
		FROM
			PRODUCT_COST	
		WHERE
			PRODUCT_COST_STATUS = 1
			AND PRODUCT_ID IN (#product_id_list#)
			ORDER BY START_DATE DESC,RECORD_DATE DESC
	</cfquery>
</cfif>
</cfif>
<!---Maliyet  --->
<table  width="100%" onMouseOver="calculate_spects(form_field_list);">
 	<cfoutput>
	<input type="hidden" id="tree_record_num#attributes.satir#" name="tree_record_num#attributes.satir#" value="#get_prod_tree.recordcount#"></cfoutput>
	<cfset satir = 0>
	<cfoutput query="get_prod_tree">
		<cfset '_product_id_#currentrow#' = get_prod_tree.PRODUCT_ID>
		<cfset satir=satir+1>
		 <cfif IsQuery(GET_PRICE)>
			<cfquery name="GET_PRICE_MAIN#attributes.satir#" dbtype="query">
				SELECT
						*
				FROM
						GET_PRICE
				WHERE
						PRODUCT_ID= #Evaluate('_product_id_#currentrow#')#
			</cfquery>
		</cfif>
		<cfif not isdefined("GET_PRICE_MAIN") or ( isQuery(GET_PRICE_MAIN) and GET_PRICE_MAIN.RECORDCOUNT eq 0)>
			<cfquery name="GET_PRICE_MAIN#attributes.satir#" dbtype="query">
				SELECT
						*
				FROM
						GET_PRICE_STANDART
				WHERE
						PRODUCT_ID = #Evaluate('_product_id_#currentrow#')#
			</cfquery>
		</cfif>
		<cfif IS_CONFIGURE>
			<cfquery name="get_alternative#attributes.satir#_#satir#" dbtype="query">
				SELECT * FROM GET_ALTERNATE_PRODUCT WHERE ASIL_PRODUCT=#PRODUCT_ID# OR ALTERNATIVE_PRODUCT_ID=#PRODUCT_ID#
			</cfquery>
		</cfif>
       <tr id="tree_row#attributes.satir#_#satir#"<cfif isdefined('attributes.is_show_configure') and attributes.is_show_configure eq 1 and IS_CONFIGURE neq 1> style="display:none;"</cfif>>
		<td width="15"><!--- <cfloop from="1" to="#len(attributes.satir)#" index="k">&nbsp;&nbsp;a</cfloop> --->
        <cfif isdefined('attributes.is_show_line_number') and attributes.is_show_line_number eq 1>
	        <input type="text" name="line_number#attributes.satir#_#satir#" id="line_number#attributes.satir#_#satir#" style="width:15px;text-align:right" class="box" readonly value="#LINE_NUMBER#">
		</cfif>
        <input type="hidden" name="tree_row_kontrol#attributes.satir#_#satir#" id="tree_row_kontrol#attributes.satir#_#satir#" value="1"><!--- <cfif IS_CONFIGURE><a href="javascript://" onClick="sil_tree_row('#attributes.satir#_#satir#')"><img src="/images/delete_list.gif" alt="Ürün Sil" border="0"></a><input type="hidden" name="tree_is_configure#attributes.satir#_#satir#" value="1"></cfif> ---></td>
		<td width="120"><input type="text" name="tree_stock_code#attributes.satir#_#satir#" id="tree_stock_code#attributes.satir#_#satir#" value="#stock_code#" style="width:120px" readonly></td>
		<td nowrap="nowrap">
			<select  name="tree_product_id#attributes.satir#_#satir#" id="tree_product_id#attributes.satir#_#satir#" style="width:280px;" onChange="UrunDegis#attributes.satir#(this,'#attributes.satir#_#satir#');" <cfif isdefined('get_alternative#attributes.satir#_#satir#') and Evaluate('get_alternative#attributes.satir#_#satir#').recordcount  and IS_CONFIGURE>style="background:FFCCCC;"</cfif>>
				<option value="#product_id#,#stock_id#,#Evaluate('get_price_main#attributes.satir#').price#,#Evaluate('get_price_main#attributes.satir#').money#,#Evaluate('get_price_main#attributes.satir#').PRICE_STDMONEY#,#Evaluate('get_price_main#attributes.satir#').PRICE_KDV_STDMONEY#,#PRODUCT_NAME# #PROPERTY#,#is_production#">#PRODUCT_NAME# #PROPERTY#</option>
				<cfif IS_CONFIGURE>
					<cfloop query="get_alternative#attributes.satir#_#satir#">
						<cfif spec_purchasesales eq 1 and isQuery(GET_PRICE)>
							<cfquery name="GET_PRICE_ALTER#attributes.satir#_#satir#_#Evaluate('get_alternative#attributes.satir#_#satir#').currentrow#" dbtype="query">
								SELECT
										*
								FROM
										GET_PRICE
								WHERE
										PRODUCT_ID = #_PRODUCT_ID_#
							</cfquery>
						</cfif>
						<cfif not isdefined("GET_PRICE_ALTER#attributes.satir#_#satir#_#Evaluate('get_alternative#attributes.satir#_#satir#').currentrow#") or evaluate('GET_PRICE_ALTER#attributes.satir#_#satir#_#Evaluate('get_alternative#attributes.satir#_#satir#').currentrow#.RECORDCOUNT') eq 0 or evaluate('GET_PRICE_ALTER#attributes.satir#_#satir#_#Evaluate('get_alternative#attributes.satir#_#satir#').currentrow#.price') eq 0>
							<cfquery name="GET_PRICE_ALTER#attributes.satir#_#satir#_#Evaluate('get_alternative#attributes.satir#_#satir#').currentrow#" dbtype="query">
								SELECT
										*
								FROM
										GET_PRICE_STANDART
								WHERE
										PRODUCT_ID = #_PRODUCT_ID_#
							</cfquery>
						</cfif>
						<option value="#Evaluate('get_alternative#attributes.satir#_#satir#')._PRODUCT_ID_#,#Evaluate('get_alternative#attributes.satir#_#satir#').stock_id#,#evaluate('GET_PRICE_ALTER#attributes.satir#_#satir#_#Evaluate('get_alternative#attributes.satir#_#satir#').currentrow#.price')#,#evaluate('GET_PRICE_ALTER#attributes.satir#_#satir#_#Evaluate('get_alternative#attributes.satir#_#satir#').currentrow#.money')#,#evaluate('GET_PRICE_ALTER#attributes.satir#_#satir#_#Evaluate('get_alternative#attributes.satir#_#satir#').currentrow#.PRICE_STDMONEY')#,#evaluate('GET_PRICE_ALTER#attributes.satir#_#satir#_#Evaluate('get_alternative#attributes.satir#_#satir#').currentrow#.PRICE_KDV_STDMONEY')#,#Evaluate('get_alternative#attributes.satir#_#satir#').product_name# #Evaluate('get_alternative#attributes.satir#_#satir#').PROPERTY#,#is_production#" <cfif get_prod_tree.stock_id eq Evaluate('get_alternative#attributes.satir#_#satir#').stock_id>selected</cfif>>#Evaluate('get_alternative#attributes.satir#_#satir#').product_name# #Evaluate('get_alternative#attributes.satir#_#satir#').PROPERTY#</option>
					</cfloop>
				</cfif>
			</select>
			<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid='+list_getat(document.add_spect_variations.tree_product_id#attributes.satir#_#satir#.value,1)+'&sid='+list_getat(document.add_spect_variations.tree_product_id#attributes.satir#_#satir#.value,2),'medium')"><img src="/images/plus_thin.gif" title="Ürün Detay" border="0" align="absmiddle"></a>
		</td>
		<cfif attributes.is_change_spect_name eq 1>
			<td>
				<input type="text" id="related_spect_main_name#attributes.satir#_#satir#" name="related_spect_main_name#attributes.satir#_#satir#" value="#spect_main_name#">	
			</td>
		</cfif>
		<td>
		<input type="hidden" id="control#attributes.satir#_#satir#" name="control#attributes.satir#_#satir#" value="">
		<input type="hidden" id="stock_id#attributes.satir#_#satir#" name="stock_id#attributes.satir#_#satir#" style="width:43px;"value="#stock_id#">
		<input type="text" title="Spec Bileşenleri" readonly id="related_spect_main_id#attributes.satir#_#satir#"  name="related_spect_main_id#attributes.satir#_#satir#"  <cfif is_production eq 1>onClick="document.getElementById('kaydet#attributes.satir#').disabled=true;document.getElementById('tree_std_money#attributes.satir#_#satir#').value=document.getElementById('old_tree_std_money#attributes.satir#_#satir#').value;goster(SHOW_PRODUCT_TREE_ROW#attributes.satir#_#satir#);AjaxPageLoad('#request.self#?fuseaction=objects.popup_ajax_spect_detail_ajax#xml_str#&stock_id='+list_getat(document.getElementById('tree_product_id#attributes.satir#_#satir#').value,2,',')+'&product_id='+list_getat(document.getElementById('tree_product_id#attributes.satir#_#satir#').value,1,',')+'&satir=#attributes.satir#_#satir#&spec_purchasesales=#attributes.spec_purchasesales#&RATE1=#attributes.RATE1#&RATE2=#attributes.RATE2#&is_spect_or_tree='+document.getElementById('related_spect_main_id#attributes.satir#_#satir#').value+'','SHOW_PRODUCT_TREE_INFO#attributes.satir#_#satir#',1);"</cfif>style="width:43px;" class="box" value="<cfif SPECT_MAIN_ID neq 0>#SPECT_MAIN_ID#</cfif>" >
		</td><!--- Spec --->
		<script type="text/javascript">
			<cfif is_production eq 1 and (SPECT_MAIN_ID eq 0 or SPECT_MAIN_ID eq '')>//üretilen ürün ise ve bağlı buluduğu bir main spect yok ise 
				var form_field_list = form_field_list+'#attributes.satir#_#satir#'+',';
			</cfif>
		</script>	
		<td>
		<input type="hidden" name="is_configure#attributes.satir#_#satir#" id="is_configure#attributes.satir#_#satir#" value="#IS_CONFIGURE#">
		<input type="checkbox" name="tree_is_sevk#attributes.satir#_#satir#" id="tree_is_sevk#attributes.satir#_#satir#" value="1" <cfif is_sevk>checked</cfif>>
		</td><!--- SB --->
		<!--- Alt Ağaç --->
		<td style="width:15;"><a href="javascript://" onClick="document.getElementById('kaydet#attributes.satir#').disabled=true;document.getElementById('tree_std_money#attributes.satir#_#satir#').value=document.getElementById('old_tree_std_money#attributes.satir#_#satir#').value;goster(SHOW_PRODUCT_TREE_ROW#attributes.satir#_#satir#);AjaxPageLoad('#request.self#?fuseaction=objects.popup_ajax_spect_detail_ajax#xml_str#&stock_id='+list_getat(document.getElementById('tree_product_id#attributes.satir#_#satir#').value,2,',')+'&product_id='+list_getat(document.getElementById('tree_product_id#attributes.satir#_#satir#').value,1,',')+'&satir=#attributes.satir#_#satir#&spec_purchasesales=#attributes.spec_purchasesales#&RATE1=#attributes.RATE1#&RATE2=#attributes.RATE2#','SHOW_PRODUCT_TREE_INFO#attributes.satir#_#satir#',1);"><img id="under_tree#attributes.satir#_#satir#" title="Ağaç Bileşenleri" style="cursor:pointer;" <cfif is_production neq 1>style="display:none"</cfif> src="/images/shema_list.gif" align="absmiddle" border="0"></a></td>
		<!--- Alt Ağaç --->
		<td><input name="tree_amount#attributes.satir#_#satir#" id="tree_amount#attributes.satir#_#satir#" type="text" class="moneybox" style="width:50px" onFocus="document.getElementById('reference_amount').value=filterNum(this.value,4)"  onKeyUp="FormatCurrency(this,event,2);UrunDegis#attributes.satir#(document.getElementById('tree_product_id#attributes.satir#_#satir#'),'#attributes.satir#_#satir#',1);" value="#TLFormat(amount,4)#" <cfif IS_CONFIGURE eq 0>readonly</cfif> autocomplete="off"></td>
		<td <cfif isdefined('attributes.is_show_diff_price') and attributes.is_show_diff_price eq 0> style="display:none;"</cfif>>
		<input type="text" name="tree_diff_price#attributes.satir#_#satir#" id="tree_diff_price#attributes.satir#_#satir#" value="#TLFormat(0,4)#" onkeyup="return(FormatCurrency(this,event,2));" class="moneybox" onBlur="hesapla('');" style="width:80px"  <cfif IS_CONFIGURE eq 0>readonly</cfif>>
		<input type="hidden" name="tree_kdvstd_money#attributes.satir#_#satir#" id="tree_kdvstd_money#attributes.satir#_#satir#" value="#Evaluate('get_price_main#attributes.satir#').price_kdv_stdmoney#"><!--- Fiyat Farkı --->
		</td>
		<td <cfif isdefined('attributes.is_show_price') and attributes.is_show_price eq 0> style="display:none"</cfif>><input type="text" name="tree_total_amount_money#attributes.satir#_#satir#" id="tree_total_amount_money#attributes.satir#_#satir#df" value="#session.ep.money#" class="box" readonly  style="width:50px"></td><!--- #Evaluate('get_price_main#attributes.satir#').money# ---><!--- Para Br --->
		<cfif not isdefined('attributes.is_show_cost') or (isdefined('attributes.is_show_cost') and attributes.is_show_cost eq 1)>
			<!--- Maliyet --->
			<cfquery name="get_product_cost" dbtype="query"><!--- Maliyetler geliyor. --->
				SELECT * FROM get_product_cost_all WHERE PRODUCT_ID = #PRODUCT_ID#
			</cfquery>
			<!--- maliyetleri yoksa 0 set ediliyor. --->
			<cfif len(get_product_cost.PURCHASE_NET_SYSTEM)><cfset PURCHASE_NET_SYSTEM = get_product_cost.PURCHASE_NET_SYSTEM><cfelse><cfset PURCHASE_NET_SYSTEM = 0></cfif>
			<cfif len(get_product_cost.PURCHASE_EXTRA_COST_SYSTEM)><cfset PURCHASE_EXTRA_COST_SYSTEM = get_product_cost.PURCHASE_EXTRA_COST_SYSTEM><cfelse><cfset PURCHASE_EXTRA_COST_SYSTEM = 0></cfif>
			<td><input type="text" name="tree_product_cost#attributes.satir#_#satir#" id="tree_product_cost#attributes.satir#_#satir#" value="#TLFormat(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM,4)#" readonly class="moneybox" style="width:50px"></td>
			<!--- Maliyet --->
		</cfif>
		<td <cfif isdefined('attributes.is_show_price') and attributes.is_show_price eq 0> style="display:none"</cfif>>
			<input type="hidden" name="old_tree_std_money#attributes.satir#_#satir#" id="old_tree_std_money#attributes.satir#_#satir#" value="#TLFormat(Evaluate('get_price_main#attributes.satir#').price_stdmoney,4)#" class="moneybox" style="width:50px">
			<input type="hidden" name="reference_std_money#attributes.satir#_#satir#" id="reference_std_money#attributes.satir#_#satir#" value="#TLFormat(Evaluate('get_price_main#attributes.satir#').price_stdmoney,4)#" class="moneybox" style="width:50px">
			<input type="text" name="tree_std_money#attributes.satir#_#satir#" id="tree_std_money#attributes.satir#_#satir#" value="#TLFormat(Evaluate('get_price_main#attributes.satir#').price_stdmoney,4)#" class="moneybox" style="width:50px">
		</td>
		</tr>
		<tr id="SHOW_PRODUCT_TREE_ROW#attributes.satir#_#satir#" style="display:none">
			<td colspan="11"><div id="SHOW_PRODUCT_TREE_INFO#attributes.satir#_#satir#"></div></td>
		</tr>
	</cfoutput>
	<cfoutput>
	<tr id="SHOW_CREATE_SPECT#attributes.satir#"><!---  style="display:none" --->
		<td colspan="11"><div id="SHOW_CREATE_SPECT_INFO#attributes.satir#"></div></td>
	</tr>
	</cfoutput>
	<tr>
		<td colspan="11"  style="text-align:right;">
		<cfoutput>
		<!--- alert('#attributes.satir#'.substr('#attributes.satir#'.length,2)); --->
		<input type="button" id="kaydet#attributes.satir#" value="Kaydet" onClick="kontrol#attributes.satir#()">
		<input type="button" id="vazgec#attributes.satir#" value="Vazgeç" onClick="kontrol#attributes.satir#(1)">
		</cfoutput></td>
	</tr>
</table>
<script type="text/javascript">
	function <cfoutput>UrunDegis#attributes.satir#(field,no,type)</cfoutput>
	{
		//Bu kısımda değiştirilen satır ile ilgili değişiklikler yapılıyor
		gizle(document.getElementById('SHOW_PRODUCT_TREE_ROW'+no));//ürün değiştiğinde değişen ürüne ait açılmış bir detayı varsa kapatıyoruz.
		var _stock_id_ = list_getat(field.value,2,',');//stock id göndererek main spect id'si varsa onu alıyoruz.
		var _is_production_ = list_getat(field.value,8,',')//is_production olup olmadığı
		if(_is_production_ == 1)
		{
			var deger = workdata('get_main_spect_id',_stock_id_);
			if(deger.SPECT_MAIN_ID != undefined)//ürün üretilsede ağacı olmayabilir,o sebeble fonksiyondan undefined değeri dönebilir,hata olursa  boşaltıyoruz spect_main_id'yi
			var SPECT_MAIN_ID =deger.SPECT_MAIN_ID;else	var SPECT_MAIN_ID ='';
				document.getElementById('related_spect_main_id'+no).value = SPECT_MAIN_ID;//spect_main_id değiştir.
				goster(document.getElementById('under_tree'+no));//alt ağaç ikonunu göster
		}
		else
		{
			gizle(document.getElementById('under_tree'+no));
			document.getElementById('related_spect_main_id'+no).value ='';
		}
		//!Bu kısımda değiştirilen satır ile ilgili değişiklikler yapılıyor
		var price = list_getat(field.value,5,',');//5.ci eleman sistem para birimini ifade ediyor(YTL).
		if(price=="")price=0;
		var miktar = parseFloat(filterNum(document.getElementById('tree_amount'+no).value,4));
		if(isNaN(miktar) == true){document.getElementById('tree_amount'+no).value=0; miktar=0;}
		document.getElementById('tree_std_money'+no).value = commaSplit(price,4);//fiyat kısmına alternatif ürünü fiyatı yazılıyor
		var fark = miktar*(parseFloat(filterNum(document.getElementById('reference_std_money'+no).value,4))-price);
		var ust_fiyat =filterNum(document.getElementById('tree_std_money<cfoutput>#attributes.satir#</cfoutput>').value,4);
		if(type!=undefined)//miktar değişiyorsa
		{
			old_price = document.getElementById('reference_amount').value*price;
			new_price = (filterNum(document.getElementById('tree_std_money'+no).value,4)*miktar)-old_price;
			document.getElementById('tree_std_money<cfoutput>#attributes.satir#</cfoutput>').value = commaSplit(parseFloat(new_price)+parseFloat(ust_fiyat),4);
			document.getElementById('reference_amount').value = miktar;
		}
		else//ürün değişiyorsa
		{
			document.getElementById('tree_diff_price'+no).value = commaSplit(price-filterNum(document.getElementById('old_tree_std_money'+no).value,4),4);//fiyat farkı
			document.getElementById('tree_std_money<cfoutput>#attributes.satir#</cfoutput>').value = commaSplit(parseFloat(ust_fiyat)-parseFloat(fark),4);//üst fiyat yazılıyor
			document.getElementById('reference_std_money'+no).value = commaSplit(parseFloat(price),4);
		}
	}
	function <cfoutput>kontrol#attributes.satir#(type)
	{	
		var gelen_1=list_len('#attributes.satir#','_')-1;
		var new_satir='';
		for(i=1;i<=gelen_1;i=i+1)
		{
			var deger = list_getat('#attributes.satir#',i,'_');
			new_satir= new_satir+'_'+deger;
		}
		var up_save_button = new_satir.substr(1,new_satir.length);
		if(up_save_button.length>0)
			document.getElementById('kaydet'+up_save_button).disabled=false;
		gizle(document.getElementById('SHOW_PRODUCT_TREE_ROW#attributes.satir#'));
		if(type!=undefined)//eğer vazgeç butonunu tıklandı ise aşağıya girmeyecek
		{return false;}
		document.getElementById('old_tree_std_money#attributes.satir#').value=document.getElementById('tree_std_money#attributes.satir#').value;
	    var record_count = document.getElementById('tree_record_num#attributes.satir#').value
		var stock_id_list ='';
		var product_id_list ='';
		var product_name_list='';
		var amount_list = '';
		var is_sevk_list = '';
		var is_configure_list = '';
		var is_property_list = '';
		var property_id_list = '';
		var variation_id_list ='';
		var total_min_list ='';
		var total_max_list ='';
		var diff_price_list ='';
		var product_price_list ='';
		var product_money_list ='';
		var tolerance_list ='';
		var related_spect_main_id_list='';
		var line_number_list ='';
		for (i=1;i<=record_count;i++)
		{
			var miktar = filterNum(document.getElementById('tree_amount#attributes.satir#_'+i).value,4);
			amount_list += miktar+',';
			var fiyat =  filterNum(document.getElementById('tree_std_money#attributes.satir#_'+i).value,4);
			var stock_id = list_getat(document.getElementById('tree_product_id#attributes.satir#_'+i).value,2);
			stock_id_list +=stock_id+','
			var product_id = list_getat(document.getElementById('tree_product_id#attributes.satir#_'+i).value,1);
			product_id_list +=product_id+',';
			var product_name = list_getat(document.getElementById('tree_product_id#attributes.satir#_'+i).value,7);
			product_name_list +=product_name+'|@|';   
			if(document.getElementById('tree_is_sevk#attributes.satir#_'+i).checked == true)
			is_sevk_list +=1+','; else is_sevk_list +=0+',';
			is_configure_list += document.getElementById('is_configure#attributes.satir#_'+i).value+',';
			is_property_list += 0 +',';//sarf olduğu için 0 gönderiliyor
			property_id_list += 0 +',';//sarf oluğı için özelliği yok
			variation_id_list += 0 +',';//sarf olduğu için varyasyonu yok.
			total_min_list += '-' +',';//özellik olmadığı için - gönderiliyor.
			total_max_list += '-' +',';//özellik olmadığı için - gönderiliyor.
			diff_price_list+=filterNum(document.getElementById('tree_diff_price#attributes.satir#_'+i).value,4)+',';//oluşan fiyat farkları
			product_price_list+=filterNum(document.getElementById('tree_std_money#attributes.satir#_'+i).value,4)+',';//ürünün ytl fiyatları
			product_money_list+='#session.ep.money#' +',';
			tolerance_list += '-' +',';
			if(document.getElementById('related_spect_main_id#attributes.satir#_'+i).value != '')
			related_spect_main_id_list+=document.getElementById('related_spect_main_id#attributes.satir#_'+i).value +',';
			else
			related_spect_main_id_list+=0 +',';
			<cfif isdefined('attributes.is_show_line_number') and attributes.is_show_line_number eq 1>//XML'den seçilmiş ise
				if(document.getElementById('line_number#attributes.satir#_'+i).value > 0)
					line_number_list += document.getElementById('line_number#attributes.satir#_'+i).value+',';
				else
					line_number_list += 0 +',';
			</cfif>
		}
		var ust_miktar = filterNum(document.getElementById('tree_amount#attributes.satir#').value,4);
		if(ust_miktar == '') ust_miktar = 1;
		var all_fields = document.getElementById('tree_product_id#attributes.satir#').value;
		var main_product_id = list_getat(all_fields,1,',');//Ana ürünün product id'si
		var main_stock_id = list_getat(all_fields,2,',');//Ana ürünün stock id'si
		<cfif attributes.is_change_spect_name eq 1>
			var spec_name = document.getElementById('related_spect_main_name#attributes.satir#').value;
		<cfelse>
			var spec_name = list_getat(all_fields,7,',');//Ana ürünün ismi-spect_name olarak kullanıcaz
		</cfif>
		var spec_total_value = ust_miktar*filterNum(document.getElementById('tree_std_money#attributes.satir#').value,4);
		if(spec_total_value=='')spec_total_value = 0;
		var main_product_money = '#session.ep.money#';
		var spec_other_total_value = wrk_round(spec_total_value/parseFloat('#attributes.rate2/attributes.rate1#'));
		var other_money = '#session.ep.money2#';
		var spec_row_count = record_count;
		//var old_main_spect_id = document.getElementById('related_spect_main_id#attributes.satir#').value;//ana ürünün main spect id'si
		if(list_len(stock_id_list,',')-1 > 0)
		{
			product_name_list = product_name_list; 
			//
			var adres='&spec_row_count='+spec_row_count+'&stock_id_list='+stock_id_list+'&product_id_list='+product_id_list+'&product_name_list='+product_name_list+'';
			adres += '<cfif isdefined("attributes.is_show_line_number") and attributes.is_show_line_number eq 1>&line_number_list='+line_number_list+'</cfif>&amount_list='+amount_list+'&is_sevk_list='+is_sevk_list+'&is_configure_list='+is_configure_list+'&is_property_list='+is_property_list+'&satir='+"#attributes.satir#"+'';
			adres += '&property_id_list='+property_id_list+'&variation_id_list='+variation_id_list+'&total_min_list='+total_min_list+'&total_max_list='+total_max_list+'';
			adres += '&diff_price_list='+diff_price_list+'&product_price_list='+product_price_list+'&product_money_list='+product_money_list+'&tolerance_list='+tolerance_list+'';
			adres += '&main_product_id='+main_product_id+'&main_stock_id='+main_stock_id+'&spec_name='+spec_name+'&spec_total_value='+spec_total_value+'';//&old_main_spect_id='+old_main_spect_id+'
			adres += '&main_product_money='+main_product_money+'&spec_other_total_value='+spec_other_total_value+'&other_money='+other_money+'&related_spect_main_id_list='+related_spect_main_id_list+'';
			AjaxPageLoad('#request.self#?fuseaction=objects.popup_ajax_new_cre_spect&adres'+adres+'','SHOW_CREATE_SPECT_INFO#attributes.satir#',1);
		}
		</cfoutput>
	}
	function calculate_spects(field_name_list)
	{
		for(i=1;i<=list_len(field_name_list)-1;i++)
		{
			var control = 'control'+list_getat(field_name_list,i,',');
			if(document.getElementById(control).value!=1)
			{	var spect_id = 'related_spect_main_id'+list_getat(field_name_list,i,',');
				var stock_id = 'stock_id'+list_getat(field_name_list,i,',');
				var deger = workdata('get_main_spect_id',document.getElementById(stock_id).value);
				if(deger.SPECT_MAIN_ID != undefined)//ürün üretilsede ağacı olmayabilir,o sebeble fonksiyondan undefined değeri dönebilir,hata olursa  boşaltıyoruz spect_main_id'yi
				var SPECT_MAIN_ID =deger.SPECT_MAIN_ID;else	var SPECT_MAIN_ID ='';
				//alert(document.getElementById(eval('add_spect_variations.spect_main_id#attributes.satir#_#satir#')).value);//=SPECT_MAIN_ID;
				document.getElementById(spect_id).value=SPECT_MAIN_ID
				document.getElementById(spect_id).style.background ='CCCCCC';
				document.getElementById(control).value=1;
			}	
		}
	}
</script>


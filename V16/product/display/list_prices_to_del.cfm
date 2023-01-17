<cffunction name="get_currency">
	<cfargument name="cur_ty">
	<cfquery name="get_mon" datasource="#DSN#">
		SELECT
			RATE2/RATE1 AS RATE
		FROM
			SETUP_MONEY
		WHERE
			PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
			MONEY ='#cur_ty#'
 	</cfquery>
	<cfreturn get_mon.RATE>
</cffunction> 
<cfquery name="GET_PRODUCT_PRICE" datasource="#dsn3#">
	SELECT
		P.PRICE_ID,
		P.PRICE,
		P.PRICE_KDV,
		P.IS_KDV,
		P.MONEY,
		P.RECORD_EMP,
		P.STARTDATE,
		P.FINISHDATE,
		PU.ADD_UNIT,
		PU.WEIGHT,
		PC.PRICE_CAT
	FROM
		PRICE P,
		PRICE_CAT PC,
		PRODUCT_UNIT PU
	WHERE
		P.PRODUCT_ID = #URL.PID#
		AND	P.PRICE_CATID = PC.PRICE_CATID
		AND	PU.PRODUCT_ID = P.PRODUCT_ID
		<!---AND ISNULL(P.STOCK_ID,0)=0--->	 
		AND	ISNULL(P.SPECT_VAR_ID,0)=0
		AND	(P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL)
		AND	P.UNIT = PU.PRODUCT_UNIT_ID
</cfquery>
<cfscript>
		get_product_list_action = createObject("component", "V16.product.cfc.get_product");
		get_product_list_action.dsn1 = dsn1;
		get_product_list_action.dsn_alias = dsn_alias;
		GET_PRODUCT = get_product_list_action.get_product_
		(
			module_name : fusebox.circuit,
			pid : attributes.pid
		);
</cfscript>
<cfquery name="GET_COMPETITIVE_LIST" datasource="#DSN3#">
	SELECT 
		COMPETITIVE_ID
	FROM
		PRODUCT_COMP_PERM 
	WHERE 
		POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfquery name="GET_PURCHASE_PROD_DISCOUNT_DETAIL" datasource="#dsn3#" maxrows="1">
	SELECT
		*
	FROM
		CONTRACT_PURCHASE_PROD_DISCOUNT
	WHERE
		PRODUCT_ID = #attributes.pid# AND
		CONTRACT_ID IS NULL
	ORDER BY
		START_DATE DESC
</cfquery>
<cfset COMPETITIVE_LIST = ValueList(GET_COMPETITIVE_LIST.COMPETITIVE_ID)>
<cfset alis_kdv = GET_PRODUCT.TAX>
<cfset satis_kdv = GET_PRODUCT.TAX_PURCHASE>
<cfinclude template="../query/get_product_prices_sa_ss.cfm">
<cfset sa_prices_units = valuelist(GET_PRICE_SA.ADD_UNIT,',') >
<cfset sa_prices = valuelist(GET_PRICE_SA.PRICE,',') >
<cfset sa_prices_moneys = valuelist(GET_PRICE_SA.MONEY,',') >
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37637.Fiyat Silme ve Ekleme'></cfsavecontent>
<cf_popup_box title="#message#:#get_product_name(product_id:attributes.pid)#">
<cf_medium_list>
	<thead>
		<tr> 
			<th colspan="8"><cf_get_lang dictionary_id='37117.Satış Fiyatları'></th>
			<th style="text-align:right;">
				<cfif len(get_product.PROD_COMPETITIVE) >
					<cfif listfind(COMPETITIVE_LIST,get_product.PROD_COMPETITIVE,",")>
						<cfset dontshow = 1 >
						<cfset str_url_open = "product.popup_form_add_product_price&pid=#get_product.product_id#" >
					<cfelse>
						<cfset dontshow = 0 >
						<cfset str_url_open = "product.popup_add_price_request&pid=#get_product.product_id#" >
					</cfif>
					<cfelse>
						<cfset dontshow = 0 >
						<cfset str_url_open = "product.popup_add_price_request&pid=#get_product.product_id#">
				</cfif>
			</th>
		</tr>
		<tr> 
			<th width="150"><cf_get_lang dictionary_id='57509.Liste'></th>
			<th width="45"><cf_get_lang dictionary_id='57636.Birim'></th>				              
			<th width="110" style="text-align:right;"><cf_get_lang dictionary_id='37188.Kg'> <cf_get_lang dictionary_id='58084.Fiyat'></th>				
			<th width="110" style="text-align:right;"><cf_get_lang dictionary_id='58084.Fiyat'></th>
			<th width="110" style="text-align:right;"><cf_get_lang dictionary_id='37427.KDV li Fiyat'></th>
			<th width="55"><cf_get_lang dictionary_id='37045.Kar Marjı'>%</th>					 			 
			<th><cf_get_lang dictionary_id='57483.Kayıt'></th>
			<th width="90"><cf_get_lang dictionary_id='37119.Geçerlilik Tarihi'></th>  
			<th width="15">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=#str_url_open#</cfoutput>','page');">
					<img src="/images/plus_list.gif" border="0" title="<cf_get_lang dictionary_id='37124.Fiyat Ekle'>">
				</a>
			</th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="GET_PRODUCT_PRICE">				  
			<tr>
				<td>#PRICE_CAT#</td>
				<td>#ADD_UNIT#</td>
				<td style="text-align:right;">
					<!--- sadece teraziye giden urun icin kg fiyat olur --->
					<cfif isnumeric(PRICE) and  isnumeric(WEIGHT) and (WEIGHT neq 0) and get_product.is_terazi>#TLFormat(PRICE/WEIGHT)#</cfif>
				</td>
				<td style="text-align:right;">#TLFormat(PRICE)#&nbsp;#money#</td>
				<td style="text-align:right;"><cfif IS_KDV EQ 1>#TLFormat(PRICE_KDV)#<cfelse>#TLFormat(((PRICE*satis_kdv)/100)+PRICE)#</cfif>&nbsp;#money#</td>
				<td style="text-align:right;">
					<!--- Marj hesaplamasında farklı unit lerden sonuç çıkarmasını önlemek için konuldu. --->
					<cfif listfindnocase(sa_prices_units,ADD_UNIT,',')>
						<cfscript>
							indirimli_alis_fiyat = listgetat(sa_prices,listfindnocase(sa_prices_units,ADD_UNIT,','),',');
							sa_money = listgetat(sa_prices_moneys,listfindnocase(sa_prices_units,ADD_UNIT,','),',');
							indirim1 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT1;
							indirim2 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT2;
							indirim3 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT3;
							indirim4 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT4;
							indirim5 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT5;
							if (not len(indirim1)){indirim1 = 0;}
							if (not len(indirim2)){indirim2 = 0;}
							if (not len(indirim3)){indirim3 = 0;}
							if (not len(indirim4)){indirim4 = 0;}
							if (not len(indirim5)){indirim5 = 0;}
							indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim1)/100;
							indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim2)/100;
							indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim3)/100;
							indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim4)/100;
							indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim5)/100;
						</cfscript>
						<cfif isnumeric(get_currency(sa_money)) and isnumeric(indirimli_alis_fiyat) and indirimli_alis_fiyat>
							<cfset indirimli_alis_fiyat = indirimli_alis_fiyat*get_currency(sa_money) >
							<cfset satis_fiyat = PRICE*get_currency(MONEY) >
							#TLFormat(((satis_fiyat-indirimli_alis_fiyat)*100)/indirimli_alis_fiyat)#
						</cfif>
					</cfif>
				</td>
				<td>#get_emp_info(RECORD_EMP,0,1)#</td>
				<td>#dateformat(STARTDATE,dateformat_style)#-#dateformat(FINISHDATE,dateformat_style)#</td>
				<td>
					<cfsavecontent variable="del_rec"><cf_get_lang dictionary_id ='37775.Kayıtlı Fiyatı Siliyorsunuz! Emin misiniz'></cfsavecontent>
					<cfif dontshow eq 1>
						<a href="javascript://" onClick="javascript:if (confirm('#del_rec#')) windowopen('#request.self#?fuseaction=product.emptypopup_del_price&price_id=#price_id#&pid=#attributes.pid#','small'); else return false;">
							<img src="/images/delete_list.gif">
						</a>
					</cfif>
				</td>
			</tr>			  
		</cfoutput>
	</tbody>
</cf_medium_list>
</cf_popup_box>

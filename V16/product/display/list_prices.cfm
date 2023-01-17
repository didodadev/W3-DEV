<cfif not len(attributes.price_lists)>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='45954.Fiyat Listesi Seçmelisiniz'>!");
		window.close();	
	</script>
	<cfabort>
<cfelseif not len(attributes.finishdate)>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='37398.Geçerlilik Tarihi Girilmeli'>!");
		window.close();	
	</script>
	<cfabort>
</cfif>
<cfif isdefined("attributes.compid")>
	<cfset dsn3 = "#dsn#_#attributes.compid#">
</cfif>
<cfset attributes.finishdate2 = attributes.finishdate>
<cf_date tarih='attributes.finishdate2'>
<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
	SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT WHERE PRICE_CATID IN (#attributes.price_lists#) ORDER BY PRICE_CAT
</cfquery>
<cfquery name="GET_PRICE_STANDART" datasource="#DSN3#">
	SELECT 
		PRICE_STANDART.PRICE,PRICE_STANDART.PRICE_KDV,PRICE_STANDART.IS_KDV,PRICE_STANDART.MONEY,
		PU.ADD_UNIT,
		PRICE_STANDART.START_DATE
	FROM 
		PRICE_STANDART,
		PRODUCT_UNIT PU
	WHERE 
		PRICE_STANDART.PRODUCT_ID = #attributes.pid# AND
		PRICE_STANDART.PRICESTANDART_STATUS = 1	AND 
		PRICE_STANDART.PURCHASESALES = 1 AND 
		PU.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND 
		PU.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
		PU.IS_MAIN = 1
</cfquery>
<cfquery name="GET_LAST_PRICE_ALL" datasource="#dsn3#">
	SELECT 
		PRICE.PRICE,
		PRICE.PRICE_KDV,
		PRICE.IS_KDV,
		PRICE.MONEY,
		PRICE.PRICE_CATID,
		PU.ADD_UNIT,
		PRICE.STARTDATE,
		PRICE.FINISHDATE,
		PRICE.PRICE_DISCOUNT
	FROM 
		PRICE,
		PRODUCT_UNIT PU
	WHERE 		
		PRICE.PRODUCT_ID = #attributes.pid# AND
		<!---ISNULL(PRICE.STOCK_ID,0)=0 AND--->
		ISNULL(PRICE.SPECT_VAR_ID,0)=0 AND
		PRICE.STARTDATE < #CreateODBCDateTime(attributes.finishdate2)# AND
		PRICE.PRICE_CATID IN (#attributes.price_lists#) AND
		PU.IS_MAIN = 1 AND	
		PRICE.UNIT = PU.PRODUCT_UNIT_ID
	ORDER BY
		PRICE.STARTDATE DESC
</cfquery>
<script type="text/javascript">
	function add_price(price_kdv,price,discount)
	{    
		<cfif isdefined("attributes.field_price_kdv")>
			opener.<cfoutput>#field_price_kdv#</cfoutput>.value = price_kdv ;
		</cfif>
		<cfif isdefined("attributes.field_price")>
			opener.<cfoutput>#field_price#</cfoutput>.value = price ;
		</cfif>
		<cfif isdefined("attributes.field_discount")>
			opener.<cfoutput>#field_discount#</cfoutput>.value = discount ;
		</cfif>
		window.close();
	}
</script>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57657.Ürün'></cfsavecontent>
<cf_popup_box title='#message# : #get_product_name(product_id:attributes.pid)# : (#attributes.finishdate#)'>
	<cf_medium_list>
		<thead>
			<tr> 
				<th><cf_get_lang dictionary_id='57453.Şube'></th>
				<th><cf_get_lang dictionary_id='58084.Fiyat'></th>
				<th><cf_get_lang dictionary_id='37638.KDV Hariç Fiyat'></th>
				<th><cf_get_lang dictionary_id='37482.Tutar Ind'>.</th>
				<th><cf_get_lang dictionary_id='37235.Geçerlilik'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_price_cat.recordcount>
			<cfscript>
				end_price_2_w_kdv = get_price_standart.price_kdv;
				end_price_2_w = get_price_standart.price;
			</cfscript>
			<cfoutput>
			<tr>           
				<td><cf_get_lang dictionary_id='58721.Standart Satış'></td>
				<td style="cursor:pointer" class="tableyazi" onClick="javascript:add_price('#TLFormat(end_price_2_w_kdv,session.ep.our_company_info.sales_price_round_num)#','#TLFormat(end_price_2_w,session.ep.our_company_info.sales_price_round_num)#','#TLFormat(0)#');" align="right">#TLFormat(end_price_2_w_kdv,session.ep.our_company_info.sales_price_round_num)#&nbsp;#get_price_standart.money# (#get_price_standart.add_unit#)</td> 
				<td style="text-align:right;">#TLFormat(end_price_2_w,session.ep.our_company_info.sales_price_round_num)#&nbsp;#get_price_standart.money# (#get_price_standart.add_unit#)</td>
				<td style="text-align:right;">#TLFormat(0,session.ep.our_company_info.sales_price_round_num)#</td>
				<td>#DateFormat(get_price_standart.start_date,dateformat_style)# - </td>
			</tr>
			</cfoutput>
			<cfoutput query="get_price_cat">
				<cfquery name="GET_LAST_PRICE" dbtype="query" maxrows="1">
					SELECT 
						PRICE,
						PRICE_KDV,
						IS_KDV,
						MONEY,
						ADD_UNIT,
						STARTDATE,
						FINISHDATE,
						PRICE_DISCOUNT
					FROM 
						GET_LAST_PRICE_ALL
					WHERE 
						PRICE_CATID = #PRICE_CATID#
					ORDER BY
						STARTDATE DESC
				</cfquery>
				<cfscript>
						end_price_2_w_kdv = get_last_price.price_kdv;
						end_price_2_w = get_last_price.PRICE;
				</cfscript>
				<tr>           
					<td>#PRICE_CAT#</td>
					<td style="cursor:pointer" class="tableyazi" onClick="javascript:add_price('#TLFormat(end_price_2_w_kdv)#','#TLFormat(end_price_2_w,session.ep.our_company_info.sales_price_round_num)#','#TLFormat(get_last_price.price_discount,session.ep.our_company_info.sales_price_round_num)#');" align="right">#TLFormat(end_price_2_w_kdv,session.ep.our_company_info.sales_price_round_num)#&nbsp;#get_last_price.money# (#get_last_price.add_unit#)</td>
					<td style="cursor:pointer" align="right">#TLFormat(end_price_2_w,session.ep.our_company_info.sales_price_round_num)#&nbsp;#get_last_price.money# (#get_last_price.add_unit#)</td>
					<td style="text-align:right;">#TLFormat(get_last_price.price_discount,session.ep.our_company_info.sales_price_round_num)#</td>
					<td>#DateFormat(get_last_price.startdate,dateformat_style)# - #DateFormat(get_last_price.finishdate,dateformat_style)#</td>
				</tr>
			</cfoutput> 
			<cfelse>
			<tr> 
				<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
			</tr>
			</cfif>
		</tbody>
	</cf_medium_list>
</cf_popup_box>

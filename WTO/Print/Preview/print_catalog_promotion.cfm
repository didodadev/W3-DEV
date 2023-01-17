<cfsetting showdebugoutput="no">
<cfscript>
	// sayıları sadece iki ondalıklı yapan fonksiyon
	function yuvarla(fInput) 
	{
	  fInput = fInput * 1.00;
	  if (listlen(fInput,".") eq 2)
		{
		if (left(listgetat(fInput,2,"."),2) neq "00")
			{
			fInput = "#listgetat(fInput,1,".")#.#left(listgetat(fInput,2,"."),2)#";  
			}
		else
			{
			fInput = listgetat(fInput,1,".");
			}
		}
	  return(fInput);
	}
</cfscript>
<cfset attributes.kek=1>
<cfset module_name="product">
<cfset var_="upd_purchase_basket">
<cfset attributes.var_="upd_purchase_basket">
<cfinclude template="/V16/product/query/get_action_stages.cfm">
<cfinclude template="/V16/product/query/get_price_cats.cfm">
<cfinclude template="/V16/product/query/get_catalog_promotion_detail.cfm">
<cfif len(get_catalog_detail.VALID_EMP)>
  <cfquery name="GET_EMP2" datasource="#DSN#">
	  SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_catalog_detail.VALID_EMP#
  </cfquery>
<cfelseif len(get_catalog_detail.VALIDATOR_POSITION_CODE)>
  <cfquery name="GET_EMP_POSITION" datasource="#DSN#">
	  SELECT EMPLOYEE_ID ,EMPLOYEE_NAME , EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_ID = #get_catalog_detail.VALIDATOR_POSITION_CODE#
  </cfquery>
</cfif>
<cfquery name="GET_CAMPAIGN" datasource="#DSN3#">
	SELECT CAMP_ID,CAMP_HEAD,CAMP_FINISHDATE,CAMP_STARTDATE FROM CAMPAIGNS WHERE CAMP_FINISHDATE > #now()#  ORDER BY CAMP_HEAD
</cfquery>
<cfset recordnumber = 0>
<cfif IsDefined("attributes.id")>
	<cfinclude template="/V16/product/query/get_catalog_promotion_products.cfm">
	<cfset recordnumber = get_catalog_product.RecordCount>
</cfif>
<cfinclude template="/V16/contract/query/get_moneys.cfm">
<cfinclude template="/V16/contract/query/get_units.cfm">

<cfsavecontent variable="catalog1">
	<cfoutput query="get_action_stages">
		<cfif get_catalog_detail.stage_id eq stage_id>
		#stage_name#
		</cfif>
	</cfoutput>
</cfsavecontent>

<cfsavecontent variable="onay1">
	<cfif len(get_catalog_detail.valid)>
		<cfif get_emp2.recordcount>
			<cfset record_date = date_add('h',session.ep.TIME_ZONE,get_catalog_detail.validate_date)>
			<cfoutput> #get_emp2.employee_name# #get_emp2.employee_surname# (#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#) </cfoutput>
		<cfelse>
			<cf_get_lang dictionary_id='37219.Bilinmiyor'>
		</cfif>
	<cfelse>
		<input type="hidden" name="valid" id="valid" value="">
	</cfif>
</cfsavecontent>


<cfif not get_catalog_detail.recordcount>
    <cfset hata  = 10>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
    <cfset hata_mesaj  = message>
    <cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cf_woc_header>
	<cfoutput>
		<cf_woc_elements>
			<cfsavecontent variable="catalog"><cfif get_catalog_detail.catalog_status is 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></cfsavecontent>
			<cf_wuxi id="" data="#get_catalog_detail.CAT_PROM_NO# #catalog# #catalog1#" label="37272" type="cell">
			<cfsavecontent variable="onay"><cfif get_catalog_detail.valid eq 1><cf_get_lang dictionary_id='58699.Onaylandı'><cfelseif get_catalog_detail.valid eq 0><cf_get_lang dictionary_id='57617.Reddedildi'><cfelse><cf_get_lang dictionary_id='57615.Onay Bekliyor'>
			</cfif></cfsavecontent>
			<cf_wuxi id="" data="#onay1#" label="#onay#" type="cell">
			<cfset attributes.emp_id = get_catalog_detail.record_emp>
			<cfinclude template="/V16/product/query/get_employee_name.cfm">
			<cf_wuxi id="" data="#GET_EMPLOYEES.EMPLOYEE_NAME# #GET_EMPLOYEES.EMPLOYEE_SURNAME# - #dateformat(get_catalog_detail.RECORD_DATE,dateformat_style)#" label="57483" type="cell">
			<cf_wuxi id="" data="#get_catalog_detail.catalog_head#" label="37210" type="cell">	
			<cf_wuxi id="" data="#get_catalog_detail.catalog_detail#" label="57629" type="cell">	
		</cf_woc_elements>
		<cf_woc_elements>
			<cf_woc_list id="aaa">
				<thead>
					<tr>
						<th></th>
						<th></th>
						<th></th>
						<th></th>
						<th  colspan="2" align="center"><cf_get_lang dictionary_id='37227.Standart'></th>
						<th></th>
						<th colspan="6" align="center"><cf_get_lang dictionary_id='57641.iskonto'></th>
						<cf_wuxi label="58258" type="cell" is_row="0" id=""> <!---MALİYET--->
						<cf_wuxi label="57639" type="cell" is_row="0" id=""> <!---kdv--->
						<th colspan="3" align="center" ><cf_get_lang dictionary_id='37049.Aksiyon Fiyat'></th>
						<th colspan="2" nowrap align="center"><cf_get_lang dictionary_id='57749.Dönüş Fiyatı'></th>
					</tr>
					<tr>
						<cf_wuxi label="57629" type="cell" is_row="0" id=""> <!---açıklama--->
						<cf_wuxi label="57789" type="cell" is_row="0" id=""> <!---özel kod--->
						<cf_wuxi label="57636" type="cell" is_row="0" id=""> <!---birim--->
						<cf_wuxi label="57489" type="cell" is_row="0" id=""><!---para birimi--->
						<cf_wuxi label="58176" type="cell" is_row="0" id=""> <!---alış--->
						<cf_wuxi label="57448" type="cell" is_row="0" id=""> <!---satış--->
						<cf_wuxi label="37313" type="cell" is_row="0" id=""> <!---s. marj--->
						<th>1</th>
						<th>2</th>
						<th>3</th>
						<th>4</th>
						<th>5</th>
						<th>6</th>
						<cf_wuxi label="58716" type="cell" is_row="0" id=""> <!---kdv'li--->
						<cf_wuxi label="57448" type="cell" is_row="0" id=""> <!---satış--->
						<cf_wuxi label="37048" type="cell" is_row="0" id=""> <!---a. marj--->
						<cf_wuxi label="37365" type="cell" is_row="0" id=""> <!---kdv dahil--->
						<cf_wuxi label="37598" type="cell" is_row="0" id=""> <!---tutar indirimi--->
						<cf_wuxi label="37365" type="cell" is_row="0" id=""> <!---kdv dahil--->
						<cf_wuxi label="37598" type="cell" is_row="0" id=""> <!---tutar indirimi--->
					</tr>
				</thead>
				<tbody>
					<cfif IsDefined("attributes.id") and recordnumber>
						<cfloop query="get_catalog_product">
							<tr>
								<cf_wuxi data="#get_catalog_product.product_name#" type="cell" is_row="0"> 
								<cfif len(get_catalog_product.product_code_2)><cf_wuxi data="#get_catalog_product.product_code_2#" type="cell" is_row="0"><cfelse><td></td></cfif> 
								<cf_wuxi data="#unit#" type="cell" is_row="0"> 
								<cf_wuxi data="#money#" type="cell" is_row="0"> 
								<cf_wuxi data="#TLFormat(purchase_price,4)#" type="cell" is_row="0"> 
								<cf_wuxi data="#TLFormat(sales_price)#" type="cell" is_row="0"> 
								<cf_wuxi data="#TLFormat(profit_margin)#" type="cell" is_row="0"> 
								<cf_wuxi data="#TLFormat(discount1)#" type="cell" is_row="0"> 
								<cf_wuxi data="#TLFormat(discount2)#" type="cell" is_row="0"> 
								<cf_wuxi data="#TLFormat(discount3)#" type="cell" is_row="0"> 
								<cf_wuxi data="#TLFormat(discount4)#" type="cell" is_row="0"> 
								<cf_wuxi data="#TLFormat(discount5)#" type="cell" is_row="0"> 
								<cf_wuxi data="#TLFormat(discount6)#" type="cell" is_row="0"> 
								<cf_wuxi data="#TLFormat(row_total,4)#" type="cell" is_row="0"> 
								<cf_wuxi data="#tax#" type="cell" is_row="0"> 
								<cf_wuxi data="#TLFormat(action_profit_margin)#" type="cell" is_row="0"> 
								<cf_wuxi data="#TLFormat(action_price)#" type="cell" is_row="0"> 
								<cf_wuxi data="#TLFormat(action_price_discount)#" type="cell" is_row="0"> 
								<cf_wuxi data="#TLFormat(returning_price)#" type="cell" is_row="0"> 
								<cf_wuxi data="#TLFormat(returning_price_discount)#" type="cell" is_row="0"> 

							</tr>
						</cfloop>
					</cfif>
				</tbody>
			</cf_woc_list>
		</cf_woc_elements>
	</cfoutput>
	<cf_woc_footer>
</cfif>

			

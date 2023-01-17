<cfquery name="GET_PRODUCT_COST" DATASOURCE="#DSN3#" MAXROWS="1"><!---Ürün tutarları ve para birimi  --->
	SELECT * FROM PRODUCT_COST WHERE PRODUCT_ID = #attributes.product_id# ORDER BY RECORD_DATE DESC
</cfquery>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr class="color-border">
    	<td align="center" valign="top" >
		<cfoutput>
		  <table width="100%" border="0" cellpadding="2" cellspacing="1">
			<tr class="color-header" >
				<td height="22"  class="form-title" style="text-align:right;" ><cf_get_lang dictionary_id='60174.Standart Maliyet'></td>
				<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='54458.Genel Gider'></td>
				<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='34652.Taşıma Gideri'></td>
				<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58156.Diğer'> <cf_get_lang dictionary_id ='58678.Gider'></td>
				<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='36813.Toplam Birim Maliyet'></td>
				<td width="65" class="form-title" ><cf_get_lang dictionary_id='57489.Para Birimi'></td>
			</tr>
			<cfif GET_PRODUCT_COST.recordcount>			
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td  style="text-align:right;">
					#TLFormat(evaluate(GET_PRODUCT_COST.PRODUCT_COST-GET_PRODUCT_COST.OTHER_COST-GET_PRODUCT_COST.TRANSPORT_COST-GET_PRODUCT_COST.GENERAL_COST),4)#
				</td>
				<td  style="text-align:right;">#TLFormat(GET_PRODUCT_COST.GENERAL_COST,4)#</td>
				<td  style="text-align:right;">#TLFormat(GET_PRODUCT_COST.TRANSPORT_COST,4)#</td>
				<td  style="text-align:right;">#TLFormat(GET_PRODUCT_COST.OTHER_COST,4)#</td>
				<td  style="text-align:right;">
					<cfquery name="get_pro_main_unit" datasource="#DSN3#">
						SELECT PRODUCT_UNIT_ID,ADD_UNIT FROM PRODUCT_UNIT WHERE PRODUCT_ID = #attributes.product_id# AND ADD_UNIT = MAIN_UNIT
					</cfquery>
					<cfquery name="get_pr" dbtype="query">SELECT * FROM GET_PRICE_SS WHERE ADD_UNIT = '#get_pro_main_unit.ADD_UNIT#'</cfquery>
					<cfif len(get_pr.PRICE) >
						<cfset flt_price = get_pr.PRICE >
					<cfelse>
						<cfset flt_price = 0 >
					</cfif>
					<cfif len(GET_PRODUCT_COST.PRODUCT_COST)>
						<cfif get_pr.MONEY neq GET_PRODUCT_COST.MONEY >
							<cfset para_maliyeti = (GET_PRODUCT_COST.PRODUCT_COST*Evaluate("attributes.#GET_PRODUCT_COST.MONEY#"))/Evaluate("attributes.#get_pr.MONEY#")>
						<cfelse>
							<cfset para_maliyeti = GET_PRODUCT_COST.PRODUCT_COST >
						</cfif>
						<cfset marj = "">
						<cfset marj = numberformat(((flt_price-para_maliyeti)/para_maliyeti)*100,"__.__")>
						<cfif money_value neq GET_PRODUCT_COST.MONEY >
							<cfset para_maliyeti_satir = GET_PRODUCT_COST.PRODUCT_COST*Evaluate("attributes.#GET_PRODUCT_COST.MONEY#")>
						<cfelse>
							<cfset para_maliyeti_satir = GET_PRODUCT_COST.PRODUCT_COST>						
						</cfif>
					<cfelse>
						<cfset marj = "">
						<cfset para_maliyeti_satir="">
					</cfif>
					<a href="##" onClick="set_opener_money('#flt_price#', '#get_pr.money#', '#get_pro_main_unit.product_unit_id#', '#get_pro_main_unit.add_unit#', '#get_stock_strat(get_pro_main_unit.product_unit_id)#','#para_maliyeti_satir#','#marj#')" class="tableyazi">
					#TLFormat(GET_PRODUCT_COST.PRODUCT_COST,4)#
					</a>
				</td>
				<td>#GET_PRODUCT_COST.MONEY#</td>
		   </tr>
			</cfif>
		  </table>
		</cfoutput>		
		</td>
	</tr>
</table><br/>

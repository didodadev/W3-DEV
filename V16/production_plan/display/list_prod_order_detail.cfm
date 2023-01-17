<cfset attributes.prod_id=attributes.product_id>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.station_id" default=''>
<cfquery name="GET_PO" datasource="#dsn3#">
		SELECT
		DISTINCT
			PRODUCTION_ORDERS.*,
			GET_STOCK.PRODUCT_STOCK,
			PRODUCT.PRODUCT_NAME,
			PRODUCT.PRODUCT_ID,
			PRODUCT.PRODUCT_CATID,
			ORDERS.ORDER_NUMBER,
			ORDERS.COMPANY_ID,
			ORDERS.CONSUMER_ID,
			ORDERS.SALES_PARTNER_ID,
			ORDERS.ORDER_EMPLOYEE_ID,
			STOCKS.PROPERTY
		FROM
			PRODUCT,	
			PRODUCTION_ORDERS,
			#dsn2_alias#.GET_STOCK AS GET_STOCK,
			ORDERS,
			STOCKS
		WHERE
			PRODUCTION_ORDERS.ORDER_ID = #attributes.order_no# AND
			PRODUCTION_ORDERS.STOCK_ID = STOCKS.STOCK_ID AND
			ORDERS.ORDER_ID = PRODUCTION_ORDERS.ORDER_ID AND
			PRODUCT.PRODUCT_ID = GET_STOCK.PRODUCT_ID AND 
			GET_STOCK.STOCK_ID = PRODUCTION_ORDERS.STOCK_ID
</cfquery>
<cfquery name="GET_PO_DET" dbtype="query">
	SELECT 
		*
	FROM
		GET_PO
	WHERE
		P_ORDER_ID IS NOT NULL
		<cfif len(attributes.keyword)>AND P_ORDER_NO LIKE '%#attributes.keyword#%'</cfif>
		<cfif len(attributes.station_id)>AND STATION_ID = #attributes.station_id#</cfif>
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_PO_DET.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_W" datasource="#DSN3#">
	SELECT * FROM WORKSTATIONS ORDER BY STATION_NAME
</cfquery>
<table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center" >
  <cfform name="search" action="#request.self#?fuseaction=prod.popup_list_prod_order&product_id=#attributes.product_id#" method="post">
    <tr>
      <td>
        <table width="100%">
          <tr>
            <td class="headbold"><cfif GET_PO_DET.RECORDCOUNT><cfoutput>#GET_PO_DET.PRODUCT_NAME#&nbsp;#GET_PO_DET.PROPERTY#</cfoutput></cfif><cf_get_lang dictionary_id='36368.Üretim Emirleri'></td>
          </tr>
        </table>
      </td>
    </tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
	<tr class="color-list" height="22">
		<td colspan="9" align="right" style="text-align:right;">
			<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td align="right" style="text-align:right;">
					<cf_get_lang dictionary_id='57460.Filtre'>:
					<select name="STATION_ID" id="STATION_ID" style="width:150px;">
					<option value=""><cf_get_lang dictionary_id='36371.Tüm İstasyonlar'></option>
					<cfoutput query="get_w">
					<option value="#statIon_ID#"<cfif attributes.STATION_ID EQ STATION_ID>SELECTED</cfif>>#STATION_NAME#</option>
					</cfoutput>
					</select>
					<cfif isdefined("attributes.query_p_order_id")>
					<input type="hidden" name="query_p_order_id" id="query_p_order_id" value="<cfoutput>#attributes.query_p_order_id#</cfoutput>">
					<cfset str_link="&query_p_order_id=#attributes.query_p_order_id#">	
					<cfelse>
					<cfset str_link="">																			
					</cfif>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td width="20" align="right" style="text-align:right;"><cf_wrk_search_button></td>
				</tr>
			</table>
		</td>
	</tr>
	</cfform>
	<tr class="color-header" height="22">
		<td class="form-title" width="65"><cf_get_lang dictionary_id='29474.Emir No'></td>
		<td class="form-title" width="65"><cf_get_lang dictionary_id='58211.Siparis No'></td>
		<td class="form-title" width="100"><cf_get_lang dictionary_id='58834.İstasyon'></td>
		<td class="form-title" width="90"><cf_get_lang dictionary_id='57501.Başlangıç'></td>
		<td class="form-title" width="90"><cf_get_lang dictionary_id='57502.Bitiş'></td>
		<td width="70" align="right" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></td>
		<td class="form-title" width="50"><cf_get_lang dictionary_id='57636.Birim'></td>
	</tr>
	<cfif GET_PO_DET.RECORDCOUNT>
		<cfoutput query="GET_PO_DET" STARTROW="#attributes.startrow#" MAXROWS="#attributes.maxrows#">
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>#P_ORDER_NO#</td>
				<td>#ORDER_NUMBER#</td>
				<td><cfif len(STATION_ID)>#get_name(STATION_ID,"ws")#</cfif></td>
				<td>#dateformat(START_DATE,dateformat_style)# #TimeFormat(START_DATE,"hh")#:#TimeFormat(START_DATE,"mm")#</td>
				<td>#dateformat(FINISH_DATE,dateformat_style)# #TimeFormat(FINISH_DATE,"hh")#:#TimeFormat(FINISH_DATE,"mm")#</td>
				<td align="right" style="text-align:right;">#QUANTITY#</td>
				<td>#GET_PRODUCT_PROPERTY_PROD(STOCK_ID,'unit')#</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row" height="20">
			<td colspan="10"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
		</tr>
	</cfif>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="98%" align="center" cellspacing="0" cellpadding="0" border="0" height="35">
		<tr>
			<td><cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="prod.popup_list_prod_order&keyword=#attributes.keyword#&station_id=#attributes.station_id#&product_id=#attributes.product_id##str_link#"></td><!--- &route_id=#attributes.route_id# --->
			<!-- sil --><td align="right" style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# &nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
</cfif>

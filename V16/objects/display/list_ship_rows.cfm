<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.product_name" default="">
<cfif isdefined("attributes.form_varmi") >
	<cfinclude template="../query/get_ship_rows.cfm">
	<cfparam name="attributes.totalrecords" default='#get_ship_rows.recordcount#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">	
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.ship_no" default=''>
<cfquery name="STORES" datasource="#DSN#">
	SELECT * FROM DEPARTMENT  WHERE  IS_STORE <> 2 AND DEPARTMENT_STATUS = 1 
</cfquery>
<script type="text/javascript">
	function gonder(st_id,s_code,s_number,p_name,amount,s_date,s_id,par_id,comp_id,con_id,pur_sale,guaranty_cat_id)
	{
		<cfoutput>
		<cfif isdefined("attributes.field_pur_sale")>
			opener.#attributes.field_pur_sale#.value = pur_sale;
		</cfif>
		<cfif isdefined("attributes.field_ship_id")>
			opener.#attributes.field_ship_id#.value = s_id;
		</cfif>
		<cfif isdefined("attributes.field_stock_code")>
			opener.#attributes.field_stock_code#.value = s_code;
		</cfif>
		<cfif isdefined("attributes.field_stock_id")>
			opener.#attributes.field_stock_id#.value = st_id;
		</cfif>
		<cfif isdefined("attributes.field_s_number")>
			opener.#attributes.field_s_number#.value = s_number;
		</cfif>
		<cfif isdefined("attributes.field_p_name")>
			opener.#attributes.field_p_name#.value = p_name;
		</cfif>
		<cfif isdefined("attributes.field_amount")>
			opener.#attributes.field_amount#.value = amount;
		</cfif>
		<cfif isdefined("attributes.field_s_date")>
			opener.#attributes.field_s_date#.value = s_date;
		</cfif>
		
		<cfif isdefined("attributes.field_partner")>
			opener.#attributes.field_partner#.value = par_id;
		</cfif>
		
		<cfif isdefined("attributes.field_company")>
			opener.#attributes.field_company#.value = comp_id;
		</cfif>
		
		<cfif isdefined("attributes.field_consumer")>
			opener.#attributes.field_consumer#.value = con_id;
		</cfif>
		
		</cfoutput>
		window.close();
	}
</script>

<cfscript>
	url_string = '';
	if (isdefined('attributes.field_pur_sale')) url_string = '#url_string#&field_pur_sale=#field_pur_sale#';
	if (isdefined('attributes.field_ship_id')) url_string = '#url_string#&field_ship_id=#field_ship_id#';
	if (isdefined('attributes.field_stock_code')) url_string = '#url_string#&field_stock_code=#field_stock_code#';
	if (isdefined('attributes.field_stock_id')) url_string = '#url_string#&field_stock_id=#field_stock_id#';
	if (isdefined('attributes.field_s_number')) url_string = '#url_string#&field_s_number=#field_s_number#';
	if (isdefined('attributes.field_p_name')) url_string = '#url_string#&field_p_name=#field_p_name#';
	if (isdefined('attributes.field_amount')) url_string = '#url_string#&field_amount=#field_amount#';
	if (isdefined('attributes.field_s_date')) url_string = '#url_string#&field_s_date=#field_s_date#';
	if (isdefined('attributes.field_partner')) url_string = '#url_string#&field_partner=#field_partner#';
	if (isdefined('attributes.field_company')) url_string = '#url_string#&field_company=#field_company#';
	if (isdefined('attributes.field_consumer')) url_string = '#url_string#&field_consumer=#field_consumer#';
	if (isdefined('attributes.take')) url_string = '#url_string#&take=#attributes.take#';
	if (isdefined('attributes.sale')) url_string = '#url_string#&sale=#attributes.sale#';
</cfscript>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
  <tr>
    <td class="headbold"><cfif isdefined("attributes.take")><cf_get_lang dictionary_id='33098.Alış İrsaliyesi'><cfelseif isdefined("attributes.sale")><cf_get_lang dictionary_id='30098.Satış İrsaliyesi'></cfif> / <cf_get_lang dictionary_id='57637.Seri No'></td>
    <td style="text-align:right;" valign="bottom">
      <table>
	  	<tr>
        	<cfform name="search_product" action="#request.self#?fuseaction=objects.popup_list_ship_rows#url_string#" method="post">
			<input name="form_varmi" id="form_varmi" value="1" type="hidden">
            	<td><cf_get_lang dictionary_id='58138.Irsaliye No'></td>
				<td><cfinput type="text" name="ship_no" style="width:100px;" value="#attributes.ship_no#" maxlength="255"></td>
				<td><input type="text" name="start_date" id="start_date" value="<cfif isDefined("attributes.start_date") and len(attributes.start_date)><cfoutput>#dateformat(attributes.start_date,dateformat_style)#</cfoutput></cfif>" style="width:100px;">
		     		<cf_wrk_date_image date_field="start_date"></td>
				<td><cfsavecontent variable="Sayi_Hatasi_Mesaj"><cf_get_lang dictionary_id='33097.Maksimum Kayıt sayısı Hatalı'></cfsavecontent>
					<cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="#Sayi_Hatasi_Mesaj#"></td>
            <td><cf_wrk_search_button></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
		<tr class="color-list" height="20">
			<td colspan="13" style="text-align:right;">
				<table>				
					<tr>
						<td><cf_get_lang dictionary_id='57657.Ürün'></td>
						<td>
						<!--- <cf_wrk_products form_name = 'search_product' product_name='product_name' stock_id='stock_id'> --->
						<input type="hidden" name="stock_id" id="stock_id" <cfif len("attributes.stock_id") and len(attributes.product_name)>value="<cfoutput>#attributes.stock_id#</cfoutput>"</cfif>>
						<input type="text" name="product_name" id="product_name" style="width:135px;" value="<cfif len(attributes.stock_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" readonly="yes" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','STOCK_ID','stock_id','','2','200');" autocomplete="off">
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=search_product.stock_id&field_name=search_product.product_name','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></td>
						<td><cf_get_lang dictionary_id='57417.Üyeler'></td>
						<td><input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined('attributes.company') and len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">				
              			<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.company') and len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
						<input type="text" name="company" id="company" style="width:150px;" value="<cfif isdefined('attributes.company') and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>">
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_consumer=search_product.consumer_id&field_comp_name=search_product.company&field_comp_id=search_product.company_id&select_list=2,3','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
						<td><cf_get_lang dictionary_id='58763.Depo'></td><!---  --->
						<td><input type="hidden" name="form_varmi" id="form_varmi" value="1">
						<select name="department_id" id="department_id" style="width:150px;">
                            <option value=""><cf_get_lang dictionary_id='58763.Depo'></option>
                            <cfoutput query="stores"> 
                            	<option value="#department_id#" <cfif isDefined('attributes.department_id') and attributes.department_id eq stores.department_id>selected</cfif>>#department_head# </option>
                            </cfoutput>
						</select>
                        </td>
					</tr>
					</cfform>
				</table>
			</td>
	   	</tr>	
        <tr class="color-header" height="22">
			<td  class="form-title"><cf_get_lang dictionary_id='57657.Ürün'></td>
			<td  class="form-title"><cf_get_lang dictionary_id='57635.Miktar'></td>
			<td width="150" class="form-title"><cf_get_lang dictionary_id='58138.İrsaliye No'></td>
			<td  class="form-title"><cf_get_lang dictionary_id='57742.Tarih'></td>
			<td  width="150" class="form-title"><cf_get_lang dictionary_id='57658.Üye'></td>
		</tr>
        <cfif isdefined("attributes.form_varmi") and get_ship_rows.recordcount>
            <cfoutput query="get_ship_rows" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            	<!--- <cfquery name="get_product_guaranty" datasource="#DSN3#">
					SELECT * FROM PRODUCT_GUARANTY WHERE PRODUCT_ID = #PRODUCT_ID#
				</cfquery> --->
			 <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
			    <td><a href="javascript://" class="tableyazi" onclick="gonder('#stock_id#','#stock_code#','#ship_number#','#product_name#','#amount#','#dateformat(ship_date,dateformat_style)#','#ship_id#','#partner_id#','#company_id#','#consumer_id#','#purchase_sales#');">#PRODUCT_NAME#</a></td>
				<td>#amount#</td>
                <td>#SHIP_NUMBER#</td>
			    <td>#dateformat(SHIP_DATE,dateformat_style)#</td>
                <td>
				  <cfif len(partner_id)>
				    #get_par_info(partner_id,0,0,1)#
				  <cfelseif len(consumer_id)>
					 #get_cons_info(consumer_id,0,1)#
				  </cfif>
				</td>
              </tr>
            </cfoutput>
        <cfelse>
          	<tr>
            	<td colspan="10" class="color-row" height="20"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
          	</tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<cfif attributes.maxrows lt attributes.totalrecords>
  <table cellpadding="2" cellspacing="0" border="0" width="98%" align="center">
    <tr height="2" >
      <td>
		<cfset adres="objects.popup_list_ship_rows" >
		<cfif len(attributes.ship_no)>
			<cfset adres = "#adres#&ship_no=#attributes.ship_no#">
		</cfif>
		<cfif isDefined('attributes.start_date') and len(attributes.start_date)>
			<cfset adres = "#adres#&start_date=#attributes.start_date#">
		</cfif>
		<cfif isdefined("attributes.form_varmi")>
			<cfset adres = "#adres#&form_varmi=#attributes.form_varmi#" >
		</cfif>
		<cfif len(attributes.stock_id)>
			<cfset adres = "#adres#&stock_id=#attributes.stock_id#">
		</cfif>
		<cfif len(attributes.product_name)>
			<cfset adres = "#adres#&product_name=#attributes.product_name#">
		</cfif>
		<cfif len(attributes.company)>
			<cfset adres = "#adres#&company=#attributes.company#">
		</cfif>
		<cfif len(attributes.company_id)>
			<cfset adres = "#adres#&company_id=#attributes.company_id#">
		</cfif>
		<cfif len(attributes.consumer_id)>
			<cfset adres = "#adres#&consumer_id=#attributes.consumer_id#">
		</cfif>
		<cfif isDefined('attributes.department_id') and len(attributes.department_id) >
          <cfset adres = "#adres#&department_id=#attributes.department_id#">
        </cfif>
		<cfif len(url_string)>
			<cfset adres = '#adres##url_string#'>
		</cfif>
	  	<cf_pages page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">
		</td>
      <!-- sil -->
	  <td  style="text-align:right;"><cfoutput> <cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif>

<cfset module_name="sales">
<cfparam name="attributes.is_filter" default="0">
<cfparam name="attributes.product_cat" default=''>
<cfparam name="attributes.product_catid" default=''>
<cfparam name="attributes.search_company_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.list_order_no" default="">
<cfparam name="attributes.unit" default="1">
<cfparam name="attributes.product_type" default="2">
<cfif attributes.is_filter>
	<cfinclude template="../query/get_ezgi_stocks.cfm">
    <cfset stock_id_list = ValueList(products.stock_id)>
<cfelse>
	<cfset PRODUCTS.recordcount = 0>
</cfif>
        <cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
            SELECT TOP (1)  
                PRICE_CAT_ID, 
                PRICE_CAT
            FROM     
                EZGI_VIRTUAL_OFFER_PRICE_LIST
            WHERE        
                STATUS = 1
           	ORDER BY
            	PRICE_CAT_ID DESC
        </cfquery>

    
	<cfif not GET_PRICE_CAT.RECORDCOUNT>
		<script type="text/javascript">
			alert("Kurumsal Üyeyi Bir Fiyat Listesine Dahil Ediniz!");
			window.close();
		</script>
		<cfabort>
	</cfif>

<cfparam name="attributes.price_catid"  default="#GET_PRICE_CAT.PRICE_CAT_ID#">
<cfquery name="get_cat" datasource="#dsn3#">
        SELECT      
            PRODUCT_CATID, 
            HIERARCHY, 
            PRODUCT_CAT
        FROM            
            PRODUCT_CAT
        WHERE
            PRODUCT_CATID IN 
            (
                SELECT        
                    PRODUCT_CATID
                FROM            
                    PRODUCT
                GROUP BY 
                    PRODUCT_CATID
            )
            <cfif isdefined('attributes.list_order_no') and len(attributes.list_order_no)>
                AND       
                    LIST_ORDER_NO IN (#attributes.list_order_no#)
            </cfif>
        ORDER BY
            PRODUCT_CAT
</cfquery>
<cfparam name="attributes.maxrows" default="#SESSION.EP.MAXROWS#">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default=#products.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfif isdefined("attributes.list_order_no") and len(attributes.list_order_no)>
	<cfset url_str = "#url_str#&list_order_no=#attributes.list_order_no#">
</cfif>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
</cfif>
<cfif isdefined('attributes.product_catid') and len(attributes.product_catid)>
	<cfset url_str2 = "&product_catid=#attributes.product_catid#&product_cat=#PRODUCT_CAT#">
<cfelse>
	<cfset url_str2 =''>
</cfif>
<br />
<cfform name="price_cat" action="#request.self#?fuseaction=prod.popup_list_ezgi_virtual_offer_product#url_str##url_str2#" method="post">
	<input type="hidden" name="is_filter" id="is_filter" value="1">
	<cf_medium_list_search title='#lang_array_main.item [725]#'>
		<cf_medium_list_search_area>
			<table>
				<tr> 
					<td style="width:60px"><cf_get_lang_main no='48.Filtre'></td>
					<td style="width:120px"><cfinput type="text" name="keyword" maxlength="50" value="#attributes.keyword#" style="width:100px;"></td>
					<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
                    	<cfinput type="hidden" name="company_id" value="#attributes.company_id#">
                    </cfif>
                    <cfinput type="hidden" name="product_catid" id="product_catid" value="#attributes.product_catid#">
                    <cfinput type="hidden" name="product_cat" id="product_catid" value="#attributes.product_cat#">
                    <td style="width:230px">
                    	<select name="price_catid" id="price_catid" style="width:220px; height:20px">
                         	<cfoutput query="GET_PRICE_CAT">
								<option value="#GET_PRICE_CAT.PRICE_CAT_ID#" <cfif GET_PRICE_CAT.PRICE_CAT_ID eq attributes.price_catid> selected</cfif>>#GET_PRICE_CAT.PRICE_CAT#</option>
                           	</cfoutput>
                        </select>
                   	</td>
                    <td>
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td style="text-align:right;">
                    	<cf_wrk_search_button search_function='input_control()'>
                   	</td>
				</tr>       
			</table>
		</cf_medium_list_search_area>
	</cf_medium_list_search>
</cfform>
<cf_area width="200px">
	<table width="100%">
		<cfif get_cat.recordcount>
			<cfoutput query="get_cat">
            	<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="text-align:right;cursor: pointer;<cfif isdefined('attributes.product_catid') and attributes.product_catid eq PRODUCT_CATID>background-color:LightGray</cfif>" >
                	<td style="width:30px; text-align:right">#currentrow#&nbsp;</td>
                    <td width="80%">
                    	<a href="#request.self#?fuseaction=prod.popup_list_ezgi_virtual_offer_product&is_filter=1&list_order_no=#attributes.list_order_no#&product_catid=#PRODUCT_CATID#&product_cat=#PRODUCT_CAT#&keyword=#attributes.keyword#&price_catid=#attributes.price_catid#">
                    		&nbsp;#PRODUCT_CAT#
                    	</a>
                    </td>
                </tr>
            </cfoutput>
		</cfif>
  	</table>
</cf_area>
<cf_area width="500px">
<cf_medium_list>
	<thead>
		<tr>
			<th width="100px"><cf_get_lang_main no='106.Stok Kodu'></th>
			<th><cf_get_lang_main no='245.Ürün'></th>
         	<th width="75px"><cf_get_lang_main no='672.Fiyat'></th>
          	<th width="40px"><cf_get_lang_main no='265.Döviz'></th>
			<th width="25"><cf_get_lang_main no='224.Birim'></th>
		</tr>
	</thead>
	<tbody>
		<cfif products.recordcount>
		<cfoutput query="products" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 

            <cfif isdefined('SALES_PRICE_#STOCK_ID#')>
            	<cfset sales_price = Evaluate('SALES_PRICE_#STOCK_ID#')>
                <cfset money = Evaluate('MONEY_#STOCK_ID#')>
            <cfelse>
            	<cfset discount = 0>
            	<cfset sales_price = 0>
                <cfset money = session.ep.money>
            </cfif>
			<form name="product#currentrow#" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_session2module#url_str#">
				<input type="Hidden" name="product_id" id="product_id" value="#product_id#">
				<input type="Hidden" name="product_name" id="product_name" value="#product_name#">
			<tr height="20" title="#PRODUCT_DETAIL2#"  onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">           
				<td>#STOCK_CODE#</td>
				<cfscript>
					temp_prod_property=replace(PROPERTY,'"','','all');
					temp_prod_property=replace(temp_prod_property,"'","","all");
					temp_prod_property=replace(temp_prod_property,";","","all");
					temp_prod_name=replace(product_name,'"','','all');
					temp_prod_name=replace(temp_prod_name,"'","","all");
					temp_prod_name=replace(temp_prod_name,";","","all");
				</cfscript>

				<td style="cursor:pointer" class="tableyazi" onClick="javascript:opener.add_row(#STOCK_ID#,'#temp_prod_name#','#PRODUCT_CODE#','#PRODUCT_CODE_2#','#main_unit#','#product_id#','#price#','#money#','0','0','0');">#product_name# #property#</td> 
            	<td style="text-align:right">#Tlformat(price,2)#</td>
              	<td>#money#</td>
				<td width="15">#main_unit#</td>
			</tr>
		  </form>
		</cfoutput> 
		<cfelse>
			<tr> 
				<td colspan="8">
					<cfif attributes.is_filter>

						<cf_get_lang_main no='72.Kayıt Bulunamadı'>!
					<cfelse>
						<cf_get_lang_main no='289.Filtre Ediniz'>!
					</cfif>
				</td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
</cf_area>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="99%">
	  <tr> 
		<td>
			<cfset adres = "prod.popup_list_ezgi_virtual_offer_product&is_filter=1">
			<cfif len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isDefined('attributes.product_catid') and len(attributes.product_catid)>
				<cfset adres = "#adres#&product_catid=#attributes.product_catid#">
			</cfif>
			<cfif isDefined('attributes.product_cat') and len(attributes.product_cat)>
				<cfset adres = "#adres#&product_cat=#attributes.product_cat#">
			</cfif>

			<cfif isdefined("attributes.compid")>
				<cfset adres = "#adres#&compid=#attributes.compid#">
			</cfif>
			<cfif isdefined("attributes.price_catid")>
				<cfset adres = "#adres#&price_catid=#attributes.price_catid#">
			</cfif>
            <cfif isdefined("attributes.list_order_no") and len(attributes.list_order_no)>
				<cfset adres = "#adres#&list_order_no=#attributes.list_order_no#">
            </cfif>

            <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				<cfset adres = "#adres#&company_id=#attributes.company_id#">
            </cfif>
			<cf_pages page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#">
		  </td>
		  <!-- sil --><td style="text-align:right;"> <cfoutput> <cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> 
		  </td><!-- sil -->
	  </tr>
	</table>
</cfif>
<script type="text/javascript">
	price_cat.keyword.focus();
	function input_control()
	{
	<cfif not session.ep.our_company_info.unconditional_list>
		if (price_cat.keyword.value.length == 0 && price_cat.product_cat.value.length == 0 && (price_cat.employee_id.value.length == 0 || price_cat.employee.value.length == 0) && (price_cat.search_company_id.value.length == 0 || price_cat.search_company.value.length == 0) )
			{
				alert("<cf_get_lang_main no='1538.En Az Bir Alanda Filtre Etmelisiniz'> !");
				return false;
			}
		else return true;
	<cfelse>
		return true;
	</cfif>
	}
	function gonder(stock_id,product_name)
	{
		window.opener.add_ezgi_row(stock_id,product_name);
		self.close();
	}
</script>
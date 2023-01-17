
<cfinclude template="../query/get_invoice_rows.cfm">

<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.page" default=1>

<cfparam name="attributes.totalrecords" default=#get_invoice_rows.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>


<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
  <tr>
    <td class="headbold"><cfif isdefined("attributes.take")><cf_get_lang dictionary_id='32451.Alış Faturası'><cfelseif isdefined("attributes.sale")><cf_get_lang dictionary_id='32435.Satış Faturası'></cfif> / <cf_get_lang dictionary_id='57637.Seri No'></td>
    <td style="text-align:right;" valign="bottom" style="text-align:right;">
      <table>
        <cfform name="search_product" action="#request.self#?fuseaction=objects.popup_list_invoice_rows" method="post">
            <td><cf_get_lang dictionary_id='57460.Filtre'></td>
			<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
			<td>
			  <input type="text" name="start_date" id="start_date" value="<cfif isDefined("attributes.start_date") and len(attributes.start_date)><cfoutput>#dateformat(attributes.start_date,dateformat_style)#</cfoutput></cfif>" style="width:100px;">
		     <cf_wrk_date_image date_field="start_date">
			</td>
			<td>
			<cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="Sayi_Hatasi_Mesaj">
			</td>
            <td><cf_wrk_search_button></td>
          </tr>
        </cfform>
      </table>
    </td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
      <table cellpadding="2" cellspacing="1" border="0" width="100%" align="center">
        <tr class="color-header" height="22">
		<td width="150" class="form-title"><cf_get_lang dictionary_id='58133.Fatura No'></td>
		<td  width="150" class="form-title"><cf_get_lang dictionary_id='57658.Üye'></td>
		<td  class="form-title"><cf_get_lang dictionary_id='57742.Tarih'></td>
		<td  class="form-title"><cf_get_lang dictionary_id='57657.Ürün'></td>
		<td  class="form-title"><cf_get_lang dictionary_id='57635.Miktar'></td>
        </tr>
        <cfif get_invoice_rows.recordcount>
            <cfoutput query="get_invoice_rows" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
             <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                <td>#INVOICE_NUMBER#</td>
                <td>
				  <cfif len(partner_id)>  
				    #get_par_info(partner_id,0,0,1)#
				  <cfelseif len(consumer_id)> 
				     #get_cons_info(consumer_id,0,1)#
				  </cfif>
				</td>
			    <td>#dateformat(INVOICE_DATE,dateformat_style)#</td>
			    <td><a href="javascript://" class="tableyazi" onclick="gonder('#stock_id#','#stock_code#','#invoice_number#','#product_name#','#amount#','#dateformat(invoice_date,dateformat_style)#','#invoice_id#','#partner_id#','#company_id#','#consumer_id#','#purchase_sales#');">#PRODUCT_NAME#</a></td>
				<td>#amount#</td>
              </tr>
            </cfoutput>
          <cfelse>
          <tr>
            <td colspan="4" class="color-row"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!
			</td>
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
		<cfset adres=attributes.fuseaction>
		<cfif len(attributes.keyword)>
			<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isDefined('attributes.start_date') and len(attributes.start_date)>
			<cfset adres = "#adres#&start_date=#attributes.start_date#">
		</cfif>
		
	  	<cf_pages
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">
		</td>
      <!-- sil --><td style="text-align:right;" style="text-align:right;"><cfoutput> <cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif>

<script type="text/javascript">
 
	function gonder(s_id,s_code,i_number,p_name,amount,i_date,i_id,par_id,comp_id,con_id,pur_sale)
	{
		<cfoutput>
		<cfif isdefined("attributes.field_pur_sale")>
			opener.#attributes.field_pur_sale#.value = pur_sale;
		</cfif>
		<cfif isdefined("attributes.field_invoice_id")>
			opener.#attributes.field_invoice_id#.value = i_id;
		</cfif>
		<cfif isdefined("attributes.field_stock_code")>
			opener.#attributes.field_stock_code#.value = s_code;
		</cfif>
		<cfif isdefined("attributes.field_stock_id")>
			opener.#attributes.field_stock_id#.value = s_id;
		</cfif>
		<cfif isdefined("attributes.field_i_number")>
			opener.#attributes.field_i_number#.value = i_number;
		</cfif>
		<cfif isdefined("attributes.field_p_name")>
			opener.#attributes.field_p_name#.value = p_name;
		</cfif>
		<cfif isdefined("attributes.field_amount")>
			opener.#attributes.field_amount#.value = amount;
		</cfif>
		<cfif isdefined("attributes.field_i_date")>
			opener.#attributes.field_i_date#.value = i_date;
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

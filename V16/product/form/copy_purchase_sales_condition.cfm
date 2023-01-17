<cfinclude template="../query/get_paymethods.cfm">
<cfif attributes.type is 1>
  <cfinclude template="../query/get_purchase_prod_discount.cfm">
<cfelse>
  <cfinclude template="../query/get_sales_prod_discount.cfm">
</cfif>
<cfquery name="GET_COMPANIES" datasource="#dsn1#">
SELECT
	DISTINCT 
	POC.OUR_COMPANY_ID,
	OC.NICK_NAME
FROM
	#dsn_alias#.OUR_COMPANY AS OC,
	PRODUCT_OUR_COMPANY AS POC
WHERE
	POC.OUR_COMPANY_ID = OC.COMP_ID AND
	POC.OUR_COMPANY_ID <> #session.ep.company_id# AND
	POC.PRODUCT_ID = #attributes.pid#
ORDER BY
	OC.NICK_NAME
</cfquery>
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=product.emptypopup_copy_purchase_sales_condition">
  <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
    <tr class="color-border">
      <td>
        <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
          <tr class="color-list">
            <td class="headbold" height="35">&nbsp;<cf_get_lang dictionary_id='37650.Ürün İskontoları Kopyalama'></td>
          </tr>
          <tr class="color-row">
            <td valign="top">
              <table width="100%" border="0">
                <tr>
                  <td>
                    <table>
                      <cfif attributes.type is 1>
                        <cfset queryname = "GET_PURCHASE_PROD_DISCOUNT">
                        <cfset discount_id = GET_PURCHASE_PROD_DISCOUNT.C_P_PROD_DISCOUNT_ID>
                      <cfelse>
                        <cfset queryname = "GET_SALES_PROD_DISCOUNT">
                        <cfset discount_id = GET_SALES_PROD_DISCOUNT.C_S_PROD_DISCOUNT_ID>
                      </cfif>
                      <cfoutput query="#queryname#">
                        <input type="hidden" name="discount_id" id="discount_id" value="#discount_id#">
                        <input type="hidden" name="pid" id="pid" value="#attributes.pid#">
                        <tr class="txtbold">
                          <td width="150"><cf_get_lang dictionary_id='37442.Kopyalanacak Firma'></td>
                          <td>                            
							<select name="compid" id="compid" style="width:140px;">
								<cfloop query="GET_COMPANIES">
								<option value="#OUR_COMPANY_ID#">#NICK_NAME#</option>
								</cfloop>
							</select>
                          </td>
                        </tr>
                        <tr class="txtbold">
                          <td width="60"><cf_get_lang dictionary_id='37069.Kosul Tipi'></td>
                          <td>
                            <input type="hidden" name="purchase_sales" id="purchase_sales" value="#attributes.type#">
                            <cfif attributes.type is 1><cf_get_lang dictionary_id='58176.Alış'></cfif>
                            <cfif attributes.type is 2><cf_get_lang dictionary_id='57448.Satış'></cfif>
                          </td>
                        </tr>
                        <tr class="txtbold">
                          <td><cf_get_lang dictionary_id='57574.Firma'></td>
                          <td><input type="hidden" name="company_id" id="company_id" value="#company_id#">
                            <cfif Len(COMPANY_ID)>
                              <cfset attributes.COMPANY_ID = COMPANY_ID>
                              <cfinclude template="../query/get_company_name.cfm">
                              <cfif get_company_name.recordCount>
                                <cfset company_name= get_company_name.NICKNAME>
                              <cfelse>
                                <cfset company_name= "">
                              </cfif>
                            <cfelse>
                              <cfset company_name= "">
                            </cfif>
                            <input type="text" name="company_name"  id="company_name" style="width:140px;" value="#company_name#">
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&select_list=2&field_comp_name=form_basket.company_name&field_comp_id=form_basket.company_id','project');"><img src="/images/plus_thin.gif" border="0" title="" align="absmiddle"></a>&nbsp; </td>
                        </tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id='57501.Baslangic'> *</td>
							<td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Baslangic Tarihi Girmelisiniz'></cfsavecontent>
							<cfif len(start_date)>								
								<cfinput type="text" name="start_date" value="#dateformat(start_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" required="yes" style="width:140px;">
							<cfelse>
								<cfinput type="text" name="start_date" value="" maxlength="10" validate="#validate_style#" message="#message#" required="yes" style="width:140px;">
							</cfif>
							<cf_wrk_date_image date_field="start_date"></td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id='57502.Bitiş Tarihi'> </td>
							<td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58491.Bitiş Tarihi girmelisiniz'></cfsavecontent>
							<cfif len(finish_date)>								
								<cfinput type="text" name="finish_date" value="#dateformat(finish_date,dateformat_style)#" maxlength="10" message="#message#" required="yes" style="width:140px;">
							<cfelse>
								<cfinput type="text" name="finish_date" value="" maxlength="10" validate="#validate_style#" message="#message#" style="width:140px;">
							</cfif>
							<cf_wrk_date_image date_field="finish_date"></td>
						</tr>
						<tr class="txtbold">
                          <td><cf_get_lang dictionary_id='57641.İndirim'> 1 %</td>
                          <td><input type="text" name="discount1" id="discount1" value="#TLFormat(discount1)#" style="width:140px;" onKeyup='return(FormatCurrency(this,event));'></td>
                        </tr>
						<tr class="txtbold">
                          <td><cf_get_lang dictionary_id='57641.İndirim'> 2 %</td>
                          <td><input type="text" name="discount2" id="discount2" value="#TLFormat(discount2)#" style="width:140px;" onKeyup='return(FormatCurrency(this,event));'></td>
                        </tr>
                        <tr class="txtbold">
                          <td><cf_get_lang dictionary_id='57641.İndirim'> 3 %</td>
                          <td><input type="text" name="discount3" id="discount3" value="#TLFormat(discount3)#" style="width:140px;" onKeyup='return(FormatCurrency(this,event));'></td>
                        </tr>
                        <tr class="txtbold">
                          <td><cf_get_lang dictionary_id='57641.İndirim'> 4 %</td>
                          <td><input type="text" name="discount4" id="discount4" value="#TLFormat(discount4)#" style="width:140px;" onKeyup='return(FormatCurrency(this,event));'></td>
                        </tr>
                        <tr class="txtbold">
                          <td><cf_get_lang dictionary_id='57641.İndirim'> 5 %</td>
                          <td><input type="text" name="discount5" id="discount5" value="#TLFormat(discount5)#" style="width:140px;" onKeyup='return(FormatCurrency(this,event));'></td>
                        </tr>
                        <tr class="txtbold">
                          <td><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></td>
                          <td>
						  	<cfset paymethodid = paymethod_id>
							<select name="paymethod_id" id="paymethod_id" style="width:140px;">
                              <cfloop query="get_paymethods">
                                <option value="#get_paymethods.paymethod_id#"  <cfif paymethodid is get_paymethods.paymethod_id>selected</cfif>>#get_paymethods.paymethod#
                              </cfloop>
                            </select></td>
                        </tr>
                        <tr class="txtbold">
                          <td><cf_get_lang dictionary_id='37072.Teslim Süresi'> (<cf_get_lang dictionary_id='57490.Gün'>)</td>
                          <td><input type="text" name="delivery_dateno" id="delivery_dateno" style="width:140px;" value="#TLFormat(delivery_dateno)#">
                          </td>
                        </tr>
						<tr>
						<td colspan="2" class="txtboldblue">
						<cf_get_lang dictionary_id='57483.Kayit'> :
						<cfif isdefined("GET_PURCHASE_PROD_DISCOUNT.record_emp") and len(GET_PURCHASE_PROD_DISCOUNT.record_emp)>
							<cfif len(GET_PURCHASE_PROD_DISCOUNT.record_emp)>#get_emp_info(GET_PURCHASE_PROD_DISCOUNT.record_emp,0,0)#</cfif>
							- <cfif len(GET_PURCHASE_PROD_DISCOUNT.record_date)>#dateformat(GET_PURCHASE_PROD_DISCOUNT.record_date,dateformat_style)#</cfif>
						<cfelse>
							<cfif len(GET_SALES_PROD_DISCOUNT.record_emp)>#get_emp_info(GET_SALES_PROD_DISCOUNT.record_emp,0,0)#</cfif>
							- <cfif len(GET_SALES_PROD_DISCOUNT.record_date)>#dateformat(GET_SALES_PROD_DISCOUNT.record_date,dateformat_style)#</cfif>
						</cfif>
						</td>
						</tr>
						<cfif GET_COMPANIES.RecordCount>
						<tr>
						  <td>&nbsp;</td>
						  <td height="35"><cf_workcube_buttons is_upd='0' add_function='unformat_fields()'></td>
						</tr>
						</cfif>
                      </cfoutput>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</cfform>
<script type="text/javascript">
	/*function f1(fld) javascript diline çevir 123.123.123.123,12 -> 123123123123.12
	{
		var temp_str = fld.toString();
		while (temp_str.indexOf('.') >= 0)
			{
			yer = temp_str.indexOf('.');
			temp_str = temp_str.substr(0,yer) + '' + temp_str.substr(yer+1, temp_str.length-yer-1);
			}
		if (temp_str.indexOf(',') >= 0)
			{
			yer = temp_str.indexOf(',');
			temp_str = temp_str.substr(0,yer) + '.' + temp_str.substr(yer+1, temp_str.length-yer-1);
			}
		return temp_str;
	}*/
	
	/* function f2(fld)bizim dilimize çevirir 123123123123.12 -> 123123123123,12
	{
		var temp_str = fld.toString();
		if (temp_str.indexOf('.') >= 0)
			{
			yer = temp_str.indexOf('.');
			temp_str = temp_str.substr(0,yer) + ',' + temp_str.substr(yer+1, temp_str.length-yer-1);
			}
		return temp_str;
	}
	*/
	function unformat_fields()
	{

		form_basket.discount1.value = filterNum(form_basket.discount1.value);
		form_basket.discount2.value = filterNum(form_basket.discount2.value);
		form_basket.discount3.value = filterNum(form_basket.discount3.value);
		form_basket.discount4.value = filterNum(form_basket.discount4.value);
		form_basket.discount5.value = filterNum(form_basket.discount5.value);

		if(form_basket.discount1.value > 100 || form_basket.discount1.value < 0){alert('<cf_get_lang dictionary_id='37744.İskonto 0 ile 100 arasında olmalıdır'>!');return false;}
		if(form_basket.discount2.value > 100 || form_basket.discount2.value < 0){alert('<cf_get_lang dictionary_id='37744.İskonto 0 ile 100 arasında olmalıdır'>!');return false;}
		if(form_basket.discount3.value > 100 || form_basket.discount3.value < 0){alert('<cf_get_lang dictionary_id='37744.İskonto 0 ile 100 arasında olmalıdır'>!');return false;}
		if(form_basket.discount4.value > 100 || form_basket.discount4.value < 0){alert('<cf_get_lang dictionary_id='37744.İskonto 0 ile 100 arasında olmalıdır'>!');return false;}
		if(form_basket.discount5.value > 100 || form_basket.discount5.value < 0){alert('<cf_get_lang dictionary_id='37744.İskonto 0 ile 100 arasında olmalıdır'>!');return false;}
		
		return true;
	}
</script>


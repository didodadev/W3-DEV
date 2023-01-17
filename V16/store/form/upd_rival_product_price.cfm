<cfinclude template="../query/get_rival_price.cfm">
<cfset attributes.pid = get_rival_price.product_id>
<cfinclude template="../query/get_rivals.cfm">
<cfset attributes.prm_money=1>
<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_unit.cfm">
<cfset attributes.product_unit_id=get_rival_price.unit_id >
<cfinclude template="../query/get_product_unit.cfm">
<cfsavecontent variable="txt">
    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=store.popup_form_add_rival_price"><img src="/images/plus1.gif" title="<cf_get_lang_main no ='170.Ekle'>"></a>
</cfsavecontent>
<cf_popup_box title="#getLang('store',175)#" right_images="#txt#">
  <cfform action="#request.self#?fuseaction=store.emptypopup_upd_rival_price" method="post" name="price" >
    <input type="hidden" name="pr_id" id="pr_id" value="<cfoutput>#PR_ID#</cfoutput>">
    <input type="hidden" name="stock_id" id="stock_id" value="">
        <table border="0">
            <tr> 
                <td><cf_get_lang_main no='245.Ürün'></td>
                <td colspan="3" nowrap> <input type="hidden" name="pid" id="pid" value="<cfif isdefined("pid")><cfoutput>#pid#</cfoutput></cfif>"  > 
                    <input type="Text" style="width:200;" name="txt_product" id="txt_product" value="<cfoutput>#get_rival_price.PRODUCT_NAME#</cfoutput>"> 
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=price.stock_id&product_id=price.pid&field_name=price.txt_product','list');"  > 
                    <img src="/images/plus_thin.gif" align="absmiddle" border="0"></a> 
                </td>
            </tr>
            <tr> 
                <td><cf_get_lang_main no='1367.Rakip'></td>
                <td colspan="3">
                    <select name="r_id" id="r_id" style="width:198px;">
						<cfoutput query="get_rivals"> 
                            <option value="#R_ID#" <cfif get_rival_price.r_id eq r_id>selected</cfif>>#rival_name#</option>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <tr> 
                <td width="75"><cf_get_lang no='181.Devam'></td>
                <td colspan="3">
                    <cfsavecontent variable="message"> <cf_get_lang no='167.Rakip Fiyat girmelisiniz'>!</cfsavecontent> 
                    <cfinput type="text" name="price" value="#get_rival_price.price#" style="width:148px;" required="yes" message="#message#" validate="float" passThrough = "onkeyup=""return(FormatCurrency(this,event));""">
                    <select name="money" id="money" style="width:50;">
						<cfoutput query="get_moneys"> 
                            <option value="#money#" <cfif get_rival_price.money is money>selected</cfif>>#money#</option>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <tr> 
                <td><cf_get_lang no='187.Ürün Birimi'></td>
                <td colspan="3">
                    <select name="UNIT_ID" id="UNIT_ID" style="width:200;">
                        <cfoutput query="GET_UNIT"> 
                          <option value="#UNIT_ID#" <cfif GET_PRODUCT_UNIT.MAIN_UNIT_ID eq UNIT_ID >Selected</cfif> >#UNIT#</option>
                        </cfoutput> 
                    </select>
                </td>
            </tr>
            <tr> 
                <td><cf_get_lang_main no='243.Başlama T'></td>
                <td><cfsavecontent variable="message"> <cf_get_lang_main no='326.Başlama T girmelisiniz'></cfsavecontent> 
                    <cfinput value="#dateformat(get_rival_price.startdate,dateformat_style)#" required="Yes" validate="#validate_style#" message="#message#" type="text" name="startdate" style="width:65px;" maxlength="10"> 
                    <cf_wrk_date_image date_field="startdate">
                </td>
                <td><cf_get_lang_main no='202.Bitiş T'></td>
                <td><cfif len(get_rival_price.finishdate)>
					<cfset date2=dateformat(get_rival_price.finishdate,dateformat_style)>
                    <cfelse>
                    <cfset date2="">
                    </cfif> <cfinput value="#date2#" validate="#validate_style#" type="text" name="finishdate" style="width:65px;" maxlength="10" message="Tarih Formatını Doğru Girmelisiniz !"> 
               	    <cf_wrk_date_image date_field="finishdate">
                </td>
            </tr>
        </table>
      <cf_popup_box_footer> 
          <cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=store.emptypopup_del_rival_price&pr_id=#pr_id#'>
      </cf_popup_box_footer>
  </cfform>
</cf_popup_box>
<script type="text/javascript">
function kontrol()
	{
	if(document.price.txt_product.value.length == 0)
	{
		window.alert("<cf_get_lang no='180.Ürün girmelisiniz'>!");
		return false;
	}
	/*
	if(document.price.money.value == 0)
	{
		window.alert("<cf_get_lang no='149.Parabirimi Girmelisiniz'>");
		return false;
	}
	*/
	price.price.value = filterNum(price.price.value);
	return true;
	}
</script>

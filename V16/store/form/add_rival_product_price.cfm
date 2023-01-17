<cfinclude template="../query/get_rivals.cfm">
<cfset attributes.prm_money=1>
<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_unit.cfm">
<cf_popup_box title="#getLang('store',168)#">
    <cfform action="#request.self#?fuseaction=store.emptypopup_add_rival_product_price" method="post" name="price" >
    <table>
        <tr>
            <td width="90"><cf_get_lang_main no='245.Ürün'>*</td>
            <td nowrap>
                <input type="hidden" name="pid" id="pid" value="<cfif isDefined("pid")>#pid#</cfif>">
                <input type="hidden" name="stock_id" id="stock_id" value="<cfif isDefined("stock_id")>#stock_id#</cfif>">
                <input type="Text"   style="width:200px;" name="txt_product" id="txt_product"  value="" readonly="yes">
                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=price.stock_id&product_id=price.pid&field_name=price.txt_product','list');"  > <img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang no='114.Rakip'>*</td>
            <td>
                <select name="r_id" id="r_id" style="width:200Px;">
					<cfoutput query="get_rivals">
                      <option value="#R_ID#">#rival_name# 
                    </cfoutput>
                </select>
            </td>
        </tr>
        <tr>
            <td width="100"><cf_get_lang no='20.Rakip Fiyat Ekle'>*</td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang no='167.Rakip Fiyat girmelisiniz'></cfsavecontent>
                <cfinput type="text" name="price"  required="yes" message="#message#" validate="float" passThrough = "onkeyup=""return(FormatCurrency(this,event));""" style="width:140px;">
                <select name="money" id="money" style="width:58px;">
					<cfoutput query="get_moneys">
                      <option value="#money#">#money# </option>
                    </cfoutput>
                </select>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='224.Birim'></td>
            <td>
                <select name="UNIT_ID" id="UNIT_ID" style="width:65px;">
					<cfoutput query="GET_UNIT">
                      <option value="#UNIT_ID#">#UNIT#</option>
                    </cfoutput>
                </select>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='243.Başlangıç Tarihi'>*</td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang_main no='326.Başlama Tarihi girmelisiniz'></cfsavecontent>
                <cfinput required="Yes" validate="#validate_style#" message="#message#" type="text" name="startdate" style="width:65px;" maxlength="10">
                <cf_wrk_date_image date_field="startdate">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='288.Bitiş Tarihi'></td>
            <td>
                <cfinput  validate="#validate_style#"  type="text" name="finishdate" style="width:65px;" maxlength="10">
                <cf_wrk_date_image date_field="finishdate">
            </td>
        </tr>
    </table>
    <cf_popup_box_footer><cf_workcube_buttons is_upd='0' add_function='unformat_fields()'></cf_popup_box_footer>
    </cfform>   
</cf_popup_box>
<script type="text/javascript">

	function unformat_fields()
	{
		if(document.price.txt_product.value.length == 0)
		{
			window.alert("<cf_get_lang no='180.Ürün girmelisiniz'>!");
			return false;
		}
		if(document.price.r_id.value.length == 0)
		{
			window.alert("<cf_get_lang no='114.Rakip'>!");
			return false;
		}
		if(document.price.money.value == 0)
		{
			window.alert("Para birimi Girmelisiniz..");
			return false;
		}
		price.price.value = filterNum(price.price.value);
		return true;
	}
</script>


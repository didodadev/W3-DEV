<cfquery name="GET_PRICE_CAT" datasource="#dsn3#">
	SELECT 
		* 
	FROM 
		PRICE_CAT
	WHERE 
		BRANCH LIKE '%,#listgetat(session.ep.user_location,2,'-')#,%'
</cfquery>
<cfif not GET_PRICE_CAT.recordcount>
	<script type="text/javascript">
		alert("Şube Fiyat Listesi eksik !");
		window.close();
	</script>
	<cfabort>
</cfif>

<cfinclude template="../query/get_product_name.cfm">
<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_product_unit.cfm">
<cfif len(GET_PRODUCT.PROD_COMPETITIVE)>
	<cfset attributes.COMPETITIVE_ID=GET_PRODUCT.PROD_COMPETITIVE>
	<cfinclude template="../query/get_competitive_name.cfm">
	<cfset COMPETITIVE_NAME=GET_COMPETITIVE_NAME.COMPETITIVE>
<cfelse>
	<cfset COMPETITIVE_NAME="">
</cfif>
<cf_popup_box title="#getLang('store',178)#"><!--Yeni Fiyat Önerisi-->
    <cfform name="price" action="#request.self#?fuseaction=store.emptypopup_add_price_request" method="post" onsubmit="return (unformat_fields());">
        <input type="hidden" name="active_company" id="active_company" value="<cfoutput>#session.ep.company_id#</cfoutput>"> 
        <input type="hidden" name="active_year" id="active_year" value="<cfoutput>#session.ep.period_year#</cfoutput>"> 
        <input type="Hidden" name="pid" id="pid" value="<cfoutput>#attributes.pid#</cfoutput>">
        <input type="Hidden" name="satis_kdv" id="satis_kdv" value="<cfoutput>#GET_PRODUCT.TAX#</cfoutput>">
        <table>
            <tr>
                <td width="100"><cf_get_lang_main no='245.Ürün'></td>
                <td class="txtbold"><cfoutput>#get_product.product_name# - #COMPETITIVE_NAME#</cfoutput></td>
            </tr>
            <input type="hidden" name="price_catid" id="price_catid" value="<cfoutput>#GET_PRICE_CAT.PRICE_CATID#</cfoutput>"><!--- #attributes.price_catid# --->
            <tr> 
                <td><cf_get_lang no='187.Ürün Birimi'>*</td>
                <td colspan="2">
                <select name="unit_id" id="unit_id" style="width:195px;">
					<cfoutput query="get_product_unit"> 
                      <option value="#PRODUCT_UNIT_ID#">#add_unit#</option> 
                    </cfoutput> 
                </select>
                </td>
            </tr> 
            <tr> 
                <td><cf_get_lang no='79.KDV Dahil'></td>
                <td colspan="2"><input type="checkbox" name="is_kdv" id="is_kdv" value="1"></td>
            </tr> 
            <tr> 
                <td><cf_get_lang no='178.Yeni Fiyat'>*</td>
                <td> 
                <cfsavecontent variable="message"><cf_get_lang no='173.Yeni Fiyat girmelisiniz'></cfsavecontent>
                <cfinput type="text" name="price" style="width:195px;" required="yes" message="#message#" passThrough = "onkeyup=""return(FormatCurrency(this,event));""" class="moneybox">
                </td>
            </tr>
            <tr>
                <td><cf_get_lang_main no='77.Para Br'>*</td>
                <td>
                    <select name="money" id="money" style="width:195px;">
                      <option value="0"><cf_get_lang_main no='322.Seçiniz'> </option>
                      <cfoutput query="get_moneys"> 
                        <option value="#get_moneys.money#" <cfif get_moneys.money is session.ep.money>selected</cfif>>#get_moneys.money# </option>
                      </cfoutput> 
                    </select>
                </td>
            </tr>
            <tr> 
                <td><cf_get_lang_main no='89.Başlama'>*</td>
                <td> 
                    <cfsavecontent variable="message"><cf_get_lang_main no='326.Başlama girmelisiniz'></cfsavecontent>
                    <cfinput required="Yes" validate="#validate_style#" message="#message#" type="text" name="startdate" style="width:78px;"  >
                    <cf_wrk_date_image date_field="startdate">
                    <select name="start_clock" id="start_clock" style="width:50px;">
                      <option value="0" selected><cf_get_lang_main no='79.Saat'></option>
                      <cfloop from="1" to="23" index="i">
                        <cfoutput><option value="#i#">#i#</option></cfoutput>
                      </cfloop>
                    </select>
                    <select name="start_min" id="start_min" style="width:40px;">
                      <option value="00" selected>00</option>
                      <option value="05">05</option>
                      <option value="10">10</option>
                      <option value="15">15</option>
                      <option value="20">20</option>
                      <option value="25">25</option>
                      <option value="30">30</option>
                      <option value="35">35</option>
                      <option value="40">40</option>
                      <option value="45">45</option>
                      <option value="50">50</option>
                      <option value="55">55</option>
                    </select>
                </td>
            </tr>
            <tr> 
                <td valign="top"><cf_get_lang no='186.Gerekçe'></td>
                <td><textarea name="REASON" id="REASON" style="width:195px; height:80px;"></textarea></td>
            </tr>
        </table>
      <cf_popup_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_popup_box_footer>
    </cfform>   
</cf_popup_box>
<script type="text/javascript">
function kontrol()
{
	if(document.price.money.value == 0)
	{
		window.alert("<cf_get_lang no='149.Para birimi Girmelisiniz'>");
		return false;
	}
	if(document.price.price_catid.value == 0)
	{
		window.alert("<cf_get_lang no='148.Fiyat Listesi Seçmelisiniz'>");
		return false;
	}
	return true;
}
function unformat_fields()
{
	price.price.value = filterNum(price.price.value);
}
</script>

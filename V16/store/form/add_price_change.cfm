<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
	SELECT		
		PRICE_CATID,
		STARTDATE
	FROM 
		PRICE_CAT
	WHERE 
		BRANCH LIKE '%,#listgetat(session.ep.user_location,2,'-')#,%'
</cfquery>
<cfif not get_price_cat.recordcount>
	<script type="text/javascript">
		alert("Şube Fiyat Kategorisi eksik !");
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
<cf_popup_box title="#getLang('store',185)#">
<cfform name="price" method="post"action="#request.self#?fuseaction=store.emptypopup_add_price" onsubmit="return (unformat_fields());">
    <table>
        <input type="hidden" name="active_company" id="active_company" value="<cfoutput>#session.ep.company_id#</cfoutput>"> 
        <input type="hidden" name="price_catid" id="price_catid" value="<cfoutput>#get_price_cat.price_catid#</cfoutput>">
        <input type="hidden" name="satis_kdv" id="satis_kdv" value="<cfoutput>#get_product.tax#</cfoutput>">
        <input type="hidden" name="active_year" id="active_year" value="<cfoutput>#session.ep.period_year#</cfoutput>">
        <input type="hidden" name="product_name" id="product_name" value="<cfoutput>#get_product.product_name#</cfoutput>">
        <tr>
            <td width="80" height="22"><cf_get_lang_main no='245.Ürün'></td>
            <td><cfoutput>#get_product.product_name# - #COMPETITIVE_NAME#</cfoutput></td>
        </tr>
        <tr>
            <td><cf_get_lang no='187.Ürün Birimi'></td>
            <td>
                <select name="unit_id" id="unit_id" style="width:153px;">
                <cfoutput query="get_product_unit"> 
                    <option value="#PRODUCT_UNIT_ID#">#add_unit# </option>
                </cfoutput> 
                </select>
                <input type="checkbox" name="is_kdv" id="is_kdv" value="1" checked> <cf_get_lang no='79.KDV Dahil'>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang no='185.Yeni Fiyat'></td>
            <td>
                <input type="Hidden" name="pid" id="pid" value="<cfoutput>#url.pid#</cfoutput>">
                <cfsavecontent variable="message"><cf_get_lang no='173.Yeni Fiyat girmelisiniz'></cfsavecontent>
                <cfinput type="text" name="price" style="width:110px;" required="yes" message="#message#" passThrough = "onkeyup=""return(FormatCurrency(this,event));""" class="moneybox">
                <select name="money" id="money" style="width:40px;">
                    <cfoutput query="get_moneys"> 
                    <option value="#get_moneys.money#" <cfif get_moneys.money is session.ep.money>selected</cfif>>#get_moneys.money# </option>
                    </cfoutput> 
                </select>
            </td>
        </tr>
        <cfif isdefined("attributes.price_catid") and (attributes.price_catid neq -1) and  (attributes.price_catid neq -2)>				  
        <cfset attributes.pcat_id = attributes.price_catid>
        <cfinclude template="../../product/query/get_price_cat_rows.cfm"> 
        <tr> 
            <td><cf_get_lang_main no='89.Başlama'></td>
            <td> 
                <cfsavecontent variable="message"><cf_get_lang_main no='326.Başlama girmelisiniz'></cfsavecontent>
                <cfinput required="Yes" validate="#validate_style#" maxlength="10" message="#message#" type="text" name="startdate" style="width:65px;" value="#dateformat(now(),dateformat_style)#">
                <cf_wrk_date_image date_field="startdate">
                <select name="start_clock" id="start_clock" style="width:50px;">
                    <option value="0" selected><cf_get_lang_main no='79.Saat'></option>
                    <cfloop from="1" to="23" index="i">
                        <cfoutput><option value="#i#" <cfif hour(get_price_Cat.startdate) eq i> selected</cfif>>#i#</option></cfoutput>
                    </cfloop>
                </select>
                <select name="start_min" id="start_min" style="width:40px;">
                    <option value="00"<cfif minute(get_price_Cat.startdate) eq 0> selected</cfif>>00</option>
                    <option value="05"<cfif minute(get_price_Cat.startdate) eq 5> selected</cfif>>05</option>
                    <option value="10"<cfif minute(get_price_Cat.startdate) eq 10> selected</cfif>>10</option>
                    <option value="15"<cfif minute(get_price_Cat.startdate) eq 15> selected</cfif>>15</option>
                    <option value="20"<cfif minute(get_price_Cat.startdate) eq 20> selected</cfif>>20</option>
                    <option value="25"<cfif minute(get_price_Cat.startdate) eq 25> selected</cfif>>25</option>
                    <option value="30"<cfif minute(get_price_Cat.startdate) eq 30> selected</cfif>>30</option>
                    <option value="35"<cfif minute(get_price_Cat.startdate) eq 35> selected</cfif>>35</option>
                    <option value="40"<cfif minute(get_price_Cat.startdate) eq 40> selected</cfif>>40</option>
                    <option value="45"<cfif minute(get_price_Cat.startdate) eq 45> selected</cfif>>45</option>
                    <option value="50"<cfif minute(get_price_Cat.startdate) eq 50> selected</cfif>>50</option>
                    <option value="55"<cfif minute(get_price_Cat.startdate) eq 55> selected</cfif>>55</option>
                </select>
            </td>
        </tr>
        <cfelse>
        <tr> 
            <td><cf_get_lang_main no='89.Başlama'></td>
            <td> 
                <cfsavecontent variable="message"><cf_get_lang_main no='326.Başlama girmelisiniz'></cfsavecontent>
                <cfinput required="Yes" validate="#validate_style#" message="#message#" type="text" name="startdate" style="width:80px;">
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
        </cfif>
        <tr>
            <td><cf_get_lang_main no='1447.süreç'></td>
            <td>
                <cf_workcube_process is_upd='0' process_cat_width='154' is_detail='0'>
            </td>
        </tr>
    </table>
    <cf_popup_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_popup_box_footer>
</cfform>   
</cf_popup_box>
<script type="text/javascript">
	function unformat_fields()
	{
		price.price.value = filterNum(price.price.value);
	}
	function kontrol()
	{
		if(process_cat_control()==false)
			return false;
		if(document.price.money.value == 0)
		{
			window.alert("<cf_get_lang no='149.Parabirimi Girmelisiniz'>");
			return false;
		}
		
		if(document.price.price_catid.value == 0)
		{
			window.alert("<cf_get_lang no='148.Fiyat Listesi Seçmelisiniz'>");
			return false;
		}
		return true;
	}	
</script>

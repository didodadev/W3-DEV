<cfset module_name="product">
<cfset var_="upd_purchase_basket">
<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_consumer_cat.cfm">
<cfinclude template="../query/get_action_stages.cfm">
<cfquery name="GET_PRICE_CATS" datasource="#dsn#_#attributes.compid#">
	SELECT * FROM PRICE_CAT ORDER BY PRICE_CAT
</cfquery>
<cfinclude template="../query/get_catalog_promotion_detail.cfm">
<cfif len(get_catalog_detail.valid_emp)>
	<cfquery name="GET_EMP2" datasource="#DSN#">
		SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_catalog_detail.valid_emp#
	</cfquery>
<cfelseif len(get_catalog_detail.validator_position_code)>
	<cfquery name="GET_EMP_POSITION" datasource="#DSN#">
		SELECT EMPLOYEE_ID ,EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_ID = #get_catalog_detail.validator_position_code#
	</cfquery>
</cfif>
<cfif len(get_catalog_detail.camp_id)>
	<cfquery name="GET_CAMPAIGN" datasource="#DSN3#">
		SELECT CAMP_ID,CAMP_HEAD,CAMP_FINISHDATE,CAMP_STARTDATE FROM CAMPAIGNS WHERE CAMP_ID = #get_catalog_detail.camp_id#
	</cfquery>
</cfif>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=product.emptypopup_add_catalog_promotion" onsubmit="return (unformat_fields())">
<cfoutput>
<input type="hidden" name="compid" id="compid" value="#attributes.compid#">
<input type="hidden" name="visible" id="visible" value="0">
<input type="hidden" name="var_" id="var_" value="#var_#">
<input type="hidden" name="module_name" id="module_name" value="#module_name#">
<input type="hidden" name="catalog_id" id="catalog_id" value="#get_catalog_detail.catalog_id#">
</cfoutput>
<table class="dph">
    <tr>
        <td class="dpht"><a href="javascript:gizle_goster_ikili('copy_catalog_promotion','copy_catalog_promotion_bask');">&raquo;</a><cf_get_lang dictionary_id='37302.Aksiyon Planlama Aracı'> (<cf_get_lang dictionary_id ='37837.Şirkete Kopyala'>)
    </tr>
</table>
<cf_basket_form id="copy_catalog_promotion">
    <table>
        <tr>
            <td>
                <table>
                    <tr>
                        <td width="125"><cf_get_lang dictionary_id='37210.Aksiyon'> *</td>
                        <td width="220">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='37399.Aksiyon girmelisiniz'></cfsavecontent>
                            <cfinput required="Yes" message="#message#" type="text" name="CATALOG_HEAD" style="width:171px;" value="">
                        </td>
                        <td width="65"><cf_get_lang dictionary_id='57482.Aşama'></td>
                        <td width="200">
                            <select name="stage_id" id="stage_id" style="width:180px;">
                            <cfoutput query="get_action_stages">
                                <option value="#stage_id#">#stage_name#</option>
                            </cfoutput>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='57446.Kampanya'></td>
                        <td class="txtbold">
                            <input type="hidden" name="camp_id" id="camp_id" value="">
                            <input type="text" name="camp_name" id="camp_name" value="" style="width:171px;">
                            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_campaigns&field_id=form_basket.camp_id&field_name=form_basket.camp_name&compid=#attributes.compid#</cfoutput>','list');"><img border="0" src="/images/plus_thin.gif" align="absmiddle"></a>	 
                        </td>
                        <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
                        <td rowspan="3" valign="top"><textarea name="DETAIL" id="DETAIL" style="width:180px;height:70px;"><cfoutput>#get_catalog_detail.catalog_detail#</cfoutput></textarea></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='37119.Geçerlilik Tarihi'> *</td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='37398.Geçerlilik Tarihi girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="startdate" value="" required="yes" validate="#validate_style#" message="#message#" style="width:70px;">
                            <cf_wrk_date_image date_field="startdate"> / 
                            <cfinput  type="text" name="finishdate" value="" required="Yes" validate="#validate_style#" message="#message#" style="width:70px;">
                            <cf_wrk_date_image date_field="finishdate">
                        </td>
                        <td colspan="2">&nbsp;</td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='37213.Kondüsyon Tarihi'> *</td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='37400.Kondüsyon Tarihi girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="kondusyon_date" value="" required="Yes" validate="#validate_style#" message="#message#" style="width:70px;">
                            <cf_wrk_date_image date_field="kondusyon_date"> /
                            <cfinput type="text" name="kondusyon_finish_date" value="" required="Yes" validate="#validate_style#" message="#message#" style="width:70px;">
                            <cf_wrk_date_image date_field="kondusyon_finish_date">
                        </td>
                        <td colspan="2">&nbsp;</td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='57500.Onay'></td>
                        <td>
                            <input type="hidden" name="VALIDATOR_POSITION_CODE" id="VALIDATOR_POSITION_CODE" value="<cfoutput>#get_catalog_detail.validator_position_code#</cfoutput>">
                            <input type="text" name="VALIDATOR" id="VALIDATOR" value="<cfoutput><cfif len(get_catalog_detail.validator_position_code)>#get_emp_info(get_catalog_detail.validator_position_code,1,0)#</cfif></cfoutput>" style="width:171px;">
                            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions</cfoutput>&field_id=form_basket.VALIDATOR_POSITION_CODE&field_name=form_basket.VALIDATOR','list');"> <img border="0" src="/images/plus_thin.gif" align="absmiddle"></a>
                        </td>
                        <td colspan="2">&nbsp;</td>
                    </tr>
                </table>
           </td>
           <td valign="top">
               	  <table>
                        <tr>
                            <td><cf_get_lang dictionary_id='37028.Fiyat Listeleri'></td>
                            <td>
                            <cf_multiselect_check 
                             name="PRICE_CATS"
                                option_name="price_cat"
                                option_value="price_catid"
                                query_name="get_price_cats"
                                width="250">
                            </td>
                       </tr>
                       <tr>
                            <td><cf_get_lang dictionary_id ='37798.Kurumsal Kategoriler'></td>
                            <td>
                            <cf_multiselect_check 
                                name="COMPANYCAT_ID"
                                option_name="companycat"
                                option_value="companycat_id"
                                query_name="get_companycat"
                                width="250">
                            </td>
                       </tr>
                       <tr>
                          <td><cf_get_lang dictionary_id ='37799.Bireysel Kategoriler'></td>
                          <td>
                            <cf_multiselect_check 
                                name="CONSCAT_ID"
                                option_name="conscat"
                                option_value="conscat_id"
                                query_name="get_consumer_cat"
                                width="250">
                          </td>
                       </tr>
                  </table>
             </td>
        </tr>
    </table>
    <cf_basket_form_button><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_basket_form_button>
</cf_basket_form>
<cf_basket id="copy_catalog_promotion_bask">
	<cfinclude template="../display/basket_purchase.cfm">
</cf_basket>
</cfform> 
<script type="text/javascript">
function check_all(deger)
{
	<cfif get_price_cats.recordcount gt 1>
		for(i=0; i<form_basket.PRICE_CATS.length; i++)
			form_basket.PRICE_CATS[i].checked = deger;
	<cfelseif get_price_cats.recordcount eq 1>
		form_basket.PRICE_CATS.checked = deger;
	</cfif>
}
function kontrol()
{
	x = (250 - form_basket.DETAIL.value.length);
	if ( x < 0)
	{ 
		alert ("<cf_get_lang dictionary_id='57629.Açıklama '>"+ ((-1) * x) +"<cf_get_lang dictionary_id='29538.Karakter Uzun'>  !");
		return false;
	}

	temp1=0;
	<cfif get_price_cats.recordcount gt 1>
		for(i=0;i<form_basket.PRICE_CATS.length;i++)
			if (form_basket.PRICE_CATS[i].checked==1)
				temp1 = 1;
	<cfelseif get_price_cats.recordcount eq 1>
		if (form_basket.PRICE_CATS.checked==1)
			temp1 = 1;
	</cfif>
	
	//Fiyat Listesi secili olmasa bile internet secili olma durumu BK 20070307
	if (form_basket.is_public.checked==1)
		temp1 = 1;	
	
	if (temp1 == 0)
	{
		alert("<cf_get_lang dictionary_id ='37800.Aksiyonu Fiyat Listesine Bağlamalısınız'> !");
		return false;
	}	

	for(var i=1; i<=row_count; i++)
	{
		var str_me=eval("form_basket.disc_ount1"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
		if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37803.no lu satırdaki İskonto 1 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
		var str_me=eval("form_basket.disc_ount2"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
		if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37804.no lu satırdaki İskonto 2 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
		var str_me=eval("form_basket.disc_ount3"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
		if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37805.no lu satırdaki İskonto 3 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
		var str_me=eval("form_basket.disc_ount4"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
		if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37806.no lu satırdaki İskonto 4 alanındaki değer, 0 ile 100 arasında olmalı'> !"); str_me.focus(); return false;}
		var str_me=eval("form_basket.disc_ount5"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
		if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37807.no lu satırdaki İskonto 5 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
		var str_me=eval("form_basket.disc_ount6"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
		if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37808.no lu satırdaki İskonto 6 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
		var str_me=eval("form_basket.disc_ount7"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
		if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37809.no lu satırdaki İskonto 7 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
		var str_me=eval("form_basket.disc_ount8"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
		if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37810.no lu satırdaki İskonto 8 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
		var str_me=eval("form_basket.disc_ount9"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
		if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37811.no lu satırdaki İskonto 9 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
		var str_me=eval("form_basket.disc_ount10"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
		if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang dictionary_id ='37812.no lu satırdaki İskonto 10 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
	}
	
	if(date_check(form_basket.startdate,form_basket.finishdate,"<cf_get_lang dictionary_id ='37801.Geçerlilik Tarihleri Hatalı, Lütfen Düzeltin'> !") && date_check(form_basket.kondusyon_date,form_basket.finishdate,"<cf_get_lang dictionary_id ='37802.Kondüsyon Tarihi Geçerlilik Bitişinden Önce Olmalı, Lütfen Düzeltin '>!"))
		return true;
	else
		return false;
}

function unformat_fields()
{
	for(var i=1; i<=row_count; i++)
	{
		var str_me=eval("form_basket.p_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.s_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.profit_margin"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.disc_ount1"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.disc_ount2"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.disc_ount3"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.disc_ount4"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.disc_ount5"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.disc_ount6"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.disc_ount7"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.disc_ount8"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.disc_ount9"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.disc_ount10"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.row_nettotal"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		/*var str_me=eval("form_basket.row_nettotal_2"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);*/
		var str_me=eval("form_basket.tax_purchase"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.row_lasttotal"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.tax"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.action_profit_margin"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.action_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.action_price_kdvsiz"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);		
		var str_me=eval("form_basket.returning_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.action_price_disc"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);	
		var str_me=eval("form_basket.returning_price_disc"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		
		var str_me=eval("form_basket.rebate_cash_1"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.rebate_rate"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.extra_product_1"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.extra_product_2"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.return_day"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.return_rate"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);
		var str_me=eval("form_basket.price_protection_day"+i);if(str_me!= null)str_me.value=filterNum(str_me.value);		
	}
}
</script>

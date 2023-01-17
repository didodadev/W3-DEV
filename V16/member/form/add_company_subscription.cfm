<cfsetting showdebugoutput="no">
<cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY ORDER BY MONEY_ID
</cfquery>
<cfquery name="GET_SUBS_ADD_OPTION" datasource="#DSN3#">
	SELECT SUBSCRIPTION_ADD_OPTION_ID, SUBSCRIPTION_ADD_OPTION_NAME FROM SETUP_SUBSCRIPTION_ADD_OPTIONS
</cfquery>
<cf_get_lang_set module_name="sales">
    <table>
        <cfform name="form_add_subscription" method="post" action="#request.self#?fuseaction=member.emptypopup_add_company_subscription"> 
            <tr>
                <td><cf_get_lang dictionary_id='58233.Tanım'> *</td>
                <td colspan="3"><cfinput type="text" name="subscription_head" value="" maxlength="100" style="width:400px;"></td>
                <td><cf_get_lang dictionary_id='30044.Sözleşme No'></td>
                <td><input type="text" name="contract_no" id="contract_no" value="" maxlength="20" style="width:147px;"></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='30218.Servis Tipi'> *</td>
                <td><cf_wrk_select table_name="SETUP_SUBSCRIPTION_TYPE" name="subscription_type" value="SUBSCRIPTION_TYPE_ID" field="SUBSCRIPTION_TYPE" datasource="#dsn3#" width="150"></td>
                <td><cf_get_lang dictionary_id='57747.Sözleşme Tarihi'> *</td>
                <td><cfsavecontent variable="message1"><cf_get_lang dictionary_id='30122.Başlangıç Tarihini Kontrol Ediniz'> !</cfsavecontent>
                    <cfinput type="text" name="start_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="yes" message="#message1#" maxlength="10" style="width:65px">
                    <cf_wrk_date_image date_field="start_date" >
                </td>
                <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
                <td rowspan="3" valign="top"><textarea name="detail" id="detail" style="width:150px;height:60px;"><cfif isDefined("attributes.detail")><cfoutput>#attributes.detail#</cfoutput></cfif></textarea></td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id="58859.Süreç">*</td>
                <td ><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'></td>
                <td><cf_get_lang dictionary_id='57656.Servis'> <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></td>
                <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='60562.Kurulum Sevk Tarihini Kontrol Ediniz'>!</cfsavecontent>
                  <cfinput type="text" name="montage_date" validate="#validate_style#" message="#message#" maxlength="10" style="width:65px">
                  <cf_wrk_date_image date_field="montage_date">
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='57657.Ürün'> *</td>
                <td>
                  <input type="hidden" name="product_id" id="product_id" value="">
                  <input type="hidden" name="stock_id" id="stock_id" value="">
                  <input name="product_name" type="text" id="product_name" style="width:150px;" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','2','200');" value="" autocomplete="off">
                  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=form_add_subscription.product_id&field_name=form_add_subscription.product_name&field_id=form_add_subscription.stock_id&keyword='+encodeURIComponent(document.form_add_subscription.product_name.value),'list','popup_product_names');"><img src="/images/plus_thin.gif"></a>
                </td>
                <td><cf_get_lang dictionary_id='30222.Servis Bitis T'></td>
                <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='60562.Kurulum Sevk Tarihini Kontrol Ediniz'>!</cfsavecontent>
                  <cfinput type="text" name="finish_date" validate="#validate_style#" message="#message#" maxlength="10" style="width:65px">
                  <cf_wrk_date_image date_field="finish_date">
                </td>
            </tr>
            <tr>
                <cfif isdefined('attributes.cpid') and len(attributes.cpid)>
                    <input type="hidden" name="subs_member_id" id="subs_member_id" value="<cfoutput>#attributes.cpid#</cfoutput>">
                    <cfif len(get_company.manager_partner_id)>
                        <input type="hidden" name="subs_partner_id" id="subs_partner_id" value="<cfoutput>#GET_COMPANY.manager_partner_id#</cfoutput>">
                    <cfelse>
                        <input type="hidden" name="subs_partner_id" id="subs_partner_id" value="<cfoutput>#get_partner.partner_id#</cfoutput>">
                    </cfif>
                    <td><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></td>
                    <td valign="middle">
                        <cf_wrkAssetp fieldId='asset_id' fieldName='asset_name' form_name='form_add_subscription'>
                    </td>
                <cfelse>
                    <input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#attributes.assetp_id#</cfoutput>">
                    <td><cf_get_lang dictionary_id="57457.Musteri"> *</td>			
                    <td>
                        <input type="hidden" name="subs_partner_id" id="subs_partner_id" value="" />
                        <input type="hidden" name="subs_member_id" id="subs_member_id" value="">
                        <input type="text" name="subs_member_name" id="subs_member_name" style="width:150px;" value="" onFocus="AutoComplete_Create('subs_member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','1,0,0','PARTNER_ID,MEMBER_ID','subs_partner_id,subs_member_id','form_add_subscription','2','250');" autocomplete="off">
                        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=2&field_comp_name=form_add_subscription.subs_member_name&field_comp_id=form_add_subscription.subs_member_id&field_partner=form_add_subscription.subs_partner_id','list','popup_list_pars');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                    </td>
                </cfif>
                <td><cf_get_lang dictionary_id='57673.Tutar'> *</td>
                <td>
                    <input name="amount" id="amount" type="input" value="" class="moneybox" onKeyUp="return(FormatCurrency(this,event));" style="width:67px;">
                    <select name="money_type" id="money_type" style="width:50px;">
                    <cfoutput query="get_money_info">
                        <option value="#MONEY#">#MONEY#</option>
                    </cfoutput>
                    </select>
                </td>
                <td colspan="2"  style="text-align:right;">
                    <div id="show_subscription_info"></div>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57461.Kaydet"></cfsavecontent>
                    <input type="button" onclick="control();" value="<cfoutput>#message#</cfoutput>" />
                </td>
            </tr>
        </cfform>
    </table>
<script type="text/javascript">
	function control()
	{
		if (document.form_add_subscription.subscription_head.value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'> !");
			return false;
		}
		temporary_categori = document.form_add_subscription.subscription_type.selectedIndex;
		if (document.form_add_subscription.subscription_type[temporary_categori].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='41094.Sistem Kategorisi Seçiniz'> ! ");
			return false;
		}
		if (document.form_add_subscription.product_id.value == "" || document.form_add_subscription.product_name.value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='36677.Ürün Seçmelisiniz'> ! ");
			return false;
		}
		<cfif isdefined('attributes.assetp_id') and len(attributes.assetp_id)>
			if (document.form_add_subscription.subs_member_id.value == "" || document.form_add_subscription.subs_member_name.value == "" || document.form_add_subscription.subs_partner_id.value == "")
			{
				alert("<cf_get_lang dictionary_id='30265.Lütfen müşteri seçiniz!'>");
				document.form_add_subscription.subs_member_name.focus();
				return false;
			}
		</cfif>
		if (document.form_add_subscription.amount.value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='29535.Tutar Girmelisiniz'> !");
			return false;
		}
		
	<cfif isdefined('attributes.cpid') and len(attributes.cpid)>
		AjaxFormSubmit('form_add_subscription','show_subscription_info','1',"Kaydediliyor..","Kaydedildi",'<cfoutput>#request.self#?fuseaction=member.popupajax_my_company_systems&maxrows=#session.ep.maxrows#&cpid=#attributes.cpid#</cfoutput>','LIST_MY_COMPANY_SYSTEMS');
	<cfelse>
		AjaxFormSubmit('form_add_subscription','show_subscription_info','1',"Kaydediliyor..","Kaydedildi",'<cfoutput>#request.self#?fuseaction=member.popupajax_my_company_systems&maxrows=#session.ep.maxrows#&assetp_id=#attributes.assetp_id#</cfoutput>','LIST_MY_COMPANY_SYSTEMS');
	</cfif>
	
	}
</script>
<cfabort>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">


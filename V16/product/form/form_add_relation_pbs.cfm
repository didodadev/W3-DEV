<cf_get_lang_set module_name="product">
<cfif isdefined('attributes.pid') and len(attributes.pid)>
	<cfset attribute_deger = 'pid=#attributes.pid#'>
<cfelseif isdefined('attributes.opp_id') and len(attributes.opp_id)>
	<cfset attribute_deger = 'opp_id=#attributes.opp_id#'>
<cfelseif isdefined('attributes.project_id') and len(attributes.project_id)>
	<cfset attribute_deger = 'project_id=#attributes.project_id#'>
<cfelseif  isdefined('attributes.offer_id') and len(attributes.offer_id)>
	<cfset attribute_deger = 'offer_id=#attributes.offer_id#'>
</cfif>
<cfif isdefined('attributes.opp_id') and len(attributes.opp_id)>
	<cfquery name="getProduct" datasource="#dsn3#">
		SELECT STOCK_ID FROM OPPORTUNITIES WHERE OPP_ID = #attributes.opp_id#
	</cfquery>
	<cfset productSelect = getProduct.STOCK_ID>	
</cfif>
<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
	<cfquery name="getProduct" datasource="#dsn#">
		SELECT PRODUCT_ID FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.project_id#
	</cfquery>
	<cfquery name="getOffer" datasource="#dsn3#">
		SELECT OFFER_ID FROM OFFER WHERE PROJECT_ID = #attributes.project_id#
	</cfquery>
	<cfquery name="getOpp" datasource="#dsn3#">
		SELECT OPP_ID FROM OPPORTUNITIES WHERE PROJECT_ID = #attributes.project_id#
	</cfquery>
</cfif>
<cfif isdefined('attributes.pid') and len(attributes.pid)>
	<cfquery name="getProject" datasource="#dsn#">
		SELECT PROJECT_ID FROM PRO_PROJECTS WHERE PRODUCT_ID = #attributes.pid#
	</cfquery>
	<cfquery name="getOpp" datasource="#dsn3#">
		SELECT DISTINCT OPP.OPP_ID FROM OPPORTUNITIES OPP,STOCKS S WHERE S.STOCK_ID = OPP.STOCK_ID AND S.PRODUCT_ID = #attributes.pid#
	</cfquery>
</cfif>
<br/>
<cfif (isdefined('productSelect') and not len(productSelect)) or 
	(isdefined('attributes.project_id') and not len(getProduct.product_id) and getOffer.recordcount eq 0 and getOpp.recordcount eq 0) or 
	(isdefined('attributes.pid') and len(attributes.pid)) or (isdefined('attributes.offer_id') and len(attributes.offer_id))>
    <table cellspacing="1" cellpadding="1" width="98%" border="0" align="center" class="color-border">
         <tr class="color-list" valign="top" height="25">
            <form name="add_pbs_form">
            <td>
                <cf_get_lang dictionary_id="37200.PBS">
                <input type="hidden" name="is_price" id="is_price" value="">
                <input type="hidden" name="pbs_id" id="pbs_id" value="">
                <input type="text" name="pbs_code" id="pbs_code" style="width:110px;" value="" onFocus="goster(div_pbs_);pbs_search();" autocomplete="off">
			    <a href="javascript://" onClick="pencere_ac_pbs_code();"><img src="/images/plus_thin.gif" align="absmiddle"></a>
            </td>
            </form>
            <td id="div_pbs_"><div id="pbs_div"></div></td>
        </tr>
    </table>
</cfif>
<table align="center" width="99%" cellspacing="0" cellpadding="0">
	<tr>
    	<td><div id="pbs_list"></div></td>
   </tr>
</table>
<cfoutput>
	<script language="javascript">
		function pbs_search()
		{     
			 if(document.getElementById('pbs_id').value == '')
			 {
				alert("<cf_get_lang dictionary_id='60483.Lütfen PBS Seçiniz'>");
				return false;
			 }
			 else
			 {
			   adress_ = '#request.self#?fuseaction=product.emptypopup_pbs_result&#attribute_deger#&is_price='+document.getElementById('is_price').value+'&pbs_id='+document.getElementById('pbs_id').value;
			   AjaxPageLoad(adress_,'pbs_div',1);
			 } 
		}
		
		function pencere_ac_pbs_code()
		{
			windowopen('#request.self#?fuseaction=product.popup_list_pbs_code&is_submitted=1&is_single=1&field_id=add_pbs_form.pbs_id&field_name=add_pbs_form.pbs_code&field_is_price=add_pbs_form.is_price','list','popup_list_pbs_code');
		}
		
		 adress_ = '#request.self#?fuseaction=product.emptypopup_relation_pbs_list&#attribute_deger#';
		 AjaxPageLoad(adress_,'pbs_list',1);
	</script>
</cfoutput>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

<cfif isdefined("attributes.is_form_submitted") and len (attributes.is_form_submitted)>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfif form_varmi eq 1>
<cfinclude template="../query/get_rival_price_list.cfm">
<cfelse>
<cfset get_rival_prices.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_rival_prices.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="form" action="#request.self#?fuseaction=store.list_rival_product_prices" method="post">
    <cf_big_list_search title="#getLang('store',19)#"> 
        <cf_big_list_search_area>
            <table>
                <tr> 
                	<cfinput type="hidden" name="is_form_submitted" value="1">
                    <td><cf_get_lang_main no='48.Filtre'></td>
                    <td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" maxlength="3" validate="integer" range="1,250" message="#message#" style="width:25px;">
                    </td>
                    <td><cf_wrk_search_button></td>			
                <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>
</cfform>
<cf_big_list> 
    <thead>
        <tr> 
            <th width="35"><cf_get_lang_main no="1165.Sıra"></th>
            <th><cf_get_lang_main no='1367.Rakip'></th>
            <th><cf_get_lang_main no='245.Ürün'></th>
            <th width="60"><cf_get_lang_main no='224.Birim'></th>
            <th width="100" style="text-align:right;"><cf_get_lang_main no='672.Fiyat'></th>
            <th width="85"><cf_get_lang_main no='243.B Tarihi'></th>
            <th width="80"><cf_get_lang_main no='288.B Tarihi'></th>
            <th class="header_icn_none">
            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=store.popup_form_add_rival_price</cfoutput>','small');"><img src="/images/plus_list.gif" title="<cf_get_lang no='20.Rakip Fiyat Ekle'>"></a>
            </th>	
        </tr>
    </thead>
    <tbody>
    <cfif get_rival_prices.recordcount>
        <cfoutput query="get_rival_prices" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
            <tr> 
                <td>#currentrow#</td>
                <td><A  class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.popup_form_upd_rival&r_id=#r_id#','small');">#rival_name#</a></td>
                <td>#PRODUCT_NAME#</td>
                <td><!--- #GET_UNIT_NAME(UNIT_ID,PRODUCT_ID)# --->
                #UNIT#
                </td>
                <td style="text-align:right;"> <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.popup_form_upd_rival_product_price&pr_id=#pr_id#&pid=#PRODUCT_ID#','small');">#TLFormat(PRICE)#&nbsp;#MONEY#</a></td>
                <td>#dateformat(STARTDATE,dateformat_style)#</td><!--- popup_form_upd_rival_price --->
                <td>#dateformat(FINISHDATE,dateformat_style)#</td>
                <!-- sil -->
                <td> <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=store.popup_form_upd_rival_price&pr_id=#pr_id#&pid=#PRODUCT_ID#','small');"><img src="/images/update_list.gif" title="<cf_get_lang no='110.Rakibi Düzenle'>"></a></td>
                <!-- sil -->
            </tr>
        </cfoutput>
        <cfelse>
            <tr> 
                <td colspan="8"><cfif form_varmi eq 0><cf_get_lang_main no="289.Filtre Ediniz">!<cfelse><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</cfif></td>
            </tr>
        </cfif>
     </tbody>
</cf_big_list>
<cfset url_str = "store.list_rival_product_prices">
<cfif isdefined("attributes.is_form_submitted")>
	<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
</cfif>
<cfif isdefined ("attributes.keyword") and len(attributes.keyword)>
    <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.branch_id")>
    <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>
<cf_paging page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="#url_str#"> 
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

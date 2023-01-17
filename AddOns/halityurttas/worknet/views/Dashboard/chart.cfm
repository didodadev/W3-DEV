<cfsetting showdebugoutput="no">
<cfinclude template="../../config.cfm">
<cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.companies.member") />
<cfset cmp2 = objectResolver.resolveByRequest("#addonNS#.components.demands.demand") />
<cfset cmp3 = objectResolver.resolveByRequest("#addonNS#.components.products.product") />

<cfset get_company = cmp.getCompany() />
<cfset get_demand = cmp2.getDemand() />
<cfset get_product = cmp3.getProduct(is_catalog:0) /> 
<cfset get_catalog = cmp3.getProduct(is_catalog:1) /> 
<cf_ajax_list>
	<tbody>
        <tr class="nohover" height="25"><td class="txtbold"><cf_get_lang_main no="2157.Genel"> <cf_get_lang_main no="344.Durum"></td></tr>
        <tr class="nohover">
            <td> 
                 <cfchart show3d="yes" labelformat="number" pieslicestyle="solid" format="jpg" chartheight="400" chartwidth="600"> 
                    <cfchartseries type="bar" itemcolumn="general" colorlist="0099FF,6666CC,33CC33,CC6600">
                        <cfchartdata item="Uye" value="#get_company.recordcount#">
                        <cfchartdata item="Talep" value="#get_demand.recordcount#">
                        <cfchartdata item="Urun" value="#get_product.recordcount#"> 
                        <cfchartdata item="Katalog" value="#get_catalog.recordcount#"> 
                    </cfchartseries>
                </cfchart> 
            </td>
        </tr>
    </tbody>
</cf_ajax_list> 
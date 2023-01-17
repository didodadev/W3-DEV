<cfset get_basket = createObject("component", "V16.objects2.sale.cfc.basketAction")>
<cfset partner_id = consumer_id = cookie_name = "" />
<cfif isdefined("session.ww.userid")>
	<cfset consumer_id = session_base.userid>
<cfelseif isdefined("session.pp.userid")>
	<cfset partner_id = session_base.userid>
<cfelse>
    <cfset cookie_name = evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#") />
</cfif>

<cfset basket = get_basket.get_product_to_basket( consumer_id, partner_id, cookie_name ) >

<cfquery name="get_total" dbtype="query">
    SELECT SUM(PRICE_KDV_TL) AS T_TL_PRICE,
        SUM(PRICE * QUANTITY) AS T_USD_PRICE,
        SUM(QUANTITY) AS T_ADET, 
        SUM(PRICE_TL) AS PRICE_TL
    FROM basket
    WHERE (IS_CARGO IS NULL OR IS_CARGO = 0)
    GROUP BY MONEY
</cfquery>
<cfquery name="get_total_group_kdv" dbtype="query">
    SELECT
        TAX,
        SUM(PRICE_KDV_TL) AS T_TL_PRICE,
        SUM(PRICE_TL) AS PRICE_TL
    FROM basket
    GROUP BY TAX
</cfquery>
<cfquery name="get_cargo" dbtype="query">
    SELECT SUM(PRICE_CARGO) AS T_TL_PRICE,SUM(QUANTITY) AS T_ADET FROM basket WHERE IS_CARGO = 1
</cfquery>
<cfif get_total.recordcount>
    <div class="row mb-2">
        <div class="col-md-12">                
            <h6 class="mb-2 text-color-5 font-weight-bold">Ara Toplam</h6>
            <p class="text-color-5 font-weight-bold"><cfoutput>#TLFORMAT(get_total.PRICE_TL)# #session_base.MONEY#</cfoutput></p>
            <div class="table-responsive">
                <table class="table table-bordered">
                    <tbody>
                        <cfloop query = "#get_total_group_kdv#">
                            <tr>
                                <td>KDV (%<cfoutput>#get_total_group_kdv.TAX#</cfoutput>):</td>
                                <td class="text-right"><cfoutput>#TLFORMAT(get_total_group_kdv.T_TL_PRICE  - get_total_group_kdv.PRICE_TL)# #session_base.MONEY#</cfoutput></td>
                            </tr>
                        </cfloop>
                    </tbody>
                </table>
            </div>
            <h6 class="mb-2 text-color-5 font-weight-bold">Toplam KDV</h6>
            <p class="text-color-5 font-weight-bold"><cfoutput>#TLFORMAT(get_total.T_TL_PRICE  - get_total.PRICE_TL)# #session_base.MONEY#</cfoutput></p>
            <cfif get_cargo.recordcount>
                <h6 class="mb-2 text-color-5 font-weight-bold">Kargo</h6>
                <p class="text-color-5 font-weight-bold"><cfoutput>#TLFORMAT(get_cargo.T_ADET * get_cargo.T_TL_PRICE)# #session_base.MONEY#</cfoutput></p>
            </cfif>
            <tr>
                <h6 class="mb-2 text-color-5 font-weight-bold">Genel Toplam</h6>
                <p class="text-color-5 font-weight-bold"><cfoutput>#TLFORMAT(get_total.T_TL_PRICE)# #session_base.MONEY#</cfoutput></p>
            </tr>
        </div>
    </div>
</cfif>
<div class="row">
    <div class="col-md-12">
        <a href="/<cfoutput>#url.param_lang#</cfoutput>/cart" class="btn font-weight-bold btn-color-1"> <cf_get_lang dictionary_id='61907.Sepeti İncele'></a>
    </div>
</div>
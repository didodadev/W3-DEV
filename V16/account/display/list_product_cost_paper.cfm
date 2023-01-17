<cf_form_box title="#getLang('main',490)#">
    <table>
        <cfif not listfindnocase(denied_pages,'account.product_cost_rate_paper')>
            <tr>
                <td><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=account.product_cost_rate_paper" class="tableyazi"><cf_get_lang no="287.Üretim Maliyetleri Yansitma"></a></td>
            </tr>
        </cfif>
        <cfif not listfindnocase(denied_pages,'account.product_labor_cost_paper')>
            <tr>
                <td><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=account.product_labor_cost_paper" class="tableyazi"><cf_get_lang no="288.Üretim İşçilik Maliyetleri Yansitma"></a></td>
            </tr>
        </cfif>
        <cfif not listfindnocase(denied_pages,'account.production_result_account_card')>
            <tr>
                <td><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=account.production_result_account_card" class="tableyazi"><cf_get_lang no="286.Üretim Sonuçları Muhasebeleştirme"></a></td>
            </tr>
        </cfif>
        <cfif not listfindnocase(denied_pages,'account.product_cost_account_card')>
            <tr>
                <td><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=account.product_cost_account_card" class="tableyazi"><cf_get_lang no="285.Satılan Malın Maliyeti Muhasebeleştirme"></a></td>
            </tr>
        </cfif>
    </table>
</cf_form_box>

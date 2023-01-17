<cfparam name="attributes.expression_category_id" default="0">

<cfinclude template="../../config.cfm" runonce="true">
<cfinclude template="../../models/types.cfm" runonce="true">

<cfobject name="inst_expression" type="component" component="#addonns#.domains.expressions">
<cfset query_expression = inst_expression.get_expressions(expression_category: attributes.expression_category_id)>
<cf_flat_list>
    <thead>
        <tr>
            <th style="text-align: center; width: 20px;"><cf_get_lang dictionary_id='57487.no'></th>
            <th>Expression</th>
            <th style="width: 100px;"><cf_get_lang dictionary_id="57756.Durum"></th>
            <th style="width: 60px;">#</th>
        </tr>
    </thead>
    <tbody>
        <cfif query_expression.recordcount>
            <cfoutput query="query_expression">
            <tr>
                <td>#currentrow#</td>
                <td>#mid(EXPRESSION_BODY, 1, 200)##len(EXPRESSION_BODY) gt 200 ? "..." : ""#</td>
                <td><cfif status eq "1"><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                <td><a href="#request.self#?fuseaction=plevne.expression&event=upd&id=#expression_id#&expression_category_id=#attributes.expression_category_id#" target="_blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>"></i></a></td>
            </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'></td>
            </tr>
        </cfif>
    </tbody>
</cf_flat_list> 
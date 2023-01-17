<cfinclude template="../query/get_last_news.cfm">
<cf_ajax_list>
    <table width="180">
        <cfif get_last_news.recordcount>
            <cfoutput query="get_last_news">
            <tr>
                <td><img src="/images/arrow_org.gif"></td>
                <td><img src="/images/arrow_blue.gif" align="absmiddle"> <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#get_last_news.content_id#" class="label">#get_last_news.cont_head#</a></td>
            </tr>
            </cfoutput>
        <cfelse>
            <tr> 
                <td colspan="2"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
            </tr>		
        </cfif>
    </table>
</cf_ajax_list>

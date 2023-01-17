<cfinclude template="../query/get_last_news.cfm">
<div class="blog_title"><cfoutput>#getLang('rule',1,'haberler')#</cfoutput></div>
<cfif get_last_news.recordcount>
    <div class="flex-col">
        <cfoutput query="get_last_news">
            <div class="blog_item">
                <div class="blog_item_text">
                <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#get_last_news.content_id#">#get_last_news.cont_head#</a>
                </div>
            </div>
        </cfoutput>
    <cfelse>
        <h2><cf_get_lang_main no='72.Kayıt Yok'> !</h2>
    </div>
</cfif>
<!--- <ul class="ltList">
    <cfif get_last_news.recordcount>
        <cfoutput query="get_last_news">
            <li>
                <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#get_last_news.content_id#">#get_last_news.cont_head#</a>
            </li>
        </cfoutput>
    <cfelse>
        <li><cf_get_lang_main no='72.Kayıt Yok'> !</li>
    </cfif>
</ul> --->

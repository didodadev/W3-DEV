<cfinclude template="../query/get_last_news.cfm">
    <cfif get_last_news.recordcount>
            <div class="col-12 last-news px-0">
            <hr/>
                <h4 class="col-12">HABERLER</h4>
            <hr/>
                <ul class="col-12 px-0">
                    <cfoutput query="get_last_news">
                        <li class="col-12 px-0">
                            <a class="" href="#request.self#?fuseaction=rule.dsp_rule&cntid=#get_last_news.content_id#">
                                <i class="wrk-circular-button-right"></i>#get_last_news.cont_head#
                            </a>
                        </li>
                    </cfoutput>
                </ul>        
    <cfelse>
            <div class="col-12">
                <cf_get_lang_main no='72.Kayıt Yok'> !
            </div>
    </cfif>
            </div>








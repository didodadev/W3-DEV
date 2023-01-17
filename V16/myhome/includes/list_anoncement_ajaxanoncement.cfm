<cfsetting showdebugoutput="no">
<cfset is_announcement = 1>
<cfinclude template="../query/get_homepage_news.cfm">
<!---- Doğum Günleri  BEGIN ---->
<cfsetting showdebugoutput="no">
<cfset my_month=month(now())>
<cfset my_day=day(now())>
<cfset list_day = ''>
<cfset list_month = ''>
<cfset list_day = '#day(now())#'>
<cfset list_month = '#month(now())#'>
<cfloop from = "1" to = "6" index = "LoopCount">
	<cfset list_day = listappend(list_day,'#day(date_add("d",LoopCount,now()))#',',')>
	<cfset list_month = listappend(list_month,'#month(date_add("d",LoopCount,now()))#',',')>
</cfloop>
<ul class="ui-list"> 
    <cfoutput query="get_homepage_news">
        <li>
            <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#get_homepage_news.content_id#">
                <div class="ui-list-left">
                    <span class="ui-list-icon ctl-protest"></span>
                    #get_homepage_news.cont_head#
                </div>
            </a>
        </li>
    </cfoutput>
    <cfif not get_homepage_news.recordcount>
        <li>
            <a  href="javascript://">
                <div class="ui-list-left">
                    <span class="ui-list-icon ctl-protest"></span>
                    <cf_get_lang_main no='72.Kayıt Yok'>
                </div>
            </a>
        </li>
    </cfif>
</ul>


 

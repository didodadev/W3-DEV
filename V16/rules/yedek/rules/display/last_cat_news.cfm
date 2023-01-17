<!--- Haberler --->			
<cfinclude template="../query/get_last_cat_news.cfm">
<table width="190">
	<cfoutput query="GET_LAST_CAT_NEWS">
        <tr>
            <td><img src="/images/arrow_org.gif"></td>
            <td><img src="/images/arrow_org.gif"><a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#GET_LAST_CAT_NEWS.CONTENT_ID#" class="tableyazi">#GET_LAST_CAT_NEWS.cont_head#</a></td>
        </tr>
    </cfoutput>
</table>
<!--- Haberler --->		

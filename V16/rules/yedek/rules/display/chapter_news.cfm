<cfinclude template="../query/get_chapter_news.cfm">
<cfif get_chapter_news.recordcount>
	<cfoutput query="get_chapter_news">
        <cfquery name="GET_IMAGE" datasource="#DSN#" maxrows="1">
            SELECT 
                CONTIMAGE_SMALL
            FROM
                CONTENT_IMAGE
            WHERE
                CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_chapter_news.content_id#">
            ORDER BY 
                CONTIMAGE_ID DESC
        </cfquery>
        <table border="0" align="center" style="width:99%">
            <tr>
                <cfif get_image.recordcount>
                    <td rowspan="3" style="width:125px; vertical-align:top;"><img src="#file_web_path#content/#get_image.contimage_small#" align="left" width="120" height="120"></td>
                </cfif>
                <td class="headbold" style="vertical-align:top;">#cont_head#</td>
            </tr>
            <tr>
                <td class="txtbold" style="vertical-align:top;">#cont_summary#</td>
            </tr>
            <tr>
                <td style="vertical-align:top;"><img src="images/arrow.gif">&nbsp;	<a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#get_chapter_news.content_id#"><cf_get_lang_main no='714.Devam'></a>
                </td>
            </tr>
            <tr style="height:11px;">
                <td colspan="2" background="../../images/content_sptr.gif"></td>
            </tr>
        </table>
        <br/>
    </cfoutput>
<cfelse>
	<cf_get_lang_main no='72.Kayıt Yok!'>
</cfif>

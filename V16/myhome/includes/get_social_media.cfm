<cfsetting showdebugoutput="no">
<cfquery datasource="#dsn#" name="get_publis_twit">
	SELECT 
    	SID, 
        SOCIAL_MEDIA_ID, 
        SOCIAL_MEDIA_CONTENT, 
        PUBLISH_DATE, 
        IMAGE, 
        USER_NAME, 
        SEARCH_KEY, SITE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_EMP, 
        PROCESS_ROW_ID, 
        UPDATE_DATE, 
        UPDATE_IP, 
        COMMENT_URL, 
        LANGUAGE, 
        USER_ID, 
        IS_PUBLISH 
    FROM 
	    SOCIAL_MEDIA_REPORT 
    WHERE 
    	IS_PUBLISH=1
</cfquery>
<cfif get_publis_twit.recordcount>
    <marquee direction="up" scrolldelay="200" onmouseover="this.setAttribute('scrollamount', 0, 0);" onmouseout="this.setAttribute('scrollamount', 6, 0);">
        <div>
            <cfoutput query="get_publis_twit">
                <div style="border:1px solid ##CCC; margin-bottom:8px; clear:both;">
                    <img src="#IMAGE#" height="50" border="1" width="50"/><br /><b>#USER_NAME#:</b>#SOCIAL_MEDIA_CONTENT#
                </div>
            </cfoutput>
        </div>
    </marquee>
<cfelse>
	<cf_flat_list><tr><td><cf_get_lang_main no ='72.Kayıt yok'>!</td></tr></cf_flat_list>
</cfif>

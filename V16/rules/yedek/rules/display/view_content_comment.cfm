<cfquery name="GET_PRODUCT_COMMENT" datasource="#DSN#">
	SELECT 
		*
	FROM
		CONTENT_COMMENT
	WHERE
		CONTENT_ID = #attributes.CONTENT_ID#  		
		AND STAGE_ID = -2 
</cfquery>
<cfinclude template="../query/get_content_head.cfm">
<cf_popup_box title="#getLang('rule',29)#">  
    <cf_medium_list>      
        <thead>
            <tr>
                <th></th>
                <th>Konu</th>
                <th><cfoutput>#get_content_head.cont_head#</cfoutput></th>
            </tr>
            </thead>
            <tbody>
            <cfif GET_PRODUCT_COMMENT.RECORDCOUNT>
                <cfoutput query="GET_PRODUCT_COMMENT">
                    <tr>
                        <td width="20"><img src="images/notkalem.gif"></td>
                        <td>#name# #surname# - (<a href="mailto:#mail_address#" class="label">#mail_address#</a>)</td>
                        <td style="text-align:right;"><strong><cf_get_lang_main no='1572.PUAN'> :
                        #content_comment_point#</strong></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td colspan="3">#content_comment#</td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td width="20"><img src="images/notkalem.gif" border="0"></td>
                    <td colspan="2"><cf_get_lang no='27.Yayınlanan Yorum Bulunamadı'></td>
                </tr>
            </cfif>
        </tbody>
    </cf_medium_list>
</cf_popup_box>


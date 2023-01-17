<cfquery name="GET_TRAINING_COMMENT" datasource="#DSN#">
	SELECT 
		TC.*,
		T.TRAIN_HEAD
	FROM
		TRAINING_COMMENT TC,
		TRAINING T
	WHERE
		TC.TRAINING_ID = #attributes.TRAINING_ID#
		AND
		T.TRAIN_ID = #attributes.TRAINING_ID#
		AND
		TC.STAGE_ID = -2
</cfquery>
<cfsavecontent variable="right">
<cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training.popup_add_training_comment&training_id=#attributes.TRAINING_ID#','large');"><img src="/images/add_not.gif" border="0"></a></cfoutput>
</cfsavecontent>
<cf_popup_box title="#getLang('training',86)# : #GET_TRAINING_COMMENT.TRAIN_HEAD#" right_images='#right#'>
    <table>
    <cfif GET_TRAINING_COMMENT.RECORDCOUNT>
		<cfoutput query="GET_TRAINING_COMMENT">
            <tr>
                <td width="20"><img src="images/notkalem.gif"></td> 
                <td>#name# #surname# - (<a href="mailto:#mail_address#" class="label">#mail_address#</a>)</td>
                <td style="text-align:right;"><strong><cf_get_lang_main no='1572.PUAN'> :  #training_comment_point#</strong></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td colspan="3">#training_comment#</td>
            </tr>			      
            <tr>
          	  <td colspan="3">&nbsp;</td>
            </tr>
        </cfoutput>
        <cfelse>
        <tr>
            <td width="20"><img src="images/notkalem.gif"></td> 
            <td><cf_get_lang no='87.Yayınlanan Yorum Bulunamadı'></td>
        </tr>
    </cfif>
    </table>
</cf_popup_box>

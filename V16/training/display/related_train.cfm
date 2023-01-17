<cfquery name="GET_RELATED_TRAIN" datasource="#dsn#">
	SELECT
		T.TRAIN_HEAD,
		T.TRAIN_ID,
		TR.RELATED_ID,
		T.TRAIN_OBJECTIVE
	FROM
		TRAINING_RELATED TR,
		TRAINING T
	WHERE
		TR.RELATED_TRAINING_ID = T.TRAIN_ID 
		AND
		TR.TRAINING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_id#">
</cfquery>
<table class="ajax_list">
    <tbody>
        <cfif GET_RELATED_TRAIN.recordcount>
            <cfoutput query="GET_RELATED_TRAIN">
                <tr>
                    <td><a href="#request.self#?fuseaction=training.training_subject&train_id=#train_id#" title="#mid(TRAIN_OBJECTIVE,1,100)#..." class="tableyazi">#train_head#</a></td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
</table>

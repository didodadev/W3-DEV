<cfquery name="GET_SUBSCRIPTION_TYPES" datasource="#DSN3#">
	SELECT
        #dsn#.Get_Dynamic_Language(SUBSCRIPTION_TYPE_ID,'#session.ep.language#','SETUP_SUBSCRIPTION_TYPE','SUBSCRIPTION_TYPE',NULL,NULL,SUBSCRIPTION_TYPE) AS SUBSCRIPTION_TYPE_,
        *
	FROM
		SETUP_SUBSCRIPTION_TYPE
	ORDER BY 
		SUBSCRIPTION_TYPE
</cfquery>
<table>
    <cfif get_subscription_types.recordcount>
        <cfoutput query="get_subscription_types">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td><a href="#request.self#?fuseaction=settings.upd_subscription_type&subscription_type_id=#subscription_type_id#" class="tableyazi">#SUBSCRIPTION_TYPE_#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
    </cfif>
</table>

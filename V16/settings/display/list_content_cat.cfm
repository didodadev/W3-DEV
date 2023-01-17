<cfquery name="CONTENTCATS" datasource="#dsn#">
	SELECT 
    	DISTINCT
	    CC.CONTENTCAT_ID, 
        #dsn#.Get_Dynamic_Language(CC.CONTENTCAT_ID,'#session.ep.language#','CONTENT_CAT','CONTENTCAT',NULL,NULL,CC.CONTENTCAT) AS CONTENTCAT,
        CC.FILE_TYPE1, 
        CC.FILE_TYPE2, 
        CC.CONTENTCAT_IMAGE1, 
        CC.CONTENTCAT_IMAGE2, 
        CC.CONTENTCAT_LINK1, 
        CC.CONTENTCAT_ALT1, 
        CC.CONTENTCAT_LINK2, 
        CC.CONTENTCAT_ALT2, 
        CC.LANGUAGE_ID, 
        CC.IS_RULE, 
        CC.IS_HOMEPAGE, 
        CC.COMPANY_ID, 
        CC.RECORD_DATE, 
        CC.RECORD_EMP, 
        CC.RECORD_IP, 
        CC.UPDATE_DATE,
        CC.UPDATE_EMP, 
        CC.UPDATE_IP, 
        CC.IS_TRAINING 
    FROM 
    	CONTENT_CAT CC

</cfquery>
<table>
    <cfif contentCats.recordcount>
		<cfoutput query="contentCats">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=settings.form_upd_content_cat&ID=#contentCat_ID#" class="tableyazi">#contentCat#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
    </cfif>
</table>

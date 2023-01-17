<!--- Çekilen queryler --->
<cfquery name="testCategories" datasource="#dsn#">
	SELECT
        ID,
        #dsn#.Get_Dynamic_Language(ID,'#session.ep.language#','TEST_CAT','CATEGORY_NAME',NULL,NULL,CATEGORY_NAME) AS CATEGORY_NAME
    FROM
        TEST_CAT
</cfquery>
<table>
    <cfif testCategories.recordcount>
        <cfoutput query="testCategories">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=settings.upd_test_category&id=#id#" class="tableyazi">#category_name#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
        <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
        <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
    </tr>
    </cfif>
</table>


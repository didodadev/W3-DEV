<cfquery name="GET_ASSET_HISTORY" datasource="#DSN#">
    SELECT 
        ASSET.ASSET_ID,
        ASSET.ASSETCAT_ID,
        ASSET.ASSET_NO,
        ASSET.ASSET_NAME,
        ASSET.ASSET_FILE_REAL_NAME,
        ASSET.REVISION_NO,
        ASSET_CAT.ASSETCAT,
        CONTENT_PROPERTY.NAME,
        ASSET.RECORD_DATE
    FROM
        ASSET
    JOIN ASSET_CAT ON ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID
    JOIN CONTENT_PROPERTY ON ASSET.PROPERTY_ID = CONTENT_PROPERTY.CONTENT_PROPERTY_ID
    WHERE 
        ASSET_NO = (SELECT ASSET_NO FROM ASSET WHERE ASSET_ID = <cfqueryparam value = "#attributes.asset_id#" cfsqltype="cf_sql_integer">) AND
        ASSET.RECORD_DATE < (SELECT RECORD_DATE FROM ASSET WHERE ASSET_ID = <cfqueryparam value = "#attributes.asset_id#" cfsqltype="cf_sql_integer">)
</cfquery>
<cf_popup_box title="#getLang('main',61,'Tarihçe')#"><!---Tarihçe--->
	<table class="workDevList">
        <cfif GET_ASSET_HISTORY.recordcount>
            <thead>
                <tr>
                    <th width="30"><cf_get_lang_main no='1165.Sıra'></th>
                    <th><cf_get_lang_main no='468.Belge No'></th>
                    <th><cf_get_lang_main no='1655.Varlık'></th>
                    <th><cf_get_lang_main no='74.Kategori'></th>
                    <th><cf_get_lang_main no='655.Döküman Tipi'></th>
                    <th><cf_get_lang_main no='215.Kayıt Tarihi'></th>
                    <th><i class="fa fa-edit"></i></th>
                </tr>
            </thead>
            <cfset counter = 1>
            <cfoutput query = "GET_ASSET_HISTORY">
                <tr>
                    <td>#counter#</td>
                    <td>#ASSET_NO#</td>
                    <td title="orijinal Dosya Adı: #ASSET_FILE_REAL_NAME#">#ASSET_NAME#</td>
                    <td>#ASSETCAT#</td>
                    <td>#NAME#</td>
                    <td>#dateformat(RECORD_DATE,dateformat_style)#</td>
                    <td><i class="fa fa-edit" style="cursor:pointer;" onclick="openAsset(#ASSET_ID#,#ASSETCAT_ID#);"></i></td>
                </tr>
                <cfset counter++>
            </cfoutput>
        <cfelse>
            <tr>
                <td><cf_get_lang_main no='72.Kayit Yok'></td>
            </tr>
        </cfif>
    </table>
</cf_popup_box>

<script>
    function openAsset(assetid,assetcat_id){
        window.opener.open('<cfoutput>#request.self#</cfoutput>?fuseaction=asset.list_asset&event=upd&asset_id='+assetid+'&assetcat_id='+assetcat_id+'','_blank');
        window.close();
    }
</script>
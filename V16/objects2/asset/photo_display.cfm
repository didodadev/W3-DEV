<cfparam name="asset_title" default="Foto" />
<cf_box title="#asset_title#">
    <cfif not isdefined("get_asset")>
    	<cfif not isdefined("photoData")>
        <cfset photoData=createObject("component","objects2.asset.query.AssetData").init(dsn,1) />
        </cfif>
        <cfset get_asset = photoData.getAsset(attributes.asset_id) />
        <cfset photoData.IncreaseDownloadCount(attributes.asset_id) />
    </cfif>
    <cfif get_asset.record_pub neq "">
        <cfset userid=get_asset.record_pub />
        <cfset usertype = "consumer" />
    <cfelseif get_asset.record_emp neq "">
        <cfset userid=get_asset.record_emp />
        <cfset usertype = "employee" />
    <cfelseif get_asset.record_par neq "">
        <cfset userid=get_asset.record_par />
        <cfset usertype = "partner" />
    <cfelse>
    	<cfset usertype="" />
    </cfif>
    <img src="<cfoutput>/documents/#get_asset.assetcat_path#/#get_asset.asset_file_name#</cfoutput>" alt="<cf_get_lang no='207.Fotoğraf'>" title="<cf_get_lang no='207.Fotoğraf'>" width="580" />
    <div class="myportal_frame" style="padding:5px;">
    <cfoutput><strong><cf_get_lang no='171.Foto Adı'>: #get_asset.ASSET_NAME#</strong><br/>
     <cf_get_lang_main no='359.Detay'>: #get_asset.ASSET_DETAIL#</cfoutput>
    </div>
</cf_box>


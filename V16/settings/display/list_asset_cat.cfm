<cfquery name="ASSETCATS" datasource="#DSN#">
	SELECT 
	    ASSETCAT_ID, 
        ASSETCAT,
        ASSETCAT_MAIN_ID
    FROM 
    	ASSET_CAT
	ORDER BY
		ASSETCAT
</cfquery>

<!---
<table class="workDevList">
    <tr> 
        <td width="250"><b><cf_get_lang no='64.Elektronik Varlık Kategorileri'></b></td>
    </tr>
</table>
<div class="scrollbar" style="max-height:375px;overflow:auto;margin-top:-10px;">
    <table class="workDevList" cellpadding="0" cellspacing="0" border="0">
        <cfif assetCats.recordcount>
            <cfoutput query="assetCats">
                <cfif ASSETCAT_MAIN_ID eq ''>
                    <cfquery name="ASSETCHILDCATS" dbtype="query">
                        SELECT ASSETCAT_ID, ASSETCAT FROM ASSETCATS WHERE ASSETCAT_MAIN_ID = #assetCat_ID# ORDER BY ASSETCAT
                    </cfquery>
                    <tr>
                        <td width="5"><i class="fa fa-folder-o"></i></td>
                        <td>
                            <cfif not FindNoCase('popup', attributes.fuseaction)>
                                <a href="#request.self#?fuseaction=settings.form_upd_asset_cat&ID=#assetCat_ID#" class="tableyazi">#assetCat#</a>
                            <cfelse>
                                <a href="#request.self#?fuseaction=objects.popup_upd_asset_cat&ID=#assetCat_ID#" class="tableyazi">#assetCat#</a>
                            </cfif>
                            <cfif ASSETCHILDCATS.recordcount>
                                <table>
                                    <cfloop query="ASSETCHILDCATS">
                                        <tr>
                                            <td>
                                                <cfif not FindNoCase('popup', attributes.fuseaction)>
                                                    <a href="#request.self#?fuseaction=settings.form_upd_asset_cat&ID=#ASSETCHILDCATS.assetCat_ID#" class="tableyazi">#ASSETCHILDCATS.assetCat#</a>
                                                <cfelse>
                                                    <a href="#request.self#?fuseaction=objects.popup_upd_asset_cat&ID=#ASSETCHILDCATS.assetCat_ID#" class="tableyazi">#ASSETCHILDCATS.assetCat#</a>
                                                </cfif>
                                            </td>
                                        </tr>
                                    </cfloop>       
                                </table>
                            </cfif>
                        </td>
                    </tr>
                </cfif>
            </cfoutput>
        <cfelse>
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
            </tr>
        </cfif>
    </table>
</div>
--->
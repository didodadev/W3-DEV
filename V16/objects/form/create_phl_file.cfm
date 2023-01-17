<cfparam name="attributes.phl_files" default="">
<cf_popup_box title="#getLang('objects',1644)#">
<cfform name="formexport" method="post" action="#request.self#?fuseaction=objects.popup_create_phl_file">
    <table style="width:100%">
        <tr>
            <td style="width:75px;"><cf_get_lang dictionary_id='59274.PHL'></td>
            <td>
                <select name="phl_files" id="phl_files" style="width:150px;">
                	<option value="1">Formula 7400</option>
                </select>
            </td>
                
        </tr>
		<tr>
			<td><cf_get_lang dictionary_id='58964.Fiyat Listesi'></td>
			<td> 
                <cfif isdefined('attributes.is_store')>
                    <input type="hidden" name="is_store" id="is_store" value="1">
                    <cfset attributes.branch_id = listgetat(session.ep.user_location, 2, '-')>
                    <cfquery name="PRICE_CAT" datasource="#DSN3#">
                        SELECT
                            PRICE_CATID,
                            PRICE_CAT
                        FROM
                            PRICE_CAT
                        WHERE
                            PRICE_CAT_STATUS = 1 AND
                            PRICE_CAT.BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.branch_id#,%">
                            ORDER BY
                            PRICE_CAT
                    </cfquery>
                    <input type="hidden" name="price_catid" id="price_catid" value="<cfoutput>#price_cat.price_catid#</cfoutput>">
                    <cfoutput>#price_cat.price_cat#</cfoutput>
               	<cfelse>	
                    <cfinclude template="../query/get_price_cats2.cfm">
                    <select name="price_catid" id="price_catid" style="width:150px;">
                        <option value="-1"><cf_get_lang dictionary_id='58722.Standart Alış'></option>
                        <option value="-2" selected><cf_get_lang dictionary_id='58721.Standart Satış'></option>
                        <cfoutput query="get_price_cats"> 
                        	<option value="#price_catid#"<cfif isDefined("attributes.price_catid") and (price_catid is attributes.price_catid)>selected</cfif>>#price_cat#</option>
                        </cfoutput>
                    </select>
                </cfif>
            </td>
		</tr>
        <tr>
            <td></td>
            <td><input type="checkbox" name="is_product_provision" id="is_product_provision" value="1" checked> <cf_get_lang dictionary_id ='34035.Sadece Tedarik edilen ürünleri Getir'></td>
        </tr>
        <!--- <tr>
        <td height="20"><input type="checkbox" name="from_this_morning" value="1"></td>
        <td>Fiyatı Bu Sabahtan Beri Güncellenenler</td>
        </tr> --->
    </table>
    <cf_popup_box_footer><cf_workcube_buttons type_format="1" is_upd='0'></cf_popup_box_footer>
</cfform>
</cf_popup_box>
<cfswitch expression="#attributes.phl_files#">
<cfcase value="1">
		<!--- pos dan  phl file olustururken--->
        <cfif isdefined("attributes.is_product_provision")>
            <cflocation url="#request.self#?fuseaction=pos.emptypopup_take_phl_file1&is_product_provision=1&price_catid=#attributes.price_catid#" addtoken="no">
        <cfelse>
            <cflocation url="#request.self#?fuseaction=pos.emptypopup_take_phl_file1&price_catid=#attributes.price_catid#" addtoken="no">
        </cfif>
	</cfcase>
</cfswitch>

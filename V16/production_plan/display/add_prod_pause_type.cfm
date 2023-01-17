<cfquery name="get_pauseCat" datasource="#dsn3#">
	SELECT PROD_PAUSE_CAT_ID,PROD_PAUSE_CAT FROM SETUP_PROD_PAUSE_CAT WHERE IS_ACTIVE = 1 ORDER BY PROD_PAUSE_CAT
</cfquery>
<cfquery name="GET_PRODUCT_CATS" datasource="#DSN1#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		PC.PRODUCT_CATID,
		PC.HIERARCHY,
		PC.PRODUCT_CAT
	FROM
		PRODUCT_CAT PC,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PC.PRODUCT_CATID IS NOT NULL AND
		PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		PC.HIERARCHY
</cfquery>
<cfif not isDefined("attributes.draggable")><cf_catalystHeader></cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box id="prod_pause_type" title="#iif(isDefined("attributes.draggable"),"getLang('','Duraklama Tipi Ekle',36741)",DE(''))#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
        <cfform name="prod_pause_type" method="post" action="#request.self#?fuseaction=prod.add_prod_pause_type">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-is_active">
                        <label><cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" name="is_active" id="is_active" value="1"></label>
                    </div>
                    <div class="form-group" id="item-pauseCat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29475.Duraklama Kategorisi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="pauseCat" id="pauseCat" style="width:150px;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_pauseCat">
                                <option value="#prod_pause_cat_id#">#prod_pause_cat#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-pauseType_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="36478.Duraklama Kodu">*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='36478.Duraklama Kodu'></cfsavecontent>
                            <cfinput type="Text" name="pauseType_code" size="60" value="" maxlength="50" required="Yes" message="#message#" style="width:150px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-pauseType">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="36986.Duraklama Tipi">*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='36986.Duraklama Tipi'></cfsavecontent>
                            <cfinput type="Text" name="pauseType" size="60" value="" maxlength="50" required="Yes" message="#message#" style="width:150px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57629.Açıklama"></label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='56293.200 Karakterden Fazla Yazmayınız'></cfsavecontent>
                            <textarea name="detail" id="detail" style="width:150px;height:45px;" maxlength="200" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                     <div class="form-group" id="item-productCat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="productCat" id="productCat" multiple="multiple" style="width:200px;height:75px;">
                            <cfoutput query="GET_PRODUCT_CATS">
                            <option value="#product_catid#">#HIERARCHY#-#product_cat#</option>
                            </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0'>
            </cf_box_footer>
          <!---<table>     
                <tr>
                    <td valign="top"><cf_get_lang dictionary_id='57493.Aktif'></td>
                    <td valign="top"><input type="checkbox" name="is_active" id="is_active" value="1"></td>
                </tr>
                <tr>
                    <td valign="top"><cf_get_lang dictionary_id='29475.Duraklama Kategorisi'></td>
                    <td valign="top" width="170">
                        <select name="pauseCat" id="pauseCat" style="width:150px;">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="get_pauseCat">
                                <option value="#prod_pause_cat_id#">#prod_pause_cat#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td valign="top" rowspan="3"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></td>
                    <td valign="top" rowspan="3">
                        <select name="productCat" id="productCat" multiple="multiple" style="width:200px;height:75px;">
                            <cfoutput query="GET_PRODUCT_CATS">
                                <option value="#product_catid#">#HIERARCHY#-#product_cat#</option>
                            </cfoutput>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td valign="top"><cf_get_lang dictionary_id="36478.Duraklama Kodu">*</td>
                    <td valign="top">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='36478.Duraklama Kodu'></cfsavecontent>
                        <cfinput type="Text" name="pauseType_code" size="60" value="" maxlength="50" required="Yes" message="#message#" style="width:150px;">
                    </td> 
                </tr>
                <tr>
                    <td valign="top"><cf_get_lang dictionary_id="36986.Duraklama Tipi">*</td>
                    <td valign="top">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='36986.Duraklama Tipi'></cfsavecontent>
                        <cfinput type="Text" name="pauseType" size="60" value="" maxlength="50" required="Yes" message="#message#" style="width:150px;">
                    </td> 
                </tr>
                <tr>
                    <td valign="top" rowspan="2"><cf_get_lang dictionary_id="57629.Açıklama"></td>
                    <td valign="top" rowspan="2"><textarea name="detail" id="detail" style="width:150px;height:45px;" maxlength="200" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="200 Karakterden Fazla Yazmayınız!"></textarea></td>
                </tr>
            </table>--->
        </cfform>
    </cf_box>
</div>
    
   


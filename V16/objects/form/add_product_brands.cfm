<cf_get_lang_set module_name="objects">
<cfinclude template="../query/get_our_companies.cfm">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='58847.Marka'>: <cf_get_lang dictionary_id='45697.Yeni Kayıt'></cfsavecontent>
		<cf_box title="#head#" popup_box="1">
        <cfform action="#request.self#?fuseaction=objects.emptypopup_add_product_brands" method="post" name="product_cat" enctype="multipart/form-data">
            <cf_box_elements vertical="1">
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-is_active">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="checkbox" name="is_active" id="is_active" checked value="1"><cf_get_lang dictionary_id ='57493.Aktif'></label>
                        <label class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_internet" id="is_internet" checked value="1"><cf_get_lang dictionary_id ='58079.İnternet'></label>
                    </div>
                    <div class="form-group" id="item-brand_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='33073.Marka girmelisiniz'></cfsavecontent>
                            <cfinput type="Text" name="brand_name" value="" maxlength="75" required="Yes" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-brand_code">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58585.Kod'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="messages"> <cf_get_lang dictionary_id='33952.Kod Girmelisiniz'></cfsavecontent>
                            <cfinput type="Text" name="brand_code" value="" maxlength="50" required="Yes" message="#messages#">
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.açıklama'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='52630.En Fazla 1000 Karakter !'></cfsavecontent>
                            <textarea name="detail" id="detail" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-our_company_ids">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58017.İlişkili Şirketler'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select multiple name="our_company_ids" id="our_company_ids">
                                <cfoutput query="get_our_companies">
                                    <option value="#comp_id#">#nick_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' type_format='1'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
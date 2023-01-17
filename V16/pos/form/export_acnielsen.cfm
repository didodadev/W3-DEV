<cfquery name="get_branch" datasource="#dsn#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cf_catalystHeader>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='36037.AC Nielsen Raporu Oluştur'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="formexport" action="#request.self#?fuseaction=pos.popupflush_export_acnielsen" method="post">
            <cf_box_elements>
                <div class="col col-12 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-is_terazi">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_get_lang dictionary_id ='36060.Tartılı Ürünler Gelmesin'><input name="is_terazi" id="is_terazi" type="checkbox" value="1" style="margin-left:-3px;">
                        </label>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-branch_index">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="branch_index" id="branch_index" style="width:170px">
                                <cfoutput query="get_branch">
                                    <option value="#BRANCH_ID#">#BRANCH_NAME#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-product_catid">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <input type="hidden" name="product_catid" id="product_catid" value="">
                                <input type="hidden" name="hierarchy_code" id="hierarchy_code" value="">
                                <input type="text" name="product_cat" id="product_cat" style="width:170px;" value="">
                                <span class="input-group-addon icon-ellipsis"   onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=formexport.hierarchy_code&field_id=formexport.product_catid&field_name=formexport.product_cat&keyword='+encodeURIComponent(document.formexport.product_cat.value)</cfoutput>);"><img src="/images/plus_thin.gif" border="0" title="<cf_get_lang dictionary_id ='36072.Ürün Kategorisi Ekle'>!" align="absmiddle"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-branch_name">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='36059.ACNielsen Şube Adı'></label>
                        <div class="col col-8 col-sm-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='36073.ACNielsen Şube Adı Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" style="width:170px;" maxlength="100" name="branch_name" required="yes" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-acnielsen_code">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='36058.ACNielsen Kodu'></label>
                        <div class="col col-8 col-sm-12">
                            <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='36126.ACNielsen Kodu Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" style="width:170px;" validate="integer" name="acnielsen_code" required="yes" message="#alert#">
                        </div>
                    </div>
                    <div class="form-group" id="item-startdate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                                <cfinput type="text" style="width:65px;" message="#message#" validate="#validate_style#" name="startdate" maxlength="10" required="yes">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-finishdate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                                <cfinput type="text" style="width:65px;" message="#message#" validate="#validate_style#" name="finishdate" maxlength="10" required="yes">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function="kontrol()">
            </cf_box_footer>  
        </cfform>
    </cf_box>
</div>
               
               
<script type="text/javascript">
	function kontrol()
	{	
		if(formexport.branch_index.value.length==0)
		{
			alert("<cf_get_lang dictionary_id='58579.Lütfen Şube Seçiniz'>!");
			return false;
		}
		return true;		
	}
</script>

<cfquery name="GET_PROPERTY_CAT" datasource="#DSN1#">
    SELECT
        PROPERTY_ID,
        PROPERTY
    FROM 
        PRODUCT_PROPERTY 
</cfquery>
<cf_box title="#getLang('','alternatif sorular','36958')#" popup_box="1">
    <cfform name="form_questions" action="#request.self#?fuseaction=prod.emptypopup_add_alternative_questions" method="post">
        <cf_box_elements>
            <div class="col col-7 col-md-7 col-sm-7 col-xs-12" type="column" index="1" sort="true">
                <cf_duxi type="text" name="question_no" label="57487" hint="No" value="" maxlength="3" required="yes" onKeyUp="isNumber(this);">
                <cf_duxi type="text" name="question_name" label="58810" hint="Soru" value="" maxlength="100" required="Yes">
                    <div class="form-group" id="item-lang_module">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='34311.Alternatif'><cf_get_lang dictionary_id='57692.İşlem'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="alternative_process" id="alternative_process">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1"<cfif isDefined("attributes.alternative_process") and (attributes.alternative_process eq 1)> selected</cfif>><cf_get_lang dictionary_id='57452.Stok'><cf_get_lang dictionary_id='35651.Değiştir'></option>
                                <option value="2"<cfif isDefined("attributes.alternative_process") and (attributes.alternative_process eq 2)> selected</cfif>><cf_get_lang dictionary_id='57686.Ölçü'><cf_get_lang dictionary_id='35651.Değiştir'></option>
                                <option value="3"<cfif isDefined("attributes.alternative_process") and (attributes.alternative_process eq 3)> selected</cfif>><cf_get_lang dictionary_id='57632.Özellik'><cf_get_lang dictionary_id='35651.Değiştir'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-lang_module">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='46057.Ürün Özelliği'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="property_id" id="property_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="GET_PROPERTY_CAT" >
                                        <option value="#PROPERTY_ID#">#PROPERTY#</option>
                                    </cfoutput>
                            </select>
                        </div>
                    </div>
                <cf_duxi type="text" name="question_detail" id="question_detail" label="57629" hint="açıklama" required="yes">
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-12">
                <cf_workcube_buttons is_upd='0' add_function="control()">
            </div>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
	function control()
	{
		var get_no = wrk_safe_query('prdp_get_no','dsn',0,document.form_questions.question_no.value); 
		if(get_no.recordcount)
		{
			alert("<cf_get_lang dictionary_id='60571.Aynı No İle Kayıtlı Başka Bir Soru Mevcut'> !");
			return false;
		}
		if(document.form_questions.question_detail.value == '')
		{
			alert("<cf_get_lang dictionary_id='58194.Girilmesi Zorunlu Alan'>:<cf_get_lang dictionary_id='57629.Açıklama'> !");
			return false;
		}
		return true;
	}
</script>

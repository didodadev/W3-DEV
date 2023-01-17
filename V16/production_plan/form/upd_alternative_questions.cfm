<cfquery name="GET_PROPERTY_CAT" datasource="#DSN1#">
    SELECT
        PROPERTY_ID,
        PROPERTY
    FROM 
        PRODUCT_PROPERTY 
</cfquery>
<cfquery name="get_questions" datasource="#dsn#">
	SELECT * FROM SETUP_ALTERNATIVE_QUESTIONS WHERE QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_id#">
</cfquery>
<cf_box title="#getLang('','Alternatif Ürün Soruları','63637')#" popup_box="1">
    <cfform name="form_questions" action="#request.self#?fuseaction=prod.emptypopup_upd_alternative_questions" method="post">
        <cfinput type="hidden" name="question_id" id="question_id" value="#attributes.question_id#">
    	<cf_box_elements>
            <div class="col col-7 col-md-7 col-sm-7 col-xs-12" type="column" index="1" sort="true">
                <cf_duxi type="text" name="question_no" value="#get_questions.question_no#" maxlength="3" label="57487" hint="No" required="Yes" onKeyUp="isNumber(this);">
                <div class="form-group" id="item-question_name">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58810.Soru'>*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Girilmesi Zorunlu Alan'>:<cf_get_lang dictionary_id='36958.Alternatif Sorusu'></cfsavecontent>
                            <cfinput type="text" name="question_name" value="#get_questions.question_name#" maxlength="100" required="Yes" message="#message#" >
                            <span class="input-group-addon">
                            <cf_language_info 
                            table_name="SETUP_ALTERNATIVE_QUESTIONS" 
                            column_name="QUESTION_NAME" 
                            column_id_value="#url.question_id#" 
                            maxlength="100" 
                            datasource="#dsn#" 
                            column_id="QUESTION_ID" 
                            control_type="0">
                            </span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-lang_module">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='34311.Alternatif'><cf_get_lang dictionary_id='57692.İşlem'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="alternative_process" id="alternative_process">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <option value="1"<cfif (get_questions.alternative_process eq 1)> selected</cfif>><cf_get_lang dictionary_id='57452.Stok'><cf_get_lang dictionary_id='35651.Değiştir'></option>
                            <option value="2"<cfif (get_questions.alternative_process eq 2)> selected</cfif>><cf_get_lang dictionary_id='57686.Ölçü'><cf_get_lang dictionary_id='35651.Değiştir'></option>
                            <option value="3"<cfif (get_questions.alternative_process eq 3)> selected</cfif>><cf_get_lang dictionary_id='57632.Özellik'><cf_get_lang dictionary_id='35651.Değiştir'></option>
                        </select>
                    </div>
                </div>
                 <div class="form-group" id="item-property_id">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='46057.Ürün Özelliği'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="property_id" id="property_id">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="GET_PROPERTY_CAT">
                                    <option value="#PROPERTY_ID#"<cfif GET_PROPERTY_CAT.property_id  eq get_questions.property_id>selected</cfif>>#PROPERTY#</option>
                                </cfoutput>
                        </select>
                    </div>
                </div> 
                <div class="form-group" id="item-question_detail">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'>*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <textarea name="question_detail" id="question_detail" ><cfoutput>#get_questions.question_detail#</cfoutput></textarea>
                            <span class="input-group-addon">
                            <cf_language_info 
                            table_name="SETUP_ALTERNATIVE_QUESTIONS" 
                            column_name="QUESTION_DETAIL" 
                            column_id_value="#url.question_id#" 
                            maxlength="100" 
                            datasource="#dsn#" 
                            column_id="QUESTION_ID" 
                            control_type="0">
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box_elements>   
        <cf_box_footer>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <cf_record_info query_name='get_questions'>
            </div>
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_workcube_buttons is_upd='1' add_function="control()" delete_page_url='#request.self#?fuseaction=prod.emptypopup_del_alternative_questions&question_id=#attributes.question_id#'>
            </div>
            </div>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
	function control()
	{
		var get_no = wrk_safe_query('prdp_get_no','dsn',0,document.form_questions.question_no.value);
		if(get_no.recordcount && get_no.QUESTION_ID !=document.form_questions.question_id.value)
		{
			alert("<cf_get_lang dictionary_id='60571.Aynı No İle Kayıtlı Başka Bir Soru Mevcut'> !");
			return false;
		}
		if(document.form_questions.question_detail.value == '')
		{
			alert("<cf_get_lang dictionary_id='58194.Girilmesi Zorunlu Alan'>: <cf_get_lang dictionary_id='57629.Açıklama'> !");
			return false;
		}
		return true;
	}
</script>

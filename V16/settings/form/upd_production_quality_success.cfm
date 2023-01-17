<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='37000.Kalite Başarımı'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.add_production_quality_success" is_blank="0">

            <cfform name="care_form"  method="post"action="#request.self#?fuseaction=settings.emptypopup_upd_production_quality">
                        <cf_box_elements>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                <cfinclude template="../display/quality_success.cfm">
                            </div>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <input type="hidden" id="id" name="id" value="<cfoutput>#attributes.id#</cfoutput>" /> 
                            <cfset get_queries = createObject("component","V16.production_plan.cfc.get_succes_name")>
                            <cfset get_quality_success =get_queries.get_succes_name(id:attributes.ID)>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                                <div class="form-group" id="item-is_success_type">
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12"> &nbsp </div>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                            <input type="radio" name="is_success_type" id="is_success_type" value="1" <cfif get_quality_success.is_success_type eq 1>checked</cfif>><cf_get_lang dictionary_id='42792.Kabul'>
                                        </div>
                                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                            <input type="radio" name="is_success_type" id="is_success_type" value="0" <cfif get_quality_success.is_success_type eq 0>checked</cfif>><cf_get_lang dictionary_id='29537.Red'>
                                        </div>
                                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                            <input type="radio" name="is_success_type" id="is_success_type" value="2" <cfif get_quality_success.is_success_type eq 2>checked</cfif>><cf_get_lang dictionary_id='42799.Yeniden Muayene'>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-qua-success">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37000.Kalite Başarımı'>*</label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'>!</cfsavecontent>
                                            <div class="input-group">
                                                <cfinput type="Text" name="QUA_SUC" id="QUA_SUC" value="#get_quality_success.SUCCESS#" maxlength="50">
                                                <span class="input-group-addon">   
                                                    <cf_language_info 
                                                        table_name="QUALITY_SUCCESS"
                                                        column_name="SUCCESS" 
                                                        column_id_value="#attributes.ID#" 
                                                        maxlength="50" 
                                                        datasource="#dsn3#" 
                                                        column_id="SUCCESS_ID"
                                                        control_type="0">
                                                </span>  
                                            </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-quality-color">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43496.Renk Kodu'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cf_workcube_color_picker name="quality_color" value="#get_quality_success.quality_color#" width="200">
                                    </div>
                                </div>
                                <div class="form-group" id="item-quality-code">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58585.Kod'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="Text" name="code" value="#get_quality_success.code#" id="code" maxlength="50">
                                    </div>
                                </div>
                                <div class="form-group" id="item-detail">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                    <div class="col col-8 col-xs-12">
                                        <textarea name="DETAIL" id="DETAIL" style="height:60px;"><cfoutput>#get_quality_success.DETAIL#</cfoutput></textarea>

                                    </div>
                                </div>
                                <div class="form-group" id="item-is_default_type">
                                    <div class="col col-4 col-xs-12">&nbsp</div>
                                    <div class="col col-8 col-xs-12">
                                        <input type="checkbox" name="is_default_type" id="is_default_type" value="1" <cfif get_quality_success.is_default_type eq 1>checked</cfif>><cf_get_lang dictionary_id='43115.Standart Seçenek Olarak Gelsin'>
                                    </div>
                                </div>
                            </div>
                        </div>
                        </cf_box_elements>
                        <cf_box_footer>
                            <cf_record_info query_name="get_quality_success">
								<cfif get_quality_success.recordcount>
									<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
								<cfelse>
									<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_lib_cat&id=#attributes.id#'>
								</cfif> 
                        </cf_box_footer>
			</cfform>
  	</cf_box>
</div>
<script type="text/javascript">
    function kontrol()
	{
		if(document.getElementById("QUA_SUC").value == '')
		{
			alert('<cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'>!')
			return false;
		}
	}

</script>

<cfinclude template="../query/get_caution.cfm">
<cfquery name="get_caution_type" datasource="#dsn#">
	SELECT 
	    CAUTION_TYPE_ID, 
        CAUTION_TYPE, 
        DETAIL, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP
    FROM 
    	SETUP_CAUTION_TYPE 
	WHERE
		IS_ACTIVE = 1
	ORDER BY
		CAUTION_TYPE
</cfquery>
<cfquery name="GET_SPECIAL_DEFINITION" datasource="#dsn#">
    SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 11
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">    
    <div class="col col-8 col-xs-12">
        <cf_box title="">   
            <cfform action="#request.self#?fuseaction=ehesap.emptypopup_upd_caution" name="upd_caution" method="post">
                <input type="hidden" value="<cfoutput>#attributes.caution_id#</cfoutput>" name="caution_id" id="caution_id">
                <cf_box_elements>
                    <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-is_active">
                            <label class="col col-3 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='57493.Aktif'></span></label>
                            <label class="col col-9 col-xs-12">
                                <input type="checkbox" name="is_active" id="is_active" <cfif get_caution.is_active eq 1>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
                            </label>
                        </div>
                        <div class="form-group" id="item-caution_head">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'></label>
                            <div class="col col-9 col-xs-12">
                                <input type="text" name="caution_head" style="width:150px;" maxlength="50" value="<cfoutput>#get_caution.caution_head#</cfoutput>">
                            </div>
                        </div>
                        <div class="form-group" id="item-CAUTION_TYPE">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57630.Tip'></label>
                            <div class="col col-9 col-xs-12">
                                <select name="CAUTION_TYPE" id="CAUTION_TYPE" style="width:150px;">
                                    <cfoutput query="get_caution_type">
                                        <option value="#CAUTION_TYPE_ID#"<cfif CAUTION_TYPE_ID EQ get_caution.CAUTION_TYPE_ID>SELECTED</cfif>>#CAUTION_TYPE#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-DATE">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <input validate="#validate_style#" type="text" name="DATE" id="DATE" value="<cfoutput>#dateformat(get_caution.CAUTION_DATE,dateformat_style)#</cfoutput>" style="width:150px;">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="DATE"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                            <div class="col col-9 col-xs-12">
                                <cf_workcube_process is_upd='0' select_value='#get_caution.stage#' process_cat_width='150' is_detail='1'>
                            </div>
                        </div>
                        <div class="form-group" id="item-DECISION_NO">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58772.İşlem No'></label>
                            <div class="col col-9 col-xs-12">
                                <input  type="text" name="DECISION_NO" id="DECISION_NO" value="<cfoutput>#get_caution.DECISION_NO#</cfoutput>" style="width:150px;">
                            </div>
                        </div>
                        <div class="form-group" id="item-warner">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58586.İşlem Yapan'>*</label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="warner_id" id="warner_id" value="<cfoutput>#get_caution.warner#</cfoutput>">
                                    <input type="text" name="warner" id="warner" style="width:150px;" value="<cfoutput>#get_caution.warner_name#</cfoutput>">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="<cfoutput>windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_emp_id=upd_caution.warner_id&field_emp_name=upd_caution.warner','list');return false</cfoutput>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-caution_to">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53515.İşlem Yapılan'>*</label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <cfset attributes.employee_id = get_caution.caution_to>
                                    <cfinclude template="../query/get_employee.cfm">					
                                    <input type="hidden" name="caution_to_id" id="caution_to_id" value="<cfoutput>#get_caution.caution_to#</cfoutput>">
                                    <input type="text" name="caution_to" id="caution_to" style="width:150px;" value="<cfoutput>#get_emp_info(get_caution.caution_to,0,0)#</cfoutput>">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="<cfoutput>windowopen('#request.self#?fuseaction=objects.popup_list_positions&select_list=1,9&field_emp_id=upd_caution.caution_to_id&field_name=upd_caution.caution_to','list');return false</cfoutput>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-apology_date">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="59305.Savunma Tarihi"></label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <input validate="#validate_style#" type="text" name="apology_date" id="apology_date" value="<cfoutput>#dateformat(get_caution.apology_date,dateformat_style)#</cfoutput>" style="width:150px;">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="apology_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-special_definition">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="59306.Özel Tanım"></label>
                            <div class="col col-9 col-xs-12">
                                <select name="special_definition" id="special_definition" style="width:150px">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="GET_SPECIAL_DEFINITION">
                                        <option value="#special_definition_id#" <cfif get_caution.special_definition_id eq special_definition_id>selected="selected"</cfif>>#special_definition#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53275.Kesinti Türü'></label>
							<div class="col col-9 col-xs-12">
								<div class="input-group">
                                    <cfoutput>
                                        <input type="hidden" name="interruption_id" id="interruption_id" value="#get_caution.interruption_id#" />
                                        <input type="text" name="interruption_name" id="interruption_name"  value="#get_caution.comment_pay#" readonly >
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.popup_list_kesinti&is_disciplinary_punishment=1');"></span>
                                    </cfoutput>
								</div>
							</div>
						</div>
                        <div class="form-group">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='64060.Disiplin Ceza Kesintisi'></label>
							<div class="col col-9 col-xs-12">
                                <cfoutput>
                                    <div class="col col-5 col-xs-5">
                                        <input type="number" name="interruption_dividend" id="interruption_dividend"  value="#get_caution.interruption_dividend#" min="1" max="30">
                                    </div>
                                    <div class="col col-2 col-xs-2" style="text-align : center">
                                        /
                                    </div>
                                    <div class="col col-5 col-xs-5">
                                        <input type="number" name="interruption_denominator" id="interruption_denominator"  value="#get_caution.interruption_denominator#" min="1" max="30">
                                    </div>
                                </cfoutput>
							</div>
						</div>
                        <div class="form-group" id="item-is_discipline_center">
                            <label class="col col-3 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='53339.Merkez Disiplin Kurulu'></span></label>
                            <label class="col col-9 col-xs-12">
                                <input type="checkbox" name="is_discipline_center" id="is_discipline_center" <cfif get_caution.is_discipline_center eq 1>checked</cfif>><cf_get_lang dictionary_id='53339.Merkez Disiplin Kurulu'>
                            </label>
                        </div>
                        <div class="form-group" id="item-is_discipline_branch">
                            <label class="col col-3 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='53340.Şube Disiplin Kurulu'></span></label>
                            <label class="col col-9 col-xs-12">
                                <input type="checkbox" name="is_discipline_branch" id="is_discipline_center" <cfif get_caution.is_discipline_branch eq 1>checked</cfif>><cf_get_lang dictionary_id='53340.Şube Disiplin Kurulu'>
                            </label>
                        </div>
                        <div class="form-group" id="item-CAUTION_DETAIL">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='30937.Gerekçe'></label>
                            <div class="col col-9 col-xs-12">
                                <textarea style="width:250px;height:85px;" name="CAUTION_DETAIL" id="CAUTION_DETAIL"><cfoutput>#get_caution.caution_detail#</cfoutput></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-apol">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53092.Savunma'></label>
                            <div class="col col-9 col-xs-12">
                                <textarea style="width:250px;height:85px;" name="apol" id="apol"><cfoutput>#get_caution.apology#</cfoutput></textarea>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <div class="col col-6">
                        <cf_record_info query_name="get_caution">
                    </div>
                    <div class="col col-6">
                        <cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_caution&caution_id=#attributes.caution_id#'>
                    </div>
                </cf_box_footer>
            </cfform>
        </cf_box>
    </div>  
    <div class="col col-4 col-xs-12">
        <!--- Belgeler --->
        <cf_get_workcube_asset asset_cat_id="-8" module_id='48' action_section='CAUTION_ID' action_id='#attributes.caution_id#'>        
    </div>   
</div>

<script type="text/javascript">
	function kontrol()
	{
		if (upd_caution.warner.value == "")
			{
			alert("<cf_get_lang dictionary_id ='54007.İhtar Eden Seçmelisiniz'>!");
					return false;
			}
			
		if (upd_caution.caution_to.value == "")
			{
			alert("<cf_get_lang dictionary_id ='54008.İhtar Alan Seçmelisiniz'>!");
					return false;
			}
		return true;	
	}
    function add_row(from_salary,show,comment_pay,period_pay,method_pay,term,start_sal_mon,end_sal_mon,amount_pay,calc_days,ehesap,row_id_,account_code,company_id,fullname,account_name,consumer_id,money,acc_type_id,tax,odkes_id)
	{
        document.getElementById('interruption_name').value = comment_pay;
        document.getElementById('interruption_id').value = odkes_id;
	}
</script>

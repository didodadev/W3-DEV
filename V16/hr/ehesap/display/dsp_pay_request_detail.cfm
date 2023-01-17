<cfinclude template="../query/get_payment_request.cfm">
<cfif fuseaction contains "popup">
	<cfset is_popup=1>
<cfelse>
	<cfset is_popup=0>
</cfif>
<cfquery name="get_demand_type" datasource="#dsn#">
	SELECT * FROM SETUP_PAYMENT_INTERRUPTION WHERE ISNULL(IS_DEMAND,0) = 1
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','','53503')#" add_href="openBoxDraggable('#request.self#?fuseaction=ehesap.popup_add_payment_request')" print_href="index.cfm?fuseaction=ehesap.list_payment_requests&event=upd&id=115&is_print=1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="upd_payment" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_upd_pay_request&id=#attributes.id#&employee_id=#get_payment_request.TO_EMPLOYEE_ID#">
        <input type="hidden" name="id" id="id" value="<cfoutput>#id#</cfoutput>">
        <input type="hidden" name="modal_id" id="modal_id" value="<cfoutput>#attributes.modal_id#</cfoutput>">
        <cf_box_elements>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-subject">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57480.Konu'></label>
                    <label class="col col-8 col-xs-12">
                        <cfoutput>#get_payment_request.subject#</cfoutput>
                    </label>
                </div>
                <div class="form-group" id="item-demand_type">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='31578.Avans Tipi'></label>
                    <div class="col col-6 col-xs-12">
                        <select name="demand_type" id="demand_type">
                            <cfoutput query="get_demand_type">
                                <option value="#odkes_id#" <cfif get_payment_request.demand_type eq odkes_id>selected</cfif>>#comment_pay#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-priority">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57485.Öncelik'></label>
                    <label class="col col-8 col-xs-12">
                        <cfset attributes.priority_id=#get_payment_request.priority#>
                        <cfinclude template="../query/get_priority.cfm">
                        <cfoutput>#get_priority.priority#</cfoutput>
                    </label>
                </div>
                <div class="form-group" id="item-duedate">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57640.Vade'></label>
                    <label class="col col-8 col-xs-12">
                        <cfoutput>#dateformat(get_payment_request.duedate,dateformat_style)#</cfoutput>
                    </label>
                </div>
                <div class="form-group" id="item-emp_info">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                    <label class="col col-8 col-xs-12">
                        <cfif len(get_payment_request.TO_EMPLOYEE_ID)>
                            <cfoutput>#get_emp_info(get_payment_request.TO_EMPLOYEE_ID,0,0)#</cfoutput>
                        </cfif>
                    </label>
                </div>
                <div class="form-group" id="item-amount">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57673.tutar'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfif isdefined("attributes.is_print") and len(attributes.is_print)>
                                <cfoutput>#TLFormat(get_payment_request.AMOUNT)#&nbsp;#get_payment_request.MONEY#</cfoutput>
                            <cfelse>
                                <cfinput type="text" value="#TLFormat(get_payment_request.AMOUNT)#" name="amount" style="width:150px;text-align:right;" onkeyup="return(FormatCurrency(this,event));"> <span class="input-group-addon no-bg"><cfoutput>#get_payment_request.MONEY#</cfoutput></span>
                                <input type="hidden" name="old_amount" id="old_amount" value="<cfoutput>#get_payment_request.AMOUNT#</cfoutput>">
                            </cfif>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-employee_in_out_id">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='54066.Giriş - Çıkış Kaydı'></label>
                    <div class="col col-8 col-xs-12">
                        <cfquery name="GET_IN_OUTS" datasource="#DSN#">
                            SELECT 
                                EIO.IN_OUT_ID,E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME,B.BRANCH_NAME 
                            FROM 
                                EMPLOYEES_IN_OUT EIO,
                                EMPLOYEES E,
                                BRANCH B
                            WHERE 
                                E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
                                B.BRANCH_ID = EIO.BRANCH_ID AND
                                EIO.EMPLOYEE_ID = #get_payment_request.TO_EMPLOYEE_ID# AND 
                                (EIO.FINISH_DATE IS NULL OR EIO.FINISH_DATE >= #CREATEODBCDATETIME(now())#)
                        </cfquery>
                        <cfif GET_IN_OUTS.recordcount gt 0>
                            <cfif isdefined('attributes.is_print')>
                                <cfoutput>#GET_IN_OUTS.EMPLOYEE_NAME# #GET_IN_OUTS.EMPLOYEE_SURNAME# - #GET_IN_OUTS.BRANCH_NAME#</cfoutput>
                            <cfelse>
                                <select name="employee_in_out_id" id="employee_in_out_id" style="width:150px;">
                                    <cfoutput query="GET_IN_OUTS">
                                    <option value="#in_out_id#" <cfif len(get_payment_request.in_out_id) and get_payment_request.in_out_id eq in_out_id>selected="selected"</cfif>>#BRANCH_NAME#</option>
                                    </cfoutput>
                                </select>
                            </cfif>
                        </cfif>
                    </div>
                </div>
                <div class="form-group" id="item-DETAIL">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput>#get_payment_request.DETAIL#</cfoutput>
                    </div>
                </div>
                <cfif len(get_payment_request.validator_position_code_1) and not len(get_payment_request.valid_1)>
                    <div class="form-group" id="item-position_code_1">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id ='41834.Birinci Amir Onay'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_emp_info(get_payment_request.validator_position_code_1,1,0)#</cfoutput><cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                        </label>
                    </div>
                <cfelseif len(get_payment_request.validator_position_code_1) and len(get_payment_request.valid_1) and get_payment_request.valid_1 eq 1>
                    <div class="form-group" id="item-position_code_1">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id ='41834.Birinci Amir Onay'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_emp_info(get_payment_request.validator_position_code_1,1,0)#</cfoutput><cf_get_lang dictionary_id='58699.Onaylandı'>
                        </label>
                    </div>
                <cfelseif len(get_payment_request.validator_position_code_1) and len(get_payment_request.valid_1) and get_payment_request.valid_1 eq 0>
                    <div class="form-group" id="item-valid_1_detail">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_payment_request.valid_1_detail#</cfoutput>
                        </label>
                    </div>
                    <div class="form-group" id="item-position_code_2">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id ='41834.Birinci Amir Onay'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_emp_info(get_payment_request.validator_position_code_1,1,0)#</cfoutput><cf_get_lang dictionary_id ='57617.Reddedildi'>
                        </label>
                    </div>
                    <div class="form-group" id="item-valid_1_detail">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_payment_request.valid_1_detail#</cfoutput>
                        </label>
                    </div>
                </cfif> 
                <cfif len(get_payment_request.validator_position_code_2) and not len(get_payment_request.valid_2)>
                    <div class="form-group" id="item-position_code_2">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id ='41832.ikinci Amir Onay'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_emp_info(get_payment_request.validator_position_code_2,1,0)#</cfoutput><cf_get_lang dictionary_id ='57615.Onay Bekliyor'> !
                        </label>
                    </div>
                    <cfelseif len(get_payment_request.validator_position_code_2) and get_payment_request.valid_2 eq 1> 
                    <div class="form-group" id="item-position_code_2">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id ='41832.İkinci Amir Onay'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_emp_info(get_payment_request.validator_position_code_2,1,0)#</cfoutput><cf_get_lang dictionary_id='58699.Onaylandı'>
                        </label>
                    </div>
                    <cfelseif len(get_payment_request.validator_position_code_2) and get_payment_request.valid_2 eq 0>
                    <div class="form-group" id="item-valid_2_detail">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id ='57629.Açıklama'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_payment_request.valid_2_detail#</cfoutput>
                        </label>
                    </div>
                    <div class="form-group" id="item-validator_position_code_2">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id ='41832.İkinci Amir Onay'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_emp_info(get_payment_request.validator_position_code_2,1,0)#</cfoutput><cf_get_lang dictionary_id ='57617.Reddedildi'>
                        </label>
                    </div>
                    <div class="form-group" id="item-valid_2_detail">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_payment_request.valid_2_detail#</cfoutput>
                        </label>
                    </div>
                    </cfif>
                <div class="form-group" id="item-STATUS">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57756.Durum'></label>
                    <label class="col col-8 col-xs-12">
                        <cfif get_payment_request.STATUS eq 1 >
                            <cf_get_lang dictionary_id='58699.Onaylandı'>!
                        <cfelse>
                            <cf_get_lang dictionary_id='57617.Red Edildi'>!
                        </cfif>
                        <cfif len(get_payment_request.VALID_EMP)>
                            <cfoutput><b>#get_emp_info(get_payment_request.VALID_EMP,0,0)#</b></cfoutput>
                        </cfif>
                    </label>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-6">
                <cf_record_info query_name="get_payment_request">
            </div>
            <div class="col col-6">
                <cfif len(get_payment_request.action_id)>
                    <div style="float:right; margin-right:10px;"><font color="##FF0000"><cf_get_lang dictionary_id="41831.Talebe Ait Ödeme Kaydı Olduğu İçin Güncelleme Yapılamaz"> !</font></div>
                <cfelse>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57463.Sil'></cfsavecontent>
                    <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_payment_request&id=#attributes.id#&employee_id=#get_payment_request.TO_EMPLOYEE_ID#&modal_id=#attributes.modal_id#' add_function="kontrol_et()">
                </cfif>
            </div>
        </cf_box_footer>
            
    </cfform>
</cf_box>
<cfif isdefined("attributes.is_print")>
	<script type="text/javascript">
		function waitfor()
		{
			window.close();
		}	
		setTimeout("waitfor()",3000);
		window.print();
	</script>
</cfif>
<script type="text/javascript">
	function kontrol_et()
	{
		if (!document.upd_payment.amount.value.length)
			{
				alert("<cf_get_lang dictionary_id='54619.Tutar Girmelisiniz'>!");
				return false;
			}
		document.upd_payment.amount.value = filterNum(document.upd_payment.amount.value);
	}
    $( ".catalyst-plus" ).click(function() {
 window.close();
});
</script>

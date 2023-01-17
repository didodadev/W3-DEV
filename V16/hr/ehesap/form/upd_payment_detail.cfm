<cfif attributes.fuseaction neq 'ehesap.list_interruption' and attributes.fuseaction neq 'ehesap.list_payments'>
    <cf_xml_page_edit>
</cfif>
<cfif isdefined("attributes.is_payment")>
	<cfquery name="get_payments" datasource="#DSN#">
		SELECT 
			EMPLOYEE_ID,
			COMMENT_PAY COMMENT,
			AMOUNT_PAY AMOUNT,
			METHOD_PAY METHOD,
			START_SAL_MON,
			END_SAL_MON,
            RECORD_EMP,
            RECORD_DATE,
            UPDATE_EMP,
            UPDATE_DATE,
            PROCESS_STAGE
		FROM 
			SALARYPARAM_PAY
		WHERE
			EMPLOYEE_ID IS NOT NULL AND
			SPP_ID = #attributes.id#
	</cfquery>
<cfelseif isdefined("attributes.is_interruption")>	
	<cfquery name="get_payments" datasource="#DSN#">
		SELECT 
			EMPLOYEE_ID,
			COMMENT_GET COMMENT,
			AMOUNT_GET AMOUNT,
			METHOD_GET METHOD,
			START_SAL_MON,
			END_SAL_MON,
            RECORD_EMP,
            RECORD_DATE,
            UPDATE_EMP,
            UPDATE_DATE,
            PROCESS_STAGE
		FROM 
			SALARYPARAM_GET
		WHERE
			EMPLOYEE_ID IS NOT NULL AND
			SPG_ID = #attributes.id#
	</cfquery>
<cfelseif isdefined("attributes.is_tax_except")>	
	<cfquery name="get_payments" datasource="#DSN#">
		SELECT 
			EMPLOYEE_ID,
			TAX_EXCEPTION COMMENT,
			AMOUNT,
			START_MONTH START_SAL_MON,
			FINISH_MONTH END_SAL_MON,
            RECORD_EMP,
            RECORD_DATE,
            UPDATE_EMP,
            UPDATE_DATE
		FROM 
			SALARYPARAM_EXCEPT_TAX
		WHERE
			EMPLOYEE_ID IS NOT NULL AND
			TAX_EXCEPTION_ID = #attributes.id#
	</cfquery>
<cfelseif isdefined("attributes.is_bes")>	
	<cfquery name="get_payments" datasource="#DSN#">
		SELECT 
			EMPLOYEE_ID,
			COMMENT_BES COMMENT,
			RATE_BES AMOUNT,
			START_SAL_MON,
			END_SAL_MON,
            RECORD_EMP,
            RECORD_DATE,
            UPDATE_EMP,
            UPDATE_DATE,
            SOCIETY_TYPES=(SELECT SETUP_SOCIAL_SOCIETY.SOCIETY FROM SETUP_SOCIAL_SOCIETY WHERE SETUP_SOCIAL_SOCIETY.SOCIETY_ID= SALARYPARAM_BES.SOCIETY_TYPE )
		FROM 
			SALARYPARAM_BES
		WHERE
			EMPLOYEE_ID IS NOT NULL AND
			SPB_ID = #attributes.id#
	</cfquery>
</cfif>
<cfif attributes.fuseaction is 'ehesap.list_interruption'>
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='32191.Kesinti'></cfsavecontent>
<cfelse>
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='63079.BES'>-<cf_get_lang dictionary_id='63080.Bireysel Emeklilik'></cfsavecontent>
</cfif>
    <cf_box title="#title#" popup_box="1">
    <cfform name="upd_payment" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_upd_payment&id=#attributes.id#&employee_id=#get_payments.EMPLOYEE_ID#">
        <input type="hidden" name="id" id="id" value="<cfoutput>#id#</cfoutput>">
        <input type="hidden" name="is_payment" id="is_payment" value="<cfif isdefined("attributes.is_payment")><cfoutput>#attributes.is_payment#</cfoutput></cfif>">
        <input type="hidden" name="is_interruption" id="is_interruption" value="<cfif isdefined("attributes.is_interruption")><cfoutput>#attributes.is_interruption#</cfoutput></cfif>">
        <input type="hidden" name="is_tax_except" id="is_tax_except" value="<cfif isdefined("attributes.is_tax_except")><cfoutput>#attributes.is_tax_except#</cfoutput></cfif>">
        <input type="hidden" name="is_bes" id="is_bes" value="<cfif isdefined("attributes.is_bes")><cfoutput>#attributes.is_bes#</cfoutput></cfif>">
        <cf_box_elements>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-EMPLOYEE_ID">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                    <label class="col col-8 col-xs-12">
                        <cfif len(get_payments.EMPLOYEE_ID)>
                            <cfoutput>#get_emp_info(get_payments.EMPLOYEE_ID,0,0)#</cfoutput>
                        </cfif>
                    </label>
                </div>
                <div class="form-group" id="item-get_payments">
                    <label class="col col-4 col-xs-12 txtbold"><cfif isdefined("attributes.is_payment")><cf_get_lang dictionary_id='53290.Ödenek Türü'><cfelseif isdefined("attributes.is_interruption")><cf_get_lang dictionary_id='53275.Kesinti Türü'><cfelseif isdefined("attributes.is_tax_except")><cf_get_lang dictionary_id='53017.Vergi İstisnası'><cfelseif isdefined("attributes.is_bes")><cf_get_lang dictionary_id="59344.Otomatik BES Türü"></cfif></label>
                    <label class="col col-8 col-xs-12">
                        <cfoutput>#get_payments.comment#</cfoutput>
                    </label>
                </div>
                <cfif not isdefined("attributes.is_tax_except") and not isdefined("attributes.is_bes")>
                    <div class="form-group" id="item-method">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='29472.Yöntem'></label>
                        <label class="col col-8 col-xs-12">
                            <cfif isdefined("attributes.is_payment")>
                                <cfif get_payments.method eq 1>
                                    <cf_get_lang dictionary_id='53136.Artı'>
                                <cfelse>
                                    %
                                </cfif>
                            <cfelseif isdefined("attributes.is_interruption")>
                                <cfif get_payments.method eq 1>
                                    <cf_get_lang dictionary_id='53134.Eksi'>
                                <cfelse>
                                    %
                                </cfif>
                            </cfif>
                        </label>
                    </div>
                    <div class="form-group" id="item-process">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
                        <div class="col col-8 col-xs-12"> 
                            <cf_workcube_process is_upd='0' select_value='#get_payments.PROCESS_STAGE#' process_cat_width='188' is_detail='1'>
                        </div>
                    </div>
                </cfif>
                <cfif isdefined("get_payments.society_types") and len(get_payments.society_types)>
                    <div class="form-group" id="item-society_type">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='62968.Sigorta Kurumu'></label>
                        <label class="col col-8 col-xs-12"><cfoutput>#get_payments.society_types#</cfoutput></label>
                    </div>
                </cfif>
                <div class="form-group" id="item-start_sal_mon">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="start_sal_mon" id="start_sal_mon" style="width:65px;">
                            <cfoutput>
                                <cfloop from="1" to="12" index="j">
                                    <option value="#j#"<cfif get_payments.start_sal_mon eq j> selected</cfif>>#listgetat(ay_list(),j,',')#</option>
                                </cfloop>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-end_sal_mon">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57502.Bitiş'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="end_sal_mon" id="end_sal_mon" style="width:65px;">
                            <cfoutput>
                                <cfloop from="1" to="12" index="j">
                                    <option value="#j#"<cfif get_payments.end_sal_mon eq j> selected</cfif>>#listgetat(ay_list(),j,',')#</option>
                                </cfloop>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-amount_pay">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57635.Miktar'></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" value="#TLFormat(get_payments.amount,2)#" name="amount_pay" id="amount_pay" style="width:65px;text-align:right;" onkeyup="return(FormatCurrency(this,event,2));">
                    </div>
                </div>
            </div>
        </cf_box_elements>       
        <cf_box_footer>
            <cf_record_info query_name="get_payments">
            <cfif isdefined("attributes.is_payment")>
                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_payment&id=#attributes.id#&employee_id=#get_payments.EMPLOYEE_ID#&is_payment=1' add_function="kontrol_et()">
            <cfelseif isdefined("attributes.is_interruption")>
                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_payment&id=#attributes.id#&employee_id=#get_payments.EMPLOYEE_ID#&is_interruption=1' add_function="kontrol_et()">
            <cfelseif isdefined("attributes.is_tax_except")>
                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_payment&id=#attributes.id#&employee_id=#get_payments.EMPLOYEE_ID#&is_tax_except=1' add_function="kontrol_et()">
            <cfelseif isdefined("attributes.is_bes")>
                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_payment&id=#attributes.id#&employee_id=#get_payments.EMPLOYEE_ID#&is_bes=1' add_function="kontrol_et()">
            </cfif>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
function kontrol_et()
{
    var employee_id = <cfoutput>#get_payments.EMPLOYEE_ID#</cfoutput>;
	if (!document.getElementById('amount_pay').value.length)
	{
		alert("<cf_get_lang dictionary_id='54619.Tutar Girmelisiniz'>!");
		return false;
	}
	document.getElementById('amount_pay').value = filterNum(document.getElementById('amount_pay').value,4);
    if(document.getElementById('process_stage').value == '')
    {
        alert("<cf_get_lang dictionary_id='58842.Lütfen Süreç Seçiniz'>!")
        return false;
    }
    <cfif attributes.fuseaction neq 'ehesap.list_interruption' and attributes.fuseaction neq 'ehesap.list_payments'>
        var new_sql = "SELECT DATEDIFF(YEAR,BIRTH_DATE,GETDATE()) AS YAS,* FROM EMPLOYEES_IDENTY WHERE EMPLOYEE_ID ="+employee_id;
        var get_age = wrk_query(new_sql,'dsn');
        var xml_bes_age = <cfoutput>#xml_bes_definition_age#</cfoutput>;
        var emp_age_ = get_age.YAS[0];
        if (emp_age_ > xml_bes_age)
        {
            alert('<cf_get_lang dictionary_id="40114.Çalışan Yaşı">' + xml_bes_age + ' <cf_get_lang dictionary_id="64067.yaşından büyük olduğu için Bes sistemine dahil edilemez.">');
            return false;
        }
    </cfif>
}
</script>

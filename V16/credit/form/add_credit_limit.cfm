<cfquery name="GET_MONEY_RATE" datasource="#DSN2#">
	SELECT * FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>
<cfquery name="get_credit_type" datasource="#dsn#">
	SELECT * FROM SETUP_CREDIT_TYPE
</cfquery>
<cfif isdefined("attributes.credit_limit_id")>
	<cfquery name="get_credit_contract" datasource="#dsn3#">
		SELECT * FROM CREDIT_CONTRACT WHERE CREDIT_LIMIT_ID = #attributes.credit_limit_id#
	</cfquery>
<cfelse>
	<cfset get_credit_contract.recordcount=0>
</cfif>
<cfif isdefined("attributes.credit_limit_id")>
	<cfquery name="get_credit_detail" datasource="#dsn3#">
		SELECT #dsn#.Get_Dynamic_Language(CREDIT_LIMIT_ID,'#session.ep.language#','CREDIT_LIMIT','LIMIT_HEAD',NULL,NULL,LIMIT_HEAD) AS LIMIT_HEAD,* FROM CREDIT_LIMIT WHERE CREDIT_LIMIT_ID = #attributes.credit_limit_id#
	</cfquery>
	<cfset account_id = get_credit_detail.account_id>
	<cfset credit_type_ = get_credit_detail.credit_type>
	<cfset credit_limit = get_credit_detail.credit_limit>
	<cfset credit_money = get_credit_detail.money_type>
	<cfset action_detail = get_credit_detail.action_detail>
	<cfset limit_head = get_credit_detail.limit_head>
<cfelse>
	<cfset account_id = ''>
	<cfset credit_type_ = ''>
	<cfset credit_limit = 0>
	<cfset credit_money = ''>
	<cfset action_detail = ''>
	<cfset limit_head = ''>
</cfif>
<cf_catalystHeader>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
<cfform name="add_credit_type" method="post" action="#request.self#?fuseaction=credit.emptypopup_add_credit_limit">
	<cfoutput>
		<cfif isdefined("attributes.credit_limit_id")>
			<input type="hidden" name="credit_limit_id" id="credit_limit_id" value="#attributes.credit_limit_id#">
		</cfif>
                    <cf_box_elements>
                    	<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" >
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='1652.Banka Hesabi'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrkBankAccounts width='180' control_status='1' selected_value='#account_id#'>
                                </div>
                            </div>
                            <div class="form-group" >
                                <label class="col col-4 col-xs-12"><cf_get_lang no='2.Kredi Kurumu'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("url.credit_limit_id") and len(url.credit_limit_id)>#get_credit_detail.company_id#</cfif>">
                                        <input type="text" name="company" id="company" value="<cfif isdefined("url.credit_limit_id") and len(url.credit_limit_id)>#get_par_info(get_credit_detail.company_id,1,1,0)#</cfif>" readonly style="width:180px;">	  
                                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=add_credit_type.company_id&field_comp_name=add_credit_type.company&select_list=2','list');"></span>
                                    </div>
                                </div>
                        	</div>
                            <div class="form-group" >
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='1408.Başlık'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cfif isdefined("attributes.credit_limit_id")>
                                    <div class="input-group">
                                        <input type="text" name="limit_head" id="limit_head" value="#limit_head#"  maxlength="50">
                                        <span class="input-group-addon">
                                            <cf_language_info 
                                                table_name="CREDIT_LIMIT" 
                                                column_name="LIMIT_HEAD" 
                                                column_id_value="#attributes.credit_limit_id#" 
                                                maxlength="50" 
                                                datasource="#dsn3#" 
                                                column_id="CREDIT_LIMIT_ID" 
                                                control_type="0">
                                        </span>
                                    </div>
                                <cfelse>
                                    <input type="text" name="limit_head" id="limit_head" value="#limit_head#"  maxlength="50">
                                </cfif>
                                </div>
                            </div>
                            <div class="form-group" >
                                <label class="col col-4 col-xs-12"><cf_get_lang no='26.Kredi Türü'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <select name="credit_type" id="credit_type" style="width:180px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfloop query="get_credit_type">
                                            <option value="#credit_type_id#" <cfif credit_type_id eq credit_type_>selected</cfif>>#credit_type#</option>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" >
                                <label class="col col-4 col-xs12"><cf_get_lang_main no='1551.Kredi Limiti'> *</label>
                                        <div class="col col-5 col-xs-12">
                                            <cfsavecontent variable="message"><cf_get_lang no='105.Geçerli Tutar Girmelisiniz!'></cfsavecontent>
										    <cfinput type="text" required="yes" name="action_value" value="#tlformat(credit_limit)#" class="moneybox" message="#message#"  onkeyup="return(FormatCurrency(this,event));" >
                                        </div> 
                                        <div class="col col-3 col-xs-12">
                                            <select name="action_currency_id" id="action_currency_id" <cfif get_credit_contract.recordcount>disabled</cfif> >
                                                <cfloop query="get_money_rate">
                                                    <option value="#money#" <cfif money eq credit_money>selected</cfif>>#money#</option>
                                                </cfloop>
                                            </select> 
                                        </div>
                            </div>
                            <div class="form-group" >
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="action_detail" id="action_detail" >#action_detail#</textarea>
                                </div>
                            </div>
                        
                        
        				</div>
                    </cf_box_elements>
                    <cf_box_footer>
                                <cfif isdefined("get_credit_detail")>
                                    <div class="col col-6 ">
                                        <cf_record_info query_name="get_credit_detail">
                                    </div>
                                </cfif>
                                <div class="col col-6 ">
                                        <cfif isdefined("get_credit_detail")>
                                            <!---<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=credit.emptypopup_del_credit_limit&credit_limit_id=#get_credit_detail.credit_limit_id#'>--->
                                            <cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=credit.list_credit_limit&event=del&credit_limit_id=#get_credit_detail.credit_limit_id#'>
                                        <cfelse>
                                            <cf_workcube_buttons is_upd='0' add_function='kontrol()' type_format='1'>
                                     </cfif>
                                </div> <!---///butonlar--->
                    </cf_box_footer>
                    
        	
       
	</cfoutput>
</cfform>
</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if(document.add_credit_type.account_id.value == '' && (document.add_credit_type.company_id.value == '' || document.add_credit_type.company.value == ''))
		{
			alert('<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1652.Banka Hesabi'> <cf_get_lang_main no='586.veya'> <cf_get_lang no='2.Kredi Kurumu'>!');
			return false;
		}
		if(document.add_credit_type.limit_head.value == '')
		{
			alert('<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1408.Başlık'> !');
			return false;
		}
		if(document.add_credit_type.credit_type.value == '')
		{
			alert('<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='26.Kredi Türü'> !');
			return false;
		}
		if(document.add_credit_type.action_value.value == '' || document.add_credit_type.action_value.value == 0)
		{
			alert('<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1551.Kredi Limiti'> !');
			return false;
		}
		document.add_credit_type.action_value.value = filterNum(document.add_credit_type.action_value.value);
		if (document.add_credit_type.action_currency_id.disabled == true)
			 document.add_credit_type.action_currency_id.disabled = false;
		return true;
	}
</script>

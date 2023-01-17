<cf_xml_page_edit fuseact="cheque.form_add_payroll_entry">
<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
<cfif isnumeric(url.id)>
	<cfquery name="GET_ACTION_DETAIL" datasource="#DSN2#">
		SELECT
			P.*,
			SC.IS_UPD_CARI_ROW
		FROM
			PAYROLL P,
			#dsn3_alias#.SETUP_PROCESS_CAT SC
		WHERE 
			P.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"> AND
			P.PAYROLL_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="90"> AND
			SC.PROCESS_CAT_ID = P.PROCESS_CAT
		<cfif session.ep.isBranchAuthorization>
			AND P.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
		</cfif>		
	</cfquery>
	<cfquery name="get_pay_cheques" datasource="#dsn2#">
		SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"> AND CHEQUE_STATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="3">
	</cfquery>
<cfelse>
	<cfset get_action_detail.recordcount = 0>
</cfif>
<cfquery name="CONTROL_CHEQUE_STATUS" datasource="#dsn2#">
	SELECT
    	C.CHEQUE_ID
    FROM
        CHEQUE C
        LEFT JOIN CHEQUE_HISTORY CH ON CH.CHEQUE_ID = C.CHEQUE_ID
    WHERE
        CH.PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
        AND ISNULL((SELECT TOP 1 PAYROLL_ID FROM CHEQUE_HISTORY CH2 WHERE CH2.CHEQUE_ID = C.CHEQUE_ID ORDER BY HISTORY_ID DESC),0) <> <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>
<cfif not get_action_detail.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='590.Böyle Bir Çek Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
 <cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box>
<cfform name="form_payroll_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_payroll_entry">
 	<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <input type="hidden" name="payroll_acc_cari_cheque_based" id="payroll_acc_cari_cheque_based" value="<cfoutput>#GET_ACTION_DETAIL.CHEQUE_BASED_ACC_CARI#</cfoutput>">
    <input type="hidden" name="rev_date" id="rev_date" value="<cfoutput>#dateformat(get_action_detail.payroll_revenue_date,dateformat_style)#</cfoutput>">
    <input type="hidden" name="bordro_type" id="bordro_type" value="1">
    <input type="hidden" name="x_detail_acc_card" id="x_detail_acc_card" value="<cfoutput>#x_detail_acc_card#</cfoutput>">
    <cf_basket_form id="payroll_entry">
    <div class="row">
        	<div class="col col-12 uniqueRow">
            	<div class="row formContent">
                	<cf_box_elements>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                        	<div class="form-group">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57692.İşlem'> *</label>
                                <div class="col col-8 col-xs-12">
									<cf_workcube_process_cat process_cat=#get_action_detail.process_cat#>
                            	</div>
                            </div>
                            <div class="form-group">
	                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49747.Bordro No'></label>
	                            <div class="col col-8 col-xs-12">
									<input type="text" name="payroll_no" id="payroll_no" maxlength="10" value="<cfif len(get_action_detail.PAYROLL_NO)><cfoutput>#get_action_detail.PAYROLL_NO#</cfoutput></cfif>" >
                            	</div>
                        	</div>
                            <div class="form-group">
	                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
	                            <div class="col col-8 col-xs-12">
	                                <div class="input-group">
                                      	<cfinput value="#dateformat(GET_ACTION_DETAIL.payroll_revenue_date,dateformat_style)#" required="Yes" type="text" readonly name="payroll_revenue_date"  validate="#validate_style#" onBlur="change_money_info('form_payroll_basket','payroll_revenue_date');">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="payroll_revenue_date" call_function="change_money_info" control_date="#dateformat(GET_ACTION_DETAIL.payroll_revenue_date,dateformat_style)#"></span>
	                                </div>
	                            </div>
	                        </div>

                            <div class="form-group">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58929.Tahsilat Tipi'></label>
                                <div class="col col-8 col-xs-12">
                                	<cf_wrk_special_definition width_info='150' type_info='1' field_id="special_definition_id" selected_value='#get_action_detail.special_definition_id#'>
                            	</div>
                            </div>

                        </div>
                    	<div class="col col-4 col-md-4 col-sm-6 col-xs-12">

                            <div class="form-group">
	                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'> *</label>
	                            <div class="col col-8 col-xs-12">
	                                <div class="input-group">
	                                	<cfsavecontent variable="message"><cf_get_lang dictionary_id='54613.Şirket Girmelisiniz'></cfsavecontent>
					                    <cfset emp_id = get_action_detail.employee_id>
					                    <cfif len(get_action_detail.acc_type_id)>
					                        <cfset emp_id = "#emp_id#_#get_action_detail.acc_type_id#">
					                    </cfif>
					                    <cfif len(get_action_detail.company_id)>
					                        <cfset member_name=get_par_info(get_action_detail.company_id,1,1,0)>
					                        <cfset member_type="partner">
					                    <cfelseif len(get_action_detail.consumer_id)>
					                        <cfset member_name=get_cons_info(get_action_detail.consumer_id,0,0)>
					                        <cfset member_type="consumer">
					                    <cfelseif len(get_action_detail.employee_id)>
					                        <cfset member_name=get_emp_info(get_action_detail.employee_id,0,0,0,get_action_detail.acc_type_id)>
					                        <cfset member_type="employee">
					                    </cfif>
					                    <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_action_detail.company_id#</cfoutput>">
					                    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_action_detail.consumer_id#</cfoutput>">
					                    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#emp_id#</cfoutput>">
					                    <input type="hidden" name="member_type" id="member_type" value="<cfoutput>#member_type#</cfoutput>">
					                    <cfinput type="text" name="company_name" value="#member_name#"  readonly required="yes" message="#message#">
	                                    <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='162.Şirket'>" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=1,2,3,9&field_comp_id=form_payroll_basket.company_id&field_member_name=form_payroll_basket.company_name&field_name=form_payroll_basket.company_name&field_consumer=form_payroll_basket.consumer_id&field_emp_id=form_payroll_basket.employee_id&field_type=form_payroll_basket.member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>');"></span>
                                	</div>
                            	</div>
                        	</div>
							<div class="form-group">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57520.Kasa'></label>
                                <div class="col col-8 col-xs-12">
									<cfif control_cheque_status.recordcount> <!--- İşlem görmüş çek varsa kasa değiştirilemez --->
										<cf_wrk_Cash name="cash_id" value="#get_action_detail.PAYROLL_CASH_ID#" cash_id="#get_action_detail.PAYROLL_CASH_ID#" currency_branch="1">
				                    <cfelse>
										<cf_wrk_Cash name="cash_id" currency_branch="1" value="#get_action_detail.PAYROLL_CASH_ID#" cash_status="1" cash_id ="#get_action_detail.PAYROLL_CASH_ID#">
				                    </cfif>
                            	</div>
                            </div>
							<div class="form-group">
	                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50233.Tahsil Eden'> *</label>
	                            <div class="col col-8 col-xs-12">
	                                <div class="input-group">
	                                	<input type="hidden" name="REVENUE_COLLECTOR_ID" id="REVENUE_COLLECTOR_ID" value="<cfoutput>#GET_ACTION_DETAIL.REVENUE_COLLECTOR_ID#</cfoutput>">
					                    <cfinput type="text" name="REVENUE_COLLECTOR" value="#get_emp_info(get_action_detail.REVENUE_COLLECTOR_ID,0,0)#" required="yes" >
	                                    <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='50233.Tahsil Eden'>" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_payroll_basket.REVENUE_COLLECTOR_ID&field_name=form_payroll_basket.REVENUE_COLLECTOR&select_list=1,9');"></span>
                                	</div>
                            	</div>
                        	</div>
							<div class="form-group">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                <div class="col col-8 col-xs-12">
									<cf_wrkProject project_Id="#get_action_detail.project_id#" fieldName="project_name" AgreementNo="1" Customer="2" Employee="3" Priority="4" Stage="5" width="150" boxwidth="600" boxheight="400" buttontype="2">
                            	</div>
                            </div>
                        </div>

                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
							<div class="form-group">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                                <div class="col col-8 col-xs-12">
                                	<textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px;height:50px;"><cfoutput>#get_action_detail.action_detail#</cfoutput></textarea>
                            	</div>
                            </div>
                        	<div class="form-group">
	                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29522.Sözleşme'></label>
	                            <div class="col col-8 col-xs-12">
	                                <div class="input-group">
	                                	<input type="hidden" name="contract_id" id="contract_id" value="<cfoutput>#get_action_detail.contract_id#</cfoutput>">
										<cfif len(get_action_detail.contract_id)>
					                        <cfquery name="get_contract_head" datasource="#dsn3#">
					                            SELECT CONTRACT_ID,CONTRACT_HEAD FROM RELATED_CONTRACT WHERE CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_action_detail.contract_id#">
					                        </cfquery>
					                    </cfif>
					                    <input type="text" name="contract_head" id="contract_head" value="<cfif len(get_action_detail.contract_id)><cfoutput>#get_contract_head.contract_head#</cfoutput></cfif>" >
	                                    <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&field_id=form_payroll_basket.contract_id&field_name=form_payroll_basket.contract_head'</cfoutput>);"></span>
                                	</div>
                            	</div>
                        	</div>						
							<cfif session.ep.our_company_info.asset_followup eq 1>
								<div class="form-group">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></label>
									<div class="col col-8 col-xs-12">
										<cf_wrkAssetp asset_id='#get_action_detail.assetp_id#' fieldId='asset_id' fieldName='asset_name' form_name='form_payroll_basket'>
									</div>
								</div>
							</cfif>
                        </div>
                    </cf_box_elements>
                    <cf_box_footer>
	                    <div class="col col-6 col-xs-12">
							<cf_record_info query_name="get_action_detail">
						</div>
						<div class="col col-6 col-xs-12">

							<cf_workcube_buttons is_upd='1' 
								update_status='#get_action_detail.UPD_STATUS#'
								del_function_for_submit='delete_action()' 
								add_function='kontrol4()'
								delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_payroll&id=#url.id#&head=#get_action_detail.PAYROLL_NO#&cheque_base_acc=#get_action_detail.CHEQUE_BASED_ACC_CARI#'>
								<div class="pull-right"><input type="button" value="<cf_get_lang dictionary_id='31314.Çek Ekle'>" class="ui-wrk-btn ui-wrk-btn-extra " onclick="javascript:openBoxDraggable('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.popup_add_cheque');"></div>
							</div>
						<cfif control_cheque_status.recordcount>
							<div class="col col-12 col-xs-12">
								<font color="##FF0000" style=" padding: 3px; line-height: 20px;"><cf_get_lang dictionary_id="56595.İşlem Görmüş Çekler Var. Cari Hesap, Kasa, Tutar ve Tarih Güncellenemez">!</font>
							</div>	
						</cfif>
                	</cf_box_footer>
                </div>
            </div>
        </div>
    </cf_basket_form>
	
		<cf_basket id="payroll_entry_bask">
			<cfset attributes.rev_date = dateformat(get_action_detail.payroll_revenue_date,dateformat_style)>
			<cfset attributes.bordro_type = "1">
			<cfset attributes.in = 1>
			<cfif get_action_detail.is_upd_cari_row eq 1 and get_pay_cheques.recordcount gt 0>
				<cfset rate_readonly_info = 1>
			</cfif>
			<cfinclude template="../display/basket_cheque.cfm">
		</cf_basket>

 </cfform>	
</cfif>
<script type="text/javascript">
    var company_id_control,date_control;
	<cfif control_cheque_status.recordcount>
	company_id_control=document.form_payroll_basket.company_id.value;
	date_control=document.form_payroll_basket.payroll_revenue_date.value;
	</cfif>
	function delete_action()
	{
		if (!chk_period(form_payroll_basket.payroll_revenue_date, 'İşlem')) return false;			
		if (document.all.del_flag.value != 0)//basket_cheque de tutuluyor
		{
			alert("<cf_get_lang dictionary_id='49814.İşlem Görmüş Çekler Var Bordroyu Silemezsiniz !'>");
			return false;
		}
		return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.payroll_type#'</cfoutput>);
	}
	function kontrol4()
	{   
		if(company_id_control!=undefined && date_control!=undefined){
	    if(document.form_payroll_basket.payroll_revenue_date.value!=date_control || document.form_payroll_basket.company_id.value!=company_id_control){
		alert("<cf_get_lang dictionary_id="56595.İşlem Görmüş Çekler Var. Cari Hesap, Kasa, Tutar ve Tarih Güncellenemez">!");
		location.href = document.referrer;
		return false;
		}
	    }
		if(!$("#payroll_revenue_date").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'></cfoutput>"})    
			return false;
		}
		if(!$("#REVENUE_COLLECTOR").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='49918.Tahsil Eden Seçiniz'></cfoutput>"})    
			return false;
		}
		if (!chk_process_cat('form_payroll_basket')) return false;
		if (!check_display_files('form_payroll_basket')) return false;
		if (!chk_period(form_payroll_basket.payroll_revenue_date, 'İşlem')) return false;			
		if(document.form_payroll_basket.cash_id.value=="")
		{
			alert("<cf_get_lang dictionary_id='50246.Kasa Seçiniz'>");
			return false;		
		}
		if(document.all.cheque_num.value == 0)
		{
			alert("<cf_get_lang dictionary_id='50223.Çek Seçiniz veya Çek Ekleyiniz !'>");
			return false;
		}
		for(kk=1;kk<=document.all.kur_say.value;kk++)
		{
			cheque_rate_change(kk);
		}
		if(toplam(1,0,1)==false)return false;
		return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.payroll_type#'</cfoutput>);
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

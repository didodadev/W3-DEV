<cfset ExpenseRules= createObject("component","V16.hr.ehesap.cfc.expense_rules") />
<cfset get_money=ExpenseRules.GET_MONEY() />
<cfif isdefined("attributes.expense_puantaj_id")>
	<cfquery name="get_puantaj" datasource="#dsn#">
		SELECT 
			EEP.*,
			EHR.EXPENSE_HR_RULES_DESCRIPTION,
			EI.EXPENSE_ITEM_NAME
		FROM 
			EMPLOYEES_EXPENSE_PUANTAJ  EEP
		LEFT JOIN EXPENSE_HR_RULES EHR ON  EEP.EXPENSE_HR_RULES_ID = EHR.EXPENSE_HR_RULES_ID 
		LEFT JOIN #dsn2#.EXPENSE_ITEMS EI ON EHR.EXPENSE_ITEM_ID=EI.EXPENSE_ITEM_ID
		WHERE EXPENSE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_puantaj_id#">
	</cfquery>
</cfif>
<cf_papers paper_type="allowence_expense">
<cf_catalystHeader>
	<cfform name="add_expense_puantaj" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_add_expense_puantaj">
		<cfif isdefined("attributes.expense_puantaj_id")>
			<input type="hidden" name="expense_puantaj_id" id="expense_puantaj_id" value="<cfoutput>#attributes.expense_puantaj_id#</cfoutput>">
		</cfif>
        <div class="row">
        	<div class="col col-12 uniqueRow">
            	<div class="row formContent">
                	<div class="row" type="row">
                    	<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-expense_stage">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1447)#</cfoutput> *</label>
								<div class="col col-8 col-xs-12">
									<cfif isdefined("attributes.expense_puantaj_id")>
										<cf_workcube_process is_upd='0' process_cat_width='120' is_detail='0' select_value="#get_puantaj.process_stage#">
									<cfelse>
										<cf_workcube_process is_upd='0' process_cat_width='120' is_detail='0'>
									</cfif>
                                </div>
                            </div>
							<cfif isdefined("attributes.expense_puantaj_id")>
								<div class="form-group" id="item-paper_number">
                                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',468)#</cfoutput></label>
                                    <div class="col col-8 col-xs-12">
                                        <input name="paper_number" id="paper_number" type="text" value="<cfoutput>#get_puantaj.paper_no#</cfoutput>">
                                    </div>
                                </div>
							<cfelse>
								<div class="form-group" id="item-paper_number">
									<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',468)#</cfoutput></label>
									<div class="col col-8 col-xs-12">
										<input type="text" name="paper_number" id="paper_number" value="<cfoutput>#paper_code & '-' & paper_number#</cfoutput>">
									</div>
								</div>
							</cfif>
							<div class="form-group" id="item-expense_date">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no='330.Tarih'> *</label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
                                    	<input type="text" name="expense_date" id="expense_date" style="width:70px;" value="<cfif isdefined("attributes.expense_puantaj_id")><cfoutput>#dateformat(get_puantaj.expense_date,dateformat_style)#</cfoutput></cfif>" maxlength="10">
					
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="expense_date"></span>
                                    </div>
                            	</div>
                            </div>
                        	<div class="form-group" id="item-employee">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no='164.Çalışan'> *</label>
                                <div class="col col-8 col-xs-12">
                                	<cfif isdefined("attributes.expense_puantaj_id")>
										
										<cf_wrk_employee_in_out
											form_name="add_expense_puantaj"
											emp_id_fieldname="employee_id"
											in_out_id_fieldname="in_out_id"
											width="150"
											emp_id_value = "#get_puantaj.employee_id#"
											in_out_value = "#get_puantaj.in_out_id#"
											emp_name_fieldname="employee_name">
									<cfelse>
										<cf_wrk_employee_in_out
											form_name="add_expense_puantaj"
											emp_id_fieldname="employee_id"
											in_out_id_fieldname="in_out_id"
											width="150"
											emp_name_fieldname="employee_name"> 
									</cfif>
                            	</div>
                            </div>
							<div class="form-group" id="item-expense_item_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="41539.HArcırah Tipi"></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfoutput>
											<input type="hidden" name="expense_type" id="expense_type" value="<cfif isdefined("attributes.expense_puantaj_id")>#get_puantaj.expense_type#</cfif>">
											<input type="hidden" name="expense_type_id" id="expense_type_id" value="<cfif isdefined("attributes.expense_puantaj_id")>#get_puantaj.EXPENSE_HR_RULES_ID#</cfif>">
											<input type="text" name="expense_type_name" id="expense_type_name" value="<cfif isdefined("attributes.expense_puantaj_id")>#get_puantaj.EXPENSE_HR_RULES_DESCRIPTION#</cfif>" class="boxtext" style="width:90%" readonly> 					
											<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_allowance_rules&field_id=expense_type_id&field_name=expense_type_name&field_expense_item_id=expense_item_id&field_expense_item_name=expense_item_name&field_expense_center_id=expense_center_id&field_expense_center_name=EXPENSE_CODE_NAME&field_tax_exception_money_type=tax_exception_money_type&field_tax_exception_amount=tax_exception_amount&field_is_country_out=expense_type&field_additional_allowance_id=salaryparam_pay_id&call_function=hesapla(1)','list');"></span>
										</cfoutput>
									</div>
								</div>                              
							</div>
                            <div class="form-group" id="item-EXPENSE_CODE_NAME">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no='1048.Masraf Merkezi'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
	                                    <input type="hidden" name="expense_center_id" id="expense_center_id" value="<cfif isdefined("attributes.expense_puantaj_id")><cfoutput>#get_puantaj.expense_center_id#</cfoutput></cfif>">
					                    <input type="hidden" name="EXPENSE_CODE" id="EXPENSE_CODE" value="<cfif isdefined("attributes.expense_puantaj_id")><cfoutput>#get_puantaj.expense_code#</cfoutput></cfif>">
					                   	<cfif isdefined("attributes.expense_puantaj_id")>
					                    	<cfinput type="Text" name="EXPENSE_CODE_NAME" value="#get_puantaj.expense_code_name#" style="width:145px;">
					                    <cfelse>
					                    	<cfinput type="Text" name="EXPENSE_CODE_NAME" value="" style="width:145px;">
					                    </cfif>
                                    	<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=add_expense_puantaj.expense_center_id&field_code=add_expense_puantaj.EXPENSE_CODE&field_acc_code_name=add_expense_puantaj.EXPENSE_CODE_NAME</cfoutput>','list');"></span>
                                    </div>
                            	</div>
                            </div>
							<div class="form-group" id="item-expense_item_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58551.Gider Kalemi"></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cf_wrk_expense_items form_name='upd_expense_rules' expense_item_id='expense_item_id' expense_item_name='expense_item_name'>
										<input type="hidden" name="expense_item_id" id="expense_item_id" value="<cfif isdefined("attributes.expense_puantaj_id")><cfoutput>#get_puantaj.expense_item_id#</cfoutput></cfif>">
										<input type="text" name="expense_item_name" id="expense_item_name" value="<cfif isdefined("attributes.expense_puantaj_id")><cfoutput>#get_puantaj.expense_item_name#</cfoutput></cfif>" onKeyUp="get_expense_item();" style="width:175px;">
										<a href="javascript://" class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_expense_puantaj.expense_item_id&field_name=add_expense_puantaj.expense_item_name','list');"></a>                                       
									</div>
								</div>                              
							</div>
							<div class="form-group" id="item-daily_pay_max">
								<label class="col col-4 col-xs-12">Günlük Harcırah</label>
								<div class="col col-5 col-xs-12">
									<input class="box" type="hidden" name="daily_pay_max" id="daily_pay_max"  value="<cfif isdefined("attributes.expense_puantaj_id")><cfoutput>#TLFormat(get_puantaj.net_amount)#</cfoutput></cfif>" onkeyup="return(FormatCurrency(this,event))"  onblur="hesapla(1)">
									<input class="box" type="text" name="daily_spending" id="daily_spending"  value="<cfif isdefined("attributes.expense_puantaj_id")><cfoutput>#TLFormat(get_puantaj.daily_spending)#</cfoutput></cfif>" onkeyup="return(FormatCurrency(this,event))"  onblur="hesapla(1)">
								</div>
								<div class="col col-3 col-xs-12">                                                                      
									<cfselect name="tax_exception_money_type" id="tax_exception_money_type">
										<cfoutput query="get_money">                                     
											<option value="#MONEY#" <cfif isdefined("attributes.expense_puantaj_id") and get_puantaj.tax_exception_money_type eq MONEY>selected</cfif>>#MONEY#</option>                                                                             
										</cfoutput>
									</cfselect>                                   
								</div>
							</div>
							<div class="form-group" id="item-expense_day">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no='78.Gün'> / <cf_get_lang_main dictionary_id='57635.Miktar'> *</label>
                                <div class="col col-5 col-xs-12">
                                	<input type="text" name="expense_day" id="expense_day" value="<cfif isdefined("attributes.expense_puantaj_id")><cfoutput>#get_puantaj.expense_day#</cfoutput><cfelse>1</cfif>" onKeyUp="isNumber(this);" class="moneybox" style="width:70px;" onblur="hesapla(1)">
                            	</div>
							</div>
							<div class="form-group" id="item-total_amount">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59520.Toplam Harcırah"></label>
								<div class="col col-5 col-xs-12">
									<input class="box" type="text" name="total_amount" id="total_amount"  value="<cfif isdefined("attributes.expense_puantaj_id")><cfoutput>#TLFormat(get_puantaj.net_amount)#</cfoutput></cfif>" onkeyup="return(FormatCurrency(this,event))"  onblur="hesapla(2)">
								</div>
							</div>
							<div class="form-group" id="item-tax_exception_amount">
								<label class="col col-4 col-xs-12">Günlük İstisna Tutarı</label>
								<div class="col col-5 col-xs-12">
									<input class="box" type="text" name="tax_exception_amount" id="tax_exception_amount"  value="<cfif isdefined("attributes.expense_puantaj_id")><cfoutput>#TLFormat(get_puantaj.tax_exception_amount)#</cfoutput></cfif>" onkeyup="return(FormatCurrency(this,event))" readonly >
								</div>
							</div>
							<div class="form-group" id="item-amount">
								<label class="col col-4 col-xs-12">Toplam İstisna Tutarı</label>
								<div class="col col-5 col-xs-12">
									<input class="box" type="text" name="amount" id="amount"  value="" onkeyup="return(FormatCurrency(this,event))"  readonly>
								</div>
							</div>
							<div class="form-group" id="item-salaryparam_pay_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="40073.Ödenek"> ID</label>
								<div class="col col-5 col-xs-12">
									<input class="box" type="text" name="salaryparam_pay_id" id="salaryparam_pay_id"  value="<cfif isdefined("attributes.expense_puantaj_id")><cfoutput>#get_puantaj.salaryparam_pay_id#</cfoutput></cfif>" onkeyup="return(FormatCurrency(this,event))"  onblur="hesapla(2)">
								</div>
							</div>
                        </div>
                    </div>
                    <div class="row formContentFooter">
	                    <div class="col col-6 col-xs-12">
	                        <cfif isdefined("attributes.expense_puantaj_id")>
								<cf_record_info query_name="get_puantaj">
							</cfif>
						</div>
                        <div class="col col-6 col-xs-12">
							<cfif isdefined("attributes.expense_puantaj_id")>
								<cfquery name="get_puantaj_kontrol" datasource="#dsn#">
									SELECT
										EPR.PUANTAJ_ID
									FROM
										EMPLOYEES_PUANTAJ EP,
										EMPLOYEES_PUANTAJ_ROWS EPR
									WHERE
										EP.PUANTAJ_ID = EPR.PUANTAJ_ID
										AND EPR.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj.in_out_id#">
										AND EP.SAL_MON > = #month(get_puantaj.expense_date)#
										AND EP.SAL_YEAR > = #year(get_puantaj.expense_date)#
								</cfquery>
								<cfquery name="get_expense_puantaj" datasource="#dsn#">
									SELECT
										EXPENSE_PUANTAJ_ID
									FROM
										EMPLOYEES_EXPENSE_PUANTAJ
									WHERE
										IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj.in_out_id#">
										AND (EXPENSE_DATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_puantaj.expense_date)#">
										OR (EXPENSE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_puantaj.expense_date)#"> AND RECORD_DATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_puantaj.record_date#">))
										AND EXPENSE_PUANTAJ_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_puantaj_id#">
								</cfquery>
								<cfif get_puantaj_kontrol.recordcount eq 0 and get_expense_puantaj.recordcount eq 0>
									<cf_workcube_buttons is_upd='1' add_function='check()' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_expense_puantaj&expense_puantaj_id=#attributes.expense_puantaj_id#'>
								<cfelse>
									<cfif get_puantaj_kontrol.recordcount>
										<font color="red"><cf_get_lang dictionary_id ="59553.Harcırah Tarihinden Sonra Girilen Harcırah Kaydı Olduğu İçin Güncelleme Yapamazsınız"></font>
									<cfelse>
										<font color="red"><cf_get_lang dictionary_id ="59553.Harcırah Tarihinden Sonra Girilen Harcırah Kaydı Olduğu İçin Güncelleme Yapamazsınız"></font>
									</cfif>
								</cfif>
							<cfelse>
								<cf_workcube_buttons is_upd='0' add_function='check()'>
							</cfif>
	                    </div>
                	</div>
        		</div>
        	</div>
        </div>
	</cfform>
<script type="text/javascript">
	<cfif isdefined("attributes.expense_puantaj_id")>
		hesapla();
	</cfif>
	function check()
	{
		<cfif isdefined("attributes.expense_puantaj_id")>
			employee_puantaj_id = "<cfoutput>#attributes.expense_puantaj_id#</cfoutput>";
		<cfelse>
			employee_puantaj_id = 0;
			if(document.add_expense_puantaj.employee_name.value == '' || document.add_expense_puantaj.employee_id.value == '')
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='164.Çalışan'> !");
				return false;
			}
		</cfif>
		if(document.add_expense_puantaj.expense_day.value == '' || document.add_expense_puantaj.expense_day.value == 0)
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='78.Gün'> !");
			return false;
		}
		if(document.add_expense_puantaj.expense_date.value == '')
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='330.Tarih'> !");
			return false;
		}
		expense_date = js_date(document.add_expense_puantaj.expense_date.value.toString());
		var listParam = document.add_expense_puantaj.in_out_id.value + "*" + expense_date + "*" + employee_puantaj_id;
		get_puantaj_ = wrk_safe_query("hr_control_expense_puantaj",'dsn',0,listParam);
		if(get_puantaj_.recordcount > 0)
		{
			alert("Çalışan İçin Aynı veya Yeni Tarihli Harcırah Kaydı Mevcut. Lütfen Bilgileri Kontrol Ediniz!");
			return false;
		}
		document.getElementById("total_amount").value = filterNum(document.getElementById("total_amount").value);
		document.getElementById("daily_pay_max").value = filterNum(document.getElementById("daily_pay_max").value);
		document.getElementById("daily_spending").value = filterNum(document.getElementById("daily_spending").value);
		document.getElementById("tax_exception_amount").value = filterNum(document.getElementById("tax_exception_amount").value);
		document.getElementById("amount").value = filterNum(document.getElementById("amount").value);
		return true;
	}
	function format(type){
		if(type == 1)
			document.getElementById("daily_spending").value = commaSplit(document.getElementById("daily_spending").value,2);
		if(type == 2)
			document.getElementById("total_amount").value = commaSplit(document.getElementById("total_amount").value,2);
		if(document.getElementById("amount") != undefined)
			document.getElementById("amount").value = commaSplit(document.getElementById("amount").value,2);
		
	}
	function hesapla(type){
		if(type == 1){
			document.getElementById("total_amount").value = parseFloat(filterNum(document.getElementById("daily_spending").value) * filterNum(document.getElementById("expense_day").value));
		}
		if(type == 2){
			document.getElementById("daily_spending").value = parseFloat(filterNum(document.getElementById("total_amount").value) / filterNum(document.getElementById("expense_day").value));
		}	
		if(document.getElementById("amount") != undefined){
			document.getElementById("amount").value = parseFloat(filterNum(document.getElementById("tax_exception_amount").value) * filterNum(document.getElementById("expense_day").value));
		}
			
		format(1);
		format(2);
	}
</script>


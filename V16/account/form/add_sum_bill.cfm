<cfset xml_page_control_list = 'x_selected_process_id'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="0" fuseact="account.popup_add_sum_bills">
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME 
	FROM
		BRANCH
	ORDER BY
		BRANCH_ID
</cfquery>
<cfset list_card_type_ = '11,12,13,14'>
<cfquery name="GET_ALL_PROCESS_CAT" datasource="#DSN3#">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT,IS_ACCOUNT FROM SETUP_PROCESS_CAT
</cfquery>
<cfquery name="get_acc_card_type" dbtype="query">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM GET_ALL_PROCESS_CAT WHERE IS_ACCOUNT = 1 AND PROCESS_TYPE IN (#list_card_type_#) ORDER BY PROCESS_TYPE
</cfquery>
<cfquery name="get_acc_card_process_type" dbtype="query">
	SELECT DISTINCT PROCESS_TYPE FROM GET_ALL_PROCESS_CAT WHERE IS_ACCOUNT = 1 AND PROCESS_TYPE IN (#list_card_type_#) ORDER BY PROCESS_TYPE
</cfquery>
<cfquery name="get_process_cat" dbtype="query">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT,IS_ACCOUNT FROM GET_ALL_PROCESS_CAT WHERE 1=1 <cfif is_selected_account eq 0>AND IS_ACCOUNT = 1</cfif> ORDER BY PROCESS_TYPE
</cfquery>
<cfquery name="get_process_cat_process_type" dbtype="query">
	SELECT DISTINCT PROCESS_TYPE FROM GET_ALL_PROCESS_CAT WHERE 1=1 <cfif is_selected_account eq 0>AND IS_ACCOUNT = 1</cfif> AND PROCESS_TYPE NOT IN (10,19) ORDER BY PROCESS_TYPE
</cfquery>
<cfquery name="get_group_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE_GROUP_ID,
		PROCESS_NAME,
		PROCESS_TYPE
	FROM  
        BILLS_PROCESS_GROUP
</cfquery>
<cf_catalystHeader>
	<cfform name="add_sum_bills" method="post" action="#request.self#?fuseaction=account.emptypopup_add_sum_bills">
	<input type="hidden" name="x_open_add_page" id="x_open_add_page" value="<cfoutput>#x_open_add_page#</cfoutput>">
    	<div class="row">
        	<div class="col col-12 uniqueRow">
            	<div class="row formContent">
                    <div class="row" type="row">
                        <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        	<div class="form-group">
                            	<label class="bold"><cf_get_lang no='261.Filtre Seçenekleri'></label>
                            </div>
                            <div class="form-group" id="item-process_type_group">
                            	<label class="col col-4 col-xs-12"><cf_get_lang no='262.İşlem Grubu'></label>
                                <div class="col col-8 col-xs-12">
                                	<select name="process_type_group" id="process_type_group" style="width:175px;" onchange="get_proc_cat();">
										<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
										<cfoutput query="get_group_process_type">
											<option value="#process_type_group_id#">#process_name#</option>
										</cfoutput>
									</select>
                                </div>
                            </div>
                            <div class="form-group" id="item-CARD_TYPE">
                            	<label class="col col-4 col-xs-12"><cf_get_lang no='86.Fiş Türü'></label>
                                <div class="col col-8 col-xs-12">
                                	<select name="CARD_TYPE" id="CARD_TYPE" style="width:175px;">
										<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
										<cfoutput query="get_acc_card_process_type">
											<cfquery name="get_pro_cat" dbtype="query">
												SELECT * FROM get_acc_card_type WHERE PROCESS_TYPE = #get_acc_card_process_type.process_type# 
											</cfquery>
											<cfloop query="get_pro_cat">
												<option value="#get_pro_cat.process_type#-#get_pro_cat.process_cat_id#">#get_pro_cat.process_cat#</option>
											</cfloop>
										</cfoutput>
									</select>
                                </div>
                            </div>
                            <div class="form-group" id="item-PROCESS_TYPE">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no ='388.İşlem Tipi'></label>
                                <div class="col col-8 col-xs-12">
                                	<select name="PROCESS_TYPE" id="PROCESS_TYPE" style="width:175px;height:175px;" multiple>
										<cfoutput query="get_process_cat_process_type">
										 <option value="#process_type#-0" <cfif isdefined('x_selected_process_id') and len(x_selected_process_id) and x_selected_process_id eq process_type>selected</cfif>>#get_process_name(process_type)#</option>
											<cfquery name="get_pro_cat" dbtype="query">
												SELECT * FROM get_process_cat WHERE PROCESS_TYPE = #get_process_cat_process_type.process_type# 
											</cfquery>										
											<cfloop query="get_pro_cat">
												<option value="#get_pro_cat.process_type#-#get_pro_cat.process_cat_id#" <cfif (is_selected_account eq 1) and (get_pro_cat.is_account eq 0)> style="color:red" </cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#get_pro_cat.process_cat#</option>
											</cfloop>
										</cfoutput>
									</select>
                                </div>
                            </div>
                            <div class="form-group" id="item-branch_id">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no ='41.Şube'></label>
                                <div class="col col-8 col-xs-12">
                                	<select name="branch_id" id="branch_id" style="width:175px;">
										<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
										<cfoutput query="get_branchs">
											<option value="#branch_id#">#branch_name#</option>
										</cfoutput>
									</select>
                                </div>
                            </div>
                            <div class="form-group" id="item-START_DATE">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no='641.Başlangıç Tarih'>*</label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
                                    	<cfif len(x_selected_start_date) and isdate(x_selected_start_date)>
                                            <cfinput type="text" name="START_DATE" maxlength="10" validate="#validate_style#" style="width:175px;" value="#x_selected_start_date#">
                                        <cfelse>
                                            <cfinput type="text" name="START_DATE" maxlength="10" validate="#validate_style#" style="width:175px;">	
                                        </cfif>
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="START_DATE"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-FINISH_DATE">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no='288.Bitiş Tarih'>*</label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
                                    	<cfif len(x_selected_finish_date) and isdate(x_selected_finish_date)>
                                            <cfinput type="text" name="FINISH_DATE" maxlength="10" validate="#validate_style#" style="width:175px;" value="#x_selected_finish_date#">
                                        <cfelse>
                                            <cfinput type="text" name="FINISH_DATE" maxlength="10" validate="#validate_style#" style="width:175px;">	
                                        </cfif>
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="FINISH_DATE"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-invoice_start_no">
                            	<label class="col col-4 col-xs-12"><cf_get_lang no='148.Fatura Başlangıç No'></label>
                                <div class="col col-8 col-xs-12">
                                	<cfsavecontent variable="message"><cf_get_lang no ='205.İlk Fatura No Girmelisiniz'></cfsavecontent>
									<cfinput type="text" value="" name="invoice_start_no" message="!" style="width:175px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-invoice_finish_no">
                            	<label class="col col-4 col-xs-12"><cf_get_lang no='149.Fatura Bitiş No'></label>
                                <div class="col col-8 col-xs-12">
                                	<cfsavecontent variable="message"><cf_get_lang no ='206.Son Fatura No Girmelisiniz'></cfsavecontent>
									<cfinput type="text" value="" name="invoice_finish_no" message="!" style="width:175px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-CARD_NO_STR">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no='2269.Fiş'><cf_get_lang no='30.Başlangıç No'></label>
                                <div class="col col-8 col-xs-12">
                                	<input type="text" name="CARD_NO_STR" id="CARD_NO_STR" style="width:175px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-CARD_NO_FIN">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no='2269.Fiş'><cf_get_lang no='29.Bitiş No'></label>
                                <div class="col col-8 col-xs-12">
                                	<input type="text" name="CARD_NO_FIN" id="CARD_NO_FIN" style="width:175px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-code1">
                            	<label class="col col-4 col-xs-12"><cf_get_lang no='46.Başlangıç Hesabı'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
                                    	<cfinput style="width:175px;" type="Text" name="code1" id="code1" onFocus="AutoComplete_Create('code1','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'1\',0','','','add_sum_bills','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="javascript:pencere_ac_muavin('add_sum_bills.code1','add_sum_bills.name1','add_sum_bills.name1');" title="Başlangıç Hesabı"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-code2">
                            	<label class="col col-4 col-xs-12"><cf_get_lang no='49.Bitiş Hesabı'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
                                    	<cfinput style="width:175px;" type="Text" name="code2" id="code2" onFocus="AutoComplete_Create('code2','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'1\',0','','','add_sum_bills','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="javascript:pencere_ac_muavin('add_sum_bills.code2','add_sum_bills.name2','add_sum_bills.name2');" title="Bitiş Hesabı"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-employee_name">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no='487.Kayıt Eden'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
                                    	<input type="hidden" name="employee_id" id="employee_id" value="">
										<input type="text" name="employee_name" id="employee_name" value="" style="width:175px;">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_sum_bills.employee_id&field_name=add_sum_bills.employee_name&select_list=1&keyword='+encodeURIComponent(document.add_sum_bills.employee_name.value),'list');return false"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        	<div class="form-group">
                            	<label class="bold"><cf_get_lang no='260.Oluşacak Belge'></label>
                            </div>
                            <div class="form-group" id="item-PROCESS_DATE">
                            	<label class="col col-4 col-xs-12"><cf_get_lang no='17.Hareket Birleştirme'><cf_get_lang_main no ='1181.Tarihi '>*</label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
                                    	<cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik veri'>:<cf_get_lang no='17.Hareket Birleştirme'><cf_get_lang_main no ='1181.Tarihi '>!</cfsavecontent>
										<cfif len(x_selected_act_date) and isdate(x_selected_act_date)>
                                            <cfinput type="text" name="PROCESS_DATE" maxlength="10" required="Yes" message="#message#" validate="#validate_style#" style="width:175px;" value="#x_selected_act_date#">
                                        <cfelse>
                                            <cfinput maxlength="10" validate="#validate_style#" required="Yes" message="#message#" type="text" name="PROCESS_DATE" style="width:175px;">
                                        </cfif>
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="PROCESS_DATE"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-bill_detail">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                                <div class="col col-8 col-xs-12">
                                	<textarea name="bill_detail" id="bill_detail" style="width:180px;height:50px;"></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="item-is_account_group">
                            	<label class="col col-12"><cf_get_lang no ='170.Hesap Bazında Grupla'><input type="checkbox" name="is_account_group" id="is_account_group" value="1" onclick="is_claim_debt();" <cfif x_selected_account_group eq 1>checked</cfif>></label>
                            </div>
                            <cfif x_is_group_debt_claim> 
                                <div class="form-group" id="is_claim_check_td" <cfif not x_selected_account_group>style="display:none"</cfif>>
                                    <label class="col col-12"><cf_get_lang_main no ='176.Alacak'><input type="checkbox" name="is_claim_group" id="is_claim_group" value="1" checked="checked" onchange="is_none_checked(1);"></label>
                                </div>
                                <div class="form-group" id="is_debt_check_td" <cfif not x_selected_account_group>style="display:none"</cfif>>
                                    <label class="col col-12"><cf_get_lang_main no ='175.Borç'><input type="checkbox" name="is_debt_group" id="is_debt_group" value="1" checked="checked" onchange="is_none_checked(2);"></label>
                                </div>
                            </cfif>
                            <div class="form-group" id="item-is_day_group">
                            	<label class="col col-12"><cf_get_lang no='263.Gün Bazında Grupla'><input type="checkbox" name="is_day_group" id="is_day_group" value="1" <cfif x_selected_day_group eq 1>checked</cfif>></label>
                            </div>
                        </div>
                    </div>
                    <div class="row formContentFooter">
                    	<div class="col col-12">
                        	<cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol_fis_birlestir()'>
                        </div>
                    </div>
                </div>
            </div>
        </div>
	</cfform>
<script type="text/javascript">
	function is_claim_debt()
	{
		if(document.getElementById("is_account_group").checked == true)
		{
			document.getElementById("is_claim_check_td").style.display = "";
			document.getElementById("is_debt_check_td").style.display = "";				
		}	
		else
		{
			document.getElementById("is_claim_check_td").style.display = "none";
			document.getElementById("is_debt_check_td").style.display = "none";				
		}
	}
	function is_none_checked(type)
	{
		if(type == 1)
		{
			if(document.getElementById("is_claim_group").checked == false && document.getElementById("is_debt_group").checked == false)
				document.getElementById("is_claim_group").checked = true;		
		}
		else if(type == 2)
		{
			if(document.getElementById("is_claim_group").checked == false && document.getElementById("is_debt_group").checked == false)
				document.getElementById("is_debt_group").checked = true;		
		}
	}
	function get_proc_cat()
	{
		selected_type = document.add_sum_bills.process_type_group.value;
		if(selected_type != '')
		{
			get_process_cat = wrk_query('SELECT IS_ACCOUNT_GROUP,IS_DAY_GROUP,ACCOUNT_CODE_1,ACCOUNT_CODE_2,ACTION_DETAIL FROM BILLS_PROCESS_GROUP WHERE PROCESS_TYPE_GROUP_ID ='+selected_type,'dsn3');
			
			document.add_sum_bills.bill_detail.value = String(get_process_cat.ACTION_DETAIL);
			document.add_sum_bills.code1.value = get_process_cat.ACCOUNT_CODE_1;
			document.add_sum_bills.code2.value = get_process_cat.ACCOUNT_CODE_2;
			if(get_process_cat.IS_ACCOUNT_GROUP == 1)
				document.add_sum_bills.is_account_group.checked = true;
			if(get_process_cat.IS_DAY_GROUP == 1)
				document.add_sum_bills.is_day_group.checked = true;
		}
	}
	function pencere_ac_muavin(str_alan_1,str_alan_2,str_alan)
	{
		var txt_keyword = eval(str_alan_1 + ".value" );
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id='+str_alan_1+'&field_id2='+str_alan_1+'&keyword='+txt_keyword,'list');
	}
	function kontrol_fis_birlestir()
	{
		if (!chk_period(add_sum_bills.PROCESS_DATE,'İşlem')) return false;
		if(document.add_sum_bills.is_day_group.checked == false)
		{
			if(add_sum_bills.CARD_NO_STR.value != '' && add_sum_bills.CARD_NO_FIN.value != '' && add_sum_bills.START_DATE.value !='' && add_sum_bills.FINISH_DATE.value!='')
			{
				alert("<cf_get_lang_main no ='641.Başlangıç Tarihi'>-<cf_get_lang_main no='288.Bitiş Tarihi'><cf_get_lang_main no='586.veya'><cf_get_lang no ='175.Başlangıç ve Bitiş Numaralarını Yazınız'>!");
				return false;
			}
			else if(add_sum_bills.START_DATE.value =='' && add_sum_bills.FINISH_DATE.value=='' && add_sum_bills.CARD_NO_STR.value == '' && add_sum_bills.CARD_NO_FIN.value == '')
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='641.Başlangıç Tarihi'> - <cf_get_lang_main no='288.Bitiş Tarihi'>");
				return false;
			}
			else if((add_sum_bills.START_DATE.value =='' && add_sum_bills.FINISH_DATE.value!='') || (add_sum_bills.START_DATE.value != '' && add_sum_bills.FINISH_DATE.value == ''))
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='641.Başlangıç Tarihi'> - <cf_get_lang_main no='288.Bitiş Tarihi'>");
				return false;
			}
			else if((add_sum_bills.CARD_NO_STR.value =='' && add_sum_bills.CARD_NO_FIN.value!='') || (add_sum_bills.CARD_NO_STR.value != '' && add_sum_bills.CARD_NO_FIN.value == ''))
			{
				alert("<cf_get_lang no ='175.Başlangıç ve Bitiş Numaralarını Yazınız'>!");
				return false;
			}
			if((add_sum_bills.code1.value =='' && add_sum_bills.code2.value!='') || (add_sum_bills.code1.value != '' && add_sum_bills.code2.value == ''))
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='46.Başlangıç Hesabı'> - <cf_get_lang no='49.Bitiş Hesabı'>");
				return false;
			}
		}
		else
		{
			if(add_sum_bills.START_DATE.value == '' || add_sum_bills.FINISH_DATE.value =='')
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='641.Başlangıç Tarihi'> - <cf_get_lang_main no='288.Bitiş Tarihi'>");
				return false;
			}
			if((add_sum_bills.START_DATE.value =='' && add_sum_bills.FINISH_DATE.value!='') || (add_sum_bills.START_DATE.value != '' && add_sum_bills.FINISH_DATE.value == ''))
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='641.Başlangıç Tarihi'> - <cf_get_lang_main no='288.Bitiş Tarihi'>");
				return false;
			}
			if((add_sum_bills.CARD_NO_STR.value =='' && add_sum_bills.CARD_NO_FIN.value!='') || (add_sum_bills.CARD_NO_STR.value != '' && add_sum_bills.CARD_NO_FIN.value == ''))
			{
				alert("<cf_get_lang no ='175.Başlangıç ve Bitiş Numaralarını Yazınız'>!");
				return false;
			}
			if((add_sum_bills.code1.value =='' && add_sum_bills.code2.value!='') || (add_sum_bills.code1.value != '' && add_sum_bills.code2.value == ''))
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='46.Başlangıç Hesabı'> - <cf_get_lang no='49.Bitiş Hesabı'>");
				return false;
			}
		}
		kontrol_group = 0;
		if(add_sum_bills.process_type_group.value != '')
			kontrol_group = parseFloat(kontrol_group+1);
		if(add_sum_bills.PROCESS_TYPE.value != '' || add_sum_bills.CARD_TYPE.value != '')
			kontrol_group = parseFloat(kontrol_group+1);
		
		if(kontrol_group > 1)
		{
			alert("<cf_get_lang dictionary_id='52184.İşlem Grubu, İşlem tipi ve/veya Fiş Türü Seçeneklerinden Sadece Birini Seçmelisiniz!'>");
			return false;
		}

		if( add_sum_bills.START_DATE.value !='' && add_sum_bills.FINISH_DATE.value!='')
		{
			<cfif x_month_count eq 1>
				day_count_kontrol = 31;
				day_count_kontrol_alert = "<cf_get_lang no ='177.Tarih Aralığını Bir Aydan Fazla Olmamalıdır'> !";
			<cfelse>
				day_count_kontrol = 92;
				day_count_kontrol_alert = "<cf_get_lang no ='147.Tarih Aralığını Üç Aydan Fazla Olmamalıdır'> !";
			</cfif>
			if(datediff(add_sum_bills.START_DATE.value,add_sum_bills.FINISH_DATE.value,0) > day_count_kontrol)
			{
				alert(day_count_kontrol_alert);
				return false;
			}
		}
		return true;
	}
</script>

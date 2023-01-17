<cf_get_lang_set module_name="bank">
<cf_xml_page_edit fuseact="bank.form_add_get_money">
<cfinclude template="../query/control_bill_no.cfm">
<cf_catalystHeader>
<div class="col col-12 col-xs-12">  
    <cf_box>   
        <cfform name="get_money" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_get_money" method="post">
            <input type="hidden" name="ACTION_TYPE" id="ACTION_TYPE" value="PARA ÇEKME">
            <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs12"><cf_get_lang_main no='388.işlem tipi'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process_cat slct_width="285">
                        </div>
                    </div>
                    <div class="form-group" id="item-TO_CASH_ID">
                        <label class="col col-4 col-xs12"><cf_get_lang_main no='108.Kasa'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrk_Cash name="TO_CASH_ID" currency_branch="0" cash_status="1" onChange="check_acc_info(this.value);">
                        </div>
                    </div>
                    <div class="form-group" id="item-account_id">
                        <label class="col col-4 col-xs12"><cf_get_lang no='45.Banka/Hesap'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrkBankAccounts width='285' call_function='kur_ekle_f_hesapla' control_status='1'>
                        </div>
                    </div>
                    <div class="form-group" id="item-project_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="project_id" id="project_id" value="" />
                                    <input type="text" style="width:150px" name="project_head" id="project_head" value="" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','148');" autocomplete="off" />
                                </cfoutput>
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=get_money.project_id&project_head=get_money.project_head');"></span>
                            </div>
                        </div>
                    </div>
                    <cfif x_select_branch eq 1 and session.ep.isBranchAuthorization eq 0>
                    <div class="form-group" id="item-department_branch">
                        <label class="col col-4 col-xs12"><cf_get_lang_main no ='41.Şube'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='285' is_default='1' is_deny_control='1'>
                        </div>
                    </div>
                    </cfif>
                    <div class="form-group" id="item-paper_number">
                        <label class="col col-4 col-xs12"><cf_get_lang_main no='468.belge no'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="paper_number"  maxlength="50 "value="" style="width:150px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-ACTION_DATE">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='330.Tarih'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
                                <cfinput value="#dateformat(now(),dateformat_style)#" required="Yes" maxlength="10" validate="#validate_style#" message="#message#" type="text" name="ACTION_DATE" style="width:150px;" onBlur="change_money_info('get_money','ACTION_DATE');">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="ACTION_DATE" call_function="change_money_info"></span>
                            </div>	                           
                        </div>   
                    </div>
                    <div class="form-group" id="item-ACTION_VALUE">
                        <label class="col col-4 col-xs12"><cf_get_lang_main no='261.Tutar'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message1"><cf_get_lang_main no='1738.Lutfen Tutar Giriniz'>!</cfsavecontent>
                            <cfinput type="text" name="ACTION_VALUE" class="moneybox" style="width:150px;" value="" onBlur="kur_ekle_f_hesapla('account_id');" onkeyup="return(FormatCurrency(this,event,2,'float'));" required="yes" message="#message1#">
                        </div>
                    </div>
                    <div class="form-group" id="item-other_act_value">
                        <label class="col col-4 col-xs12"><cf_get_lang_main no='644.Dövizli Tutar'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="OTHER_CASH_ACT_VALUE" class="moneybox" style="width:150px;" value="" onBlur="kur_ekle_f_hesapla('account_id',true);" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                    </div>
                    <div class="form-group" id="item-employee">
                            <label class="col col-4 col-xs12"><cf_get_lang no='51.Parayı Çeken'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message1"><cf_get_lang no='2.Parayı Çeken'></cfsavecontent>
                                    <input type="Hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfoutput>#session.ep.userid#</cfoutput>">
                                    <cfinput type="text" name="EMPLOYEE" id="EMPLOYEE" onFocus= "AutoComplete_Create('EMPLOYEE','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','EMPLOYEE_ID','','2','250');" required="yes" message="#message1#" value="#get_emp_info(session.ep.userid,0,0)#" style="width:150px;">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=get_money.EMPLOYEE_ID&field_name=get_money.EMPLOYEE<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9</cfoutput>','list')"></span>
                                </div>
                            </div>
                        </div>
                    <div class="form-group" id="item-action_detail">
                        <label class="col col-4 col-xs12"><cf_get_lang_main no='217.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="ACTION_DETAIL" id="ACTION_DETAIL" ></textarea>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group">
                        <label class="bold"><cf_get_lang no='53.İşlem Para Br'></label>
                    </div>
                    <div class="form-group" id="item-kur_ekle">     
                        <div class="col col-12 scrollContent scroll-x2">
                            <cfscript>f_kur_ekle(process_type:0,base_value:'ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'get_money',select_input:'account_id',rate_purchase:xml_rate_purchase);</cfscript>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>	<!---/// footer alanı record info ve submit butonu--->
                <div class="col col-12"><cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'></div> <!---///butonlar--->
            </cf_box_footer>
        </cfform>  
    </cf_box>
</div>
<script type="text/javascript">
	kur_ekle_f_hesapla('account_id');
	function kontrol()
	{			
		if(!chk_process_cat('get_money')) return false;
		if(!check_display_files('get_money')) return false;
		if(!chk_period(document.get_money.ACTION_DATE, 'İşlem')) return false;
		if(!acc_control()) return false;
		kur_ekle_f_hesapla('account_id');//dövizli tutarı silinenler için
		if(document.getElementById('TO_CASH_ID').value == '')
		{ 
			alert ("<cf_get_lang no='188.Kasa Seciniz'> !");
			return false;
		}
		return true;
	}
	function check_acc_info(cash_money_info)
	{
		//Seçilen kasaya göre bankaların listelenmesi
		var account_id_len = eval('document.getElementById("account_id")').options.length;
		for(j=account_id_len;j>=0;j--)
			eval('document.getElementById("account_id")').options[j] = null;	
		eval('document.getElementById("account_id")').options[0] = new Option('Seçiniz','');
		var money_info = list_getat(cash_money_info,2,';');
		if(money_info != '')
		{
			<cfif session.ep.isBranchAuthorization>
				var new_sql2 = "bnk_get_acc_1";
			<cfelse>
				var new_sql2 = "bnk_get_acc_2";
			</cfif>
			var get_acc = wrk_safe_query(new_sql2,'dsn3',0,money_info);
			for(var tt=0;tt < get_acc.recordcount;tt++)
				eval('document.getElementById("account_id")').options[tt+1]=new Option(''+get_acc.ACCOUNT_NAME[tt]+' '+get_acc.ACCOUNT_CURRENCY_ID[tt]+'',''+get_acc.ACCOUNT_ID[tt]+'');
		}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

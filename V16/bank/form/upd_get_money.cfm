<cf_get_lang_set module_name="bank">
<cf_xml_page_edit fuseact="bank.form_add_get_money">
<cfset attributes.TABLE_NAME = "BANK_ACTIONS">
<cfinclude template="../query/get_action_detail.cfm">
<cfif not get_action_detail.recordcount>
	<br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform name="upd_get_money" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_get_money" method="post">
            <input type="hidden" name="id" value="<cfoutput>#attributes.id#</cfoutput>">
            <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
            <cfset cash=get_action_detail.ACTION_TO_CASH_ID>
            <cfset acc=get_action_detail.ACTION_FROM_ACCOUNT_ID>
            <cfset value=get_action_detail.ACTION_VALUE>
            <cfset emp_id=get_action_detail.ACTION_EMPLOYEE_ID>
           <cf_box_elements>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs12"><cf_get_lang_main no='388.işlem tipi'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process_cat process_cat='#get_action_detail.process_cat#' slct_width="250">
                        </div>
                    </div>
                    <div class="form-group" id="item-TO_CASH_ID">
                        <label class="col col-4 col-xs12"><cf_get_lang_main no='108.Kasa'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrk_Cash name="TO_CASH_ID" currency_branch="0" cash_status="1" onChange="check_acc_info(this.value);" value="#CASH#">
                        </div>
                    </div>
                    <div class="form-group" id="item-account_id">
                        <label class="col col-4 col-xs12"><cf_get_lang no='45.Banka/Hesap'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrkBankAccounts width='250' call_function='kur_ekle_f_hesapla' selected_value='#acc#' is_upd='1' currency_id_info='#get_action_detail.ACTION_CURRENCY_ID#'>
                        </div>
                    </div>
                    <div class="form-group" id="item-project_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                            <cfif len(get_action_detail.project_id)>
                                <cfquery name="get_pro_name" datasource="#dsn#">
                                    SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID=#get_action_detail.project_id#
                                </cfquery>
                            </cfif>
                            <cfif isdefined('get_pro_name')><cfset attributes.project_head=get_pro_name.project_head><cfelse><cfset attributes.project_head=''></cfif>
                                <cfoutput>
                                    <input type="hidden" name="project_id" id="project_id" value="#get_action_detail.project_id#" />
                                    <input type="text" style="width:150px" name="project_head" id="project_head" value="#attributes.project_head#" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','148');" autocomplete="off" />
                                </cfoutput>
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=upd_get_money.project_id&project_head=upd_get_money.project_head');"></span>
                            </div>
                        </div>
                    </div>
                    <cfif x_select_branch eq 1 and session.ep.isBranchAuthorization eq 0>
                    <div class="form-group" id="item-department_branch">
                        <label class="col col-4 col-xs12"><cf_get_lang_main no ='41.Şube'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='150' selected_value='#get_action_detail.from_branch_id#' is_deny_control='1'>
                        </div>
                    </div>
                    </cfif>
                    <div class="form-group" id="item-paper_number">
                        <label class="col col-4 col-xs12"><cf_get_lang_main no='468.belge no'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="paper_number" value="#get_action_detail.paper_no#" style="width:150px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-ACTION_DATE">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='330.Tarih'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
                                <cfinput value="#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" type="text" readonly name="ACTION_DATE" style="width:150px;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="ACTION_DATE" control_date="#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#" call_function="change_money_info"></span>
                            </div>	                           
                        </div>   
                    </div>
                    <div class="form-group" id="item-ACTION_VALUE">
                        <label class="col col-4 col-xs12"><cf_get_lang_main no='261.Tutar'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message1"><cf_get_lang_main no='1738.Lutfen Tutar Giriniz'>!</cfsavecontent>
                            <cfinput type="text" name="ACTION_VALUE" required="yes" class="moneybox" message="#message1#" style="width:150px;" value="#TLFormat(VALUE)#" onBlur="kur_ekle_f_hesapla('account_id');" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                    </div>
                    <div class="form-group" id="item-other_act_value">
                        <label class="col col-4 col-xs12"><cf_get_lang_main no='644.Dövizli Tutar'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="OTHER_CASH_ACT_VALUE" style="width:150px;" class="moneybox" value="#TLFormat(get_action_detail.OTHER_CASH_ACT_VALUE)#" onBlur="kur_ekle_f_hesapla('account_id',true);" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                    </div>
                    <div class="form-group" id="item-employee">
                            <label class="col col-4 col-xs12"><cf_get_lang no='51.Parayı Çeken'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="Hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfoutput>#emp_id#</cfoutput>">
                                    <input type="text" name="EMPLOYEE" id="EMPLOYEE" onFocus= "AutoComplete_Create('EMPLOYEE','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','EMPLOYEE_ID','','2','250');" value="<cfoutput>#get_emp_info(emp_id,0,0)#</cfoutput>" style="width:150px;">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_get_money.EMPLOYEE_ID&field_name=upd_get_money.EMPLOYEE<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9</cfoutput>','list','popup_list_positions');"></span>
                                </div>
                            </div>
                        </div>
                    <div class="form-group" id="item-action_detail">
                        <label class="col col-4 col-xs12"><cf_get_lang_main no='217.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px;height:60px;"><cfoutput>#get_action_detail.ACTION_DETAIL#</cfoutput></textarea>
                        </div>
                    </div>
                </div>
                <div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="false">
                    <div class="form-group"> <label class="bold"><cf_get_lang no='53.İşlem Para Br'></label></div>
                    <div class="form-group" id="item-kur_ekle">                    
                        <div class="col col-12 scrollContent scroll-x2">
                            <cfscript>f_kur_ekle(action_id:url.id,process_type:1,base_value:'ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'upd_get_money',action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#',select_input:'account_id',rate_purchase:xml_rate_purchase);</cfscript>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>	<!---/// footer alanı record info ve submit butonu--->
                <div class="col col-6"><cf_record_info query_name="get_action_detail"></div> <!---///record info--->
                <div class="col col-6">
                    <cf_workcube_buttons type_format="1" is_upd='1' is_cancel="0" update_status='#get_action_detail.UPD_STATUS#'
                        del_function_for_submit='del_kontrol()'
                        delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_get_money&id=#attributes.id#&old_process_type=#get_action_detail.action_type_id#&paper_no=#get_action_detail.paper_no#'
                        delete_alert='#getLang('main',1176)#'
                        add_function='kontrol()'>  
                </div> <!---///butonlar--->
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>

<script type="text/javascript">
	kur_ekle_f_hesapla('account_id');
	function del_kontrol()
	{
		control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
		if(!chk_period(document.upd_get_money.ACTION_DATE, 'İşlem')) return false;
		else return true;
	}
	function kontrol()
	{
		control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
		if(document.getElementById('account_id').value == '')
		{
			alert("<cf_get_lang no='169.Banka Hesabi Secmelisiniz!'>");
			return false;
		}
		if(!chk_process_cat('upd_get_money')) return false;
		if(!check_display_files('upd_get_money')) return false;
		if(!chk_period(document.upd_get_money.ACTION_DATE, 'İşlem')) return false;
		kur_ekle_f_hesapla('account_id');//dövizli tutarı silenler için..
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
				var new_sql2 = "bnk_get_acc_3";
			<cfelse>
				var new_sql2 = "bnk_get_acc_4";
			</cfif>
			var get_acc = wrk_safe_query(new_sql2,'dsn3',0,money_info);
			for(var tt=0;tt < get_acc.recordcount;tt++)
				eval('document.getElementById("account_id")').options[tt+1]=new Option(''+get_acc.ACCOUNT_NAME[tt]+' '+get_acc.ACCOUNT_CURRENCY_ID[tt]+'',''+get_acc.ACCOUNT_ID[tt]+'');
		}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

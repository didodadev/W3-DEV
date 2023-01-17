<cf_get_lang_set module_name="bank">
<cf_xml_page_edit fuseact="bank.form_add_invest_money">
<cfset refmodule="#listgetat(attributes.fuseaction,1,'.')#">
<cfset attributes.TABLE_NAME = "BANK_ACTIONS">
<cfinclude template="../query/get_action_detail.cfm">
<cfif not get_action_detail.recordcount>
	<br/><font class="bold"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cf_catalystHeader>
    <div>
        <cf_box>
            <cfform name="upd_invest_money" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_invest_money" method="post">
                <cfif listgetat(attributes.fuseaction,2,'.') is 'popup_upd_invest_money'>
                    <input type="hidden" name="is_popup" id="is_popup" value="1">
                <cfelse>
                    <input type="hidden" name="is_popup" id="is_popup" value="0">
                </cfif>
                <input type="hidden" name="ACTION_TYPE" id="ACTION_TYPE" value="PARA YATIRMA">
                <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
                <input type="hidden" name="id" id="id" value="<cfoutput>#url.id#</cfoutput>">
                <cf_box_elements>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item_process_cat" >
                            <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57800.işlem tipi'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process_cat process_cat=#get_action_detail.process_cat# slct_width="250">
                            </div>
                        </div>
                        <div class="form-group" id="item_cash_id">
                            <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57520.Kasa'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrk_Cash name="FROM_CASH_ID" currency_branch="0" cash_status="1" onChange="kur_ekle_f_hesapla('FROM_CASH_ID');check_acc_info(this.value);" value="#get_action_detail.ACTION_FROM_CASH_ID#">
                            </div>
                        </div>
                        <div class="form-group" id="item_bank_accounts">
                            <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='48706.Banka/Hesap'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkBankAccounts width='250' call_function='' selected_value='#get_action_detail.action_to_account_id#' is_upd='1' currency_id_info='#get_action_detail.ACTION_CURRENCY_ID#'>
                            </div>
                        </div>
                        <div class="form-group" id="item-project_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
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
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=upd_invest_money.project_id&project_head=upd_invest_money.project_head');"></span>
                                </div>
                            </div>
                        </div>
                        <cfif x_select_branch eq 1 and session.ep.isBranchAuthorization eq 0>
                        <div class="form-group" id="item_department_branch">
                            <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='150' selected_value='#get_action_detail.to_branch_id#' is_deny_control='1'>
                            </div>
                        </div>
                        </cfif>
                        <div class="form-group" id="item_paper_number">
                            <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57880.belge no'></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="paper_number" value="#get_action_detail.paper_no#" style="width:150px;">
                            </div>
                        </div>
                        <div class="form-group"  id="item_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
                                    <cfinput value="#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" type="text" name="ACTION_DATE" style="width:150px;" readonly onBlur="change_money_info('upd_invest_money','ACTION_DATE');">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="ACTION_DATE" call_function="change_money_info" control_date="#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#"></span>
                                </div>	                           
                            </div>   
                        </div>
                        <div class="form-group" id="item_action_value">
                            <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57673.Tutar'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message1"><cf_get_lang dictionary_id='29535.Lutfen Tutar Giriniz'>!</cfsavecontent>
                            <cfinput type="text" name="ACTION_VALUE" class="moneybox" value="#TLFormat(get_action_detail.ACTION_VALUE)#" required="yes" message="#message1#" style="width:150px;" onBlur="kur_ekle_f_hesapla('FROM_CASH_ID');" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                        </div>
                        <div class="form-group" id="item_other_act_value">
                            <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="OTHER_CASH_ACT_VALUE" class="moneybox" value="#TLFormat(get_action_detail.OTHER_CASH_ACT_VALUE)#" style="width:150px;" onBlur="kur_ekle_f_hesapla('FROM_CASH_ID',true);" onkeyup="return(FormatCurrency(this,event));">                        </div>
                        </div>
                        <div class="form-group" id="item-employee">
                                <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='48713.Parayı Yatıran'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="Hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfoutput>#get_action_detail.ACTION_EMPLOYEE_ID#</cfoutput>">
                                        <input type="text" name="EMPLOYEE" id="EMPLOYEE" onFocus= "AutoComplete_Create('EMPLOYEE','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','EMPLOYEE_ID','','2','250');" value="<cfoutput>#get_emp_info(get_action_detail.ACTION_EMPLOYEE_ID,0,0)#</cfoutput>" style="width:150px;">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_invest_money.EMPLOYEE_ID&field_name=upd_invest_money.EMPLOYEE<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9</cfoutput>','list','popup_list_positions');"></span>
                                    </div>
                                </div>
                            </div>
                        <div class="form-group" id="item-action_detail">
                            <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px;height:60px;"><cfoutput>#get_action_detail.ACTION_DETAIL#</cfoutput></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="false">
                        <div class="form-group">
                            <label class="bold"><cf_get_lang dictionary_id='48714.İşlem Para Br'></label>
                        </div>
                        <div id="item-kur_ekle"  class="form-group">                            
                            <div class="col col-12 scrollContent scroll-x2">
                                <cfscript>f_kur_ekle(action_id:url.id,process_type:1,base_value:'ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'upd_invest_money',action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#',select_input:'FROM_CASH_ID');</cfscript>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>	<!---/// footer alanı record info ve submit butonu--->
                    <div class="col col-6">
                        <cf_record_info query_name="get_action_detail">
                    </div> <!---///record info--->
                    <div class="col col-6">
                        <cfif listgetat(attributes.fuseaction,2,'.') is 'popup_upd_invest_money'>
                            <cfset url_link = "&is_popup=1">
                        <cfelse>
                            <cfset url_link = "">
                        </cfif>
                        <cfif listgetat(attributes.fuseaction,2,'.') is 'popup_upd_invest_money'>
                            <cf_workcube_buttons 
                                is_upd='1' 
                                del_function_for_submit='del_kontrol()'
                                update_status='#get_action_detail.UPD_STATUS#'
                                delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_invest_money&url_link=#url_link#&id=#url.id#&old_process_type=#get_action_detail.action_type_id#&paper_no=#get_action_detail.paper_no#' add_function='kontrol()'> 
                        <cfelse>
                            <cf_workcube_buttons 
                                is_upd='1' is_cancel="0" 
                                del_function_for_submit='del_kontrol()'
                                update_status='#get_action_detail.UPD_STATUS#'
                                delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_invest_money&url_link=#url_link#&id=#url.id#&old_process_type=#get_action_detail.action_type_id#&paper_no=#get_action_detail.paper_no#' add_function='kontrol()'> 
                        </cfif>
                    </div> <!---///butonlar--->
                </cf_box_footer>
            </cfform>
        </cf_box>
    </div>
<script type="text/javascript">
	kur_ekle_f_hesapla('FROM_CASH_ID');
	function del_kontrol()
	{
		control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
		if(!chk_period(document.upd_invest_money.ACTION_DATE, 'İşlem')) return false;
		else return true;
	}
	function kontrol()
	{
		control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
		if(document.getElementById('account_id').value == '')
		{
			alert("<cf_get_lang dictionary_id='48830.Banka Hesabi Secmelisiniz!'>");
			return false;
		}
		if(!chk_process_cat('upd_invest_money')) return false;
		if(!check_display_files('upd_invest_money')) return false;
		if(!chk_period(document.upd_invest_money.ACTION_DATE, 'İşlem')) return false;
		kur_ekle_f_hesapla('FROM_CASH_ID');//dövizli tutarı silenler için..
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

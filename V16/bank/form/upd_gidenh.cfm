<cf_get_lang_set module_name="bank">
<cf_xml_page_edit fuseact="bank.form_add_gidenh">
<cfset refmodule="#listgetat(attributes.fuseaction,1,'.')#">
<cfset attributes.TABLE_NAME = "BANK_ACTIONS">
<cfinclude template="../query/get_action_detail.cfm">
<cfscript>
    getXml = createObject("component","V16.bank.cfc.getXmlInfo");
    getXml = getXml.getXmlInfo('bank.list_bank_actions','x_ehesap_records_show');
    if(getXml.recordcount and getXml.property_value eq 1){
        if( len(get_action_detail.ACTION_TO_EMPLOYEE_ID)){
            include("../../objects/query/get_acc_types.cfm");
            if(((not module_power_user_hr and listfind(hr_type_list,get_action_detail.acc_type_id)) or (not module_power_user_ehesap and listfind(ehesap_type_list,get_action_detail.acc_type_id))) ){

                writeOutput(getlang('main',1531,'Kayıt bulunamdı'));
                abort;
            }
        }
    }
</cfscript>
<!--- giden havale ile ilgili kapama isleminin olup olmadigina bakilir --->
<cfif len(get_action_detail.action_id) and len(get_action_detail.action_type_id)>
	<cfquery name="get_closed" datasource="#dsn2#">
		SELECT 
			CCR.CLOSED_ID 
		FROM 
			CARI_CLOSED CC,
			CARI_CLOSED_ROW CCR 
		WHERE 
			CC.CLOSED_ID = CCR.CLOSED_ID
			AND CC.IS_CLOSED = 1
			AND CCR.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_action_detail.action_id#">
			AND CCR.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_action_detail.action_type_id#">
	</cfquery>
</cfif>
<cfif not get_action_detail.recordcount>
	<br/><font class="txtbold"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform name="upd_gidenh" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_gidenh">
            <input type="hidden" name="ACTION_TYPE" id="ACTION_TYPE" value="<cfoutput>#UCase(getLang('main',423))#</cfoutput>">
            <input type="hidden" name="my_fuseaction" id="my_fuseaction" value="<cfoutput>#fusebox.fuseaction#</cfoutput>">
            <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
            <input type="hidden" name="bank_order_id" id="bank_order_id" value="<cfif len(get_action_detail.bank_order_id)><cfoutput>#get_action_detail.bank_order_id#</cfoutput></cfif>">
            <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
            <cf_box_elements>
                <div  class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true" >
                    <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process_cat process_cat=#get_action_detail.process_cat# slct_width="285">
                            </div>
                    </div>
                    <cfif xml_process_stage eq 1>
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process is_upd='0'select_value='#get_action_detail.process_stage#' is_detail='1'>
                            </div>
                        </div>
                    </cfif>
                        <div class="form-group" id="item-account_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48706.Banka/Hesap'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkBankAccounts width='285' call_function='kur_ekle_f_hesapla' selected_value='#get_action_detail.action_from_account_id#' is_upd='1'>
                            </div>
                        </div>
                    <cfif isDefined('x_select_branch') and x_select_branch eq 1 and session.ep.isBranchAuthorization eq 0>
                        <div class="form-group" id="item-branch_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            <div class="col col-8 col-xs-12">
                                    <cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='285' selected_value='#get_action_detail.from_branch_id#'>
                            </div>
                        </div>
                    </cfif>
                    <cfif isDefined("x_select_type_info") and x_select_type_info neq 0>
                        <div class="form-group" id="item-special_definition_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58928.Ödeme Tipi'><cfif x_select_type_info eq 2>*</cfif></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrk_special_definition width_info='150' type_info='2' field_id="special_definition_id" selected_value='#get_action_detail.special_definition_id#'>
                            </div>
                        </div>
                    </cfif>
                    <cfif isDefined("x_select_department") and x_select_department eq 1>
                        <div class="form-group" id="item-acc_department_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkDepartmentBranch fieldId='acc_department_id' is_department='1' width='150' selected_value='#get_action_detail.ACC_DEPARTMENT_ID#'>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-comp_name">
                    <cfoutput>
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.cari Hesap'>*</label>
                        <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                <cfset emp_id = get_action_detail.ACTION_TO_EMPLOYEE_ID>
                                <cfif len(get_action_detail.acc_type_id) and len(emp_id)>
                                    <cfset emp_id = "#emp_id#_#get_action_detail.acc_type_id#">
                                </cfif>
                                <cfif len(get_action_detail.ACTION_TO_COMPANY_ID)>
                                    <cfset member_name=get_par_info(get_action_detail.ACTION_TO_COMPANY_ID,1,1,0)>
                                <cfelseif len(get_action_detail.ACTION_TO_CONSUMER_ID)>
                                    <cfset member_name=get_cons_info(get_action_detail.ACTION_TO_CONSUMER_ID,0,0)>
                                <cfelseif len(get_action_detail.ACTION_TO_EMPLOYEE_ID)>
                                    <cfset member_name=get_emp_info(get_action_detail.ACTION_TO_EMPLOYEE_ID,0,0,0,get_action_detail.acc_type_id)>
                                </cfif>
                                    <input type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="#emp_id#" >
                                    <input type="hidden" name="ACTION_TO_COMPANY_ID" id="ACTION_TO_COMPANY_ID" value="#get_action_detail.ACTION_TO_COMPANY_ID#">
                                    <input type="hidden" name="ACTION_TO_CONSUMER_ID" id="ACTION_TO_CONSUMER_ID" value="#get_action_detail.ACTION_TO_CONSUMER_ID#">
                                    <input type="text" name="comp_name" id="comp_name" style="width:150px;" onFocus="AutoComplete_Create('comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'0\',\'1\',\'\',\'0\'','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID','ACTION_TO_CONSUMER_ID,ACTION_TO_COMPANY_ID,EMPLOYEE_ID','','2','250','get_money_info(\'upd_gidenh\',\'ACTION_DATE\')');" value="<cfif isdefined("member_name") and len(member_name)>#member_name#<cfelse>#get_emp_info(get_action_detail.ACTION_TO_EMPLOYEE_ID,0,0,0,get_action_detail.acc_type_id)#</cfif>">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_comp_id=upd_gidenh.ACTION_TO_COMPANY_ID&field_member_name=upd_gidenh.comp_name&field_emp_id=upd_gidenh.EMPLOYEE_ID&field_name=upd_gidenh.comp_name&field_consumer=upd_gidenh.ACTION_TO_CONSUMER_ID<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3,1,9','list','popup_list_pars');"></span>
                            </div>
                        </div>
                    </cfoutput>
                    </div>
                    <div class="form-group" id="item-project_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'><cfif isdefined("x_required_project") and x_required_project eq 1>*</cfif></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                            <cfif len(get_action_detail.project_id)>
                                <cfquery name="get_pro_name" datasource="#dsn#">
                                    SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID =#get_action_detail.project_id#
                                </cfquery>
                                <cfoutput>
                                    <input type="hidden"  name="project_id" id="project_id"  value="#get_action_detail.project_id#" />
                                    <input type="text" style="width:150px" name="project_head" id="project_head" value="#get_pro_name.project_head#" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','add_costplan','3','135')" autocomplete="off" />
                                </cfoutput>
                            <cfelse>
                                <input type="hidden"  name="project_id" id="project_id"  value="" />
                                <input type="text" style="width:150px" name="project_head" id="project_head" value="" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','add_costplan','3','135')" autocomplete="off" />
                            </cfif>
                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=upd_gidenh.project_id&project_head=upd_gidenh.project_head');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-subscription_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrk_subscriptions fieldId='subscription_id' fieldName='subscription_no' form_name='upd_gidenh' subscription_id='#get_action_detail.subscription_id#' subscription_no='#get_subscription_no(iif(len(get_action_detail.subscription_id),get_action_detail.subscription_id,0))#'>
                            </div>
                        </div>
                    <cfif session.ep.our_company_info.asset_followup eq 1>
                        <div class="form-group" id="item-asset_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkAssetp asset_id="#get_action_detail.assetp_id#" fieldId='asset_id' fieldName='asset_name' form_name='upd_gidenh'>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-paper_number">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.belge no'></label>
                        <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="paper_number" readonly="readonly" value="#get_action_detail.paper_no#" style="width:150px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-ACTION_DATE">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
                        <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                <cfinput value="#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#" validate="#validate_style#" required="Yes"  type="text" name="ACTION_DATE" style="width:150px;" readonly onBlur="change_money_info('upd_gidenh','ACTION_DATE','#xml_money_type#');">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="ACTION_DATE" call_function="change_money_info" control_date="#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#" function_currency_type="#xml_money_type#"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-ACTION_VALUE">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'>*</label>
                        <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="ACTION_VALUE" class="moneybox" style="width:150px;" value="#TLFormat(get_action_detail.ACTION_VALUE-get_action_detail.MASRAF)#" onBlur="kur_ekle_f_hesapla('account_id');" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                    </div>
                    <div class="form-group" id="item-OTHER_CASH_ACT_VALUE">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></label>
                        <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="OTHER_CASH_ACT_VALUE" style="width:150px;" class="moneybox" value="#TLFormat(get_action_detail.OTHER_CASH_ACT_VALUE)#" onBlur="kur_ekle_f_hesapla('account_id',true);" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                    </div>
                    <div class="form-group" id="item-ACTION_DETAIL">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                                <textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px;height:50px;"><cfoutput>#get_action_detail.ACTION_DETAIL#</cfoutput></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-masraf">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='58930.Masraf'></label>
                    </div>
                    <div class="form-group" id="item-tutar">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif get_action_detail.MASRAF gt 0>
                                <cfinput type="text" name="masraf" class="moneybox" style="width:150px;" value="#TLFormat(get_action_detail.MASRAF)#" onkeyup="return(FormatCurrency(this,event));">
                                <cfelse>
                                <cfinput type="text" name="masraf" class="moneybox" style="width:150px;" value="" onkeyup="return(FormatCurrency(this,event));">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-expense_center_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
                        <div class="col col-8 col-xs-12">
                                <cf_wrkExpenseCenter width_info="150" fieldId="expense_center_id" fieldName="expense_center_name" form_name="upd_gidenh" expense_center_id="#get_action_detail.expense_center_id#" img_info="plus_thin">
                        </div>
                    </div>
                    <div class="form-group" id="item-expense_item_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></label>
                        <div class="col col-8 col-xs-12">
                                <cf_wrkExpenseItem width_info="150" fieldId="expense_item_id" fieldName="expense_item_name" form_name="upd_gidenh" income_type_info="0" expense_item_id="#get_action_detail.expense_item_id#" img_info="plus_thin">
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true" >
                    <div class="form-group">
                        <label class ="col col-12 bold"><cf_get_lang dictionary_id='48714.İşlem Para Br'></label>
                    </div>
                    <cfif isdefined("xml_money_type") and xml_money_type eq 0>
                        <cfset currency_rate_ = 0>
                    <cfelseif isdefined("xml_money_type") and xml_money_type eq 1>
                        <cfset currency_rate_ = 1>
                    <cfelseif isdefined("xml_money_type") and xml_money_type eq 2>
                        <cfset currency_rate_ = 0>
                    </cfif>	  
                    <div class="form-group" id="item-kur_ekle">                    
                        <div class="col col-12 scrollContent scroll-x2">
                            <cfscript>f_kur_ekle(rate_purchase : currency_rate_,action_id:attributes.id,process_type:1,base_value:'ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'upd_gidenh',action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#',select_input:'account_id');</cfscript>
                        </div>
                    </div>
                </div>
            </cf_box_elements>                           
            <cf_box_footer>
                <div class="col col-6 col col-xs-12">
                    <cf_record_info query_name="get_action_detail">
                </div>
                <div class="col col-6 col-xs-12">
                    <cfif not(session.ep.our_company_info.is_paper_closer eq 1 and isdefined("get_closed") and get_closed.recordcount neq 0)>
                        <cf_workcube_buttons is_upd='1' is_cancel="0"
                            update_status='#get_action_detail.upd_status#'
                            del_function_for_submit='del_kontrol()'
                            delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_gidenh&id=#attributes.id#&head=#get_action_detail.paper_no#&old_process_type=#get_action_detail.action_type_id#' 
                            delete_alert='Giden Havale İşlemini Siliyorsunuz. Emin misiniz?' 
                            add_function='kontrol()'> 
                    </cfif>
                    <cfif (session.ep.our_company_info.is_paper_closer eq 1 and isdefined("get_closed") and get_closed.recordcount neq 0)>
                        <table style="text-align:right;">
                        <tr>
                        <td style="text-align:right;">
                        <font color="##FF0000"><cf_get_lang dictionary_id="52412.Fatura Kapama İşlemi Yapıldığı İçin Belge Güncellenemez">.</font>
                        </td>
                        </tr>
                        </table>
                    </cfif>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>	
<script type="text/javascript">
	function del_kontrol()
	{
		control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
		if(!chk_period(document.upd_gidenh.ACTION_DATE, 'İşlem')) return false;
		else return true;
	}
	function kontrol()
	{
		if(!chk_process_cat('upd_gidenh')) return false;
		if(!check_display_files('upd_gidenh')) return false;
		if(!chk_period(document.upd_gidenh.ACTION_DATE, 'İşlem')) return false;
		kur_ekle_f_hesapla('account_id');//dövizli tutarı silenler için..
        <cfif x_select_type_info eq 2>
            if(document.add_gidenh.special_definition_id.value == "")
            {
                alert("<cf_get_lang dictionary_id='48792.Ödeme Tipi Seçmelisiniz '>!");	
                return false;
            }
        </cfif>	
		if((document.getElementById('ACTION_TO_COMPANY_ID').value =="" || document.upd_gidenh.EMPLOYEE_ID.VALUE=="" || document.upd_gidenh.ACTION_TO_CONSUMER_ID.value=="") && document.getElementById('comp_name').value=='')
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57519.Cari Hesap'>");
			return false;
		}
		if(document.getElementById('ACTION_VALUE').value == "")
		{
			alert("<cf_get_lang dictionary_id='29535.Tutar Giriniz'>!");
			return false;
        }
        <cfif x_required_project eq 1>
            if(document.upd_gidenh.project_id.value == "")
            {
                alert("<cf_get_lang dictionary_id='40045.Proje Seçmelisiniz '>!");	
                return false;
            }
        </cfif>	
		if(document.upd_gidenh.masraf.value != "" && document.upd_gidenh.masraf.value != 0)//masraf tutarı girildiğindeki kontrol
		{
			if(document.upd_gidenh.expense_item_id.value == "" || document.upd_gidenh.expense_item_name.value == "") 
			{
				alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='58551.Gider Kalemi'>");
				return false;
			}
			if(document.upd_gidenh.expense_center_id.value == "" || document.upd_gidenh.expense_center_name.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='58460.Masraf Merkezi'>");
				return false;
			}
		}
		return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
	}
	kur_ekle_f_hesapla('account_id');
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<!---select ifadeleri düzenlendi. e.a 19072012--->
<cf_get_lang_set module_name="ch">
<cfquery name="GET_CARI_OPEN_ROW" datasource="#DSN2#">
	SELECT 
		CR.ACTION_CURRENCY_ID,
		CR.CARI_ACTION_ID,
        CR.SUBSCRIPTION_ID,
		CR.ACTION_NAME,
		CR.PROCESS_CAT, 
		CR.TO_CMP_ID, 
		CR.FROM_CMP_ID, 
		CR.FROM_CONSUMER_ID,
		CR.TO_CONSUMER_ID,
		CR.FROM_EMPLOYEE_ID,
		CR.TO_EMPLOYEE_ID,
		CR.ACTION_VALUE,
		CR.OTHER_CASH_ACT_VALUE,
		CR.OTHER_MONEY,
		CR.DUE_DATE,
		CR.PROJECT_ID,
		CR.ASSETP_ID,
		CR.ACTION_DATE,
		CR.ACTION_VALUE_2,
		CR.RECORD_EMP,
		CR.RECORD_DATE,
		CR.UPDATE_EMP,
		CR.UPDATE_DATE,
		CR.ACTION_CURRENCY_2,
		CR.PAPER_NO,
		ISNULL(CR.TO_BRANCH_ID,FROM_BRANCH_ID) BRANCH_ID,
		CR.ACC_TYPE_ID
	<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
		,C.FULLNAME
	<cfelseif isdefined("attributes.cons_id") and len(attributes.cons_id)>
		<cfif database_type is "MSSQL">
			,(CON.CONSUMER_NAME + ' ' + CON.CONSUMER_SURNAME) AS FULLNAME
		<cfelseif database_type is "DB2">
			,(CON.CONSUMER_NAME || ' ' || CON.CONSUMER_SURNAME) AS FULLNAME
		</cfif>
	<cfelseif isdefined("attributes.emp_id") and len(attributes.emp_id)>
		<cfif database_type is "MSSQL">
			,(EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME) AS FULLNAME
		<cfelseif database_type is "DB2">
			,(EMP.EMPLOYEE_NAME || ' ' || EMP.EMPLOYEE_SURNAME) AS FULLNAME
		</cfif>
	</cfif>
	FROM 
		CARI_ROWS CR
	<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
		,#dsn_alias#.COMPANY C
	<cfelseif isdefined("attributes.cons_id") and len(attributes.cons_id)>
		,#dsn_alias#.CONSUMER CON
	<cfelseif isdefined("attributes.emp_id") and len(attributes.emp_id)>
		,#dsn_alias#.EMPLOYEES EMP
	</cfif>
	WHERE		
		CR.ACTION_TYPE_ID = 40
	<cfif isdefined("attributes.cari_act_id")>
		AND CR.CARI_ACTION_ID = #attributes.cari_act_id#
	</cfif>
	<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
		 AND (CR.FROM_CMP_ID = #attributes.comp_id# OR CR.TO_CMP_ID = #attributes.comp_id#)
		 AND (CR.FROM_CMP_ID = C.COMPANY_ID OR CR.TO_CMP_ID = C.COMPANY_ID)
	<cfelseif isdefined("attributes.cons_id") and len(attributes.cons_id)>
		 AND (CR.FROM_CONSUMER_ID = #attributes.cons_id# OR CR.TO_CONSUMER_ID = #attributes.cons_id#)
		 AND (CR.FROM_CONSUMER_ID = CON.CONSUMER_ID OR CR.TO_CONSUMER_ID = CON.CONSUMER_ID)
	<cfelseif isdefined("attributes.emp_id") and len(attributes.emp_id)>
		 AND (CR.FROM_EMPLOYEE_ID = #attributes.emp_id# OR CR.TO_EMPLOYEE_ID = #attributes.emp_id#)
		 AND (CR.FROM_EMPLOYEE_ID = EMP.EMPLOYEE_ID OR CR.TO_EMPLOYEE_ID = EMP.EMPLOYEE_ID)
	</cfif>
</cfquery>
<cfquery name="GET_MONEY_RATE" datasource="#dsn2#">
	SELECT MONEY FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang(1344,'Açılış Fişi',58756)#"popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="upd_ch_open" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_ch_open_row">
        <input type="hidden" name="cari_act_id" id="cari_act_id" value="<cfoutput>#attributes.cari_act_id#</cfoutput>">	
        <input type="hidden" name="modal_id" id="modal_id" value="<cfoutput>#attributes.modal_id#</cfoutput>">	
        <cfoutput query="GET_CARI_OPEN_ROW">
            <cfif len(to_cmp_id)>
                <cfset my_company_id = to_cmp_id>
            <cfelseif len(from_cmp_id)>
                <cfset my_company_id = from_cmp_id>
            <cfelse>
                <cfset my_company_id ="">
            </cfif>
            <cfif len(to_consumer_id)>
                <cfset my_consumer_id = to_consumer_id>
            <cfelseif len(from_consumer_id)>	
                <cfset my_consumer_id = from_consumer_id>
            <cfelse>
                <cfset my_consumer_id = "">
            </cfif>
            <cfif len(to_employee_id)>
                <cfset my_employee_id = to_employee_id>
            <cfelseif len(from_employee_id)>	
                <cfset my_employee_id = from_employee_id>
            <cfelse>
                <cfset my_employee_id = "">
            </cfif>
            <cfset emp_id = my_employee_id>
            <cfset fullname_ = fullname>
            <cfif len(my_employee_id) and len(acc_type_id)>
                <cfset fullname_ = get_emp_info(my_employee_id,0,0,0,acc_type_id)>
                <cfset emp_id = '#emp_id#_#acc_type_id#'>
            </cfif>
            <cfif len(my_company_id) and len(acc_type_id)>
                <cfset fullname_ = get_par_info(my_company_id,1,1,0,acc_type_id)>
                <cfset my_company_id = '#my_company_id#_#acc_type_id#'>
            </cfif>
            <cfif len(my_consumer_id) and len(acc_type_id)>
                <cfset fullname_ = get_par_info(get_cons_info,1,0,acc_type_id)>
                <cfset my_consumer_id = '#my_consumer_id#_#acc_type_id#'>
            </cfif>
            <cfset subscription_id = subscription_id>
            <cfif len(subscription_id)>
                <cfset subscription_no = get_subscription_no(subscription_id)>
            <cfelse>
                <cfset subscription_no = "">
            </cfif>
            <input type="hidden" name="old_comp_id" id="old_comp_id" value="#my_company_id#">
            <input type="hidden" name="comp_id" id="comp_id" value="#my_company_id#">
            <input type="hidden" name="old_cons_id" id="old_cons_id" value="#my_consumer_id#">
            <input type="hidden" name="cons_id" id="cons_id" value="#my_consumer_id#">
            <input type="hidden" name="old_emp_id" value="#emp_id#">
            <input type="hidden" name="emp_id" id="emp_id" value="#emp_id#">
            <input type="hidden" name="CARI_ACTION_ID" id="CARI_ACTION_ID" value="<cfoutput>#attributes.cari_act_id#</cfoutput>">
            <input type="hidden" name="member_type" id="member_type" value="">
            <input type="hidden" name="cari_act_id" id="cari_act_id" value="<cfoutput>#attributes.cari_act_id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-detail">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="detail" id="detail" value="#ACTION_NAME#" >
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'>*</label>
                        <div class="col col-9 col-xs-12">
                            <cf_workcube_process_cat process_cat=#get_cari_open_row.process_cat# slct_width="200">
                        </div>
                    </div>
                    <div class="form-group" id="item-emp_id">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57519.Hesap'>*</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="acc_name" id="acc_name" onFocus="AutoComplete_Create('acc_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','comp_id,cons_id,emp_id,member_type','','3','200');" value="#fullname_#" >
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_ac();"></span>
                            </div> 
                        </div>
                    </div>
                    <cfif session.ep.our_company_info.project_followup eq 1>
                        <div class="form-group" id="item-project_id">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="#PROJECT_ID#">
                                    <cfif len(PROJECT_ID)>
                                    <cfquery name="get_project_name" datasource="#dsn#">
                                    SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #PROJECT_ID#
                                    </cfquery>
                                    </cfif>
                                    <cf_wrk_projects form_name='upd_ch_open' project_id='project_id' project_name='project_name'>
                                    <input type="text" name="project_name" id="project_name" value="<cfif len(PROJECT_ID)>#get_project_name.project_head#</cfif>"  onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_head=upd_ch_open.project_name&project_id=upd_ch_open.project_id&form_varmi=1');"></span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-subscription_id">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='29502.Abone No'></label>
                        <div class="col col-9 col-xs-12">
                            <cf_wrk_subscriptions fieldId='subscription_id' fieldName='subscription_no' form_name='upd_ch_open'  subscription_id='#subscription_id#' subscription_no='#subscription_no#'>
                        </div>
                    </div>
                    <cfif session.ep.our_company_info.asset_followup eq 1>
                        <div class="form-group" id="item-asset_id">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></label>
                            <div class="col col-9 col-xs-12">
                                <cf_wrkAssetp asset_id="#assetp_id#" fieldId='asset_id' fieldName='asset_name' form_name='upd_ch_open' width='200'>
                            </div>
                        </div>
                    </cfif>
                    <cfif session.ep.isBranchAuthorization eq 0>
                        <div class="form-group" id="item-branch_id">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='57453.Şube'></label>
                            <div class="col col-9 col-xs-12">
                                <cf_wrkDepartmentBranch fieldId='branch_id' selected_value='#branch_id#' is_branch='1' width='200' is_default='0' is_deny_control='1'>
                            </div>
                        </div>
                    </cfif>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-open_date">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfinput name="open_date" value="#dateformat(action_date,dateformat_style)#" validate="#validate_style#" type="text"  readonly="yes" required="yes" message="İşlem Tarihi Giriniz!">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="open_date" control_date="#dateformat(action_date,dateformat_style)#"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-due_date">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58851.Ödeme Tarihi'></label>
                            <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfinput name="due_date" value="#dateformat(due_date,dateformat_style)#" validate="#validate_style#" type="text" >
                                <span class="input-group-addon"><cf_wrk_date_image date_field="due_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-paper_no">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="paper_no" id="paper_no" value="#paper_no#"  maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-debt">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57587.Borç'>*</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="debt" id="debt" value="<cfif len(to_cmp_id) or len(to_consumer_id) or len(to_employee_id)>#TLFormat(action_value,2)#<cfelse>0</cfif>" class="moneybox"  onBlur="sil(0);" onkeyup="return(FormatCurrency(this,event));"><span class="input-group-addon">#session.ep.money#</span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-claim">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57588.Alacak'>*</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="claim" id="claim" value="<cfif len(from_cmp_id) or len(from_consumer_id) or len(from_employee_id)>#TLFormat(action_value,2)#<cfelse>0</cfif>" class="moneybox"  onBlur="sil(1);" onkeyup="return(FormatCurrency(this,event));"><span class="input-group-addon">#session.ep.money#</span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-other_money_type">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58121.İşlem Dövizi'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="other_money_value" id="other_money_value" value="<cfif len(GET_CARI_OPEN_ROW.OTHER_CASH_ACT_VALUE)>#TLFormat(GET_CARI_OPEN_ROW.OTHER_CASH_ACT_VALUE,2)#</cfif>" class="moneybox"  onkeyup="return(FormatCurrency(this,event));">
                                <span class="input-group-addon width">
                                    <select name="other_money_type" id="other_money_type" style="width:60px;">
                                        <cfloop query="GET_MONEY_RATE">
                                            <option value="#money#"<cfif len(GET_CARI_OPEN_ROW.OTHER_MONEY) and (GET_CARI_OPEN_ROW.OTHER_MONEY eq money)>selected</cfif>>#money#</option>
                                        </cfloop>
                                    </select>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-action_value_2">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='47485.Sistem 2 Dövizi'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="action_value_2" id="action_value_2" maxlength="50" value="<cfif len(GET_CARI_OPEN_ROW.ACTION_VALUE_2)>#TLFormat(GET_CARI_OPEN_ROW.ACTION_VALUE_2,2)#</cfif>" class="moneybox"  onkeyup="return(FormatCurrency(this,event));">
                                <span class="input-group-addon"><cfif len(session.ep.money2)><cfoutput>#session.ep.money2#</cfoutput></cfif></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
                    
            <cf_box_footer>
                <cf_record_info query_name="GET_CARI_OPEN_ROW">
                <cf_workcube_buttons is_upd='1' type_format='1' is_delete='1' add_function="kontrol()" delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_ch_open_row&cari_act_id=#CARI_ACTION_ID#'>
            </cf_box_footer>
                
        </cfoutput>  
    </cfform> 
</cf_box>
<script type="text/javascript">
	function sil(gelen)
	{
		if( (gelen==0) && (upd_ch_open.debt.value.length) && (upd_ch_open.claim.value.length) )
		upd_ch_open.claim.value = '';
		else if ( (gelen==1) && (upd_ch_open.debt.value.length) && (upd_ch_open.claim.value.length) )
		upd_ch_open.debt.value = '';
	}
	function pencere_ac(r_row)
	{
		hesap_sec();
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_multi_act=1&is_cari_action=1&field_name=upd_ch_open.acc_name&field_type=upd_ch_open.member_type&field_comp_name=upd_ch_open.acc_name&field_consumer=upd_ch_open.cons_id&field_emp_id=upd_ch_open.emp_id&field_comp_id=upd_ch_open.comp_id<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_store_module")>&is_store_module=1</cfif>&is_form_submitted=1&select_list=2,3,1,9');
	}
	
	function kontrol()
	{
		if(!chk_process_cat('upd_ch_open')) return false;
		if(!chk_period(document.upd_ch_open.open_date,'İşlem')) return false;
		if((upd_ch_open.acc_name.value=='') || (upd_ch_open.comp_id.value=='' && upd_ch_open.cons_id.value=='' && upd_ch_open.emp_id.value==''))
		{
			alert("<cf_get_lang dictionary_id='50081.Lütfen Cari Hesap Seçiniz'> !");
			return false;
		}
		if((upd_ch_open.debt.value=='') && (upd_ch_open.claim.value==''))
		{
			alert("<cf_get_lang dictionary_id='57587.Borç'>/<cf_get_lang dictionary_id='57588.Alacak'> <cf_get_lang dictionary_id='58589.Değer Girmelisiniz'>!");
			return false;
		}
		if(((upd_ch_open.debt.value==' ') || (upd_ch_open.debt.value== 0 )) && ((upd_ch_open.claim.value==' ') || (upd_ch_open.claim.value== 0)))
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='57587.Borç'>/<cf_get_lang dictionary_id='57588.Alacak'> <cf_get_lang dictionary_id='57989.Ve'> <cf_get_lang dictionary_id='30012.Değer 0 Sıfır Olamaz'>");
			return false;
		}
		if((upd_ch_open.other_money_value.value==''))
		{
			alert("<cf_get_lang dictionary_id='50063.İşlem Dövizi Değeri Girmelisiniz'>!");
			return false;
		}	
		if((upd_ch_open.action_value_2.value==''))
		{
			alert("<cf_get_lang dictionary_id='50062.Sistem Dövizi Değeri Girmelisiniz'>!");
			return false;
		}
		upd_ch_open.debt.value = filterNum(upd_ch_open.debt.value,4);
		upd_ch_open.claim.value = filterNum(upd_ch_open.claim.value,4);
		upd_ch_open.other_money_value.value = filterNum(upd_ch_open.other_money_value.value,4);	
		upd_ch_open.action_value_2.value = filterNum(upd_ch_open.action_value_2.value,4);	
		return true;
	}
	function hesap_sec()
	{
		if(document.upd_ch_open.comp_id.value!='')
		{
			document.upd_ch_open.comp_id.value='';
			document.upd_ch_open.acc_name.value='';
		}
		if(document.upd_ch_open.emp_id.value!='')
		{
			document.upd_ch_open.emp_id.value='';
			document.upd_ch_open.acc_name.value='';
		}
		if(document.upd_ch_open.cons_id.value!='')
		{
			document.upd_ch_open.cons_id.value='';
			document.upd_ch_open.acc_name.value='';
		}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

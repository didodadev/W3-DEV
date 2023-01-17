<!--- teminat tabloları crm ekranlarnda da kullanılıyor ama sayfalar ortaklaştırılmadı şimdilik,ayrı özellikleri var--->
<cf_get_lang_set module_name="member">
    <cfparam name="commission_rate" default="0">
    <cfquery name="GET_MONEY" datasource="#dsn2#">
        SELECT * FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY
    </cfquery>
    <cfquery name="GET_OUR_COMPANIES" datasource="#dsn#">
        SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
    </cfquery>
    <cfquery name="GET_BANKS_NAME" datasource="#DSN3#">
        SELECT DISTINCT BANK_ID,BANK_NAME FROM BANK_BRANCH WHERE BANK_ID IS NOT NULL ORDER BY BANK_NAME
    </cfquery> 
    <cfif isdefined('attributes.securefund_id') and len(attributes.securefund_id)>
        <cfquery name="GET_COMPANY_SECUREFUND" datasource="#DSN#">
            SELECT * FROM COMPANY_SECUREFUND WHERE SECUREFUND_ID = #ATTRIBUTES.SECUREFUND_ID#
        </cfquery>
    </cfif>
    <cf_papers paper_type="securefund">
    <cf_catalystHeader>
    <div class="col col-12 col-xs-12">
        <cf_box>
            <cfform name="add_secure" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=member.emptypopup_add_securefund">
                <cf_box_elements>
                    <div class="col col-4 col-md-6 col-sm-8 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-SECUREFUND_STATUS">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                            <div class="col col-8 col-xs-12">
                                <cfif isdefined("GET_COMPANY_SECUREFUND")>
                                    <input type="checkbox" name="SECUREFUND_STATUS" id="SECUREFUND_STATUS" value="1"<cfif GET_COMPANY_SECUREFUND.SECUREFUND_STATUS eq 1>checked</cfif>>
                                <cfelse>
                                    <input type="checkbox" name="SECUREFUND_STATUS" id="SECUREFUND_STATUS" value="1" checked>
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-member_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57658.Üye'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfoutput>
                                        <cfif isdefined("attributes.comp_id")>
                                            <input type="hidden" name="company_id" id="company_id" value="#attributes.comp_id#">
                                            <input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.comp_id#">
                                            <cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
                                                <input type="text" name="member" id="member" value="#get_par_info(attributes.comp_id,1,0,0)#" readonly>
                                            <cfelseif isdefined("attributes.comp_id") and len(attributes.comp_id)>
                                                <input type="text" name="member" id="member" value="#get_cons_info(attributes.comp_id,0,0)#" readonly>
                                            </cfif>
                                            <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_all_pars&is_multi_act=1&field_comp_id=add_secure.company_id&field_name=add_secure.member&field_consumer=add_secure.consumer_id&select_list=2,3');"></span>
                                        <cfelse>
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57785.Üye secmelisiniz'></cfsavecontent>
                                            <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
                                                <input type="hidden" name="consumer_id" id="consumer_id" value="">
                                                <input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
                                                <input type="text" name="member" id="member" value="#get_par_info(attributes.company_id,1,0,0)#" readonly>
                                            <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                                                <input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
                                                <input type="hidden" name="company_id" id="company_id" value="">
                                                <input type="text" name="member" id="member" value="#get_cons_info(attributes.consumer_id,0,0)#" readonly>
                                            <cfelse>
                                                <input type="hidden" name="consumer_id" id="consumer_id" value="">
                                                <input type="hidden" name="company_id" id="company_id" value="">
                                                <input type="text" name="member" id="member" value="" readonly required="yes" message="#message#">
                                            </cfif>
                                            <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_all_pars&is_multi_act=1&field_comp_id=add_secure.company_id&field_name=add_secure.member&field_consumer=add_secure.consumer_id&select_list=2,3');"></span>    
                                        </cfif>
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-our_company_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30451.Şirketimiz'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="our_company_id" id="our_company_id" onchange="showDepartment(this.value)">
                                    <cfoutput query="get_our_companies">
                                        <cfif isdefined("GET_COMPANY_SECUREFUND")>
                                            <option value="#COMP_ID#"<cfif comp_id eq GET_COMPANY_SECUREFUND.OUR_COMPANY_ID> selected</cfif>>#company_name#</option>
                                        <cfelse>
                                            <option value="#COMP_ID#"<cfif comp_id eq session.ep.company_id> selected</cfif>>#company_name#</option>
                                        </cfif>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-DEPARTMENT_PLACE">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30127.Şubemiz'></label>
                            <div class="col col-8 col-xs-12">
                                <div width="310" id="DEPARTMENT_PLACE">
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-bank_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57521.Banka'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="bank_id" id="bank_id" onchange="get_branches();">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfif isdefined("GET_COMPANY_SECUREFUND") and len(GET_COMPANY_SECUREFUND.BANK_BRANCH_ID)>
                                        <cfquery name="get_bank_" datasource="#dsn3#">
                                            SELECT BANK_ID FROM BANK_BRANCH WHERE BANK_BRANCH_ID = #GET_COMPANY_SECUREFUND.BANK_BRANCH_ID#
                                        </cfquery>
                                    </cfif>
                                    <cfoutput query="get_banks_name">
                                        <option value="#bank_id#" <cfif isdefined("get_bank_") and bank_id eq get_bank_.BANK_ID>selected</cfif>>#bank_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-branch_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="branch_id" id="branch_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfif isdefined("GET_COMPANY_SECUREFUND") and len(GET_COMPANY_SECUREFUND.BANK_BRANCH_ID)>
                                        <cfquery name="get_bank_branch_" datasource="#dsn3#">
                                            SELECT BANK_BRANCH_ID,BANK_BRANCH_NAME FROM BANK_BRANCH WHERE BANK_BRANCH_ID = #GET_COMPANY_SECUREFUND.BANK_BRANCH_ID#
                                        </cfquery>
                                        <cfoutput query="get_bank_branch_">
                                            <option value="#bank_branch_id#"<cfif bank_branch_id eq get_bank_branch_.BANK_BRANCH_ID>selected</cfif>>#bank_branch_name#</option>
                                        </cfoutput>
                                    </cfif>	
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-SECUREFUND_CAT_ID">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30452.Teminat Kategorisi'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrk_combo 
                                    name="SECUREFUND_CAT_ID"
                                    query_name="GET_SECUREFUND"
                                    value="#iif(isDefined("GET_COMPANY_SECUREFUND"),'GET_COMPANY_SECUREFUND.SECUREFUND_CAT_ID',DE(''))#"
                                    option_value="SECUREFUND_CAT_ID"
                                    option_name="SECUREFUND_CAT"
                                    width="150">
                            </div>
                        </div>
                        <div class="form-group" id="item-GIVE_TAKE">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58488.Alınan'>/<cf_get_lang dictionary_id='58490.Verilen'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="GIVE_TAKE" id="GIVE_TAKE">
                                    <cfif isdefined("GET_COMPANY_SECUREFUND")>
                                        <option value="0"<cfif GET_COMPANY_SECUREFUND.GIVE_TAKE EQ 0> selected</cfif>><cf_get_lang dictionary_id='58488.Alınan'></option>
                                        <option value="1"<cfif GET_COMPANY_SECUREFUND.GIVE_TAKE EQ 1> selected</cfif>><cf_get_lang dictionary_id='58490.Verilen'></option>
                                        <option value="2"<cfif GET_COMPANY_SECUREFUND.GIVE_TAKE EQ 2> selected</cfif>><cf_get_lang dictionary_id='62327.iade edilmeyen'></option>
                                    <cfelse>
                                        <option value="0" selected><cf_get_lang dictionary_id='58488.Alınan'></option>
                                        <option value="1"><cf_get_lang dictionary_id='58490.Verilen'></option>
                                        <option value="2"><cf_get_lang dictionary_id='62327.iade edilmeyen'></option>
                                    </cfif>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-offer_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57545.Teklif'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfoutput>
                                        <cfif isdefined("GET_COMPANY_SECUREFUND") and len(GET_COMPANY_SECUREFUND.OFFER_ID)>
                                            <cfquery name="get_offer_name" datasource="#dsn3#">
                                                SELECT OFFER_ID,OFFER_HEAD FROM OFFER WHERE OFFER_ID =#GET_COMPANY_SECUREFUND.offer_id#
                                            </cfquery>
                                            
                                            <input type="hidden" name="offer_id" id="offer_id" value="#GET_COMPANY_SECUREFUND.offer_id#">
                                            <input type="text" name="offer_name" id="offer_name" value="#get_offer_name.offer_head#">
                                        <cfelse>
                                            <input type="hidden" name="offer_id" id="offer_id" value="">
                                            <input type="text" name="offer_name" id="offer_name" value="">
                                        </cfif>
                                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_offers&order_id=add_secure.offer_id&order_name=add_secure.offer_name');"></span>
                                    </cfoutput>
                                </div>
                            </div>
                        </div>                   
                        <div class="form-group" id="item-contract_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29522.Sozlesme'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfoutput>
                                        <cfif isdefined("attributes.contract_id") and len(attributes.contract_id)>
                                        <cfquery name="get_contract_head" datasource="#dsn3#">
                                                    SELECT CONTRACT_ID,CONTRACT_NO FROM RELATED_CONTRACT WHERE CONTRACT_ID =#attributes.contract_id#
                                        </cfquery>
                                            <input type="hidden" name="contract_id" id="contract_id" value="#attributes.CONTRACT_ID#">
                                            <input type="text" name="contract_head" id="contract_head" value="#get_contract_head.CONTRACT_NO#">
                                        <cfelse>
                                            <input type="hidden" name="contract_id" id="contract_id" value="">
                                            <input type="text" name="contract_head" id="contract_head" value="">
                                        </cfif>    
                                    </cfoutput>         
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&field_id=add_secure.contract_id&field_name=add_secure.contract_head'</cfoutput>);"></span>    
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-contract_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
                            <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="paper_number" maxlength="50" value="#paper_code & '-' & paper_number#">
                            </div>
                        </div>                   
                        <div class="form-group" id="item-action_value">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'> *</label>
                            <div class="col col-8 col-xs-12">
                            <cfif isdefined("GET_COMPANY_SECUREFUND")>
                                    <cfinput type="text" name="action_value" class="moneybox" value="#TLFORMAT(GET_COMPANY_SECUREFUND.ACTION_VALUE)#" onkeyup="return(FormatCurrency(this,event));" onBlur="doviz_hesapla();">
                                <cfelse>
                                    <cfinput type="text" name="action_value" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event));" onBlur="doviz_hesapla();">
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-action_value_2">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30635.Döviz Tutar'>*</label>
                            <div class="col col-8 col-xs-12">
                            <cfif isdefined("GET_COMPANY_SECUREFUND")>
                                    <cfinput type="text" name="action_value_2" class="moneybox" value="#TLFormat(GET_COMPANY_SECUREFUND.SECUREFUND_TOTAL)#" onkeyup="return(FormatCurrency(this,event));" onBlur="ytl_hesapla();">
                                <cfelse>	
                                    <cfinput type="text" name="action_value_2" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event));" onBlur="ytl_hesapla();">
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-6 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cfif isdefined("GET_COMPANY_SECUREFUND")>
                                    <cf_workcube_process_cat process_cat=#GET_COMPANY_SECUREFUND.ACTION_CAT_ID#>
                                <cfelse>
                                    <cf_workcube_process_cat slct_width="150">
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-taken_acc_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58789.Teminat Borç Hesabı'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif isdefined("GET_COMPANY_SECUREFUND")>
                                        <cfquery name="GET_ACC_1" datasource="#DSN2#">
                                            SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#GET_COMPANY_SECUREFUND.TAKEN_ACC_CODE#'
                                        </cfquery>
                                        <input type="hidden" name="taken_acc_id" id="taken_acc_id" value="<cfoutput>#GET_COMPANY_SECUREFUND.TAKEN_ACC_CODE#</cfoutput>">
                                        <input type="text" name="taken_acc_name" id="taken_acc_name" value="<cfif len(GET_COMPANY_SECUREFUND.TAKEN_ACC_CODE)><cfoutput>#GET_COMPANY_SECUREFUND.TAKEN_ACC_CODE# - #GET_ACC_1.ACCOUNT_NAME#</cfoutput></cfif>" onFocus="AutoComplete_Create('taken_acc_name','CODE_NAME','CODE_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','taken_acc_id','form','3','250');" autocomplete="off">
                                    <cfelse>
                                        <input type="hidden" name="taken_acc_id" id="taken_acc_id" value="">
                                        <input type="text" name="taken_acc_name" id="taken_acc_name" value="" onFocus="AutoComplete_Create('taken_acc_name','CODE_NAME','CODE_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','taken_acc_id','form','3','250');" autocomplete="off">
                                    </cfif>
                                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_secure.taken_acc_name&field_id=add_secure.taken_acc_id</cfoutput>&account_code='+document.add_secure.taken_acc_id.value)"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-given_acc_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58790.Teminat Alacak Hesabı'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif isdefined("GET_COMPANY_SECUREFUND")>
                                        <cfquery name="GET_ACC_2" datasource="#DSN2#">
                                            SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#GET_COMPANY_SECUREFUND.GIVEN_ACC_CODE#'
                                        </cfquery>
                                        <input type="hidden" name="given_acc_id" id="given_acc_id" value="<cfoutput>#GET_COMPANY_SECUREFUND.GIVEN_ACC_CODE#</cfoutput>">
                                        <input type="text" name="given_acc_name" id="given_acc_name" value="<cfif len(GET_COMPANY_SECUREFUND.GIVEN_ACC_CODE)><cfoutput>#GET_COMPANY_SECUREFUND.GIVEN_ACC_CODE# - #GET_ACC_2.ACCOUNT_NAME#</cfoutput></cfif>"  onFocus="AutoComplete_Create('given_acc_name','CODE_NAME','CODE_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','given_acc_id','form','3','250');" autocomplete="off">
                                    <cfelse>
                                        <input type="hidden" name="given_acc_id" id="given_acc_id" value="">
                                        <input type="text" name="given_acc_name" id="given_acc_name" value="" onFocus="AutoComplete_Create('given_acc_name','CODE_NAME','CODE_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','given_acc_id','form','3','250');" autocomplete="off">
                                    </cfif>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_secure.given_acc_name&field_id=add_secure.given_acc_id</cfoutput>&account_code='+document.add_secure.given_acc_id.value)"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-department">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61473.Sorumlu Departman'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="department_id" id="department_id" value="">
                                    <input type="text" name="department" id="department" value="">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=myhome.popup_list_departments&field_id=add_secure.department_id&field_name=add_secure.department</cfoutput>');"></span>              
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-START_DATE">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'>*</label>
                            <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57738.Başlama Tarihi Girmelisiniz'> !</cfsavecontent>
                                <cfif isdefined("GET_COMPANY_SECUREFUND")>
                                    <cfinput type="text" name="START_DATE" value="#dateformat(GET_COMPANY_SECUREFUND.START_DATE,dateformat_style)#" validate="#validate_style#" maxlength="10" required="Yes" message="#message#"> 
                                <cfelse>
                                    <cfinput value="" type="text" name="START_DATE" validate="#validate_style#" required="Yes" message="#message#" maxlength="10"> 
                                </cfif>
                                <span class="input-group-addon"><cf_wrk_date_image date_field="START_DATE"></span>
                            </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-FINISH_DATE">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'> *</label>
                            <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57739.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
                                <cfif isdefined("GET_COMPANY_SECUREFUND")>
                                    <cfinput type="text" name="FINISH_DATE" value="#dateformat(GET_COMPANY_SECUREFUND.FINISH_DATE,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" maxlength="10"> 
                                <cfelse>
                                    <cfinput value="" type="text" name="FINISH_DATE" validate="#validate_style#" required="Yes" message="#message#" maxlength="10"> 
                                </cfif>
                                <span class="input-group-addon"><cf_wrk_date_image date_field="FINISH_DATE"></span>
                            </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-project_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfoutput>
                                        <cfif isdefined("GET_COMPANY_SECUREFUND")>
                                            <input type="hidden" name="project_id" id="project_id" value="#GET_COMPANY_SECUREFUND.project_id#">
                                            <input type="text" name="project_head" id="project_head" value="<cfif len(GET_COMPANY_SECUREFUND.project_id)>#GET_PROJECT_NAME(GET_COMPANY_SECUREFUND.project_id)#</cfif>"  onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','add_secure','3','150')" autocomplete="off">
                                        <cfelse>
                                            <input type="hidden" name="project_id" id="project_id" value="">
                                            <input type="text" name="project_head" id="project_head" value="" onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','add_secure','3','150')" autocomplete="off">
                                        </cfif>
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_secure.project_id&project_head=add_secure.project_head');"></span>
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                        <cfif isdefined("GET_COMPANY_SECUREFUND") and len(GET_COMPANY_SECUREFUND.CREDIT_LIMIT)>
                            <cfquery name="GET_CREDIT_LIMIT" datasource="#dsn3#">
                                SELECT * FROM CREDIT_LIMIT WHERE CREDIT_LIMIT_ID = #GET_COMPANY_SECUREFUND.CREDIT_LIMIT#
                            </cfquery>
                        </cfif>
                        <div class="form-group" id="item-credit_limit_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58963.Kredi Limiti'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif isdefined("GET_CREDIT_LIMIT")>
                                        <input type="hidden" name="credit_limit_id" id="credit_limit_id" value="<cfoutput>#get_credit_limit.credit_limit_id#</cfoutput>">
                                        <cfinput type="text" name="credit_limit_name" id="credit_limit_name" value="#get_credit_limit.limit_head#">
                                    <cfelse>
                                        <input type="hidden" name="credit_limit_id" id="credit_limit_id" value="">
                                        <cfinput type="text" name="credit_limit_name" id="credit_limit_name" value="">
                                    </cfif>
                                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_credit_limit&credit_limit_id=add_secure.credit_limit_id&limit_head=add_secure.credit_limit_name','','ui-draggable-box-medium');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-REALESTATE_DETAIL">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <cfif isdefined("GET_COMPANY_SECUREFUND")>
                                    <textarea name="REALESTATE_DETAIL" id="REALESTATE_DETAIL"><cfoutput>#GET_COMPANY_SECUREFUND.REALESTATE_DETAIL#</cfoutput></textarea>
                                <cfelse>
                                    <textarea name="REALESTATE_DETAIL" id="REALESTATE_DETAIL"></textarea>
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-SECUREFUND_FILE">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'></label>
                            <div class="col col-8 col-xs-12">
                            <input type="file" name="SECUREFUND_FILE" id="SECUREFUND_FILE">
                            </div>
                        </div>
                        <div class="form-group" id="item-money_cat_expense">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <label><cf_get_lang dictionary_id='58930.Masraf'></label>
                            </div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfif isdefined("GET_COMPANY_SECUREFUND")>
                                        <input type="text" name="expense_total" id="expense_total" class="moneybox" validate="float" value="<cfif len(GET_COMPANY_SECUREFUND.EXPENSE_TOTAL) and (GET_COMPANY_SECUREFUND.EXPENSE_TOTAL neq 0)><cfoutput>#TLFormat(GET_COMPANY_SECUREFUND.EXPENSE_TOTAL)#</cfoutput></cfif>" onkeyup="return(FormatCurrency(this,event));">
                                        <span class="input-group-addon width">
                                        <select name="money_cat_expense" id="money_cat_expense">
                                            <cfoutput query="GET_MONEY">
                                                <option value="#money#"<cfif money is '#GET_COMPANY_SECUREFUND.money_cat_expense#'> selected</cfif>>#money#</option>
                                            </cfoutput>
                                        </select>
                                        </span>
                                    <cfelse>
                                        <input type="text" name="expense_total" class="moneybox" validate="float" value="" onkeyup="return(FormatCurrency(this,event));">
                                        <span class="input-group-addon width">
                                        <select name="money_cat_expense" id="money_cat_expense">
                                            <cfoutput query="GET_MONEY">
                                                <option value="#money#" <cfif session.ep.money eq money>selected</cfif>>#money#</option>
                                            </cfoutput>
                                        </select>
                                        </span>
                                    </cfif>	
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-commission_rate">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58791.Komisyon'>%</label>
                            <div class="col col-8 col-xs-12">
                                <cfif isdefined("GET_COMPANY_SECUREFUND")>
                                    <cfinput type="text" name="commission_rate" value="#TlFormat(get_company_securefund.commission_rate)#" class="moneybox" onkeyup="return(FormatCurrency(this,event,4));">
                                <cfelse>
                                    <cfinput type="text" name="commission_rate" value="#TlFormat(commission_rate,4)#" class="moneybox" onkeyup="return(FormatCurrency(this,event,4));">
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-6 col-sm-8 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-kur-ekle">
                            <div class="col col-12 scrollContent scroll-x2">
                                <label class="bold"><cf_get_lang dictionary_id ='30636.İşlem Para Birimi'></label>
                                <cfif session.ep.rate_valid eq 1>
                                    <cfset readonly_info = "yes">
                                <cfelse>
                                    <cfset readonly_info = "no">
                                </cfif>
                                <input type="hidden" name="kur_say" id="kur-say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
                                <cfif isdefined("GET_COMPANY_SECUREFUND")>
                                    <cfif len(get_company_securefund.money_cat)>
                                        <cfset selected_money=get_company_securefund.money_cat>
                                    <cfelse>
                                        <cfset selected_money=session.ep.money>
                                    </cfif>
                                    <table>
                                        <cfoutput query="get_money">
                                            <tr>
                                                <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
                                                <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                                                <td><input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onClick="doviz_hesapla();" <cfif selected_money eq money>checked</cfif>></td>
                                                <td>#money# #TLFormat(rate1,0)# /</td>
                                                <td><input type="text" <cfif readonly_info>readonly</cfif> class="box" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="doviz_hesapla();"></td>
                                            </tr>
                                        </cfoutput>
                                    </table>
                                <cfelse>
                                    <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
                                        <cfquery name="get_credit_all" datasource="#dsn#">
                                            SELECT MONEY FROM COMPANY_CREDIT WHERE COMPANY_ID = #attributes.company_id# AND OUR_COMPANY_ID = #session.ep.company_id#
                                        </cfquery>
                                    <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                                        <cfquery name="get_credit_all" datasource="#dsn#">
                                            SELECT MONEY FROM COMPANY_CREDIT WHERE CONSUMER_ID = #attributes.consumer_id# AND OUR_COMPANY_ID = #session.ep.company_id#
                                        </cfquery>
                                    </cfif>
                                    <cfif isdefined("get_credit_all") and get_credit_all.recordcount and len(get_credit_all.money)>
                                        <cfset selected_money=get_credit_all.money>
                                    <cfelseif len(session.ep.other_money)>
                                        <cfset selected_money=session.ep.other_money>
                                    <cfelse>
                                        <cfset selected_money=session.ep.money>
                                    </cfif>
                                    <table>
                                        <cfoutput query="get_money">
                                            <tr>
                                                <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
                                                <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                                                <td><input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onClick="doviz_hesapla();" <cfif selected_money eq money>checked</cfif>></td>
                                                <td>#money# #TLFormat(rate1,0)# /</td>
                                                <td><input type="text" <cfif readonly_info>readonly</cfif> class="box" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="doviz_hesapla();"></td>
                                            </tr>
                                        </cfoutput>
                                    </table>
                                </cfif>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons is_upd='0' add_function="kontrol()">
                </cf_box_footer>
            </cfform>
        </cf_box>
    </div>
    <script type="text/javascript">
        showDepartment(<cfoutput>#session.ep.company_id#</cfoutput>);
        function showDepartment(no)	
        {
            var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=finance.popup_ajax_list_departments&our_company_id="+no+"&submitted_branch=<cfoutput>#listlast(session.ep.user_location,'-')#</cfoutput><cfif session.ep.isBranchAuthorization>&deny_control=1</cfif>";
            AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Şubeler');
        }
        function doviz_hesapla()
        {
            toplam =eval("document.add_secure.action_value");
            toplam.value=filterNum(toplam.value);
            toplam=parseFloat(toplam.value);
            for(s=1;s<=add_secure.kur_say.value;s++)
            {
                if(document.add_secure.rd_money[s-1].checked == true)
                {
                    deger_diger_para = document.add_secure.rd_money[s-1];
                    form_value_rate2=eval("document.add_secure.txt_rate2_"+s);
                }
            }
            deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
            form_value_rate2.value = filterNum(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            if(toplam>0)
            {
                
                document.add_secure.action_value_2.value = commaSplit(toplam * parseFloat(deger_money_id_3)/(parseFloat(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')));
                document.add_secure.action_value.value=commaSplit(toplam);
            }
            else
            {
                document.add_secure.action_value_2.value =0;
                document.add_secure.action_value.value=0;
            }
            form_value_rate2.value = commaSplit(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'); 
            return true;
        }
        function ytl_hesapla()
        {
            toplam2 =eval("document.add_secure.action_value_2");
            toplam2.value=filterNum(toplam2.value);
            toplam2=parseFloat(toplam2.value);
            for(s=1;s<=add_secure.kur_say.value;s++)
            {
                if(document.add_secure.rd_money[s-1].checked == true)
                {
                    deger_diger_para = document.add_secure.rd_money[s-1];
                    form_value_rate2=eval("document.add_secure.txt_rate2_"+s);
                }
            }
            deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
            form_value_rate2.value = filterNum(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            if(toplam2>0)
            {
            document.add_secure.action_value.value = commaSplit(toplam2 * parseFloat(form_value_rate2.value,4)/(parseFloat(deger_money_id_3)));
            document.add_secure.action_value_2.value=commaSplit(toplam2);
            }
            else
            {
            document.add_secure.action_value.value =0;
            document.add_secure.action_value_2.value=0;
            }
            form_value_rate2.value = commaSplit(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            return true;
        }
        function kontrol()
        {
            if(document.add_secure.member.value =='' )
            {
                alert("<cf_get_lang dictionary_id='57715.Üye Seçiniz'> !");
                return false;
            }
            if(!chk_process_cat('add_secure')) return false;
            x = document.add_secure.SECUREFUND_CAT_ID.selectedIndex;
            if (document.add_secure.SECUREFUND_CAT_ID[x].value == "")
            { 
                alert ("<cf_get_lang dictionary_id='30452.Teminat Kategorisi'>!");
                return false;
            }
            if (document.add_secure.action_value.value == 0)
            { 
                alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='57673.Tutar'> !");
                return false;
            }
            if ( !date_check (document.getElementById('START_DATE'),document.getElementById('FINISH_DATE'),"<cf_get_lang_main dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
                {return false;}
                
            return true;
        }
        function get_branches()
        {
            for (i=document.getElementById("branch_id").options.length-1;i>-1;i--)
            {
                document.getElementById("branch_id").options.remove(i);
            }	
        
            var get_branch_name = wrk_query("SELECT BANK_BRANCH_ID,BANK_BRANCH_NAME FROM BANK_BRANCH WHERE BANK_ID = " + document.getElementById("bank_id").value+" ORDER BY BANK_BRANCH_NAME","dsn3");
        
            if(get_branch_name.recordcount > 0)
            {
                document.getElementById("branch_id").options.add(new Option('Seçiniz ', ''));
                for(i = 1;i<=get_branch_name.recordcount;++i)
                {
                    document.getElementById("branch_id").options.add(new Option(get_branch_name.BANK_BRANCH_NAME[i-1], get_branch_name.BANK_BRANCH_ID[i-1]));
                }
            }
        }
    </script>
    
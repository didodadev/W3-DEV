<!--- teminat tabloları crm ekranlarnda da kullanılıyor ama sayfalar ortaklaştırılmadı şimdilik,ayrı özellikleri var--->
<cf_get_lang_set module_name="member">
<cfset refmodule="#listgetat(attributes.fuseaction,1,'.')#">
<cfquery name="GET_MONEY_RATE" datasource="#dsn2#">
    SELECT * FROM SETUP_MONEY WHERE MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_MONEY" datasource="#dsn#">
    SELECT * FROM COMPANY_SECUREFUND_MONEY WHERE ACTION_ID = #ATTRIBUTES.SECUREFUND_ID# ORDER BY MONEY_TYPE
</cfquery>
<cfif GET_MONEY.recordcount eq 0>
    <cfquery name="GET_MONEY" datasource="#dsn2#">
        SELECT MONEY AS MONEY_TYPE,* FROM SETUP_MONEY WHERE MONEY_STATUS=1
    </cfquery>
</cfif>
<cfquery name="GET_OUR_COMPANIES" datasource="#dsn#">
    SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
</cfquery>
<cfquery name="GET_BANKS_NAME" datasource="#DSN3#">
    SELECT DISTINCT BANK_ID,BANK_NAME FROM BANK_BRANCH WHERE BANK_ID IS NOT NULL ORDER BY BANK_NAME
</cfquery>  
<cfquery name="GET_COMPANY_SECUREFUND" datasource="#DSN#">
    SELECT
        CS.*,
        D.DEPARTMENT_HEAD
    FROM
        COMPANY_SECUREFUND CS
        LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = CS.DEPARTMENT_ID
    WHERE
        SECUREFUND_ID = #ATTRIBUTES.SECUREFUND_ID#
</cfquery>

<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform name="add_secure" method="post" action="#request.self#?fuseaction=member.emptypopup_upd_securefund" enctype="multipart/form-data">
            <input type="hidden" name="securefund_id" id="securefund_id" value="<cfoutput>#ATTRIBUTES.SECUREFUND_ID#</cfoutput>">
            <input type="hidden" name="action_period_id" id="action_period_id" value="<cfoutput>#GET_COMPANY_SECUREFUND.ACTION_PERIOD_ID#</cfoutput>">
            <cf_box_elements>
                <div class="col col-4 col-md-5 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-SECUREFUND_STATUS">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="checkbox" name="SECUREFUND_STATUS" id="SECUREFUND_STATUS" value="1"<cfif GET_COMPANY_SECUREFUND.SECUREFUND_STATUS eq 1>checked</cfif>><cfif len(get_company_securefund.return_process_cat)>&nbsp;&nbsp;&nbsp;(<cfif GET_COMPANY_SECUREFUND.GIVE_TAKE EQ 1><cf_get_lang dictionary_id='58488.alınan'><cfelseif GET_COMPANY_SECUREFUND.GIVE_TAKE EQ 2><cf_get_lang dictionary_id='62327.iade edilmeyen'><cfelse><cf_get_lang dictionary_id='58490.verilen'></cfif>)</cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-member_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57658.Üye'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                            <cfoutput>
                                <cfset acc_type_id = 0>
                                <cfset company_id = GET_COMPANY_SECUREFUND.company_id>
                                <cfset consumer_id = GET_COMPANY_SECUREFUND.consumer_id>
                                <cfif len(GET_COMPANY_SECUREFUND.ACCOUNT_TYPE_ID)>
                                    <cfset acc_type_id = GET_COMPANY_SECUREFUND.ACCOUNT_TYPE_ID>
                                    <cfif len(GET_COMPANY_SECUREFUND.company_id)>
                                        <cfset company_id = company_id & '_' & acc_type_id>
                                    <cfelseif len(GET_COMPANY_SECUREFUND.consumer_id)>
                                        <cfset consumer_id = consumer_id & '_' & acc_type_id>
                                    </cfif>
                                </cfif>
                                <input type="hidden" name="company_id" id="company_id" value="#company_id#">
                                <input type="hidden" name="consumer_id" id="consumer_id" value="#consumer_id#">
                                <cfif len(GET_COMPANY_SECUREFUND.company_id)>
                                    <input type="text" name="company" id="company" value="#get_par_info(GET_COMPANY_SECUREFUND.company_id,1,0,0,acc_type_id)#" readonly>
                                <cfelseif len(GET_COMPANY_SECUREFUND.consumer_id)>
                                    <input type="text" name="company" id="company" value="#get_cons_info(GET_COMPANY_SECUREFUND.consumer_id,0,0,acc_type_id)#" readonly>
                                </cfif>
                                <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_all_pars&is_multi_act=1&field_comp_id=add_secure.company_id&field_name=add_secure.company&field_consumer=add_secure.consumer_id&select_list=2,3');"></span>    
                            </cfoutput>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-our_company_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30451.Şirketimiz'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="our_company_id" id="our_company_id" onchange="showDepartment(this.value)">
                                <cfoutput query="get_our_companies">
                                <option value="#COMP_ID#"<cfif comp_id eq GET_COMPANY_SECUREFUND.OUR_COMPANY_ID> selected</cfif>>#company_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-DEPARTMENT_PLACE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30127.Şubemiz'></label>
                        <div class="col col-8 col-xs-12">
                            <div width="310" id="DEPARTMENT_PLACE"> </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-bank_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57521.Banka'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="bank_id" id="bank_id" onchange="get_branches();">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif len(GET_COMPANY_SECUREFUND.BANK_BRANCH_ID)>
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
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Sube'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="branch_id" id="branch_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif len(GET_COMPANY_SECUREFUND.BANK_BRANCH_ID)>
                                    <cfquery name="get_bank_branch_" datasource="#dsn3#">
                                        SELECT BANK_BRANCH_ID,BANK_BRANCH_NAME FROM BANK_BRANCH WHERE BANK_ID = #get_bank_.BANK_ID#
                                    </cfquery>
                                    <cfoutput query="get_bank_branch_">
                                        <option value="#bank_branch_id#"<cfif bank_branch_id eq GET_COMPANY_SECUREFUND.BANK_BRANCH_ID>selected</cfif>>#bank_branch_name#</option>
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
                            value="#GET_COMPANY_SECUREFUND.SECUREFUND_CAT_ID#"
                            option_value="SECUREFUND_CAT_ID"
                            option_name="SECUREFUND_CAT"
                            width="150">
                        </div>
                    </div>
                    <div class="form-group" id="item-GIVE_TAKE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58488.Alınan'>/<cf_get_lang dictionary_id='58490.Verilen'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="GIVE_TAKE" id="GIVE_TAKE">
                                <option value="0"<cfif GET_COMPANY_SECUREFUND.GIVE_TAKE EQ 0> selected</cfif>><cf_get_lang dictionary_id='58488.Alınan'></option>
                                <option value="1"<cfif GET_COMPANY_SECUREFUND.GIVE_TAKE EQ 1> selected</cfif>><cf_get_lang dictionary_id='58490.Verilen'></option>
                                <option value="2"<cfif GET_COMPANY_SECUREFUND.GIVE_TAKE EQ 2> selected</cfif>><cf_get_lang dictionary_id='62327.iade edilmeyen'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-offer_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57545.Teklif'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                <input type="hidden" name="offer_id" id="offer_id" value="<cfoutput>#GET_COMPANY_SECUREFUND.offer_id#</cfoutput>">
                                <cfif len(GET_COMPANY_SECUREFUND.offer_id)>
                                    <cfquery name="get_offer_name" datasource="#dsn3#">
                                        SELECT OFFER_ID,OFFER_HEAD FROM OFFER WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMPANY_SECUREFUND.offer_id#">
                                    </cfquery>
                                </cfif>
                                <input type="text" name="offer_name" id="offer_name" value="<cfif len(GET_COMPANY_SECUREFUND.offer_id)><cfoutput>#get_offer_name.offer_head#</cfoutput></cfif>">
                                <span class="input-group-addon icon-ellipsis"  onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_offers&order_id=add_secure.offer_id&order_name=add_secure.offer_name');"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-contract_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29522.Sozlesme'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="contract_id" id="contract_id" value="<cfoutput>#GET_COMPANY_SECUREFUND.contract_id#</cfoutput>">
                                <cfif len(GET_COMPANY_SECUREFUND.contract_id)>
                                    <cfquery name="get_contract_head" datasource="#dsn3#">
                                        SELECT CONTRACT_ID,CONTRACT_HEAD FROM RELATED_CONTRACT WHERE CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMPANY_SECUREFUND.contract_id#">
                                    </cfquery>
                                </cfif>
                                <input type="text" name="contract_head" id="contract_head" value="<cfif len(GET_COMPANY_SECUREFUND.contract_id)><cfoutput>#get_contract_head.contract_head#</cfoutput></cfif>">
                                <span class="input-group-addon icon-ellipsis"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&field_id=add_secure.contract_id&field_name=add_secure.contract_head'</cfoutput>);"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-paper_number">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.belge no'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="paper_number" id="paper_number" value="<cfoutput>#GET_COMPANY_SECUREFUND.paper_no#</cfoutput>">
                        </div>
                    </div>                    
                    <div class="form-group" id="item-action_value">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="action_value" class="moneybox" value="#TLFORMAT(GET_COMPANY_SECUREFUND.ACTION_VALUE)#"  onkeyup="return(FormatCurrency(this,event));" onBlur="doviz_hesapla();">
                        </div>
                    </div>
                    <div class="form-group" id="item-FINISH_DATE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30635.Döviz Tutar'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="action_value_2" class="moneybox" value="#TLFormat(GET_COMPANY_SECUREFUND.SECUREFUND_TOTAL)#"  onkeyup="return(FormatCurrency(this,event));" onBlur="ytl_hesapla();">
                        </div>
                    </div>
                    <div class="form-group" id="item-cf_wrk_add_info">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57810.Ek Bilgi'></label>
                        <div class="col col-8 col-xs-12"> 
                            <cf_wrk_add_info info_type_id="-27" info_id="#attributes.securefund_id#" upd_page = "1"> 
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-5 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-SECUREFUND_STATUS">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process_cat process_cat=#GET_COMPANY_SECUREFUND.ACTION_CAT_ID#>
                        </div>
                    </div>
                    <div class="form-group" id="item-taken_acc_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58789.Teminat Borç Hesabı'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfquery name="GET_ACC_1" datasource="#DSN2#">
                                    SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#GET_COMPANY_SECUREFUND.TAKEN_ACC_CODE#'
                                </cfquery>
                                <input type="hidden" name="taken_acc_id" id="taken_acc_id" value="<cfoutput>#GET_COMPANY_SECUREFUND.TAKEN_ACC_CODE#</cfoutput>">
                                <input type="text" name="taken_acc_name" id="taken_acc_name" value="<cfif len(GET_COMPANY_SECUREFUND.TAKEN_ACC_CODE)><cfoutput>#GET_COMPANY_SECUREFUND.TAKEN_ACC_CODE# - #GET_ACC_1.ACCOUNT_NAME#</cfoutput></cfif>" onFocus="AutoComplete_Create('taken_acc_name','CODE_NAME','CODE_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','taken_acc_id','form','3','250');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_secure.taken_acc_name&field_id=add_secure.taken_acc_id</cfoutput>&account_code='+document.add_secure.taken_acc_id.value)"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-given_acc_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58790.Teminat Alacak Hesabı'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfquery name="GET_ACC_2" datasource="#DSN2#">
                                    SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#GET_COMPANY_SECUREFUND.GIVEN_ACC_CODE#'
                                </cfquery>
                                <input type="hidden" name="given_acc_id" id="given_acc_id" value="<cfoutput>#GET_COMPANY_SECUREFUND.GIVEN_ACC_CODE#</cfoutput>">
                                <input type="text" name="given_acc_name" id="given_acc_name" value="<cfif len(GET_COMPANY_SECUREFUND.GIVEN_ACC_CODE)><cfoutput>#GET_COMPANY_SECUREFUND.GIVEN_ACC_CODE# - #GET_ACC_2.ACCOUNT_NAME#</cfoutput></cfif>" onFocus="AutoComplete_Create('given_acc_name','CODE_NAME','CODE_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','given_acc_id','form','3','250');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_secure.given_acc_name&field_id=add_secure.given_acc_id</cfoutput>&account_code='+document.add_secure.given_acc_id.value)"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-department">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61473.Sorumlu Departman'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#GET_COMPANY_SECUREFUND.DEPARTMENT_ID#</cfoutput>">
                                <input type="text" name="department" id="department" value="<cfoutput>#GET_COMPANY_SECUREFUND.DEPARTMENT_HEAD#</cfoutput>">
                                <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=myhome.popup_list_departments&field_id=add_secure.department_id&field_name=add_secure.department</cfoutput>');"></span>              
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-START_DATE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57655.Başlama Tarihi'>!</cfsavecontent>
                            <cfinput value="#dateformat(GET_COMPANY_SECUREFUND.START_DATE,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" type="text" name="START_DATE">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="START_DATE"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-FINISH_DATE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi!'></cfsavecontent>
                            <cfinput value="#dateformat(GET_COMPANY_SECUREFUND.FINISH_DATE,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" type="text" name="FINISH_DATE">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="FINISH_DATE"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-project_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                <input type="hidden" name="project_id" id="project_id" value="#GET_COMPANY_SECUREFUND.project_id#">
                                <input type="text" name="project_head" id="project_head" value="<cfif len(GET_COMPANY_SECUREFUND.project_id)>#GET_PROJECT_NAME(GET_COMPANY_SECUREFUND.project_id)#</cfif>"  onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','add_secure','3','150')" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis"  onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_secure.project_id&project_head=add_secure.project_head');"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                    <cfif len(GET_COMPANY_SECUREFUND.CREDIT_LIMIT)>
                        <cfquery name="GET_CREDIT_LIMIT" datasource="#dsn3#">
                            SELECT * FROM CREDIT_LIMIT WHERE CREDIT_LIMIT_ID = #GET_COMPANY_SECUREFUND.CREDIT_LIMIT#
                        </cfquery>
                    </cfif>
                    <div class="form-group" id="item-credit_limit_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58963.Kredi Limiti'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="credit_limit_id" id="credit_limit_id" value="<cfif isdefined("get_credit_limit")><cfoutput>#get_credit_limit.credit_limit_id#</cfoutput></cfif>">
                                <cfif isdefined("get_credit_limit")>
                                    <cfinput type="text" name="credit_limit_name" id="credit_limit_name" value="#get_credit_limit.limit_head#">
                                <cfelse>
                                    <cfinput type="text" name="credit_limit_name" id="credit_limit_name" value="">
                                </cfif>
                                <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_credit_limit&credit_limit_id=add_secure.credit_limit_id&limit_head=add_secure.credit_limit_name','','ui-draggable-box-medium');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-REALESTATE_DETAIL">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="REALESTATE_DETAIL" id="REALESTATE_DETAIL"><cfoutput>#GET_COMPANY_SECUREFUND.REALESTATE_DETAIL#</cfoutput></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-OLDSECUREFUND_FILE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input  type="hidden" name="OLDSECUREFUND_FILE" id="OLDSECUREFUND_FILE" value="#GET_COMPANY_SECUREFUND.SECUREFUND_FILE#">
                                    <input  type="hidden" name="OLDSECUREFUND_FILE_SERVER_ID" id="OLDSECUREFUND_FILE_SERVER_ID" value="#GET_COMPANY_SECUREFUND.SECUREFUND_FILE_SERVER_ID#">
                                    <cfif Len(GET_COMPANY_SECUREFUND.SECUREFUND_FILE)>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#file_web_path#member/#GET_COMPANY_SECUREFUND.SECUREFUND_FILE#','list')">#GET_COMPANY_SECUREFUND.SECUREFUND_FILE#></span>
                                    <cfelse>
                                    <cf_get_lang dictionary_id='58546.yok'>
                                    </cfif>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-SECUREFUND_FILE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30456.Yeni Belge'></label>
                        <div class="col col-8 col-xs-12">
                            <input  type="file" name="SECUREFUND_FILE" id="SECUREFUND_FILE">
                        </div>
                    </div>
                    <div class="form-group" id="item-expense_total">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58930.Masraf'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="expense_total" id="expense_total" class="moneybox" validate="float" value="<cfif len(GET_COMPANY_SECUREFUND.EXPENSE_TOTAL) and (GET_COMPANY_SECUREFUND.EXPENSE_TOTAL neq 0)><cfoutput>#TLFormat(GET_COMPANY_SECUREFUND.EXPENSE_TOTAL)#</cfoutput></cfif>" onkeyup="return(FormatCurrency(this,event));">
                                <span class="input-group-addon width">
                                    <select name="money_cat_expense" id="money_cat_expense">
                                        <cfoutput query="GET_MONEY_RATE">
                                            <option value="#money#"<cfif money is '#GET_COMPANY_SECUREFUND.money_cat_expense#'> selected</cfif>>#money#</option>
                                        </cfoutput>
                                    </select>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-commission_rate">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58791.Komisyon'>%</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="commission_rate" value="#TlFormat(get_company_securefund.commission_rate,4)#" class="moneybox" passThrough="onkeyup=""return(FormatCurrency(this,event,4));""">
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-5 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-get_money">
                        <div class="col col-12 scrollContent scroll-x2">
                            <label class="col col-12 col-xs-12 bold"><cf_get_lang dictionary_id ='30636.İşlem Para Birimi'></label>
                            <input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
                            <cfif len(get_company_securefund.money_cat)>
                                <cfset selected_money=get_company_securefund.money_cat>
                            <cfelse>
                                <cfset selected_money=session.ep.money>
                            </cfif>
                            <cfif session.ep.rate_valid eq 1>
                                <cfset readonly_info = "yes">
                            <cfelse>
                                <cfset readonly_info = "no">
                            </cfif>
                            <table>
                                <cfoutput query="get_money">
                                    <tr>
                                        <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money_type#">
                                        <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                                        <td><input type="radio" name="rd_money" id="rd_money" value="#money_type#,#currentrow#,#rate1#,#rate2#" onClick="doviz_hesapla();" <cfif selected_money eq money_type>checked</cfif>></td>
                                        <td>#money_type# #TLFormat(rate1,0)# /</td>
                                        <td><input type="text" <cfif readonly_info>readonly</cfif> class="box" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="doviz_hesapla();"></td>
                                    </tr>
                                </cfoutput>
                            </table>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6">
                    <cf_record_info query_name="GET_COMPANY_SECUREFUND">
                </div>
                <div class="col col-6">
                <cfif not len(get_company_securefund.return_process_cat)>
                    <cf_workcube_buttons is_upd='1' 
                        delete_page_url = '#request.self#?fuseaction=member.emptypopup_del_securefund&oldsecurefund_file=#GET_COMPANY_SECUREFUND.SECUREFUND_FILE#&oldsecurefund_file_server_id=#GET_COMPANY_SECUREFUND.SECUREFUND_FILE_SERVER_ID#&securefund_id=#ATTRIBUTES.SECUREFUND_ID#&active_period=#GET_COMPANY_SECUREFUND.ACTION_PERIOD_ID#&old_process_type=#GET_COMPANY_SECUREFUND.action_type_id#' 
                        add_function="kontrol()">
                <cfelse>
                        <font color="FF0000"><cf_get_lang dictionary_id='59910.İade İşlemi Yapıldığı İçin Güncelleme Yapamazsınız'> !</font>&nbsp;
                </cfif>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','Süre Uzatımı',62379)#" add_href="openBoxDraggable('#request.self#?fuseaction=finance.securefund_extension_of_time&event=add&securefund_id=#attributes.securefund_id#')">
        <cfscript>
            extension_time = createObject("component","V16.member.cfc.securefund_extension_time");
            extension_time.dsn = dsn;
            get_securefund_extension_time = extension_time.get_securefund_extension_time(securefund_id : attributes.securefund_id);
            if (len(get_securefund_extension_time.action_cat_id))
                get_process_cat = extension_time.get_process_cat(action_cat_id : get_securefund_extension_time.action_cat_id);
        </cfscript>
        <cf_grid_list>
            <thead>
                <th><cf_get_lang dictionary_id='61806.İşlem Tipi'></th>
                <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                <th><cf_get_lang dictionary_id='62379.Süre Uzatımı'>-<cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></th>
                <th><cf_get_lang dictionary_id='58930.Masraf'></th>
                <th><cf_get_lang dictionary_id='58930.Masraf'><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                <th><cf_get_lang dictionary_id ='58791.Komisyon'></th>
                <th><cf_get_lang dictionary_id='58586.İşlem Yapan'></th>
                <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                <th width="25" class="text-center"><i class="fa fa-pencil"></i></th>
            </thead>
            <cfif get_securefund_extension_time.recordCount>
                <cfoutput query="get_securefund_extension_time">
                    <tbody>
                        <td>#get_process_cat.process_cat#</td>
                        <td>#detail#</td>
                        <td>#dateformat(extension_time_finish_date,dateformat_style)#</td>
                        <td class="moneybox">#TLformat(expense_total,session.ep.our_company_info.rate_round_num)#</td>
                        <td>#money_cat_expense#</td>
                        <td class="moneybox">#TLformat(commission_rate)#</td>
                        <td>#get_emp_info(record_emp,0,0)#</td>
                        <td>#money_cat#</td>
                        <td><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=finance.securefund_extension_of_time&event=upd&extension_securefund_id=#securefund_extension_time_id#&securefund_id=#attributes.securefund_id#&give_take=#get_company_securefund.give_take#</cfoutput>')"><i class="fa fa-pencil"></i></a></td>
                    </tbody>
                </cfoutput>
                <cfelse>
                    <tbody><td colspan="10"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td></tbody>
                </cfif>
        </cf_grid_list>
    </cf_box>
</div>
<script type="text/javascript">
    showDepartment(<cfoutput>#session.ep.company_id#</cfoutput>);
    function showDepartment(no)	
    {
        var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=finance.popup_ajax_list_departments&our_company_id="+no+"<cfif len(GET_COMPANY_SECUREFUND.OURCOMP_BRANCH)>&submitted_branch=<cfoutput>#GET_COMPANY_SECUREFUND.OURCOMP_BRANCH#</cfoutput></cfif><cfif session.ep.isBranchAuthorization>&deny_control=1</cfif>";
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
        document.add_secure.action_value.value = commaSplit(toplam2 * parseFloat(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/(parseFloat(deger_money_id_3)));
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
        if(!chk_process_cat('add_secure')) return false;
        x = document.add_secure.SECUREFUND_CAT_ID.selectedIndex;
        if (document.add_secure.SECUREFUND_CAT_ID[x].value == "")
        { 
            alert ("<cf_get_lang dictionary_id='30452.Teminat Kategorisi'>!");
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

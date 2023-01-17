<!---
    File: setup_upd_rule_set.cfm
    Author: Gramoni-Mahmut <mahmut.cifci@gramoni.com>
    Date: 29.07.2018
    Controller: WodibaSetupRuleSetsController.cfm
    Description:
		
--->
<cfquery name="GET_RULE_SET" datasource="#dsn#">
    Select * from WODIBA_RULE_SETS where RULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#" />
</cfquery>

<cfparam name="attributes.process_start_date" default="" />

<cfif Not isDefined('attributes.process_start_date')>
    <cfset attributes.process_start_date = '' />
<cfelse>
    <cfset attributes.process_start_date = dateFormat(attributes.process_start_date,dateformat_style) />
</cfif>
<cfset attributes.is_virman = ''/>
<cfif isdefined("attributes.is_form_submitted")>
    <cfset attributes.is_virman=GET_RULE_SET.PROCESS_TYPE />
    <cfquery datasource="#dsn#">
        UPDATE
            WODIBA_RULE_SETS
        SET
        <cfif attributes.is_virman eq 23>
            PROCESS_DATE_RANGE = <cfif len(attributes.process_date_range)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_date_range#" /><cfelse>NULL</cfif>,
            IS_DIFF_BRANCH = <cfif isDefined("attributes.is_difference_branch")>1<cfelse>0</cfif>,
            DIFF_BRANCH_PROCESS_CAT_ID = <cfif len(attributes.diff_branch_process_cat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.diff_branch_process_cat_id#" /><cfelse>NULL</cfif>,
        <cfelseif attributes.is_virman eq 24 or attributes.is_virman eq 25>
            MATCH_COMPANY_BY_INVOICE_NUMBER = <cfif isDefined("attributes.match_company_by_invoice_number")>1<cfelse>0</cfif>,
            IS_PROCESS_INVOICE_CLOSING = <cfif isDefined("attributes.is_process_invoice_closing")>1<cfelse>0</cfif>,
            INVOICE_CLOSING_PAYMENT_TOLERANS_VALUE = <cfif len("attributes.invoice_closing_payment_tolerans_value")>#attributes.invoice_closing_payment_tolerans_value#<cfelse>0</cfif>,
        </cfif>
            PROCESS_CAT_ID      = <cfif len(attributes.rule_set_id)>#attributes.rule_set_id#<cfelse>NULL</cfif>,
            PROCESS_START_DATE  = <cfif len(attributes.process_start_date)><cfqueryparam cfsqltype="cf_sql_date" value="#attributes.process_start_date#" /><cfelse>NULL</cfif>
        WHERE
            RULE_ID     = #attributes.id# AND
            COMPANY_ID  = #session.ep.company_id#
    </cfquery>
    <script>alert('<cf_get_lang_main no='1927.Güncellendi'>');</script>
    <cfquery name="GET_RULE_SET" datasource="#dsn#">
        SELECT * FROM WODIBA_RULE_SETS WHERE RULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#" />
    </cfquery>
</cfif>

<cfquery name="GET_RULE_SET" datasource="#dsn#">
    SELECT * FROM WODIBA_RULE_SETS WHERE RULE_ID = #attributes.id#
</cfquery>

<cfquery name="GET_PROCESS_CAT" datasource="#dsn3#">
    SELECT PROCESS_CAT, PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = #GET_RULE_SET.PROCESS_TYPE# ORDER BY PROCESS_CAT
</cfquery>

<cfquery name="GET_RULE_SET_ROWS" datasource="#dsn#">
    SELECT * FROM WODIBA_RULE_SET_ROWS WHERE RULE_ID = #attributes.id#
</cfquery>

<cfset module_name = 'bank' />

<cf_catalystHeader>
 <cfform action="#request.self#?fuseaction=settings.wodiba_bank_rule_set_definitions&event=upd&id=#attributes.id#" method="post">
    <input name="is_form_submitted" id="is_form_submitted" value="1" type="hidden">
    <cf_box>
    <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1">
                        <div class="form-group">
                            <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='51337'></label>
                            <div class="col col-12 col-md-12 col-xs-12">
                                <select name="rule_set_id" id="rule_set_id" style="width:100px;">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfloop query="GET_PROCESS_CAT"><cfoutput>
                                        <option value="#PROCESS_CAT_ID#" <cfif GET_RULE_SET.PROCESS_CAT_ID eq PROCESS_CAT_ID>selected</cfif>><cfoutput>#PROCESS_CAT# (#PROCESS_CAT_ID#)</cfoutput></option> 
                                        </cfoutput>
                                    </cfloop>
                                </select>
                            </div>	
                        </div>
                        <div class="form-group">
                            <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='49901.Kayıt Başlangıç Tarihi'></label>
                            <div class="col col-12 col-md-12 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Değerlerini Kontrol ediniz'></cfsavecontent>
                                    <cfinput type="text" maxlength="10" name="process_start_date" value="#dateformat(GET_RULE_SET.PROCESS_START_DATE,dateformat_style)#" style="width:65px" validate="#validate_style#" message="#message#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="process_start_date"></span>
                                </div>
                            </div>	
                        </div>
                    </div>
                    <cfif GET_RULE_SET.PROCESS_TYPE eq 23>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2">
                            <div class="form-group">
                                <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='61226.Virman İşlem Tarih Aralığı (Gün)'></label>
                                    <select name="process_date_range" id="process_date_range" style="width:100px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfloop index="i" from="1" to="10">
                                            <cfoutput>
                                            <option value="#i#" <cfif GET_RULE_SET.PROCESS_DATE_RANGE eq i>selected</cfif>><cfoutput>#i#</cfoutput></option> 
                                            </cfoutput>
                                        </cfloop>
                                    </select>
                            </div>
                            <div class="form-group">
                                <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='61264.Farklı Şube İşlem Kategorisi'></label>
                                <div class="input-group">
                                    <span class="input-group-addon">
                                        <input type="checkbox" name="is_difference_branch" id="is_difference_branch" value="1" <cfif GET_RULE_SET.IS_DIFF_BRANCH eq 1>checked</cfif>>
                                    </span>
                                    <select name="diff_branch_process_cat_id" id="diff_branch_process_cat_id" style="width:50px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfloop query="GET_PROCESS_CAT">
                                            <cfoutput>
                                                <option value="#PROCESS_CAT_ID#" <cfif GET_RULE_SET.DIFF_BRANCH_PROCESS_CAT_ID eq PROCESS_CAT_ID>selected</cfif>><cfoutput>#PROCESS_CAT#(#PROCESS_CAT_ID#)</cfoutput></option>  
                                            </cfoutput>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <cfif GET_RULE_SET.PROCESS_TYPE eq 24 || GET_RULE_SET.PROCESS_TYPE eq 25>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3">
                            <div class="form-group">
                                <div class="input-group">
                                    <label for="match_company_by_invoice_number"><cf_get_lang dictionary_id='63958.Fatura Numarasına Göre Cari Eşleme Yapılsın'></label>
                                    <input type="checkbox" name="match_company_by_invoice_number" id="match_company_by_invoice_number" value="1" <cfif GET_RULE_SET.MATCH_COMPANY_BY_INVOICE_NUMBER eq 1>checked</cfif>>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="input-group">
                                    <label for="is_process_invoice_closing"><cf_get_lang dictionary_id='63982.Fatura Kapama İşlemi Yapılsın'></label>
                                    <input type="checkbox" onclick="toleranceFunction()" name="is_process_invoice_closing" id="is_process_invoice_closing" value="1" <cfif GET_RULE_SET.IS_PROCESS_INVOICE_CLOSING eq 1>checked</cfif>>
                                </div>
                            </div>
                            <div class="form-group">
                                <div id="tolerance">
                                    <label for="invoice_closing_payment_tolerans_value"><cf_get_lang dictionary_id='29443.Tolerans'>(min: 0 - max: 5)</label>
                                    <input type="number" min="0" max="5" placeholder="1.0" step="0.01" width="5px" name="invoice_closing_payment_tolerans_value" id="invoice_closing_payment_tolerans_value" value="<cfoutput>#GET_RULE_SET.INVOICE_CLOSING_PAYMENT_TOLERANS_VALUE#</cfoutput>">
                                </div>
                            </div>
                        </div>
                    </cfif>
                </div>
                <div class="row formContentFooter">
                    <input type="submit" value="<cf_get_lang_main no='52.Güncelle'>">	
                </div>
            </div>
        </div>
    </div>
</cf_box>
<cf_box uidrop="1" hide_table_column="1" woc_setting = "#{ checkbox_name : 'print_hr_id', print_type : 173 }#">
    <cf_grid_list>
			<table class="workDevList">
                <thead>
                    <tr>
                        <th colspan="7" style="text-align:center;">Girdi</th>
                        <th colspan="11" style="text-align:center;">Çıktı</th>
                    </tr>
					<tr>
						<th><a href="javascript:openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.wodiba_bank_rule_set_definitions&event=add&id=<cfoutput>#attributes.id#</cfoutput>','','ui-draggable-box-medium');"><img src="/images/plus_list.gif" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></a></th>
                        <th><cf_get_lang_main dictionary_id='51290.Kural tanımı'></th>
                        <th><cf_get_lang_main no='1652.Banka Hesabı'></th>
						<th><cf_get_lang no='225.İşlem Kodu'></th>
                        <th><cf_get_lang_main no='142.Giriş'>/<cf_get_lang_main no='19.Çıkış'></th>
						<th>IBAN</th>
						<th>VKN</th>
						<th><cf_get_lang_main no='217.Açıklama'></th>
                        <th><cf_get_lang_main no='388.İşlem Tipi'></th>
                        <th><cf_get_lang_main no='1048.Masraf merkezi'></th>
                        <th><cf_get_lang_main no='822.Bütçe kalemi'></th>
                        <th><cf_get_lang_main no='4.Proje'></th>
                        <th><cf_get_lang_main no='107.Cari hesap'></th>
                        <th><cf_get_lang_main no='1104.Ödeme yöntemi'></th>
                        <th><cf_get_lang_main no='2774.Tahsilat Ödeme Tipi'></th>
                        <th><cf_get_lang_main no='1421.Fiziki varlık'></th>
                        <th><cf_get_lang_main no='41.Şube'></th>
                        <th><cf_get_lang_main no='160.Departman'></th>
					</tr>
				</thead>
                <tbody>
                    <cfif GET_RULE_SET_ROWS.recordCount>
                    <cfoutput query="GET_RULE_SET_ROWS">
                    <tr>
                        <td><a href="javascript:openBoxDraggable('#request.self#?fuseaction=settings.wodiba_bank_rule_set_definitions&event=row&id=#attributes.id#&row_id=#RULE_SET_ROW_ID#','','ui-draggable-box-medium');"><img src="/images/update_list.gif" alt="<cf_get_lang_main no='52.Güncelle'>" title="<cf_get_lang_main no='52.Güncelle'>"></a></td>
                        <td>#RULE_SET_ROW_NAME#</td>
                        <cfquery name="get_account" datasource="#dsn3#">
                            SELECT ACCOUNT_NAME FROM ACCOUNTS WHERE ACCOUNT_ID = #ACCOUNT_ID#
                        </cfquery>
                        <td>#get_account.ACCOUNT_NAME#</td>
                        <td>#TRANSACTION_CODE#</td>
                        <td><cfif IN_OUT Eq 'IN'><cf_get_lang_main no='142.Giriş'><cfelseif IN_OUT Eq 'OUT'><cf_get_lang_main no='19.Çıkış'></cfif></td>
                        <td>#IBAN#</td>
                        <td>#VKN#</td>
                        <td>#DESCRIPTION#</td>
                        <cfif Len(PROCESS_CAT_ID)>
                        <cfquery name="get_process_cat" datasource="#dsn3#">
                            SELECT PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #PROCESS_CAT_ID#
                        </cfquery>
                        <cfset process_cat_name = get_process_cat.PROCESS_CAT />
                        <cfelse>
                        <cfset process_cat_name = "" />
                        </cfif>
                        <td>#process_cat_name#</td>
                        <cfif Len(EXPENSE_CENTER_ID)>
                        <cfquery name="get_expense_center" datasource="#dsn2#">
                            SELECT EXPENSE_CODE, EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = #EXPENSE_CENTER_ID#
                        </cfquery>
                        <cfset expense_name = get_expense_center.EXPENSE_CODE & " " & get_expense_center.EXPENSE />
                        <cfelse>
                        <cfset expense_name = "" />
                        </cfif>
                        <td>#expense_name#</td>
                        <cfif Len(EXPENSE_ITEM_ID)>
                        <cfquery name="get_expense_item" datasource="#dsn2#">
                            SELECT ACCOUNT_CODE, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #EXPENSE_ITEM_ID#
                        </cfquery>
                        <cfset expense_item_name = get_expense_item.ACCOUNT_CODE & " " & get_expense_item.EXPENSE_ITEM_NAME />
                        <cfelse>
                        <cfset expense_item_name = "" />
                        </cfif>
                        <td>#expense_item_name#</td>
                        <cfif Len(PROJECT_ID)>
                        <cfquery name="get_project" datasource="#dsn#">
                            SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #PROJECT_ID#
                        </cfquery>
                        <cfset project_name = get_project.PROJECT_HEAD />
                        <cfelse>
                        <cfset project_name = "" />
                        </cfif>
                        <td>#project_name#</td>
                        <cfif Len(COMPANY_ID) And COMPANY_ID Neq 0>
                        <cfquery name="get_company" datasource="#dsn#">
                            SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID = #COMPANY_ID#
                        </cfquery>
                        <cfset company_name = get_company.NICKNAME />
                        <cfelseif Len(CONSUMER_ID) And CONSUMER_ID Neq 0>
                        <cfquery name="get_company" datasource="#dsn#">
                            SELECT CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS CONSUMER_NAME FROM CONSUMER WHERE CONSUMER_ID = #CONSUMER_ID#
                        </cfquery>
                        <cfset company_name = get_company.CONSUMER_NAME />
                        <cfelseif Len(EMPLOYEE_ID) And EMPLOYEE_ID Neq 0>
                        <cfquery name="get_company" datasource="#dsn#">
                            SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS EMPLOYEE_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #EMPLOYEE_ID#
                        </cfquery>
                        <cfset company_name = get_company.EMPLOYEE_NAME />
                        <cfelse>
                        <cfset company_name = "" />
                        </cfif>
                        <td>#company_name#</td>
                        <cfif Len(PAYMENT_TYPE_ID)>
                        <cfquery name="get_paymethod" datasource="#dsn#">
                            SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #PAYMENT_TYPE_ID#
                        </cfquery>
                        <cfset paymethod_name = get_paymethod.PAYMETHOD />
                        <cfelse>
                        <cfset paymethod_name = "" />
                        </cfif>
                        <td>#paymethod_name#</td>
                        <cfif Len(SPECIAL_DEFINITION_ID)>
                        <cfquery name="get_special_definition" datasource="#dsn#">
                            SELECT SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_ID = #SPECIAL_DEFINITION_ID#
                        </cfquery>
                        <cfset special_definition = get_special_definition.SPECIAL_DEFINITION />
                        <cfelse>
                        <cfset special_definition = "" />
                        </cfif>
                        <td>#special_definition#</td>
                        <cfif Len(ASSET_ID)>
                        <cfquery name="get_asset" datasource="#dsn#">
                            SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = #ASSET_ID#
                        </cfquery>
                        <cfset asset_name = get_asset.ASSETP />
                        <cfelse>
                        <cfset asset_name = "" />
                        </cfif>
                        <td>#asset_name#</td>
                        <cfif Len(BRANCH_ID)>
                        <cfquery name="get_branch" datasource="#dsn#">
                            SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #BRANCH_ID#
                        </cfquery>
                        <cfset branch_name = get_branch.BRANCH_NAME />
                        <cfelse>
                        <cfset branch_name = "" />
                        </cfif>
                        <td>#branch_name#</td>
                        <cfif Len(DEPARTMENT_ID)>
                            <cfquery name="get_department" datasource="#dsn#">
                            SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #DEPARTMENT_ID#
                        </cfquery>
                        <cfset department_name = get_department.DEPARTMENT_HEAD />
                        <cfelse>
                        <cfset department_name = "" />
                        </cfif>
                        <td>#department_name#</td>
                    </tr>
                    </cfoutput>
                    <cfelse>
                    <tr>
                        <td colspan="5"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
                    </tr>
                    </cfif>
				</tbody>
			</table>
</cf_grid_list>
</cf_box>
 </cfform>

 <script type="text/javascript">
    $(document).keydown(function(e){
        // ESCAPE key pressed
        if (e.keyCode == 27) {
            window.close();
        }
    });

    function toleranceFunction() {
      var checkBox = document.getElementById("is_process_invoice_closing");
      var text = document.getElementById("tolerance");
      if (checkBox.checked == true){
        text.style.display = "block";
      } else {
         text.style.display = "none";
      }
    }

</script>
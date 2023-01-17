<cf_xml_page_edit fuseact="ehesap.popup_form_add_kesinti">
<cfquery name="get_odenek" datasource="#dsn#">
  SELECT * FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = #ATTRIBUTES.ODKES_ID#
</cfquery>

<cfquery name="get_ch_types" datasource="#dsn#">
	SELECT * FROM SETUP_ACC_TYPE ORDER BY ACC_TYPE_NAME
</cfquery>
<cfquery name="get_our_company" datasource="#dsn#">
	SELECT DISTINCT
		OC.COMP_ID,
		OC.COMPANY_NAME
	FROM 
		SETUP_PERIOD SP,
		OUR_COMPANY OC
	WHERE
		SP.OUR_COMPANY_ID = OC.COMP_ID AND
		SP.PERIOD_ID IN (SELECT 
							EPP.PERIOD_ID
						FROM
							EMPLOYEE_POSITIONS EP,
							EMPLOYEE_POSITION_PERIODS EPP
						WHERE
							EP.POSITION_ID = EPP.POSITION_ID AND
							EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
	ORDER BY
		OC.COMPANY_NAME
</cfquery>
<cfquery name="get_budget_accounts" datasource="#dsn#">
	SELECT DISTINCT
		*
	FROM 
        SETUP_PAYMENT_INTERRUPTION_BUDGET_ACCOUNTS
	WHERE
		ODKES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.odkes_id#">
</cfquery>
<cfset periods = createObject('component','V16.objects.cfc.periods')>
<cfset period_years = periods.get_period_year()>
<cfinclude template="../query/get_moneys.cfm">
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform name="add_odenek" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_upd_kesinti">
            <input type="hidden" name="odkes_id" id="odkes_id" value="<cfoutput>#ATTRIBUTES.ODKES_ID#</cfoutput>">
            <cf_box_elements>
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-is_active">
                        <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='57493.Aktif'></span></label>
                        <div class="col col-4 col-xs-12">
                            <label><cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_odenek.status eq 1>checked</cfif>></label>
                        </div>
                        <div class="col col-4 col-xs-12">
                            <label><cf_get_lang dictionary_id='53179.Bordroda'><input type="checkbox" name="show" id="show"  value="<cfoutput>#get_odenek.show#</cfoutput>" <cfif get_odenek.show eq 1>checked</cfif>></label>
                        </div>
                    </div>
                    <div class="form-group" id="item-comment">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58233.Tanım'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="comment" id="comment" value="<cfoutput>#get_odenek.COMMENT_PAY#</cfoutput>">
                                <span class="input-group-addon">
                                    <cf_language_info	
                                    table_name="SETUP_PAYMENT_INTERRUPTION"
                                    column_name="COMMENT_PAY" 
                                    column_id_value="#attributes.odkes_id#" 
                                    maxlength="500" 
                                    datasource="#dsn#" 
                                    column_id="ODKES_ID" 
                                    control_type="1">	
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-PERIOD">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53310.Periyod'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="PERIOD" id="PERIOD">
                                <option value="1" <cfif get_odenek.PERIOD_PAY EQ 1>SELECTED</cfif>><cf_get_lang dictionary_id='53311.Ayda'> 1</option>
                                <option value="2" <cfif get_odenek.PERIOD_PAY EQ 2>SELECTED</cfif>>3 <cf_get_lang dictionary_id='53311.Ayda'> 1</option>
                                <option value="3" <cfif get_odenek.PERIOD_PAY EQ 3>SELECTED</cfif>>6 <cf_get_lang dictionary_id='53311.Ayda'> 1</option>
                                <option value="4" <cfif get_odenek.PERIOD_PAY EQ 4>SELECTED</cfif>><cf_get_lang dictionary_id='53312.Yılda'> 1</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-METHOD">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="29472.Yöntem"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="METHOD" id="METHOD">
                                <option value="1" <cfif get_odenek.METHOD_PAY EQ 1>SELECTED</cfif>><cf_get_lang dictionary_id='53134.Eksi'></option>
                                <option value="2" <cfif get_odenek.METHOD_PAY EQ 2>SELECTED</cfif>>% <cf_get_lang dictionary_id='58724.Ay'></option>
                                <option value="3" <cfif get_odenek.METHOD_PAY EQ 3>SELECTED</cfif>>% <cf_get_lang dictionary_id='57490.Gün'></option>
                                <option value="4" <cfif get_odenek.METHOD_PAY EQ 4>SELECTED</cfif>>% <cf_get_lang dictionary_id='57491.Saat'></option>
                                <option value="5" <cfif get_odenek.METHOD_PAY EQ 5>SELECTED</cfif>>% <cf_get_lang dictionary_id='53971.Kazanç'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-from_salary">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54032.Net / Brüt'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="from_salary" id="from_salary">
                                <option value="0"<cfif get_odenek.from_salary eq 0> selected</cfif>><cf_get_lang dictionary_id='53145.Net Ücretden Kesilsin'></option>
                                <option value="1"<cfif get_odenek.from_salary eq 1> selected</cfif>><cf_get_lang dictionary_id='53507.Brüt Ücretden Kesilsin'></option>
                            </select>
                        </div>
                    </div>
                    <cfif is_show_account_code eq 1>
                        <div class="form-group" id="item-account_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="account_code" id="account_code" value="#get_odenek.account_code#" >
                                    <cfinput type="Text" name="account_name" id="account_name" value="#get_odenek.account_name#" onFocus="AutoComplete_Create('account_name','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE,ACCOUNT_NAME','account_code,account_name','','3','225');">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_odenek.account_code&field_name=add_odenek.account_name','list');" title="<cf_get_lang_main no='1399.Muhasebe Kodu'>"></span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-calc_days">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53967.Kesinti Günü"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="calc_days" id="calc_days">
                                <option value="0" <cfif get_odenek.calc_days EQ 0>SELECTED</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                <option value="1" <cfif get_odenek.calc_days EQ 1>SELECTED</cfif>><cf_get_lang dictionary_id='57490.Gün'></option>
                                <option value="2" <cfif get_odenek.calc_days EQ 2>SELECTED</cfif>><cf_get_lang dictionary_id='53968.Fiili Gün'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-TAX">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53969.Vergi Muafiyeti"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="TAX" id="TAX">
                                <option value="1"<cfif get_odenek.TAX EQ 1>SELECTED</cfif>><cf_get_lang dictionary_id='53250.Gelir Vergisi'> + <cf_get_lang dictionary_id='53252.Damga Vergisi'></option>
                                <option value="3"<cfif get_odenek.TAX EQ 3>SELECTED</cfif>><cf_get_lang dictionary_id='53250.Gelir Vergisi'></option>
                                <option value="2"<cfif get_odenek.TAX EQ 2>SELECTED</cfif>><cf_get_lang dictionary_id='53402.Muaf Değil'></option>
                        </select>
                        </div>
                    </div>
                    <cfif is_show_member_type eq 1>
                        <div class="form-group" id="item-acc_type_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53329.Hesap Tipi"></label>
                            <div class="col col-8 col-xs-12">
                                <select name="acc_type_id" id="acc_type_id">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfoutput query="get_ch_types">
                                        <option value="#acc_type_id#" <cfif get_odenek.acc_type_id eq acc_type_id>selected</cfif>>#acc_type_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </cfif>
                </div>  
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-amount">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57635.Miktar'></label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57635.Miktar'></cfsavecontent>
                            <cfinput required="yes" message="#message#" type="text" name="amount" value="#TLFormat(get_odenek.AMOUNT_PAY)#" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                    </div>
                    <div class="form-group" id="item-start_sal_mon">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
                        <div class="col col-8 col-xs-12">
                            <cfoutput>
                                <select name="start_sal_mon" id="start_sal_mon">
                                    <cfloop from="1" to="12" index="j">
                                        <option value="#j#" <cfif get_odenek.START_SAL_MON EQ J>SELECTED</cfif>>#listgetat(ay_list(),j,',')#</option>
                                    </cfloop>
                                </select>
                            </cfoutput>
                        </div>
                    </div>
                    <div class="form-group" id="item-end_sal_mon">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'></label>
                        <div class="col col-8 col-xs-12">
                            <cfoutput>
                                <select name="end_sal_mon" id="end_sal_mon">
                                    <cfloop from="1" to="12" index="j">
                                        <option value="#j#" <cfif get_odenek.END_SAL_MON EQ J>SELECTED</cfif>>#listgetat(ay_list(),j,',')#</option>
                                    </cfloop>
                                </select>
                            </cfoutput>
                        </div>
                    </div>
                    <div class="form-group" id="item-money">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57489.Para Birimi"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="money" id="money">
                                <cfoutput query="get_moneys">
                                    <option value="#money#" <cfif get_odenek.money is money> selected</cfif>>#money#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <cfif is_show_member eq 1>
                        <div class="form-group" id="item-member_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_odenek.company_id#</cfoutput>">
                                    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_odenek.consumer_id#</cfoutput>">
                                    <cfif len(get_odenek.company_id)>
                                        <cfinput  name="member_name" id="member_name" type="text" value="#get_par_info(get_odenek.company_id,1,0,0)#" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID','company_id','','3','180','');">
                                    <cfelseif len(get_odenek.consumer_id)>
                                        <cfinput  name="member_name" id="member_name" type="text" value="#get_cons_info(get_odenek.consumer_id,0,0,0)#" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID','company_id','','3','180','');">
                                    <cfelse>	
                                        <cfinput  name="member_name" id="member_name" type="text" value="" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID','company_id','','3','180','');">
                                    </cfif>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_name=add_odenek.member_name&field_consumer=add_odenek.consumer_id&field_comp_id=add_odenek.company_id&field_member_name=add_odenek.member_name</cfoutput>','list')" title="<cf_get_lang_main no='107.Cari Hesap'>"></span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-is_inst_avans">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54036.Taksitlendirilmiş Avans'></label>
                        <label class="col col-8 col-xs-12">
                            <input type="checkbox" name="is_inst_avans" id="is_inst_avans" value="<cfoutput>#get_odenek.is_inst_avans#</cfoutput>" <cfif get_odenek.is_inst_avans eq 1>checked</cfif>>              
                        </label>
                    </div>
                    <div class="form-group" id="item-is_demand">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59317.Avans Taleplerinde Seçilebilir"></label>
                        <label class="col col-8 col-xs-12">
                            <input type="checkbox" name="is_demand" id="is_demand" value="1"  <cfif get_odenek.is_demand eq 1>checked</cfif>>             
                        </label>
                    </div>
                    <cfif get_odenek.is_ehesap neq 1 or session.ep.ehesap>
                        <div class="form-group" id="item-is_ehesap">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="56369.Üst Düzey IK Yetkisi"></label>
                            <label class="col col-8 col-xs-12">
                                <input type="checkbox" name="is_ehesap" id="is_ehesap" value="1"<cfif get_odenek.is_ehesap eq 1> checked</cfif>>              
                            </label>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-is_disciplinary_punishment">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43318.Disiplin Cezası'></label>
                        <label class="col col-8 col-xs-12">
                            <input type="checkbox" name="is_disciplinary_punishment" id="is_disciplinary_punishment" value="1" <cfif get_odenek.is_disciplinary_punishment eq 1> checked</cfif>>              
                        </label>
                    </div>
                    <cf_duxi name="is_union_information" type="checkbox"  data="get_odenek.is_union_information" value="1" label="65022">
                    <div class="form-group" id="item-is_net_to_gross" style="display:none">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='65416.Net Ücretse Brüt Olarak Kesilsin'></label>
                        <label class="col col-8 col-xs-12">
                            <input type="checkbox" name="is_net_to_gross" id="is_net_to_gross" value="1" <cfif get_odenek.is_net_to_gross eq 1> checked</cfif>>              
                        </label>
                    </div>
                </div>
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true" id="union_information_div" style="display:none">
                    <cf_duxi type="text" name="union_information_name" data="get_odenek.union_information_name" hint="Sendika adı" label="64957">
                    <cf_duxi type="text" name="union_information_address" data="get_odenek.union_information_address" hint="adres" label="63895">
                    <cf_duxi type="text" name="union_information_bank_name" data="get_odenek.union_information_bank_name" hint="banka adı" label="30349">
                    <cf_duxi type="text" name="union_information_branch_name" data="get_odenek.union_information_branch_name" hint="şube adı" label="29532">
                    <cf_duxi type="text" name="union_information_account_name" data="get_odenek.union_information_account_name" hint="hesap numarası" label="58178">
                </div>  
            </cf_box_elements>
            <div class="ui-scroll">
                <table class="ui-table-list ui-form">
                    <thead>
                        <tr>
                            <cfoutput><input type="hidden" name="record_num" value="<cfif get_budget_accounts.recordCount>#get_budget_accounts.recordCount#<cfelse>0</cfif>" id="record_num"></cfoutput>
                            <th width="40"><a onclick="add_row()" href="javascript://"><i class="fa fa-plus"></i></a></th>
                            <th><cf_get_lang dictionary_id="58460.Masraf Merkezi"></th>
                            <th><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></th>
                            <th><cf_get_lang dictionary_id='57574.Şirket'></th>
                            <th><cf_get_lang dictionary_id='32693.Periyod/yıl'></th>
                          <!---  <th><cf_get_lang dictionary_id='32633.Hesap Kodu'></th> --->
                        </tr>
                    </thead>
                     <tbody id="table_info">
                        <cfif get_budget_accounts.recordCount>
                            <cfoutput query="get_budget_accounts">
                                <tr id="frm_row#currentrow#">
                                    <td>
                                        <cfinput type="hidden" name="id#currentrow#" id="id#currentrow#" value="#budget_accounts_id#">
                                        <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                                        <a href="javascript://" onClick="sil(#currentrow#);"><i class="fa fa-minus"></i></a>
                                    </td>
                                    <td>
                                        <cfquery name="get_expense_center" datasource="#dsn2#">
                                            SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = #expense_center_id#
                                        </cfquery>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <input type="hidden" name="expense_center_id#currentrow#" value="#expense_center_id#" id="expense_center_id#currentrow#"><input type="text" id="expense_center_name#currentrow#" name="expense_center_name#currentrow#" value="#get_expense_center.expense#" class="boxtext"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_exp('#currentrow#');"></span>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <cfquery name="get_expense_item" datasource="#dsn2#">
                                            SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #expense_item_id#
                                        </cfquery>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <input type="hidden" name="expense_item_id#currentrow#" value="#expense_item_id#" id="expense_item_id#currentrow#"><input type="text" id="expense_item_name#currentrow#" name="expense_item_name#currentrow#" value="#get_expense_item.expense_item_name#" class="boxtext"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_item('#currentrow#');"></span>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form-group">
                                            <select name="our_company_id#currentrow#" id="our_company_id#currentrow#">
                                                <option value=""><cf_get_lang dictionary_id='57574.Şirket'></option>
                                                <cfloop query="get_our_company">
                                                    <option value="#comp_id#" <cfif get_budget_accounts.our_company_id eq comp_id>selected</cfif>>#company_name#</option>
                                                </cfloop>
                                            </select>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form-group">
                                            <select name="period_year#currentrow#" id="period_year#currentrow#">
                                                <option value=""><cf_get_lang dictionary_id='58455.Yıl'></option>
                                                <cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
                                                    <option value="#i#" <cfif get_budget_accounts.period_year eq i>selected</cfif>>#i#</option>
                                                </cfloop>
                                            </select>
                                        </div>
                                    </td>
                                   
                                    <!---
                                    <td>
                                        <cfquery name="get_account_plan" datasource="#dsn2#">
                                            SELECT ACCOUNT_NAME,ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#account_code#'
                                        </cfquery>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <input type="hidden" name="account_id#currentrow#" value="#account_code#" id="account_id#currentrow#">
                                                <input type="text" id="account_code#currentrow#" name="account_code#currentrow#" value="#get_account_plan.account_code#-#get_account_plan.account_name#" class="boxtext"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_exp('#currentrow#');"></span>
                                            </div>
                                        </div>
                                    </td>--->
                                </tr>
                            </cfoutput>
                        </cfif>
                     </tbody>
                </table>
            </div>
            <cf_box_footer>
                <div class="col col-6">
                    <cf_record_info query_name="get_odenek">
                </div>
                <div class="col col-6">
                    <cfif get_odenek.is_ehesap neq 1 or session.ep.ehesap>
                        <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_kesinti&ODKES_ID=#URL.ODKES_ID#' delete_alert='#message#' add_function='form_chk()'>
                    </cfif>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
    open_info_div();
    from_salary_control($( "#from_salary" ).val());
	function form_chk()
	{
		add_odenek.amount.value = filterNum(add_odenek.amount.value);
		return true;
    }
    <cfif isdefined("get_budget_accounts") and get_budget_accounts.recordcount>
		row_count=<cfoutput>#get_budget_accounts.recordcount#</cfoutput>;
	<cfelse>
		row_count=0;
	</cfif>

    $( "#from_salary" ).change(function() {
        from_salary_control($(this).val());
    });

    function from_salary_control(type){
        if(type== 1)
        {
            $("#item-is_net_to_gross").show();
        }else{
            $("#item-is_net_to_gross").hide();
        }
    }
    function sil(sy)
	{
		var my_element=document.getElementById('row_kontrol'+sy);	
		my_element.value=0;		
		var my_element=eval("frm_row"+sy);	
		my_element.style.display="none";	
	}

    function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table_info").insertRow(document.getElementById("table_info").rows.length);
		newRow.setAttribute("name","frm_row"+row_count);
		newRow.setAttribute("id","frm_row"+row_count);	
		document.getElementById('record_num').value = row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol'+row_count+'" id="row_kontrol'+row_count+'" value="1"> <ul class="ui-icon-list"><li><a href="javascript://" onclick="sil(' + row_count + ');"><i class="fa fa-minus"></i></a></li></ul>';
        // masraf merkezi
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
        newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="expense_center_id' + row_count +'" value="" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" value="" class="boxtext"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_exp('+ row_count +');"></span></div></div>';
        //Bütçe kalemi
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
        newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="expense_item_id' + row_count +'" value="" id="expense_item_id' + row_count +'"><input type="text" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="" class="boxtext"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_item('+ row_count +');"></span></div></div>';
        //Sirket
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
        newCell.innerHTML ='<div class="form-group"><select name="our_company_id' + row_count +'" id="our_company_id' + row_count +'"><option value=""><cf_get_lang dictionary_id='57574.Şirket'></option><cfoutput><cfloop query="get_our_company"><option value="#comp_id#" <cfif session.ep.company_id eq comp_id>selected</cfif>>#company_name#</option></cfloop></cfoutput></select></div>';
        
        //Period Yılı
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
        newCell.innerHTML ='<div class="form-group"><select name="period_year' + row_count +'" id="period_year' + row_count +'"><option value=""><cf_get_lang dictionary_id='58455.Yıl'></option><cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i"><cfoutput><option value="#i#">#i#</option></cfoutput></cfloop></select></div>';

        //Muhasebe Kodu
        /*
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.setAttribute('nowrap','nowrap');
        newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="account_id' + row_count +'" id="account_id' + row_count +'" value=""><input type="text" name="account_code' + row_count +'" id="account_code' + row_count +'" class="boxtext"  value="" onFocus="autocomp_acc_code('+row_count+');"><span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="pencere_ac_acc('+ row_count +');"></span></div></div>';											
    */
    }
    function autocomp_acc_code(no)
	{
		AutoComplete_Create("account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","","ACCOUNT_CODE","account_id"+no,"",3,225);
	}
    function pencere_ac_acc(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_odenek.account_id' + no +'&field_name=add_odenek.account_code' + no +'','list');
	}
    function pencere_ac_item(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_income=1&field_id=add_odenek.expense_item_id' + no +'&field_name=add_odenek.expense_item_name' + no,'list');
	}
    function pencere_ac_exp(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=add_odenek.expense_center_id' + no +'&field_name=add_odenek.expense_center_name' + no,'list');
	}
    $( "#is_union_information" ).on( "click", function() {
        open_info_div();
    });
    function open_info_div() {
        if ($('#is_union_information').is(':checked')) {
            $('#union_information_div').show();
        }else
        {
            $('#union_information_div').hide();
        }
    }
</script>

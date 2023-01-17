<cfset attributes.according_to_session=1>
<cfinclude template="../query/get_com_branch.cfm">
<cfinclude template="../query/get_cash_detail.cfm">
<cfquery name="GET_PAYMENT_TYPE_ROW" datasource="#DSN2#">
	SELECT
		C.*,
		A.ACCOUNT_NAME
	FROM
		CASH_PAYMENT_TYPE_ROW C,
		ACCOUNT_PLAN A
	WHERE
		C.CASH_ID = #url.id# AND
		C.POS_ACCOUNT_CODE = A.ACCOUNT_CODE	
</cfquery>
<cfset row = get_payment_type_row.recordcount>
<cfquery name="GET_CASH_ACT" datasource="#DSN2#">
	SELECT
		ACTION_ID
	FROM
		CASH_ACTIONS
	WHERE
		CASH_ACTION_FROM_CASH_ID = #attributes.id# OR
		CASH_ACTION_TO_CASH_ID = #attributes.id#
</cfquery>
<cfquery name="GET_ACCOUNTS" datasource="#DSN2#">
	SELECT
		ACCOUNT_CODE,
		ACCOUNT_NAME
	FROM
		ACCOUNT_PLAN
	WHERE
		SUB_ACCOUNT = 0
</cfquery>	
<cf_catalystHeader>
<cfform name="upd_cash" method="post" action="#request.self#?fuseaction=cash.upd_cash">
	<input type="hidden" name="id" value="<cfoutput>#attributes.id#</cfoutput>">
    <cf_box_elements>
        <div class="row"> 
            <div class="col col-12 uniqueRow"> 		
                <div class="row formContent">
                    <div class="row" type="row">
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-status">
                                <label class="col col-1 col-xs-12"><cf_get_lang_main no='81.Aktif'></label>
                                <div class="col col-1 col-xs-12"> 
                                    <input type="checkbox" name="status" id="status" <cfif get_cash_detail.cash_status eq 1>checked</cfif>>
                                </div>
                            </div>
                            <div class="form-group" id="item-BRANCH_ID">
                                <label class="col col-6 col-xs-12"><cf_get_lang_main no='41.Şube'>*</label>
                                <div class="col col-6 col-xs-12"> 
                                    <select name="branch_id" id="branch_id" style="width:175px;" onChange="get_departments(this.options.selectedIndex);">
                                        <cfoutput query="get_com_branch">
                                            <option value="#branch_id#" <cfif branch_id eq get_cash_detail.branch_id>selected</cfif>>#branch_name#</option>
                                            <cfif branch_id eq get_cash_detail.branch_id><cfset attributes.branch_id=branch_id><cfelse><cfset attributes.branch_id=0></cfif>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-DEPARTMENT_ID">
                                <label class="col col-6 col-xs-12"><cf_get_lang_main no='160.Departman'>*</label>
                                <div class="col col-6 col-xs-12"> 
                                    <cfinclude template="../query/get_com_department.cfm">
                                    <select name="department_id" id="department_id" style="width:175px;">
                                        <cfoutput query="GET_DEPARTMENT">
                                            <option value="#department_id#" <cfif department_id eq get_cash_detail.department_id>selected</cfif>>#department_head#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-cash_name">
                                <label class="col col-6 col-xs-12"><cf_get_lang no='60.Kasa Adı'>*</label>
                                <div class="col col-6 col-xs-12"> 
                                    <cfsavecontent variable="message"><cf_get_lang no='147.Kasa Adı Girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" name="cash_name" value="#get_cash_detail.cash_name#" required="yes" message="#message#" maxlength="50" style="width:175px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-cash_code">
                                <label class="col col-6 col-xs-12"><cf_get_lang no='63.Kasa Kodu'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <input type="text" name="cash_code" id="cash_code" value="<cfoutput>#get_cash_detail.cash_code#</cfoutput>" style="width:175px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-account_name">
                                <label class="col col-6 col-xs-12"><cf_get_lang no='72.Kasa Muhasebe Kodu'>*</label>
                                <div class="col col-6 col-xs-12"> 
                                    <div class="input-group">
                                        <cfquery name="GET_ACC_7" datasource="#DSN2#">
                                            SELECT
                                                ACCOUNT_NAME
                                            FROM
                                                ACCOUNT_PLAN
                                            WHERE
                                                ACCOUNT_CODE = '#get_cash_detail.cash_acc_code#'
                                        </cfquery>
                                        <input type="hidden" name="account_id" id="account_id" style="width:177px;" value="<cfoutput>#get_cash_detail.cash_acc_code#</cfoutput>">
                                        <input type="text" name="account_name" id="account_name" value="<cfif len(get_cash_detail.cash_acc_code)><cfoutput>#get_cash_detail.cash_acc_code# - #get_acc_7.account_name#</cfoutput></cfif>" style="width:177px;"  onFocus="AutoComplete_Create('account_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','CODE_NAME,ACCOUNT_CODE','account_name,account_id','upd_cash','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=upd_cash.account_name&field_id=upd_cash.account_id</cfoutput>')" title="<cf_get_lang no='72.Kasa Muhasebe Kodu'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-a_cheque_account_name">
                                <label class="col col-6 col-xs-12"><cf_get_lang no='73.Alınan Çek Muhasebe Kodu'>*</label>
                                <div class="col col-6 col-xs-12"> 
                                    <div class="input-group">
                                        <cfquery name="GET_ACC_6" datasource="#DSN2#">
                                            SELECT
                                                ACCOUNT_NAME
                                            FROM
                                                ACCOUNT_PLAN
                                            WHERE
                                                ACCOUNT_CODE = '#get_cash_detail.A_CHEQUE_ACC_CODE#'
                                        </cfquery>
                                        <input type="hidden" name="a_cheque_account_id" id="a_cheque_account_id" style="width:177px;" value="<cfoutput>#get_cash_detail.A_CHEQUE_ACC_CODE#</cfoutput>">
                                        <input type="text" name="a_cheque_account_name" id="a_cheque_account_name" value="<cfif len(get_cash_detail.A_CHEQUE_ACC_CODE)><cfoutput>#get_cash_detail.A_CHEQUE_ACC_CODE# - #get_acc_6.account_name#</cfoutput></cfif>" style="width:177px;" onFocus="AutoComplete_Create('a_cheque_account_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','CODE_NAME,ACCOUNT_CODE','a_cheque_account_name,a_cheque_account_id','upd_cash','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=upd_cash.a_cheque_account_name&field_id=upd_cash.a_cheque_account_id</cfoutput>')" title="<cf_get_lang no='73.Alınan Çek Muhasebe Kodu'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-a_voucher_account_name">
                                <label class="col col-6 col-xs-12"><cf_get_lang no='39.Alınan Senet Muhasebe Kodu'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <div class="input-group">
                                        <cfquery name="GET_ACC_5" datasource="#DSN2#">
                                            SELECT
                                                ACCOUNT_NAME
                                            FROM
                                                ACCOUNT_PLAN
                                            WHERE
                                                ACCOUNT_CODE = '#get_cash_detail.A_VOUCHER_ACC_CODE#'
                                        </cfquery>
                                        <input type="hidden" name="a_voucher_account_id" id="a_voucher_account_id" style="width:177px;" value="<cfoutput>#get_cash_detail.a_voucher_acc_code#</cfoutput>">
                                        <input type="text" name="a_voucher_account_name" id="a_voucher_account_name" value="<cfif len(get_cash_detail.a_voucher_acc_code)><cfoutput>#get_cash_detail.a_voucher_acc_code# - #get_acc_5.account_name#</cfoutput></cfif>" style="width:177px;" onFocus="AutoComplete_Create('a_voucher_account_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','CODE_NAME,ACCOUNT_CODE','a_voucher_account_name,a_voucher_account_id','upd_cash','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=upd_cash.a_voucher_account_name&field_id=upd_cash.a_voucher_account_id</cfoutput>')" title="<cf_get_lang no='39.Alınan Senet Muhasebe Kodu'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-v_voucher_account_name">
                                <label class="col col-6 col-xs-12"><cf_get_lang no='19.Verilen Senet muhasebe Kodu'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <div class="input-group">
                                        <cfquery name="GET_ACC_4" datasource="#DSN2#">
                                            SELECT
                                                ACCOUNT_NAME
                                            FROM
                                                ACCOUNT_PLAN
                                            WHERE
                                                ACCOUNT_CODE = '#get_cash_detail.V_VOUCHER_ACC_CODE#'
                                        </cfquery>
                                        <input type="hidden" name="v_voucher_account_id" id="v_voucher_account_id" style="width:177px;" value="<cfoutput>#get_cash_detail.V_VOUCHER_ACC_CODE#</cfoutput>">
                                        <input type="text" name="v_voucher_account_name" id="v_voucher_account_name" value="<cfif len(get_cash_detail.V_VOUCHER_ACC_CODE)><cfoutput>#get_cash_detail.V_VOUCHER_ACC_CODE# - #get_acc_4.account_name#</cfoutput></cfif>" style="width:177px;" onFocus="AutoComplete_Create('v_voucher_account_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','CODE_NAME,ACCOUNT_CODE','v_voucher_account_name,v_voucher_account_id','upd_cash','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=upd_cash.v_voucher_account_name&field_id=upd_cash.v_voucher_account_id</cfoutput>')" title="<cf_get_lang no='19.Verilen Senet muhasebe Kodu'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-due_account_code_name">
                                <label class="col col-6 col-xs-12"><cf_get_lang no ='200.Vade Farkları Muhasebe Kodu'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <div class="input-group">
                                        <cfquery name="GET_ACC_1" datasource="#DSN2#">
                                            SELECT
                                                ACCOUNT_NAME
                                            FROM
                                                ACCOUNT_PLAN
                                            WHERE
                                                ACCOUNT_CODE = '#get_cash_detail.due_diff_acc_code#'
                                        </cfquery>
                                        <input type="hidden" name="due_account_id" id="due_account_id" style="width:177px;" value="<cfoutput>#get_cash_detail.due_diff_acc_code#</cfoutput>">
                                        <input type="text" name="due_account_code_name" id="due_account_code_name" value="<cfif len(get_cash_detail.due_diff_acc_code)><cfoutput>#get_cash_detail.due_diff_acc_code# - #get_acc_1.account_name#</cfoutput></cfif>" style="width:177px;" onFocus="AutoComplete_Create('due_account_code_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','CODE_NAME,ACCOUNT_CODE','due_account_code_name,due_account_id','upd_cash','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=upd_cash.due_account_code_name&field_id=upd_cash.due_account_id</cfoutput>')" title="<cf_get_lang no ='200.Vade Farkları Muhasebe Kodu'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-cheque_transfer_code_name">
                                <label class="col col-6 col-xs-12"><cf_get_lang no ='88.Yoldaki Çekler Muhasebe Kodu'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <div class="input-group">
                                        <cfquery name="GET_ACC_2" datasource="#DSN2#">
                                            SELECT
                                                ACCOUNT_NAME
                                            FROM
                                                ACCOUNT_PLAN
                                            WHERE
                                                ACCOUNT_CODE = '#get_cash_detail.transfer_cheque_acc_code#'
                                        </cfquery>
                                        <input type="hidden" name="cheque_transfer_account_id" id="cheque_transfer_account_id" style="width:177px;" value="<cfoutput>#get_cash_detail.transfer_cheque_acc_code#</cfoutput>">
                                        <input type="text" name="cheque_transfer_code_name" id="cheque_transfer_code_name" value="<cfif len(get_cash_detail.transfer_cheque_acc_code)><cfoutput>#get_cash_detail.transfer_cheque_acc_code# - #get_acc_2.account_name#</cfoutput></cfif>" style="width:177px;" onFocus="AutoComplete_Create('cheque_transfer_code_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','CODE_NAME,ACCOUNT_CODE','cheque_transfer_code_name,cheque_transfer_account_id','upd_cash','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=upd_cash.cheque_transfer_code_name&field_id=upd_cash.cheque_transfer_account_id</cfoutput>')" title="<cf_get_lang no ='88.Yoldaki Çekler Muhasebe Kodu'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-voucher_transfer_code_name">
                                <label class="col col-6 col-xs-12"><cf_get_lang no ='96.Yoldaki Senetler Muhasebe Kodu'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <div class="input-group">
                                        <cfquery name="GET_ACC_3" datasource="#DSN2#">
                                            SELECT
                                                ACCOUNT_NAME
                                            FROM
                                                ACCOUNT_PLAN
                                            WHERE
                                                ACCOUNT_CODE = '#get_cash_detail.transfer_voucher_acc_code#'
                                        </cfquery>
                                        <input type="hidden" name="voucher_transfer_account_id" id="voucher_transfer_account_id" style="width:177px;" value="<cfoutput>#get_cash_detail.transfer_voucher_acc_code#</cfoutput>">
                                        <input type="text" name="voucher_transfer_code_name" id="voucher_transfer_code_name" value="<cfif len(get_cash_detail.transfer_voucher_acc_code)><cfoutput>#get_cash_detail.transfer_voucher_acc_code# - #get_acc_3.account_name#</cfoutput></cfif>" style="width:177px;" onFocus="AutoComplete_Create('voucher_transfer_code_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','CODE_NAME,ACCOUNT_CODE','voucher_transfer_code_name,voucher_transfer_account_id','upd_cash','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=upd_cash.voucher_transfer_code_name&field_id=upd_cash.voucher_transfer_account_id</cfoutput>')" title="<cf_get_lang no ='96.Yoldaki Senetler Muhasebe Kodu'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-karsiliksiz_cekler_name">
                                <label class="col col-6 col-xs-12"><cf_get_lang no="4.Karşılıksız Çekler"> *</label>
                                <div class="col col-6 col-xs-12"> 
                                    <div class="input-group">
                                        <cfquery name="GET_ACC_8" datasource="#DSN2#">
                                            SELECT
                                                ACCOUNT_NAME
                                            FROM
                                                ACCOUNT_PLAN
                                            WHERE
                                                ACCOUNT_CODE = '#get_cash_detail.KARSILIKSIZ_CEKLER_CODE#'
                                        </cfquery>
                                        <input type="hidden" name="karsiliksiz_cekler_id" id="karsiliksiz_cekler_id" style="width:177px;" value="<cfoutput>#get_cash_detail.karsiliksiz_cekler_code#</cfoutput>">
                                        <input type="text" name="karsiliksiz_cekler_name" id="karsiliksiz_cekler_name" value="<cfif len(get_cash_detail.karsiliksiz_cekler_code)><cfoutput>#get_cash_detail.karsiliksiz_cekler_code# - #get_acc_8.account_name#</cfoutput></cfif>" style="width:177px;" onFocus="AutoComplete_Create('karsiliksiz_cekler_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','CODE_NAME,ACCOUNT_CODE','karsiliksiz_cekler_name,karsiliksiz_cekler_id','upd_cash','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=upd_cash.karsiliksiz_cekler_name&field_id=upd_cash.karsiliksiz_cekler_id</cfoutput>')"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-protestolu_senetler_name">
                                <label class="col col-6 col-xs-12"><cf_get_lang no="5.Protestolu Senetler"> *</label>
                                <div class="col col-6 col-xs-12"> 
                                    <div class="input-group">
                                        <cfquery name="GET_ACC_9" datasource="#DSN2#">
                                            SELECT
                                                ACCOUNT_NAME
                                            FROM
                                                ACCOUNT_PLAN
                                            WHERE
                                                ACCOUNT_CODE = '#get_cash_detail.PROTESTOLU_SENETLER_CODE#'
                                        </cfquery>
                                        <input type="hidden" name="protestolu_senetler_id" id="protestolu_senetler_id" style="width:177px;" value="<cfoutput>#get_cash_detail.protestolu_senetler_code#</cfoutput>">
                                        <input type="text" name="protestolu_senetler_name" id="protestolu_senetler_name" value="<cfif len(get_cash_detail.protestolu_senetler_code)><cfoutput>#get_cash_detail.protestolu_senetler_code# - #get_acc_9.account_name#</cfoutput></cfif>" style="width:177px;" onFocus="AutoComplete_Create('protestolu_senetler_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','CODE_NAME,ACCOUNT_CODE','protestolu_senetler_name,protestolu_senetler_id','upd_cash','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=upd_cash.protestolu_senetler_name&field_id=upd_cash.protestolu_senetler_id</cfoutput>')"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-cash_employee">
                                <label class="col col-6 col-xs-12"><cf_get_lang_main no='132.Sorumlu'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="cash_emp_id" id="cash_emp_id" value="<cfoutput>#get_cash_detail.emp_id#</cfoutput>">
                                        <input type="text" name="cash_employee" id="cash_employee" value="<cfoutput>#get_emp_info(get_cash_detail.emp_id,0,0)#</cfoutput>" style="width:177px;"  onFocus="AutoComplete_Create('cash_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','cash_emp_id','','3','175')">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_cash.cash_emp_id&field_name=upd_cash.cash_employee&select_list=1,9');" title="<cf_get_lang_main no='132.Sorumlu'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-is_all_branch">
                                <label class="col col-6 col-xs-12"><cf_get_lang no ='86.Bütün Şubelerden Virman İşlemi Yapılabilsin'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <input type="checkbox" name="is_all_branch" id="is_all_branch" value="1" <cfif get_cash_detail.is_all_branch eq 1>checked</cfif>>
                                </div>
                            </div>
                            <div class="form-group" id="item-is_whops">
                                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='65219.Whops ile Çalışsın'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <input type="checkbox" name="is_whops" id="is_whops" value="1" <cfif get_cash_detail.is_whops eq 1>checked</cfif>>
                                </div>
                            </div>
                        </div>
                    </div>	
                    <div class="row formContentFooter">	
                        <div class="col col-6">
                            <cf_record_info query_name="get_cash_detail">
                        </div> 
                        <div class="col col-6">
                            <cfif not get_cash_act.recordcount>
                                <cf_workcube_buttons type_format="1" is_upd='1' delete_page_url='#request.self#?fuseaction=cash.del_cash&id=#url.id#'>
                            <cfelse>
                                <cf_workcube_buttons type_format='1' is_upd='1' is_delete ='0' add_function='kontrol()'>
                            </cfif>
                        </div> 
                    </div>
                </div>
            </div>
        </div>
    </cf_box_elements>
</cfform>
<script type="text/javascript">
	my_arr=new Array();
	<cfloop  from="1" to="#get_com_branch.recordcount#" index="i">
		<cfset s=#get_com_branch.BRANCH_ID[i]#>
		my_arr[<cfoutput>#s#</cfoutput>] = new Array(3);
		<cfquery name="get_deps" datasource="#DSN#">
			SELECT
				BRANCH_ID,
				DEPARTMENT_ID,
				DEPARTMENT_HEAD  
			FROM
				DEPARTMENT
			WHERE
				BRANCH_ID=#get_com_branch.BRANCH_ID[i]#
		</cfquery>
		<cfset say=0>
		<cfoutput query="get_deps" >
			my_arr[#s#][#say#]='#DEPARTMENT_HEAD#';
			<cfset say=say+1>				
			my_arr[#s#][#say#]=#DEPARTMENT_ID#;
			<cfset say=say+1>				
		</cfoutput>
	</cfloop>
	
	function get_departments(x)
	{
		temp_opt=upd_cash.department_id;
		for (m=upd_cash.department_id.options.length-1;m>=0;m--)
			temp_opt.options[m]=null;		
		i=upd_cash.branch_id.options[x].value;
		s=0;
		for( j = 0 ; j < my_arr[i].length ; j += 2)
		{
			temp_opt.options[s]=null;
			temp_opt.options[s]=new Option(my_arr[i][j],my_arr[i][j+1]);
			s=s+1;
		}
		for (m=upd_cash.department_id.options.length-1;m>=0;m--)
		{
			if(temp_opt.options[m].value == "")
			{
				temp_opt.options[m]=null;	
			}
		}
	}
	function kontrol()
	{
		if (document.getElementById('branch_id').value == '')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='41.Sube'>");
			return false;
		}
		if (document.getElementById('department_id').value == '')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='160.Departman'>");
			return false;
		}
		if (document.getElementById('cash_name').value == '')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='60.Kasa Adi'>");
			return false;
		}
		if (document.getElementById('currency_id').value == '')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='77.Para Birimi'>");
			return false;
		}
		if (document.getElementById('account_id').value == "" || document.getElementById('account_name').value == "")
		{ 
			alert ("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='72.Kasa Muhasebe Kodu'>");
			return false;
		}	
		if (document.getElementById('a_cheque_account_id').value == "" || document.getElementById('a_cheque_account_name').value == "")
		{ 
			alert ("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='73.Alınan Çek Muhasebe Kodu'>");
			return false;
		}
		if (document.getElementById("karsiliksiz_cekler_id").value == "" || document.getElementById("karsiliksiz_cekler_name").value == "")
		{ 
			alert ("<cf_get_lang_main no='782.Zorunlu Alan'>: Karşılıksız Çekler");
			return false;
		}
		if (document.getElementById("protestolu_senetler_id").value == "" || document.getElementById("protestolu_senetler_name").value == "")
		{ 
			alert ("<cf_get_lang_main no='782.Zorunlu Alan'>: Protestolu Senetler");
			return false;
		}
		return true;
	}	
	function pencere_ac_acc(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=upd_cash.account_code_name' + no +'&field_id=upd_cash.account_code' + no +'','list');
	}
</script>

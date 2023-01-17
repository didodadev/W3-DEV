<cfset attributes.according_to_session=1>
<cfinclude template="../query/get_com_branch.cfm">
<cfinclude template="../query/get_money.cfm">
<cfquery name="get_accounts" datasource="#dsn2#">
	SELECT
		ACCOUNT_CODE,
		ACCOUNT_NAME
	FROM
		ACCOUNT_PLAN
	WHERE
		SUB_ACCOUNT = 0
</cfquery>
<cf_catalystHeader>
<cfform name="add_cash" method="post" action="#request.self#?fuseaction=cash.add_cash">
    <cf_box_elements>
        <div class="row"> 
            <div class="col col-12 uniqueRow"> 		
                <div class="row formContent">
                    <div class="row" type="row">
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-status">
                                <label class="col col-1 col-xs-12"><cf_get_lang_main no='81.Aktif'></label>
                                <div class="col col-1 col-xs-12"> 
                                    <input type="checkbox" name="status" id="status" value="1">
                                </div>
                            </div>
                            <div class="form-group" id="item-BRANCH_ID">
                                <label class="col col-6 col-xs-12"><cf_get_lang_main no='41.Şube'>*</label>
                                <div class="col col-6 col-xs-12"> 
                                    <select name="BRANCH_ID" id="BRANCH_ID" style="width:175px;" onChange="get_departments(this.options.selectedIndex);">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfoutput query="get_com_branch">
                                            <option value="#BRANCH_ID#">#BRANCH_NAME#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-DEPARTMENT_ID">
                                <label class="col col-6 col-xs-12"><cf_get_lang_main no='160.Departman'>*</label>
                                <div class="col col-6 col-xs-12"> 
                                    <select name="DEPARTMENT_ID" id="DEPARTMENT_ID" style="width:175px;">
                                        <option value="" ><cf_get_lang no='65.Önce Şube Seçiniz'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-cash_name">
                                <label class="col col-6 col-xs-12"><cf_get_lang no='60.Kasa Adı'>*</label>
                                <div class="col col-6 col-xs-12"> 
                                    <cfsavecontent variable="message"><cf_get_lang no='147.Kasa Adı Girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" name="cash_name" value="" style="width:175px;" required="yes" message="#message#" maxlength="50">
                                </div>
                            </div>
                            <div class="form-group" id="item-cash_code">
                                <label class="col col-6 col-xs-12"><cf_get_lang no='63.Kasa Kodu'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <input type="text" name="cash_code" id="cash_code" value="" style="width:175px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-currency_id">
                                <label class="col col-6 col-xs-12"><cf_get_lang_main no='77.Para Birimi'>*</label>
                                <div class="col col-6 col-xs-12"> 
                                    <select name="currency_id" id="currency_id" style="width:175px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfoutput query="get_money">
                                            <option value="#MONEY#">#MONEY#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-account_name">
                                <label class="col col-6 col-xs-12"><cf_get_lang no='72.Kasa Muhasebe Kodu'>*</label>
                                <div class="col col-6 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="account_id" id="account_id" value="" style="width:175px;">
                                        <input type="text" name="account_name" id="account_name" style="width:175px;" value="" onFocus="AutoComplete_Create('account_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','CODE_NAME,ACCOUNT_CODE','account_name,account_id','add_cash','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_cash.account_name&field_id=add_cash.account_id</cfoutput>&account_code='+document.add_cash.account_id.value)" title="<cf_get_lang no='72.Kasa Muhasebe Kodu'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-a_cheque_account_name">
                                <label class="col col-6 col-xs-12"><cf_get_lang no='73.Alınan Çek Muhasebe Kodu'>*</label>
                                <div class="col col-6 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="a_cheque_account_id" id="a_cheque_account_id" value="" style="width:175px;">
                                        <input type="text" name="a_cheque_account_name" id="a_cheque_account_name" style="width:175px;" value="" onFocus="AutoComplete_Create('a_cheque_account_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','CODE_NAME,ACCOUNT_CODE','a_cheque_account_name,a_cheque_account_id','add_cash','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_cash.a_cheque_account_name&field_id=add_cash.a_cheque_account_id</cfoutput>&account_code='+document.add_cash.a_cheque_account_id.value)" title="<cf_get_lang no='73.Alınan Çek Muhasebe Kodu'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-a_voucher_account_name">
                                <label class="col col-6 col-xs-12"><cf_get_lang no='39.Alınan Senet Muhasebe Kodu'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="a_voucher_account_id" id="a_voucher_account_id" value="" style="width:175px;">
                                        <input type="text" name="a_voucher_account_name" id="a_voucher_account_name" style="width:175px;" value="" onFocus="AutoComplete_Create('a_voucher_account_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','CODE_NAME,ACCOUNT_CODE','a_voucher_account_name,a_voucher_account_id','add_cash','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_cash.a_voucher_account_name&field_id=add_cash.a_voucher_account_id</cfoutput>&account_code='+document.add_cash.a_voucher_account_id.value)" title="<cf_get_lang no='39.Alınan Senet Muhasebe Kodu'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-v_voucher_account_name">
                                <label class="col col-6 col-xs-12"><cf_get_lang no='19.Verilen Senet muhasebe Kodu'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="v_voucher_account_id" id="v_voucher_account_id" value="" style="width:175px;">
                                        <input type="text" name="v_voucher_account_name" id="v_voucher_account_name" style="width:175px;" value="" onFocus="AutoComplete_Create('v_voucher_account_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','CODE_NAME,ACCOUNT_CODE','v_voucher_account_name,v_voucher_account_id','add_cash','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_cash.v_voucher_account_name&field_id=add_cash.v_voucher_account_id</cfoutput>&account_code='+document.add_cash.v_voucher_account_id.value)" title="<cf_get_lang no='19.Verilen Senet muhasebe Kodu'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-due_account_code_name">
                                <label class="col col-6 col-xs-12"><cf_get_lang no ='200.Vade Farkları Muhasebe Kodu'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="due_account_id" id="due_account_id" value="" style="width:175px;">
                                        <input type="text" name="due_account_code_name" id="due_account_code_name" style="width:175px;" value="" onFocus="AutoComplete_Create('due_account_code_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','CODE_NAME,ACCOUNT_CODE','due_account_code_name,due_account_id','add_cash','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_cash.due_account_code_name&field_id=add_cash.due_account_id</cfoutput>&account_code='+document.add_cash.due_account_id.value)" title="<cf_get_lang no ='200.Vade Farkları Muhasebe Kodu'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-cheque_transfer_code_name">
                                <label class="col col-6 col-xs-12"><cf_get_lang no ='88.Yoldaki Çekler Muhasebe Kodu'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="cheque_transfer_account_id" id="cheque_transfer_account_id" value="" style="width:175px;">
                                        <input type="text" name="cheque_transfer_code_name" id="cheque_transfer_code_name" style="width:175px;" value="" onFocus="AutoComplete_Create('cheque_transfer_code_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','CODE_NAME,ACCOUNT_CODE','cheque_transfer_code_name,cheque_transfer_account_id','add_cash','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_cash.cheque_transfer_code_name&field_id=add_cash.cheque_transfer_account_id</cfoutput>&account_code='+document.add_cash.cheque_transfer_account_id.value)" title="<cf_get_lang no ='88.Yoldaki Çekler Muhasebe Kodu'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-voucher_transfer_code_name">
                                <label class="col col-6 col-xs-12"><cf_get_lang no ='96.Yoldaki Senetler Muhasebe Kodu'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="voucher_transfer_account_id" id="voucher_transfer_account_id" value="" style="width:175px;">
                                        <input type="text" name="voucher_transfer_code_name" id="voucher_transfer_code_name" style="width:175px;" value="" onFocus="AutoComplete_Create('voucher_transfer_code_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','CODE_NAME,ACCOUNT_CODE','voucher_transfer_code_name,voucher_transfer_account_id','add_cash','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_cash.voucher_transfer_code_name&field_id=add_cash.voucher_transfer_account_id</cfoutput>&account_code='+document.add_cash.voucher_transfer_account_id.value)" title="<cf_get_lang no ='96.Yoldaki Senetler Muhasebe Kodu'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-karsiliksiz_cekler_name">
                                <label class="col col-6 col-xs-12"><cf_get_lang no="4.Karşılıksız Çekler"> *</label>
                                <div class="col col-6 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="karsiliksiz_cekler_id" id="karsiliksiz_cekler_id" value="" style="width:175px;">
                                        <input type="text" name="karsiliksiz_cekler_name" id="karsiliksiz_cekler_name" style="width:175px;" value="" onFocus="AutoComplete_Create('karsiliksiz_cekler_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','CODE_NAME,ACCOUNT_CODE','karsiliksiz_cekler_name,karsiliksiz_cekler_id','add_cash','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_cash.karsiliksiz_cekler_name&field_id=add_cash.karsiliksiz_cekler_id</cfoutput>&account_code='+document.add_cash.karsiliksiz_cekler_id.value)"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-protestolu_senetler_name">
                                <label class="col col-6 col-xs-12"><cf_get_lang no="5.Protestolu Senetler"> *</label>
                                <div class="col col-6 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="protestolu_senetler_id" id="protestolu_senetler_id" value="" style="width:175px;">
                                        <input type="text" name="protestolu_senetler_name" id="protestolu_senetler_name" style="width:175px;" value="" onFocus="AutoComplete_Create('protestolu_senetler_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','CODE_NAME,ACCOUNT_CODE','protestolu_senetler_name,protestolu_senetler_id','add_cash','3','250');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_cash.protestolu_senetler_name&field_id=add_cash.protestolu_senetler_id</cfoutput>&account_code='+document.add_cash.protestolu_senetler_id.value)"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-cash_employee">
                                <label class="col col-6 col-xs-12"><cf_get_lang_main no='132.Sorumlu'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="cash_emp_id" id="cash_emp_id" value="">
                                        <input type="text" name="cash_employee" id="cash_employee" value="" style="width:175px;" onFocus="AutoComplete_Create('cash_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','cash_emp_id','','3','175')">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_cash.cash_emp_id&field_name=add_cash.cash_employee&select_list=1,9');" title="<cf_get_lang_main no='132.Sorumlu'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-is_all_branch">
                                <label class="col col-6 col-xs-12"><cf_get_lang no ='86.Bütün Şubelerden Virman İşlemi Yapılabilsin'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <input type="checkbox" name="is_all_branch" id="is_all_branch" value="1">
                                </div>
                            </div>
                            <div class="form-group" id="item-is_whops">
                                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='65219.Whops ile Çalışsın'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <input type="checkbox" name="is_whops" id="is_whops" value="1">
                                </div>
                            </div>
                        </div>
                    </div>	
                    <div class="row formContentFooter">	
                        <div class="col col-12"><cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'></div> 
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
			ORDER BY
				DEPARTMENT_HEAD
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
		temp_opt=add_cash.DEPARTMENT_ID;
		for (m=add_cash.DEPARTMENT_ID.options.length-1;m>=0;m--)
			temp_opt.options[m]=null;		
			
		i=add_cash.BRANCH_ID.options[x].value;
		s=0;
		for(j=0;j<my_arr[i].length;j+=2){
			temp_opt.options[s]=null;
			temp_opt.options[s]=new Option(my_arr[i][j],my_arr[i][j+1]);
			s=s+1;
		}
		for (m=add_cash.DEPARTMENT_ID.options.length-1;m>=0;m--){
			if(temp_opt.options[m].value == "")
			{
				temp_opt.options[m]=null;	
			}
		}
	}
	
	function kontrol()
	{
		if (document.getElementById('BRANCH_ID').value == '')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='41.Sube'>");
			return false;
		}
		if (document.getElementById('DEPARTMENT_ID').value == '')
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
</script>

<!---
    File: setup_rule_definition.cfm
    Folder: AddOns\Gramoni\WoDiBa\form\
    Author: Gramoni
    Date: 03.11.2020
    Controller: WodibaSetupRuleSetsController.cfc
    Description:
		Virman işlemlerinde POS bloke hesaptan yapılan virman işlemleri ve vadeli mevduat işlemlerinde sabit hesapları tanımlamak için eklendi.
        process_type bazlı ekrana gelen özellikler kontrol edilmelidir.
--->

<cfquery name="get_bank" datasource="#dsn#">
    SELECT BANK_ID,BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>
<cfquery name="get_det" datasource="#dsn#">
	SELECT
        DEFINITION_ID,
        RULE_SET_ID,
        BANK_ID,
        MONEY_TYPE,
        POS_ACCOUNT_ID,
        MAIN_ACCOUNT_ID
	FROM
        WODIBA_RULE_SET_DEFINITIONS
    WHERE
        RULE_SET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
    ORDER BY
        DEFINITION_ID
</cfquery>
<cfquery name="get_accounts" datasource="#dsn3#">
	SELECT
		ACCOUNT_ID,
        ACCOUNT_NAME
	FROM
        ACCOUNTS
</cfquery>
<cfquery name="get_money" datasource="#dsn#">
    SELECT
        MONEY_ID,
        MONEY
    FROM 
        SETUP_MONEY
    WHERE
        COMPANY_ID = #session.ep.COMPANY_ID#
</cfquery>
<cfset bank_accounts_options = "">
<cfloop query="get_accounts">
    <cfset bank_accounts_options = bank_accounts_options & '<option value="#ACCOUNT_ID#">#ACCOUNT_NAME#</option>'>
</cfloop>
<cfset banks_options = "">
<cfloop query="get_bank">
    <cfset banks_options = banks_options & '<option value="#BANK_ID#">#BANK_NAME#</option>'>
</cfloop>
<cfset money_options = "">
<cfloop query="get_money">
    <cfset money_options = money_options & '<option value="#MONEY#">#MONEY#</option>'>
</cfloop>
<cf_box  title="POS Bloke / Mevduat Hesabı Tanımlama" scroll="1" draggable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="form_definition" id="form_definition" method="post" action="#request.self#?fuseaction=settings.emptypopup_setup_add_definition&event=def&id=#attributes.id#">
        <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
        <input type="hidden" name="row_count_sabit" id="row_count_sabit" value="<cfoutput>#get_det.recordcount#</cfoutput>">
        <input type="hidden" name="row_count" id="row_count" value="">
        <cf_grid_list>
            <thead>
                <tr>
                    <th style="width:50px;"><input type="button" class="eklebuton" title="" onClick="add_row();"></th>
                    <th style="width:100px;"><cf_get_lang dictionary_id='57521.Banka'></th>
                    <th style="width:60px;"><cf_get_lang dictionary_id='57489.Currency'></th>
                    <th style="width:120px;"><cf_get_lang dictionary_id='61458.Bloke Hesap'></th>
                    <th style="width:120px;"><cf_get_lang dictionary_id='39372.Main Account Name'></th>
                </tr>
            </thead>
            <tbody id="link_table">
                <cfoutput query="get_det">
                    <tr id="sabit_my_row_#currentrow#">
                        <td><a style="cursor:pointer" onclick="sabit_sil(#currentrow#);" ><img src="images/delete_list.gif" border="0"></a></td>
                        <td>
                            <select id="sabit_bank#currentrow#" name="sabit_bank#currentrow#" style="width:150px;" onchange="get_accounts(#currentrow#,1);">
                                <option value=""></option>
                                <cfloop query="get_bank">
                                    <option value="#BANK_ID#"<cfif get_det.BANK_ID eq BANK_ID>selected</cfif>>#BANK_NAME#</option>
                                </cfloop>
                            </select>
                            <input type="hidden" id="sabit_main_account_id_#currentrow#" name="sabit_main_account_id_#currentrow#" value="#MAIN_ACCOUNT_ID#">
                            <input type="hidden" id="sabit_pos_account_id_#currentrow#" name="sabit_pos_account_id_#currentrow#" value="#POS_ACCOUNT_ID#">
                            <input type="hidden" id="sabit_definition#currentrow#" name="sabit_definition#currentrow#" value="#DEFINITION_ID#">
                            <input type="hidden" id="sabit_row_kontrol_#currentrow#" name="sabit_row_kontrol_#currentrow#" value="1">
                        </td>
                        <td>
                            <select id="sabit_money_type#currentrow#" name="sabit_money_type#currentrow#" style="width:150px;" onchange="get_accounts(#currentrow#,1);">
                                <option value=""></option>
                                <cfloop query="get_money">
                                    <option value="#MONEY#" <cfif get_det.MONEY_TYPE eq MONEY>selected</cfif>>#MONEY#</option>
                                </cfloop>
                            </select>
                        </td>
                        <td>
                            <select id="sabit_pos_bloke#currentrow#" name="sabit_pos_bloke#currentrow#" style="width:150px;">
                                <option value=""></option>
                                <cfloop query="get_accounts">
                                    <option value="#ACCOUNT_ID#" <cfif get_det.POS_ACCOUNT_ID eq ACCOUNT_ID>selected</cfif>>#ACCOUNT_NAME#</option>
                                </cfloop>
                            </select>
                        </td>    
                        <td>
                            <select id="sabit_bank_account#currentrow#" name="sabit_bank_account#currentrow#" style="width:150px;">
                                <option value=""></option>
                                <cfloop query="get_accounts">
                                    <option value="#ACCOUNT_ID#" <cfif get_det.MAIN_ACCOUNT_ID eq ACCOUNT_ID>selected</cfif>>#ACCOUNT_NAME#</option>
                                </cfloop>
                            </select>
                        </td>
                    </tr>
                </cfoutput>
            </tbody>
    </cf_grid_list>

        <cf_workcube_buttons is_upd='0' add_function="kontrol()">
    </cfform>
</cf_box>
<script>
    $( document ).ready(function() {
        sabit_length = document.getElementById('row_count_sabit').value;
        for (curr = 1; curr <= sabit_length; curr++) {
            sabit_pos_account_id = document.getElementById('sabit_pos_account_id_'+curr).value;
            sabit_main_account_id = document.getElementById('sabit_main_account_id_'+curr).value;
            get_accounts(curr,1);
            document.getElementById('sabit_bank_account'+curr).value = sabit_main_account_id;
            document.getElementById('sabit_pos_bloke'+curr).value = sabit_pos_account_id;
        }
    });
    row_count=0;
    function sabit_sil(sy)
    {
        var my_element=eval("sabit_row_kontrol_"+sy);
        my_element.value=0;

        var my_element=eval("sabit_my_row_"+sy);
        my_element.style.display="none";
    }
    function sil(sy)
    {
        var my_element=eval("row_kontrol_"+sy);
        my_element.value=0;

        var my_element=eval("my_row_"+sy);
        my_element.style.display="none";
        row_count--;
    }
    function add_row()
    {
        row_count++;
        var newRow;
        var newCell;
        banks_options = '<option value=""></option>' + String('<cfoutput>#banks_options#</cfoutput>');
        bank_accounts_options = '<option value=""></option>' + String('<cfoutput>#bank_accounts_options#</cfoutput>');
        money_options = '<option value=""></option>' + String('<cfoutput>#money_options#</cfoutput>');
        newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);	
        newRow.setAttribute("name","my_row_" + row_count);
        newRow.setAttribute("id","my_row_" + row_count);		
        newRow.setAttribute("NAME","my_row_" + row_count);
        newRow.setAttribute("ID","my_row_" + row_count);		
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="images/delete_list.gif" border="0"></a>';	
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select id="bank' + row_count +'" name="bank'+ row_count +'" style="width:150px;" onchange="get_accounts(' + row_count + ',2);">' + banks_options + '</select>';
        newCell.innerHTML+= '<input type="hidden" id="row_kontrol_' + row_count +'" name="row_kontrol_' + row_count +'" value="1">';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select id="money_type' + row_count +'" name="money_type'+ row_count +'" style="width:150px;" onchange="get_accounts(' + row_count + ',2);">' + money_options + '</select>';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select id="pos_bloke' + row_count +'" name="pos_bloke'+ row_count +'" style="width:150px;">' + bank_accounts_options + '</select>';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select id="bank_account' + row_count +'" name="bank_account'+ row_count +'" style="width:150px;">' + bank_accounts_options + '</select>';
    }
    function get_accounts(row_count,row_type) {
        if (row_type == 2) {
            ext_params_1 = document.getElementById('bank'+row_count).value;
            ext_params_2 = document.getElementById('money_type'+row_count).value;
/*ext_params = document.getElementById('bank'+row_count).value + "*" +document.getElementById('money_type'+row_count).value;*/   
        }
        else if (row_type == 1) {
            ext_params_1 = document.getElementById('sabit_bank'+row_count).value;
            ext_params_2 = document.getElementById('sabit_money_type'+row_count).value;
/* ext_params = document.getElementById('sabit_bank'+row_count).value + "*" +document.getElementById('sabit_money_type'+row_count).value;*/        }
/*bank_accounts = wrk_safe_query("bnk_get_acc_5",'dsn3',0,ext_params);*/
        bank_accounts = $.ajax({
                        url: "AddOns/Gramoni/WoDiBa/cfc/Functions.cfc?method=getBankAcc",
                        type: "POST",
                        data: {param_1 : ext_params_1,param_2 : ext_params_2},
                        cache: false,
                        async: false,
                        success: function(data){
                            return_data = ReplaceAll(data,'//""','');
                            final_json = JSON.parse(return_data);
                        }
                    }); 
        bank_accounts_options = "";
        if (final_json.DATA.length > 0) {
            for (i = 0; i < final_json.DATA.length; i++) {
                bank_accounts_options = bank_accounts_options + '<option value="'+final_json.DATA[i][2]+'">'+final_json.DATA[i][0]+'</option>';
            }
            if (row_type == 2) {
                $('#bank_account'+row_count+' option').remove();
                $('#bank_account'+row_count).append(bank_accounts_options);
                
                $('#pos_bloke'+row_count+' option').remove();
                $('#pos_bloke'+row_count).append(bank_accounts_options);
            }
            else if (row_type == 1) {
                $('#sabit_bank_account'+row_count+' option').remove();
                $('#sabit_bank_account'+row_count).append(bank_accounts_options);

                $('#sabit_pos_bloke'+row_count+' option').remove();
                $('#sabit_pos_bloke'+row_count).append(bank_accounts_options);
            }
        }
        else{
            if (row_type == 2) {
                $('#bank_account'+row_count+' option').remove();                
                $('#pos_bloke'+row_count+' option').remove();
            }
            else if (row_type == 1) {
                $('#sabit_bank_account'+row_count+' option').remove();
                $('#sabit_pos_bloke'+row_count+' option').remove();
            }
        }
    }
    function kontrol(){
        form_definition.row_count.value = row_count;
        for ( i = 1; i <= row_count; i++) {
            a = document.getElementById('pos_bloke'+i).value;
            b = document.getElementById('bank_account'+i).value;
            if (a == b) {
                alert('Pos Bloke Hesabı Ana Hesap ile Aynı Olamaz !!');
                return false;
            }
        }
        array_sabit = [];
        for ( k = 1; k <= sabit_length; k++) {
            x = document.getElementById('sabit_pos_bloke'+k).value;
            y = document.getElementById('sabit_bank_account'+k).value;
            if (x == y) {
                alert('Pos Bloke Hesabı Ana Hesap ile Aynı Olamaz !!');
                return false;
            }
        }
        for (j = 1; j <= sabit_length; j++) {
            if (document.getElementById('sabit_row_kontrol_'+j).value == 1) {
                for (p = 1; p <= row_count; p++) {
                    if (document.getElementById('row_kontrol_'+p).value == 1) {
                        if (document.getElementById('sabit_bank'+j).value == document.getElementById('bank'+p).value && document.getElementById('sabit_money_type'+j).value == document.getElementById('money_type'+p).value) {
                            alert('Aynı Para birimine sahip bir banka icin islem gerceklestirilmis !!');
                            return false;
                        }  
                    }
                } 
            }
        }
        
        return true;
    }
    $(document).keydown(function(e){
        // ESCAPE key pressed
        if (e.keyCode == 27) {
            window.close();
        }
    });
</script>
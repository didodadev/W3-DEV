<cf_get_lang_set module_name="bank">
<cf_papers paper_type="virman">
<cfinclude template="../query/control_bill_no.cfm">
<!--- <cfinclude template="../query/get_control.cfm"> --->
<cfif isdefined("attributes.ID") and len(attributes.ID)>
	<cfif (session.ep.isBranchAuthorization)>
        <cfquery name="get_all_cash" datasource="#dsn2#">
            SELECT CASH_ID FROM CASH WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
        </cfquery>
        <cfset cash_list = valuelist(get_all_cash.cash_id)>
        <cfif not listlen(cash_list)><cfset cash_list = 0></cfif>
        <cfset control_branch_id = ListGetAt(session.ep.user_location,2,"-")>
    </cfif>
    <cfquery name="get_virman" datasource="#dsn2#">
        SELECT
            BA.*,
            PP.PROJECT_HEAD            
        FROM
            BANK_ACTIONS BA
                LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON BA.PROJECT_ID = PP.PROJECT_ID
        WHERE
            ACTION_ID=#attributes.ID# OR ACTION_ID = #attributes.ID+1#
            <cfif (session.ep.isBranchAuthorization)>
            AND                    
            (
            	ACTION_TYPE_ID IN (23,26,27) AND
                FROM_BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")# OR
				TO_BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
            )
        	</cfif>
    </cfquery>
    <cfquery name="GET_COST_WITH_EXPENSE_ROWS_ID" datasource="#dsn2#">
        SELECT * FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #URL.ID# AND EXPENSE_COST_TYPE = #get_virman.action_type_id#
    </cfquery>
    
    <cfset process_cat = get_virman.process_cat>
    <cfset from_account_id = get_virman.action_from_account_id>
    <cfset action_to_account_id = get_virman.action_to_account_id[2]>
    <cfset from_branch_id = get_virman.from_branch_id>
    <cfset to_branch_id = get_virman.to_branch_id[2]>
    <cfset action_date = get_virman.action_date>
    <cfset action_value = get_virman.action_value>
    <cfset masraf = get_virman.masraf>
    <cfset other_cash_act_value = get_virman.other_cash_act_value>
    <cfset expense_center_id = get_cost_with_expense_rows_id.expense_center_id>
    <cfset expense_item_id = get_cost_with_expense_rows_id.expense_item_id>
    <cfset other_money_order = get_virman.other_money>
    <cfset action_detail = get_virman.action_detail>
<cfelse>
	<cfset process_cat = ''>
    <cfset from_account_id = ''>
    <cfset action_to_account_id = ''>
    <cfset from_branch_id = ''>
    <cfset to_branch_id = ''>
    <cfset action_date = now()>
    <cfset action_value = 0>
    <cfset masraf = 0>
    <cfset other_cash_act_value = ''>
    <cfset expense_center_id = ''>
    <cfset expense_item_id = ''>
    <cfset other_money_order = ''>
    <cfset action_detail = ''>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box closable="0">
        <cfform name="add_virman" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_virman">
            <input type="hidden" name="ACTION_TYPE" id="ACTION_TYPE" value="<cfoutput>#UCase(getLang('main',648))#</cfoutput>">
            <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
            <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process_cat slct_width="285" process_cat=#process_cat#>
                            </div> 
                        </div>
                        <div class="form-group" id="item-from_account_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48723.Hangi Hesaptan'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkBankAccounts fieldId='from_account_id' call_function='kur_ekle_f_hesapla' width='285' selected_value='#from_account_id#'>
                            </div> 
                        </div>
                        <div class="form-group" id="item-to_account_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48726.Hangi Hesaba'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkBankAccounts fieldId='to_account_id' call_function='kur_ekle_f_hesapla;change_currency_info' width='285'  selected_value='#action_to_account_id#' line_info='2'>
                            </div> 
                        </div>
                        <div class="form-group" id="item-branch_id_alacak">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59238.Çıkış Şube'></label>
                            <div class="col col-8 col-xs-12">
                                <cfif session.ep.isBranchAuthorization eq 0></cfif>
                                <cf_wrkDepartmentBranch fieldId='branch_id_alacak' is_branch='1' width='150' is_default='1' is_deny_control='1' selected_value='#from_branch_id#'>
                            </div> 
                        </div>
                        <div class="form-group" id="item-branch_id_borc">
                            <cfif session.ep.isBranchAuthorization eq 0></cfif>
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59239.Giriş Şube'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkDepartmentBranch fieldId='branch_id_borc' is_branch='1' width='150' is_default='1' is_deny_control='1' selected_value='#to_branch_id#'>
                            </div> 
                        </div>
                        <div class="form-group" id="item-project_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfoutput>
                                        <input type="hidden"  name="project_id" id="project_id"/>
                                        <input type="text" style="width:150px" name="project_head" id="project_head" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','148');" autocomplete="off" />
                                    </cfoutput>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_cash_to_cash.project_id&project_head=add_cash_to_cash.project_head');"></span>
                                </div>
                            </div> 
                        </div>
                        <div class="form-group" id="item-paper_number">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="paper_number" maxlength="50" value="#paper_code & '-' & paper_number#" style="width:150px;">
                            </div> 
                        </div>
                        <div class="form-group" id="item-ACTION_DATE">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
                                    <cfinput type="text" name="ACTION_DATE" value="#dateformat(ACTION_DATE,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" style="width:150px;" onBlur="change_money_info('add_virman','ACTION_DATE');"> 
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="ACTION_DATE" call_function="change_money_info" control_date="#dateformat(ACTION_DATE,dateformat_style)#"></span>
                                </div>
                            </div> 
                        </div>
                        <div class="form-group" id="item-ACTION_VALUE">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message1"><cf_get_lang dictionary_id='48744.Miktar Giriniz!'></cfsavecontent>
                                <cfinput type="text" name="ACTION_VALUE" value="#TLFormat(action_value-masraf)#" required="yes" message="#message1#" class="moneybox" style="width:150px;" onBlur="kur_ekle_f_hesapla('from_account_id');" onkeyup="return(FormatCurrency(this,event));">
                            </div> 
                        </div>
                        <div class="form-group" id="item-OTHER_CASH_ACT_VALUE">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58056.Döviz Tutar'></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="OTHER_CASH_ACT_VALUE" value="#TLFormat(OTHER_CASH_ACT_VALUE)#" style="width:150px;" class="moneybox" onBlur="kur_ekle_f_hesapla('from_account_id',true);" onkeyup="return(FormatCurrency(this,event));"> 
                            </div> 
                        </div>
                        <div class="form-group" id="item-ACTION_DETAIL">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px;height:50px;" maxlength="200" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="200 Karakterden Fazla Yazmayınız!"><cfoutput>#action_detail#</cfoutput></textarea>
                            </div> 
                        </div>
                    </div>
                    
                    <div class="col col-6 col-md-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-kur-ekle">
                            <div class="col col-12 scrollContent scroll-x2">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48714.İşlem Para Br'></label>
                                <cfscript>f_kur_ekle(process_type:0,base_value:'ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'add_virman',select_input:'from_account_id',selected_money='#other_money_order#',is_disable='1');</cfscript>
                            </div>
                        </div>
                        <div class="form-group" id="item-masraf_baslik">
                            <label class="col col-12 bold"><cf_get_lang dictionary_id='58930.Masraf'></label>
                        </div>
                        <div class="form-group" id="item-masraf">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'></label>
                            <div class="col col-8 col-xs-12">
                                <cfif masraf gt 0>
                                <cfinput type="text" name="masraf" class="moneybox" style="width:150px;" value="#TLFormat(MASRAF)#" onkeyup="return(FormatCurrency(this,event));">
                                <cfelse>
                                    <cfinput type="text" name="masraf" class="moneybox" style="width:150px;" value="" onkeyup="return(FormatCurrency(this,event));">
                                </cfif>
                            </div> 
                        </div>
                        <div class="form-group" id="item-expense_center_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkExpenseCenter width_info="150" fieldId="expense_center_id" fieldName="expense_center_name" form_name="add_virman" expense_center_id="#expense_center_id#" img_info="plus_thin">
                            </div> 
                        </div>
                        <div class="form-group" id="item-expense_item_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkExpenseItem width_info="150" fieldId="expense_item_id" fieldName="expense_item_name" form_name="add_virman" expense_item_id="#expense_item_id#" income_type_info="0" img_info="plus_thin">
                            </div> 
                        </div>
                    </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	kur_ekle_f_hesapla('from_account_id');
	function change_currency_info()
	{
		new_kur_say = document.all.kur_say.value;
		for(var i=1;i<=new_kur_say;i++)
		{
			if(eval('document.all.hidden_rd_money_'+i) != undefined && eval('document.all.hidden_rd_money_'+i).value == document.getElementById('currency_id2').value)
				eval('document.all.rd_money['+(i-1)+']').checked = true;
		}
		kur_ekle_f_hesapla('from_account_id');
	}
	function kontrol()
	{
		if(!paper_control(add_virman.paper_number,'VIRMAN')) return false;
		if(!chk_process_cat('add_virman')) return false;
		if(!check_display_files('add_virman')) return false;
		if(!chk_period(document.add_virman.ACTION_DATE,'İşlem')) return false;
		if(!acc_control('from_account_id')) return false;
		if(!acc_control('to_account_id')) return false;
		kur_ekle_f_hesapla('from_account_id');//dövizli tutarı silinenler için
		if(document.add_virman.from_account_id.value == document.add_virman.to_account_id.value)				
		{
			alert("<cf_get_lang dictionary_id='48755.Seçtiğiniz Banka Hesapları Aynı !'>");		
			return false; 
		}
		if(document.add_virman.masraf.value != "" && document.add_virman.masraf.value != 0)
		{
			if(document.add_virman.expense_item_id.value == "" || document.add_virman.expense_item_name.value == "")
			{
				alert("<cf_get_lang dictionary_id='48880.Gider Kalemi Seçiniz!'>");
				return false;
			}
			if(document.add_virman.expense_center_id.value == "" || document.add_virman.expense_center_name.value == "")
			{
				alert("<cf_get_lang dictionary_id='48881.Masraf Merkezi Seçiniz'>!");
				return false;
			}
		}
        if(document.getElementById('ACTION_VALUE').value == '0,00')
        {
            alert("<cf_get_lang dictionary_id='54619.Tutar Girmelisiniz!'>!");
            return false;
        }
        
        
		return true;
	}

    function kur_ekle_f_hesapla(select_input,doviz_tutar)
    {
        var process_cat_ = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
        var IS_PROCESS_CURRENCY = '';

        var rate_round_num = <cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>;
        
        if(process_cat_ != '')
        {
            url_= '/V16/settings/cfc/processCat.cfc?method=getProcessCat';
            $.ajax({                                                                                             
                url: url_,
                dataType: "text",
                data: {process_cat: process_cat_},
                cache: false,
                async: false,
                success: function(read_data) {
                    data_ = jQuery.parseJSON(read_data.replace('//',''));
                    if(data_.DATA.length != 0)
                    {
                        $.each(data_.DATA,function(i){
                            IS_PROCESS_CURRENCY = data_.DATA[i][0];
                        });
                    }
                }
            });
        }
        
        if(IS_PROCESS_CURRENCY != true)
        {
            
            if(!doviz_tutar) doviz_tutar=false;
            if(document.getElementById(select_input) == undefined || document.getElementById(select_input).value == '') return false;//eğerki kasada seçilecek hesap var ise....
            if(document.getElementById('currency_id') != undefined)
                var currency_type = document.getElementById('currency_id').value;
            else
                var currency_type = eval('document.add_virman.'+select_input+'.options[document.add_virman.'+select_input+'.selectedIndex]').value;
            
            var other_money_value_eleman= eval('document.add_virman.OTHER_CASH_ACT_VALUE');
            var temp_act,temp_base_act,rate1_eleman,rate2_eleman;
            if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
            {
                other_money_value_eleman.value = '';
                return false;
            }
            if(!doviz_tutar && eval('document.add_virman.ACTION_VALUE.value') != "" && currency_type != "")
            {
                if(document.getElementById('currency_id') != undefined)
                    currency_type = document.getElementById('currency_id').value;
                else
                    currency_type = list_getat(currency_type,2,';');
                for(var i=1;i<=document.add_virman.kur_say.value;i++)
                {
                    rate1_eleman = filterNum(eval('document.add_virman.txt_rate1_' + i).value,rate_round_num);
                    rate2_eleman = filterNum(eval('document.add_virman.txt_rate2_' + i).value,rate_round_num);
                    if( eval('document.add_virman.hidden_rd_money_'+i).value == currency_type)
                    {
                        temp_act=filterNum(document.add_virman.ACTION_VALUE.value)*rate2_eleman/rate1_eleman;
                        document.add_virman.system_amount.value = commaSplit(temp_act,rate_round_num);
                    }
                }
                if(document.add_virman.kur_say.value == 1)
                {
                    for(var i=1;i<=document.add_virman.kur_say.value;i++)
                    {
                        rate1_eleman = filterNum(eval('document.add_virman.txt_rate1_' + i).value,rate_round_num);
                        rate2_eleman = filterNum(eval('document.add_virman.txt_rate2_' + i).value,rate_round_num);
                        if( eval('document.add_virman.rd_money.checked'))
                        {
                            if(eval('document.add_virman.hidden_rd_money_'+i).value == currency_type)
                                other_money_value_eleman.value = commaSplit(filterNum(document.add_virman.ACTION_VALUE.value));
                            else
                                other_money_value_eleman.value = commaSplit(filterNum(document.add_virman.system_amount.value,4)*(rate1_eleman/rate2_eleman));
                            document.add_virman.money_type.value = eval('document.add_virman.hidden_rd_money_'+i).value;
                            document.add_virman.system_amount.value = commaSplit(filterNum(document.add_virman.system_amount.value),rate_round_num);
                        }
                    }
                }
                else
                {
                    for(var i=1;i<=document.add_virman.kur_say.value;i++)
                    {
                        rate1_eleman = filterNum(eval('document.add_virman.txt_rate1_' + i).value,rate_round_num);
                        rate2_eleman = filterNum(eval('document.add_virman.txt_rate2_' + i).value,rate_round_num);
                        if( eval('document.add_virman.rd_money['+(i-1)+'].checked'))
                        {
                            if(eval('document.add_virman.hidden_rd_money_'+i).value == currency_type)
                                other_money_value_eleman.value = commaSplit(filterNum(document.add_virman.ACTION_VALUE.value));
                            else
                                other_money_value_eleman.value = commaSplit(filterNum(document.add_virman.system_amount.value,4)*(rate1_eleman/rate2_eleman));
                            document.add_virman.money_type.value = eval('document.add_virman.hidden_rd_money_'+i).value;
                            document.add_virman.system_amount.value = commaSplit(filterNum(document.add_virman.system_amount.value),rate_round_num);
                        }
                    }
                }
            }
            else if(doviz_tutar && document.add_virman.ACTION_VALUE.value != "" && currency_type != "")
            {
                for(var i=1;i<=document.add_virman.kur_say.value;i++)
                    if( eval('document.add_virman.rd_money['+(i-1)+'].checked'))
                    {
                        rate1_eleman = filterNum(eval('document.add_virman.txt_rate1_' + i).value,rate_round_num);
                        if(document.getElementById('currency_id') != undefined)
                            currency_type = document.getElementById('currency_id').value;
                        else
                            currency_type = list_getat(currency_type,2,';');
                        if (eval('document.add_virman.hidden_rd_money_'+i).value != 'TL')//hesap TL olmayıp,kurdan TL seçilip,döviz inputu edit edilirse TL kurunu değiştirmesn diye
                            eval('document.add_virman.txt_rate2_' + i).value = commaSplit(filterNum(document.add_virman.system_amount.value)/filterNum(other_money_value_eleman.value)*rate1_eleman,rate_round_num);
                        else
                            for(var t=1;t<=add_virman.kur_say.value;t++)//hesap TL olmayıp,kurdan TL seçilip,döviz inputu edit edilirse TL kurunu değiştirmesn,hesabın kurunu değiştirsn diye
                                if( eval('document.add_virman.hidden_rd_money_'+t).value == currency_type && eval('document.add_virman.hidden_rd_money_'+t).value != 'TL')
                                    eval('document.add_virman.txt_rate2_' + t).value = commaSplit(filterNum(other_money_value_eleman.value)/filterNum(add_virman.ACTION_VALUE.value)*rate1_eleman,rate_round_num);
                        if (eval('document.add_virman.hidden_rd_money_'+i).value != 'TL')
                            for(var k=1;k<=document.add_virman.kur_say.value;k++)
                            {
                                rate1_eleman = filterNum(eval('document.add_virman.txt_rate1_' + k).value,rate_round_num);
                                rate2_eleman = filterNum(eval('document.add_virman.txt_rate2_' + k).value,rate_round_num);
                                if( eval('document.add_virman.hidden_rd_money_'+k).value == currency_type)
                                {
                                    temp_act=filterNum(document.add_virman.ACTION_VALUE.value)*(rate2_eleman/rate1_eleman);
                                    document.add_virman.system_amount.value = commaSplit(temp_act,rate_round_num);
                                }
                            }
                        else
                            document.add_virman.system_amount.value = other_money_value_eleman.value;
                    }
                    return true;
                }
            
                document.add_virman.ACTION_VALUE.value = commaSplit(filterNum(document.add_virman.ACTION_VALUE.value));
            
            return true;
        }
        else
        {
            if(document.add_virman.kur_say.value == 1)
            {
                for(var i=1;i<=document.add_virman.kur_say.value;i++)
                    if( eval('document.add_virman.rd_money.checked'))
                        document.add_virman.money_type.value = eval('document.add_virman.hidden_rd_money_'+i).value;
            }
            else
            {
                for(var i=1;i<=document.add_virman.kur_say.value;i++)
                    if( eval('document.add_virman.rd_money['+(i-1)+'].checked'))
                        document.add_virman.money_type.value = eval('document.add_virman.hidden_rd_money_'+i).value;
            }	
        }
    }
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

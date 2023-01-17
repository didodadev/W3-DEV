<cf_get_lang_set module_name="bank">
<cfset refmodule="#listgetat(attributes.fuseaction,1,'.')#">
<cfquery name="GET_ACTION_DETAIL" datasource="#dsn2#">
	SELECT
        BANK_ACTIONS.*,
        PP.PROJECT_HEAD
	FROM
		BANK_ACTIONS
        LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON PP.PROJECT_ID = BANK_ACTIONS.PROJECT_ID
	WHERE
		(ACTION_ID = #ATTRIBUTES.ID# OR ACTION_ID = #ATTRIBUTES.ID+1#) AND
		ACTION_TYPE_ID IN (23,26,27)
		<cfif (session.ep.isBranchAuthorization)>
			AND 
				(
					FROM_BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")# OR
					TO_BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
				)
		</cfif>
	ORDER BY
		ACTION_ID ASC
</cfquery>
<cfquery name="GET_COST_WITH_EXPENSE_ROWS_ID" datasource="#dsn2#">
	SELECT * FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #URL.ID# AND EXPENSE_COST_TYPE = #get_action_detail.action_type_id#
</cfquery>
<cfif len(get_cost_with_expense_rows_id.expense_center_id)>
  <cfquery name="GET_EXPENSE" datasource="#dsn2#">
	  SELECT * FROM EXPENSE_CENTER WHERE EXPENSE_ID = #GET_COST_WITH_EXPENSE_ROWS_ID.EXPENSE_CENTER_ID#
  </cfquery>
</cfif>
<cfif len(get_cost_with_expense_rows_id.expense_item_id)>
	<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
		SELECT * FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #GET_COST_WITH_EXPENSE_ROWS_ID.EXPENSE_ITEM_ID#
	</cfquery>
</cfif>
<cfif not get_action_detail.recordcount>
	<br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cfsavecontent variable="right">
	<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id='19' action_section='BANK_ACTION_ID' action_id='#attributes.id#'>
</cfsavecontent>
<cf_catalystHeader>
	<cfform name="upd_virman" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_virman" method="post"><!---  && unformat_fields() --->
		<cfif listgetat(attributes.fuseaction,2,'.') is 'popup_upd_virman'>
			<input type="hidden" name="is_popup" id="is_popup" value="1">
		<cfelse>
			<input type="hidden" name="is_popup" id="is_popup" value="0">
		</cfif>
		<input type="hidden" name="ids" id="ids" value="<cfoutput>#attributes.id#,#attributes.id+1#</cfoutput>">
        <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
		<input type="hidden" name="ACTION_TYPE" id="ACTION_TYPE" value="<cfoutput>#UCase(getLang('main',648))#</cfoutput>">
		<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
        <div class="row">
        	<div class="col col-12 uniqueRow">
            	<div class="row formContent">
                    <div class="row" type="row">
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                                <div class="form-group" id="item-process_cat">
                                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',388)#</cfoutput>*</label>
                                    <div class="col col-8 col-xs-12">
                                        <cf_workcube_process_cat process_cat=#get_action_detail.process_cat# slct_width="285">
                                    </div> 
                                </div>
                                <div class="form-group" id="item-from_account_id">
                                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('bank',62)#</cfoutput>*</label>
                                    <div class="col col-8 col-xs-12">
                                        <cf_wrkBankAccounts fieldId='from_account_id' call_function='kur_ekle_f_hesapla' width='285' selected_value='#get_action_detail.action_from_account_id#' is_upd='1'>
                                    </div> 
                                </div>
                                <div class="form-group" id="item-to_account_id">
                                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('bank',65)#</cfoutput>*</label>
                                    <div class="col col-8 col-xs-12">
                                        <cf_wrkBankAccounts fieldId='to_account_id' call_function='kur_ekle_f_hesapla;change_currency_info' width='285'  selected_value='#get_action_detail.action_to_account_id[2]#' is_upd='1' line_info='2'>
                                    </div> 
                                </div>
                                <cfif session.ep.isBranchAuthorization eq 0>
                                    <div class="form-group" id="item-branch_id_alacak">
                                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',2726)#​</cfoutput></label>
                                        <div class="col col-8 col-xs-12">
                                            <cf_wrkDepartmentBranch fieldId='branch_id_alacak' is_branch='1' width='150' is_default='1' is_deny_control='1' selected_value='#get_action_detail.from_branch_id#'>
                                        </div> 
                                    </div>
                                
                                    <div class="form-group" id="item-branch_id_borc">
                                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',2727)#​</cfoutput></label>
                                        <div class="col col-8 col-xs-12">
                                            <cf_wrkDepartmentBranch fieldId='branch_id_borc' is_branch='1' width='150' is_default='1' is_deny_control='1' selected_value='#get_action_detail.to_branch_id[2]#'>
                                        </div> 
                                    </div>
                                </cfif>
                                <div class="form-group" id="item-project_id">
                                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',4)#</cfoutput></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                             <cfoutput>
                                                <input type="hidden"  name="project_id" id="project_id" value="#get_action_detail.project_id#"/>
                                                <input type="text" style="width:150px" name="project_head" id="project_head" value="#get_action_detail.project_head#" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','148');" autocomplete="off" />
                                            </cfoutput>
                                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_cash_to_cash.project_id&project_head=add_cash_to_cash.project_head');"></span>
                                        </div>
                                    </div> 
                                </div>
                                <div class="form-group" id="item-paper_number">
                                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',468)#</cfoutput></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="paper_number" value="#get_action_detail.paper_no#" style="width:150px;">
                                    </div> 
                                </div>
                                <div class="form-group" id="item-ACTION_DATE">
                                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',330)#</cfoutput>*</label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz !'></cfsavecontent>
											<cfinput name="ACTION_DATE" type="text" value="#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" style="width:150px;" onBlur="change_money_info('upd_virman','ACTION_DATE');"> 
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="ACTION_DATE" call_function="change_money_info" control_date="#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#"></span>
                                        </div>
                                    </div> 
                                </div>
                                <div class="form-group" id="item-ACTION_VALUE">
                                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',261)#</cfoutput>*</label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="message1"><cf_get_lang no='83.Miktar Giriniz!'></cfsavecontent>
                                        <cfinput type="text" name="ACTION_VALUE" value="#TLFormat(get_action_detail.ACTION_VALUE-get_action_detail.MASRAF)#" required="yes" message="#message1#" class="moneybox" style="width:150px;" onBlur="kur_ekle_f_hesapla('from_account_id');" onkeyup="return(FormatCurrency(this,event));">
                                    </div> 
                                </div>
                                <div class="form-group" id="item-OTHER_CASH_ACT_VALUE">
                                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',644)#</cfoutput></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" name="OTHER_CASH_ACT_VALUE" value="#TLFormat(get_action_detail.OTHER_CASH_ACT_VALUE)#" style="width:150px;" class="moneybox" onBlur="kur_ekle_f_hesapla('from_account_id',true);" onkeyup="return(FormatCurrency(this,event));">
                                    </div> 
                                </div>
                                <div class="form-group" id="item-ACTION_DETAIL">
                                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',217)#</cfoutput></label>
                                    <div class="col col-8 col-xs-12">
                                       <textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px;height:50px;"><cfoutput>#get_action_detail.ACTION_DETAIL#</cfoutput></textarea>
                                    </div> 
                                </div>
                                <div class="form-group" id="item-masraf_baslik">
                                	<label class="col col-12 bold"><cfoutput>#getLang('main',1518)#​</cfoutput></label>
                                </div>
                                <div class="form-group" id="item-masraf">
                                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',261)#</cfoutput></label>
                                    <div class="col col-8 col-xs-12">
                                       <cfif get_action_detail.MASRAF gt 0>
                                            <cfinput type="text" name="masraf" class="moneybox" style="width:150px;" value="#TLFormat(get_action_detail.MASRAF)#" onkeyup="return(FormatCurrency(this,event));">
                                       <cfelse>
                                            <cfinput type="text" name="masraf" class="moneybox" style="width:150px;" value="" onkeyup="return(FormatCurrency(this,event));">
                                       </cfif>
                                    </div> 
                                </div>
                                <div class="form-group" id="item-expense_center_id"> 
                                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1048)#</cfoutput></label>
                                    <div class="col col-8 col-xs-12">
                                        <cf_wrkExpenseCenter width_info="150" fieldId="expense_center_id" fieldName="expense_center_name" form_name="upd_virman" expense_center_id="#get_cost_with_expense_rows_id.expense_center_id#" img_info="plus_thin">
                                    </div> 
                                </div>
                                <div class="form-group" id="item-expense_item_id">
                                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',822)#</cfoutput></label>
                                    <div class="col col-8 col-xs-12">
                                        <cf_wrkExpenseItem width_info="150" fieldId="expense_item_id" fieldName="expense_item_name" form_name="upd_virman" income_type_info="0" expense_item_id="#get_cost_with_expense_rows_id.expense_item_id#" img_info="plus_thin">
                                    </div> 
                                </div>
                            </div>
                            <div class="col col-2 col-md-6 col-xs-12" type="column" index="2" sort="false">
                            	<div class="row" id="item-kur-ekle">
                                	<div class="col col-8 scrollContent scroll-x2">
                                        <label class="bold"><cf_get_lang no='53.İşlem Para Br'></label>
                                        <cfscript>f_kur_ekle(action_id:URL.ID,process_type:1,base_value:'ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'upd_virman',action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#',select_input:'from_account_id',is_disable='1');</cfscript>
                                   	</div>
                                </div>
                            </div>
                     </div>
                    <div class="row formContentFooter">
                    	<div class="col col-8">
                        	<cf_record_info query_name="get_action_detail">
                        </div>
                        <div class="col col-4">
                            <cfif listgetat(attributes.fuseaction,2,'.') is 'popup_upd_virman'>
								<cfset url_link = "&is_popup=1">
                            <cfelse>
                                <cfset url_link = "">
                            </cfif>
                            <cf_workcube_buttons 
                                is_upd='1'
                                del_function_for_submit='del_kontrol()'  
                                update_status='#get_action_detail.UPD_STATUS#'
                                delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_virman&ids=#attributes.id#,#attributes.id+1#&head=#get_action_detail.paper_no#&old_process_type=#get_action_detail.action_type_id##url_link#'
                                add_function='kontrol()'>
                        </div>
                    </div>
       			</div>
            </div>
        </div>
	</cfform>
<script type="text/javascript">
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
	function del_kontrol()
	{
		control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
		if(!chk_period(document.upd_virman.ACTION_DATE, 'İşlem')) return false;
		else return true;
	}
	function kontrol()
	{
		control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
		if(!chk_period(document.upd_virman.ACTION_DATE, 'İşlem')) return false;
		if(!chk_process_cat('upd_virman')) return false;
		if(!check_display_files('upd_virman')) return false;
		kur_ekle_f_hesapla('from_account_id');//dövizli tutarı silinenler için
		if(document.upd_virman.from_account_id.value == document.upd_virman.to_account_id.value)				
		{
			alert("<cf_get_lang no='94.Seçtiğiniz Banka Hesapları Aynı !'>");		
			return false; 
		}
		if(document.upd_virman.masraf.value != "" && document.upd_virman.masraf.value != 0)
		{
			if(document.upd_virman.expense_item_id.value == "" || document.upd_virman.expense_item_name.value == "")
			{
				alert("<cf_get_lang no='219.Gider Kalemi Seçiniz!'>");
				return false;
			}
			if(document.upd_virman.expense_center_id.value == "" || document.upd_virman.expense_center_name.value == "")
			{
				alert("<cf_get_lang no='220.Masraf Merkezi Seçiniz!'>");
				return false;
			}
		}
         if(document.getElementById('ACTION_VALUE').value == '0,00')
        {
            alert("<cf_get_lang_main no='261.Tutar Girmelisiniz!'> Girmelisiniz!");
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
                var currency_type = eval('document.upd_virman.'+select_input+'.options[document.upd_virman.'+select_input+'.selectedIndex]').value;
            
            var other_money_value_eleman= eval('document.upd_virman.OTHER_CASH_ACT_VALUE');
            var temp_act,temp_base_act,rate1_eleman,rate2_eleman;
            if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
            {
                other_money_value_eleman.value = '';
                return false;
            }
            if(!doviz_tutar && eval('document.upd_virman.ACTION_VALUE.value') != "" && currency_type != "")
            {
                if(document.getElementById('currency_id') != undefined)
                    currency_type = document.getElementById('currency_id').value;
                else
                    currency_type = list_getat(currency_type,2,';');
                for(var i=1;i<=document.upd_virman.kur_say.value;i++)
                {
                    rate1_eleman = filterNum(eval('document.upd_virman.txt_rate1_' + i).value,rate_round_num);
                    rate2_eleman = filterNum(eval('document.upd_virman.txt_rate2_' + i).value,rate_round_num);
                    if( eval('document.upd_virman.hidden_rd_money_'+i).value == currency_type)
                    {
                        temp_act=filterNum(document.upd_virman.ACTION_VALUE.value)*rate2_eleman/rate1_eleman;
                        document.upd_virman.system_amount.value = commaSplit(temp_act,rate_round_num);
                    }
                }
                if(document.upd_virman.kur_say.value == 1)
                {
                    for(var i=1;i<=document.upd_virman.kur_say.value;i++)
                    {
                        rate1_eleman = filterNum(eval('document.upd_virman.txt_rate1_' + i).value,rate_round_num);
                        rate2_eleman = filterNum(eval('document.upd_virman.txt_rate2_' + i).value,rate_round_num);
                        if( eval('document.upd_virman.rd_money.checked'))
                        {
                            if(eval('document.upd_virman.hidden_rd_money_'+i).value == currency_type)
                                other_money_value_eleman.value = commaSplit(filterNum(document.upd_virman.ACTION_VALUE.value));
                            else
                                other_money_value_eleman.value = commaSplit(filterNum(document.upd_virman.system_amount.value,4)*(rate1_eleman/rate2_eleman));
                            document.upd_virman.money_type.value = eval('document.upd_virman.hidden_rd_money_'+i).value;
                            document.upd_virman.system_amount.value = commaSplit(filterNum(document.upd_virman.system_amount.value),rate_round_num);
                        }
                    }
                }
                else
                {
                    for(var i=1;i<=document.upd_virman.kur_say.value;i++)
                    {
                        rate1_eleman = filterNum(eval('document.upd_virman.txt_rate1_' + i).value,rate_round_num);
                        rate2_eleman = filterNum(eval('document.upd_virman.txt_rate2_' + i).value,rate_round_num);
                        if( eval('document.upd_virman.rd_money['+(i-1)+'].checked'))
                        {
                            if(eval('document.upd_virman.hidden_rd_money_'+i).value == currency_type)
                                other_money_value_eleman.value = commaSplit(filterNum(document.upd_virman.ACTION_VALUE.value));
                            else
                                other_money_value_eleman.value = commaSplit(filterNum(document.upd_virman.system_amount.value,4)*(rate1_eleman/rate2_eleman));
                            document.upd_virman.money_type.value = eval('document.upd_virman.hidden_rd_money_'+i).value;
                            document.upd_virman.system_amount.value = commaSplit(filterNum(document.upd_virman.system_amount.value),rate_round_num);
                        }
                    }
                }
            }
            else if(doviz_tutar && document.upd_virman.ACTION_VALUE.value != "" && currency_type != "")
            {
                for(var i=1;i<=document.upd_virman.kur_say.value;i++)
                    if( eval('document.upd_virman.rd_money['+(i-1)+'].checked'))
                    {
                        rate1_eleman = filterNum(eval('document.upd_virman.txt_rate1_' + i).value,rate_round_num);
                        if(document.getElementById('currency_id') != undefined)
                            currency_type = document.getElementById('currency_id').value;
                        else
                            currency_type = list_getat(currency_type,2,';');
                        if (eval('document.upd_virman.hidden_rd_money_'+i).value != 'TL')//hesap TL olmayıp,kurdan TL seçilip,döviz inputu edit edilirse TL kurunu değiştirmesn diye
                            eval('document.upd_virman.txt_rate2_' + i).value = commaSplit(filterNum(document.upd_virman.system_amount.value)/filterNum(other_money_value_eleman.value)*rate1_eleman,rate_round_num);
                        else
                            for(var t=1;t<=upd_virman.kur_say.value;t++)//hesap TL olmayıp,kurdan TL seçilip,döviz inputu edit edilirse TL kurunu değiştirmesn,hesabın kurunu değiştirsn diye
                                if( eval('document.upd_virman.hidden_rd_money_'+t).value == currency_type && eval('document.upd_virman.hidden_rd_money_'+t).value != 'TL')
                                    eval('document.upd_virman.txt_rate2_' + t).value = commaSplit(filterNum(other_money_value_eleman.value)/filterNum(upd_virman.ACTION_VALUE.value)*rate1_eleman,rate_round_num);
                        if (eval('document.upd_virman.hidden_rd_money_'+i).value != 'TL')
                            for(var k=1;k<=document.upd_virman.kur_say.value;k++)
                            {
                                rate1_eleman = filterNum(eval('document.upd_virman.txt_rate1_' + k).value,rate_round_num);
                                rate2_eleman = filterNum(eval('document.upd_virman.txt_rate2_' + k).value,rate_round_num);
                                if( eval('document.upd_virman.hidden_rd_money_'+k).value == currency_type)
                                {
                                    temp_act=filterNum(document.upd_virman.ACTION_VALUE.value)*(rate2_eleman/rate1_eleman);
                                    document.upd_virman.system_amount.value = commaSplit(temp_act,rate_round_num);
                                }
                            }
                        else
                            document.upd_virman.system_amount.value = other_money_value_eleman.value;
                    }
                    return true;
                }
            
                document.upd_virman.ACTION_VALUE.value = commaSplit(filterNum(document.upd_virman.ACTION_VALUE.value));
            
            return true;
        }
        else
        {
            if(document.upd_virman.kur_say.value == 1)
            {
                for(var i=1;i<=document.upd_virman.kur_say.value;i++)
                    if( eval('document.upd_virman.rd_money.checked'))
                        document.upd_virman.money_type.value = eval('document.upd_virman.hidden_rd_money_'+i).value;
            }
            else
            {
                for(var i=1;i<=document.upd_virman.kur_say.value;i++)
                    if( eval('document.upd_virman.rd_money['+(i-1)+'].checked'))
                        document.upd_virman.money_type.value = eval('document.upd_virman.hidden_rd_money_'+i).value;
            }	
        }
    }
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

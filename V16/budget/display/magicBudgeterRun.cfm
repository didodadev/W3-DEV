<cfset wizard = createObject("component", "V16.budget.cfc.MagicBudgeter")>
<cfset get_wizard = wizard.det_wizard2( wizard_id : attributes.wizard_id )>
<cfset get_prev = wizard.get_prev_cards( wizard_id : attributes.wizard_id )>

<cfparam name = "attributes.start_date" default = "01#dateformat(now(),'/mm/yyyy')#">
<cfparam name = "attributes.finish_date" default = "#daysinmonth(now())##dateformat(now(),'/mm/yyyy')#">
<cfparam name = "attributes.action_date" default = "#dateformat(now(),'dd/mm/yyyy')#">

<cf_date tarih = "attributes.start_date">
<cf_date tarih = "attributes.finish_date">
<cf_date tarih = "attributes.action_date">

<cfquery name = "get_blocks" dbtype = "query">
    SELECT DISTINCT WIZARD_BLOCK_ID FROM get_wizard
</cfquery>

<cfsavecontent variable="title"><cf_get_lang dictionary_id="60726.Sihirbaz"> : <cfoutput>#get_wizard.wizard_name#</cfoutput></cfsavecontent>
<cf_box title="#title#" closable="0">

    <cfform name = "run_wizard" id = "run_wizard" method = "post">
        <cf_box_elements vertical="1">
        <input type = "hidden" name = "run_submitted" id = "run_submitted" value = "1">
        <input type = "hidden" name = "save_submitted" id = "save_submitted" value = "0">
        <input type = "hidden" name = "is_manual" id = "is_manual" value = "0">
            <div class="col col-4">
                <div class="form-group" id="item-start_date">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                    <div class="col col-4 col-xs-12">
                        <div class="input-group">
                            <input type="text" name="start_date" id="start_date" maxlength="10" value = "<cfoutput>#dateformat(attributes.start_date, dateformat_style)#</cfoutput>">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-finish_date">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                    <div class="col col-4 col-xs-12">
                        <div class="input-group">
                            <input type="text" name="finish_date" id="finish_date" maxlength="10" value = "<cfoutput>#dateformat(attributes.finish_date, dateformat_style)#</cfoutput>">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-action_date">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
                    <div class="col col-4 col-xs-12">
                        <div class="input-group">
                            <input type="text" name="action_date" id="action_date" maxlength="10" value = "<cfoutput>#dateformat(attributes.action_date, dateformat_style)#</cfoutput>">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="action_date"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-target_type">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
                    <div class="col col-4 col-xs-12">
                        <cf_workcube_process_cat>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-12">
                <input type = "button" value = "<cf_get_lang dictionary_id='57911.Çalıştır'>" onClick = "submit();">
                <cfif isDefined('attributes.run_submitted') and attributes.run_submitted eq 1>
                    <input type = "button" value = "<cf_get_lang dictionary_id='57461.Kaydet'>" onClick = "save_card();">
                </cfif>
            </div>
        </cf_box_footer>
    </cfform>

    <script type = "text/javascript">
        function save_card() {
                $("#save_submitted").val(1);
                $("#is_manual").val(1);
                $("#run_wizard").submit();
            return true;
        }
    </script>

    <div class="col col-12">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="10">#</th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                    <th width="20"><a href="javascript:void(0)"><i class="fa fa-pencil"></i></a></th>
                    <th width="20"><a href="javascript:void(0)"><i class="fa fa-trash"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_prev.recordcount>
                    <cfoutput query="get_prev">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#dateformat(EXPENSE_DATE,dateformat_style)#</td>
                            <td>#detail#</td>
                            <td>
                                <cfif IS_INCOME eq 1>
                                    <a href="#request.self#?fuseaction=budget.budget_income_summery&search_date1=#dateformat(EXPENSE_DATE,dateformat_style)#&search_date2=#dateformat(EXPENSE_DATE,dateformat_style)#&form_submitted=1" target="_blank">
                                        <i class="fa fa-pencil" title=""></i>
                                    </a>
                                <cfelse>
                                    <a href="#request.self#?fuseaction=cost.list_expense_management&search_date1=#dateformat(EXPENSE_DATE,dateformat_style)#&search_date2=#dateformat(EXPENSE_DATE,dateformat_style)#&form_exist=1" target="_blank">
                                        <i class="fa fa-pencil" title=""></i>
                                    </a>
                                </cfif>
                            </td>
                            <td style="text-align:center;"><i class="fa fa-trash" onclick="delBg(#WIZARD_ID#,#EXP_ITEM_ROWS_ID#)"></i></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan = "5"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    </div>

    <div class="col col-12">
        <cfif isDefined('attributes.run_submitted') and attributes.run_submitted eq 1>
            <cfset del_rel = wizard.del_empty_relations()>

            <cfset borc_hesap_list = borc_tutar_list = alacak_hesap_list = alacak_tutar_list = borc_exp_item = alacak_exp_item =  '' >
            <cfset fis_satir_detay = []>
            <cfset fis_satir_detay[1] = []>
            <cfset fis_satir_detay[2] = []>
            
            <cfloop from = "1" to = "#get_blocks.recordcount#" index = "b">
                <cfquery name="get_block" dbtype="query">
                    SELECT * FROM get_wizard WHERE WIZARD_BLOCK_ID = #get_blocks.wizard_block_id[b]# ORDER BY BLOCK_COLUMN
                </cfquery>

                <cfset total_block1_bakiye = total_block3_bakiye = 0 >
                <cfset first_hesap_list = first_tutar_list = second_hesap_list = second_tutar_list = first_exp_list = second_exp_list = '' >
                <cfset first_detay_list = second_detay_list = [] >
                <cfset first_toplam = second_toplam = 0 >

                <cfoutput query="get_block">
                    <cfif block_column eq 1>
                        <cfquery name="get_balance" datasource="#dsn2#">
                            SELECT
                                EIR.EXPENSE_CENTER_ID,
                                ISNULL(SUM(EIR.AMOUNT * (1 - 2 * EIR.IS_INCOME)),0) AS ACC_BALANCE
                            FROM
                                EXPENSE_ITEMS_ROWS AS EIR
                            WHERE
                                1 = 1
                                <cfif isDefined('attributes.start_date') and len(attributes.start_date)>
                                    AND EIR.EXPENSE_DATE >= #attributes.start_date#
                                </cfif>
                                <cfif isDefined('attributes.finish_date') and len(attributes.finish_date)>
                                    AND EIR.EXPENSE_DATE <= #attributes.finish_date#
                                </cfif>
                                <cfif len(get_block.ACTIVITY_TYPE[currentRow])>
                                    AND EIR.ACTIVITY_TYPE = #get_block.ACTIVITY_TYPE[currentRow]#
                                </cfif>
                                <cfif len(get_block.EXP_ITEM[currentRow])>
                                    AND EIR.EXPENSE_ITEM_ID = #get_block.EXP_ITEM[currentRow]#
                                </cfif>
                                    AND EIR.EXPENSE_CENTER_ID = #EXP_CENTER#
                            GROUP BY
                                EIR.EXPENSE_CENTER_ID
                        </cfquery>
                    </cfif>
                    
                    <cfset acc_balance = ( len(get_balance.acc_balance) ) ? get_balance.acc_balance : 0>

                    <cfswitch expression="#block_column#">
                        <cfcase value="1">
                            <cfset this_bakiye = acc_balance * (rate/100) >
                            <cfif this_bakiye gt 0 >
                                <cfset this_borc = 0 >
                                <cfset this_alacak = acc_balance * (rate/100) >
                            <cfelse>
                                <cfset this_borc = acc_balance * (rate/100) * -1 >
                                <cfset this_alacak = 0 >
                            </cfif>
                            <cfset total_block1_bakiye = total_block1_bakiye + this_bakiye >
                        </cfcase>
                        <cfcase value="2">
                            <cfif total_block1_bakiye gt 0>
                                <cfset this_borc = total_block1_bakiye * (rate/100) >
                                <cfset this_alacak = 0 >
                            <cfelse>
                                <cfset this_borc = 0 >
                                <cfset this_alacak = total_block1_bakiye * (rate/100) * -1 >
                            </cfif>
                        </cfcase>
                        <cfdefaultcase>
                            <cfset this_borc = this_alacak = 0 >
                        </cfdefaultcase>
                    </cfswitch>

                    <cfset this_borc = numberFormat(this_borc,'9.99')>
                    <cfset this_alacak = numberFormat(this_alacak,'9.99')>
                        
                    <cfif this_borc gt 0 >
                        <cfset first_tutar_list = listAppend(first_tutar_list, this_borc)>
                        <cfset first_hesap_list = listAppend(first_hesap_list, exp_center)>
                        <cfset first_exp_list = listAppend(first_exp_list, exp_item)> 
						<cfset first_detay_list[arrayLen(first_detay_list) + 1] = '#block_name# - #description#'>
                        <cfset first_toplam = first_toplam + this_borc>
                    </cfif>
                    
                    <cfif this_alacak gt 0 >
                        <cfset second_tutar_list = listAppend(second_tutar_list, this_alacak)>
                        <cfset second_hesap_list = listAppend(second_hesap_list, exp_center)> 
                        <cfset second_exp_list = listAppend(second_exp_list, exp_item)> 
						<cfset second_detay_list[arrayLen(second_detay_list) + 1] = '#block_name# - #description#'>
                        <cfset second_toplam = second_toplam + this_alacak>
                    </cfif>

                    <cfswitch expression="#block_income#">
                        <cfcase value="0">
                            <cfset reverse_type = ( total_block1_bakiye gt 0 ) ? 1 : 0 >
                        </cfcase>
                        <cfcase value="1">
                            <cfset reverse_type = ( total_block1_bakiye gt 0 ) ? 0 : 1 >
                        </cfcase>
                    </cfswitch>

                </cfoutput>
                    <cfif reverse_type eq 1>
                        <cfset borc_hesap_list = listAppend(borc_hesap_list, first_hesap_list)>
                        <cfset borc_tutar_list = listAppend(borc_tutar_list, first_tutar_list)>
                        <cfset alacak_hesap_list = listAppend(alacak_hesap_list, second_hesap_list)>
                        <cfset alacak_tutar_list = listAppend(alacak_tutar_list, second_tutar_list)>
                        <cfset borc_exp_item = listAppend(borc_exp_item, first_exp_list)>
                        <cfset alacak_exp_item = listAppend(alacak_exp_item, second_exp_list)>
                        <cfscript>
                            for(f = 1; f lte arrayLen(first_detay_list); f++ ) {
                                fis_satir_detay[1][arrayLen(fis_satir_detay[1]) + 1] = first_detay_list[f];
                            }
                            for(f = 1; f lte arrayLen(second_detay_list); f++ ) {
                                fis_satir_detay[2][arrayLen(fis_satir_detay[2]) + 1] = second_detay_list[f];
                            }
                        </cfscript>
                    <cfelse>
                        <cfset borc_hesap_list = listAppend(borc_hesap_list, second_hesap_list)>
                        <cfset borc_tutar_list = listAppend(borc_tutar_list, second_tutar_list)>
                        <cfset alacak_hesap_list = listAppend(alacak_hesap_list, first_hesap_list)>
                        <cfset alacak_tutar_list = listAppend(alacak_tutar_list, first_tutar_list)>
                        <cfset borc_exp_item = listAppend(borc_exp_item, second_exp_list)>
                        <cfset alacak_exp_item = listAppend(alacak_exp_item, first_exp_list)>
                        <cfscript>
                            for(f = 1; f lte arrayLen(second_detay_list); f++ ) {
                                fis_satir_detay[1][arrayLen(fis_satir_detay[1]) + 1] = second_detay_list[f];
                            }
                            for(f = 1; f lte arrayLen(first_detay_list); f++ ) {
                                fis_satir_detay[2][arrayLen(fis_satir_detay[2]) + 1] = first_detay_list[f];
                            }
                        </cfscript>
                    </cfif>

            </cfloop>

                <cfset total_borc = total_alacak = 0 >
                <cfscript>
					for( b = 1; b lte listLen(borc_tutar_list); b++ ) {
						total_borc = total_borc + listGetAt(borc_tutar_list, b);
					}
					for( a = 1; a lte listLen(alacak_tutar_list); a++ ) {
						total_alacak = total_alacak + listGetAt(alacak_tutar_list, a);
					}

					round_diff = total_borc - total_alacak;

					if(round_diff gt 0) {
						listSetAt(borc_tutar_list, listLen(borc_tutar_list), listLast(borc_tutar_list) - round_diff);
                    }
                </cfscript>
            <cfif listlen(listAppend(borc_hesap_list,alacak_hesap_list))>
                <cfquery name="get_acc_names" datasource = "#dsn2#">
                    SELECT EXPENSE, EXPENSE_ID FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#listAppend(borc_hesap_list,alacak_hesap_list)#)
                </cfquery>
            </cfif>
            <cfif listlen(listAppend(borc_exp_item,alacak_exp_item))>
                <cfquery name="get_exp_names" datasource = "#dsn2#">
                    SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#listAppend(borc_exp_item,alacak_exp_item)#)
                </cfquery>
            </cfif>
            
            <cfoutput>
                <cf_grid_list>
                    <cfset borc_toplam = 0>
                    <cfset alacak_toplam = 0>
                    <thead>
                        <tr>
                            <th><cf_get_lang dictionary_id='58678.Gider'><cf_get_lang dictionary_id='57652.Hesap'>(<cf_get_lang dictionary_id='58460.Masraf Merkezi'> - <cf_get_lang dictionary_id='58234.Bütçe Kalemi'> - <cf_get_lang dictionary_id='31172.Aktivite Tipi'> )</th>
                            <th><cf_get_lang dictionary_id='58677.Gelir'><cf_get_lang dictionary_id='57652.Hesap'>(<cf_get_lang dictionary_id='58460.Masraf Merkezi'> - <cf_get_lang dictionary_id='58234.Bütçe Kalemi'> - <cf_get_lang dictionary_id='31172.Aktivite Tipi'> )</th>
                            <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                            <th style = "text-align:right;"><cf_get_lang dictionary_id='58678.Gider'><cf_get_lang dictionary_id='57673.Tutar'></th>
                            <th style = "text-align:right;"><cf_get_lang dictionary_id='58677.Gelir'><cf_get_lang dictionary_id='57673.Tutar'></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfloop from = "1" to = "#listlen(borc_hesap_list)#" index = "b">
                            <cfset borc_toplam = borc_toplam + listGetAt(borc_tutar_list,b)>
                            <tr>
                                <cfquery name="get_this_acc" dbtype = "query">
                                    SELECT * FROM get_acc_names WHERE EXPENSE_ID = '#listGetAt(borc_hesap_list,b)#'
                                </cfquery>
                                <cfquery name="get_this_exp" dbtype = "query">
                                    SELECT * FROM get_exp_names WHERE EXPENSE_ITEM_ID = '#listGetAt(borc_exp_item,b)#'
                                </cfquery>
                                <td>#get_this_acc.EXPENSE# - #get_this_exp.EXPENSE_ITEM_NAME#</td>
                                <td></td>
                                <td>#fis_satir_detay[1][b]#</td>
                                <td style = "text-align:right;">#TLFormat(listGetAt(borc_tutar_list,b))# #session.ep.money#</td>
                                <td style = "text-align:right;"></td>
                            </tr>
                        </cfloop>
                        <cfloop from = "1" to = "#listlen(alacak_hesap_list)#" index = "a">
                            <cfset alacak_toplam = alacak_toplam + listGetAt(alacak_tutar_list,a)>
                            <tr>
                                <cfquery name = "get_this_acc" dbtype = "query">
                                    SELECT * FROM get_acc_names WHERE EXPENSE_ID = '#listGetAt(alacak_hesap_list,a)#'
                                </cfquery>
                                <cfquery name="get_this_exp" dbtype = "query">
                                    SELECT * FROM get_exp_names WHERE EXPENSE_ITEM_ID = '#listGetAt(alacak_exp_item,a)#'
                                </cfquery>
                                <td></td>
                                <td>#get_this_acc.EXPENSE# - #get_this_exp.EXPENSE_ITEM_NAME#</td>
                                <td>#fis_satir_detay[2][a]#</td>
                                <td style = "text-align:right;"></td>
                                <td style = "text-align:right;">#TLFormat(listGetAt(alacak_tutar_list,a))# #session.ep.money#</td>
                            </tr>
                        </cfloop>
                    </tbody>
                        <tr>
                            <td colspan = "3" style = "text-align:right;"><strong><cf_get_lang dictionary_id='57492.Toplam'>:</strong></td>
                            <td style = "text-align:right;"><strong>#TLFormat(borc_toplam)# #session.ep.money#</strong></td>
                            <td style = "text-align:right;"><strong>#TLFormat(alacak_toplam)# #session.ep.money#</strong></td>
                        </tr>
                </cf_grid_list>
            </cfoutput>
        </cfif>
    </div>

    <cfif isDefined('attributes.save_submitted') and attributes.save_submitted eq 1>
        <cfset round_amount = first_toplam - second_toplam>
		<cfif get_block.block_income eq 1>
			<cfset alacak_tutar_list = listSetAt(alacak_tutar_list, listLen(alacak_tutar_list), listLast(alacak_tutar_list) + round_amount) >
        <cfelse>
			<cfset borc_tutar_list = listSetAt(borc_tutar_list, listLen(borc_tutar_list), listLast(borc_tutar_list) - round_amount) >
        </cfif>

        <cfloop from="1" to="#listlen(borc_hesap_list)#" index="b">
            <cfset butce_id = butceci(
                                        action_id : get_wizard.wizard_id,
                                        action_table : 'BUDGET_WIZARD_RELATION',
                                        is_income_expense : false,
                                        process_type : 162, 
                                        nettotal : listGetAt(borc_tutar_list,b),
                                        other_money_value : listGetAt(borc_tutar_list,b),
                                        action_currency : session.ep.money,
                                        expense_date : attributes.action_date,
                                        expense_center_id : listGetAt(borc_hesap_list,b),
                                        expense_item_id : listGetAt(borc_exp_item,b),
                                        detail : "#dateformat(attributes.start_date,'dd/mm/yyyy')# - #dateformat(attributes.finish_date,'dd/mm/yyyy')# #get_wizard.wizard_name# (bütçe transfer işlemi)",
                                        branch_id : listgetat(session.ep.user_location,2,'-'),
                                        insert_type : 1
                                    )>
            <cfif butce_id>
                <cfquery name="GET_EXP" datasource = "#dsn2#">
                    SELECT max(EXP_ITEM_ROWS_ID) AS EXP_ITEM_ROWS_ID FROM EXPENSE_ITEMS_ROWS
                </cfquery>
                <cfquery name="save_relation" datasource="#dsn#">
                    INSERT INTO
                        BUDGET_WIZARD_RELATION
                    (
                        WIZARD_ID,
                        EXP_ITEM_ROWS_ID,
                        PERIOD_ID,
                        IS_MANUAL,
                        RECORD_DATE,
                        IS_INCOME
                    ) 
                    VALUES (
                        #get_wizard.wizard_id#,
                        #GET_EXP.EXP_ITEM_ROWS_ID#,
                        #session.ep.period_id#,
                        #attributes.is_manual#,
                        #now()#,
                        0
                    )
                </cfquery>
            </cfif>
        </cfloop>
        
        <cfloop from="1" to="#listlen(alacak_hesap_list)#" index="a">
            <cfset butce_id = butceci(
                                        action_id : get_wizard.wizard_id,
                                        action_table : 'BUDGET_WIZARD_RELATION',
                                        is_income_expense : true,
                                        process_type : 162, 
                                        nettotal : listGetAt(alacak_tutar_list,a),
                                        other_money_value : listGetAt(alacak_tutar_list,a),
                                        action_currency : session.ep.money,
                                        expense_date : attributes.action_date,
                                        expense_center_id : listGetAt(alacak_hesap_list,a),
                                        expense_item_id : listGetAt(alacak_exp_item,a),
                                        detail : "#dateformat(attributes.start_date,'dd/mm/yyyy')# - #dateformat(attributes.finish_date,'dd/mm/yyyy')# #get_wizard.wizard_name# (bütçe transfer işlemi)",
                                        branch_id : listgetat(session.ep.user_location,2,'-'),
                                        insert_type : 1
                                    )>

            <cfif butce_id>
                <cfquery name="GET_EXP" datasource = "#dsn2#">
                    SELECT max(EXP_ITEM_ROWS_ID) AS EXP_ITEM_ROWS_ID FROM EXPENSE_ITEMS_ROWS
                </cfquery>
                <cfquery name="save_relation" datasource="#dsn#">
                    INSERT INTO
                        BUDGET_WIZARD_RELATION
                    (
                        WIZARD_ID,
                        EXP_ITEM_ROWS_ID,
                        PERIOD_ID,
                        IS_MANUAL,
                        RECORD_DATE,
                        IS_INCOME
                    ) 
                    VALUES (
                        #get_wizard.wizard_id#,
                        #GET_EXP.EXP_ITEM_ROWS_ID#,
                        #session.ep.period_id#,
                        #attributes.is_manual#,
                        #now()#,
                        1
                    )
                </cfquery>
            </cfif>
        </cfloop>
        <script type = "text/javascript">
            alert('Transfer işlemi gerçekleştirildi');
            window.location.href = "<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&wizard_id=#get_wizard.wizard_id#</cfoutput>";
        </script>
    </cfif>

</cf_box>
<script>
    function delBg(wizard_id, exp_item_rows_id){
        if( confirm("<cf_get_lang dictionary_id='48604.Silmek istediğinize emin misiniz ?'>") )
        {
            $.ajax({ 
                type:"get",
                dataType: 'json',
                url:'/V16/budget/cfc/MagicBudgeter.cfc?method=del_budget_transfer',
                data: { 
                    action_id : wizard_id,
                    exp_item_rows_id : exp_item_rows_id
                },
                success: function(returnData){
                    if(returnData){
                        alert("<cf_get_lang dictionary_id='44003.İşlem Başarılı'>");
                        location.reload();
                    }
                    else{
                        alert("<cf_get_lang dictionary_id='29917.Hata oluştu'>");
                        return false;
                    }
                }
            });
        }
        return false;
    }

</script>
<cfif (not session.ep.ehesap)>
	<cfinclude template="../query/get_emp_branches.cfm">
</cfif>
<cf_xml_page_edit fuseact="ehesap.popup_form_upd_kesinti_hr">
<cfparam name="attributes.related_year" default="#year(now())#">
<cfset periods = createObject('component','V16.objects.cfc.periods')>
<cfset cmp_process = createObject('component','V16.workdata.get_process')>
<cfset get_process_stage = cmp_process.GET_PROCESS_TYPES(faction_list : 'ehesap.popup_form_upd_odenek_hr')>
<cfset period_years = periods.get_period_year()>
<cfquery name="get_ch_types" datasource="#dsn#">
	SELECT * FROM SETUP_ACC_TYPE ORDER BY ACC_TYPE_NAME
</cfquery>
<cfquery name="GET_DET" datasource="#dsn#">
	SELECT
		SG.*,
        EIO.BRANCH_ID
	FROM
		SALARYPARAM_GET SG LEFT JOIN EMPLOYEES_IN_OUT EIO ON SG.IN_OUT_ID = EIO.IN_OUT_ID
	WHERE
		SG.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		AND SG.TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_year#">
		AND SG.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
	ORDER BY
		SG.TERM,
		SG.START_SAL_MON,
		SG.AMOUNT_GET
</cfquery>
<cfif get_det.recordcount>
	<cfif (not session.ep.ehesap) and (not listFind(emp_branch_list, GET_DET.branch_id))>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !");
			history.back();
		</script>
		<!--- yetki dışı kullanım için mail şablonu hazırlanmalı erk 20030911--->
		<cfabort>
	</cfif>
</cfif>
<cfquery name="GET_IN_OUT_PERIODS" datasource="#DSN#">
	SELECT
		ACCOUNT_CODE
	FROM
		EMPLOYEES_IN_OUT_PERIOD
	WHERE
		IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
</cfquery>

<cf_box title="#getLang('','Kesinti Tanımları',53273)# #get_emp_info(attributes.employee_id,0,0)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_form" id="search_form" method="post" action="#request.self#?fuseaction=ehesap.popup_form_upd_kesinti_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#">
		<cf_box_search more="0">
			<div class="form-group">
				<select name="related_year" id="related_year">
					<cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
						<cfoutput>
							<option value="#i#"<cfif attributes.related_year eq i> selected</cfif>>#i#</option>
						</cfoutput>
					</cfloop>
				</select>
			</div>
			<div class="form-group">
				<!--- Ücret Odenek Ajaxından --->
				<cfif isdefined("attributes.from_upd_salary") and attributes.from_upd_salary eq 1>
					<input type="hidden" name="from_upd_salary" id="from_upd_salary" value="1">
					<cf_wrk_search_button button_type="4" search_function="ajax_function()">
				<cfelse>
					<cf_wrk_search_button button_type="4" search_function="loadPopupBox('search_form' ,  #attributes.modal_id#)">
				</cfif>
			</div>
			<div class="form-group">
				<a class="ui-btn ui-btn-gray" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=ehesap.popup_add_kesinti_taksitli&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#</cfoutput>')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='54036.Taksitlendirilmiş Avans'>"></i></a>
			</div>
		</cf_box_search>
	</cfform>
    <cfform name="form_basket" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_form_upd_kesinti_hr">
        <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.EMPLOYEE_ID#</cfoutput>">
        <input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#attributes.in_out_id#</cfoutput>">
        <input type="hidden" name="rowCount" id="rowCount" value="">
        <input type="hidden" name="sabitrowCount" id="sabitrowCount" value="<cfoutput>#get_det.recordcount#</cfoutput>">
		<cfif isdefined("attributes.from_upd_salary") and attributes.from_upd_salary eq 1>
			<input type="hidden" name="from_upd_salary" id="from_upd_salary" value="1">
		</cfif>
		<cfif isdefined("attributes.draggable") and attributes.draggable eq 1>
			<input type="hidden" name="draggable" id="draggable" value="1">
		</cfif>
        <cf_grid_list id="table_list">
            <thead>
                <tr>         
                    <th width="20"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_kesinti&draggable=1')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                    <th colspan="2"><cf_get_lang dictionary_id='53179.Bordro'>/ <cf_get_lang dictionary_id='58233.Tanım'></th>
                    <th><cf_get_lang dictionary_id='53234.Maaş'></th>
                    <th><cf_get_lang dictionary_id='53310.Periyod'></th>
                    <th><cf_get_lang dictionary_id='29472.Yöntem'></th>
                    <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                    <th><cf_get_lang dictionary_id='58472.Dönem'></th>
                    <th><cf_get_lang dictionary_id='57501.Başlangıç'></th>
                    <th><cf_get_lang dictionary_id='57502.Bitiş'></th>
                    <th><cf_get_lang dictionary_id='53396.Rakam'></th>
                    <th></th>
                    <cfif is_show_account_code eq 1>
                        <th width="140"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
                    </cfif>
                    <cfif is_show_member eq 1>
                        <th width="140"><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
                    </cfif>
                    <cfif is_show_member_type eq 1>
                        <th width="140"><cf_get_lang dictionary_id="53329.Hesap Tipi"></th>
                    </cfif>
					<th><cf_get_lang dictionary_id ='58859.Süreç'></th>
                </tr>
            </thead>
            <cfoutput query="GET_DET" group="TERM">
                <tbody id="my_div_#term#">
                    <cfoutput>
                        <tr id="sabit_my_row_#currentrow#" title="<cfif len(record_date)>Kayıt : #get_emp_info(record_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#)</cfif>  <cfif len(update_date)> &nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id='57703.Güncelleme'> : #get_emp_info(update_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,update_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#)</cfif>">
                            <td>
                                <cfif (is_ehesap neq 1 or session.ep.ehesap) and not len(payment_id)>
                                    <a onClick="sabit_sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
                                <cfelseif len(payment_id) and payment_id neq 0>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.list_payment_requests&event=det&id=#payment_id#','small');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                </cfif>
                            </td>
                            <td width="50" nowrap="nowrap">
                                <input type="hidden" name="sabit_money#currentrow#" id="sabit_money#currentrow#" value="#money#">
                                <input type="hidden" name="spg_id#currentrow#" id="spg_id#currentrow#" value="#spg_id#">
                                <input type="hidden" name="sabit_row_kontrol_#currentrow#" id="sabit_row_kontrol_#currentrow#" value="1">
                                <input type="hidden" name="sabit_from_salary#currentrow#"  id="sabit_from_salary#currentrow#" value="<cfif len(from_salary)>#from_salary#<cfelse>0</cfif>">
                                <input type="hidden" name="sabit_period_get#currentrow#" id="sabit_period_get#currentrow#" value="#period_get#">
                                <input type="hidden" name="sabit_is_ehesap#currentrow#" id="sabit_is_ehesap#currentrow#" value="<cfif is_ehesap eq 1>1<cfelse>0</cfif>">
                                <input type="hidden" name="sabit_calc_days#currentrow#" id="sabit_calc_days#currentrow#" value="#calc_days#">
                                <input type="hidden" name="sabit_is_inst_avans#currentrow#" id="sabit_is_inst_avans#currentrow#" value="#is_inst_avans#">
                                <input type="hidden" name="sabit_total_get#currentrow#" id="sabit_total_get#currentrow#" value="#total_get#">
                                <input type="hidden" name="sabit_tax#currentrow#" id="sabit_tax#currentrow#" value="#tax#">
								<input type="hidden" name="sabit_is_net_to_gross#currentrow#" id="sabit_is_net_to_gross#currentrow#" value="#is_net_to_gross#">
                                <cfif show eq 1>
                                    <input type="hidden" name="sabit_show#currentrow#" id="sabit_show#currentrow#" value="1">
                                    <img border="0" src="/images/b_ok.gif" title="Bordroda Görüntülensin" align="absmiddle">
                                <cfelse>
                                    <input type="hidden" name="sabit_show#currentrow#" id="sabit_show#currentrow#" value="0">
                                </cfif>
                                <cfif is_inst_avans eq 1>
                                    <img border="0" src="/images/pos_credit.gif" title="<cf_get_lang dictionary_id='59674.Taksitlendirilmiş Toplam Borç Tutarı'> : #tlformat(total_get)# - Açıklama : #detail#" align="absmiddle">
                                </cfif>
                            </td>
                            <td width="170"><input type="text" name="sabit_comment_get#currentrow#" id="sabit_comment_get#currentrow#" style="width:130px;" value="#comment_get#" readonly></td>
                            <td width="100"><cfif from_salary eq 1><cf_get_lang dictionary_id='53397.Brüt Ücretden'><cfelseif from_salary eq 0><cf_get_lang dictionary_id='53398.Net Ücretden'></cfif></td>
                            <td><cfif period_get eq 1><cf_get_lang dictionary_id='53311.Ayda'><cfelseif period_get eq 2>3 <cf_get_lang dictionary_id='53311.Ayda'><cfelseif period_get eq 3>6 <cf_get_lang dictionary_id='53311.Ayda'><cfelseif period_get eq 4><cf_get_lang dictionary_id='53312.Yılda'></cfif></td>
                            <td width="55">
                                <input type="hidden" name="sabit_method_get#currentrow#" id="sabit_method_get#currentrow#" value="#method_get#" />
                                <cfif method_get eq 1>
                                    Eksi
                                <cfelseif method_get eq 2>
                                    % Ay
                                <cfelseif method_get eq 3>
                                    % Gün
                                <cfelseif method_get eq 4>
                                    % Saat
                                <cfelseif method_get eq 5>
                                    % Kazanç
                                </cfif>
                            </td>
                            <td><input type="text" name="sabit_detail#currentrow#" id="sabit_detail#currentrow#" value="#get_det.detail#"></td>
                            <td>
                                <select name="sabit_term#currentrow#" id="sabit_term#currentrow#">
									<cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="j">
                                        <option value="#j#" <cfif term eq j>selected</cfif>>#j#</option></cfloop>
                                </select>
                            </td>
                            <td>
                                <select name="sabit_start_sal_mon#currentrow#" id="sabit_start_sal_mon#currentrow#" style="70" onchange="change_mon('sabit_end_sal_mon#currentrow#',this.value);">
                                    <cfloop from="1" to="12" index="j">
                                        <option value="#j#"<cfif start_sal_mon eq j> selected</cfif>>#listgetat(ay_list(),j,',')#</option>
                                    </cfloop>
                                </select>
                            </td>
                            <td>
                                <select name="sabit_end_sal_mon#currentrow#" id="sabit_end_sal_mon#currentrow#" style="70">
                                    <cfloop from="1" to="12" index="j">
                                    <option value="#j#"<cfif end_sal_mon eq j> selected</cfif>>#listgetat(ay_list(),j,',')#</option>
                                    </cfloop>
                                </select>
                            </td>
                            <td><input type="text" name="sabit_amount_get#currentrow#" id="sabit_amount_get#currentrow#" style="width:100px;" class="moneybox" value="#TLFormat(amount_get,4)#" onkeyup="return(FormatCurrency(this,event,4));"></td>
                            <td>#money#</td>
                            <cfif is_show_account_code eq 1>
                                <td nowrap>
                                    <cfinput type="hidden" name="sabit_account_code#currentrow#" id="sabit_account_code#currentrow#" value="#get_det.account_code#">
                                    <cfinput type="Text" name="sabit_account_name#currentrow#" id="sabit_account_name#currentrow#" value="#get_det.account_name#" style="width:100px;" onFocus="AutoComplete_Create('sabit_account_name#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','ACCOUNT_NAME,ACCOUNT_CODE','sabit_account_name#currentrow#,sabit_account_code#currentrow#','','3','225');"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_account_plan&field_name=form_basket.sabit_account_name#currentrow#&field_id=form_basket.sabit_account_code#currentrow#','list');" ><img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id='58811.Muhasebe Kodu'>" border="0" align="absmiddle"></a>
                                </td>
                            </cfif>
                            <cfif is_show_member eq 1>
                                <td nowrap>
                                    <input type="hidden" name="sabit_company_id#currentrow#" id="sabit_company_id#currentrow#" value="#get_det.company_id#">
                                    <input type="hidden" name="sabit_consumer_id#currentrow#" id="sabit_consumer_id#currentrow#" value="#get_det.consumer_id#">
                                    <cfif len(company_id)>
                                        <cfinput  name="sabit_member_name#currentrow#" id="sabit_member_name#currentrow#" type="text" value="#get_par_info(get_det.company_id,1,0,0)#" style="width:100px;" onFocus="AutoComplete_Create('sabit_member_name#currentrow#','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,CONSUMER_ID','sabit_company_id#currentrow#,sabit_consumer_id#currentrow#','','3','180','');">
                                    <cfelseif len(consumer_id)>
                                        <cfinput  name="sabit_member_name#currentrow#" id="sabit_member_name#currentrow#" type="text" value="#get_cons_info(get_det.consumer_id,0,0)#" style="width:100px;" onFocus="AutoComplete_Create('sabit_member_name#currentrow#','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,CONSUMER_ID','sabit_company_id#currentrow#,sabit_consumer_id#currentrow#','','3','180','');">
                                    <cfelse>	
                                        <cfinput  name="sabit_member_name#currentrow#" id="sabit_member_name#currentrow#" type="text" value="" style="width:100px;" onFocus="AutoComplete_Create('sabit_member_name#currentrow#','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,CONSUMER_ID','sabit_company_id#currentrow#,sabit_consumer_id#currentrow#','','3','180','');">
                                    </cfif><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_name=form_basket.sabit_member_name#currentrow#&field_consumer=form_basket.sabit_consumer_id#currentrow#&field_comp_id=form_basket.sabit_company_id#currentrow#&field_member_name=form_basket.sabit_member_name#currentrow#','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id='57519.Cari Hesap'>" border="0" align="top"></a>
                                </td>
                            </cfif>
                            <cfif is_show_member_type eq 1>
                                <td nowrap>
                                    <select name="sabit_acc_type_id#currentrow#" id="sabit_acc_type_id#currentrow#" style="width:125px;">
                                        <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                        <cfloop query="get_ch_types">
                                            <option value="#acc_type_id#" <cfif get_ch_types.acc_type_id eq get_det.acc_type_id>selected</cfif>>#acc_type_name#</option>
                                        </cfloop>
                                    </select>
                                </td>
                            </cfif>
							<td>
								<cf_workcube_process is_upd='0' select_value='#PROCESS_STAGE#' process_cat_width='188' is_detail='1' select_name="sabit_process_stage_#currentrow#">
							</td>
                        </tr>
                    </cfoutput>
                </tbody>
            </cfoutput>
            <cfquery name="get_rows_ext" datasource="#dsn#">
                SELECT
                    EPRE.PAY_METHOD,
                    --EE.DEDUCTION_TYPE,
                    EPRE.EMPLOYEE_PUANTAJ_EXT_ID,
                    ISNULL((CASE WHEN EPRE.PAY_METHOD = 1 THEN EPRE.AMOUNT_2 WHEN EPRE.PAY_METHOD = 2 THEN EPRE.AMOUNT END),0) AS ODENEN,
                    EP.SAL_MON,
                    EP.SAL_YEAR,
                    CASE WHEN EE.EXECUTION_CAT = 1 THEN 'İcra' ELSE 'Nafaka' END AS COMMENT,
                    ACC.ACC_TYPE_NAME,
                    EE.ACCOUNT_CODE,
                    EE.ACCOUNT_NAME,
                    (CASE WHEN EE.COMPANY_ID IS NOT NULL THEN C.NICKNAME WHEN EE.CONSUMER_ID IS NOT NULL THEN CON.CONSUMER_NAME + ' ' + CON.CONSUMER_SURNAME ELSE ''END) AS MEMBER_NAME
                FROM
                    EMPLOYEES_PUANTAJ_ROWS_EXT EPRE
                    INNER JOIN EMPLOYEES_PUANTAJ EP ON EPRE.PUANTAJ_ID = EP.PUANTAJ_ID
                    INNER JOIN EMPLOYEES_EXECUTIONS EE ON EE.EXECUTION_ID = EPRE.COMMENT_PAY_ID
                    INNER JOIN EMPLOYEES_PUANTAJ_ROWS EPR ON EPRE.EMPLOYEE_PUANTAJ_ID = EPR.EMPLOYEE_PUANTAJ_ID 
                LEFT JOIN SETUP_ACC_TYPE ACC ON EE.ACC_TYPE_ID = ACC.ACC_TYPE_ID
                    LEFT JOIN COMPANY C ON C.COMPANY_ID = EE.COMPANY_ID
                    LEFT JOIN CONSUMER CON ON CON.CONSUMER_ID = EE.CONSUMER_ID
                
                WHERE
                    EP.SAL_YEAR = #attributes.related_year# AND
                    EPRE.EXT_TYPE = 3 AND <!--- icra kesintisi--->
                    EPR.IN_OUT_ID = #attributes.in_out_id#
                ORDER BY
                    EP.SAL_YEAR,
                    EP.SAL_MON
            </cfquery>
            <cfoutput query="get_rows_ext" group="sal_year">
                <tbody id="my_div2_#sal_year#">
					<cfoutput>
                        <tr>
                            <td></td>
                            <td></td>
                            <td>#comment#</td>
                            <td></td>
                            <td></td>
                            <td><cfif PAY_METHOD eq 1><cf_get_lang dictionary_id='51029.Yüzde'><cfelseif PAY_METHOD eq 2><cf_get_lang dictionary_id='39993.Eksi'></cfif></td>
                            <td></td>
                            <td>#sal_year#</td>
                            <td>#listgetat(ay_list(),sal_mon,',')#</td>
                            <td>#listgetat(ay_list(),sal_mon,',')#</td>
                            <td style="text-align:right">#TLformat(odenen)#</td>
                            <td></td>
                            <td>#account_name#</td>
                            <td>#MEMBER_NAME#</td>
                            <td>#acc_type_name#</td>
                        </tr>
                    </cfoutput>	
                </tbody>
            </cfoutput>
        </cf_grid_list>
        <cf_box_footer>
            <cf_record_info query_name="GET_DET">
            <cf_workcube_buttons is_upd='1' is_delete='0' add_function='check_form()'>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
	rowCount = 0;
	sabitrowCount = <cfif get_det.recordcount><cfoutput>#get_det.recordcount#</cfoutput><cfelse>0</cfif>;
	
	function add_row(from_salary, show, comment_pay, period_pay, method_pay, term, start_sal_mon, end_sal_mon, amount_pay, calc_days,is_ehesap,total_get,account_code,company_id,company_name,account_name,consumer_id,money,acc_type_id,satir_tax,odkes_id,is_net_to_gross)
	{
		rowCount++;
		var newRow;
		var newCell;
		if(is_ehesap == '')
			is_ehesap = 0;
		if(total_get == 0)
			total_get = '';
		
		newRow = document.getElementById("table_list").insertRow(document.getElementById("table_list").rows.length);
		newRow.className = 'color-row';
		newRow.setAttribute("name","my_row_" + rowCount);
		newRow.setAttribute("id","my_row_" + rowCount);		
		newRow.setAttribute("NAME","my_row_" + rowCount);
		newRow.setAttribute("ID","my_row_" + rowCount);
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a onClick="sil(' + rowCount + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML+= '<input  type="hidden"  value="1"  name="row_kontrol_' + rowCount +'"><input type="Hidden" name="from_salary' + rowCount +'" value="' + from_salary + '">';
		newCell.innerHTML+= '<input type="Hidden" name="period_get' + rowCount +'" value="' + period_pay + '">';
		newCell.innerHTML+= '<input type="Hidden" name="money' + rowCount +'" value="' + money + '">';
		newCell.innerHTML+= '<input type="hidden" name="total_get' + rowCount +'" value="' + total_get + '">';
		newCell.innerHTML+= '<input type="Hidden" name="calc_days' + rowCount +'" value="' + calc_days + '">';
		newCell.innerHTML+= '<input type="Hidden" name="is_ehesap' + rowCount +'" value="' + is_ehesap + '">';
		newCell.innerHTML+= '<input type="Hidden" name="method_get' + rowCount +'" value="' + method_pay + '">';
		newCell.innerHTML+= '<input type="Hidden" name="tax' + rowCount +'" value="' + satir_tax + '">';
		newCell.innerHTML+= '<input type="Hidden" name="show' + rowCount +'" value="' + show + '">';
		newCell.innerHTML+= '<input type="Hidden" name="is_net_to_gross' + rowCount +'" value="' + is_net_to_gross + '">';
		if (show == '1')
			newCell.innerHTML+= '<img border="0" src="/images/b_ok.gif" align="center" align="absmiddle">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="comment_get' + rowCount +'" style="width:150px;" readonly value="' + comment_pay + '">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		if (from_salary == '1')
			newCell.innerHTML = '<cf_get_lang dictionary_id='53397.Brüt Ücretden'>';
		else if (from_salary == '0')
			newCell.innerHTML = '<cf_get_lang dictionary_id='53398.Net Ücretden'>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		if (period_pay == '1')
			newCell.innerHTML = '<cf_get_lang dictionary_id='53311.Ayda'>';
		else if (period_pay == '2')
			newCell.innerHTML = '3 <cf_get_lang dictionary_id='53311.Ayda'>';
		else if (period_pay == '3')
			newCell.innerHTML = '6 <cf_get_lang dictionary_id='53311.Ayda'>';
		else if (period_pay == '4')
			newCell.innerHTML = '<cf_get_lang dictionary_id='53312.Yılda'>';
		newCell.innerHTML+= ' 1';
	
		newCell = newRow.insertCell(newRow.cells.length);
		
		if(method_pay == '1')
			newCell.innerHTML = "Eksi";
		else if(method_pay == '2')
			newCell.innerHTML = "% Ay";
		else if(method_pay == '3')
			newCell.innerHTML = "% Gün";
		else if(method_pay == '4')
			newCell.innerHTML = "% Saat";
		else if(method_pay == '5')
			newCell.innerHTML = "% Kazanç";
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="detail' + rowCount + '"id="detail'+rowCount+'" value="">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="term' + rowCount +'"><cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="j"><option value="<cfoutput>#j#</cfoutput>" <cfif year(now()) eq j>selected</cfif>><cfoutput>#j#</cfoutput></option></cfloop></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="start_sal_mon' + rowCount +'" style="70" onchange="change_mon(\'end_sal_mon'+rowCount+'\',this.value);"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option></cfloop></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="end_sal_mon' + rowCount +'" id="end_sal_mon' + rowCount +'" style="70"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option></cfloop></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input name="amount_get' + rowCount +'" type="text"  class="moneybox" style="width:100px;" value="'+amount_pay+'" onkeyup="return(FormatCurrency(this,event,4));">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = money;		
		
		<cfif is_show_account_code eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input name="account_code' + rowCount +'" type="hidden" value="'+account_code+'"><input name="account_name' + rowCount +'" type="text" style="width:100px;" value="'+account_name+'" onFocus="autocomp_account('+rowCount+');"><a href="javascript://" onClick="pencere_ac_acc2('+ rowCount +');"><img src="/images/plus_thin.gif"  align="top" border="0"></a>';
		</cfif>
		<cfif is_show_member eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="company_id' + rowCount +'" id="company_id' + rowCount +'"  value="'+company_id+'"><input type="hidden" name="consumer_id' + rowCount +'" id="consumer_id' + rowCount +'"  value="'+consumer_id+'"><input type="text" name="member_name' + rowCount +'" id="member_name' + rowCount +'" onFocus="autocomp('+rowCount+');"  value="'+company_name+'" style="width:100px"><a href="javascript://" onClick="pencere_ac_company('+ rowCount +');"><img src="/images/plus_thin.gif"  align="top" border="0" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>';
		</cfif>
		<cfif is_show_member_type eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			b = '<select name="acc_type_id' + rowCount  +'" id="acc_type_id' + rowCount  +'" style="width:125px;"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>';
			<cfoutput query="get_ch_types">
			if('#acc_type_id#' == acc_type_id)
				b += '<option value="#acc_type_id#" selected>#acc_type_name#</option>';
			else
				b += '<option value="#acc_type_id#">#acc_type_name#</option>';
			</cfoutput>
			newCell.innerHTML =b+ '</select>';
		</cfif>

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="process_stage_' + rowCount +'"  id="process_stage' + rowCount +'"><cfoutput query="get_process_stage"><option value="#process_row_id#">#stage#</option></cfoutput></select></div>';
		
	
		eval("form_basket.start_sal_mon" + rowCount).selectedIndex = start_sal_mon-1;
		eval("form_basket.end_sal_mon" + rowCount).selectedIndex = end_sal_mon-1;
	
		return true;
	}
	function autocomp(no)
	{
		AutoComplete_Create("member_name"+no,"MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE","MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE","get_member_autocomplete","\"1,2,3\",0,0,0","COMPANY_ID,CONSUMER_ID","company_id"+no+",consumer_id"+no+"","",3,250,"");
	}
	function pencere_ac_company(sira_no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&row_no='+sira_no+'&select_list=2,3&field_consumer=form_basket.consumer_id'+ sira_no +'&field_comp_id=form_basket.company_id'+ sira_no +'&field_member_name=form_basket.member_name'+ sira_no +'&field_name=form_basket.member_name' + sira_no +'','list');
	}
	function pencere_ac_acc2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=form_basket.account_name' + no +'&field_id=form_basket.account_code' + no +'','list');
	}
	function autocomp_account(no)
	{
		AutoComplete_Create("account_name"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_NAME,ACCOUNT_CODE","account_name"+no+",account_code"+no+"","",3);
	}
	function sil(sy)
	{
		var my_element=eval("form_basket.row_kontrol_"+sy);
		my_element.value=0;
	
		var my_element=eval("my_row_"+sy);
		my_element.style.display="none";
	}
	
	function sabit_sil(sy)
	{
		var my_element=eval("form_basket.sabit_row_kontrol_"+sy);
		my_element.value=0;
	
		var my_element=eval("sabit_my_row_"+sy);
		my_element.style.display="none";
	}
	
	function check_form()
	{
		form_basket.rowCount.value = rowCount;
		for (i=0; i < rowCount; i++)
		{
			var k = i + 1;
			 if(eval("form_basket.amount_get" + k).value.length == 0)
			{
				alert('<cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id="53083.Kesinti">');
				return false;
			}				
			<cfif isdefined("is_kontrol_account_code") and is_kontrol_account_code eq 1 and is_show_account_code eq 1>
				kontrol_account_code = "<cfoutput>#GET_IN_OUT_PERIODS.ACCOUNT_CODE#</cfoutput>";
				if(kontrol_account_code != '' && eval("form_basket.account_code" + k).value != '' && kontrol_account_code == eval("form_basket.account_code" + k).value)
				{
					alert("<cf_get_lang dictionary_id='59675.Seçilen Muhasebe Kodu Çalışanın Muhasebe Kodu İle Aynı Olamaz'> !");
					return false;
				}
			</cfif>	
		}
		for (m=0; m < rowCount; m++)
		{
			var c = m + 1;
			eval("form_basket.amount_get" + c).value = filterNum(eval("form_basket.amount_get" + c).value,4);
		}			
		for (i=0; i < sabitrowCount; i++)
		{
			var k = i + 1;
			 if(eval("form_basket.sabit_amount_get" + k).value.length == 0)
			{
				alert('<cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id="53083.Kesinti">');
				return false;
			}				
			<cfif isdefined("is_kontrol_account_code") and is_kontrol_account_code eq 1 and is_show_account_code eq 1>
				kontrol_account_code = "<cfoutput>#GET_IN_OUT_PERIODS.ACCOUNT_CODE#</cfoutput>";
				if(kontrol_account_code != '' && eval("form_basket.sabit_account_code" + k).value != '' && kontrol_account_code == eval("form_basket.sabit_account_code" + k).value)
				{
					alert("<cf_get_lang dictionary_id='59675.Seçilen Muhasebe Kodu Çalışanın Muhasebe Kodu İle Aynı Olamaz'> !");
					return false;
				}
			</cfif>	
		}
		for (m=0; m < sabitrowCount; m++)
		{
			var c = m + 1;
			eval("form_basket.sabit_amount_get" + c).value = filterNum(eval("form_basket.sabit_amount_get" + c).value,4);
		}
		<cfif isdefined("attributes.draggable") and attributes.draggable eq 1>
			loadPopupBox('form_basket' , <cfoutput>#attributes.modal_id#</cfoutput>);
			return false;
		<cfelse>
			return true;
		</cfif>
	}
	function change_mon(id,i)
	{
		$('#'+id).val(i);
	}
	function ajax_function()
	{
		related_year = $("#related_year").val();

		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_form_upd_kesinti_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#</cfoutput>&from_upd_salary=1&related_year='+related_year,'ajax_right');

		return false;
	}
</script>

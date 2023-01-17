<cfparam name="attributes.sal_mon" default="1"> 
<cfparam name="attributes.ins_period" default="1">
<cfquery name="get_in_out" datasource="#dsn#">
	SELECT IN_OUT_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<cfquery name="GET_POSITION_DETAIL" datasource="#dsn#">
	SELECT
		UPPER_POSITION_CODE,
		UPPER_POSITION_CODE2
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		IS_MASTER = 1 AND
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<cfform name="add_request" method="post" action="#request.self#?fuseaction=myhome.emptypopup_add_payment_request">
		<input type="hidden" name="odkes_id" id="odkes_id" value="">
		<!---<input type="hidden" name="employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">--->
		<input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#get_in_out.in_out_id#</cfoutput>">
		<input type="hidden" name="is_inst_avans" id="is_inst_avans" value="1">
		<input type="hidden" name="periyod_get" id="periyod_get" value="">
		<input type="hidden" name="method_get" id="method_get" value="">
		<input type="hidden" name="from_salary" id="from_salary" value="">
		<input type="hidden" name="show" id="show" value="">
		<input type="hidden" name="term" id="term" value="">
		<input type="hidden" name="start_sal_mon" id="start_sal_mon" value="">
		<input type="hidden" name="end_sal_mon" id="end_sal_mon" value="">
		<input type="hidden" name="calc_days" id="calc_days" value="">
		<input type="hidden" name="form_add_request" id="form_add_request" value="0">
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-process_cat">
					<label class="col col-4 col-sm-12 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
					<div class="col col-8 col-sm-12 col-xs-12"><cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'></div>
				</div>
				<div class="form-group" id="item-pos_code_emp">
					<label class="col col-4 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57576.Calışan'></label>
					<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
					<div class="col col-8 col-sm-12 col-xs-12">
						<cfif isdefined("x_select_emp") and x_select_emp eq 1>
							<div class="input-group">
								<input name="emp_name" type="text" id="emp_name"  value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>" readonly><!---onFocus="AutoComplete_Create('emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','add_request','3','140');"  autocomplete="off"--->
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&call_function=change_upper_pos_codes()&field_emp_id=add_request.employee_id&field_name=add_request.emp_name&upper_pos_code=<cfoutput>#session.ep.position_code#</cfoutput>&select_list=1','list');"></span>
							</div>
						<cfelse>
							<input name="emp_name" type="text" id="emp_name"  value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>" readonly><!---onFocus="AutoComplete_Create('emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','add_request','3','140');"  autocomplete="off"--->
						</cfif>
					</div>
				</div>
				<div class="form-group" id="item-comment_get">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31578.Avans Tipi'>*</label>
					<div class="col col-8 col-sm-12 col-xs-12">
						<div class="input-group">
							<input type="text" name="comment_get" id="comment_get" value="" readonly >
							<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_list_kesinti_taksitli','medium')"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-start_month">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31579.Başlagıç Ay'></label>
					<div class="col col-8 col-sm-12 col-xs-12">
						<select name="sal_mon" id="sal_mon">
								<cfloop from="1" to="12" index="i">
									<cfoutput><option value="#i#" <cfif attributes.sal_mon is i>selected</cfif> >#listgetat(ay_list(),i,',')#</option></cfoutput>
								</cfloop>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-detail_">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
					<div class="col col-8 col-sm-12 col-xs-12">
						<textarea name="detail" id="detail"></textarea>
					</div>
				</div>
				<!--- <div class="form-group">
					<label class="col col-4 col-sm-12"><cf_get_lang_main no ='88.Onay'>1</label>
					<input type="hidden" name="validator_pos_code" id="validator_pos_code" value="<cfif  isdefined("get_position_detail.upper_position_code") and len(get_position_detail.upper_position_code)><cfoutput>#get_position_detail.upper_position_code#</cfoutput></cfif>">
					<div class="col col-4">
						<input type="text" name="valid_name" id="valid_name" readonly="yes" value="<cfif isdefined("get_position_detail.upper_position_code") and len(get_position_detail.upper_position_code)><cfoutput>#get_emp_info(get_position_detail.upper_position_code,1,0)#</cfoutput></cfif>">
						<cfif not(isdefined("get_position_detail.upper_position_code") and len(get_position_detail.upper_position_code))><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_request.validator_pos_code&field_name=add_request.valid_name','list');return false"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a></cfif>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-sm-12"><cf_get_lang_main no ='88.Onay'>2</label>
					<input type="hidden" name="validator_pos_code2" id="validator_pos_code2" value="<cfif isdefined("get_position_detail.upper_position_code2") and len(get_position_detail.upper_position_code2)><cfoutput>#get_position_detail.upper_position_code2#</cfoutput></cfif>">
					<div class="col col-4">
						<input type="text" name="valid_name2" id="valid_name2" readonly="yes" value="<cfif isdefined("get_position_detail.upper_position_code2") and len(get_position_detail.upper_position_code2)><cfoutput>#get_emp_info(get_position_detail.upper_position_code2,1,0)#</cfoutput></cfif>">
						<cfif not(isdefined("get_position_detail.upper_position_code2") and len(get_position_detail.upper_position_code2))><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_request.validator_pos_code2&field_name=add_request.valid_name2','list');return false"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a></cfif>
					</div>					
				</div> --->
				<div class="form-group" id="item-total_amount">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29534.Toplam Tutar'></label>
					<div class="col col-8 col-sm-12 col-xs-12">
						<input type="text" name="toplam_tutar" id="toplam_tutar" class="moneybox" value="0" onBlur="hesapla();" onkeyup="return(FormatCurrency(this,event));">
					</div>
				</div>
				<div class="form-group" id="item-ins_period">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='31550.Taksit Sayısı'></label>
					<div class="col col-8 col-sm-12 col-xs-12">
					 <input type="number" name="ins_period" id="ins_period" onBlur="tutar_göster(this.value);" value="<cfoutput>#attributes.ins_period#</cfoutput>" max="99" min="1" required="required"/>
					</div>
				</div>				
				<div id="tutar0" class="form-group">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='31581.Taksit'><cfoutput>1</cfoutput></label>
					<div class="col col-8 col-sm-12 col-xs-12 ">
						<input type="text" name="amount_get0" id="amount_get0" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event));">
					</div>
				</div>
				<cfloop from="1" to="98" index="i">
					<div id="tutar<cfoutput>#i#</cfoutput>" class="form-group" style="display:none;">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31581.Taksit'><cfoutput>#evaluate(i+1)#</cfoutput></label>
						<div class="col col-8 col-sm-12 col-xs-12">
							<input type="text" name="amount_get<cfoutput>#i#</cfoutput>" id="amount_get<cfoutput>#i#</cfoutput>" class="moneybox" onkeyup="return(FormatCurrency(this,event));">
						</div>
					</div>
				</cfloop>
			</div>
		</cf_box_elements>
			<!--- <tr id="tutar<cfoutput>#i#</cfoutput>" style="display:none;"> --->	
	<cf_box_footer>
		<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
	</cf_box_footer>
</cfform>
<script type="text/javascript">
function change_upper_pos_codes()
{
	var emp_upper_pos_code = wrk_query('SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2,POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = '+document.add_request.employee_id.value,'dsn');
	var emp_upper_pos_name = wrk_query('SELECT E.EMPLOYEE_NAME FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE,'dsn');
	var emp_upper_pos_surname = wrk_query('SELECT E.EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE,'dsn');
	var emp_upper_pos_name2 = wrk_query('SELECT E.EMPLOYEE_NAME  FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE2,'dsn');
	var emp_upper_pos_surname2 = wrk_query('SELECT E.EMPLOYEE_SURNAME  FROM EMPLOYEE_POSITIONS EP,EMPLOYEES E WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = '+emp_upper_pos_code.UPPER_POSITION_CODE2,'dsn');

	if(<cfoutput>#session.ep.userid#</cfoutput> != document.add_request.employee_id.value)
	{
		if(emp_upper_pos_code.UPPER_POSITION_CODE)
			document.getElementById('validator_pos_code').value = emp_upper_pos_code.UPPER_POSITION_CODE;
		else
			document.getElementById('validator_pos_code').value = '';
		if(emp_upper_pos_name.EMPLOYEE_NAME)
			document.getElementById('valid_name').value = emp_upper_pos_name.EMPLOYEE_NAME;
		else
			document.getElementById('valid_name').value = '';
		if(emp_upper_pos_surname.EMPLOYEE_SURNAME)
			document.getElementById('valid_name').value += ' ' + emp_upper_pos_surname.EMPLOYEE_SURNAME;
		else
			document.getElementById('valid_name').value = '';
		if(emp_upper_pos_code.UPPER_POSITION_CODE2)
			document.getElementById('validator_pos_code2').value = emp_upper_pos_code.UPPER_POSITION_CODE2;
		else
			document.getElementById('validator_pos_code2').value = '';
		if(emp_upper_pos_name2.EMPLOYEE_NAME)
			document.getElementById('valid_name2').value = emp_upper_pos_name2.EMPLOYEE_NAME;
		else
			document.getElementById('valid_name2').value = '';
		if(emp_upper_pos_surname2.EMPLOYEE_SURNAME)
			document.getElementById('valid_name2').value += ' ' + emp_upper_pos_surname2.EMPLOYEE_SURNAME;
		else
			document.getElementById('valid_name2').value = '';
	}
}

function add_row(from_salary, show, comment_pay, period_pay, method_pay, term, start_sal_mon, end_sal_mon, amount_pay, calc_days,odkes_id)
{
	document.add_request.odkes_id.value=odkes_id;
	document.add_request.from_salary.value=from_salary;
	document.add_request.show.value=show;
	document.add_request.comment_get.value=comment_pay;
	document.add_request.periyod_get.value=period_pay;
	document.add_request.method_get.value=method_pay;
	document.add_request.term.value=term;
	document.add_request.start_sal_mon.value=start_sal_mon;
	document.add_request.end_sal_mon.value=end_sal_mon;
	document.add_request.toplam_tutar.value=amount_pay;
	document.add_request.amount_get0.value=amount_pay;
	document.add_request.calc_days.value=calc_days;
	return true;
}
function tutar_göster(number)
{
	if (document.add_request.comment_get.value == '')
	{
		alert("<cf_get_lang dictionary_id ='31852.Avans Tipi Seçiniz'>!");
		document.add_request.ins_period.value = 1;
		return false;
	}
	if(document.add_request.toplam_tutar.value != "" && document.add_request.ins_period.value)
	{
		fiyat= document.add_request.toplam_tutar.value;
		fiyat = filterNum(fiyat);
		taksit_sayisi = number;
		taksit= fiyat / taksit_sayisi;
		taksit =  commaSplit(taksit);
		for (i=0;i<=number;i++)
		{
			eleman = eval('tutar'+i);
			eleman.style.display = '';
			deger = eval("document.add_request.amount_get"+i);
			deger.value = taksit;
		}
		for (i=number;i<99;i++)
		{
			eleman = eval('tutar'+i);
			eleman.style.display = 'none';
		}
	}
}
function hesapla()
{
	if(document.add_request.toplam_tutar.value != "" && document.add_request.ins_period.value)
	{
		fiyat= document.add_request.toplam_tutar.value;
		fiyat = filterNum(fiyat);
		taksit_sayisi = document.add_request.ins_period.value;
		taksit= fiyat / taksit_sayisi;
		taksit =  commaSplit(taksit);
		document.add_request.toplam_tutar.value = commaSplit(filterNum(document.add_request.toplam_tutar.value));
		for (i=0;i<=(document.add_request.ins_period.value-1);i++)
		{
			
			deger = eval("document.add_request.amount_get"+i);
			deger.value = taksit;
		}
	}
}
function kontrol()
{
	if (document.add_request.comment_get.value =="")
	{
		alert("<cf_get_lang dictionary_id ='31852.Avans Tipi Seçiniz'>!");
		return false;
	}
    if (document.add_request.toplam_tutar.value == "")
	{
		alert("<cf_get_lang dictionary_id='29535.Lutfen Tutar Giriniz'>");
		return false;
	}
	if (document.getElementById('ins_period').value == "")
	{
		alert("<cf_get_lang dictionary_id='31411.Taksit Sayısı Giriniz'>");
		return false;
	}
	unformat_fields();
	return true;
}
function unformat_fields()
	{
		if(document.add_request.comment_get.value == '')
		{
			alert("<cf_get_lang dictionary_id ='31852.Avans Tipi Seçiniz'>!");
			return false;
		}
		for(r=0;r<=(add_request.ins_period.value-1);r++)
		{
			eval('add_request.amount_get' + r).value = filterNum(eval('add_request.amount_get' + r).value,4);
		}
		add_request.toplam_tutar.value =  filterNum(add_request.toplam_tutar.value,4);
		return true;
	}
</script>
<meta name="viewport" content="width=device-width, initial-scale=1">
<cfif (not session.ep.ehesap)>
	<cfinclude template="../query/get_emp_branches.cfm">
</cfif>
<cfparam name="attributes.sal_year" default="#year(now())#">
<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_ssk_yearly.cfm">
<script src="../../../JS/sweetalert/sweetalert2.min.js"></script>
<link rel="stylesheet" href="../../../css/assets/template/sweetalert/sweetalert2.min.css">
<cfquery name="GET_POSITION_DETAIL" datasource="#dsn#">
	SELECT POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#attributes.employee_id#">  AND IS_MASTER = <cfqueryparam cfsqltype = "cf_sql_integer" value = "1">  
</cfquery>
<cfset get_wage_scale = createObject('component','V16.hr.cfc.wage_scale')><!--- Temel Ücret Skalası. 20190925ERU --->
<cfset get_scale = get_wage_scale.GET_WAGE_SCALE(position_id : GET_POSITION_DETAIL.position_cat_id, year : attributes.sal_year)>
<cfif get_ssk_yearly.recordcount>
	<cfif (not session.ep.ehesap) and (not listFind(emp_branch_list, get_ssk_yearly.branch_id))>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !");
			history.back();
		</script>
		<!--- yetki dışı kullanım için mail şablonu hazırlanmalı erk 20030911--->
		<cfabort>
	</cfif>
</cfif>
<cfparam name="attributes.modal_id" default="">
<cf_box id="yearly_box" title="#getLang('','Maaş Tanımla',53289)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform id="add_expense" action="#request.self#?fuseaction=ehesap.emptypopup_upd_yearly_ssk" method="post" name="add_expense" >
		<input type="hidden" name="position_id" id="position_id" value="<cfoutput>#GET_POSITION_DETAIL.position_cat_id#</cfoutput>">    
		<cfif get_scale.recordcount>
		    <input type="hidden" name="min_salary" id="min_salary" value="<cfoutput>#get_scale.min_salary#</cfoutput>">        	
		    <input type="hidden" name="max_salary" id="max_salary" value="<cfoutput>#get_scale.max_salary#</cfoutput>">
		    <input type="hidden" name="scale_money" id="scale_money" value="<cfoutput>#get_scale.money#</cfoutput>">
		<cfelse>
			<input type="hidden" name="min_salary" id="min_salary" value="-1">        	
		    <input type="hidden" name="max_salary" id="max_salary" value="-1">
		    <input type="hidden" name="scale_money" id="scale_money" value="<cfoutput>#get_ssk_yearly.money#</cfoutput>">
		</cfif>
        <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
        <input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#attributes.in_out_id#</cfoutput>">
		<cf_box_elements>
			<div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<div class="col col-5 col-xs-12">
						<label><cf_get_lang dictionary_id='58455.Yıl'></label>
					</div>
					<div class="col col-7 col-xs-12">
						<select name="sal_year" id="sal_year" onChange="yenile(this.selectedIndex);">
							<cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="i">
								<cfoutput><option value="#i#"<cfif attributes.sal_year eq i> selected</cfif>>#i#</option></cfoutput>
							</cfloop>
						</select>	
					</div>
				</div>
				<div class="form-group">
					<div class="col col-5 col-xs-12">
						<label><cf_get_lang dictionary_id='57592.Ocak'></label>
								
					</div>
					<div class="col col-7 col-xs-12">
						<cfinput onKeyup="if (FormatCurrency(this,event)) {return true;} else {upd(1); return false;}" type="text" name="M1" id="M1" style="width:100px;" class="moneybox" value="#TLFormat(get_ssk_yearly.m1)#">								
					</div>
				</div>
				<div class="form-group">
					<div class="col col-5 col-xs-12">
						<label><cf_get_lang dictionary_id='57593.Şubat'></label>		
					</div>
					<div class="col col-7 col-xs-12">
						<cfinput onkeyup="if (FormatCurrency(this,event)) {return true;} else {upd(2); return false;}"  type="text" name="M2" id="M2" style="width:100px;" class="moneybox" value="#TLFormat(get_ssk_yearly.m2)#">
					</div>
				</div>
				<div class="form-group">
					<div class="col col-5 col-xs-12">
						<label><cf_get_lang dictionary_id='57594.Mart'></label>
								
					</div>
					<div class="col col-7 col-xs-12">
						<cfinput onkeyup="if (FormatCurrency(this,event)) {return true;} else {upd(3); return false;}"  type="text" name="M3" style="width:100px;" class="moneybox" value="#TLFormat(get_ssk_yearly.m3)#">
					</div>
				</div>
				<div class="form-group">
					<div class="col col-5 col-xs-12">
						<label><cf_get_lang dictionary_id='57595.Nisan'></label>		
					</div>
					<div class="col col-7 col-xs-12">
						<cfinput onkeyup="if (FormatCurrency(this,event)) {return true;} else {upd(4); return false;}" type="text" name="M4" style="width:100px;" class="moneybox" value="#TLFormat(get_ssk_yearly.m4)#">
					</div>
				</div>
				<div class="form-group">
					<div class="col col-5 col-xs-12">
						<label><cf_get_lang dictionary_id='57596.Mayıs'></label>		
					</div>
					<div class="col col-7 col-xs-12">
						<cfinput onkeyup="if (FormatCurrency(this,event)) {return true;} else {upd(5); return false;}" type="text" name="M5" style="width:100px;" class="moneybox" value="#TLFormat(get_ssk_yearly.m5)#">
					</div>
				</div>
				<div class="form-group">
					<div class="col col-5 col-xs-12">
						<label><cf_get_lang dictionary_id='57597.Haziran'></label>		
					</div>
					<div class="col col-7 col-xs-12">
						<cfinput onkeyup="if (FormatCurrency(this,event)) {return true;} else {upd(6); return false;}" type="text" name="M6" style="width:100px;" class="moneybox" value="#TLFormat(get_ssk_yearly.m6)#">
					</div>
				</div>
			</div>
			<div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group">
					<div class="col col-5 col-xs-12">
						<label><cf_get_lang dictionary_id='57489.Para Birimi'></label>
					</div>
					<div class="col col-7 col-xs-12">
						<select name="money" id="money">
							<cfoutput query="get_moneys">
								<option value="#MONEY#" <cfif (len(get_ssk_yearly.money) and get_ssk_yearly.money is '#MONEY#') or (not len(get_ssk_yearly.money) and session.ep.money is '#MONEY#')>selected</cfif>>#MONEY#</option>
							</cfoutput>
						</select>
					</div>	
				</div>
				<div class="form-group">
					<div class="col col-5 col-xs-12">
						<label><cf_get_lang dictionary_id='57598.Temmuz'></label>
					</div>
					<div class="col col-7 col-xs-12">
						<cfinput onKeyup="if (FormatCurrency(this,event)) {return true;} else {upd(7); return false;}" type="text" name="M7" style="width:100px;" class="moneybox" value="#TLFormat(get_ssk_yearly.m7)#">
					</div>		
				</div> 
				<div class="form-group">
					<div class="col col-5 col-xs-12">
						<label><cf_get_lang dictionary_id='57599.Ağustos'></label>
					</div>
					<div class="col col-7 col-xs-12">
						<cfinput onkeyup="if (FormatCurrency(this,event)) {return true;} else {upd(8); return false;}"  type="text" name="M8" style="width:100px;" class="moneybox" value="#TLFormat(get_ssk_yearly.m8)#">
					</div>		
				</div> 
				<div class="form-group">
					<div class="col col-5 col-xs-12">
						<label><cf_get_lang dictionary_id='57600.Eylül'></label>
					</div>
					<div class="col col-7 col-xs-12">
						<cfinput onkeyup="if (FormatCurrency(this,event)) {return true;} else {upd(9); return false;}" type="text" name="M9" style="width:100px;" class="moneybox" value="#TLFormat(get_ssk_yearly.m9)#">
					</div>		
				</div> 
				<div class="form-group">
					<div class="col col-5 col-xs-12">
						<label><cf_get_lang dictionary_id='57601.Ekim'></label>
					</div>
					<div class="col col-7 col-xs-12">
						<cfinput onkeyup="if (FormatCurrency(this,event)) {return true;} else {upd(10); return false;}" type="text" name="M10" style="width:100px;" class="moneybox" value="#TLFormat(get_ssk_yearly.m10)#">
					</div>		
				</div> 
				<div class="form-group">
					<div class="col col-5 col-xs-12">
						<label><cf_get_lang dictionary_id='57602.Kasım'></label>
					</div>
					<div class="col col-7 col-xs-12">
						<cfinput onkeyup="if (FormatCurrency(this,event)) {return true;} else {upd(11); return false;}" type="text" name="M11" style="width:100px;" class="moneybox" value="#TLFormat(get_ssk_yearly.m11)#">
					</div>		
				</div> 
				<div class="form-group">
					<div class="col col-5 col-xs-12">
						<label><cf_get_lang dictionary_id='57603.Aralık'></label>
					</div>		
					<div class="col col-7 col-xs-12">
						<cfinput onkeyup="return(FormatCurrency(this,event));" type="text" name="M12" style="width:100px;" class="moneybox" value="#TLFormat(get_ssk_yearly.m12)#">
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info query_name="get_ssk_yearly">
			<cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("upd_form() && loadPopupBox('add_expense' , #attributes.modal_id#)"),DE(""))#">
		</cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
	function yenile(gelen)
	{
		var sal_year_gelen = add_expense.sal_year.options[gelen].value;
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=ehesap.popup_form_plan_yearly_ssk&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#&sal_year='+sal_year_gelen+'</cfoutput>','','ui-draggable-box-medium');
		/* <cfoutput>
		location.href='#request.self#?fuseaction=ehesap.popup_form_plan_yearly_ssk&in_out_id=#attributes.in_out_id#&employee_id=#url.employee_id#&sal_year='+add_expense.sal_year.options[gelen].value;
		</cfoutput> */
	}

	function upd_form()
	{
		//Temel Ücret Skalasında maximum ve minimum değerler aralığında kontrolü 20190925ERU
		if(add_expense.min_salary.value != -1 && add_expense.max_salary.value != -1)
		{
			UnformatFields();
			for(i = 1 ; i <= 12 ; i++ ){
				if(parseFloat(document.getElementById("M"+i).value) < parseFloat(add_expense.min_salary.value) || parseFloat(document.getElementById("M"+i).value) > parseFloat(add_expense.max_salary.value)){
					if(add_expense.money.value == add_expense.scale_money.value){
						message_confirm = "<cf_get_lang dictionary_id='51194.Tanımladığınız Tutar çalışanın pozisyon tipi temel ücret skalası aralığında değildir.'>";
						saveMes = "<cf_get_lang dictionary_id = '44097.devam et'>";
						cancelMes = "<cf_get_lang dictionary_id='51196.Yoksay'>";
						if(add_expense.money.value == add_expense.scale_money.value){
							Swal.fire({
							title: message_confirm,
							text: "",
							type: 'warning',
							showCancelButton: true,
							confirmButtonColor: '#3085d6',
							cancelButtonColor: '#d33',
							confirmButtonText: saveMes,
							cancelButtonText: cancelMes
							}).then((result) => {
							if (result.value) {
								document.getElementById("add_expense").submit();
							}else{
								return false;
							}
							})						
						}
						return false;
					}
				}
			}
		}
		else{
			UnformatFields();
			return true;
		} 	
	}

	function upd(key)
	{
		if(key==1)
		{
			add_expense.M2.value = add_expense.M1.value;
			add_expense.M3.value = add_expense.M1.value;
			add_expense.M4.value = add_expense.M1.value;
			add_expense.M5.value = add_expense.M1.value;
			add_expense.M6.value = add_expense.M1.value;
			add_expense.M7.value = add_expense.M1.value;
			add_expense.M8.value = add_expense.M1.value;
			add_expense.M9.value = add_expense.M1.value;
			add_expense.M10.value = add_expense.M1.value;
			add_expense.M11.value = add_expense.M1.value;
			add_expense.M12.value = add_expense.M1.value;
		}

		else if(key==2)
		{
			add_expense.M3.value = add_expense.M2.value;
			add_expense.M4.value = add_expense.M2.value;
			add_expense.M5.value = add_expense.M2.value;
			add_expense.M6.value = add_expense.M2.value;
			add_expense.M7.value = add_expense.M2.value;
			add_expense.M8.value = add_expense.M2.value;
			add_expense.M9.value = add_expense.M2.value;
			add_expense.M10.value = add_expense.M2.value;
			add_expense.M11.value = add_expense.M2.value;
			add_expense.M12.value = add_expense.M2.value;
		}

		else if(key==3)
		{
			add_expense.M4.value = add_expense.M3.value;
			add_expense.M5.value = add_expense.M3.value;
			add_expense.M6.value = add_expense.M3.value;
			add_expense.M7.value = add_expense.M3.value;
			add_expense.M8.value = add_expense.M3.value;
			add_expense.M9.value = add_expense.M3.value;
			add_expense.M10.value = add_expense.M3.value;
			add_expense.M11.value = add_expense.M3.value;
			add_expense.M12.value = add_expense.M3.value;

		}

		else if(key==4)
		{
			add_expense.M5.value = add_expense.M4.value;
			add_expense.M6.value = add_expense.M4.value;
			add_expense.M7.value = add_expense.M4.value;
			add_expense.M8.value = add_expense.M4.value;
			add_expense.M9.value = add_expense.M4.value;
			add_expense.M10.value = add_expense.M4.value;
			add_expense.M11.value = add_expense.M4.value;
			add_expense.M12.value = add_expense.M4.value;
		}

		else if(key==5)
		{
			add_expense.M6.value = add_expense.M5.value;
			add_expense.M7.value = add_expense.M5.value;
			add_expense.M8.value = add_expense.M5.value;
			add_expense.M9.value = add_expense.M5.value;
			add_expense.M10.value = add_expense.M5.value;
			add_expense.M11.value = add_expense.M5.value;
			add_expense.M12.value = add_expense.M5.value;
		}

		else if(key==6)
		{
			add_expense.M7.value = add_expense.M6.value;
			add_expense.M8.value = add_expense.M6.value;
			add_expense.M9.value = add_expense.M6.value;
			add_expense.M10.value = add_expense.M6.value;
			add_expense.M11.value = add_expense.M6.value;
			add_expense.M12.value = add_expense.M6.value;
		}

		else if(key==7)
		{
			add_expense.M8.value = add_expense.M7.value;
			add_expense.M9.value = add_expense.M7.value;
			add_expense.M10.value = add_expense.M7.value;
			add_expense.M11.value = add_expense.M7.value;
			add_expense.M12.value = add_expense.M7.value;
		}

		else if(key==8)
		{
			add_expense.M9.value = add_expense.M8.value;
			add_expense.M10.value = add_expense.M8.value;
			add_expense.M11.value = add_expense.M8.value;
			add_expense.M12.value = add_expense.M8.value;
		}

		else if(key==9)
		{
			add_expense.M10.value = add_expense.M9.value;
			add_expense.M11.value = add_expense.M9.value;
			add_expense.M12.value = add_expense.M9.value;
		}

		else if(key==10)
		{
			add_expense.M11.value = add_expense.M10.value;
			add_expense.M12.value = add_expense.M10.value;
		}

		else if(key==11)
		{
			add_expense.M12.value = add_expense.M11.value;
		}
			
	}
	
	function UnformatFields()
	{
		add_expense.M1.value = filterNum(add_expense.M1.value);
		add_expense.M2.value = filterNum(add_expense.M2.value);
		add_expense.M3.value = filterNum(add_expense.M3.value);
		add_expense.M4.value = filterNum(add_expense.M4.value);
		add_expense.M5.value = filterNum(add_expense.M5.value);
		add_expense.M6.value = filterNum(add_expense.M6.value);
		add_expense.M7.value = filterNum(add_expense.M7.value);
		add_expense.M8.value = filterNum(add_expense.M8.value);
		add_expense.M9.value = filterNum(add_expense.M9.value);
		add_expense.M10.value = filterNum(add_expense.M10.value);
		add_expense.M11.value = filterNum(add_expense.M11.value);
		add_expense.M12.value = filterNum(add_expense.M12.value);
		if (add_expense.M1.value == '') add_expense.M1.value = 0;
		if (add_expense.M2.value == '') add_expense.M2.value = 0;
		if (add_expense.M3.value == '') add_expense.M3.value = 0;
		if (add_expense.M4.value == '') add_expense.M4.value = 0;
		if (add_expense.M5.value == '') add_expense.M5.value = 0;
		if (add_expense.M6.value == '') add_expense.M6.value = 0;
		if (add_expense.M7.value == '') add_expense.M7.value = 0;
		if (add_expense.M8.value == '') add_expense.M8.value = 0;
		if (add_expense.M9.value == '') add_expense.M9.value = 0;
		if (add_expense.M10.value == '') add_expense.M10.value = 0;
		if (add_expense.M11.value == '') add_expense.M11.value = 0;
		if (add_expense.M12.value == '') add_expense.M12.value = 0;
	}
</script>

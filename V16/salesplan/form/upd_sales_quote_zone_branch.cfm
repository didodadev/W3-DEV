<cfinclude template="../query/get_moneys.cfm">
<cfquery name="GET_SALES_QUOTE_ZONE" datasource="#DSN#">
	SELECT 
		SQ.*,
		SZ.SZ_NAME,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM 
		SALES_QUOTES_GROUP SQ,
		SALES_ZONES SZ,
		EMPLOYEES E
	WHERE
		SQ.RECORD_EMP = E.EMPLOYEE_ID AND
		SZ.SZ_ID = SQ.SALES_ZONE_ID AND
		SQ.SALES_QUOTE_ID = #attributes.sales_quote_id#
</cfquery>
<cfquery name="GET_ROWS" datasource="#DSN#">
	SELECT 
		*
	FROM
		SALES_QUOTES_GROUP_ROWS
	WHERE
		SALES_QUOTE_ID = #get_sales_quote_zone.sales_quote_id#
	ORDER BY
		QUOTE_MONTH ASC	
</cfquery>
<cfset month_degerler = valuelist(get_rows.sales_income)>
<table cellspacing="0" cellpadding="0" border="0" width="100%" align="center" height="100%">
  <tr class="color-border">
    <td>
	<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
	<cfform name="form_basket" method="post" action="#request.self#?fuseaction=salesplan.emptypopup_upd_sales_quote_zone_branch">
	<input type="hidden" name="sales_zone_id" id="sales_zone_id" value="<cfoutput>#get_sales_quote_zone.sales_zone_id#</cfoutput>">
	<input type="hidden" name="quote_year" id="quote_year" value="<cfoutput>#get_sales_quote_zone.quote_year#</cfoutput>">
	<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
	<input type="hidden" name="sales_quote_id" id="sales_quote_id" value="<cfoutput>#get_sales_quote_zone.sales_quote_id#</cfoutput>">
	  <tr class="color-list" height="35">
		<td class="headbold"><cf_get_lang_main no='247.Satış Bölgesi'> / <cf_get_lang no='130.Şube Bazında Kota Planla'></td>
	  </tr>
	  <tr class="color-row">
		<td valign="top">
		<table>
		  <tr>
		  	<td><cf_get_lang_main no='247.Satış Bölgesi'></td>
		 	<td><input type="text" name="sales_zone" id="sales_zone" value="<cfoutput>#get_sales_quote_zone.sz_name#</cfoutput>" readonly style="width:150px;"></td>
			<td><cf_get_lang_main no='1060.Dönem'></td>
		  	<td>
			  <select name="quote_year_select" id="quote_year_select" style="width:65px;" onchange="if (this.options[this.selectedIndex].value != 'null') { window.open(this.options[this.selectedIndex].value,'_self') }">
			  <cfoutput>
			  <cfloop from="#session.ep.period_year#" to="2020" index="i">
			  	<option value="#request.self#?fuseaction=salesplan.popup_check_sales_quote_zone_branch&quote_year=#i#&branch_id=#get_sales_quote_zone.sales_zone_id#-#attributes.branch_id#&is_submit=1" <cfif get_sales_quote_zone.quote_year eq i>selected</cfif>>#i#</option>
			  </cfloop>
			  </cfoutput>
			  </select>
		 	</td>
		  </tr>
	 	  <tr>
		  	<td><cf_get_lang no='12.İlgili Şube'></td>
		  	<td>
			  <cfinclude template="../query/get_branch_name.cfm">
			  <input type="text" name="sales_zone" id="sales_zone" value="<cfoutput>#get_branch_name.branch_name#</cfoutput>" readonly style="width:150px;">
		 	</td>
		  	<td><cf_get_lang_main no='217.Açıklama'></td>
		  	<td rowspan="2"><textarea name="quote_detail" id="quote_detail" style="width:150px;height:45px;"><cfoutput>#get_sales_quote_zone.quote_detail#</cfoutput></textarea></td>
		  </tr>
		  <tr>
		  	<td><cf_get_lang no='115.Planlayan'></td>
		  	<td>
			  <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_sales_quote_zone.planner_emp_id#</cfoutput>">
			  <input type="text" name="employee_name" id="employee_name" value="<cfoutput>#get_emp_info(get_sales_quote_zone.planner_emp_id,0,0)#</cfoutput>" readonly style="width:150px;">
			  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_basket.employee_id&field_name=form_basket.employee_name','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
		  	</td>
		  	<td></td>
		  </tr>
		  <tr>
		  	<td colspan="4"> <cf_get_lang_main no='71.Kayıt'>
			  : <cfoutput>#get_sales_quote_zone.employee_name# #get_sales_quote_zone.employee_surname# - #dateformat(date_add("h",session.ep.time_zone,get_sales_quote_zone.record_date),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,get_sales_quote_zone.record_date),timeformat_style)#)</cfoutput>&nbsp;&nbsp;&nbsp;
			  <cfif len(get_sales_quote_zone.update_date)>
			  	<cf_get_lang no='291.Güncelleme'> : <cfoutput>#get_emp_info(get_sales_quote_zone.update_emp,0,0)# - #dateformat(date_add("h",session.ep.time_zone,get_sales_quote_zone.update_date),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,get_sales_quote_zone.update_date),timeformat_style)#)</cfoutput>
			  </cfif>
		  	</td>
		  </tr>
		</table>
		<br/>
		<cfset toplam = 0>
		<cfloop list="#month_degerler#" index="i">
		  <cfset toplam = toplam + i>
		</cfloop>
		<table cellspacing="0" cellpadding="0" border="0">
		  <tr class="color-border">
		  	<td>
			<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
			  <tr class="color-row">
				<td width="75"><cf_get_lang_main no='77.Para Birimi'></td>
				<td colspan="5">
				  <select name="money" id="money">
				  <cfoutput query="get_moneys">
					 <option value="#MONEY#"  <cfif get_sales_quote_zone.quote_money is '#MONEY#'>selected</cfif>>#MONEY#</option>
				  </cfoutput>
				  </select>
				</td>
			  </tr>
			  <tr class="color-row">
				<td><cf_get_lang_main no='180.Ocak'></td>
				<td><cfinput type="text" name="M1" value="#tlformat(listgetat(month_degerler,1,','))#" passThrough = "onkeyup=""return(FormatCurrency(this,event));"" onFocus=""son_deger_degis(1);"" onBlur=""toplam_al(1);""" class="moneybox" style="width:100px;"></td>
				<td width="75"><cf_get_lang_main no='186.Temmuz'></td>
				<td><cfinput type="text" name="M7" value="#tlformat(listgetat(month_degerler,7,','))#" passThrough = "onkeyup=""return(FormatCurrency(this,event));"" onFocus=""son_deger_degis(7);"" onBlur=""toplam_al(7);""" class="moneybox" style="width:100px;"></td>
			  </tr>
			  <tr class="color-row">
				<td><cf_get_lang_main no='181.Şubat'></td>
				<td><cfinput type="text" name="M2" value="#tlformat(listgetat(month_degerler,2,','))#" passThrough = "onkeyup=""return(FormatCurrency(this,event));"" onFocus=""son_deger_degis(2);"" onBlur=""toplam_al(2);""" class="moneybox" style="width:100px;"></td>
				<td><cf_get_lang_main no='187.Ağustos'></td>
				<td><cfinput type="text" name="M8" value="#tlformat(listgetat(month_degerler,8,','))#" passThrough = "onkeyup=""return(FormatCurrency(this,event));"" onFocus=""son_deger_degis(8);"" onBlur=""toplam_al(8);""" class="moneybox" style="width:100px;"></td>
			  </tr>
			  <tr class="color-row">
				<td><cf_get_lang_main no='182.Mart'></td>
				<td><cfinput type="text" name="M3" value="#tlformat(listgetat(month_degerler,3,','))#" passThrough = "onkeyup=""return(FormatCurrency(this,event));"" onFocus=""son_deger_degis(3);"" onBlur=""toplam_al(3);""" class="moneybox" style="width:100px;"></td>
				<td><cf_get_lang_main no='188.Eylül'></td>
				<td><cfinput type="text" name="M9" value="#tlformat(listgetat(month_degerler,9,','))#" passThrough = "onkeyup=""return(FormatCurrency(this,event));"" onFocus=""son_deger_degis(9);"" onBlur=""toplam_al(9);""" class="moneybox" style="width:100px;"></td>
			  </tr>
			  <tr class="color-row">
				<td><cf_get_lang_main no='183.Nisan'></td>
				<td><cfinput type="text" name="M4" value="#tlformat(listgetat(month_degerler,4,','))#" passThrough = "onkeyup=""return(FormatCurrency(this,event));"" onFocus=""son_deger_degis(4);"" onBlur=""toplam_al(4);""" class="moneybox" style="width:100px;"></td>
				<td><cf_get_lang_main no='189.Ekim'></td>
				<td><cfinput type="text" name="M10" value="#tlformat(listgetat(month_degerler,10,','))#" passThrough = "onkeyup=""return(FormatCurrency(this,event));"" onFocus=""son_deger_degis(10);"" onBlur=""toplam_al(10);""" class="moneybox" style="width:100px;"></td>
			  </tr>
			  <tr class="color-row">
				<td><cf_get_lang_main no='184.Mayıs'></td>
				<td><cfinput type="text" name="M5" value="#tlformat(listgetat(month_degerler,5,','))#" passThrough = "onkeyup=""return(FormatCurrency(this,event));"" onFocus=""son_deger_degis(5);"" onBlur=""toplam_al(5);""" class="moneybox" style="width:100px;"></td>
				<td><cf_get_lang_main no='190.Kasım'></td>
				<td><cfinput type="text" name="M11" value="#tlformat(listgetat(month_degerler,11,','))#" passThrough = "onkeyup=""return(FormatCurrency(this,event));"" onFocus=""son_deger_degis(11);"" onBlur=""toplam_al(11);""" class="moneybox" style="width:100px;"></td>
			  </tr>
			  <tr class="color-row">
				<td><cf_get_lang_main no='185.Haziran'></td>
				<td><cfinput type="text" name="M6" value="#tlformat(listgetat(month_degerler,6,','))#" passThrough = "onkeyup=""return(FormatCurrency(this,event));"" onFocus=""son_deger_degis(6);"" onBlur=""toplam_al(6);""" class="moneybox" style="width:100px;"></td>
				<td><cf_get_lang_main no='191.Aralık'></td>
				<td><cfinput type="text" name="M12" value="#tlformat(listgetat(month_degerler,12,','))#" passThrough = "onkeyup=""return(FormatCurrency(this,event));"" onFocus=""son_deger_degis(12);"" onBlur=""toplam_al(12);""" class="moneybox" style="width:100px;"></td>
			  </tr>
			  <tr class="color-row">
				<td colspan="3" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.Toplam'></td>
				<td><input type="text" name="TOPLAMLAR" id="TOPLAMLAR" readonly style="width:100px;" class="moneybox" value="<cfoutput>#tlformat(toplam)#</cfoutput>"></td>
			  </tr>
			</table>
		  	</td>
		  </tr>
		  <tr>
		  	<td align="right" height="35" colspan="4"> <cf_workcube_buttons is_upd='0' add_function='upd_form()'> </td>
		  </tr>
		</table>
		</td>
	  </tr>
	</cfform>
	</table>
    </td>
  </tr>
</table>
<script type="text/javascript">
function upd_form()
{
	UnformatFields();
	if (form_basket.M1.value == '') form_basket.M1.value = 0;
	if (form_basket.M2.value == '') form_basket.M2.value = 0;
	if (form_basket.M3.value == '') form_basket.M3.value = 0;
	if (form_basket.M4.value == '') form_basket.M4.value = 0;
	if (form_basket.M5.value == '') form_basket.M5.value = 0;
	if (form_basket.M6.value == '') form_basket.M6.value = 0;
	if (form_basket.M7.value == '') form_basket.M7.value = 0;
	if (form_basket.M8.value == '') form_basket.M8.value = 0;
	if (form_basket.M9.value == '') form_basket.M9.value = 0;
	if (form_basket.M10.value == '') form_basket.M10.value = 0;
	if (form_basket.M11.value == '') form_basket.M11.value = 0;
	if (form_basket.M12.value == '') form_basket.M12.value = 0;
}
function UnformatFields()
{
	form_basket.M1.value = filterNum(form_basket.M1.value);
	form_basket.M2.value = filterNum(form_basket.M2.value);
	form_basket.M3.value = filterNum(form_basket.M3.value);
	form_basket.M4.value = filterNum(form_basket.M4.value);
	form_basket.M5.value = filterNum(form_basket.M5.value);
	form_basket.M6.value = filterNum(form_basket.M6.value);
	form_basket.M7.value = filterNum(form_basket.M7.value);
	form_basket.M8.value = filterNum(form_basket.M8.value);
	form_basket.M9.value = filterNum(form_basket.M9.value);
	form_basket.M10.value = filterNum(form_basket.M10.value);
	form_basket.M11.value = filterNum(form_basket.M11.value);
	form_basket.M12.value = filterNum(form_basket.M12.value);
}

function son_deger_degis(satir_id)
{
	son_deger = eval("form_basket.M" + satir_id + ".value");
	son_deger = filterNum(son_deger);
}

function toplam_al(satir_id)
{
	gelen_input = eval("form_basket.M" + satir_id + ".value");
	gelen_input = filterNum(gelen_input);
	son_toplam = form_basket.TOPLAMLAR.value;
	son_toplam = filterNum(son_toplam);
	
	son_toplam = (son_toplam + gelen_input) - son_deger;
	
	gelen_input = commaSplit(gelen_input);
	son_toplam = commaSplit(son_toplam);
	
	eval("form_basket.M" + satir_id).value = gelen_input;
	form_basket.TOPLAMLAR.value = son_toplam;
}
</script>

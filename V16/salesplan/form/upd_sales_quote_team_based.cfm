<cfsavecontent variable="ay1"><cf_get_lang_main no='180.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang_main no='181.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang_main no='182.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang_main no='183.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang_main no='184.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang_main no='185.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang_main no='186.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang_main no='187.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang_main no='188.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang_main no='189.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang_main no='190.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang_main no='191.Aralık'></cfsavecontent>
<cfset aylar = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
<cfinclude template="../query/get_moneys.cfm">

<cfquery name="GET_SALES_QUOTE_ZONE" datasource="#dsn#">
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

<cfquery name="get_quote_teams" datasource="#dsn#">
	SELECT
		TEAM_NAME,
		TEAM_ID
	FROM
		SALES_ZONES_TEAM SZT
	WHERE
		SALES_ZONES=#GET_SALES_QUOTE_ZONE.SALES_ZONE_ID#
</cfquery>

<cfquery name="GET_ROWS" datasource="#dsn#">
	SELECT 
		SQGR.SALES_INCOME,
		SQGR.ROW_MONEY,
		SQGR.QUOTE_MONTH,
		SQGR.TEAM_ID,
		SZT.TEAM_NAME
	FROM 
		SALES_QUOTES_GROUP_ROWS SQGR,
		SALES_ZONES_TEAM SZT
	WHERE
		SQGR.SALES_QUOTE_ID = #GET_SALES_QUOTE_ZONE.sales_quote_id# AND
		SZT.TEAM_ID=SQGR.TEAM_ID		
	ORDER BY
		SZT.TEAM_NAME,
		QUOTE_MONTH ASC	
</cfquery>

<cfquery name="GET_SALES_TEAM_BRANCH" datasource="#dsn#">
	SELECT 
		SQR.* 
	FROM 
		SALES_QUOTES_GROUP SQ,
		SALES_QUOTES_GROUP_ROWS SQR 
	WHERE 
		SQ.SALES_QUOTE_ID = SQR.SALES_QUOTE_ID 
		AND SQ.QUOTE_TYPE = 1 
		AND SQR.BRANCH_ID = #attributes.branch_id#
		AND SQ.QUOTE_YEAR = #GET_SALES_QUOTE_ZONE.quote_year#
		AND	SQ.SALES_ZONE_ID = #GET_SALES_QUOTE_ZONE.sales_zone_id#
</cfquery>
<table cellspacing="0" cellpadding="0" border="0" width="100%" align="center" height="100%">
	<tr class="color-border">
		<td>
	  <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
		<cfform name="form_basket" action="#request.self#?fuseaction=salesplan.emptypopup_upd_sales_quote_team_based" method="post">
		<input type="hidden" name="sales_zone_id" id="sales_zone_id" value="<cfoutput>#GET_SALES_QUOTE_ZONE.sales_zone_id#</cfoutput>">
		<input type="hidden" name="quote_year" id="quote_year" value="<cfoutput>#GET_SALES_QUOTE_ZONE.quote_year#</cfoutput>">
		<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
		<input type="hidden" name="SALES_QUOTE_ID" id="SALES_QUOTE_ID" value="<cfoutput>#GET_SALES_QUOTE_ZONE.SALES_QUOTE_ID#</cfoutput>">
		<tr class="color-list" height="35">
			<td class="headbold"><cf_get_lang no='104.Takım Bazında Satış Hedefler'></td>
		</tr>
		<tr class="color-row">
		  <td valign="top">
				<table>		
					<tr>
						<td><cf_get_lang_main no='247.Satış Bölgesi'></td>
						<td>
						<input type="text" style="width:150px;" name="sales_zone" id="sales_zone" value="<cfoutput>#GET_SALES_QUOTE_ZONE.sz_name#</cfoutput>" readonly>
						</td>
						<td><cf_get_lang_main no='1060.Dönem'></td>
						<td>								
						<select name="quote_year_select" id="quote_year_select" style="width:65px;" onchange="if (this.options[this.selectedIndex].value != 'null') { window.open(this.options[this.selectedIndex].value,'_self') }">
							<cfoutput>
								<cfloop from="#session.ep.period_year#" to="2020" index="i">
									<option value="#request.self#?fuseaction=salesplan.popup_check_sales_quote_team_based&quote_year=#i#&branch_id=#attributes.branch_id#&sales_zone_id=#GET_SALES_QUOTE_ZONE.sales_zone_id#" <cfif GET_SALES_QUOTE_ZONE.quote_year eq i>selected</cfif>>#i#</option>
								</cfloop>
							</cfoutput>
						</select>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang no='12.İlgili Şube'></td>
						<td>
						<cfinclude template="../query/get_branch_name.cfm">
						<input type="text" style="width:150px;" name="sales_zone" id="sales_zone" value="<cfoutput>#get_branch_name.branch_name#</cfoutput>" readonly>
						</td>
						<td><cf_get_lang_main no='217.Açıklama'></td>
						<td rowspan="2">
						<textarea name="quote_detail" id="quote_detail" style="width:150px;height:45px;"><cfoutput>#GET_SALES_QUOTE_ZONE.quote_detail#</cfoutput></textarea>
						</td>
					</tr>
					<tr>						
						<td><cf_get_lang no='115.Planlayan'></td>
					   <td>
					   <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#GET_SALES_QUOTE_ZONE.planner_emp_id#</cfoutput>">
	
						<input type="text" name="employee_name" id="employee_name" style="width:150px;" value="<cfoutput>#get_emp_info(GET_SALES_QUOTE_ZONE.planner_emp_id,0,0)#</cfoutput>" readonly>
	
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_basket.employee_id&field_name=form_basket.employee_name','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
	
						</td>
	
						<td>&nbsp;</td>
					</tr>
					 <tr>
					  <td colspan="4">
					   <cf_get_lang_main no='71.Kayıt'> : <cfoutput>#GET_SALES_QUOTE_ZONE.employee_name# #GET_SALES_QUOTE_ZONE.employee_surname# - #dateformat(date_add("h",session.ep.time_zone,GET_SALES_QUOTE_ZONE.record_date),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,GET_SALES_QUOTE_ZONE.record_date),timeformat_style)#)</cfoutput>&nbsp;&nbsp;&nbsp;
					  <cfif len(GET_SALES_QUOTE_ZONE.update_date)>
					  <cf_get_lang no='291.Güncelleme'> : <cfoutput>#get_emp_info(GET_SALES_QUOTE_ZONE.update_emp,0,0)# - #dateformat(date_add("h",session.ep.time_zone,GET_SALES_QUOTE_ZONE.update_date),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,GET_SALES_QUOTE_ZONE.update_date),timeformat_style)#)</cfoutput></cfif></td>
				  </tr>
				</table>
			 <br/>
				<cfscript>
	
					son_toplam = 0;kolon_1 = 0;kolon_2 = 0;kolon_3 = 0;kolon_4 = 0;kolon_5 = 0;kolon_6 = 0;
	
					kolon_7 = 0;kolon_8 = 0;kolon_9 = 0;kolon_10 = 0;kolon_11 = 0;kolon_12 = 0;
	
				</cfscript>
	
				<table cellspacing="0" cellpadding="0" border="0">
					<tr class="color-border">
						<td>
						<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
					<tr class="color-row">								 
							  <td width="75"><cf_get_lang_main no='77.Para Birimi'></td>
							  <td colspan="15">
								<select name="money" id="money">
								  <cfoutput query="get_moneys">
									<option value="#MONEY#" <cfif GET_SALES_QUOTE_ZONE.quote_money is '#MONEY#'>selected</cfif>>#MONEY#</option>
								  </cfoutput>
								</select>
							  </td>
							</tr>
							<tr class="color-list">
							  <td class="txtboldblue"><cf_get_lang_main no='1099.Takım'><input type="hidden" name="team_ids" id="team_ids" value="<cfoutput>#valuelist(get_quote_teams.TEAM_ID)#</cfoutput>"></td>
							 <cfloop from="1" to="12" index="k">
								<td align="center" class="txtboldblue">
								 <cfoutput>#Listgetat(aylar,k)#</cfoutput>								  
								</td>
							 </cfloop>
							 <td class="txtboldblue"><cf_get_lang_main no='758.Satır Toplam'></td>
							</tr>
							<tr class="color-list">
							<td nowrap class="txtboldblue"><cf_get_lang no='126.Şube Kotaları'></td>
							<cfset toplam_other_quotes=0>
							<cfif GET_SALES_TEAM_BRANCH.recordcount>
								<cfoutput query="GET_SALES_TEAM_BRANCH">
									<cfset toplam_other_quotes=toplam_other_quotes + sales_income>
									<td align="right" class="box" style="text-align:right;">#tlformat(sales_income,0)#</td>
								</cfoutput>
								<td align="right" class="box" style="text-align:right;"><cfoutput>#tlformat(toplam_other_quotes,0)#</cfoutput></td>
							<cfelse>
							<td colspan="13" align="center"><cf_get_lang no='127.Şube Bazlı Kota Bulunamadı'>!</td>
							</cfif>
						</tr>								
							
							<cfoutput query="get_quote_teams">
	
							<tr class="color-row">
	
							  <td nowrap>#TEAM_NAME#</td>
	
							  <cfset toplam = 0>
	
							  <cfloop from="1" to="12" index="k">
	
								<cfquery name="get_team_target" dbtype="query">
									SELECT 
										SALES_INCOME
									FROM
										GET_ROWS
									WHERE
										QUOTE_MONTH=#k# AND
										TEAM_ID=#TEAM_ID#
								</cfquery>
	
								<cfif get_team_target.recordcount and len(get_team_target.SALES_INCOME)>
									<cfset yazilacak_rakam = get_team_target.SALES_INCOME>
								<cfelse>
									<cfset yazilacak_rakam = 0>									
								</cfif>
								<cfset 'kolon_#k#' = evaluate("kolon_#k#") + yazilacak_rakam>
								<cfset son_toplam = son_toplam + yazilacak_rakam>
								<cfset toplam = toplam + yazilacak_rakam>
							  <td>
								  <input name="team_#TEAM_ID#_#k#" id="team_#TEAM_ID#_#k#" type="text" class="box" style="width:70px;" tabindex="#k#" onFocus="son_deger_degis(#team_id#,#k#);" onBlur="toplam_al(#TEAM_ID#,#k#);" onkeyup="return(FormatCurrency(this,event));" value="#tlformat(yazilacak_rakam,0)#" autocomplete="off">
							  </td>
							 </cfloop>
							 <td>
							<cfinput passThrough = "onkeyup=""return(FormatCurrency(this,event));""" type="text" name="toplam_#TEAM_ID#" style="width:80px;" class="box" value="#tlformat(toplam,0)#">
							</td>
							</tr>
							</cfoutput>
							<tr class="color-row">
								<td class="txtboldblue"><cf_get_lang no='119.Toplamlar'></td>									
								<cfloop from="1" to="12" index="m">
									<td>
									<input type="text" name="toplam_colon_<cfoutput>#m#</cfoutput>" id="toplam_colon_<cfoutput>#m#</cfoutput>" style="width:70px;" class="box" value="<cfoutput>#tlformat(evaluate("kolon_#m#"),0)#</cfoutput>" readonly>
									</td>
								</cfloop>
	
								<td><input type="text" name="son_toplam" id="son_toplam" style="width:80px;" class="box" value="<cfoutput>#tlformat(son_toplam,0)#</cfoutput>" readonly></td>
	
							</tr>
	
						  </table>
						</td>
					</tr>
					<tr>
					<td align="right" height="35" colspan="4">
						<cf_workcube_buttons is_upd='0' add_function='upd_form()'>
					</td>
					</tr>
		</cfform>
	</table>
	</td>
	</tr>
	</table>
	</td>
	</tr>
</table>

<script type="text/javascript">

function upd_form()

{
	UnformatFields();

	<cfoutput query="get_quote_teams">

		for(var i=1; i<=12; i++)			
		{ 
			if(eval("form_basket.team_#team_id#_"+i).value == '')
			eval("form_basket.team_#team_id#_"+i).value=0;
		}

	</cfoutput>	
	return true;
}



function UnformatFields()
{	
	<cfoutput query="get_quote_teams">
		for(var i=1; i<=12; i++)			
		{ 
			eval("form_basket.team_#team_id#_"+i).value = filterNum(eval("form_basket.team_#team_id#_"+i).value);
		}

	</cfoutput>
	for(var y=1; y<=12; y++)			

		{

		eval("form_basket.toplam_colon_"+y).value = filterNum(eval("form_basket.toplam_colon_"+y).value);

		}

}

function son_deger_degis(satir_id,kolon_no)
{
	son_deger = eval("form_basket.team_" + satir_id + "_" + kolon_no + ".value");
	son_deger = filterNum(son_deger);
}


function toplam_al(satir_id,kolon_no)
{
		gelen_satir_toplam = eval("form_basket.toplam_" + satir_id).value;
		gelen_satir_toplam = filterNum(gelen_satir_toplam);
		gelen_input = eval("form_basket.team_" + satir_id + "_" + kolon_no + ".value");
		gelen_input = filterNum(gelen_input);
		gelen_kolon_toplam = eval("form_basket.toplam_colon_" + kolon_no).value;
		gelen_kolon_toplam = filterNum(gelen_kolon_toplam);
		son_toplam = form_basket.son_toplam.value;
		son_toplam = filterNum(son_toplam);
		
		
		son_toplam = (parseFloat(son_toplam) + parseFloat(gelen_input)) - parseFloat(son_deger);
		gelen_kolon_toplam = (parseFloat(gelen_kolon_toplam) + parseFloat(gelen_input)) - parseFloat(son_deger);
		gelen_satir_toplam = (parseFloat(gelen_satir_toplam) + parseFloat(gelen_input)) - parseFloat(son_deger);
		
		gelen_input = commaSplit(gelen_input,0);
		gelen_satir_toplam = commaSplit(gelen_satir_toplam,0);
		gelen_kolon_toplam = commaSplit(gelen_kolon_toplam,0);
		son_toplam = commaSplit(son_toplam,0);
		
		eval("form_basket.toplam_" + satir_id).value = gelen_satir_toplam;
		eval("form_basket.toplam_colon_" + kolon_no).value = gelen_kolon_toplam;
		eval("form_basket.team_" + satir_id + "_" + kolon_no).value = gelen_input;
		form_basket.son_toplam.value = son_toplam;
}
</script>

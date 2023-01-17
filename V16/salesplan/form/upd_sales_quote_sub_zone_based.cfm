<cfscript>
function ListCompare(List1, List2)
{
  var TempList = "";
  var j = 0;
  for (j=1; j lte ListLen(List1); j=j+1) {
	if (not ListFindNoCase(List2, ListGetAt(List1, j))){
	 TempList = ListAppend(TempList, ListGetAt(List1, j));
	}
  }
  return TempList;
}
</cfscript>
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
		SZ_NAME, 
		SZ_ID,
		SZ_HIERARCHY,
		RESPONSIBLE_BRANCH_ID,
		B.BRANCH_NAME
	FROM 
		SALES_ZONES SZ,
		BRANCH B
	WHERE
		SZ.SZ_ID = #attributes.sales_zone_id# AND
		B.BRANCH_ID=SZ.RESPONSIBLE_BRANCH_ID
</cfquery>
<cfquery name="get_quote_teams" datasource="#dsn#">
	SELECT
		SZ_NAME, 
		SZ_ID,
		SZ_HIERARCHY,
		RESPONSIBLE_BRANCH_ID,
		B.BRANCH_NAME
	FROM 
		SALES_ZONES,
		BRANCH B
	WHERE 
		SZ_ID IN (#attributes.sub_zone_ids#) AND
		B.BRANCH_ID=SALES_ZONES.RESPONSIBLE_BRANCH_ID
</cfquery>
<cfquery name="GET_ROWS" datasource="#dsn#">
	SELECT 
		SQGR.SALES_INCOME,
		SQGR.ROW_MONEY,
		SQGR.QUOTE_MONTH,
		SQGR.SALES_QUOTE_ID,
		SQ.SALES_ZONE_ID,
		SQ.SALES_QUOTE_ID,
		SQ.QUOTE_DETAIL,
		SQ.QUOTE_MONEY,
		SQ.QUOTE_YEAR,
		SQ.PLANNER_EMP_ID,
		SZ.SZ_NAME
	FROM 
		SALES_QUOTES_GROUP_ROWS SQGR,
		SALES_QUOTES_GROUP SQ,
		SALES_ZONES SZ
	WHERE
		SQGR.SALES_QUOTE_ID=SQ.SALES_QUOTE_ID AND
		SZ.SZ_ID = SQ.SALES_ZONE_ID AND
		SQ.QUOTE_TYPE=1 AND 
		SQ.SALES_QUOTE_ID IN (#attributes.sales_quotes#) 
	ORDER BY
		SQGR.QUOTE_MONTH ASC	
</cfquery>
<cfsavecontent variable="right_">
	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=salesplan.popup_add_sales_quote_sub_zone_based&sales_zone_id=#attributes.sales_zone_id#&SUB_ZONE_IDS=#attributes.sub_zone_ids#&SALES_QUOTES=#attributes.sales_quotes#&BRANCH_ID=#attributes.branch_id#&SZ_HIERARCHY=#attributes.sz_hierarchy#</cfoutput>','page');"><img src="/images/plus1.gif" title="<cf_get_lang_main no='170.Ekle'>"></a>
</cfsavecontent>
<cf_popup_box title="#getLang('salesplan',23)#" right_images="#right_#">
<cfform name="form_basket" action="#request.self#?fuseaction=salesplan.emptypopup_upd_sales_quote_sub_zone_based" method="post">
<input type="hidden" name="sales_zone_id" id="sales_zone_id" value="<cfoutput>#attributes.sub_zone_ids#</cfoutput>">
<input type="hidden" name="quote_year" id="quote_year" value="<cfoutput>#GET_ROWS.quote_year#</cfoutput>">
<!---<input type="hidden" name="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">--->
<input type="hidden" name="sales_quotes" id="sales_quotes" value="<cfoutput>#attributes.sales_quotes#</cfoutput>">
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
							<option value="#request.self#?fuseaction=salesplan.popup_check_sales_quote_sub_zone_based&quote_year=#i#&branch_id=#attributes.branch_id#&sales_zone_id=#GET_SALES_QUOTE_ZONE.SZ_ID#&sz_hierarchy=#GET_SALES_QUOTE_ZONE.SZ_HIERARCHY#" <cfif GET_ROWS.quote_year eq i>selected</cfif>>#i#</option>
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
			<td><!--- Açıklama ---></td>
			<td rowspan="2">
			<!--- <textarea name="quote_detail" style="width:150px;height:45px;"><cfoutput>#GET_SALES_QUOTE_ZONE.quote_detail#</cfoutput></textarea> --->
			</td>
		</tr>
		<tr>				
			<td><!--- Planlayan ---></td>
			<td>
			<!--- 							   <input type="hidden" name="employee_id" value="<cfoutput>#GET_SALES_QUOTE_ZONE.planner_emp_id#</cfoutput>">
			<input type="text" name="employee_name" style="width:150px;" value="<cfoutput>#get_emp_info(GET_SALES_QUOTE_ZONE.planner_emp_id,0,0)#</cfoutput>" readonly>
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_basket.employee_id&field_name=form_basket.employee_name','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
			--->								</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
	</table>
	<br/>
	<cfscript>
		son_toplam = 0;kolon_1 = 0;kolon_2 = 0;kolon_3 = 0;kolon_4 = 0;kolon_5 = 0;kolon_6 = 0;
		kolon_7 = 0;kolon_8 = 0;kolon_9 = 0;kolon_10 = 0;kolon_11 = 0;kolon_12 = 0;
	</cfscript>
	<cf_medium_list>
		<thead>
			<tr>			 
				<th width="75"><cf_get_lang_main no='77.Para Birimi'></th>
				<th colspan="15">
					<select name="money" id="money">
						<cfoutput query="get_moneys">
							<option value="#MONEY#" <cfif GET_ROWS.quote_money is '#MONEY#'>selected</cfif>>#MONEY#</option>
						</cfoutput>
					</select>
				</th>
			</tr>
			<tr>
				<th class="txtboldblue"><cf_get_lang_main no='41.Şube'></th>
					<cfloop from="1" to="12" index="k">
						<th align="center" class="txtboldblue">
							<cfoutput>#Listgetat(aylar,k)#</cfoutput>					  
						</th>
					</cfloop>
				<th class="txtboldblue"><cf_get_lang_main no='758.Satır Toplam'></th>
			</tr>
		</thead>
		<tbody>
			<cfset my_tabindex=1>
			<cfoutput query="get_quote_teams">								
				<cfif (listlen(ListCompare(replace(get_quote_teams.sz_hierarchy, '.', ',', 'all'),replace(attributes.sz_hierarchy, '.', ',', 'all')), ',') eq 1)>
					<tr>
						<td>
							<input type="hidden" name="sz_ids" id="sz_ids" value="#get_quote_teams.SZ_ID#.#get_quote_teams.RESPONSIBLE_BRANCH_ID#"><!--- alt bölge ve şube id'leri birlikte tutuluyor --->
							<!---   <input type="hidden" name="sub_branch_ids" value=""> --->
							#SZ_NAME# / #BRANCH_NAME#</td>
							<cfset toplam = 0>
							<cfloop from="1" to="12" index="k">
								<cfquery name="get_team_target" dbtype="query">
									SELECT 
										SALES_INCOME
									FROM
										GET_ROWS
									WHERE
										QUOTE_MONTH=#k# 
										AND SALES_ZONE_ID=#get_quote_teams.SZ_ID# 
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
									<input onkeyup="return(FormatCurrency(this,event));" onBlur="toplam_al(#get_quote_teams.SZ_ID#,#k#);" type="text" name="team_#get_quote_teams.SZ_ID#_#k#" id="team_#get_quote_teams.SZ_ID#_#k#" style="width:63px;" class="box" value="#tlformat(yazilacak_rakam)#">
								</td>
							</cfloop>
						<cfset my_tabindex=my_tabindex + 1>
						<td>
							<cfinput passThrough = "onkeyup=""return(FormatCurrency(this,event));""" type="text" name="toplam_#get_quote_teams.SZ_ID#" style="width:63px;" class="box" value="#tlformat(toplam)#">
						</td>
					</tr>								
				</cfif>								
			</cfoutput>
			<tr class="color-row">
				<td align="right" class="txtboldblue" style="text-align:right;"><cf_get_lang no='119.Toplamlar'></td>							
				<cfloop from="1" to="12" index="m">
					<td>
						<input type="text" name="toplam_colon_<cfoutput>#m#</cfoutput>" id="toplam_colon_<cfoutput>#m#</cfoutput>" style="width:63px;" class="box" value="<cfoutput>#tlformat(evaluate("kolon_#m#"))#</cfoutput>" readonly>
					</td>
				</cfloop>
				<td><input type="text" name="son_toplam" id="son_toplam" style="width:63px;" class="box" value="<cfoutput>#tlformat(son_toplam)#</cfoutput>" readonly></td>
			</tr>
		</tbody>
	</cf_medium_list>
	<cf_popup_box_footer><cf_workcube_buttons type_format='1' is_upd='0' add_function='upd_form()'></cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script type="text/javascript">
function upd_form()
{
	UnformatFields();
	<cfoutput query="get_quote_teams">
	 <cfif (listlen(ListCompare(replace(get_quote_teams.sz_hierarchy, '.', ',', 'all'),replace(attributes.sz_hierarchy, '.', ',', 'all')), ',') eq 1)>
		for(var b=1; b<=12; b++)			
		{ 
		if(eval("form_basket.team_#SZ_ID#_"+b).value == '')
		eval("form_basket.team_#SZ_ID#_"+b).value=0;
		}
	</cfif>
	</cfoutput>	
	return true;
}

function UnformatFields()
	{	
		<cfoutput query="get_quote_teams">
		 <cfif (listlen(ListCompare(replace(get_quote_teams.sz_hierarchy, '.', ',', 'all'),replace(attributes.sz_hierarchy, '.', ',', 'all')), ',') eq 1)>
			for(var c=1; c<=12; c++)			
			{ 
			eval("form_basket.team_#SZ_ID#_"+c).value = filterNum(eval("form_basket.team_#SZ_ID#_"+c).value);
			}
		</cfif>			
		</cfoutput>
		for(var d=1; d<=12; d++)			
			{
			eval("form_basket.toplam_colon_"+d).value = filterNum(eval("form_basket.toplam_colon_"+d).value);
			}
	}

function reformat()
{
	<cfoutput query="get_quote_teams">
		 <cfif (listlen(ListCompare(replace(get_quote_teams.sz_hierarchy, '.', ',', 'all'),replace(attributes.sz_hierarchy, '.', ',', 'all')), ',') eq 1)>
			for(var e=1; e<=12; e++)			
			{ 
			eval("form_basket.team_#SZ_ID#_"+e).value = commaSplit(eval("form_basket.team_#SZ_ID#_"+e).value);
			}
		</cfif>
	</cfoutput>
			for(var y=1; y<=12; y++)			
			{
			eval("form_basket.toplam_colon_"+y).value = commaSplit(eval("form_basket.toplam_colon_"+y).value);
			}
			form_basket.son_toplam.value = commaSplit(form_basket.son_toplam.value);	
	return true;
}

function toplam_al(satir_id,kolon_adi)
{
	upd_form();
		<cfloop from="1" to="12" index="my_ay">
		<cfoutput>
			M#my_ay# = eval(eval("form_basket.team_" + satir_id + "_#my_ay#.value"));
		</cfoutput>
		</cfloop>	
		eval("form_basket.toplam_" + satir_id).value = (M1 + M2 + M3 + M4 + M5 + M6 + M7 + M8 + M9 + M10 + M11 + M12);
		eval("form_basket.toplam_" + satir_id).value = commaSplit(eval("form_basket.toplam_" + satir_id).value);

		toplam_k = 0;	
		<cfoutput query="get_quote_teams">
		<cfif (listlen(ListCompare(replace(get_quote_teams.sz_hierarchy, '.', ',', 'all'),replace(attributes.sz_hierarchy, '.', ',', 'all')), ',') eq 1)>
			xxx = eval(eval("form_basket.team_#SZ_ID#_" + kolon_adi + ".value"));
			toplam_k = toplam_k + xxx;
		</cfif>
		</cfoutput>	
		eval("form_basket.toplam_colon_" + kolon_adi).value = toplam_k;
		son_toplam = 0;
		<cfloop from="1" to="12" index="ay">
		<cfoutput>
			C#ay# = eval(form_basket.toplam_colon_#ay#.value);
			son_toplam = son_toplam + C#ay#;
		</cfoutput>
		</cfloop>					
		form_basket.son_toplam.value = son_toplam;			
	return reformat();
}
</script>

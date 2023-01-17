<cf_xml_page_edit fuseact="salesplan.popup_add_sales_zones_team" is_multi_page="1">
<cfsavecontent variable="ay1"><cf_get_lang dictionary_id='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id='57593.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id='57596.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id='57599.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id='57602.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id='57603.Aralık'></cfsavecontent>
<cfset aylar = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
<cfinclude template="../query/get_moneys.cfm">
<cfquery name="GET_SALES_TEAM_BRANCH" datasource="#DSN#">
	SELECT 
		SQR.SALES_INCOME
	FROM 
		SALES_QUOTES_GROUP SQ,
		SALES_QUOTES_GROUP_ROWS SQR 
	WHERE 
		SQ.SALES_QUOTE_ID = SQR.SALES_QUOTE_ID AND
		SQ.QUOTE_TYPE = 1 AND
		SQR.BRANCH_ID = #attributes.branch_id# AND
		SQ.QUOTE_YEAR = #attributes.quote_year# AND
		SQ.SALES_ZONE_ID = #attributes.sales_zone_id#
</cfquery>

<cfparam name="attributes.quote_year" default="#session.ep.period_year#">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cfsavecontent variable="head"><cf_get_lang dictionary_id='41549.Takım Bazında Satış Hedefi	'></cfsavecontent>
<cf_box title="#head#" uidrop="1" hide_table_column="1" resize="0" collapsable="0">
<cfform name="form_basket" action="#request.self#?fuseaction=salesplan.emptypopup_add_sales_quote_team_based" method="post">
<input type="hidden" name="sales_zone_id" id="sales_zone_id" value="<cfoutput>#attributes.sales_zone_id#</cfoutput>">
<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
<input type="hidden" name="quote_year" id="quote_year" value="<cfoutput>#attributes.quote_year#</cfoutput>">
	<cf_box_elements>	
		<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group">
				<label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></label>
				<div class="col col-8 col-xs-12">
					<div>
						<cfinclude template="../query/get_sales_zone_name.cfm">
						<input type="text" style="width:150px;" name="sales_zone" id="sales_zone" value="<cfoutput>#GET_SALES_ZONE_NAME.sz_name#</cfoutput>" readonly>
					</div>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div>
						<select name="quote_year_select" id="quote_year_select" style="width:150px;" onchange="if (this.options[this.selectedIndex].value != 'null') { window.open(this.options[this.selectedIndex].value,'_self') }">
							<cfoutput>
								<cfloop from="#session.ep.period_year#" to="2020" index="i">
									<option value="#request.self#?fuseaction=salesplan.popup_check_sales_quote_team_based&quote_year=#i#&branch_id=#attributes.branch_id#&sales_zone_id=#attributes.sales_zone_id#" <cfif attributes.quote_year eq i>selected</cfif>>#i#</option>
								</cfloop>
							</cfoutput>
						</select>
					</div>
				</div>
			</div>
		</div>		
		<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">	
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='41457.İlgili Şube'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div>
						<cfinclude template="../query/get_branch_name.cfm">
						<input type="text"  name="sales_zone" id="sales_zone" value="<cfoutput>#get_branch_name.branch_name#</cfoutput>" readonly>
					</div>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='41560.Planlayan'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="input-group">
						<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
						<input type="text" name="employee_name" id="employee_name"  value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>" readonly>
						<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_basket.employee_id&field_name=form_basket.employee_name');"></span>
					</div>
				</div>
			</div>
		</div>
		<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div>
						<textarea name="quote_detail" id="quote_detail" style="width:200px;height:130px;"></textarea>
					</div>
				</div>
			</div>
		</div>
	</cf_box_elements>
	<cfscript>
		son_toplam = 0;kolon_1 = 0;kolon_2 = 0;kolon_3 = 0;kolon_4 = 0;kolon_5 = 0;kolon_6 = 0;
		kolon_7 = 0;kolon_8 = 0;kolon_9 = 0;kolon_10 = 0;kolon_11 = 0;kolon_12 = 0;
	</cfscript>
	<cf_basket>
    <cf_grid_list>
		<thead>
        	<cfif xml_select_upper_team>
                <cfquery name="get_quote_teams" datasource="#dsn#"><!---Sadece üst takımlar listelensin py --->
                     SELECT DISTINCT
                        UST_TAKIM.TEAM_ID, 
                        UST_TAKIM.TEAM_NAME, 
                        UST_TAKIM.SALES_ZONES
                     FROM 
                        SALES_ZONES_TEAM ALT_TAKIM RIGHT JOIN
                        SALES_ZONES_TEAM UST_TAKIM
                    ON
                        ALT_TAKIM.UPPER_TEAM_ID = UST_TAKIM.TEAM_ID
                    WHERE 
                        UST_TAKIM.SALES_ZONES = <cfqueryparam cfsqltype="cf_sql_integer" value="#sales_zone_id#"> AND UST_TAKIM.UPPER_TEAM_ID IS NULL   
                    ORDER BY 
                        UST_TAKIM.TEAM_NAME
                </cfquery>
            <cfelse>
                <cfquery name="get_quote_teams" datasource="#dsn#">
                    SELECT
                        TEAM_NAME,
                        SALES_ZONES,
                        TEAM_ID
                    FROM
                        SALES_ZONES_TEAM SZT
                    WHERE
                        SALES_ZONES=#sales_zone_id#
                </cfquery>
            </cfif>
			<tr>								 
				<th style="width:50px;"><cf_get_lang dictionary_id='57489.Para Birimi'></th>
				<th colspan="15">
					<select name="money" id="money">
						<cfoutput query="get_moneys">
							<option value="#MONEY#" <cfif session.ep.money is '#MONEY#'>selected</cfif>>#MONEY#</option>
						</cfoutput>
					</select>
				</th>
			</tr>
			<tr>
				<th class="txtboldblue"><cf_get_lang dictionary_id='58672.Aylar'><input type="hidden" name="team_ids" id="team_ids" value="<cfoutput>#valuelist(get_quote_teams.TEAM_ID)#</cfoutput>"></th>
				<cfloop from="1" to="12" index="k">
					<th align="center" width="75" class="txtboldblue">
						<cfoutput>#Listgetat(aylar,k)#</cfoutput>								  
					</th>
				</cfloop>
				<th class="txtboldblue" width="90"><cf_get_lang dictionary_id='58170.Satır Toplam'></th>
			</tr>
			<tr>
				<th><cf_get_lang dictionary_id='41574.Şube Hedefi'></th>
				<cfset toplam_other_quotes=0>
				<cfif get_sales_team_branch.recordcount>
					<cfoutput query="get_sales_team_branch">
						<cfset toplam_other_quotes=toplam_other_quotes + sales_income>
						<th width="75" align="right" class="box" style="text-align:right;">#tlformat(sales_income)#</th>
					</cfoutput>
					<th width="90" style="text-align:right;"><cfoutput>#tlformat(toplam_other_quotes)#</cfoutput></th>
				<cfelse>
					<th colspan="13" align="center"><cf_get_lang dictionary_id='41572.Şube Bazlı Kota Bulunamadı'>!</th>
				</cfif>
			</tr>	
		</thead>
		<tbody>
			<cfoutput query="get_quote_teams">
				<tr>
					<td nowrap>#TEAM_NAME#</td>
					<cfloop from="1" to="12" index="k">
						<td>
							<cfinput passThrough = "onkeyup=""return(FormatCurrency(this,event,0));"" onFocus=""get_first_value(this.value,#team_id#,#k#)"" onBlur=""toplam_al(#TEAM_ID#,#k#);""" type="text" name="team_#TEAM_ID#_#k#" style="width:70px;" value="#tlformat(0,0)#" class="box" tabindex="#k#">
						</td>
					</cfloop>
					<td><cfinput  type="text" name="toplam_#TEAM_ID#" style="width:80px;" class="box" value="#tlformat(0,0)#"></td>
				</tr>
			</cfoutput>
			<tr>
				<td><cf_get_lang dictionary_id='119.Toplamlar'></td>									
				<cfloop from="1" to="12" index="m">
					<td>
						<input type="text" name="toplam_colon_<cfoutput>#m#</cfoutput>" id="toplam_colon_<cfoutput>#m#</cfoutput>" style="width:70px;" class="box" value="<cfoutput>#tlformat(evaluate("kolon_#m#"),0)#</cfoutput>" readonly>
					</td>
				</cfloop>
				<td><input type="text" name="son_toplam" id="son_toplam" style="width:80px;" class="box" value="<cfoutput>#tlformat(son_toplam,0)#</cfoutput>" readonly></td>
			</tr>
		</tbody>
     </cf_grid_list>
	</cf_basket>
	<cf_box_footer>
		<cfif get_sales_team_branch.recordcount><cf_workcube_buttons type_format='1' is_upd='0' add_function='upd_form()'></cfif>
	</cf_box_footer>
</cfform>
</cf_box>
</div>

<script type="text/javascript">
function upd_form()
{
	UnformatFields();
	<cfoutput query="get_quote_teams">
		for(var i=1; i<=12; i++)			
		{ 
			if(document.getElementById('team_#team_id#_'+i).value == '')
				document.getElementById('team_#team_id#_'+i).value=0;
		}
	</cfoutput>	
	return true;
}

function UnformatFields()
{	
	<cfoutput query="get_quote_teams">
		for(var i=1; i<=12; i++)			
		{ 
			document.getElementById('team_#team_id#_'+i).value = filterNum(document.getElementById('team_#team_id#_'+i).value);
		}
	</cfoutput>
	for(var y=1; y<=12; y++)			
	{
		document.getElementById('toplam_colon_'+y).value = filterNum(document.getElementById('toplam_colon_'+y).value);
	}
}
/*function son_deger_degis(satir_id,kolon_no)
{
	son_deger = eval("form_basket.team_" + satir_id + "_" + kolon_no + ".value");
	son_deger = filterNum(son_deger);
}
*/
function get_first_value(deger_,team_id,k)
{
	if(deger_ == '')
		deger_ = 0;
	son_deger = deger_;
}

function toplam_al(satir_id,kolon_no)
{
		gelen_satir_toplam = document.getElementById('toplam_' + satir_id).value;
		gelen_satir_toplam = filterNum(gelen_satir_toplam);
		gelen_input = document.getElementById('team_' + satir_id + '_' + kolon_no).value;
		gelen_input = filterNum(gelen_input);
		gelen_kolon_toplam = document.getElementById('toplam_colon_' + kolon_no).value;
		gelen_kolon_toplam = filterNum(gelen_kolon_toplam);
		son_toplam = document.getElementById('son_toplam').value;
		son_toplam = filterNum(son_toplam);
		
		
		son_toplam = (parseInt(son_toplam) + parseInt(gelen_input)) - son_deger;
		gelen_kolon_toplam = (parseInt(gelen_kolon_toplam) + parseInt(gelen_input)) - son_deger;
		gelen_satir_toplam = (parseInt(gelen_satir_toplam) + parseInt(gelen_input)) - son_deger;
		
		gelen_input = commaSplit(gelen_input,0);
		gelen_satir_toplam = commaSplit(gelen_satir_toplam,0);
		gelen_kolon_toplam = commaSplit(gelen_kolon_toplam,0);
		son_toplam = commaSplit(son_toplam,0);
		
		document.getElementById('toplam_' + satir_id).value = gelen_satir_toplam;
		document.getElementById('toplam_colon_' + kolon_no).value = gelen_kolon_toplam;
		document.getElementById('team_' + satir_id + '_' + kolon_no).value = gelen_input;
		document.getElementById('son_toplam').value = son_toplam;
}
</script>

<cfif not isdefined("attributes.period_id") >
	<cfset attributes.period_id = SESSION.EP.PERIOD_ID>
</cfif>
<cfquery name="get_company_periods" datasource="#dsn#">
	SELECT PERIOD_ID,PERIOD FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> ORDER BY PERIOD_ID DESC
</cfquery>

<cfquery name="get_other_period" datasource="#dsn#">
	SELECT	
    	PERIOD_ID, 
        PERIOD,
        PERIOD_YEAR,
        OUR_COMPANY_ID
	FROM 
		SETUP_PERIOD
	WHERE 
		OUR_COMPANY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND 
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
</cfquery>
<cfset attributes.department_id = listfirst(attributes.id,'-')>
<cfset attributes.location_id = listlast(attributes.id,'-')>
<!---<cfquery name="GET_LOCATION_PERIODS" datasource="#dsn#">
	SELECT
		CP.*
	FROM
		STOCKS_LOCATION_PERIOD CP
	WHERE
		CP.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#"> AND 
		CP.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> AND 
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
</cfquery>--->
<cf_popup_box title='#getLang('stock',9)#'>
	<cfform name="add_period" method="post" action="#request.self#?fuseaction=stock.emptypopup_stock_location_period">
		<table>
			<input name="location_id" id="location_id" type="hidden" value="<cfoutput>#attributes.location_id#</cfoutput>" />
			<input name="department_id" id="department_id" type="hidden" value="<cfoutput>#attributes.department_id#</cfoutput>" />
			<cfif GET_OTHER_PERIOD.RECORDCOUNT>
				<input type="hidden" name="for_control" id="for_control" value="#PERIOD_YEAR#-#OUR_COMPANY_ID#-#PERIOD_ID#" />
				<input name="RECORD_NUM" id="RECORD_NUM" value="<cfoutput>#GET_OTHER_PERIOD.RECORDCOUNT#</cfoutput>" type="hidden" />
				<cfoutput query="GET_OTHER_PERIOD">
					<cfquery name="get_acc_code" datasource="#dsn#">
						SELECT
                            LOCATION_ID, 
                            DEPARTMENT_ID, 
                            PERIOD_ID, 
                            ACCOUNT_CODE, 
                            ACCOUNT_CODE_PUR, 
                            ACCOUNT_DISCOUNT, 
                            ACCOUNT_PRICE, 
                            ACCOUNT_PRICE_PUR, 
                            ACCOUNT_PUR_IADE, 
                            ACCOUNT_IADE,
                            ACCOUNT_YURTDISI, 
                            ACCOUNT_YURTDISI_PUR, 
                            ACCOUNT_DISCOUNT_PUR, 
                            PRODUCTION_COST, 
                            MATERIAL_CODE, 
                            ACCOUNT_EXPENDITURE, 
                            SALE_PRODUCT_COST, 
                            ACCOUNT_LOSS, 
                            SCRAP_CODE, 
                            MATERIAL_CODE_SALE, 
                            PRODUCTION_COST_SALE, 
                            SCRAP_CODE_SALE, 
                            RECORD_EMP, 
                            RECORD_DATE, 
                            RECORD_IP
						FROM
							STOCKS_LOCATION_PERIOD
						WHERE
							LOCATION_ID = #attributes.location_id# AND
							DEPARTMENT_ID = #attributes.department_id# AND
							PERIOD_ID = #GET_OTHER_PERIOD.PERIOD_ID#
					</cfquery>
					<tr height="20">
						<td width="80"><cf_get_lang no='17.Dönem Yıl'></td>
						<td>
							<select name="period_main_id" id="period_main_id" style="width:200px;" onChange="javascript:window.location.href='<cfoutput>#request.self#?fuseaction=stock.popup_list_stock_location_period&id=#attributes.id#&period_id=</cfoutput>' + add_period.period_main_id.options[add_period.period_main_id.options.selectedIndex].value;">
								<cfloop query="get_company_periods">
									<option value="#PERIOD_ID#" <cfif get_company_periods.PERIOD_ID eq attributes.period_id >selected</cfif>>#PERIOD#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang no='20.Satış Hesabı'></td>
						<td nowrap="nowrap">
							<input type="textbox" name="account_code" id="account_code" value="#get_acc_code.account_code#" style="width:200px;" onFocus="AutoComplete_Create('account_code','ACCOUNT_CODE','ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','account_code','add_period','3','250');" autocomplete="off">
							<a href="javascript://" onClick="pencere_ac('#session.ep.period_year#','#session.ep.company_id#','account_code');"><img src="/images/plus_thin.gif" align="absmiddle" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang no='21.Alış Hesabı'></td>
						<td>
							<input type="textbox" name="account_code_purchase" id="account_code_purchase" value="#get_acc_code.account_code_pur#" style="width:200px;" onFocus="AutoComplete_Create('account_code_purchase','ACCOUNT_CODE','ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','account_code_purchase','add_period','3','250');" autocomplete="off">
							<a href="javascript://" onClick="pencere_ac('#session.ep.period_year#','#session.ep.company_id#','account_code_purchase');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='903.Satış İskontoları'></td>
						<td>
							<input type="textbox"  name="account_discount" id="account_discount" value="#get_acc_code.account_discount#" style="width:200px;" onFocus="AutoComplete_Create('account_discount','ACCOUNT_CODE','ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','account_discount','add_period','3','250');" autocomplete="off">
							<a href="javascript://" onClick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_discount');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang no='22.Alış İskonto'></td>
						<td>
							<input type="textbox" name="account_discount_pur" id="account_discount_pur" value="#get_acc_code.account_discount_pur#" style="width:200px;" onFocus="AutoComplete_Create('account_discount_pur','ACCOUNT_CODE','ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','account_discount_pur','add_period','3','250');" autocomplete="off">
							<a href="javascript://" onClick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_discount_pur');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang no='30.Satış İade'></td>
						<td>
							<input type="textbox" name="account_iade" id="account_iade" value="#get_acc_code.account_iade#" style="width:200px;" onFocus="AutoComplete_Create('account_iade','ACCOUNT_CODE','ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','account_iade','add_period','3','250');" autocomplete="off">
							<a href="javascript://" onClick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_iade');"><img src="/images/plus_thin.gif" align="absmiddle" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang no='36.Alış İade'></td>
						<td>
							<input type="textbox" name="account_pur_iade" id="account_pur_iade" value="#get_acc_code.account_pur_iade#" style="width:200px;" onFocus="AutoComplete_Create('account_pur_iade','ACCOUNT_CODE','ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','account_pur_iade','add_period','3','250');" autocomplete="off">
							<a href="javascript://" onClick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_pur_iade');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang no='38.Satış Fiyat Farkı'></td>
						<td>
							<input type="textbox" name="account_price" id="account_price" value="#get_acc_code.account_price#" style="width:200px;" onFocus="AutoComplete_Create('account_price','ACCOUNT_CODE','ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','account_price','add_period','3','250');" autocomplete="off">
							<a href="javascript://" onClick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_price');"><img src="/images/plus_thin.gif" align="absmiddle" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang no='49.Alış Fiyat Farkı'></td>
						<td>
							<input type="textbox" name="account_price_pur" id="account_price_pur" value="#get_acc_code.account_price_pur#" style="width:200px;" onFocus="AutoComplete_Create('account_price_pur','ACCOUNT_CODE','ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','account_price_pur','add_period','3','250');" autocomplete="off">
							<a href="javascript://" onClick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_price_pur');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td>Yurtdışı Satış</td>
						<td>
							<input type="textbox" name="account_yurtdisi" id="account_yurtdisi" value="#get_acc_code.account_yurtdisi#" style="width:200px;" onFocus="AutoComplete_Create('account_yurtdisi','ACCOUNT_CODE','ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','account_yurtdisi','add_period','3','250');" autocomplete="off">
							<a href="javascript://" onClick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_yurtdisi');"><img src="/images/plus_thin.gif" align="absmiddle" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td>Yurtdışı Alış</td>
						<td>
							<input type="textbox" name="account_yurtdisi_pur" id="account_yurtdisi_pur" value="#get_acc_code.account_yurtdisi_pur#" style="width:200px;" onFocus="AutoComplete_Create('account_yurtdisi_pur','ACCOUNT_CODE','ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','account_yurtdisi_pur','add_period','3','250');" autocomplete="off">
							<a href="javascript://" onClick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_yurtdisi_pur');"><img src="/images/plus_thin.gif" align="absmiddle" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='44.Üretim'></td>
						<td>
							<input type="textbox" name="production_cost" id="production_cost" value="#get_acc_code.production_cost#" style="width:200px;" onFocus="AutoComplete_Create('production_cost','ACCOUNT_CODE','ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','production_cost','add_period','3','250');" autocomplete="off">
							<a href="javascript://" onClick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','production_cost');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td>Hammadde Satış</td>
						<td>
							<input type="textbox" name="material_code_sale" id="material_code_sale" value="#get_acc_code.material_code_sale#" style="width:200px;" onFocus="AutoComplete_Create('material_code_sale','ACCOUNT_CODE','ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','material_code_sale','add_period','3','250');" autocomplete="off">
							<a href="javascript://" onClick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','material_code_sale');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang no='339.Hammadde'></td>
						<td>
							<input type="textbox" name="material_code" id="material_code" value="#get_acc_code.material_code#" style="width:200px;" onFocus="AutoComplete_Create('material_code','ACCOUNT_CODE','ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','material_code','add_period','3','250');" autocomplete="off">
							<a href="javascript://" onClick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','material_code');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td>Mamül Satış</td>
						<td>
							<input type="textbox" name="production_cost_sale" id="production_cost_sale" value="#get_acc_code.production_cost_sale#" style="width:200px;" onFocus="AutoComplete_Create('production_cost_sale','ACCOUNT_CODE','ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','production_cost_sale','add_period','3','250');" autocomplete="off">
							<a href="javascript://" onClick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','production_cost_sale');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td>Sarf</td>
						<td>
							<input type="textbox" name="account_expenditure" id="account_expenditure" value="#get_acc_code.account_expenditure#" style="width:200px;" onFocus="AutoComplete_Create('account_expenditure','ACCOUNT_CODE','ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','account_expenditure','add_period','3','250');" autocomplete="off">
							<a href="javascript://" onClick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_expenditure');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='1674.Fire'></td>
						<td>
							<input type="textbox" name="account_loss" id="account_loss" value="#get_acc_code.account_loss#" style="width:200px;" onFocus="AutoComplete_Create('account_loss','ACCOUNT_CODE','ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','account_loss','add_period','3','250');" autocomplete="off">
							<a href="javascript://" onClick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_loss');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap">Satılan Malın Maliyeti</td>
						<td>
							<input type="textbox" name="sale_product_cost" id="sale_product_cost" value="#get_acc_code.sale_product_cost#" style="width:200px;" onFocus="AutoComplete_Create('sale_product_cost','ACCOUNT_CODE','ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','sale_product_cost','add_period','3','250');" autocomplete="off">
							<a href="javascript://" onClick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','sale_product_cost');"><img src="/images/plus_thin.gif"   align="absmiddle" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap">Hurda Satış</td>
						<td>
							<input type="textbox" name="scrap_code_sale" id="scrap_code_sale" value="#get_acc_code.scrap_code_sale#" style="width:200px;" onFocus="AutoComplete_Create('scrap_code_sale','ACCOUNT_CODE','ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','scrap_code_sale','add_period','3','250');" autocomplete="off">
							<a href="javascript://" onClick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','scrap_code_sale');"><img src="/images/plus_thin.gif"   align="absmiddle" border="0" /></a>
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap">Hurda</td>
						<td>
							<input type="textbox" name="scrap_code" id="scrap_code" value="#get_acc_code.scrap_code#" style="width:200px;" onFocus="AutoComplete_Create('scrap_code','ACCOUNT_CODE','ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','scrap_code','add_period','3','250');" autocomplete="off">
							<a href="javascript://" onClick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','scrap_code');"><img src="/images/plus_thin.gif"   align="absmiddle" border="0" /></a>
						</td>
					</tr>
				</cfoutput>
				<input type="hidden" name="periods" id="periods" value="<cfoutput>#valuelist(GET_OTHER_PERIOD.PERIOD_ID)#</cfoutput>" />
			</cfif>
		</table>
		<cf_popup_box_footer>
			<cfsavecontent variable="message">Kaydet</cfsavecontent><cf_workcube_buttons is_upd='0' insert_info='#message#' add_function='control_wrk()'>
			<cfoutput> 
				<cfif len(get_acc_code.record_emp)>
					<cf_record_info query_name="get_acc_code">
				</cfif>
			</cfoutput>
		</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<script type="text/javascript">
	function pencere_ac(period,company,isim)
	{
		temp_account_code = eval('document.add_period.'+isim);
		if (temp_account_code.value.length >= 3)
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&db_source='+company+'&PERIOD_YEAR='+period+'&field_id=add_period.'+isim+'&account_code=' + temp_account_code.value</cfoutput>, 'list');
		else
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&db_source='+company+'&PERIOD_YEAR='+period+'&field_id=add_period.'+isim+'</cfoutput>', 'list');
	}
	function control_wrk()
	{
		var Dizi = new Array();	
		Dizi[0]= new Array ('account_code','Satış Hesabı Kayıtlı Değildir.')
		Dizi[1]= new Array ('account_code_purchase','Alış Hesabı Kayıtlı Değildir.')
		Dizi[2]= new Array ('account_discount','Satış İskonto Hesabı Kayıtlı Değildir.')
		Dizi[3]= new Array ('account_discount_pur','Alış İskonto Hesabı Kayıtlı Değildir.')
		Dizi[4]= new Array ('account_iade','Satış İade Hesabı Kayıtlı Değildir.')
		Dizi[5]= new Array ('account_pur_iade','Alış İade Hesabı Kayıtlı Değildir.')
		Dizi[6]= new Array ('account_price','Satış Fiyat Farkı Hesabı Kayıtlı Değildir.')
		Dizi[7]= new Array ('account_price_pur','Alış Fiyat Farkı Hesabı Kayıtlı Değildir.')
		Dizi[8]= new Array ('account_yurtdisi','Yurtdışı Satış Hesabı Kayıtlı Değildir.')
		Dizi[9]= new Array ('account_yurtdisi_pur','Yurtdışı Alış Hesabı Kayıtlı Değildir.')
		Dizi[10]= new Array ('production_cost','Üretim Hesabı Kayıtlı Değildir.')
		Dizi[11]= new Array ('material_code_sale','Hammadde Satış Hesabı Kayıtlı Değildir.')
		Dizi[12]= new Array ('material_code','Hammadde Hesabı Kayıtlı Değildir.')
		Dizi[13]= new Array ('production_cost_sale','Mamül Satış Hesabı Kayıtlı Değildir.')
		Dizi[14]= new Array ('account_expenditure','Sarf Hesabı Kayıtlı Değildir.')
		Dizi[15]= new Array ('account_loss','Fire Hesabı Kayıtlı Değildir.')
		Dizi[16]= new Array ('sale_product_cost','Satılan Malın Maliyeti Hesabı Kayıtlı Değildir.')
		Dizi[17]= new Array ('scrap_code_sale','Hurda Satış Hesabı Kayıtlı Değildir.')
		Dizi[18]= new Array ('scrap_code','Hurda Hesabı Kayıtlı Değildir.')
		for(i=0;i<=18;i++)
		{
			var my_value = document.getElementById(Dizi[i][0]).value;
			if(my_value != "")
				{ 
					if(WrkAccountControl(my_value,Dizi[i][1]) == 0){
						return false;
						break;
					}	
				}	
		}
		return true;
	}
</script>

<script type="text/javascript">
	function basamak_1()
	{
		if(confirm("Mali Tablo Tanımları Aktarım İşlemi Yapacaksınız!!! Bu İşlem Geri Alınamaz!!! Emin misiniz?"))
			document.form_.submit();
		else 
			return false;
	}
	function show_periods_departments(number)
	{
		if(number == 1)
		{
			if(document.getElementById('source_company').value != '')
			{
				var company_id = document.getElementById('source_company').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'kaynak_period_1',1,'Dönemler');
			}
		}
		else if(number == 2)
		{
			if(document.getElementById('target_company').value != '')
			{
				var company_id = document.getElementById('target_company').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'hedef_period_1',1,'Dönemler');
			}
		}
	}
	$(document).ready(function(){
		<cfif NOT (isdefined("attributes.target_company") and len(attributes.target_company))>
			var company_id = document.getElementById('target_company').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'hedef_period_1',1,'Dönemler');
		</cfif>
		}
	)
	$(document).ready(function(){
		<cfif NOT (isdefined("attributes.source_company") and len(attributes.source_company))>
			var company_id = document.getElementById('source_company').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'kaynak_period_1',1,'Dönemler');
		</cfif>
		}
	)
</script>
<cfquery name="get_companies" datasource="#dsn#">
	SELECT 
    	COMP_ID, 
        COMPANY_NAME
    FROM 
	    OUR_COMPANY 
</cfquery>
<cfparam name="attributes.is_income_table" default="">
<cfparam name="attributes.is_balance_sheet" default="">
<cfparam name="attributes.is_cash_flow_table" default="">
<cfparam name="attributes.is_cost_table" default="">
<cfif not isdefined("attributes.hedef_period")>
<cfsavecontent variable = "title">
	<cf_get_lang_main no='118.Mali Tablolar'><cf_get_lang no='1548.Aktarım'>
</cfsavecontent>
<cf_form_box title="#title#">
<form name="form_" method="post" action="">
	<cf_area width="50%">
		<table>
			<tr>
				<td colspan="2">
					<input type="checkbox" name="is_income_table" id="is_income_table" <cfif isDefined("attributes.is_income_table") and len(attributes.is_income_table)>checked</cfif>>
					<cf_get_lang dictionary_id='31795.Gelir Tablosu'>
					<input type="checkbox" name="is_balance_sheet" id="is_balance_sheet" <cfif isDefined("attributes.is_balance_sheet") and len(attributes.is_balance_sheet)>checked</cfif>>		
					<cf_get_lang dictionary_id='47270.Bilanço'>
					<input type="checkbox" name="is_cash_flow_table" id="is_cash_flow_table" <cfif isDefined("attributes.is_cash_flow_table") and len(attributes.is_cash_flow_table)>checked</cfif>>		
					<cf_get_lang dictionary_id='47267.Nakit Akım Tablosu'>
					<input type="checkbox" name="is_cost_table" id="is_cost_table" <cfif isDefined("attributes.is_cost_table") and len(attributes.is_cost_table)>checked</cfif>>		
					<cf_get_lang dictionary_id='64294.Satışların Maliyeti Tablosu'>
				</td>		
			</tr>
			<tr>
				<td><cf_get_lang no='1784.Kaynak Dönem'></td>
				<td style="width:200px;">
					<select name="source_company" id="source_company" onchange="show_periods_departments(1)" style="width:180px;">
						<cfoutput query="get_companies">
							<option value="#comp_id#" <cfif isdefined("attributes.source_company") and attributes.source_company eq comp_id>selected<cfelseif comp_id eq session.ep.company_id>selected</cfif>>#COMPANY_NAME#</option>
						</cfoutput>
					</select>
				</td>
				<td style="width:230px;">
				<div id="source_div">
					<select name="kaynak_period_1" id="kaynak_period_1" style="width:220px;">
						<cfif isdefined("attributes.source_company") and len(attributes.source_company)>
							<cfquery name="get_periods" datasource="#dsn#">
								SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #attributes.source_company# ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
							</cfquery>
							<cfoutput query="get_periods">				
								<option value="#period_id#" <cfif isdefined("attributes.kaynak_period_1") and attributes.kaynak_period_1 eq period_id>selected</cfif>>#period#</option>						
							</cfoutput>
						</cfif>
					</select>
				</div>
			</td>
			</tr>
			<tr>
				<td><cf_get_lang no ='1277.Hedef Dönem'></td>
				<td style="width:200px;">
					<select name="target_company" id="target_company" onchange="show_periods_departments(2)" style="width:180px;">
						
						<cfoutput query="get_companies">
							<option value="#comp_id#" <cfif isdefined("attributes.target_company") and attributes.target_company eq comp_id>selected<cfelseif comp_id eq session.ep.company_id>selected</cfif>>#COMPANY_NAME#</option>
						</cfoutput>
					</select>
				</td>
				<td style="width:230px;">
					<div id="target_div">
						<select name="hedef_period_1" id="hedef_period_1" style="width:220px;">
							<cfif isdefined("attributes.target_company") and len(attributes.target_company)>
								<cfoutput query="get_periods">				
									<option value="#period_id#" <cfif isdefined("attributes.hedef_period_1") and attributes.hedef_period_1 eq period_id>selected</cfif>>#period#</option>						
								</cfoutput>
							</cfif>
						</select>
					</div>
				</td>
			</tr>
			<tr>
				<td><input type="button" value="<cf_get_lang_main no ='1264.Aktar'>" onClick="basamak_1();"></td>
			</tr>
		</table>
	</cf_area>
	<cf_area width="50%">
		<table>
				<tr height="30">
					<td class="headbold" valign="top"><cf_get_lang_main no='21.Yardım'></td>
				</tr>    
				<tr>
					<!--- <td valign="top"> 
						<cftry>
							
							<cfinclude template="#file_web_path#templates/period_help/financialStatements_#session.ep.language#.html">
							<cfcatch>
								<script type="text/javascript">
									alert("<cf_get_lang_main no='1963.Yardım Dosyası Bulunamadı Lutfen Kontrol Ediniz'>");
								</script>
							</cfcatch>
						</cftry>
					</td> --->
					<td valign="top"><cfset getImportExpFormat("financialStatements") /></td>

				</tr>
			</table>
	</cf_area>
	</form>	
</cfif>
<cfif isdefined("attributes.hedef_period_1") and isdefined("attributes.kaynak_period_1")>
	<cfif not len(attributes.hedef_period_1)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2031.Hedef Period Seçmelisiniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfif not len(attributes.kaynak_period_1)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2064.Kaynak Dönem Secmelisiniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
		
	<cfquery name="get_hedef_period" datasource="#dsn#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.hedef_period_1#
	</cfquery>
	
	<cfquery name="get_kaynak_period" datasource="#dsn#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID= #attributes.kaynak_period_1#
	</cfquery>
	<form name="form1_" id="form1_" action="" method="post">
		<input type="hidden" name="income_table" id="income_table" value="<cfif isdefined("attributes.is_income_table") and len(attributes.is_income_table)>1</cfif>">
		<input type="hidden" name="balance_sheet" id="balance_sheet" value="<cfif isdefined("attributes.is_balance_sheet") and len(attributes.is_balance_sheet)>1</cfif>">
		<input type="hidden" name="cash_flow_table" id="cash_flow_table" value="<cfif isdefined("attributes.is_cash_flow_table") and len(attributes.is_cash_flow_table)>1</cfif>">
		<input type="hidden" name="cost_table" id="cost_table" value="<cfif isdefined("attributes.is_cost_table") and len(attributes.is_cost_table)>1</cfif>">
		<input type="hidden" name="aktarim_hedef_period" id="aktarim_hedef_period" value="<cfoutput>#attributes.hedef_period_1#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="<cfoutput>#get_kaynak_period.period_id#</cfoutput>">
		<input type="hidden" name="aktarim_hedef_year" id="aktarim_hedef_year" value="<cfoutput>#get_hedef_period.period_year#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_year" id="aktarim_kaynak_year" value="<cfoutput>#get_kaynak_period.period_year#</cfoutput>">
		<input type="hidden" name="aktarim_hedef_company" id="aktarim_hedef_company" value="<cfoutput>#get_hedef_period.OUR_COMPANY_ID#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_company" id="aktarim_kaynak_company" value="<cfoutput>#get_kaynak_period.our_company_id#</cfoutput>">
		<cf_get_lang no ='2028.Kaynak Veri Tabani'> : <cfoutput>#get_kaynak_period.period# (#get_kaynak_period.period_year#)</cfoutput><br/>
		<cf_get_lang no ='2029.Hedef Veri Tabanı'>: <cfoutput>#get_hedef_period.period# (#get_hedef_period.period_year#)</cfoutput><br/>
		<input type="button" value="<cf_get_lang no ='2027.Aktarimi Baslat'>" onClick="basamak_2();">
	</form>
	
	<!--- once hedef tabloda kayitlar varmi diye bakilir --->
	<cfset aaaa = "#dsn#_#get_hedef_period.period_year#_#get_hedef_period.OUR_COMPANY_ID#">
	<cfquery name="select_income_table" datasource="#aaaa#">
		SELECT COUNT(INCOME_ID) COUNT_INCOME FROM INCOME_TABLE
	</cfquery>
	<cfquery name="select_balance_form" datasource="#aaaa#">
		SELECT COUNT(BALANCE_ID) COUNT_BALANCE FROM BALANCE_SHEET_TABLE
	</cfquery>
	<cfquery name="select_cash_flow_table" datasource="#aaaa#">
		SELECT COUNT(CASH_FLOW_ID) COUNT_CASH FROM CASH_FLOW_TABLE
	</cfquery>
	<cfquery name="select_cost_table" datasource="#aaaa#">
		SELECT COUNT(COST_ID) COUNT_COST FROM COST_TABLE
	</cfquery>
	<script language="javascript">
		function basamak_2()
		{
			if(confirm("Mali Tablo Tanımları Aktarım İşlemi Yapacaksınız!!! Bu İşlem Geri Alınamaz!!! Emin misiniz?"))
			{
				<cfif select_income_table.count_income gt 0 or select_balance_form.COUNT_BALANCE gt 0 or select_cash_flow_table.COUNT_CASH gt 0 or select_cost_table.COUNT_COST gt 0>
					if(confirm("<cf_get_lang no ='2049.Bu aktarim daha önce yapılmıştır'>! Aktarım Yapılacak Dönemde Kayıtlı Mali Tablo Tanımları Silinecektir! Emin misiniz?"))
					{
						document.form1_.submit();
					}
					else 
						return false;
				<cfelse>
					document.form1_.submit();
				</cfif>
			}
			else
				return false;
		}
	</script>
</cfif>	

<cfif isdefined("attributes.aktarim_hedef_period")>	
	<cflock name="#CREATEUUID()#" timeout="70">
		<cftransaction>	
			<cfset hedef_dsn2 = '#dsn#_#attributes.aktarim_hedef_year#_#attributes.aktarim_hedef_company#'>
			<cfset kaynak_dsn2 = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#'>
			<!--- Gelir Tablosu Tanımları --->
			<cfif isdefined("attributes.income_table") and len(attributes.income_table)>
				<cfquery name="del_income_table" datasource="#hedef_dsn2#">
					DELETE FROM INCOME_TABLE
				</cfquery>
				<cfquery name="transfer_income_table" datasource="#hedef_dsn2#">
					SET IDENTITY_INSERT INCOME_TABLE ON
					
					INSERT INTO INCOME_TABLE
					(
						INCOME_ID,
						CODE,
						NAME,
						ACCOUNT_CODE,
						SIGN,
						BA,
						VIEW_AMOUNT_TYPE,
						IFRS_CODE,
						NAME_LANG_NO
					)
						SELECT DISTINCT
							INCOME_ID,
							CODE,
							NAME,
							ACCOUNT_CODE,
							SIGN,
							BA,
							VIEW_AMOUNT_TYPE,
							IFRS_CODE,
							NAME_LANG_NO
						FROM
							#kaynak_dsn2#.INCOME_TABLE
							
					SET IDENTITY_INSERT INCOME_TABLE OFF
				</cfquery>
				<cfquery name="del_income_table_def" datasource="#hedef_dsn2#">
					DELETE FROM ACCOUNT_DEFINITIONS WHERE DEF_TYPE_ID = 7
				</cfquery>
				<cfquery name="transfer_income_table_def" datasource="#hedef_dsn2#">
					INSERT INTO ACCOUNT_DEFINITIONS
					(
						DEF_TYPE_ID,
						DEF_TYPE_NAME,
						DEF_SELECTED_ROWS,
						DEF_FORM_TABLE,
						IS_DEPT_CLAIM_DETAIL
					)
						SELECT DISTINCT
							DEF_TYPE_ID,
							DEF_TYPE_NAME,
							DEF_SELECTED_ROWS,
							DEF_FORM_TABLE,
							IS_DEPT_CLAIM_DETAIL
						FROM
							#kaynak_dsn2#.ACCOUNT_DEFINITIONS
						WHERE 
							DEF_TYPE_ID = 7
				</cfquery>
			</cfif>
			<!--- Bilanco Form Tanımları --->
			<cfif isdefined("attributes.balance_sheet") and len(attributes.balance_sheet)>
				<cfquery name="del_balance_table" datasource="#hedef_dsn2#">
					DELETE FROM BALANCE_SHEET_TABLE
				</cfquery>
				<cfquery name="transfer_balance_form" datasource="#hedef_dsn2#">
					SET IDENTITY_INSERT BALANCE_SHEET_TABLE ON
					
					INSERT INTO BALANCE_SHEET_TABLE
					(
						BALANCE_ID,
						CODE,
						NAME,
						ACCOUNT_CODE,
						SIGN,
						BA,
						VIEW_AMOUNT_TYPE,
						IFRS_CODE,
						NAME_LANG_NO
					)
						SELECT DISTINCT
							BALANCE_ID,
							CODE,
							NAME,
							ACCOUNT_CODE,
							SIGN,
							BA,
							VIEW_AMOUNT_TYPE,
							IFRS_CODE,
							NAME_LANG_NO
						FROM
							#kaynak_dsn2#.BALANCE_SHEET_TABLE
							
					SET IDENTITY_INSERT BALANCE_SHEET_TABLE OFF
				</cfquery>
				<cfquery name="del_balance_table_def" datasource="#hedef_dsn2#">
					DELETE FROM ACCOUNT_DEFINITIONS WHERE DEF_TYPE_ID = 8
				</cfquery>
				<cfquery name="transfer_balance_form_def" datasource="#hedef_dsn2#">
					INSERT INTO ACCOUNT_DEFINITIONS
					(
						DEF_TYPE_ID,
						DEF_TYPE_NAME,
						DEF_SELECTED_ROWS,
						DEF_FORM_TABLE,
						IS_DEPT_CLAIM_DETAIL
					)
						SELECT DISTINCT
							DEF_TYPE_ID,
							DEF_TYPE_NAME,
							DEF_SELECTED_ROWS,
							DEF_FORM_TABLE,
							IS_DEPT_CLAIM_DETAIL
						FROM
							#kaynak_dsn2#.ACCOUNT_DEFINITIONS
						WHERE 
							DEF_TYPE_ID = 8
				</cfquery>
			</cfif>
			<!--- Nakit Akım Tablosu Tanımları --->
			<cfif isdefined("attributes.cash_flow_table") and len(attributes.cash_flow_table)>
				<cfquery name="del_cash_flow_table" datasource="#hedef_dsn2#">
					DELETE FROM CASH_FLOW_TABLE
				</cfquery>
				<cfquery name="transfer_cash_flow_table" datasource="#hedef_dsn2#">
						INSERT INTO CASH_FLOW_TABLE
						(
							CASH_FLOW_ID,
							CODE,
							NAME,
							ACCOUNT_CODE,
							SIGN,
							BA,
							VIEW_AMOUNT_TYPE,
							IFRS_CODE,
							NAME_LANG_NO
						)
							SELECT DISTINCT
								CASH_FLOW_ID,
								CODE,
								NAME,
								ACCOUNT_CODE,
								SIGN,
								BA,
								VIEW_AMOUNT_TYPE,
								IFRS_CODE,
								NAME_LANG_NO
							FROM
								#kaynak_dsn2#.CASH_FLOW_TABLE
				</cfquery>
				<cfquery name="del_cash_flow_table_def" datasource="#hedef_dsn2#">
					DELETE FROM ACCOUNT_DEFINITIONS WHERE DEF_TYPE_ID = 10
				</cfquery>
				<cfquery name="transfer_cash_flow_table_def" datasource="#hedef_dsn2#">
					INSERT INTO ACCOUNT_DEFINITIONS
					(
						DEF_TYPE_ID,
						DEF_TYPE_NAME,
						DEF_SELECTED_ROWS,
						DEF_FORM_TABLE,
						IS_DEPT_CLAIM_DETAIL
					)
						SELECT DISTINCT
							DEF_TYPE_ID,
							DEF_TYPE_NAME,
							DEF_SELECTED_ROWS,
							DEF_FORM_TABLE,
							IS_DEPT_CLAIM_DETAIL
						FROM
							#kaynak_dsn2#.ACCOUNT_DEFINITIONS
						WHERE 
							DEF_TYPE_ID = 10
				</cfquery>
			</cfif>
			<!--- Satışların Maliyeti Tablosu Tanımları --->
			<cfif isdefined("attributes.cost_table") and len(attributes.cost_table)>
				<cfquery name="del_cost_table" datasource="#hedef_dsn2#">
					DELETE FROM COST_TABLE
				</cfquery>
				<cfquery name="transfer_cost_table" datasource="#hedef_dsn2#">
						SET IDENTITY_INSERT COST_TABLE ON
						
						INSERT INTO COST_TABLE
						(
							COST_ID,
							CODE,
							NAME,
							ACCOUNT_CODE,
							SIGN,
							BA,
							VIEW_AMOUNT_TYPE,
							ZERO,
							ADD_,
							IFRS_CODE,
							NAME_LANG_NO
						)
							SELECT DISTINCT
								COST_ID,
								CODE,
								NAME,
								ACCOUNT_CODE,
								SIGN,
								BA,
								VIEW_AMOUNT_TYPE,
								ZERO,
								ADD_,
								IFRS_CODE,
								NAME_LANG_NO
							FROM
								#kaynak_dsn2#.COST_TABLE
								
						SET IDENTITY_INSERT COST_TABLE OFF
				</cfquery>
				<cfquery name="del_cost_table_def" datasource="#hedef_dsn2#">
					DELETE FROM ACCOUNT_DEFINITIONS WHERE DEF_TYPE_ID = 9
				</cfquery>
				<cfquery name="transfer_cost_table_def" datasource="#hedef_dsn2#">
					INSERT INTO ACCOUNT_DEFINITIONS
					(
						DEF_TYPE_ID,
						DEF_TYPE_NAME,
						DEF_SELECTED_ROWS,
						DEF_FORM_TABLE,
						IS_DEPT_CLAIM_DETAIL
					)
						SELECT DISTINCT
							DEF_TYPE_ID,
							DEF_TYPE_NAME,
							DEF_SELECTED_ROWS,
							DEF_FORM_TABLE,
							IS_DEPT_CLAIM_DETAIL
						FROM
							#kaynak_dsn2#.ACCOUNT_DEFINITIONS
						WHERE 
							DEF_TYPE_ID = 9
				</cfquery>
			</cfif>
			<script type="text/javascript">
				alert("<cf_get_lang no ='2020.İşlem Başarıyla Tamamlanmıştır'>!");
			</script>
		</cftransaction>
	</cflock>
</cfif>﻿

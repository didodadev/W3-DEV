<!--- KASA ID LERİYLE AKTARILACK SENEYE DUZENLENECEK, ÇEK ve SENETTE SORUN YAŞANIYORDU --->

<cfquery name="get_companies" datasource="#dsn#">
	SELECT 
    	COMP_ID, 
        COMPANY_NAME
    FROM 
	    OUR_COMPANY 
</cfquery>
<cfif not isdefined("attributes.hedef_period")>
<cfsavecontent variable = "title">
	<cf_get_lang no ='1783.kasa Aktarımı'>
</cfsavecontent>
<cf_form_box title="#title#">
	<cf_area width="50%">
					<form action="" method="post" name="form_">
					<table>
					<tr>
						<td><cf_get_lang no='1277.Hedef Dönem'></td>
						<td width="190">
							<select name="item_company_id" id="item_company_id"  onchange="show_periods_departments(1)"  style="width:200px;">
								<cfoutput query="get_companies">
									<option value="#comp_id#" <cfif isdefined("attributes.item_company_id") and attributes.item_company_id eq comp_id>selected<cfelseif comp_id eq session.ep.company_id>selected</cfif>>#company_name#</option>
								</cfoutput>
							</select>
						</td>
						<td>
							<div id="period_div">
								<select name="hedef_period_1" id="hedef_period_1" style="width:220px;">
									<cfif isdefined("attributes.item_company_id") and len(attributes.item_company_id)>
										<cfquery name="get_periods" datasource="#dsn#">
											SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #attributes.item_company_id# ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
										</cfquery>
										<cfoutput query="get_periods">				
											<option value="#period_id#" <cfif isdefined("attributes.hedef_period_1") and attributes.hedef_period_1 eq period_id>selected</cfif>>#period#</option>						
										</cfoutput>
									</cfif>
								</select>	
							</div>
						</td>
						<td width="80"><input type="checkbox" name="definition" id="definition" <cfif isdefined("attributes.definition") and len(definition)>checked</cfif>><cf_get_lang dictionary_id='57529.Tanımlar'></td>
						<td width="70"><input type="checkbox" name="bakiye" id="bakiye" onClick="gizle_goster();" <cfif isdefined("attributes.bakiye") and len(bakiye)>checked</cfif>><cf_get_lang dictionary_id='64295.Bakiyeler'></td>
						<td width="120" id="process_type_option" style="display:none;">
							<cf_workcube_process_cat slct_width="100" module_id="18">
						</td>
						<td><input type="button" value="<cf_get_lang_main no ='1264.Aktar'>" onClick="basamak_1();"></td>
					</tr>	
					</table>
					</form>
	</cf_area>
	<cf_area width="50%">
		<table>
				<tr height="30">
					<td class="headbold" valign="top"><cf_get_lang_main no='21.Yardım'></td>
				</tr>    
				<tr>
					<!--- <td valign="top"> 
						<cftry>
							<cfinclude template="#file_web_path#templates/period_help/cashTransfer_#session.ep.language#.html">
							<cfcatch>
								<script type="text/javascript">
									alert("<cf_get_lang_main no='1963.Yardım Dosyası Bulunamadı Lutfen Kontrol Ediniz'>");
								</script>
							</cfcatch>
						</cftry>
					</td> --->
					<td valign="top"><cfset getImportExpFormat("cashTransfer") /></td>
				</tr>
			</table>
	</cf_area>					     
</cf_form_box>		
</cfif>

<cfif isdefined("attributes.hedef_period_1")>
	<cfif not len(attributes.hedef_period_1)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2031.Hedef Period Seçmelisiniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfquery name="get_hedef_period" datasource="#dsn#">
		SELECT 
            PERIOD_ID, 
            PERIOD, 
            PERIOD_YEAR, 
            OUR_COMPANY_ID, 
            RECORD_DATE, 
            RECORD_IP, 
            RECORD_EMP, 
            UPDATE_DATE, 
            UPDATE_IP, 
            UPDATE_EMP, 
            IS_LOCKED 	
        FROM 
	        SETUP_PERIOD 
        WHERE 
        	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.hedef_period_1#">
	</cfquery>
	
	<cfquery name="get_kaynak_period" datasource="#dsn#">
		SELECT 
            PERIOD_ID, 
            PERIOD, 
            PERIOD_YEAR, 
            OUR_COMPANY_ID, 
            RECORD_DATE, 
            RECORD_IP, 
            RECORD_EMP, 
            UPDATE_DATE, 
            UPDATE_IP, 
            UPDATE_EMP, 
            IS_LOCKED	 	
        FROM 
    	    SETUP_PERIOD 
        WHERE 
	        OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hedef_period.OUR_COMPANY_ID#"> AND PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hedef_period.PERIOD_YEAR-1#">
	</cfquery>
	<cfif not get_kaynak_period.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2030.Kaynak Period Bulunamadı!Önceki Dönemi Olmayan Bir Döneme Aktarım Yapılamaz'>");
			history.back();
		</script>
		<cfabort>
	</cfif>
	
	<form action="" name="form1_" method="post">
		<input type="hidden" name="aktarim_hedef_period" id="aktarim_hedef_period" value="<cfoutput>#attributes.hedef_period_1#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="<cfoutput>#get_kaynak_period.period_id#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_year" id="aktarim_kaynak_year" value="<cfoutput>#get_kaynak_period.period_year#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_company" id="aktarim_kaynak_company" value="<cfoutput>#get_kaynak_period.our_company_id#</cfoutput>">
		<input type="hidden" name="aktarim_hedef_year" id="aktarim_hedef_year" value="<cfoutput>#get_hedef_period.period_year#</cfoutput>">
		<input type="hidden" name="aktarim_hedef_company" id="aktarim_hedef_company" value="<cfoutput>#get_hedef_period.OUR_COMPANY_ID#</cfoutput>">
		<input type="hidden" name="aktarim_process_cat" id="aktarim_process_cat" value="<cfoutput>#attributes.process_cat#</cfoutput>">
		<cfif isdefined("attributes.definition")><input type="hidden" name="aktarim_definition" id="aktarim_definition" value="1"></cfif>
		<cfif isdefined("attributes.bakiye")><input type="hidden" name="aktarim_bakiye" id="aktarim_bakiye" value="1"></cfif>
		<cf_get_lang no ='2028.Kaynak Veri Tabani'> : <cfoutput>#get_kaynak_period.period# (#get_kaynak_period.period_year#)</cfoutput><br>
		<cf_get_lang no ='2029.Hedef Veri Tabanı'> : <cfoutput>#get_hedef_period.period# (#get_hedef_period.period_year#)</cfoutput><br>
		<input type="button" value="<cf_get_lang no ='2027.Aktarimi Baslat'>" onClick="basamak_2();">
	</form>
</cfif>	
<cfif isdefined("attributes.aktarim_hedef_period")>	
	<cflock name="#CREATEUUID()#" timeout="70">
		<cftransaction>
			<cfset hedef_dsn2 = '#dsn#_#attributes.aktarim_hedef_year#_#attributes.aktarim_hedef_company#'>
			<cfset kaynak_dsn2 = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#'>
			<!--- once hedef taboda kayitlar varmi diye bakilir --->
			<cfquery name="SELECT_CASH" datasource="#hedef_dsn2#">
				SELECT 
					CASH_ID, 
					CASH_NAME, 
					CASH_ACC_CODE, 
					CASH_CODE, 
					BRANCH_ID, 
					ISOPEN, 
					CASH_CURRENCY_ID, 
					A_CHEQUE_ACC_CODE, 
					A_VOUCHER_ACC_CODE, 
					V_VOUCHER_ACC_CODE, 
					DUE_DIFF_ACC_CODE, 
					DEPARTMENT_ID, 
					CASH_EMP_ID,
					EMP_ID, 
					CASH_STATUS, 
					TRANSFER_CHEQUE_ACC_CODE, 
					TRANSFER_VOUCHER_ACC_CODE,
					IS_ALL_BRANCH, 
					RECORD_EMP, 
					RECORD_IP, 
					RECORD_DATE, 
					UPDATE_EMP, 
					UPDATE_IP, 
					UPDATE_DATE,
					PROTESTOLU_SENETLER_CODE,
					KARSILIKSIZ_CEKLER_CODE
				FROM 
					CASH
			</cfquery>
			<cfif isdefined("attributes.aktarim_definition") and aktarim_definition eq 1>
				<!--- yoksa eski donemdeki bilgiler yeni donemdeki tabloya aktarilir --->
				<cfquery name="get_money"  datasource="#hedef_dsn2#">
					SELECT MONEY FROM SETUP_MONEY 
				</cfquery>
				<cfif not get_money.recordcount>
					<script type="text/javascript">
						alert("<cf_get_lang no ='1747.Öncelikle Para birimi aktarınız'>!");
						history.back();
						window.close;
					</script>
					<cfabort>
				</cfif>
				<cfif SELECT_CASH.recordcount>
					<script type="text/javascript">
						alert("<cf_get_lang no ='2049.Bu aktarim daha önce yapılmıştır'>!");
						history.back();
						window.close;
					</script>
					<cfabort>
				<cfelse>
					<cfquery name="TRANSFER_CASH" datasource="#hedef_dsn2#">		
						SET IDENTITY_INSERT CASH ON
						
						INSERT INTO CASH
						(
							CASH_ID, 
							CASH_NAME, 
							CASH_ACC_CODE, 
							CASH_CODE, 
							BRANCH_ID, 
							ISOPEN, 
							CASH_CURRENCY_ID, 
							A_CHEQUE_ACC_CODE, 
							A_VOUCHER_ACC_CODE, 
							V_VOUCHER_ACC_CODE, 
							DUE_DIFF_ACC_CODE, 
							DEPARTMENT_ID, 
							CASH_EMP_ID,
							EMP_ID, 
							CASH_STATUS, 
							TRANSFER_CHEQUE_ACC_CODE, 
							TRANSFER_VOUCHER_ACC_CODE,
							IS_ALL_BRANCH, 
							RECORD_EMP, 
							RECORD_IP, 
							RECORD_DATE, 
							UPDATE_EMP, 
							UPDATE_IP, 
							UPDATE_DATE,
							PROTESTOLU_SENETLER_CODE,
							KARSILIKSIZ_CEKLER_CODE
						)
							SELECT
								CASH_ID, 
								CASH_NAME, 
								CASH_ACC_CODE, 
								CASH_CODE, 
								BRANCH_ID, 
								0, 
								CASH_CURRENCY_ID, 
								A_CHEQUE_ACC_CODE, 
								A_VOUCHER_ACC_CODE, 
								V_VOUCHER_ACC_CODE, 
								DUE_DIFF_ACC_CODE, 
								DEPARTMENT_ID, 
								CASH_EMP_ID,
								EMP_ID, 
								CASH_STATUS, 
								TRANSFER_CHEQUE_ACC_CODE, 
								TRANSFER_VOUCHER_ACC_CODE,
								IS_ALL_BRANCH, 
								CASH.RECORD_EMP, 
								CASH.RECORD_IP, 
								CASH.RECORD_DATE, 
								CASH.UPDATE_EMP, 
								CASH.UPDATE_IP, 
								CASH.UPDATE_DATE,
								PROTESTOLU_SENETLER_CODE,
								KARSILIKSIZ_CEKLER_CODE
							FROM
								#kaynak_dsn2#.CASH CASH,
								#hedef_dsn2#.SETUP_MONEY SETUP_MONEY
							WHERE 
								(CASH.CASH_CURRENCY_ID <> 'YTL' AND CASH.CASH_CURRENCY_ID = SETUP_MONEY.MONEY)
								OR
								(CASH.CASH_CURRENCY_ID = 'YTL' AND SETUP_MONEY.MONEY='TL')
					
						SET IDENTITY_INSERT CASH OFF
					</cfquery>
					<cfquery name="GET_" datasource="#hedef_dsn2#">
						SELECT DISTINCT
						 	sysobjects.NAME TABLE_NAME,
							syscolumns.NAME COLUM_NAME		
						FROM 
							INFORMATION_SCHEMA.COLUMNS ISC,
							syscolumns,
							sysobjects
						WHERE
							syscolumns.name = ISC.COLUMN_NAME AND
							sysobjects.name = ISC.TABLE_NAME and
							ISC.TABLE_SCHEMA = '#hedef_dsn2#' AND
							sysobjects.id=syscolumns.id AND
							syscolumns.xusertype IN (231,99,35,167)	AND 
							sysobjects.xtype='U' AND sysobjects.name<>'dtproperties' AND SUBSTRING(sysobjects.name,1,1) <> '_'
							AND sysobjects.NAME = 'CASH'
						ORDER BY
							sysobjects.NAME
					</cfquery> 
					<cfoutput query="GET_">
						<cfquery name="GET1" datasource="#hedef_dsn2#">
							SELECT #COLUM_NAME# FROM #TABLE_NAME# WHERE  #COLUM_NAME# = 'YTL'
						</cfquery>
						<cfif GET1.RECORDCOUNT>
							<cfquery name="upd_" datasource="#hedef_dsn2#">
								UPDATE #TABLE_NAME#  SET #COLUM_NAME# = 'TL' WHERE #COLUM_NAME# = 'YTL'
							</cfquery>
						</cfif>
					</cfoutput>
				</cfif>
			</cfif>
			<cfif isdefined("attributes.aktarim_bakiye") and aktarim_bakiye eq 1>
				<!--- once hedef taboda kayitlar varmi diye bakilir --->
				<cfquery name="SELECT_CASH_ACTIONS" datasource="#hedef_dsn2#">
					SELECT 
                        ACTION_ID, 
                        ACTION_DETAIL, 
                        RECORD_EMP, 
                        RECORD_DATE, 
                        RECORD_IP, 
                        UPDATE_EMP, 
                        UPDATE_DATE, 
                        UPDATE_IP
                    FROM 
                    	CASH_ACTIONS
				</cfquery>
				<cfif SELECT_CASH_ACTIONS.recordcount>
					<script type="text/javascript">
						alert("<cf_get_lang no ='2049.Bu aktarim daha önce yapılmıştır'>!");
						history.back();
						window.close;
					</script>
					<cfabort>
				<cfelseif SELECT_CASH.recordcount eq 0>
					<script type="text/javascript">
						alert("Hedef Dönemde Aktarım Yapılacak Kasa Tanımı Bulunamamıştır!");
						history.back();
						window.close;
					</script>
					<cfabort>
				<cfelse>
					<!--- Kasa Acilis Fisi Kaydedilecek (CASH_REMAINDER_LAST) --->
					<cfquery name="get_cash_remainder_last" datasource="#hedef_dsn2#">
						SELECT
						 	ISNULL(SUM(BORC-ALACAK),0) BAKIYE,
							ISNULL(SUM(OTHER_CASH_ACT_VALUE),0) OTHER_CASH_ACT_VALUE,
							ISNULL(SUM(ACTION_VALUE_2),0) ACTION_VALUE_2,
							ISNULL(SUM(ACTION_VALUE),0) ACTION_VALUE,
							CASH_ID,
							CASH_NAME,
							OTHER_MONEY,
							CASH_ACTION_CURRENCY_ID
						FROM
						(
							SELECT DISTINCT
								CASE WHEN CASH_ACTIONS.CASH_ACTION_TO_CASH_ID = CASH.CASH_ID THEN SUM(CASH_ACTIONS.CASH_ACTION_VALUE)ELSE 0 END AS BORC, 
								CASE WHEN CASH_ACTIONS.CASH_ACTION_FROM_CASH_ID = CASH.CASH_ID THEN SUM(CASH_ACTIONS.CASH_ACTION_VALUE) ELSE 0 END AS ALACAK, 
								SUM(CASH_ACTIONS.OTHER_CASH_ACT_VALUE) OTHER_CASH_ACT_VALUE,
								SUM(CASH_ACTIONS.ACTION_VALUE_2) ACTION_VALUE_2,
								SUM(CASH_ACTIONS.ACTION_VALUE) ACTION_VALUE,
								CASH.CASH_ID, 
								CASH.CASH_NAME,
								CASH_ACTIONS.OTHER_MONEY,
								CASH_ACTIONS.CASH_ACTION_CURRENCY_ID
							FROM
								#kaynak_dsn2#.CASH_ACTIONS, 
								#kaynak_dsn2#.CASH
							WHERE
								CASH_ACTIONS.CASH_ACTION_FROM_CASH_ID = CASH.CASH_ID OR CASH_ACTIONS.CASH_ACTION_TO_CASH_ID = CASH.CASH_ID
							GROUP BY
								CASH.CASH_ID, 
								CASH.CASH_NAME,
								CASH_ACTIONS.CASH_ACTION_TO_CASH_ID,
								CASH_ACTIONS.CASH_ACTION_FROM_CASH_ID,
								CASH_ACTIONS.OTHER_MONEY,
								CASH_ACTIONS.CASH_ACTION_CURRENCY_ID
						) T1
						GROUP BY
							CASH_ID,
							CASH_NAME,
							OTHER_MONEY,
							CASH_ACTION_CURRENCY_ID
					</cfquery>
					<!--- gecmis doneme ait hareket varsa aktarım yapılacak, yoksa herhangi bir bakiye aktarımı olmayacak. --->
					<cfif get_cash_remainder_last.recordcount>
						<cfquery name="get_process_type" datasource="#hedef_dsn2#">
							SELECT PROCESS_TYPE	FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.aktarim_process_cat#
						</cfquery>	
						<cfloop query="get_cash_remainder_last">
							<cfquery name="CASH_OPEN" datasource="#hedef_dsn2#">
								INSERT INTO
									CASH_ACTIONS
									(
										PROCESS_CAT,
										ACTION_TYPE,
										ACTION_TYPE_ID,
										ACTION_DATE,
										CASH_ACTION_VALUE,
										CASH_ACTION_CURRENCY_ID,
										<cfif bakiye gt 0>CASH_ACTION_TO_CASH_ID<cfelse>CASH_ACTION_FROM_CASH_ID</cfif>,
										OTHER_CASH_ACT_VALUE,
										OTHER_MONEY,
										ACTION_DETAIL,
										IS_ACCOUNT,
										IS_ACCOUNT_TYPE,
										RECORD_EMP,
										RECORD_IP,
										RECORD_DATE,
										ACTION_VALUE,
										ACTION_CURRENCY_ID
										<cfif len(session.ep.money2)>
											,ACTION_VALUE_2
											,ACTION_CURRENCY_ID_2
										</cfif>
									)
									VALUES
									(
										#attributes.aktarim_process_cat#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="KASA AÇILIŞI">,
										#get_process_type.process_type#,
										#now()#,
										#abs(get_cash_remainder_last.BAKIYE)#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_cash_remainder_last.CASH_ACTION_CURRENCY_ID#">,
										#get_cash_remainder_last.CASH_ID#,
										#get_cash_remainder_last.OTHER_CASH_ACT_VALUE#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_cash_remainder_last.OTHER_MONEY#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="Kasa Açılışı (Dönem Aktarım)">,
										1,
										30,
										#session.ep.userid#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
										DATEADD(dd,0,DATEDIFF(dd,0,#NOW()#)),
										#get_cash_remainder_last.ACTION_VALUE#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
										<cfif len(session.ep.money2)>
											,#get_cash_remainder_last.ACTION_VALUE_2#
											,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
										</cfif>
									)
							</cfquery>
							<cfquery name="GET_ACT_ID" datasource="#hedef_dsn2#">
								SELECT MAX(ACTION_ID) AS ACT_ID FROM CASH_ACTIONS
							</cfquery>
							<!--- acilan kasanin durumunu acik göster--->
							<cfquery name="UPD_CASH_STATUS" datasource="#hedef_dsn2#">
								UPDATE
									CASH
								SET
									ISOPEN=1
								WHERE
									CASH_ID = #get_cash_remainder_last.CASH_ID#
							</cfquery>
							<cfquery name="get_money_rate" datasource="#hedef_dsn2#">
								SELECT
									RATE1,
									RATE2,
									MONEY
								FROM
									#dsn_alias#.SETUP_MONEY
								WHERE 
									COMPANY_ID = #session.ep.company_id#
									AND PERIOD_ID = #session.ep.period_id#
							</cfquery>
							<cfif get_money_rate.recordcount>
								<cfloop query="get_money_rate">
									<cfquery name="add_money" datasource="#hedef_dsn2#">
										INSERT INTO CASH_ACTION_MONEY
										(
											ACTION_ID,
											MONEY_TYPE,
											RATE2,
											RATE1,
											IS_SELECTED
										)
										VALUES
										(
											#GET_ACT_ID.ACT_ID#,
											'#get_money_rate.MONEY#',
											#get_money_rate.rate2#,
											#get_money_rate.rate1#,
											<cfif get_cash_remainder_last.OTHER_MONEY is get_money_rate.MONEY>
												1
											<cfelse>
												0
											</cfif>	
										)
									</cfquery>
								</cfloop>
							</cfif>		
						</cfloop>
					</cfif>
				</cfif>
			</cfif>
		</cftransaction>
	</cflock>
	<script type="text/javascript">
		alert("<cf_get_lang no ='2020.İşlem Başarıyla Tamamlanmiştır'>!");
	</script>
</cfif>﻿
<script type="text/javascript">
	function basamak_1()
	{
		if(document.getElementById('bakiye').checked == true)
			if(!chk_process_cat('form_')) 
				return false;
		if(document.getElementById('bakiye').checked == true && document.getElementById('definition').checked)
		{
			alert("<cf_get_lang no ='817.Aynı Anda Kasa Tanımları ve Bakiyeleri Aktarılamaz Lütfen Önce Tanımları Aktarınız'>") ;
			return false;	
		}
				
		if(confirm("<cf_get_lang no ='2046.Kasa Aktarım İşlemi Yapacaksınız !!!Bu İşlem Geri Alınamaz!!! Emin misiniz'>?"))
			document.form_.submit();
		else 
			return false;
	}
	function basamak_2()
	{
		if(confirm("<cf_get_lang no ='2046.Kasa Aktarım İşlemi Yapacaksınız !!!Bu İşlem Geri Alınamaz!!! Emin misiniz'>?"))
			document.form1_.submit();
		else 
			return false;
	}
	function gizle_goster()
	{
		if(document.getElementById('bakiye').checked == true)
			process_type_option.style.display = '';
		else
			process_type_option.style.display = 'none';
	}
	$(document).ready(function(){
		<cfif NOT (isdefined("attributes.item_company_id") and len(attributes.item_company_id))>
			var company_id = document.getElementById('item_company_id').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'hedef_period_1',1,'Dönemler');
		</cfif>
	}
	)
	function show_periods_departments(number)
	{
		if(number == 1)
		{
			if(document.getElementById('item_company_id').value != '')
			{
				var company_id = document.getElementById('item_company_id').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'hedef_period_1',1,'Dönemler');
			}
		}
	}
</script>

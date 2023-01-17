<!--- Bilanco Tablosu --->
<cfinclude template="../query/get_branch_list.cfm">
<cfparam name="attributes.acc_card_type" default="">
<cfparam name="attributes.search_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.search_start_date" default="01/01/#session.ep.period_year#">
<cfparam name="attributes.is_submitted" default="0">
<cfparam name="attributes.table_code_type" default="0">
<cf_date tarih="attributes.search_date">
<cf_date tarih="attributes.search_start_date">
<cfif attributes.is_submitted eq 1>
	<cfinclude template="../query/get_balance_sheet.cfm">
	<cfinclude template="../query/get_income_table.cfm">
<cfelse>
	<cfset GET_BALANCE_DEF.recordcount=0>
	<cfset GET_BALANCE_SHEET.recordcount=0>
</cfif>
<cfif attributes.is_submitted eq 1 and GET_BALANCE_SHEET.recordcount eq 0>
	<table width="99%" align="center">
		<tr> 
			<td class="headbold"><cf_get_lang dictionary_id='47345.Bilanço Tablosu Tanimlarinizi Yapiniz'></td>
		</tr>
	</table>
	<cfexit method="exittemplate">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="form" action="#request.self#?fuseaction=account.list_balance_sheet" method="post">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cfinput type="hidden" name="maxrows" value="20">
				<cf_box_search>
					<div class="form-group">
						<cfinclude template="../query/get_money_list.cfm">                      	
					</div>
					<div class="form-group">
						<select name="table_code_type" id="table_code_type">
						<option value="0" <cfif attributes.table_code_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58793.Tek Düzen'></option>
						<option value="1" <cfif attributes.table_code_type eq 1>selected</cfif>><cf_get_lang dictionary_id='47352.UFRS Bazinda'></option>
						</select>                     	
					</div>
					<div class="form-group">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='47349.Lütfen Islem Baslangiç Tarihini Giriniz !'></cfsavecontent>
							<cfinput type="text" name="search_start_date" id="search_start_date" maxlength="10" value="#dateformat(attributes.search_start_date,dateformat_style)#" validate="#validate_style#" message="#message#" style="width:65px;">                     	
							<span class="input-group-addon"><cf_wrk_date_image date_field="search_start_date"></span>
						</div>
					</div>
					<div class="form-group">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='47349.Lütfen Islem Baslangiç Tarihini Giriniz !'></cfsavecontent>
							<cfinput type="text" name="search_date" id="search_date" maxlength="10" value="#dateformat(attributes.search_date,dateformat_style)#" required="Yes" validate="#validate_style#" message="#message#" style="width:65px;">
							<span class="input-group-addon"><cf_wrk_date_image date_field="search_date"></span>
						</div>
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
						<cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'>
					</div>
					<cfif isdefined("attributes.is_submitted") and attributes.is_submitted eq 1>
						<div class="form-group">
							<a class="ui-btn ui-btn-blue ui-btn-addon-right" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=account.popup_detail_bilanco&donen_varliklar='+document.balance_sheet_table.donen_varliklar.value+'&duran_varliklar='+document.balance_sheet_table.duran_varliklar.value+'&stoklar='+document.balance_sheet_table.stoklar.value+'&kisa_vadeli_yabanci='+document.balance_sheet_table.kisa_vadeli_yabanci.value+'&uzun_vadeli_yabanci='+document.balance_sheet_table.uzun_vadeli_yabanci.value+'&ozsermaye='+document.balance_sheet_table.ozsermaye.value);">
							<cfoutput>#getlang(328,'Mali Analizler',59296)#</cfoutput></a>
						</div>
					</cfif>			
					<cfif isdefined("attributes.is_submitted") and attributes.is_submitted eq 1 and not listfindnocase(denied_pages,'account.popup_add_financial_table')>
						<div class="form-group">
							<a class="ui-btn ui-btn-gray2" href="javascript://" onClick="save_balance();"><i class="fa fa-save"></i></a>
						</div>
					</cfif>		
				</cf_box_search>
				<cf_box_search_detail>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-acc_branch_id">
							<label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
							<div class="col col-12">
								<select multiple="multiple" name="acc_branch_id" id="acc_branch_id" style="width:175px;height:75px;">
									<optgroup label="<cf_get_lang dictionary_id='57453.Şube'>"></optgroup>
									<cfoutput query="get_branchs">
										<option value="#BRANCH_ID#" <cfif isdefined('attributes.acc_branch_id') and listfind(attributes.acc_branch_id,BRANCH_ID)>selected</cfif>>#BRANCH_NAME#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-acc_card_type">
							<label class="col col-12"><cfoutput>#getlang(86,'Fiş Türü',47348)#</cfoutput></label>
							<div class="col col-12">
								<cfquery name="get_acc_card_type" datasource="#dsn3#">
									SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
								</cfquery>
								<select multiple="multiple" name="acc_card_type" id="acc_card_type" style="width:200px;height:75px;">
									<cfoutput query="get_acc_card_type" group="process_type">
										<cfoutput>
										<option value="#process_type#-#process_cat_id#" <cfif listfind(attributes.acc_card_type,'#process_type#-#process_cat_id#',',')>selected</cfif>>#process_cat#</option>
										</cfoutput>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-is_bakiye">
							<label class="col col-12">
								<input type="checkbox" name="is_bakiye" id="is_bakiye" value="1" <cfif isdefined('attributes.is_bakiye')>checked</cfif>><cf_get_lang dictionary_id ='47402.Sadece Bakiyesi Olanlar'>
							</label>
						</div>
						<div class="form-group" id="item-is_system_money_2">
							<label class="col col-12">
								<input type="checkbox" name="is_system_money_2" id="is_system_money_2" value="1" <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>checked</cfif>><cf_get_lang dictionary_id='58905.Sistem Dövizi'>
							</label>
						</div>
						<div class="form-group" id="item-get_income_value">
							<label class="col col-12">
								<input type="checkbox" name="get_income_value" id="get_income_value" value="1" <cfif isdefined('attributes.get_income_value')>checked</cfif>><cf_get_lang dictionary_id="51820.Dönem Karı/Zararı Hesabını Gelir Tablosundan Aktar">
							</label>
						</div>
						<div class="form-group" id="item-no_process_accounts">
							<label class="col col-12">
								<input type="checkbox" name="no_process_accounts" id="no_process_accounts" value="0" <cfif isdefined('attributes.no_process_accounts')>checked</cfif>><cf_get_lang dictionary_id="47555.Hareket Görmeyenleri Getirme">
							</label>
						</div>
					</div>
				</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cfif attributes.is_submitted eq 1>
		<cfif get_balance_sheet.recordcount>
			<!--- gelir tablosu degerleri hespalama 20140203 --->
			<cfif GET_INCOME_DEF.RECORDCOUNT>
				<cfset acc_list_=listdeleteduplicates(Valuelist(get_income_table.account_code))>
				<cfquery name="GET_BAKIYE_ALL_INCOME" datasource="#DSN2#">
					SELECT 
						SUM(BAKIYE) AS BAKIYE,
						SUM(BORC) AS BORC,
						SUM(ALACAK) AS ALACAK,
						ACCOUNT_CODE
					FROM 
					(
						SELECT
							SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS BAKIYE, 
							SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC) AS BORC,
							SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS ALACAK, 
							SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC_2 - ACCOUNT_ACCOUNT_REMAINDER.ALACAK_2) AS BAKIYE_2, 
							SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC_2) AS BORC_2,
							SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK_2) AS ALACAK_2, 
							ACCOUNT_PLAN.ACCOUNT_CODE, 
							ACCOUNT_PLAN.ACCOUNT_NAME,
							ACCOUNT_PLAN.ACCOUNT_ID,
							ACCOUNT_PLAN.IFRS_CODE, 
							ACCOUNT_PLAN.IFRS_NAME,
							ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE,
							ACCOUNT_ACCOUNT_REMAINDER.CARD_TYPE,
							ACCOUNT_ACCOUNT_REMAINDER.CARD_CAT_ID	
						FROM
							ACCOUNT_PLAN,
							(
								SELECT
									0 AS ALACAK,
									0 AS ALACAK_2,
									SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS BORC,			
									SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS BORC_2,
									ACCOUNT_CARD_ROWS.ACCOUNT_ID,
									ACCOUNT_CARD.ACTION_DATE,
									ACCOUNT_CARD.CARD_TYPE,
									ACCOUNT_CARD.CARD_CAT_ID
								FROM
									<cfif attributes.table_code_type eq 0>
										ACCOUNT_CARD_ROWS
									<cfelseif attributes.table_code_type eq 1>
										ACCOUNT_ROWS_IFRS ACCOUNT_CARD_ROWS
									</cfif>
									,ACCOUNT_CARD
								WHERE
									BA = 0 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
								GROUP BY
									ACCOUNT_CARD_ROWS.ACCOUNT_ID,
									ACCOUNT_CARD.ACTION_DATE,
									ACCOUNT_CARD.CARD_TYPE,
									ACCOUNT_CARD.CARD_CAT_ID
								
								UNION
								
								SELECT
									SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS ALACAK, 
									SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS ALACAK_2,
									0 AS BORC,
									0 AS BORC_2,
									ACCOUNT_CARD_ROWS.ACCOUNT_ID,
									ACCOUNT_CARD.ACTION_DATE,
									ACCOUNT_CARD.CARD_TYPE,
									ACCOUNT_CARD.CARD_CAT_ID
								FROM
									<cfif attributes.table_code_type eq 0>
										ACCOUNT_CARD_ROWS
									<cfelseif attributes.table_code_type eq 1>
										ACCOUNT_ROWS_IFRS ACCOUNT_CARD_ROWS
									</cfif>
									,ACCOUNT_CARD
								WHERE
									BA = 1 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
								GROUP BY
									ACCOUNT_CARD_ROWS.ACCOUNT_ID,
									ACCOUNT_CARD.ACTION_DATE,
									ACCOUNT_CARD.CARD_TYPE,
									ACCOUNT_CARD.CARD_CAT_ID
							)ACCOUNT_ACCOUNT_REMAINDER
						WHERE
							(
								(ACCOUNT_PLAN.SUB_ACCOUNT=1 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE +'%')
								OR
								(ACCOUNT_PLAN.SUB_ACCOUNT=0 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE)
							)
							AND CARD_TYPE <> 19
						GROUP BY
							ACCOUNT_PLAN.ACCOUNT_CODE, 
							ACCOUNT_PLAN.ACCOUNT_NAME,
							ACCOUNT_PLAN.IFRS_CODE, 
							ACCOUNT_PLAN.IFRS_NAME,
							ACCOUNT_PLAN.ACCOUNT_ID, 
							ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE,
							ACCOUNT_ACCOUNT_REMAINDER.CARD_TYPE,
							ACCOUNT_ACCOUNT_REMAINDER.CARD_CAT_ID
					)t1
					WHERE
						<cfif len(acc_list_)>
							ACCOUNT_CODE IN (#ListQualify(acc_list_,"'",",")#)
						<cfelse>
							ACCOUNT_CODE IS NULL
						</cfif>
						<cfif len(attributes.search_date)>
							AND ACTION_DATE <= #attributes.search_date#
						</cfif>	
						<cfif len(attributes.search_start_date)>
							AND ACTION_DATE >= #attributes.search_start_date#
						</cfif>	
					GROUP BY
						ACCOUNT_CODE
				</cfquery>
				<cfquery name="GET_INCOME_TABLE_ALL" datasource="#dsn2#">
					SELECT  
						ACCOUNT_CODE,
						CODE,
						INCOME_ID
					FROM 
						INCOME_TABLE
				</cfquery>
				<cfif get_income_table.recordcount>
					<cfscript>
						temp_money_rate_=1;
						for(ind_a=1;ind_a lte GET_BAKIYE_ALL_INCOME.recordcount;ind_a=ind_a+1 )
						{
							temp_acc_=replace(GET_BAKIYE_ALL_INCOME.ACCOUNT_CODE[ind_a],".","_","all");
							'borc_#temp_acc_#' = GET_BAKIYE_ALL_INCOME.BORC[ind_a]/temp_money_rate_;
							'alacak_#temp_acc_#' = GET_BAKIYE_ALL_INCOME.ALACAK[ind_a]/temp_money_rate_;
							'bakiye_#temp_acc_#' = GET_BAKIYE_ALL_INCOME.BAKIYE[ind_a]/temp_money_rate_;
						}
					</cfscript>
					<cfoutput query="get_income_table">
						<cfif len(account_code)>
							<cfscript>
								borc2 = 0;
								alacak2 = 0;
								bakiye2 = 0;
								new_temp_acc_ =replace(ACCOUNT_CODE,".","_","all");
								if(isdefined('borc_#new_temp_acc_#') and len(evaluate('borc_#new_temp_acc_#')) ) borc=evaluate('borc_#new_temp_acc_#'); else borc=0;
								if(isdefined('alacak_#new_temp_acc_#') and len(evaluate('alacak_#new_temp_acc_#')) ) alacak=evaluate('alacak_#new_temp_acc_#'); else alacak=0;
								if(isdefined('bakiye_#new_temp_acc_#') and len(evaluate('bakiye_#new_temp_acc_#')) ) bakiye=evaluate('bakiye_#new_temp_acc_#'); else bakiye=0;
								acc_bakiye_control = bakiye;
								if (sign eq "-")
								{
									bakiye = -1*abs(bakiye);
									bakiye2 = -1*abs(bakiye2);
								}
								else
								{
									bakiye = abs(bakiye);
									bakiye2 = abs(bakiye2);
								}
							</cfscript>
						</cfif>
						<cfif find(".",code,1) eq 3>
							<cfquery name="GET_TOTAL2"  dbtype="query">
								SELECT 
									SUM(GET_BAKIYE_ALL_INCOME.BAKIYE) BAKIYE, 
									SUM(GET_BAKIYE_ALL_INCOME.BORC) BORC,
									SUM(GET_BAKIYE_ALL_INCOME.ALACAK) ALACAK 
								FROM 
									GET_BAKIYE_ALL_INCOME, 
									GET_INCOME_TABLE_ALL
								WHERE 
									GET_BAKIYE_ALL_INCOME.ACCOUNT_CODE = GET_INCOME_TABLE_ALL.ACCOUNT_CODE AND
									GET_INCOME_TABLE_ALL.CODE LIKE '#CODE#%' AND 
									GET_INCOME_TABLE_ALL.INCOME_ID IN(#SELECTED_LIST#)
							</cfquery>
							<cfscript>
								bakiye_total = 0;
								bakiye_total2 = 0;
								borc_total = 0;
								borc_total2 = 0;
								alacak_total = 0;
								alacak_total2 = 0;
								if(GET_TOTAL2.recordcount)
								{
									bakiye_total = get_total2.BAKIYE/temp_money_rate_;
									borc_total = get_total2.BORC/temp_money_rate_;
									alacak_total = get_total2.ALACAK/temp_money_rate_;
									if (sign eq "-")
									{
										bakiye_total = -1*abs(bakiye_total);
										bakiye_total2 = -1*abs(bakiye_total2);
									}
									else
									{
										bakiye_total = abs(bakiye_total);
										bakiye_total2 = abs(bakiye_total2);
									}
								}
							</cfscript>
						</cfif>
						<cfif isdefined("bakiye")>
							<cfswitch expression="#get_income_table.VIEW_AMOUNT_TYPE#">
								<cfcase value="0">
									<cfset last_bakiye = borc>
									<cfset last_bakiye_total = borc_total>
									<cfset last_bakiye2 = borc2>
									<cfset last_bakiye_total2 = borc_total2>
								</cfcase>
								<cfcase value="1">
									<cfset last_bakiye = alacak>
									<cfset last_bakiye_total = alacak_total>
									<cfset last_bakiye2 = alacak2>
									<cfset last_bakiye_total2 = alacak_total2>
								</cfcase>
								<cfcase value="2">
									<cfset last_bakiye = bakiye>
									<cfset last_bakiye_total = bakiye_total>
									<cfset last_bakiye2 = bakiye2>
									<cfset last_bakiye_total2 = bakiye_total2>
								</cfcase>
							</cfswitch>	
						<cfelse>
							<cfswitch expression="#get_income_table.VIEW_AMOUNT_TYPE#">
								<cfcase value="0">
									<cfset last_bakiye_total = borc_total>
									<cfset last_bakiye_total2 = borc_total2>
								</cfcase>
								<cfcase value="1">
									<cfset last_bakiye_total = alacak_total>
									<cfset last_bakiye_total2 = alacak_total2>
								</cfcase>
								<cfcase value="2">
									<cfset last_bakiye_total = bakiye_total>
									<cfset last_bakiye_total2 = bakiye_total2>
								</cfcase>
							</cfswitch>								
						</cfif>
						<cfif find(".",code) eq 0>
							<cfswitch expression="#trim(code)#">
								<cfcase value="01_">
									<cfset "toplam_#code#" = toplam_01.C + toplam_01.D >
								</cfcase>
								<cfcase value="02_">
									<cfset "toplam_#code#" = toplam_01_ + toplam_02.E >
								</cfcase>
								<cfcase value="03_">
									<cfset "toplam_#code#" = toplam_02_ + toplam_03.F + toplam_03.G + toplam_03.H>
								</cfcase>
								<cfcase value="04_">
									<cfset "toplam_#code#" = toplam_03_ + toplam_04.I + toplam_04.J>							
								</cfcase>
								<cfcase value="05_">
									<cfif not isdefined("toplam_05.K")><cfset "toplam_05.K" = 0></cfif>
									<cfset "toplam_#code#" = toplam_04_ + toplam_05.K>
									<cfset last_income_value_ = evaluate("toplam_#code#")>
								</cfcase>
							</cfswitch>
						<cfelseif find(".",code,4) neq 5 and find(".",code,1) eq 3>
							<cfif code eq "01.C">
								<!--- net satislar --->
								<cfset "toplam_#code#" = toplam_01.A + toplam_01.B >
							<cfelse>								 
								<cfset "toplam_#code#" = last_bakiye_total >
							</cfif>
						</cfif>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</cfif>
			<!--- gelir tablosu degerleri --->
			<cfquery name="get_setup_balance" datasource="#dsn2#">
				SELECT ACCOUNT_CODE,ACCOUNT_CODE_NO FROM SETUP_BALANCE_SHEET_LIST
			</cfquery>
			<cfset acc_list_=listdeleteduplicates(Valuelist(GET_BALANCE_SHEET.ACCOUNT_CODE))>
			<cfquery name="GET_BAKIYE_ALL" datasource="#DSN2#">
				SELECT 
					SUM(BAKIYE) BAKIYE,
					SUM(BORC) BORC,
					SUM(ALACAK) ALACAK,
					<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
					SUM(BAKIYE_2) BAKIYE_2,
					SUM(BORC_2) BORC_2,
					SUM(ALACAK_2) ALACAK_2,
					</cfif>
					<cfif attributes.table_code_type eq 0>
					ACCOUNT_CODE
					<cfelse>
					IFRS_CODE AS ACCOUNT_CODE
					</cfif>
				FROM 
				(
					SELECT
						SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS BAKIYE, 
						SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC) AS BORC,
						SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS ALACAK, 
						SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC_2 - ACCOUNT_ACCOUNT_REMAINDER.ALACAK_2) AS BAKIYE_2, 
						SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC_2) AS BORC_2,
						SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK_2) AS ALACAK_2, 
						ACCOUNT_PLAN.ACCOUNT_CODE, 
						ACCOUNT_PLAN.ACCOUNT_NAME,
						ACCOUNT_PLAN.ACCOUNT_ID,
						ACCOUNT_PLAN.IFRS_CODE, 
						ACCOUNT_PLAN.IFRS_NAME,
						ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE,
						ACCOUNT_ACCOUNT_REMAINDER.CARD_TYPE,
						ACCOUNT_ACCOUNT_REMAINDER.CARD_CAT_ID	
					FROM
						ACCOUNT_PLAN,
						(
							SELECT
								0 AS ALACAK,
								0 AS ALACAK_2,
								SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS BORC,			
								SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS BORC_2,
								ACCOUNT_CARD_ROWS.ACCOUNT_ID,
								ACCOUNT_CARD.ACTION_DATE,
								ACCOUNT_CARD.CARD_TYPE,
								ACCOUNT_CARD.CARD_CAT_ID
							FROM
								<cfif attributes.table_code_type eq 0>
									ACCOUNT_CARD_ROWS
								<cfelseif attributes.table_code_type eq 1>
									ACCOUNT_ROWS_IFRS ACCOUNT_CARD_ROWS
								</cfif>
								,ACCOUNT_CARD
							WHERE
								BA = 0 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
								<cfif isdefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
									AND ACCOUNT_CARD_ROWS.ACC_BRANCH_ID IN(#attributes.acc_branch_id#)
								</cfif>
								<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
									AND (
									<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
										(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
										<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
									</cfloop>  
										)
								</cfif>	
							GROUP BY
								ACCOUNT_CARD_ROWS.ACCOUNT_ID,
								ACCOUNT_CARD.ACTION_DATE,
								ACCOUNT_CARD.CARD_TYPE,
								ACCOUNT_CARD.CARD_CAT_ID
							
							UNION
							
							SELECT
								SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS ALACAK, 
								SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS ALACAK_2,
								0 AS BORC,
								0 AS BORC_2,
								ACCOUNT_CARD_ROWS.ACCOUNT_ID,
								ACCOUNT_CARD.ACTION_DATE,
								ACCOUNT_CARD.CARD_TYPE,
								ACCOUNT_CARD.CARD_CAT_ID
							FROM
								<cfif attributes.table_code_type eq 0>
									ACCOUNT_CARD_ROWS
								<cfelseif attributes.table_code_type eq 1>
									ACCOUNT_ROWS_IFRS ACCOUNT_CARD_ROWS
								</cfif>
								,ACCOUNT_CARD
							WHERE
								BA = 1 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
								<cfif isdefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
									AND ACCOUNT_CARD_ROWS.ACC_BRANCH_ID IN(#attributes.acc_branch_id#)
								</cfif>
								<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
									AND (
									<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
										(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
										<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
									</cfloop>  
										)
								</cfif>	
							GROUP BY
								ACCOUNT_CARD_ROWS.ACCOUNT_ID,
								ACCOUNT_CARD.ACTION_DATE,
								ACCOUNT_CARD.CARD_TYPE,
								ACCOUNT_CARD.CARD_CAT_ID
						)ACCOUNT_ACCOUNT_REMAINDER
					WHERE
						(
							(ACCOUNT_PLAN.SUB_ACCOUNT=1 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE +'%')
							OR
							(ACCOUNT_PLAN.SUB_ACCOUNT=0 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE)
						)
						AND CARD_TYPE <> 19
					GROUP BY
						ACCOUNT_PLAN.ACCOUNT_CODE, 
						ACCOUNT_PLAN.ACCOUNT_NAME,
						ACCOUNT_PLAN.IFRS_CODE, 
						ACCOUNT_PLAN.IFRS_NAME,
						ACCOUNT_PLAN.ACCOUNT_ID, 
						ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE,
						ACCOUNT_ACCOUNT_REMAINDER.CARD_TYPE,
						ACCOUNT_ACCOUNT_REMAINDER.CARD_CAT_ID
					<cfif isdefined('attributes.is_bakiye')>
						HAVING round(SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK),2) <> 0
					</cfif>
				)T1
				WHERE
				<cfif len(acc_list_)>
					ACCOUNT_CODE IN (#ListQualify(acc_list_,"'",",")#)
				<cfelse>
					ACCOUNT_CODE IS NULL
				</cfif>
				<cfif len(attributes.search_date)>
					AND ACTION_DATE <= #attributes.search_date#
				</cfif>	
				<cfif len(attributes.search_start_date)>
					AND ACTION_DATE >= #attributes.search_start_date#
				</cfif>
				GROUP BY
					<cfif attributes.table_code_type eq 0>
					ACCOUNT_CODE
					<cfelse>
					IFRS_CODE
					</cfif>
			</cfquery>
			<cfquery name="GET_BAKIYE_ALL_OPEN" datasource="#DSN2#">
				SELECT 
					SUM(BAKIYE) BAKIYE,
					SUM(BORC) BORC,
					SUM(ALACAK) ALACAK,
					<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
					SUM(BAKIYE_2) BAKIYE_2,
					SUM(BORC_2) BORC_2,
					SUM(ALACAK_2) ALACAK_2,
					</cfif>
					<cfif attributes.table_code_type eq 0>
					ACCOUNT_CODE
					<cfelse>
					IFRS_CODE AS ACCOUNT_CODE
					</cfif>
				FROM 
				(
					SELECT
						SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS BAKIYE, 
						SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC) AS BORC,
						SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS ALACAK, 
						SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC_2 - ACCOUNT_ACCOUNT_REMAINDER.ALACAK_2) AS BAKIYE_2, 
						SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC_2) AS BORC_2,
						SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK_2) AS ALACAK_2, 
						ACCOUNT_PLAN.ACCOUNT_CODE, 
						ACCOUNT_PLAN.ACCOUNT_NAME,
						ACCOUNT_PLAN.ACCOUNT_ID,
						ACCOUNT_PLAN.IFRS_CODE, 
						ACCOUNT_PLAN.IFRS_NAME,
						ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE,
						ACCOUNT_ACCOUNT_REMAINDER.CARD_TYPE,
						ACCOUNT_ACCOUNT_REMAINDER.CARD_CAT_ID	
					FROM
						ACCOUNT_PLAN,
						(
							SELECT
								0 AS ALACAK,
								0 AS ALACAK_2,
								SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS BORC,			
								SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS BORC_2,
								ACCOUNT_CARD_ROWS.ACCOUNT_ID,
								ACCOUNT_CARD.ACTION_DATE,
								ACCOUNT_CARD.CARD_TYPE,
								ACCOUNT_CARD.CARD_CAT_ID
							FROM
								<cfif attributes.table_code_type eq 0>
									ACCOUNT_CARD_ROWS
								<cfelseif attributes.table_code_type eq 1>
									ACCOUNT_ROWS_IFRS ACCOUNT_CARD_ROWS
								</cfif>
								,ACCOUNT_CARD
							WHERE
								ACCOUNT_CARD.CARD_TYPE = 10 AND
								BA = 0 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
								<cfif isdefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
									AND ACCOUNT_CARD_ROWS.ACC_BRANCH_ID IN(#attributes.acc_branch_id#)
								</cfif>
								<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
									AND (
									<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
										(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
										<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
									</cfloop>  
										)
								</cfif>	
							GROUP BY
								ACCOUNT_CARD_ROWS.ACCOUNT_ID,
								ACCOUNT_CARD.ACTION_DATE,
								ACCOUNT_CARD.CARD_TYPE,
								ACCOUNT_CARD.CARD_CAT_ID
							
							UNION
							
							SELECT
								SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS ALACAK, 
								SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS ALACAK_2,
								0 AS BORC,
								0 AS BORC_2,
								ACCOUNT_CARD_ROWS.ACCOUNT_ID,
								ACCOUNT_CARD.ACTION_DATE,
								ACCOUNT_CARD.CARD_TYPE,
								ACCOUNT_CARD.CARD_CAT_ID
							FROM
								<cfif attributes.table_code_type eq 0>
									ACCOUNT_CARD_ROWS
								<cfelseif attributes.table_code_type eq 1>
									ACCOUNT_ROWS_IFRS ACCOUNT_CARD_ROWS
								</cfif>
								,ACCOUNT_CARD
							WHERE
								ACCOUNT_CARD.CARD_TYPE = 10 AND
								BA = 1 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
								<cfif isdefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
									AND ACCOUNT_CARD_ROWS.ACC_BRANCH_ID IN(#attributes.acc_branch_id#)
								</cfif>
								<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
									AND (
									<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
										(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
										<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
									</cfloop>  
										)
								</cfif>	
							GROUP BY
								ACCOUNT_CARD_ROWS.ACCOUNT_ID,
								ACCOUNT_CARD.ACTION_DATE,
								ACCOUNT_CARD.CARD_TYPE,
								ACCOUNT_CARD.CARD_CAT_ID
						)ACCOUNT_ACCOUNT_REMAINDER
					WHERE
						(
							(ACCOUNT_PLAN.SUB_ACCOUNT=1 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE +'%')
							OR
							(ACCOUNT_PLAN.SUB_ACCOUNT=0 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE)
						)
						AND CARD_TYPE <> 19
					GROUP BY
						ACCOUNT_PLAN.ACCOUNT_CODE, 
						ACCOUNT_PLAN.ACCOUNT_NAME,
						ACCOUNT_PLAN.IFRS_CODE, 
						ACCOUNT_PLAN.IFRS_NAME,
						ACCOUNT_PLAN.ACCOUNT_ID, 
						ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE,
						ACCOUNT_ACCOUNT_REMAINDER.CARD_TYPE,
						ACCOUNT_ACCOUNT_REMAINDER.CARD_CAT_ID
					<cfif isdefined('attributes.is_bakiye')>
						HAVING round(SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK),2) <> 0
					</cfif>
				)T1
				WHERE
				<cfif len(acc_list_)>
					ACCOUNT_CODE IN (#ListQualify(acc_list_,"'",",")#)
				<cfelse>
					ACCOUNT_CODE IS NULL
				</cfif>
				<cfif len(attributes.search_date)>
					AND ACTION_DATE <= #attributes.search_date#
				</cfif>	
				<cfif len(attributes.search_start_date)>
					AND ACTION_DATE >= #attributes.search_start_date#
				</cfif>
				GROUP BY
					<cfif attributes.table_code_type eq 0>
					ACCOUNT_CODE
					<cfelse>
					IFRS_CODE
					</cfif>
			</cfquery>
			<cfquery name="GET_OPEN_VALUES" datasource="#dsn2#">
				SELECT 
					ACR.AMOUNT,
					<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
						ACR.AMOUNT_2,
					</cfif>
					ACR.ACCOUNT_ID,
					LEFT(ACR.ACCOUNT_ID,3) ACCOUNT_ID_3,
					ACR.CARD_ID,
					ACR.BA
				FROM 
					<cfif attributes.table_code_type eq 0>
						ACCOUNT_CARD_ROWS ACR
					<cfelseif attributes.table_code_type eq 1>
						ACCOUNT_ROWS_IFRS ACR
					</cfif>
					,ACCOUNT_CARD AC
				WHERE
					AC.CARD_TYPE = 10 AND
					AC.CARD_ID = ACR.CARD_ID
					<cfif isdefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
						AND ACR.ACC_BRANCH_ID IN(#attributes.acc_branch_id#)
					</cfif>
					<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
						AND (
						<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
							(AC.CARD_TYPE = #listfirst(type_ii,'-')# AND AC.CARD_CAT_ID = #listlast(type_ii,'-')#)
							<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
						</cfloop>  
							)
					</cfif>	
			</cfquery>
		</cfif>
		<cfform action="#request.self#?fuseaction=account.popup_add_financial_table" method="post" name="balance_sheet_table">
			<input type="hidden" name="fintab_type" id="fintab_type" value="BALANCE_TABLE">
			<!-- sil -->
			<cfsavecontent variable="cont">
				<cf_box title="#getLang(8,'Bilanço',47270)#" uidrop="1" hide_table_column="1">
					<cf_grid_list><!---medium_list olmasının sebebi sayfa, bilanço kaydedilirken textara içerisine yazıdırılmasıdır. layout alanında fonksiyonların çakışmasını engellemek için yapılmışdır. OS290414--->
						<thead>
							<tr>
								<cfset colspan_ = 4>
								<cfif get_setup_balance.recordcount and get_setup_balance.account_code eq 1><cfset colspan_ = colspan_ + 1></cfif>
								<cfif get_setup_balance.recordcount and get_setup_balance.account_code_no eq 1><cfset colspan_ = colspan_ + 1></cfif>
								<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1><cfset colspan_ = colspan_ + 2></cfif>
								<th colspan="<cfoutput>#colspan_#</cfoutput>"><cfoutput>#session.ep.company_nick#-#session.ep.period_year#&nbsp;&nbsp;#dateformat(now(),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,now()),timeformat_style)#</cfoutput></th>
							</tr>
							<tr>
								<th colspan="2"><cfoutput>#dateFormat(attributes.search_start_date,dateformat_style)# - #dateFormat(attributes.search_date,dateformat_style)#</cfoutput></th>
									<cfif get_setup_balance.recordcount and get_setup_balance.account_code eq 1>
										<th class="form-title" nowrap><cfif attributes.table_code_type eq 1><cf_get_lang dictionary_id='58308.UFRS'><cfelse><cf_get_lang dictionary_id='47299.Hesap Kodu'></cfif></th>
									</cfif>
									<cfif get_setup_balance.recordcount and get_setup_balance.account_code_no eq 1>
										<th class="form-title" nowrap><cfif attributes.table_code_type eq 1><cf_get_lang dictionary_id='58308.UFRS'><cfelse><cf_get_lang dictionary_id='47299.Hesap Kodu'></cfif></th>
									</cfif>
								<th class="form-title" align="center" nowrap><!---<cfoutput>#Evaluate(session.ep.period_year-1)#</cfoutput>---><cf_get_lang dictionary_id='57940.Önceki Yıl'></th> 
								<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
									<th class="form-title" align="center" nowrap><cfoutput>#Evaluate(session.ep.period_year-1)# #session.ep.money2#</cfoutput></th> 
								</cfif>
								<th class="form-title" align="center" nowrap><cf_get_lang dictionary_id ='47330.Cari Dönem'></th>
								<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
									<th class="form-title" align="center" nowrap><cf_get_lang dictionary_id ='47330.Cari Dönem'><cfoutput>#session.ep.money2#</cfoutput></th> 
								</cfif>
							</tr>
						</thead>
						<tbody>
							<cfif get_balance_sheet.recordcount>
								<cfset temp_rate_=filterNum(attributes.rate,#session.ep.our_company_info.rate_round_num#)>
								<cfquery name="get_balance_sheet_acc" dbtype="query">
									SELECT * FROM get_balance_sheet WHERE ACCOUNT_CODE IS NOT NULL
								</cfquery>
								<cfscript>
									for(ind_a=1;ind_a lte GET_BAKIYE_ALL.recordcount;ind_a=ind_a+1 )
									{
										temp_acc_=replace(GET_BAKIYE_ALL.ACCOUNT_CODE[ind_a],".","_","all");
										'borc_#temp_acc_#' = GET_BAKIYE_ALL.BORC[ind_a]/temp_rate_;
										'alacak_#temp_acc_#' = GET_BAKIYE_ALL.ALACAK[ind_a]/temp_rate_;
										'acc_bakiye_#temp_acc_#' = abs(GET_BAKIYE_ALL.BAKIYE[ind_a])/temp_rate_;
										'bakiye_#temp_acc_#' = GET_BAKIYE_ALL.BAKIYE[ind_a]/temp_rate_;
										if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
										{
											'borc2_#temp_acc_#' = GET_BAKIYE_ALL.ALACAK_2[ind_a];
											'alacak2_#temp_acc_#' = GET_BAKIYE_ALL.BORC_2[ind_a];
											'acc_bakiye2_#temp_acc_#' = abs(GET_BAKIYE_ALL.BAKIYE_2[ind_a]);
										}
									}
									bakiye_total3 = 0;
									say = true;
									non_display_acc_list_active_ ='';
									non_display_acc_list_passive_='';
									for(kk_=1;kk_ lte get_balance_sheet_acc.recordcount;kk_=kk_+1 )
									{
										control_temp_acc_ =replace(get_balance_sheet_acc.ACCOUNT_CODE[kk_],".","_","all");
										'hesap_tersmi_#control_temp_acc_#' = false;
										if(isdefined('bakiye_#control_temp_acc_#') and len(evaluate('bakiye_#control_temp_acc_#')) and evaluate('bakiye_#control_temp_acc_#') neq 0)
											{
											if ((evaluate('bakiye_#control_temp_acc_#') lt 0 and get_balance_sheet_acc.ba[kk_] eq 0) or (evaluate('bakiye_#control_temp_acc_#') gt 0 and get_balance_sheet_acc.ba[kk_] eq 1))
												if (Len(GET_BALANCE_DEF.INVERSE_REMAINDER) and GET_BALANCE_DEF.INVERSE_REMAINDER)
													'hesap_tersmi_#control_temp_acc_#' = true;//yani hesap tersmis ters olduguna dikkat cekilecek
												else
												{
													if(find("A",get_balance_sheet_acc.code[kk_],1) eq 1) //aktif hesaplar ve pasif hesapların listeleri ayrı takip ediliyor
													non_display_acc_list_active_= listappend(non_display_acc_list_active_,get_balance_sheet_acc.code[kk_]);//  hesap ters bakiye verdigi ve ters hesaplar secilmedigi icin hesap gosterilmeyecek, ayrıca bu liste icindeki hesap kodları ust hesap bakiye hesaplamasına katılmaz
											else
												non_display_acc_list_passive_ = listappend(non_display_acc_list_passive_,get_balance_sheet_acc.code[kk_]);
											}
										}
									}
								</cfscript>
								<cfquery name="get_balance_sheet_A" dbtype="query">
									SELECT * FROM get_balance_sheet WHERE CODE LIKE 'A%'
								</cfquery>
								<cfset ters_hesap_code =''> <!--- ters bakiye vermis hesapların kodunu tutar ve bu liste icindeki kodlar ust hesapların bakiye toplamlarına dahil edilmez --->
								<cfoutput query="get_balance_sheet_A">
									<cfif len(account_code)>
										<cfscript>
											new_temp_acc_ =replace(ACCOUNT_CODE,".","_","all");
											if(isdefined('borc_#new_temp_acc_#') and len(evaluate('borc_#new_temp_acc_#')) ) borc=evaluate('borc_#new_temp_acc_#'); else borc=0;
											if(isdefined('alacak_#new_temp_acc_#') and len(evaluate('alacak_#new_temp_acc_#')) ) alacak=evaluate('alacak_#new_temp_acc_#'); else alacak=0;
											if(isdefined('acc_bakiye_#new_temp_acc_#') and len(evaluate('acc_bakiye_#new_temp_acc_#')) ) acc_bakiye=evaluate('acc_bakiye_#new_temp_acc_#'); else acc_bakiye=0;
											if(isdefined('bakiye_#new_temp_acc_#') and len(evaluate('bakiye_#new_temp_acc_#')) ) bakiye=evaluate('bakiye_#new_temp_acc_#'); else bakiye=0;
											if (sign eq "-")
												acc_bakiye = -1*acc_bakiye;
											if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
											{
												if(isdefined('borc2_#new_temp_acc_#') and len(evaluate('borc2_#new_temp_acc_#')) ) borc_2=evaluate('borc2_#new_temp_acc_#'); else borc_2=0;
												if(isdefined('alacak2_#new_temp_acc_#') and len(evaluate('alacak2_#new_temp_acc_#')) ) alacak_2=evaluate('alacak2_#new_temp_acc_#'); else alacak_2=0;
												if(isdefined('acc_bakiye2_#new_temp_acc_#') and len(evaluate('acc_bakiye2_#new_temp_acc_#')) ) acc_bakiye_2=evaluate('acc_bakiye2_#new_temp_acc_#'); else acc_bakiye_2=0;
												if (sign eq "-")
													acc_bakiye_2 = -1*acc_bakiye_2;
											}
										</cfscript>
										<!--- onceki donem acilis fisinden --->
										<cfquery dbtype="query" name="GET_VALUE_A">
											SELECT 
												SUM(AMOUNT) AMOUNT,
												<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													SUM(AMOUNT_2) AMOUNT_2,
												</cfif>
												BA
											FROM 
												GET_OPEN_VALUES 
											WHERE 
												ACCOUNT_ID LIKE '#ACCOUNT_CODE#%' 
												GROUP BY BA
										</cfquery>
										<cfscript>
											val_of_rem=0;
											val_of_rem_2=0;
											for(ii_=1;ii_ lte GET_VALUE_A.recordcount;ii_=ii_+1 )
												{
												if(GET_VALUE_A.BA[ii_] eq 0 and len(GET_VALUE_A.AMOUNT[ii_]))
													val_of_rem = GET_VALUE_A.AMOUNT[ii_];
												else if(GET_VALUE_A.BA[ii_] eq 1 and len(GET_VALUE_A.AMOUNT[ii_]))
													val_of_rem = val_of_rem-GET_VALUE_A.AMOUNT[ii_];
												if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
													{
														if(GET_VALUE_A.BA[ii_] eq 0 and len(GET_VALUE_A.AMOUNT_2[ii_]))
															val_of_rem_2 = GET_VALUE_A.AMOUNT_2[ii_];
														else if(GET_VALUE_A.BA[ii_] eq 1 and len(GET_VALUE_A.AMOUNT_2[ii_]))
															val_of_rem_2 = val_of_rem_2-GET_VALUE_A.AMOUNT_2[ii_];
													}
												}
											val_of_rem=abs(val_of_rem);
											if (sign eq "-")
												val_of_rem = -1*val_of_rem;
											if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
											{
												val_of_rem_2=abs(val_of_rem_2);
												if (sign eq "-")
												val_of_rem_2 = -1*val_of_rem_2;
											}
										</cfscript>
										<!--- onceki donem  --->
									</cfif>
									<cfif find(".",code) eq 0 or (not len(account_code) and find(".",code) neq 0)>
										<cfquery name="GET_TOTAL_ARTI_OPEN" dbtype="query">
											SELECT 
												SUM(GET_BAKIYE_ALL_OPEN.BAKIYE) BAKIYE, 
												SUM(GET_BAKIYE_ALL_OPEN.BORC) BORC,
												SUM(GET_BAKIYE_ALL_OPEN.ALACAK) ALACAK 
												<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													,SUM(BAKIYE_2) BAKIYE_2
													,SUM(BORC_2) BORC_2
													,SUM(ALACAK_2) ALACAK_2
												</cfif>
											FROM 
												GET_BAKIYE_ALL_OPEN,
												GET_BALANCE_SHEET
											WHERE 
												GET_BAKIYE_ALL_OPEN.ACCOUNT_CODE = GET_BALANCE_SHEET.ACCOUNT_CODE AND 
												GET_BALANCE_SHEET.CODE LIKE '#CODE#%' AND 	
												(GET_BALANCE_SHEET.SIGN IS NULL OR GET_BALANCE_SHEET.SIGN = '+') AND 
												<cfif len(non_display_acc_list_active_)>
													GET_BALANCE_SHEET.CODE NOT IN (#ListQualify(non_display_acc_list_active_,"'",',')#) AND 	
												</cfif>
												GET_BALANCE_SHEET.BALANCE_ID IN (#bal_def_sel_rows#)
										</cfquery>
										<cfquery name="GET_TOTAL_EKSI_OPEN"  dbtype="query">
											SELECT 
												SUM(GET_BAKIYE_ALL_OPEN.BAKIYE) BAKIYE, 
												SUM(GET_BAKIYE_ALL_OPEN.BORC) BORC,
												SUM(GET_BAKIYE_ALL_OPEN.ALACAK) ALACAK 
												<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													,SUM(BAKIYE_2) BAKIYE_2
													,SUM(BORC_2) BORC_2
													,SUM(ALACAK_2) ALACAK_2
												</cfif>
											FROM 
												GET_BAKIYE_ALL_OPEN,
												GET_BALANCE_SHEET
											WHERE 
												GET_BAKIYE_ALL_OPEN.ACCOUNT_CODE=GET_BALANCE_SHEET.ACCOUNT_CODE AND 
												GET_BALANCE_SHEET.CODE LIKE '#CODE#%' AND 
												GET_BALANCE_SHEET.SIGN = '-' AND 
												<cfif len(non_display_acc_list_active_)>
													GET_BALANCE_SHEET.CODE NOT IN (#ListQualify(non_display_acc_list_active_,"'",',')#) AND 	
												</cfif>
												GET_BALANCE_SHEET.BALANCE_ID IN (#bal_def_sel_rows#)
										</cfquery>
										<cfscript>
											borc_open=0; alacak_open=0; bakiye_total1_open=0;
											borc_2_open=0; alacak_2_open=0; bakiye_total1_2_open=0;
											if (GET_TOTAL_ARTI_OPEN.recordcount) 
											{
												bakiye_total1_open = bakiye_total1_open + abs(GET_TOTAL_ARTI_OPEN.BAKIYE/temp_rate_);
												borc_open = borc_open + (GET_TOTAL_ARTI_OPEN.BORC/temp_rate_);
												alacak_open = alacak_open + (GET_TOTAL_ARTI_OPEN.ALACAK/temp_rate_);
												if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
												{
													bakiye_total1_2_open = bakiye_total1_2_open + abs(GET_TOTAL_ARTI_OPEN.BAKIYE_2);
													borc_2_open = borc_2_open + (GET_TOTAL_ARTI_OPEN.BORC_2);
													alacak_2_open = alacak_2_open + (GET_TOTAL_ARTI_OPEN.ALACAK_2);
												}
											}
											if (GET_TOTAL_EKSI_OPEN.recordcount)
											{
												bakiye_total1_open = bakiye_total1_open - abs(GET_TOTAL_EKSI_OPEN.BAKIYE/temp_rate_);
												borc_open = borc_open + (GET_TOTAL_EKSI_OPEN.BORC/temp_rate_);
												alacak_open = alacak_open + (GET_TOTAL_EKSI_OPEN.ALACAK/temp_rate_);
												if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
													{
														bakiye_total1_2_open = bakiye_total1_2_open - abs(GET_TOTAL_EKSI_OPEN.BAKIYE_2);
														borc_2_open = borc_2_open + (GET_TOTAL_EKSI_OPEN.BORC_2);
														alacak_2_open = alacak_2_open + (GET_TOTAL_EKSI_OPEN.ALACAK_2);
													}
											}
										</cfscript> 
										<cfquery name="GET_TOTAL_ARTI" dbtype="query">
											SELECT 
												SUM(GET_BAKIYE_ALL.BAKIYE) BAKIYE, 
												SUM(GET_BAKIYE_ALL.BORC) BORC,
												SUM(GET_BAKIYE_ALL.ALACAK) ALACAK 
												<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													,SUM(BAKIYE_2) BAKIYE_2
													,SUM(BORC_2) BORC_2
													,SUM(ALACAK_2) ALACAK_2
												</cfif>
											FROM 
												GET_BAKIYE_ALL,
												GET_BALANCE_SHEET
											WHERE 
												GET_BAKIYE_ALL.ACCOUNT_CODE = GET_BALANCE_SHEET.ACCOUNT_CODE AND 
												GET_BALANCE_SHEET.CODE LIKE '#CODE#%' AND 	
												(GET_BALANCE_SHEET.SIGN IS NULL OR GET_BALANCE_SHEET.SIGN = '+') AND 
												<cfif len(non_display_acc_list_active_)>
													GET_BALANCE_SHEET.CODE NOT IN (#ListQualify(non_display_acc_list_active_,"'",',')#) AND 	
												</cfif>
												GET_BALANCE_SHEET.BALANCE_ID IN (#bal_def_sel_rows#)
										</cfquery>
										<cfquery name="GET_TOTAL_EKSI"  dbtype="query">
											SELECT 
												SUM(GET_BAKIYE_ALL.BAKIYE) BAKIYE, 
												SUM(GET_BAKIYE_ALL.BORC) BORC,
												SUM(GET_BAKIYE_ALL.ALACAK) ALACAK 
												<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													,SUM(BAKIYE_2) BAKIYE_2
													,SUM(BORC_2) BORC_2
													,SUM(ALACAK_2) ALACAK_2
												</cfif>
											FROM 
												GET_BAKIYE_ALL,
												GET_BALANCE_SHEET
											WHERE 
												GET_BAKIYE_ALL.ACCOUNT_CODE=GET_BALANCE_SHEET.ACCOUNT_CODE AND 
												GET_BALANCE_SHEET.CODE LIKE '#CODE#%' AND 
												GET_BALANCE_SHEET.SIGN = '-' AND 
												<cfif len(non_display_acc_list_active_)>
													GET_BALANCE_SHEET.CODE NOT IN (#ListQualify(non_display_acc_list_active_,"'",',')#) AND 	
												</cfif>
												GET_BALANCE_SHEET.BALANCE_ID IN (#bal_def_sel_rows#)
										</cfquery>
										<cfscript>
											borc=0; alacak=0; bakiye_total1=0;
											borc_2=0; alacak_2=0; bakiye_total1_2=0;
											if (GET_TOTAL_ARTI.recordcount) 
											{
												bakiye_total1 = bakiye_total1 + abs(GET_TOTAL_ARTI.BAKIYE/temp_rate_);
												borc = borc + (GET_TOTAL_ARTI.BORC/temp_rate_);
												alacak = alacak + (GET_TOTAL_ARTI.ALACAK/temp_rate_);
												if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
												{
													bakiye_total1_2 = bakiye_total1_2 + abs(GET_TOTAL_ARTI.BAKIYE_2);
													borc_2 = borc_2 + (GET_TOTAL_ARTI.BORC_2);
													alacak_2 = alacak_2 + (GET_TOTAL_ARTI.ALACAK_2);
												}
											}
											if (GET_TOTAL_EKSI.recordcount)
											{
												bakiye_total1 = bakiye_total1 - abs(GET_TOTAL_EKSI.BAKIYE/temp_rate_);
												borc = borc + (GET_TOTAL_EKSI.BORC/temp_rate_);
												alacak = alacak + (GET_TOTAL_EKSI.ALACAK/temp_rate_);
												if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
													{
														bakiye_total1_2 = bakiye_total1_2 - abs(GET_TOTAL_EKSI.BAKIYE_2);
														borc_2 = borc_2 + (GET_TOTAL_EKSI.BORC_2);
														alacak_2 = alacak_2 + (GET_TOTAL_EKSI.ALACAK_2);
													}
											}
										</cfscript> 
									</cfif>
									<cfset x=0>
									<cfif find(".",code) eq 0 or (not len(account_code) and find(".",code) neq 0)>
										<cfif isdefined('attributes.is_bakiye') and bakiye_total1 neq 0>
											<cfset x=1>
										</cfif>
									<cfelseif len(account_code)>
										<cfif isdefined('attributes.is_bakiye') and acc_bakiye neq 0>
											<cfset x=1>
										</cfif>
									</cfif>
									<cfif (x eq 1 or not isdefined('attributes.is_bakiye')) and not listfind(non_display_acc_list_active_,code,',')> <!--- gosterilmeyecek hesap kodları arasında degilse --->
										<tr class="color-list" height="20">
											<cfif get_setup_balance.recordcount and get_setup_balance.account_code eq 1>
												<td>#code#</td>
											</cfif>
											<cfif get_setup_balance.recordcount and get_setup_balance.account_code_no eq 1>
												<td width="15">
													<cfif ListLen(account_code,".") neq 1>
														<cfloop from="1" to="#ListLen(account_code,".")#" index="i">&nbsp;</cfloop>
													</cfif>
													#account_code# 
												</td>
											</cfif>
											<td height="20" colspan="2">
												<cfif ListLen(code,".") neq 1>
													<cfloop from="1" to="#ListLen(code,".")#" index="i">&nbsp;&nbsp;</cfloop>
												</cfif>
												<cfif find(".",code) eq 0><font color="ff0000"></cfif>
												<cfif len(NAME_LANG_NO)>#getLang('main',NAME_LANG_NO)#<cfelse>#name#</cfif><!--- hesap tanımlarının dil seti yapılmıssa, mainden dil alınıyor yoksa standart tanım yazdırılıyor--->
												<cfif find(".",code) eq 0></font></cfif>
											</td>
											<cfif find(".",code) eq 0 or (not len(account_code) and find(".",code) neq 0)>
												<td nowrap="nowrap" style="text-align:right;"><cfif not len(account_code)><font color="ff0000"></cfif>#TLFormat(bakiye_total1_open)#<cfif find(".",code) eq 0></font></cfif></td>
												<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													<td nowrap="nowrap" style="text-align:right;"><cfif not len(account_code)><font color="ff0000"></cfif>#TLFormat(bakiye_total1_2_open)#<cfif find(".",code) eq 0></font></cfif></td>
												</cfif>
												<td nowrap="nowrap" style="text-align:right;"><cfif find(".",code) eq 0><font color="ff0000"></cfif>#TLFormat(bakiye_total1)# #attributes.money#<cfif find(".",code) eq 0></font></cfif></td>
												<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													<td nowrap="nowrap" style="text-align:right;"><cfif find(".",code) eq 0><font color="ff0000"></cfif>#TLFormat(bakiye_total1_2)# #session.ep.money2#<cfif find(".",code) eq 0></font></cfif></td>
												</cfif>
											<cfelseif len(account_code)>
												<td nowrap="nowrap" style="text-align:right;">#TLFormat(val_of_rem)#</td><!--- onceki donem --->
												<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													<td nowrap="nowrap" style="text-align:right;">#TLFormat(val_of_rem_2)#</td><!--- onceki donem --->
												</cfif>
												<td nowrap="nowrap" style="text-align:right;">
													<cfif evaluate('hesap_tersmi_#new_temp_acc_#')><font color="ff0000"></cfif>
													<cfswitch expression="#GET_BALANCE_SHEET.VIEW_AMOUNT_TYPE#">
														<cfcase value="0">#TLFormat(borc)# #attributes.money#</cfcase>
														<cfcase value="1">#TLFormat(alacak)# #attributes.money#</cfcase>
														<cfcase value="2">#TLFormat(acc_bakiye)# #attributes.money#</cfcase>
													</cfswitch>
													<cfif evaluate('hesap_tersmi_#new_temp_acc_#')></font></cfif>
												</td>
												<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													<td nowrap="nowrap" style="text-align:right;">
														<cfif evaluate('hesap_tersmi_#new_temp_acc_#')><font color="ff0000"></cfif>
														<cfswitch expression="#GET_BALANCE_SHEET.VIEW_AMOUNT_TYPE#">
															<cfcase value="0">#TLFormat(borc_2)# #session.ep.money2#</cfcase>
															<cfcase value="1">#TLFormat(alacak_2)# #session.ep.money2#</cfcase>
															<cfcase value="2">#TLFormat(acc_bakiye_2)# #session.ep.money2#</cfcase>
														</cfswitch>
														<cfif evaluate('hesap_tersmi_#new_temp_acc_#')></font></cfif>
													</td>
												</cfif>
											</cfif>
											<cfif code eq 'A.01'><cfinput type="hidden" name="donen_varliklar" value="#TLFormat(bakiye_total1)#"></cfif>
											<cfif code eq 'A.02'><cfinput type="hidden" name="duran_varliklar" value="#TLFormat(bakiye_total1)#"></cfif>
											<cfif code eq 'A.01.E'><cfinput type="hidden" name="stoklar" value="#TLFormat(bakiye_total1)#"></cfif>
										</tr>
									</cfif>
								</cfoutput>
								<cfquery name="get_balance_sheet_P" dbtype="query">
									SELECT * FROM get_balance_sheet WHERE CODE LIKE 'P%'
								</cfquery>
								<cfoutput query="get_balance_sheet_P">
									<cfif len(account_code)>
										<cfscript>
										new_temp_acc_ =replace(ACCOUNT_CODE,".","_","all");
										if(isdefined('borc_#new_temp_acc_#') and len(evaluate('borc_#new_temp_acc_#')) ) borc=evaluate('borc_#new_temp_acc_#'); else borc=0;
										if(isdefined('alacak_#new_temp_acc_#') and len(evaluate('alacak_#new_temp_acc_#')) ) alacak=evaluate('alacak_#new_temp_acc_#'); else alacak=0;
										if(isdefined('acc_bakiye_#new_temp_acc_#') and len(evaluate('acc_bakiye_#new_temp_acc_#')) ) acc_bakiye=evaluate('acc_bakiye_#new_temp_acc_#'); else acc_bakiye=0;
										if(isdefined('bakiye_#new_temp_acc_#') and len(evaluate('bakiye_#new_temp_acc_#')) ) bakiye=evaluate('bakiye_#new_temp_acc_#'); else bakiye=0;
										if (sign eq "-")
										acc_bakiye = -1*acc_bakiye;
										if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
										{
										if(isdefined('borc2_#new_temp_acc_#') and len(evaluate('borc2_#new_temp_acc_#')) ) borc_2=evaluate('borc2_#new_temp_acc_#'); else borc_2=0;
										if(isdefined('alacak2_#new_temp_acc_#') and len(evaluate('alacak2_#new_temp_acc_#')) ) alacak_2=evaluate('alacak2_#new_temp_acc_#'); else alacak_2=0;
										if(isdefined('acc_bakiye2_#new_temp_acc_#') and len(evaluate('acc_bakiye2_#new_temp_acc_#')) ) acc_bakiye_2=evaluate('acc_bakiye2_#new_temp_acc_#'); else acc_bakiye_2=0;
										if (sign eq "-")
										acc_bakiye_2 = -1*acc_bakiye_2;
										}
										</cfscript>
										<!--- onceki donem acilis fisinden --->
										<cfquery dbtype="query" name="GET_VALUE_A">
											SELECT 
												SUM(AMOUNT) AMOUNT,
												<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													SUM(AMOUNT_2) AMOUNT_2,
												</cfif>
												BA
											FROM 
												GET_OPEN_VALUES 
											WHERE 
												ACCOUNT_ID LIKE '#ACCOUNT_CODE#%' 
												GROUP BY BA
										</cfquery>
										<cfscript>
											val_of_rem=0;
											val_of_rem_2=0;
											for(ii_=1;ii_ lte GET_VALUE_A.recordcount;ii_=ii_+1 )
											{
												if(GET_VALUE_A.BA[ii_] eq 0 and len(GET_VALUE_A.AMOUNT[ii_]))
												val_of_rem = GET_VALUE_A.AMOUNT[ii_];
												else if(GET_VALUE_A.BA[ii_] eq 1 and len(GET_VALUE_A.AMOUNT[ii_]))
												val_of_rem = val_of_rem-GET_VALUE_A.AMOUNT[ii_];
												if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
												{
													if(GET_VALUE_A.BA[ii_] eq 0 and len(GET_VALUE_A.AMOUNT_2[ii_]))
													val_of_rem_2 = GET_VALUE_A.AMOUNT_2[ii_];
													else if(GET_VALUE_A.BA[ii_] eq 1 and len(GET_VALUE_A.AMOUNT_2[ii_]))
													val_of_rem_2 = val_of_rem_2-GET_VALUE_A.AMOUNT_2[ii_];
												}
											}
											val_of_rem=abs(val_of_rem);
											if (sign eq "-")
											val_of_rem = -1*val_of_rem;
											if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
											{
												val_of_rem_2=abs(val_of_rem_2);
												if (sign eq "-")
												val_of_rem_2 = -1*val_of_rem_2;
											}
										</cfscript>
									<!--- onceki donem  --->
									</cfif>
									<cfif find(".",code) eq 0 or (not len(account_code) and find(".",code) neq 0)>
										<cfquery name="GET_TOTAL_ARTI_OPEN" dbtype="query">
											SELECT 
												SUM(GET_BAKIYE_ALL_OPEN.BAKIYE) BAKIYE, 
												SUM(GET_BAKIYE_ALL_OPEN.BORC) BORC,
												SUM(GET_BAKIYE_ALL_OPEN.ALACAK) ALACAK 
												<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													,SUM(BAKIYE_2) BAKIYE_2
													,SUM(BORC_2) BORC_2
													,SUM(ALACAK_2) ALACAK_2
												</cfif>
											FROM 
												GET_BAKIYE_ALL_OPEN,
												GET_BALANCE_SHEET
											WHERE 
												GET_BAKIYE_ALL_OPEN.ACCOUNT_CODE = GET_BALANCE_SHEET.ACCOUNT_CODE AND 
												GET_BALANCE_SHEET.CODE LIKE '#CODE#%' AND 	
												(GET_BALANCE_SHEET.SIGN IS NULL OR GET_BALANCE_SHEET.SIGN = '+') AND 
												<cfif len(non_display_acc_list_active_)>
													GET_BALANCE_SHEET.CODE NOT IN (#ListQualify(non_display_acc_list_active_,"'",',')#) AND 	
												</cfif>
												GET_BALANCE_SHEET.BALANCE_ID IN (#bal_def_sel_rows#)
										</cfquery>
										<cfquery name="GET_TOTAL_EKSI_OPEN"  dbtype="query">
											SELECT 
												SUM(GET_BAKIYE_ALL_OPEN.BAKIYE) BAKIYE, 
												SUM(GET_BAKIYE_ALL_OPEN.BORC) BORC,
												SUM(GET_BAKIYE_ALL_OPEN.ALACAK) ALACAK 
												<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													,SUM(BAKIYE_2) BAKIYE_2
													,SUM(BORC_2) BORC_2
													,SUM(ALACAK_2) ALACAK_2
												</cfif>
											FROM 
												GET_BAKIYE_ALL_OPEN,
												GET_BALANCE_SHEET
											WHERE 
												GET_BAKIYE_ALL_OPEN.ACCOUNT_CODE=GET_BALANCE_SHEET.ACCOUNT_CODE AND 
												GET_BALANCE_SHEET.CODE LIKE '#CODE#%' AND 
												GET_BALANCE_SHEET.SIGN = '-' AND 
												<cfif len(non_display_acc_list_active_)>
													GET_BALANCE_SHEET.CODE NOT IN (#ListQualify(non_display_acc_list_active_,"'",',')#) AND 	
												</cfif>
												GET_BALANCE_SHEET.BALANCE_ID IN (#bal_def_sel_rows#)
										</cfquery>
										<cfscript>
											borc_open=0; alacak_open=0; bakiye_total1_open=0;
											borc_2_open=0; alacak_2_open=0; bakiye_total1_2_open=0;
											if (GET_TOTAL_ARTI_OPEN.recordcount) 
											{
												bakiye_total1_open = bakiye_total1_open + abs(GET_TOTAL_ARTI_OPEN.BAKIYE/temp_rate_);
												borc_open = borc_open + (GET_TOTAL_ARTI_OPEN.BORC/temp_rate_);
												alacak_open = alacak_open + (GET_TOTAL_ARTI_OPEN.ALACAK/temp_rate_);
												if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
												{
													bakiye_total1_2_open = bakiye_total1_2_open + abs(GET_TOTAL_ARTI_OPEN.BAKIYE_2);
													borc_2_open = borc_2_open + (GET_TOTAL_ARTI_OPEN.BORC_2);
													alacak_2_open = alacak_2_open + (GET_TOTAL_ARTI_OPEN.ALACAK_2);
												}
											}
											if (GET_TOTAL_EKSI_OPEN.recordcount)
											{
												bakiye_total1_open = bakiye_total1_open - abs(GET_TOTAL_EKSI_OPEN.BAKIYE/temp_rate_);
												borc_open = borc_open + (GET_TOTAL_EKSI_OPEN.BORC/temp_rate_);
												alacak_open = alacak_open + (GET_TOTAL_EKSI_OPEN.ALACAK/temp_rate_);
												if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
													{
														bakiye_total1_2_open = bakiye_total1_2_open - abs(GET_TOTAL_EKSI_OPEN.BAKIYE_2);
														borc_2_open = borc_2_open + (GET_TOTAL_EKSI_OPEN.BORC_2);
														alacak_2_open = alacak_2_open + (GET_TOTAL_EKSI_OPEN.ALACAK_2);
													}
											}
										</cfscript> 
										<cfquery name="GET_TOTAL_ARTI" dbtype="query">
											SELECT 
												SUM(GET_BAKIYE_ALL.BAKIYE) BAKIYE, 
												SUM(GET_BAKIYE_ALL.BORC) BORC,
												SUM(GET_BAKIYE_ALL.ALACAK) ALACAK 
												<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													,SUM(BAKIYE_2) BAKIYE_2
													,SUM(BORC_2) BORC_2
													,SUM(ALACAK_2) ALACAK_2
												</cfif>
											FROM 
												GET_BAKIYE_ALL,
												GET_BALANCE_SHEET
											WHERE 
												GET_BAKIYE_ALL.ACCOUNT_CODE = GET_BALANCE_SHEET.ACCOUNT_CODE AND 
												GET_BALANCE_SHEET.CODE LIKE '#CODE#%' AND 	
												(GET_BALANCE_SHEET.SIGN IS NULL OR GET_BALANCE_SHEET.SIGN = '+') AND 
												<cfif len(non_display_acc_list_passive_)>
													GET_BALANCE_SHEET.CODE NOT IN (#ListQualify(non_display_acc_list_passive_,"'",',')#) AND 	
												</cfif>
												GET_BALANCE_SHEET.BALANCE_ID IN (#bal_def_sel_rows#)
										</cfquery>
										<cfquery name="GET_TOTAL_EKSI"  dbtype="query">
											SELECT 
												SUM(GET_BAKIYE_ALL.BAKIYE) BAKIYE, 
												SUM(GET_BAKIYE_ALL.BORC) BORC,
												SUM(GET_BAKIYE_ALL.ALACAK) ALACAK 
												<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													,SUM(BAKIYE_2) BAKIYE_2
													,SUM(BORC_2) BORC_2
													,SUM(ALACAK_2) ALACAK_2
												</cfif>
											FROM 
												GET_BAKIYE_ALL,
												GET_BALANCE_SHEET
											WHERE 
												GET_BAKIYE_ALL.ACCOUNT_CODE=GET_BALANCE_SHEET.ACCOUNT_CODE AND 
												GET_BALANCE_SHEET.CODE LIKE '#CODE#%' AND 
												GET_BALANCE_SHEET.SIGN = '-' AND 
												<cfif len(non_display_acc_list_passive_)>
													GET_BALANCE_SHEET.CODE NOT IN (#ListQualify(non_display_acc_list_passive_,"'",',')#) AND 	
												</cfif>
												GET_BALANCE_SHEET.BALANCE_ID IN (#bal_def_sel_rows#)
										</cfquery>
										<cfscript>
											borc=0; alacak=0; bakiye_total1=0;
											borc_2=0; alacak_2=0; bakiye_total1_2=0;
											if (GET_TOTAL_ARTI.recordcount) 
											{
												bakiye_total1 = bakiye_total1 + abs(GET_TOTAL_ARTI.BAKIYE/temp_rate_);
												borc = borc + (GET_TOTAL_ARTI.BORC/temp_rate_);
												alacak = alacak + (GET_TOTAL_ARTI.ALACAK/temp_rate_);
												if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
												{
													bakiye_total1_2 = bakiye_total1_2 + abs(GET_TOTAL_ARTI.BAKIYE_2);
													borc_2 = borc_2 + (GET_TOTAL_ARTI.BORC_2);
													alacak_2 = alacak_2 + (GET_TOTAL_ARTI.ALACAK_2);
												}
											}
											if (GET_TOTAL_EKSI.recordcount)
											{
												bakiye_total1 = bakiye_total1 - abs(GET_TOTAL_EKSI.BAKIYE/temp_rate_);
												borc = borc + (GET_TOTAL_EKSI.BORC/temp_rate_);
												alacak = alacak + (GET_TOTAL_EKSI.ALACAK/temp_rate_);
												if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
												{
													bakiye_total1_2 = bakiye_total1_2 - abs(GET_TOTAL_EKSI.BAKIYE_2);
													borc_2 = borc_2 + (GET_TOTAL_EKSI.BORC_2);
													alacak_2 = alacak_2 + (GET_TOTAL_EKSI.ALACAK_2);
												}
											}
										</cfscript> 
									</cfif>
									<cfset y=0>
									<cfif not listfind(non_display_acc_list_passive_,code,',')>
										<cfif find(".",code) eq 0 or (not len(account_code) and find(".",code) neq 0)>
											<cfif isdefined('attributes.is_bakiye') and bakiye_total1 neq 0>
												<cfset y=1>
											</cfif>
										<cfelseif len(account_code)>
											<cfif isdefined('attributes.is_bakiye') and acc_bakiye neq 0>
												<cfset y=1>
											</cfif>
										</cfif>
									</cfif>
									<cfif (y eq 1 or not isdefined('attributes.is_bakiye')) and not listfind(non_display_acc_list_passive_,code,',')> <!--- gosterilmeyecek hesap kodları arasında degilse --->
										<tr class="color-list" height="20">
											<cfif get_setup_balance.recordcount and get_setup_balance.account_code eq 1>
												<td>#code#</td>
											</cfif>
											<cfif get_setup_balance.recordcount and get_setup_balance.account_code_no eq 1>
												<td width="15">
													<cfif ListLen(account_code,".") neq 1>
														<cfloop from="1" to="#ListLen(account_code,".")#" index="i">&nbsp;</cfloop>
													</cfif>
													#account_code# 
												</td>
											</cfif>
											<td height="20" colspan="2">
												<cfif ListLen(code,".") neq 1>
													<cfloop from="1" to="#ListLen(code,".")#" index="i">&nbsp;&nbsp;</cfloop>
												</cfif>
												<cfif find(".",code) eq 0><font color="ff0000"></cfif>
												<cfif len(NAME_LANG_NO)>#getLang('main',NAME_LANG_NO)#<cfelse>#name#</cfif><!--- hesap tanımlarının dil seti yapılmıssa, mainden dil alınıyor yoksa standart tanım yazdırılıyor--->
												<cfif find(".",code) eq 0></font></cfif>
											</td>
											
											<cfif find(".",code) eq 0 or (not len(account_code) and find(".",code) neq 0)>
												<td nowrap="nowrap" style="text-align:right;"><cfif not len(account_code)><font color="ff0000"></cfif>#TLFormat(bakiye_total1_open)#<cfif find(".",code) eq 0></font></cfif></td>
												<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													<td nowrap="nowrap" style="text-align:right;"><cfif not len(account_code)><font color="ff0000"></cfif>#TLFormat(bakiye_total1_2_open)#<cfif find(".",code) eq 0></font></cfif></td>
												</cfif>
												<td nowrap="nowrap" style="text-align:right;"><cfif find(".",code) eq 0><font color="ff0000"></cfif>#TLFormat(bakiye_total1)# #attributes.money#<cfif find(".",code) eq 0></font></cfif></td>
												<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													<td nowrap="nowrap" style="text-align:right;"><cfif find(".",code) eq 0><font color="ff0000"></cfif>#TLFormat(bakiye_total1_2)# #session.ep.money2#<cfif find(".",code) eq 0></font></cfif></td>
												</cfif>
											<cfelseif len(account_code)>
												<td nowrap="nowrap" style="text-align:right;">#TLFormat(val_of_rem)#</td><!--- onceki donem --->
												<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													<td nowrap="nowrap" style="text-align:right;">#TLFormat(val_of_rem_2)#</td><!--- onceki donem --->
												</cfif>
												<td nowrap="nowrap" style="text-align:right;">
													<cfif account_code eq '590' and isdefined("attributes.get_income_value") and attributes.get_income_value eq 1>
														<cfif isdefined("last_income_value_") and last_income_value_ gt 0>
															<cfset income_value_ = last_income_value_>
														<cfelse>
															<cfset income_value_ = 0>
														</cfif>
													<cfelseif account_code eq '591' and isdefined("attributes.get_income_value") and attributes.get_income_value eq 1>
														<cfif isdefined("last_income_value_") and last_income_value_ lt 0>
															<cfset income_value_ = abs(last_income_value_)>
														<cfelse>
															<cfset income_value_ = 0>
														</cfif>
													<cfelse>
														<cfset income_value_ = 0>
													</cfif>
													<cfif evaluate('hesap_tersmi_#new_temp_acc_#')><font color="ff0000"></cfif>
													<cfswitch expression="#GET_BALANCE_SHEET.VIEW_AMOUNT_TYPE#">
														<cfcase value="0">#TLFormat(borc)# #attributes.money#</cfcase>
														<cfcase value="1">#TLFormat(alacak)# #attributes.money#</cfcase>
														<cfcase value="2">#TLFormat(acc_bakiye+income_value_)# #attributes.money#</cfcase>
													</cfswitch>
													<cfif evaluate('hesap_tersmi_#new_temp_acc_#')></font></cfif>
												</td>
												<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													<td nowrap="nowrap" style="text-align:right;">
														<cfif evaluate('hesap_tersmi_#new_temp_acc_#')><font color="ff0000"></cfif>
														<cfswitch expression="#GET_BALANCE_SHEET.VIEW_AMOUNT_TYPE#">
															<cfcase value="0">#TLFormat(borc_2)# #session.ep.money2#</cfcase>
															<cfcase value="1">#TLFormat(alacak_2)# #session.ep.money2#</cfcase>
															<cfcase value="2">#TLFormat(acc_bakiye_2)# #session.ep.money2#</cfcase>
														</cfswitch>
														<cfif evaluate('hesap_tersmi_#new_temp_acc_#')></font></cfif>
													</td>
												</cfif>
											</cfif>
											<cfif code eq 'P.01'><cfinput type="hidden" name="kisa_vadeli_yabanci" value="#TLFormat(bakiye_total1)#"></cfif>
											<cfif code eq 'P.02'><cfinput type="hidden" name="uzun_vadeli_yabanci" value="#TLFormat(bakiye_total1)#"></cfif>
											<cfif code eq 'P.03'><cfinput type="hidden" name="ozsermaye" value="#TLFormat(bakiye_total1)#"></cfif>
										</tr>
									</cfif>
								</cfoutput>
							<cfelse>
								<tr class="color-row" height="20">
									<td colspan="6"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</td>
								</tr>
							</cfif>
						</tbody>
					</cf_grid_list>
				</cf_box>
			</cfsavecontent>
			<cfoutput>#cont#</cfoutput>
			
		</cfform>
		<cfelse>
			<cf_box title="#getLang(8,'Bilanço',47270)#" uidrop="1" hide_table_column="1">
				<cf_grid_list>
					<tbody>
						<tr>
							<td height="25"><cf_get_lang dictionary_id='57701.Filtre Ediniz!'></td>
						</tr>
					</tbody>
				</cf_grid_list>
			</cf_box>
		</cfif>
</div>
<br />
<script type="text/javascript">
	function save_balance()
	{
		if (document.getElementById("search_date").value=='')
		{
			alert("<cf_get_lang dictionary_id ='47459.Önce Tarihleri Seçiniz'>!");
			return false;
		}
		date2 = document.getElementById("search_date").value;
		fintab_type_ = document.getElementById("fintab_type").value;
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=account.popup_add_financial_table&draggable=1&module=#fusebox.circuit#&faction=#fusebox.fuseaction#</cfoutput>&fintab_type='+fintab_type_+'&date2='+date2);
	}
</script>

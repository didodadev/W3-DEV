<!--- Gelir Tablosu --->
<!--- Select  ifadeleri ile ilgili çalışma yapıldı. Egemen Ateş 16.07.2012 --->
<cfinclude template="../query/get_branch_list.cfm">
<cfparam name="attributes.search_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.search_start_date" default="01/01/#session.ep.period_year#">
<cfparam name="attributes.table_code_type" default="0">
<cfparam name="attributes.is_submitted" default="0">
<cfparam name="attributes.acc_card_type" default="">
<cfif isdate(attributes.search_date)>
	<cf_date tarih = "attributes.search_date">
</cfif>
<cfif isdate(attributes.search_start_date)>
	<cf_date tarih = "attributes.search_start_date">
</cfif>
<cfif attributes.is_submitted eq 1>
	<cfinclude template="../query/get_income_table.cfm">
<cfelse>
	<cfset GET_INCOME_DEF.recordcount=0>
	<cfset get_income_table.recordcount=0>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_income" action="#request.self#?fuseaction=account.list_income_table" method="post">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1" style="width:65px;">
				<cf_box_search>
					<div class="form-group">
						<cfinclude template="../query/get_money_list.cfm">
					</div>
					<div class="form-group">
						<select name="table_code_type" id="table_code_type">
							<option value="0" <cfif attributes.table_code_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58793.Tek Düzen'></option>
							<option value="1" <cfif attributes.table_code_type eq 1>selected</cfif>> <cf_get_lang dictionary_id='47352.UFRS Bazinda'></option>
						</select>
					</div>
					<div class="form-group">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='47349.Lütfen Islem Baslangiç Tarihini Giriniz !'></cfsavecontent>
							<cfinput type="text" name="search_start_date" id="search_start_date" maxlength="10" value="#dateformat(attributes.search_start_date,dateformat_style)#" validate="#validate_style#" message="#message#" >
							<span class="input-group-addon"><cf_wrk_date_image date_field="search_start_date"></span>
						</div>	                           
					</div>
					<div class="form-group">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='47349.Lütfen Islem Baslangiç Tarihini Giriniz !'></cfsavecontent>
							<cfinput type="text" name="search_date" id="search_date" maxlength="10" value="#dateformat(attributes.search_date,dateformat_style)#" required="Yes" validate="#validate_style#" message="#message#" >
							<input type="hidden" name="maxrows" id="maxrows" value="20" >
							<span class="input-group-addon"><cf_wrk_date_image date_field="search_date"></span>
						</div>	                           
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
						<cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'>
					</div>
					<cfif isdefined("attributes.is_submitted") and attributes.is_submitted eq 1 and not listfindnocase(denied_pages,'account.popup_add_financial_table')>
						<div class="form-group">
							<a  class="ui-btn ui-btn-gray2" href="javascript://" onClick="save_income_table();"><i class="fa fa-save"></i></a>
						</div>
					</cfif>
				</cf_box_search>
				<cf_box_search_detail>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-acc_card_type">
							<label class="col col-12"><cfoutput>#getlang(1344,'Açılış Fişi',58756)#</cfoutput></label>
							<div class="col col-12">
								<cfquery name="get_acc_card_type" datasource="#dsn3#">
									SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
								</cfquery>
								<select multiple="multiple" name="acc_card_type" id="acc_card_type" >
									<cfoutput query="get_acc_card_type" group="process_type">
										<cfoutput>
											<option value="#process_type#-#process_cat_id#" <cfif listfind(attributes.acc_card_type,'#process_type#-#process_cat_id#',',')>selected</cfif>>#process_cat#</option>
										</cfoutput>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-acc_branch_id">
							<label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
							<div class="col col-12">
								<select multiple="multiple" name="acc_branch_id" id="acc_branch_id" >
									<optgroup label="<cf_get_lang dictionary_id='57453.Şube'>"></optgroup>
									<cfoutput query="get_branchs">
										<option value="#BRANCH_ID#" <cfif isdefined('attributes.acc_branch_id') and listfind(attributes.acc_branch_id,BRANCH_ID)>selected</cfif>>#BRANCH_NAME#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-is_bakiye">
							<label class="col col-12"><span class="hide"><cf_get_lang dictionary_id ='47402.Sadece Bakiyesi Olanlar'></span>&nbsp;</label>
							<label><cf_get_lang dictionary_id ='47402.Sadece Bakiyesi Olanlar'><input type="checkbox" name="is_bakiye" id="is_bakiye" value="1" <cfif isdefined('attributes.is_bakiye')>checked</cfif>></label>
						</div>
						<div class="form-group" id="item-is_system_money_2">
							<label><cf_get_lang dictionary_id='58905.Sistem Dövizi'><input type="checkbox" name="is_system_money_2" id="is_system_money_2" value="1" <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>checked</cfif>></label>
						</div>
					</div>
				</cf_box_search_detail>
		</cfform>
	</cf_box>
		<cfif attributes.is_submitted eq 1>
			<cfif GET_INCOME_DEF.RECORDCOUNT>
			<cfset acc_list_=listdeleteduplicates(Valuelist(get_income_table.account_code))>
			<cfquery name="GET_BAKIYE_ALL" DATASOURCE="#DSN2#" >
				SELECT 
					SUM(BAKIYE) AS BAKIYE,
					SUM(BORC) AS BORC,
					SUM(ALACAK) AS ALACAK,
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
					<cfif attributes.table_code_type eq 0>
						ACCOUNT_CODE
					<cfelse>
						IFRS_CODE
					</cfif>
			</cfquery>
			<cfquery name="GET_INCOME_TABLE_ALL" datasource="#dsn2#">
				SELECT  
					ACCOUNT_CODE,
					CODE,
					INCOME_ID
				FROM INCOME_TABLE
			</cfquery>
			<cfform action="#request.self#?fuseaction=account.popup_add_financial_table" method="post" name="income_table">
				<input type="hidden" name="fintab_type" id="fintab_type" value="INCOME_TABLE" />
				<cfsavecontent variable="cont">
					<cf_box title="#getLang(1,'Gelir Tablosu',47263)#" uidrop="1" hide_table_column="1">
						<cf_grid_list>
							<thead>
								<tr>
									<cfset colspan_ = 4>
									<th colspan="<cfoutput>#colspan_-1#</cfoutput>"><cfoutput>#dateFormat(attributes.search_start_date,dateformat_style)# - #dateFormat(attributes.search_date,dateformat_style)#&nbsp;&nbsp;#session.ep.company#-#session.ep.period_year#</cfoutput>
									<cf_get_lang dictionary_id='47263.Gelir Tablosu'></th>
									<th style="text-align:right"><cfoutput>#dateformat(now(),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,now()),timeformat_style)#</cfoutput></th>
								</tr>
								<tr>
									<th>&nbsp;</th>
									<th><cfif attributes.table_code_type eq 1><cf_get_lang dictionary_id='58308.UFRS'><cfelse><cf_get_lang dictionary_id='47299.Hesap Kodu'></cfif></th>
									<th><cf_get_lang dictionary_id='47300.Hesap Adı'></th>
									<th style="text-align:right;"><cf_get_lang dictionary_id ='47330.Cari Dönem'></th>
									<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
										<th><cf_get_lang dictionary_id ='47330.Cari Dönem'> <cfoutput>#session.ep.money2#</cfoutput></th>
									</cfif>
								</tr>
							</thead>
							<tbody>
								<cfif get_income_table.recordcount>
									<cfscript>
										temp_money_rate_=filterNum(attributes.rate,#session.ep.our_company_info.rate_round_num#);
										for(ind_a=1;ind_a lte GET_BAKIYE_ALL.recordcount;ind_a=ind_a+1 )
										{
											temp_acc_=replace(GET_BAKIYE_ALL.ACCOUNT_CODE[ind_a],".","_","all");
											'borc_#temp_acc_#' = GET_BAKIYE_ALL.BORC[ind_a]/temp_money_rate_;
											'alacak_#temp_acc_#' = GET_BAKIYE_ALL.ALACAK[ind_a]/temp_money_rate_;
											'bakiye_#temp_acc_#' = GET_BAKIYE_ALL.BAKIYE[ind_a]/temp_money_rate_;
											if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
											{
												'borc2_#temp_acc_#' = GET_BAKIYE_ALL.ALACAK_2[ind_a];
												'alacak2_#temp_acc_#' = GET_BAKIYE_ALL.BORC_2[ind_a];
												'bakiye2_#temp_acc_#' = abs(GET_BAKIYE_ALL.BAKIYE_2[ind_a]);
											}
										}
									</cfscript>
									<cfoutput query="get_income_table">
										<cfset normal_bakiye = true><!--- bakiye ters degil --->
										<cfif len(account_code)>
											<cfscript>
												borc2 = 0;
												alacak2 = 0;
												bakiye2 = 0;
												new_temp_acc_ =replace(ACCOUNT_CODE,".","_","all");
												if(isdefined('borc_#new_temp_acc_#') and len(evaluate('borc_#new_temp_acc_#')) ) borc=evaluate('borc_#new_temp_acc_#'); else borc=0;
												if(isdefined('alacak_#new_temp_acc_#') and len(evaluate('alacak_#new_temp_acc_#')) ) alacak=evaluate('alacak_#new_temp_acc_#'); else alacak=0;
												if(isdefined('bakiye_#new_temp_acc_#') and len(evaluate('bakiye_#new_temp_acc_#')) ) bakiye=evaluate('bakiye_#new_temp_acc_#'); else bakiye=0;
												if( isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
												{
													if(isdefined('borc2_#new_temp_acc_#') and len(evaluate('borc2_#new_temp_acc_#')) ) borc2=evaluate('borc2_#new_temp_acc_#'); else borc2=0;
													if(isdefined('alacak2_#new_temp_acc_#') and len(evaluate('alacak2_#new_temp_acc_#')) ) alacak2=evaluate('alacak2_#new_temp_acc_#'); else alacak2=0;
													if(isdefined('bakiye2_#new_temp_acc_#') and len(evaluate('bakiye2_#new_temp_acc_#')) ) bakiye2=evaluate('bakiye2_#new_temp_acc_#'); else bakiye2=0;
												}
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
													if (inv_rem eq 0 and ( (acc_bakiye_control lt 0 and ba eq 0) or (acc_bakiye_control gt 0 and ba eq 1) ) )
														normal_bakiye = false;/*bakiye ters geldi : ters bakiyeleri goster denmemis ve bakiye tersse gostermemek icin*/
											</cfscript>
										</cfif>
										<cfif normal_bakiye>
											<cfif find(".",code,1) eq 3>
												<cfquery name="GET_TOTAL2"  dbtype="query">
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
														GET_INCOME_TABLE_ALL
													WHERE 
														GET_BAKIYE_ALL.ACCOUNT_CODE = GET_INCOME_TABLE_ALL.ACCOUNT_CODE AND
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
														if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
														{
															bakiye_total2 = get_total2.BAKIYE_2/temp_money_rate_;
															borc_total2 = get_total2.BORC_2/temp_money_rate_;
															alacak_total2 = get_total2.ALACAK_2/temp_money_rate_;
														}
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
											<cfset tempCode = Replace(code,'.','_','all')>
											<cfif find(".",code) eq 0>
												<cfswitch expression="#trim(tempCode)#">
													<cfcase value="01_">
														<cfset "toplam_#tempCode#" = toplam_01_C + toplam_01_D >
													</cfcase>
													<cfcase value="02_">
														<cfset "toplam_#tempCode#" = toplam_01_ + toplam_02_E >
													</cfcase>
													<cfcase value="03_">
														<cfset "toplam_#tempCode#" = toplam_02_ + toplam_03_F + toplam_03_G + toplam_03_H>
													</cfcase>
													<cfcase value="04_">
														<cfset "toplam_#tempCode#" = toplam_03_ + toplam_04_I + toplam_04_J>							
													</cfcase>
													<cfcase value="05_">
														<cfif not isdefined("toplam_05_K")><cfset "toplam_05_K" = 0></cfif>
														<cfset "toplam_#tempCode#" = toplam_04_ + toplam_05_K>
													</cfcase>
												</cfswitch>
											<cfelseif find(".",code,4) neq 5 and find(".",code,1) eq 3>
												<cfif code eq "01.C">
													<!--- net satislar --->
													<cfset "toplam_#tempCode#" = toplam_01_A + toplam_01_B >
												<cfelse>								 
													<cfset "toplam_#tempCode#" = last_bakiye_total >
												</cfif>
											</cfif>
											<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
												<cfset tempCode2 = Replace(code,'.','_','all')>
												<cfif find(".",code) eq 0>
													<cfswitch expression="#trim(code)#">
														<cfcase value="01_">
															<cfset "toplam2_#tempCode2#" = toplam2_01_C + toplam2_01_D >
														</cfcase>
														<cfcase value="02_">
															<cfset "toplam2_#tempCode2#" = toplam2_01_ + toplam2_02_E >
														</cfcase>
														<cfcase value="03_">
															<cfset "toplam2_#tempCode2#" = toplam2_02_ + toplam2_03_F + toplam2_03_G + toplam2_03_H>
														</cfcase>
														<cfcase value="04_">
															<cfset "toplam2_#tempCode2#" = toplam2_03_ + toplam2_04_I + toplam2_04_J>							
														</cfcase>	
														<cfcase value="05_">
															<cfif not isdefined("toplam2_05_K")><cfset "toplam2_05_K" = 0></cfif>
															<cfset "toplam2_#tempCode2#" = toplam2_04_ + toplam2_05_K>
														</cfcase>				
													</cfswitch>
												<cfelseif find(".",code,1) eq 3>
													<cfif code eq "01.C">
														<!--- net satislar --->
														<cfset "toplam2_#tempCode2#" = toplam2_01_A + toplam2_01_B >
													<cfelse>
														<cfset "toplam2_#tempCode2#" = last_bakiye_total2 >
													</cfif>
												</cfif>						
											</cfif>
											<cfif (isdefined('attributes.is_bakiye') and bakiye_total neq 0) or not isdefined('attributes.is_bakiye') or (find(".",code) eq 0) or ((code eq "01.C") and (toplam_01_A + toplam_01_B) neq 0)>
												<tr class="color-row" height="20">
													<td><cfif len(code) gt 3>#right(code,len(code)-3)#</cfif></td>
													<td>
														<cfif ListLen(account_code,".") neq 1><cfloop from="1" to="#ListLen(account_code,".")#" index="i">&nbsp;</cfloop></cfif>
														#account_code#
													</td>
													<td>
														<cfif ListLen(code,".") neq 1><cfloop from="1" to="#ListLen(code,".")#" index="i">&nbsp;&nbsp;</cfloop></cfif>
														<cfif find(".",code) eq 0><font color="ff0000"></cfif>
															<cfif len(NAME_LANG_NO)>#getLang('main',NAME_LANG_NO)#<cfelse>#name#</cfif><!--- hesap tanımlarının dil seti yapılmıssa, mainden dil alınıyor yoksa standart tanım yazdırılıyor--->
														<cfif find(".",code) eq 0></font></cfif>
													</td>
													<td style="text-align:right;">
														<cfset tempCode = Replace(code,'.','_','all')>
														<cfif find(".",code) eq 0>
															<cfswitch expression="#trim(code)#">
																<cfcase value="01_">
																	#TLFormat(toplam_01_C + toplam_01_D)# #attributes.money#
																</cfcase>
																<cfcase value="02_">
																	#TLFormat(toplam_01_ + toplam_02_E)# #attributes.money#
																</cfcase>
																<cfcase value="03_">
																	#TLFormat(toplam_02_ + toplam_03_F + toplam_03_G + toplam_03_H)# #attributes.money#
																</cfcase>
																<cfcase value="04_">
																	#TLFormat(toplam_03_ + toplam_04_I + toplam_04_J)# #attributes.money#	
																</cfcase>
																<cfcase value="05_">
																	<cfif not isdefined("toplam_05_K")><cfset "toplam_05_K" = 0></cfif>
																	#TLFormat(toplam_04_ + toplam_05_K)# #attributes.money#
																</cfcase>	
															</cfswitch>
														<cfelseif find(".",code,4) eq 5>
															<cfif len(account_code)> #TLFormat(last_bakiye)# #attributes.money#</cfif>
														<cfelseif find(".",code,1) eq 3>
															<cfif code eq "01.C">
																<!--- net satislar --->
																#TLFormat(toplam_01_A + toplam_01_B)# #attributes.money#
															<cfelse>								 
																#TLFormat(last_bakiye_total)# #attributes.money#							 
															</cfif>
														</cfif>
													</td>
													<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
														<td style="text-align:right;">
														<cfif find(".",code) eq 0>
															<cfswitch expression="#trim(code)#">
																<cfcase value="01_">
																	#TLFormat(toplam2_01_C + toplam2_01_D)# #session.ep.money2#
																</cfcase>
																<cfcase value="02_">
																	#TLFormat(toplam2_01_ + toplam2_02_E)# #session.ep.money2#
																</cfcase>
																<cfcase value="03_">
																	#TLFormat(toplam2_02_ + toplam2_03_F + toplam2_03_G + toplam2_03_H)# #session.ep.money2#
																</cfcase>
																<cfcase value="04_">
																	#TLFormat(toplam2_03_ + toplam2_04_I + toplam2_04_J)# #session.ep.money2#	
																</cfcase>
																<cfcase value="05_">
																	#TLFormat(toplam2_04_ + toplam2_05_K)# #session.ep.money2#
																</cfcase>						
															</cfswitch>
														<cfelseif find(".",code,4) eq 5 >
															<cfif len(account_code)> #TLFormat(last_bakiye2)# #session.ep.money2#</cfif>
														<cfelseif find(".",code,1) eq 3 >
															<cfif code eq "01.C">
																<!--- net satislar --->
																#TLFormat(toplam2_01_A + toplam2_01_B)# #session.ep.money2#
															<cfelse>								 
																#TLFormat(last_bakiye_total2)# #session.ep.money2#							 
															</cfif>
														</cfif>						
														</td>
													</cfif>
												</tr>
											</cfif>
										</cfif>
									</cfoutput>
								<cfelse>
									<tr>
										<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
									</tr>
								</cfif>
							</tbody>
						</cf_grid_list>
					</cf_box>
				</cfsavecontent>
				<cfoutput>#cont#</cfoutput>
				<!-- sil -->          
			</cfform>
			<!-- sil -->
			<cfelse>
				<cf_box>
					<cf_grid_list>
						<tbody>
							<tr>
								<td><cf_get_lang dictionary_id='47287.Gelir Tablosu Tanımlarınızı Yapınız'>.</td>
							</tr>
						</tbody>
					</cf_grid_list>
				</cf_box>
			</cfif>
		<cfelse>
			<cf_box>
				<cf_grid_list>
					<tbody>
						<tr>
							<td><cf_get_lang dictionary_id='57701.Filtre Ediniz!'></td>
						</tr>
					</tbody>
				</cf_grid_list>
			</cf_box>
		</cfif>
</div>
<script type="text/javascript">
	function save_income_table()
	{
		if((document.getElementById("search_start_date").value=='') || (document.getElementById("search_date").value==''))
		{
			alert("<cf_get_lang dictionary_id ='47459.Önce Tarihleri Seçiniz'>!");
			return false;
		}
		date1 = document.getElementById("search_start_date").value;
		date2 = document.getElementById("search_date").value;
		fintab_type_ = document.getElementById("fintab_type").value;
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=account.popup_add_financial_table&draggable=1&module=#fusebox.circuit#&faction=#fusebox.fuseaction#</cfoutput>&fintab_type='+fintab_type_+'&date1='+date1+'&date2='+date2);
	}
</script>


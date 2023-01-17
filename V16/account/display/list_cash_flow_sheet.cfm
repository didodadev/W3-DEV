<!--- Nakit Akim Tablosu --->
<cfinclude template="../query/get_branch_list.cfm">
<cfparam name="attributes.acc_card_type" default="">
<cfparam name="attributes.search_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.search_start_date" default="01/01/#session.ep.period_year#">
<cfparam name="attributes.is_submitted" default="0">
<cfparam name="attributes.is_pre_period" default="0">
<cfparam name="attributes.table_code_type" default="0">
<cf_date tarih="attributes.search_date">
<cf_date tarih="attributes.search_start_date">
<cfif isdefined("is_submitted")>
	<cfinclude template="../query/get_cash_flow_table.cfm"> 
<cfelse>
	<cfset GET_CASH_FLOW_DEF.recordcount=0>
	<cfset GET_CASH_FLOW.recordcount=0>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="form" action="#request.self#?fuseaction=account.list_cash_flow_detail" method="post" enctype="multipart/form-data">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cf_box_search>
				<!--- Arama --->
					<cfinclude template="../query/get_money_list.cfm">
					<div class="form-group" id="table_code_type">
						<select name="table_code_type" id="table_code_type">
							<option value="0" <cfif attributes.table_code_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58793.Tek Düzen'></option>
							<option value="1" <cfif attributes.table_code_type eq 1>selected</cfif>><cf_get_lang dictionary_id='47352.UFRS Bazinda'></option>
						</select>
					</div>
					<div class="form-group" id="table_code_type">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='47349.Lütfen Islem Baslangiç Tarihini Giriniz !'></cfsavecontent>
							<cfinput type="text" name="search_start_date" id="search_start_date" maxlength="10" value="#dateformat(attributes.search_start_date,dateformat_style)#" validate="#validate_style#" message="#message#" style="width:67px;">
							<span class="input-group-addon"><cf_wrk_date_image date_field="search_start_date"></span>
						</div>
					</div>
					<div class="form-group" id="table_code_type">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='47349.Lütfen Islem Baslangiç Tarihini Giriniz !'></cfsavecontent>
							<cfinput type="text" name="search_date" id="search_date" maxlength="10" value="#dateformat(attributes.search_date,dateformat_style)#" required="Yes" validate="#validate_style#" message="#message#" style="width:67px;">
							<span class="input-group-addon"><cf_wrk_date_image date_field="search_date"></span>
						</div>
					</div>				  
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
					</div>
					<div class="form-group">
						<cfif isdefined("attributes.is_submitted") and attributes.is_submitted eq 1 and not listfindnocase(denied_pages,'account.popup_add_financial_table')>
							<a href="javascript://" class="ui-btn ui-btn-gray2" onClick="save_cash_flow_table();"><i class="fa fa-save" title="<cf_get_lang dictionary_id='47270.Bilanço'> <cf_get_lang dictionary_id='59031.Kaydet'>" alt="<cf_get_lang dictionary_id='47270.Bilanço'> <cf_get_lang dictionary_id='59031.Kaydet'>"></i></a>
						</cfif>
					</div>
				<!--- Arama --->
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group">
						<cfquery name="get_acc_card_type" datasource="#dsn3#">
							SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
						</cfquery>
						<select multiple="multiple" name="acc_card_type" id="acc_card_type" multiple>
							<cfoutput query="get_acc_card_type" group="process_type">
								<cfoutput>
									<option value="#process_type#-#process_cat_id#" <cfif listfind(attributes.acc_card_type,'#process_type#-#process_cat_id#',',')>selected</cfif>>#process_cat#</option>
								</cfoutput>
							</cfoutput>
						</select>
					</div>
					<div class="form-group">
						<select multiple="multiple" name="acc_branch_id" id="acc_branch_id" multiple>
							<optgroup label="<cf_get_lang dictionary_id='57453.Şube'>"></optgroup>
							<cfoutput query="get_branchs">
								<option value="#BRANCH_ID#" <cfif isdefined('attributes.acc_branch_id') and listfind(attributes.acc_branch_id,BRANCH_ID)>selected</cfif>>#BRANCH_NAME#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group">
						<label><cf_get_lang dictionary_id ='47338.Önceki Dönem'></label>
						<input type="checkbox" name="is_pre_period" id="is_pre_period" value="1" <cfif isdefined('attributes.is_pre_period') and attributes.is_pre_period eq 1>checked</cfif>>
					</div>
					<div class="form-group">
						<label><cf_get_lang dictionary_id='58905.Sistem Dövizi'></label>
						<input type="checkbox" name="is_system_money_2" id="is_system_money_2" value="1" <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>checked</cfif>>
					</div>
					<div class="form-group">
						<label><cf_get_lang dictionary_id ='47402.Sadece Bakiyesi Olanlar'></label>
						<input type="checkbox" name="is_bakiye" id="is_bakiye" value="1" <cfif isdefined('attributes.is_bakiye')>checked</cfif>>
					</div>					
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
<cfif isdefined("is_submitted")>
	<cfif GET_CASH_FLOW_DEF.RECORDCOUNT>
		<cfset temp_money_rate_=filterNum(attributes.rate,#session.ep.our_company_info.rate_round_num#)>
			<cfform name="income_table" action="#request.self#?fuseaction=account.popup_add_financial_table" method="post">
				<!-- sil -->
				<cfsavecontent variable="cont">
					<!--- <cf_big_list> --->
					<cf_box title="#getLang(5,'Nakit Akım Tablosu',47267)#" uidrop="1" hide_table_column="1">
						<cf_grid_list>
							<thead>
								<input type="hidden" name="fintab_type" id="fintab_type" value="CASH_FLOW_TABLE">
								<cfif year(now()) gt session.ep.period_year>
									<cfset kayit_donemi = '31/12/#session.ep.period_year#'>
								<cfelse>
									<cfset kayit_donemi = dateformat(now(),dateformat_style)>
								</cfif>
								<input type="Hidden" name="save_date1" id="save_date1" value="<cfoutput>#kayit_donemi#</cfoutput>">
								<tr>
									<th><cf_get_lang dictionary_id='47300.Hesap Adı'></th>
									<cfif attributes.is_pre_period eq 1>
										<cfquery name="GET_PRE_PERIOD" datasource="#DSN#">
											SELECT 
												* 
											FROM 
												SETUP_PERIOD 
											WHERE 
												PERIOD_YEAR =#SESSION.EP.PERIOD_YEAR-1#
										</cfquery>
									<cfelse>
										<cfset GET_PRE_PERIOD.RECORDCOUNT=0>
									</cfif>
									<cfif dsp_dept_claim_ eq 1><cfset cols_number_ =3><cfelse><cfset cols_number_ =1></cfif>
									<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
										<cfset cols_number_ =cols_number_*2>
									</cfif>
									<cfif GET_PRE_PERIOD.RECORDCOUNT>
										<th colspan="<cfoutput>#cols_number_#</cfoutput>"><cf_get_lang dictionary_id ='47338.Önceki Dönem'></th>
									</cfif>
									<th colspan="<cfoutput>#cols_number_#</cfoutput>"><cf_get_lang dictionary_id ='47330.Cari Dönem'></th>
								</tr>
								<tr>
									<th></th>
									<cfif get_pre_period.recordcount neq 0>
										<cfif dsp_dept_claim_ eq 1><!---tanımlarda borc bakiye durumu goster secilmisse hepsi, yoksa sadece o kod icin secilen toplam gosterilir --->
											<th><cf_get_lang dictionary_id='57587.Borç'></th>
											<th><cf_get_lang dictionary_id='57588.Alacak'></th>
											<th><cf_get_lang dictionary_id='57589.Bakiye'></th>
											<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
												<cfoutput>
													<th>#get_pre_period.other_money# <cf_get_lang dictionary_id='57587.Borç'></th>
													<th>#get_pre_period.other_money# <cf_get_lang dictionary_id='57588.Alacak'></th>
													<th>#get_pre_period.other_money# <cf_get_lang dictionary_id='57589.Bakiye'></th>
												</cfoutput>
											</cfif>
										<cfelse>
											<th>Toplam</th>
											<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
												<th><cfoutput>#get_pre_period.other_money#</cfoutput><cf_get_lang dictionary_id='57587.Borç'></th>
											</cfif>
										</cfif>
									</cfif>
									<cfif dsp_dept_claim_ eq 1><!---tanımlarda borc bakiye durumu goster secilmisse hepsi, yoksa sadece o kod icin secilen toplam gosterilir --->
										<th><cf_get_lang dictionary_id='57587.Borç'></th>
										<th><cf_get_lang dictionary_id='57588.Alacak'></th>
										<th><cf_get_lang dictionary_id='57589.Bakiye'></th>
										<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
											<cfoutput>
											<th>#session.ep.money2# <cf_get_lang dictionary_id='57587.Borç'></th>
											<th>#session.ep.money2# <cf_get_lang dictionary_id='57588.Alacak'></th>
											<th>#session.ep.money2# <cf_get_lang dictionary_id='57589.Bakiye'></th>
											</cfoutput>
										</cfif>
									<cfelse>
										<th style="text-align:right;">Toplam</th>
										<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
											<th><cfoutput>#session.ep.money2#</cfoutput><cf_get_lang dictionary_id='57587.Borç'></th>
										</cfif>
									</cfif>
								</tr>
							</thead>  
							<tbody>  
								<cfif GET_CASH_FLOW.RECORDCOUNT>
									<cfquery name="GET_TOTAL_MAIN" datasource="#DSN2#">
										SELECT 
											SUM(AART.BAKIYE) AS BAKIYE,
											SUM(AART.BORC) AS BORC,
											SUM(AART.ALACAK) AS ALACAK,
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
														</cfif>,
														ACCOUNT_CARD
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
										)AART
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
									<cfquery name="GET_DB_CASH_TOTAL" datasource="#DSN2#">
										SELECT 
											AP2.ACCOUNT_CODE,	
											SUM(ACR.AMOUNT) AS BAKIYE,
											SUM(ISNULL(ACR.AMOUNT_2,0)) AS BAKIYE_2
										FROM
											ACCOUNT_CARD ACC,
											<cfif attributes.table_code_type eq 0>
												ACCOUNT_CARD_ROWS
											<cfelseif attributes.table_code_type eq 1>
												ACCOUNT_ROWS_IFRS
											</cfif> ACR,
											ACCOUNT_PLAN AP,
											ACCOUNT_PLAN AP2
										WHERE 
											ACR.CARD_ID=ACC.CARD_ID 
											AND
											(
												ACR.ACCOUNT_ID LIKE '101%'
												OR ACR.ACCOUNT_ID LIKE '102%'
												OR ACR.ACCOUNT_ID LIKE '100%'
												OR ACR.ACCOUNT_ID LIKE '103%'
											)
											AND AP.ACCOUNT_CODE=ACR.ACCOUNT_ID
											AND (
												AP2.ACCOUNT_CODE =replace(left(AP.ACCOUNT_CODE,charindex('.',AP.ACCOUNT_CODE)),'.','')		
												OR 
												(
													AP2.ACCOUNT_CODE =AP.ACCOUNT_CODE AND
													len(replace(left(AP.ACCOUNT_CODE,charindex('.',AP.ACCOUNT_CODE)),'.',''))=0
												)
											)
										GROUP BY
											AP2.ACCOUNT_CODE	
									</cfquery>
									<cfif GET_PRE_PERIOD.RECORDCOUNT> <!--- onceki donem --->
										<cfset old_dsn_="#dsn#_#get_pre_period.period_year#_#session.ep.company_id#">
										<cfquery name="GET_LAST_YEAR_TOTAL_MAIN" datasource="#old_dsn_#">
											SELECT 
												SUM(AART.BAKIYE) AS BAKIYE,
												SUM(AART.BORC) AS BORC,
												SUM(AART.ALACAK) AS ALACAK,
											<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
												SUM(AART.BAKIYE_2) BAKIYE_2,
												SUM(AART.BORC_2) BORC_2,
												SUM(AART.ALACAK_2) ALACAK_2,
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
													ACCOUNT_ACCOUNT_REMAINDER
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
											)AART
											WHERE
											<cfif len(acc_list_)>
												ACCOUNT_CODE IN (#ListQualify(acc_list_,"'",",")#)
											<cfelse>
												ACCOUNT_CODE IS NULL
											</cfif>
											GROUP BY
												<cfif attributes.table_code_type eq 0>
												ACCOUNT_CODE
												<cfelse>
												IFRS_CODE
												</cfif>
										</cfquery>
										<cfquery name="GET_LAST_YEAR_DB_CASH_TOTAL" datasource="#old_dsn_#">
											SELECT 
												AP2.ACCOUNT_CODE,	
												SUM(ACR.AMOUNT) AS BAKIYE,
												SUM(ISNULL(ACR.AMOUNT_2,0)) AS BAKIYE_2
											FROM
												ACCOUNT_CARD ACC,
												<cfif attributes.table_code_type eq 0>
													ACCOUNT_CARD_ROWS
												<cfelseif attributes.table_code_type eq 1>
													ACCOUNT_ROWS_IFRS
												</cfif> ACR,
												ACCOUNT_PLAN AP,
												ACCOUNT_PLAN AP2
											WHERE 
												ACR.CARD_ID=ACC.CARD_ID 
												AND
												(
													ACR.ACCOUNT_ID LIKE '101%'
													OR ACR.ACCOUNT_ID LIKE '102%'
													OR ACR.ACCOUNT_ID LIKE '100%'
													OR ACR.ACCOUNT_ID LIKE '103%'
												)
												AND AP.ACCOUNT_CODE=ACR.ACCOUNT_ID
												AND (
													AP2.ACCOUNT_CODE =replace(left(AP.ACCOUNT_CODE,charindex('.',AP.ACCOUNT_CODE)),'.','')		
													OR 
													(
														AP2.ACCOUNT_CODE =AP.ACCOUNT_CODE AND
														len(replace(left(AP.ACCOUNT_CODE,charindex('.',AP.ACCOUNT_CODE)),'.',''))=0
													)
												)
											GROUP BY
												AP2.ACCOUNT_CODE	
										</cfquery>
									</cfif>
									<cfscript>
										for(ind_a=1;ind_a lte GET_TOTAL_MAIN.recordcount;ind_a=ind_a+1 ) //CARI DONEM
										{
											temp_acc_=replace(GET_TOTAL_MAIN.ACCOUNT_CODE[ind_a],".","_","all");
											'borc_#temp_acc_#' = GET_TOTAL_MAIN.BORC[ind_a]/temp_money_rate_;
											'alacak_#temp_acc_#' = GET_TOTAL_MAIN.ALACAK[ind_a]/temp_money_rate_;
											'acc_bakiye_#temp_acc_#' = abs(GET_TOTAL_MAIN.BAKIYE[ind_a])/temp_money_rate_;
											'bakiye_#temp_acc_#' = GET_TOTAL_MAIN.BAKIYE[ind_a]/temp_money_rate_;
											if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
											{
												'borc2_#temp_acc_#' = GET_TOTAL_MAIN.ALACAK_2[ind_a];
												'alacak2_#temp_acc_#' = GET_TOTAL_MAIN.BORC_2[ind_a];
												'acc_bakiye2_#temp_acc_#' = abs(GET_TOTAL_MAIN.BAKIYE_2[ind_a]);
												'bakiye2_#temp_acc_#' = GET_TOTAL_MAIN.BAKIYE_2[ind_a];
											}
										}
										for(ind_c=1;ind_c lte GET_DB_CASH_TOTAL.recordcount;ind_c=ind_c+1 ) //donem bası nakit toplam
										{
											'donembasi_bakiye_#GET_DB_CASH_TOTAL.ACCOUNT_CODE[ind_c]#' = GET_DB_CASH_TOTAL.BAKIYE[ind_c]/temp_money_rate_;
											if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
												'donembasi_bakiye2_#GET_DB_CASH_TOTAL.ACCOUNT_CODE[ind_c]#' = GET_DB_CASH_TOTAL.BAKIYE_2[ind_c];
										}
										
										if(GET_PRE_PERIOD.RECORDCOUNT neq 0) //ONCEKI DONEM
										{
											for(ind_a=1;ind_a lte GET_LAST_YEAR_TOTAL_MAIN.recordcount;ind_a=ind_a+1 )
											{
												temp_acc_=replace(GET_LAST_YEAR_TOTAL_MAIN.ACCOUNT_CODE[ind_a],".","_","all");
												'last_year_borc_#temp_acc_#' = GET_LAST_YEAR_TOTAL_MAIN.BORC[ind_a]/temp_money_rate_;
												'last_year_alacak_#temp_acc_#' = GET_LAST_YEAR_TOTAL_MAIN.ALACAK[ind_a]/temp_money_rate_;
												'last_year_acc_bakiye_#temp_acc_#' = abs(GET_LAST_YEAR_TOTAL_MAIN.BAKIYE[ind_a])/temp_money_rate_;
												'last_year_bakiye_#temp_acc_#' = GET_LAST_YEAR_TOTAL_MAIN.BAKIYE[ind_a]/temp_money_rate_;
												if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
												{
													'last_year_borc2_#temp_acc_#' = GET_LAST_YEAR_TOTAL_MAIN.ALACAK_2[ind_a];
													'last_year_alacak2_#temp_acc_#' = GET_LAST_YEAR_TOTAL_MAIN.BORC_2[ind_a];
													'last_year_acc_bakiye2_#temp_acc_#' = abs(GET_LAST_YEAR_TOTAL_MAIN.BAKIYE_2[ind_a]);
													'last_year_bakiye2_#temp_acc_#' = GET_LAST_YEAR_TOTAL_MAIN.BAKIYE_2[ind_a];
												}
											}
											for(ind_c=1;ind_c lte GET_LAST_YEAR_DB_CASH_TOTAL.recordcount;ind_c=ind_c+1 ) //donem bası nakit toplam
											{
												'last_year_donembasi_bakiye_#GET_LAST_YEAR_DB_CASH_TOTAL.ACCOUNT_CODE[ind_c]#' = GET_LAST_YEAR_DB_CASH_TOTAL.BAKIYE[ind_c]/temp_money_rate_;
												if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
													'last_year_donembasi_bakiye2_#GET_LAST_YEAR_DB_CASH_TOTAL.ACCOUNT_CODE[ind_c]#' = GET_LAST_YEAR_DB_CASH_TOTAL.BAKIYE_2[ind_c];
											}
											
										}
										dsonu_nakit_toplam=0;
										dsonu_nakit_toplam2=0;
										last_year_dsonu_nakit_toplam=0;
										last_year_dsonu_nakit_toplam2=0;
										dbasi_nakit_toplam=0;
										dbasi_nakit_toplam2=0;
										last_year_dbasi_nakit_toplam=0;
										last_year_dbasi_nakit_toplam2=0;
										nakit_toplam_acc_list='100,101,102,103';
										for(aa=1;aa lte listlen(nakit_toplam_acc_list);aa=aa+1 )  
										{
											ind_d = listgetat(nakit_toplam_acc_list,aa);
											if(ind_d eq 103)
											{
												if(isdefined('bakiye_#ind_d#') and evaluate('bakiye_#ind_d#'))
													dsonu_nakit_toplam=dsonu_nakit_toplam-evaluate('bakiye_#ind_d#');
												if(isdefined('donembasi_bakiye_#ind_d#') and evaluate('donembasi_bakiye_#ind_d#')) //cari donem basi nakit toplamları
													dbasi_nakit_toplam=dbasi_nakit_toplam-evaluate('donembasi_bakiye_#ind_d#');
												if(isdefined('last_year_bakiye_#ind_d#') and evaluate('last_year_bakiye_#ind_d#')) //onceki yıl donem sonu nakit toplamları
													last_year_dsonu_nakit_toplam=last_year_dsonu_nakit_toplam-evaluate('last_year_bakiye_#ind_d#');
												if(isdefined('last_year_donembasi_bakiye_#ind_d#') and evaluate('last_year_donembasi_bakiye_#ind_d#')) //onceki yıl donem basi nakit toplamları
													last_year_dbasi_nakit_toplam=last_year_dbasi_nakit_toplam-evaluate('last_year_donembasi_bakiye_#ind_d#');
													
												if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
												{
													if(isdefined('bakiye2_#ind_d#') and evaluate('bakiye2_#ind_d#'))
														dsonu_nakit_toplam2=dsonu_nakit_toplam2-evaluate('bakiye2_#ind_d#');
													if(isdefined('donembasi_bakiye2_#ind_d#') and evaluate('donembasi_bakiye2_#ind_d#')) //cari donem basi nakit toplamları
														dbasi_nakit_toplam2=dbasi_nakit_toplam2-evaluate('donembasi_bakiye2_#ind_d#');
													if(isdefined('last_year_bakiye2_#ind_d#') and evaluate('last_year_bakiye2_#ind_d#')) //onceki yıl donem sonu nakit toplamları
														last_year_dsonu_nakit_toplam2=last_year_dsonu_nakit_toplam2-evaluate('last_year_bakiye2_#ind_d#');
													if(isdefined('last_year_donembasi_bakiye2_#ind_d#') and evaluate('last_year_donembasi_bakiye2_#ind_d#')) //onceki yıl donem basi nakit toplamları
														last_year_dbasi_nakit_toplam2=last_year_dbasi_nakit_toplam2-evaluate('last_year_donembasi_bakiye2_#ind_d#');
												}
													
											}
											else
											{
												if(isdefined('bakiye_#ind_d#') and evaluate('bakiye_#ind_d#'))
													dsonu_nakit_toplam=dsonu_nakit_toplam+evaluate('bakiye_#ind_d#');
												if(isdefined('donembasi_bakiye_#ind_d#') and evaluate('donembasi_bakiye_#ind_d#'))
													dbasi_nakit_toplam=dbasi_nakit_toplam+evaluate('donembasi_bakiye_#ind_d#');
												if(isdefined('last_year_bakiye_#ind_d#') and evaluate('last_year_bakiye_#ind_d#')) //onceki yıl donem sonu nakit toplamları
													last_year_dsonu_nakit_toplam=last_year_dsonu_nakit_toplam+evaluate('last_year_bakiye_#ind_d#');
												if(isdefined('last_year_donembasi_bakiye_#ind_d#') and evaluate('last_year_donembasi_bakiye_#ind_d#')) //onceki yıl donem basi nakit toplamları
													last_year_dbasi_nakit_toplam=last_year_dbasi_nakit_toplam+evaluate('last_year_donembasi_bakiye_#ind_d#');
						
												if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
												{
													if(isdefined('bakiye2_#ind_d#') and evaluate('bakiye2_#ind_d#'))
														dsonu_nakit_toplam2=dsonu_nakit_toplam2+evaluate('bakiye2_#ind_d#');
													if(isdefined('donembasi_bakiye2_#ind_d#') and evaluate('donembasi_bakiye2_#ind_d#')) //cari donem basi nakit toplamları
														dbasi_nakit_toplam2=dbasi_nakit_toplam2+evaluate('donembasi_bakiye2_#ind_d#');
													if(isdefined('last_year_bakiye2_#ind_d#') and evaluate('last_year_bakiye2_#ind_d#')) //onceki yıl donem sonu nakit toplamları
														last_year_dsonu_nakit_toplam2=last_year_dsonu_nakit_toplam2+evaluate('last_year_bakiye2_#ind_d#');
													if(isdefined('last_year_donembasi_bakiye2_#ind_d#') and evaluate('last_year_donembasi_bakiye2_#ind_d#')) //onceki yıl donem basi nakit toplamları
														last_year_dbasi_nakit_toplam2=last_year_dbasi_nakit_toplam2+evaluate('last_year_donembasi_bakiye2_#ind_d#');
												}
						
											}
										}
									</cfscript>
									<cfoutput query="GET_CASH_FLOW">
										<cfif len(account_code)>
											<cfscript>
												new_temp_acc_ =replace(ACCOUNT_CODE,".","_","all");
												if(isdefined('borc_#new_temp_acc_#') and len(evaluate('borc_#new_temp_acc_#')) ) borc=evaluate('borc_#new_temp_acc_#'); else borc=0;
												if(isdefined('alacak_#new_temp_acc_#') and len(evaluate('alacak_#new_temp_acc_#')) ) alacak=evaluate('alacak_#new_temp_acc_#'); else alacak=0;
												if(isdefined('bakiye_#new_temp_acc_#') and len(evaluate('bakiye_#new_temp_acc_#')) ) bakiye=evaluate('bakiye_#new_temp_acc_#'); else bakiye=0;
												if (sign eq "-")
													bakiye = -1*bakiye;
												if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
												{
													if(isdefined('borc2_#new_temp_acc_#') and len(evaluate('borc2_#new_temp_acc_#')) ) borc_2=evaluate('borc2_#new_temp_acc_#'); else borc_2=0;
													if(isdefined('alacak2_#new_temp_acc_#') and len(evaluate('alacak2_#new_temp_acc_#')) ) alacak_2=evaluate('alacak2_#new_temp_acc_#'); else alacak_2=0;
													if(isdefined('acc_bakiye2_#new_temp_acc_#') and len(evaluate('acc_bakiye2_#new_temp_acc_#')) ) bakiye_2=evaluate('acc_bakiye2_#new_temp_acc_#'); else 
													{
															bakiye_2 = 0;
															acc_bakiye_2=0;
													} 

													
													if (sign eq "-")
														bakiye_2 = -1*bakiye_2;
												}
												
											if(GET_PRE_PERIOD.RECORDCOUNT)
											{
												if(isdefined('last_year_borc_#new_temp_acc_#') and len(evaluate('last_year_borc_#new_temp_acc_#')) ) last_year_borc=evaluate('last_year_borc_#new_temp_acc_#'); else last_year_borc=0;
												if(isdefined('last_year_alacak_#new_temp_acc_#') and len(evaluate('last_year_alacak_#new_temp_acc_#')) ) last_year_alacak=evaluate('last_year_alacak_#new_temp_acc_#'); else last_year_alacak=0;
												if(isdefined('last_year_bakiye_#new_temp_acc_#') and len(evaluate('last_year_bakiye_#new_temp_acc_#')) ) last_year_bakiye=evaluate('last_year_bakiye_#new_temp_acc_#'); else last_year_bakiye=0;
												if (sign eq "-")
													last_year_bakiye = -1*last_year_bakiye;
												if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
												{
													if(isdefined('last_year_borc2_#new_temp_acc_#') and len(evaluate('last_year_borc2_#new_temp_acc_#')) ) last_year_borc_2=evaluate('last_year_borc2_#new_temp_acc_#'); else last_year_borc_2=0;
													if(isdefined('last_year_alacak2_#new_temp_acc_#') and len(evaluate('last_year_alacak2_#new_temp_acc_#')) ) last_year_alacak_2=evaluate('last_year_alacak2_#new_temp_acc_#'); else last_year_alacak_2=0;
													if(isdefined('last_year_acc_bakiye2_#new_temp_acc_#') and len(evaluate('last_year_acc_bakiye2_#new_temp_acc_#')) ) last_year_bakiye_2=evaluate('last_year_acc_bakiye2_#new_temp_acc_#'); 
													else
													{
														last_year_bakiye_2 = 0;
														last_year_acc_bakiye_2=0;
													}
													if (sign eq "-")
														last_year_bakiye_2 = -1*last_year_bakiye_2;
												}
											}
											</cfscript>
										</cfif>
										<cfif find(".",code) eq 0 or (not len(account_code) and find(".",code) neq 0)>
											<cfif GET_PRE_PERIOD.RECORDCOUNT>
												<cfquery name="GET_LAST_YEAR_TOTAL_" dbtype="query"> <!--- ONCEKI DONEM --->
													SELECT 
														SUM(GET_LAST_YEAR_TOTAL_MAIN.BAKIYE) BAKIYE,
														SUM(GET_LAST_YEAR_TOTAL_MAIN.BORC) BORC,
														SUM(GET_LAST_YEAR_TOTAL_MAIN.ALACAK) ALACAK 
														<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
														,SUM(GET_LAST_YEAR_TOTAL_MAIN.BAKIYE_2) BAKIYE_2
														,SUM(GET_LAST_YEAR_TOTAL_MAIN.BORC_2) BORC_2
														,SUM(GET_LAST_YEAR_TOTAL_MAIN.ALACAK_2) ALACAK_2
														</cfif>
														,GET_CASH_FLOW.SIGN
													FROM 
														GET_LAST_YEAR_TOTAL_MAIN,
														GET_CASH_FLOW
													WHERE 
														GET_LAST_YEAR_TOTAL_MAIN.ACCOUNT_CODE = GET_CASH_FLOW.ACCOUNT_CODE AND 
														GET_CASH_FLOW.CODE LIKE '#CODE#%' AND 	
														GET_CASH_FLOW.CASH_FLOW_ID IN (#SELECTED_LIST#)
													GROUP BY
														GET_CASH_FLOW.SIGN
												</cfquery>
											</cfif>
											<cfquery name="GET_TOTAL_" dbtype="query"> <!--- AKTIF CARI DONEM --->
												SELECT 
													SUM(GET_TOTAL_MAIN.BAKIYE) BAKIYE,
													SUM(GET_TOTAL_MAIN.BORC) BORC,
													SUM(GET_TOTAL_MAIN.ALACAK) ALACAK 
													<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													,SUM(GET_TOTAL_MAIN.BAKIYE_2) BAKIYE_2
													,SUM(GET_TOTAL_MAIN.BORC_2) BORC_2
													,SUM(GET_TOTAL_MAIN.ALACAK_2) ALACAK_2
													</cfif>
													,GET_CASH_FLOW.SIGN
												FROM 
													GET_TOTAL_MAIN,
													GET_CASH_FLOW
												WHERE 
													GET_TOTAL_MAIN.ACCOUNT_CODE = GET_CASH_FLOW.ACCOUNT_CODE AND 
													GET_CASH_FLOW.CODE LIKE '#CODE#%' AND 	
													GET_CASH_FLOW.CASH_FLOW_ID IN (#SELECTED_LIST#)
												GROUP BY
													GET_CASH_FLOW.SIGN
											</cfquery>
											<cfscript>
												borc_total=0; alacak_total=0; bakiye_total=0;
												borc_total_2=0; alacak_total_2=0; bakiye_total_2=0;
												for(ii_=1;ii_ lte GET_TOTAL_.recordcount;ii_=ii_+1 )
												{
													if(len(GET_TOTAL_.SIGN[ii_]) and GET_TOTAL_.SIGN[ii_] is '-')
													{
														bakiye_total = bakiye_total - abs(GET_TOTAL_.BAKIYE[ii_]/temp_money_rate_);
														borc_total = borc_total + (GET_TOTAL_.BORC[ii_]/temp_money_rate_);
														alacak_total = alacak_total + (GET_TOTAL_.ALACAK[ii_]/temp_money_rate_);
														if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
														{
															bakiye_total_2 = bakiye_total_2 - abs(GET_TOTAL_.BAKIYE_2[ii_]);
															borc_total_2 = borc_total_2 + (GET_TOTAL_.BORC_2[ii_]);
															alacak_total_2 = alacak_total_2 + (GET_TOTAL_.ALACAK_2[ii_]);
														}
													}
													else
													{
														bakiye_total = bakiye_total + abs(GET_TOTAL_.BAKIYE[ii_]/temp_money_rate_);
														borc_total = borc_total + (GET_TOTAL_.BORC[ii_]/temp_money_rate_);
														alacak_total = alacak_total + (GET_TOTAL_.ALACAK[ii_]/temp_money_rate_);
														if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
														{
															bakiye_total_2 = bakiye_total_2 + abs(GET_TOTAL_.BAKIYE_2[ii_]);
															borc_total_2 = borc_total_2 + (GET_TOTAL_.BORC_2[ii_]);
															alacak_total_2 = alacak_total_2 + (GET_TOTAL_.ALACAK_2[ii_]);
														}
													}
												}
												if(GET_PRE_PERIOD.RECORDCOUNT)
												{
													last_year_borc_total=0; last_year_alacak_total=0; last_year_bakiye_total=0;
													last_year_borc_total_2=0; last_year_alacak_total_2=0; last_year_bakiye_total_2=0;
													for(ii_=1;ii_ lte GET_LAST_YEAR_TOTAL_.recordcount;ii_=ii_+1 )
													{
														if(len(GET_LAST_YEAR_TOTAL_.SIGN[ii_]) and GET_LAST_YEAR_TOTAL_.SIGN[ii_] is '-')
														{
															last_year_bakiye_total = last_year_bakiye_total - abs(GET_LAST_YEAR_TOTAL_.BAKIYE[ii_]/temp_money_rate_);
															last_year_borc_total = last_year_borc_total + (GET_LAST_YEAR_TOTAL_.BORC[ii_]/temp_money_rate_);
															last_year_alacak_total = last_year_alacak_total + (GET_LAST_YEAR_TOTAL_.ALACAK[ii_]/temp_money_rate_);
															if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
															{
																last_year_bakiye_total_2 = last_year_bakiye_total_2 - abs(GET_LAST_YEAR_TOTAL_.BAKIYE_2[ii_]);
																last_year_borc_total_2 = last_year_borc_total_2 + (GET_LAST_YEAR_TOTAL_.BORC_2[ii_]);
																last_year_alacak_total_2 = last_year_alacak_total_2 + (GET_LAST_YEAR_TOTAL_.ALACAK_2[ii_]);
															}
														}
														else
														{
															last_year_bakiye_total = last_year_bakiye_total + abs(GET_LAST_YEAR_TOTAL_.BAKIYE[ii_]/temp_money_rate_);
															last_year_borc_total = last_year_borc_total + (GET_LAST_YEAR_TOTAL_.BORC[ii_]/temp_money_rate_);
															last_year_alacak_total = last_year_alacak_total + (GET_LAST_YEAR_TOTAL_.ALACAK[ii_]/temp_money_rate_);
															if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
															{
																last_year_bakiye_total_2 = last_year_bakiye_total_2 + abs(GET_LAST_YEAR_TOTAL_.BAKIYE_2[ii_]);
																last_year_borc_total_2 = last_year_borc_total_2 + (GET_LAST_YEAR_TOTAL_.BORC_2[ii_]);
																last_year_alacak_total_2 = last_year_alacak_total_2 + (GET_LAST_YEAR_TOTAL_.ALACAK_2[ii_]);
															}
														}
													}
												}
												
											</cfscript> 
										</cfif>
										<!--- kosullara gore satirin gosterilip gosterilmemesini saglayan degiskenin belirlenmesi: goster --->
										<cfset goster=0>
										<cfif dsp_dept_claim_ eq 1>
											<cfif find(".",code) eq 0 or (not len(account_code) and find(".",code) neq 0)>
												<cfif bakiye_total neq 0>
													<cfset goster=1>
												<cfelse>
													<cfset goster=0>
												</cfif>
												<cfif get_pre_period.recordcount neq 0 and last_year_bakiye_total neq 0 and attributes.is_pre_period eq 1> <!--- onceki donem --->
													<cfset goster=1>
												<cfelse>
													<cfset goster=0>
												</cfif>
											<cfelseif find(".",code) neq 0 and len(account_code)>
												<cfif bakiye neq 0>
													<cfset goster=1>
												<cfelse>
													<cfset goster=0>
												</cfif>
												<cfif get_pre_period.recordcount neq 0 and last_year_bakiye_total neq 0 and attributes.is_pre_period eq 1> <!--- onceki donem --->
													<cfset goster=1>
												<cfelse>
													<cfset goster=0>
												</cfif>
											</cfif>
										<cfelse> <!--- sadece secilen toplamlar gosteriliyor --->
											<cfif code eq 6 and not len(account_code) and find(".",code) eq 0><!--- donem sonu nakit toplam --->
												<cfif dsonu_nakit_toplam neq 0>
													<cfset goster=1>
												<cfelse>
													<cfset goster=0>
												</cfif>
												<cfif get_pre_period.recordcount neq 0 and last_year_dsonu_nakit_toplam neq 0 and attributes.is_pre_period eq 1> <!--- onceki donem --->
													<cfset goster=1>
												<cfelse>
													<cfset goster=0>
												</cfif>
											<cfelseif code eq 5 and not len(account_code) and find(".",code) eq 0><!--- donem bası nakit mevcudu --->
												<cfif dbasi_nakit_toplam neq 0>
													<cfset goster=1>
												<cfelse>
													<cfset goster=0>
												</cfif>
												<cfif get_pre_period.recordcount neq 0 and last_year_dbasi_nakit_toplam neq 0 and attributes.is_pre_period eq 1> <!--- onceki donem --->
													<cfset goster=1>
												<cfelse>
													<cfset goster=0>
												</cfif>
											<cfelseif code eq 4 and not len(account_code) and find(".",code) eq 0><!--- nakit artışı : donem sonu nakit toplam-donem başı nakit mevcudu--->
												<cfif (dsonu_nakit_toplam-dbasi_nakit_toplam) neq 0>
													<cfset goster=1>
												<cfelse>
													<cfset goster=0>
												</cfif>
												<cfif get_pre_period.recordcount neq 0 and (last_year_dsonu_nakit_toplam-last_year_dbasi_nakit_toplam) neq 0 and attributes.is_pre_period eq 1> <!--- onceki donem --->
													<cfset goster=1>
												<cfelse>
													<cfset goster=0>						
												</cfif>
											<cfelseif find(".",code) eq 0 or (not len(account_code) and find(".",code) neq 0)>
												<cfif bakiye_total neq 0>
													<cfset goster=1>
												<cfelse>
													<cfset goster=0>
												</cfif>
												<cfif get_pre_period.recordcount neq 0 and last_year_bakiye_total neq 0 and attributes.is_pre_period eq 1> <!--- onceki donem --->
													<cfset goster=1>	
												<cfelse>
													<cfset goster=0>						
												</cfif>
											<cfelseif find(".",code) neq 0 and len(account_code)>
												<cfswitch expression="#GET_CASH_FLOW.VIEW_AMOUNT_TYPE#">
													<cfcase value="0"><cfif borc neq 0><cfset goster=1><cfelse><cfset goster=0></cfif></cfcase>
													<cfcase value="1"><cfif alacak neq 0><cfset goster=1><cfelse><cfset goster=0></cfif></cfcase>
													<cfcase value="2"><cfif bakiye neq 0><cfset goster=1><cfelse><cfset goster=0></cfif></cfcase>
												</cfswitch>
												<cfif get_pre_period.recordcount neq 0> <!--- onceki donem --->
													<cfswitch expression="#GET_CASH_FLOW.VIEW_AMOUNT_TYPE#">
														<cfcase value="0"><cfif last_year_borc neq 0 and attributes.is_pre_period eq 1><cfset goster=1><cfelse><cfset goster=0></cfif></cfcase>
														<cfcase value="1"><cfif last_year_alacak neq 0 and attributes.is_pre_period eq 1><cfset goster=1><cfelse><cfset goster=0></cfif></cfcase>
														<cfcase value="2"><cfif last_year_bakiye neq 0 and attributes.is_pre_period eq 1><cfset goster=1><cfelse><cfset goster=0></cfif></cfcase>
													</cfswitch>
												</cfif>
											</cfif>
										</cfif>
										<!--- --->
										<cfif goster eq 1 or not isdefined('attributes.is_bakiye')>
											<tr>
											<td>
												<cfif ListLen(CODE,".") neq 1>
													<cfloop from="1" to="#ListLen(CODE,".")#" index="i">&nbsp;</cfloop>
												</cfif>
												<cfif len(NAME_LANG_NO)>#getLang('main',NAME_LANG_NO)#<cfelse>#name#</cfif><!--- hesap tanımlarının dil seti yapılmıssa, mainden dil alınıyor yoksa standart tanım yazdırılıyor--->
											</td>
											<cfif dsp_dept_claim_ eq 1>
												<cfif find(".",code) eq 0 or (not len(account_code) and find(".",code) neq 0)>
													<cfif get_pre_period.recordcount neq 0> <!--- onceki donem --->
														<td nowrap="nowrap" style="text-align:right;">
															#TLFormat(last_year_borc_total)# #attributes.money#
														</td> 
														<td nowrap="nowrap" style="text-align:right;">
															#TLFormat(last_year_alacak_total)# #attributes.money#
														</td> 
														<td nowrap="nowrap" style="text-align:right;">
															#TLFormat(last_year_bakiye_total)# #attributes.money#
														</td>
														<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1><!--- onceki donem sistem dovizi --->
															<td nowrap="nowrap" style="text-align:right;">
																#TLFormat(last_year_borc_total_2)# #get_pre_period.other_money#
															</td> 
															<td nowrap="nowrap" style="text-align:right;">
																#TLFormat(last_year_alacak_total_2)# #get_pre_period.other_money#
															</td> 
															<td nowrap="nowrap" style="text-align:right;">
																#TLFormat(last_year_bakiye_total_2)# #get_pre_period.other_money#
															</td>
														</cfif>
													</cfif>
													<td nowrap="nowrap" style="text-align:right;"> <!--- aktif cari donem --->
														#TLFormat(borc_total)# #attributes.money#
													</td> 
													<td nowrap="nowrap" style="text-align:right;">
														#TLFormat(alacak_total)# #attributes.money#
													</td> 
													<td nowrap="nowrap" style="text-align:right;">
														#TLFormat(bakiye_total)# #attributes.money#
													</td>
													<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1> <!--- aktif cari donem sistem dovizli --->
														<td nowrap="nowrap" style="text-align:right;">
															#TLFormat(borc_total_2)# #session.ep.money2#
														</td> 
														<td nowrap="nowrap" style="text-align:right;">
															#TLFormat(alacak_total_2)# #session.ep.money2#
														</td> 
														<td nowrap="nowrap" style="text-align:right;">
															#TLFormat(bakiye_total_2)# #session.ep.money2#
														</td>
													</cfif>
												<cfelseif find(".",code) neq 0 and len(account_code)>
													<cfif get_pre_period.recordcount neq 0> <!--- onceki donem --->
														<td nowrap="nowrap" style="text-align:right;">
															#TLFormat(last_year_borc)# #attributes.money#
														</td> 
														<td nowrap="nowrap" style="text-align:right;">
															#TLFormat(last_year_alacak)# #attributes.money#
														</td> 
														<td nowrap="nowrap" style="text-align:right;">
															#TLFormat(last_year_bakiye)# #attributes.money#
														</td>
														<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
															<td nowrap="nowrap" style="text-align:right;">
																#TLFormat(last_year_borc_2)# #get_pre_period.other_money#
															</td> 
															<td nowrap="nowrap" style="text-align:right;">
																#TLFormat(last_year_alacak_2)# #get_pre_period.other_money#
															</td> 
															<td nowrap="nowrap" style="text-align:right;">
																#TLFormat(last_year_bakiye_2)# #get_pre_period.other_money#
															</td>
														</cfif>
													</cfif>
													<td nowrap="nowrap" style="text-align:right;">
														#TLFormat(borc)# #attributes.money#
													</td> 
													<td nowrap="nowrap" style="text-align:right;">
														#TLFormat(alacak)# #attributes.money#
													</td> 
													<td nowrap="nowrap" style="text-align:right;">
														#TLFormat(bakiye)# #attributes.money# 
													</td>
													<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
														<td nowrap="nowrap" style="text-align:right;">
															#TLFormat(borc_2)# #session.ep.money2#
														</td> 
														<td nowrap="nowrap" style="text-align:right;">
															#TLFormat(alacak_2)# #session.ep.money2#
														</td> 
														<td nowrap="nowrap" style="text-align:right;">
															#TLFormat(bakiye_2)# #session.ep.money2#
														</td>
													</cfif>
												</cfif>
											<cfelse> <!--- sadece secilen toplamlar gosteriliyor --->
												<cfif code eq 6 and not len(account_code) and find(".",code) eq 0><!--- donem sonu nakit toplam --->
													<cfif get_pre_period.recordcount neq 0>
														<td nowrap="nowrap" style="text-align:right;">#TLFormat(last_year_dsonu_nakit_toplam)# #attributes.money#</td>
														<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
														<td nowrap="nowrap" style="text-align:right;">#TLFormat(last_year_dsonu_nakit_toplam2)# #get_pre_period.other_money#</td>
														</cfif>
													</cfif>
													<td nowrap="nowrap" style="text-align:right;">#TLFormat(dsonu_nakit_toplam)# #attributes.money#</td>
													<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													<td nowrap="nowrap" style="text-align:right;">#TLFormat(dsonu_nakit_toplam2)# #session.ep.money2#</td>
													</cfif>
												<cfelseif code eq 5 and not len(account_code) and find(".",code) eq 0><!--- donem bası nakit mevcudu --->
													<cfif get_pre_period.recordcount neq 0>
														<td nowrap="nowrap" style="text-align:right;">#TLFormat(last_year_dbasi_nakit_toplam)# #attributes.money#</td>
														<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
														<td nowrap="nowrap" style="text-align:right;">#TLFormat(last_year_dbasi_nakit_toplam2)# #get_pre_period.other_money#</td>
														</cfif>
													</cfif>
													<td nowrap="nowrap" style="text-align:right;">#TLFormat(dbasi_nakit_toplam)# #attributes.money#</td>
													<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													<td nowrap="nowrap" style="text-align:right;">#TLFormat(dbasi_nakit_toplam2)# #session.ep.money2#</td>
													</cfif>
												<cfelseif code eq 4 and not len(account_code) and find(".",code) eq 0><!--- nakit artışı : donem sonu nakit toplam-donem başı nakit mevcudu--->
													<cfif get_pre_period.recordcount neq 0>
														<td nowrap="nowrap" style="text-align:right;">#TLFormat(last_year_dsonu_nakit_toplam-last_year_dbasi_nakit_toplam)# #attributes.money#</td>
														<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
														<td nowrap="nowrap" style="text-align:right;">#TLFormat(last_year_dsonu_nakit_toplam2-last_year_dbasi_nakit_toplam2)# #get_pre_period.other_money#</td>
														</cfif>
													</cfif>
													<td nowrap="nowrap" style="text-align:right;">#TLFormat(dsonu_nakit_toplam-dbasi_nakit_toplam)# #attributes.money#</td>
													<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													<td nowrap="nowrap" style="text-align:right;">#TLFormat(dsonu_nakit_toplam2-dbasi_nakit_toplam2)# #session.ep.money2#</td>
													</cfif>
												<cfelseif find(".",code) eq 0 or (not len(account_code) and find(".",code) neq 0)>
													<cfif get_pre_period.recordcount neq 0>
														<td nowrap="nowrap" style="text-align:right;">#TLFormat(last_year_bakiye_total)# #attributes.money#</td>
														<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
														<td nowrap="nowrap" style="text-align:right;">#TLFormat(last_year_bakiye_total_2)# #get_pre_period.other_money#</td>
														</cfif>
													</cfif>
													<td nowrap="nowrap" style="text-align:right;">#TLFormat(bakiye_total)# #attributes.money#</td>
													<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
													<td nowrap="nowrap" style="text-align:right;">#TLFormat(bakiye_total_2)# #session.ep.money2#</td>
													</cfif>
												<cfelseif find(".",code) neq 0 and len(account_code)>
													<cfif get_pre_period.recordcount neq 0> <!--- onceki donem --->
														<td nowrap="nowrap" style="text-align:right;">
															<cfswitch expression="#GET_CASH_FLOW.VIEW_AMOUNT_TYPE#">
																<cfcase value="0">#TLFormat(last_year_borc)# #attributes.money#</cfcase>
																<cfcase value="1">#TLFormat(last_year_alacak)# #attributes.money#</cfcase>
																<cfcase value="2">#TLFormat(last_year_bakiye)# #attributes.money#</cfcase>
															</cfswitch>
														</td>
														<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
															<td nowrap="nowrap" style="text-align:right;">
																<cfswitch expression="#GET_CASH_FLOW.VIEW_AMOUNT_TYPE#">
																	<cfcase value="0">#TLFormat(last_year_borc_2)# #get_pre_period.other_money#</cfcase>
																	<cfcase value="1">#TLFormat(last_year_alacak_2)# #get_pre_period.other_money#</cfcase>
																	<cfcase value="2">#TLFormat(last_year_bakiye_2)# #get_pre_period.other_money#</cfcase>
																</cfswitch>
															</td>
														</cfif>
													</cfif>
													<td nowrap style="text-align:right;">
														<cfswitch expression="#GET_CASH_FLOW.VIEW_AMOUNT_TYPE#">
															<cfcase value="0">#TLFormat(borc)# #attributes.money#</cfcase>
															<cfcase value="1">#TLFormat(alacak)# #attributes.money#</cfcase>
															<cfcase value="2">#TLFormat(bakiye)# #attributes.money#</cfcase>
														</cfswitch>
													</td>
													<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
														<td nowrap style="text-align:right;">
															<cfswitch expression="#GET_CASH_FLOW.VIEW_AMOUNT_TYPE#">
																<cfcase value="0">#TLFormat(borc_2)# #session.ep.money2#</cfcase>
																<cfcase value="1">#TLFormat(alacak_2)# #session.ep.money2#</cfcase>
																<cfcase value="2">#TLFormat(bakiye_2)# #session.ep.money2#</cfcase>
															</cfswitch>
														</td>
													</cfif>
												</cfif>
											</cfif>
											</tr>
										</cfif>
									</cfoutput>	
								<cfelse>
									<tr>
										<td colspan="11"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
									</tr>
								</cfif>
								<cfif dsp_dept_claim_ eq 1>
									<cfset spn=7>
								<cfelse>
									<cfset spn=3>					
								</cfif>
							</tbody>
						</cf_grid_list>
					</cf_box>
					<!--- </cf_big_list> --->
				</cfsavecontent>	
				<cfoutput>#cont#</cfoutput>
			</cfform>
	<cfelse>
		<cf_box>
			<cf_grid_list>
				<tr> 
					<td class="txtbold"><cf_get_lang dictionary_id='47322.Nakit Akım Tablosu  Tanımlarınızı Yapınız'></td>
				</tr>
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
	function save_cash_flow_table()
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

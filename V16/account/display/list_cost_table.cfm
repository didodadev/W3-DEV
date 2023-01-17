<!--- Satilan Malin Maliyeti Tablosu --->
<!---Select  ifadeleri ile ilgili çalışma yapıldı. Egemen Ateş 16.07.2012 --->
<cfinclude template="../query/get_branch_list.cfm">
<cfparam name="attributes.acc_card_type" default="">
<cfparam name="attributes.table_code_type" default="0">
<cfparam name="attributes.search_date" default="#dateformat(now(),dateformat_style)#">
<cf_date tarih="attributes.search_date">
<cfif isdefined("is_submitted")>
	<cfinclude template="../query/get_cost_table.cfm">
<cfelse>
	<cfset get_cost_def.recordcount=0>
	<cfset GET_COST_TABLE.recordcount=0>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="form" action="#request.self#?fuseaction=account.list_cost_table" method="post">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1"> 
			<cf_box_search>
				<div class="form-group">
					<cfinclude template="../query/get_money_list.cfm">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='47349.Lütfen Islem Baslangiç Tarihini Giriniz !'></cfsavecontent>
						<cfinput type="text" name="search_date" id="search_date" maxlength="10" value="#dateformat(attributes.search_date,dateformat_style)#" required="Yes" validate="#validate_style#" message="#message#" style="width:67px;">
						<span class="input-group-addon"><cf_wrk_date_image date_field="search_date"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="table_code_type" id="table_code_type">
						<option value="0" <cfif attributes.table_code_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58793.Tek Düzen'></option>
						<option value="1" <cfif attributes.table_code_type eq 1>selected</cfif>> <cf_get_lang dictionary_id='47352.UFRS Bazinda'></option>
					</select>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function= "control()">
					<cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'>
				</div>
				<cfif isdefined("attributes.is_submitted") and attributes.is_submitted eq 1 and not listfindnocase(denied_pages,'account.popup_add_financial_table')>
					<div class="form-group">
						<a class="ui-btn ui-btn-gray2" href="javascript://" onClick="save_cost_table();"><i class="fa fa-save"></i></a>
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
					<div class="form-group" id="acc_detail_search">
						<label class="col col-12"><cf_get_lang dictionary_id='58756.Açılış Fişi'></label>
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
						<label class="col col-12"><span class="hide"><cf_get_lang dictionary_id ='47402.Sadece Bakiyesi Olanlar'></span>&nbsp;</label>
						<label><input type="checkbox" name="is_bakiye" id="is_bakiye" value="1" <cfif isdefined('attributes.is_bakiye')>checked</cfif>><cf_get_lang dictionary_id ='47402.Sadece Bakiyesi Olanlar'></label>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cfif isdefined("is_submitted")>
		<cfif get_cost_def.recordcount>
			<cfquery name="GET_BAKIYE_ALL" DATASOURCE="#DSN2#" >
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
						<cfif len(attributes.search_date)>
							AND ACTION_DATE <= #attributes.search_date#
						</cfif>
					GROUP BY
						ACCOUNT_PLAN.ACCOUNT_CODE, 
						ACCOUNT_PLAN.ACCOUNT_NAME,
						ACCOUNT_PLAN.IFRS_CODE, 
						ACCOUNT_PLAN.IFRS_NAME,
						ACCOUNT_PLAN.ACCOUNT_ID, 
						ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE,
						ACCOUNT_ACCOUNT_REMAINDER.CARD_TYPE,
						ACCOUNT_ACCOUNT_REMAINDER.CARD_CAT_ID
				)T1
				
				GROUP BY
					ACCOUNT_CODE
			</cfquery>
			<cfquery name="GET_COST_TABLE_ALL" DATASOURCE="#DSN2#">
				SELECT 
					ZERO,
					ACCOUNT_CODE,
					SIGN,
					CODE,
					COST_ID,
					ADD_
				FROM COST_TABLE
			</cfquery>
			<cfquery name="GET_TOTAL_ACCOUNT" DATASOURCE="#DSN2#">
				SELECT 
					ACR.BA,
					ACR.AMOUNT,
					ACR.ACCOUNT_ID
				FROM
					ACCOUNT_CARD AC,
					<cfif attributes.table_code_type eq 0>
						ACCOUNT_CARD_ROWS
					<cfelseif attributes.table_code_type eq 1>
						ACCOUNT_ROWS_IFRS
					</cfif> ACR
				WHERE 
					AC.CARD_ID=ACR.CARD_ID	
					<cfif len(attributes.search_date)>
							AND ACTION_DATE <= #attributes.search_date#
						</cfif>	
			</cfquery>		
				<cfform action="#request.self#?fuseaction=account.popup_add_financial_table" method="post" name="cost_table">
					<input type="hidden" name="fintab_type" id="fintab_type" value="COST_TABLE">
					<!-- sil -->	
					<cfsavecontent variable="cont">
					<!--- <cf_big_list> --->
					<cf_box title="#getLang(117,'Satılan Malın Maliyeti Tablosu',47379)#" uidrop="1" hide_table_column="1">
						<cf_grid_list>
							<thead>
								<tr>
									<th>&nbsp;</th>
									<th><cf_get_lang dictionary_id='47299.Hesap Kodu'></th>
									<th><cf_get_lang dictionary_id='47300.Hesap Adi'></th>
									<th><cf_get_lang dictionary_id ='47330.Cari Dönem'> </th>
								</tr>
							</thead>
							<tbody>
								<cfif get_cost_table.recordcount>
									<cfif isdefined("attributes.bakiye_total1")>
										<cfset bakiye_total1=attributes.bakiye_total1>
									<cfelse>
										<cfset bakiye_total1=0>
									</cfif>
									<cfset b_total=0>
									<cfoutput query="get_cost_table">
									<cfset ctr=1>
									<cfif len(account_code)>
										<cfquery name="GET_BAKIYE"  dbtype="query">
											SELECT
												SUM(BAKIYE) AS BAKIYE,
												SUM(BORC) AS BORC,
												SUM(ALACAK) AS ALACAK
											FROM
												GET_BAKIYE_ALL
											WHERE
												ACCOUNT_CODE = '#ACCOUNT_CODE#'
										</cfquery>
										<cfif get_bakiye.recordcount and len(get_bakiye.borc)>
											<cfset borc=get_bakiye.borc/attributes.rate>
										<cfelse>
											<cfset borc=0>
										</cfif>
										<cfif get_bakiye.recordcount and  len(get_bakiye.alacak)>
											<cfset alacak=get_bakiye.alacak/attributes.rate>
										<cfelse>
											<cfset alacak=0>
										</cfif>
										<cfif get_bakiye.recordcount and  len(get_bakiye.bakiye)>
											<cfset tmp=get_bakiye.bakiye/attributes.rate>
										<cfelse>
											<cfset tmp=0>
										</cfif>
										<cfif sign eq "-">
											<cfset bakiye=(-1*tmp)>
										<cfelse>
											<cfset bakiye=tmp>	
										</cfif>
										<cfif ( (get_bakiye.bakiye lt 0 and ba eq 0) or (get_bakiye.bakiye gt 0 and ba eq 1) ) and inv_rem eq 0>
											<!--- inv_rem : ters hesaplari ala alma;get_cost_def.INVERSE_REMAINDER --->
											<cfset ctr=0>
										</cfif>
									</cfif>
									<cfif code eq "01.D">
										<cfset nega=1>
									<cfelse>
										<cfset nega=0>
									</cfif>
									<cfif find(".",code) eq 0>
									<cfif code eq "02">
										<cfif not isdefined('BAK_21')>
											<cfset BAK_21=0>
										</cfif>
										<cfif not isdefined('BAK_22')>
											<cfset BAK_22=0>
										</cfif>
										<cfif not isdefined('BAK_23')>
											<cfset BAK_23=0>
										</cfif>
										<cfset BAKIYE_TOTAL1 = BAK_21 + BAK_22 + BAK_23>
										<cfset B_TOTAL=(B_TOTAL/attributes.rate)+(BAKIYE_TOTAL1/attributes.rate)>			
									<cfelseif CODE eq "04">
										<cfif not isdefined("BAK_41")>
											<cfset BAK_41=0>
										</cfif>
										<cfif not isdefined("BAK_42")>
											<cfset BAK_42=0>
										</cfif>				
										<cfif not isdefined("BAK_43")>
											<cfset BAK_43=0>
										</cfif>				
										<cfif not isdefined("BAK_44")>
											<cfset BAK_44=0>
										</cfif>				
										<cfset BAKIYE_TOTAL1= BAK_41 + BAK_42 + BAK_43 + BAK_44>
										<cfset B_TOTAL=(B_TOTAL/attributes.rate)+(BAKIYE_TOTAL1/attributes.rate)>					
									<cfelse>	
										<cfquery name="GET_TOTAL" dbtype="query">
											SELECT 
												SUM(GET_BAKIYE_ALL.BAKIYE) AS BAKIYE,
												SUM(GET_BAKIYE_ALL.BORC) AS BORC,
												SUM(GET_BAKIYE_ALL.ALACAK) AS ALACAK
											FROM
												GET_BAKIYE_ALL,
												GET_COST_TABLE_ALL
											WHERE 
												GET_COST_TABLE_ALL.ZERO=0
											AND
												GET_BAKIYE_ALL.ACCOUNT_CODE = GET_COST_TABLE_ALL.ACCOUNT_CODE
											AND
												GET_COST_TABLE_ALL.CODE LIKE '#CODE#%'
											AND 
												(
														GET_COST_TABLE_ALL.SIGN IS NULL
													OR 
														GET_COST_TABLE_ALL.SIGN = '+'
												)		
											AND
												GET_COST_TABLE_ALL.COST_ID IN(#SELECTED_LIST#)
										</cfquery>
										<cfquery name="GET_TOTAL_"  dbtype="query">
											SELECT 
												SUM(GET_BAKIYE_ALL.BAKIYE) AS BAKIYE,
												SUM(GET_BAKIYE_ALL.BORC) AS BORC,
												SUM(GET_BAKIYE_ALL.ALACAK) AS ALACAK
											FROM
												GET_BAKIYE_ALL,
												GET_COST_TABLE_ALL
											WHERE 
												GET_COST_TABLE_ALL.ZERO=0
											AND
												GET_BAKIYE_ALL.ACCOUNT_CODE=GET_COST_TABLE_ALL.ACCOUNT_CODE
											AND
												GET_COST_TABLE_ALL.CODE LIKE '#CODE#%'
											AND 
												GET_COST_TABLE_ALL.SIGN='-'	
											AND
												GET_COST_TABLE_ALL.COST_ID IN(#SELECTED_LIST#)	
										</cfquery>
										<cfif not get_total.recordcount or get_total.bakiye is "">
											<cfset add1=0>
										<cfelse>
											<cfset add1=get_total.bakiye/attributes.rate>
										</cfif>
										<cfif  not get_total.recordcount or get_total_.bakiye is "">
											<cfset add2=0>
										<cfelse>
											<cfset add2=get_total_.bakiye/attributes.rate>
										</cfif>
										<cfset bakiye_total1=abs(add1)-abs(add2)>
										<cfif get_total.borc is "">
											<cfset add1=0>
										<cfelse>
										<cfset add1=get_total.borc/attributes.rate>
										</cfif>
										<cfif get_total_.borc is "">
											<cfset add2=0>
										<cfelse>
											<cfset add2=get_total_.borc/attributes.rate>
										</cfif>
										<cfset borc=add1+add2>
										<cfif  not get_total.recordcount or get_total.alacak is "">
											<cfset add1=0>
										<cfelse>
											<cfset add1=get_total.alacak/attributes.rate>
										</cfif>
										<cfif  not get_total.recordcount or get_total_.alacak is "">
											<cfset add2=0>
										<cfelse>
											<cfset add2=get_total_.alacak/attributes.rate>
										</cfif>
										<cfset alacak=add1+add2>
										<cfset B_TOTAL=(B_TOTAL/attributes.rate)+(BAKIYE_TOTAL1/attributes.rate)>
											<cfif NEGA EQ 1 >
											<cfquery name="get_sign" dbtype="query">
												SELECT
													SIGN
												FROM
													GET_COST_TABLE_ALL 
												WHERE 
													CODE='01.D' 
											</cfquery>
											
											<cfif get_sign.sIgn eq "-">
												<cfset NEGATIF_151="-#NEGATIF_151#">
											</cfif>
												<cfset B_TOTAL=(B_TOTAL/attributes.rate)+(NEGATIF_151/attributes.rate)>
												<cfset BAKIYE_TOTAL1=(BAKIYE_TOTAL1/attributes.rate)+(NEGATIF_151/attributes.rate)>
											</cfif>
									</cfif>
								</cfif>			
								<cfif listlen(code,".") eq 2>
									<cfset BAKIYE_TOTAL3=0>
									<cfif CODE EQ "01.D">
										<cfquery name="get_sign" dbtype="query">
											SELECT SIGN FROM GET_COST_TABLE_ALL WHERE CODE='01.D.01' 
										</cfquery>
										<cfquery name="get_sign2" dbtype="query">
											SELECT SIGN FROM GET_COST_TABLE_ALL WHERE CODE='01.D.02' 
										</cfquery>
								
										<cfquery name="GET_TOTAL3" dbtype="query">
											SELECT 
												SUM(GET_BAKIYE_ALL.BAKIYE) AS BAKIYE,
												SUM(GET_BAKIYE_ALL.BORC) AS BORC,
												SUM(GET_BAKIYE_ALL.ALACAK) AS ALACAK
											FROM
												GET_BAKIYE_ALL,
												GET_COST_TABLE_ALL
											WHERE 
												GET_COST_TABLE_ALL.ADD_ = 0
											AND
												GET_BAKIYE_ALL.ACCOUNT_CODE=GET_COST_TABLE_ALL.ACCOUNT_CODE
											AND
												GET_COST_TABLE_ALL.CODE LIKE '#CODE#%'
											AND
												GET_COST_TABLE_ALL.COST_ID IN(#SELECTED_LIST#)		
										</cfquery>
										<cfset temp=get_total3.bakiye>
										<cfif not GET_TOTAL3.recordcount or temp is "">
											<cfset temp=0>
										<cfelse>
											<cfset temp=get_total3.bakiye/attributes.rate>								
										</cfif>
										<cfif  not GET_TOTAL3.recordcount or  sign eq "-">
											<cfset bakiye_total3=bakiye_total3+evaluate((-1)*temp)>
										<cfelse>
											<cfset bakiye_total3=bakiye_total3+temp>
										</cfif>
										<cfif GET_TOTAL3.recordcount and  LEN(get_total3.BORC)>
											<cfset borc_3=get_total3.BORC/attributes.rate>
										<cfelse>
											<cfset borc_3=0>
										</cfif>
										<cfif GET_TOTAL3.recordcount and  LEN(get_total3.ALACAK)>
											<cfset alacak_3=get_total3.ALACAK/attributes.rate>
										<cfelse>
											<cfset alacak_3=0>
										</cfif>
										<cfif GET_SIGN.SIGN NEQ get_sign2.SIGN>
											<cfquery name="GET_TOTAL_" dbtype="query">
												SELECT 
													BA,
													AMOUNT,
													ACCOUNT_ID
												FROM
													GET_TOTAL_ACCOUNT
												WHERE 
													ACCOUNT_ID LIKE '151%'
											</cfquery> 				
											<cfif GET_TOTAL_.RECORDCOUNT GT 0>
												<cfif GET_TOTAL_.BA  EQ 0>
													<cfset BORC_ = -1 * GET_TOTAL_.AMOUNT/attributes.rate >
													<cfset ALACAK_ = 0 >
												<cfelse>
													<cfset BORC_ = 0 >
													<cfset ALACAK_=GET_TOTAL3.AMOUNT/attributes.rate>
												</cfif>
											<cfelse>
												<cfset BORC_=0>
												<cfset ALACAK_=0>
												<cfset BAKIYE_=0>									
											</cfif>
											<cfset BORC_3=BORC_3+(2*BORC_)>
											<cfset ALACAK_3=ALACAK_3+ALACAK_>
											<cfset BAKIYE_TOTAL3=ALACAK_3-BORC_3>						
										</cfif>
										<cfset NEGATIF_151=BORC_3/attributes.rate>
									<cfelse>
										<cfif not LEN(SELECTED_LIST)>
											<cfset SELECTED_LIST=-1>
										</cfif>
										<cfquery name="GET_TOTAL3" dbtype="query">
											SELECT 
												SUM(GET_BAKIYE_ALL.BAKIYE) AS BAKIYE,
												SUM(GET_BAKIYE_ALL.BORC) AS BORC,
												SUM(GET_BAKIYE_ALL.ALACAK) AS ALACAK
											FROM
												GET_BAKIYE_ALL,
												GET_COST_TABLE_ALL
											WHERE 
												GET_COST_TABLE_ALL.ZERO=0
											AND
												GET_BAKIYE_ALL.ACCOUNT_CODE=GET_COST_TABLE_ALL.ACCOUNT_CODE
											AND
												GET_COST_TABLE_ALL.CODE LIKE '#CODE#%'
											AND
												GET_COST_TABLE_ALL.COST_ID IN(#SELECTED_LIST#)		
										</cfquery>
										<cfset temp=get_total3.bakiye>
										<cfif  not get_total3.recordcount or temp is "">
											<cfset temp = 0 >
										<cfelse>
											<cfset temp = get_total3.bakiye/attributes.rate>
										</cfif>
										<cfif not get_total3.recordcount or  sign eq "-">
											<cfset bakiye_total3 = bakiye_total3 + evaluate((-1)*temp)>
										<cfelse>
											<cfset bakiye_total3 = bakiye_total3 + temp>
										</cfif>
										<cfif   get_total3.recordcount and  len(get_total3.BORC)>
											<cfset borc_3 = get_total3.BORC/attributes.rate >
										<cfelse>
											<cfset borc_3 = 0 >
										</cfif>
										<cfif   get_total3.recordcount and  len(get_total3.ALACAK)>
											<cfset alacak_3=get_total3.ALACAK/attributes.rate>
										<cfelse>
											<cfset alacak_3=0>
										</cfif>
									</cfif>
								</cfif>
								<cfif listlen(code,".") eq 3>
									<cfif CODE EQ "01.D.01">
										<cfset b=151>
										<cfquery name="GET_TOTAL_"  dbtype="query">
											SELECT 
												BA,
												AMOUNT,
												ACCOUNT_ID
											FROM
												GET_TOTAL_ACCOUNT
											WHERE 
												ACCOUNT_ID LIKE '#b#%'
										</cfquery> 				
										<cfset BORC_ = 0>
										<cfset ALACAK_ = 0>
										<cfset BAKIYE_ = 0>		
										<cfif GET_TOTAL_.RECORDCOUNT GT 0>									
											<cfloop from="1" to="#GET_TOTAL_.RECORDCOUNT#" index="i">
												<cfif GET_TOTAL_.BA[i]  EQ 0>
													<cfset BORC_=BORC_-(GET_TOTAL_.AMOUNT[i]/attributes.rate)>
													<cfset BAKIYE_=BAKIYE_-(GET_TOTAL_.AMOUNT[i]/attributes.rate)>
												<cfelse>
													<cfset ALACAK_=ALACAK_+(GET_TOTAL_.AMOUNT[i]/attributes.rate)>
													<cfset BAKIYE_=BAKIYE_+(GET_TOTAL_.AMOUNT[i]/attributes.rate)>									
												</cfif>
											</cfloop>
										</cfif>
									<cfelseif CODE EQ "01.D.02">
										<cfset b=151>
											<cfquery name="GET_TOTAL_"  dbtype="query">
												SELECT 
													BA,
													AMOUNT,
													ACCOUNT_ID
												FROM
													GET_TOTAL_ACCOUNT
												WHERE 
													ACCOUNT_ID LIKE '#b#%'
											</cfquery> 				
											<cfset BORC_151=0>
											<cfset ALACAK_151=0>
											<cfset BAKIYE_151=0>		
											<cfif GET_TOTAL_.RECORDCOUNT GT 0>									
												<cfloop from="1" to="#GET_TOTAL_.RECORDCOUNT#" index="i">
													<cfif GET_TOTAL_.BA[i]  EQ 0>
														<cfset BORC_151=BORC_151+(GET_TOTAL_.AMOUNT[i]/attributes.rate)>
														<cfset BAKIYE_151=BAKIYE_151-(GET_TOTAL_.AMOUNT[i]/attributes.rate)>
													<cfelse>
														<cfset ALACAK_151=ALACAK_151+(GET_TOTAL_.AMOUNT[i]/attributes.rate)>
														<cfset BAKIYE_151=BAKIYE_151+(GET_TOTAL_.AMOUNT[i]/attributes.rate)>									
													</cfif>
												</cfloop>
											</cfif>					
											<cfquery name="GET_TOTAL2" dbtype="query">
											SELECT 
												SUM(GET_BAKIYE_ALL.BAKIYE) AS BAKIYE,
												SUM(GET_BAKIYE_ALL.BORC) AS BORC,
												SUM(GET_BAKIYE_ALL.ALACAK) AS ALACAK
											FROM
												GET_BAKIYE_ALL,
												GET_COST_TABLE_ALL
											WHERE 
												GET_BAKIYE_ALL.ACCOUNT_CODE=GET_COST_TABLE_ALL.ACCOUNT_CODE
											AND
												GET_COST_TABLE_ALL.CODE LIKE '#CODE#%'
											AND
												GET_COST_TABLE_ALL.COST_ID IN(#SELECTED_LIST#)		
										</cfquery>
										<cfif not len(get_total2.BORC)>
											<cfset borc_=0>
										<cfelse>
											<cfset borc_=get_total2.BORC>							
										</cfif>
										<cfif not len(get_total2.ALACAK)>
											<cfset alacak_=0>
										<cfelse>	
											<cfset alacak_=get_total2.ALACAK/attributes.rate>
										</cfif>
										<cfset BORC_=BORC_-BORC_151>
										<cfset ALACAK_=ALACAK_-ALACAK_151>
										<cfset BAKIYE_=ALACAK_-BORC_>
										<cfset bakiye_=bakiye_>
										<cfif sign eq "-">
											<cfset bakiye_=evaluate((-1)*bakiye_)>
										</cfif>
									<cfelseif CODE EQ "02.E.01">
										<cfset b=152>
										<cfquery name="GET_TOTAL_" dbtype="query">
											SELECT 
												BA,
												AMOUNT,
												ACCOUNT_ID
											FROM
												GET_TOTAL_ACCOUNT
											WHERE 
												ACCOUNT_ID LIKE '#b#%'
										</cfquery> 				
										<cfset BORC_=0>
										<cfset ALACAK_=0>
										<cfset BAKIYE_=0>		
										<cfif GET_TOTAL_.RECORDCOUNT GT 0>									
											<cfloop from="1" to="#GET_TOTAL_.RECORDCOUNT#" index="i">
												<cfif GET_TOTAL_.BA[i]  EQ 0>
													<cfset BORC_=BORC_-(GET_TOTAL_.AMOUNT[i]/attributes.rate)>
													<cfset BAKIYE_=BAKIYE_-(GET_TOTAL_.AMOUNT[i]/attributes.rate)>
												<cfelse>
													<cfset ALACAK_=ALACAK_+(GET_TOTAL_.AMOUNT[i]/attributes.rate)>
													<cfset BAKIYE_=BAKIYE_+(GET_TOTAL_.AMOUNT[i]/attributes.rate)>									
												</cfif>
											</cfloop>
										</cfif>
										<cfif sign eq "-">
											<cfset bakiye_=evaluate((-1)*bakiye_)>
										</cfif>	
										<cfset bak_02=BAKIYE_>
										<cfset bor_02=borc_>
										<cfset al_02=alacak_>
										<cfset BAK_21=BAKIYE_>
									<cfelseif CODE EQ "02.E.02">
										<cfset b=152>
										<cfquery name="GET_TOTAL2"  dbtype="query">
											SELECT 
												SUM(GET_BAKIYE_ALL.BAKIYE) AS BAKIYE,
												SUM(GET_BAKIYE_ALL.BORC) AS BORC,
												SUM(GET_BAKIYE_ALL.ALACAK) AS ALACAK
											FROM
												GET_BAKIYE_ALL,
												GET_COST_TABLE_ALL
											WHERE 
												GET_BAKIYE_ALL.ACCOUNT_CODE = GET_COST_TABLE_ALL.ACCOUNT_CODE
											AND
												GET_COST_TABLE_ALL.CODE LIKE '#CODE#%'
											AND
												GET_COST_TABLE_ALL.COST_ID IN (#SELECTED_LIST#)		
										</cfquery>
										<cfif  not len(get_total2.BORC)>
											<cfset borc_ = 0 >
							
										<cfelse>
											<cfset borc_ = get_total2.BORC/attributes.rate >
										</cfif>
										<cfif not len(get_total2.ALACAK)>
											<cfset alacak_ = 0 >
										<cfelse>
											<cfset alacak_ = get_total2.ALACAK/attributes.rate >
										</cfif>
										<cfset BORC_ = BORC_-BOR_02 >
										<cfset ALACAK_ = ALACAK_-AL_02 >
										<cfset BAKIYE_ = ALACAK_-BORC_ >
										<cfset bakiye_ = bakiye_ >
										<cfif sign eq "-">
											<cfset bakiye_=evaluate((-1)*bakiye_)>
										</cfif>
										<cfset BAK_22 = BAKIYE_>
									<cfelseif CODE EQ "04.A.01">
										<cfset b=153>
										<cfquery name="GET_TOTAL_" dbtype="query">
											SELECT 
												BA,
												AMOUNT,
												ACCOUNT_ID
											FROM
												GET_TOTAL_ACCOUNT
											WHERE 
												ACCOUNT_ID LIKE '#b#%'
										</cfquery> 				
										<cfset BORC_=0>
										<cfset ALACAK_=0>
										<cfset BAKIYE_=0>
										<cfif GET_TOTAL_.RECORDCOUNT GT 0>
										<cfloop from="1" to="#GET_TOTAL_.RECORDCOUNT#" index="i">
											<cfif GET_TOTAL_.BA[i]  EQ 0>
												<cfset BORC_=BORC_-(GET_TOTAL_.AMOUNT[i]/attributes.rate)>
												<cfset BAKIYE_=BAKIYE_-(GET_TOTAL_.AMOUNT[i]/attributes.rate)>
											<cfelse>
												<cfset ALACAK_=ALACAK_+(GET_TOTAL_.AMOUNT[i]/attributes.rate)>
												<cfset BAKIYE_=BAKIYE_+(GET_TOTAL_.AMOUNT[i]/attributes.rate)>
											</cfif>
										</cfloop>
										</cfif>
										<cfif sign eq "-">
											<cfset bakiye_=evaluate((-1)*bakiye_)>
										</cfif>
										<cfset bak_04=BAKIYE_>
										<cfset bor_04=borc_>
										<cfset al_04=alacak_>
										<cfset BAK_41=BAKIYE_>
									<cfelseif CODE EQ "04.A.02">
										<cfquery name="GET_TOTAL2" dbtype="query">
											SELECT 
												SUM(GET_BAKIYE_ALL.BAKIYE) AS BAKIYE,
												SUM(GET_BAKIYE_ALL.BORC) AS BORC,
												SUM(GET_BAKIYE_ALL.ALACAK) AS ALACAK
											FROM
												GET_BAKIYE_ALL,
												GET_COST_TABLE_ALL
											WHERE 
												GET_COST_TABLE_ALL.ACCOUNT_CODE = GET_BAKIYE_ALL.ACCOUNT_CODE
											AND
												GET_COST_TABLE_ALL.CODE LIKE '#CODE#%'
											AND
												GET_COST_TABLE_ALL.COST_ID IN (#SELECTED_LIST#)		
										</cfquery>
										
										<cfif not len(get_total2.BORC)>
											<cfset borc_=0>
										<cfelse>
											<cfset borc_=get_total2.BORC/attributes.rate>
										</cfif>
										<cfif  not len(get_total2.ALACAK)>
											<cfset alacak_=0>
										<cfelse>
											<cfset alacak_=get_total2.ALACAK/attributes.rate>
										</cfif>
										<cfset BORC_=BORC_+bor_04>
										<cfset ALACAK_=ALACAK_+AL_04>
										<cfset BAKIYE_=ALACAK_-BORC_>
										<cfset bakiye_=bakiye_>
										<cfif sign eq "-">
											<cfset bakiye_=evaluate((-1)*bakiye_)>
										</cfif>			
										<cfset BAK_42 = BAKIYE_>
									<cfelseif CODE EQ "04.A.03">
										<cfquery name="GET_TOTAL2"  dbtype="query">
											SELECT 
												SUM(GET_BAKIYE_ALL.BAKIYE) AS BAKIYE,
												SUM(GET_BAKIYE_ALL.BORC) AS BORC,
												SUM(GET_BAKIYE_ALL.ALACAK) AS ALACAK
											FROM
												GET_BAKIYE_ALL,
												GET_COST_TABLE_ALL									
											WHERE 
												GET_BAKIYE_ALL.ACCOUNT_CODE = GET_COST_TABLE_ALL.ACCOUNT_CODE
											AND
												GET_COST_TABLE_ALL.CODE LIKE '#CODE#%'
											AND
												GET_COST_TABLE_ALL.COST_ID IN(#SELECTED_LIST#)		
										</cfquery>
										
										<cfif  not len(get_total2.BORC)>
											<cfset borc_=0>
										<cfelse>
											<cfset borc_=get_total2.BORC/attributes.rate>
										</cfif>
										<cfif not len(get_total2.ALACAK) >
											<cfset alacak_=0>
										<cfelse>
											<cfset alacak_=get_total2.ALACAK/attributes.rate>
										</cfif>
										<cfset BORC_=BORC_>
										<cfset ALACAK_=ALACAK_>
										<cfset BAKIYE_=ALACAK_-BORC_>
										<cfset bakiye_=bakiye_>
										<cfif sign eq "-">
											<cfset bakiye_=evaluate((-1)*bakiye_)>
										</cfif>
										<cfset BAK_43=BAKIYE_>
									<cfelse>
										<cfquery name="GET_TOTAL2" dbtype="query">
											SELECT 
												SUM(GET_BAKIYE_ALL.BAKIYE) AS BAKIYE,
												SUM(GET_BAKIYE_ALL.BORC) AS BORC,
												SUM(GET_BAKIYE_ALL.ALACAK) AS ALACAK
											FROM
												GET_BAKIYE_ALL,
												GET_COST_TABLE_ALL	
											WHERE 
												GET_BAKIYE_ALL.ACCOUNT_CODE=GET_COST_TABLE_ALL.ACCOUNT_CODE
											AND
												GET_COST_TABLE_ALL.CODE LIKE '#CODE#%'
											AND
												GET_COST_TABLE_ALL.COST_ID IN(#SELECTED_LIST#)		
										</cfquery>
										
										<cfif not len(get_total2.bakiye) >
											<cfset bakiye_=0>
										<cfelse>
											<cfset bakiye_=get_total2.bakiye/attributes.rate>
										</cfif>
										<cfset bakiye_=bakiye_>
										<cfif not len(get_total2.BORC)>
											<cfset borc_=0>
										<cfelse>
											<cfset borc_=get_total2.BORC/attributes.rate>
										</cfif>
										<cfif not len(get_total2.ALACAK)>
											<cfset alacak_=0>
										<cfelse>
											<cfset alacak_=get_total2.ALACAK/attributes.rate>
										</cfif>
										<cfif sign eq "-">
											<cfset bakiye_=evaluate((-1)*bakiye_)>
										</cfif>	
										<cfif CODE EQ "02.E.03">
											<cfset BAK_23 = BAKIYE_>
										</cfif>
										<cfif CODE EQ "04.A.04">
											<cfset BAK_44 = BAKIYE_>
										</cfif>
									</cfif>
								</cfif>
									<cfset x=0>
									<cfif find(".",code) eq 0>
										<cfif CODE EQ "03" >
											<cfif isdefined('attributes.is_bakiye') and B_TOTAL neq 0>
												<cfset x=1>
											</cfif>
										<cfelseif CODE EQ "06" >
											<cfif isdefined('attributes.is_bakiye') and B_TOTAL neq 0>
												<cfset x=1>
											</cfif>
										<cfelse>
											<cfif isdefined('attributes.is_bakiye') and BAKIYE_TOTAL1 neq 0>
												<cfset x=1>
											</cfif>
										</cfif>
									<cfelseif listlen(code,".") eq 2>
										<cfif isdefined('attributes.is_bakiye') and BAKIYE_TOTAL3 neq 0>
											<cfset x=1>
										</cfif>			
									<cfelseif  listlen(code,".") eq 3>
										<cfif isdefined('attributes.is_bakiye') and bakiye_ neq 0>
											<cfset x=1>
										</cfif>	
									</cfif>
									<cfif (x eq 1 or not isdefined('attributes.is_bakiye')) and ctr eq 1>
										<tr>
											<td>#code#</td>
											<td><cfif ListLen(account_code,".") neq 1><cfloop from="1" to="#ListLen(account_code,".")#" index="i">&nbsp;</cfloop></cfif>#account_code#</td>
											<td>
												<cfif ListLen(code,".") neq 1><cfloop from="1" to="#ListLen(code,".")#" index="i">&nbsp;&nbsp;</cfloop></cfif>
												<cfif find(".",code) eq 0>
													<font color="ff0000">#name#</font>
												<cfelse>#name#</cfif>
											</td>
											<cfif find(".",code) eq 0>
												<td style="text-align:right;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
													<font color="ff0000">
													<cfif CODE EQ "03" >
														#TLFormat(ABS(B_TOTAL))#
														<cfset b_degeri = ABS(B_TOTAL)>
													<cfelseif CODE EQ "06" >
														#TLFormat(ABS(B_TOTAL))#
														<cfset b_degeri = ABS(B_TOTAL)>
													<cfelse>
														#TLFormat(ABS(BAKIYE_TOTAL1))# 
														<cfset b_degeri = ABS(BAKIYE_TOTAL1)>
													</cfif>
													#attributes.money#</font>
												</td>
											<cfelseif listlen(code,".") eq 2>
												<td style="text-align:right;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; #TLFormat(ABS(BAKIYE_TOTAL3))# #attributes.money#</td>
											<cfelseif  listlen(code,".") eq 3>
												<td style="text-align:right;">#TLFormat(ABS(bakiye_))# #attributes.money# </td>
											</cfif>
										</tr>
									</cfif>
								</cfoutput>
								<cfelse>
									<tr>
										<td colspan="6"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</td>
									</tr>
								</cfif>
							</tbody>
						</cf_grid_list>
					</cf_box>
					<!--- </cf_big_list> --->
					</cfsavecontent>
					<cfoutput>#cont#</cfoutput>
				</cfform>
				<!-- sil -->
		<cfelse>
			<cf_box>
				<cf_grid_list>
					<tr> 
						<td height="35" class="headbold"><cf_get_lang dictionary_id='47342.SMM Tablosu  Tanimlarinizi Yapiniz !'></td>
					</tr>
				</cf_grid_list>
			</cf_box>
		</cfif>
	<cfelse>
		<cf_box>
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
<script type="text/javascript">
	function control(){
		val_ = $("#rate").val();
		$("#rate").val(filterNum(val_));
		return true;	
	}
	function save_cost_table()
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

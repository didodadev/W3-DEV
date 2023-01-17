<cf_xml_page_edit fuseact="account.list_account_plan_rows">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.acc_code_type" default="0">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.is_sub_project" default="">
<cfinclude template="../query/get_branch_list.cfm">
<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
	<cf_date tarih = "attributes.startdate">
<cfelse>
	<cfset attributes.startdate = "#dateformat(session.ep.period_start_date,dateformat_style)#">
</cfif>
<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
	<cf_date tarih = "attributes.finishdate">
<cfelse>
	<cfset attributes.finishdate = "#dateformat(session.ep.period_finish_date,dateformat_style)#">
</cfif>
<cfif isdefined("attributes.form_varmi")>
	<cfinclude template="../query/get_account_rows.cfm">
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.totalrecords" default="#get_account_rows.recordcount#">
	<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
</cfif>
<cfquery name="get_money" datasource="#dsn2#">
	SELECT MONEY FROM SETUP_MONEY WHERE MONEY_STATUS =1
</cfquery>
<cfset money_list=valuelist(get_money.MONEY)>
<cfsavecontent variable="head">
	<cf_get_lang dictionary_id='57919.Hareketler'> 
	<cfif isdefined("attributes.form_varmi")>
		<cfoutput>
		<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>#get_account_rows.ifrs_name#<cfelse>#get_account_rows.account_name#</cfif> : #attributes.code#
		</cfoutput>
	</cfif>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search" action="#request.self#?fuseaction=account.popup_list_account_plan_rows&acc_code_type=#attributes.acc_code_type#" method="post">
			<cf_box_search>
				<input type="hidden" name="form_varmi" id="form_varmi" value="1">
				<input type="hidden" name="code" id="code" value="<cfoutput>#URLDecode(attributes.code)#</cfoutput>">
				<div class="form-group" id="other_money_head" <cfif not isdefined("attributes.is_other_money")> style="display:none;" </cfif>>
					<div class="input-group">
						
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="keyword" placeholder="#getlang('main','Filtre',57460)#" maxlength="50" value="#attributes.keyword#">
						<cfif isdate(attributes.startdate)>
							<cfset tarih_1=dateformat(attributes.startdate,dateformat_style)>
						<cfelse>
							<cfset tarih_1="">
						</cfif>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="startdate" message="#getLang('','Başlangıç Tarihi',58053)#" required="yes" validate="#validate_style#"  value="#tarih_1#" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfif isdate(attributes.finishdate)>
							<cfset tarih_2=dateformat(attributes.finishdate,dateformat_style)>
						<cfelse>
							<cfset tarih_2="">
						</cfif>
						<cfinput type="text" name="finishdate" message="#getLang('','Bitiş Tarihi',57700)#" required="yes" validate="#validate_style#" value="#tarih_2#" maxlength="10">	
						<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
					</div>
				</div>
				<div class="form-group" <cfif isdefined("attributes.is_other_money")></cfif>>
					<input type="checkbox" name="is_other_money" id="is_other_money" value="1" <cfif isdefined("attributes.is_other_money")>checked</cfif>>
					<label><cf_get_lang dictionary_id='58121.İşlem Dövizi'></label>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1," required="yes">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" onclick="addEvent()"><i class="fa fa-plus"></i></a>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="form-group" id="item-acc_branch_id">
					<label class="col col-12"><cf_get_lang dictionary_id='57453.Sube'></label>
					<div class="col col-4">
						<select name="acc_branch_id" id="acc_branch_id">
							<option value=""><cf_get_lang dictionary_id='57453.Sube'></option>
							<cfoutput query="get_branchs">
								<option value="#BRANCH_ID#" <cfif isdefined('attributes.acc_branch_id') and attributes.acc_branch_id eq BRANCH_ID>selected</cfif>>#BRANCH_NAME#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-project_head">
						<label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
								<input type="text" name="project_head" id="project_head" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');" value="<cfoutput>#attributes.project_head#</cfoutput>" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=list_works.project_head&project_id=list_works.project_id</cfoutput>');" title="<cf_get_lang dictionary_id='58797.Proje Seiniz'>"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-acc_branch_id">
						<label class="col col-12"><span class="hide"><cf_get_lang dictionary_id='47564.Alt Projeleri Getir'></span>&nbsp;</label>
						<label><input type="checkbox" name="is_sub_project" id="is_sub_project" value="1" <cfif attributes.is_sub_project eq 1>checked</cfif>><cf_get_lang dictionary_id='47564.Alt Projeleri Getir'></label>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title='#head#' scroll="1" uidrop="1">
		<cf_grid_list sort="1">
			<thead>				
				<cfif isdefined("attributes.form_varmi")>
					<tr>
						<th colspan="5">
							<cfoutput>
								<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>#get_account_rows.ifrs_name#<cfelse>#get_account_rows.account_name#</cfif> : #attributes.code#
							</cfoutput>
						</th>
						<th <cfif isdefined("attributes.is_other_money") and len(session.ep.money2)>
							colspan="8"
						<cfelseif isdefined("attributes.is_other_money")>
							colspan="6"
						</cfif>
						>
							<cfoutput>
								#session.ep.company_nick# - #session.ep.period_year#
							</cfoutput>
						</th>
					</tr>
				</cfif>
				<tr>
					<th><cf_get_lang dictionary_id='57946.Fiş No'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<cfif is_acc_branch><th><cf_get_lang dictionary_id='57453.Sube'></th></cfif>
					<cfif is_acc_department><th><cf_get_lang dictionary_id='57572.Departman'></th></cfif>
					<cfif is_acc_project><th><cf_get_lang dictionary_id='57416.Proje'></th></cfif>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='57587.Borç'></th>
					<th><cf_get_lang dictionary_id='57588.Alacak'></th>
					<th><cf_get_lang dictionary_id='57589.Bakiye'></th>
					<cfif len(session.ep.money2)>
						<cfif isdefined("attributes.is_other_money")>
						<cfoutput>
							<th <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>#session.ep.money2# <cf_get_lang dictionary_id='57587.Borç'></th>
							<th <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>#session.ep.money2# <cf_get_lang dictionary_id='57588.Alacak'></th>
						</cfoutput>
						</cfif>
					</cfif>
					<cfif isdefined("attributes.is_other_money")>
						<th  <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>><cf_get_lang dictionary_id="57862.İslem Dovizi Borc"></th>
						<th  <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>><cf_get_lang dictionary_id="57863.İslem Dovizi Alacak"></th>
						<th  <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>><cf_get_lang dictionary_id='39655.İşlem Dövizi Tutar'></th>
						<th  <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>><cf_get_lang dictionary_id='58121.İşlem Dövizi'> <cf_get_lang dictionary_id='57489.Para Birimi'></th>
						<th  <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>><cf_get_lang dictionary_id='58121.İşlem Dövizi'> (<cf_get_lang dictionary_id='29684.A'>) / (<cf_get_lang dictionary_id='58591.B'>)</th>
					</cfif>
				</tr>
			</thead>
			<cfscript>
				duty_total = 0 ;
				duty_total_2 = 0;
				claim_total = 0 ;
				claim_total_2 = 0 ;
				borc_ = 0 ;
				alacak_ = 0 ;
				borc_2 = 0;
				alacak_2 = 0;
			</cfscript>
			<cfif isdefined("attributes.form_varmi") and get_account_rows.recordcount>
				<tbody>
					<!--- devreden islemlerin hesabi --->
					<cfloop  list="#money_list#" index="kk">
						<cfset 'dev_alacak_islem_dovizli#kk#'=0>
						<cfset 'dev_borc_islem_dovizli#kk#'=0>
						<cfset 'alacak_islem_dovizli#kk#'=0>
						<cfset 'borc_islem_dovizli#kk#'=0>
						<cfset 'bakiye_dovizli_#kk#'=0>
					</cfloop>
					<cfif isdate(attributes.startdate)>
						<cfset attributes.is_turnover = 1 >
						<cfoutput query="get_account_card_rows_devreden"><!--- BA ya gore sadece iki kez doner --->
							<cfif ba eq 0 >
								<cfset borc_ = borc_ + amount >
								<cfif len(amount_2)>
									<cfset borc_2 = borc_2 + amount_2 >
								</cfif>
								<cfif isdefined('attributes.is_other_money')>
									<cfif len(other_amount) and len(other_currency)>
										<cfset 'dev_borc_islem_dovizli#other_currency#'=evaluate( 'dev_borc_islem_dovizli#other_currency#')+other_amount>
									</cfif>
								</cfif>
							<cfelse>
								<cfset alacak_ = alacak_ + amount>
								<cfif len(amount_2)>
									<cfset alacak_2 = alacak_2 + amount_2>
								</cfif>
								<cfif isdefined('attributes.is_other_money')>
									<cfif len(other_amount) and len(other_currency)>
										<cfset 'dev_alacak_islem_dovizli#other_currency#'=evaluate( 'dev_alacak_islem_dovizli#other_currency#')-other_amount>
									</cfif>
								</cfif>
							</cfif>
						</cfoutput>
					</cfif>
					<cfif attributes.page neq 1>
						<cfset attributes.max_=(attributes.page-1)*attributes.maxrows>
						<cfoutput query="get_account_rows" startrow="1" maxrows="#attributes.max_#">
							<cfif ba eq 0>
								<cfset borc_ = borc_ + amount >
								<cfif len(amount_2)>
									<cfset borc_2 = borc_2 + amount_2 >
								</cfif>
								<cfif isdefined('attributes.is_other_money') and len(other_amount) and len(other_currency)>
									<cfset 'dev_borc_islem_dovizli#other_currency#'=evaluate('dev_borc_islem_dovizli#other_currency#')+other_amount>
								</cfif>
							<cfelse>
								<cfset alacak_ = alacak_ + amount >
								<cfif len(amount_2)>
									<cfset alacak_2 = alacak_2 + amount_2 >
								</cfif>
								<cfif isdefined('attributes.is_other_money') and len(other_amount) and len(other_currency)>
									<cfset 'dev_alacak_islem_dovizli#other_currency#'=evaluate('dev_alacak_islem_dovizli#other_currency#')-other_amount>
								</cfif>
							</cfif>
						</cfoutput>
					</cfif>
					<cfif attributes.page neq 1  or isdefined("attributes.is_turnover")>
						<cfoutput>
							<tr>
								<td class="txtboldblue"><cf_get_lang dictionary_id='58034.Devreden'></td>
								<td></td>
								<cfif is_acc_branch><td></td></cfif>
								<cfif is_acc_department><td></td></cfif>
								<cfif is_acc_project><td></td></cfif>
								<td></td>
								<td class="txtboldblue" >#TLFormat(borc_)#  </td>
								<td class="txtboldblue" >#TLFormat(alacak_)#</td>
								<td class="txtboldblue" >#TLFormat(ABS(borc_-alacak_))# <cfif borc_ gt alacak_>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
								<cfif len(session.ep.money2)>
									<td class="txtboldblue" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>#TLFormat(borc_2)#</td>
									<td class="txtboldblue" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>#TLFormat(alacak_2)#</td>
								</cfif>
								<td nowrap class="txtboldblue" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
									<cfloop list="#money_list#" index="zz">
										<cfif isdefined('dev_borc_islem_dovizli#zz#') and len(evaluate('dev_borc_islem_dovizli#zz#')) and evaluate('dev_borc_islem_dovizli#zz#') neq 0>
											#TLFormat(abs(evaluate('dev_borc_islem_dovizli#zz#')))# #zz#<br />
										</cfif>
									</cfloop>
								</td>
								<td nowrap class="txtboldblue"  <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
									<cfloop list="#money_list#" index="zz">
										<cfif isdefined('dev_alacak_islem_dovizli#zz#') and len(evaluate('dev_alacak_islem_dovizli#zz#')) and evaluate('dev_alacak_islem_dovizli#zz#') neq 0>
											#TLFormat(abs(evaluate('dev_alacak_islem_dovizli#zz#')))# #zz#<br />
										</cfif>
									</cfloop>
								</td>
								<td nowrap class="txtboldblue" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
									<cfloop list="#money_list#" index="zz">
										<cfset 'dev_bakiye_dovizli_#zz#' = abs(evaluate('dev_borc_islem_dovizli#zz#'))-abs(evaluate('dev_alacak_islem_dovizli#zz#'))>
										<cfif evaluate('dev_bakiye_dovizli_#zz#') neq 0>
											#TLFormat(abs(evaluate('dev_bakiye_dovizli_#zz#')))#<br />
										</cfif>
									</cfloop>
								</td>
								<td nowrap class="txtboldblue" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
									<cfloop list="#money_list#" index="zz">
										<cfset 'dev_bakiye_dovizli_#zz#' = abs(evaluate('dev_borc_islem_dovizli#zz#'))-abs(evaluate('dev_alacak_islem_dovizli#zz#'))>
										<cfif evaluate('dev_bakiye_dovizli_#zz#') neq 0>
											#zz#<br />
										</cfif>
									</cfloop>
								</td>
								<td nowrap class="txtboldblue" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
									<cfloop list="#money_list#" index="zz">
										<cfset 'dev_bakiye_dovizli_#zz#' = abs(evaluate('dev_borc_islem_dovizli#zz#'))-abs(evaluate('dev_alacak_islem_dovizli#zz#'))>
										<cfif evaluate('dev_bakiye_dovizli_#zz#') neq 0>
											<cfif evaluate('dev_bakiye_dovizli_#zz#') lt 0>(<cf_get_lang dictionary_id='29684.A'>)<cfelse>(<cf_get_lang dictionary_id='58591.B'>)</cfif><br />
										</cfif>
									</cfloop>
								</td>
							</tr>
						</cfoutput>
					</cfif>
					<cfoutput query="get_account_rows" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td><a href="javascript:windowopen('#request.self#?fuseaction=account.popup_list_card_rows&card_id=#CARD_ID#','medium');" class="tableyazi">#BILL_NO#</a></td>
							<td>#dateformat(ACTION_DATE,dateformat_style)#</td>
							<cfif is_acc_branch><td>#BRANCH_NAME#</td></cfif>
							<cfif is_acc_department><td>#BRANCH_NAME2# <cfif len(DEPARTMENT_HEAD)>- #DEPARTMENT_HEAD#</cfif></td></cfif>
							<cfif is_acc_project><td>#PROJECT_HEAD#</td></cfif>
							<td>#DETAIL#</td>
							<td ><cfif ba eq 0>#TLFormat(AMOUNT)#<cfset duty_total = duty_total + AMOUNT></cfif></td>
							<td ><cfif ba eq 1>#TLFormat(AMOUNT)#<cfset claim_total = claim_total + AMOUNT></cfif></td>
							<td >#TLFormat(ABS((borc_+duty_total)-(alacak_+claim_total)))# <cfif (borc_+duty_total)gt (alacak_+claim_total)>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
							<cfif len(session.ep.money2)>
							<td nowrap="nowrap" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
								<cfif ba eq 0 and len(AMOUNT_2)>#TLFormat(AMOUNT_2)# 
									<cfset duty_total_2 = duty_total_2 + AMOUNT_2>
								</cfif>
							</td>
							<td nowrap="nowrap" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
								<cfif ba eq 1 and len(AMOUNT_2)>#TLFormat(AMOUNT_2)# <cfset claim_total_2 = claim_total_2 + AMOUNT_2></cfif>
							</td>
							</cfif>
							<td nowrap="nowrap" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
								<cfif ba eq 0 and len(OTHER_AMOUNT) and len(OTHER_CURRENCY)>
									<cfset 'bakiye_dovizli_#OTHER_CURRENCY#'=evaluate('bakiye_dovizli_#OTHER_CURRENCY#')+OTHER_AMOUNT>
									<cfset 'borc_islem_dovizli#other_currency#'=evaluate('borc_islem_dovizli#other_currency#')+other_amount>
									#TLFormat(OTHER_AMOUNT)# #OTHER_CURRENCY#&nbsp;
								</cfif>
							</td>
							<td nowrap="nowrap" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
								<cfif ba eq 1 and len(OTHER_AMOUNT) and len(trim(OTHER_CURRENCY))>
									<cfset 'bakiye_dovizli_#OTHER_CURRENCY#'=evaluate('bakiye_dovizli_#OTHER_CURRENCY#')-OTHER_AMOUNT>
									<cfset 'alacak_islem_dovizli#other_currency#'=evaluate('alacak_islem_dovizli#other_currency#')-other_amount>
									#TLFormat(OTHER_AMOUNT)# #OTHER_CURRENCY#&nbsp;
								</cfif>
							</td>
							<td nowrap="nowrap" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
								<cfif len(trim(other_currency))>
									#TLFormat(abs(evaluate('bakiye_dovizli_#other_currency#')))# 
								</cfif>
							</td>
							<td nowrap="nowrap" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
								#other_currency#
							</td>
							<td nowrap="nowrap" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
								<cfif len(trim(OTHER_CURRENCY)) and evaluate('bakiye_dovizli_#other_currency#') gte 0 >(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
							</td>
						</tr>
					</cfoutput>
				</tbody>
				<tfoot>
					<cfoutput>
						<tr>
							<td class="txtboldblue"><cf_get_lang dictionary_id='57581.Sayfa'><cf_get_lang dictionary_id='57492.Toplam'></td>
							<td></td>
							<cfif is_acc_branch><td></td></cfif>
							<cfif is_acc_department><td></td></cfif>
							<cfif is_acc_project><td></td></cfif>
							<td></td>
							<td nowrap="nowrap" class="txtboldblue" >#TLFormat(duty_total)#</td>
							<td nowrap="nowrap" class="txtboldblue" >#TLFormat(claim_total)#</td>
							<td class="txtboldblue" >#tlformat(ABS(duty_total-claim_total))# <cfif duty_total gt claim_total>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
							<cfif len(session.ep.money2)>
								<td nowrap="nowrap" class="txtboldblue" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>#TLFormat(duty_total_2)#</td>
								<td nowrap="nowrap" class="txtboldblue" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>#TLFormat(claim_total_2)#</td>
							</cfif>	
							<td nowrap="nowrap" class="txtboldblue"<cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
								<cfloop list="#money_list#" index="zz">
									<cfif isdefined('borc_islem_dovizli#zz#') and evaluate('borc_islem_dovizli#zz#') neq 0>
										#TLFormat(abs(evaluate('borc_islem_dovizli#zz#')))# #zz#<br />
									</cfif>
								</cfloop>
							</td>
							<td nowrap class="txtboldblue"  <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
								<cfloop list="#money_list#" index="zz">
									<cfif isdefined('alacak_islem_dovizli#zz#') and evaluate('alacak_islem_dovizli#zz#') neq 0>
										#TLFormat(abs(evaluate('alacak_islem_dovizli#zz#')))# #zz#<br />
									</cfif>
								</cfloop>
							</td>
							<td nowrap class="txtboldblue" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
								<cfloop list="#money_list#" index="zz">
									<cfif isdefined('bakiye_dovizli_#zz#') and evaluate('bakiye_dovizli_#zz#') neq 0>
										#TLFormat(abs(evaluate('bakiye_dovizli_#zz#')))#<br />
									</cfif>
								</cfloop>
							</td>
							<td nowrap class="txtboldblue" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
								<cfloop list="#money_list#" index="zz">
									<cfif isdefined('bakiye_dovizli_#zz#') and evaluate('bakiye_dovizli_#zz#') neq 0>
										#zz#<br />
									</cfif>
								</cfloop>
							</td>
							<td nowrap class="txtboldblue" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
								<cfloop list="#money_list#" index="zz">
									<cfif isdefined('bakiye_dovizli_#zz#') and evaluate('bakiye_dovizli_#zz#') neq 0>
										<cfif evaluate('bakiye_dovizli_#zz#') lt 0>(<cf_get_lang dictionary_id='29684.A'>)<cfelse>(<cf_get_lang dictionary_id='58591.B'>)</cfif><br />
									</cfif>
								</cfloop>
							</td>
						</tr>
						<tr>
							<td class="txtboldblue"><cf_get_lang dictionary_id='57492.Toplam'></td>
							<td></td>
							<cfif is_acc_branch><td></td></cfif>
							<cfif is_acc_department><td></td></cfif>
							<cfif is_acc_project><td></td></cfif>
							<td></td>
							<td class="txtboldblue" >#TLFormat(duty_total+borc_)#</td>
							<td class="txtboldblue" >#TLFormat(claim_total+alacak_)#</td>
							<td class="txtboldblue" >#TLFormat(ABS(duty_total+borc_-(claim_total+alacak_)))# <cfif (duty_total+borc_) gt (claim_total+alacak_)>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
							<cfif len(session.ep.money2)>
							<td class="txtboldblue" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>#TLFormat(duty_total_2+borc_2)#</td>
							<td class="txtboldblue" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>#TLFormat(claim_total_2+alacak_2)#</td>
							</cfif>
							<td nowrap="nowrap" class="txtboldblue" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
								<cfloop list="#money_list#" index="zz">
									<cfset 'dev_borc_islem_dovizli#zz#' = evaluate('dev_borc_islem_dovizli#zz#')+evaluate('borc_islem_dovizli#zz#')>
									<cfif evaluate('dev_borc_islem_dovizli#zz#') neq 0>
										#TLFormat(abs(evaluate('dev_borc_islem_dovizli#zz#')))# #zz#<br />
									</cfif>
								</cfloop>
							</td>
							<td nowrap="nowrap" class="txtboldblue" <cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
								<cfloop list="#money_list#" index="zz">
									<cfset 'dev_alacak_islem_dovizli#zz#' = evaluate('dev_alacak_islem_dovizli#zz#')+evaluate('alacak_islem_dovizli#zz#')>
									<cfif evaluate('dev_alacak_islem_dovizli#zz#') neq 0>
										#TLFormat(abs(evaluate('dev_alacak_islem_dovizli#zz#')))# #zz#<br />
									</cfif>
								</cfloop>
							</td>
							<td nowrap="nowrap" class="txtboldblue"<cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
								<cfloop list="#money_list#" index="zz">
									<cfset 'dev_bakiye_dovizli_#zz#' = evaluate('dev_bakiye_dovizli_#zz#')+evaluate('bakiye_dovizli_#zz#')>
									<cfif evaluate('dev_bakiye_dovizli_#zz#') neq 0>
										#TLFormat(abs(evaluate('dev_bakiye_dovizli_#zz#')))#<br />
									</cfif>
								</cfloop>
							</td>
							<td nowrap="nowrap" class="txtboldblue"<cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
								<cfloop list="#money_list#" index="zz">
									<cfset 'dev_bakiye_dovizli_#zz#' = evaluate('dev_bakiye_dovizli_#zz#')+evaluate('bakiye_dovizli_#zz#')>
									<cfif evaluate('dev_bakiye_dovizli_#zz#') neq 0>
										#zz#
									</cfif>
								</cfloop>
							</td>
							<td nowrap="nowrap" class="txtboldblue"<cfif not isdefined("attributes.is_other_money")>style="display:none;"</cfif>>
								<cfloop list="#money_list#" index="zz">
									<cfset 'dev_bakiye_dovizli_#zz#' = evaluate('dev_bakiye_dovizli_#zz#')+evaluate('bakiye_dovizli_#zz#')>
									<cfif evaluate('dev_bakiye_dovizli_#zz#') neq 0>
										<cfif evaluate('dev_bakiye_dovizli_#zz#') lt 0>(<cf_get_lang dictionary_id='29684.A'>)<cfelse>(<cf_get_lang dictionary_id='58591.B'>)</cfif><br />
									</cfif>
								</cfloop>
							</td>
						</tr>
					</cfoutput>
				</tfoot>
			<cfelse>
				<tbody>
					<tr>
						<td colspan=""><cfif isdefined("get_account_rows.recordcount")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
					</tr>
				</tbody>
			</cfif>
		</cf_grid_list>
		<cfif isdefined("attributes.form_varmi") and attributes.maxrows lt attributes.totalrecords>
			<cfset adres = "account.popup_list_account_plan_rows&code=#attributes.code#">
			<cfif isdate(attributes.startdate)>
				<cfset adres = "#adres#&startdate=#dateformat(attributes.startdate,dateformat_style)#" >
			</cfif>
			<cfif isdate(attributes.finishdate)>
				<cfset adres = "#adres#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#" >
			</cfif>
			<cfif isdefined('attributes.acc_code_type')>
				<cfset adres = "#adres#&acc_code_type=#attributes.acc_code_type#">
			</cfif>
			<cfif isdefined('attributes.acc_branch_id')>
				<cfset adres = "#adres#&acc_branch_id=#attributes.acc_branch_id#">
			</cfif>
			<cfif isdefined('attributes.project_id')>
				<cfset adres = "#adres#&project_id=#attributes.project_id#">
			</cfif>
			<cfif isdefined('attributes.project_head')>
				<cfset adres = "#adres#&project_head=#attributes.project_head#">
			</cfif>
			<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
				<cfset adres = adres&"&keyword="&attributes.keyword>
			</cfif>
			<cfif isdefined('attributes.is_other_money') and attributes.is_other_money eq 1>
				<cfset adres = adres&"&is_other_money="&attributes.is_other_money>
			</cfif>
			<cf_paging
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#&form_varmi=1">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();	
</script>

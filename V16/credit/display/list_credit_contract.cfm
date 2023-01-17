<cf_xml_page_edit fuseact="credit.list_credit_contract">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.credit_employee_id" default="">
<cfparam name="attributes.credit_employee" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.listing_type" default="1">
<cfparam name="attributes.credit_limit_id" default="">
<cfparam name="attributes.credit_type_id" default="">
<cfparam name="attributes.is_scenario_control" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif len(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
</cfif>
<cfif len(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
</cfif>
<cfscript>
	getCredit_ = createobject("component","V16.credit.cfc.credit");
	getCredit_.dsn3 = dsn3;
</cfscript>
<cfif isdefined("attributes.form_submitted")>
	<cfscript>
		get_credit_contracts = getCredit_.getCredit
		(
			listing_type : attributes.listing_type,
			company_id : attributes.company_id,
			company : attributes.company,
			keyword : attributes.keyword,
			credit_employee_id : attributes.credit_employee_id,
			credit_employee:attributes.credit_employee,
			start_date : attributes.start_date,
			finish_date :  attributes.finish_date,
			is_active : attributes.is_active,
			process_type : attributes.process_type,
			credit_limit_id : attributes.credit_limit_id,
			credit_type_id : attributes.credit_type_id,
			is_scenario_control : attributes.is_scenario_control,
			startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
			maxrows : '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#'
		);
	</cfscript>
    <cfparam name="attributes.totalrecords" default='#get_credit_contracts.QUERY_COUNT#'>
<cfelse> 
	<cfset get_credit_contracts.recordcount = 0>
    <cfparam name="attributes.totalrecords" default='0'>
</cfif> 
   <cfquery name="get_credit_limit" datasource="#dsn3#">
	SELECT CREDIT_LIMIT_ID,#dsn#.Get_Dynamic_Language(CREDIT_LIMIT_ID,'#session.ep.language#','CREDIT_LIMIT','LIMIT_HEAD',NULL,NULL,LIMIT_HEAD) AS LIMIT_HEAD FROM CREDIT_LIMIT ORDER BY LIMIT_HEAD
</cfquery>
<cfscript>
	get_setup_process_cat_fusename = getCredit_.get_setup_process_cat_fusename();
</cfscript>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_credit_contract" method="post" action="#request.self#?fuseaction=credit.list_credit_contract">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class ="form-group">
					<label><cf_get_lang dictionary_id='51362.Senaryoda Görünenler'><input type="checkbox" name="is_scenario_control" id="is_scenario_control" value="1" <cfif attributes.is_scenario_control eq 1>checked</cfif> /></label>
				</div>
				<div class ="form-group">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255"  placeHolder="#getLang(2667,"Kredi No",59178)#">
				</div>
				<div class ="form-group">
					<div class="input-group">
						<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
						<input type="text" name="company" id="company" placeHolder="<cf_get_lang dictionary_id='59171.Kredi Kurumu'>" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\'','COMPANY_ID','company_id','','3','120');" autocomplete="off" value="<cfoutput>#attributes.company#</cfoutput>" style="width:120px;">	  
						<cfset str_linke_ait="&field_comp_id=list_credit_contract.company_id&field_comp_name=list_credit_contract.company&select_list=2">
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput>','list');"></span>
					</div>
				</div>
				<div class ="form-group">
					<select name="listing_type" id="listing_type">
						<option value="1" <cfif attributes.listing_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
						<option value="2" <cfif attributes.listing_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
					</select>
				</div>
				<div class ="form-group">
					<select name="is_active" id="is_active" style="width:50px;">
						<option value="" <cfif attributes.is_active eq "">selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
					</select>
				</div>
				<div class ="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1," required="yes"  style="width:25px;">
				</div>
				<div class ="form-group">
					<cf_wrk_search_button button_type="4" cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' search_function="">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-credit_limit_id">
					<label class="col col-12"><cf_get_lang dictionary_id='58963.Kredi Limiti'></label>
						<div class="col col-12">
							<select name="credit_limit_id" id="credit_limit_id" style="width:130px;">
								<option value=""><cf_get_lang dictionary_id='58963.Kredi Limiti'></option>
								<cfoutput query="get_credit_limit">
									<option value="#credit_limit_id#" <cfif attributes.credit_limit_id eq credit_limit_id>selected</cfif>>#limit_head#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-credit_type_id">
						<label class="col col-12"><cf_get_lang dictionary_id='51358.Kredi Türü'></label>
						<div class="col col-12">
							<cfsavecontent variable="text"><cf_get_lang dictionary_id='51358.Kredi Türü'></cfsavecontent>
							<cf_wrk_combo
							name="credit_type_id"
							query_name="GET_CREDIT_TYPE"
							option_name="credit_type"
							option_value="credit_type_id"
							option_text="#text#"
							value="#attributes.credit_type_id#"
							width="130">
						</div>
					</div>
				</div>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-process_type">
						<label class="col col-12"><cf_get_lang dictionary_id ='57800.İşlem Tipi'></label>
						<div class="col col-12">
							<select name="process_type" id="process_type">
								<option value=""><cf_get_lang dictionary_id ='57800.İşlem Tipi'></option>	
								<cfloop query="get_setup_process_cat_fusename">
								<cfoutput><option value="#get_setup_process_cat_fusename.process_cat_id#" <cfif attributes.process_type eq get_setup_process_cat_fusename.process_cat_id>selected</cfif>>#get_setup_process_cat_fusename.process_cat#</option></cfoutput>
								</cfloop>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-credit_employee_id">
						<label class="col col-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
						<div class="col col-12">
							<input type="hidden" name="credit_employee_id" id="credit_employee_id" value="<cfoutput>#attributes.credit_employee_id#</cfoutput>">
							<cf_wrk_employee_positions form_name='list_credit_contract' emp_id='credit_employee_id' emp_name='credit_employee'>
							<div class="input-group">
								<input type="text" name="credit_employee" id="credit_employee" value="<cfoutput>#attributes.credit_employee#</cfoutput>" onFocus="AutoComplete_Create('credit_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','credit_employee_id','','3','120');">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_credit_contract.credit_employee_id&field_name=list_credit_contract.credit_employee&select_list=1','list');"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
					<div class="form-group" id="item-start_date">
						<label class="col col-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58492.Tarihi Kontrol Ediniz.'></cfsavecontent>
								<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" >
								<span class="input-group-addon "><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="6" sort="true">
					<div class="form-group" id="item-finish_date">
						<label class="col col-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
						<div class="col col-12">
							<div class="input-group ">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58492.Tarihi Kontrol Ediniz.'></cfsavecontent>
								<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
								<span class="input-group-addon "><cf_wrk_date_image date_field="finish_date"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
			<cfset colspan=8>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(1,'Krediler',51333)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='51338.Kredi No'></th>
					<cfif isdefined("is_agreement_no") and is_agreement_no eq 1>
						<th><cf_get_lang dictionary_id='30044.Sözleşme No'></th><cfset colspan=colspan+1>
					</cfif>
					<th><cfoutput>#getLang(2661,"Kredi Türü",59172)#</cfoutput></th>
					<cfif attributes.listing_type eq 1><th><cf_get_lang dictionary_id='57742.Tarih'></th><cfset colspan=colspan+1></cfif>
					<cfif attributes.listing_type eq 2>
						<th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th><cfset colspan=colspan+1>
					</cfif>
					<th><cf_get_lang dictionary_id='51334.Kredi Kurumu'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<cfif is_credit_employee_id eq 1><th><cf_get_lang dictionary_id='57544.Sorumlu'></th></cfif>
					<cfif isdefined("is_detail_credit_contract") and is_detail_credit_contract neq 1>
						<th><cf_get_lang dictionary_id='57845.Tahsilat'></th>
						<th><cf_get_lang dictionary_id='57847.Ödeme'></th><cfset colspan=colspan+2>
					<cfelseif attributes.listing_type eq 2>
						<th><cf_get_lang dictionary_id='57845.Tahsilat'></th>
						<th><cf_get_lang dictionary_id='57847.Ödeme'></th><cfset colspan=colspan+2>
					<cfelseif isdefined("is_detail_credit_contract") and is_detail_credit_contract eq 1 and attributes.listing_type eq 1>
						<th><cf_get_lang dictionary_id='58869.Planlanan'> <cf_get_lang dictionary_id='57845.Tahsilat'></th>
						<th><cf_get_lang dictionary_id='51389.Gerçekleşen'> <cf_get_lang dictionary_id='57845.Tahsilat'></th>
						<th><cf_get_lang dictionary_id='58869.Planlanan'> <cf_get_lang dictionary_id='57847.Ödeme'></th>
						<th><cf_get_lang dictionary_id='51389.Gerçekleşen'> <cf_get_lang dictionary_id='57847.Ödeme'></th><cfset colspan=colspan+4>
						<th><cf_get_lang dictionary_id='59340.Gecikme Tutarı'></th>
					</cfif>
					<cfif isdefined("is_detail_credit_contract") and is_detail_credit_contract neq 1 and attributes.listing_type neq 2>
						<th><cfoutput>#getLang(1171,"Fark",58583)#</cfoutput></th>
						<th><cfoutput>#getLang(77,"Para Birimi",57489)#</cfoutput></th><cfset colspan=colspan+2>
					<cfelseif isdefined("is_detail_credit_contract") and is_detail_credit_contract eq 1 and attributes.listing_type eq 1>
						<th><cfoutput>#getLang(1032,"Kalan",58444)#</cfoutput><cf_get_lang dictionary_id='57845.Tahsilat'></th>
						<th><cfoutput>#getLang(1032,"Kalan",58444)#</cfoutput><cf_get_lang dictionary_id='57847.Ödeme'></th><cfset colspan=colspan+3>
						<th><cfoutput>#getLang(77,"Para Birimi",57489)#</cfoutput></th>
					</cfif>
					<!-- sil -->	
					<th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=credit.list_credit_contract&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_credit_contracts.recordcount>
					<cfoutput query="get_credit_contracts">
						<tr>
							<td>#rownum#</td>
							<td><a href="#request.self#?fuseaction=credit.list_credit_contract&event=det&credit_contract_id=#credit_contract_id#" class="tableyazi">#credit_no#</a></td>
							<cfif isdefined("is_agreement_no") and is_agreement_no eq 1><td>#agreement_no#</td></cfif>
							<td>#CREDIT_TYPE#</td>
							<cfif attributes.listing_type eq 1><td>#dateformat(credit_date,dateformat_style)#</td></cfif> 
							<cfif attributes.listing_type eq 2>
								<td>#dateformat(row_process_date,dateformat_style)#</td> 
							</cfif>
							<td><cfif len(company_id)><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');"><cfif len(company_id)>#nickname#</cfif></a></cfif></td>
							<td>#detail#</td>
							<cfif is_credit_employee_id eq 1>
								<td>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#credit_emp_id#','medium');" class="tableyazi">
										#SORUMLU#</a>
								</td>
							</cfif>
							<cfif isdefined("is_detail_credit_contract") and is_detail_credit_contract neq 1 and attributes.listing_type eq 1>
								<td style="text-align:right;">#tlformat(row_total_revenue,session.ep.our_company_info.rate_round_num)#</td>
								<td style="text-align:right;">#tlformat(row_total_payment,session.ep.our_company_info.rate_round_num)#</td>
							<cfelseif attributes.listing_type eq 2>
								<td style="text-align:right;">#tlformat(row_total_revenue1,session.ep.our_company_info.rate_round_num)#</td>
								<td style="text-align:right;">#tlformat(row_total_payment1,session.ep.our_company_info.rate_round_num)#</td>
							<cfelseif isdefined("is_detail_credit_contract") and is_detail_credit_contract eq 1 and attributes.listing_type eq 1>
								<td style="text-align:right;">#tlformat(row_total_revenue,session.ep.our_company_info.rate_round_num)#</td>
								<td style="text-align:right;">
									#TLFormat(REALIZED_COLLECTION,session.ep.our_company_info.rate_round_num)#
								</td>
								<td style="text-align:right;">#TLFormat(row_total_payment,session.ep.our_company_info.rate_round_num)#</td>
								<td style="text-align:right;">
										#TLFormat(PAYMENT_REALIZED,session.ep.our_company_info.rate_round_num)#
								</td>
								<td style="text-align:right;">
									<cfif isdefined("delay_price")>
										#TLFormat(delay_price,session.ep.our_company_info.rate_round_num)#
									<cfelse>
										#TLFormat(0,session.ep.our_company_info.rate_round_num)#
									</cfif>
								</td>
							</cfif>
							<cfif isdefined("is_detail_credit_contract") and is_detail_credit_contract neq 1 and attributes.listing_type neq 2>
								<td style="text-align:right;">#TLFormat(row_total_revenue - row_total_payment,session.ep.our_company_info.rate_round_num)#</td>
								<td align="center">#money_type#</td>
							<cfelseif isdefined("is_detail_credit_contract") and is_detail_credit_contract eq 1 and attributes.listing_type eq 1>
								<td style="text-align:right;">
									#TLFormat(row_total_revenue - REALIZED_COLLECTION,session.ep.our_company_info.rate_round_num)#
								</td>
								<td style="text-align:right;">
										#TLFormat(row_total_payment + delay_price - wrk_round(PAYMENT_REALIZED),session.ep.our_company_info.rate_round_num)#
								</td>
								<td align="center">#money_type#</td>
							</cfif>
							<!-- sil -->
							<td><a href="#request.self#?fuseaction=credit.list_credit_contract&event=det&credit_contract_id=#get_credit_contracts.credit_contract_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr> 
					</cfoutput>
				</tbody>
					<cfscript>
						getTotalCreditPayment = getCredit_.getTotalCreditPayment(
							listing_type : attributes.listing_type,
							company_id : attributes.company_id,
							company : attributes.company,
							keyword : attributes.keyword,
							credit_employee_id : attributes.credit_employee_id,
							credit_employee : attributes.credit_employee,
							start_date : attributes.start_date,
							finish_date :  attributes.finish_date,
							is_active : attributes.is_active,
							process_type : attributes.process_type,
							credit_limit_id : attributes.credit_limit_id,
							credit_type_id : attributes.credit_type_id,
							is_scenario_control : attributes.is_scenario_control 
						);
					</cfscript>
					<cfoutput>
						<tfoot>
							<tr>
								<cfif isdefined("is_agreement_no") and is_agreement_no eq 1 and is_credit_employee_id eq 1>
									<td colspan="8" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='29954.Genel'> <cf_get_lang dictionary_id='57492.Toplam'></td>
								</cfif>
									<cfif isdefined("is_agreement_no") and is_agreement_no eq 0 and is_credit_employee_id eq 0>
									<td colspan="6" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='29954.Genel'> <cf_get_lang dictionary_id='57492.Toplam'></td>
								</cfif>
								<cfif isdefined("is_agreement_no") and is_agreement_no eq 1 and is_credit_employee_id eq 0>
									<td colspan="7" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='29954.Genel'> <cf_get_lang dictionary_id='57492.Toplam'></td>
								</cfif>
								<cfif isdefined("is_agreement_no") and is_agreement_no eq 0 and is_credit_employee_id eq 1>
									<td colspan="7" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='29954.Genel'> <cf_get_lang dictionary_id='57492.Toplam'></td>
								</cfif>
									<cfif attributes.listing_type eq 1>
										<td class="txtbold" style="text-align:right;">
											<cfloop query="getTotalCreditPayment">
												#tlformat(TOTAL_COLLECTION_PLANNED)#<br/>
											</cfloop>
										</td>
										<cfif isdefined("is_detail_credit_contract") and is_detail_credit_contract eq 1>
											<td class="txtbold" style="text-align:right;">
												<cfloop query="getTotalCreditPayment">
													#tlformat(TOTAL_REALIZED_COLLECTION)#<br/>
												</cfloop>
											</td>
										</cfif>
										<td class="txtbold" style="text-align:right;">
											<cfloop query="getTotalCreditPayment">
												#tlformat(getTotalCreditPayment.PAYMENT_TOTAL_PLANNED)#<br/>
											</cfloop>
										</td>
										<cfif isdefined("is_detail_credit_contract") and is_detail_credit_contract eq 0>
											<td class="txtbold" style="text-align:right;">
												<cfloop query="getTotalCreditPayment">
													#tlformat(TOPLAM_FARK)#<br/>
												</cfloop>
											</td>
										</cfif>
										<cfif isdefined("is_detail_credit_contract") and is_detail_credit_contract eq 1>
											<td class="txtbold" style="text-align:right;">
												<cfloop query="getTotalCreditPayment">
													#tlformat(getTotalCreditPayment.PAYMENT_TOTAL_REALIZED)#<br/>
												</cfloop>
											</td>
											<td class="txtbold" style="text-align:right;">
												<cfloop query="getTotalCreditPayment">
													#tlformat(getTotalCreditPayment.TOTAL_AMOUNT_OF_DELAY)#<br/>
												</cfloop>
											</td>
											<td class="txtbold" style="text-align:right;">
												<cfloop query="getTotalCreditPayment">
													#tlformat(getTotalCreditPayment.REMAINING_TOTAL_COLLECTION)#<br/>
												</cfloop>
											</td> 
											<td class="txtbold" style="text-align:right;">
												<cfloop query="getTotalCreditPayment">
													#tlformat(getTotalCreditPayment.REMAINING_TOTAL_PAYMENT)#<br/>
												</cfloop>
											</td>
									</cfif>
										<td class="txtbold" colspan="2" style="text-align:left;">
											<cfloop query="getTotalCreditPayment">
												#getTotalCreditPayment.PARA_BIRIMI#<br/>
											</cfloop>
										</td>
									</cfif>
									<cfif attributes.listing_type eq 2>
										<td class="txtbold" style="text-align:right;">
											<cfloop query="getTotalCreditPayment">
												#tlformat(ROW_ODEME)#<br/>
											</cfloop>
										</td>
										<td class="txtbold" style="text-align:right;">
											<cfloop query="getTotalCreditPayment">
												#tlformat(ROW_TAHSILAT)#<br/>
											</cfloop>
										</td>
										<td class="txtbold"  style="text-align:right;">
										</td>
									</cfif>
						</tfoot>
					
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="<cfoutput>#colspan#</cfoutput>"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
		</cf_grid_list>

		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres="credit.list_credit_contract">
			<cfif len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.company_id)>
				<cfset adres = "#adres#&company_id=#attributes.company_id#">
			</cfif>
			<cfif len(attributes.company)>
				<cfset adres ="#adres#&company=#attributes.company#">
			</cfif>
			<cfif len(attributes.credit_employee_id)>
				<cfset adres = "#adres#&credit_employee_id=#attributes.credit_employee_id#">
			</cfif>
			<cfif len(attributes.credit_employee)>
				<cfset adres = "#adres#&credit_employee=#attributes.credit_employee#">
			</cfif>
			<cfif len(attributes.start_date)>
				<cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
			</cfif>
			<cfif len(attributes.finish_date)>
				<cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
			</cfif>
			<cfif len(attributes.is_active)>
				<cfset adres = "#adres#&is_active=#attributes.is_active#">
			</cfif>
			<cfif len(attributes.process_type)>
				<cfset adres = "#adres#&process_type=#attributes.process_type#">
			</cfif>
			<cfif len(attributes.listing_type)>
				<cfset adres = "#adres#&listing_type=#attributes.listing_type#">
			</cfif>
			<cfif len(attributes.credit_limit_id)>
				<cfset adres = "#adres#&credit_limit_id=#attributes.credit_limit_id#">
			</cfif>
			<cfif len(attributes.credit_type_id)>
				<cfset adres = "#adres#&credit_type_id=#attributes.credit_type_id#">
			</cfif>
			<cf_paging
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#"  
				startrow="#attributes.startrow#" 
				adres="#adres#&form_submitted=1">
		</cfif>
	</cf_box>
</div>

<script type="text/javascript">
	$('#keyword').focus();
</script>
 
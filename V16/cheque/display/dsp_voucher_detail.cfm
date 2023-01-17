<cf_get_lang_set module_name="cheque">
<cf_xml_page_edit fuseact="cheque.popup_view_voucher_detail">
<cfset refmodule="#listgetat(attributes.fuseaction,1,'.')#">
<cfquery name="check_our_company" datasource="#dsn#">
	SELECT IS_REMAINING_AMOUNT FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfif isnumeric(url.id)>
	<cfinclude template="../query/get_voucher_detail.cfm">
<cfelse>
	<cfset get_voucher_detail.recordcount = 0>
</cfif>
<cfquery name="get_bank_action" datasource="#dsn2#">
	SELECT ACTION_ID,ISNULL(UPD_STATUS,1) AS UPD_STATUS FROM BANK_ACTIONS WHERE VOUCHER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>
<cfquery name="get_remaining_amount" datasource="#dsn2#">
	SELECT 
    	VOUCHER_ID, 
        REMAINING_VALUE, 
        OTHER_REMAINING_VALUE, 
        OTHER_REMAINING_VALUE2 
    FROM 
    	VOUCHER_REMAINING_AMOUNT 
    WHERE 
    	VOUCHER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>
<cfsavecontent variable="head_">
	<cf_get_lang dictionary_id='58502.Senet No'>: <cfoutput>#get_voucher_detail.VOUCHER_NO#</cfoutput><cfif get_voucher_detail.is_pay_term eq 1> - <cf_get_lang dictionary_id ="29945.Ödeme Sözü"> </cfif>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#head_#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfif not get_voucher_detail.recordcount>
			<cfset hata  = 11>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='58004.Böyle Bir Senet Bulunamadı'> !</cfsavecontent>
			<cfset hata_mesaj  = message>
				<cfinclude template="../../dsp_hata.cfm">
			<cfelse>
			<cfform name="change_status">
				<cfoutput query="get_voucher_history">
					<cf_box_elements>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12"  style="text-align:right;">
							<cfsavecontent variable="bordro">
							<cfif len(get_voucher_detail.VOUCHER_PAYROLL_ID)>		
								<cfinclude template="../query/get_voucher_payroll.cfm"> 
								<cfset payroll_type = get_voucher_payroll.payroll_type>
								<cfif get_voucher_payroll.PAYROLL_NO gt 1>
									<cfset type=payroll_type>
									<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ch.popup_dsp_voucher_payroll_action&draggable=1&ID=#get_voucher_payroll.ACTION_ID#&period_id=#session.ep.period_id#&our_company_id=#session.ep.company_id#');" class="bold" style="color:##555">
										#get_voucher_payroll.PAYROLL_NO# 
									</a> 
								<cfelseif get_voucher_payroll.PAYROLL_NO eq -1>
									<cf_get_lang dictionary_id='50336.Açılış'>
								<cfelseif get_voucher_payroll.PAYROLL_NO eq -2>
									<cf_get_lang dictionary_id="51695.Bordrosuz">
								</cfif>
							<cfelse>
								<cfset payroll_type = 0>
							</cfif>
						</cfsavecontent>
							<!---  --->
							<cfif UPD_STATUS neq 0 and currentrow eq get_voucher_history.recordcount and (get_voucher_detail.voucher_status_id eq 5 or get_voucher_detail.voucher_status_id eq 7 or get_voucher_detail.voucher_status_id eq 12 or (get_voucher_detail.voucher_status_id eq 3 and not len(get_voucher_history.payroll_id))) and get_voucher_history.recordcount gte 2>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='50378.İşlemi Geri Almak İstediğinizden Emin misiniz?'></cfsavecontent>
								<cfif (get_bank_action.recordcount and get_bank_action.upd_status eq 1) or get_bank_action.recordcount eq 0>
									<a href="##" onClick="javascript:if (confirm('#message#')) windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_voucher_process&p_id=#get_voucher_history.PAYROLL_ID#&c_id=#URL.ID#','small'); else return;"  style="color:##555"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='50242.Çıkar'>" title="<cf_get_lang dictionary_id='50242.Çıkar'>"></i></a> 
								</cfif>
							<cfelseif len(get_voucher_history.payroll_id)>	
								<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_upd_voucher_history&draggable=1&history_id=#history_id#&p_id=#get_voucher_history.PAYROLL_ID#&c_id=#URL.ID#');"  style="color:##555"><i class="fa fa-paste" alt="<cf_get_lang dictionary_id ='50377.Senet History Guncelle'>" title="<cf_get_lang dictionary_id ='50377.Senet History Guncelle'>"></i></a> 
							</cfif>
							<cfif Len(payroll_id)>
								<cfquery name="get_payroll_action" datasource="#dsn2#">
									SELECT 
										ACTION_ID,
										ACTION_TYPE_ID
									FROM
										VOUCHER_PAYROLL_ACTIONS
									WHERE
										PAYROLL_ID = #payroll_id#
								</cfquery>
							<cfelse>
								<cfset get_payroll_action.recordcount = 0>
							</cfif>
							<cfif get_payroll_action.recordcount>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#get_payroll_action.action_id#&process_cat=#get_payroll_action.action_type_id#','page');"  style="color:##555"><i class="fa fa-ticket" alt="<cf_get_lang dictionary_id ='58452.Mahsup Fişi'>" title="<cf_get_lang dictionary_id ='58452.Mahsup Fişi'>"></i></a>
							<cfelseif listfind('3,5,7',get_voucher_history.status) and not len(payroll_id)>
								<cfquery name="get_bank_act" datasource="#dsn2#">
									SELECT ACTION_ID,ACTION_TYPE_ID FROM BANK_ACTIONS WHERE VOUCHER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
								</cfquery>
								<cfquery name="get_cash_act" datasource="#dsn2#">
									SELECT ACTION_ID,ACTION_TYPE_ID FROM CASH_ACTIONS WHERE VOUCHER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
								</cfquery>
								<cfif get_bank_act.recordcount>
									<cfset act_id = get_bank_act.action_id>
									<cfset act_process = get_bank_act.action_type_id>
								<cfelseif get_cash_act.recordcount>
									<cfset act_id = get_cash_act.action_id>
									<cfset act_process = get_cash_act.action_type_id>
								<cfelse>
									<cfset act_id = url.id>
									<cfset act_process = 1056>
								</cfif>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#act_id#&process_cat=#act_process#','page');" style="color:##555"><i class="fa fa-ticket" alt="<cf_get_lang dictionary_id ='58452.Mahsup Fişi'>" title="<cf_get_lang dictionary_id ='58452.Mahsup Fişi'>"></i></a>
							<cfelseif len(payroll_id)>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#payroll_id#&process_cat=#payroll_type#','page');" style="color:##555" ><i class="fa fa-ticket"  alt="<cf_get_lang dictionary_id='58452.Mahsup Fişi'>" title="<cf_get_lang dictionary_id ='58452.Mahsup Fişi'>"></i></a>
							</cfif>
						</div>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group">
								<label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
								<label class="col col-8 col-xs-12">#dateformat(get_voucher_history.ACT_DATE,dateformat_style)#</label>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='58182.Portföy No'></label>
								<label class="col col-8 col-xs-12">#get_voucher_detail.VOUCHER_PURSE_NO#</label>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='50206.Bordro'></label>
								<label class="col col-8 col-xs-12">
									#bordro#
								</label>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57482.Aşama'></label>
								<label class="col col-8 col-xs-12">
									<cfswitch expression="#get_voucher_history.status#">
										<cfcase value="1"><cf_get_lang dictionary_id='50249.Portföyde'></cfcase>
										<cfcase value="2"><cf_get_lang dictionary_id='50250.Bankada'></cfcase>
										<cfcase value="3"><cf_get_lang dictionary_id='50251.Tahsil Edildi'></cfcase>
										<cfcase value="4"><cf_get_lang dictionary_id='50252.Ciro Edildi'></cfcase>
										<cfcase value="5"><cf_get_lang dictionary_id='50334.Protestolu'></cfcase>
										<cfcase value="6"><cf_get_lang dictionary_id='50254.Ödenmedi'></cfcase>
										<cfcase value="7"><cf_get_lang dictionary_id='50255.Ödendi'> </cfcase>
										<cfcase value="8"><cf_get_lang dictionary_id='58506.İptal'></cfcase>
										<cfcase value="9"><cf_get_lang dictionary_id='29418.İade'></cfcase>
										<cfcase value="10"><cf_get_lang dictionary_id='50334.Protestolu'>-<cf_get_lang dictionary_id='50249.Portföyde'></cfcase>
										<cfcase value="11"><cf_get_lang dictionary_id='50364.Kısmi Tahsil'></cfcase>
										<cfcase value="12"><cf_get_lang dictionary_id='50363.İcra'></cfcase>
										<cfcase value="13"><cf_get_lang dictionary_id='50467.Teminatta'></cfcase>
										<cfcase value="14"><cf_get_lang dictionary_id='58568.Transfer'></cfcase>
									</cfswitch> 
								</label>
							</div>
							<cfif x_transfer_info eq 1>
								<div class="form-group">
									<label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='61951.Transfer Olan Kasa'></label>
									<cfif len(payroll_id) and (get_voucher_payroll.payroll_type eq 136 or get_voucher_payroll.payroll_type eq 137)>
										<label class="col col-8 col-xs-12">#cash_name1#</label>
									</cfif>    
								</div>
								<div class="form-group">
									<label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='61952.Transfer Edilen Kasa'></label>
									<cfif len(payroll_id) and (get_voucher_payroll.payroll_type eq 136 or get_voucher_payroll.payroll_type eq 137)>	
										<label class="col col-8 col-xs-12">#cash_name2#</label>
									</cfif>    
								</div>
							</cfif>
						</div>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group">
								<label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57658.Üye'></label>
								<label class="col col-8 col-xs-12"><cfif len(get_voucher_payroll.COMPANY_ID)>#get_par_info(get_voucher_payroll.COMPANY_ID,1,1,0)#</cfif></label>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57521.Banka'></label>
								<label class="col col-8 col-xs-12">
									<cfif len(get_voucher_payroll.payroll_account_id)>
										<cfif get_voucher_history.status eq 3>
											<cfquery name="get_bank_act" datasource="#dsn2#">
												SELECT ACTION_TO_ACCOUNT_ID FROM BANK_ACTIONS WHERE VOUCHER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
											</cfquery>
											<cfset bank_acc = get_bank_act.ACTION_TO_ACCOUNT_ID>
										<cfelse>
											<cfset bank_acc =get_voucher_payroll.payroll_account_id>
										</cfif>
										<cfquery name="get_bank_branch" datasource="#dsn3#">
											SELECT BB.BANK_NAME, BB.BANK_BRANCH_NAME FROM ACCOUNTS ACC,BANK_BRANCH BB WHERE ACC.ACCOUNT_BRANCH_ID = BB.BANK_BRANCH_ID AND ACC.ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#bank_acc#">
										</cfquery>
										#get_bank_branch.BANK_NAME# #get_bank_branch.BANK_BRANCH_NAME#
									</cfif>
								</label>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='58180.Borçlu'></label>
								<label class="col col-8 col-xs-12">#get_voucher_detail.debtor_name#</label>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57640.Vade'></label>
								<label class="col col-8 col-xs-12">#dateformat(get_voucher_detail.voucher_duedate,dateformat_style)#</label>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='50272.İşlem Para Br'></label>
								<label class="col col-8 col-xs-12" style="text-align:right;">
									<cfif get_voucher_history.status neq 3>
										#TLFormat(get_voucher_history.VOUCHER_VALUE_)# #get_voucher_detail.currency_id#
									<cfelse>
										#TLFormat(get_voucher_history.VOUCHER_VALUE)# #get_voucher_detail.currency_id#
									</cfif>
								</label>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='50263.Sistem Para Br'></label>
								<label class="col col-8 col-xs-12" style="text-align:right;">
									<cfif get_voucher_history.status neq 3>
										<cfif len(get_voucher_history.OTHER_MONEY_VALUE_)>#tlformat(get_voucher_history.OTHER_MONEY_VALUE_)# #get_voucher_history.OTHER_MONEY#</cfif>
									<cfelse>
										<cfif len(get_voucher_history.OTHER_MONEY_VALUE)>#tlformat(get_voucher_history.OTHER_MONEY_VALUE)# #get_voucher_history.OTHER_MONEY#</cfif>
									</cfif>
								</label>
							</div>
						</div>
					</cf_box_elements>
					<cfif get_voucher_history.recordcount gt 1 and not get_voucher_history.currentrow eq get_voucher_history.recordcount>
						<hr class="margin-bottom-15" style="height: 0px;border-top: 1px solid ##d6d6d6;">
					</cfif>
				</cfoutput>
				<cfif isdefined("x_asset_notes") and x_asset_notes eq 1>
					<!--- Notlar --->
					<cf_get_workcube_note action_section='VOUCHER_ID' action_id='#attributes.id#' period_id='#session.ep.period_id#'><br/>					
					<!--- Belgeler --->
					<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-17" module_id='16' action_section='VOUCHER_ID' action_id='#attributes.id#'><br/>
				</cfif>
				<cf_box_footer>
					<cfif get_voucher_detail.VOUCHER_STATUS_ID eq 6>
						<input type="button" class="ui-wrk-btn ui-wrk-btn-extra" name="bir" value="<cf_get_lang dictionary_id='50255.Ödendi'>" onclick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_masraf&sta=7&voucher=1&voucher_id=#url.id#</cfoutput>','medium','popup_add_masraf')">
				<cfelseif get_voucher_detail.VOUCHER_STATUS_ID eq 2 or get_voucher_detail.VOUCHER_STATUS_ID eq 13>
						<input type="button" class="ui-wrk-btn ui-wrk-btn-extra" name="iki" value="<cf_get_lang dictionary_id='50239.Tahsil Et'>" onclick="javascript:openBoxDraggable('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_masraf&sta=3&voucher=1&draggable=1&voucher_id=#url.id#</cfoutput>')">
						<input type="button" class="ui-wrk-btn ui-wrk-btn-extra" name="uc" value="<cf_get_lang dictionary_id ='50238.Protesto Et'>" onclick="javascript:openBoxDraggable('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_masraf&sta=5&voucher=1&draggable=1&voucher_id=#url.id#&extra_status=2</cfoutput>')">
				<cfelseif get_voucher_detail.VOUCHER_STATUS_ID eq 1>
						<input type="button" class="ui-wrk-btn ui-wrk-btn-extra" name="uc" value="<cf_get_lang dictionary_id ='50238.Protesto Et'>" onclick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_masraf&sta=5&voucher=1&voucher_id=#url.id#&extra_status=1</cfoutput>','medium','popup_add_masraf')">
				</cfif>
					<cfif len(get_voucher_detail.VOUCHER_PAYROLL_ID)>
						<cfinclude template="../query/get_voucher_payroll.cfm"> 
						<cfif get_voucher_payroll.recordcount and get_voucher_payroll.PAYROLL_NO eq -1 and get_voucher_history.recordcount eq 1>
							<cfsavecontent variable="mesage"><cf_get_lang dictionary_id ='50382.Senedi Silmek İstediğinizden Emin misiniz'></cfsavecontent>
							<cf_workcube_buttons is_upd='0' is_insert='0' is_delete='1' is_cancel ='0' delete_page_url='#request.self#?fuseaction=cheque.list_vouchers&event=del&voucher_id=#get_voucher_detail.voucher_id#' delete_alert=' #mesage#'>
						</cfif>
					</cfif>
				</cf_box_footer>	
			</cfform>
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	function warn1()
	{
		if(confirm("<cf_get_lang dictionary_id ='50379.Senedin durumu ödendi olarak değiştirilecek emin misiniz'> "))
			document.change_status.submit();
		else
			return false;
	}
	
	function warn2()
	{
		if(confirm("<cf_get_lang dictionary_id ='50380.Senetin durumu protestolu olarak değiştirilecek emin misiniz'> "))
			document.change_status.submit();
		else
			return false;
	}
	
	function warn3()
	{
		if(confirm("<cf_get_lang dictionary_id ='50381.Senedin durumu tahsil edildi olarak değiştirilecek emin misiniz'>"))
			document.change_status.submit();
		else
			return false;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

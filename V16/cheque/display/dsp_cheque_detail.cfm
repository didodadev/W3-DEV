<cf_get_lang_set module_name="cheque">
<cfset refmodule="#listgetat(attributes.fuseaction,1,'.')#">
<cfquery name="GET_PERIOD_CONTROL" datasource="#dsn#">
	SELECT 
    	PERIOD_ID, 
        PERIOD, 
        PERIOD_YEAR, 
        IS_INTEGRATED, 
        OUR_COMPANY_ID, 
        PERIOD_DATE, 
        OTHER_MONEY, 
        STANDART_PROCESS_MONEY, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP, 
        PROCESS_DATE 
    FROM 
    	SETUP_PERIOD 
    WHERE 
    	PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year-1#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cf_xml_page_edit fuseact="cheque.popup_view_cheque_detail">
<cfif isnumeric(url.id)>
	<cfinclude template="../query/get_cheque_detail.cfm">
<cfelse>
	<cfset get_cheque_detail.recordcount = 0>
</cfif>
<cfquery name="get_bank_action" datasource="#dsn2#">
	SELECT ACTION_ID,ISNULL(UPD_STATUS,1) AS UPD_STATUS FROM BANK_ACTIONS WHERE CHEQUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>
<cfif not get_cheque_detail.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='58002.Böyle Bir Çek Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
		<cf_box title="#getLang('','settings',58007)#" id="dsp_cheque_details" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
			<cfsavecontent variable="title1"><cf_get_lang dictionary_id='57473.Tarihçe'></cfsavecontent>
				<cfsavecontent variable="title2"><cf_get_lang dictionary_id='57422.Notlar'></cfsavecontent>
				<cfsavecontent variable="title3"><cf_get_lang dictionary_id='57568.Belgeler'></cfsavecontent>
			<cf_tab divID = "sayfa_1,sayfa_2,sayfa_3" defaultOpen="sayfa_1" divLang = "#title1#;#title2#;#title3#" tabcolor = "fff">   
				<div id = "unique_sayfa_1" class = "uniqueBox">
				<cfform name="change_status" action="" method="post">	
				<cf_grid_list>
					<thead>
						<tr> 
							<th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
							<th><cf_get_lang dictionary_id='58182.Portföy No'></th>
							<th><cf_get_lang dictionary_id='50206.Bordro'></th>
							<th><cf_get_lang dictionary_id='57482.Aşama'></th>
							<cfif x_transfer_info eq 1>
								<th><cf_get_lang dictionary_id='61951.Transfer Olan Kasa'></th>
								<th><cf_get_lang dictionary_id='61952.Transfer Edilen Kasa'></th>
							</cfif>
							<th><cf_get_lang dictionary_id='57519.cari hesap'></th>
							<th><cf_get_lang dictionary_id='57521.Banka'></th>
							<th><cf_get_lang dictionary_id='58180.Borçlu'></th>
							<th><cf_get_lang dictionary_id='58970.Ciro Eden'></th> 
							<th><cf_get_lang dictionary_id='57640.Vade'></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id='50272.İşlem Para Br'></th>
							<th style="text-align:right;"><cf_get_lang dictionary_id='50263.Sistem Para Br'></th>
							<th width="20"></th>
							<th width="20"></th>
						</tr>
					</thead>
					<tbody>
						<cfoutput query="get_cheque_history"> 
							<tr> 
								<cfif len(payroll_id)>
									<cfinclude template="../query/get_cheque_payroll.cfm"> 
									<cfset payroll_type = get_cheque_payroll.payroll_type>
								<cfelse>
									<cfset payroll_type = 0>
								</cfif>
								<td>
									#dateformat(get_cheque_history.ACT_DATE,dateformat_style)#
								</td>
								<td>#get_cheque_detail.CHEQUE_PURSE_NO#</td>
								<td>
									<cfset payroll_id=get_cheque_detail.CHEQUE_PAYROLL_ID>
									<cfif len(payroll_id)>	
										<cfset type=payroll_type>
										<cfswitch expression="#type#">
											<cfcase value="90">
												<!--- <cfset act="Çek Giriş Bordrosu"> --->
												<cfset Xurl="popup_upd_payroll_entry_">
											</cfcase>
											<cfcase value="91">
												<!--- <cfset act="Çek Çıkış Bordrosu-Ciro"> --->
												<cfset Xurl="popup_upd_payroll_endorsement_">
											</cfcase>
											<cfcase value="92">
												<!--- <cfset act="Çek Çıkış Bordrosu-Tahsil"> --->
												<cfset Xurl="popup_upd_payroll_bank_revenue_">
											</cfcase>
											<cfcase value="93">
												<!--- <cfset act="Çek Çıkış Bordrosu-Banka"> --->
												<cfset Xurl="popup_upd_payroll_bank_guaranty_">
											</cfcase>
											<cfcase value="133">
												<!--- <cfset act="Çek Çıkış Bordrosu-Banka Teminat"> --->
												<cfset Xurl="popup_upd_payroll_bank_guaranty_tem_"> 
											</cfcase>
											<cfcase value="94">
												<!--- <cfset act="Çek İade Çıkış Bordrosu"> --->
												<cfset Xurl="popup_upd_payroll_endor_return_">
											</cfcase>
											<cfcase value="95">
												<!--- <cfset act="Çek İade Giriş Bordrosu"> --->
												<cfset Xurl="popup_upd_payroll_entry_return_">
											</cfcase>
											<cfcase value="105">
												<!--- <cfset act="Çek İade Giriş Bordrosu-Banka"> --->
												<cfset Xurl="popup_upd_payroll_bank_guaranty_return_"> 
											</cfcase>
											<cfcase value="106">
												<!--- <cfset act=""> --->
												<cfset Xurl="">
											</cfcase>
											<cfdefaultcase>
												<!--- <cfset act=""> --->
												<cfset Xurl="">
											</cfdefaultcase>
										</cfswitch>
										<cfif get_cheque_payroll.PAYROLL_NO gt 1>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.#Xurl#&ID=#get_cheque_payroll.ACTION_ID#','page');" class="tableyazi">
												#get_cheque_payroll.PAYROLL_NO# 
											</a> 
										<cfelseif get_cheque_payroll.PAYROLL_NO eq -1>
											<cf_get_lang dictionary_id='50336.Açılış'>
										<cfelseif get_cheque_payroll.PAYROLL_NO eq -2>
											<cf_get_lang dictionary_id='51695.Bordrosuz'>
										</cfif>
									</cfif>
								</td>
								<td>
									<cfswitch expression="#get_cheque_history.status#">
										<cfcase value="1"><cf_get_lang dictionary_id='50249.Portföyde'></cfcase>
										<cfcase value="2"><cf_get_lang dictionary_id='50250.Bankada'></cfcase>
										<cfcase value="3"><cf_get_lang dictionary_id='50251.Tahsil Edildi'> </cfcase>
										<cfcase value="4"><cf_get_lang dictionary_id='50252.Ciro Edildi'> </cfcase>
										<cfcase value="5"><cf_get_lang dictionary_id='50253.Karşılıksız'></cfcase>
										<cfcase value="6"><cf_get_lang dictionary_id='50254.Ödenmedi'></cfcase>
										<cfcase value="7"><cf_get_lang dictionary_id='50255.Ödendi'> </cfcase>
										<cfcase value="8"><cf_get_lang dictionary_id='58506.İptal'></cfcase>
										<cfcase value="9"><cf_get_lang dictionary_id='29418.İade'></cfcase>
										<cfcase value="10"><cf_get_lang dictionary_id='50253.Karşılıksız'>-<cf_get_lang dictionary_id='50249.Portföyde'></cfcase>
										<cfcase value="12"><cf_get_lang dictionary_id='50363.İcra'></cfcase>
										<cfcase value="13"><cf_get_lang dictionary_id='50467.Teminatta'></cfcase>
										<cfcase value="14"><cf_get_lang dictionary_id='58568.Transfer'></cfcase>
									</cfswitch>
									<cfif get_cheque_history.status eq 4 and GET_PERIOD_CONTROL.recordcount and get_cheque_payroll.PAYROLL_NO eq -1>
										<cfquery name="GET_EXTRA_INFO" datasource="#dsn2#">
											SELECT TOP 1
												P.COMPANY_ID,
												P.CONSUMER_ID
											FROM 
												#dsn_alias#.CHEQUE_VOUCHER_COPY_REF CC,
												#dsn#_#session.ep.period_year-1#_#session.ep.company_id#.CHEQUE_HISTORY CHH,
												#dsn#_#session.ep.period_year-1#_#session.ep.company_id#.PAYROLL P
											WHERE 
												CC.TO_CHEQUE_VOUCHER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
												AND CC.TO_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
												AND CC.IS_CHEQUE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
												AND CC.FROM_CHEQUE_VOUCHER_ID = CHH.CHEQUE_ID
												AND CHH.STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="4">
												AND CHH.PAYROLL_ID = P.ACTION_ID
											ORDER BY
												CHH.RECORD_DATE DESC
										</cfquery>
										<cfif GET_EXTRA_INFO.recordcount>
											<br/><cfif len(GET_EXTRA_INFO.COMPANY_ID)>
												(#get_par_info(GET_EXTRA_INFO.COMPANY_ID,1,1,0)#)
											<cfelseif len(GET_EXTRA_INFO.CONSUMER_ID)>
												(#get_cons_info(GET_EXTRA_INFO.CONSUMER_ID,0,0)#)
											</cfif>
										</cfif>
									</cfif>
								</td>
								<cfif x_transfer_info eq 1>
									<cfif len(payroll_id) and (get_cheque_payroll.payroll_type eq 134 or get_cheque_payroll.payroll_type eq 135)>
										<td>#cash_name1#</td>
										<td>#cash_name2#</td>
									<cfelse>
										<td></td>
										<td></td>
									</cfif>
								</cfif>
								<td>
									<cfif len(get_cheque_detail.cheque_payroll_id)>
										<cfif len(get_cheque_payroll.COMPANY_ID)>
											#get_par_info(get_cheque_payroll.COMPANY_ID,1,1,0)#
										<cfelseif len(get_cheque_detail.COMPANY_ID)>
											#get_par_info(get_cheque_detail.COMPANY_ID,1,1,0)#
										<cfelseif len(get_cheque_payroll.CONSUMER_ID)>
											#get_cons_info(get_cheque_payroll.CONSUMER_ID,0,0)#
										<cfelseif len(get_cheque_detail.CONSUMER_ID)>
											#get_cons_info(get_cheque_detail.CONSUMER_ID,0,0)#
										</cfif>	
									</cfif>
								</td>
								<td>
									<cfif len(get_cheque_payroll.payroll_account_id)>
										<cfif get_cheque_history.status eq 3>
											<cfquery name="get_bank_act" datasource="#dsn2#">
												SELECT ACTION_TO_ACCOUNT_ID FROM BANK_ACTIONS WHERE CHEQUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
											</cfquery>
											<cfset bank_acc = get_bank_act.ACTION_TO_ACCOUNT_ID>
										<cfelse>
											<cfset bank_acc =get_cheque_payroll.payroll_account_id>
										</cfif>
										<cfquery name="get_bank_branch" datasource="#dsn3#">
											SELECT BB.BANK_NAME, BB.BANK_BRANCH_NAME FROM ACCOUNTS ACC,BANK_BRANCH BB WHERE ACC.ACCOUNT_BRANCH_ID = BB.BANK_BRANCH_ID AND ACC.ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#bank_acc#">
										</cfquery>
										#get_bank_branch.BANK_NAME# #get_bank_branch.BANK_BRANCH_NAME#
									<cfelseif len(get_cheque_detail.bank_name) and get_cheque_history.status neq 1>
										#get_cheque_detail.BANK_NAME# #get_cheque_detail.bank_branch_name#</td>
									</cfif>
								</td>
								<td>#get_cheque_detail.DEBTOR_NAME#</td>
								<td>#get_cheque_detail.ENDORSEMENT_MEMBER#</td>
								<td>#dateformat(get_cheque_detail.CHEQUE_DUEDATE,dateformat_style)#</td>
								<td style="text-align:right;">#TLFormat(get_cheque_detail.CHEQUE_VALUE)# #get_cheque_detail.CURRENCY_ID#</td>
								<td style="text-align:right;"><cfif len(get_cheque_history.OTHER_MONEY_VALUE)>#tlformat(get_cheque_history.OTHER_MONEY_VALUE)# #get_cheque_history.OTHER_MONEY#</cfif></td>
								<td nowrap>
									<cfif (currentrow eq get_cheque_history.recordcount) and  (payroll_type neq 92) and (payroll_type neq 105) and (get_cheque_detail.CHEQUE_STATUS_ID eq 5 or get_cheque_detail.CHEQUE_STATUS_ID eq 7 or (get_cheque_detail.CHEQUE_STATUS_ID eq 12 and get_cheque_payroll.PAYROLL_NO neq -1) or get_cheque_detail.CHEQUE_STATUS_ID eq 3) and get_cheque_history.recordcount gte 2>
										<cfsavecontent variable="back_message"><cf_get_lang dictionary_id ='50378.İşlemi Geri Almak İstediğinizden Emin misiniz'></cfsavecontent>
										<cfif (get_bank_action.recordcount and get_bank_action.upd_status eq 1) or get_bank_action.recordcount eq 0>
											<a href="javascript://" onClick="javascript:if (confirm('#back_message#')) windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_process&p_id=#get_cheque_history.PAYROLL_ID#&c_id=#URL.ID#','small'); else return;"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='50242.Çıkar'>" title="<cf_get_lang dictionary_id='50242.Çıkar'>"></i></a> 
										</cfif>
									<cfelseif len(payroll_id)>
										<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_upd_cheque_history&p_id=#get_cheque_history.PAYROLL_ID#&c_id=#URL.ID#');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='50271.Değer Güncelle'>" title="<cf_get_lang dictionary_id='50271.Değer Güncelle'>"></i></a> 
									</cfif>
								</td>
								<td>
									<cfif listfind('3,5,7',get_cheque_history.status) and not len(payroll_id)>
										<cfquery name="get_bank_act" datasource="#dsn2#">
											SELECT ACTION_ID,ACTION_TYPE_ID FROM BANK_ACTIONS WHERE CHEQUE_ID = #url.id#
										</cfquery>
										<cfif get_bank_act.recordcount>
											<cfset act_id = get_bank_act.action_id>
											<cfset act_process = get_bank_act.action_type_id>
										<cfelse>
											<cfset act_id = url.id>
											<cfset act_process = 1046>
										</cfif>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#act_id#&process_cat=#act_process#','page');"><i class="icon-detail" alt="<cf_get_lang dictionary_id ='58452.Mahsup Fişi'>" title="<cf_get_lang dictionary_id ='58452.Mahsup Fişi'>"></i></a>
									<cfelseif len(get_cheque_history.payroll_id)>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#get_cheque_history.payroll_id#&process_cat=#get_cheque_payroll.payroll_type#','page');"><i class="icon-detail" alt="<cf_get_lang dictionary_id ='58452.Mahsup Fişi'>" title="<cf_get_lang dictionary_id ='58452.Mahsup Fişi'>"></i></a>
									</cfif> 
								</td>
							</tr>
						</cfoutput> 
					</tbody>
				</cf_grid_list>
				<cf_box_footer>
						<cfoutput>
							<div class="pull-right">
						<cfif get_cheque_detail.CHEQUE_STATUS_ID eq 6>
							<input type="button" class="ui-wrk-btn ui-wrk-btn-extra" name="bir" value="<cf_get_lang dictionary_id='50255.Ödendi'>" onclick="javascript:windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_masraf&cheque_id=#URL.ID#&sta=7','medium','popup_add_masraf')">
						<cfelseif get_cheque_detail.CHEQUE_STATUS_ID eq 2 or get_cheque_detail.CHEQUE_STATUS_ID eq 13>
							<input type="button" class="ui-wrk-btn ui-wrk-btn-extra" name="iki" value="<cf_get_lang dictionary_id='50251.Tahsil Edildi'>" onclick="javascript:windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_masraf&cheque_id=#URL.ID#&sta=3','project','popup_add_masraf')">
							<input type="button" class="ui-wrk-btn ui-wrk-btn-extra" name="uc" value="<cf_get_lang dictionary_id='50253.Karşılıksız'>" onclick="javascript:windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_masraf&cheque_id=#URL.ID#&sta=5&extra_status=2','medium','popup_add_masraf')">
						<cfelseif get_cheque_detail.CHEQUE_STATUS_ID eq 1>
							<input type="button" class="ui-wrk-btn ui-wrk-btn-extra" name="uc" value="<cf_get_lang dictionary_id='50253.Karşılıksız'>" onclick="javascript:windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_masraf&cheque_id=#URL.ID#&sta=5&extra_status=1','medium','popup_add_masraf')">
						</cfif>
					</div>
						</cfoutput>
					<cfif get_cheque_payroll.PAYROLL_NO eq -1 and get_cheque_history.recordcount eq 1>
						<cfsavecontent variable="message1"><cf_get_lang dictionary_id='51694.Çeki Silmek İstediğinizden Emin misiniz ?'></cfsavecontent>
						<cf_workcube_buttons is_upd='0' is_delete='1' is_cancel ='0' is_insert = '0' delete_page_url='#request.self#?fuseaction=cheque.list_cheques&event=del&cheque_id=#GET_CHEQUE_DETAIL.cheque_id#' delete_alert= '#message1#'>
					</cfif>
				</cf_box_footer>
			</cfform>
			</div>
		<div id = "unique_sayfa_2" class = "uniqueBox">
		<cfif isdefined("x_asset_notes")>
			<!--- Notlar --->
			<cf_get_workcube_note no_border="1" action_section='CHEQUE_ID' action_id='#attributes.id#' period_id='#session.ep.period_id#'>					
			<!--- Belgeler --->
		</div><div id = "unique_sayfa_3" class = "uniqueBox">
			<cf_get_workcube_asset no_border="1" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id='16' action_section='CHEQUE_ID' action_id='#attributes.id#'>
		</cfif>
	</div>
</cf_box>
</cfif>
<script type="text/javascript">
	function warn1()
	{
		if(confirm("<cf_get_lang dictionary_id='50305.Çekin durumu ödendi olarak değiştirilecek emin misiniz '>"))
			document.change_status.submit();
		else return false;
	}
	function warn2()
	{
		if(confirm("<cf_get_lang dictionary_id='50306.Çekin durumu karşılıksız olarak değiştirilecek emin misiniz '>"))
			document.change_status.submit();
		else return false;
	}
	function warn3()
	{
		if(confirm("<cf_get_lang dictionary_id='50258.Çekin durumu tahsil edildi olarak değiştirilecek emin misiniz'>"))
			document.change_status.submit();
		else return false;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
<cfinclude template="../query/get_money2.cfm">
<cfset from_session_=''>
<cfset cheque_system_value = 0>
<cfparam name="attributes.modal_id" default="">
<cfif isdefined("c_id") and isdefined("p_id") and len(c_id) and len(p_id)>
	<cfquery name="CHECK_HISTORY_INFO" datasource="#dsn2#">
		SELECT 
			C.*,
			CH.OTHER_MONEY2 AS HISTORY_OTHER_MONEY2,
			CH.OTHER_MONEY_VALUE2 AS HISTORY_OTHER_MONEY_VALUE2,
			CH.OTHER_MONEY_VALUE AS HISTORY_OTHER_MONEY_VALUE
		FROM 
			CHEQUE_HISTORY CH,
			CHEQUE C
		WHERE 
			C.CHEQUE_ID=CH.CHEQUE_ID
			AND CH.CHEQUE_ID=#c_id# 
			AND CH.PAYROLL_ID=#p_id#
	</cfquery>
	<cfset other_money_type = CHECK_HISTORY_INFO.HISTORY_OTHER_MONEY2>
	<cfset cheque_system_value = CHECK_HISTORY_INFO.HISTORY_OTHER_MONEY_VALUE>
	<cfset from_session_=0>
	<cfquery name="get_money_bskt" datasource="#dsn2#">
		SELECT MONEY_TYPE MONEY,RATE1,RATE2 FROM PAYROLL_MONEY WHERE ACTION_ID = #p_id#
	</cfquery>
	<cfif not get_money_bskt.recordcount><!--- setup_money den --->
		<cfquery name="get_money_bskt" datasource="#dsn2#">
			SELECT MONEY_TYPE MONEY,RATE1,RATE2 FROM CHEQUE_HISTORY_MONEY WHERE ACTION_ID = #c_id#
		</cfquery>
		<cfif not get_money_bskt.recordcount><!--- setup_money den --->
			<cfquery name="get_money_bskt" datasource="#dsn2#">
				SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY_ID
			</cfquery>
		</cfif>
	</cfif>
<cfelseif isdefined("url.cheque_id")>
	<cfquery name="CHECK_HISTORY_INFO" datasource="#dsn2#">
		SELECT 
			*
		FROM 
			CHEQUE
		WHERE 
			CHEQUE_ID=#attributes.cheque_id# 
	</cfquery>
	<cfset from_session_=1>		
	<cfquery name="get_money_bskt" datasource="#dsn2#">
		SELECT MONEY_TYPE MONEY,RATE1,RATE2 FROM PAYROLL_MONEY WHERE ACTION_ID = #CHECK_HISTORY_INFO.CHEQUE_PAYROLL_ID#
	</cfquery>
	<cfif not get_money_bskt.recordcount><!--- setup_money den --->
		<cfquery name="get_money_bskt" datasource="#dsn2#">
			SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY_ID
		</cfquery>
	</cfif>
</cfif>
<cf_box title="#getLang('','settings',58007)# #getLang('','settings',58660)#" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfoutput>
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">	
				<div class="form-group" >
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='25.Çek No'></label>
					<div class="col col-8 col-md-6 col-xs-12">#CHECK_HISTORY_INFO.CHEQUE_NO#</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='77.İşlem Para Br'></label>
					<div class="col col-8 col-md-6 col-xs-12">	#TLFormat(CHECK_HISTORY_INFO.CHEQUE_VALUE)#&nbsp;#CHECK_HISTORY_INFO.CURRENCY_ID#</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='68.Sistem Para Br'></label>
					<div class="col col-8 col-md-6 col-xs-12">#TLFormat(CHECK_HISTORY_INFO.OTHER_MONEY_VALUE)#&nbsp;#CHECK_HISTORY_INFO.OTHER_MONEY#</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='181.Sistem 2 Döviz Br'></label>
					<div class="col col-8 col-md-6 col-xs-12"> <cfif len(CHECK_HISTORY_INFO.OTHER_MONEY_VALUE2)>#TLFormat(CHECK_HISTORY_INFO.OTHER_MONEY_VALUE2)#&nbsp;#CHECK_HISTORY_INFO.OTHER_MONEY2#</cfif>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='228.Vade'></label>
					<div class="col col-8 col-md-6 col-xs-12"> #dateformat(CHECK_HISTORY_INFO.CHEQUE_DUEDATE,dateformat_style)#</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='769.Ödeme Yeri'></label>
					<div class="col col-8 col-md-6 col-xs-12">#CHECK_HISTORY_INFO.CHEQUE_CITY#</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='377.Özel Kod'></label>
					<div class="col col-8 col-md-6 col-xs-12">#CHECK_HISTORY_INFO.CHEQUE_CODE#</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='105.Cari Hesap Çeki'></label>
					<div class="col col-8 col-md-6 col-xs-12"><cfif CHECK_HISTORY_INFO.SELF_CHEQUE neq 1><cf_get_lang_main no='84.hayır'><cfelse><cf_get_lang_main no='83.evet'></cfif></div>
				</div>
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">	
				<div class="form-group">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='109.Banka'></label>
					<div class="col col-8 col-md-6 col-xs-12">			
						<cfif len(CHECK_HISTORY_INFO.BANK_NAME)>
						#CHECK_HISTORY_INFO.BANK_NAME#</td>
					<cfelseif len(CHECK_HISTORY_INFO.ACCOUNT_ID)>
						<cfquery name="get_bank_branch" datasource="#dsn3#">
							SELECT BB.BANK_NAME, BB.BANK_BRANCH_NAME FROM ACCOUNTS ACC,BANK_BRANCH BB WHERE ACC.ACCOUNT_BRANCH_ID = BB.BANK_BRANCH_ID AND ACC.ACCOUNT_ID = #CHECK_HISTORY_INFO.ACCOUNT_ID#
						</cfquery>
						#get_bank_branch.BANK_NAME#
					</cfif></div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='1529.Subesi'></label>
					<div class="col col-8 col-md-6 col-xs-12">
						<cfif len(CHECK_HISTORY_INFO.BANK_BRANCH_NAME)>
						#CHECK_HISTORY_INFO.BANK_BRANCH_NAME#</td>
					<cfelseif len(CHECK_HISTORY_INFO.ACCOUNT_ID)>
						<cfquery name="get_bank_branch" datasource="#dsn3#">
							SELECT BB.BANK_NAME, BB.BANK_BRANCH_NAME FROM ACCOUNTS ACC,BANK_BRANCH BB WHERE ACC.ACCOUNT_BRANCH_ID = BB.BANK_BRANCH_ID AND ACC.ACCOUNT_ID = #CHECK_HISTORY_INFO.ACCOUNT_ID#
						</cfquery>
						#get_bank_branch.BANK_BRANCH_NAME#
					</cfif>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='766.Hesap No'></label>
					<div class="col col-8 col-md-6 col-xs-12">#CHECK_HISTORY_INFO.ACCOUNT_NO#</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='768.Borçlu'></label>
					<div class="col col-8 col-md-6 col-xs-12">#CHECK_HISTORY_INFO.DEBTOR_NAME#</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='1350.Vergi Dairesi'></label>
					<div class="col col-8 col-md-6 col-xs-12">#CHECK_HISTORY_INFO.TAX_PLACE#</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='340.Vergi No'></label>
					<div class="col col-8 col-md-6 col-xs-12">#CHECK_HISTORY_INFO.TAX_NO#</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='770.Portföy No'></label>
					<div class="col col-8 col-md-6 col-xs-12">#CHECK_HISTORY_INFO.CHEQUE_PURSE_NO#</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='1558.Ciro Eden'></label>
					<div class="col col-8 col-md-6 col-xs-12"> #CHECK_HISTORY_INFO.ENDORSEMENT_MEMBER#</div>
				</div>
			</div>
		</cf_box_elements>
	</cfoutput>
	<div id="case" class="col col-12" <cfif ('#CHECK_HISTORY_INFO.CURRENCY_ID#' eq '#session.ep.money#')>style="display:none;"</cfif>>
		<cfoutput>
			<cfform name="cheque_history" action="#request.self#?fuseaction=cheque.emptypopup_upd_cheque_history" method="post"  >
				<cf_box_elements>
					<input type="hidden" name="cheque_id" id="cheque_id" value="<cfif isdefined("url.c_id")>#url.c_id#</cfif>">
					<input type="hidden" name="payroll_id" id="payroll_id" value="<cfif isdefined("url.p_id")>#url.p_id#</cfif>">
					<input type="hidden" name="row" id="row" value="<cfif isdefined("url.row")>#url.row#</cfif>">
					<div class="col col-12">
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">	
							<div class="form-group">
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='77.İşlem Para Br'></label>
								<div class="col col-6 col-md-6 col-xs-12">
									<input type="text" name="cheque_value" id="cheque_value" value="<cfif not from_session_>#tlformat(CHECK_HISTORY_INFO.CHEQUE_VALUE)#</cfif>" readonly="yes" style="width:100px;" class="moneybox" >
								</div>	
								<div class="col col-2 col-md-2 col-xs-12">
									<input type="text" name="cheque_currency" id="cheque_currency" value="<cfif not from_session_>#CHECK_HISTORY_INFO.CURRENCY_ID#</cfif>" class="boxtext" readonly="yes" style="width:100px;">
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='68. Sistem Para Br'></label>
								<div class="col col-6 col-md-6 col-xs-12">
									<input type="text" name="system_currency_value" id="system_currency_value" style="width:100px;" class="moneybox" onBlur="f_kur_hesapla_multi2();" onKeyup="return(FormatCurrency(this,event));" value="<cfif not from_session_><cfoutput>#tlformat(cheque_system_value)#</cfoutput></cfif>" required="yes" message="Sistem Tutarı!">
								</div>	
								<div class="col col-2 col-md-2 col-xs-12">
									<input type="text" name="cheque_currency" id="cheque_currency" value="<cfoutput>#session.ep.money#</cfoutput> " class="boxtext" readonly="yes" style="width:100px;">
								</div>
							</div>
						</div>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="4" sort="true">	
							<cfif  isdefined("attributes.kur_say") and  len(attributes.kur_say)>
								<input type="hidden" name="kur_say" id="kur_say" value="#attributes.kur_say#">
								<input type="hidden" name="rd_money" id="rd_money" value="<cfif not from_session_>#CHECK_HISTORY_INFO.CURRENCY_ID#</cfif>">
								<cfoutput>	
									<div class="form-group">
										<label class="col col-4 col-md-6 col-xs-12"></label>
										<div class="col col-8 col-md-6 col-xs-12 bold padding-left-5"><cf_get_lang_main no='265.Dövizler'></div>
									</div>
									<div class="form-group">
											<label class="col col-4 col-md-6 col-xs-12"></label>
										<div class="col col-8 col-md-6 col-xs-12">
											<cfif session.ep.rate_valid eq 1>
												<cfset readonly_info = "yes">
											<cfelse>
												<cfset readonly_info = "no">
											</cfif>
											<cfloop from="1" to="#attributes.kur_say#" index="i">
												<div class="form-group">	
													<div class="col col-3 col-md-3 col-xs-12">
														<input type="text" name="hidden_rd_money_#i#" id="hidden_rd_money_#i#" value="" class="boxtext" readonly="yes" style="width:70px;">
													</div>
													<div class="col col-2 col-md-2 col-xs-12 text-right">
														<input type="text" name="txt_rate1_#i#" id="txt_rate1_#i#" value="" class="boxtext" readonly="yes" style="width:20px;">
													</div>
													<div class="col col-1 col-md-1 col-xs-12">/
													</div>
													<div class="col col-6 col-md-6 col-xs-12">
														<input type="text" <cfif readonly_info>readonly</cfif> name="txt_rate2_#i#" id="txt_rate2_#i#" value="" style="width:70px;" class="box" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(1);f_kur_hesapla_multi();">
													</div>
												</div>
											</cfloop>
										</div>
									</div>
								</cfoutput>
							<cfelse>
								<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money_bskt.recordcount#</cfoutput>">
								<input type="hidden" name="rd_money" id="rd_money" value="<cfoutput>#CHECK_HISTORY_INFO.CURRENCY_ID#</cfoutput>">
								<cfif get_money_bskt.recordcount>
									<div class="form-group">
										<label class="col col-4 col-md-4 col-xs-12"></label>
										<div class="col col-8 col-md-8 col-xs-12 bold padding-left-5"><cf_get_lang_main no='265.Dövizler'></div>
									</div>
									<cfloop query="get_money_bskt">
										<div class="form-group">
											<label class="col col-4 col-md-4 col-xs-12"></label>
											<div class="col col-8 col-md-8 col-xs-8">
												<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
												<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
												<cfif session.ep.rate_valid eq 1>
													<cfset readonly_info = "yes">
												<cfelse>
													<cfset readonly_info = "no">
												</cfif>
												<label></label>
												<label class="col col-2 col-md-2 col-xs-12">#money#</label>
												<label class="col col-1 col-md-1 col-xs-12">
														#TLFormat(rate1,0)# </label><label class="col col-1 col-md-1 col-xs-12">/
													</label>
													<div class="col col-8 col-md-8 col-xs-12">
														<input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> value="#TLFormat(rate2,'#session.ep.our_company_info.rate_round_num#')#" style="width:60px;" class="box" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(1);f_kur_hesapla_multi();">
													</div>
											</div>
										</div>
									</cfloop>							
								</cfif>	
							</cfif>
						</div>
					</div>				
				</cf_box_elements>
			</cfform>
		</cfoutput>
		<cf_box_footer>
			<cf_workcube_buttons is_upd="1" is_delete="0" add_function="kontrol5()">
		</cf_box_footer>
	</div>
</cf_box>
<cfoutput>
	<script type="text/javascript">
        function kontrol5()
        { 
            document.cheque_history.system_currency_value.value=filterNum(document.cheque_history.system_currency_value.value); 
            for(var i=1;i<=cheque_history.kur_say.value;i++)
            {
                eval('cheque_history.txt_rate1_' + i).value = filterNum(eval('cheque_history.txt_rate1_' + i).value,'#session.ep.our_company_info.rate_round_num#');
                eval('cheque_history.txt_rate2_' + i).value = filterNum(eval('cheque_history.txt_rate2_' + i).value,'#session.ep.our_company_info.rate_round_num#');
            }
			<cfoutput>#iif(isdefined("attributes.draggable"),DE("loadPopupBox('cheque_history' , #attributes.modal_id#);"),DE(""))#</cfoutput>
            return false;
		}
        function f_kur_hesapla_multi(doviz_input)
        {
            for(var i=1;i<=cheque_history.kur_say.value;i++)
            {
                    rate1_eleman = filterNum(eval('document.cheque_history.txt_rate1_' + i).value,'#session.ep.our_company_info.rate_round_num#');
                    rate2_eleman = filterNum(eval('document.cheque_history.txt_rate2_' + i).value,'#session.ep.our_company_info.rate_round_num#');
                if( eval('cheque_history.hidden_rd_money_'+i).value == '#CHECK_HISTORY_INFO.CURRENCY_ID#')
                    {
                        temp_act = filterNum(cheque_history.cheque_value.value)*rate2_eleman/rate1_eleman;
                        cheque_history.system_currency_value.value = commaSplit(temp_act);
                        eval('document.cheque_history.txt_rate2_' + i).value= commaSplit(rate2_eleman,'#session.ep.our_company_info.rate_round_num#');
                    }	
            }
        }
        function f_kur_hesapla_multi2()
        {
            for(var i=1;i<=cheque_history.kur_say.value;i++)
            {
                if( eval('cheque_history.hidden_rd_money_'+i).value == '#CHECK_HISTORY_INFO.CURRENCY_ID#')
                    eval('cheque_history.txt_rate2_' + i).value = commaSplit(filterNum(cheque_history.system_currency_value.value)/filterNum(cheque_history.cheque_value.value),'#session.ep.our_company_info.rate_round_num#');
            }
            cheque_history.system_currency_value.value = commaSplit(filterNum(cheque_history.system_currency_value.value),'#session.ep.our_company_info.rate_round_num#');
        }
        <cfif isdefined("url.cheque_id")>
            document.cheque_history.cheque_value.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cheque_value'+#attributes.row#).value;
            document.cheque_history.cheque_currency.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.currency_id'+#attributes.row#).value;
            document.cheque_history.system_currency_value.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cheque_system_currency_value'+#attributes.row#).value;
            money_list = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.money_list'+#attributes.row#).value;
            document.cheque_history.kur_say.value = list_getat(money_list,1,'-');
            document.cheque_history.rd_money.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.currency_id'+#attributes.row#).value;
            for(fff=1;fff <=list_getat(money_list,1,'-');fff++)
            {
                money = list_getat(money_list,fff+1,'-');
                eval('cheque_history.hidden_rd_money_' + fff).value = list_getat(money,1,',');
                eval('cheque_history.txt_rate1_' + fff).value = commaSplit(list_getat(money,2,','),0);
                eval('cheque_history.txt_rate2_' + fff).value = commaSplit(list_getat(money,3,','),'#session.ep.our_company_info.rate_round_num#');
            }
        </cfif>
    </script>
</cfoutput>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->


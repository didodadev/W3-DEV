<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
<cfinclude template="../query/get_money2.cfm">
<cfset from_session=''>
<cfquery name="check_our_company" datasource="#dsn#">
	SELECT IS_REMAINING_AMOUNT FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfif isdefined("c_id") and isdefined("p_id")>
	<cfquery name="VOUCHER_HISTORY_INFO" datasource="#dsn2#">
		SELECT 
			<cfif check_our_company.is_remaining_amount eq 1 and isdefined("attributes.history_id")>
				V.OTHER_MONEY_VALUE2 -(ISNULL((SELECT ( ISNULL(SUM(VC.CLOSED_AMOUNT),0)) FROM VOUCHER_PAYROLL VP,VOUCHER_CLOSED VC,VOUCHER_HISTORY VHH WHERE VC.PAYROLL_ID = VP.ACTION_ID AND VP.ACTION_ID = VHH.PAYROLL_ID AND VC.ACTION_ID = VHH.VOUCHER_ID AND VC.ACTION_ID = V.VOUCHER_ID AND VHH.HISTORY_ID <= #attributes.history_id# AND ISNULL(VP.PAYROLL_AVG_DUEDATE,DATEADD(day,-1,VP.RECORD_DATE)) <= VH.ACT_DATE GROUP BY VC.ACTION_ID),0)/(V.OTHER_MONEY_VALUE/V.OTHER_MONEY_VALUE2)) OTHER_MONEY_VALUE2_,
				V.OTHER_MONEY_VALUE -ISNULL((SELECT ( ISNULL(SUM(VC.CLOSED_AMOUNT),0)) FROM VOUCHER_PAYROLL VP,VOUCHER_CLOSED VC,VOUCHER_HISTORY VHH WHERE VC.PAYROLL_ID = VP.ACTION_ID AND VP.ACTION_ID = VHH.PAYROLL_ID AND VC.ACTION_ID = VHH.VOUCHER_ID AND VC.ACTION_ID = V.VOUCHER_ID AND VHH.HISTORY_ID <= #attributes.history_id# AND ISNULL(VP.PAYROLL_AVG_DUEDATE,DATEADD(day,-1,VP.RECORD_DATE)) <= VH.ACT_DATE GROUP BY VC.ACTION_ID),0) OTHER_MONEY_VALUE_,
				V.VOUCHER_VALUE - ISNULL((SELECT (ISNULL(SUM(VC.OTHER_CLOSED_AMOUNT),0)) FROM VOUCHER_PAYROLL VP,VOUCHER_CLOSED VC,VOUCHER_HISTORY VHH WHERE VC.PAYROLL_ID = VP.ACTION_ID AND VP.ACTION_ID = VHH.PAYROLL_ID AND VC.ACTION_ID = VHH.VOUCHER_ID AND VC.ACTION_ID = V.VOUCHER_ID AND VHH.HISTORY_ID <= #attributes.history_id# AND ISNULL(VP.PAYROLL_AVG_DUEDATE,DATEADD(day,-1,VP.RECORD_DATE)) <= VH.ACT_DATE GROUP BY VC.ACTION_ID),0) VOUCHER_VALUE_,
			<cfelse>
				V.OTHER_MONEY_VALUE2 OTHER_MONEY_VALUE2_,
				V.OTHER_MONEY_VALUE OTHER_MONEY_VALUE_,
				V.VOUCHER_VALUE VOUCHER_VALUE_,
			</cfif>
			V.*,
			VH.OTHER_MONEY2 AS OTHER_MONEY2,
			VH.OTHER_MONEY_VALUE2 AS OTHER_MONEY_VALUE2,
			VH.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
			VH.OTHER_MONEY AS OTHER_MONEY,
			VH.STATUS
		FROM 
			VOUCHER_HISTORY VH,
			VOUCHER V
		WHERE 
			V.VOUCHER_ID=VH.VOUCHER_ID
			AND VH.VOUCHER_ID=#c_id# 
			AND VH.PAYROLL_ID=#p_id#
	</cfquery>
	<cfset other_money_type = VOUCHER_HISTORY_INFO.OTHER_MONEY2>
	<cfset voucher_system_value = VOUCHER_HISTORY_INFO.OTHER_MONEY_VALUE>
	<cfset from_session=0>
	<cfquery name="get_money_bskt" datasource="#dsn2#">
		SELECT MONEY_TYPE MONEY,RATE1,RATE2 FROM VOUCHER_PAYROLL_MONEY WHERE ACTION_ID = #p_id#
	</cfquery>
	<cfif not get_money_bskt.recordcount>
		<cfquery name="get_money_bskt" datasource="#dsn2#"><!--- VOUCHER_HISTORY_MONEY tablosunda kayıt varsa --->
			SELECT MONEY_TYPE MONEY,RATE1,RATE2 FROM VOUCHER_HISTORY_MONEY WHERE ACTION_ID = #p_id#
		</cfquery>
		<cfif not get_money_bskt.recordcount><!--- setup_money den --->
			<cfquery name="get_money_bskt" datasource="#dsn2#">
				SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY_ID
			</cfquery>
		</cfif>
	</cfif>
<cfelseif isdefined("url.voucher_id")>
	<cfquery name="VOUCHER_HISTORY_INFO" datasource="#dsn2#">
		SELECT 
			<cfif check_our_company.is_remaining_amount eq 1 and isdefined("attributes.history_id")>
				V.OTHER_MONEY_VALUE2 -(ISNULL((SELECT ( ISNULL(SUM(VC.CLOSED_AMOUNT),0)) FROM VOUCHER_PAYROLL VP,VOUCHER_CLOSED VC,VOUCHER_HISTORY VHH WHERE VC.PAYROLL_ID = VP.ACTION_ID AND VP.ACTION_ID = VHH.PAYROLL_ID AND VC.ACTION_ID = VHH.VOUCHER_ID AND VC.ACTION_ID = V.VOUCHER_ID AND VHH.HISTORY_ID <= #attributes.history_id# AND ISNULL(VP.PAYROLL_AVG_DUEDATE,DATEADD(day,-1,VP.RECORD_DATE)) <= VH.ACT_DATE GROUP BY VC.ACTION_ID),0)/(V.OTHER_MONEY_VALUE/V.OTHER_MONEY_VALUE2)) OTHER_MONEY_VALUE2_,
				V.OTHER_MONEY_VALUE -ISNULL((SELECT ( ISNULL(SUM(VC.CLOSED_AMOUNT),0)) FROM VOUCHER_PAYROLL VP,VOUCHER_CLOSED VC,VOUCHER_HISTORY VHH WHERE VC.PAYROLL_ID = VP.ACTION_ID AND VP.ACTION_ID = VHH.PAYROLL_ID AND VC.ACTION_ID = VHH.VOUCHER_ID AND VC.ACTION_ID = V.VOUCHER_ID AND VHH.HISTORY_ID <= #attributes.history_id# AND ISNULL(VP.PAYROLL_AVG_DUEDATE,DATEADD(day,-1,VP.RECORD_DATE)) <= VH.ACT_DATE GROUP BY VC.ACTION_ID),0) OTHER_MONEY_VALUE_,
				V.VOUCHER_VALUE - ISNULL((SELECT (ISNULL(SUM(VC.OTHER_CLOSED_AMOUNT),0)) FROM VOUCHER_PAYROLL VP,VOUCHER_CLOSED VC,VOUCHER_HISTORY VHH WHERE VC.PAYROLL_ID = VP.ACTION_ID AND VP.ACTION_ID = VHH.PAYROLL_ID AND VC.ACTION_ID = VHH.VOUCHER_ID AND VC.ACTION_ID = V.VOUCHER_ID AND VHH.HISTORY_ID <= #attributes.history_id# AND ISNULL(VP.PAYROLL_AVG_DUEDATE,DATEADD(day,-1,VP.RECORD_DATE)) <= VH.ACT_DATE GROUP BY VC.ACTION_ID),0) VOUCHER_VALUE_,
			<cfelse>
				V.OTHER_MONEY_VALUE2 OTHER_MONEY_VALUE2_,
				V.OTHER_MONEY_VALUE OTHER_MONEY_VALUE_,
				V.VOUCHER_VALUE VOUCHER_VALUE_,
			</cfif>
			V.*
		FROM 
			VOUCHER V
		WHERE 
			V.VOUCHER_ID=#attributes.voucher_id# 
	</cfquery>
	<cfset from_session=1>
	<cfquery name="get_money_bskt" datasource="#dsn2#">
		SELECT MONEY_TYPE MONEY,RATE1,RATE2 FROM VOUCHER_PAYROLL_MONEY WHERE ACTION_ID = #VOUCHER_HISTORY_INFO.VOUCHER_PAYROLL_ID#
	</cfquery>
	<cfif not get_money_bskt.recordcount>
		<cfquery name="get_money_bskt" datasource="#dsn2#">
			SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY_ID
		</cfquery>
	</cfif>
</cfif>
<cf_box title="#getLang('','settings',58008)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfoutput>
	<div class="col col-6 col-md-6 col-sm-6 col-xs-6" type="column" index="1" sort="true">
		<div class="form-group">
			<label class="col col-4 col-md-4 col-xs-4"><cf_get_lang_main no='1090.Senet No'></label>
			<div class="col col-8 col-md-8 col-xs-8">#VOUCHER_HISTORY_INFO.VOUCHER_NO#
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-4 col-xs-4"><cf_get_lang_main no='228.Vade'></label>
			<div class="col col-8 col-md-8 col-xs-8">#dateformat(VOUCHER_HISTORY_INFO.VOUCHER_DUEDATE,dateformat_style)#
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-4 col-xs-4"><cf_get_lang_main no='770.Portföy No'></label>
			<div class="col col-8 col-md-8 col-xs-8">#VOUCHER_HISTORY_INFO.VOUCHER_PURSE_NO#
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-4 col-xs-4"><cf_get_lang_main no='769.Ödeme Yeri'></label>
			<div class="col col-8 col-md-8 col-xs-8">#VOUCHER_HISTORY_INFO.VOUCHER_CITY#
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-4 col-xs-4"><cf_get_lang_main no='768.Borçlu'></label>
			<div class="col col-8 col-md-8 col-xs-8">#VOUCHER_HISTORY_INFO.DEBTOR_NAME#
			</div>
		</div></div>
	<div class="col col-6 col-md-6 col-sm-6 col-xs-6" type="column" index="2" sort="true">
		<div class="form-group">
			<label class="col col-4 col-md-4 col-xs-4"><cf_get_lang_main no='377.Özel Kod'></label>
			<div class="col col-8 col-md-8 col-xs-8">#VOUCHER_HISTORY_INFO.VOUCHER_CODE#
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-4 col-xs-4"><cf_get_lang no='77.İşlem Para Br'></label>
			<div class="col col-8 col-md-8 col-xs-8">
				<cfif isdefined("VOUCHER_HISTORY_INFO.STATUS") and VOUCHER_HISTORY_INFO.STATUS neq 3>
					#TLFormat(VOUCHER_HISTORY_INFO.VOUCHER_VALUE_)#&nbsp;#VOUCHER_HISTORY_INFO.CURRENCY_ID#
				<cfelse>
					#TLFormat(VOUCHER_HISTORY_INFO.VOUCHER_VALUE)#&nbsp;#VOUCHER_HISTORY_INFO.CURRENCY_ID#
				</cfif>
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-4 col-xs-4"><cf_get_lang no ='181.Sistem 2 Döviz Br'></label>
			<div class="col col-8 col-md-8 col-xs-8">
				<cfif isdefined("VOUCHER_HISTORY_INFO.STATUS") and VOUCHER_HISTORY_INFO.STATUS neq 3>
					<cfif len(VOUCHER_HISTORY_INFO.OTHER_MONEY2)>#TLFormat(VOUCHER_HISTORY_INFO.OTHER_MONEY_VALUE2_)#&nbsp;#VOUCHER_HISTORY_INFO.OTHER_MONEY2#</cfif>
				<cfelse>
					<cfif len(VOUCHER_HISTORY_INFO.OTHER_MONEY2)>#TLFormat(VOUCHER_HISTORY_INFO.OTHER_MONEY_VALUE2)#&nbsp;#VOUCHER_HISTORY_INFO.OTHER_MONEY2#</cfif>
				</cfif>
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-4 col-xs-4"><cf_get_lang no='68. Sistem Para Br'></label>
			<div class="col col-8 col-md-8 col-xs-8">
				<cfif isdefined("VOUCHER_HISTORY_INFO.STATUS") and VOUCHER_HISTORY_INFO.STATUS neq 3>
					#TLFormat(VOUCHER_HISTORY_INFO.OTHER_MONEY_VALUE_)# #VOUCHER_HISTORY_INFO.OTHER_MONEY#
				<cfelse>
					#TLFormat(VOUCHER_HISTORY_INFO.OTHER_MONEY_VALUE)# #VOUCHER_HISTORY_INFO.OTHER_MONEY#
				</cfif>
			</div>
		</div>
	</div>
		</cfoutput>

</cf_box>
<cfoutput>
	<script type="text/javascript">
		function kontrol()
		{ 
			document.voucher_history.system_currency_value.value=filterNum(document.voucher_history.system_currency_value.value); 
			for(var i=1;i<=voucher_history.kur_say.value;i++)
			{
				eval('voucher_history.txt_rate1_' + i).value = filterNum(eval('voucher_history.txt_rate1_' + i).value,'#session.ep.our_company_info.rate_round_num#');
				eval('voucher_history.txt_rate2_' + i).value = filterNum(eval('voucher_history.txt_rate2_' + i).value,'#session.ep.our_company_info.rate_round_num#');
			}
		}
		function f_kur_hesapla_multi(doviz_input)
		{
			for(var i=1;i<=#get_money_bskt.recordcount#;i++)
			{
					rate1_eleman = filterNum(eval('document.voucher_history.txt_rate1_' + i).value,'#session.ep.our_company_info.rate_round_num#');
					rate2_eleman = filterNum(eval('document.voucher_history.txt_rate2_' + i).value,'#session.ep.our_company_info.rate_round_num#');
				if( eval('voucher_history.hidden_rd_money_'+i).value == '#VOUCHER_HISTORY_INFO.CURRENCY_ID#')
					{
						temp_act = filterNum(voucher_history.voucher_value.value)*rate2_eleman/rate1_eleman;
						voucher_history.system_currency_value.value = commaSplit(temp_act);
						eval('document.voucher_history.txt_rate2_' + i).value= commaSplit(rate2_eleman,'#session.ep.our_company_info.rate_round_num#');
					}	
			}
		}
		function f_kur_hesapla_multi2()
		{
			for(var i=1;i<=#get_money_bskt.recordcount#;i++)
			{
				if( eval('voucher_history.hidden_rd_money_'+i).value == '#VOUCHER_HISTORY_INFO.CURRENCY_ID#')
					{
						eval('voucher_history.txt_rate2_' + i).value = commaSplit(filterNum(voucher_history.system_currency_value.value)/filterNum(voucher_history.voucher_value.value),'#session.ep.our_company_info.rate_round_num#');
					}
			}
			voucher_history.system_currency_value.value = commaSplit(filterNum(voucher_history.system_currency_value.value),2);
		}
	</script>
</cfoutput>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

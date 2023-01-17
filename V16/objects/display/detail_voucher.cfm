<cfif isdefined("session.pp.userid")>
	<cfset url.id = Decrypt(url.id,session.pp.userid,"CFMX_COMPAT","Hex")>
	<cfset attributes.id = Decrypt(attributes.id,session.pp.userid,"CFMX_COMPAT","Hex")>
</cfif>
<cf_get_lang_set module_name="objects">
<cfif isdefined("attributes.period_id") and len(attributes.period_id) >
	<cfquery name="get_period" datasource="#DSN#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
	</cfquery>
	<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>
<cfquery name="GET_VOUCHER" datasource="#db_adres#">
	SELECT
	  DISTINCT	
		V.VOUCHER_STATUS_ID,
        V.VOUCHER_PAYROLL_ID,
		V.VOUCHER_PURSE_NO ,
		V.DEBTOR_NAME,
		V.VOUCHER_CITY,
		V.VOUCHER_DUEDATE,
		V.VOUCHER_VALUE,
		V.VOUCHER_NO,
		V.VOUCHER_CODE,
		V.ACCOUNT_NO,
		V.CURRENCY_ID,
		V.ACCOUNT_CODE,
		V.SELF_VOUCHER,
		V.OTHER_MONEY_VALUE,
		V.OTHER_MONEY,
		V.COMPANY_ID,
		V.CONSUMER_ID,
		(SELECT VP.RECORD_EMP FROM VOUCHER_PAYROLL VP WHERE VP.ACTION_ID = V.VOUCHER_PAYROLL_ID) RECORD_EMP,
		(SELECT VP.RECORD_DATE FROM VOUCHER_PAYROLL VP WHERE VP.ACTION_ID = V.VOUCHER_PAYROLL_ID) RECORD_DATE,
		(SELECT VP.UPDATE_EMP FROM VOUCHER_PAYROLL VP WHERE VP.ACTION_ID = V.VOUCHER_PAYROLL_ID) UPDATE_EMP,
		(SELECT VP.UPDATE_DATE FROM VOUCHER_PAYROLL VP WHERE VP.ACTION_ID = V.VOUCHER_PAYROLL_ID) UPDATE_DATE
	FROM
		VOUCHER AS V
	WHERE
		V.VOUCHER_ID = #attributes.id#
</cfquery>
<cfquery name="GET_CARD" datasource="#dsn2#">
	SELECT
		ACS.CARD_ID,
        ACS.ACTION_TYPE
	FROM
		ACCOUNT_CARD ACS
	WHERE
    	ACS.ACTION_TYPE = (SELECT PAYROLL_TYPE FROM VOUCHER_PAYROLL WHERE ACTION_ID = #GET_VOUCHER.VOUCHER_PAYROLL_ID#)
		AND ACS.ACTION_ID = #GET_VOUCHER.VOUCHER_PAYROLL_ID#
</cfquery>
<cfsavecontent variable="right">
<cfif GET_CARD.recordcount  and isdefined("session.ep.user_level") and listgetat(session.ep.user_level,22)>
	<li><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=#GET_VOUCHER.VOUCHER_PAYROLL_ID#&process_cat=#GET_CARD.ACTION_TYPE#</cfoutput>','page');" class="font-red-pink"><i class="fa fa-bar-chart" title="<cf_get_lang dictionary_id ='59032.Muhasebe Hareketleri'>"></i></a></li>
</cfif>
</cfsavecontent>

<cfoutput query="GET_VOUCHER">
	<cf_box title="#getLang('','Senet Detay',33783)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" right_images="#right#">
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group require" id="item-voucher_purse_no">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id ='33784.Pörtföy'><cf_get_lang dictionary_id='57487.No'> :</label>
					<div class="col col-6 col-sm-12">
						#voucher_purse_no#
					</div>                
				</div> 
				<div class="form-group require" id="item-voucher_no">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='58502.Senet No'> :</label>
					<div class="col col-6 col-sm-12">
						#voucher_no#
					</div>                
				</div> 
				<div class="form-group require" id="item-voucher_duedate">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id ='33785.Vadesi'> :</label>
					<div class="col col-6 col-sm-12">
						#dateformat(voucher_duedate,dateformat_style)#
					</div>                
				</div> 
				<div class="form-group require" id="item-voucher_status_id">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id ='57482.Aşama'> :</label>
					<div class="col col-6 col-sm-12">
						<cfif voucher_status_id eq 1>
							<cf_get_lang dictionary_id ='32810.Portfoyde'>
						<cfelseif voucher_status_id eq 2>
							<cf_get_lang dictionary_id ='33788.Bankada'>
						<cfelseif voucher_status_id eq 3>
							<cf_get_lang dictionary_id ='49774.Tahsil Edildi'>
						<cfelseif voucher_status_id eq 4>
							<cf_get_lang dictionary_id ='33790.Ciro Edildi'>
						<cfelseif voucher_status_id eq 5>
							<cf_get_lang dictionary_id ='50077.Protestolu'>
						<cfelseif voucher_status_id eq 6>
							<cf_get_lang dictionary_id ='33792.Ödenmedi'>
						<cfelseif voucher_status_id eq 7>
							<cf_get_lang dictionary_id ='33793.Ödendi'>
						<cfelseif voucher_status_id eq 8>
							<cf_get_lang dictionary_id ='58506.İptal'>
						<cfelseif voucher_status_id eq 9>
							<cf_get_lang dictionary_id ='29418.İade'>
						</cfif>
					</div>                
				</div> 
				<div class="form-group require" id="item-currency_id">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id ='33795.İşlem Para Birimi'> :</label>
					<div class="col col-6 col-sm-12">
						#TLFormat(voucher_value)# #currency_id#
					</div>                
				</div>
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group require" id="item-other_money">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id ='33046.Sistem Para Birimi'> :</label>
					<div class="col col-6 col-sm-12">
						#TLFormat(other_money_value)# #other_money#
					</div>                
				</div>
				<div class="form-group require" id="item-company_id">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='57519.Cari Hesap'> :</label>
					<div class="col col-6 col-sm-12">
						<cfif len(company_id)>#get_par_info(company_id,1,1,0)#<cfelseif len(consumer_id)>#get_cons_info(consumer_id,0,0)# </cfif>
					</div>                
				</div>
				<div class="form-group require" id="item-debtor_name">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='58180.Borçlu'> :</label>
					<div class="col col-6 col-sm-12">
						#debtor_name#
					</div>                
				</div>
				<div class="form-group require" id="item-voucher_city">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='58181.Ödeme Yeri'> :</label>
					<div class="col col-6 col-sm-12">
						#voucher_city#
					</div>                
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info query_name="get_voucher">
		</cf_box_footer>
	</cf_box>
</cfoutput>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

<cfif isdefined("attributes.period_id") and len(attributes.period_id) >
	<cfquery name="get_period" datasource="#DSN#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
	</cfquery>
	<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>
<cfquery name="GET_CHEQUE" datasource="#db_adres#">
	SELECT * FROM CHEQUE WHERE CHEQUE_ID = #attributes.id#
</cfquery>
<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
	SELECT
		ACCOUNTS.*,
		BANK_BRANCH.BANK_NAME,
		BANK_BRANCH.BANK_BRANCH_NAME
	FROM
		ACCOUNTS,	
		BANK_BRANCH,
		#dsn2_alias#.SETUP_MONEY AS SM
	WHERE
		<cfif len(GET_CHEQUE.ACCOUNT_ID)>
			ACCOUNTS.ACCOUNT_ID=#GET_CHEQUE.ACCOUNT_ID# AND
		</cfif>
		ACCOUNTS.ACCOUNT_CURRENCY_ID = SM.MONEY AND
		ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID
	ORDER BY
		ACCOUNTS.ACCOUNT_NAME
</cfquery>
<cfquery name="GET_CARD" datasource="#dsn2#">
	SELECT
		ACS.CARD_ID,
        ACTION_TYPE,
        ACTION_ID
	FROM
		ACCOUNT_CARD ACS
	WHERE
    	ACS.ACTION_TYPE = (SELECT PAYROLL_TYPE FROM PAYROLL WHERE ACTION_ID = #GET_CHEQUE.CHEQUE_PAYROLL_ID#)
		AND ACS.ACTION_ID = #GET_CHEQUE.CHEQUE_PAYROLL_ID#
</cfquery>
<cfsavecontent variable="right">
	<cfif GET_CARD.recordcount  and isdefined("session.ep.user_level") and listgetat(session.ep.user_level,22)>
        <li><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=#GET_CARD.ACTION_ID#&process_cat=#GET_CARD.ACTION_TYPE#</cfoutput>');" class="font-red-pink"><i class="fa fa-bar-chart" title="<cf_get_lang dictionary_id='59032.Muhasebe Hareketleri'>"></i></a></li>
    </cfif>
</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32735.Çek Detay'></cfsavecontent>
<cf_box title="#getLang('','Çek Detay',32735)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" right_images="#right#">
	<cf_box_elements>
		<cfoutput query="GET_CHEQUE">
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group require" id="item-CHEQUE_PURSE_NO">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='33784.Pörtföy'><cf_get_lang dictionary_id='57487.No'> :</label>
					<div class="col col-6 col-sm-12">
						#CHEQUE_PURSE_NO#
					</div>                
				</div> 
				<div class="form-group require" id="item-ACCOUNT_ID">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='32739.Müşteri Hesap No'> :</label>
					<div class="col col-6 col-sm-12">
						<cfif len(GET_CHEQUE.ACCOUNT_ID)>#GET_ACCOUNTS.ACCOUNT_NAME#</cfif>
					</div>                
				</div> 
				<div class="form-group require" id="item-CHEQUE_NO">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='32745.Çek No'> :</label>
					<div class="col col-6 col-sm-12">
						#CHEQUE_NO#
					</div>                
				</div>
				<div class="form-group require" id="item-CHEQUE_STATUS_ID">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='57482.Aşama'> :</label>
					<div class="col col-6 col-sm-12">
						<cfswitch expression="#GET_CHEQUE.CHEQUE_STATUS_ID#">
							<cfcase value="1"><cf_get_lang dictionary_id='32810.Portföyde'></cfcase>
							<cfcase value="2"><cf_get_lang dictionary_id='33788.Bankada'></cfcase>
							<cfcase value="13"><cf_get_lang dictionary_id='32812.Teminatta'></cfcase>
							<cfcase value="3"><cf_get_lang dictionary_id='39650.Tahsil Edildi'></cfcase>
							<cfcase value="4"><cf_get_lang dictionary_id='33790.Ciro Edildi'></cfcase>
							<cfcase value="5"><cf_get_lang dictionary_id='32861.Karşılıksız'></cfcase>
							<cfcase value="6"><cf_get_lang dictionary_id='33792.Ödenmedi'></cfcase>
							<cfcase value="7"><cf_get_lang dictionary_id='33793.Ödendi'></cfcase>
							<cfcase value="8"><cf_get_lang dictionary_id='58506.İptal'></cfcase>
							<cfcase value="9"><cf_get_lang dictionary_id='29418.İade'></cfcase>
							<cfcase value="10"><cf_get_lang dictionary_id='32861.Karşılıksız'>-<cf_get_lang dictionary_id='32810.Portföyde'></cfcase>
							<cfcase value="12"><cf_get_lang dictionary_id='32741.Icra'></cfcase>
							<cfcase value="14"><cf_get_lang dictionary_id='58568.Transfer'></cfcase>
						</cfswitch>
					</div>                
				</div>
				<div class="form-group require" id="item-company_id">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='57519.Cari Hesap'> :</label>
					<div class="col col-6 col-sm-12">
						<cfif len(company_id)>#get_par_info(company_id,1,1,0)#<cfelseif len(consumer_id)>#get_cons_info(consumer_id,0,0)# </cfif>
					</div>                
				</div>
				<div class="form-group require" id="item-cheque_duedate">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='57640.Vade'> :</label>
					<div class="col col-6 col-sm-12">
						#dateformat(cheque_duedate,dateformat_style)#
					</div>                
				</div>
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group require" id="item-cheque_value">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='57673.Tutar'> :</label>
					<div class="col col-6 col-sm-12">
						#TLFormat(cheque_value)# #CURRENCY_ID#
					</div>                
				</div>
				<div class="form-group require" id="item-other_money_value">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='32742.Sistem Tutarı'> :</label>
					<div class="col col-6 col-sm-12">
						#TLFormat(other_money_value)# #session.ep.money#
					</div>                
				</div>
				<div class="form-group require" id="item-other_money_value2">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='32743.Sistem İkinci Dövizi'> :</label>
					<div class="col col-6 col-sm-12">
						#tlformat(other_money_value2)# #other_money2#
					</div>                
				</div>
				<div class="form-group require" id="item-cheque_city">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='58181.Ödeme Yeri'> :</label>
					<div class="col col-6 col-sm-12">
						#cheque_city#
					</div>                
				</div>
				<div class="form-group require" id="item-cheque_code">
					<label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='57789.Özel Kod'> :</label>
					<div class="col col-6 col-sm-12">
						#cheque_code#
					</div>                
				</div>
			</div>
		</cfoutput>
	</cf_box_elements>
	<cf_box_footer>
		<cf_record_info query_name="GET_CHEQUE">
	</cf_box_footer>
</cf_box>

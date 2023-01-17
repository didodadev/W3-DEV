<!---E.A 19072012 SELECT IFADELERI DUZENLENDI.--->
<cfquery name="GET_EXPENSE" datasource="#DSN3#">
	SELECT
		ACTION_DATE,
        PROCESS_TYPE,
		ACCOUNT_ID,
		ACTION_TO_COMPANY_ID,
		CONS_ID,
		TOTAL_COST_VALUE,
		ACTION_CURRENCY_ID,
		OTHER_COST_VALUE,
		OTHER_MONEY,
		DETAIL,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE	
	FROM 
		CREDIT_CARD_BANK_EXPENSE 
	WHERE 
		CREDITCARD_EXPENSE_ID = #attributes.id#
</cfquery>
<cfquery name="GET_CARD" datasource="#dsn2#">
	SELECT
		ACS.CARD_ID
	FROM
		ACCOUNT_CARD ACS
	WHERE
		ACS.ACTION_TYPE = #GET_EXPENSE.PROCESS_TYPE#
		AND ACS.ACTION_ID = #attributes.id#
</cfquery>
<cfsavecontent variable="right">
<cfif GET_CARD.recordcount and isdefined("session.ep.user_level") and listgetat(session.ep.user_level,22)>
    <li><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#GET_EXPENSE.PROCESS_TYPE#</cfoutput>');"><i class="icon-fa fa-table" title="<cf_get_lang dictionary_id='59032.Muhasebe Hareketleri'>"></i></a></li>
</cfif>
</cfsavecontent>
<cf_box title="#getLang('main',425)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" right_images="#right#">
	<cf_box_elements>
		<cfoutput>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
						<label><cf_get_lang_main no='330.Tarih'>:</label>
					</div>
					<div class="col col-8 col-md-6 col-sm-6 col-xs-12">
						<label>: #dateformat(get_expense.action_date,dateformat_style)#</label>
					</div>
				</div>
				<div class="form-group">
					<cfset account_id=get_expense.ACCOUNT_ID>
					<cfinclude template="../query/get_action_account.cfm">
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
						<label><cf_get_lang_main no='240.Hesap'>:</label>
					</div>
					<div class="col col-8 col-md-6 col-sm-6 col-xs-12">
						<label>: #get_action_account.account_name#</label>
					</div>
				</div>
				<div class="form-group">
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
						<label><cf_get_lang_main no='107.cari Hesap'>:</label>
					</div>
					<div class="col col-8 col-md-6 col-sm-6 col-xs-12">
						<label>: 
							<cfif len(get_expense.ACTION_TO_COMPANY_ID)>
								#get_par_info(get_expense.ACTION_TO_COMPANY_ID,1,0,0)#
							<cfelse>
								#get_cons_info(get_expense.cons_id,0,0)#
							</cfif>
						</label>
					</div>
				</div>
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group">
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
						<label><cf_get_lang_main no='261.Tutar'>:</label>
					</div>
					<div class="col col-8 col-md-6 col-sm-6 col-xs-12">
						<label>: #TLFormat(get_expense.total_cost_value)# #get_expense.action_currency_id#
						</label>
					</div>
				</div>
				<div class="form-group">
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
						<label><cf_get_lang_main no='644.Dövizli Tutar'></label>
					</div>
					<div class="col col-8 col-md-6 col-sm-6 col-xs-12">
						<label>: #TLFormat(get_expense.other_cost_value)# #get_expense.other_money#
						</label>
					</div>
				</div>
				<div class="form-group">
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
						<label><cf_get_lang_main no='217.Açıklama'></label>
					</div>
					<div class="col col-8 col-md-6 col-sm-6 col-xs-12">
						<label>: #get_expense.detail#</label>
					</div>
				</div>
			</div>
		</cfoutput>
	</cf_box_elements>
	<cf_box_footer>
		<cf_record_info query_name="get_expense">
	</cf_box_footer>
</cf_box>

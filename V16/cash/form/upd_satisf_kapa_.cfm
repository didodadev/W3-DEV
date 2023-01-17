<cf_get_lang_set module_name="cash">
	<cfset attributes.TABLE_NAME = "CASH_ACTIONS">
	<cfinclude template="../query/get_action_detail.cfm">
	<cfquery name="GET_CARD" datasource="#dsn2#">
		SELECT
			ACS.CARD_ID
		FROM
			ACCOUNT_CARD ACS
		WHERE
			ACS.ACTION_TYPE = #get_action_detail.action_type_id#
			AND ACS.ACTION_ID = #attributes.id#
	</cfquery>
	<cfsavecontent variable="right">
		<cfif GET_CARD.recordcount  and isdefined("session.ep.user_level") and listgetat(session.ep.user_level,22)>
			<li><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_action_detail.ACTION_TYPE_ID#</cfoutput>');"><i class="icon-fa fa-table" title="<cf_get_lang dictionary_id='59032.Muhasebe Hareketleri'>"></i></a></li>
		</cfif>
	</cfsavecontent>
	<div class="col col-12 col-xs-12">
		<cf_box title="#getLang('main',434)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" right_images="#right#"><!--- Satis Faturasi Kapama --->
			<cfoutput>
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-xs-12">
						<div class="form-group">
							<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57742.Tarih'></b></label>
							<label class="col col-8 col-xs-12">: #dateformat(get_action_detail.ACTION_DATE,dateformat_style)#</label>
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='49795.Kasaya'></b></label>
							<label class="col col-8 col-xs-12"><cfset cash_id=get_action_detail.CASH_ACTION_TO_CASH_ID>
								<cfif len(get_action_detail.CASH_ACTION_TO_CASH_ID)>
									<cfinclude template="../query/get_action_cash.cfm">
									: #get_action_cash.CASH_NAME# <cf_get_lang dictionary_id='49741.kasasına'>
								</cfif>
							</label>
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='257441.Fatura'></b></label>
							<label class="col col-8 col-xs-12"><cfif len(get_action_detail.BILL_ID)>
									<cfset bill_id=get_action_detail.BILL_ID>
									<cfinclude template="../query/get_action_bill.cfm">
									: #get_action_bill.INVOICE_NUMBER# <cf_get_lang dictionary_id='49850.no lu fatura'>
								</cfif>
							</label>
						</div>
					</div>
					<div class="col col-6 col-md-6 col-xs-12">
						<div class="form-group">
							<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57673.Tutar'></b></label>
							<label class="col col-8 col-xs-12">: #TLFormat(get_action_detail.CASH_ACTION_VALUE)#&nbsp;#get_action_detail.cash_action_currency_id#</label>
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='58056.Dövizli Tutar'></b></label>
							<label class="col col-8 col-xs-12">: #TLFormat(get_action_detail.other_cash_act_value)#&nbsp;#get_action_detail.other_money#</label>
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57629.Açıklama'></b></label>
							<label class="col col-8 col-xs-12">: #get_action_detail.ACTION_DETAIL# </label>
						</div>
					</div>
				</cf_box_elements>
			</cfoutput>
			<cf_box_footer>
				<cfif len(get_action_detail.RECORD_EMP)><cf_record_info query_name="get_action_detail"></cfif>
			</cf_box_footer>
		</cf_box>
	</div>
	<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
	
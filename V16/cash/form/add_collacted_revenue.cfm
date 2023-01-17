<cfif isdefined("attributes.multi_id") and len(attributes.multi_id)><!--- kopyalama --->
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT MONEY_TYPE AS MONEY,* FROM CASH_ACTION_MULTI_MONEY WHERE ACTION_ID = #attributes.multi_id# ORDER BY ACTION_MONEY_ID
	</cfquery>
	<cfif not get_money.recordcount>
		<cfquery name="get_money" datasource="#dsn2#">
			SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE MONEY_STATUS=1 ORDER BY MONEY_ID
		</cfquery>
	</cfif>
	<cfquery name="get_action_detail" datasource="#dsn2#">
		SELECT
			CM.*,
			CA.CASH_ACTION_FROM_COMPANY_ID AS ACTION_COMPANY_ID,
			CA.CASH_ACTION_FROM_CONSUMER_ID AS ACTION_CONSUMER_ID,
			CA.CASH_ACTION_FROM_EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
			CA.OTHER_CASH_ACT_VALUE AS ACTION_VALUE_OTHER,
			CA.PROJECT_ID,
			CA.PAPER_NO,
			CA.CASH_ACTION_VALUE AS ACTION_VALUE,
			CA.ACTION_DETAIL,
			CA.ACTION_ID,
			CA.OTHER_MONEY AS ACTION_CURRENCY,
			CA.REVENUE_COLLECTOR_ID AS EMPLOYEE_ID,
			CM.UPD_STATUS,
			CA.ASSETP_ID,
			CA.SPECIAL_DEFINITION_ID,
            CA.ACC_TYPE_ID,
			CA.SUBSCRIPTION_ID
		FROM
			CASH_ACTIONS_MULTI CM,
			CASH_ACTIONS CA
		WHERE
			CM.MULTI_ACTION_ID = CA.MULTI_ACTION_ID AND
			CM.MULTI_ACTION_ID = #attributes.multi_id#
	</cfquery>
<cfelse>
	<cfinclude template="../query/get_money.cfm">
</cfif>
<cfset pageHead = getLang('','Toplu Tahsilat','29560')&' : '&getLang('','Yeni Kayıt','45697')>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_process">
			<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
			<cf_basket_form id="collacted_revenue">
				<cf_box_elements>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-process_cat">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='388.İşlem tipi'> *</label>
							<div class="col col-8 col-xs-12">
								<cfif isdefined('get_action_detail')>
									<cf_workcube_process_cat process_cat="#get_action_detail.process_cat#">
								<cfelse>
									<cf_workcube_process_cat slct_width="150">
								</cfif>
							</div>
						</div>
						<div class="form-group" id="item-cash_action_from_cash_id">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='108.Kasa'> *</label>
							<div class="col col-8 col-xs-12">
								<cfif isdefined('get_action_detail')>
									<cf_wrk_Cash name="cash_action_to_cash_id" id="cash_action_to_cash_id" cash_status="1" currency_branch="0" value="#get_action_detail.to_cash_id#" onChange="kur_ekle_f_hesapla('cash_action_to_cash_id');">
								<cfelse>
									<cf_wrk_Cash name="cash_action_to_cash_id" id="cash_action_to_cash_id" cash_status="1" currency_branch="0" onChange="kur_ekle_f_hesapla('cash_action_to_cash_id');">
								</cfif>
							</div>
						</div>
						<div class="form-group" id="item-action_date">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='330.Tarih'> *</label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
								<cfset date_info = now()>
								<cfif isdefined('get_action_detail')>
									<cfset date_info = get_action_detail.action_date>
								</cfif>
								<div class="input-group">
									<cfinput type="text" name="action_date" value="#dateformat(date_info,dateformat_style)#" maxlength="10" validate="#validate_style#" required="Yes" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="action_date" call_function="change_money_info"></span>
								</div>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function='control_form()'>
				</cf_box_footer>
			</cf_basket_form>
			<cf_basket id="collacted_revenue_bask">
				<cfset paper_type = 3>
				<cfif isdefined("attributes.multi_id") and len(attributes.multi_id)>
					<cfset is_copy = 1>
				</cfif>
				<cfinclude template="../../objects/display/add_bank_cash_process_row.cfm">
			</cf_basket>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function open_file()
	{
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_add_collacted_from_file&type=4<cfif isdefined("attributes.multi_id")>&multi_id=#attributes.multi_id#</cfif></cfoutput>','multi_add_modal','ui-draggable-box-medium');
		return false;
	}
</script>

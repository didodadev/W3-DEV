<cf_xml_page_edit fuseact="cash.add_collacted_payment">
	<cfparam name="attributes.modal_id" default="">
<cfset cash_status = 1>
<cfinclude template="../query/get_cashes.cfm">
<cfif isdefined("attributes.multi_id") and len(attributes.multi_id)><!--- MA20081113 kopyalama --->
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
			CA.CASH_ACTION_TO_COMPANY_ID AS ACTION_COMPANY_ID,
			CA.CASH_ACTION_TO_CONSUMER_ID AS ACTION_CONSUMER_ID,
			CA.CASH_ACTION_TO_EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
			CA.OTHER_CASH_ACT_VALUE AS ACTION_VALUE_OTHER,
			CA.PROJECT_ID,
			CA.PAPER_NO,
			CA.CASH_ACTION_VALUE AS ACTION_VALUE,
			CA.ACTION_DETAIL,
			CA.ACTION_ID,
			CA.OTHER_MONEY AS ACTION_CURRENCY,
			CA.PAYER_ID AS EMPLOYEE_ID,
			CM.UPD_STATUS,
			CA.ASSETP_ID,
			CA.SPECIAL_DEFINITION_ID,
			CA.ACC_TYPE_ID,
			CA.SUBSCRIPTION_ID
		FROM
			CASH_ACTIONS_MULTI CM,
			CASH_ACTIONS CA
		WHERE
			CM.MULTI_ACTION_ID = CA.MULTI_ACTION_ID 
			AND CM.MULTI_ACTION_ID = #attributes.multi_id#
	</cfquery>
<cfelseif isdefined("attributes.puantaj_id") and len(attributes.puantaj_id)>
	<cfquery name="get_money" datasource="#dsn#">
		SELECT MONEY_TYPE AS MONEY,* FROM EMPLOYEES_PUANTAJ_CARI_ACTIONS_MONEY WHERE ACTION_ID = #attributes.puantaj_id#
	</cfquery>
	<cfif not get_money.recordcount>
		<cfquery name="get_money" datasource="#dsn2#">
			SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE MONEY_STATUS=1 ORDER BY MONEY_ID
		</cfquery>
	</cfif>
	<cfquery name="get_action_detail" datasource="#dsn#">
		SELECT
			'' PROCESS_CAT,
			EP.ACTION_DATE,
			'' AS ACTION_COMPANY_ID,
			'' AS ACTION_CONSUMER_ID,
			EPCR.EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
			((EPCR.ACTION_VALUE
			-
			ISNULL(
			(
				SELECT 
					SUM(AMOUNT)
				FROM
					EMPLOYEES_PUANTAJ_ROWS_EXT EXT,
					EMPLOYEES_PUANTAJ_ROWS EPR
				WHERE
					EPR.EMPLOYEE_PUANTAJ_ID = EXT.EMPLOYEE_PUANTAJ_ID
					AND (EPR.IN_OUT_ID = EPCR.IN_OUT_ID OR EPCR.IN_OUT_ID IS NULL)
					AND EPR.PUANTAJ_ID = #attributes.puantaj_id#
					AND EPR.EMPLOYEE_ID = EPCR.EMPLOYEE_ID
					AND EXT.EXT_TYPE = 1
			)
			,0))/(EPCR.ACTION_VALUE/EPCR.OTHER_ACTION_VALUE)) ACTION_VALUE_OTHER,
			'' PAPER_NO,
			'' PROJECT_ID,
			'' ACTION_ID,
			(EPCR.ACTION_VALUE
			-
			ISNULL(
			(
				SELECT 
					SUM(AMOUNT)
				FROM
					EMPLOYEES_PUANTAJ_ROWS_EXT EXT,
					EMPLOYEES_PUANTAJ_ROWS EPR
				WHERE
					EPR.EMPLOYEE_PUANTAJ_ID = EXT.EMPLOYEE_PUANTAJ_ID
					AND EPR.PUANTAJ_ID = #attributes.puantaj_id#
					AND EPR.EMPLOYEE_ID = EPCR.EMPLOYEE_ID
					AND EXT.EXT_TYPE = 1
			)
			,0)
			) ACTION_VALUE,
			EP.ACTION_DETAIL,
			EP.OTHER_MONEY AS ACTION_CURRENCY,
			0 UPD_STATUS,
			0 MASRAF,
			EPCR.EXPENSE_CENTER_ID,
			EPCR.EXPENSE_ITEM_ID,
			'' ASSETP_ID,
			'' FROM_CASH_ID,
			'' SPECIAL_DEFINITION_ID,
			EP.EMPLOYEE_ID,
            EPCR.ACC_TYPE_ID,
            '' AS SUBSCRIPTION_ID
		FROM
			EMPLOYEES_PUANTAJ_CARI_ACTIONS EP,
			EMPLOYEES_PUANTAJ_CARI_ACTIONS_ROW EPCR
		WHERE
			EP.DEKONT_ID = EPCR.DEKONT_ID 
			AND EP.PUANTAJ_ID = #attributes.puantaj_id#
			AND (EPCR.ACTION_VALUE
			-
			ISNULL(
			(
				SELECT 
					SUM(AMOUNT)
				FROM
					EMPLOYEES_PUANTAJ_ROWS_EXT EXT,
					EMPLOYEES_PUANTAJ_ROWS EPR
				WHERE
					EPR.EMPLOYEE_PUANTAJ_ID = EXT.EMPLOYEE_PUANTAJ_ID
					AND (EPR.IN_OUT_ID = EPCR.IN_OUT_ID OR EPCR.IN_OUT_ID IS NULL)
					AND EPR.PUANTAJ_ID = #attributes.puantaj_id#
					AND EPR.EMPLOYEE_ID = EPCR.EMPLOYEE_ID
					AND EXT.EXT_TYPE = 1
			)
			,0)
			) > 0
	</cfquery>
<cfelseif isdefined('attributes.payment_ids') and len(attributes.payment_ids)>
	<cfquery name="get_action_detail" datasource="#dsn#">
		SELECT	
			'' PROCESS_CAT,
			CP.RECORD_DATE AS ACTION_DATE,
			'' AS ACTION_COMPANY_ID,
			'' AS ACTION_CONSUMER_ID,
			CP.TO_EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
			'' AS FROM_CASH_ID,
			#session.ep.userid# AS EMPLOYEE_ID,
			'' AS PROJECT_ID,
			'' AS ACTION_ID,
			CP.ID AS AVANS_ID,
			CP.AMOUNT AS ACTION_VALUE,
			'' AS ACTION_VALUE_OTHER,
			'' AS ACTION_CURRENCY,
			'' AS ACTION_DETAIL,
			'' AS SPECIAL_DEFINITION_ID,
            ISNULL((SELECT ACC_TYPE_ID FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = CP.DEMAND_TYPE),-2) AS ACC_TYPE_ID,
            '' AS SUBSCRIPTION_ID
		FROM
			CORRESPONDENCE_PAYMENT CP,
			EMPLOYEES E,
			EMPLOYEES_IN_OUT EI
		WHERE 
			CP.ID IN(#attributes.payment_ids#) AND
			CP.IN_OUT_ID = EI.IN_OUT_ID AND 
			EI.EMPLOYEE_ID = E.EMPLOYEE_ID 
	</cfquery>
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE MONEY_STATUS=1 ORDER BY MONEY_ID
	</cfquery>
<cfelseif isdefined('attributes.other_payment_ids') and len(attributes.other_payment_ids)>
		<cfquery name="get_action_detail" datasource="#dsn#">
			SELECT	
				'' PROCESS_CAT,
				SGR.RECORD_DATE AS ACTION_DATE,
				'' AS ACTION_COMPANY_ID,
				'' AS ACTION_CONSUMER_ID,
				SGR.EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
				'' AS FROM_CASH_ID,
				#session.ep.userid# AS EMPLOYEE_ID,
				'' AS PROJECT_ID,
				'' AS ACTION_ID,
				SGR.SPGR_ID AS AVANS_ID,
				SGR.AMOUNT_GET AS ACTION_VALUE,
				'' AS ACTION_VALUE_OTHER,
				'' AS ACTION_CURRENCY,
				'' AS ACTION_DETAIL,
				'' AS SPECIAL_DEFINITION_ID,
				ISNULL((SELECT ACC_TYPE_ID FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = SGR.ODKES_ID),-2) AS ACC_TYPE_ID,
				'' AS SUBSCRIPTION_ID
			FROM
				SALARYPARAM_GET_REQUESTS SGR,
				EMPLOYEES E,
				EMPLOYEES_IN_OUT EI
			WHERE 
				SGR.SPGR_ID IN(#attributes.other_payment_ids#) AND
				SGR.IN_OUT_ID = EI.IN_OUT_ID AND 
				EI.EMPLOYEE_ID = E.EMPLOYEE_ID 
		</cfquery>
		<cfquery name="get_money" datasource="#dsn2#">
			SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE MONEY_STATUS=1 ORDER BY MONEY_ID
		</cfquery>
<cfelse>
	<cfinclude template="../query/get_money.cfm">
</cfif>
<div id="collacted_payment_file" style="margin-left:1000px; margin-top:15px; position:absolute;display:none;z-index:9999;"></div>
<cfset pageHead = getlang('','Nakit ödeme','63540')&": "&getlang('','Toplu Kayıt','63541') >
<cf_catalystHeader>
	<cf_box>
<cfform name="add_process">
    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <cfif isdefined("attributes.puantaj_id") and len(attributes.puantaj_id)>
        <input type="hidden" name="new_dsn2" id="new_dsn2" value="<cfoutput>#attributes.new_dsn2#</cfoutput>">
        <input type="hidden" name="new_dsn3" id="new_dsn3" value="<cfoutput>#attributes.new_dsn3#</cfoutput>">
        <input type="hidden" name="puantaj_id" id="puantaj_id" value="<cfoutput>#attributes.puantaj_id#</cfoutput>">
        <input type="hidden" name="is_virtual" id="is_virtual" value="<cfoutput>#attributes.is_virtual_puantaj#</cfoutput>">
        <input type="hidden" name="new_period_id" id="new_period_id" value="<cfoutput>#attributes.new_period_id#</cfoutput>">
    </cfif>
    <cfif isdefined('attributes.payment_ids')><!---ehesap/ avans talepleri ekranından geliyor ise--->
        <input type="hidden" name="payment_ids" id="payment_ids" value="<cfoutput>#attributes.payment_ids#</cfoutput>">
    </cfif>
	<cfif isdefined('attributes.other_payment_ids')><!---ehesap/Taksitli avans talepleri ekranından geliyor ise--->
        <input type="hidden" name="other_payment_ids" id="other_payment_ids" value="<cfoutput>#attributes.other_payment_ids#</cfoutput>">
    </cfif>
	<cf_basket_form id="collacted_payment">
<cf_box_elements>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-process_cat">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem tipi'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cfif isdefined('get_action_detail')>
                                        <cf_workcube_process_cat process_cat="#get_action_detail.process_cat#">
                                    <cfelse>
                                        <cf_workcube_process_cat>
                                    </cfif>
                                </div>
                            </div>
                            <div class="form-group" id="item-cash_action_from_cash_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57520.Kasa'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <select name="cash_action_from_cash_id" id="cash_action_from_cash_id" onChange="kur_ekle_f_hesapla('cash_action_from_cash_id');">
                                        <cfoutput query="get_cashes">
                                            <cfif isdefined('get_action_detail')>
                                                <option value="#cash_id#;#cash_currency_id#;#branch_id#" <cfif cash_id eq get_action_detail.from_cash_id>selected</cfif>>
                                            <cfelse>
                                                <option value="#cash_id#;#cash_currency_id#;#branch_id#">
                                            </cfif>
                                            #cash_name#&nbsp;#cash_currency_id#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-action_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
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
    <cf_basket id="collacted_payment_bask">
        <cfset paper_type = 4>
        <cfif isdefined("attributes.multi_id") and len(attributes.multi_id)>
            <cfset is_copy = 1>
        <cfelseif isdefined("attributes.puantaj_id") and len(attributes.puantaj_id)>
            <cfset is_copy = 1>
        <cfelseif isdefined("attributes.payment_ids") and len(attributes.payment_ids)>
            <cfset is_copy = 1>
		<cfelseif isdefined("attributes.other_payment_ids") and len(attributes.other_payment_ids)>
            <cfset is_copy = 1>
        </cfif>		
		<br>
        <cfinclude template="../../objects/display/add_bank_cash_process_row.cfm">
	</cf_basket>
</cfform>
</cf_box>
<script type="text/javascript">
	function open_file()
	{
		document.getElementById('collacted_payment_file').style.display='';
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_add_collacted_from_file&type=5<cfif isdefined("attributes.multi_id")>&multi_id=#attributes.multi_id#</cfif></cfoutput>');
		return false;
	}
</script>

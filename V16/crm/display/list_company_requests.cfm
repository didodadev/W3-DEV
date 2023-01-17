<cfquery name="GET_RISK_REQUEST" datasource="#DSN#" maxrows="5">
	SELECT
		COMPANY_RISK_REQUEST.REQUEST_ID,
		COMPANY_RISK_REQUEST.RISK_MONEY_CURRENCY,
		COMPANY_RISK_REQUEST.RISK_TOTAL,
		COMPANY_RISK_REQUEST.VALID_DATE,
		COMPANY_RISK_REQUEST.RECORD_DATE,
		COMPANY_RISK_REQUEST.RECORD_EMP,
		BRANCH.BRANCH_NAME,
		PROCESS_TYPE_ROWS.STAGE
	FROM
		COMPANY_RISK_REQUEST,
		BRANCH,
		PROCESS_TYPE_ROWS
	WHERE
		COMPANY_RISK_REQUEST.COMPANY_ID = #attributes.cpid# AND
		BRANCH.BRANCH_ID = COMPANY_RISK_REQUEST.BRANCH_ID AND
		PROCESS_TYPE_ROWS.PROCESS_ROW_ID = COMPANY_RISK_REQUEST.PROCESS_CAT AND 
		COMPANY_RISK_REQUEST.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
	ORDER BY
		COMPANY_RISK_REQUEST.RECORD_DATE DESC
</cfquery>
<cfquery name="GET_LAW_REQUEST" datasource="#DSN#" maxrows="5">
	SELECT
		COMPANY_LAW_REQUEST.LAW_REQUEST_ID,
		COMPANY_LAW_REQUEST.RECORD_DATE,
		COMPANY_LAW_REQUEST.RECORD_EMP,
		BRANCH.BRANCH_NAME,
		PROCESS_TYPE_ROWS.STAGE
	FROM
		COMPANY_LAW_REQUEST,
		BRANCH,
		PROCESS_TYPE_ROWS
	WHERE
		COMPANY_LAW_REQUEST.COMPANY_ID = #attributes.cpid# AND
		BRANCH.BRANCH_ID = COMPANY_LAW_REQUEST.BRANCH_ID AND
		PROCESS_TYPE_ROWS.PROCESS_ROW_ID = COMPANY_LAW_REQUEST.PROCESS_CAT AND 
		COMPANY_LAW_REQUEST.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
	ORDER BY
		COMPANY_LAW_REQUEST.RECORD_DATE DESC
</cfquery>
<cfquery name="GET_SALE_REQUEST_CLOSE" datasource="#DSN#" maxrows="5">
	SELECT
		COMPANY_SALE_CLOSE_REQUEST.SALE_CLOSE_REQUEST_ID,
		COMPANY_SALE_CLOSE_REQUEST.RECORD_DATE,
		COMPANY_SALE_CLOSE_REQUEST.RECORD_EMP,
		BRANCH.BRANCH_NAME,
		PROCESS_TYPE_ROWS.STAGE
	FROM
		COMPANY_SALE_CLOSE_REQUEST,
		BRANCH,
		PROCESS_TYPE_ROWS
	WHERE
		COMPANY_SALE_CLOSE_REQUEST.COMPANY_ID = #attributes.cpid# AND
		BRANCH.BRANCH_ID = COMPANY_SALE_CLOSE_REQUEST.BRANCH_ID AND
		PROCESS_TYPE_ROWS.PROCESS_ROW_ID = COMPANY_SALE_CLOSE_REQUEST.PROCESS_CAT AND 
		COMPANY_SALE_CLOSE_REQUEST.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
	ORDER BY
		COMPANY_SALE_CLOSE_REQUEST.RECORD_DATE DESC
</cfquery>
<cfquery name="GET_SALE_REQUEST" datasource="#DSN#" maxrows="5">
	SELECT
		COMPANY_SALE_REQUEST.SALE_REQUEST_ID,
		COMPANY_SALE_REQUEST.RECORD_DATE,
		COMPANY_SALE_REQUEST.RECORD_EMP,
		BRANCH.BRANCH_NAME,
		PROCESS_TYPE_ROWS.STAGE
	FROM
		COMPANY_SALE_REQUEST,
		BRANCH,
		PROCESS_TYPE_ROWS
	WHERE
		COMPANY_SALE_REQUEST.COMPANY_ID = #attributes.cpid# AND
		BRANCH.BRANCH_ID = COMPANY_SALE_REQUEST.BRANCH_ID AND
		PROCESS_TYPE_ROWS.PROCESS_ROW_ID = COMPANY_SALE_REQUEST.PROCESS_CAT AND 
		COMPANY_SALE_REQUEST.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) 
	ORDER BY
		COMPANY_SALE_REQUEST.RECORD_DATE DESC
</cfquery>
<cfquery name="GET_POSTPONE" datasource="#DSN#" maxrows="5">
	SELECT
		COMPANY_DEBIT_POSTPONE.COMPANY_DEBIT_POSTPONE_ID,
		COMPANY_DEBIT_POSTPONE.RECORD_DATE,
		COMPANY_DEBIT_POSTPONE.RECORD_EMP,
		BRANCH.BRANCH_NAME,
		PROCESS_TYPE_ROWS.STAGE
	FROM
		COMPANY_DEBIT_POSTPONE,
		BRANCH,
		PROCESS_TYPE_ROWS
	WHERE
		COMPANY_DEBIT_POSTPONE.COMPANY_ID = #attributes.cpid# AND
		BRANCH.BRANCH_ID = COMPANY_DEBIT_POSTPONE.BRANCH_ID AND
		PROCESS_TYPE_ROWS.PROCESS_ROW_ID = COMPANY_DEBIT_POSTPONE.PROCESS_CAT AND 
		COMPANY_DEBIT_POSTPONE.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
	ORDER BY
		COMPANY_DEBIT_POSTPONE.RECORD_DATE DESC
</cfquery>
<cfquery name="get_guess_endorsement" datasource="#dsn#" maxrows="5">
	SELECT
		COMPANY_GUESS_ENDORSEMENT.GUESS_ENDORSEMENT_ID,
		COMPANY_GUESS_ENDORSEMENT.GUESS_ENDORSEMENT_MONEY_CURRENCY,
		COMPANY_GUESS_ENDORSEMENT.GUESS_ENDORSEMENT_TOTAL,
		COMPANY_GUESS_ENDORSEMENT.RECORD_DATE,
		COMPANY_GUESS_ENDORSEMENT.RECORD_EMP,
		PROCESS_TYPE_ROWS.STAGE
	FROM
		COMPANY_GUESS_ENDORSEMENT,
		PROCESS_TYPE_ROWS
	WHERE
		COMPANY_GUESS_ENDORSEMENT.COMPANY_ID = #attributes.cpid# AND
		PROCESS_TYPE_ROWS.PROCESS_ROW_ID = COMPANY_GUESS_ENDORSEMENT.PROCESS_CAT
	ORDER BY
		COMPANY_GUESS_ENDORSEMENT.RECORD_DATE DESC
</cfquery>
<cf_box>

<input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
<cf_flat_list>
    <thead>
        <tr>
            <th colspan="7"><cf_get_lang no='739.Risk Talepleri'></th>
        </tr>
        <tr>
            <th width="30"><cf_get_lang_main no='75.No'></th>
            <th><cf_get_lang_main no='1351.Depo'></th>
            <th width="90"><cf_get_lang_main no ='1212.Geçerlilik Tarihi'></th>
            <th width="150"  style="text-align:right;"><cf_get_lang no='740.Talep Edilen Risk'></th>
            <th width="200"><cf_get_lang no='562.Süreç Aşama'></th>
            <th width="200"><cf_get_lang_main no='71.Kayıt'></th>
            <th width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_add_company_risk&consumer_id=#attributes.cpid#</cfoutput>','longpage','popup_add_company_risk')"><i class="fa fa-plus"></i></a></th>
        </tr>
    </thead>
    <tbody>
        <cfif get_risk_request.recordcount>
            <cfoutput query="get_risk_request">
            <tr>
                <td>#currentrow#</td>
                <td>#branch_name#</td>
                <td align="center">#DateFormat(valid_date,dateformat_style)#</td>
                <td  style="text-align:right;">#tlformat(risk_total)# #risk_money_currency#</td>
                <td>#stage#</td>
                <td>#get_emp_info(record_emp,0,1)# - #dateformat(record_date,dateformat_style)#</td>
                <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_upd_company_risk&request_id=#request_id#','longpage','form_upd_company_risk')"><i class="fa fa-pencil"></i></a></td>
            </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="7"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_flat_list>
<cf_flat_list>
    <thead>
        <tr>
            <th colspan="5"><cf_get_lang no='555.Avukata Verme Talebi'></th>
        </tr>
        <tr>
            <th width="30"><cf_get_lang_main no='75.No'></th>
            <th><cf_get_lang_main no='1351.Depo'></th>
            <th width="200"><cf_get_lang no='562.Süreç Aşama'></th>
            <th width="200"><cf_get_lang_main no='71.Kayıt'></th>
            <th width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_add_law_request&consumer_id=#attributes.cpid#</cfoutput>','longpage','popup_add_law_request');"><i class="fa fa-plus"></i></a></th>
        </tr>
    </thead>
    <tbody>
        <cfif get_law_request.recordcount>
            <cfoutput query="get_law_request">
            <tr>
                <td>#currentrow#</td>
                <td>#branch_name#</td>
                <td>#stage#</td>
                <td>#get_emp_info(record_emp,0,1)# - #dateformat(record_date,dateformat_style)#</td>
                <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_upd_law_request&law_request_id=#law_request_id#','longpage','popup_upd_law_request')"><i class="fa fa-pencil"></i></a></td>
            </tr>
            </cfoutput>
        <cfelse>
            <tr class="color-row" height="20">
                <td colspan="5"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_flat_list>
<cf_flat_list>
    <thead>
        <tr>
            <th colspan="5"><cf_get_lang no='553.Satışa Açma Talepleri'></th>
        </tr>
        <tr>
            <th width="30"><cf_get_lang_main no='75.No'></th>
            <th><cf_get_lang_main no='1351.Depo'></th>
            <th width="200"><cf_get_lang no='562.Süreç Aşama'></th>
            <th width="200"><cf_get_lang_main no='71.Kayıt'></th>
            <th width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_add_company_sale_request&consumer_id=#attributes.cpid#</cfoutput>','longpage','popup_add_company_sale_request')"><i class="fa fa-plus"></i></a></th>
        </tr>
    </thead>
    <tbody>
        <cfif get_sale_request.recordcount>
            <cfoutput query="get_sale_request">
            <tr>
                <td>#currentrow#</td>
                <td>#branch_name#</td>
                <td>#stage#</td>
                <td>#get_emp_info(record_emp,0,1)# - #dateformat(record_date,dateformat_style)#</td>
                <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_upd_company_sale_request&sale_request_id=#sale_request_id#','longpage','popup_upd_company_sale_request')"><i class="fa fa-pencil"></i></a></td>
            </tr>
            </cfoutput>
        <cfelse>
            <tr class="color-row" height="20">
                <td colspan="5"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
            </tr>
        </cfif>
   </tbody>
</cf_flat_list>
<cf_flat_list>
    <thead>
        <tr>
            <th colspan="5"><cf_get_lang no='554.Satışa Kapama Talepleri'></th>
        </tr>
        <tr>
            <th width="30"><cf_get_lang_main no='75.No'></th>
            <th><cf_get_lang_main no='1351.Depo'></th>
            <th width="200"><cf_get_lang no='562.Süreç Aşama'></th>
            <th width="200"><cf_get_lang_main no='71.Kayıt'></th>
            <th width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_add_company_sale_close_request&consumer_id=#attributes.cpid#</cfoutput>','longpage','popup_add_company_sale_close_request');"><i class="fa fa-plus"></i></a></th>
        </tr>
    </thead>
    <tbody>
        <cfif get_sale_request_close.recordcount>
            <cfoutput query="get_sale_request_close">
            <tr>
                <td>#currentrow#</td>
                <td>#branch_name#</td>
                <td>#stage#</td>
                <td>#get_emp_info(record_emp,0,1)# - #dateformat(record_date,dateformat_style)#</td>
                <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_upd_company_sale_close_request&sale_request_id=#sale_close_request_id#','longpage','popup_upd_company_sale_close_request')"><i class="fa fa-pencil"></i></a></td>
            </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="5"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_flat_list>
<cf_flat_list>
    <thead>
        <tr>
            <th colspan="5"><cf_get_lang no='741.Borç Erteleme Talebi'></th>
        </tr>
        <tr>
            <th width="30"><cf_get_lang_main no='75.No'></th>
            <th><cf_get_lang_main no='1351.Depo'></th>
            <th width="200"><cf_get_lang no='562.Süreç Aşama'></th>
            <th width="200"><cf_get_lang_main no='71.Kayıt'></th>
            <th width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_add_postpone_debit&consumer_id=#attributes.cpid#</cfoutput>','longpage','popup_add_postpone_debit');"><i class="fa fa-plus"></i></a></th>
        </tr>
    </thead>
    <tbody>
        <cfif get_postpone.recordcount>
            <cfoutput query="get_postpone">
            <tr>
                <td>#currentrow#</td>
                <td>#branch_name#</td>
                <td>#stage#</td>
                <td>#get_emp_info(record_emp,0,1)# - #dateformat(record_date,dateformat_style)#</td>
                <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_upd_postpone_debit&debit_postpone_id=#company_debit_postpone_id#','longpage','popup_upd_postpone_debit');"><i class="fa fa-pencil"></i></a></td>
            </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="5"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_flat_list>
<cf_flat_list>
    <thead>
        <tr>
            <th colspan="5"><cf_get_lang no ='137.Tahmini Ciro Talebi'></th>
        </tr>
        <tr>
            <th width="30"><cf_get_lang_main no='75.No'></th>
            <th style="text-align:right;"><cf_get_lang no ='151.Tahmini Ciro'></th>
            <th width="200"><cf_get_lang no='562.Süreç Aşama'></th>
            <th width="200"><cf_get_lang_main no='71.Kayıt'></th>
            <th width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_add_company_endorsement&consumer_id=#attributes.cpid#</cfoutput>','longpage','popup_add_company_endorsement')"><i class="fa fa-plus"></i></a></th>
        </tr>
    </thead>
    <tbody>
        <cfif get_guess_endorsement.recordcount>
            <cfoutput query="get_guess_endorsement">
            <tr>
                <td>#currentrow#</td>
                <td  style="text-align:right;">#tlformat(guess_endorsement_total)# #guess_endorsement_money_currency#</td>
                <td>#stage#</td>
                <td>#get_emp_info(record_emp,0,1)# - #dateformat(record_date,dateformat_style)#</td>
                <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_upd_company_endorsement&endorsement_id=#guess_endorsement_id#','longpage','popup_upd_company_endorsement')"><i class="fa fa-pencil"></i></a></td>
            </tr>
            </cfoutput>
        <cfelse>
            <tr class="color-row" height="20">
                <td colspan="5"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_flat_list>
</cf_box>
<cfif isdefined("attributes.is_open_request") and len(attributes.is_open_request)>
	<cfif attributes.is_open_request eq 1>
		<script type="text/javascript">
			windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_upd_company_risk&consumer_id=#attributes.cpid#&request_id=#attributes.action_id#</cfoutput>','longpage');
		</script>
		<cfset attributes.is_open_request = ''>
	<cfelseif attributes.is_open_request eq 2>
		<script type="text/javascript">
			windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_upd_law_request&consumer_id=#attributes.cpid#&law_request_id=#attributes.action_id#</cfoutput>','longpage');
		</script>
		<cfset attributes.is_open_request = ''>
	<cfelseif attributes.is_open_request eq 3>
		<script type="text/javascript">
			windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_upd_sale_request&consumer_id=#attributes.cpid#&sale_request_id=#attributes.action_id#</cfoutput>','longpage');
		</script>
		<cfset attributes.is_open_request = ''>
	<cfelseif attributes.is_open_request eq 4>
		<script type="text/javascript">
			windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_upd_company_sale_close_request&consumer_id=#attributes.cpid#&sale_request_id=#attributes.action_id#</cfoutput>','longpage');
		</script>
		<cfset attributes.is_open_request = ''>
	</cfif>
</cfif>
<script type="text/javascript">
function gonder_avukata_verme(id)
{
	window.parent.location.href=<cfoutput>'#request.self#?fuseaction=crm.form_upd_law_request&consumer_id=#attributes.cpid#&law_request_id=</cfoutput>' + id;
}
function gonder_erteleme(id)
{
	window.parent.location.href=<cfoutput>'#request.self#?fuseaction=crm.form_upd_postpone_debit&consumer_id=#attributes.cpid#&debit_postpone_id=</cfoutput>' + id;
}
</script>

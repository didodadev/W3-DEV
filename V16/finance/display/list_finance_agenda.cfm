<cf_xml_page_edit fuseact="finance.dsp_welcome">
<cfparam name="attributes.start_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.finish_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.date_type_info" default="1">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cf_date tarih="attributes.start_date">
<cf_date tarih="attributes.finish_date">
<cfinclude template="../../objects/query/get_acc_types.cfm">
<cfquery name="get_cari_rows" datasource="#dsn2#">
	SELECT
		*
	FROM
		CARI_ROWS
	WHERE
	<cfif attributes.date_type_info eq 2>
		ISNULL(DUE_DATE,ACTION_DATE) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
		ISNULL(DUE_DATE,ACTION_DATE) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
	<cfelseif attributes.date_type_info eq 3>
		RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('d',1,attributes.finish_date)#">
	<cfelse>
		ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
		ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
	</cfif>
	<cfif len(attributes.branch_id)>
		AND
		(
			FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> OR
			TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
		)
	</cfif>
	<cfif len(attributes.record_emp_id) and len(attributes.record_emp_name)>
		AND RECORD_EMP = #attributes.record_emp_id#
	</cfif>
    <cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)>
		AND #control_acc_type_list#
	</cfif>
</cfquery>
<cfquery name="GET_CARI_ALISLAR" dbtype="query">
	SELECT ACTION_TABLE,ACTION_ID,PAPER_NO,ACTION_TYPE_ID,ACTION_DATE,RECORD_DATE,DUE_DATE,ACTION_VALUE,OTHER_CASH_ACT_VALUE,OTHER_MONEY,FROM_CMP_ID,TO_CMP_ID,TO_CONSUMER_ID,FROM_CONSUMER_ID,TO_EMPLOYEE_ID,FROM_EMPLOYEE_ID FROM get_cari_rows WHERE ACTION_TYPE_ID IN (59,60,601,64,65,68,690,691,591,592,54,55,51,63,62,42,120,131)
</cfquery>
<cfquery name="GET_CARI_SATISLAR" dbtype="query">
	SELECT ACTION_TABLE,ACTION_ID,PAPER_NO,ACTION_TYPE_ID,ACTION_DATE,RECORD_DATE,DUE_DATE,ACTION_VALUE,OTHER_CASH_ACT_VALUE,OTHER_MONEY,FROM_CMP_ID,TO_CMP_ID,TO_CONSUMER_ID,FROM_CONSUMER_ID,TO_EMPLOYEE_ID,FROM_EMPLOYEE_ID FROM get_cari_rows WHERE ACTION_TYPE_ID IN (52,53,56,561,66,67,531,62,50,58,54,41,121)
</cfquery>
<cfquery name="GET_CARI_ODEMELER" dbtype="query">
	SELECT ACTION_TABLE,ACTION_ID,PAPER_NO,ACTION_TYPE_ID,ACTION_DATE,RECORD_DATE,DUE_DATE,ACTION_VALUE,OTHER_CASH_ACT_VALUE,OTHER_MONEY,FROM_CMP_ID,TO_CMP_ID,TO_CONSUMER_ID,FROM_CONSUMER_ID,TO_EMPLOYEE_ID,FROM_EMPLOYEE_ID FROM get_cari_rows WHERE ACTION_TYPE_ID IN (32,1041,1051,91,94,98,101,291,25,242,1044,1054)
</cfquery>
<cfquery name="GET_CARI_TAHSILATLAR" dbtype="query">
	SELECT ACTION_TABLE,ACTION_ID,PAPER_NO,ACTION_TYPE_ID,ACTION_DATE,RECORD_DATE,DUE_DATE,ACTION_VALUE,OTHER_CASH_ACT_VALUE,OTHER_MONEY,FROM_CMP_ID,TO_CMP_ID,TO_CONSUMER_ID,FROM_CONSUMER_ID,TO_EMPLOYEE_ID,FROM_EMPLOYEE_ID FROM get_cari_rows WHERE ACTION_TYPE_ID IN (31,35,1040,1050,90,95,97,108,292,24,240,241,1043,1053)
</cfquery>
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH
</cfquery>
<cfif is_dsp_orders eq 1>
	<cfquery name="GET_ORDERS" datasource="#dsn3#"><!--- Satış Siparişleri --->
		SELECT 
			ORDER_NUMBER,
			ORDER_STAGE,
			IS_PROCESSED,
			ORDER_HEAD,
			ORDER_STATUS,
			NETTOTAL,
			ORDER_DATE,
			ORDER_ID,
			OTHER_MONEY,
			OTHER_MONEY_VALUE,
			COMPANY_ID,
			CONSUMER_ID,
			RECORD_DATE,
			DUE_DATE
		FROM 
			ORDERS
		WHERE
			(
				(	ORDERS.PURCHASE_SALES = 1 AND
					ORDERS.ORDER_ZONE = 0
				 )  
				OR
				(	ORDERS.PURCHASE_SALES = 0 AND
					ORDERS.ORDER_ZONE = 1
				)
			) AND
			<cfif attributes.date_type_info eq 2>
				ISNULL(DUE_DATE,ORDER_DATE) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
				ISNULL(DUE_DATE,ORDER_DATE) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
			<cfelseif attributes.date_type_info eq 3>
				RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('d',1,attributes.finish_date)#">
			<cfelse>
				ORDER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
				ORDER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
			</cfif>
			<cfif len(attributes.branch_id)>
				AND DELIVER_DEPT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">)
			</cfif>
			<cfif len(attributes.record_emp_id) and len(attributes.record_emp_name)>
				AND RECORD_EMP = #attributes.record_emp_id#
			</cfif>
			AND ISNULL(IS_INSTALMENT,0)= 0
	</cfquery>
	<cfquery name="GET_ORDERS_INS" datasource="#dsn3#"><!--- Taksitli Satışlar --->
		SELECT 
			ORDER_NUMBER,
			ORDER_STAGE,
			IS_PROCESSED,
			ORDER_HEAD,
			ORDER_STATUS,
			NETTOTAL,
			ORDER_DATE,
			ORDER_ID,
			OTHER_MONEY,
			OTHER_MONEY_VALUE,
			COMPANY_ID,
			CONSUMER_ID,
			RECORD_DATE,
			DUE_DATE
		FROM 
			ORDERS
		WHERE
			(
				(	ORDERS.PURCHASE_SALES = 1 AND
					ORDERS.ORDER_ZONE = 0
				 )  
				OR
				(	ORDERS.PURCHASE_SALES = 0 AND
					ORDERS.ORDER_ZONE = 1
				)
			) AND
			<cfif attributes.date_type_info eq 2>
				ISNULL(DUE_DATE,ORDER_DATE) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
				ISNULL(DUE_DATE,ORDER_DATE) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
			<cfelseif attributes.date_type_info eq 3>
				RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('d',1,attributes.finish_date)#">
			<cfelse>
				ORDER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
				ORDER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
			</cfif>
			<cfif len(attributes.branch_id)>
				AND DELIVER_DEPT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">)
			</cfif>
			<cfif len(attributes.record_emp_id) and len(attributes.record_emp_name)>
				AND RECORD_EMP = #attributes.record_emp_id#
			</cfif>
			AND ISNULL(IS_INSTALMENT,0) = 1
	</cfquery>
</cfif>
<cfset company_id_list=''>
<cfset consumer_id_list=''>
<cfset employee_id_list=''>
<cfif is_dsp_orders eq 1>
	<cfoutput query="GET_ORDERS">
		<cfif len(COMPANY_ID) and COMPANY_ID neq 0 and not listfind(company_id_list,COMPANY_ID)>
			<cfset company_id_list=listappend(company_id_list,COMPANY_ID)>
		</cfif>
		<cfif len(CONSUMER_ID)  and CONSUMER_ID neq 0 and not listfind(consumer_id_list,CONSUMER_ID)>
			<cfset consumer_id_list=listappend(consumer_id_list,CONSUMER_ID)>
		</cfif>
	</cfoutput>	
	<cfoutput query="GET_ORDERS_INS">
		<cfif len(COMPANY_ID) and COMPANY_ID neq 0 and not listfind(company_id_list,COMPANY_ID)>
			<cfset company_id_list=listappend(company_id_list,COMPANY_ID)>
		</cfif>
		<cfif len(CONSUMER_ID)  and CONSUMER_ID neq 0 and not listfind(consumer_id_list,CONSUMER_ID)>
			<cfset consumer_id_list=listappend(consumer_id_list,CONSUMER_ID)>
		</cfif>
	</cfoutput>		 
</cfif>
<cfif GET_CARI_ROWS.recordcount>
	<cfoutput query="GET_CARI_ROWS">
		<cfif len(TO_CMP_ID) and TO_CMP_ID neq 0 and not listfind(company_id_list,TO_CMP_ID)>
			<cfset company_id_list=listappend(company_id_list,TO_CMP_ID)>
		</cfif>
		<cfif len(FROM_CMP_ID) and FROM_CMP_ID neq 0 and not listfind(company_id_list,FROM_CMP_ID)>
			<cfset company_id_list=listappend(company_id_list,FROM_CMP_ID)>
		</cfif>
		<cfif len(TO_CONSUMER_ID)  and TO_CONSUMER_ID neq 0 and not listfind(consumer_id_list,TO_CONSUMER_ID)>
			<cfset consumer_id_list=listappend(consumer_id_list,TO_CONSUMER_ID)>
		</cfif>
		<cfif len(FROM_CONSUMER_ID)  and FROM_CONSUMER_ID neq 0 and not listfind(consumer_id_list,FROM_CONSUMER_ID)>
			<cfset consumer_id_list=listappend(consumer_id_list,FROM_CONSUMER_ID)>
		</cfif>
		<cfif len(TO_EMPLOYEE_ID) and TO_EMPLOYEE_ID neq 0 and not listfind(employee_id_list,TO_EMPLOYEE_ID)>
			<cfset employee_id_list=listappend(employee_id_list,TO_EMPLOYEE_ID)>
		</cfif>
		<cfif len(FROM_EMPLOYEE_ID) and FROM_EMPLOYEE_ID neq 0 and not listfind(employee_id_list,FROM_EMPLOYEE_ID)>
			<cfset employee_id_list=listappend(employee_id_list,FROM_EMPLOYEE_ID)>
		</cfif>		
	</cfoutput>			 
</cfif>
<cfif len(company_id_list)>
	 <cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
	 <cfquery name="get_company_detail" datasource="#dsn#">
		SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
	 </cfquery>
</cfif>
<cfif len(consumer_id_list)>
	<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
	<cfquery name="get_consumer_detail" datasource="#dsn#">
		SELECT CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS FULLNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
	</cfquery>
</cfif>
<cfif len(employee_id_list)>
	<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
	<cfquery name="get_employee_detail" datasource="#dsn#">
		SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS FULLNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID 
	</cfquery>
</cfif>
<cfform name="list_actions">
<cf_big_list_search title="#getLang('finance',16)#">
    <cf_big_list_search_area>
        <div class="row">
            <div class="col col-lg-12 col-xs-12 form-inline">
                <div class="form-group">
                    <select name="branch_id" id="branch_id">
                        <option value=""><cf_get_lang_main no='41.Şube'></option>
                        <cfoutput query="GET_BRANCH">
                            <option value="#BRANCH_ID#" <cfif attributes.branch_id eq BRANCH_ID>selected</cfif>>#BRANCH_NAME#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <div class="col col-12 col-xs-12">
                        <div class="input-group">                            
                            <input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
                            <input name="record_emp_name" type="text"  id="record_emp_name"  onFocus="AutoComplete_Create('record_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','list_actions','3','135')" value="<cfif len(attributes.record_emp_name)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" autocomplete="off">
                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=list_actions.record_emp_name&field_emp_id=list_actions.record_emp_id&select_list=1,9','list');return false"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang_main no='1333.Başlama Tarihi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" style="width:65px;" required="yes" message="#message#" maxlength="10">
                        <span class="input-group-addon"> <cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                         <cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
                        <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" style="width:65px;" required="yes" message="#message#" maxlength="10">
                        <span class="input-group-addon">  <cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button>
                </div>
            </div>
        </div>
    </cf_big_list_search_area>
</cf_big_list_search>
</cfform>
<br />
<cfset alislar_toplam = 0>
<cfset satislar_toplam = 0>
<cfset tahsilatlar_toplam = 0>
<cfset odemeler_toplam = 0>
<cfset satis_sip_toplam = 0>
<cfset tak_satis_sip_toplam = 0>
<!-- sil -->
<cf_medium_list id="ana">
	<tr>
		<td valign="top">
            <cf_seperator id="alışlar" header="Alışlar">
            <cf_medium_list id="alışlar">
                <thead>
                    <tr>
                        <th><cf_get_lang_main no='75.No'></th>
                        <th><cf_get_lang_main no='388.İşlem Tipi'></th>
                        <th><cf_get_lang_main no='107.Cari Hesap'></th>
                        <th><cf_get_lang_main no='467.İşlem Tarihi'></th>
                        <th><cf_get_lang_main no='215.Kayıt Tarihi'></th>
                        <th><cf_get_lang_main no='469.Vade Tarihi'></th>
                        <th><cf_get_lang_main no='261.Tutar'> <cf_get_lang_main no='265.Döviz'></th>
                        <th><cf_get_lang_main no='261.Tutar'> <cfoutput>#session.ep.money#</cfoutput></th>
                    </tr>
                </thead>
                <cfif GET_CARI_ALISLAR.recordcount>
                    <tbody>
                        <cfoutput query="GET_CARI_ALISLAR">
                            <tr>
                                <td>#PAPER_NO#</td>
                                <td>
                                    <cfswitch expression = "#ACTION_TYPE_ID#">
                                        <cfcase value="24"><cfset type="ch.popup_dsp_gelenh"></cfcase>
                                        <cfcase value="25"><cfset type="ch.popup_dsp_gidenh"></cfcase>
                                        <cfcase value="26,27"><cfset type="ch.popup_check_preview"></cfcase>
                                        <cfcase value="31"><cfset type="ch.popup_dsp_cash_revenue"></cfcase>
                                        <cfcase value="35"><cfset type="ch.popup_dsp_cash_revenue"></cfcase>
                                        <cfcase value="32"><cfset type="ch.popup_dsp_cash_payment"></cfcase>
                                        <cfcase value="40"><cfset type="ch.popup_dsp_account_open"></cfcase>
                                        <cfcase value="43"><cfset type="objects.popup_cari_action"></cfcase>
                                        <cfcase value="41,42,45,46"><cfset type="ch.popup_print_upd_debit_claim_note"></cfcase>
                                        <cfcase value="90"><cfset type="ch.popup_dsp_payroll_entry"></cfcase>
                                        <cfcase value="106"><cfset type="ch.popup_dsp_payroll_entry"></cfcase>
                                        <cfcase value="91"><cfset type="ch.popup_dsp_payroll_endorsement"></cfcase>
                                        <cfcase value="94"><cfset type="ch.popup_dsp_payroll_endor_return"></cfcase>
                                        <cfcase value="95"><cfset type="ch.popup_dsp_payroll_entry_return"></cfcase>
                                        <cfcase value="97"><cfset type="ch.popup_dsp_voucher_payroll_action"></cfcase>
                                        <cfcase value="98"><cfset type="ch.popup_dsp_voucher_payroll_action"></cfcase>
                                        <cfcase value="101"><cfset type="ch.popup_dsp_voucher_payroll_action"></cfcase>
                                        <cfcase value="108"><cfset type="ch.popup_dsp_voucher_payroll_action"></cfcase>
                                        <cfcase value="131"><cfset type="ch.popup_dsp_collacted_dekont"></cfcase>
                                        <cfcase value="160"><cfset type="objects.popup_detail_budget_plan"></cfcase> 
                                        <cfcase value="241"><cfset type="ch.popup_dsp_credit_card_payment_type"></cfcase>
                                        <cfcase value="242"><cfset type="ch.popup_dsp_credit_card_payment"></cfcase>
                                        <cfcase value="251,260"><cfset type="bank.popup_dsp_assign_order"></cfcase>
                                        <cfcase value="120,121"><cfset type="objects.popup_list_cost_expense"></cfcase>
                                        <cfcase value="291,292"><cfset type="credit.popup_dsp_credit_payment"></cfcase>
                                        <cfcase value="293,294"><cfset type="credit.popup_dsp_stockbond_purchase"></cfcase>
                                        <cfcase value="48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,591,531,561,592,68,601,690,691">
                                            <cfif isdefined("invoice_partner_link")>
                                                <cfset type = invoice_partner_link>
                                            <cfelse>
                                                <cfset type="objects.popup_detail_invoice">
                                            </cfif>
                                        </cfcase>
                                        <cfdefaultcase><cfset type=""></cfdefaultcase>
                                    </cfswitch>
                                    <cfif listfind('24,25,26,27,31,35,32,34,35,36,43,241,242,177,250,260,251,131',ACTION_TYPE_ID,',')>
                                        <cfset page_type = 'small'>
                                    <cfelse>
                                        <cfset page_type = 'page'>
                                    </cfif>
                                    <cfif listfind("291,292",action_type_id)>
                                        <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#action_id#&our_company_id=#session.ep.company_id#','#page_type#');">
                                    <cfelseif ACTION_TABLE is 'CHEQUE'> 
                                        <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_cheque_det&id=#action_id#','small')">
                                    <cfelseif ACTION_TABLE is 'VOUCHER'> 
                                        <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_voucher_det&id=#action_id#','small')">
                                    <cfelseif ACTION_TABLE is 'BUDGET_PLAN'> 
                                        <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_budget_plan&id=#cari_action_id#','small')">
                                    <cfelse>
                                    <a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=#type#&id=#action_id#','#page_type#');">
                                    </cfif>
                                        #get_process_name(ACTION_TYPE_ID)#
                                    </a>
                                </td>
                                <td>
                                    <cfif len(GET_CARI_ALISLAR.TO_CMP_ID) and GET_CARI_ALISLAR.TO_CMP_ID neq 0>
                                        <cfset member_id = GET_CARI_ALISLAR.TO_CMP_ID>
                                        <cfset member_type = 'partner'>
                                        <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#GET_CARI_ALISLAR.TO_CMP_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#get_company_detail.NICKNAME[listfind(company_id_list,GET_CARI_ALISLAR.TO_CMP_ID,',')]#</a>
                                    <cfelseif len(GET_CARI_ALISLAR.FROM_CMP_ID) and GET_CARI_ALISLAR.FROM_CMP_ID neq 0>
                                        <cfset member_id = GET_CARI_ALISLAR.FROM_CMP_ID>
                                        <cfset member_type = 'partner'>
                                        <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#GET_CARI_ALISLAR.FROM_CMP_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#get_company_detail.NICKNAME[listfind(company_id_list,GET_CARI_ALISLAR.FROM_CMP_ID,',')]#</a>
                                    <cfelseif len(GET_CARI_ALISLAR.TO_CONSUMER_ID)  and GET_CARI_ALISLAR.TO_CONSUMER_ID neq 0>
                                        <cfset member_id = GET_CARI_ALISLAR.TO_CONSUMER_ID>
                                        <cfset member_type = 'consumer'>
                                        <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#GET_CARI_ALISLAR.TO_CONSUMER_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#get_consumer_detail.FULLNAME[listfind(consumer_id_list,GET_CARI_ALISLAR.TO_CONSUMER_ID,',')]#</a>
                                    <cfelseif len(GET_CARI_ALISLAR.FROM_CONSUMER_ID)  and GET_CARI_ALISLAR.FROM_CONSUMER_ID neq 0>
                                        <cfset member_id = GET_CARI_ALISLAR.FROM_CONSUMER_ID>
                                        <cfset member_type = 'consumer'>
                                        <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#GET_CARI_ALISLAR.FROM_CONSUMER_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#get_consumer_detail.FULLNAME[listfind(consumer_id_list,GET_CARI_ALISLAR.FROM_CONSUMER_ID,',')]#</a>
                                    <cfelseif len(FROM_EMPLOYEE_ID)  and GET_CARI_ALISLAR.FROM_EMPLOYEE_ID neq 0>
                                        <cfset member_id = GET_CARI_ALISLAR.FROM_EMPLOYEE_ID>
                                        <cfset member_type = 'employee'>
                                        <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#GET_CARI_ALISLAR.FROM_EMPLOYEE_ID#','medium');">#get_employee_detail.FULLNAME[listfind(employee_id_list,GET_CARI_ALISLAR.FROM_EMPLOYEE_ID,',')]#</a>
                                    <cfelseif len(TO_EMPLOYEE_ID)  and GET_CARI_ALISLAR.TO_EMPLOYEE_ID neq 0>	
                                        <cfset member_id = GET_CARI_ALISLAR.TO_EMPLOYEE_ID>
                                        <cfset member_type = 'employee'>
                                        <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#GET_CARI_ALISLAR.TO_EMPLOYEE_ID#','medium');">#get_employee_detail.FULLNAME[listfind(employee_id_list,GET_CARI_ALISLAR.TO_EMPLOYEE_ID,',')]#</a>
                                    </cfif>
                                </td>
                                <td>#dateformat(ACTION_DATE,dateformat_style)#</td>
                                <td>#dateformat(RECORD_DATE,dateformat_style)#</td>
                                <td><cfif len(DUE_DATE)>#dateformat(DUE_DATE,dateformat_style)#<cfelse>#dateformat(ACTION_DATE,dateformat_style)#</cfif></td>
                                <td>#TLFormat(OTHER_CASH_ACT_VALUE)# #OTHER_MONEY#</td>
                                <td>#TLFormat(ACTION_VALUE)#</td>
                                <cfset alislar_toplam = alislar_toplam + ACTION_VALUE>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <tfoot>
                        <tr><td colspan="8" class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.Toplam'> : <cfoutput>#TLFormat(alislar_toplam)# #session.ep.money#</cfoutput></td>
                        </tr>
                    </tfoot>
                <cfelse>
                    <tr>
                        <td colspan="8"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
                    </tr>
                </cfif>
            </cf_medium_list>
            <br/>
            <cf_seperator id="satisler" header="Satışlar">
            <cf_medium_list id="satisler">
                <thead>
                    <tr>
                        <th><cf_get_lang_main no='75.No'></th>
                        <th><cf_get_lang_main no='388.İşlem Tipi'></th>
                        <th><cf_get_lang_main no='107.Cari Hesap'></th>
                        <th><cf_get_lang_main no='467.İşlem Tarihi'></th>
                        <th><cf_get_lang_main no='215.Kayıt Tarihi'></th>
                        <th><cf_get_lang_main no='469.Vade Tarihi'></th>
                        <th ><cf_get_lang_main no='261.Tutar'> <cf_get_lang_main no='265.Döviz'></th>
                        <th ><cf_get_lang_main no='261.Tutar'> <cfoutput>#session.ep.money#</cfoutput></th>
                    </tr>
                </thead>            
                <cfif GET_CARI_SATISLAR.recordcount>
                    <tbody>
                        <cfoutput query="GET_CARI_SATISLAR">
                            <tr>
                                <td>#PAPER_NO#</td>
                                <td>
                                    <cfswitch expression = "#ACTION_TYPE_ID#">
                                        <cfcase value="24"><cfset type="ch.popup_dsp_gelenh"></cfcase>
                                        <cfcase value="25"><cfset type="ch.popup_dsp_gidenh"></cfcase>
                                        <cfcase value="26,27"><cfset type="ch.popup_check_preview"></cfcase>
                                        <cfcase value="31"><cfset type="ch.popup_dsp_cash_revenue"></cfcase>
                                        <cfcase value="35"><cfset type="ch.popup_dsp_cash_revenue"></cfcase>
                                        <cfcase value="32"><cfset type="ch.popup_dsp_cash_payment"></cfcase>
                                        <cfcase value="40"><cfset type="ch.popup_dsp_account_open"></cfcase>
                                        <cfcase value="43"><cfset type="objects.popup_cari_action"></cfcase>
                                        <cfcase value="41,42,45,46"><cfset type="ch.popup_print_upd_debit_claim_note"></cfcase>
                                        <cfcase value="90"><cfset type="ch.popup_dsp_payroll_entry"></cfcase>
                                        <cfcase value="106"><cfset type="ch.popup_dsp_payroll_entry"></cfcase>
                                        <cfcase value="91"><cfset type="ch.popup_dsp_payroll_endorsement"></cfcase>
                                        <cfcase value="94"><cfset type="ch.popup_dsp_payroll_endor_return"></cfcase>
                                        <cfcase value="95"><cfset type="ch.popup_dsp_payroll_entry_return"></cfcase>
                                        <cfcase value="97"><cfset type="ch.popup_dsp_voucher_payroll_action"></cfcase>
                                        <cfcase value="98"><cfset type="ch.popup_dsp_voucher_payroll_action"></cfcase>
                                        <cfcase value="101"><cfset type="ch.popup_dsp_voucher_payroll_action"></cfcase>
                                        <cfcase value="108"><cfset type="ch.popup_dsp_voucher_payroll_action"></cfcase>
                                        <cfcase value="131"><cfset type="ch.popup_dsp_collacted_dekont"></cfcase>
                                        <cfcase value="160"><cfset type="objects.popup_detail_budget_plan"></cfcase> 
                                        <cfcase value="241"><cfset type="ch.popup_dsp_credit_card_payment_type"></cfcase>
                                        <cfcase value="242"><cfset type="ch.popup_dsp_credit_card_payment"></cfcase>
                                        <cfcase value="251,260"><cfset type="bank.popup_dsp_assign_order"></cfcase>
                                        <cfcase value="120,121"><cfset type="objects.popup_list_cost_expense"></cfcase>
                                        <cfcase value="291,292"><cfset type="credit.popup_dsp_credit_payment"></cfcase>
                                        <cfcase value="293,294"><cfset type="credit.popup_dsp_stockbond_purchase"></cfcase>
                                        <cfcase value="48,49,50,51,52,53,54,56,57,58,59,60,61,62,63,64,65,66,591,531,561,592,68,601,690,691">
                                            <cfif isdefined("invoice_partner_link")>
                                                <cfset type = invoice_partner_link>
                                            <cfelse>
                                                <cfset type="objects.popup_detail_invoice">
                                            </cfif>
                                        </cfcase>
                                        <cfdefaultcase><cfset type=""></cfdefaultcase>
                                    </cfswitch>
                                    <cfif listfind('24,25,26,27,31,32,34,35,36,43,241,242,177,250,260,251,131',ACTION_TYPE_ID,',')>
                                        <cfset page_type = 'small'>
                                    <cfelse>
                                        <cfset page_type = 'page'>
                                    </cfif>
                                    <cfif listfind("291,292",action_type_id)>
                                        <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#action_id#&our_company_id=#session.ep.company_id#','#page_type#');">
                                    <cfelseif ACTION_TABLE is 'CHEQUE'> 
                                        <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_cheque_det&id=#action_id#','small')">
                                    <cfelseif ACTION_TABLE is 'VOUCHER'> 
                                        <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_voucher_det&id=#action_id#','small')">
                                    <cfelseif ACTION_TABLE is 'BUDGET_PLAN'> 
                                        <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_budget_plan&id=#cari_action_id#','small')">
                                    <cfelse>
                                    <a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=#type#&id=#action_id#','#page_type#');">
                                    </cfif>
                                        #get_process_name(ACTION_TYPE_ID)#
                                    </a>
                                </td>
                                <td>
                                    <cfif len(GET_CARI_SATISLAR.TO_CMP_ID) and GET_CARI_SATISLAR.TO_CMP_ID neq 0>
                                        <cfset member_id = GET_CARI_SATISLAR.TO_CMP_ID>
                                        <cfset member_type = 'partner'>
                                        <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#GET_CARI_SATISLAR.TO_CMP_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#get_company_detail.NICKNAME[listfind(company_id_list,GET_CARI_SATISLAR.TO_CMP_ID,',')]#</a>
                                    <cfelseif len(GET_CARI_SATISLAR.FROM_CMP_ID) and GET_CARI_SATISLAR.FROM_CMP_ID neq 0>
                                        <cfset member_id = GET_CARI_SATISLAR.FROM_CMP_ID>
                                        <cfset member_type = 'partner'>
                                        <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#GET_CARI_SATISLAR.FROM_CMP_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#get_company_detail.NICKNAME[listfind(company_id_list,GET_CARI_SATISLAR.FROM_CMP_ID,',')]#</a>
                                    <cfelseif len(GET_CARI_SATISLAR.TO_CONSUMER_ID)  and GET_CARI_SATISLAR.TO_CONSUMER_ID neq 0>
                                        <cfset member_id = GET_CARI_SATISLAR.TO_CONSUMER_ID>
                                        <cfset member_type = 'consumer'>
                                        <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#GET_CARI_SATISLAR.TO_CONSUMER_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#get_consumer_detail.FULLNAME[listfind(consumer_id_list,GET_CARI_SATISLAR.TO_CONSUMER_ID,',')]#</a>
                                    <cfelseif len(GET_CARI_SATISLAR.FROM_CONSUMER_ID)  and GET_CARI_SATISLAR.FROM_CONSUMER_ID neq 0>
                                        <cfset member_id = GET_CARI_SATISLAR.FROM_CONSUMER_ID>
                                        <cfset member_type = 'consumer'>
                                        <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#GET_CARI_SATISLAR.FROM_CONSUMER_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#get_consumer_detail.FULLNAME[listfind(consumer_id_list,GET_CARI_SATISLAR.FROM_CONSUMER_ID,',')]#</a>
                                    <cfelseif len(FROM_EMPLOYEE_ID)  and GET_CARI_SATISLAR.FROM_EMPLOYEE_ID neq 0>
                                        <cfset member_id = GET_CARI_SATISLAR.FROM_EMPLOYEE_ID>
                                        <cfset member_type = 'employee'>
                                        <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#GET_CARI_SATISLAR.FROM_EMPLOYEE_ID#','medium');">#get_employee_detail.FULLNAME[listfind(employee_id_list,GET_CARI_SATISLAR.FROM_EMPLOYEE_ID,',')]#</a>
                                    <cfelseif len(TO_EMPLOYEE_ID)  and GET_CARI_SATISLAR.TO_EMPLOYEE_ID neq 0>	
                                        <cfset member_id = GET_CARI_SATISLAR.TO_EMPLOYEE_ID>
                                        <cfset member_type = 'employee'>
                                        <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#GET_CARI_SATISLAR.TO_EMPLOYEE_ID#','medium');">#get_employee_detail.FULLNAME[listfind(employee_id_list,GET_CARI_SATISLAR.TO_EMPLOYEE_ID,',')]#</a>
                                    </cfif>
                                </td>
                                <td >#dateformat(ACTION_DATE,dateformat_style)#</td>
                                <td >#dateformat(RECORD_DATE,dateformat_style)#</td>
                                <td ><cfif len(DUE_DATE)>#dateformat(DUE_DATE,dateformat_style)#<cfelse>#dateformat(ACTION_DATE,dateformat_style)#</cfif></td>
                                <td >#TLFormat(OTHER_CASH_ACT_VALUE)# #OTHER_MONEY#</td>
                                <td >#TLFormat(ACTION_VALUE)#</td>
                                <cfset satislar_toplam = satislar_toplam + ACTION_VALUE>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <tfoot>
                        <tr><td colspan="8" class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.Toplam'> : <cfoutput>#TLFormat(satislar_toplam)# #session.ep.money#</cfoutput></td></tr>
                    </tfoot>
                <cfelse>
                    <tr>
                        <td colspan="8"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
                    </tr>
                </cfif>
            </cf_medium_list>
            <br/>
            <cfif is_dsp_orders>
                <cf_seperator id="siparisler" header="Satış Siparişleri">
                <cf_medium_list id="siparisler">
                    <thead>
                        <tr>
                            <th><cf_get_lang_main no='75.No'></th>
                            <th><cf_get_lang_main no='107.Cari Hesap'></th>
                            <th><cf_get_lang_main no='467.İşlem Tarihi'></th>
                            <th><cf_get_lang_main no='215.Kayıt Tarihi'></th>
                            <th><cf_get_lang_main no='469.Vade Tarihi'></th>
                            <th ><cf_get_lang_main no='261.Tutar'> <cf_get_lang_main no='265.Döviz'></th>
                            <th ><cf_get_lang_main no='261.Tutar'> <cfoutput>#session.ep.money#</cfoutput></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfif GET_ORDERS.recordcount>
                            <cfoutput query="GET_ORDERS">
                                <tr>
                                    <td><a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_order&order_id=#order_id#','page');">#ORDER_NUMBER#</a></td>
                                    <td>
                                        <cfif len(COMPANY_ID)>
                                            <cfset member_id = COMPANY_ID>
                                            <cfset member_type = 'partner'>
                                            <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMPANY_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#get_company_detail.NICKNAME[listfind(company_id_list,COMPANY_ID,',')]#</a>
                                        <cfelseif len(CONSUMER_ID)>
                                            <cfset member_id = CONSUMER_ID>
                                            <cfset member_type = 'consumer'>
                                            <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#CONSUMER_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#get_consumer_detail.FULLNAME[listfind(consumer_id_list,CONSUMER_ID,',')]#</a>
                                        </cfif>
                                    </td>
                                    <td >#dateformat(ORDER_DATE,dateformat_style)#</td>
                                    <td >#dateformat(RECORD_DATE,dateformat_style)#</td>
                                    <td ><cfif len(DUE_DATE)>#dateformat(DUE_DATE,dateformat_style)#<cfelse>#dateformat(ORDER_DATE,dateformat_style)#</cfif></td>
                                    <td >#TLFormat(OTHER_MONEY_VALUE)# #OTHER_MONEY#</td>
                                    <td >#TLFormat(NETTOTAL)#</td>
                                    <cfset satis_sip_toplam = satis_sip_toplam + NETTOTAL>
                                </tr>
                            </cfoutput>
                            <tr><td colspan="8" class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.Toplam'> : <cfoutput>#TLFormat(satis_sip_toplam)# #session.ep.money#</cfoutput></td></tr>
                        <cfelse>
                            <tr>
                                <td colspan="8"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
                            </tr>
                        </cfif>
                    </tbody>
                </cf_medium_list>
                    <br/>
                <cf_seperator id="tak_satisler" header="#getLang('main',796)#">
                <cf_medium_list id="tak_satisler">
                    <thead>
                        <tr>
                            <th><cf_get_lang_main no='75.No'></th>
                            <th><cf_get_lang_main no='107.Cari Hesap'></th>
                            <th><cf_get_lang_main no='467.İşlem Tarihi'></th>
                            <th><cf_get_lang_main no='215.Kayıt Tarihi'></th>
                            <th><cf_get_lang_main no='469.Vade Tarihi'></th>
                            <th ><cf_get_lang_main no='261.Tutar'> <cf_get_lang_main no='265.Döviz'></th>
                            <th ><cf_get_lang_main no='261.Tutar'> <cfoutput>#session.ep.money#</cfoutput></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfif GET_ORDERS_INS.recordcount>
                            <cfoutput query="GET_ORDERS_INS">
                                <tr>
                                    <td><a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_order&order_id=#order_id#','page');">#ORDER_NUMBER#</a></td>
                                    <td>
                                        <cfif len(COMPANY_ID)>
                                            <cfset member_id = COMPANY_ID>
                                            <cfset member_type = 'partner'>
                                            <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMPANY_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#get_company_detail.NICKNAME[listfind(company_id_list,COMPANY_ID,',')]#</a>
                                        <cfelseif len(CONSUMER_ID)>
                                            <cfset member_id = CONSUMER_ID>
                                            <cfset member_type = 'consumer'>
                                            <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#CONSUMER_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#get_consumer_detail.FULLNAME[listfind(consumer_id_list,CONSUMER_ID,',')]#</a>
                                        </cfif>
                                    </td>
                                    <td >#dateformat(ORDER_DATE,dateformat_style)#</td>
                                    <td >#dateformat(RECORD_DATE,dateformat_style)#</td>
                                    <td ><cfif len(DUE_DATE)>#dateformat(DUE_DATE,dateformat_style)#<cfelse>#dateformat(ORDER_DATE,dateformat_style)#</cfif></td>
                                    <td >#TLFormat(OTHER_MONEY_VALUE)# #OTHER_MONEY#</td>
                                    <td >#TLFormat(NETTOTAL)#</td>
                                    <cfset tak_satis_sip_toplam = tak_satis_sip_toplam + NETTOTAL>
                                </tr>
                            </cfoutput>
                            <tr><td colspan="8" class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.Toplam'> : <cfoutput>#TLFormat(tak_satis_sip_toplam)# #session.ep.money#</cfoutput></td></tr>
                        <cfelse>
                            <tr>
                                <td colspan="8"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
                            </tr>
                        </cfif>
                    </tbody>
                </cf_medium_list>
            </cfif>
            <br/>
		</td>
    </tr>
	<tr>
        <td valign="top">
            <cf_seperator id="ödemeler" header="#getLang('main',1246)#">
            <cf_medium_list id="ödemeler">
                <thead>
                    <tr>
                        <th><cf_get_lang_main no='75.No'></th>
                        <th><cf_get_lang_main no='388.İşlem Tipi'></th>
                        <th><cf_get_lang_main no='107.Cari Hesap'></th>
                        <th><cf_get_lang_main no='467.İşlem Tarihi'></th>
                        <th><cf_get_lang_main no='215.Kayıt Tarihi'></th>
                        <th><cf_get_lang_main no='469.Vade Tarihi'></th>
                        <th ><cf_get_lang_main no='261.Tutar'> <cf_get_lang_main no='265.Döviz'></th>
                        <th ><cf_get_lang_main no='261.Tutar'> <cfoutput>#session.ep.money#</cfoutput></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif GET_CARI_ODEMELER.recordcount>
                            <cfoutput query="GET_CARI_ODEMELER">
                                <tr>
                                    <td>#PAPER_NO#</td>
                                    <td>
                                        <cfswitch expression = "#ACTION_TYPE_ID#">
                                            <cfcase value="24"><cfset type="ch.popup_dsp_gelenh"></cfcase>
                                            <cfcase value="25"><cfset type="ch.popup_dsp_gidenh"></cfcase>
                                            <cfcase value="26,27"><cfset type="ch.popup_check_preview"></cfcase>
                                            <cfcase value="31"><cfset type="ch.popup_dsp_cash_revenue"></cfcase>
                                            <cfcase value="35"><cfset type="ch.popup_dsp_cash_revenue"></cfcase>
                                            <cfcase value="32"><cfset type="ch.popup_dsp_cash_payment"></cfcase>
                                            <cfcase value="40"><cfset type="ch.popup_dsp_account_open"></cfcase>
                                            <cfcase value="43"><cfset type="objects.popup_cari_action"></cfcase>
                                            <cfcase value="41,42,45,46"><cfset type="ch.popup_print_upd_debit_claim_note"></cfcase>
                                            <cfcase value="90"><cfset type="ch.popup_dsp_payroll_entry"></cfcase>
                                            <cfcase value="106"><cfset type="ch.popup_dsp_payroll_entry"></cfcase>
                                            <cfcase value="91"><cfset type="ch.popup_dsp_payroll_endorsement"></cfcase>
                                            <cfcase value="94"><cfset type="ch.popup_dsp_payroll_endor_return"></cfcase>
                                            <cfcase value="95"><cfset type="ch.popup_dsp_payroll_entry_return"></cfcase>
                                            <cfcase value="97"><cfset type="ch.popup_dsp_voucher_payroll_action"></cfcase>
                                            <cfcase value="98"><cfset type="ch.popup_dsp_voucher_payroll_action"></cfcase>
                                            <cfcase value="101"><cfset type="ch.popup_dsp_voucher_payroll_action"></cfcase>
                                            <cfcase value="108"><cfset type="ch.popup_dsp_voucher_payroll_action"></cfcase>
                                            <cfcase value="131"><cfset type="ch.popup_dsp_collacted_dekont"></cfcase>
                                            <cfcase value="160"><cfset type="objects.popup_detail_budget_plan"></cfcase> 
                                            <cfcase value="241"><cfset type="ch.popup_dsp_credit_card_payment_type"></cfcase>
                                            <cfcase value="242"><cfset type="ch.popup_dsp_credit_card_payment"></cfcase>
                                            <cfcase value="251,260"><cfset type="bank.popup_dsp_assign_order"></cfcase>
                                            <cfcase value="120,121"><cfset type="objects.popup_list_cost_expense"></cfcase>
                                            <cfcase value="291,292"><cfset type="credit.popup_dsp_credit_payment"></cfcase>
                                            <cfcase value="293,294"><cfset type="credit.popup_dsp_stockbond_purchase"></cfcase>
                                            <cfcase value="48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,591,531,561,592,68,601,690,691">
                                                <cfif isdefined("invoice_partner_link")>
                                                    <cfset type = invoice_partner_link>
                                                <cfelse>
                                                    <cfset type="objects.popup_detail_invoice">
                                                </cfif>
                                            </cfcase>
                                            <cfdefaultcase><cfset type=""></cfdefaultcase>
                                        </cfswitch>
                                        <cfif listfind('24,25,26,27,31,32,34,35,36,43,241,242,177,250,260,251,131',ACTION_TYPE_ID,',')>
                                            <cfset page_type = 'small'>
                                        <cfelse>
                                            <cfset page_type = 'page'>
                                        </cfif>
                                        <cfif listfind("291,292",action_type_id)>
                                            <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#action_id#&our_company_id=#session.ep.company_id#','#page_type#');">
                                        <cfelseif ACTION_TABLE is 'CHEQUE'> 
                                            <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_cheque_det&id=#action_id#','small')">
                                        <cfelseif ACTION_TABLE is 'VOUCHER'> 
                                            <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_voucher_det&id=#action_id#','small')">
                                        <cfelseif ACTION_TABLE is 'BUDGET_PLAN'> 
                                            <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_budget_plan&id=#cari_action_id#','small')">
                                        <cfelse>
                                        <a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=#type#&id=#action_id#','#page_type#');">
                                        </cfif>
                                            #get_process_name(ACTION_TYPE_ID)#
                                        </a>
                                    </td>
                                    <td>
                                        <cfif len(GET_CARI_ODEMELER.TO_CMP_ID) and GET_CARI_ODEMELER.TO_CMP_ID neq 0>
                                            <cfset member_id = GET_CARI_ODEMELER.TO_CMP_ID>
                                            <cfset member_type = 'partner'>
                                            <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#GET_CARI_ODEMELER.TO_CMP_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#get_company_detail.NICKNAME[listfind(company_id_list,GET_CARI_ODEMELER.TO_CMP_ID,',')]#</a>
                                        <cfelseif len(GET_CARI_ODEMELER.FROM_CMP_ID) and GET_CARI_ODEMELER.FROM_CMP_ID neq 0>
                                            <cfset member_id = GET_CARI_ODEMELER.FROM_CMP_ID>
                                            <cfset member_type = 'partner'>
                                            <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#GET_CARI_ODEMELER.FROM_CMP_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#get_company_detail.NICKNAME[listfind(company_id_list,GET_CARI_ODEMELER.FROM_CMP_ID,',')]#</a>
                                        <cfelseif len(GET_CARI_ODEMELER.TO_CONSUMER_ID)  and GET_CARI_ODEMELER.TO_CONSUMER_ID neq 0>
                                            <cfset member_id = GET_CARI_ODEMELER.TO_CONSUMER_ID>
                                            <cfset member_type = 'consumer'>
                                            <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#GET_CARI_ODEMELER.TO_CONSUMER_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#get_consumer_detail.FULLNAME[listfind(consumer_id_list,GET_CARI_ODEMELER.TO_CONSUMER_ID,',')]#</a>
                                        <cfelseif len(GET_CARI_ODEMELER.FROM_CONSUMER_ID)  and GET_CARI_ODEMELER.FROM_CONSUMER_ID neq 0>
                                            <cfset member_id = GET_CARI_ODEMELER.FROM_CONSUMER_ID>
                                            <cfset member_type = 'consumer'>
                                            <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#GET_CARI_ODEMELER.FROM_CONSUMER_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#get_consumer_detail.FULLNAME[listfind(consumer_id_list,GET_CARI_ODEMELER.FROM_CONSUMER_ID,',')]#</a>
                                        <cfelseif len(FROM_EMPLOYEE_ID)  and GET_CARI_ODEMELER.FROM_EMPLOYEE_ID neq 0>
                                            <cfset member_id = GET_CARI_ODEMELER.FROM_EMPLOYEE_ID>
                                            <cfset member_type = 'employee'>
                                            <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#GET_CARI_ODEMELER.FROM_EMPLOYEE_ID#','medium');">#get_employee_detail.FULLNAME[listfind(employee_id_list,GET_CARI_ODEMELER.FROM_EMPLOYEE_ID,',')]#</a>
                                        <cfelseif len(TO_EMPLOYEE_ID)  and GET_CARI_ODEMELER.TO_EMPLOYEE_ID neq 0>	
                                            <cfset member_id = GET_CARI_ODEMELER.TO_EMPLOYEE_ID>
                                            <cfset member_type = 'employee'>
                                            <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#GET_CARI_ODEMELER.TO_EMPLOYEE_ID#','medium');">#get_employee_detail.FULLNAME[listfind(employee_id_list,GET_CARI_ODEMELER.TO_EMPLOYEE_ID,',')]#</a>
                                        </cfif>
                                    </td>
                                    <td >#dateformat(ACTION_DATE,dateformat_style)#</td>
                                    <td >#dateformat(RECORD_DATE,dateformat_style)#</td>
                                    <td ><cfif len(DUE_DATE)>#dateformat(DUE_DATE,dateformat_style)#<cfelse>#dateformat(ACTION_DATE,dateformat_style)#</cfif></td>
                                    <td >#TLFormat(OTHER_CASH_ACT_VALUE)# #OTHER_MONEY#</td>
                                    <td >#TLFormat(ACTION_VALUE)#</td>
                                    <cfset odemeler_toplam = odemeler_toplam + ACTION_VALUE>
                                </tr>
                            </cfoutput>
                            <tfoot>
                                <tr>
                                    <td colspan="8" class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.Toplam'> : <cfoutput>#TLFormat(odemeler_toplam)# #session.ep.money#</cfoutput></td>
                                </tr>
                        </tfoot>
                    <cfelse>
                        <tbody>
                            <tr>
                                <td colspan="8"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
                            </tr>
                        </tbody>
                    </cfif>
                </tbody>
            </cf_medium_list>
            <br/>
            <cf_seperator id="tahsilatlar" header="#getLang('finance',60)#">
            <cf_medium_list id="tahsilatlar">
                <thead>
                    <tr>
                        <th><cf_get_lang_main no='75.No'></th>
                        <th><cf_get_lang_main no='388.İşlem Tipi'></th>
                        <th><cf_get_lang_main no='107.Cari Hesap'></th>
                        <th><cf_get_lang_main no='467.İşlem Tarihi'></th>
                        <th><cf_get_lang_main no='215.Kayıt Tarihi'></th>
                        <th><cf_get_lang_main no='469.Vade Tarihi'></th>
                        <th ><cf_get_lang_main no='261.Tutar'> <cf_get_lang_main no='265.Döviz'></th>
                        <th ><cf_get_lang_main no='261.Tutar'> <cfoutput>#session.ep.money#</cfoutput></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif GET_CARI_TAHSILATLAR.recordcount>
                            <cfoutput query="GET_CARI_TAHSILATLAR">
                                <tr>
                                    <td>#PAPER_NO#</td>
                                    <td>
                                        <cfswitch expression = "#ACTION_TYPE_ID#">
                                            <cfcase value="24"><cfset type="ch.popup_dsp_gelenh"></cfcase>
                                            <cfcase value="25"><cfset type="ch.popup_dsp_gidenh"></cfcase>
                                            <cfcase value="26,27"><cfset type="ch.popup_check_preview"></cfcase>
                                            <cfcase value="31"><cfset type="ch.popup_dsp_cash_revenue"></cfcase>
                                            <cfcase value="35"><cfset type="ch.popup_dsp_cash_revenue"></cfcase>
                                            <cfcase value="32"><cfset type="ch.popup_dsp_cash_payment"></cfcase>
                                            <cfcase value="40"><cfset type="ch.popup_dsp_account_open"></cfcase>
                                            <cfcase value="43"><cfset type="objects.popup_cari_action"></cfcase>
                                            <cfcase value="41,42,45,46"><cfset type="ch.popup_print_upd_debit_claim_note"></cfcase>
                                            <cfcase value="90"><cfset type="ch.popup_dsp_payroll_entry"></cfcase>
                                            <cfcase value="106"><cfset type="ch.popup_dsp_payroll_entry"></cfcase>
                                            <cfcase value="91"><cfset type="ch.popup_dsp_payroll_endorsement"></cfcase>
                                            <cfcase value="94"><cfset type="ch.popup_dsp_payroll_endor_return"></cfcase>
                                            <cfcase value="95"><cfset type="ch.popup_dsp_payroll_entry_return"></cfcase>
                                            <cfcase value="97"><cfset type="ch.popup_dsp_voucher_payroll_action"></cfcase>
                                            <cfcase value="98"><cfset type="ch.popup_dsp_voucher_payroll_action"></cfcase>
                                            <cfcase value="101"><cfset type="ch.popup_dsp_voucher_payroll_action"></cfcase>
                                            <cfcase value="108"><cfset type="ch.popup_dsp_voucher_payroll_action"></cfcase>
                                            <cfcase value="131"><cfset type="ch.popup_dsp_collacted_dekont"></cfcase>
                                            <cfcase value="160"><cfset type="objects.popup_detail_budget_plan"></cfcase> 
                                            <cfcase value="241"><cfset type="ch.popup_dsp_credit_card_payment_type"></cfcase>
                                            <cfcase value="242"><cfset type="ch.popup_dsp_credit_card_payment"></cfcase>
                                            <cfcase value="251,260"><cfset type="bank.popup_dsp_assign_order"></cfcase>
                                            <cfcase value="120,121"><cfset type="objects.popup_list_cost_expense"></cfcase>
                                            <cfcase value="291,292"><cfset type="credit.popup_dsp_credit_payment"></cfcase>
                                            <cfcase value="293,294"><cfset type="credit.popup_dsp_stockbond_purchase"></cfcase>
                                            <cfcase value="48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,591,531,561,592,68,601,690,691">
                                                <cfif isdefined("invoice_partner_link")>
                                                    <cfset type = invoice_partner_link>
                                                <cfelse>
                                                    <cfset type="objects.popup_detail_invoice">
                                                </cfif>
                                            </cfcase>
                                            <cfdefaultcase><cfset type=""></cfdefaultcase>
                                        </cfswitch>
                                        <cfif listfind('24,25,26,27,31,32,34,35,36,43,241,242,177,250,260,251,131',ACTION_TYPE_ID,',')>
                                            <cfset page_type = 'small'>
                                        <cfelse>
                                            <cfset page_type = 'page'>
                                        </cfif>
                                        <cfif listfind("291,292",action_type_id)>
                                            <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#action_id#&our_company_id=#session.ep.company_id#','#page_type#');">
                                        <cfelseif ACTION_TABLE is 'CHEQUE'> 
                                            <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_cheque_det&id=#action_id#','small')">
                                        <cfelseif ACTION_TABLE is 'VOUCHER'> 
                                            <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_voucher_det&id=#action_id#','small')">
                                        <cfelseif ACTION_TABLE is 'BUDGET_PLAN'> 
                                            <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_budget_plan&id=#cari_action_id#','small')">
                                        <cfelse>
                                            <a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=#type#&id=#action_id#','#page_type#');">
                                        </cfif>
                                            #get_process_name(ACTION_TYPE_ID)#
                                        </a>
                                    </td>
                                    <td>
                                        <cfif len(GET_CARI_TAHSILATLAR.TO_CMP_ID) and GET_CARI_TAHSILATLAR.TO_CMP_ID neq 0>
                                            <cfset member_id = GET_CARI_TAHSILATLAR.TO_CMP_ID>
                                            <cfset member_type = 'partner'>
                                            <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#GET_CARI_TAHSILATLAR.TO_CMP_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#get_company_detail.NICKNAME[listfind(company_id_list,GET_CARI_TAHSILATLAR.TO_CMP_ID,',')]#</a>
                                        <cfelseif len(GET_CARI_TAHSILATLAR.FROM_CMP_ID) and GET_CARI_TAHSILATLAR.FROM_CMP_ID neq 0>
                                            <cfset member_id = GET_CARI_TAHSILATLAR.FROM_CMP_ID>
                                            <cfset member_type = 'partner'>
                                            <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#GET_CARI_TAHSILATLAR.FROM_CMP_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#get_company_detail.NICKNAME[listfind(company_id_list,GET_CARI_TAHSILATLAR.FROM_CMP_ID,',')]#</a>
                                        <cfelseif len(GET_CARI_TAHSILATLAR.TO_CONSUMER_ID)  and GET_CARI_TAHSILATLAR.TO_CONSUMER_ID neq 0>
                                            <cfset member_id = GET_CARI_TAHSILATLAR.TO_CONSUMER_ID>
                                            <cfset member_type = 'consumer'>
                                            <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#GET_CARI_TAHSILATLAR.TO_CONSUMER_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#get_consumer_detail.FULLNAME[listfind(consumer_id_list,GET_CARI_TAHSILATLAR.TO_CONSUMER_ID,',')]#</a>
                                        <cfelseif len(GET_CARI_TAHSILATLAR.FROM_CONSUMER_ID)  and GET_CARI_TAHSILATLAR.FROM_CONSUMER_ID neq 0>
                                            <cfset member_id = GET_CARI_TAHSILATLAR.FROM_CONSUMER_ID>
                                            <cfset member_type = 'consumer'>
                                            <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#GET_CARI_TAHSILATLAR.FROM_CONSUMER_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#get_consumer_detail.FULLNAME[listfind(consumer_id_list,GET_CARI_TAHSILATLAR.FROM_CONSUMER_ID,',')]#</a>
                                        <cfelseif len(FROM_EMPLOYEE_ID)  and GET_CARI_TAHSILATLAR.FROM_EMPLOYEE_ID neq 0>
                                            <cfset member_id = GET_CARI_TAHSILATLAR.FROM_EMPLOYEE_ID>
                                            <cfset member_type = 'employee'>
                                            <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#GET_CARI_TAHSILATLAR.FROM_EMPLOYEE_ID#','medium');">#get_employee_detail.FULLNAME[listfind(employee_id_list,GET_CARI_TAHSILATLAR.FROM_EMPLOYEE_ID,',')]#</a>
                                        <cfelseif len(TO_EMPLOYEE_ID)  and GET_CARI_TAHSILATLAR.TO_EMPLOYEE_ID neq 0>	
                                            <cfset member_id = GET_CARI_TAHSILATLAR.TO_EMPLOYEE_ID>
                                            <cfset member_type = 'employee'>
                                            <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#GET_CARI_TAHSILATLAR.TO_EMPLOYEE_ID#','medium');">#get_employee_detail.FULLNAME[listfind(employee_id_list,GET_CARI_TAHSILATLAR.TO_EMPLOYEE_ID,',')]#</a>
                                        </cfif>
                                    </td>
                                    <td >#dateformat(ACTION_DATE,dateformat_style)#</td>
                                    <td >#dateformat(RECORD_DATE,dateformat_style)#</td>
                                    <td ><cfif len(DUE_DATE)>#dateformat(DUE_DATE,dateformat_style)#<cfelse>#dateformat(ACTION_DATE,dateformat_style)#</cfif></td>
                                    <td >#TLFormat(OTHER_CASH_ACT_VALUE)# #OTHER_MONEY#</td>
                                    <td >#TLFormat(ACTION_VALUE)#</td>
                                    <cfset tahsilatlar_toplam = tahsilatlar_toplam + ACTION_VALUE>
                                </tr>
                            </cfoutput>
                                <tfoot>
                                <tr>
                                    <td colspan="8" class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.Toplam'> : <cfoutput>#TLFormat(tahsilatlar_toplam)# #session.ep.money#</cfoutput></td>
                                </tr>
                                </tfoot>
                        <cfelse>
                            <tbody>
                                <tr>
                                    <td colspan="8"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
                                </tr>
                            </tbody>
                    </cfif>
                </tbody>
            </cf_medium_list>
            <br/>
        </td>
	</tr>
</cf_medium_list>

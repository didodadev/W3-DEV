<!---e.a 19072012 select ifadeleri düzenlendi.--->
<cfquery name="get_actions" datasource="#dsn2#">
	SELECT 
		*
	FROM 
		CARI_DUE_DIFF_ACTIONS
	WHERE 
		DUE_DIFF_ID = #attributes.due_diff_id# 
</cfquery>
<cfquery name="get_rate" datasource="#dsn2#">
	SELECT 
		RATE2,
		MONEY_TYPE MONEY
	FROM 
		CARI_DUE_DIFF_ACTIONS_MONEY
	WHERE 
		ACTION_ID = #attributes.due_diff_id# 
		AND IS_SELECTED = 1
</cfquery>
<cfif get_actions.action_type eq 2>
	<cfquery name="GET_PERIOD" datasource="#dsn#"><!--- yetkili olduğum aktif şirketler --->
		SELECT PERIOD_YEAR,PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id#
	</cfquery>
	<cfquery name="get_rows" datasource="#dsn2#">
		SELECT
			*
		FROM
		(
			<cfoutput query="GET_PERIOD">
				SELECT 
					C.COMPANY_ID,
					C.CONSUMER_ID,
					C.INVOICE_ID,
					C.CARI_ROW_ID,
					C.ACTION_VALUE,
					C.DUE_DIFF_VALUE,
					C.PERIOD_ID,
					I.DUE_DATE,
					I.INVOICE_NUMBER PAPER_NO
				FROM 
					CARI_DUE_DIFF_ACTIONS_ROW C,
					#dsn#_#GET_PERIOD.PERIOD_YEAR#_#session.ep.company_id#.INVOICE I
				WHERE 
					DUE_DIFF_ID = #attributes.due_diff_id#
					AND C.INVOICE_ID = I.INVOICE_ID
					AND C.PERIOD_ID = #GET_PERIOD.PERIOD_ID#
			<cfif GET_PERIOD.recordcount neq 1 and currentrow neq GET_PERIOD.recordcount> UNION ALL </cfif>
			</cfoutput>
		) GET_ROWS
	</cfquery>	
<cfelse>
	<cfquery name="get_rows" datasource="#dsn2#">
		SELECT 
			C.COMPANY_ID,
			C.CONSUMER_ID,
			C.INVOICE_ID,
			C.CARI_ROW_ID,
			C.ACTION_VALUE,
			C.DUE_DIFF_VALUE,
			CR.DUE_DATE,
			CR.PAPER_NO
		FROM 
			CARI_DUE_DIFF_ACTIONS_ROW C,
			CARI_ROWS CR
		WHERE 
			DUE_DIFF_ID = #attributes.due_diff_id#
			AND C.CARI_ROW_ID = CR.CARI_ACTION_ID
	</cfquery>
</cfif>
<cfif get_rows.recordcount>
	<cfset company_id_list = "">
	<cfset consumer_id_list = "">
	<cfoutput query="get_rows">
		<cfif len(company_id) and not listfind(company_id_list, company_id)>
			<cfset company_id_list=listappend(company_id_list, company_id)>
		</cfif>
		<cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
			<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
		</cfif>
	</cfoutput>
	<cfif len(company_id_list)>
		<cfset company_id_list = listsort(company_id_list,"numeric","ASC",",")>
		<cfquery name="get_company_detail" datasource="#dsn#">
			SELECT COMPANY_ID,NICKNAME,MEMBER_CODE FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
		</cfquery>
		<cfset company_id_list = listsort(listdeleteduplicates(valuelist(get_company_detail.company_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfif len(consumer_id_list)>
		<cfset consumer_id_list = listsort(consumer_id_list,"numeric","ASC",",")>
		<cfquery name="get_consumer_detail" datasource="#dsn#">
			SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME,MEMBER_CODE FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
		</cfquery>
		<cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer_detail.consumer_id,',')),'numeric','ASC',',')>
	</cfif>
</cfif>
<cfsavecontent variable="right">
	<cfoutput>
        <a href="#request.self#?fuseaction=ch.form_add_due_diff_action"><img src="/images/plus1.gif" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a>
    </cfoutput>
</cfsavecontent>
<cfif get_actions.action_type eq 1>
	<cfquery name="control_payment_row" datasource="#dsn2#">
		SELECT
			ACTION_ID
		FROM
			CARI_ACTIONS CR
		WHERE
			DUE_DIFF_ID = #attributes.due_diff_id#
			AND ACTION_ID IN(SELECT ICR.ACTION_ID FROM CARI_CLOSED_ROW ICR WHERE ICR.ACTION_ID = CR.ACTION_ID AND ICR.ACTION_TYPE_ID = CR.ACTION_TYPE_ID)
	</cfquery>
<cfelseif get_actions.action_type eq 2>
	<cfquery name="control_payment_row" datasource="#dsn3#">
		SELECT
			SUBSCRIPTION_ID
		FROM
			SUBSCRIPTION_PAYMENT_PLAN_ROW
		WHERE
			DUE_DIFF_ID = #attributes.due_diff_id#
			AND PERIOD_ID = #session.ep.period_id#
			AND (IS_PAID = 1 OR IS_BILLED =1)
	</cfquery>
<cfelseif get_actions.action_type eq 3>
	<cfquery name="control_payment_row" datasource="#dsn2#">
		SELECT
			DIFF_INVOICE_ID
		FROM
			INVOICE_CONTRACT_COMPARISON
		WHERE
			DUE_DIFF_ID = #attributes.due_diff_id#
			AND DIFF_INVOICE_ID IS NOT NULL
	</cfquery>									
</cfif>
<cf_catalystHeader>
<cf_box>
<cfform name="upd_premium_payment" method="post" action="#request.self#?fuseaction=ch.form_upd_due_diff_action">
<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
			<cf_box_elements>
	
            	<div class="col col-3 col-ms-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group">
                        <label class="col col-4 col-xs-12 bold"><cf_get_lang_main no='467.İşlem Tarihi'>:</label>
                        <label class="col col-8 col-xs-12"><cfoutput>#dateformat(get_actions.action_date,dateformat_style)#</cfoutput></label>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-12 bold"><cf_get_lang no='43.Hareket Tipi'>:</label>
                        <label class="col col-8 col-xs-12"><cfif get_actions.action_type eq 1><cf_get_lang no='42.Cari Dekont'><cfelseif get_actions.action_type eq 2><cf_get_lang no='41.Sistem Ödeme Planı'><cfelse><cf_get_lang no='39.Fatura Kontrol Satırı'></cfif></label>
                    </div>
				</div>
			</cf_box_elements>
        	<div class="ui-form-list-btn">
                <div class="col col-12">
                    <cfif len(get_actions.record_emp)>
        				<cf_get_lang_main no='71.Kayıt'> : 
						<cfoutput>#get_emp_info(get_actions.record_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,get_actions.record_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,get_actions.record_date),timeformat_style)#</cfoutput>
        			</cfif>
					<cfif control_payment_row.recordcount eq 0>
            			<cf_workcube_buttons type_format='1' 
                		is_upd='1' 
                		is_insert='0' 
                		delete_page_url = '#request.self#?fuseaction=ch.emptypopup_del_due_diff_action&due_diff_id=#attributes.due_diff_id#'>	
        			</cfif>
                 </div>
            </div>
       
</cfform>
<cf_grid_list>
    <thead>
        <tr>
            <th width="20">No</th>
            <th width="60"><cf_get_lang_main no ='146.Üye No'></th>
            <th><cf_get_lang_main no='107.Cari Hesap'></th>
            <th><cf_get_lang_main no='721.Fatura No'></th>
            <th><cf_get_lang_main no='469.Vade Tarihi'></th>
            <th style="text-align:right;"><cf_get_lang no='28.Açık Fatura'></th>
            <th width="150" style="text-align:right;"><cf_get_lang no='27.Hesaplanan Vade Farkı'></th>
            <th width="150" style="text-align:right;"><cf_get_lang no='26.Hesaplanan Vade Farkı Döviz'></th>
        </tr>
    </thead>
    <tbody>
		<cfscript>
			total_1 = 0;
			total_2 = 0;
			total_3 = 0;
		</cfscript>
		<cfoutput query="get_rows">
			<tr>
				<td>#currentrow#</td>
				<td>
					<cfif len(company_id)>
						#get_company_detail.MEMBER_CODE[listfind(company_id_list,company_id,',')]#
					<cfelse>
						#get_consumer_detail.MEMBER_CODE[listfind(consumer_id_list,consumer_id,',')]#
					</cfif>
				</td>
				<td>
					<cfif len(company_id)>
						<a href="javascript:// " onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');" class="tableyazi">
							#get_company_detail.NICKNAME[listfind(company_id_list,company_id,',')]#
						</a>
					<cfelse>
						<a href="javascript:// " onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');" class="tableyazi">
							#get_consumer_detail.CONSUMER_NAME[listfind(consumer_id_list,consumer_id,',')]#&nbsp;#get_consumer_detail.CONSUMER_SURNAME[listfind(consumer_id_list,consumer_id,',')]#
						</a>
					</cfif>				
				</td>
				<td>#paper_no#</td>
				<td>#dateformat(due_date,dateformat_style)#</td>
				<td style="text-align:right;">#tlformat(action_value)# #session.ep.money#</td>
				<td style="text-align:right;">#tlformat(due_diff_value)# #session.ep.money#</td>
				<td style="text-align:right;">#tlformat(due_diff_value/get_rate.rate2)# #get_rate.money#</td>
			</tr>
			<cfscript>
				total_1 = total_1 + due_diff_value;
				total_2 = total_2 + (due_diff_value/get_rate.rate2);
				total_3 = total_3 + action_value;
			</cfscript>
		</cfoutput>
    </tbody>
</cf_grid_list>
<div class="ui-info-bottom flex-end">
		<cfoutput>
			<p class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<b><cf_get_lang_main no ='80.Toplam'></b>&nbsp;&nbsp;
			</p>
			<p class="col col-2 col-md-2 col-sm-3 col-xs-12"><b><cf_get_lang no='28.Açık Fatura'>: </b>#tlformat(total_3)# #session.ep.money#</p>
			<p class="col col-2 col-md-2 col-sm-3 col-xs-12"><b><cf_get_lang no='27.Hesaplanan Vade Farkı'>: </b><td nowrap class="txtbold" style="text-align:right;">#tlformat(total_1)# #session.ep.money#</td></p>
			<p class="col col-2 col-md-2 col-sm-3 col-xs-12">
				<b><cf_get_lang no='26.Hesaplanan Vade Farkı Döviz'>: </b><td nowrap class="txtbold" style="text-align:right;">#tlformat(total_2)# #get_rate.money#</td>
			</p>
		</cfoutput>
</div>
</cf_box>

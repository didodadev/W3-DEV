<cfparam name="attributes.serial_number" default="">
<cfsavecontent variable="right">
<cfform name="search_barcod" action="#request.self#?fuseaction=finance.popup_add_cheque_row" method="post">
	<input type="hidden" name="store_report_id" id="store_report_id" value="<cfoutput>#attributes.store_report_id#</cfoutput>">
	<cf_get_lang_main no ='225.Seri No'>
		<input type="text" name="serial_number" id="serial_number" style="width:150px;" value="<cfoutput>#attributes.serial_number#</cfoutput>">
		<cf_wrk_search_button>
</cfform>
</cfsavecontent>
<cf_popup_box title="#getLang('finance',509)#" right_images="#right#">
	<table>
		<cfif len(attributes.serial_number)>
			<cfquery name="GET_GIFT_CHEQUE" datasource="#dsn#">
				SELECT 
					CHEQUE_PRINTS_ROWS.CHEQUE_PRINT_NUMBER,
					CHEQUE_PRINTS.COMPANY_ID,
					CHEQUE_PRINTS.CONSUMER_ID,
					CHEQUE_PRINTS.MONEY,
					CHEQUE_PRINTS.MONEY_TYPE,
					CHEQUE_PRINTS.PRINT_DATE,
					CHEQUE_PRINTS_ROWS.CHEQUE_GIFT_ROW_ID
				FROM
					CHEQUE_PRINTS,
					CHEQUE_PRINTS_ROWS
				WHERE
					CHEQUE_PRINTS.CHEQUE_ID = CHEQUE_PRINTS_ROWS.CHEQUE_PRINT_ID AND
					DAILY_REPORT_ID IS NULL
					<cfif len(attributes.serial_number)>AND CHEQUE_PRINT_NUMBER = '#attributes.serial_number#'</cfif>
			</cfquery>
			<tr>
				<td>
					<table width="100%">
						<cfif get_gift_cheque.recordcount>
							<cfoutput query="get_gift_cheque">
								<tr>
									<td class="txtboldblue" width="100"><cf_get_lang_main no ='225.Seri No'></td>
									<td><a href="#request.self#?fuseaction=finance.emptypopup_add_cheque_row&store_report_id=#attributes.store_report_id#&cheque_gift_row_id=#cheque_gift_row_id#" class="tableyazi">#get_gift_cheque.cheque_print_number#</a></td>
								</tr>
								<tr>
									<td class="txtboldblue" width="100"><cf_get_lang_main no ='246.Üye'></td>
									<td><cfif len(get_gift_cheque.company_id)>
											#get_par_info(get_gift_cheque.company_id,0,0,0)#
										<cfelseif len(get_gift_cheque.consumer_id)>
											#get_cons_info(get_gift_cheque.consumer_id,0,0)#
										</cfif>
									</td>
								</tr>
								<tr>
									<td class="txtboldblue"><cf_get_lang_main no ='261.Tutar'></td>
									<td>#tlformat(get_gift_cheque.money)# #get_gift_cheque.money_type#</td>
								</tr>
								<tr>
									<td class="txtboldblue"><cf_get_lang_main no ='330.Tarih'></td>
									<td>#dateformat(get_gift_cheque.print_date,dateformat_style)#</td>
								</tr>
							</cfoutput>
						<cfelse>
							<tr> 
								<td colspan="2"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
							</tr>
						</cfif>
					</table>
				</td>
			</tr>
		<cfelse>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</cfif>
	</table>
</cf_popup_box>
<cfif isdefined("session.operation_submitted")>
<script type="text/javascript">
		wrk_opener_reload();
	</script>
	<cfscript>
		delete_operation = structdelete(session,'operation_submitted');
	</cfscript>
</cfif>

<cfsetting showdebugoutput="no">
<cf_get_lang_set module_name="prod">
<cfquery name="GET_ORDER_RESULT" datasource="#DSN3#">
	SELECT
		PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
		PRODUCTION_ORDER_RESULTS.START_DATE,
		PRODUCTION_ORDER_RESULTS.FINISH_DATE,
		PRODUCTION_ORDER_RESULTS.RESULT_NO,
		PRODUCTION_ORDER_RESULTS.POSITION_ID,
		PRODUCTION_ORDER_RESULTS.STATION_ID,
		PRODUCTION_ORDERS_MAIN.AMOUNT QUANTITY,
			PRODUCTION_ORDERS_MAIN.PARTY_ID,
		ISNULL((SELECT
			SUM(POR_.AMOUNT) ORDER_AMOUNT
		FROM
			PRODUCTION_ORDER_RESULTS_ROW POR_,
			PRODUCTION_ORDER_RESULTS POO
		WHERE
			POR_.PR_ORDER_ID = POO.PR_ORDER_ID

				AND POO.PARTY_ID = PRODUCTION_ORDER_RESULTS.PARTY_ID
	
			AND POR_.TYPE = 1
			<!---AND POR_.SPEC_MAIN_ID IN (SELECT PRODUCTION_ORDERS.SPEC_MAIN_ID FROM PRODUCTION_ORDERS WHERE PRODUCTION_ORDERS.P_ORDER_ID = POO.P_ORDER_ID)--->
		),0) RESULT_AMOUNT
	FROM
		PRODUCTION_ORDER_RESULTS,
		TEXTILE_PRODUCTION_ORDERS_MAIN AS  PRODUCTION_ORDERS_MAIN
	WHERE
	

			PRODUCTION_ORDER_RESULTS.PARTY_ID = PRODUCTION_ORDERS_MAIN.PARTY_ID AND
			PRODUCTION_ORDERS_MAIN.PARTY_ID=#attributes.party_id#
	
	ORDER BY
		PRODUCTION_ORDER_RESULTS.FINISH_DATE DESC
</cfquery>
<div id="related_ordeR_results">
	<cf_ajax_list>
		<thead>
			<tr>
				<th width="40"><cf_get_lang no='449.Sonuç No'></th>
				<th width="130" nowrap><cf_get_lang_main no='330.Tarih'></th>
				<th width="110"><cf_get_lang no='452.İşlemi Yapan'></th>
				<th width="130"><cf_get_lang_main no='1422.İstasyon'></th>
				<th><cf_get_lang no='163.Çıktılar'></th>
				<th width="15">
					<cfif GET_ORDER_RESULT.recordcount and (GET_ORDER_RESULT.result_amount lt GET_ORDER_RESULT.QUANTITY)>
						<a style="cursor:pointer;" onClick="add_p_order_result('<cfoutput>#attributes.party_id#</cfoutput>')"><img src="/images/plus_list.gif" align="absmiddle" border="0"/></a>
					<cfelseif not GET_ORDER_RESULT.recordcount>
						<a style="cursor:pointer;" onClick="add_p_order_result('<cfoutput>#attributes.party_id#</cfoutput>')"><img src="/images/plus_list.gif" align="absmiddle" border="0"/></a>
					</cfif>
				</th>
			</tr>
		</thead>
		<tbody>
			<script type="text/javascript">
				function add_p_order_result(party_id){
					if(<cfoutput>'#attributes.date_control#'</cfoutput> == 1)
						window.location.href ='<cfoutput>#request.self#</cfoutput>?fuseaction=textile.list_results&event=add&party_id='+party_id+'';
					else
						alert('Sonuç Girmek İçin Başlangıç ve Bitiş Tarihlerini Giriniz!');	
				}
			</script>
			<cfoutput query="get_order_result">
				<tr>
					<td><a href="#request.self#?fuseaction=textile.list_results&event=upd&party_id=#attributes.party_id#&pr_order_id=#pr_order_id#" class="tableyazi">#result_no#</a></td>
					<td>#dateformat(start_date,'dd/mm/yyyy')# #timeformat(start_date,'HH:mm')# - #dateformat(finish_date,'dd/mm/yyyy')# #timeformat(finish_date,'HH:mm')#</td>
					<td>#get_emp_info(position_id,0,1)#</td>
					<td>
						<cfif len(station_id)>
							<cfquery name="GET_STATION" datasource="#DSN3#">
								SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = #station_id#
							</cfquery>
							#get_station.station_name#
						</cfif>
					</td>
					<td>
					<cfquery name="GET_ROW_ENTER" datasource="#DSN3#">
						SELECT * FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = #get_order_result.pr_order_id# AND TYPE = 1
					</cfquery>
					<table>
						<cfloop query="GET_ROW_ENTER">
							<tr>
								<td style="width:250px;"><b><cf_get_lang_main no='40.Stok'> : </b>#get_row_enter.name_product#&nbsp;&nbsp;</td>
								<td><b><cf_get_lang_main no='223.Miktar'> : </b> #TlFormat(get_row_enter.amount,3)#&nbsp;#get_row_enter.unit_name#</td>
							</tr>
						</cfloop>
					</table>
					</td>
					<td>
					<a href="#request.self#?fuseaction=textile.list_results&event=upd&party_id=#party_id#&pr_order_id=#pr_order_id#"><img src="/images/update_list.gif" align="absmiddle" border="0"/></a></td>
				</tr>
			</cfoutput>
		</tbody>
	</cf_ajax_list>
</div>
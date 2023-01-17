<cfsavecontent variable="ay1"><cf_get_lang dictionary_id='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id='57593.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id='57596.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id='57599.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id='57602.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id='57603.Aralık'></cfsavecontent>
<cfset aylar = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
<cfset type_index = 'GET_SALES_TOTAL,GET_STOCKS_TOTAL,GET_CARI_TOTAL,GET_CREDIT_TOTAL,GET_CASH_TOTAL,GET_INVENTORY_TOTAL'>
<cfparam name="attributes.startdate" default="1">
<cfparam name="attributes.finishdate" default="1">
<cfparam name="attributes.time_type" default="0"><!--- ay bazında --->
<cfparam name="attributes.summery_type" default="">
<cfparam name="attributes.period_type" default="">
<cfset tarih_farki =0>
<cfset old_day_number =0>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent  variable="head"><cf_get_lang dictionary_id="57983.EKG"></cfsavecontent>
	<cf_box>
		<cfform name="form_report" action="#request.self#?fuseaction=report.company_ekg" method="post">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cf_box_search more="0">
				<div class="form-group">
					<select name="startdate" id="startdate">
						<cfloop from="1" to="12" index="sd">
							<cfoutput><option value="#sd#" <cfif attributes.startdate eq sd>selected</cfif>>#Evaluate("ay#sd#")#</option></cfoutput>
						</cfloop>
					</select>
				</div>
				<div class="form-group">
					<select name="finishdate" id="finishdate">
					<cfloop from="1" to="12" index="fd">
						<cfoutput><option value="#fd#" <cfif attributes.finishdate eq fd>selected</cfif>>#Evaluate("ay#fd#")#</option></cfoutput>
					</cfloop>
					</select>
				</div>
				<div class="form-group">
					<select name="time_type" id="time_type">
						<option value=""><cf_get_lang dictionary_id ='57497.Zaman Dilimi'></option>
					<option value="0" <cfif attributes.time_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58724.Ay'></option>
					<option value="1" <cfif attributes.time_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57490.Gün'></option>					
					</select>
				</div>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
					<cf_wrk_search_button button_type='4' is_excel="0" insert_info=' #message# ' search_function='control()'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>   
	<cf_box title="#head#">    
		<cfif isdefined('is_submitted')>
			<cfif attributes.time_type><!--- gün bazında --->
				<cfif attributes.startdate eq attributes.finishdate>
					<cfset tarih_farki = DaysInMonth(CreateDate(session.ep.period_year,attributes.startdate,1))>
				<cfelse>
					<cfloop from="#attributes.startdate#" to="#attributes.finishdate#" index="index_x">
						<cfset tarih_farki = tarih_farki + DaysInMonth(CreateDate(session.ep.period_year,index_x,1))>
					</cfloop>
				</cfif>
			<cfelse> <!--- ay bazında--->
				<cfset tarih_farki = (attributes.finishdate-attributes.startdate)>
			</cfif>
			<cfif isdefined('is_submitted')>
				<cfset month_list = ''>
				<cfif attributes.time_type eq 0><!--- ay --->
					<cfloop from="#attributes.startdate#" to="#attributes.startdate+tarih_farki#" index="i">
						<cfset month_list=listappend(month_list,i)>
					</cfloop>
				<cfelseif attributes.time_type eq 1><!--- gün bazında --->
					<cfloop from="#attributes.startdate#" to="#attributes.finishdate#" index="xx">
						<cfset month_list=listappend(month_list,xx)>
					</cfloop>
				</cfif>
				<!--- satış tutarları --->
				<cfquery name="GET_SALES_TOTAL" datasource="#dsn2#">
					SELECT
					<cfif attributes.time_type eq 0>
						DATEPART(MM,INVOICE_DATE) AY,
					<cfelse>
						DATEPART(MM,INVOICE_DATE) AY,
						DATEPART(DD,INVOICE_DATE) GUN,
					</cfif>
						SUM(NET_SALE) AS BAKIYE
					FROM
						DAILY_TOTAL_SALES
					WHERE
						MONTH(INVOICE_DATE) >= #attributes.startdate# AND 
						MONTH(INVOICE_DATE) < #attributes.finishdate+1#
					GROUP BY
					<cfif attributes.time_type eq 0>
						DATEPART(MM,INVOICE_DATE)
					<cfelse>
						DATEPART(MM,INVOICE_DATE),
						DATEPART(DD,INVOICE_DATE)
					</cfif>
				</cfquery>
				<!--- stok miktarları --->
				<cfquery name="GET_STOCKS_TOTAL" datasource="#dsn2#">
					SELECT
					<cfif attributes.time_type eq 0>
						DATEPART(MM,PROCESS_DATE) AY,
						SUM(AMOUNT) BAKIYE
					<cfelse>
						DATEPART(MM,PROCESS_DATE) AY,
						DATEPART(DD,PROCESS_DATE) GUN,
						AMOUNT BAKIYE
					</cfif>
					FROM
					<cfif attributes.time_type eq 0>
						DAILY_STOCKS
					<cfelse>
						DAILY_TOTAL_STOCKS
					</cfif>
					WHERE
						<!--- MONTH(PROCESS_DATE) >= #attributes.startdate# AND --->
						MONTH(PROCESS_DATE) < #attributes.finishdate+1#
					<cfif attributes.time_type eq 0><!--- aylık bazda  --->
					GROUP BY
						DATEPART(MM,PROCESS_DATE)
					</cfif>
					<cfif attributes.time_type eq 1> <!--- gunluk bazda --->
					ORDER BY
						DATEPART(MM,PROCESS_DATE) DESC,
						DATEPART(DD,PROCESS_DATE) DESC
					</cfif>
				</cfquery>
				<!--- cari borc-alacak toplamları  --->
				<cfquery name="GET_CARI_TOTAL" datasource="#dsn2#">
					SELECT
					<cfif attributes.time_type eq 0>
						DATEPART(MM,ACTION_DATE) AY,
						SUM(BAKIYE) BAKIYE
					<cfelse>
						DATEPART(MM,ACTION_DATE) AY,
						DATEPART(DD,ACTION_DATE) GUN,
						BAKIYE
					</cfif>
					FROM
					<cfif attributes.time_type eq 0>
						DAILY_CARI_REMAINDER
					<cfelse>
						DAILY_TOTAL_CARI_REMAINDER
					</cfif>
					WHERE
						<!--- MONTH(ACTION_DATE) >= #attributes.startdate# AND --->
						MONTH(ACTION_DATE) < #attributes.finishdate+1#
					<cfif attributes.time_type eq 0><!--- aylık bazda  --->
					GROUP BY
						DATEPART(MM,ACTION_DATE)
					</cfif>
					<cfif attributes.time_type eq 1> <!--- gunluk bazda --->
					ORDER BY
						DATEPART(MM,ACTION_DATE) DESC,
						DATEPART(DD,ACTION_DATE) DESC
					</cfif>
				</cfquery>
				<!--- kredi tahsilatlar- ödemeler toplamları --->
				<cfquery name="GET_CREDIT_TOTAL" datasource="#dsn2#">
					SELECT
					<cfif attributes.time_type eq 0>
						DATEPART(MM,PROCESS_DATE) AY,
						SUM(BAKIYE) BAKIYE
					<cfelse>
						DATEPART(MM,PROCESS_DATE) AY,
						DATEPART(DD,PROCESS_DATE) GUN,
						BAKIYE
					</cfif>
					FROM
					<cfif attributes.time_type eq 0>
						DAILY_CREDIT
					<cfelse>
						DAILY_TOTAL_CREDIT
					</cfif>
					WHERE
						<!--- MONTH(PROCESS_DATE) >= #attributes.startdate# AND --->
						MONTH(PROCESS_DATE) < #attributes.finishdate+1#
					<cfif attributes.time_type eq 0><!--- aylık bazda  --->
					GROUP BY
						DATEPART(MM,PROCESS_DATE)
					</cfif>
					<cfif attributes.time_type eq 1> <!--- gunluk bazda --->
					ORDER BY
						DATEPART(MM,PROCESS_DATE) DESC,
						DATEPART(DD,PROCESS_DATE) DESC
					</cfif>
				</cfquery>
				<!--- kasa ve bankadaki nakit miktarı --->
				<cfquery name="GET_CASH_TOTAL" datasource="#dsn2#">
					SELECT
					<cfif attributes.time_type eq 0>
						DATEPART(MM,ACTION_DATE) AY,
						SUM(BAKIYE) BAKIYE
					<cfelse>
						DATEPART(MM,ACTION_DATE) AY,
						DATEPART(DD,ACTION_DATE) GUN,
						BAKIYE
					</cfif>
					FROM
					<cfif attributes.time_type eq 0>
						DAILY_EFFECTIVE_MONEY
					<cfelse>
						DAILY_TOTAL_EFFECTIVE_MONEY
					</cfif>
					WHERE
						<!--- MONTH(ACTION_DATE) >= #attributes.startdate# AND --->
						MONTH(ACTION_DATE) < #attributes.finishdate+1#
					<cfif attributes.time_type eq 0><!--- aylık bazda  --->
					GROUP BY
						DATEPART(MM,ACTION_DATE)
					</cfif>
					<cfif attributes.time_type eq 1> <!--- gunluk bazda --->
					ORDER BY
						DATEPART(MM,ACTION_DATE) DESC,
						DATEPART(DD,ACTION_DATE) DESC
					</cfif>
				</cfquery>
				<!--- sabit kıymet --->
				<cfquery name="GET_INVENTORY_TOTAL" datasource="#dsn3#">
					SELECT
					<cfif attributes.time_type eq 0>
						DATEPART(MM,ENTRY_DATE) AY,
						SUM(LAST_INVENTORY_VALUE) BAKIYE
					<cfelse>
						DATEPART(MM,ENTRY_DATE) AY,
						DATEPART(DD,ENTRY_DATE) GUN,
						LAST_INVENTORY_VALUE BAKIYE
					</cfif>
					FROM
					<cfif attributes.time_type eq 0>
						DAILY_INVENTORIES
					<cfelse>
						DAILY_TOTAL_INVENTORIES
					</cfif>
					WHERE
						MONTH(ENTRY_DATE) < #attributes.finishdate+1# AND
						YEAR(ENTRY_DATE) = #session.ep.period_year#
					<cfif attributes.time_type eq 0><!--- aylık bazda  --->
					GROUP BY
						DATEPART(MM,ENTRY_DATE)
					</cfif>
					<cfif attributes.time_type eq 1> <!--- gunluk bazda --->
					ORDER BY
						DATEPART(MM,ENTRY_DATE) DESC,
						DATEPART(DD,ENTRY_DATE) DESC
					</cfif>
				</cfquery>
				<cfloop list="#month_list#" index="month_index">
					<cfloop list="#type_index#" index="tt_index">
					<cfset 'kumulatif_deger_#tt_index#' = 0>
					<!--- <cfset 'kumulatif_degerin_gunu_#tt_index#' = 0> --->
						<cfif attributes.time_type eq 0>
							<cfif tt_index is not 'GET_SALES_TOTAL'>
								<cfoutput query="#tt_index#">
									<cfif BAKIYE contains 'E'><cfset bakiye_new = 0><cfelse><cfset bakiye_new = BAKIYE></cfif>
									<cfif (AY lte month_index)>
										<cfif isdefined('alan_#tt_index#_#month_index#') and len(evaluate('alan_#tt_index#_#month_index#'))>
											<cfset 'alan_#tt_index#_#month_index#' = evaluate('alan_#tt_index#_#month_index#') + bakiye_new>
										<cfelse>
											<cfset 'alan_#tt_index#_#month_index#' = bakiye_new>
										</cfif>
									</cfif>
								</cfoutput>
							<cfelse>
								<cfoutput query="#tt_index#">
									<cfif (AY eq month_index)>
										<cfset 'alan_#tt_index#_#month_index#' = BAKIYE>
									</cfif>
								</cfoutput>
							</cfif>
						<cfelse> <!--- gun bazında --->
							<cfoutput query="#tt_index#">	
								<cfif BAKIYE contains 'E'><cfset bakiye_new = 0><cfelse><cfset bakiye_new = BAKIYE></cfif>
								<cfif AY eq month_index>
									<cfset 'alan_#tt_index#_#month_index#_#GUN#' = bakiye_new>
								<cfelseif AY lt (listfirst(month_list)) and evaluate('kumulatif_deger_#tt_index#') eq 0><!--- secilen aydan onceki en kucuk deger kumulatif baslangıc degeri olarak set edilir, eger secilen aylar icinde kayıt yoksa bu kumulatif deger tasınır --->
									<cfset 'kumulatif_deger_#tt_index#' = bakiye_new>
								</cfif>					
							</cfoutput>
						</cfif>
					</cfloop>
				</cfloop>
					<div class="col col-10 col-md-10 col-sm-8 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></cfsavecontent>
						<cfsavecontent variable="message2"><cf_get_lang dictionary_id='38794.Değer'></cfsavecontent>
							<script src="JS/Chart.min.js"></script>
                            <canvas id="myChart1" style="float:left;"></canvas>
                            <script>
								var ctx = document.getElementById('myChart1');
								
								<cfif attributes.time_type><!--- gun bazında --->
								var data = {
									labels : [<cfset old_day_number=0><cfset month_day_list=''><cfset temp_value = 0>
												<cfloop list="#month_list#" index="month_ii">
													<cfset month_day_list=DaysInMonth(CreateDate(session.ep.period_year,month_ii,1))>
													<cfif len(month_day_list)>
														<cfloop from="1" to="#month_day_list#" index="day_ii"> 
															<cfoutput>#old_day_number+day_ii#</cfoutput>,
														</cfloop>
														<cfset old_day_number += month_day_list>
													</cfif>
												</cfloop>
											],
									datasets: [<cfloop list="#type_index#" index="xx_index">
										{
											label:"<cfif xx_index eq 'GET_SALES_TOTAL'>
														<cf_get_lang dictionary_id ='39129.Satış Tutarı'>
													<cfelseif xx_index eq 'GET_STOCKS_TOTAL'>
														<cf_get_lang dictionary_id ='38737.Stok Durumu'>
													<cfelseif xx_index eq 'GET_CARI_TOTAL'>
														<cf_get_lang dictionary_id ='40443.Borc-Alacak Bakıye'>
													<cfelseif xx_index eq 'GET_CREDIT_TOTAL'>
														<cf_get_lang dictionary_id ='40442.Krediler'>
													<cfelseif xx_index eq 'GET_CASH_TOTAL'>
														<cf_get_lang dictionary_id ='40441.Nakit Tutar'>
													<cfelseif xx_index eq 'GET_INVENTORY_TOTAL'>
														<cf_get_lang dictionary_id ='40440.Sabit Kıymet Tutarı'>
													</cfif>",
											fill: false,
											lineTension: 0.1,
											backgroundColor: "rgba(225,0,0,0.4)",
											borderColor: [<cfloop list="#type_index#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>], // The main line color
											data: [<cfloop list="#month_list#" index="month_ii"><cfloop from="1" to="#month_day_list#" index="day_ii">
													<cfif isdefined('alan_#xx_index#_#month_ii#_#day_ii#') and len(evaluate('alan_#xx_index#_#month_ii#_#day_ii#'))>
														<cfoutput>#wrk_round(evaluate('alan_#xx_index#_#month_ii#_#day_ii#'))#</cfoutput>
													<cfelseif month_ii eq listfirst(month_list) and day_ii eq 1 and isdefined('kumulatif_deger_#xx_index#') and len(evaluate('kumulatif_deger_#xx_index#'))>
														<cfoutput>#wrk_round(evaluate('kumulatif_deger_#xx_index#'))#</cfoutput>
													<cfelseif xx_index eq 'GET_SALES_TOTAL'>0
													</cfif>,</cfloop></cfloop><cfset old_day_number += month_day_list>],
											spanGaps: true,
										}, </cfloop>
									]
								};
								<cfelse>
								var data = {
									labels: [<cfloop list="#month_list#" index="month_ii"><cfoutput>'#listgetat(aylar,month_ii,',')#'</cfoutput>,</cfloop>],
									datasets: [<cfloop list="#type_index#" index="xx_index">
										{
											label:"<cfif xx_index eq 'GET_SALES_TOTAL'>
														<cf_get_lang dictionary_id ='39129.Satış Tutarı'>
												   <cfelseif xx_index eq 'GET_STOCKS_TOTAL'>
														<cf_get_lang dictionary_id ='38737.Stok Durumu'>
													<cfelseif xx_index eq 'GET_CARI_TOTAL'>
														<cf_get_lang dictionary_id ='40443.Borc-Alacak Bakıye'>
													<cfelseif xx_index eq 'GET_CREDIT_TOTAL'>
														<cf_get_lang dictionary_id ='40442.Krediler'>
													<cfelseif xx_index eq 'GET_CASH_TOTAL'>
														<cf_get_lang dictionary_id ='40441.Nakit Tutar'>
													<cfelseif xx_index eq 'GET_INVENTORY_TOTAL'>
														<cf_get_lang dictionary_id ='40440.Sabit Kıymet Tutarı'>
													</cfif>",
											fill: false,
											lineTension: 0.1,
											backgroundColor: [<cfloop list="#type_index#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
											borderColor: [<cfloop list="#type_index#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>], // The main line color
											borderCapStyle: 'square',
											borderDash: [], // try [5, 15] for instance
											borderDashOffset: 0.0,
											borderJoinStyle: 'miter',
											pointBorderColor: "black",
											pointBackgroundColor: "white",
											pointBorderWidth: 1,
											pointHoverRadius: 8,
											pointHoverBackgroundColor: "orange",
											pointHoverBorderColor: "brown",
											pointHoverBorderWidth: 2,
											pointRadius: 4,
											pointHitRadius: 10,
											data: [<cfloop list="#month_list#" index="month_ii"><cfif isdefined('alan_#xx_index#_#month_ii#') and len(evaluate('alan_#xx_index#_#month_ii#'))><cfoutput>#wrk_round(evaluate('alan_#xx_index#_#month_ii#'))#</cfoutput><cfelseif xx_index eq 'GET_SALES_TOTAL'>0</cfif>,</cfloop>],
											spanGaps: true,
									  }, </cfloop>
									]
								  };
								</cfif>

								  // Notice the scaleLabel at the same level as Ticks
								var options = {
									scales: {
											yAxes: [{
												ticks: {
													beginAtZero:true,
													userCallback: function(value, index, values) {
														// Convert the number to a string and splite the string every 3 charaters from the end
														value = value.toString();
														value = value.split(/(?=(?:...)*$)/);
														
														// Convert the array to a string and format the output
														value = value.join('.');
														return value;
														}
												},
												scaleLabel: {
													display: true,
													labelString: '<cfoutput>#message2#</cfoutput>',
													fontSize: 20 
													}
											}],
											xAxes:[{
												ticks: {
													beginAtZero:true
												},
												scaleLabel: {
													display: true,
													labelString: '<cfoutput>#message#</cfoutput>',
													fontSize: 20 
													}
											}]         
										},
									tooltips: {
										callbacks: {
											label : function(tooltipItem, data){
												return data.datasets[tooltipItem.datasetIndex].label + ': '+ tooltipItem.yLabel.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
											}
										}
									}
								};

                                var myChart1 = new Chart(ctx, {
                                    type: 'line',
                                    data: data,
									options: options
                                });
                            </script>
						</div>			
			</cfif>
      	</cfif>
	</cf_box>
</div>
<script type="text/javascript">
function control()
{	
	if(form_report.time_type.value == "")
	{
		alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='57497.Zaman Dilimi'>");
		return false;
	}
	else
		return true;
}
</script>

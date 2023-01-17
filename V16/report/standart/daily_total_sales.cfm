<cfparam name="attributes.module_id_control" default="20,11">
<cfinclude template="report_authority_control.cfm">
<cfsavecontent variable="message13"><cf_get_lang dictionary_id ='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="message2"><cf_get_lang dictionary_id ='57593.Şubat'></cfsavecontent>
<cfsavecontent variable="message3"><cf_get_lang dictionary_id ='57594.Mart'></cfsavecontent>
<cfsavecontent variable="message4"><cf_get_lang dictionary_id ='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="message5"><cf_get_lang dictionary_id ='57596.Mayıs'></cfsavecontent>
<cfsavecontent variable="message6"><cf_get_lang dictionary_id ='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="message7"><cf_get_lang dictionary_id ='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="message8"><cf_get_lang dictionary_id ='57599.Ağustos'></cfsavecontent>
<cfsavecontent variable="message9"><cf_get_lang dictionary_id ='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="message10"><cf_get_lang dictionary_id ='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="message11"><cf_get_lang dictionary_id ='57602.Kasım'></cfsavecontent>
<cfsavecontent variable="message12"><cf_get_lang dictionary_id ='57603.Aralık'></cfsavecontent>
<cfset aylar = "#message13#,#message2#,#message3#,#message4#,#message5#,#message6#,#message7#,#message8#,#message9#,#message10#,#message11#,#message12#">
<cfset type_index = 'NET_SALE,NET_SALE_OTHER_MONEY,TOTAL_SALE,TOTAL_SALE_OTHER_MONEY,INVOICE_SALE_RATIO,INVOICE_COUNT,INVOICE_ROW_COUNT,STOCK_UNIQUE_COUNT,AMOUNT,TOTAL_COST,TOTAL_COST_OTHER_MONEY'>
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.time_type" default="">
<cfparam name="attributes.summery_type" default="">
<cfparam name="attributes.period_type" default="">
<cfparam name="attributes.is_excel" default="">
<cfform name="form_report" action="#request.self#?fuseaction=report.daily_total_sales" method="post">
<input type="hidden" name="is_submitted" id="is_submitted" value="1">
  <cfsavecontent variable="title"><cf_get_lang dictionary_id='40309.Satışlar Özet Raporu'></cfsavecontent>
  <cf_report_list_search title="#title#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'>*</label>
										<div class="col col-6">
											<select name="startdate" id="startdate" style="width:90px;">
												<option value="1" <cfif attributes.startdate eq 1>selected</cfif>><cf_get_lang dictionary_id ='57592.Ocak'></option>
												<option value="2" <cfif attributes.startdate eq 2>selected</cfif>><cf_get_lang dictionary_id ='57593.Şubat'></option>
												<option value="3" <cfif attributes.startdate eq 3>selected</cfif>><cf_get_lang dictionary_id ='57594.Mart'></option>
												<option value="4" <cfif attributes.startdate eq 4>selected</cfif>><cf_get_lang dictionary_id ='57595.Nisan'></option>
												<option value="5" <cfif attributes.startdate eq 5>selected</cfif>><cf_get_lang dictionary_id ='57596.Mayıs'></option>
												<option value="6" <cfif attributes.startdate eq 6>selected</cfif>><cf_get_lang dictionary_id ='57597.Haziran'></option>
												<option value="7" <cfif attributes.startdate eq 7>selected</cfif>><cf_get_lang dictionary_id ='57598.Temmuz'></option>
												<option value="8" <cfif attributes.startdate eq 8>selected</cfif>><cf_get_lang dictionary_id ='57599.Ağustos'></option>
												<option value="9" <cfif attributes.startdate eq 9>selected</cfif>><cf_get_lang dictionary_id ='57600.Eylül'></option>
												<option value="10" <cfif attributes.startdate eq 10>selected</cfif>><cf_get_lang dictionary_id ='57601.Ekim'></option>
												<option value="11" <cfif attributes.startdate eq 11>selected</cfif>><cf_get_lang dictionary_id ='57602.Kasım'></option>
												<option value="12" <cfif attributes.startdate eq 12>selected</cfif>><cf_get_lang dictionary_id ='57603.Aralık'></option>
											</select>
										</div>
										<div class="col col-6">
											<select name="finishdate" id="finishdate" style="width:90px;" <cfif attributes.time_type eq 1>disabled</cfif>>
												<option value="1" <cfif attributes.finishdate eq 1>selected</cfif>><cf_get_lang dictionary_id ='57592.Ocak'></option>
												<option value="2" <cfif attributes.finishdate eq 2>selected</cfif>><cf_get_lang dictionary_id ='57593.Şubat'></option>
												<option value="3" <cfif attributes.finishdate eq 3>selected</cfif>><cf_get_lang dictionary_id ='57594.Mart'></option>
												<option value="4" <cfif attributes.finishdate eq 4>selected</cfif>><cf_get_lang dictionary_id ='57595.Nisan'></option>
												<option value="5" <cfif attributes.finishdate eq 5>selected</cfif>><cf_get_lang dictionary_id ='57596.Mayıs'></option>
												<option value="6" <cfif attributes.finishdate eq 6>selected</cfif>><cf_get_lang dictionary_id ='57597.Haziran'></option>
												<option value="7" <cfif attributes.finishdate eq 7>selected</cfif>><cf_get_lang dictionary_id ='57598.Temmuz'></option>
												<option value="8" <cfif attributes.finishdate eq 8>selected</cfif>><cf_get_lang dictionary_id ='57599.Ağustos'></option>
												<option value="9" <cfif attributes.finishdate eq 9>selected</cfif>><cf_get_lang dictionary_id ='57600.Eylül'></option>
												<option value="10" <cfif attributes.finishdate eq 10>selected</cfif>><cf_get_lang dictionary_id ='57601.Ekim'></option>
												<option value="11" <cfif attributes.finishdate eq 11>selected</cfif>><cf_get_lang dictionary_id ='57602.Kasım'></option>
												<option value="12" <cfif attributes.finishdate eq 12>selected</cfif>><cf_get_lang dictionary_id ='57603.Aralık'></option>
											</select>
										</div>
									</div>	
									<div class="form-group">
										<div class="col col-6">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57497.Zaman dilimi'>*</label>
											<select name="time_type" id="time_type" style="width:90px;" onchange="change_month();">
												<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
												<option value="1" <cfif attributes.time_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57490.Gün'></option>
												<option value="2" <cfif attributes.time_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58724.Ay'></option>	
											</select>
										</div>
										<div class="col col-6">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57630.Tip'></label>
											<select name="summery_type" id="summery_type" style="width:90px;" onchange="change_month();">
												<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
												<option value="1" <cfif attributes.summery_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='57453.Şube'></option>
												<option value="2" <cfif attributes.summery_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='57492.Toplam'></option>					
											</select>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
							<input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'>
                            <input name="is_form_submited" id="is_form_submited" type="hidden" value="1">
							<cf_wrk_report_search_button button_type='1' search_function='control()' is_excel='1'>					
					    </div>	  
					</div>
				</div>
			</div>
        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">	
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = (((attributes.page-1)*attributes.maxrows)) + 1>
<cfif isDefined("attributes.is_form_submited")>
	<cf_report_list>
		<cfif attributes.time_type eq 1><!--- gün bazında --->
			<cfset tarih_farki = DaysInMonth(CreateDate(session.ep.period_year,attributes.startdate,1))>
		<cfelseif attributes.time_type eq 2><!--- ay --->
			<cfset tarih_farki = (attributes.finishdate-attributes.startdate)>
		</cfif>
			<cfif len(attributes.is_submitted)>
				<cfset month_list = ''>
				<cfif attributes.time_type eq 2><!--- ay --->
					<cfloop from="#attributes.startdate#" to="#attributes.startdate+tarih_farki#" index="i">
						<cfset month_list=listappend(month_list,i)>
					</cfloop>
				<cfelseif attributes.time_type eq 1><!--- gün bazında --->
					<cfloop from="1" to="#tarih_farki#" index="gg">
						<cfset month_list=listappend(month_list,gg)>
					</cfloop>
				</cfif>
				<cfquery name="GET_SALES_TOTAL" datasource="#dsn2#">
					SELECT
						<cfif attributes.time_type eq 2>
							DATEPART(MM,INVOICE_DATE) AY,
						<cfelse>
							DATEPART(DD,INVOICE_DATE) AY,
						</cfif>
						<cfif attributes.summery_type eq 1>
							B.BRANCH_ID,
							B.BRANCH_NAME,	
						</cfif>
						SUM(NET_SALE) NET_SALE,
						SUM(NET_SALE_OTHER_MONEY) NET_SALE_OTHER_MONEY,
						SUM(TOTAL_SALE) TOTAL_SALE,
						SUM(TOTAL_SALE_OTHER_MONEY) TOTAL_SALE_OTHER_MONEY,
						(SUM(NET_SALE)/SUM(INVOICE_COUNT)) INVOICE_SALE_RATIO,
						SUM(INVOICE_COUNT) INVOICE_COUNT,
						SUM(INVOICE_ROW_COUNT + INVOICE_POS_ROW_COUNT) INVOICE_ROW_COUNT,
						SUM(STOCK_UNIQUE_COUNT) STOCK_UNIQUE_COUNT,
						SUM(AMOUNT) AMOUNT,
						SUM(TOTAL_COST) TOTAL_COST,
						SUM(TOTAL_COST_OTHER_MONEY) TOTAL_COST_OTHER_MONEY
					FROM
						DAILY_TOTAL_SALES DTS
						<cfif attributes.summery_type eq 1>
							,#dsn_alias#.BRANCH B
						</cfif>
					WHERE
						<cfif attributes.time_type eq 2>
							MONTH(INVOICE_DATE) >= #attributes.startdate# AND 
							MONTH(INVOICE_DATE) < #attributes.finishdate+1#
						<cfelse>
							MONTH(INVOICE_DATE) = #attributes.startdate#
						</cfif>
						<cfif attributes.summery_type eq 1>
							AND DTS.BRANCH_ID=B.BRANCH_ID
						</cfif>	
					GROUP BY
						<cfif attributes.summery_type eq 1>
							B.BRANCH_ID,
							B.BRANCH_NAME,	
						</cfif>
						<cfif attributes.time_type eq 2>
							DATEPART(MM,INVOICE_DATE)
						<cfelse>
							DATEPART(DD,INVOICE_DATE)
						</cfif>
				</cfquery>
				<cfif attributes.summery_type eq 1> <!---sube bazında tarih aralıgına baglı olarak toplamlar olusturuluyor--->
					<cfparam name="attributes.totalrecords" default="#GET_SALES_TOTAL.recordcount#">
					<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
						<cfset attributes.startrow=1>
						<cfset attributes.maxrows=GET_SALES_TOTAL.recordcount>
					</cfif>
					<cfset branch_name_list=ListDeleteDuplicates(valuelist(GET_SALES_TOTAL.BRANCH_NAME))>
					<cfset branch_id_list=ListDeleteDuplicates(valuelist(GET_SALES_TOTAL.BRANCH_ID))>
					<cfloop list="#branch_id_list#" index="branch_index">
						<cfloop list="#month_list#" index="month_index">
							<cfoutput query="GET_SALES_TOTAL" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
								<cfif AY eq month_index and BRANCH_ID eq branch_index>
									<cfloop list="#type_index#" index="tt_index">
										<cfset 'alan_#tt_index#_#month_index#_#branch_index#' = evaluate(tt_index)>
									</cfloop>
								</cfif>
							</cfoutput>
						</cfloop>
					</cfloop>
				<cfelse>
					<cfset branch_name_list = ''>
					<cfset branch_id_list=''>
					<cfloop list="#month_list#" index="month_index">
						<cfoutput query="GET_SALES_TOTAL">
							<cfif (AY eq month_index)>
								<cfloop list="#type_index#" index="tt_index">
									<cfset 'alan_#tt_index#_#month_index#' = evaluate(tt_index)>
								</cfloop>
							</cfif>
						</cfoutput>
					</cfloop>
				</cfif>
				<cfif attributes.summery_type eq 1><!--- sube bazında --->
			  	<thead>
						<tr>
							<th class="txtbold">&nbsp;</th>
							<cfoutput>
								<cfif attributes.time_type eq 1>
									<cfloop from="1" to="#tarih_farki#" index="tt">
										<th style="text-align:center;" class="txtbold" colspan='#listlen(type_index)#'>#tt#</th>
									</cfloop>
								<cfelse>
									<cfloop from="0" to="#tarih_farki#" index="kk">
										<th style="text-align:center;" class="txtbold" colspan='#listlen(type_index)#'>#listgetat(aylar,(attributes.startdate+kk),',')#</th>
									</cfloop>
								</cfif>
								<th style="text-align:center;" class="txtbold" colspan='#listlen(type_index)#'><font color="##FF0000"><cf_get_lang dictionary_id ='40302.Toplamlar'></font></th>
							</cfoutput>
						</tr>
						<cfoutput>
							<tr>
							<th class="txtbold"><cf_get_lang dictionary_id ='40307.İşlem Tipleri'></th>
							<cfif attributes.time_type eq 1><cfset start_number = 1><cfelse><cfset start_number = 0></cfif>
							<cfloop from="#start_number#" to="#tarih_farki#" index="tt">
								<cfloop list="#type_index#" index="t_ind">
									<th style="text-align:center;" class="txtbold">
										<cfif t_ind is 'NET_SALE'><cf_get_lang dictionary_id='57448.Satış'><cf_get_lang dictionary_id='58083.Net'><br/>(#session.ep.money#)
										<cfelseif t_ind is 'NET_SALE_OTHER_MONEY'><cf_get_lang dictionary_id='57448.Satış'><cf_get_lang dictionary_id='58083.Net'><br/>(#session.ep.money2#)
										<cfelseif t_ind is 'TOTAL_SALE'><cf_get_lang dictionary_id='57448.Satış'><cf_get_lang dictionary_id='58716.Kdv li'><br/>(#session.ep.money#)
										<cfelseif t_ind is 'TOTAL_SALE_OTHER_MONEY'><cf_get_lang dictionary_id='57448.Satış'><cf_get_lang dictionary_id='58716.Kdv li'><br/>(#session.ep.money2#)
										<cfelseif t_ind is 'INVOICE_SALE_RATIO'><cf_get_lang dictionary_id ='57441.Fatura'><cf_get_lang dictionary_id ='58601.Bazında'><cf_get_lang dictionary_id ='57448.Satış'>(#session.ep.money#)
										<cfelseif t_ind is 'INVOICE_COUNT'><cf_get_lang dictionary_id ='40304.Fatura Adedi'>
										<cfelseif t_ind is 'INVOICE_ROW_COUNT'><cf_get_lang dictionary_id ='40305.Fatura Satırı'>
										<cfelseif t_ind is 'STOCK_UNIQUE_COUNT'><cf_get_lang dictionary_id ='40306.Çeşit Sayısı'>
										<cfelseif t_ind is 'AMOUNT'><cf_get_lang dictionary_id ='57492.Toplam'><br/><cf_get_lang dictionary_id ='57635.Miktar'>
										<cfelseif t_ind is 'TOTAL_COST'><cf_get_lang dictionary_id='58258.Maliyet'><br/>(#session.ep.money#)
										<cfelseif t_ind is 'TOTAL_COST_OTHER_MONEY'><cf_get_lang dictionary_id='58258.Maliyet'><br/>(#session.ep.money2#)
										</cfif>
									</th>
								</cfloop>
							</cfloop>
							<cfloop list="#type_index#" index="total_ind">
								<th style="text-align:center;" class="txtbold"><font color="##FF0000">
									<cfif total_ind is 'NET_SALE'><cf_get_lang dictionary_id='57448.Satış'><cf_get_lang dictionary_id='58083.Net'><br/>(#session.ep.money#)
									<cfelseif total_ind is 'NET_SALE_OTHER_MONEY'><cf_get_lang dictionary_id='57448.Satış'><cf_get_lang dictionary_id='58083.Net'><br/>(#session.ep.money2#)
									<cfelseif total_ind is 'TOTAL_SALE'><cf_get_lang dictionary_id='57448.Satış'><cf_get_lang dictionary_id='58716.Kdv li'><br/>(#session.ep.money#)
									<cfelseif total_ind is 'TOTAL_SALE_OTHER_MONEY'><cf_get_lang dictionary_id='57448.Satış'><cf_get_lang dictionary_id='58716.Kdv li'><br/>(#session.ep.money2#)
									<cfelseif total_ind is 'INVOICE_SALE_RATIO'><cf_get_lang dictionary_id ='57441.Fatura'><cf_get_lang dictionary_id ='58601.Bazında'><cf_get_lang dictionary_id ='57448.Satış'>(#session.ep.money#)
									<cfelseif total_ind is 'INVOICE_COUNT'><cf_get_lang dictionary_id ='40304.Fatura Adedi'>
									<cfelseif total_ind is 'INVOICE_ROW_COUNT'><cf_get_lang dictionary_id ='40305.Fatura Satırı'>
									<cfelseif total_ind is 'STOCK_UNIQUE_COUNT'><cf_get_lang dictionary_id ='40306.Çeşit Sayısı'>
									<cfelseif total_ind is 'AMOUNT'><cf_get_lang dictionary_id ='57492.Toplam'><br/><cf_get_lang dictionary_id ='57635.Miktar'>
									<cfelseif total_ind is 'TOTAL_COST'><cf_get_lang dictionary_id='58258.Maliyet'><br/>(#session.ep.money#)
									<cfelseif total_ind is 'TOTAL_COST_OTHER_MONEY'><cf_get_lang dictionary_id='58258.Maliyet'><br/>(#session.ep.money2#)
									</cfif></font>
								</th>
							</cfloop>
							</tr>
						</cfoutput>
					</thead>
						<!--- toplamlar için kullanılacak degiskenler set ediliyor --->
						<cfloop list="#branch_id_list#" index="n_ind">
							<cfloop list="#type_index#" index="z_ind">
								<cfset 'total_#z_ind#_#n_ind#' =0>
							</cfloop>
						</cfloop>
						<cfif GET_SALES_TOTAL.recordcount>
							<tbody>
								<cfoutput>
									<cfloop list="#branch_id_list#" index="b_index">
										<tr>
											<td nowrap class="txtbold">#listgetat(branch_name_list,listfind(branch_id_list,b_index))#</td>
											<cfloop list="#month_list#" index="ddd_other">
												<cfloop list="#type_index#" index="ii_index">
													<td style="text-align:right;">
														<cfif isdefined('alan_#ii_index#_#ddd_other#_#b_index#') and len(evaluate('alan_#ii_index#_#ddd_other#_#b_index#'))>
															<cfset 'total_#ii_index#_#b_index#'=evaluate('total_#ii_index#_#b_index#') + #evaluate('alan_#ii_index#_#ddd_other#_#b_index#')#>
															<cfif listfindnocase('INVOICE_COUNT,INVOICE_ROW_COUNT,STOCK_UNIQUE_COUNT',ii_index)>
																#TLFormat(evaluate('alan_#ii_index#_#ddd_other#_#b_index#'),0)# <!--- stok - fatura ve fatura satır adedi --->
															<cfelse>
																#TLFormat(evaluate('alan_#ii_index#_#ddd_other#_#b_index#'))#
															</cfif>
														<cfelse>
															#TLFormat(0)#
														</cfif>
													</td>
												</cfloop>
											</cfloop>
											<!--- toplamlar yazdırılıyor --->
											<cfloop list="#type_index#" index="kk_ind">
												<td style="text-align:right;">
													<cfif listfindnocase('INVOICE_COUNT,INVOICE_ROW_COUNT,STOCK_UNIQUE_COUNT',kk_ind)>
														<font color="##FF0000">#TLFormat(evaluate('total_#kk_ind#_#b_index#'),0)#</font>
													<cfelse>
														<font color="##FF0000">#TLFormat(evaluate('total_#kk_ind#_#b_index#'))#</font>
													</cfif>
												</td> 
											</cfloop>
										</tr>
									</cfloop>
								</cfoutput>
							</tbody>
						<cfelse>
							<tr>
								<td colspan="353"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
							</tr>
						</cfif>
				<cfelse>
					<thead>
						<tr>
							<th class="txtbold"><cf_get_lang dictionary_id ='40307.İşlem Tipleri'></th>
							<cfif attributes.time_type eq 1>
								<cfloop from="1" to="#tarih_farki#" index="tt">
									<th style="text-align:center;" class="txtbold"><cfoutput>#tt#</cfoutput></th>
								</cfloop>
							<cfelse>
								<cfloop from="0" to="#tarih_farki#" index="kk">
									<th style="text-align:center;" class="txtbold"><cfoutput><cfif attributes.time_type eq 2>#listgetat(aylar,(attributes.startdate+kk),',')#</cfif></cfoutput></td>
								</cfloop>
							</cfif>
							<th class="txtbold" style="text-align:center;"><font color="##FF0000"><cf_get_lang dictionary_id ='57492.Toplam'></font></th>
						</tr>
					</thead>
					<cfif GET_SALES_TOTAL.recordcount>
						<tbody>
							<cfloop list="#type_index#" index="ii_index">
								<cfset 'toplam_#ii_index#'=0>
								<tr>
									<cfoutput>
										<td nowrap class="txtbold">
											<cfif ii_index is 'NET_SALE'><cf_get_lang dictionary_id='57448.Satış'><cf_get_lang dictionary_id='58083.net'>(#session.ep.money#)
											<cfelseif ii_index is 'NET_SALE_OTHER_MONEY'><cf_get_lang dictionary_id='57448.Satış'><cf_get_lang dictionary_id='58083.net'> (#session.ep.money2#)
											<cfelseif ii_index is 'TOTAL_SALE'><cf_get_lang dictionary_id='57448.Satış'><cf_get_lang dictionary_id='58716.Kdv li'> (#session.ep.money#)
											<cfelseif ii_index is 'TOTAL_SALE_OTHER_MONEY'><cf_get_lang dictionary_id='57448.Satış'><cf_get_lang dictionary_id='58716.Kdv li'>(#session.ep.money2#)
											<cfelseif ii_index is 'INVOICE_SALE_RATIO'><cf_get_lang dictionary_id ='57441.Fatura'><cf_get_lang dictionary_id ='58601.Bazında'><cf_get_lang dictionary_id ='57448.Satış'>(#session.ep.money#)
											<cfelseif ii_index is 'INVOICE_COUNT'><cf_get_lang dictionary_id ='40304.Fatura Adedi'>
											<cfelseif ii_index is 'INVOICE_ROW_COUNT'><cf_get_lang dictionary_id ='40305.Fatura Satırı'>
											<cfelseif ii_index is 'STOCK_UNIQUE_COUNT'><cf_get_lang dictionary_id ='40306.Çeşit Sayısı'>
											<cfelseif ii_index is 'AMOUNT'><cf_get_lang dictionary_id ='57492.Toplam'><br/><cf_get_lang dictionary_id ='57635.Miktar'>
											<cfelseif ii_index is 'TOTAL_COST'><cf_get_lang dictionary_id='58258.Maliyet'> (#session.ep.money#)
											<cfelseif ii_index is 'TOTAL_COST_OTHER_MONEY'><cf_get_lang dictionary_id='58258.Maliyet'> (#session.ep.money2#)
											</cfif>
										</td>
										<cfloop list="#month_list#" index="ddd_other">
											<td style="text-align:right;">
												<cfif isdefined('alan_#ii_index#_#ddd_other#') and len(evaluate('alan_#ii_index#_#ddd_other#'))>
													<cfset 'toplam_#ii_index#'=evaluate('toplam_#ii_index#')+evaluate('alan_#ii_index#_#ddd_other#')>
													<cfif listfindnocase('INVOICE_COUNT,INVOICE_ROW_COUNT,STOCK_UNIQUE_COUNT',ii_index)>
														#TLFormat(evaluate('alan_#ii_index#_#ddd_other#'),0)# <!--- stok - fatura ve fatura satır adedi --->
													<cfelse>
														#TLFormat(evaluate('alan_#ii_index#_#ddd_other#'))#
													</cfif>
												<cfelse>
													#TLFormat(0)#
												</cfif>
											</td>
										</cfloop>
										<td style="text-align:right;">
											<font color="##FF0000">
												<cfif listfindnocase('INVOICE_COUNT,INVOICE_ROW_COUNT,STOCK_UNIQUE_COUNT',ii_index)>
													#TLFormat(evaluate('toplam_#ii_index#'),0)#
												<cfelse>
													#TLFormat(evaluate('toplam_#ii_index#'))#
												</cfif>
											</font>
										</td>
									</cfoutput>
								</tr>
							</cfloop>
						</tbody>
					<cfelse>
                <tr>
                   <td colspan="353"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                </tr>
          </cfif>
				</cfif>
			</cfif>
			<cfif len(attributes.is_submitted)>
				<cfif attributes.time_type neq 1 and attributes.summery_type neq 1>
					<tr>
						<td valign="top" style="text-align:center;" class="txtbold"><cf_get_lang dictionary_id ='40308.Fatura Satış Oranı'></td>
					</tr>
					<tr>	
						<td valign="top" width="300">
							<script src="JS/Chart.min.js"></script>
							<canvas id="myChart" style="width:300px;height:300px;"></canvas>
							<script>
								var ctx = document.getElementById("myChart");
								var myChart = new Chart(ctx, {
									type: 'bar',
									data: {
										labels: [ <cfloop list="#month_list#" index="kk"><cfoutput>"#listgetat(aylar,kk,',')#"</cfoutput>,</cfloop> ],
										datasets: [{
											label: ['Fatura Satış Oranı'],
											data: [<cfloop list="#month_list#" index="kk"> 
														<cfif isdefined('alan_INVOICE_COUNT_#kk#') and evaluate('alan_INVOICE_COUNT_#kk#') neq 0 and isdefined('alan_NET_SALE_#kk#') and len(evaluate('alan_NET_SALE_#kk#'))>
															<cfset 'satis_oran_#kk#'= evaluate('alan_NET_SALE_#kk#')/evaluate('alan_INVOICE_COUNT_#kk#')>
														<cfelse>
															<cfset 'satis_oran_#kk#'= 0>
														</cfif>
													<cfoutput>#wrk_round(evaluate('satis_oran_#kk#'))#</cfoutput>,
													</cfloop> 
													],
											backgroundColor: [
												<cfloop list="#month_list#" index="kk">
												'rgba(255, 99, 132, 0.2)',
												</cfloop>
											],
											borderColor: [
												<cfloop list="#month_list#" index="kk">
												'rgba(255,99,132,1)',
												</cfloop>
											],
											borderWidth: 1
										}
										]
									},
									options: {
										scales: {
											yAxes: [{
												ticks: {
													beginAtZero:true
												}
											}]
										}
									}
								});
							</script>
						</td>		
					</tr>
				</cfif>
			</cfif>	
	</cf_report_list>
</cfif>
<script>
function control()
{
	if(document.form_report.time_type.value == "")
    {
		alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='57497.Zaman Dilimi'>");
		return false;
	}

    if(document.form_report.is_excel.checked==false)
		{
			
			document.form_report.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			return true;
		}
		else
			document.form_report.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_daily_total_sales</cfoutput>"

}
function change_month()
{
	if(form_report.time_type.value == 1)
		form_report.finishdate.disabled = true;
	else
		form_report.finishdate.disabled = false;
}
</script>
<cfsetting showdebugoutput="no">
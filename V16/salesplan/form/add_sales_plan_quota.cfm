<cfquery name="get_money" datasource="#dsn2#">
	SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY ORDER BY MONEY_ID
</cfquery>
<cfquery name="get_sales_zone" datasource="#dsn#">	
	SELECT * FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
</cfquery>
<cfquery name="get_company_cat" datasource="#dsn#">	
	SELECT * FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>

<cfform name="add_sales_plan" method="post" action="#request.self#?fuseaction=salesplan.emptypopup_add_sales_plan_quota" enctype="multipart/form-data">
	<cf_catalystHeader>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box>
			<div id="sales_plan_quota_file" style="right:0; position:absolute; z-index:1;"></div>    
			<cf_box_elements id="sales_plan">
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_cat"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process is_upd='0' process_cat_width='135' is_detail='0'>
						</div>
					</div>
					<div class="form-group" id="item-paper_no"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'> *</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="paper_no" id="paper_no" maxlength="40">
						</div>
					</div>
					<div class="form-group" id="item-zone_id"> 
						<label class="col col-4 col-xs-12" id="sz_1" style="display:none;"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></label>
						<div class="col col-8 col-xs-12" id="sz_2" style="display:none;">                                           
							<select name="zone_id" id="zone_id" onChange="change_scope();">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_sales_zone">
									<option value="#sz_id#">#sz_name#</option>
								</cfoutput>
							</select>	
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-plan_date"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
						<div class="col col-8 col-xs-12">                                	        
							<div class="input-group">
								<cfinput name="plan_date" type="text" validate="#validate_style#" required="Yes" value="#dateformat(now(),dateformat_style)#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="plan_date"></span>
							</div>
						</div>
					</div>	
					<div class="form-group" id="item-planner_name"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41560.Planlayan'></label>
						<div class="col col-8 col-xs-12">                                	        
							<div class="input-group">
								<input type="hidden" name="planner_id" id="planner_id" value="">
								<input type="Text" name="planner_name" id="planner_name" value="">  
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_sales_plan.planner_id&field_name=add_sales_plan.planner_name&select_list=1');"></span> 
							</div>
						</div>
					</div>
					<div class="form-group" id="item-companycat_id"> 
						<label class="col col-4 col-xs-12" id="sz_3" style="display:none;"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></label>
						<div class="col col-8 col-xs-12" id="sz_4" style="display:none;">
							<select name="companycat_id" id="companycat_id" onChange="change_scope();">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_company_cat">
									<option value="#companycat_id#">#companycat#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">  
					<div class="form-group" id="item-plan_year"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'></label>
						<div class="col col-8 col-xs-12">
							<select name="plan_year" id="plan_year">
								<cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+3#" index="i">
									<cfoutput>
										<option value="#i#" <cfif i eq session.ep.period_year>selected</cfif>>#i#</option>
									</cfoutput>
								</cfloop>
							</select>                               	
						</div>
					</div>	
					<div class="form-group" id="item-sale_scope"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41602.Kapsam'></label>
						<div class="col col-8 col-xs-12">
							<select name="sale_scope" id="sale_scope" onChange="change_scope();">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="1"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></option>
								<option value="2"><cf_get_lang dictionary_id='57453.Şube'></option>
								<option value="3"><cf_get_lang dictionary_id='41478.Satış Takımı'></option>
								<option value="4"><cf_get_lang dictionary_id='41603.Mikro Bölge'></option>
								<option value="5"><cf_get_lang dictionary_id='58875.Çalışanlar'></option>
								<option value="6"><cf_get_lang dictionary_id='58673.Müşteriler'></option>
								<option value="7"><cf_get_lang dictionary_id='57567.Ürün Kategorileri'></option>
								<option value="8"><cf_get_lang dictionary_id='41606.Markalar'></option>
								<option value="9"><cf_get_lang dictionary_id='41607.Üye Kategorileri'></option>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">  
					<div class="form-group" id="item-detail"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="detail" id="detail" style="width:135px;height:50px;"></textarea>
						</div>
					</div> 
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
						
			<cf_basket id="sales_plan_bask">
				<cf_grid_list>
					<thead>
						<tr>
							<th width="20"></th>
							<th></th>
							<th></th>
							<cfloop list="#ay_list()#" index="i">
								<th colspan="5" class="text-center"><cfoutput>#i#</cfoutput></th>
								<th width="20"></th>
							</cfloop>
							<th colspan="2"><cf_get_lang dictionary_id='57492.Toplam'></th>
						</tr>
						<tr>
							<input name="record_num" id="record_num" type="hidden" value="0">
							<th width="20">
								<a href="javascript://" onclick="pencere_ac_company();" id="sz_5" style="display:none;"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
							</th>
							<th width="160"><cf_get_lang dictionary_id='41602.Kapsam'></th>
							<th width="20"></th>
							<cfloop list="#ay_list()#" index="i">
								<th class="text-right"><cf_get_lang dictionary_id='30010.Ciro'> <cfoutput>#session.ep.money#</cfoutput></th>
								<th class="text-right"><cf_get_lang dictionary_id='30010.Ciro'> <cfoutput>#session.ep.money2#</cfoutput></th>
								<th><cf_get_lang dictionary_id='57635.Miktar'></th>
								<cfset set_net_kar_ = "set_net_kar_#listfind(ay_list(),i)#">
								<cfset apply_kar = "#listfind(ay_list(),i)#">
								<cfset set_net_prim_ = "set_net_prim_#listfind(ay_list(),i)#">
								<cfset apply_prim = "#listfind(ay_list(),i)#">
								<th><cf_get_lang dictionary_id='41516.Kar'>% <input name="<cfoutput>#set_net_kar_#</cfoutput>" id="<cfoutput>#set_net_kar_#</cfoutput>" type="text" class="box" style="width:70px;" onFocus="this.value='';" onBlur="if(this.value.length && filterNum(this.value) <= 100) apply_kar(<cfoutput>#apply_kar#</cfoutput>);" onkeyup="return(FormatCurrency(this,event,2));" value="0,00" autocomplete="off"></th>
								<th><cf_get_lang dictionary_id='41588.Prim'>% <input name="<cfoutput>#set_net_prim_#</cfoutput>" id="<cfoutput>#set_net_prim_#</cfoutput>" type="text" class="box" style="width:70px;" onFocus="this.value='';" onBlur="if(this.value.length && filterNum(this.value) <= 100) apply_prim(<cfoutput>#apply_prim#</cfoutput>);" onkeyup="return(FormatCurrency(this,event,2));" value="0,00" autocomplete="off"></th>
								<th width="20"></th>
							</cfloop>
							<th width="100" class="text-right"><cf_get_lang dictionary_id='30010.Ciro'> <cfoutput>#session.ep.money#</cfoutput></th>
							<th width="100" class="text-right"><cf_get_lang dictionary_id='30010.Ciro'> <cfoutput>#session.ep.money2#</cfoutput></th>
						</tr>
					</thead>
			
					<tbody name="table1" id="table1"></tbody>
					<tfoot style="display:none" id="total_">
						<tr title="<cf_get_lang dictionary_id='57492.Toplam'>">
							<td colspan="2" class="text-right" width="165" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
							<td width="20"></td>
							<cfloop from="1" to="#listlen(ay_list())#" index="i">
								<cfoutput>
									<td class="text-right" width="210"><input name="total_stytem#i#" id="total_stytem#i#" type="text" value="0" class="box" readonly></td>
									<td class="text-right" width="210"><input name="total_stytem2#i#" id="total_stytem2#i#" type="text" value="0" class="box" readonly></td>
									<td class="text-right"></td>
									<td class="text-right"></td>
									<td class="text-right"></td>
									<td width="20"></td>
								</cfoutput>
							</cfloop>
							<td class="text-right"><input name="satir_total_stytem" id="satir_total_stytem" type="text" value="0" class="box" readonly></td>
							<td class="text-right"><input name="satir_total_stytem2" id="satir_total_stytem2" type="text" value="0" class="box" readonly></td>
						</tr>
					</tfoot>
				</cf_grid_list>
				<cf_basket_footer height="95">
					<div class="ui-row">
						<div id="sepetim_total" class="padding-0">
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"><cf_get_lang dictionary_id='57677.Döviz'></span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody">
										<table>
											<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
											<cfquery name="get_standart_process_money" datasource="#dsn#">
												SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #session.ep.period_id#
											</cfquery>
											<cfoutput>
												<cfif IsQuery(get_standart_process_money) and len(get_standart_process_money.STANDART_PROCESS_MONEY)>
													<cfset selected_money=get_standart_process_money.STANDART_PROCESS_MONEY>
												<cfelseif len(session.ep.money2)>
													<cfset selected_money=session.ep.money2>
												<cfelse>
													<cfset selected_money=session.ep.money>
												</cfif>
												<cfif session.ep.rate_valid eq 1>
													<cfset readonly_info = "yes">
												<cfelse>
													<cfset readonly_info = "no">
												</cfif>
												<cfloop query="get_money">
													<tr>
														<div class="col col-4">
															<td>
																<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
																<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
																<div class="form-group">
																	<input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onClick="toplam_hesapla(1);" <cfif selected_money eq money>checked</cfif>>#money#
																</div>
															</td>  
														</div> 
														<div class="col col-2">
															<td>
																<div class="form-group">
																	#TLFormat(rate1,0)#/
																</div>
															</td>
														</div>
														<div class="col col-6">
															<td>
																<div class="form-group">
																	<input type="text" <cfif readonly_info>readonly</cfif> class="moneybox" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" style="width:100%;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="toplam_hesapla(1);">
																</div>
															</td>    
														</div> 
													</tr>
												</cfloop>
											</cfoutput>
										</table>
									</div>
								</div>
							</div>
							<div class="col col-5 col-md-5 col-sm-5 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"><cf_get_lang dictionary_id='57492.Toplam'></span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody"> 
										<table>
											<tr>
												<td>
													<div class="col col-6">
													</div>
													<div class="col col-6">
														<div class="form-group">
															<div class="col col-9 col-xs-12">
																<input type="text" name="total_amount" id="total_amount" class="moneybox" readonly value="0">
															</div>
															<div class="col col-3 col-xs-12">
																<input type="text" name="tl_value2" id="tl_value2" readonly value="<cfoutput>#session.ep.money#</cfoutput>">
															</div>
														</div>
													</div>
												</td>
											</tr>
										</table>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"><cf_get_lang dictionary_id='40163.Toplam Miktar'> </span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody" id="totalAmountList">  
										<table>
											<tr>
												<td id="rate_value1">
													<div class="col col-6">
													</div>
													<div class="col col-6">
														<div class="form-group" id="rate_value1">
															<div class="col col-9 col-xs-12">
																<input type="text" name="other_total_amount" id="other_total_amount" class="moneybox" readonly value="0">
															</div>
															<div class="col col-3 col-xs-12">
																<input type="text" name="tl_value1" id="tl_value1" readonly value="<cfoutput>#selected_money#</cfoutput>">
															</div>
														</div>
													</div>
												</td>
											</tr>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</cf_basket_footer>
			</cf_basket>
		</cf_box>
	</div>
</cfform>
<script language="JavaScript">
	row_count=0;
	ay_list = "<cfoutput>#ay_list()#</cfoutput>";
	function sil(sy)
	{
		var my_element=eval("add_sales_plan.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
	}
	function add_row(scope_id,scope_name,scope_name2,revenue_money_1,revenue_money2_1,amount_1,profit_1,bonus_1,revenue_money_2,revenue_money2_2,amount_2,profit_2,bonus_2,revenue_money_3,revenue_money2_3,amount_3,profit_3,bonus_3,revenue_money_4,revenue_money2_4,amount_4,profit_4,bonus_4,revenue_money_5,revenue_money2_5,amount_5,profit_5,bonus_5,revenue_money_6,revenue_money2_6,amount_6,profit_6,bonus_6,revenue_money_7,revenue_money2_7,amount_7,profit_7,bonus_7,revenue_money_8,revenue_money2_8,amount_8,profit_8,bonus_8,revenue_money_9,revenue_money2_9,amount_9,profit_9,bonus_9,revenue_money_10,revenue_money2_10,amount_10,profit_10,bonus_10,revenue_money_11,revenue_money2_11,amount_11,profit_11,bonus_11,revenue_money_12,revenue_money2_12,amount_12,profit_12,bonus_12)
	{
		document.add_sales_plan.sale_scope.selectedIndex = scope_name2;
		if(scope_name2 == undefined) scope_name2 = '';
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newRow.className = 'color-row';
		newRow.onmouseover=function(){this.className='color-light'};
		newRow.onmouseout=function(){this.className='color-row'};
		document.add_sales_plan.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol'+ row_count +'" id="row_kontrol'+ row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');" ><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" value="'+scope_name+' '+scope_name2+'" name="plan_scope' + row_count +'" id="plan_scope' + row_count +'" class="boxtext" readonly><input type="hidden" value="'+scope_id+'" name="plan_scope_id' + row_count +'">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '';
		for(i=1;i<=<cfoutput>#listlen(ay_list())#</cfoutput>;i++)
		{
			if(eval('revenue_money_'+i) == undefined)
				new_revenue_money = commaSplit(0);
			else
				new_revenue_money = commaSplit(filterNum(eval('revenue_money_'+i)));
			if(eval('revenue_money2_'+i) == undefined)
				new_revenue_money2 = commaSplit(0);
			else
				new_revenue_money2 = commaSplit(filterNum(eval('revenue_money2_'+i)));
			if(eval('amount_'+i) == undefined)
				new_amount = commaSplit(0);
			else
				new_amount = commaSplit(filterNum(eval('amount_'+i)));
			if(eval('profit_'+i) == undefined)
				new_profit = commaSplit(0);
			else
				new_profit = commaSplit(filterNum(eval('profit_'+i)));
			if(eval('bonus_'+i) == undefined)
				new_bonus = commaSplit(0);
			else
				new_bonus = commaSplit(filterNum(eval('bonus_'+i)));
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" value="'+new_revenue_money+'" title="'+scope_name+' '+scope_name2+' - '+list_getat(ay_list,i)+'"  id="net_total'+ i +'_'+ row_count +'" name="net_total'+ i +'_'+ row_count +'" style="width:170px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);toplam_al('+row_count+','+i+');" onFocus="son_deger_degis('+row_count+','+i+');">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" value="'+new_revenue_money2+'" title="'+scope_name+' '+scope_name2+' - '+list_getat(ay_list,i)+'"  id="net_total_other'+ i +'_'+ row_count +'" name="net_total_other'+ i +'_'+ row_count +'" class="moneybox"onkeyup="return(FormatCurrency(this,event));"  onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);toplam_al2('+row_count+','+i+');" onFocus="son_deger_degis('+row_count+','+i+');">';
		 
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" value="'+new_amount+'"  name="quantity'+ i +'_'+ row_count +'" id="quantity'+ i +'_'+ row_count +'" title="'+scope_name+' '+scope_name2+' - '+list_getat(ay_list,i)+'" class="moneybox" onkeyup="isNumber(this);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" value="'+new_profit+'" title="'+scope_name+' '+scope_name2+' - '+list_getat(ay_list,i)+'" id="net_kar'+ i +'_'+ row_count +'" name="net_kar'+ i +'_'+ row_count +'" class="moneybox" onkeyup="return(FormatCurrency(this,event));" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" value="'+new_bonus+'" title="'+scope_name+' '+scope_name2+' - '+list_getat(ay_list,i)+'" id="net_prim'+ i +'_'+ row_count +'"  name="net_prim'+ i +'_'+ row_count +'" class="moneybox" onkeyup="return(FormatCurrency(this,event));" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '';
		}
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" value="'+commaSplit(0)+'" title="'+scope_name+' '+scope_name2+' - '+list_getat(ay_list,i)+'" name="satir_net_total_'+ row_count +'" id="satir_net_total_'+row_count+'" class="moneybox" readonly>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="text" value="'+commaSplit(0)+'" title="'+scope_name+' '+scope_name2+' - '+list_getat(ay_list,i)+'" id="satir_net_total_other_'+ row_count +'" name="satir_net_total_other_'+ row_count +'" class="moneybox" readonly>';
	}
	function change_scope()
	{
		if(document.add_sales_plan.sale_scope.value != '')
		{
			row_count = 0;
			add_sales_plan.record_num.value = 0;
			var oTable=document.getElementById("table1");
			while(oTable.rows.length>0)
				oTable.deleteRow(oTable.rows.length-1);
		}
		add_sales_plan.total_amount.value = commaSplit(0);
		add_sales_plan.other_total_amount.value = commaSplit(0);
		add_sales_plan.satir_total_stytem.value = commaSplit(0);
		add_sales_plan.satir_total_stytem2.value = commaSplit(0);
		for(i=1;i<=<cfoutput>#listlen(ay_list())#</cfoutput>;i++)
			{
				eval('add_sales_plan.total_stytem'+i).value = commaSplit(0);
				eval('add_sales_plan.total_stytem2'+i).value = commaSplit(0);
				eval('add_sales_plan.set_net_kar_'+i).value = commaSplit(0);
				eval('add_sales_plan.set_net_prim_'+i).value = commaSplit(0);
			}
		if(document.add_sales_plan.sale_scope.value == 1)//Satış Bölgesi Bazında
		{
			document.getElementById('sz_1').style.display = 'none';
			document.getElementById('sz_2').style.display = 'none';
			document.getElementById('sz_3').style.display = 'none';
			document.getElementById('sz_4').style.display = 'none';
			document.getElementById('sz_5').style.display = 'none';
			document.add_sales_plan.zone_id.value = '';
			var zone_control = wrk_safe_query('slsp_zone_control','dsn');
			if(zone_control.recordcount > 0)
				document.getElementById('total_').style.display = '';
			else
				document.getElementById('total_').style.display = 'none';
			for(var j=0;j<zone_control.recordcount;j++)
			{
				add_row(zone_control.SZ_ID[j],zone_control.SZ_NAME[j],document.add_sales_plan.sale_scope.value);
			}
		}
		else if(document.add_sales_plan.sale_scope.value == 2)//Şube Bazında
		{
			document.getElementById('sz_1').style.display = 'none';
			document.getElementById('sz_2').style.display = 'none';
			document.getElementById('sz_3').style.display = 'none';
			document.getElementById('sz_4').style.display = 'none';
			document.getElementById('sz_5').style.display = 'none';
			document.add_sales_plan.zone_id.value = '';
			var branch_control = wrk_safe_query('slsp_branch_control','dsn');
			if(branch_control.recordcount > 0)
				document.getElementById('total_').style.display = '';
			else
				document.getElementById('total_').style.display = 'none';
			for(var j=0;j<branch_control.recordcount;j++)
			{
				add_row(branch_control.BRANCH_ID[j],branch_control.BRANCH_NAME[j],document.add_sales_plan.sale_scope.value);
			}
		}
		else if(document.add_sales_plan.sale_scope.value == 3)//Satış Takımı Bazında
		{
			document.getElementById('sz_1').style.display = '';
			document.getElementById('sz_2').style.display = '';
			document.getElementById('sz_3').style.display = 'none';
			document.getElementById('sz_4').style.display = 'none';
			document.getElementById('sz_5').style.display = 'none';
			if(document.add_sales_plan.zone_id.value != '')
			{
				var team_control = wrk_safe_query('slsp_team_control','dsn',0,document.add_sales_plan.zone_id.value);
				if(team_control.recordcount > 0)
					document.getElementById('total_').style.display = '';
				else
					document.getElementById('total_').style.display = 'none';
				
				for(var j=0;j<team_control.recordcount;j++)
				{
					add_row(team_control.TEAM_ID[j],team_control.TEAM_NAME[j],document.add_sales_plan.sale_scope.value);
				}
			}
			else
			{
				alert("<cf_get_lang dictionary_id ='41614.Satış Takımları İçin Önce Satış Bölgesi Seçmelisiniz'> !");
				document.getElementById('total_').style.display = 'none';
			}
		}
		else if(document.add_sales_plan.sale_scope.value == 4)//Mikro Bölge Bazında
		{
			document.getElementById('sz_1').style.display = '';
			document.getElementById('sz_2').style.display = '';
			document.getElementById('sz_3').style.display = 'none';
			document.getElementById('sz_4').style.display = 'none';
			document.getElementById('sz_5').style.display = 'none';
			if(document.add_sales_plan.zone_id.value != '')
			{
				var ims_control = wrk_safe_query('slsp_ims_control','dsn',0,document.add_sales_plan.zone_id.value);
				if(ims_control.recordcount > 0)
					document.getElementById('total_').style.display = '';
				else
					document.getElementById('total_').style.display = 'none';
				for(var j=0;j<ims_control.recordcount;j++)
				{
					add_row(ims_control.IMS_CODE_ID[j],ims_control.IMS_CODE_NAME[j],document.add_sales_plan.sale_scope.value);
				}
			}
			else
			{
				alert("<cf_get_lang dictionary_id ='41615.Mikro Bölge İçin Önce Satış Bölgesi Seçmelisiniz'> !");
				document.getElementById('total_').style.display = 'none';
			}
		}
		else if(document.add_sales_plan.sale_scope.value == 5)//Çalışan Bazında
		{
			document.getElementById('sz_1').style.display = '';
			document.getElementById('sz_2').style.display = '';
			document.getElementById('sz_3').style.display = 'none';
			document.getElementById('sz_4').style.display = 'none';
			document.getElementById('sz_5').style.display = 'none';
			if(document.add_sales_plan.zone_id.value != '')
			{
				var employee_control = wrk_safe_query('slsp_employee_control','dsn',0,document.add_sales_plan.zone_id.value);
				if(employee_control.recordcount > 0)
					document.getElementById('total_').style.display = '';
				else
					document.getElementById('total_').style.display = 'none';
				for(var j=0;j<employee_control.recordcount;j++)
				{
					add_row(employee_control.EMPLOYEE_ID[j],employee_control.EMPLOYEE_NAME[j] +  ' ' + employee_control.EMPLOYEE_SURNAME[j],document.add_sales_plan.sale_scope.value);
				}
			}
			else
			{
				alert("<cf_get_lang dictionary_id ='41616.Çalışanlar İçin Önce Satış Bölgesi Seçmelisiniz'>!");
				document.getElementById('total_').style.display = 'none';
			}
		}
		else if(document.add_sales_plan.sale_scope.value == 6)//Müşteri Bazında
		{
			document.getElementById('sz_1').style.display = '';
			document.getElementById('sz_2').style.display = '';
			document.getElementById('sz_3').style.display = '';
			document.getElementById('sz_4').style.display = '';
			document.getElementById('sz_5').style.display = '';
			if(document.add_sales_plan.zone_id.value != '' || document.add_sales_plan.companycat_id.value != '')
			{
				if(document.add_sales_plan.zone_id.value != '' && document.add_sales_plan.companycat_id.value != '')//üye kategorisi ve satış bölgesi seçilmiş ise
				{
					var listParam = document.add_sales_plan.zone_id.value + "*" + document.add_sales_plan.companycat_id.value;
					var new_sql_company = 'slsp_company_control';
				}
				else if(document.add_sales_plan.zone_id.value != '' && document.add_sales_plan.companycat_id.value == '')//sadece satış bölgesi seçilmiş ise
				{
					var listParam = document.add_sales_plan.zone_id.value;
					var new_sql_company = 'slsp_company_control_2';
				}
				else if(document.add_sales_plan.zone_id.value == '' && document.add_sales_plan.companycat_id.value != '')//sadece üye kategorisi seçilmiş ise
				{
					var listParam = document.add_sales_plan.companycat_id.value;
					var new_sql_company = 'slsp_company_control_3';
				}
				var company_control = wrk_safe_query(new_sql_company,'dsn',0,listParam);
				if(company_control.recordcount > 0)
					document.getElementById('total_').style.display = '';
				else
					document.getElementById('total_').style.display = 'none';
				for(var j=0;j<company_control.recordcount;j++)
				{
					add_row(company_control.COMPANY_ID[j],company_control.FULLNAME[j],document.add_sales_plan.sale_scope.value);
				}
			}
			else
			{
				alert("<cf_get_lang dictionary_id ='41617.Müşteriler İçin Önce Satış Bölgesi veya Üye Kategorisi Seçmelisiniz'> !");
				document.getElementById('total_').style.display = 'none';
			}
		}
		else if(document.add_sales_plan.sale_scope.value == 7)//Ürün kategorisi Bazında
		{
			document.getElementById('sz_1').style.display = 'none';
			document.getElementById('sz_2').style.display = 'none';
			document.getElementById('sz_3').style.display = 'none';
			document.getElementById('sz_4').style.display = 'none';
			document.getElementById('sz_5').style.display = 'none';
			document.add_sales_plan.zone_id.value = '';
			var product_cat_control = wrk_safe_query("slsp_product_cat_control_2",'dsn3',0,"<cfoutput>#dsn1_alias#</cfoutput>");
			if(product_cat_control.recordcount > 0)
				document.getElementById('total_').style.display = '';
			else
				document.getElementById('total_').style.display = 'none';
			for(var j=0;j<product_cat_control.recordcount;j++)
			{
				add_row(product_cat_control.PRODUCT_CATID[j],product_cat_control.PRODUCT_CAT[j],document.add_sales_plan.sale_scope.value);
			}
		}
		else if(document.add_sales_plan.sale_scope.value == 8)//Marka Bazında
		{
			document.getElementById('sz_1').style.display = 'none';
			document.getElementById('sz_2').style.display = 'none';
			document.getElementById('sz_3').style.display = 'none';
			document.getElementById('sz_4').style.display = 'none';
			document.getElementById('sz_5').style.display = 'none';
			document.add_sales_plan.zone_id.value = '';
			var brand_control = wrk_safe_query('slsp_brand_control_2','dsn3',0,'<cfoutput>#dsn1_alias#</cfoutput>');
			if(brand_control.recordcount > 0)
				document.getElementById('total_').style.display = '';
			else
				document.getElementById('total_').style.display = 'none';
			for(var j=0;j<brand_control.recordcount;j++)
			{
				add_row(brand_control.BRAND_ID[j],brand_control.BRAND_NAME[j],document.add_sales_plan.sale_scope.value);
			}
		}
		else if(document.add_sales_plan.sale_scope.value == 9)//Üye Kategorisi Bazında
		{
			document.getElementById('sz_1').style.display = 'none';
			document.getElementById('sz_2').style.display = 'none';
			document.getElementById('sz_3').style.display = 'none';
			document.getElementById('sz_4').style.display = 'none';
			document.getElementById('sz_5').style.display = 'none';
			document.add_sales_plan.zone_id.value = '';
			var comp_cat_control = wrk_safe_query('slsp_comp_cat_control','dsn');
			if(comp_cat_control.recordcount > 0)
				document.getElementById('total_').style.display = '';
			else
				document.getElementById('total_').style.display = 'none';
			for(var j=0;j<comp_cat_control.recordcount;j++)
			{
				add_row(comp_cat_control.COMPANYCAT_ID[j],comp_cat_control.COMPANYCAT[j],document.add_sales_plan.sale_scope.value);
			}
		}
	}
	function pencere_ac_company(no)
	{
		no = row_count + 1;
		add_row(6,'','');
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=7</cfoutput>&field_comp_name=add_sales_plan.plan_scope'+ no +'&field_comp_id=add_sales_plan.plan_scope_id'+ no);
	}
	function hesapla(row_no,month)
	{
		var satir_toplam = filterNum(eval('add_sales_plan.net_total'+month+'_'+row_no).value);
		if('<cfoutput>#session.ep.money2#</cfoutput>' != '')
		{
			for(i=1;i<=add_sales_plan.kur_say.value;i++)
			{
				if(eval('add_sales_plan.hidden_rd_money_'+i).value == '<cfoutput>#session.ep.money2#</cfoutput>')
				{
					form_txt_rate2_ = filterNum(eval("document.add_sales_plan.txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				}
			}
			eval('add_sales_plan.net_total_other'+month+'_'+row_no).value = commaSplit(satir_toplam/form_txt_rate2_);
		}
		var total_amount_ = 0;
		var total_amount_2 = 0;
		for(i=1;i<=<cfoutput>#listlen(ay_list())#</cfoutput>;i++)
			if(eval("document.add_sales_plan.row_kontrol"+row_no).value==1)
			{
				total_amount_ += filterNum(eval('add_sales_plan.net_total'+i+'_'+row_no).value);
				total_amount_2 += filterNum(eval('add_sales_plan.net_total_other'+i+'_'+row_no).value);
			}
		eval('add_sales_plan.satir_net_total_'+row_no).value = commaSplit(total_amount_);
		eval('add_sales_plan.satir_net_total_other_'+row_no).value = commaSplit(total_amount_2);
		toplam_hesapla();
	}
	function son_deger_degis(row_no,month)
	{
		son_deger = eval("add_sales_plan.net_total" + month + "_" + row_no + ".value");
		son_deger = filterNum(son_deger);
		son_deger_other = eval("add_sales_plan.net_total_other" + month + "_" + row_no + ".value");
		son_deger_other = filterNum(son_deger_other);
	}
	function toplam_al(row_no,month)
	{
		gelen_satir_toplam = eval("add_sales_plan.satir_net_total_" + row_no).value;
		gelen_satir_toplam = filterNum(gelen_satir_toplam);
		gelen_input = eval("add_sales_plan.net_total" + month + "_" + row_no + ".value");
		gelen_input = filterNum(gelen_input);
		gelen_kolon_toplam = eval("add_sales_plan.total_stytem" + month).value;
		gelen_kolon_toplam = filterNum(gelen_kolon_toplam);
		son_toplam = add_sales_plan.satir_total_stytem.value;
		son_toplam = filterNum(son_toplam);
		
		son_toplam = (parseFloat(son_toplam) + parseFloat(gelen_input)) - parseFloat(son_deger);
		gelen_kolon_toplam = (parseFloat(gelen_kolon_toplam) + parseFloat(gelen_input)) - parseFloat(son_deger);
		gelen_satir_toplam = (parseFloat(gelen_satir_toplam) + parseFloat(gelen_input)) - parseFloat(son_deger);
		gelen_input = commaSplit(gelen_input,2);
		gelen_satir_toplam = commaSplit(gelen_satir_toplam,2);
		gelen_kolon_toplam = commaSplit(gelen_kolon_toplam,2);
		son_toplam = commaSplit(son_toplam,2);
		
		eval("add_sales_plan.satir_net_total_" + row_no).value = gelen_satir_toplam;
		eval("add_sales_plan.total_stytem" + month).value = gelen_kolon_toplam;
		eval("add_sales_plan.net_total" + month + "_" + row_no).value = gelen_input;
		add_sales_plan.satir_total_stytem.value = son_toplam;
		add_sales_plan.total_amount.value = son_toplam;
		
		if('<cfoutput>#session.ep.money2#</cfoutput>' != '')
		{
			for(i=1;i<=add_sales_plan.kur_say.value;i++)
			{
				if(eval('add_sales_plan.hidden_rd_money_'+i).value == '<cfoutput>#session.ep.money2#</cfoutput>')
				{
					form_txt_rate2_ = filterNum(eval("document.add_sales_plan.txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				}
			}
			eval('add_sales_plan.net_total_other'+month+'_'+row_no).value = commaSplit(filterNum(eval("add_sales_plan.net_total" + month + "_" + row_no).value)/form_txt_rate2_);

			gelen_satir_toplam_other = eval("add_sales_plan.satir_net_total_other_" + row_no).value;
			gelen_satir_toplam_other = filterNum(gelen_satir_toplam_other);
			gelen_input_other = eval("add_sales_plan.net_total_other" + month + "_" + row_no + ".value");
			gelen_input_other = filterNum(gelen_input_other);
			gelen_kolon_toplam_other = eval("add_sales_plan.total_stytem2" + month).value;
			gelen_kolon_toplam_other = filterNum(gelen_kolon_toplam_other);
			son_toplam_other = add_sales_plan.satir_total_stytem2.value;
			son_toplam_other = filterNum(son_toplam_other);
			
			son_toplam_other = (parseFloat(son_toplam_other) + parseFloat(gelen_input_other)) - parseFloat(son_deger_other);
			gelen_kolon_toplam_other = (parseFloat(gelen_kolon_toplam_other) + parseFloat(gelen_input_other)) - parseFloat(son_deger_other);
			gelen_satir_toplam_other = (parseFloat(gelen_satir_toplam_other) + parseFloat(gelen_input_other)) - parseFloat(son_deger_other);
			
			gelen_input_other = commaSplit(gelen_input_other,2);
			gelen_satir_toplam_other = commaSplit(gelen_satir_toplam_other,2);
			gelen_kolon_toplam_other = commaSplit(gelen_kolon_toplam_other,2);
			son_toplam_other = commaSplit(son_toplam_other,2);
			
			eval("add_sales_plan.satir_net_total_other_" + row_no).value = gelen_satir_toplam_other;
			eval("add_sales_plan.total_stytem2" + month).value = gelen_kolon_toplam_other;
			eval("add_sales_plan.net_total_other" + month + "_" + row_no).value = gelen_input_other;
			add_sales_plan.satir_total_stytem2.value = son_toplam_other;
			add_sales_plan.other_total_amount.value = son_toplam_other;
		}
	}
	function toplam_al2(row_no,month)
	{		
		gelen_satir_toplam_other = eval("add_sales_plan.satir_net_total_other_" + row_no).value; 
		gelen_satir_toplam_other = filterNum(gelen_satir_toplam_other);	
		gelen_input_other = eval("add_sales_plan.net_total_other" + month + "_" + row_no + ".value");
		gelen_input_other = filterNum(gelen_input_other);
		
		gelen_kolon_toplam_other = eval("add_sales_plan.total_stytem2" + month).value;
		gelen_kolon_toplam_other = filterNum(gelen_kolon_toplam_other);
		son_toplam_other = add_sales_plan.satir_total_stytem2.value;
		son_toplam_other = filterNum(son_toplam_other);

		son_toplam_other = parseFloat( son_toplam_other)+ parseFloat( gelen_input_other )  - parseFloat ( son_deger_other);
		gelen_kolon_toplam_other = parseFloat(gelen_kolon_toplam_other) + parseFloat( gelen_input_other) - parseFloat (son_deger_other);
		gelen_satir_toplam_other = parseFloat (gelen_satir_toplam_other) + parseFloat( gelen_input_other) - parseFloat( son_deger_other);
		
		gelen_input_other = commaSplit(gelen_input_other,2);
		gelen_satir_toplam_other = commaSplit(gelen_satir_toplam_other,2);
		gelen_kolon_toplam_other = commaSplit(gelen_kolon_toplam_other,2);
		son_toplam_other = commaSplit(son_toplam_other,2);

		
		eval("add_sales_plan.satir_net_total_other_" + row_no).value = gelen_satir_toplam_other;
		eval("add_sales_plan.total_stytem2" + month).value = gelen_kolon_toplam_other;
		eval("add_sales_plan.net_total_other" + month + "_" + row_no).value = gelen_input_other;
		add_sales_plan.satir_total_stytem2.value = son_toplam_other;
		add_sales_plan.other_total_amount.value = son_toplam_other;
		
		for(i=1;i<=add_sales_plan.kur_say.value;i++)
		{
			if(eval('add_sales_plan.hidden_rd_money_'+i).value == '<cfoutput>#session.ep.money2#</cfoutput>')
			{
				form_txt_rate2_ = filterNum(eval("document.add_sales_plan.txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}
		}
		eval('add_sales_plan.net_total'+month+'_'+row_no).value = commaSplit(filterNum(eval('add_sales_plan.net_total_other'+month+'_'+row_no).value)*form_txt_rate2_);
		gelen_satir_toplam = eval("add_sales_plan.satir_net_total_" + row_no).value;
		gelen_satir_toplam = filterNum(gelen_satir_toplam);
		gelen_input = eval("add_sales_plan.net_total" + month + "_" + row_no + ".value");
		gelen_input = filterNum(gelen_input);
		gelen_kolon_toplam = eval("add_sales_plan.total_stytem" + month).value;
		gelen_kolon_toplam = filterNum(gelen_kolon_toplam);
		son_toplam = add_sales_plan.satir_total_stytem.value;
		son_toplam = filterNum(son_toplam);
		
		son_toplam = parseFloat(son_toplam )+ parseFloat( gelen_input) -parseFloat( son_deger);
		gelen_kolon_toplam = parseFloat(gelen_kolon_toplam) + parseFloat(gelen_input) -parseFloat( son_deger);
		gelen_satir_toplam = parseFloat(gelen_satir_toplam) + parseFloat(gelen_input) - parseFloat(son_deger);
		
		gelen_input = commaSplit(gelen_input,2);
		gelen_satir_toplam = commaSplit(gelen_satir_toplam,2);
		gelen_kolon_toplam = commaSplit(gelen_kolon_toplam,2);
		son_toplam = commaSplit(son_toplam,2);
		
		eval("add_sales_plan.satir_net_total_" + row_no).value = gelen_satir_toplam;
		eval("add_sales_plan.total_stytem" + month).value = gelen_kolon_toplam;
		eval("add_sales_plan.net_total" + month + "_" + row_no).value = gelen_input;
		add_sales_plan.satir_total_stytem.value = son_toplam;
		add_sales_plan.total_amount.value = son_toplam;
	}
	function toplam_hesapla(type)
	{
		if(add_sales_plan.kur_say.value == 1)
			for(s=1;s<=add_sales_plan.kur_say.value;s++)
			{
				if(document.add_sales_plan.rd_money.checked == true)
				{
					deger_diger_para = document.add_invent.rd_money.value;
					form_txt_rate2_ = filterNum(eval("document.add_sales_plan.txt_rate2_"+s).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
				}
				if(eval('add_sales_plan.hidden_rd_money_'+s).value == '<cfoutput>#session.ep.money2#</cfoutput>')
					form_txt_rate2_2 = filterNum(eval("document.add_sales_plan.txt_rate2_"+s).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
			}
		else 
			for(s=1;s<=add_sales_plan.kur_say.value;s++)
			{
				if(document.add_sales_plan.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.add_sales_plan.rd_money[s-1].value;
					form_txt_rate2_ = filterNum(eval("document.add_sales_plan.txt_rate2_"+s).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
				}
				if(eval('add_sales_plan.hidden_rd_money_'+s).value == '<cfoutput>#session.ep.money2#</cfoutput>')
					form_txt_rate2_2 = filterNum(eval("document.add_sales_plan.txt_rate2_"+s).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
			}
		var total_amount = 0;
		var other_total_amount = 0;
		for(j=1;j<=add_sales_plan.record_num.value;j++)
			{
				var total_amount_ = 0;
				var total_amount_2 = 0;
				for(i=1;i<=<cfoutput>#listlen(ay_list())#</cfoutput>;i++)
					if(eval("document.add_sales_plan.row_kontrol"+j).value==1)
					{
						eval('add_sales_plan.total_stytem'+i).value = 0; 
						eval('add_sales_plan.total_stytem2'+i).value = 0;
						total_amount_ += parseFloat(filterNum(eval('add_sales_plan.net_total'+i+'_'+j).value));
						total_amount_2 += parseFloat(filterNum(eval('add_sales_plan.net_total_other'+i+'_'+j).value));
					}
				eval('add_sales_plan.satir_net_total_'+j).value = commaSplit(total_amount_);
				eval('add_sales_plan.satir_net_total_other_'+j).value = commaSplit(total_amount_2);
			}
		for(j=1;j<=add_sales_plan.record_num.value;j++)
			for(i=1;i<=<cfoutput>#listlen(ay_list())#</cfoutput>;i++)
				if(eval("document.add_sales_plan.row_kontrol"+j).value==1)
				{
					total_amount += parseFloat(filterNum(eval('add_sales_plan.net_total'+i+'_'+j).value));
					satir_toplam = filterNum(eval('add_sales_plan.net_total'+i+'_'+j).value);
					if('<cfoutput>#session.ep.money2#</cfoutput>' != '')
					{
						if(type!= undefined)
							eval('add_sales_plan.net_total_other'+i+'_'+j).value = commaSplit(satir_toplam/form_txt_rate2_2);
						other_total_amount += parseFloat(filterNum(eval('add_sales_plan.net_total_other'+i+'_'+j).value));
						satir_toplam_2 = filterNum(eval('add_sales_plan.net_total_other'+i+'_'+j).value);
					}
					eval('add_sales_plan.total_stytem'+i).value = commaSplit(filterNum(eval('add_sales_plan.total_stytem'+i).value) + satir_toplam); 
					eval('add_sales_plan.total_stytem2'+i).value = commaSplit(filterNum(eval('add_sales_plan.total_stytem2'+i).value) + satir_toplam_2); 
				}
		add_sales_plan.total_amount.value = commaSplit(total_amount);
		add_sales_plan.other_total_amount.value = commaSplit(total_amount/form_txt_rate2_);
		add_sales_plan.satir_total_stytem.value = commaSplit(total_amount);
		if('<cfoutput>#session.ep.money2#</cfoutput>' != '')
			add_sales_plan.satir_total_stytem2.value = commaSplit(other_total_amount);
		add_sales_plan.tl_value1.value = list_getat(deger_diger_para,1,',');
	}
	function kontrol()
	{	
		var record_exist=0;
		say=0;
		for(r=1;r<=add_sales_plan.record_num.value;r++)
		{
			if(eval("document.add_sales_plan.row_kontrol"+r).value==1)
			{
				record_exist=1;
			}
		}
		if (document.add_sales_plan.paper_no.value == '') 
		{
			alert("<cf_get_lang dictionary_id ='58556.Belge No Giriniz'> !");
			document.getElementById("paper_no").focus();
			return false;
		}
		if (document.add_sales_plan.sale_scope.value == '') 
		{
			alert("<cf_get_lang dictionary_id ='41618.Lütfen Kapsam Seçiniz'> !");
			return false;
		}
		if (record_exist == 0) 
		{
			alert("<cf_get_lang dictionary_id='41592.Lütfen Satır Giriniz'>!");
			return false;
		}
		if(document.add_sales_plan.sale_scope.value == 1)//Satış Bölgesi Bazında
		{
			for(j=1;j<=add_sales_plan.record_num.value;j++)
				if(eval("document.add_sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.add_sales_plan.plan_year.value + "*" + eval("document.add_sales_plan.plan_scope_id"+j).value;
					var zone_control = wrk_safe_query("slsp_zone_control_2",'dsn',0,listParam);
					if(zone_control.recordcount)
					{
						alert ("<cf_get_lang dictionary_id ='41619.Seçilen Satış Bölgesi İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.add_sales_plan.sale_scope.value == 2)//Şube Bazında
		{
			for(j=1;j<=add_sales_plan.record_num.value;j++)
				if(eval("document.add_sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.add_sales_plan.plan_year.value + "*" + eval("document.add_sales_plan.plan_scope_id"+j).value;
					var control = wrk_safe_query("slsp_control",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang dictionary_id ='41620.Seçilen Şube İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.add_sales_plan.sale_scope.value == 3)//Satış Takımı Bazında
		{
			for(j=1;j<=add_sales_plan.record_num.value;j++)
				if(eval("document.add_sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.add_sales_plan.plan_year.value + "*" + eval("document.add_sales_plan.plan_scope_id"+j).value;
					var control = wrk_safe_query("slsp_control_2",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang dictionary_id ='41621.Seçilen Satış Takımı İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.add_sales_plan.sale_scope.value == 4)//Mikro Bölge Bazında
		{
			for(j=1;j<=add_sales_plan.record_num.value;j++)
				if(eval("document.add_sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;	
					var listParam = document.add_sales_plan.plan_year.value + "*" + eval("document.add_sales_plan.plan_scope_id"+j).value;
					var control = wrk_safe_query("slsp_control_3",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang dictionary_id ='41622.Seçilen Mikro Bölge İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.add_sales_plan.sale_scope.value == 5)//Çalışan Bazında
		{
			for(j=1;j<=add_sales_plan.record_num.value;j++)
				if(eval("document.add_sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.add_sales_plan.plan_year.value + "*" + eval("document.add_sales_plan.plan_scope_id"+j).value;
					var control = wrk_safe_query("slsp_control_4",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang dictionary_id ='41623.Seçilen Çalışan İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.add_sales_plan.sale_scope.value == 6)//Müşteri Bazında
		{
			for(j=1;j<=add_sales_plan.record_num.value;j++)
				if(eval("document.add_sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.add_sales_plan.plan_year.value + "*" + eval("document.add_sales_plan.plan_scope_id"+j).value;
					var control = wrk_safe_query("slsp_control_5",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang dictionary_id ='41624.Seçilen Müşteri İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.add_sales_plan.sale_scope.value == 7)//Ürün kategorisi Bazında
		{
			for(j=1;j<=add_sales_plan.record_num.value;j++)
				if(eval("document.add_sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.add_sales_plan.plan_year.value + "*" + eval("document.add_sales_plan.plan_scope_id"+j).value;
					var control = wrk_safe_query("slsp_control_6",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang dictionary_id ='41625.Seçilen Ürün kategorisi İçin İlgili Dönemde Kota Tanımı Yapılmış Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.add_sales_plan.sale_scope.value == 8)//Marka Bazında
		{
			for(j=1;j<=add_sales_plan.record_num.value;j++)
				if(eval("document.add_sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.add_sales_plan.plan_year.value + "*" + eval("document.add_sales_plan.plan_scope_id"+j).value;
					var control = wrk_safe_query("slsp_control_7",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang dictionary_id ='41626.Seçilen Marka İçin İlgili Dönemde Kota Tanımı Yapılmış  Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		else if(document.add_sales_plan.sale_scope.value == 9)//Üye Kategorisi Bazında
		{
			for(j=1;j<=add_sales_plan.record_num.value;j++)
				if(eval("document.add_sales_plan.row_kontrol"+j).value==1)	
				{	
					say++;
					var listParam = document.add_sales_plan.plan_year.value + "*" + eval("document.add_sales_plan.plan_scope_id"+j).value;
					var control = wrk_safe_query("slsp_control_8",'dsn',0,listParam);
					if(control.recordcount)
					{
						alert ("<cf_get_lang dictionary_id ='41627.Seçilen Üye Kategorisi İçin İlgili Dönemde Kota Tanımı Yapılmış ! Satır'>: "+ say);
						return false;
						break;
					}
				}
		}
		unformat_fields();
		return process_cat_control();
		return true;
	}
	function unformat_fields()
	{
		for(j=1;j<=add_sales_plan.record_num.value;j++)
			for(i=1;i<='<cfoutput>#listlen(ay_list())#</cfoutput>';i++)
				if(eval("document.add_sales_plan.row_kontrol"+j).value==1)	
				{
					$("#net_total"+i+"_"+j).val(filterNum($("#net_total"+i+"_"+j).val()));
					$("#net_total_other"+i+"_"+j).val(filterNum($("#net_total_other"+i+"_"+j).val()));
					$("#net_kar"+i+"_"+j).val(filterNum($("#net_kar"+i+"_"+j).val()));
					$("#net_prim"+i+"_"+j).val(filterNum($("#net_prim"+i+"_"+j).val()));
					$("#quantity"+i+"_"+j).val(filterNum($("#quantity"+i+"_"+j).val()));


				}
		for(st=1;st<=add_sales_plan.kur_say.value;st++)
		{
			
			eval('add_sales_plan.txt_rate2_' + st).value = filterNum(eval('add_sales_plan.txt_rate2_' + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('add_sales_plan.txt_rate1_' + st).value = filterNum(eval('add_sales_plan.txt_rate1_' + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	function apply_kar(no)
	{
		for(j=1;j<=document.getElementById('record_num').value;j++)
		{
			if(eval("document.add_sales_plan.row_kontrol"+j).value==1)	
				eval('add_sales_plan.net_kar'+no+'_'+j).value = commaSplit(filterNum(eval('add_sales_plan.set_net_kar_'+no).value));
		}
	}
	function apply_prim(no)
	{
		for(j=1;j<=add_sales_plan.record_num.value;j++)
			if(eval("document.add_sales_plan.row_kontrol"+j).value==1)	
				eval('add_sales_plan.net_prim'+no+'_'+j).value = commaSplit(filterNum(eval('add_sales_plan.set_net_prim_'+no).value));
	}
	function open_file()
	{
		document.getElementById("sales_plan_quota_file").style.display='';
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.popup_add_sales_plan_quota_file<cfif isdefined("attributes.plan_id")>&plan_id=#attributes.plan_id#</cfif></cfoutput>','sales_plan_quota_file',1);
		return false;
	}
</script>
<cfif isdefined("attributes.is_from_file")><!--- Dosya importtan gelmişse satırlar eklenecek --->
	<cfinclude template="../../objects/query/get_sales_plan_quota_row_from_file.cfm">
</cfif>

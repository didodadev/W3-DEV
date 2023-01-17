<cfsetting showdebugoutput="yes">
 <cfquery name="get_account_refl_def" datasource="#dsn2#">
	SELECT
    	*
    FROM
    	ACCOUNT_CLOSED_DEFINITION
    WHERE
    	CLOSED_TYPE = <cfqueryparam cfsqltype="cf_sql_bit" value="1">  
        AND CLOSED_ACCOUNT_CODE IS NOT NULL
</cfquery>
<cfquery name="get_account_closed_def" datasource="#dsn2#">
	SELECT
    	*
    FROM
    	ACCOUNT_CLOSED_DEFINITION
    WHERE
    	CLOSED_TYPE = <cfqueryparam cfsqltype="cf_sql_bit" value="1">  
        AND CLOSED_ACCOUNT_CODE IS NULL 
        AND INCOME = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
</cfquery>
<cfquery name="get_account_closed_def1" datasource="#dsn2#">
	SELECT
    	*
    FROM
    	ACCOUNT_CLOSED_DEFINITION
    WHERE
    	CLOSED_TYPE = <cfqueryparam cfsqltype="cf_sql_bit" value="1">  
        AND CLOSED_ACCOUNT_CODE IS NULL  
        AND INCOME = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
</cfquery>
<cfif get_account_refl_def.recordcount eq 0 and get_account_closed_def.recordcount eq 0 and get_account_closed_def1.recordcount eq 0>
	<cfset defaultRowCount ="5">
<cfelse><!-- sütunu boş olan tarafdaki satır sayısı diğer sutunlarla eşit açılması için yapıldı -->
	<cfscript>
		someArray = [get_account_refl_def.recordcount,get_account_closed_def.recordcount,get_account_closed_def1.recordcount];
		defaultRowCount = arrayMax(someArray);
	</cfscript>
</cfif>
<cfif get_account_refl_def.recordcount and get_account_refl_def.recordcount gt 0> 
	<cfset count1 = get_account_refl_def.recordcount>
<cfelse>	
	<cfset count1 = 0>
</cfif>
<cfif get_account_closed_def.recordcount and get_account_closed_def.recordcount gt 0> 
	<cfset count2 = get_account_closed_def.recordcount>
<cfelse>	
	<cfset count2 = 0>
</cfif>
<cfif get_account_closed_def1.recordcount and get_account_closed_def1.recordcount gt 0> 
	<cfset count3 = get_account_closed_def1.recordcount>
<cfelse>	
	<cfset count3 = 0>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfform name="add_acc" method="post" action="#request.self#?fuseaction=account.emptypopup_add_reflecting_acc_def">
		<cfsavecontent variable="message"> <cf_get_lang dictionary_id="47253.Yansıtma Hesapları Kapanış Tanımları"> </cfsavecontent>
		<cf_box title="#message#">
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<cf_grid_list>
						<input type="hidden" name="is_form_submitted" value="1" />
						<thead>
							<tr>
								<th colspan="4" width="500"><cf_get_lang dictionary_id="48255.Gider Hesaplarının Yansıtmaları"></th>
							</tr>
							<tr>
								<th><a href="javascript://" onClick="addRow1();" title="<cf_get_lang_main no='295.Satır Ekle'>"><i class="fa fa-plus"></i></a></th>
								<th><cf_get_lang dictionary_id="59068.Gider Hesabı Kodu"></th>
								<th><cf_get_lang dictionary_id="59069.Alacaklı Hesaplar"></th> 
								<th><cf_get_lang dictionary_id="60718.Borçlu Hesaplar"></th>
							</tr>
						</thead>
						<tbody id="table_list_1">
							<cfif get_account_refl_def.recordcount>
								<cfoutput query="get_account_refl_def">
									<tr id="myRow1_#currentrow#">
										<td><a href="javascript://" onClick="delRow1(#currentrow#);"><i class="fa fa-minus"></i></a></td>
										<td nowrap>
											<div class="form-group">
												<div class="col col-12">
													<div class="input-group">
														<input type="text" name="acc_code1_closed_#currentrow#" class="kapanis" id="acc_code1_closed_#currentrow#" value="#closed_account_code#" onFocus="auto_acc_code(#currentrow#,1,'closed');" autocomplete="off" onblur="deneme2(#currentrow#);" onchange="kapanisFunction('acc_code1_closed_#currentrow#','#currentrow#');" onblur="kapanisFunction('acc_code1_closed_#currentrow#','#currentrow#');">
														<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code1_closed_#currentrow#&field_id2=add_acc.acc_code1_claim_#currentrow#&changeFunction=kapanisFunction&changeFunctionParam=acc_code1_closed_#currentrow#&changeFunctionParam2=#currentrow#','list');"></span>
													</div>
												</div>
											</div>		
										</td>
										<td nowrap>
											<div class="form-group">
												<div class="col col-12">
													<div class="input-group">
														<input type="text" name="acc_code1_claim_#currentrow#" id="acc_code1_claim_#currentrow#" class="alacaklar" value="#claim_account_code#" onFocus="auto_acc_code(#currentrow#,1,'claim');" autocomplete="off" onchange="alacakFunction('acc_code1_claim_#currentrow#');" onblur="alacakFunction('acc_code1_claim_#currentrow#');">
														<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code1_claim_#currentrow#&changeFunction=alacakFunction&changeFunctionParam=acc_code1_claim_#currentrow#&changeFunctionParam2=#currentrow#','list');"></span>
													</div>
												</div>
											</div>
										</td>
										<td nowrap>
											<div class="form-group">
												<div class="col col-12">
													<div class="input-group">
														<input type="text" name="acc_code1_debt_#currentrow#" id="acc_code1_debt_#currentrow#" value="#debt_account_code#" onFocus="auto_acc_code(#currentrow#,1,'debt');" autocomplete="off" onblur="deneme(#currentrow#);" >
														<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code1_debt_#currentrow#&field_id2=add_acc.acc_code2_claim_#currentrow#','list');"></span>
													</div>
												</div>
											</div>	
										</td>
									</tr>
								</cfoutput>  
							<cfelse>          
								<cfoutput>
									<cfloop from="1" to="#defaultRowCount#" index="i">
										<cfset count1 += 1>
										<tr id="myRow1_#i#">
											<td><a href="javascript://" onClick="delRow1(#i#);"><i class="fa fa-minus"></i></a></td>
											<td nowrap>
												<div class="form-group">
													<div class="col col-12">
														<div class="input-group">
															<input class="kapanis" type="text" name="acc_code1_closed_#i#" id="acc_code1_closed_#i#" onFocus="auto_acc_code(#i#,1,'closed');" autocomplete="off" onblur="deneme2(#i#);" onchange="kapanisFunction('acc_code1_closed_#i#','#i#');" onblur="kapanisFunction('acc_code1_closed_#i#','#i#')">
															<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code1_closed_#i#&field_id2=add_acc.acc_code1_claim_#i#&changeFunction=kapanisFunction&changeFunctionParam=acc_code1_closed_#i#&changeFunctionParam2=#i#','list');"></span>
														</div>
													</div>
												</div>
											</td>
											<td nowrap>
												<div class="form-group">
													<div class="col col-12">
														<div class="input-group">
															<input class="alacaklar" type="text" name="acc_code1_claim_#i#" id="acc_code1_claim_#i#" onFocus="auto_acc_code(#i#,1,'claim');" autocomplete="off" onchange="alacakFunction('acc_code1_claim_#i#');" onblur="alacakFunction('acc_code1_claim_#i#');">
															<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code1_claim_#i#&changeFunction=alacakFunction&changeFunctionParam=acc_code1_claim_#i#&changeFunctionParam2=#i#','list');"></span>
														</div>
													</div>
												</div>	
											</td>
											<td nowrap>
												<div class="form-group">
													<div class="col col-12">
														<div class="input-group">
															<input type="text" name="acc_code1_debt_#i#" id="acc_code1_debt_#i#" onFocus="auto_acc_code(#i#,1,'debt');" autocomplete="off" onblur="deneme(#i#);">
															<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code1_debt_#i#&field_id2=add_acc.acc_code2_claim_#i#','list');"></span>
														</div>
													</div>
												</div>	
											</td>
										</tr>
									</cfloop>
								</cfoutput>  
							</cfif>                      
						</tbody>
					</cf_grid_list>        
				</div>        
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<cf_grid_list>
						<thead>
							<tr>
								<th colspan="3" width="500"><cf_get_lang dictionary_id="49722.Yansıtmaların Kapanması İşlemi"></th>
							</tr>
							<tr>
								<th><a href="javascript://" onClick="addRow1();"><i class="fa fa-plus"></i></a></th>
								<th><cf_get_lang dictionary_id="59069.Alacaklı Hesaplar"></th>
								<th><cf_get_lang dictionary_id="60718.Borçlu Hesaplar"></th>
							</tr>
						</thead>
						<tbody id="table_list_2">
							<cfif get_account_closed_def.recordcount>
								<cfoutput query="get_account_closed_def">
									<tr id="myRow2_#currentrow#">
										<td><a href="javascript://" onClick="delRow2(#currentrow#);"><i class="fa fa-minus"></i></a></td>
										<td nowrap>
											<div class="form-group">
												<div class="col col-12">
													<div class="input-group">
														<input type="text" name="acc_code2_claim_#currentrow#" id="acc_code2_claim_#currentrow#" value="#claim_account_code#" onFocus="auto_acc_code(#currentrow#,2,'claim');" autocomplete="off" >
														<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code2_claim_#currentrow#','list');"></span>
													</div>
												</div>
											</div>	
										</td>   
										<td nowrap>
											<div class="form-group">
												<div class="col col-12">
													<div class="input-group">
														<input type="text" name="acc_code2_debt_#currentrow#" id="acc_code2_debt_#currentrow#" value="#debt_account_code#" onFocus="auto_acc_code(#currentrow#,2,'debt');" autocomplete="off" onblur="deneme1(#currentrow#);">
														<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code2_debt_#currentrow#&field_id2=add_acc.acc_code3_claim_#currentrow#','list');"></span>
													</div>
												</div>
											</div>
										</td>
									</tr>
								</cfoutput>            
							<cfelse>
								<cfoutput> 
									<cfloop from="1" to="#defaultRowCount#" index="i">
										<cfset count2 += 1>
										<tr id="myRow2_#i#">
											<td><a href="javascript://" onClick="delRow2(#i#);"><i class="fa fa-minus"></i></a></td>
											<td nowrap>
												<div class="form-group">
													<div class="col col-12">
														<div class="input-group">
															<input type="text" name="acc_code2_claim_#i#" id="acc_code2_claim_#i#" onFocus="auto_acc_code(#i#,2,'claim');" autocomplete="off">
															<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code2_claim_#i#','list');"></span>
														</div>
													</div>
												</div>
											</td>
											<td nowrap>
												<div class="form-group">
													<div class="col col-12">
														<div class="input-group">
															<input type="text" name="acc_code2_debt_#i#" id="acc_code2_debt_#i#" onFocus="auto_acc_code(#i#,2,'debt');" autocomplete="off" onblur="deneme1(#i#);">
															<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code2_debt_#i#&field_id2=add_acc.acc_code3_claim_#i#','list');"></span>
														</div>
													</div>
												</div>
											</td>
										</tr>
									</cfloop>
								</cfoutput>
							</cfif>  
						</tbody>
					</cf_grid_list>        
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<cf_grid_list>
						<thead>
							<tr>
								<th  colspan="3" width="500"><cf_get_lang dictionary_id="49723.Gelir Tablosu Hesaplarının Kapanması İşlemi"></th>
							</tr>
							<tr>
								<th><a href="javascript://" onClick="addRow1();"><i class="fa fa-plus"></i></a></th>
								<th><cf_get_lang dictionary_id="59069.Alacaklı Hesaplar"></th>
								<th><cf_get_lang dictionary_id="60718.Borçlu Hesaplar"></th>
							</tr>
						</thead>
						<tbody id="table_list_3">
							<cfif get_account_closed_def1.recordcount>
								<cfoutput query="get_account_closed_def1">
									<tr id="myRow3_#currentrow#">
										<td><a href="javascript://" onClick="delRow3(#currentrow#);"><i class="fa fa-minus"></i></a></td>
										<td nowrap>
											<div class="form-group">
												<div class="col col-12">
													<div class="input-group">
														<input type="text" name="acc_code3_claim_#currentrow#" id="acc_code3_claim_#currentrow#" value="#claim_account_code#" onFocus="auto_acc_code(#currentrow#,3,'claim');" autocomplete="off" >
														<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code3_claim_#currentrow#','list');"></span>
													</div>
												</div>
											</div>		
										</td>   
										<td nowrap>
											<div class="form-group">
												<div class="col col-12">
													<div class="input-group">
														<input type="text" name="acc_code3_debt_#currentrow#" id="acc_code3_debt_#currentrow#" value="#debt_account_code#" onFocus="auto_acc_code(#currentrow#,3,'debt');" autocomplete="off">
														<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code3_debt_#currentrow#','list');"></span>
													</div>
												</div>
											</div>
										</td>
									</tr>
								</cfoutput>            
							<cfelse>    
								<cfoutput> 
									<cfloop from="1" to="#defaultRowCount#" index="i">
										<cfset count3 += 1>
										<tr id="myRow3_#i#">
											<td><a href="javascript://" onClick="delRow3(#i#);"><i class="fa fa-minus"></i></a></td>
											<td nowrap>
												<div class="form-group">
													<div class="col col-12">
														<div class="input-group">
															<input type="text" name="acc_code3_claim_#i#" id="acc_code3_claim_#i#" onFocus="auto_acc_code(#i#,3,'claim');" autocomplete="off">
															<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code3_claim_#i#','list');"></span>
														</div>
													</div>
												</div>	
											</td>
											<td nowrap>
												<div class="form-group">
													<div class="col col-12">
														<div class="input-group">
															<input type="text" name="acc_code3_debt_#i#" id="acc_code3_debt_#i#" onFocus="auto_acc_code(#i#,3,'debt');" autocomplete="off">
															<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code3_debt_#i#','list');"></span>
														</div>
													</div>
												</div>
											</td>
										</tr>
									</cfloop>
								</cfoutput>
							</cfif>
						</tbody>
					</cf_grid_list>        
				</div>
			</div>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cfinput type="hidden" name="rowCount1" id="rowCount1" value="#count1#">
				<cfinput type="hidden" name="rowCount2" id="rowCount2" value="#count2#">
				<cfinput type="hidden" name="rowCount3" id="rowCount3" value="#count3#">
				<cf_box_footer>
					<cf_record_info query_name="get_account_refl_def">
					<cf_workcube_buttons type_format="1" is_upd='0' add_function="kontrol()">
				</cf_box_footer>
			</div>
		</cf_box>
	</cfform>
</div>
<script type="text/javascript">
	<cfoutput>
	rowCount1 = '#count1#';
	rowCount2 = '#count2#';
	rowCount3 = '#count3#';
	</cfoutput>
	function kontrol()
	{		
		//gider hesaplarının yansıtmaları
		var myArray_closed1 = [];
		var myArray_claim1 = [];	
		for(var m = 1; m <= rowCount1; m++)
		{
			var closed1 = document.getElementById('acc_code1_closed_'+m).value;
			var claim1 = document.getElementById('acc_code1_claim_'+m).value;
			var debt1 = document.getElementById('acc_code1_debt_'+m).value;
			if((closed1 != '' || claim1 != '' || debt1 != '') && (closed1 == '' || claim1 == '' || debt1 == '')) //bir tanesi doluysa ama hepsi dolu değilse
			{
				alert('Eksik alan !');	
				return false;
			}
			if(closed1 != '')
				myArray_closed1.push(closed1);
			if(claim1 != '')
				myArray_claim1.push(claim1);	
		}
		
		uniqueArray_closed1 = myArray_closed1.filter(function(elem, pos) {
    		return myArray_closed1.indexOf(elem) == pos;})	
		uniqueArray_claim1 = myArray_claim1.filter(function(elem, pos) {
    		return myArray_claim1.indexOf(elem) == pos;})			
		//yansıtmaların kapatılması
		var myArray_claim2 = [];	
		for(var n = 1; n <= rowCount2; n++)
		{
			var claim2 = document.getElementById('acc_code2_claim_'+n).value;
			var debt2 = document.getElementById('acc_code2_debt_'+n).value;
			if((claim2 != '' || debt2 != '') && (claim2 == '' || debt2 == '')) //bir tanesi doluysa ama hepsi dolu değilse
			{
				alert("<cf_get_lang dictionary_id='30594.Eksik alan'>");	
				return false;
			}
			if(claim2 != '')
				myArray_claim2.push(claim2);
		}
		uniqueArray_claim2 = myArray_claim2.filter(function(elem, pos) {
    		return myArray_claim2.indexOf(elem) == pos;})					
		//gider hesaplarının yansıtmalarında alt hesabı olan alacaklı ve borçlu hesaplar seçilemez		
		for(var k = 1; k <= rowCount1; k++)
		{
			get_claim_subaccount_1 = wrk_query("SELECT ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE LIKE '" +document.getElementById('acc_code1_claim_'+k).value+ ".%'","dsn2");
			if(get_claim_subaccount_1.recordcount)	
			{
				alert("<cf_get_lang dictionary_id='30592.Gider hesaplarının yansıtmalarında alt hesabı olan alacaklı hesap seçilemez'> :" + document.getElementById('acc_code1_claim_'+k).value + "");
				return false;	
			}
			get_debt_subaccount_1 = wrk_query("SELECT ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE LIKE '" +document.getElementById('acc_code1_debt_'+k).value+ ".%'","dsn2");
			if(get_debt_subaccount_1.recordcount)	
			{ 
				alert("<cf_get_lang dictionary_id='30587.Gider hesaplarının yansıtmalarında alt hesabı olan borçlu hesap seçilemez'>:" + document.getElementById('acc_code1_debt_'+k).value);
				return false;	
			}
			
		}
		for(var j = 1; j <= rowCount2; j++)
		{
			get_claim_subaccount_2 = wrk_query("SELECT ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE LIKE '" +document.getElementById('acc_code2_claim_'+j).value+ ".%'","dsn2");
			if(get_claim_subaccount_2.recordcount)	
			{
				alert("<cf_get_lang dictionary_id='30571.Yansıtmaların kapanmasında alt hesabı olan alacaklı hesap seçilemez'>:" + document.getElementById('acc_code2_claim_'+j).value);
				return false;	
			}
		}
	}
	function addRow1()
	{
		rowCount1++;
		add_acc.rowCount1.value = rowCount1;
		var newRow1;
		var newCell1;
		newRow1 = document.getElementById("table_list_1").insertRow(document.getElementById("table_list_1").rows.length);
		newRow1.setAttribute("id", "myRow1_"+rowCount1);
		
		newCell1 = newRow1.insertCell(newRow1.cells.length);
		newCell1.innerHTML = '<a href="javascript://" onClick="delRow1(' + rowCount1 + ');"><img src="/images/delete_list.gif"></a>';

		newCell1 = newRow1.insertCell(newRow1.cells.length);
		newCell1.innerHTML =  '<div class="form-group"><div class="col col-12"><div class="input-group"><input type="text" class="kapanis" name="acc_code1_closed_' + rowCount1 + '" id="acc_code1_closed_' + rowCount1 + '" onFocus="auto_acc_code(' + rowCount1 + ',1,\'closed\');" onblur="deneme2('+rowCount1+');" autocomplete="off" onchange="kapanisFunction(\'acc_code1_closed_\' + rowCount1+);"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code1_closed_'+rowCount1+'&field_id2=add_acc.acc_code1_claim_'+rowCount1+'&changeFunction=kapanisFunction&changeFunctionParam=acc_code1_closed_'+rowCount1+'&changeFunctionParam2='+rowCount1+'\',\'list\');"></span></div></div></div>';   

		newCell1 = newRow1.insertCell(newRow1.cells.length);
		newCell1.innerHTML =  '<div class="form-group"><div class="col col-12"><div class="input-group"><input type="text" class="alacaklar" name="acc_code1_claim_' + rowCount1 + '" id="acc_code1_claim_' + rowCount1 + '" onFocus="auto_acc_code(' + rowCount1 + ',1,\'claim\');" autocomplete="off" onchange="alacakFunction(\'acc_code1_claim_\' + rowCount1+);"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code1_claim_'+rowCount1+'&changeFunction=kapanisFunction&changeFunctionParam=acc_code1_claim_'+rowCount1+'&changeFunctionParam2='+rowCount1+'\',\'list\');"></span></div></div></div>';

		newCell1 = newRow1.insertCell(newRow1.cells.length);
		newCell1.innerHTML =  '<div class="form-group"><div class="col col-12"><div class="input-group"><input type="text" name="acc_code1_debt_' + rowCount1 + '" id="acc_code1_debt_' + rowCount1 + '" onFocus="auto_acc_code(' + rowCount1 + ',1,\'debt\');" onblur="deneme('+rowCount1+');" autocomplete="off"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_acc.acc_code1_debt_'+rowCount1+'&field_id2=add_acc.acc_code2_claim_'+rowCount1+'\',\'list\');"></span></div></div></div>';  
		
		
		rowCount2++;
		add_acc.rowCount2.value = rowCount2;
		var newRow2;
		var newCell2;
		newRow2 = document.getElementById("table_list_2").insertRow(document.getElementById("table_list_2").rows.length);
		newRow2.setAttribute("id", "myRow2_"+rowCount2);
		
		newCell2 = newRow2.insertCell(newRow2.cells.length);
		newCell2.innerHTML = '<a href="javascript://" onClick="delRow2(' + rowCount2 + ');"><img src="/images/delete_list.gif"></a>';
		
		newCell2 = newRow2.insertCell(newRow2.cells.length);
		newCell2.innerHTML =  '<div class="form-group"><div class="col col-12"><div class="input-group"><input type="text" name="acc_code2_claim_' + rowCount2 + '" id="acc_code2_claim_' + rowCount2 + '" onFocus="auto_acc_code(' + rowCount2 + ',2,\'claim\');" autocomplete="off"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code2_claim_'+rowCount2+'\',\'list\');"></span></div></div></div>';

		newCell2 = newRow2.insertCell(newRow2.cells.length);
		newCell2.innerHTML =  '<div class="form-group"><div class="col col-12"><div class="input-group"><input type="text" name="acc_code2_debt_' + rowCount2 + '" id="acc_code2_debt_' + rowCount2 + '" onblur="deneme1('+rowCount2+');" onFocus="auto_acc_code(' + rowCount2 + ',2,\'debt\');" autocomplete="off"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_acc.acc_code2_debt_'+rowCount2+'&field_id2=add_acc.acc_code3_claim_'+rowCount2+'\',\'list\');"></span></div></div></div>';
		
		
		rowCount3++;
		add_acc.rowCount3.value = rowCount3;
		var newRow3;
		var newCell3;
		newRow3 = document.getElementById("table_list_3").insertRow(document.getElementById("table_list_3").rows.length);
		newRow3.setAttribute("id", "myRow3_"+rowCount3);
		
		newCell3 = newRow3.insertCell(newRow3.cells.length);
		newCell3.innerHTML = '<a href="javascript://" onClick="delRow3(' + rowCount3 + ');"><img src="/images/delete_list.gif"></a>';
		
		newCell3 = newRow3.insertCell(newRow3.cells.length);
		newCell3.innerHTML =  '<div class="form-group"><div class="col col-12"><div class="input-group"><input type="text" name="acc_code3_claim_' + rowCount3 + '" id="acc_code3_claim_' + rowCount3 + '" onFocus="auto_acc_code(' + rowCount3 + ',3,\'claim\');" autocomplete="off"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code3_claim_'+rowCount3+'\',\'list\');"></span></div></div></div>';

		newCell3 = newRow3.insertCell(newRow3.cells.length);
		newCell3.innerHTML =  '<div class="form-group"><div class="col col-12"><div class="input-group"><input type="text" name="acc_code3_debt_' + rowCount3 + '" id="acc_code3_debt_' + rowCount3 + '" onFocus="auto_acc_code(' + rowCount3 + ',3,\'debt\');" autocomplete="off"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_acc.acc_code3_debt_'+rowCount3+'\',\'list\');"></span></div></div></div>';
		
	}
	function delRow1(row)
	{
		document.getElementById('acc_code1_closed_'+row).value = '';
		document.getElementById('acc_code1_claim_'+row).value = '';
		document.getElementById('acc_code1_debt_'+row).value = '';
		document.getElementById('myRow1_'+row).style.display = 'none';
		//rowCount1--;
	}
	function delRow2(row)
	{
		document.getElementById('acc_code2_claim_'+row).value = '';
		document.getElementById('acc_code2_debt_'+row).value = '';
		document.getElementById('myRow2_'+row).style.display = 'none';
		//rowCount2--;
		
	}
	function delRow3(row)
	{
		document.getElementById('acc_code3_claim_'+row).value = '';
		document.getElementById('acc_code3_debt_'+row).value = '';
		document.getElementById('myRow3_'+row).style.display = 'none';
		//rowCount3--;
		
	}	
	function auto_acc_code(no,table,num)
	{	
		/*if((table == 1 && (num == 'claim' || num == 'debt')) || (table == 2 && num == 'claim'))
			AutoComplete_Create('acc_code'+table+'_'+num+'_'+no,'ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','CODE_NAME','','','3','250');
		else*/
			AutoComplete_Create('acc_code'+table+'_'+num+'_'+no,'ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','1','CODE_NAME','','','3','250');
	}	
	function deneme(row)
	{
		document.getElementById("acc_code2_claim_"+row).value = document.getElementById("acc_code1_debt_"+row).value;
	}	
	function deneme1(row)
	{
		document.getElementById("acc_code3_claim_"+row).value = document.getElementById("acc_code2_debt_"+row).value;
	}
	function deneme2(row)
	{
		document.getElementById("acc_code1_claim_"+row).value = document.getElementById("acc_code1_closed_"+row).value;
	}
	function kapanisFunction(inputID,satir)
	{
		inputValue = $("#"+inputID).val();
		$(".kapanis").each(function(index) {
			if($(this).val() == inputValue && satir!=(index+1))
			{
				alert("<cf_get_lang dictionary_id='30553.Seçmiş olduğunuz değer mevcuttur'> <cf_get_lang dictionary_id='58508.satır no'> :" + (index+1) + "<cf_get_lang dictionary_id='30552.Seçiminizi yenileyiniz'>");
				$("#"+inputID).val('');
				$("#acc_code1_claim_"+satir).val('');
				return false;
			}
		});		
	}
	function alacakFunction(inputID,satir)
	{
		inputValue = $("#"+inputID).val();
		$(".alacaklar").each(function(index) {
			if($(this).val() == inputValue && satir!=(index+1))
			{
				alert("<cf_get_lang dictionary_id='30553.Seçmiş olduğunuz değer mevcuttur'> <cf_get_lang dictionary_id='58508.satır no'> : " + (index+1) + "<cf_get_lang dictionary_id='30552.Seçiminizi yenileyiniz'>");
				$("#"+inputID).val('');
				return false;
			}
		});
	}
</script>


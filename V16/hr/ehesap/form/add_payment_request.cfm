<cf_xml_page_edit fuseact="ehesap.popup_add_payment_request">
<cfinclude template="../query/get_priority.cfm">
<cfquery name="all_pos_cats" datasource="#DSN#">
	SELECT 
		POSITION_CAT_ID,
		POSITION_CAT
	FROM
		SETUP_POSITION_CAT
	ORDER BY
		POSITION_CAT
</cfquery>
<cfinclude template="../query/get_all_branches.cfm">

<cfif isdefined("attributes.pos_cat_id") and isdefined('attributes.is_submit') and attributes.is_submit eq 1>
	<cfquery name="get_poscat_positions" datasource="#dsn#">
		SELECT
			E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME,E.EMPLOYEE_ID,EIO.IN_OUT_ID,D.DEPARTMENT_HEAD,B.BRANCH_NAME
		FROM
			EMPLOYEES_IN_OUT EIO,
			EMPLOYEE_POSITIONS EP,
			EMPLOYEES E,
			DEPARTMENT D,
			BRANCH B
		WHERE
			<cfif len(attributes.branch_id)>
			B.BRANCH_ID = #attributes.branch_id# AND
			</cfif>
			E.EMPLOYEE_ID=EIO.EMPLOYEE_ID AND
			EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
			D.DEPARTMENT_ID=EIO.DEPARTMENT_ID AND
			D.BRANCH_ID=B.BRANCH_ID AND
			<cfif len(attributes.pos_cat_id)>
				EIO.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CAT_ID = #attributes.pos_cat_id# AND POSITION_STATUS = 1 AND EMPLOYEE_ID > 0) AND
			</cfif>
			<cfif Len(attributes.collar_type)>
					EP.COLLAR_TYPE = #attributes.collar_type# AND
			</cfif>
			EP.IS_MASTER = 1 AND
			EIO.FINISH_DATE IS NULL
		ORDER BY
			EMPLOYEE_NAME
	</cfquery>
</cfif>
<cfquery name="get_demand_type" datasource="#dsn#">
	SELECT * FROM SETUP_PAYMENT_INTERRUPTION WHERE ISNULL(IS_DEMAND,0) = 1
</cfquery>
<script type="text/javascript">
	<cfif isdefined('attributes.is_submit') and attributes.is_submit eq 1 and isdefined("get_poscat_positions") and get_poscat_positions.recordcount>
		row_count=<cfoutput>#get_poscat_positions.recordcount#</cfoutput>;
	<cfelse>
		row_count=0;
	</cfif>
</script>
<cfquery name="PAY_METHODS" datasource="#DSN#">
	SELECT 	
		SP.* 
	FROM 
		SETUP_PAYMETHOD SP,
		SETUP_PAYMETHOD_OUR_COMPANY SPOC
	WHERE 
		SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
		AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>		
<cfquery name="GET_REQUEST_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%ehesap.popup_add_payment_request%">
	ORDER BY 
		PTR.LINE_NUMBER
</cfquery>
<cfif not get_request_stage.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='54610.Avans Süreçleri Tanımlı Değil'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfinclude template="../query/get_setup_moneys.cfm">
<input type="hidden" name="hepsi_onayli" id="hepsi_onayli" value="<cfif session.ep.ehesap eq 1>1<cfelse>0</cfif>">
<cfif fuseaction contains "popup">
	<cfset is_popup=1>
<cfelse>
	<cfset is_popup=0>
</cfif>
<cfsavecontent variable="right">
   
	<li><cfoutput><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.popup_add_payment_request_file','payment_req_file',1)"><i class="fa fa-file-text-o" title="#getLang('main',2576)#"></i></a></cfoutput>	 </li>
</cfsavecontent>
<cfparam name="attributes.modal_id" default="">
<div class="col col-12 col-xs-12">
	<cf_box title="#getLang('','Avans Talepleri',52972)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" right_images="#right#">
		<cfform name="add_payment_request" action="#request.self#?fuseaction=ehesap.list_payment_requests&event=add" method="post" enctype="multipart/form-data">
			<input type="hidden" name="is_submit" id="is_submit" value="1">
			<cf_box_search more="0">
				<div class="form-group" id="payment_req_file" style="display:none;z-index:99; position:absolute; width:100%; float:right; left:0;"></div>
				<div class="form-group" id="item-pos_cat_id">
					<select name="pos_cat_id" id="pos_cat_id">
						<option value=""><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></option>
						<cfoutput query="all_pos_cats">
							<option value="#POSITION_CAT_ID#"<cfif isdefined("attributes.pos_cat_id") and (POSITION_CAT_ID eq attributes.pos_cat_id)> selected</cfif>>#POSITION_CAT#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="item-pos_cat_id">
					<select name="branch_id" id="branch_id">
						<option value="" ><cf_get_lang dictionary_id="57453.Şube"></option>
						<cfoutput query="get_all_branches">
							<option value="#branch_id#"<cfif isdefined("attributes.branch_id") and (branch_id eq attributes.branch_id)> selected</cfif>>#branch_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="item-collar_type">
					<select name="collar_type" id="collar_type">
						<option value=""><cf_get_lang dictionary_id='54054.Yaka Tipi'></option>
						<option value="1"<cfif isdefined("attributes.collar_type") and attributes.collar_type eq 1> selected</cfif>><cf_get_lang dictionary_id='54055.Mavi Yaka'></option> 
						<option value="2"<cfif isdefined("attributes.collar_type") and attributes.collar_type eq 2> selected</cfif>><cf_get_lang dictionary_id='54056.Beyaz Yaka'></option>
					</select>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4"  search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_payment_request' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
	
        <cfform name="form_add_payment_request" action="#request.self#?fuseaction=ehesap.emptypopup_add_payment_request" method="post" onsubmit="return (UnformatFields());">
            <input type="hidden" name="request_stage" id="request_stage" value="<cfif get_request_stage.recordcount><cfoutput>#get_request_stage.process_row_id#</cfoutput></cfif>">
			<input type="hidden" name="modal_id" id="modal_id" value="<cfoutput>#attributes.modal_id#</cfoutput>">
				<cf_box_elements>
					<div class="col col-6 col-xs-12" type="column" index="1">
						<div class="form-group" id="item-subject">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58820.Başlık'></cfsavecontent>
								<cfinput type="text" name="subject" id="subject" required="Yes" message="#message#">
							</div>
						</div>
						<div class="form-group" id="item-priority">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57485.Öncelik'></label>
							<div class="col col-8 col-xs-12">
								<select name="priority" id="priority">
									<cfoutput query="get_priority">
										<option value="#get_priority.priority_id#"> #priority# </option>
									</cfoutput>
								</select>					    
								<input type="hidden" name="record_num" id="record_num" value="">
							</div>
						</div>
						
					</div>
					<div class="col col-6 col-xs-12" type="column" index="2">
						<div class="form-group" id="item-duedate">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53328.Son Ödeme Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='53328.Son Ödeme Tarihi'></cfsavecontent>
									<cfinput validate="#validate_style#" required="Yes" message="#message#" type="text" name="duedate" id="duedate">
									<span class="input-group-addon"><cf_wrk_date_image date_field="duedate"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-detail">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Konu'></label>
							<div class="col col-8 col-xs-12">
								<textarea name="detail" id="detail"></textarea>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_grid_list>
					<thead>
						<tr>
							<th width="20"></th>
							<th width="200"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57576.Çalışan'> / <cf_get_lang dictionary_id='57673.Tutar'></th>
							<th width="150"><cf_get_lang dictionary_id='57673.Tutar'></th>
							<th><cf_get_lang dictionary_id='57489.Para Brimi'></th>
							<cfif xml_pay_method eq 1><th><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th></cfif>
							<cfif isdefined("xml_show_demand_type") and xml_show_demand_type eq 1><th><cf_get_lang dictionary_id='31578.Avans Tipi'></th></cfif>
							<th><cf_get_lang dictionary_id ='58859.Süreç'></th>
						</tr>
						<tr>
							<td></td>
							<td><input type="text" name="total_emp" id="total_emp" class="box" value="" style="width:80px;" readonly="readonly"> / <input type="text" name="total_amount" id="total_amount" class="box" value="" style="width:100px;" readonly="readonly"></td>
							<td><input type="text" name="total0" id="total0" style="width:150px;" class="moneybox" value="" onkeyup="FormatCurrency(this,event,2,'float');hepsi(row_count,'total');"  onChange="hepsi(row_count,'total');" onClick="hepsi(row_count,'total');"></td>
							<td>
								<div class="form-group">
									<select name="money0" id="money0" style="width:100px;" onChange="hepsi(row_count,'money');" onClick="hepsi(row_count,'money');">
										<cfoutput query="get_moneys">
											<option value="#money#" <cfif session.ep.money eq get_moneys.money>selected</cfif>>#money#</option>
										</cfoutput>
									</select>
								</div>
							</td>
							<cfif xml_pay_method eq 1>
							<td>
								<div class="form-group">
									<select name="pay_method0" id="pay_method0" style="width:150px;" onChange="hepsi(row_count,'pay_method');" onClick="hepsi(row_count,'pay_method');">
										<cfoutput query="PAY_METHODS">
											<option value="#PAYMETHOD_ID#" >#PAYMETHOD#</option>
										</cfoutput>
									</select>
								</div>
							</td>
							</cfif>
							<cfif isdefined("xml_show_demand_type") and xml_show_demand_type eq 1>
								<td>
									<div class="form-group" >
									
										<select name="demand_type0" id="demand_type0" onChange="hepsi(row_count,'demand_type');" onClick="hepsi(row_count,'demand_type');">
											
											<cfoutput query="get_demand_type">
												<option value="#odkes_id#">#comment_pay#</option>
											</cfoutput>
										</select>
									</div>
								</td>
									
							</cfif>
							<td>
								<div class="form-group">
									<select name="process_stage0" id="process_stage0" onChange="hepsi(row_count,'process_stage');">
										<cfoutput query="GET_REQUEST_STAGE">
											<option value="#process_row_id#">#stage#</option>
										</cfoutput>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<th width="20" id="add0"><a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='44630.Ekle'>" alt="<cf_get_lang dictionary_id='44630.Ekle'>"></i></th>
							<th width="20" id="employee0"><cf_get_lang dictionary_id='57576.Çalışan'></th>
							<th id="total0"><cf_get_lang dictionary_id='57673.Tutar'></th>
							<th id="money0"><cf_get_lang dictionary_id='57489.Para Br'></th>
							<cfif xml_pay_method eq 1><th id="paymethod0"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th></cfif>
							<cfif isdefined("xml_show_demand_type") and xml_show_demand_type eq 1><th id="demand_type0"><cf_get_lang dictionary_id='31578.Avans Tipi'></th></cfif>
							<th><cf_get_lang dictionary_id ='58859.Süreç'></th>
						</tr>
					</thead>
					<tbody id="table1">
					<cfif isdefined("get_poscat_positions")>
						<cfoutput query="get_poscat_positions">
							<tr id="my_row_#currentrow#">
								<td style="align:center;"><a style="cursor:pointer" onclick="sil(#currentrow#);" ><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
								<td nowrap>
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="is_kidem#currentrow#" id="is_kidem#currentrow#" value="">
											<input type="hidden" name="calc_days#currentrow#" id="calc_days#currentrow#" value="">
											<input  type="hidden"  value="1"  name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#">
											<input type="hidden" name="emp_id#currentrow#" id="emp_id#currentrow#" value="#employee_id#">
											<input type="hidden" name="in_out_id#currentrow#" id="in_out_id#currentrow#" value="#in_out_id#">
											<input name="employee#currentrow#" id="employee#currentrow#" type="text" readonly value="#employee_name# #employee_surname#">
											<span class="input-group-addon icon-ellipsis"  onClick="openBoxDraggable('javascript:openBoxDraggable('#request.self#?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=add_ext_salary.employee_in_out_id#currentrow#&field_emp_name=add_ext_salary.employee#currentrow#&field_emp_id=add_ext_salary.employee_id#currentrow#&field_branch_and_dep=add_ext_salary.department#currentrow#' );"></span>
										</div>
									</div>
								</td>
								<td><input type="text" name="total#currentrow#" id="total#currentrow#" class="moneybox" value="" onkeyup="FormatCurrency(this,event,2,'float');toplam_hesapla();" onchange="toplam_hesapla();" onclick="toplam_hesapla();"></td>
								<td>
									<div class="form-group">
										<select name="money#currentrow#" id="money#currentrow#">
											<cfloop query="get_moneys">
												<option value="#money#" <cfif session.ep.money eq get_moneys.money>selected</cfif>>#money#</option>
											</cfloop>
										</select>
									</div>
								</td>
								<cfif xml_pay_method eq 1>
								<td>
									<div class="form-group">
										<select name="pay_method#currentrow#" id="pay_method#currentrow#">
											<cfloop query="PAY_METHODS">
												<option value="#PAYMETHOD_ID#" >#PAYMETHOD#</option>
											</cfloop>
										</select>
									</div>
								</td>
								</cfif>
								<cfif isdefined("xml_show_demand_type") and xml_show_demand_type eq 1>
									<td>
										<div class="form-group" id="item-demand_type">
										
											<select name="demand_type#currentrow#" id="demand_type#currentrow#">
												<cfloop query="get_demand_type">
													<option value="#odkes_id#">#comment_pay#</option>
												</cfloop>
											</select>
										</div>
									</td>
										
								</cfif>
								<td>
									<div class="form-group">
										<select name="process_stage#currentrow#" id="process_stage#currentrow#">
											<cfloop query="GET_REQUEST_STAGE">
												<option value="#process_row_id#">#stage#</option>
											</cfloop>
										</select>
									</div>
								</td>
								</tr>
						</cfoutput>
					</cfif>
					</tbody>
				</cf_grid_list>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function="kontrol_et()">
				</cf_box_footer>
		</cfform>    
	</cf_box>
	
</div>
<script type="text/javascript">
	document.getElementById('record_num').value=row_count;
	function hepsi(satir,nesne,baslangic)
	{
		deger=eval("document.form_add_payment_request."+nesne+"0");
		if(deger.value.length!=0)/*değer boşdegilse çalıştır foru*/
		{
		if(!baslangic){baslangic=1;}/*başlangıc tüm elemanları değlde sadece bir veya bir kaçtane yapacaksak forun başlayacağı sayıyı vererek okadar dönmesini sağlayabilirz*/
			for(var i=baslangic;i<=satir;i++)
			{
				//nesne_tarih=eval("document.form_add_payment_request."+nesne+i);
				//nesne_tarih.value=deger.value;
				nesne_tarih=eval('document.getElementById( nesne + i )');
				nesne_tarih.value=deger.value;
			}
		}
		if(nesne == 'total')
		{
			toplam_hesapla();
		}
	}
	function toplam_hesapla()
	{
		var total_amount = 0;
		var sayac = 0;
		for(var i=1;i<=row_count;i++)
		{
			if(eval("form_add_payment_request.row_kontrol_"+i).value != 0 && eval("document.form_add_payment_request.total"+i).value != 0)
			{
				nesne_tarih=eval("document.form_add_payment_request.total"+i);
				total_amount += parseFloat(filterNum(nesne_tarih.value));
				sayac++
			}
		}
		document.getElementById('total_amount').value = parseFloat(total_amount);
		document.getElementById('total_emp').value = sayac;
	}
	function kontrol_et()
	{
		/*if(row_count ==0)
			return false;*/
		for (i=1;i <= row_count; i++)
			{
			temp_field = eval('document.form_add_payment_request.total'+i);
			if (!(parseFloat(filterNum(temp_field.value)) > 0) && eval("form_add_payment_request.row_kontrol_"+i).value != 0)
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57673.Tutar'>");
					return false;
				}
			emp_id_field  = eval('document.form_add_payment_request.emp_id'+i);
			employee_field = eval('document.form_add_payment_request.employee'+i)
			if(!(emp_id_field.value.length || employee_field.value.length) && eval("form_add_payment_request.row_kontrol_"+i).value != 0)
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57576.Çalışan'>");
					return false;
				}
			}
		<cfif session.ep.ehesap neq 1>
		if (confirm("<cf_get_lang dictionary_id='53603.Tüm Talepleri Onaylamak İster misiniz'> ?"))
			document.getElementById('hepsi_onayli').value = '1';
		else
			document.getElementById('hepsi_onayli').value = '0';
		</cfif>
	}
	function sil(sy)
	{
		var my_element=eval("form_add_payment_request.row_kontrol_"+sy);
		my_element.value=0;
		var my_element=eval("my_row_"+sy);
		my_element.style.display="none";

		toplam_hesapla();
	}
	function add_row(emp_in_out_id,emp_id,employee,total)
	{
		//Normal satır eklerken değişkenler olmadığı için boşluk atıyor
		if(emp_in_out_id == undefined)emp_in_out_id = '';
		if(emp_id == undefined)emp_id = '';
		if(employee == undefined)employee = '';
		if(total == undefined)total = '';
		
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","my_row_" + row_count);
		newRow.setAttribute("id","my_row_" + row_count);		
		newRow.setAttribute("NAME","my_row_" + row_count);
		newRow.setAttribute("ID","my_row_" + row_count);		
		
		document.getElementById('record_num').value=row_count;	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><i class="fa fa-minus" ></i></a>';			
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="in_out_id' + row_count + '" id="in_out_id' + row_count + '" value="' + emp_in_out_id + '"><input type="hidden" name="emp_id' + row_count + '" id="emp_id' + row_count + '" value="' + emp_id + '"><input type="text" name="employee' + row_count + '" id="employee' + row_count + '" style="width:185px;" value="' + employee + '"><input type="hidden" value="1" name="row_kontrol_' + row_count +'" id="row_kontrol_' + row_count +'"><span class="input-group-addon icon-ellipsis"  onclick="opage(' + row_count +');"></span></div></div>';
		
		
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="total' + row_count + '" id="total' + row_count + '" style="width:150px;" class="moneybox" onkeyup=""FormatCurrency(this,event,2,"float");"" value="'+total+'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="money' + row_count + '" id="money' + row_count + '" style="width:100px;"><cfoutput query="get_moneys"><option value="#money#" <cfif session.ep.money eq get_moneys.money>selected</cfif>>#money#</option></cfoutput></select></div>';
		<cfif xml_pay_method eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="pay_method' + row_count + '" id="pay_method' + row_count + '"  style="width:150px;"><cfoutput query="PAY_METHODS"><option value="#PAYMETHOD_ID#" >#PAYMETHOD#</option></cfoutput></select></div>';
		</cfif>
		<cfif xml_show_demand_type eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="demand_type' + row_count + '" id="demand_type' + row_count + '"  style="width:150px;"><cfoutput query="get_demand_type"><option value="#odkes_id#" >#comment_pay#</option></cfoutput></select></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="process_stage' + row_count + '" id="process_stage' + row_count + '"  style="width:150px;"><cfoutput query="GET_REQUEST_STAGE"><option value="#process_row_id#" >#stage#</option></cfoutput></select></div>';
	

	}		
	
	function opage(deger)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=form_add_payment_request.in_out_id'+deger+'&field_emp_id=form_add_payment_request.emp_id' + deger + '&field_emp_name=form_add_payment_request.employee' + deger);
	}	
	
	function UnformatFields()
	{
		for(satir_i=1; satir_i <= row_count; satir_i++)
		{
			var str_me = eval("form_add_payment_request.total" + satir_i);
			str_me.value = filterNum(str_me.value);
		}
	}
	function open_file()
	{
		document.getElementById('payment_req_file').style.display='';
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_add_payment_request_file</cfoutput>','payment_req_file',1);
		return false;
	}
	document.getElementById('payment_req_file').style.marginLeft=screen.width-360;
</script>
<cfif isdefined("attributes.is_from_file")><!--- Dosya importtan gelmişse satırlar eklenecek --->
	<cfinclude template="../query/get_payment_request_row_from_file.cfm">
</cfif>

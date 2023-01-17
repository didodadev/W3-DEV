<cfsavecontent variable="ay1"><cf_get_lang dictionary_id ='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id ='57593.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id ='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id ='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id ='57596.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id ='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id ='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id ='57599.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id ='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id ='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id ='57602.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id ='57603.Aralık'></cfsavecontent>
<cfscript>
</cfscript>
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
<cfif isdefined("attributes.pos_cat_id")>
	<cfquery name="get_poscat_positions" datasource="#dsn#">
		SELECT
			E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME,E.EMPLOYEE_ID,EIO.IN_OUT_ID,D.DEPARTMENT_HEAD,B.BRANCH_NAME
		FROM
			EMPLOYEES_IN_OUT EIO,
			EMPLOYEES E,
			DEPARTMENT D,
			BRANCH B
		WHERE
			<cfif len(attributes.branch_id)>
			B.BRANCH_ID = #attributes.branch_id# AND
			</cfif>
			E.EMPLOYEE_ID=EIO.EMPLOYEE_ID AND
			D.DEPARTMENT_ID=EIO.DEPARTMENT_ID AND
			D.BRANCH_ID=B.BRANCH_ID AND
			<cfif len(attributes.collar_type)>
				EIO.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE COLLAR_TYPE = #attributes.collar_type# AND POSITION_STATUS = 1 AND EMPLOYEE_ID > 0) AND
			</cfif>
			<cfif len(attributes.pos_cat_id)>
				EIO.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CAT_ID = #attributes.pos_cat_id# AND POSITION_STATUS = 1 AND EMPLOYEE_ID > 0) AND
			</cfif>
			EIO.FINISH_DATE IS NULL
		ORDER BY
			EMPLOYEE_NAME
	</cfquery>
	
</cfif>
<script type="text/javascript">
	<cfif isdefined("get_poscat_positions") and get_poscat_positions.recordcount>
		row_count=<cfoutput>#get_poscat_positions.recordcount#</cfoutput>;
	<cfelse>
		row_count=0;
	</cfif>
</script>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="58057.Toplu"></cfsavecontent>
<cfsavecontent variable="message1"><cf_get_lang dictionary_id="54045.Vergi İstisnası Ekle"></cfsavecontent>
<cfset pageHead = #message# & ' ' & #message1#>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
    	<cfform name="add_ext_salary_search" action="#request.self#?fuseaction=ehesap.list_tax_except&event=add" method="post">   
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-pos_cat_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
						<div class="col col-8 col-xs-12">
							<select name="pos_cat_id" id="pos_cat_id">
								<option value="" ><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="all_pos_cats">
									<option value="#POSITION_CAT_ID#"<cfif isdefined("attributes.pos_cat_id") and (POSITION_CAT_ID eq attributes.pos_cat_id)> selected</cfif>>#POSITION_CAT#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-collar_type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54054.yaka tipi'></label>
						<div class="col col-8 col-xs-12">
							<select name="collar_type" id="collar_type">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="1"<cfif isdefined("attributes.collar_type") and attributes.collar_type eq 1> selected</cfif>><cf_get_lang dictionary_id='54055.Mavi Yaka'> 
								<option value="2"<cfif isdefined("attributes.collar_type") and attributes.collar_type eq 2> selected</cfif>><cf_get_lang dictionary_id='54056.Beyaz Yaka'> 
							</select>
						</div>
					</div>
					<div class="form-group" id="item-branch_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-8 col-xs-12">
							<select name="branch_id" id="branch_id">
								<option value="" ><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_all_branches">
									<option value="#branch_id#"<cfif isdefined("attributes.branch_id") and (branch_id eq attributes.branch_id)> selected</cfif>>#branch_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div>
					<cfsavecontent variable="buttonName"><cf_get_lang dictionary_id="57911.Çalıştır"></cfsavecontent>
					<cf_wrk_search_button button_type="2" button_name="#buttonName#">
				</div>
			</cf_box_footer>
        </cfform>    		
    	<cfform name="add_ext_salary" action="#request.self#?fuseaction=ehesap.emptypopup_form_add_tax_exception_all" method="post">
			<input name="record_num" id="record_num" type="hidden" value="0">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div id="show_img_baslik1" style="display:none;">
						<input type="hidden" name="show0" id="show0" value="0">
						<img border="0" src="/images/b_ok.gif" align="absmiddle">
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53085.Vergi İstisnaları"></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input  type="hidden"  value="1"  name="row_kontrol_0" id="row_kontrol_0">
								<input type="hidden" name="tax_exception_id0" id="tax_exception_id0" value="" />
								<input type="text" name="comment_pay0" id="comment_pay0" value="" readonly onChange="hepsi(row_count,'comment_pay');" onClick="hepsi(row_count,'comment_pay');">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_tax_exception','medium');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-term0">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'></label>
						<div class="col col-8 col-xs-12">
							<select name="term0" id="term0" onChange="hepsi(row_count,'term')" onClick="hepsi(row_count,'term');">
								<cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="i">
								<cfoutput>
									<option value="#i#"<cfif session.ep.period_year eq i> selected</cfif>>#i#</option>
								</cfoutput>
								</cfloop>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-amount_pay0">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="amount_pay0" id="amount_pay0" class="moneybox" value="" onkeyup="hepsi(row_count,'amount_pay');return(FormatCurrency(this,event));"  onChange="hepsi(row_count,'amount_pay');" onClick="hepsi(row_count,'amount_pay');">
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-start_sal_mon0">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
						<div class="col col-8 col-xs-12">
							<select name="start_sal_mon0" id="start_sal_mon0" onChange="hepsi(row_count,'start_sal_mon');" onClick="hepsi(row_count,'start_sal_mon');">
								<cfloop from="1" to="12" index="j">
									<cfoutput><option value="#j#">#listgetat(ay_list(),j,',')#</option></cfoutput>
								</cfloop>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-end_sal_mon0">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'></label>
						<div class="col col-8 col-xs-12">
							<select name="end_sal_mon0" id="end_sal_mon0" onChange="hepsi(row_count,'end_sal_mon');" onClick="hepsi(row_count,'end_sal_mon');">
								<cfloop from="1" to="12" index="j">
								<cfoutput><option value="#j#">#listgetat(ay_list(),j,',')#</option></cfoutput>
								</cfloop>
							</select>
						</div>
					</div>					
				</div>
			</cf_box_elements>
			<cf_grid_list>
				<thead>
					<tr>
						<th width="20"><a href="javascript://" onClick="add_row2();"><i class="fa fa-plus"></i></a></th>
						<th><cf_get_lang dictionary_id='57576.Çalışan'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57453.Şube'>/<cf_get_lang dictionary_id='57572.Departman'></th>
						<th id="show_img_baslik2" style="display:none;"></th>
						<th><cf_get_lang dictionary_id='53085.Vergi İstisnalari'></th>
						<th><cf_get_lang dictionary_id='58472.Dönem'></th>
						<th><cf_get_lang dictionary_id='57501.Başlangıç'></th>
						<th><cf_get_lang dictionary_id='57502.Bitiş'></th>
						<th><cf_get_lang dictionary_id='57673.Tutar'></th>
					</tr>
				</thead>
				<tbody  id="link_table">
					<cfif isdefined("attributes.pos_cat_id") and (get_poscat_positions.recordcount)>
						<cfoutput query="get_poscat_positions">
							<tr id="my_row_#currentrow#">
								<td><a onclick="sil(#currentrow#);" ><i class="fa fa-minus"></i></a></td>
								<td nowrap>
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="tax_exception_id#currentrow#" id="tax_exception_id#currentrow#" value="" />
											<input type="hidden"  value="1"  name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#">
											<input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="#employee_id#">
											<input type="hidden" name="employee_in_out_id#currentrow#" id="employee_in_out_id#currentrow#" value="#in_out_id#">
											<input name="employee#currentrow#" id="employee#currentrow#" type="text" readonly value="#employee_name# #employee_surname#">
											<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=add_ext_salary.employee_in_out_id#currentrow#&field_emp_name=add_ext_salary.employee#currentrow#&field_emp_id=add_ext_salary.employee_id#currentrow#&field_branch_and_dep=add_ext_salary.department#currentrow#' ,'list');"></span>
										</div>
									</div>									
								</td>
								<td>
									<div class="form-group">
										<input type="text" name="department#currentrow#" id="department#currentrow#" value="#branch_name#/#department_head#" readonly>
									</div>
								</td>
								<td id="show_img#currentrow#" style="display:none;"><img border="0" src="/images/b_ok.gif" align="absmiddle" ></td>
								<td nowrap="nowrap">
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="show#currentrow#" id="show#currentrow#" value="0">
											<input type="text" name="comment_pay#currentrow#" id="comment_pay#currentrow#" value="">
											<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_list_tax_exception&row_id_=#currentrow#','medium');"></span>
										</div>
									</div>
								</td>
								<td>
									<div class="form-group">
										<select name="term#currentrow#" id="term#currentrow#">
											<cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="i">
												<option value="#i#"<cfif session.ep.period_year eq i> selected</cfif>>#i#</option>
											</cfloop>
										</select>
									</div>
								</td>
								<td>
									<div class="form-group">
										<select name="start_sal_mon#currentrow#" id="start_sal_mon#currentrow#" onchange="change_mon('end_sal_mon#currentrow#',this.value);">
											<cfloop from="1" to="12" index="j">
											<option value="#j#">#listgetat(ay_list(),j,',')#</option>
											</cfloop>
										</select>
									</div>									
								</td>
								<td>
									<div class="form-group">
										<select name="end_sal_mon#currentrow#" id="end_sal_mon#currentrow#">
											<cfloop from="1" to="12" index="j">
											<option value="#j#">#listgetat(ay_list(),j,',')#</option>
											</cfloop>
										</select>
									</div>									
								</td>
								<td>
									<div class="form-group">
										<input type="text" name="amount_pay#currentrow#" id="amount_pay#currentrow#" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event));">
									</div>
								</td>
							</tr>
						</cfoutput>
					</cfif>
				</tbody>
			</cf_grid_list>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				</cf_box_footer>
			</div>
    	</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function hepsi(satir,nesne,baslangic)
	{
		deger = document.getElementById(nesne + '0');
		//deger=eval("document.add_ext_salary."+nesne+"0");
		if(deger.value.length!=0)/*değer boşdegilse çalıştır foru*/
		{
		if(!baslangic){baslangic=1;}/*başlangıc tüm elemanları değlde sadece bir veya bir kaçtane yapacaksak forun başlayacağı sayıyı vererek okadar dönmesini sağlayabilirz*/
			for(var i=baslangic;i<=satir;i++)
			{
				//nesne_tarih=eval("document.add_ext_salary."+nesne+i);
				//nesne_tarih.value=deger.value;
				nesne_tarih=eval('document.getElementById( nesne + i )');
				nesne_tarih.value=deger.value;
			}
		}
	}
	function sil(sy)
	{
		var my_element = document.getElementById('row_kontrol_' + sy);
		//var my_element=eval("add_ext_salary.row_kontrol_"+sy);
		my_element.value=0;
		var my_element = document.getElementById('my_row_' + sy);
		//var my_element=eval("my_row_"+sy);
		my_element.style.display="none";
	}
	function goster(show)
	{
		if(show==1)
		{
			show_img_baslik1.style.display='';
			show_img_baslik2.style.display='';
			for(var i=0;i<=row_count;i++)
			{
				satir=eval("show_img"+i);
				satir.style.display='';
			}
		}
		else
		{
			show_img_baslik1.style.display='none';
			show_img_baslik2.style.display='none';
			for(var i=0;i<=row_count;i++)
			{
				satir=eval("document.getElementById('show_img" + i + "')");
				
			}
		}
	}
	function add_row(tax_exception,sal_year,start_month,finish_month,amount,calc_days,yuzde_sinir,tamamini_ode,is_isveren_,is_ssk_,exception_type,row_id_,tax_exception_id)
	{
		if(row_count == 0)
		{
			alert("<cf_get_lang dictionary_id='53611.Satır Eklemediniz'>!");
			return false;
		}
		if(row_id_ != undefined && row_id_ != '')
		{	
			document.getElementById('comment_pay'+row_id_).value = tax_exception;
			document.getElementById('term'+row_id_).value = sal_year;
			document.getElementById('start_sal_mon'+row_id_).value = start_month;
			document.getElementById('end_sal_mon'+row_id_).value = finish_month;
			document.getElementById('amount_pay'+row_id_).value = amount;
			//document.getElementById('exception_type'+row_id_).value = exception_type;
			/*eval("document.add_ext_salary.comment_pay"+row_id_).value=tax_exception;
			eval("document.add_ext_salary.term"+row_id_).value=sal_year;
			eval("document.add_ext_salary.start_sal_mon"+row_id_).value=start_month;
			eval("document.add_ext_salary.end_sal_mon"+row_id_).value=finish_month;
			eval("document.add_ext_salary.amount_pay"+row_id_).value=amount;*/
			//eval("document.add_ext_salary.calc_days"+row_id_).value=calc_days;
			//eval("document.add_ext_salary.exception_type"+row_id_).value=exception_type;
			document.getElementById('tax_exception_id'+row_id_).value = tax_exception_id;
		}
		else
		{
			goster(show);
			hepsi(row_count,'show');
			document.getElementById('comment_pay0').value=tax_exception;
			hepsi(row_count,'comment_pay');
			document.getElementById('term0').value=sal_year;
			hepsi(row_count,'term');
			document.getElementById('start_sal_mon0').value=start_month;
			hepsi(row_count,'start_sal_mon');
			document.getElementById('end_sal_mon0').value=finish_month;
			hepsi(row_count,'end_sal_mon');
			document.getElementById('amount_pay0').value=amount;
			hepsi(row_count,'amount_pay');
			//document.getElementById('calc_days0').value=calc_days;
			//hepsi(row_count,'calc_days');
			document.getElementById('tax_exception_id0').value = tax_exception_id;
			hepsi(row_count,'tax_exception_id');
		/*	document.getElementById('exception_type0').value = exception_type;
			hepsi(row_count,'exception_type');*/
		}
	}
	function add_row2()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
		newRow.setAttribute("name","my_row_" + row_count);
		newRow.setAttribute("id","my_row_" + row_count);		
		newRow.setAttribute("NAME","my_row_" + row_count);
		newRow.setAttribute("ID","my_row_" + row_count);		
					
		document.getElementById('record_num').value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a onclick="sil(' + row_count + ');" ><i class="fa fa-minus"></i></a>';	
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.whiteSpace = 'nowrap';
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="employee_in_out_id' + row_count +'" id="employee_in_out_id' + row_count +'" value=""><input type="text" name="employee' + row_count +'" id="employee' + row_count +'" onFocus="AutoComplete_Create(\'employee'+ row_count +'\',\'MEMBER_NAME\',\'MEMBER_PARTNER_NAME3\',\'get_member_autocomplete\',\'3\',\'EMPLOYEE_ID,IN_OUT_ID,BRANCH_DEPT\',\'employee_id' + row_count +',employee_in_out_id' + row_count +',department' + row_count +'\',\'my_week_timecost\',3,116);"  value=""><span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen(\'<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_in_out</cfoutput>&field_in_out_id=employee_in_out_id'+row_count+'&field_emp_name=employee'+ row_count + '&field_emp_id=employee_id'+ row_count +'&field_branch_and_dep=department'+ row_count + '\' ,\'list\');"></span><input type="Hidden" name="tax_exception_id' + row_count +'" id="tax_exception_id' + row_count +'" value=""><input type="hidden" name="exception_type' + row_count +'" id="exception_type' + row_count +'" value=""><input type="hidden" value="" name="employee_id' + row_count +'" id="employee_id' + row_count +'"><input type="hidden"  value="1"  name="row_kontrol_' + row_count +'" id="row_kontrol_' + row_count +'"></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="department' + row_count +'" id="department' + row_count +'" readonly value="">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","show_img" + row_count);
		newCell.innerHTML = '<img border="0" src="/images/b_ok.gif" align="absmiddle">';
		if(document.getElementById('show0').value==0)/* eklerken satırı show0 değerini göre resim gözüksün gözükmesin ayarı*/
		{
			satir=eval("show_img"+row_count);
			satir.style.display='none';
		}
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.whiteSpace = 'nowrap';
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="show' + row_count +'" id="show' + row_count +'" value="0"><input type="text" name="comment_pay' + row_count +'" id="comment_pay' + row_count +'" readonly value=""><span class="input-group-addon icon-ellipsis btnPointer" onClick="send_odenek('+row_count+');"></span></div></div>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="term' + row_count +'" id="term' + row_count +'"><cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="j"><option value="<cfoutput>#j#</cfoutput>" <cfif session.ep.period_year eq j>selected</cfif>><cfoutput>#j#</cfoutput></option></cfloop></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="start_sal_mon' + row_count +'" id="start_sal_mon' + row_count +'" onchange="change_mon(\'end_sal_mon'+row_count+'\',this.value);"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option></cfloop></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="end_sal_mon' + row_count +'" id="end_sal_mon' + row_count +'"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option></cfloop></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input name="amount_pay' + row_count +'" id="amount_pay' + row_count +'" type="text" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event));"></div>';
		
		hepsi(row_count,'show',row_count);
		hepsi(row_count,'comment_pay',row_count);
		hepsi(row_count,'term',row_count);
		hepsi(row_count,'start_sal_mon',row_count);
		hepsi(row_count,'end_sal_mon',row_count);
		hepsi(row_count,'amount_pay',row_count);
		//hepsi(row_count,'calc_days',row_count);
		hepsi(row_count,'tax_exception_id',row_count);
		
		odenek_text=eval("document.add_ext_salary.comment_pay"+ row_count);
		odenek_text.focus();
		return true;
	}
	function send_odenek(row_count)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_tax_exception&row_id_='+ row_count,'medium');
	}
	function kontrol()
	{
		document.getElementById('record_num').value=row_count;
		if(row_count == 0)
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='53083.Kesinti'>");
			return false;
		}
		for(var i=1;i<=row_count;i++)
		{
			 if(eval("document.add_ext_salary.amount_pay"+i).value.length == 0)
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='53083.Kesinti'>");
					return false;
				}
		}
		for(var i=1;i<=row_count;i++)
		{
			nesne=eval("document.add_ext_salary.amount_pay"+i);
			nesne.value=filterNum(nesne.value);
		}
		return true;
	}
	function change_mon(id,i)
	{
		$('#'+id).val(i);
	}		
</script>

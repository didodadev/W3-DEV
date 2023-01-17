<cfif isdefined("attributes.class_id")>
<cfinclude template="../query/get_class.cfm">
</cfif>
<cfinclude template="../query/get_class_costs.cfm">
<cfquery name="get_money" datasource="#dsn#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
</cfquery>
<cfquery name="get_items" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_CATEGORY_ID IN (SELECT EXPENSE_CAT_ID FROM EXPENSE_CATEGORY WHERE EXPENCE_IS_TRAINING = 1)
</cfquery>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME 
	FROM 
		BRANCH
	WHERE
		BRANCH_ID IN (
					SELECT
						BRANCH_ID
					FROM
						EMPLOYEE_POSITION_BRANCHES
					WHERE
						POSITION_CODE = #SESSION.EP.POSITION_CODE#	
					)
	ORDER BY BRANCH_ID
</cfquery>
<!--- <cf_catalystHeader> --->
<cfsavecontent variable="head_">
	<cf_get_lang dictionary_id='46446.Eğitim Maliyet'><cfif isdefined("attributes.class_id")>:<cfoutput>#get_class.class_name#</cfoutput></cfif>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#head_#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_training_cost" action="#request.self#?fuseaction=training_management.emptypopup_upd_training_cost" method="post">
			<cfif isdefined("attributes.class_id")><input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>"></cfif>
			<input type="hidden" name="training_class_cost_id" id="training_class_cost_id" value="<cfoutput>#get_class_costs.training_class_cost_id#</cfoutput>">
			<cfif get_class_costs.recordcount and get_class_cost_rows.recordcount>
			<input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_class_cost_rows.recordcount#</cfoutput>">
			<input name="update_record" id="update_record" type="hidden" value="1">
			<cfelse>
			<input name="record_num" id="record_num" type="hidden" value="1">
			</cfif>
			<input name="is_class_type" id="is_class_type" type="hidden" value="<cfoutput>#attributes.is_class_type#</cfoutput>">
			<cf_box_elements>
                <cf_flat_list>
                    <thead>
                        <tr>
                            <th><cf_get_lang dictionary_id='57453.Şube'></th>
                            <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                            <th><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
                            <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                            <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                            <th><cf_get_lang dictionary_id='57636.Birim'></th>
                            <th><cf_get_lang dictionary_id='57492.Toplam'></th>
                            <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                            <th><cf_get_lang dictionary_id='57636.Birim'></th>
                            <th colspan="3"><cf_get_lang dictionary_id='57492.Toplam'></th>
                            <th><a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></th>
                        </tr>
                    </thead>
                    <tbody id="maaliyet_table">
                        <cfset toplam_ongorulen = 0>
                        <cfset toplam_gerceklesen = 0>
                        <cfif get_class_costs.recordcount and  get_class_cost_rows.recordcount>
                            <cfoutput query="get_class_cost_rows">
                            <tr id="satir_#currentrow#">
                                <input type="hidden" name="cost_row_id" id="cost_row_id" value="#cost_row_id#">
                                <input  type="hidden" value="1"  name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#">
                                <td width="100">
                                    <div class="form-group">
                                        <cfset branch_id_cost = get_class_cost_rows.branch_id>
                                        <select name="branch_id_#currentrow#" id="branch_id_#currentrow#" style="width:100px;">
                                            <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                            <cfloop query="get_branchs">
                                            <option value="#branch_id#" <cfif len(branch_id_cost) and branch_id_cost eq get_branchs.branch_id>selected</cfif>>#get_branchs.branch_name#</option>
                                            </cfloop>
                                        </select>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <div class="input-group">
                                            <cfinput type="text" style="width:75px;" name="cost_date_#currentrow#" value="#dateformat(cost_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="cost_date_#currentrow#"></span>
                                        </div>
                                    </div>
                                </td>
                                <td width="110">
                                    <div class="form-group">
                                        <cfset items_names = get_class_cost_rows.expense_item_id>
                                        <select name="items_names_#currentrow#" id="items_names_#currentrow#" style="width:110px;">
                                            <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                            <cfloop query="get_items">
                                                <option value="#expense_item_id#" <cfif expense_item_id eq items_names>selected</cfif>>#expense_item_name#</option>
                                            </cfloop>
                                        </select>
                                    </div>
                                </td>
                                <td width="100"><div class="form-group"><input name="explanation_#currentrow#" id="explanation_#currentrow#" type="text" style="width:100px;" value="#explanation#"></div></td>
                                <td width="35"><div class="form-group"><input name="ongorulen_miktar_#currentrow#" id="ongorulen_miktar_#currentrow#" type="text" style="width:35px;" value="#tlformat(ongorulen_miktar,0)#" onkeyup="return(FormatCurrency(this,event,0));" onBlur="toplam_al_1(#currentrow#);"></div></td>
                                <td width="75"><div class="form-group"><input name="ongorulen_birim_#currentrow#" id="ongorulen_birim_#currentrow#" type="text" style="width:75px" value="#tlformat(ongorulen_birim)#" onkeyup="return(FormatCurrency(this,event));" onBlur="toplam_al_1(#currentrow#);"></div></td>
                                <td width="105"><div class="form-group"><input name="ongorulen_#currentrow#" id="ongorulen_#currentrow#" type="text" style="width:100px;" value="#tlformat(ongorulen)#" readonly onkeyup="return(FormatCurrency(this,event));"></div></td>
                                <td width="35"><div class="form-group"><input name="gerceklesen_miktar_#currentrow#" id="gerceklesen_miktar_#currentrow#" type="text" style="width:35px;" value="#tlformat(gerceklesen_miktar,0)#" onkeyup="return(FormatCurrency(this,event,0));" onBlur="toplam_al_2(#currentrow#);"></div></td>
                                <td width="75"><div class="form-group"><input name="gerceklesen_birim_#currentrow#" id="gerceklesen_birim_#currentrow#" type="text" style="width:75px" value="#tlformat(gerceklesen_birim)#" onkeyup="return(FormatCurrency(this,event));" onBlur="toplam_al_2(#currentrow#);"></div></td>
                                <td width="105"><div class="form-group"><input name="gerceklesen_#currentrow#" id="gerceklesen_#currentrow#" type="text" style="width:100px;" value="#tlformat(gerceklesen)#" readonly onkeyup="return(FormatCurrency(this,event));"></div></td>
                                <td><a style="cursor:pointer" onclick="sil(#currentrow#);"><img  src="images/delete_list.gif" border="0"></a></td>
                                <td></td>
                            </tr>
                            <cfset toplam_ongorulen = toplam_ongorulen + ongorulen>
                            <cfset toplam_gerceklesen = toplam_gerceklesen + gerceklesen>
                            </cfoutput>
                        <cfelse>
                            <cfset attributes.start_date = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
                            <cfset attributes.cost_date = date_add('d',7,attributes.start_date)>
                                <tr id="satir_1">
                                    <input  type="hidden" name="row_kontrol_1" id="row_kontrol_1" value="1">
                                    <td>
                                        <div class="form-group">
                                            <select name="branch_id_1" id="branch_id_1" style="width:100px;">
                                                <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                                <cfoutput query="get_branchs">
                                                <option value="#branch_id#">#branch_name#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </td>
                                    <td nowrap="nowrap">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <cfinput type="text" style="width:75px;" name="cost_date_1" value="#dateformat(attributes.cost_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="cost_date_1"></span>
                                            </div>
                                        </div>
                                    </td>
                                    <td width="110">
                                        <div class="form-group">
                                            <select name="items_names_1" id="items_names_1" style="width:110px;">
                                                <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                                <cfif get_items.recordcount>
                                                    <cfoutput query="get_items">
                                                        <option value="#expense_item_id#">#expense_item_name#</option>
                                                    </cfoutput>
                                                </cfif>
                                            </select>
                                        </div>
                                    </td>
                                    <td width="100"><div class="form-group"><input name="explanation_1" id="explanation_1" type="text" style="width:100px;"></div></td>
                                    <td width="35"><div class="form-group"><input name="ongorulen_miktar_1" id="ongorulen_miktar_1" type="text" style="width:35px;" onkeyup="return(FormatCurrency(this,event,0));" onBlur="toplam_al_1(1);"></div></td>
                                    <td width="75"><div class="form-group"><input name="ongorulen_birim_1" id="ongorulen_birim_1" type="text" style="width:75px" onkeyup="return(FormatCurrency(this,event));" onBlur="toplam_al_1(1);"></div></td>
                                    <td width="105"><div class="form-group"><input name="ongorulen_1" id="ongorulen_1" type="text" style="width:100px;" readonly onkeyup="return(FormatCurrency(this,event));"></div></td>
                                    <td width="35"><div class="form-group"><input name="gerceklesen_miktar_1" id="gerceklesen_miktar_1" type="text" style="width:35px" onkeyup="return(FormatCurrency(this,event),0);" onBlur="toplam_al_2(1);"></div></td>
                                    <td width="75"><div class="form-group"><input name="gerceklesen_birim_1" id="gerceklesen_birim_1" type="text" style="width:75px;" onkeyup="return(FormatCurrency(this,event));" onBlur="toplam_al_2(1);"></div></td>
                                    <td width="105"><div class="form-group"><input name="gerceklesen_1" id="gerceklesen_1" type="text" style="width:100px;" readonly onkeyup="return(FormatCurrency(this,event));"></div></td>
                                    <td>&nbsp;</td>
                                </tr>
                            </cfif>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td class="formbold" colspan="7" style="text-align:right"><cf_get_lang dictionary_id='57492.Toplam'></td>
                            <td colspan="7">
                                <div class="form-group">
                                    <div class="col col-6 col-xs-12 col-md-6 col-sm-6">
                                        <cfinput name="ongorulen_toplam" type="text" style="width:100px;" value="#tlformat(toplam_ongorulen)#" readonly>
                                    </div>
                                    <div class="col col-6 col-xs-12 col-md-6 col-sm-6">
                                        <cfinput name="gerceklesen_toplam" type="text" style="width:100px;" value="#tlformat(toplam_gerceklesen)#" readonly>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="formbold" colspan="7" style="text-align:right"><cf_get_lang dictionary_id='46589.Döviz Cinsi/Kur'></td>
                            <td valign="top" colspan="7">
                                <div class="form-group">
                                    <div class="col col-6 col-xs-12 col-md-6 col-sm-6">
                                        <select name="training_money" id="training_money" style="width:100px;">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_money">
                                                <option value="#money#" <cfif get_class_costs.class_cost is '#money#'>selected</cfif>>#money#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                    <div class="col col-6 col-xs-12 col-md-6 col-sm-6">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='57648.kur'>-<cf_get_lang dictionary_id='58195.tam sayı'></cfsavecontent>
                                        <cfinput type="text" name="kur" style="width:100px;" value="#tlformat(get_class_costs.exchange)#" onKeyup='return(FormatCurrency(this,event));' required="Yes" message="#message#" maxlength="20">
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </tfoot>
                </cf_flat_list>
            </cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_class_costs">
				<cf_workcube_buttons type_format='1' is_upd='0' add_function='unformat_fields()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	<cfif isdefined('get_class_cost_rows') and (get_class_cost_rows.recordcount)>
	row_count=<cfoutput>#get_class_cost_rows.recordcount#</cfoutput>;
	<cfelse>
	row_count=1;
	</cfif>
	function sil(sy)
	{
		var my_element=eval("add_training_cost.row_kontrol_"+sy);
		my_element.value=0;
		var my_element=eval("satir_"+sy);
		my_element.style.display="none";
		
		gelen_ongorulen_toplam = eval("add_training_cost.ongorulen_" + sy).value;
		gelen_gerceklesen_toplam = eval("add_training_cost.gerceklesen_" + sy).value;	
		ongorulen_toplam = add_training_cost.ongorulen_toplam.value;
		gerceklesen_toplam = add_training_cost.gerceklesen_toplam.value;
		if(gelen_ongorulen_toplam=='')
			gelen_ongorulen_toplam = 0;
		if(gelen_gerceklesen_toplam=='')
			gelen_gerceklesen_toplam = 0;
		if(ongorulen_toplam=='')
			ongorulen_toplam = 0;
		if(gerceklesen_toplam=='')
			gerceklesen_toplam = 0;
			
		gelen_ongorulen_toplam = filterNum(gelen_ongorulen_toplam);
		gelen_gerceklesen_toplam = filterNum(gelen_gerceklesen_toplam);
		ongorulen_toplam = filterNum(ongorulen_toplam);
		gerceklesen_toplam = filterNum(gerceklesen_toplam);
			
		ongorulen_toplam = ongorulen_toplam - gelen_ongorulen_toplam;
		gerceklesen_toplam = gerceklesen_toplam - gelen_gerceklesen_toplam;	
		
		ongorulen_toplam = commaSplit(ongorulen_toplam);
		gerceklesen_toplam = commaSplit(gerceklesen_toplam);
		
		add_training_cost.ongorulen_toplam.value = ongorulen_toplam;
		add_training_cost.gerceklesen_toplam.value = gerceklesen_toplam;
	}
	
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		
		newRow = document.getElementById("maaliyet_table").insertRow(document.getElementById("maaliyet_table").rows.length);
		newRow.setAttribute("name","satir_" + row_count);
		newRow.setAttribute("id","satir_" + row_count);		
		newRow.setAttribute("NAME","satir_" + row_count);
		newRow.setAttribute("ID","satir_" + row_count);		
		document.add_training_cost.record_num.value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="branch_id_'+ row_count +'" style="width:100px;"><option value=""><cf_get_lang dictionary_id ='57453.Şube'></option><cfoutput query="get_branchs"><option value="#branch_id#">#branch_name#</option></cfoutput></select></div>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","cost_date_" + row_count + "_td");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" id="cost_date_input_group' + row_count +'" name="cost_date_' + row_count +'" class="text" maxlength="10" style="width:75px;" value=""></div></div>';
		document.querySelector("#cost_date_" + row_count + "_td .input-group").setAttribute("id","cost_date_input_group" + row_count + "_td");
		wrk_date_image('cost_date_input_group' + row_count,'','add_type');
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="items_names_'+ row_count +'" style="width:110px;"><option value=""><cf_get_lang dictionary_id='58551.Gider Kalemi'></option><cfoutput query="get_items"><option value="#expense_item_id#">#expense_item_name#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input  type="hidden"  value="1"  name="row_kontrol_' + row_count +'" ><input name="explanation_'+ row_count +'" type="text" style="width:100px;"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input name="ongorulen_miktar_'+ row_count +'" type="text" style="width:35px;" onkeyup="return(FormatCurrency(this,event,0));" onBlur="toplam_al_1(' + row_count + ');"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input name="ongorulen_birim_'+ row_count +'" type="text" style="width:75px;" onkeyup="return(FormatCurrency(this,event));" onBlur="toplam_al_1(' + row_count + ');"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input name="ongorulen_'+ row_count +'" type="text" readonly style="width:100px;" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input name="gerceklesen_miktar_'+ row_count +'" type="text" style="width:35px;" onkeyup="return(FormatCurrency(this,event,0));" onBlur="toplam_al_2(' + row_count + ');"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input name="gerceklesen_birim_'+ row_count +'" type="text" style="width:75px;" onkeyup="return(FormatCurrency(this,event));" onBlur="toplam_al_2(' + row_count + ');"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input name="gerceklesen_'+ row_count +'" readonly type="text" style="width:100px;" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';
	}
	
	function toplam_al_1(satir_no)
	{
			gelen_birim = eval("add_training_cost.ongorulen_birim_" + satir_no).value;
			gelen_miktar = eval("add_training_cost.ongorulen_miktar_" + satir_no).value;
			gelen_alt_toplam = add_training_cost.ongorulen_toplam.value;
			gelen_satir_toplam = eval("add_training_cost.ongorulen_" + satir_no).value;
			
			if(gelen_birim=='')
				gelen_birim = 0;
			if(gelen_miktar=='')
				gelen_miktar = 0;
			if(gelen_satir_toplam=='')
				gelen_satir_toplam = 0;
			
			gelen_birim = filterNum(gelen_birim);
			gelen_miktar = filterNum(gelen_miktar);
			gelen_satir_toplam = filterNum(gelen_satir_toplam);
			gelen_alt_toplam = filterNum(gelen_alt_toplam);
	
			gelen_alt_toplam = gelen_alt_toplam - gelen_satir_toplam;
			gelen_satir_toplam = gelen_birim * gelen_miktar;
			gelen_alt_toplam = gelen_alt_toplam + gelen_satir_toplam;
	
			gelen_birim = commaSplit(gelen_birim);
			gelen_miktar = commaSplit(gelen_miktar,0);
			gelen_satir_toplam = commaSplit(gelen_satir_toplam);
			gelen_alt_toplam = commaSplit(gelen_alt_toplam);
			
			eval("add_training_cost.ongorulen_birim_" + satir_no).value = gelen_birim;
			eval("add_training_cost.ongorulen_miktar_" + satir_no).value = gelen_miktar;
			eval("add_training_cost.ongorulen_" + satir_no).value = gelen_satir_toplam;
			add_training_cost.ongorulen_toplam.value = gelen_alt_toplam;
	}
	
	function toplam_al_2(satir_no)
	{
			gelen_birim = eval("add_training_cost.gerceklesen_birim_" + satir_no).value;
			gelen_miktar = eval("add_training_cost.gerceklesen_miktar_" + satir_no).value;
			gelen_alt_toplam = add_training_cost.gerceklesen_toplam.value;
			gelen_satir_toplam = eval("add_training_cost.gerceklesen_" + satir_no).value;
			
			if(gelen_birim=='')
				gelen_birim = 0;
			if(gelen_miktar=='')
				gelen_miktar = 0;
			if(gelen_satir_toplam=='')
				gelen_satir_toplam = 0;
			
			gelen_birim = filterNum(gelen_birim);
			gelen_miktar = filterNum(gelen_miktar);
			gelen_satir_toplam = filterNum(gelen_satir_toplam);
			gelen_alt_toplam = filterNum(gelen_alt_toplam);
	
			gelen_alt_toplam = gelen_alt_toplam - gelen_satir_toplam;
			gelen_satir_toplam = gelen_birim * gelen_miktar;
			gelen_alt_toplam = gelen_alt_toplam + gelen_satir_toplam;
	
			gelen_birim = commaSplit(gelen_birim);
			gelen_miktar = commaSplit(gelen_miktar,0);
			gelen_satir_toplam = commaSplit(gelen_satir_toplam);
			gelen_alt_toplam = commaSplit(gelen_alt_toplam);
			
			eval("add_training_cost.gerceklesen_birim_" + satir_no).value = gelen_birim;
			eval("add_training_cost.gerceklesen_miktar_" + satir_no).value = gelen_miktar;
			eval("add_training_cost.gerceklesen_" + satir_no).value = gelen_satir_toplam;
			add_training_cost.gerceklesen_toplam.value = gelen_alt_toplam;
	}
	
	function unformat_fields()
	{
		if(add_training_cost.record_num.value > 1)
		{	
			for(r=1;r<=add_training_cost.record_num.value;r++)
				if(eval("document.add_training_cost.row_kontrol_"+r).value==1 && eval("document.add_training_cost.items_names_"+r).value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58551.Gider Kalemi'>!");
					return false;
				}
		}
		//document.add_training_cost.ongorulen_toplam.value = filterNum(document.add_training_cost.ongorulen_toplam.value);
		//document.add_training_cost.gerceklesen_toplam.value = filterNum(document.add_training_cost.gerceklesen_toplam.value);
		for(r=1;r<=add_training_cost.record_num.value;r++)//1 satır bile kayıt edilecekse kontrol yapılmalı
		{
			if(eval("document.add_training_cost.row_kontrol_"+r).value==1)
			{
				if(document.add_training_cost.ongorulen_toplam.value == 0 && document.add_training_cost.gerceklesen_toplam.value == 0)
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='57673.Tutar'>!");
					return false;
				}
				break;
			}
		}
	
		if(add_training_cost.training_money.value != '' && add_training_cost.kur.value == ''){
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='46336.Kur Değeri !'>");
			add_training_cost.kur.focus();
			return false;
		}
		
		if(add_training_cost.training_money.value=='' && add_training_cost.kur.value!=''){
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='46313.Kur Tipi'>");
			add_training_cost.training_money.focus();
			return false;
		}
		satir_sayisi = add_training_cost.record_num.value;
		for(var i=1; i<=satir_sayisi; i++)			
			{ 
			eval("add_training_cost.gerceklesen_birim_"+i).value = filterNum(eval("add_training_cost.gerceklesen_birim_"+i).value);
			eval("add_training_cost.gerceklesen_miktar_"+i).value = filterNum(eval("add_training_cost.gerceklesen_miktar_"+i).value);
			eval("add_training_cost.gerceklesen_"+i).value = filterNum(eval("add_training_cost.gerceklesen_"+i).value);
			eval("add_training_cost.ongorulen_birim_"+i).value = filterNum(eval("add_training_cost.ongorulen_birim_"+i).value);
			eval("add_training_cost.ongorulen_miktar_"+i).value = filterNum(eval("add_training_cost.ongorulen_miktar_"+i).value);
			eval("add_training_cost.ongorulen_"+i).value = filterNum(eval("add_training_cost.ongorulen_"+i).value);
			}
		add_training_cost.ongorulen_toplam.value = filterNum(add_training_cost.ongorulen_toplam.value);
		add_training_cost.gerceklesen_toplam.value = filterNum(add_training_cost.gerceklesen_toplam.value);
		add_training_cost.kur.value = filterNum(add_training_cost.kur.value);
		
		<cfif isdefined("attributes.draggable")>
            loadPopupBox('add_training_cost' , 'training_cost_box');
            return false;
        </cfif>
        return true;
	}
</script>
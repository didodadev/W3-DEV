<cfquery name="get_prod_pause" datasource="#dsn3#">
	SELECT 
		ACTION_DATE,
		PROD_PAUSE_TYPE_ID,
		PROD_DURATION,
		PROD_DETAIL,
		IS_WORKING_TIME,
		RECORD_DATE,
		RECORD_EMP 
	FROM 
		SETUP_PROD_PAUSE
	WHERE 
		PR_ORDER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#">
</cfquery>

<cfsavecontent variable="title"><cf_get_lang dictionary_id='36985.Duraklamalar'></cfsavecontent>
<cf_box title="#title#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"> 
	<cfform name="prod_pause" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_prod_pause&product_cat_list=#product_cat_list#">
	<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_prod_pause.recordcount#</cfoutput>">
	<input type="hidden" name="pr_order_id" id="pr_order_id" value="<cfoutput>#attributes.pr_order_id#</cfoutput>">
	<input type="hidden" name="p_order_id" id="p_order_id" value="<cfoutput>#attributes.p_order_id#</cfoutput>">
	<cf_grid_list>
		<thead>
			<tr>
				<th colspan="5"><cf_get_lang dictionary_id='57879.İşlem Tarihi'>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57906.İşlem Tarihi Girmelisiniz'>!</cfsavecontent>
					<cfinput type="text" name="action_date" value="#dateformat(get_prod_pause.action_date,dateformat_style)#" required="yes" message="#message#" readonly validate="#validate_style#" style="width:63px;">
					<cfif len(get_prod_pause.action_date)>
						<cf_wrk_date_image date_field="action_date" control_date="#dateformat(get_prod_pause.action_date,dateformat_style)#">
					<cfelse>
						<cf_wrk_date_image date_field="action_date">		
					</cfif>
				</th>
			</tr>
			<tr class="txtbold">
				<th width="15"><a href="javascript://" onclick="add_row();"><img src="images/plus_list.gif" border="0"></a></th>
				<th width="100"><cf_get_lang dictionary_id='36986.Duraklama Tipi'></th>
				<th width="80"><cf_get_lang dictionary_id='29513.Süre'> (<cf_get_lang dictionary_id='58827.dk'>)</th>
				<th width="250"><cf_get_lang dictionary_id='57629.Açıklama'></th>
				<th width="100"><cf_get_lang dictionary_id='36987.Çalışma Zamanı'></th>
			</tr>
		</thead>
		<tbody id="tbl_1" name="tbl_1">
			<cfif get_prod_pause.recordcount>
				<cfoutput query="get_prod_pause">
					<cfif len(prod_pause_type_id)>
						<cfquery name="get_pause_type" datasource="#dsn3#">
							SELECT PROD_PAUSE_TYPE,PROD_PAUSE_TYPE_ID FROM SETUP_PROD_PAUSE_TYPE WHERE PROD_PAUSE_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#prod_pause_type_id#">
						</cfquery>
					<cfelse>
						<cfset get_pause_type.recordcount=0>
					</cfif>
					<tr id="frm_row#currentrow#">
						<td><input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1"><a style="cursor:pointer" onclick="sil(#currentrow#);"><img  src="images/delete_list.gif" border="0"></a></td>
						<td nowrap="nowrap">
							<input type="hidden" name="prod_pause_type_id#currentrow#" id="prod_pause_type_id#currentrow#" value="<cfif get_pause_type.recordcount>#get_pause_type.prod_pause_type_id#</cfif>">
							<input type="text" name="prod_pause_type#currentrow#" id="prod_pause_type#currentrow#" style="width:118px;" value="<cfif get_pause_type.recordcount>#get_pause_type.PROD_PAUSE_TYPE#</cfif>">
							<a href="javascript://" onClick="pencere_ac_pause_type('#currentrow#');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
						</td>
						<td><input type="text" name="duration#currentrow#" id="duration#currentrow#" style="width:80px;" onKeyup="isNumber(this);" value="#prod_duration#"></td>
						<td><input type="text" name="detail#currentrow#" id="detail#currentrow#" style="width:250px;" value="#prod_detail#"></td>
						<td align="center">
							<cfsavecontent variable="dahil"><cf_get_lang dictionary_id='36988.Dahil'></cfsavecontent>
							<cfsavecontent variable="degil"><cf_get_lang dictionary_id='36989.Değil'></cfsavecontent>
							<cfif get_prod_pause.is_working_time eq 1>
								<input type="hidden" name="is_time#currentrow#" id="is_time#currentrow#" value="#is_working_time#" style="width:100px;">
								<cfset work_time = #dahil#>
							<cfelse>
								<input type="hidden" name="is_time#currentrow#" id="is_time#currentrow#" value="#is_working_time#" style="width:100px;">
								<cfset work_time = #degil#>
							</cfif>
							<input type="text" class="boxtext" name="status#currentrow#" id="status#currentrow#" value="#work_time#" style="width:70px;">
						</td>
					</tr>
				</cfoutput>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cf_box_footer>
		<cf_record_info query_name="get_prod_pause">
		<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
	</cf_box_footer>						
	</cfform>
</cf_box>
<script type="text/javascript">
	var row_count=<cfoutput>#get_prod_pause.recordcount#</cfoutput>;
	function kontrol()
	{
		if(!chk_period(document.prod_pause.action_date, 'İşlem')) return false;
	}
	function sil(sy)
	{
		var my_element=eval("prod_pause.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		
		newRow = document.getElementById("tbl_1").insertRow(document.getElementById("tbl_1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		document.prod_pause.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol'+row_count+'" value="1"><a style="cursor:pointer" onClick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.sil'>" alt="<cf_get_lang dictionary_id='57463.sil'>"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="prod_pause_type_id'+row_count+'" value=""><input type="text" name="prod_pause_type'+row_count+'" value="" style="width:118px;"> <a href="javascript://" onClick="pencere_ac_pause_type('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="duration'+row_count+'" style="width:80px;" onKeyup="isNumber(this);">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="detail'+row_count+'" style="width:250px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" class="boxtext" name="is_time'+row_count+'" value="" style="width:70px;"><input type="text" class="boxtext" name="status'+row_count+'" value="" style="width:70px;">';
	}
	function pencere_ac_pause_type(no)
	{
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_prod_pause_type&product_cat_list=#product_cat_list#</cfoutput>&field_id=all.prod_pause_type_id' + no +'&field_name=all.prod_pause_type' + no +'&field_status=all.status'+no+'&field_time=all.is_time' + no,'list');
	}
</script>



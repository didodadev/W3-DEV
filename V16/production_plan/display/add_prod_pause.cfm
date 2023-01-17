<cfparam name="inc_time" default="">
<cfquery name="get_prod_pause" datasource="#dsn3#">
	SELECT PROD_PAUSE_ID FROM SETUP_PROD_PAUSE WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>

<cfif get_prod_pause.recordcount>
	<script type="text/javascript">
		openBoxDraggable("<cfoutput>#request.self#?fuseaction=prod.popup_upd_prod_pause&product_cat_list=#product_cat_list#&p_order_id=#attributes.p_order_id#&pr_order_id=#attributes.action_id#&draggable=1&action_date=#action_date#</cfoutput>");
	</script>
<cfelse>
	<cfquery name="get_prod_pause_type" datasource="#dsn3#">
		SELECT DISTINCT
			SPPT.PROD_PAUSE_TYPE_ID,
			SPPT.PROD_PAUSE_TYPE,
			SPPC.IS_WORKING_TIME
		FROM
			SETUP_PROD_PAUSE_TYPE SPPT,
			SETUP_PROD_PAUSE_TYPE_ROW SPPTR,
			SETUP_PROD_PAUSE_CAT SPPC
		WHERE
			SPPT.PROD_PAUSE_TYPE_ID=SPPTR.PROD_PAUSE_TYPE_ID AND
			SPPT.PROD_PAUSE_CAT_ID=SPPC.PROD_PAUSE_CAT_ID AND
			SPPTR.PROD_PAUSE_PRODUCTCAT_ID IN (<cfqueryparam list="yes" value="#Product_cat_List#">)
	</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='36985.Duraklamalar'></cfsavecontent>
<cf_box title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="prod_pause" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_prod_pause&product_cat_list=#product_cat_list#">
	<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_prod_pause_type.recordcount#</cfoutput>">
	<input type="hidden" name="pr_order_id" id="pr_order_id" value="<cfoutput>#attributes.action_id#</cfoutput>">
	<input type="hidden" name="p_order_id" id="p_order_id" value="<cfoutput>#attributes.p_order_id#</cfoutput>">
	<cf_box_elements vertical="1">
		<div class="form-group col col-3 col-md-3 col-sm-4 col-xs-12">
			<label><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
			<div class="input-group">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57906.İşlem Tarihi Girmelisiniz'>!</cfsavecontent>
				<cfinput type="text" name="action_date" value="#dateformat(action_date,dateformat_style)#" required="yes" message="#message#" readonly validate="#validate_style#" style="width:63px;">
				<span class="input-group-addon"><cf_wrk_date_image date_field="action_date"></span>
			</div>
		</div>
	</cf_box_elements>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><a href="javascript://" onclick="add_row();"><i class="fa fa-plus"></i></a></th>
					<th width="140"><cf_get_lang dictionary_id='36986.Duraklama Tipi'></th>
					<th width="80"><cf_get_lang dictionary_id='29513.Süre'> (<cf_get_lang dictionary_id='58827.dk'>)</th>
					<th width="250"><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th width="100"><cf_get_lang dictionary_id='36987.Çalışma Zamanı'></th>
				</tr>
			</thead>
			<tbody id="tbl1" name="tbl1">
				<cfif get_prod_pause_type.recordcount>
					<cfoutput query="get_prod_pause_type">
						<tr id="frm_row#currentrow#">
							<td  nowrap="nowrap"><input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1"><a href="javascript://" onclick="sil(#currentrow#);"><i class="fa fa-minus"></i></a></td>
							<td  nowrap="nowrap">
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="prod_pause_type_id#currentrow#" id="prod_pause_type_id#currentrow#" value="#prod_pause_type_id#">
										<input type="text" name="prod_pause_type#currentrow#" id="prod_pause_type#currentrow#" style="width:118px;" value="#prod_pause_type#">
										<a href="javascript://"  onClick="pencere_ac_pause_type('#currentrow#');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
									</div>
								</div>
							</td>
							<td><div class="form-group"><input type="text" name="duration#currentrow#" id="duration#currentrow#" onKeyup="isNumber(this);"></div></td>
							<td><div class="form-group"><input type="text" name="detail#currentrow#" id="detail#currentrow#"></div></td>
							<td>
								<cfsavecontent variable="dahil"><cf_get_lang dictionary_id='36988.Dahil'></cfsavecontent>
								<cfsavecontent variable="degil"><cf_get_lang dictionary_id='36989.Değil'></cfsavecontent>
								<cfif get_prod_pause_type.is_working_time eq 1>
									<input type="hidden" name="is_time#currentrow#" id="is_time#currentrow#" value="#is_working_time#">
									<cfset work_time = #dahil#>
								<cfelse>
									<input type="hidden" name="is_time#currentrow#" id="is_time#currentrow#" value="#is_working_time#">
									<cfset work_time = #degil#>
								</cfif>
								<div class="form-group">
									<input type="text" class="boxtext" name="status#currentrow#" id="status#currentrow#" value="#work_time#">
								</div>
							</td>
						</tr>
					</cfoutput>
				</cfif>
			</tbody>
		</cf_grid_list>
		<div class="ui-info-bottom flex-end"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></div>	
	</cfform>
</cf_box>
</div>
	<script type="text/javascript">
		var row_count=<cfoutput>#get_prod_pause_type.recordcount#</cfoutput>;
		
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
			newRow = document.getElementById("tbl1").insertRow(document.getElementById("tbl1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			document.prod_pause.record_num.value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="row_kontrol'+row_count+'" value="1"><a style="cursor:pointer" onClick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.sil'>" alt="<cf_get_lang dictionary_id='57463.sil'>"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="prod_pause_type_id'+row_count+'" value=""><input type="text" name="prod_pause_type'+row_count+'" value="" style="width:118px;"> <span class="input-group-addon icon-ellipsis"  onClick="pencere_ac_pause_type('+ row_count +');"></span></div></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="duration'+row_count+'" onKeyup="isNumber(this);"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="detail'+row_count+'"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="hidden" class="boxtext" name="is_time'+row_count+'" value=""><input type="text" class="boxtext" name="status'+row_count+'" value=""></div>';
		}
		
		function pencere_ac_pause_type(no)
		{
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_prod_pause_type&product_cat_list=#product_cat_list#</cfoutput>&field_id=all.prod_pause_type_id' + no +'&field_name=all.prod_pause_type' + no +'&field_status=all.status'+no+'&field_time=all.is_time' + no,'list');
		}
	</script>
</cfif>

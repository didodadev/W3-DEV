

<cfparam name="attributes.product_edit" default="0">
<cfset textile_round=3>

<cfsetting showdebugoutput="no">
<cfscript>
	CreateCompenent = CreateObject("component","AddOns.N1-Soft.textile.cfc.get_req_supplier_rival");
	get_money = CreateCompenent.getMoney();
	get_workstation=CreateCompenent.getWorkstation();
	if (attributes.request_plan eq 1)
			get_process=CreateCompenent.getReqProcess(req_id:attributes.req_id,pcatid:workshipman_maneger_pcatid);
		else if (attributes.workmanship_plan eq 1){
			get_process=CreateCompenent.getReqProcess(req_id:attributes.req_id,pcatid:workshipman_maneger_pcatid,plan_status=1);
		}
</cfscript>
<cfform name="add_req_process_gm" method="post" action="#request.self#?fuseaction=textile.emptypopup_add_req_process">
	<cf_form_list>
		<cfoutput>
			<cfif attributes.request_plan eq 1>
				<input type="hidden" name="supplier_page" value="request_plan">
			<cfelseif attributes.workmanship_plan eq 1>
				<input type="hidden" name="supplier_page" value="workmanship_plan">
			</cfif>
			<input type="hidden" name="req_id" id="req_id" value="#attributes.req_id#">
			<input type="hidden" name="referal_page" value="list_process_gm">
            <input type="hidden" name="record_num" id="record_num" value="#get_process.RECORDCOUNT#">
			<input type="hidden" name="product_catid" value="#workshipman_maneger_pcatid#">
			<cfif isDefined("attributes.plan_id") and len(attributes.plan_id)>
				<input type="hidden" name="plan_id" id="plan_id" value="#attributes.plan_id#">
			</cfif>
		</cfoutput>
        <thead>
            <tr>
				  <th width="170"><cf_get_lang dictionary_id='57777.İşlemler'>*</th>
                <th width="170"><cf_get_lang dictionary_id='33139.Onay Durumu'>*</th>
				  <th width="170"><cf_get_lang dictionary_id='58084.Fiyat'>*</th>
				  <th width="170"><cf_get_lang dictionary_id='40935.Revize'> <cf_get_lang dictionary_id='58084.Fiyat'></th>
				    <th width="50"><cf_get_lang dictionary_id='62709.Parabirim'>*</th>
					
				<!---<th width="150">Açıklama</th>--->
                <th width="50"><cf_get_lang dictionary_id='58080.Resim'></th>
            </tr>
        </thead>
        <tbody >
		<cfoutput query="get_process">
			<tr  class="color-row">
				<td>
					#product_name# #id#
					<input type="hidden" name="process#currentrow#" value="#process#">
						<input type="hidden" name="product_id#currentrow#" value="#product_id#">
						<input type="hidden" name="stock_id#currentrow#" value="#stock_id#">
						<input type="hidden" name="row_id#currentrow#" value="#id#">
				</td>
				<td nowrap="nowrap">
					<input type="checkbox" name="chk_proc#currentrow#" value="" <cfif sec gt 0>checked</cfif>>
				</td>
					<td nowrap="nowrap">
					<input type="text" name="price#currentrow#"  class="moneybox" value="#tlformat(req_price,textile_round)#" onkeyup="return(FormatCurrency(this,event,#textile_round#));"  style="width:100px;">
				</td>
				<td nowrap="nowrap">
					<input type="text"  name="revize_price#currentrow#" readonly   class="moneybox" value="#tlformat(revize_price,textile_round)#" onkeyup="return(FormatCurrency(this,event,#textile_round#));"  style="width:100px;">
				</td>
				<td nowrap="nowrap">
					<select name="money#currentrow#" id="money#currentrow#"  style="width:60px;">
					<cfloop query="get_money">
						<option value="#get_money.money#" <cfif get_money.money eq get_process.REQ_MONEY>selected</cfif>>#get_money.money#</option>
					</cfloop>
					</select>
				</td>
				<!---<td nowrap="nowrap">
					<input type="text" name="detail#currentrow#" id="detail#currentrow#" value="#tlformat(detail)#" style="width:155px;">	
				</td>--->
				<td nowrap="nowrap">
					<cfif len(IMAGE_PATH)>
								<a href="javascript://" onclick="windowopen('/documents/textile/iscilik/#IMAGE_PATH#','wwide');"><img src="/addons/n1-soft/textile/img/file_zcn_store.png" width="24" height="24" /></a>
							<input type="hidden"  name="image_var#currentrow#" id="image_var#currentrow#" value="#IMAGE_PATH#">
							<input type="file" style="width:120px;" name="image_#currentrow#" id="image_#currentrow#" value="">
						<cfelse>
								<input type="file" style="width:120px;"  name="image_#currentrow#" id="image_#currentrow#" value="">
						</cfif>
				</td>
			</tr>	
		</cfoutput>
        </tbody>
		<tfoot>
        	<tr>
            	<td colspan="9">                    
                    <div style="float:left;">
						<cfif get_process.RECORDCOUNT eq 0>
							<cf_workcube_buttons is_upd='0' add_function='kontrol_gm()' type_format="1">
							<cfelse>
								<cfif isDefined("attributes.req_stage") and attributes.req_stage neq request_accept_stage_id>
									<cf_workcube_buttons is_upd='1' is_delete="0" add_function='kontrol_gm()' type_format="1">
								</cfif>
							</cfif>
						
					</div>
					<div style="float:left;" id="show_user_message1_b"></div>
                </td>
            </tr>
        </tfoot>
    </cf_form_list>
</cfform>
<script type="text/javascript">
	function kontrol_gm()
	{
			//AjaxFormSubmit(add_req_process,'show_user_message1_b',0,'&nbsp;Kaydediliyor','&nbsp;Kaydedildi','#request.self#?fuseaction=textile.emptypopup_add_req_process"&req_id=#attributes.req_id#','div_list_process');return false;
		return true;
	}
</script>

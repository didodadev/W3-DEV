<cfinclude template="../../header.cfm">

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.process_stage" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isDefined("attributes.form_submitted")>
    <cfset transfer_order = createObject("component","WBP/Recycle/files/recycle_process/cfc/transfer_order") />
			
	<cfset GetTransferOrder = transfer_order.GetTransferOrder(
		keyword: attributes.keyword,
		process_stage = attributes.process_stage
    ) />
<cfelse>
	<cfset GetTransferOrder.recordcount=0>
</cfif>

<cfparam name="attributes.totalrecords" default=#GetTransferOrder.recordcount#>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_target" method="post" action="#request.self#?fuseaction=recycle.transfer_order">
			<cf_box_search>
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255" placeholder="#place#">
                </div>
                <div class="form-group">
					<cf_workcube_process is_upd='0' select_value="#attributes.process_stage#" process_cat_width='250' is_select_text="1" is_detail='0'>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'>!</cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
    </cf_box>

    <cfsavecontent variable="head"><cf_get_lang dictionary_id='62091.Transfer Emirleri'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <cfoutput>
                        <th><cf_get_lang dictionary_id='55657.Sıra No'></th>
                        <th><cf_get_lang dictionary_id='58859.Süreç'></th>
                        <th><cf_get_lang dictionary_id='62090.Emri Veren'></th>
						<th><cf_get_lang dictionary_id='62083.Operatör'></th>
						<th><cf_get_lang dictionary_id='62088.Giriş Tank'></th>
                        <th><cf_get_lang dictionary_id='62089.Çıkış Tank'></th>
                        <th><cf_get_lang_main no ='245.Ürün'></th>
                        <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                        <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=recycle.transfer_order&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                    </cfoutput>
                </tr>
            </thead>
            <tbody>
				<cfif GetTransferOrder.recordcount>
                    <cfoutput query="GetTransferOrder" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><cf_workcube_process type="color-status" process_stage="#PROCESS_STAGE#"></td>
                            <td>#ORDER_EMPLOYEE_NAME# #ORDER_EMPLOYEE_SURNAME#</td>
                            <td>#OPARATOR_EMPLOYEE_NAME# #OPARATOR_EMPLOYEE_SURNAME#</td>
                            <td>#DPE_DEPARTMENT_HEAD# - #STE_COMMENT#</td>
                            <td>#DPX_DEPARTMENT_HEAD# - #STX_COMMENT#</td>
                            <td>#PR_PRODUCT_NAME#</td>
                            <td>#AMOUNT#</td>
							<td style="text-align:center;"><a href="#request.self#?fuseaction=recycle.transfer_order&event=upd&refinery_transport_id=#REFINERY_TRANSPORT_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						</tr>
					</cfoutput>
				<cfelse>
                    <tr>
                        <td colspan="9"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
        </cf_grid_list>

        <cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "">
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.form_submitted)>
				<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
			</cfif>
			<cfif len(attributes.process_stage)>
				<cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
			</cfif>
			<cf_paging page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="recycle.transfer_order#url_str#">
        </cfif>
    </cf_box>
</div>
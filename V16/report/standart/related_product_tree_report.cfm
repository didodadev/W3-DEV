<cfparam name="attributes.module_id_control" default="35">
<cfinclude template="report_authority_control.cfm">
<cfsetting showdebugoutput="no">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.status" default="">
<cfscript>
	function get_subs(spect_main_id,row_spect_id)
	{					
		where_parameter = 'SMR.RELATED_MAIN_SPECT_ID = #spect_main_id#';	
		if(row_spect_id Neq 0) where_parameter = '#where_parameter# AND SMR.SPECT_MAIN_ID = #row_spect_id#';
		SQLStr = "
				SELECT
					SMR.SPECT_MAIN_ID,
					SMR.STOCK_ID,
					ROUND(ISNULL(SMR.AMOUNT,0),8) AMOUNT
				FROM 
					SPECT_MAIN_ROW SMR WITH (NOLOCK)
				WHERE
					#where_parameter#
			";
		query1 = cfquery(SQLString : SQLStr, Datasource : dsn3);
		stock_id_ary = '';
		for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
		{
			stock_id_ary=listappend(stock_id_ary,query1.SPECT_MAIN_ID[str_i],'-');
			stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.AMOUNT[str_i],'§');
		}
		return stock_id_ary;
	}
	function writeTree(next_spect_main_id,row_spect_id,row_stock_id,row_amount)
	{
		var i = 1;
		var sub_products = get_subs(next_spect_main_id,row_spect_id);
		for (i=1; i lte listlen(sub_products,'-'); i = i+1)
		{
			last_spect_id = ListGetAt(ListGetAt(sub_products,i,'-'),1,'§');//alt+987 = - --//alt+789 = §
			last_stock_id = ListGetAt(ListGetAt(sub_products,i,'-'),2,'§');//alt+987 = - --//alt+789 = §
			if(last_stock_id eq row_stock_id)
				last_amount = last_amount + ListGetAt(ListGetAt(sub_products,i,'-'),3,'§');//alt+987 = - --//alt+789 = §
			writeTree(last_spect_id,0,row_stock_id,ListGetAt(ListGetAt(sub_products,i,'-'),3,'§'));
		}		 
	}
	function get_subs2(spect_main_id)
	{					
		where_parameter2 = 'SMR.SPECT_MAIN_ID = #spect_main_id#';	
		SQLStr2 = "
				SELECT
					ISNULL(SMR.RELATED_MAIN_SPECT_ID,0)  SPECT_MAIN_ID,
					ISNULL(SMR.STOCK_ID,0) STOCK_ID,
					ROUND(ISNULL(SMR.AMOUNT,0),8) AMOUNT
				FROM 
					SPECT_MAIN_ROW SMR WITH (NOLOCK)
				WHERE
					#where_parameter2#
			";
		query2 = cfquery(SQLString : SQLStr2, Datasource : dsn3);
		stock_id_ary2 = '';
		for (str_i2=1; str_i2 lte query2.recordcount; str_i2 = str_i2+1)
		{
			stock_id_ary2=listappend(stock_id_ary2,query2.SPECT_MAIN_ID[str_i2],'-');
			stock_id_ary2=listappend(stock_id_ary2,query2.STOCK_ID[str_i2],'§');
			stock_id_ary2=listappend(stock_id_ary2,wrk_round(query2.AMOUNT[str_i2],8,1),'§');
		}
		return stock_id_ary2;
	}
	function writeTree2(next_spect_main_id,row_stock_id,new_amount,row_kontrol)
	{
		var j = 1;
		var sub_products2 = get_subs2(next_spect_main_id);
		for (j=1; j lte listlen(sub_products2,'-'); j = j+1)
		{
			last_spect_id_ = ListGetAt(ListGetAt(sub_products2,j,'-'),1,'§');//alt+987 = - --//alt+789 = §
			if(listlen(ListGetAt(sub_products2,j,'-'),'§') gt 1)
				last_stock_id_ = ListGetAt(ListGetAt(sub_products2,j,'-'),2,'§');//alt+987 = - --//alt+789 = §
			else
				last_stock_id_ = 0;
			if(row_kontrol eq 1) new_amount = 1;
			if(last_stock_id_ eq row_stock_id)
			{
				if(listlen(ListGetAt(sub_products2,j,'-'),'§') gt 2)
					last_amount = last_amount + (ListGetAt(ListGetAt(sub_products2,j,'-'),3,'§')*new_amount);//alt+987 = - --//alt+789 = §
			}
			if(last_spect_id_ gt 0 and listlen(ListGetAt(sub_products2,j,'-'),'§') gt 2)
				writeTree2(last_spect_id_,row_stock_id,ListGetAt(ListGetAt(sub_products2,j,'-'),3,'§')*new_amount,0);
		}		 
	}
</cfscript>
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.stock_name" default="">
<cfif len(attributes.stock_id)>
	<cfquery name="get_stock_info" datasource="#dsn3#">
		SELECT PRODUCT_NAME,PRODUCT_ID,PRODUCT_CODE,STOCK_ID FROM STOCKS WHERE STOCK_ID = #attributes.stock_id#
	</cfquery>
	<cfset attributes.product_id = get_stock_info.product_id>
	<cfset attributes.stock_name = get_stock_info.product_name>
	<cfquery name="get_related_trees" datasource="#dsn3#">
		SELECT DISTINCT
			S1.PRODUCT_CODE,
			S1.PRODUCT_NAME,
			S2.PRODUCT_ID ROW_ID,
			S2.STOCK_ID ROW_STOCK_ID,
			S2.PRODUCT_NAME ROW_NAME,
			S2.PRODUCT_CODE ROW_CODE,
			PU.ADD_UNIT,
			SMR.AMOUNT,
			SMR.SPECT_MAIN_ID,
			1 KONTROL,
			SMR2.SPECT_MAIN_ID AS ROW_SPECT
		FROM
			SPECT_MAIN_ROW SMR WITH (NOLOCK),
			PRODUCT_UNIT PU,
			STOCKS S1,
			STOCKS S2,
			SPECT_MAIN SM WITH (NOLOCK),
			SPECT_MAIN_ROW SMR2 WITH (NOLOCK)
		WHERE
			SMR.STOCK_ID = #attributes.stock_id#
			AND SMR.STOCK_ID = S1.STOCK_ID
			AND SM.STOCK_ID = S2.STOCK_ID
			AND S1.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
			AND SM.SPECT_MAIN_ID = SMR.SPECT_MAIN_ID
			AND SMR2.RELATED_MAIN_SPECT_ID = SMR.SPECT_MAIN_ID
			<cfif not isDefined("attributes.status")>AND S1.PRODUCT_STATUS = 1 
			<cfelseif (isDefined("attributes.status") and (attributes.status neq 2))>AND S1.PRODUCT_STATUS = #attributes.status# </cfif>
			AND SM.SPECT_MAIN_ID = (SELECT MAX(SMM.SPECT_MAIN_ID) FROM SPECT_MAIN SMM WITH (NOLOCK) WHERE SMM.STOCK_ID = SM.STOCK_ID)
			--AND SMR2.SPECT_MAIN_ID = (SELECT MAX(SPECT_MAIN_ID) FROM SPECT_MAIN_ROW SMMM WITH (NOLOCK) WHERE SMMM.RELATED_MAIN_SPECT_ID = SMR.SPECT_MAIN_ID)
		UNION ALL
		SELECT DISTINCT
			S1.PRODUCT_CODE,
			S1.PRODUCT_NAME,
			S2.PRODUCT_ID ROW_ID,
			S2.STOCK_ID ROW_STOCK_ID,
			S2.PRODUCT_NAME ROW_NAME,
			S2.PRODUCT_CODE ROW_CODE,
			PU.ADD_UNIT,
			SMR.AMOUNT,
			SMR.SPECT_MAIN_ID,
			0 KONTROL,
			0 ROW_SPECT
		FROM
			SPECT_MAIN_ROW SMR WITH (NOLOCK),
			PRODUCT_UNIT PU,
			STOCKS S1,
			STOCKS S2,
			SPECT_MAIN SM WITH (NOLOCK)
		WHERE
			SMR.STOCK_ID = #attributes.stock_id#
			AND SMR.STOCK_ID = S1.STOCK_ID
			AND SM.STOCK_ID = S2.STOCK_ID
			AND S1.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
			AND SM.SPECT_MAIN_ID = SMR.SPECT_MAIN_ID
			<cfif not isDefined("attributes.status")>AND S1.PRODUCT_STATUS = 1 
			<cfelseif (isDefined("attributes.status") and (attributes.status neq 2))>AND S1.PRODUCT_STATUS = #attributes.status# </cfif>
			AND SMR.SPECT_MAIN_ID NOT IN(SELECT SMR2.RELATED_MAIN_SPECT_ID FROM SPECT_MAIN_ROW SMR2 WITH (NOLOCK) WHERE SMR2.RELATED_MAIN_SPECT_ID IS NOT NULL)
			AND SM.SPECT_MAIN_ID = (SELECT MAX(SPECT_MAIN_ID) FROM SPECT_MAIN SMM WITH (NOLOCK) WHERE SMM.STOCK_ID = SM.STOCK_ID)
		ORDER BY
			S2.PRODUCT_NAME,
			SMR.SPECT_MAIN_ID
	</cfquery>
<cfelse>
	<cfset get_related_trees.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_related_trees.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="list_product" method="post" action="">
<input name="is_form_submited" id="is_form_submited" type="hidden" value="1">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='39182.İlişkili Ağaçlar Raporu'></cfsavecontent>
    <cf_report_list_search title="#title#">
        <cf_big_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-6 col-sm-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'>*</label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
											<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
											<cfinput type="text" name="stock_name" id="stock_name" style="width:150px;" value="#attributes.stock_name#" onFocus="AutoComplete_Create('stock_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','STOCK_ID,PRODUCT_ID','stock_id,product_id','','3','225');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=list_product.stock_id&product_id=list_product.product_id&field_name=list_product.stock_name','list');"></span>
										</div>
									</div>
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
									<div class="col col-12 col-xs-12">
											<select name="status" id="status">
												<option value="1" <cfif isdefined('attributes.status') and attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
												<option value="0" <cfif isdefined('attributes.status') and attributes.status eq 0>selected </cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
												<option value="2" <cfif isdefined('attributes.status') and attributes.status eq 2>selected</cfif>><cf_get_lang dictionary_id ='57708.Tümü'></option>
											</select>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3"  onKeyUp="isNumber(this)"  style="width:25px;">
							</cfif>
							<cf_wrk_report_search_button search_function='kontrol()' is_excel="1" button_type="1">
						</div>
					</div>
				</div>
			</div>									

        </cf_big_list_search_area>
    </cf_report_list_search>
</cfform>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset filename="related_product_tree_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="content-type" content="text/plain; charset=utf-8">
	
	<cfset type_ = 1>
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_related_trees.recordcount>				
<cfelse>
	<cfset type_ = 0>
</cfif>    
<cfif isdefined("attributes.is_form_submited")>
<cf_report_list>
        <thead>
        <tr>
            <th width="20"><cf_get_lang dictionary_id ='57487.No'></th>
            <th width="100"><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
            <th><cf_get_lang dictionary_id='57657.Ürün'></th>    
            <th nowrap><cf_get_lang dictionary_id='39308.Bağlı Olduğu Stok Kodu'></th>
            <th><cf_get_lang dictionary_id='39338.Bağlı Olduğu Ürün'></th>
            <th nowrap><cf_get_lang dictionary_id='39341.Bağlı Olduğu Ana Stok Kodu'></th>
            <th><cf_get_lang dictionary_id='39366.Bağlı Olduğu Ana Ürün'></th>
            <th><cf_get_lang dictionary_id='39391.Kullanılan Miktar'></th>
            <th><cf_get_lang dictionary_id='57636.Birim'></th>
            <th><cf_get_lang dictionary_id='40163.Toplam Miktar'></th>
        </tr>
        </thead>
        <tbody>
        <cfif get_related_trees.recordcount>
            <cfquery name="get_all_stocks" datasource="#dsn3#">
                SELECT
                    S.PRODUCT_CODE,
                    S.PRODUCT_CODE_2,
                    S.PRODUCT_NAME,
                    S.PRODUCT_ID,
                    S.STOCK_ID,
                    SM.SPECT_MAIN_ID
                FROM 
                    SPECT_MAIN SM,
                    STOCKS S
                WITH (NOLOCK)
                WHERE
                    S.STOCK_ID = SM.STOCK_ID
            </cfquery>
            <cfoutput query="get_related_trees" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <cfset last_spect_id = ''>
                    <cfset last_amount = 0>
                    <cfif kontrol eq 1>
                        <cfscript>
                            writeTree(spect_main_id,row_spect,attributes.stock_id,amount);
                        </cfscript>
                    </cfif>
                    <cfif isdefined("last_spect_id") and len(last_spect_id)>
                        <cfquery name="get_row_stock" dbtype="query">
                            SELECT * FROM get_all_stocks WHERE SPECT_MAIN_ID = #last_spect_id#
                        </cfquery>
                        <cfif get_row_stock.recordcount>
                            <cfset row_code2 = get_row_stock.PRODUCT_CODE>
                            <cfset row_name2 = get_row_stock.PRODUCT_NAME>
                            <cfset row_id2 = get_row_stock.PRODUCT_ID>
                        <cfelse>
                            <cfset row_code2 = row_code>
                            <cfset row_name2 = row_name>
                            <cfset row_id2 = row_id>
                        </cfif> 
                    <cfelse>
                        <cfset row_code2 = row_code>
                        <cfset row_name2 = row_name>
                        <cfset row_id2 = row_id>
                    </cfif>
                    <td>#currentrow#</td>
                    <td>#get_stock_info.product_code#</td>
                    <td>#get_stock_info.product_name#</td>
                    <td>
                        <cfif type_ eq 1>
                            #row_code#
                        <cfelse>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_related_trees&stock_id=#row_stock_id#','project');" class="tableyazi">#row_code#</a>
                        </cfif>
                    </td>
                    <td>
                        <cfif type_ eq 1>
                            #row_name#
                        <cfelse>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#row_id#','large');" class="tableyazi">#row_name#</a>
                        </cfif>
                    </td>
                    <td>#row_code2#</td>
                    <td>
                        <cfif type_ eq 1>
                            #row_name2#
                        <cfelse>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#row_id2#','large');" class="tableyazi">#row_name2#</a>								
                        </cfif>
                    </td>
                    <td align="right" format="numeric">#tlformat(wrk_round(amount,8,1),8)#</td>
                    <td>#add_unit#</td>
                    <cfif len(last_spect_id) and last_spect_id gt 0>
                        <cfset new_spect = last_spect_id>
                    <cfelse>
                        <cfset new_spect = spect_main_id>
                    </cfif>
                    <cfscript>
                        writeTree2(new_spect,attributes.stock_id,amount,1);
                    </cfscript>
                    <td align="right" format="numeric">#tlformat(wrk_round(last_amount,8,1),8)#</td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="10"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
            </tr>
        </cfif>
        </tbody>  
</cf_report_list>
</cfif>
<cfif isdefined('attributes.totalrecords') and attributes.totalrecords gt attributes.maxrows> 
<cfset adres="report.related_product_tree_report&stock_id=#attributes.stock_id#&is_form_submited=1">
	<cfif isdefined('attributes.status') and len(attributes.status)>
        <cfset adres = "#adres#&status=#attributes.status#">
    </cfif>	  
	<cf_paging
	page="#attributes.page#" 
	maxrows="#attributes.maxrows#" 
	totalrecords="#attributes.totalrecords#" 
	startrow="#attributes.startrow#" 
	adres="#adres#">		
</cfif>
<script type="text/javascript">
	function kontrol()
	{
		if(document.list_product.stock_name.value == '' || document.list_product.product_id.value == '')
		{
			alert("<cf_get_lang dictionary_id='58227.Ürün Seçmelisiniz'> !");
			return false;
		}
		if(document.list_product.is_excel.checked==false)
		{
			document.list_product.action="<cfoutput>#request.self#?fuseaction=report.related_product_tree_report</cfoutput>";
			return true;
		}
		else
			document.list_product.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_related_product_tree_report</cfoutput>";
	
	}
</script>

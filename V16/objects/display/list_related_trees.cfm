<cfsetting showdebugoutput="no">
<cfscript>
	function get_subs(spect_main_id,row_spect_id)
	{					
		where_parameter = 'SMR.RELATED_MAIN_SPECT_ID = #spect_main_id#';	
		if(row_spect_id Neq 0) where_parameter = '#where_parameter# AND SMR.SPECT_MAIN_ID = #row_spect_id#';
		SQLStr = "
				SELECT
					SMR.SPECT_MAIN_ID,
					SMR.STOCK_ID
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
		}
		return stock_id_ary;
	}
	function writeTree(next_spect_main_id,row_spect_id)
	{
		var i = 1;
		var sub_products = get_subs(next_spect_main_id,row_spect_id);
		for (i=1; i lte listlen(sub_products,'-'); i = i+1)
		{
			last_spect_id = ListGetAt(ListGetAt(sub_products,i,'-'),1,'§');//alt+987 = - --//alt+789 = §
			last_stock_id = ListGetAt(ListGetAt(sub_products,i,'-'),2,'§');//alt+987 = - --//alt+789 = §
			writeTree(last_spect_id,0);
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
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif len(attributes.stock_id)>
	<cfquery name="get_stock_info" datasource="#dsn3#">
		SELECT PRODUCT_NAME,PRODUCT_ID,STOCK_CODE PRODUCT_CODE,STOCK_ID FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
	</cfquery>
	<cfset attributes.product_id = get_stock_info.product_id>
	<cfset attributes.product_name = get_stock_info.product_name>
	<cfquery name="get_related_trees" datasource="#dsn3#">
        WITH CTE1 AS (
            SELECT DISTINCT
                S1.STOCK_CODE PRODUCT_CODE,
                S1.PRODUCT_NAME+' '+ISNULL(S1.PROPERTY,'') PRODUCT_NAME,
                S2.PRODUCT_ID ROW_ID,
                S2.STOCK_ID ROW_STOCK_ID,
                S2.PRODUCT_NAME+' '+ISNULL(S2.PROPERTY,'') ROW_NAME,
                S2.STOCK_CODE ROW_CODE,
                S2.PROPERTY,
                PU.ADD_UNIT,
                ROUND(ISNULL(SMR.AMOUNT,0),8) AMOUNT,
                SMR.SPECT_MAIN_ID,
                CASE WHEN SMR2.SPECT_MAIN_ID IS NULL THEN 0 ELSE 1 END AS KONTROL,
                ISNULL(SMR2.SPECT_MAIN_ID,0) AS ROW_SPECT
            FROM 
                (
                    SELECT MAX(SPECT_MAIN_ID) AS SPECT_MAIN_ID,STOCK_ID FROM SPECT_MAIN WITH (NOLOCK) WHERE SPECT_STATUS = 1  GROUP BY STOCK_ID 
                ) AS SM 
                JOIN SPECT_MAIN_ROW SMR WITH (NOLOCK) ON SMR.SPECT_MAIN_ID = SM.SPECT_MAIN_ID 
                LEFT JOIN SPECT_MAIN_ROW SMR2 WITH (NOLOCK) ON SMR.SPECT_MAIN_ID = SMR2.RELATED_MAIN_SPECT_ID
                JOIN STOCKS S1 WITH (NOLOCK) ON S1.STOCK_ID = SMR.STOCK_ID 
                JOIN PRODUCT_UNIT PU WITH (NOLOCK) ON S1.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID 
                JOIN STOCKS S2 WITH (NOLOCK) ON S2.STOCK_ID = SM.STOCK_ID
            WHERE 
                  SMR.STOCK_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
        ),
             CTE2 AS (
                    SELECT
                        CTE1.*,
                        ROW_NUMBER() OVER (	ORDER BY PRODUCT_NAME+' '+ISNULL(PROPERTY,'') ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                    FROM
                        CTE1
                )
                SELECT
                    CTE2.*
                FROM
                    CTE2
                WHERE
                    RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
	</cfquery>
<cfelse>
	<cfset get_related_trees.recordcount = 0>
</cfif>
<cfif get_related_trees.recordcount>
    <cfparam name="attributes.totalrecords" default='#get_related_trees.query_count#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','İlişkili Ağaç',32525)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_related_trees" method="post" action="#request.self#?fuseaction=objects.popup_list_related_trees">
		<cf_box_search more="0">
			<cfinput type="hidden" name="is_form_sunbmitted" value="1">
			<div class="form-group">
				<div class="input-group">
					<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
					<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
					<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
					<cfinput type="text" name="product_name" id="product_name" placeholder="#getLang('','Ürün',57657)#" value="#attributes.product_name#" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','STOCK_ID,PRODUCT_ID','stock_id,product_id','','3','225');" autocomplete="off">
					<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=search_related_trees.stock_id&product_id=search_related_trees.product_id&field_name=search_related_trees.product_name');"></span>			
				</div>
			</div>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">									
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('search_related_trees' , #attributes.modal_id#)"),DE(""))#" >
			</div>
		</cf_box_search>
	</cfform>
	<div class="ui-card">
		<div class="ui-card-item">
			<p><span class="bold"><cf_get_lang dictionary_id='57657.Ürün'>:</span> <cfoutput>#get_stock_info.product_code# / #get_stock_info.product_name#</cfoutput></p>
		</div>
	</div>
	<cf_grid_list>
		<thead>
			<tr>
				<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
				<th nowrap="nowrap"><cf_get_lang dictionary_id='32537.Bağlı Olduğu Stok Kodu'></th>
				<th><cf_get_lang dictionary_id='32543.Bağlı Olduğu Ürün'></th>
				<th nowrap="nowrap"><cf_get_lang dictionary_id='32547.Bağlı Olduğu Ana Stok Kodu'></th>
				<th><cf_get_lang dictionary_id='32548.Bağlı Olduğu Ana Ürün'></th>
				<th><cf_get_lang dictionary_id='32551.Kullanılan Miktar'></th>
				<th><cf_get_lang dictionary_id='57636.Birim'></th>
				<th><cf_get_lang dictionary_id='32823.Toplam Miktar'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_related_trees.recordcount>
				<cfoutput query="get_related_trees">
					<tr>
						<cfset last_spect_id = ''>
						<cfset last_amount = 0>
						<cfif kontrol eq 1>
							<cfscript>
								writeTree(spect_main_id,row_spect);
							</cfscript>
						</cfif>
						<cfif isdefined("last_spect_id") and len(last_spect_id)>
							<cfquery name="get_all_stocks" datasource="#dsn3#">
								SELECT 
									S.STOCK_CODE PRODUCT_CODE,
									S.PRODUCT_CODE_2,
									S.PRODUCT_NAME+' '+ISNULL(S.PROPERTY,'') PRODUCT_NAME,
									S.PRODUCT_ID,
									S.STOCK_ID,
									SM.SPECT_MAIN_ID
								FROM 
									SPECT_MAIN SM,
									STOCKS S
								WITH (NOLOCK)
								WHERE
									S.STOCK_ID = SM.STOCK_ID AND
									SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#last_spect_id#">
							</cfquery>
							<cfif get_all_stocks.recordcount>
								<cfset row_code2 = get_all_stocks.PRODUCT_CODE>
								<cfset row_name2 = get_all_stocks.PRODUCT_NAME>
								<cfset row_id2 = get_all_stocks.PRODUCT_ID>
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
						<td>#rownum#</td>
						<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_related_trees&stock_id=#row_stock_id#');">#row_code#</a></td>
						<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#row_id#','large');">#row_name#</a></td>
						<td>#row_code2#</td>
						<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#row_id2#','large');">#row_name2#</a></td>
						<td class="text-right">#tlformat(wrk_round(amount,8,1),8)#</td>
						<td>#add_unit#</td>
						<cfif len(last_spect_id) and last_spect_id gt 0>
							<cfset new_spect = last_spect_id>
						<cfelse>
							<cfset new_spect = spect_main_id>
						</cfif>
						<cfscript>
							writeTree2(new_spect,attributes.stock_id,amount,1);
						</cfscript>
						<td class="text-right">#tlformat(wrk_round(last_amount,8,1),8)#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cf_paging 
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="#attributes.fuseaction#&stock_id=#attributes.stock_id#"
		isAjax="#iif(isdefined("attributes.draggable"),1,0)#">        
</cf_box>
<script type="text/javascript">
	function kontrol()
	{
		if(search_related_trees.product_name.value == '' || search_related_trees.product_id.value == '')
		{
			alert("<cf_get_lang dictionary_id='58227.Ürün Seçmelisiniz'>!");
			return false;
		}
		return true;
	}
</script>

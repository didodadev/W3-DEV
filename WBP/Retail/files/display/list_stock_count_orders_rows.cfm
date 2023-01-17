<cf_get_lang_set module_name="objects">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.user_code" default="">
<cfparam name="attributes.list_type" default="2">
<cfparam name="attributes.re_count" default="2">

<cfquery name="get_stock_row_control" datasource="#dsn_Dev#">
	SELECT SMT.TABLE_CODE FROM STOCK_MANAGE_TABLES SMT WHERE SMT.ORDER_ID = #attributes.order_id#
</cfquery>

<cfquery name="get_stock_open_import" datasource="#DSN_DEV#">
	SELECT
		(SELECT S.PROPERTY FROM #dsn1_alias#.STOCKS S WHERE S.STOCK_ID = SCOR.REAL_STOCK_ID) AS PROPERTY2,
        SCOR.*,
        SCOR.STOCK_NAME AS PROPERTY
	FROM 
		STOCK_COUNT_ORDERS_ROWS SCOR
	WHERE	
    	<cfif len(attributes.keyword)>
        (
        	SCOR.BARCODE = '#attributes.keyword#' OR
            SCOR.STOCK_NAME LIKE '%#attributes.keyword#%' OR
            SCOR.USER_CODE = '#attributes.keyword#'
        ) AND
        </cfif>
        <cfif len(attributes.user_code)>
           SCOR.USER_CODE = '#attributes.user_code#' AND
        </cfif>
        <cfif attributes.list_type eq 1>
        	SCOR.STOCK_ID IS NOT NULL AND
        </cfif>
        <cfif attributes.list_type eq 0>
        	SCOR.STOCK_ID IS NULL AND
        </cfif>
        <cfif attributes.re_count eq 1>
        	SCOR.IS_UPDATE  = 1 AND
       	<cfelseif attributes.re_count eq 0>
        	SCOR.IS_UPDATE  = 0 AND
        </cfif>
        SCOR.ORDER_ID = #attributes.order_id#
	ORDER BY
		SCOR.ROW_ID DESC
</cfquery>

<cfquery name="get_user_codes" datasource="#dsn_dev#">
	SELECT DISTINCT USER_CODE FROM STOCK_COUNT_ORDERS_ROWS WHERE ORDER_ID = #attributes.order_id#
</cfquery>


<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_stock_open_import.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="list_stock_count" method="post" action="">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cfinput type="hidden" name="order_id" value="#attributes.order_id#">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getLang('','Filtre',57460)#">
				</div>
				<div class="form-group">
					<select name="user_code" id="user_code">
						<option value=""><cf_get_lang dictionary_id='57930.Kullanıcı'></option>
						<cfoutput query="get_user_codes">
							<option value="#user_code#" <cfif user_code is attributes.user_code>selected</cfif>>#user_code#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="list_type" id="list_type">
						<option value=""><cf_get_lang dictionary_id='38737.Stok Durumu'></option>
						<option value="2" <cfif attributes.list_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58081.Hepsi'></option>
						<option value="1" <cfif attributes.list_type eq 1>selected</cfif>><cf_get_lang dictionary_id='33476.Stokta Olanlar'></option>
						<option value="0" <cfif attributes.list_type eq 0>selected</cfif>><cf_get_lang dictionary_id='61615.Stokta Olmayanlar'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="re_count" id="re_count">
						<option value=""><cf_get_lang dictionary_id='62448.Tekrar Sayımı'></option>
						<option value="2" <cfif attributes.re_count eq 2>selected</cfif>><cf_get_lang dictionary_id='58081.Hepsi'></option>
						<option value="1" <cfif attributes.re_count eq 1>selected</cfif>><cf_get_lang dictionary_id='50042.Yapılanlar'></option>
						<option value="0" <cfif attributes.re_count eq 0>selected</cfif>><cf_get_lang dictionary_id='50104.Yapılmayanlar'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='43958.Kayıt Sayısı Hatalı'></cfsavecontent>
					<input type="text" name="maxrows" id="maxrows" value="<cfoutput>#attributes.maxrows#</cfoutput>" required="yes" validate="integer" range="1,999" message="Kayıt Sayısı Hatalı" maxlength="3" onKeyUp="isNumber (this)"  style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Sayım Emir Satırları',61616)#" uidrop="1" hide_table_column="1"> 
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='30631.Tarih'></th>
					<th><cf_get_lang dictionary_id='57633.Barkod'></th>
					<th><cf_get_lang dictionary_id='57452.Stok'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th>G <cf_get_lang dictionary_id='57452.Stok'></th>
					<th style="text-align:right;">G <cf_get_lang dictionary_id='57635.Miktar'></th>
					<th><cf_get_lang dictionary_id='57930.Kullanıcı'></th>
					<th><cf_get_lang dictionary_id='61617.Tekrar Sayım'></th>
					<th><cf_get_lang dictionary_id='61618.Düzeltme Öncesi'></th>
					<th width="20"><cfif not get_stock_row_control.recordcount><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=retail.list_stock_count_orders_rows&event=add&order_id=#attributes.order_id#</cfoutput>','large');"><i class="fa fa-plus"></i></a></cfif></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_stock_open_import.recordcount>
					<cfoutput query="get_stock_open_import" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="35">#currentrow#</td>
							<td>
								<cfset record_ = dateadd('h',session.ep.time_zone,record_date)>
								#dateformat(record_,"dd/mm/yyyy")# (#timeformat(record_,'HH:MM')#)</td>
							<td>#barcode#</td>
							<td>#property#</td>
							<td style="text-align:right;">#tlformat(amount,2)#</td>
							<td>#property2#</td>
							<td style="text-align:right;">#tlformat(real_stock_amount,2)#</td>
							<td>#user_code#</td>
							<td><cfif is_update eq 1><cf_get_lang dictionary_id='58564.Var'><cfelse><cf_get_lang dictionary_id='58546.Yok'></cfif></td>
							<td><cfif is_update eq 1>#tlformat(amount_first,2)#</cfif></td>
							<td><cfif not get_stock_row_control.recordcount><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.list_stock_count_orders_rows&event=upd&row_id=#row_id#','medium');"><i class="fa fa-pencil"></i></a></cfif></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="12"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>


<cfset url_string = "">
<cfset url_string = "#url_string#&order_id=#attributes.order_id#">
<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
<cfset url_string = "#url_string#&user_code=#attributes.user_code#">
<cfset url_string = "#url_string#&list_type=#attributes.list_type#">
<cfset url_string = "#url_string#&re_count=#attributes.re_count#">
<cf_paging page="#attributes.page#" 
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#url.fuseaction##url_string#">
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.start_date" default="" >
<cfparam name="attributes.finish_date" default="" >
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.is_submitted" default="1">
<cfparam name="attributes.keyword" default="">

<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>

<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
	<cfset attributes.finish_date=date_add("h",23,attributes.finish_date)>
	<cfset attributes.finish_date=date_add("n",59,attributes.finish_date)>
	<cfset attributes.finish_date=date_add("s",59,attributes.finish_date)>
</cfif>

<cfquery name="get_stock_open_import" datasource="#DSN_DEV#">
	SELECT
		ISNULL((SELECT COUNT(ROW_ID) SAYI FROM STOCK_COUNT_ORDERS_STOCKS WHERE ORDER_ID = STOCK_COUNT_ORDERS.ORDER_ID),0) STOCK_COUNT,
        ISNULL((SELECT COUNT(ROW_ID) SAYI FROM STOCK_COUNT_ORDERS_ROWS WHERE ORDER_ID = STOCK_COUNT_ORDERS.ORDER_ID),0) SATIR_SAYISI,
        ISNULL((SELECT COUNT(ROW_ID) SAYI FROM STOCK_COUNT_ORDERS_ROWS WHERE ORDER_ID = STOCK_COUNT_ORDERS.ORDER_ID AND STOCK_ID IS NULL),0) ESLESMEYEN,
        STOCK_COUNT_ORDERS.*,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		DEPARTMENT.DEPARTMENT_HEAD,
		DEPARTMENT.DEPARTMENT_HEAD,
        ISNULL((SELECT TOP 1 TABLE_CODE FROM #DSN_DEV_ALIAS#.STOCK_MANAGE_TABLES WHERE ORDER_ID = STOCK_COUNT_ORDERS.ORDER_ID),0) STOCK_TABLE
	FROM
		STOCK_COUNT_ORDERS,
		#DSN_ALIAS#.EMPLOYEES EMPLOYEES,
		#DSN_ALIAS#.DEPARTMENT DEPARTMENT
	WHERE
		<cfif len(attributes.keyword)>
        	STOCK_COUNT_ORDERS.ORDER_DETAIL LIKE '%#attributes.keyword#%' AND
        </cfif>
		<cfif len(attributes.status)>
        	STOCK_COUNT_ORDERS.STATUS = #attributes.status# AND
        </cfif>
        DEPARTMENT.DEPARTMENT_ID = STOCK_COUNT_ORDERS.DEPARTMENT_ID AND
		STOCK_COUNT_ORDERS.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID 
		<cfif isDefined("attributes.employee_name") and len(attributes.employee_name) and isDefined("attributes.employee_id") and len(attributes.employee_id)>
			AND STOCK_COUNT_ORDERS.RECORD_EMP = #attributes.employee_id#
		</cfif>
		<cfif isdefined("attributes.department_id") and listlen(attributes.department_id)>
			AND STOCK_COUNT_ORDERS.DEPARTMENT_ID = #attributes.department_id#
		</cfif>
		<cfif isdefined("attributes.start_date") and isdate(attributes.start_date) and isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
			AND STOCK_COUNT_ORDERS.ORDER_DATE BETWEEN  #attributes.start_date# AND  #attributes.finish_date#
		</cfif>
	ORDER BY
		STOCK_COUNT_ORDERS.ORDER_DATE DESC
</cfquery>

<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cfset attributes.start_date = dateformat(attributes.start_date,'dd/mm/yyyy')>
</cfif>

<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cfset attributes.finish_date = dateformat(attributes.finish_date,'dd/mm/yyyy')>
</cfif>

<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_stock_open_import.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="list_stock_count" method="post" action="">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent  variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
						<cfinput type="text" name="keyword" id="keyword" style="width:75px;" value="#attributes.keyword#" maxlength="500" placeholder="#message#">
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi Girmelisiniz'>!</cfsavecontent>
						<cfsavecontent  variable="place1"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
						<cfinput type="text" name="start_date" id="start_date" value="#attributes.start_date#" style="width:65px;" validate="eurodate" maxlength="10" message="#message#" placeholder="#place1#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
						<cfsavecontent  variable="place2"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
						<cfinput type="text" name="finish_date" id="finish_date" value="#attributes.finish_date#" style="width:65px;" validate="eurodate" maxlength="10" message="#message#" placeholder="#place2#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58763.Depo'></cfsavecontent>
					<select name="department_id" id="department_id" style="width:250;">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfoutput query="get_all_location">
							<option value="#department_id#"<cfif attributes.department_id eq department_id> selected</cfif>>#department_head#</option>
						</cfoutput>
					</select>	
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57899.Kaydeden'></cfsavecontent>
						<input type="hidden"  name="employee_id" id="employee_id" maxlength="50" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isDefined("attributes.employee_name") and len(attributes.employee_name)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
						<input type="text" name="employee_name" id="employee_name" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isDefined("attributes.employee_name") and len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" style="width:100px;" placeholder="<cfoutput>#getLang("","Kaydeden",57899)#</cfoutput>">
						<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_stock_count.employee_id&field_name=list_stock_count.employee_name&select_list=1','list','popup_list_positions')"><img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id='57899.Kaydeden'>"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="status" id="status">
						<option value=""><cf_get_lang dictionary_id='57756.Durum'></option>
						<option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</div>
				<div class="form-group">
					<div class="input-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'>!</cfsavecontent>
						<input type="text" name="maxrows" id="maxrows" value="<cfoutput>#attributes.maxrows#</cfoutput>" required="yes" validate="integer" range="1,999" message="Kayıt Sayısı Hatalı" maxlength="3" onKeyUp="isNumber (this)"  style="width:25px;">
					</div>
				</div>
				<div class="form-group">
					<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
					<cf_wrk_search_button button_type="4" search_function="date_check(list_stock_count.start_date,list_stock_count.finish_date,'#message_date#')">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent  variable="head"><cf_get_lang dictionary_id='61495.Sayım Emirleri'></cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id ='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id ='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id ='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='58763.Depo'></th>
					<th><cf_get_lang dictionary_id='61496.Kademe Durumu'></th>
					<th><cf_get_lang dictionary_id='57452.Stok'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='61497.Sayım Tipi'></th>
					<th><cf_get_lang dictionary_id ='57483.Kayıt'></th>
					<th><cf_get_lang dictionary_id ='57627.Kayit Tarihi'></th>
					<th><cf_get_lang dictionary_id ='57756.Durum'></th>
					<th><cf_get_lang dictionary_id ='58508.Satır'></th>
					<th title="Eşleşmeyen">X</th>
					<!-- sil --><th width="20" class="header_icn_none text-center"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=retail.list_stock_count_orders&event=add</cfoutput>','list','popup_form_import_stock_count');"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id ='57582.Ekle'>" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_stock_open_import.recordcount>
					<cfoutput query="get_stock_open_import" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="35">#currentrow#</td>
							<td>#dateformat(order_date,"dd/mm/yyyy")#</td>
							<td>#order_detail#</td>
							<td>#department_head#</td>
							<td><cfif order_type eq 0><cf_get_lang dictionary_id='58430.Kademesiz'><cfelse><cf_get_lang dictionary_id='58432.Kademeli'></cfif></td>
							<td>#STOCK_COUNT#</td>
							<td>
								<cfquery name="get_alts" datasource="#dsn_Dev#">
									SELECT 
										PC.HIERARCHY,
										PC.PRODUCT_CAT 
									FROM 
										STOCK_COUNT_ORDERS_PRODUCT_CATS PRC,
										#DSN1_ALIAS#.PRODUCT_CAT PC
									WHERE 
										PRC.ORDER_ID = #ORDER_ID# AND
										PRC.PRODUCT_CAT = PC.HIERARCHY
									ORDER BY
										PC.HIERARCHY
								</cfquery>
								<cfif get_alts.recordcount>
									<cfloop query="get_alts">
										<b>#get_alts.HIERARCHY#</b> #get_alts.PRODUCT_CAT#<br />
									</cfloop>
								</cfif>
							</td>
							<td><cfif count_type eq 1>1.<cf_get_lang dictionary_id='32041.Sayım'><cfelseif count_type eq 2>2.<cf_get_lang dictionary_id='32041.Sayım'><cfelse><cf_get_lang dictionary_id='61514.Son Sayım'></cfif></td>
							<td><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
							<td>#dateformat(record_Date,"dd/mm/yyyy")# (#timeformat(record_Date,"HH:MM")#)</td>
							<td><cfif status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
							<td style="text-align:right;"><a href="#request.self#?fuseaction=retail.list_stock_count_orders_rows&order_id=#order_id#" class="tableyazi">#SATIR_SAYISI#</a></td>
							<td style="text-align:right;"><a href="#request.self#?fuseaction=retail.list_stock_count_orders_rows&order_id=#order_id#&list_type=0" class="tableyazi">#ESLESMEYEN#</a></td>
							<!-- sil -->
							<td width="55">
								<ul class="ui-icon-list">
									<li><a href="#request.self#?fuseaction=retail.list_stock_count_orders&event=compare&order_id=#order_id#" class="tableyazi"><i class="fa fa-question" title="<cf_get_lang dictionary_id='61541.Sayımları Karşılaştır'>"></i></a></li>
									<cfif order_type eq 1>
										<li><a href="#request.self#?fuseaction=retail.list_stock_count_orders&event=compareOrders&main_order_id=<cfif len(main_order_id)>#main_order_id#<cfelse>#order_id#</cfif>"><i class="fa fa-question" alt="<cf_get_lang dictionary_id='61541.Sayımları Karşılaştır'>" title="<cf_get_lang dictionary_id='61541.Sayımları Karşılaştır'>"></i></a></li>
									</cfif>
									<cfif STOCK_TABLE eq 0>
										<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=retail.list_stock_count_orders&event=transfer&order_id=#order_id#','list');"><i class="icn-md icon-exchange" alt="<cf_get_lang dictionary_id='61540.Eşleştir'>" title="<cf_get_lang dictionary_id='61540.Eşleştir'>"></i></a>
										<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=retail.list_stock_count_orders&event=upd&order_id=#order_id#','list');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></li>
									<cfelse>
										<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=retail.list_stock_count_orders&event=upd&order_id=#order_id#','list');"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></li>
									</cfif>
								</ul>
							</td><!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="14"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset url_string = "">
		<cfif isDefined("attributes.start_date") and len(attributes.start_date)>
		<cfset url_string = "#url_string#&start_date=#attributes.start_date#">
		</cfif>
		<cfif isDefined("attributes.finish_date") and len(attributes.finish_date)>
		<cfset url_string = "#url_string#&finish_date=#attributes.finish_date#">
		</cfif>
		<cfif isDefined("attributes.department_id") and len(attributes.department_id)>
		<cfset url_string = "#url_string#&department_id=#attributes.department_id#">
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
		</cfif>

		<cf_paging page="#attributes.page#" 
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="#url.fuseaction##url_string#">
		
	</cf_box>
</div>




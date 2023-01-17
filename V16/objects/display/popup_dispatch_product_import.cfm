<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.is_ship_iptal" default="">
<cfparam name="attributes.dept_id" default="">
<cfparam name="attributes.loc_id" default="">
<cfparam name="attributes.modal_id" default="">
<cfquery name="get_product_name" datasource="#dsn3#">
	SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
</cfquery>
<cfquery name="get_ship" datasource="#dsn2#">
	SELECT
		SHIP_ID,
		SHIP_TYPE,
		SHIP_NUMBER,
		SHIP_DATE,
		DELIVER_STORE_ID,
		DEPARTMENT_IN
	FROM
		SHIP
	WHERE
		<cfif len(attributes.keyword)>
			SHIP_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> AND
		</cfif>
		SHIP_ID IN (SELECT SHIP_ID FROM SHIP_ROW WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">) AND 
		SHIP_TYPE IN (81,811) AND
		(IS_DELIVERED = 0 OR IS_DELIVERED IS NULL)
		<cfif isdefined("attributes.dept_id") and len(attributes.dept_id)>
			AND DELIVER_STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dept_id#">
		</cfif>
		<cfif isdefined("attributes.loc_id") and len(attributes.loc_id)>
			AND LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.loc_id#">
		</cfif>
		<cfif isdefined("attributes.is_ship_iptal") and attributes.is_ship_iptal eq 1>
			AND IS_SHIP_IPTAL = 0
		</cfif>
	ORDER BY
		SHIP_DATE
</cfquery>
<cfparam name="attributes.totalrecords" default='#get_ship.recordcount#'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfif len(attributes.pid)>
	<cfset url_str = "#url_str#&pid=#attributes.pid#">
</cfif>
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.is_ship_iptal)>
	<cfset url_str = "#url_str#&is_ship_iptal=#attributes.is_ship_iptal#">
</cfif>
<cfif isdefined("attributes.dept_id") and len(attributes.dept_id)>
	<cfset url_str = "#url_str#&dept_id=#attributes.dept_id#">
</cfif>
<cfif isdefined("attributes.loc_id") and len(attributes.loc_id)>
	<cfset url_str = "#url_str#&loc_id=#attributes.loc_id#">
</cfif>
<cf_box title="#getLang('','Depolararası Sevk',45377)# - #getLang('','İthal Mal Girişi',29588)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
				<cfform name="search_list" action="#request.self#?fuseaction=objects.popup_dispatch_product_import&pid=#attributes.pid#&dept_id=#attributes.dept_id#&loc_id=#attributes.loc_id#" method="post">
					<cf_box_search>
					<input type="hidden" name="is_submitted" id="is_submitted" value="1">
				<div class="form-group">
						<cfinput type="text" name="keyword" placeholder="#getlang('','Filtre','57460')#" value="#attributes.keyword#" maxlength="255" style="width:80px;">
						<input type="checkbox"  name="is_ship_iptal" id="is_ship_iptal" value="1"<cfif attributes.is_ship_iptal eq 1>checked</cfif>><label><cf_get_lang dictionary_id='60156.İptaller Gelmesin'></label>
					</div>
					<div class="form-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,255" message="#message#" maxlength="3" style="width:25px;">
					</div>
					<div class="form-group"><cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_list' , #attributes.modal_id#)"),DE(""))#"></div>		
					</cf_box_search>
			</cfform>
<cf_grid_list>
	<thead><tr>
		<th colspan="5" height="22" class="txtboldblue"><cfoutput>#get_product_name.product_name#</cfoutput></th>
	</tr>
	<tr class="color-header" height="22">
		<th class="form-title" width="90"><cf_get_lang dictionary_id='58138.İrsaliye No'></th>
		<th class="form-title"><cf_get_lang dictionary_id='58578.Belge Turu'></th>
		<th class="form-title" width="90"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
		<th class="form-title" width="70"><cf_get_lang dictionary_id='33658.Giriş Depo'></th>
		<th class="form-title" width="70"><cf_get_lang dictionary_id='29428.Çıkış Depo'></th>
	</tr>
</thead>
<tbody>
	<cfif get_ship.recordcount>
		<cfset dept_id_list = "">
		<cfoutput query="get_ship" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif len(department_in) and (department_in neq 0) or len(deliver_store_id)>
				<cfif not listfind(dept_id_list,department_in)>
					<cfset dept_id_list=listappend(dept_id_list,department_in)>
				</cfif>
				<cfif not listfind(dept_id_list,deliver_store_id)>
					<cfset dept_id_list=listappend(dept_id_list,deliver_store_id)>
				</cfif>
			</cfif>
		</cfoutput>
		<cfif listlen(dept_id_list)>
			<cfset dept_id_list=listsort(dept_id_list,"numeric","ASC",",")>
			<cfquery name="get_dep_detail" datasource="#DSN#">
				SELECT DEPARTMENT_ID, DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#dept_id_list#) ORDER BY DEPARTMENT_ID
			</cfquery>
			<cfset dept_id_list = listsort(listdeleteduplicates(valuelist(get_dep_detail.department_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfoutput query="get_ship" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
			<td>
				<cfif ship_type eq 811>
					<a href="#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=#ship_id#" target="_blank" class="tableyazi">#ship_number#</a></td>
				<cfelseif ship_type eq 81>
					<a href="#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=#ship_id#" target="_blank" class="tableyazi">#ship_number#</a></td>
				</cfif>
			<td>#get_process_name(ship_type)#</td>
			<td>#dateformat(ship_date,dateformat_style)#</td>
			<td>#get_dep_detail.department_head[listfind(dept_id_list,department_in,',')]#</td>
			<td>#get_dep_detail.department_head[listfind(dept_id_list,deliver_store_id,',')]#</td>
		</tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row" height="20">
			<td colspan="13"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
		</tr>
	</cfif>
</tbody>
</cf_grid_list>

<cfif attributes.totalrecords gt attributes.maxrows>
	<cf_paging 
	page="#attributes.page#" 
	maxrows="#attributes.maxrows#" 
	totalrecords="#get_ship.recordcount#" 
	startrow="#attributes.startrow#" 
	adres="objects.popup_dispatch_product_import#url_str#"
	isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
</cfif>
</cf_box>
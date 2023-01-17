<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.branch_id" default="">
<cfparam name="is_active" default="1">
<cfparam name="attributes.page" default=1>
<cfinclude template="../../../../V16/production_plan/query/get_branch.cfm">
<cfif isdefined("attributes.is_submit")>
	<cfinclude template="../../../../V16/production_plan/query/get_workstation_all.cfm">
<cfelse>
	<cfset get_workstation_all.recordcount = 0>    
</cfif>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_workstation_all.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif not isdefined('attributes.field_id')>
	<cfset send_value = "prod.list_ezgi_workstation">
<cfelse>
	<cfset send_value = "prod.popup_list_ezgi_workstation">
</cfif>
<cfset url_str = send_value>
<cfif isdefined("attributes.is_submit")><cfset url_str = "#url_str#&is_submit=#attributes.is_submit#"></cfif>
<cfif isdefined("attributes.field_id") and len(attributes.field_id)><cfset url_str = "#url_str#&field_id=#attributes.field_id#"></cfif>
<cfif isdefined("attributes.field_name") and len(attributes.field_name)><cfset url_str = "#url_str#&field_name=#attributes.field_name#"></cfif>
<cfif len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>
<cfif len(attributes.is_active)><cfset url_str = "#url_str#&is_active=#attributes.is_active#"></cfif>
<cfif len(attributes.branch_id)><cfset url_str = "#url_str#&branch_id=#attributes.branch_id#"></cfif>
<cfform action="#request.self#?fuseaction=#send_value#" method="post" name="form">
<input type="hidden" name="is_submit" id="is_submit" value="1">
    <cf_big_list_search title="#getLang('main',1676)#"> 
        <cf_big_list_search_area>
            <table>
                <tr>
                    <td><cf_get_lang_main no='48.Filtre'></td>
                    <td style="width:100px;"><cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50"></td>
                    <td nowrap>
						<select name="branch_id" style="width:150px;">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_branch">
								<option value="#branch_id#"<cfif attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
							</cfoutput>
						</select>
                        <select name="is_active" id="is_active">
                            <option value=""><cf_get_lang_main no='296.Tümü'></option>
                            <option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
                            <option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
                        </select>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
                    </td>
                    <td><cf_wrk_search_button></td>
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>
</cfform>
<cf_big_list> 
    <thead>
        <tr>
            <th width="30"><cf_get_lang_main no='1165.Sıra'></th>
            <th><cfoutput>#getLang('prod',356)#</cfoutput></th>
            <th><cf_get_lang_main no='41.Şube'></th>
            <th><cf_get_lang_main no='160.Departman'></th>
            <th width="125"><cfoutput>#getLang('prod',96)#</cfoutput></th>
            <th width="125"><cf_get_lang_main no='166.Yetkili'></th>
          	<th width="125"><cf_get_lang_main no='3331.Son Üretim Tarihi'></th>
          	<th class="form-title" width="125"><cf_get_lang_main no='2941.Üretim Miktarı'></th>
            <!-- sil --><th  width="15" class="header_icn_none"> <a href="<cfoutput>#request.self#?fuseaction=prod.add_ezgi_workstation</cfoutput>">
            <img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>"></a></th><!-- sil -->
        </tr>
    </thead>
    <tbody>
		<cfif get_workstation_all.recordcount>
			<cfset emp_position_list = ''>
			<cfoutput query="get_workstation_all" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(emp_id) and not listfind(emp_position_list,emp_id)>
					<cfset emp_position_list = ListAppend(emp_position_list,emp_id)>
				</cfif>
			</cfoutput>
			<cfif len(emp_position_list)>
				<cfset emp_position_list = listsort(emp_position_list,"numeric","ASC",",")>
				<cfquery name="GET_EMPLOYEES" datasource="#dsn#">
					SELECT  EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID IN (#emp_position_list#) AND IS_MASTER = 1 ORDER BY EMPLOYEE_ID
				</cfquery>
				<cfset emp_position_list = listsort(listdeleteduplicates(valuelist(GET_EMPLOYEES.EMPLOYEE_ID,',')),'numeric','ASC',',')>               
			</cfif>
			<cfoutput query="get_workstation_all" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#currentrow#</td>
					<td><cfif len(up_station)>&nbsp;&nbsp;</cfif>
						<cfif isdefined('attributes.field_id')>
							<a href="javascript://"  onClick="add_product('#station_id#','#station_name#','#capacity#','#employee_id#','#employee_name# #employee_surname#')" class="tableyazi">#station_name#</a>
						<cfelse>
							<a href="#request.self#?fuseaction=prod.upd_ezgi_workstation&station_id=#station_id#" class="tableyazi">#station_name#</a>
						</cfif>
					</td>
					<td>#branch_name#</td>
					<td>#DEPARTMENT_HEAD#</td>
					<td width="175"><cfif len(OUTSOURCE_PARTNER)>#get_par_info(OUTSOURCE_PARTNER,0,-1,1)#</cfif></td>
					<td><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_workstation_all.EMP_ID#','medium');" class="tableyazi">#GET_EMPLOYEES.EMPLOYEE_NAME[listfind(emp_position_list,get_workstation_all.EMP_ID,',')]#&nbsp;#GET_EMPLOYEES.EMPLOYEE_SURNAME[listfind(emp_position_list,get_workstation_all.EMP_ID,',')]#</a></td>
						<td><cfif len(max_order_date)>#dateformat(max_order_date,'dd/mm/yyyy')#</cfif></td>
						<cfquery name="get_prod_orders" datasource="#dsn3#">
							SELECT
								SUM(LAST_AMOUNT) LAST_AMOUNT,
								UNIT
							FROM
							(
								SELECT
									PO.QUANTITY-ISNULL((SELECT SUM(PORR.AMOUNT) FROM PRODUCTION_ORDER_RESULTS POR,PRODUCTION_ORDER_RESULTS_ROW PORR WHERE PORR.TYPE = 1 AND POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND POR.P_ORDER_ID = PO.P_ORDER_ID AND POR.IS_STOCK_FIS = 1),0) LAST_AMOUNT,
									PU.ADD_UNIT UNIT
								FROM
									STOCKS S,
									PRODUCTION_ORDERS PO,
									PRODUCT_UNIT PU
								WHERE
									S.STOCK_ID = PO.STOCK_ID
									AND PO.IS_STAGE <> -1
									AND PO.STATION_ID = #station_id#
									AND S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
									AND (PO.QUANTITY -ISNULL((SELECT SUM(PORR.AMOUNT) FROM PRODUCTION_ORDER_RESULTS POR,PRODUCTION_ORDER_RESULTS_ROW PORR WHERE PORR.TYPE = 1 AND POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND POR.P_ORDER_ID = PO.P_ORDER_ID AND POR.IS_STOCK_FIS = 1),0)) > 0
							)T1
							GROUP BY
								UNIT
						</cfquery>
						<td style="text-align:right">
							<cfloop query="get_prod_orders">
								 <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_list_ezgi_workstation_orders&station_id=#get_workstation_all.station_id#','list');">#tlformat(get_prod_orders.last_amount)#</a> #get_prod_orders.unit#<cfif currentrow neq recordcount><br/></cfif>
							</cfloop>
						</td>
					<!-- sil --><td align="center" width="15"><a href="#request.self#?fuseaction=prod.upd_ezgi_workstation&station_id=#station_id#" class="tableyazi"><img src="/images/update_list.gif" border="0" title="<cf_get_lang_main no='52.Güncelle'>"></a></td><!-- sil -->
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<cfset colspan = 9>
				<td colspan="<cfoutput>#colspan#</cfoutput>"><cfif isdefined("attributes.is_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif></td>
			</tr>
		</cfif>
    </tbody>
</cf_big_list> 
<cf_paging
    page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#get_workstation_all.recordcount#" 
    startrow="#attributes.startrow#" 
    adres="#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function add_product(id,name,capacity,emp_id,emp_name)
	{
		window.close();
		<cfif isdefined("attributes.field_name")>
			opener.<cfoutput>#field_name#</cfoutput>.value = name;
		</cfif>
		<cfif isdefined("attributes.field_capacity")>
			opener.<cfoutput>#field_capacity#</cfoutput>.value = capacity;
		</cfif>
		<cfif isdefined("attributes.field_id")>
			opener.<cfoutput>#field_id#</cfoutput>.value = id;
		</cfif>
		<cfif isdefined("attributes.field_employee_id")>
			opener.<cfoutput>#field_employee_id#</cfoutput>.value = emp_id;
		</cfif>
		<cfif isdefined("attributes.emp_name")>
			opener.<cfoutput>#emp_name#</cfoutput>.value = emp_name;
		</cfif>
	}
</script>
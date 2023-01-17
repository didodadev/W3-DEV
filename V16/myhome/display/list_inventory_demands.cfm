<cfscript>
	get_demands = createObject("component","V16.myhome.cfc.get_inventory_demands");
	get_demands.dsn = dsn;
	get_inventory_demand = get_demands.inventory_demands
					(
						employee_id : session.ep.userid
					);
</cfscript>	
<cfform name="list_inventory_demand" action="#request.self#?fuseaction=myhome.list_inventory_demands" method="post">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='31266.Envanter Talepleri'></cfsavecontent>
	<cf_medium_list_search title="#message#">
	</cf_medium_list_search>
</cfform>
<cf_medium_list is_sort="1">
	<thead>
		<tr>
			<th rowspan="2" height="22"><cf_get_lang dictionary_id='57487.No'></th>
			<th rowspan="2"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
            <th rowspan="2"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
            <th rowspan="2"><cf_get_lang dictionary_id='57572.Departman'></th>
			<th rowspan="2"><cf_get_lang dictionary_id='57453.Şube'></th>
			<th rowspan="2"><cf_get_lang dictionary_id='57574.Şirket'></th>
			<th rowspan="2"><cf_get_lang dictionary_id='31379.Gruba Giriş'></th>
			<th rowspan="2">1.<cf_get_lang dictionary_id='29511.Yönetici'></th>
			<th rowspan="2"><cf_get_lang dictionary_id='31759.Form Tipi'></th>
			<th rowspan="2"><cf_get_lang dictionary_id='31267.Kayıt/Güncelleme Tarihi'></th>
			<th rowspan="2"><cf_get_lang dictionary_id='57756.Durum'></th>
            <th class="header_icn_none" nowrap="nowrap">
            	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_form_add_inventory_demand&form_type=2&employee_id=<cfoutput>#session.ep.userid#</cfoutput>','medium');">
            		<img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='45465.Envanter Talebi Ekle'>">
              	</a>
          	</th>
		</tr>
	</thead>
	<tbody>
		<cfif get_inventory_demand.recordcount>
			<cfoutput query="get_inventory_demand">
            <tr>
                <td width="25">#currentrow#</td>
                <td>#EMPLOYEE_NAME#</td>
                <td>#POSITION_NAME#</td>
                <td>#department_head#</td>
                <td>#branch_name#</td>
                <td>#COMPANY_NAME#</td>
                <td>#dateformat(STARTDATE,dateformat_style)#</td>
                <td><cfif isdefined("get_inventory_demand.UPPER_POSITION_CODE") and len(get_inventory_demand.UPPER_POSITION_CODE)>
                    <cfquery name="get_manager" datasource="#DSN#">
                        SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME AS MANAGER_NAME_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #get_inventory_demand.UPPER_POSITION_CODE#
                    </cfquery>
                    #get_manager.MANAGER_NAME_SURNAME#
                </cfif>
                </td>
                <td>
					<cfif FORM_TYPE eq 1>
                        <cf_get_lang dictionary_id='31274.İşe Giriş'>
                    <cfelseif FORM_TYPE eq 2>
                        <cf_get_lang dictionary_id='57703.Güncelleme'>
                    <cfelseif FORM_TYPE eq 3>
                        <cf_get_lang dictionary_id='29832.İşten Çıkış'>
                    </cfif>
                </td>
                <td>
					<cfif isdefined("get_inventory_demand.UPDATE_DATE") and len(get_inventory_demand.UPDATE_DATE)>
                    	#dateformat(UPDATE_DATE,dateformat_style)#
                   	<cfelse>
                   		#dateformat(RECORD_DATE,dateformat_style)#
               		</cfif>
                </td>
                <td colspan="2">#stage#</td>
           	</tr>
            </cfoutput>
		<cfelse>
			<tr>
				<td colspan="12"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
<cfset attributes.is_manager_valid_control = 1>	
<cfscript>
	get_demands_ = createObject("component","V16.myhome.cfc.get_inventory_demands");
	get_demands_.dsn = dsn;
	get_other_inventory_records = get_demands_.inventory_demands
					(
						is_manager_valid_control: 1
					);
</cfscript>	
<cfif listgetat(attributes.fuseaction,1,'.') eq 'myhome'>
    <cfquery name="get_other_inventory_records2" dbtype="query">
    	SELECT * FROM get_other_inventory_records WHERE FORM_TYPE <> 3
    </cfquery>
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31469.Onay Bekleyen'> <cf_get_lang dictionary_id ='31266.Envanter Talepleri'></cfsavecontent>
<cf_medium_list_search title="#message#"></cf_medium_list_search>
<cf_medium_list is_sort="1">
	<thead>
		<tr>
			<th rowspan="2" height="22"><cf_get_lang dictionary_id='57487.No'></th>
			<th rowspan="2"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
            <th rowspan="2"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
            <th rowspan="2"><cf_get_lang dictionary_id='57572.Departman'></th>
			<th rowspan="2"><cf_get_lang dictionary_id='57453.Şube'></th>
			<th rowspan="2"><cf_get_lang dictionary_id='57574.Şirket'></th>
			<th rowspan="2"><cf_get_lang dictionary_id='31379.Gruba Giriş'></th>
			<th rowspan="2">1.<cf_get_lang dictionary_id='29511.Yönetici'></th>
			<th rowspan="2"><cf_get_lang dictionary_id='31759.Form Tipi'></th>
			<th rowspan="2"><cf_get_lang dictionary_id='31267.Kayıt/Güncelleme Tarihi'></th>
			<th rowspan="2" colspan="2"><cf_get_lang dictionary_id='57756.Durum'></th>
      	</tr>
	</thead>
	<tbody>
		<cfif get_other_inventory_records2.recordcount>
			<cfoutput query="get_other_inventory_records2">
				<tr>
					<td width="25">#currentrow#</td>
                    <td>#EMPLOYEE_NAME#</td>
                    <td>#POSITION_NAME#</td>
                    <td>#department_head#</td>
                    <td>#branch_name#</td>
                    <td>#COMPANY_NAME#</td>
                    <td>#dateformat(STARTDATE,dateformat_style)#</td>
                    <td>#MANAGER_NAME_SURNAME#</td>
                    <td>
						<cfif FORM_TYPE eq 1>
                            <cf_get_lang dictionary_id='31274.İşe Giriş'>
                        <cfelseif FORM_TYPE eq 2>
                            <cf_get_lang dictionary_id='57703.Güncelleme'>
                        <cfelseif FORM_TYPE eq 3>
                            <cf_get_lang dictionary_id='29832.İşten Çıkış'>
                        </cfif>
                    </td>
                    <td>
                        <cfif isdefined("get_other_inventory_demand.UPDATE_DATE") and len(get_other_inventory_demand.UPDATE_DATE)>
                            #dateformat(UPDATE_DATE,dateformat_style)#
                        <cfelse>
                            #dateformat(RECORD_DATE,dateformat_style)#
                        </cfif>
                    </td>
                    <td>#stage#</td>
                    <td style="text-align:center;">
                    	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_form_upd_inventory_demand&INVENTORY_DEMAND_ID=#contentEncryptingandDecodingAES(isEncode:1,content:INVENTORY_DEMAND_ID,accountKey:'wrk')#','medium');">
                        	<img src="/images/update_list.gif" title="Envanter Güncelle">
                        </a>
                	</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr height="20">
				<td colspan="11"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>

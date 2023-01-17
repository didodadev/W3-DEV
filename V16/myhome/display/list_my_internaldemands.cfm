<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.paper_no" default="">
<cfparam name="attributes.type" default="0">
<cfparam name="attributes.by" default="0">
<cfparam name="attributes.is_active" default="">
<cfscript>
	get_dep = createObject("component","V16.myhome.cfc.get_travel_demands");
	get_dep.dsn = dsn;
	get_department = get_dep.get_department(position_code : session.ep.position_code);
</cfscript>
<cfif not isdefined('attributes.form_submitted') or (isDefined("attributes.emp_department_id") and len(attributes.emp_department_id) and isDefined("attributes.emp_department") and len(attributes.emp_department))>
	<cfparam name="attributes.emp_department_id" default="#get_department.department_id#">
	<cfparam name="attributes.emp_department" default= "#get_department.department_head#">
<cfelse>
	<cfparam name="attributes.emp_department_id" default="">
	<cfparam name="attributes.emp_department" default= "">
</cfif>
<cfif listgetat(attributes.fuseaction,2,'.') eq 'list_purchasedemand'><cfset is_demand = 1><cfelse><cfset is_demand = 0></cfif>
<cfif isdefined('attributes.form_submitted')>
	<cfquery name="GET_MY_INTERNALDEMANDS" datasource="#DSN3#">
		SELECT 
		   *,
           PTR.STAGE
		FROM 
		    INTERNALDEMAND
         	LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON INTERNALDEMAND_STAGE=PTR.PROCESS_ROW_ID
		WHERE
        	(
				INTERNALDEMAND.RECORD_EMP = #session.ep.userid#
				OR
				INTERNALDEMAND.UPDATE_EMP = #session.ep.userid#
				OR
				(
				<cfif attributes.type eq 0>(TO_POSITION_CODE=#session.ep.position_code# OR FROM_POSITION_CODE = #session.ep.userid#)</cfif>
				<cfif attributes.type eq 1>TO_POSITION_CODE = #session.ep.position_code#</cfif>
				<cfif attributes.type eq 2>FROM_POSITION_CODE = #session.ep.userid#</cfif>
				)
			)
			<cfif len(attributes.keyword)>
			AND
			(
				SUBJECT LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#attributes.keyword#%"> OR
				NOTES LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#attributes.keyword#%">
			)
			</cfif>
			<cfif len(attributes.paper_no)>
			AND INTERNAL_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#attributes.paper_no#%">
			</cfif>
            AND <cfif is_demand eq 1>DEMAND_TYPE=1<cfelse>DEMAND_TYPE=0</cfif>
            <cfif len(attributes.is_active)>AND IS_ACTIVE = #attributes.is_active#</cfif>
			<cfif len(attributes.emp_department_id) and len(attributes.emp_department)>AND DEPARTMENT_ID = #attributes.emp_department_id#</cfif>
		ORDER BY
            <cfif attributes.by eq 0 >
           		INTERNALDEMAND.RECORD_DATE DESC
            <cfelse>
          		INTERNALDEMAND.RECORD_DATE ASC
            </cfif>
            ,TARGET_DATE DESC
	</cfquery>
<cfelse>
	<cfset get_my_internaldemands.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_my_internaldemands.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif is_demand eq 1>
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='31011.Satın Alma Taleplerim'></cfsavecontent>
<cfelse>
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='30768.İç Taleplerim'></cfsavecontent>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search more="0">
				<div class="form-group" id="item-keyword">
					<cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
				</div>	
				<div class="form-group" id="item-paper_no">
					<cfinput type="text" name="paper_no" id="paper_no" maxlength="50" placeholder="#getLang('','Talep No',30770)#" value="#attributes.paper_no#">
				</div>	
				<div class="form-group" id="item-form_ul_department">
					<div class="input-group">
						<input type="hidden" name="emp_department_id" id="emp_department_id" value="<cfoutput>#attributes.emp_department_id#</cfoutput>">
						<input type="text" name="emp_department" id="emp_department" value="<cfoutput>#attributes.emp_department#</cfoutput>" onfocus="AutoComplete_Create('emp_department','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','emp_department_id','search_','3','200');"  autocomplete="off">
						<span  class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=search_.emp_department_id&field_dep_branch_name=search_.emp_department&is_store_module=1&is_function=1');"></span>
					</div>
				</div>
				<div class="form-group" id="item-type">
					<select name="type" id="type">
						<option value="0"<cfif isdefined('attributes.type')and attributes.type eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id='58081.Hepsi'></option>
						<option value="1"<cfif isdefined('attributes.type')and attributes.type eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id='31181.Talep Edilen'></option>
						<option value="2"<cfif isdefined('attributes.type')and attributes.type eq 2>selected="selected"</cfif>><cf_get_lang dictionary_id='30829.Talep Eden'></option>		
					</select>
				</div>	
				<div class="form-group" id="item-by">
					<select name="by" id="by">
						<option value="0"<cfif isdefined('attributes.by')and attributes.by eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
						<option value="1"<cfif isdefined('attributes.by')and attributes.by eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>	
					</select>
				</div>	
				<div class="form-group" id="item-is_active">
					<select name="is_active" id="is_active">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1"<cfif isdefined('attributes.is_active')and attributes.is_active eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0"<cfif isdefined('attributes.is_active')and attributes.is_active eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>	
					</select>
				</div>	
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#head#" uidrop="1" hide_table_column="1">
		<cf_grid_list> 	
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='30770.Talep No'></th>
					<th><cf_get_lang dictionary_id='31180.Talep Konusu'></th>
					<th><cf_get_lang dictionary_id='58859.Süreç'></th>
					<th><cf_get_lang dictionary_id='31181.Talep Edilen'></th>
					<th><cf_get_lang dictionary_id='30829.Talep Eden'></th>
					<th><cf_get_lang dictionary_id='57572.Departman'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
					<th><cf_get_lang dictionary_id='57483.Kayıt'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th><cf_get_lang dictionary_id ='57482.Aşama'></th>
					<!-- sil -->
					<th width="20"></th>
					<th width="20" class="header_icn_none text-center">
						<cfif is_demand eq 1>
							<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_purchasedemand&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
						<cfelse>
							<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_internaldemand&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
						</cfif>
					</th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_my_internaldemands.recordcount>
					<cfset position_code_list=''>
					<cfset employee_id_list=''>
					<cfset internaldemand_id_list=''>
					<cfoutput query="get_my_internaldemands" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(to_position_code) and not listfind(position_code_list,to_position_code)>
							<cfset position_code_list=listappend(position_code_list,to_position_code)>
						</cfif>
						<cfif len(from_position_code) and not listfind(employee_id_list,from_position_code)>
							<cfset employee_id_list=listappend(employee_id_list,from_position_code)>
						</cfif>
						<cfif len(record_emp) and not listfind(employee_id_list,record_emp)>
							<cfset employee_id_list=listappend(employee_id_list,record_emp)>
						</cfif>
						<cfif not listfind(internaldemand_id_list,INTERNAL_ID)>
							<cfset internaldemand_id_list=listappend(internaldemand_id_list,INTERNAL_ID)>
						</cfif>
					</cfoutput>
					<cfif len(position_code_list)>
						<cfset position_code_list=listsort(position_code_list,"numeric","ASC",",")>
						<cfquery name="GET_POSITIONS_DETAIL" datasource="#DSN#">
							SELECT
								EMPLOYEE_NAME,
								EMPLOYEE_SURNAME,
								EMPLOYEE_ID,
								POSITION_CODE
							FROM
								EMPLOYEE_POSITIONS
							WHERE
								POSITION_CODE IN (#position_code_list#)
							ORDER BY
								POSITION_CODE
						</cfquery>
						<cfset position_code_list = listsort(listdeleteduplicates(valuelist(get_positions_detail.position_code,',')),'numeric','ASC',',')>
					</cfif>
					<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
					<cfquery name="GET_EMP_DETAIL" datasource="#dsn#">
						SELECT
							EMPLOYEE_NAME,
							EMPLOYEE_SURNAME,
							EMPLOYEE_ID 
						FROM
							EMPLOYEES
						WHERE 
							EMPLOYEE_ID IN (#employee_id_list#)
						ORDER BY
							EMPLOYEE_ID
					</cfquery>
					<cfset employee_id_list = listsort(listdeleteduplicates(valuelist(get_emp_detail.employee_id,',')),'numeric','ASC',',')>
					<!--- Union kullanma sebebi tekliften siparişe dönüşen iç talepleride aşamasının da siparişe dönüştür olarak görülebilmesi için.--->
					<cfif len(internaldemand_id_list)>
						<cfquery name="getInternalRel" datasource="#dsn3#">
							SELECT 
								INTERNALDEMAND_ID,
								TO_OFFER_ID,
								TO_ORDER_ID,
								TO_SHIP_ID,
								TO_STOCK_FIS_ID,
								NULL TO_INTERNALDEMAND_ID 
							FROM 
								INTERNALDEMAND_RELATION 
							WHERE 
								INTERNALDEMAND_ID IN (#internaldemand_id_list#) 
						UNION ALL
							SELECT 
								INTERNALDEMAND_ID,
								null TO_OFFER_ID,
								TO_OFFER_ID TO_ORDER_ID,
								null TO_SHIP_ID,
								null TO_STOCK_FIS_ID,
								TO_INTERNALDEMAND_ID 
							FROM 
								INTERNALDEMAND_RELATION_ROW  
							WHERE 
								<!---TO_OFFER_ID IN(SELECT DISTINCT FROM_ACTION_ID FROM RELATION_ROW WHERE FROM_TABLE='OFFER' AND TO_TABLE='ORDERS')
								AND ---> INTERNALDEMAND_ID IN (#internaldemand_id_list#) 
							ORDER BY 
								INTERNALDEMAND_ID
						</cfquery>
						<cfset to_offer_id_list = ''>
						<cfset to_order_id_list = ''>
						<cfset to_ship_id_list = ''>
						<cfset to_stock_fis_id_list = ''>
						<cfset to_internaldemand_id_list = ''>
						<cfoutput query="getInternalRel">
							<cfif len(TO_OFFER_ID)>
								<cfset to_offer_id_list = '#to_offer_id_list#;#INTERNALDEMAND_ID#'>
							</cfif>
							<cfif len(TO_ORDER_ID)>
								<cfset to_order_id_list = '#to_order_id_list#;#INTERNALDEMAND_ID#'>
							</cfif>
							<cfif len(TO_SHIP_ID)>
								<cfset to_ship_id_list = '#to_offer_id_list#;#INTERNALDEMAND_ID#'>
							</cfif>
							<cfif len(TO_STOCK_FIS_ID)>
								<cfset to_stock_fis_id_list = '#to_stock_fis_id_list#;#INTERNALDEMAND_ID#'>
							</cfif>
							<cfif len(TO_INTERNALDEMAND_ID)>
								<cfset to_internaldemand_id_list = '#to_internaldemand_id_list#;#INTERNALDEMAND_ID#'>
							</cfif>
						</cfoutput>
					</cfif>
					<cfoutput query="get_my_internaldemands" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<cfif fusebox.circuit eq 'myhome'>
								<cfset internal_id_ = contentEncryptingandDecodingAES(isEncode:1,content:internal_id,accountKey:'wrk')>
							<cfelse>
								<cfset internal_id_ = internal_id>
							</cfif>
							<cfif len(department_id)>
								<cfscript>
									get_demand_list_action = CreateObject("component","V16.correspondence.cfc.get_demand");
									get_demand_list_action.dsn = dsn3;
									get_dep_= get_demand_list_action.get_department(department_id : department_id);
								</cfscript>
							</cfif>
							<td>#currentrow#</td>
							<td><cfif is_demand eq 1><a href="#request.self#?fuseaction=myhome.list_purchasedemand&event=upd&id=#internal_id_#" class="tableyazi">#internal_number#</a><cfelse><a href="#request.self#?fuseaction=myhome.list_internaldemand&event=upd&id=#internal_id_#" class="tableyazi">#internal_number#</a></cfif></td>
							<td><cfif is_demand eq 1><a href="#request.self#?fuseaction=myhome.list_purchasedemand&event=upd&id=#internal_id_#" class="tableyazi">#subject#</a><cfelse><a href="#request.self#?fuseaction=myhome.list_internaldemand&event=upd&&id=#internal_id_#" class="tableyazi">#subject#</a></cfif></td>
							<td>#STAGE#</td>
							<td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_positions_detail.employee_id[listfind(position_code_list,get_my_internaldemands.to_position_code,',')]#','medium');">#get_positions_detail.employee_name[listfind(position_code_list,get_my_internaldemands.to_position_code,',')]# #get_positions_detail.employee_surname[listfind(position_code_list,get_my_internaldemands.to_position_code,',')]#</a></td>
							<td><cfif len(from_position_code)><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#GET_EMP_DETAIL.employee_id[listfind(employee_id_list,get_my_internaldemands.from_position_code,',')]#','medium');">#GET_EMP_DETAIL.employee_name[listfind(employee_id_list,get_my_internaldemands.from_position_code,',')]# #GET_EMP_DETAIL.employee_surname[listfind(employee_id_list,get_my_internaldemands.from_position_code,',')]#</a></cfif></td>
							<td><cfif len(department_id)>#get_dep_.department_head#</cfif></td>
							<td><cfif is_active eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
							<td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');">#get_emp_detail.employee_name[listfind(employee_id_list,get_my_internaldemands.record_emp,',')]# #get_emp_detail.employee_surname[listfind(employee_id_list,get_my_internaldemands.record_emp,',')]#</a></td>
							<td nowrap="nowrap">#dateformat(record_date,dateformat_style)#</td>
							<td>
								<cfif len(to_offer_id_list) and listfind(to_offer_id_list,get_my_internaldemands.INTERNAL_ID,';') gt 0>
									<cf_get_lang dictionary_id='59033.Satınalma Teklifine Dönüştürüldü'><br />
								</cfif>
								<cfif len(to_order_id_list) and listfind(to_order_id_list,get_my_internaldemands.INTERNAL_ID,';') gt 0>
								<cf_get_lang dictionary_id='31238.Satınalma Siparişine Dönüştürüldü'><br />
								</cfif>
								<cfif len(to_ship_id_list) and listfind(to_ship_id_list,get_my_internaldemands.INTERNAL_ID,';') gt 0>
									<cf_get_lang dictionary_id='31239.Sevk İrsaliyesine Dönüştürüldü'><br />
								</cfif>
								<cfif len(to_stock_fis_id_list) and listfind(to_stock_fis_id_list,get_my_internaldemands.INTERNAL_ID,';') gt 0>
									<cf_get_lang dictionary_id='31242.Sarf Fişi Oluşturuldu'><br />
								</cfif>
								<cfif len(to_internaldemand_id_list) and listfind(to_internaldemand_id_list,get_my_internaldemands.INTERNAL_ID,';') gt 0>
								<cf_get_lang dictionary_id='31192.Satın Alma Talebine Dönüştürüldü'>
								</cfif>
							</td>
							<!-- sil -->
							<td>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_internaldemand_relation&internaldemand_id=#internal_id#','list');"><i class="fa fa-edit" alt="<cf_get_lang dictionary_id ='29676.İç Talep Karşılaştırma Raporu'>" title="<cf_get_lang dictionary_id ='29676.İç Talep Karşılaştırma Raporu'>"></i></a>
							</td>
							<td class="text-center">
								<cfif is_demand eq 1>
									<a href="#request.self#?fuseaction=myhome.list_purchasedemand&event=upd&id=#internal_id_#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='58494.Kayıt Güncelle'>" alt="<cf_get_lang dictionary_id ='58494.Kayıt Güncelle'>"></i></a>
								<cfelse>
									<a href="#request.self#?fuseaction=myhome.list_internaldemand&event=upd&id=#internal_id_#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='58494.Kayıt Güncelle'>" alt="<cf_get_lang dictionary_id ='58494.Kayıt Güncelle'>"></i></a>
								</cfif>
							</td>
							<!-- sil -->
						</tr>
					</cfoutput>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif get_my_internaldemands.recordcount eq 0> 
			<div class="ui-info-bottom">
				<p><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></p>
			</div>
		</cfif>

		<cfset url_str = "">
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif len(attributes.paper_no)>
			<cfset url_str="#url_str#&paper_no=#attributes.paper_no#">	
		</cfif>
		<cfif len(attributes.by)>
			<cfset url_str="#url_str#&by=#attributes.by#">	
		</cfif>
		<cfif isdefined("attributes.emp_department_id") and len(attributes.emp_department_id)>
            <cfset url_str="#url_str#&emp_department_id=#attributes.emp_department_id#">
        </cfif>
        <cfif isdefined("attributes.emp_department") and len(attributes.emp_department)>
            <cfset url_str="#url_str#&emp_department=#attributes.emp_department#">
        </cfif>
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#attributes.fuseaction#&#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
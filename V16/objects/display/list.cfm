<cf_grid_list>
	<thead>
		<tr> 
			<th></th>
            <th><cf_get_lang dictionary_id='57880.Belge No'></th>
			<th><cf_get_lang dictionary_id='29452.Varlık'></th>
			<th><cf_get_lang dictionary_id='57486.Kategori'></th>
			<th><cf_get_lang dictionary_id='58067.Döküman Tipi'></th>
			<th><cf_get_lang dictionary_id='58594.Format'></th>
			<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
			<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_assets.recordcount>
		<cfset get_emp_list = ''>
		<cfset get_cons_list = ''>
		<cfset get_par_list = ''>
		<cfset property_list =''>
		<cfoutput query="get_assets" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif len(record_emp) and not listfind(get_emp_list,record_emp)>
				<cfset get_emp_list=listappend(get_emp_list,record_emp)>
			</cfif>
			<cfif len(record_pub) and not listfind(get_cons_list,record_pub)>
				<cfset get_cons_list=listappend(get_cons_list,record_pub)>
			</cfif>
			<cfif len(record_par) and not listfind(get_cons_list,record_par)>
				<cfset get_par_list=listappend(get_par_list,record_par)>
			</cfif>
			<cfif len(property_id) and not listfind(property_list,property_id)>
				<cfset property_list=listappend(property_list,property_id)>
			</cfif>
		</cfoutput>
		<cfif len(get_emp_list)>
			<cfquery name="GET_EMP" datasource="#DSN#">
				SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#get_emp_list#) ORDER BY EMPLOYEE_ID
			</cfquery>
			<cfset get_emp_list = listsort(listdeleteduplicates(valuelist(get_emp.employee_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif len(get_cons_list)>
			<cfquery name="GET_CONS" datasource="#DSN#">
				SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#get_cons_list#) ORDER BY CONSUMER_ID
			</cfquery>
			<cfset get_cons_list = listsort(listdeleteduplicates(valuelist(get_cons.consumer_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif len(get_par_list)>
			<cfquery name="GET_PAR" datasource="#DSN#">
				SELECT PARTNER_ID, COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#get_par_list#) ORDER BY PARTNER_ID
			</cfquery>
			<cfset get_par_list = listsort(listdeleteduplicates(valuelist(get_par.partner_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif len(property_list)>
			<cfquery name="GET_CONTENT_PROPERTY" datasource="#DSN#">
				SELECT CONTENT_PROPERTY_ID,NAME FROM CONTENT_PROPERTY WHERE CONTENT_PROPERTY_ID IN (#property_list#)
			</cfquery> 
			<cfset property_list = listsort(listdeleteduplicates(valuelist(get_content_property.content_property_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfoutput query="get_assets" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif assetcat_id gte 0>
				<cfset url_ = "#file_web_path#assets/#assetcat_path#/">
				<cfset path = "#upload_folder#assets#dir_seperator##assetcat_path##dir_seperator#">
			<cfelse>
				<cfset url_ = "#file_web_path#/#assetcat_path#/">
				<cfset path = "#upload_folder##assetcat_path##dir_seperator#">
			</cfif>			  
			<cfset file_path = '#path##asset_file_name#'>
			<cfset rm = '#chr(13)#'>
			<cfset desc = ReplaceList(description,rm,'')>
			<cfset rm = '#chr(10)#'>
			<cfset desc = ReplaceList(desc,rm,'')>
			<cfif not len(desc)><cfset desc = 'image'></cfif>
			<tr>		   
				<td style="width:15px;">
					<cfif assetcat_id gte 0>
						<cfset file_add_ = "objects/">
					<cfelse>
						<cfset file_add_ = "">
					</cfif>
					<cf_get_server_file output_file="#file_add_##assetcat_path#/#asset_file_name#" output_server="#asset_file_server_id#" output_type="2" small_image="/images/download.gif" image_link="1">
				</td>
                <td>#asset_no#</td>
				<td>
					<cfset asset_name2="">
					<cfset asset_name2 = replace(asset_name,"'"," ","ALL")>
					<cfset asset_file_real_name_ = asset_file_real_name>
                    <cfif asset_file_real_name contains "'">
                    	<cfset asset_file_real_name_ = replace(asset_file_real_name,"'","","all")>
                    </cfif>
					<a href="##" onclick="sendAsset('#asset_file_name#','#ReplaceList(file_path,'\','\\')#','#desc#','#asset_name2#','#asset_file_size#','#property_id#','#asset_id#','#asset_file_real_name_#','#assetcat_id#',<cfif isdefined('attributes.action_')>'#attributes.action_#'<cfelse>''</cfif>,'#attributes.action_id#','#asset_no#','#EMBEDCODE_URL#')" class="tableyazi">#asset_name#</a>
				</td>
				<td>#assetcat#</td>
				<td><cfif len(property_list)>#get_content_property.name[listfind(property_list,property_id,',')]#</cfif></td>
					<cfif FindNoCase(".",asset_file_name)>
						<cfset last_3 = Mid(asset_file_name, FindNoCase(".",asset_file_name), Len(asset_file_name)-FindNoCase(".",asset_file_name)+1 )>
					<cfelse>
						<cfset last_3 = "">
					</cfif>
				<td>#last_3# (#asset_file_size# kb.)</td>
				<td><cfif len(record_emp)>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_emp.employee_id[listfind(get_emp_list,record_emp,',')]#','medium')" class="tableyazi">#get_emp.employee_name[listfind(get_emp_list,record_emp,',')]# #get_emp.employee_surname[listfind(get_emp_list,record_emp,',')]#</a>
					<cfelseif len(record_pub)>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_cons.consumer_id[listfind(get_cons_list,record_pub,',')]#','medium')" class="tableyazi">#get_cons.consumer_name[listfind(get_cons_list,record_pub,',')]# #get_cons.consumer_surname[listfind(get_cons_list,record_pub,',')]#</a>
					<cfelseif len(record_par)>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_par.partner_id[listfind(get_par_list,record_par,',')]#','medium')" class="tableyazi">#get_par.company_partner_name[listfind(get_par_list,record_par,',')]# #get_par.company_partner_surname[listfind(get_par_list,record_par,',')]#</a>
					</cfif>
				</td>
				<td>&nbsp;#dateformat(record_date,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</td>
			</tr>
		</cfoutput> 
	<cfelse>
		<tr> 
			<td colspan="8"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
		</tr>
	</cfif>
	</tbody>
</cf_grid_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfif isdefined("attributes.ASSET_ARCHIVE")>
		<cfset url_str = "#url_str#&ASSET_ARCHIVE=#attributes.ASSET_ARCHIVE#"> 
	</cfif>
	<cf_paging page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="objects.#listgetat(fuseaction,2,'.')##url_str#"
		isAjax="#iif(isdefined("attributes.draggable"),1,0)#">	
</cfif>

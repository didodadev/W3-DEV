<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_page_type" datasource="#dsn3#">
		SELECT 
			*
		FROM 
			CATALOG_PAGE_TYPES
		<cfif len(attributes.keyword)>
			WHERE 
				PAGE_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
		</cfif>
	</cfquery>
<cfelse>
	<cfset get_page_type.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_page_type.recordcount#">
<cfform name="page_search" action="#request.self#?fuseaction=product.list_catalog_pages" method="post">
<input name="form_submitted" id="form_submitted" type="hidden" value="1">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37760.Katalog Sayfa Tanımları'></cfsavecontent>
<cf_big_list_search title="#message#"> 
	<cf_big_list_search_area>
		<table>
			<tr>
				<td><cf_get_lang dictionary_id ='57460.Filtre'></td>
				<td><cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50"></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</td>
				<td><cf_wrk_search_button></td>	
			</tr>
		</table>
	</cf_big_list_search_area>
</cf_big_list_search>
</cfform>
<cf_big_list>
	<thead>
		<tr> 
			<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th><cf_get_lang dictionary_id='58069.Sayfa Tipi'></th>
			<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
			<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
            <!-- sil -->
			<th class="header_icn_none"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=product.popup_add_catalog_page_type</cfoutput>','small');"><img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a></th>
			<!-- sil -->
        </tr>
	</thead>
	<tbody>
		<cfif get_page_type.recordcount>
		<cfset emp_id_list= ''>
			<cfoutput query="get_page_type" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
				<cfif len(record_emp) and not listfind(emp_id_list,record_emp)>
					<cfset emp_id_list=listappend(emp_id_list,record_emp)>
				</cfif>
			</cfoutput> 
			<cfif len(emp_id_list)>
				<cfset emp_id_list=listsort(emp_id_list,"numeric","ASC",",")>
				<cfquery name="get_emp_detail" datasource="#dsn#">
					SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#emp_id_list#) ORDER BY EMPLOYEE_ID
				</cfquery>
			</cfif>
			<cfoutput query="get_page_type" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
			<tr>
				<td>#currentrow#</td>
				<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=product.popup_upd_catalog_page_type&type_id=#page_type_id#','small');" class="tableyazi">#page_type#</a></td>
				<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi"> #get_emp_detail.employee_name[listfind(emp_id_list,record_emp,',')]#&nbsp; #get_emp_detail.employee_surname[listfind(emp_id_list,record_emp,',')]# </a></td>
				<td>#dateformat(record_date,dateformat_style)#</td>
				<!-- sil -->	
                <td width="15" align="center"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=product.popup_upd_catalog_page_type&type_id=#page_type_id#','small');"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='57464.Güncele'>"></a></td>
				<!-- sil -->
            </tr>
			</cfoutput> 
		<cfelse>
			<tr> 
				<td colspan="5"><cfif not isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cf_paging page="#attributes.page#"
  maxrows="#attributes.maxrows#"
  totalrecords="#attributes.totalrecords#"
  startrow="#attributes.startrow#"
  adres="product.list_catalog_pages&form_submitted=1&keyword=#attributes.keyword#"> 
<script type="text/javascript">
	$('#keyword').focus();
	//document.getElementById('keyword').focus();
</script>

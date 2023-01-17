<cfsetting showdebugoutput="no">
<cfinclude template="get_list_correspondence.cfm">
<cf_flat_list>
	<tbody>
		<cfif get_list_correspondence.recordcount>
			<cfparam name="attributes.page" default=1>
			<cfparam name="attributes.maxrows" default=20>
			<cfparam name="attributes.totalrecords" default="#get_list_correspondence.recordcount#">
			<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
			<cfset writer_list = "">
			<cfoutput query="get_list_correspondence" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(record_emp) and not listfind(writer_list,record_emp)>
					<cfset writer_list=listappend(writer_list,record_emp)>
				</cfif>
			</cfoutput>
			<cfif len(writer_list)>
				<cfquery name="get_writer" datasource="#dsn#">
					SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#writer_list#) ORDER BY EMPLOYEE_ID
				</cfquery>
				<cfset writer_list = listsort(listdeleteduplicates(valuelist(get_writer.employee_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfoutput query="get_list_correspondence" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td width="47%"><a href="##" onclick="windowopen('#request.self#?fuseaction=correspondence.popup_detail_correspondence&id=#get_list_correspondence.id#','list')"  class="tableyazi">#get_list_correspondence.subject#</a></td>
					<td width="25%">#dateformat(get_list_correspondence.cor_startdate,dateformat_style)#</td>
					<td width="25%" style="text-align:right;">#get_writer.employee_name[listfind(writer_list,record_emp,',')]#&nbsp;#get_writer.employee_surname[listfind(writer_list,record_emp,',')]#</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_flat_list>

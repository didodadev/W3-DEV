<cfparam name="attributes.keyword" default="">
<cftry>
	<cfldap action="QUERY"
		name="get_users"
		server="#active_directory_server#"
		attributes = "cn,o,l,st,sn,c,mail,telephonenumber,givenname,homephone,streetaddress,postalcode,SamAccountname,physicalDeliveryOfficeName,department,name,surname"
		username="#active_directory_server_add##active_directory_control_user#"
		password="#active_directory_control_password#"
		filter="(&(objectClass=User)(objectCategory=Person)(name=*#attributes.keyword#*))"
		start = "#active_directory_start#"
		port="389"
		startrow="1"
		maxrows="100"
		sort = "cn ASC">
	<cfcatch type="any">
		<cfset get_users.recordcount = 0>
	</cfcatch>
</cftry>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="#get_users.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
function add_send_info(user_name)
{
	if(window.opener.document.getElementById('username') != undefined)
		window.opener.document.getElementById('username').value = user_name;
	else
		window.opener.document.getElementById('employee_username').value = user_name;
	window.close();
}
</script>
<cfscript>
	url_string = '';
	if (isdefined('attributes.keyword')) url_string = '#url_string#&keyword=#attributes.keyword#';
</cfscript>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="58992.Kullanıcılar"></cfsavecontent>
<cf_medium_list_search title="#message#">
	<cf_medium_list_search_area>
		<cfform name="search" action="#request.self#?fuseaction=hr.popup_list_active_directory_names" method="post">
			<table>
				<tr>
					<td><cf_get_lang dictionary_id='57460.Filtre'></td>
					<td><cfinput type="text" name="keyword" value="#attributes.keyword#" style="width:120px;" maxlength="50"></td>
					<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td><cf_wrk_search_button></td>
				</tr>
			</table>
		</cfform>
	</cf_medium_list_search_area>
</cf_medium_list_search>
<cf_medium_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='57930.Kullanici'></th>
			<th><cf_get_lang dictionary_id='57551.Kullanici Adı'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_users.recordcount>
			<cfoutput query="get_users" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td><a href="javascript://" onClick="add_send_info('#SamAccountname#');" class="tableyazi">#name# #surname#</a></td>
					<td>#SamAccountname#</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
<cfif attributes.totalrecords gt attributes.maxrows>
<table width="99%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
	<tr>
		<td><cf_pages page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="hr.popup_list_active_directory_names#url_string#">
		</td>
		<!-- sil -->
		<td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		<!-- sil -->
	</tr>
</table>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

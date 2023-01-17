<cfparam name="attributes.keyword" default="">
<cfquery name="GET_USER_GROUP" datasource="#dsn#">
	SELECT USER_GROUP_NAME FROM USER_GROUP WHERE USER_GROUP_ID = #attributes.ID#
</cfquery>
<cfscript>
	get_emp_info = createObject("component","V16.settings.cfc.get_user_group_emp");
	get_emp_info.dsn = dsn;
	get_emp = get_emp_info.get_emp(
		id : attributes.id,
		position_status : 1,
		keyword : attributes.keyword
	);
</cfscript>
<cfset url_string = "&id=#attributes.id#">
<cfif len(attributes.keyword)>
	<cfset url_string = url_string&"&keyword="&attributes.keyword>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_emp.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr> 
		<td class="headbold" height="35"> 
			<cfoutput>#GET_USER_GROUP.USER_GROUP_NAME#</cfoutput> <cf_get_lang no='811.Yetki Grubu Kullanicilari'>
		</td>
		<td align="right" style="text-align:right;">
		<!---Arama --->
			<table>
				<cfform name="form" action="#request.self#?fuseaction=settings.popup_list_usergroup_employee" method="post">		
					<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
				<tr>
					<td><cf_get_lang_main no='48.Filtre'>:</td>
					<td><cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255"></td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </td>
					<td><cf_wrk_search_button></td>
				</tr>
				</cfform>
			</table>
		<!---Arama --->
		</td>
	</tr>
</table>
<table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border" align="center">
	<tr class="color-header">
        <td class="form-title" height="22"><cf_get_lang_main no='1085.Pozisyon'></td>
        <td class="form-title" height="22"><cf_get_lang_main no='1580.Kullanıcı'></td>
        <td class="form-title" height="22"><cf_get_lang_main no ='41.Şube'></td>
        <td class="form-title" height="22"><cf_get_lang_main no ='160.Departman'></td>
        <td class="form-title" height="22"><cf_get_lang_main no ='162.Şirket'></td>
	</tr>
	<cfif get_emp.recordcount>
		<cfoutput query="get_emp" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
        <tr class="color-row"> 
            <td height="20">#position_name#</td>
            <td height="20"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','list')" class="tableyazi"> #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
            <td height="20"><cfif len(branch_id)>#BRANCH_NAME#</cfif></td>
            <td height="20">#department_head#</td>
            <td height="20"><cfif len(branch_id)>#NICK_NAME#</cfif></td>
        </tr>   
		</cfoutput>
	<cfelse>
        <tr class="color-row"> 
            <td height="20" colspan="5"><cf_get_lang_main no='72.Kayit Bulunamadi'>!</td>
        </tr> 
	</cfif>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
<table cellpadding="0" cellspacing="0" border="0" width="97%" height="35" align="center">
	<tr> 
		<td><cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="settings.popup_list_usergroup_employee#url_string#"></td>
		<!-- sil --><td align="right" style="text-align:right;"> <cfoutput> <cf_get_lang_main no='128.Toplam Kayit'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
	</tr>
</table>
</cfif>
<br/>

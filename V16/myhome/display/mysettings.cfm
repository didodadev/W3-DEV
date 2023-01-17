<cfif not isdefined("attributes.page_type")><cfset attributes.page_type = 2></cfif>
<cfinclude template="../query/my_sett.cfm">
<cfoutput>
<table width="98%" align="center" height="100%">
	<tr>
		<td height="35" class="headbold">
			<cfif isdefined("attributes.employee_id")>
				#get_emp_info(attributes.employee_id,0,0)# 
			<cfelse>
				#session.ep.name# #session.ep.surname# 
			</cfif>
		</td>
	</tr>
	<tr>
		<td valign="top">
            <ul id="menu1" class="searchMenu">
                <li style="float:left; cursor:pointer;" id="link1" <cfif attributes.page_type eq 1>class="selected"</cfif>><a onClick="pageload(1,link1);"><cf_get_lang dictionary_id='57413.Gündem'></a></li>
                <li style="float:left; cursor:pointer;" id="link2" <cfif attributes.page_type eq 2>class="selected"</cfif>><a onClick="pageload(2,link2);"><cf_get_lang dictionary_id='31075.Tasarım Dil'></a></li>
                <li style="float:left; cursor:pointer;" id="link3" <cfif attributes.page_type eq 3>class="selected"</cfif>><a onClick="pageload(3,link3);"><cf_get_lang dictionary_id='30773.Çalışma Dönemi'></a></li>
                <li style="float:left; cursor:pointer;" id="link4" <cfif attributes.page_type eq 4>class="selected"</cfif>><a onClick="pageload(4,link4);"><cf_get_lang dictionary_id='57415.Ajanda'></a></li>
                <li style="float:left; cursor:pointer;" id="link5" <cfif attributes.page_type eq 5>class="selected"</cfif>><a onClick="pageload(5,link5);"><cf_get_lang dictionary_id='57880.Belge No'></a></li>
                <li style="float:left; cursor:pointer;" id="link6" <cfif attributes.page_type eq 6>class="selected"</cfif>><a onClick="pageload(6,link6);"><cf_get_lang dictionary_id='30811.İletişim Grupları'></a></li>
                <li style="float:left; cursor:pointer;" id="link7" <cfif attributes.page_type eq 7>class="selected"</cfif>><a onClick="pageload(7,link7);"><cf_get_lang dictionary_id='57424.öncelikli menu'></a></li>
                <li style="float:left; cursor:pointer;" id="link8" <cfif attributes.page_type eq 8>class="selected"</cfif>><a onClick="pageload(8,link8);"><cf_get_lang dictionary_id='30764.Raporlarım'></a></li>
                <cfif isdefined("use_active_directory") and use_active_directory neq 3>
                    <li style="float:left; cursor:pointer;" id="link9" <cfif attributes.page_type eq 9>class="selected"</cfif>><a onClick="pageload(9,link9);"><cf_get_lang dictionary_id='57552.Şifre'></a></li>
                </cfif>
            </ul>
			<span style="background-color:FFFFFF; width:100%; height:20px;"></span>
			<div id="SHOW_PRODUCT" class="icerik_tabbed" style="width:98%;height:97%;;z-index:9999; float:left;"></div>
		</td>
	</tr>
</table>
</cfoutput>
<cfif isdefined("attributes.employee_id")>
	<cfset employee_id_ = attributes.employee_id>
<cfelse>
	<cfset employee_id_ = session.ep.userid>
</cfif>
<script type="text/javascript">
	function pageload(page,_link_)
	{
	 <cfoutput>
		if(page==1)
			var url_str = "#request.self#?fuseaction=myhome.list_personal_agenda&my_emp_id=#employee_id_#"
		else if(page==2)
			var url_str = "#request.self#?fuseaction=myhome.list_mydesign&my_emp_id=#employee_id_#"
		else if(page==3)
			var url_str = "#request.self#?fuseaction=myhome.emptypopupajax_list_myaccounts&my_emp_id=#employee_id_#"
		else if(page==4)
			var url_str = "#request.self#?fuseaction=myhome.list_myagenda&my_emp_id=#employee_id_#"
		else if(page==5)
			var url_str = "#request.self#?fuseaction=myhome.list_myreport_number&my_emp_id=#employee_id_#"
		else if(page==6)
			var url_str = "#request.self#?fuseaction=myhome.list_mywork_group&my_emp_id=#employee_id_#"
		else if(page==7)
			var url_str = "#request.self#?fuseaction=myhome.list_myfavourites&my_emp_id=#employee_id_#"
		else if(page==8)
			var url_str = "#request.self#?fuseaction=myhome.list_myreports&my_emp_id=#employee_id_#"
		else if(page==9)
			var url_str = "#request.self#?fuseaction=myhome.list_myaccount_password&my_emp_id=#employee_id_#"
		AjaxPageLoad(url_str,'SHOW_PRODUCT',1,'<cf_get_lang dictionary_id="58891.Yükleniyor">',_link_);
	  </cfoutput>
	}
	function private_agenda_display()
	{
		if(document.getElementById('day_agenda').checked == false)
		{
			document.getElementById('private_agenda').checked == false;
			gizle(private_agenda_id);
		}
		else if(document.getElementById('day_agenda').checked == true)
			goster(private_agenda_id);
	}
	<cfoutput>
		pageload("#attributes.page_type#",link2);
	</cfoutput>
</script>

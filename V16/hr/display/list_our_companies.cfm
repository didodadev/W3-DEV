<cfparam name="attributes.keyword" default="">
<cfset url_string = "">
<cfif isdefined("url.field_id")>
	<cfset url_string = "#url_string#&field_id=#url.field_id#">
</cfif>
<cfif isdefined("url.field_name")>
	<cfset url_string = "#url_string#&field_name=#url.field_name#">
</cfif>
<cfif isdefined("url.field_branch_id")>
	<cfset url_string = "#url_string#&field_branch_id=#url.field_branch_id#">
</cfif>
<cfif isdefined("url.field_branch_name")>
	<cfset url_string = "#url_string#&field_branch_name=#url.field_branch_name#">
</cfif>
<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
	<cfset url_string = "#url_string#&branch_id=#url.branch_id#">
</cfif>
<cfif isdefined("without_department")>
	<cfset url_string = "#url_string#&without_department">
</cfif>
<cfif isdefined("field_our_company_id")>
	<cfset url_string = "#url_string#&field_our_company_id=#attributes.field_our_company_id#">
</cfif>
<cfif isdefined("field_our_company")>
	<cfset url_string = "#url_string#&field_our_company=#attributes.field_our_company#">
</cfif>
<cfquery name="GET_DEPARTMENTS" datasource="#dsn#">
	SELECT 
		ZONE.ZONE_NAME,
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID,
		DEPARTMENT.DEPARTMENT_HEAD,
		DEPARTMENT.DEPARTMENT_ID,
		OUR_COMPANY.NICK_NAME,
		OUR_COMPANY.COMP_ID
	FROM 
		DEPARTMENT,
		BRANCH,
		ZONE,
		OUR_COMPANY
	WHERE 
		BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
		DEPARTMENT_STATUS = 1 AND
		IS_STORE <> 1 AND
		ZONE_STATUS = 1 AND
		BRANCH_STATUS = 1 AND
		ZONE.ZONE_ID = BRANCH.ZONE_ID
	<cfif not session.ep.ehesap>
		AND
		BRANCH.BRANCH_ID IN (
							SELECT
								BRANCH_ID
							FROM
								EMPLOYEE_POSITION_BRANCHES
							WHERE
								POSITION_CODE = #SESSION.EP.POSITION_CODE#
							)
	</cfif>
	<cfif isdefined("attributes.par_id") and len(attributes.par_id)>
		AND IS_STORE=1
	</cfif>
		AND BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		AND BRANCH.BRANCH_ID = #attributes.branch_id#
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND DEPARTMENT.DEPARTMENT_HEAD LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
	</cfif>
	ORDER BY
		ZONE.ZONE_NAME,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_departments.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
function gonder(id,alan,branch_id,branch,our_company,company)
	{
	<cfoutput>
	<cfif isdefined("field_id")>
	opener.#field_id#.value = id;
	</cfif>
	<cfif isdefined("field_name")>
	opener.#field_name#.value = alan;
	</cfif>
	<cfif isdefined("field_branch_id")>
	opener.#field_branch_id#.value = branch_id;
	</cfif>
	<cfif isdefined("field_branch_name")>
	opener.#field_branch_name#.value = branch;
	</cfif>
	<cfif isdefined("field_our_company_id")>
	opener.#field_our_company_id#.value = our_company;
	</cfif>
	<cfif isdefined("field_our_company")>
	opener.#field_our_company#.value = company;
	</cfif>
	</cfoutput>
	}
	
function gonder2(branch_id,branch)
	{
	<cfoutput>
	<cfif isdefined("field_id")>
	opener.#field_id#.value='';
	</cfif>
	<cfif isdefined("field_name")>
	opener.#field_name#.value='';
	</cfif>
	<cfif isdefined("field_branch_id")>
	opener.#field_branch_id#.value = branch_id;
	</cfif>
	<cfif isdefined("field_branch_name")>
	opener.#field_branch_name#.value = branch;
	</cfif>
	</cfoutput>
	}
</script>
<table cellspacing="0" cellpadding="0" border="0" width="100%">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" border="0" align="center" width="100%">
        <tr class="color-row">
		<cfoutput>
            <td>&nbsp;</td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#">123</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=A">A</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=B">B</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=C">C</a><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=??">??</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=D">D</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=E">E</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=F">F</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=G">G</a><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=??">??</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=H">H</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=I">I</a><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=??">??</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=J">J</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=K">K</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=L">L</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=M">M</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=N">N</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=O">O</a><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=??">??</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=P">P</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=Q">Q</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=R">R</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=S">S</a><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=??">??</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=T">T</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=U">U</a><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=??">??</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=V">V</a><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=W">W</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=Y">Y</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=hr.popup_list_departments#url_string#&keyword=Z">Z</a></td>
            <td>&nbsp;</td>
          </cfoutput>
		  </tr>
      </table>
    </td>
  </tr>
</table>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td class="headbold"><cf_get_lang no='105.Departmanlar'></td>
	<!-- sil -->
    <td  class="headbold" style="text-align:right;"><table>
      <cfform action="#request.self#?fuseaction=hr.popup_list_departments#url_string#" method="post" name="search">
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
    </table></td>
	<!-- sil -->
  </tr>
</table>
<cfif len(attributes.keyword)>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
</cfif>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2">
        <tr class="color-header">
          <td height="22" class="form-title"><cf_get_lang_main no='580.B??lge'></td>
          <td class="form-title" width="150"><cf_get_lang_main no='162.??irket'></td>
          <td height="22" class="form-title"><cf_get_lang_main no='41.??ube'></td>
          <td height="22" class="form-title"><cf_get_lang_main no='160.Departman'></td>
        </tr>
        <cfif get_departments.recordcount>
          <cfoutput query="get_departments" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
             <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                <td>#ZONE_NAME# </td>
                <td>#NICK_NAME#</td>
                <td>
				 <cfif isdefined("without_department")>
				 <a href="javascript://" onClick="gonder2('#branch_id#','#branch_name#');window.close();" class="tableyazi">#BRANCH_NAME#</a>
				 <cfelse>
				 <a href="javascript://" onClick="gonder('#department_id#','#department_head#','#branch_id#','#branch_name#','#comp_id#','#nick_name#');window.close();" class="tableyazi">#BRANCH_NAME#</a>
				 </cfif>
				 </td>
                <td> <a href="javascript://" onClick="gonder('#department_id#','#department_head#','#branch_id#','#branch_name#','#comp_id#','#nick_name#');window.close();" class="tableyazi">#DEPARTMENT_HEAD#</a></td>
              </tr>
          </cfoutput>
        <cfelse>
          <tr height="20" class="color-row">
            <td colspan="4"><cf_get_lang_main no='72.Kay??t Bulunamad??'>!</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table width="98%" border="0" cellpadding="0" cellspacing="0" height="35" align="center">
    <tr>
      <td>
	  <cf_pages 
		  page="#attributes.page#" 
		  maxrows="#attributes.maxrows#" 
		  totalrecords="#attributes.totalrecords#" 
		  startrow="#attributes.startrow#" 
		  adres="hr.popup_list_departments#url_string#"></td>
      <!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kay??t'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif>

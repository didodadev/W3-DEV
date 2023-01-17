<cfquery name="get_zone" datasource="#DSN#">
	SELECT 
		ZONE_ID,
		ZONE_NAME 
	FROM	
		ZONE
</cfquery>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
<tr>
<td class="headbold" height="35"><cf_get_lang dictionary_id="35448.Organizasyon Yapısı"></td></tr>
</table>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
  <cfif get_zone.RecordCount >
    <cfoutput query="get_zone">
      <tr>
        <td>
		  <cfif isdefined("attributes.zone_id") and (attributes.zone_id eq currentrow)>
		  <a href="javascript://" onclick="gizle_goster_img('img#currentrow#bolge1','img#currentrow#bolge2','bolge#currentrow#');"><img src="/images/tree_1.gif"  border="0" align="absmiddle" id="img#currentrow#bolge1" style="cursor:pointer;"></a>
		  <a href="javascript://" onclick="gizle_goster_img('img#currentrow#bolge1','img#currentrow#bolge2','bolge#currentrow#');"><img src="/images/tree_1.gif" border="0" align="absmiddle" id="img#currentrow#bolge2" style="cursor:pointer;display:none;"></a>
		  <cfelse>
		  <a href="javascript://" onclick="gizle_goster_img('img#currentrow#bolge1','img#currentrow#bolge2','bolge#currentrow#');"><img src="/images/tree_1.gif"  border="0" align="absmiddle" id="img#currentrow#bolge1" style="display:none;cursor:pointer;"></a>
		  <a href="javascript://" onclick="gizle_goster_img('img#currentrow#bolge1','img#currentrow#bolge2','bolge#currentrow#');"><img src="/images/tree_1.gif" border="0" align="absmiddle" id="img#currentrow#bolge2" style="cursor:pointer;"></a>
		  </cfif>		  
		  <cfif isdefined("attributes.hr")>
            <cfset str_ls="#request.self#?fuseaction=hr.form_upd_company_zone&id=#ZONE_ID#&hr=1&zone_id=#ZONE_ID#">
            <cfelse>
            <cfset str_ls="#request.self#?fuseaction=settings.form_upd_zone&id=#ZONE_ID#&zone_id=#ZONE_ID#">
          </cfif>
          <a href="#str_ls#" class="formbold" style="font-size:13px;">#ZONE_NAME#</a><br/>
          <span id="bolge#currentrow#" <cfif isdefined("attributes.zone_id") and (attributes.zone_id eq currentrow)>style="display:;"<cfelse>style="display:none;"</cfif>>
		  <cfquery name="get_branch" datasource="#DSN#">
			  SELECT 
				  BRANCH_ID,
				  BRANCH_NAME 
			  FROM 
				  BRANCH 
			  WHERE 
				  ZONE_ID=#ZONE_ID#
          </cfquery>
          <cfif get_branch.recordcount>
            <cfloop from="1" to="#get_branch.recordcount#" index="i">
              <img src="/images/tree_3.gif">
              <cfif isdefined("attributes.hr")>
                <cfset str_ls="#request.self#?fuseaction=hr.form_upd_company_branch&ID=#get_branch.BRANCH_ID[i]#&hr=1&zone_id=#get_zone.ZONE_ID#">
                <cfelse>
                <cfset str_ls="#request.self#?fuseaction=settings.form_upd_branch&ID=#get_branch.BRANCH_ID[i]#&zone_id=#get_zone.ZONE_ID#">
              </cfif>
              <a href="#str_ls#" class="tableyazi" style="font-size:12px;"><b>#get_branch.BRANCH_NAME[i]#</b></a> <br/>
              <cfquery name="get_dep" datasource="#DSN#">
				  SELECT 
					  DEPARTMENT_ID,
					  DEPARTMENT_HEAD,
					  HIERARCHY_DEP_ID 
				  FROM 
					  DEPARTMENT
				  WHERE 
					  BRANCH_ID=#get_branch.BRANCH_ID[i]# 
				  ORDER BY 
					  HIERARCHY_DEP_ID
              </cfquery>
              <cfif get_dep.recordcount>
                <cfloop from="1" to="#get_dep.recordcount#" index="k">
                  <cfset	str_len=ListLen(get_dep.HIERARCHY_DEP_ID[k],".")>
                  <cfif str_len gt 1>
                    <cfloop from="1" to="#str_len#" index="i">&nbsp;
                    </cfloop>
                    <cfelse>&nbsp;
                  </cfif>
                  <img src="/images/tree_3.gif">
                  <cfif isdefined("attributes.hr")>
                    <cfset str_l="#request.self#?fuseaction=hr.form_upd_department&ID=#get_dep.department_ID[k]#&hr=1&zone_id=#get_zone.ZONE_ID#">
                    <cfelse>
                    <cfset str_l="#request.self#?fuseaction=settings.form_upd_department&ID=#get_dep.department_ID[k]#&zone_id=#get_zone.ZONE_ID#">
                  </cfif>
                  <a href="#str_l#" class="tableyazi">#get_dep.department_Head[k]#</a><br/>
                </cfloop>
              </cfif>
            </cfloop>
          </cfif>
        </td>
      </tr>
	  </span>
    </cfoutput>
    <cfelse>
    <tr>
      <td width="20"  valign="baseline" style="text-align:right;">
	  <img src="/images/tree_1.gif" width="13"></td>
      <td><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</font></td>
    </tr>
  </cfif>
</table>

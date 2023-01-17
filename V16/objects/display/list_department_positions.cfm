<script type="text/javascript">
function add_pos(id,code,pos_name)
	{
	<cfif isdefined("attributes.field_pos_name")>
	opener.<cfoutput>#field_pos_name#</cfoutput>.value = pos_name;
	</cfif>
	<cfif isdefined("attributes.field_code")>
	opener.<cfoutput>#field_code#</cfoutput>.value = code;
	</cfif>
	window.close();
	}
</script>

<cfinclude template="../query/get_positions.cfm">
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.department_id" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>

<cfif get_positions.recordcount>
  <cfquery name="GET_NAMES" datasource="#dsn#">
  SELECT 
	  EP.EMPLOYEE_NAME, 
	  EP.EMPLOYEE_SURNAME, 
	  1 AS DEGER 
  FROM 
	  EMPLOYEE_POSITIONS EP, 
	  ZONE Z 
  WHERE 
	  EP.POSITION_CODE=Z.ADMIN1_POSITION_CODE 
  AND 
	  ZONE_ID=#GET_POSITIONS.ZONE_ID#
  UNION ALL 
  SELECT 
	  EP.EMPLOYEE_NAME, 
	  EP.EMPLOYEE_SURNAME, 
	  2 AS DEGER 
  FROM 
	  EMPLOYEE_POSITIONS EP, 
	  ZONE Z 
  WHERE 
	  EP.POSITION_CODE=Z.ADMIN2_POSITION_CODE 
  AND
  	  ZONE_ID=#GET_POSITIONS.ZONE_ID#
  </cfquery>
  <table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td class="headbold"><cfoutput>#get_positions.ZONE_NAME# /#get_positions.BRANCH_NAME# /#get_positions.DEPARTMENT_HEAD# </cfoutput></td>
      <td  valign="bottom" style="text-align:right;">
        <table>
          <cfform action="#request.self#?fuseaction=objects.popup_list_department_position#page_code#" method="post" name="search">
            <tr>
              <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
			        <td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
              <cfinclude template="../query/get_departments.cfm">
              <td>
				      <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				      <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
              </td>
              <td><cf_wrk_search_button></td>
            </tr>
          </cfform>
        </table>
      </td>
      <!-- sil -->
    </tr>
  </table>
  <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr clasS="color-border">
      <td>
        <table cellspacing="1" cellpadding="2" width="100%" border="0">
          <cfif GET_NAMES.RECORDCOUNT >
            <tr class="color-row">
              <td  colspan="4"> <cfoutput query="GET_NAMES"> <b><cf_get_lang dictionary_id='29511.Yönetici'> #DEGER#</b> : #EMPLOYEE_NAME#&nbsp;#EMPLOYEE_SURNAME# <br/>
                </cfoutput> </td>
            </tr>
          </cfif>
          <tr class="color-header">
            <td height="22" class="form-title" width="20"></td>
            <td class="form-title" width="120"><cf_get_lang dictionary_id='58497.Pozisyon'></td>
            <td class="form-title"><cf_get_lang dictionary_id='57570.Ad Soyad'></td>
            <td class="form-title" width="20"></td>
          </tr>
          <cfparam name="attributes.page" default=1>
          <cfparam name="attributes.totalrecords" default=#get_positions.recordcount#>
          <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
          <cfoutput query="get_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td align="center"><CF_ONLINE id="#employee_id#" zone="ep"></td>
              <cfif IsDefined("attributes.field_pos_name") AND IsDefined("attributes.field_code")>
                <td> <a href="##" class="tableyazi"  onClick="add_pos('#position_id#','#position_code#','#position_name#')"> #POSITION_NAME# </a> </td>
                <cfelse>
                <td>#POSITION_NAME#</td>
              </cfif>
              <td>
                <cfif not isdefined("url.trans")>
                  <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&DEPARTMENT_ID=#DEPARTMENT_ID#&emp_id=#EMPLOYEE_ID#&POS_ID=#POSITION_CODE##url_string#','medium')">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a>
                  <cfelse>
                  #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
                </cfif>
              </td>
              <td align="center"> <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_position_history&position_id=#get_positions.position_id#','large');"><img src="/images/report_square2.gif" border="0" ></a></td>
            </tr>
          </cfoutput>
        </table>
      </td>
    </tr>
  </table>
  </td>
  </tr>
  </table>
  <cfif attributes.totalrecords gt attributes.maxrows>
    <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
      <tr>
        <td> <cf_pages page="#attributes.page#"
				  maxrows="#attributes.maxrows#"
				  totalrecords="#attributes.totalrecords#"
				  startrow="#attributes.startrow#"
				  adres="objects.popup_list_department_position#url_string#"> </td>
        <!-- sil --><td  style="text-align:right;"> <cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#get_positions.recordcount#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
      </tr>
    </table>
  </cfif>
  <cfelse>
  <cfquery name="GET_ZONE" datasource="#dsn#">
	  SELECT 
		  * 
		  FROM 
		  DEPARTMENT, 
		  BRANCH, 
		  ZONE
	  WHERE 
		  DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
	  AND 
		  BRANCH.ZONE_ID=ZONE.ZONE_ID 
	  AND 
		  DEPARTMENT.DEPARTMENT_ID = #attributes.DEPARTMENT_ID#
  </cfquery>
  <table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td class="headbold"><cfoutput>#GET_ZONE.ZONE_NAME# / #GET_ZONE.BRANCH_NAME# / #GET_ZONE.DEPARTMENT_HEAD#</cfoutput></td>
    </tr>
  </table>
  <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr clasS="color-border">
      <td>
        <table cellspacing="1" cellpadding="2" width="100%" border="0">
          <tr class="color-header">
            <td height="22" class="form-title" width="20"></td>
            <td class="form-title" width="120"><cf_get_lang dictionary_id='58497.Pozisyon'></td>
            <td class="form-title"><cf_get_lang dictionary_id='57570.Ad Soyad'></td>
            <td class="form-title" width="20"></td>
          </tr>
          <tr class="color-row" height="20">
            <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</cfif>


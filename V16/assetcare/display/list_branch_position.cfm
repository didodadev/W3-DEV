<!---
	parametre  department_id 
	bu department id sine gore calisanlar listelenecek.
	ve bu listelenen calisanlardin info bilgilerini erisim olabilecek.
	
aan penceredeki istenen alana seilenleri kaydeder
	field_name : pozisyon adi gelecek
	field_id : pozisyon id si gelecek
	field_code: pozisyon kodu gelecek
	field_emp_id:employee_id
rnek kullanm :
	<a href="#" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_department_position&field_code=form_name.field_code&field_name=form_name.text_input_name</cfoutput>','list')"> Gidecekler </a>
--->
<cfparam name="attributes.keyword" default="">
<cfquery name="get_branch_info" datasource="#DSN#">
	SELECT 
		BRANCH.BRANCH_NAME,
		ZONE.ZONE_NAME
	FROM
		DEPARTMENT,
		BRANCH,		
		ZONE
	WHERE
		BRANCH.BRANCH_ID = #attributes.branch_id# AND 
		BRANCH.ZONE_ID = ZONE.ZONE_ID	
</cfquery>
<cffunction  name="get_names_of_dep">
  <cfargument name="hier">
  <cfset str_dep="">
  <cfloop from="1" to="#ListLen(hier,".")#"  index="i">
		  <cfquery name="get_dep_all" datasource="#DSN#">
			SELECT 
				*
			FROM
				DEPARTMENT
			WHERE
				DEPARTMENT_ID = #ListGetAt(hier,i,".")#
		  </cfquery>
		  <cfset str_dep=str_dep& "/#get_dep_all.DEPARTMENT_HEAD#">
  </cfloop>	
  <cfreturn #str_dep#>
</cffunction>
<cfquery name="GET_POSITIONS" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH,		
		ZONE
	WHERE
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
		BRANCH.ZONE_ID = ZONE.ZONE_ID AND		
		EMPLOYEE_POSITIONS.EMPLOYEE_ID > 0 AND
		EMPLOYEE_POSITIONS.POSITION_STATUS = 1
	<cfif len(attributes.keyword)>
		AND
		(
			EMPLOYEE_POSITIONS.POSITION_NAME LIKE '%#attributes.keyword#%' OR
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE '%#attributes.keyword#%' OR
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
		)
	</cfif>
	<cfif attributes.DEPARTMENT_ID IS NOT "all">
		AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = #attributes.DEPARTMENT_ID#
	</cfif>
	ORDER BY 
		POSITION_NAME
</cfquery>
<cfset url_string = "">

<table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr>
    	<td class="headbold">
			<cfset attributes.comp_id=get_positions.company_id>
			<cfif len(attributes.comp_id)>		
				<cfinclude template="../../objects/query/get_our_comp_name.cfm">
				<cfoutput>#get_company_name.nick_name#</cfoutput>
			</cfif>
	  	</td>
      	<td style="text-align:right;">
			<table>
				<cfform action="#request.self#?fuseaction=objects.popup_list_department_position" method="post" name="search">
				<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#attributes.department_id#</cfoutput>">
					<tr>
						<td><cf_get_lang_main no='48.Filtre'>:</td>
						<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no='310.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
						</td>
						<td><cf_wrk_search_button></td>
					</tr>
				</cfform>
			</table>
      	</td>
	</tr>
    <!-- sil -->
    </tr>
</table>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr clasS="color-border">
    	<td>
        <table cellspacing="1" cellpadding="2" width="100%" border="0">
			<tr class="color-header" height="20">
				<td class="form-title" colspan="4"><cfoutput>#get_dep_info.ZONE_NAME# / #get_dep_info.BRANCH_NAME#  #get_names_of_dep(get_dep_info.HIERARCHY_DEP_ID)#</cfoutput></td>
			</tr>
			<tr class="color-row" height="20">
				<td class="txtbold" colspan="4">
					<cf_get_lang no='86.Ynetici'> : 
					<cfif len(get_dep_info.ADMIN1_POSITION_CODE)><cfoutput>#get_emp_info(get_dep_info.ADMIN1_POSITION_CODE,1,0)#</cfoutput></cfif> 
					<cfif len(get_dep_info.ADMIN2_POSITION_CODE)><cfoutput>,#get_emp_info(get_dep_info.ADMIN2_POSITION_CODE,1,0)#</cfoutput></cfif>
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr class="color-list">
				<td height="22" width="25"></td>
				<td class="txtboldblue" width="150" nowrap><cf_get_lang no='262.Pozisyon'></td>
				<td class="txtboldblue" width="100"><cf_get_lang_main no='164.Calisan'></td>
				<td class="txtboldblue" width="100"><cf_get_lang no='160.Department'></td>
				<td class="txtboldblue" width="100"></td>
				<td width="15"></td>
			  </tr>
			  <cfparam name="attributes.page" default=1>
			  <cfparam name="attributes.totalrecords" default="#get_positions.recordcount#">
			  <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
			  <cfif get_positions.recordcount>
				  <cfoutput query="get_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					  <td align="center" width="25"><CF_ONLINE id="#employee_id#" zone="ep"></td>
						<td width="130"> 
							<cfif IsDefined("attributes.field_pos_name") and IsDefined("attributes.field_code")>
								<a href="javascript://" class="tableyazi"  onClick="add_pos('#position_id#','#position_code#','#position_name#')"> #POSITION_NAME# </a> 
							<cfelse>
								#POSITION_NAME#
							</cfif>
						</td>               
					  <td>
						<cfif not isdefined("url.trans")>
							  <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&DEPARTMENT_ID=#DEPARTMENT_ID#&emp_id=#EMPLOYEE_ID#&POS_ID=#POSITION_CODE##url_string#','medium')">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a>
						<cfelse>
							  #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
						</cfif>
					  </td>
					  <td width="15"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_position_history&position_id=#get_positions.position_id#','large');"><img src="/images/report_square2.gif" alt="" border="0"></a></td>
					<td></td>
					</tr>
				  </cfoutput>
			  <cfelse>
					  <tr class="color-row" height="20">
						<td colspan="4"><cf_get_lang_main no='72.Kayit Bulunamadi'>!</td>
					  </tr>				
			  </cfif>
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
					  adres="objects.popup_list_department_position#url_string#&department_id=#attributes.department_id#"> </td>
			<!-- sil --><td style="text-align:right;"> <cfoutput><cf_get_lang_main no='128.Toplam Kayit'>:#get_positions.recordcount#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
		  </tr>
		</table>
	  </cfif>
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

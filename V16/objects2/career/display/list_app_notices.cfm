<cfif isDefined("attributes.STARTDATE") and len(attributes.STARTDATE)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif isDefined("attributes.FINISHDATE") and len(attributes.FINISHDATE)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfif isdefined("attributes.form_varmi")>  
	<cfquery name="get_notices" datasource="#dsn#">
	  SELECT 
		* 
	  FROM 
		  NOTICES 
	  WHERE 
		1=1 AND
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
		<cfif IsDefined('attributes.status') and len(attributes.status)>
			AND STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.status#">
		</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND (NOTICE_HEAD LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%' 
				OR 
				NOTICE_NO LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%')
		</cfif>
		<cfif isDefined("attributes.STARTDATE") and len(attributes.STARTDATE)>
			AND STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.STARTDATE#">
		</cfif>
		<cfif isDefined("attributes.FINISHDATE") and len(attributes.FINISHDATE)>
		   AND FINISHDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.FINISHDATE#">
		</cfif>
	</cfquery>
	<cfparam name="attributes.totalrecords" default="#get_notices.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfoutput>
<script type="text/javascript">
function add_pos(notice_id,notice_head,notice_no,company_name,company_id,department,department_id,branch,branch_id,our_company_id,our_company_name,position_id,position_name,position_cat_id,position_cat_name)
{
	<cfif isdefined("attributes.field_name")>
		opener.<cfoutput>#attributes.field_name#</cfoutput>.value = notice_head;
	</cfif>
	<cfif isdefined("attributes.field_id")>
		opener.<cfoutput>#attributes.field_id#</cfoutput>.value = notice_id;
	</cfif>
	<cfif isdefined("attributes.field_no")>
		opener.<cfoutput>#attributes.field_no#</cfoutput>.value = notice_no;
	</cfif>
	<cfif isdefined("attributes.field_comp") and isdefined("attributes.field_comp_id")>
		opener.<cfoutput>#attributes.field_comp#</cfoutput>.value = company_name;
		opener.<cfoutput>#attributes.field_comp_id#</cfoutput>.value = company_id;
	</cfif>
	<cfif isdefined("attributes.field_department_id") and isdefined("attributes.field_department")>
		opener.<cfoutput>#attributes.field_department_id#</cfoutput>.value = department_id;
		opener.<cfoutput>#attributes.field_department#</cfoutput>.value = department;
	</cfif>
	<cfif isdefined("attributes.field_branch_id") and isdefined("attributes.field_branch")>
		opener.<cfoutput>#attributes.field_branch_id#</cfoutput>.value = branch_id;
		opener.<cfoutput>#attributes.field_branch#</cfoutput>.value =branch;
	</cfif>	
	<cfif isdefined("attributes.field_our_company_id")>
		opener.<cfoutput>#attributes.field_our_company_id#</cfoutput>.value = our_company_id;
	</cfif>	
	<cfif isdefined("attributes.field_our_company_name")>
		opener.<cfoutput>#attributes.field_our_company_name#</cfoutput>.value = our_company_name;
	</cfif>	
	<cfif isdefined("attributes.field_pos_id")>
		opener.<cfoutput>#attributes.field_pos_id#</cfoutput>.value = position_id;
	</cfif>
	<cfif isdefined("attributes.field_pos_name")>
		opener.<cfoutput>#attributes.field_pos_name#</cfoutput>.value = position_name;
	</cfif>
	<cfif isdefined("attributes.field_pos_cat_id")>
		opener.<cfoutput>#attributes.field_pos_cat_id#</cfoutput>.value = position_cat_id;
	</cfif>
	<cfif isdefined("attributes.field_pos_cat_name")>
		opener.<cfoutput>#attributes.field_pos_cat_name#</cfoutput>.value = position_cat_name;
	</cfif>
	window.close();
}
</script>
<cfscript>
	url_string = '';
	if (isdefined('attributes.field_td')) url_string = '#url_string#&field_td=#attributes.field_td#';
	if (isdefined("attributes.field_id")) url_string = "#url_string#&field_id=#attributes.field_id#";
	if (isdefined("attributes.field_no")) url_string = "#url_string#&field_no=#attributes.field_no#";
	if (isdefined("attributes.field_name")) url_string = "#url_string#&field_name=#attributes.field_name#";
	if (isdefined("attributes.field_comp")) url_string = "#url_string#&field_comp=#attributes.field_comp#";
	if (isdefined("attributes.field_comp_id")) url_string = "#url_string#&field_comp_id=#attributes.field_comp_id#";
	if (isdefined("attributes.field_department_id")) url_string = "#url_string#&field_department_id=#attributes.field_department_id#";
	if (isdefined("attributes.field_department")) url_string = "#url_string#&field_department=#attributes.field_department#";
	if (isdefined("attributes.field_branch_id")) url_string = "#url_string#&field_branch_id=#attributes.field_branch_id#";
	if (isdefined("attributes.field_branch")) url_string = "#url_string#&field_branch=#attributes.field_branch#";
	if (isdefined("attributes.field_our_company_id")) url_string = "#url_string#&field_our_company_id=#attributes.field_our_company_id#";
	if (isdefined("attributes.field_our_company_name")) url_string = "#url_string#&field_our_company_name=#attributes.field_our_company_name#";
	if (isdefined("attributes.field_pos_id")) url_string = "#url_string#&field_pos_id=#attributes.field_pos_id#";
	if (isdefined("attributes.field_pos_name")) url_string = "#url_string#&field_pos_name=#attributes.field_pos_name#";
	if (isdefined("attributes.field_pos_cat_id")) url_string = "#url_string#&field_pos_cat_id=#attributes.field_pos_cat_id#";
	if (isdefined("attributes.field_pos_cat_name")) url_string = "#url_string#&field_pos_cat_name=#attributes.field_pos_cat_name#";
</cfscript>
</cfoutput>
<table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
  	<tr>
    	<td class="headbold"><cf_get_lang no='921.İlanlar'></td>
    	<td  class="headbold" style="text-align:right;">
      	<table>
        <cfform action="#request.self#?fuseaction=objects2.popup_list_notices#url_string#" method="post" name="search">
		<input name="form_varmi" id="form_varmi" value="1" type="hidden">		
        	<tr>
				<td><cf_get_lang_main no='48.Filtre'>:</td>
				<td><cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255"></td>
				<td  style="text-align:right;"><input type="text" name="startdate" id="startdate"  style="width:65px;" value="<cfoutput>#dateformat(attributes.startdate,'dd/mm/yyyy')#</cfoutput>"></td>
				<td  style="text-align:right;"><cf_wrk_date_image date_field="startdate"></td>
				<td  style="text-align:right;"><input type="text" name="finishdate" id="finishdate" value="<cfoutput>#dateformat(attributes.finishdate,'dd/mm/yyyy')#</cfoutput>" style="width:65px;"></td>
				<td  style="text-align:right;"><cf_wrk_date_image date_field="finishdate"></td>
				<td>
					<select name="status" id="status">
						<option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang_main no='81.Aktif'>
						<option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang_main no='82.Pasif'>
						<option value="" <cfif not len(attributes.status)>selected</cfif>><cf_get_lang_main no='296.Tümü'>			                        
					</select>
				</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</td>
				<td><cf_wrk_search_button></td>
          </tr>
        </cfform>
      </table>
<cfscript>
	url_string = '#url_string#&status=#attributes.status#&company_id=#attributes.company_id#&company=#attributes.company#';
	url_string = '#url_string#&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#';
	url_string = '#url_string#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#';
	if (len(attributes.keyword)) url_string = "#url_string#&keyword=#attributes.keyword#";
</cfscript>
    </td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" border="0" width="98%" align="center">
  <tr class="color-border">
    <td>
	  <table cellspacing="1" cellpadding="2" width="100%" border="0">
		  <tr class="color-header">
		  	<td class="form-title" height="22"><cf_get_lang no='777.İlan Kodu'></td>
			<td class="form-title"><cf_get_lang no='751.İlan'></td>
            <td class="form-title" width="100"><cf_get_lang_main no='1085.Pozisyon'></td>
			<td class="form-title" width="65"><cf_get_lang no='257.Firma'></td>
			<td class="form-title" width="65"><cf_get_lang_main no='89.Başlama'></td>
			<td class="form-title" width="65"><cf_get_lang_main no='90.Bitiş'></td>
		  </tr>
	<cfif isdefined("attributes.form_varmi") and get_notices.recordcount>
		<cfoutput query="get_notices" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfif len(get_notices.department_id) and len(get_notices.our_company_id)>
			<cfquery name="GET_OUR_COMPANY" datasource="#dsn#">
			SELECT
				OUR_COMPANY.NICK_NAME,
				OUR_COMPANY.COMP_ID,
				BRANCH.BRANCH_NAME,
				BRANCH.BRANCH_ID,
				DEPARTMENT.DEPARTMENT_HEAD,
				DEPARTMENT.DEPARTMENT_ID
			FROM 
				DEPARTMENT,
				BRANCH,
				OUR_COMPANY
			WHERE 
				OUR_COMPANY.COMP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_notices.our_company_id#">
				AND BRANCH.COMPANY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_notices.our_company_id#">
				AND	BRANCH.BRANCH_ID=DEPARTMENT.BRANCH_ID
				AND BRANCH.BRANCH_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_notices.branch_id#">
				AND DEPARTMENT.DEPARTMENT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_notices.department_id#">
			</cfquery>
		</cfif>
		 <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
		 	<td><a href="javascript://" onClick="add_pos('#NOTICE_ID#','#NOTICE_NO#-#NOTICE_HEAD#','#NOTICE_NO#','#COMPANY#','#COMPANY_ID#'<cfif IsDefined('GET_OUR_COMPANY') and GET_OUR_COMPANY.recordcount>,'#GET_OUR_COMPANY.department_head#','#get_notices.department_id#','#GET_OUR_COMPANY.branch_name#','#get_notices.branch_id#','#get_notices.our_company_id#','#GET_OUR_COMPANY.NICK_NAME#'<cfelse>,'','','','','',''</cfif>,'#get_notices.position_id#','#get_notices.position_name#','#get_notices.position_cat_id#','#get_notices.position_cat_name#');" class="tableyazi">#NOTICE_NO#</a></td>
			<td><a href="javascript://" onClick="add_pos('#NOTICE_ID#','#NOTICE_NO#-#NOTICE_HEAD#','#NOTICE_NO#','#COMPANY#','#COMPANY_ID#'<cfif IsDefined('GET_OUR_COMPANY') and GET_OUR_COMPANY.recordcount>,'#GET_OUR_COMPANY.department_head#','#get_notices.department_id#','#GET_OUR_COMPANY.branch_name#','#get_notices.branch_id#','#get_notices.our_company_id#','#GET_OUR_COMPANY.NICK_NAME#'<cfelse>,'','','','','',''</cfif>,'#get_notices.position_id#','#get_notices.position_name#','#get_notices.position_cat_id#','#get_notices.position_cat_name#');" class="tableyazi">#NOTICE_HEAD#</a></td>
             <td>
                <cfif len(POSITION_ID)>
				<cfquery name="get_position_name" datasource="#dsn#">
					SELECT
						EMPLOYEE_POSITIONS.POSITION_ID,
						EMPLOYEE_POSITIONS.POSITION_CODE,
						EMPLOYEE_POSITIONS.POSITION_NAME,
						EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
						EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME
					FROM
						EMPLOYEE_POSITIONS
					WHERE
						EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
				</cfquery>
					<cfset app_position = "#get_position_name.position_name# - #get_position_name.employee_name# #get_position_name.employee_surname#">
				<cfelse>
					<cfset app_position = "-">
				</cfif>
				#app_position#					  
		    </td>
			<!---TolgaS 20051226 surun olmazsa 60 güne siline bilir<td><cfif len(get_notices.company_id)>#get_company.fullname#</cfif></td> --->
			<td><cfif len(get_notices.company)>#get_notices.company#</cfif></td>
            <td><cfif len(STARTDATE)>#dateformat(STARTDATE,"dd/mm/yyyy")#</cfif></td>
			<td><cfif len(FINISHDATE)>#dateformat(FINISHDATE,"dd/mm/yyyy")#</cfif></td>
		  </tr>
		</cfoutput>
		<cfelse>
		<tr>
			<td colspan="7" class="color-row"><cfif isdefined("attributes.form_varmi")><cf_get_lang_main no='72.Kayıt Yok'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif>!</td>
		</tr>
		</cfif>
	  </table>
    </td>
  </tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
    <tr>
      <td>
	  <cfif isdefined("attributes.form_varmi")>
		<cfset url_string = "#url_string#&form_varmi=#attributes.form_varmi#" >
	  </cfif>
	  <cf_pages page="#attributes.page#"
			  maxrows="#attributes.maxrows#"
			  totalrecords="#attributes.totalrecords#"
			  startrow="#attributes.startrow#"
			  adres="objects2.popup_list_notices#url_string#"> </td>
      <!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
    </tr>
  </table>
</cfif><br/>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

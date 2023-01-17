<cfif isdefined("attributes.keyword")>
	<cfset arama_yapilmali = 1>
<cfelse>
	<cfset arama_yapilmali = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.show_empty_pos" default='0'>
<cfif arama_yapilmali>
	<cfinclude template="../query/get_positions_.cfm">
<cfelse>
	<cfset get_positions.recordcount=0>
</cfif>
<cfquery name="GET_POSITION_CATS" datasource="#dsn#">
	SELECT * FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_positions.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT 
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID	
	FROM 
		BRANCH
	WHERE 
		BRANCH_ID IS NOT NULL
	<cfif not session.ep.ehesap>
		AND BRANCH.BRANCH_ID IN (
								SELECT
									BRANCH_ID
								FROM
									EMPLOYEE_POSITION_BRANCHES
								WHERE
									POSITION_CODE = #SESSION.EP.POSITION_CODE#
								)
	</cfif>
	ORDER BY
		BRANCH_NAME
</cfquery>
<script type="text/javascript">
function add_pos(id,name,code,emp_id,branch_name,branch_id,dep_name,dep_id,mail,pos_name,company,company_id,position_employee)
{
	<cfif isdefined("attributes.field_id")>
	opener.<cfoutput>#field_id#</cfoutput>.value += "," + id + ",";    /*position_id*/
	</cfif>
	<cfif isdefined("attributes.field_partner")>
	opener.<cfoutput>#field_partner#</cfoutput>.value = "";
	</cfif>
	<cfif isdefined("attributes.field_emp_id")>
	opener.<cfoutput>#field_emp_id#</cfoutput>.value = emp_id;
	</cfif>
	<cfif isdefined("attributes.field_code")>
	opener.<cfoutput>#field_code#</cfoutput>.value = code;    /*position_code*/
	</cfif>
	<cfif isdefined("attributes.field_pos_name")>
	opener.<cfoutput>#field_pos_name#</cfoutput>.value = pos_name;
	</cfif>
	<cfif isdefined("attributes.field_emp_name")>
	opener.<cfoutput>#field_emp_name#</cfoutput>.value = name;
	</cfif>
	<cfif isdefined("attributes.field_emp_mail")>
		if (mail.length)    
			 opener.<cfoutput>#field_emp_mail#</cfoutput>.value = mail;			 
		else{
			 alert("<cf_get_lang dictionary_id='60168.Maili olmayan birisini seçtiniz'> !! <cf_get_lang dictionary_id='55269.Lütfen başka birisini seçiniz !!'>");
			 return false;
		}		
	</cfif>
	<cfif isdefined("attributes.field_dep_name")>
	opener.<cfoutput>#field_dep_name#</cfoutput>.value = dep_name;
	</cfif>
	<cfif isdefined("attributes.field_dep_id")>
	opener.<cfoutput>#field_dep_id#</cfoutput>.value = dep_id;
	</cfif>
	<cfif isdefined("attributes.field_branch_name")>
	opener.<cfoutput>#field_branch_name#</cfoutput>.value = branch_name;
	</cfif>
	<cfif isdefined("attributes.field_branch_id")>
	opener.<cfoutput>#field_branch_id#</cfoutput>.value = branch_id;
	</cfif>
	<cfif isdefined("attributes.field_comp")>
	opener.<cfoutput>#field_comp#</cfoutput>.value = company;
	</cfif>
	<cfif isdefined("attributes.field_comp_id")>
	opener.<cfoutput>#field_comp_id#</cfoutput>.value = company_id;
	</cfif>
	<cfif isDefined("attributes.field_table")>
		opener.<cfoutput>#attributes.field_table#</cfoutput>.innerHTML += "<table class='label'><tr><td>"+name+"</td></tr></table>";
	</cfif>
	<cfif isDefined("attributes.field_pos_table")>
		opener.<cfoutput>#attributes.field_pos_table#</cfoutput>.innerHTML += "<table class='label'><tr><td>"+pos_name+"</td></tr></table>";
	</cfif>
	<cfif isDefined("attributes.field_pos")>
		opener.<cfoutput>#attributes.field_pos#</cfoutput>.value += "," + code + ",";
	</cfif>
	<cfif isdefined("attributes.field_id2")>
	    opener.<cfoutput>#attributes.field_id2#</cfoutput>.value += "," + id + ",";
	</cfif>
	<cfif isdefined("attributes.position_employee")>
	    opener.<cfoutput>#attributes.position_employee#</cfoutput>.value = position_employee;
	</cfif>
	<cfif isdefined("attributes.ssk_healty")>
	  windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.employee_relative_ssk&event=add&field_name=popup_ssk_healty_print.ill_name&field_surname=popup_ssk_healty_print.ill_surname&field_relative=popup_ssk_healty_print.ill_relative&field_birth_date=popup_ssk_healty_print.ill_bdate&field_birth_place=popup_ssk_healty_print.ill_bplace&employee_id=emp_id','medium');
	</cfif>
	window.close();
}
function reloadopener(){
	wrk_opener_reload();
	window.close();
}
</script>

<cfscript>
url_string = '';
if (isdefined('attributes.field_emp_name')) url_string = '#url_string#&field_emp_name=#field_emp_name#';
if (isdefined('attributes.position_employee')) url_string = '#url_string#&position_employee=#position_employee#';
if (isdefined('attributes.field_emp_mail')) url_string = '#url_string#&field_emp_mail=#field_emp_mail#';
if (isdefined('attributes.field_emp_id')) url_string = '#url_string#&field_emp_id=#field_emp_id#';
if (isdefined('attributes.field_pos_name')) url_string = '#url_string#&field_pos_name=#field_pos_name#';
if (isdefined('attributes.field_code')) url_string = '#url_string#&field_code=#field_code#';
if (isdefined('attributes.field_branch_name')) url_string = '#url_string#&field_branch_name=#field_branch_name#';
if (isdefined('attributes.field_branch_id')) url_string = '#url_string#&field_branch_id=#field_branch_id#';
if (isdefined('attributes.field_dep_name')) url_string = '#url_string#&field_dep_name=#field_dep_name#';
if (isdefined('attributes.field_dep_id')) url_string = '#url_string#&field_dep_id=#field_dep_id#';
if (isdefined('attributes.field_comp_id')) url_string = '#url_string#&field_comp_id=#field_comp_id#';
if (isdefined('attributes.field_comp')) url_string = '#url_string#&field_comp=#field_comp#';
if (isdefined('attributes.show_empty_pos')) url_string = '#url_string#&show_empty_pos=#attributes.show_empty_pos#';
if (isdefined('attributes.field_table')) url_string = '#url_string#&field_table=#field_table#';
if (isdefined('attributes.field_pos')) url_string = '#url_string#&field_pos=#field_pos#';
if (isdefined('attributes.field_pos_table')) url_string = '#url_string#&field_pos_table=#field_pos_table#';
if (isdefined("attributes.url_param")) url_string = "#url_string#&url_param=#url_param#";
if (isdefined("attributes.field_id")) url_string = "#url_string#&field_id=#field_id#";
if (isdefined('attributes.field_partner')) url_string = '#url_string#&field_partner=#field_partner#';
</cfscript>
<!-- sil -->
<table cellspacing="0" cellpadding="0" border="0" width="100%">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" border="0" align="center" width="100%">
        <tr class="color-row"> <cfoutput>
            <td>&nbsp;</td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=A">A</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=B">B</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=C">C</a><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=Ç">Ç</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=D">D</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=E">E</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=F">F</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=G">G</a><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=Ğ">Ğ</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=H">H</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=I">I</a><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=İ">İ</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=J">J</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=K">K</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=L">L</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=M">M</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=N">N</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=O">O</a><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=Ö">Ö</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=P">P</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=Q">Q</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=R">R</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=S">S</a><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=Ş">Ş</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=T">T</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=U">U</a><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=Ü">Ü</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=V">V</a><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=W">W</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=Y">Y</a></td>
            <td align="center" width="15"><A class="tableyazi" href="#request.self#?fuseaction=objects.popup_list_positions#url_string#&keyword=Z">Z</a></td>
            <td>&nbsp;</td>
          </cfoutput> </tr>
      </table>
    </td>
  </tr>
</table>
<!-- sil -->
<table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td width="81%" class="headbold"><cf_get_lang dictionary_id='58875.çalışanlar'></td>
	<!-- sil -->
    <td>
	<table>
      <cfform action="#request.self#?fuseaction=objects.popup_list_positions#url_string#" method="post" name="search">
        <tr>
          <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
          <td><cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" style="width:75px;"></td>
			<cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
          <td>
			<select name="branch_id" id="branch_id" style="width:200px;">
				<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
				<cfoutput query="get_branch">
                	<option value="#branch_id#"<cfif isdefined("attributes.branch_id") and (branch_id eq attributes.branch_id)> selected</cfif>>#BRANCH_NAME#</option>
				</cfoutput>
			</select>
          </td>
          <td>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
			<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
          </td>
          <td><cf_wrk_search_button></td>          
          <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>          
        </tr>
      
    </table></td>
	<!-- sil -->
  </tr>
</table>
<table cellspacing="0" cellpadding="0" border="0" width="98%" align="center">
  <tr class="color-border">
    <td>
		<table cellspacing="1" cellpadding="2" width="100%" border="0">
			<tr class="color-list">
				<td colspan="<cfif attributes.show_empty_pos eq 0>8<cfelse>5</cfif>"  style="text-align:right;">
					<select name="POSITION_CAT_ID" id="POSITION_CAT_ID" style="width:150px;">
					  <option value=""><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></option>
						<cfoutput query="get_position_cats">
							<option value="#POSITION_CAT_ID#" <cfif isdefined("attributes.POSITION_CAT_ID") and attributes.POSITION_CAT_ID eq POSITION_CAT_ID>selected</cfif>>#POSITION_CAT#
						</cfoutput>
				  </select>
				</td>
			</tr>
			</cfform>
		<cfif attributes.show_empty_pos eq 0>
			  <tr class="color-header">
				<td height="22" class="form-title"><cf_get_lang dictionary_id='57487.No'></td>
				<td class="form-title" width="120"><cf_get_lang dictionary_id='57570.Ad Soyad'></td>
				<td class="form-title" width="120"><cf_get_lang dictionary_id='58497.Pozisyon'></td>
				<td class="form-title" width="120"><cf_get_lang dictionary_id='57574.Şirket'></td>
				<td class="form-title" width="120"><cf_get_lang dictionary_id='57992.Bölge'></td>
				<td class="form-title" width="120"><cf_get_lang dictionary_id='57453.Şube'></td>
				<td class="form-title" width="80"><cf_get_lang dictionary_id='57572.Departman'></td>
				<td class="form-title" width="15"></td>
			  </tr>
			<cfif get_positions.recordcount>
			<cfoutput query="get_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			 <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td width="25"> <CF_ONLINE id="#employee_id#" zone="ep"> </td>
				<td>
				  <cfif not isdefined("url.trans")>
					<a href="javascript://" class="tableyazi"  onClick="add_pos('#position_id#','#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#','#position_code#','#EMPLOYEE_ID#','#BRANCH_NAME#','#BRANCH_ID#','#DEPARTMENT_HEAD#','#DEPARTMENT_ID#','#EMPLOYEE_EMAIL#', '#position_name#','#NICK_NAME#','#COMP_ID#')",'#position_name#-#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#'>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a>
					<cfelse>
					#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
				  </cfif>
				</td>
				<td>
				  <cfif isdefined("url.trans")>
					<a href="javascript://" class="tableyazi"  onClick="add_pos('#position_id#','#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#','#position_code#','#EMPLOYEE_ID#','#BRANCH_NAME#','#BRANCH_ID#','#DEPARTMENT_HEAD#','#DEPARTMENT_ID#','#EMPLOYEE_EMAIL#', '#position_name#','#NICK_NAME#','#COMP_ID#','#position_name#-#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#')">#POSITION_NAME#</a>
					<cfelse>
					<cfif is_master eq 1>
						#POSITION_NAME# 
					<cfelse>
						#POSITION_NAME# (EK)
					</cfif>
				  </cfif>
				</td>
				<td>#NICK_NAME#</td>
				<td>#ZONE_NAME# </td>
				<td>#BRANCH_NAME#</td>
				<td>#DEPARTMENT_HEAD#</td>
				<td>
				<cfif attributes.show_empty_pos eq 0>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&department_id=#DEPARTMENT_ID#&emp_id=#EMPLOYEE_ID#&pos_id=#POSITION_CODE##url_string#','medium')"><img src="/images/report_square2.gif" border="0"></a>
				</cfif>
				</td>
			  </tr>
			</cfoutput>
			<cfelse>
				<tr>
					<td colspan="8" class="color-row"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td>
				</tr>
			</cfif>
		<cfelse>
			  <tr class="color-header" height="22">
				<td class="form-title" width="120"><cf_get_lang dictionary_id='58497.Pozisyon'></td>
				<td class="form-title" width="120"><cf_get_lang dictionary_id='57574.Şirket'></td>
				<td class="form-title" width="120"><cf_get_lang dictionary_id='57992.Bölge'></td>
				<td class="form-title" width="120"><cf_get_lang dictionary_id='57453.Şube'></td>
				<td class="form-title" width="15"><cf_get_lang dictionary_id='57572.Departman'></td>
			  </tr>
			<cfif get_positions.recordcount>
			<cfoutput query="get_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>
				<cfif not isdefined("url.trans")>
					<a href="##" class="tableyazi"  onClick="add_pos('#position_id#','#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#','#position_code#','#EMPLOYEE_ID#','#BRANCH_NAME#','#BRANCH_ID#','#DEPARTMENT_HEAD#','#DEPARTMENT_ID#','#EMPLOYEE_EMAIL#','#position_name#','#NICK_NAME#','#COMP_ID#','#position_name#-#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#')">#POSITION_NAME#</a>
				<cfelse>
					<cfif is_master eq 1>
						#POSITION_NAME# 
					<cfelse>
						#POSITION_NAME# (EK)
					</cfif>
				  </cfif>
				<cfif EMPLOYEE_ID eq 0>
				-<font color="##FF0000">Boş</font>
				<cfelseif EMPLOYEE_ID gt 0>
				-<font color="##FF0000">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</font>
				</cfif>
				</td>
				<td>#NICK_NAME#</td>
				<td>#ZONE_NAME# </td>
				<td>#BRANCH_NAME#</td>
				<td>#DEPARTMENT_HEAD#</td>
			  </tr>
			</cfoutput>
			<cfelse>
				<tr>
					<td colspan="8" class="color-row"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td>
				</tr>
			</cfif>
		</cfif>
		</table>
    </td>
  </tr>
</table>
<cfif isdefined("attributes.POSITION_CAT_ID") and len(attributes.POSITION_CAT_ID)>
	<cfset url_string = "#url_string#&POSITION_CAT_ID=#POSITION_CAT_ID#">
</cfif>
<cfif (isdefined("attributes.branch_id") and len(attributes.branch_id))>
	<cfset url_string = "#url_string#&branch_id=#attributes.branch_id#">
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
    <tr>
      <td><cf_pages page="#attributes.page#"
			  maxrows="#attributes.maxrows#"
			  totalrecords="#attributes.totalrecords#"
			  startrow="#attributes.startrow#"
			  adres="objects.popup_list_positions#url_string#"> </td>
      <!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif><br/>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

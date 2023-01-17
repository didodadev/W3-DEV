<!--- çalışanın herhangi bir posizyonu ile idari amiri olduğu çalışanlar geliyor
TolgaS 20051214
<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_under_position_list&field_emp_id=add_perf_emp_info.employee_id&field_pos_code=add_perf_emp_info.position_code&field_name=add_perf_emp_info.emp_name</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>
--->
<cfif isdefined("attributes.up_emp_id")>
	<cfquery name="get_up_pos" datasource="#dsn#">
		SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #attributes.up_emp_id#
	</cfquery>
</cfif>
<cfif not isdefined("attributes.up_emp_id")  or not get_up_pos.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='56869.Bu işlemi yapabilmek için bir pozisyona atanmış olmanız gerekmektedir'> !");
		window.close();
	</script>
</cfif>
<cfset pos_code_list = ValueList(get_up_pos.POSITION_CODE,',')>

<cfif isdefined("attributes.is_form_submitted") or (isdefined("attributes.keyword") and len(attributes.keyword))>
	<cfquery name="GET_POSITIONS" datasource="#dsn#">
		SELECT
			EMPLOYEES.GROUP_STARTDATE,
			EMPLOYEE_POSITIONS.EMPLOYEE_ID,
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL,
			EMPLOYEE_POSITIONS.POSITION_CODE,
			EMPLOYEE_POSITIONS.POSITION_NAME,
			EMPLOYEE_POSITIONS.UPPER_POSITION_CODE,
			BRANCH.BRANCH_NAME,
			BRANCH.BRANCH_ID,
			DEPARTMENT.DEPARTMENT_HEAD,
			DEPARTMENT.DEPARTMENT_ID
		FROM
			EMPLOYEE_POSITIONS,
			DEPARTMENT,
			BRANCH,
			EMPLOYEES
		WHERE
			EMPLOYEE_POSITIONS.POSITION_STATUS=1 AND
			DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND 
			EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND
			EMPLOYEE_POSITIONS.POSITION_CODE IN(SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE UPPER_POSITION_CODE IN (#pos_code_list#)) AND
			EMPLOYEES.EMPLOYEE_STATUS=1 AND 
			EMPLOYEES.EMPLOYEE_ID=EMPLOYEE_POSITIONS.EMPLOYEE_ID 
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			<cfif len(attributes.keyword) eq 1>
				AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE '#attributes.keyword#%'
			<cfelse>
				<cfif database_type is 'MSSQL'>
				AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME + ' ' + EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
				<cfelseif database_type is 'DB2'>
				AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME || ' ' || EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
				</cfif>
			</cfif>
		</cfif>
		<cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
			AND BRANCH.BRANCH_ID = #attributes.branch_id#
		</cfif>
		
		ORDER BY
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME
	</cfquery>

	<cfset arama_yapilmali = 0>
<cfelse>
	<cfset get_positions.recordcount = 0>
	<cfset arama_yapilmali = 1>
</cfif>
<cfquery name="GET_BRANCHES" datasource="#dsn#">
	SELECT 
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID	
	FROM 
		BRANCH
	WHERE 
		BRANCH_ID IS NOT NULL
		<cfif isdefined("attributes.branch_related")>AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)</cfif>
	ORDER BY
		BRANCH_NAME
</cfquery>

<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.page" default=1>
<cfif not isdefined("attributes.maxrows") or not isNumeric(attributes.maxrows)>
	<cfset attributes.maxrows = session.ep.maxrows>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_positions.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<script type="text/javascript">
function add_pos(name,code,emp_id)
{
	<cfif isdefined("attributes.field_emp_id")>
		opener.<cfoutput>#attributes.field_emp_id#</cfoutput>.value = emp_id;
	</cfif>
	<cfif isdefined("attributes.field_name")>
		opener.<cfoutput>#attributes.field_name#</cfoutput>.value = name;
	</cfif>
	<cfif isdefined("attributes.field_pos_code")>
		opener.<cfoutput>#attributes.field_pos_code#</cfoutput>.value = code;
	</cfif>
	window.close();
}
</script>

<cfscript>
	url_string = '';
	if (isdefined('attributes.field_name')) url_string = '#url_string#&field_name=#attributes.field_name#';
	if (isdefined('attributes.field_emp_id')) url_string = '#url_string#&field_emp_id=#attributes.field_emp_id#';
	if (isdefined('attributes.field_pos_code')) url_string = '#url_string#&field_pos_code=#attributes.field_pos_code#';
	url_string2 = '&is_form_submitted=1&up_emp_id=#attributes.up_emp_id#';
</cfscript>
<table class="harfler">
    <tr>
        <cfoutput>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=A">A</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=B">B</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=C">C</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=Ç">Ç</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=D">D</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=E">E</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=F">F</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=G">G</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=Ğ">Ğ</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=H">H</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=I">I</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=İ">İ</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=J">J</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=K">K</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=L">L</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=M">M</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=N">N</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=O">O</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=Ö">Ö</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=P">P</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=Q">Q</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=R">R</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=S">S</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=Ş">Ş</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=T">T</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=U">U</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=Ü">Ü</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=V">V</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=W">W</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=Y">Y</a></td>
            <td><a class="tableyazi" href="#request.self#?fuseaction=hr.popup_under_position_list#url_string##url_string2#&keyword=Z">Z</a></td>
        </cfoutput>
    </tr>
</table>
<cf_medium_list_search>
    <cf_medium_list_search_area>
        <cfform name="search" method="post" action="#request.self#?fuseaction=hr.popup_under_position_list#url_string#">
            <table>
                <tr>
                    <input type="hidden" name="up_emp_id" id="up_emp_id" value="<cfoutput>#attributes.up_emp_id#</cfoutput>">
                    <td><cf_get_lang dictionary_id='57460.Filtre'></td>
                    <td><cfinput type="text" name="keyword" value="#attributes.keyword#"></td>
                    <td>
                        <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
                        <select name="branch_id" id="branch_id" style="width:200px;">
                            <option value=""><cf_get_lang dictionary_id='29434.Şubeler'></option>
                            <cfoutput query="GET_BRANCHES">
                                <option value="#branch_id#"<cfif branch_id eq attributes.branch_id> selected</cfif>>#BRANCH_NAME#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" required="yes" value="#attributes.maxrows#" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
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
            <th width="20"></th>
            <th width="120"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
            <th width="120"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
            <th width="120"><cf_get_lang dictionary_id='57453.Şube'></th>
            <th width="80"><cf_get_lang dictionary_id='57572.Departman'></th>
            <th width="80"><cf_get_lang dictionary_id="33341.Gruba G. T."></th>
            <th width="15"></th>
        </tr>
    </thead>
    <tbody>
        <cfif get_positions.recordcount>
            <cfoutput query="get_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr>
                <td width="25" align="center">#currentrow#</td>
                <td>
                    <cfif not isdefined("url.trans")>
                        <a href="javascript:add_pos('#get_positions.EMPLOYEE_NAME# #get_positions.EMPLOYEE_SURNAME#','#get_positions.position_code#','#get_positions.employee_id#');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a>
                    <cfelse>
                        #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
                    </cfif>
                </td>
                <td>
                    <cfif isdefined("url.trans")>
                        <a href="javascript:add_pos('#get_positions.EMPLOYEE_NAME# #get_positions.EMPLOYEE_SURNAME#','#get_positions.position_code#','#get_positions.employee_id#');" class="tableyazi">#POSITION_NAME#</a>
                    <cfelse>
                        #POSITION_NAME#
                    </cfif>
                </td>
                <td>#BRANCH_NAME#</td>
                <td>#DEPARTMENT_HEAD#</td>
                <td>#dateformat(GROUP_STARTDATE,dateformat_style)#</td>
                <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&department_id=#DEPARTMENT_ID#&emp_id=#EMPLOYEE_ID#&pos_id=#POSITION_CODE#','medium','popup_emp_det');"><img src="/images/report_square2.gif" border="0"></a></td>
            </tr>
            </cfoutput>
        <cfelse>
            <tr> 
                <td colspan="7"><cfif arama_yapilmali eq 1><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
            </tr>
        </cfif>
    </tbody>
</cf_medium_list>
<cfif attributes.totalrecords gt attributes.maxrows>
<cfif len(attributes.keyword)>
	<cfset url_string = '#url_string#&keyword=#attributes.keyword#&up_emp_id=#attributes.up_emp_id#'>
</cfif>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
  <tr>
	<td>
	  <cf_pages page="#attributes.page#"
	    	maxrows="#attributes.maxrows#"
	    	totalrecords="#attributes.totalrecords#"
		   	startrow="#attributes.startrow#"
		    adres="hr.popup_under_position_list#url_string##url_string2#">
	</td>
    <td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

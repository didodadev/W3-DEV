<cf_get_lang_set module_name="hr">
<cfparam name="attributes.is_active" default=1>
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfset url_string = "">
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.is_all_departments")>
	<cfset url_string = "#url_string#&is_all_departments=1">
</cfif>
<cfif isdefined("attributes.is_only_sgk_departments")>
	<cfset url_string = "#url_string#&is_only_sgk_departments=1">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_branch_id")>
	<cfset url_string = "#url_string#&field_branch_id=#attributes.field_branch_id#">
</cfif>
<cfif isdefined("attributes.field_branch_name")>
	<cfset url_string = "#url_string#&field_branch_name=#attributes.field_branch_name#">
</cfif>
<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
	<cfset url_string = "#url_string#&branch_id=#url.branch_id#">
</cfif>
<cfif isdefined("without_department")>
	<cfset url_string = "#url_string#&without_department=#attributes.without_department#">
</cfif>
<cfif isdefined("field_our_company_id")>
	<cfset url_string = "#url_string#&field_our_company_id=#attributes.field_our_company_id#">
</cfif>
<cfif isdefined("field_our_company")>
	<cfset url_string = "#url_string#&field_our_company=#attributes.field_our_company#">
</cfif>
<!--- departmandaki yonetici1 ve 2 yi idari amir ve fonksiyonel amir olarak atamak icin eklenmistir. SG20121120--->
<cfif isdefined("field_manager1_poscode")>
	<cfset url_string = "#url_string#&field_manager1_poscode=#attributes.field_manager1_poscode#">
</cfif>
<cfif isdefined("field_manager1_pos")>
	<cfset url_string = "#url_string#&field_manager1_pos=#attributes.field_manager1_pos#">
</cfif>
<cfif isdefined("field_manager2_poscode")>
	<cfset url_string = "#url_string#&field_manager2_poscode=#attributes.field_manager2_poscode#">
</cfif>
<cfif isdefined("field_manager2_pos")>
	<cfset url_string = "#url_string#&field_manager2_pos=#attributes.field_manager2_pos#">
</cfif>
<cfif isdefined("attributes.run_function")>
	<cfset url_string = "#url_string#&run_function=#attributes.run_function#">
</cfif>
<cfset url_string = "#url_string#&is_form_submitted=1">
<cfquery name="GET_DEPARTMENTS" datasource="#dsn#">
	SELECT 
		D.DEPARTMENT_STATUS,
		D.DEPARTMENT_ID,
		D.BRANCH_ID,
		B.BRANCH_NAME,
		O.NICK_NAME,
		O.COMP_ID,
		D.DEPARTMENT_HEAD,
		D.ADMIN1_POSITION_CODE,
		(SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME+'-'+POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = D.ADMIN1_POSITION_CODE) AS ADMIN1_POSITION,
		D.ADMIN2_POSITION_CODE,
		(SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME+'-'+POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = D.ADMIN2_POSITION_CODE) AS ADMIN2_POSITION
	FROM 
		DEPARTMENT D,
		BRANCH B,
		OUR_COMPANY O
	WHERE 
		D.BRANCH_ID = B.BRANCH_ID AND
		B.COMPANY_ID = O.COMP_ID AND
		BRANCH_STATUS = 1
		AND D.IS_STORE <> 1
		<cfif isdefined("attributes.is_only_sgk_departments") and len(attributes.is_only_sgk_departments)>
		AND B.SSK_NO IS NOT NULL AND B.SSK_OFFICE IS NOT NULL
		</cfif>
		<cfif isdefined("attributes.search_our_company_id") and len(attributes.search_our_company_id)>
		AND O.COMP_ID = #attributes.search_our_company_id# 
		</cfif>
		<cfif attributes.is_active eq 1>
			AND	D.DEPARTMENT_STATUS = 1
			<cfelseif attributes.is_active eq 0>
			AND	D.DEPARTMENT_STATUS = 0
		<!--- 	<cfelse>
			AND (D.DEPARTMENT_STATUS = 1 OR D.DEPARTMENT_STATUS = 0) --->
		</cfif>
		<cfif not session.ep.ehesap and not isdefined("attributes.is_all_departments")>
		AND
		D.BRANCH_ID IN (
							SELECT
								BRANCH_ID
							FROM
								EMPLOYEE_POSITION_BRANCHES
							WHERE
								POSITION_CODE = #SESSION.EP.POSITION_CODE# AND
                                DEPARTMENT_ID IS NULL
							)
		</cfif>
	<cfif not isdefined("attributes.is_all_departments")>
		AND
		D.BRANCH_ID IS NOT NULL
	</cfif>
	<cfif isdefined("attributes.par_id") and len(attributes.par_id)>
		AND D.IS_STORE=1
	</cfif>
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		AND D.BRANCH_ID = #attributes.branch_id#
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND 
		(
		D.DEPARTMENT_HEAD LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
		OR
		B.BRANCH_NAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
		)
	</cfif>
	ORDER BY
		O.NICK_NAME,B.BRANCH_NAME,D.DEPARTMENT_HEAD
</cfquery>
<cfinclude template="../query/get_our_comp_name.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_departments.recordcount#">
<cfparam  name="attributes.modal_id" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
function gonder(id,alan,branch_id,branch,our_company,company,admin1_position_code,admin1_position,admin2_position_code,admin2_position)
	{
	<cfoutput>
	<cfif isdefined("field_id")>
	<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#field_id#.value = id;
	</cfif>
	<cfif isdefined("field_name")>
	<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#field_name#.value = alan;
	</cfif>
	<cfif isdefined("field_branch_id")>
	<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#field_branch_id#.value = branch_id;
	</cfif>
	<cfif isdefined("field_branch_name")>
	<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#field_branch_name#.value = branch;
	</cfif>
	<cfif isdefined("field_our_company_id")>
	<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#field_our_company_id#.value = our_company;
	</cfif>
	<cfif isdefined("field_our_company")>
	<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#field_our_company#.value = company;
	</cfif>
	//departmandaki yonetici1 ve 2 yi idari amir ve fonksiyonel amir olarak atamak icin eklenmistir. SG20121120
	<cfif isdefined("field_manager1_poscode")>
	<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#field_manager1_poscode#.value = admin1_position_code;
	</cfif>
	<cfif isdefined("field_manager1_pos")>
	<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#field_manager1_pos#.value = admin1_position;
	</cfif>
	<cfif isdefined("field_manager2_poscode")>
	<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#field_manager2_poscode#.value = admin2_position_code;
	</cfif>
	<cfif isdefined("field_manager2_pos")>
	<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#field_manager2_pos#.value = admin2_position;
	</cfif>
	<cfif isdefined("attributes.run_function")>
		window.<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#run_function#;
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>	
	</cfoutput>
	}
	
	function gonder2(branch_id,branch)
	{
	<cfoutput>
	<cfif isdefined("field_id")>
	<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#field_id#.value='';
	</cfif>
	<cfif isdefined("field_name")>
	<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#field_name#.value='';
	</cfif>
	<cfif isdefined("field_branch_id")>
	<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#field_branch_id#.value = branch_id;
	</cfif>
	<cfif isdefined("field_branch_name")>
	<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#field_branch_name#.value = branch;
	</cfif>
	</cfoutput>
	}
</script>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="47042">
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#message#" scroll="0" collapsable="1" resize="1"  popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<!--- <table class="harfler">
			<tr>
				<td>
					<cfoutput>
						<td>&nbsp;</td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#"></a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=A">A</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=B">B</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=C">C</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=Ç">Ç</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=D">D</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=E">E</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=F">F</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=G">G</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=Ğ">Ğ</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=H">H</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=I">I</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=İ">İ</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=J">J</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=K">K</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=L">L</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=M">M</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=N">N</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=O">O</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=Ö">Ö</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=P">P</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=Q">Q</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=R">R</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=S">S</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=Ş">Ş</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=T">T</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=U">U</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=Ü">Ü</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=V">V</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=W">W</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=Y">Y</a></td>
						<td><A href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#&keyword=Z">Z</a></td>
						<td>&nbsp;</td>
					</cfoutput>
				</td>
			</tr>
		</table> --->
		<cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform action="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#" method="post" name="search">
			<cf_box_search title="#getLang(105,'Departmanlar',55190)#" more="0">
				<cfinput type="hidden" name="is_form_submitted" value="1">
				<div class="form-group">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getLang('main',48)#" maxlength="50">
				</div>
				<div class="form-group">
					<select name="search_our_company_id" id="search_our_company_id">
						<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
						<cfoutput query="get_company_name">
							<option value="#comp_id#" <cfif isdefined("attributes.search_our_company_id") and attributes.search_our_company_id eq comp_id>selected</cfif>>#nick_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="is_active" id="is_active" style="width:50px;">
						<option value="1" <cfif attributes.is_active is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
						<option value="0" <cfif attributes.is_active is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>
						<option value="2" <cfif attributes.is_active is 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group"><cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#"></div>          
			</cf_box_search>
		</cfform>
		<cf_flat_list>
			<cfif len(attributes.keyword)>
				<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isdefined("attributes.search_our_company_id")>
				<cfset url_string = "#url_string#&search_our_company_id=#attributes.search_our_company_id#">
			</cfif>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='57572.Departman'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_departments.recordcount and form_varmi eq 1>
				<cfoutput query="get_departments" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#nick_name#</td>
						<td>
						<cfif isdefined("without_department")>
							<a href="javascript://" onClick="gonder2('#branch_id#','#BRANCH_NAME#');<cfif not isdefined("attributes.draggable")>window.close();</cfif>">#BRANCH_NAME#</a>
						<cfelse>
							<a href="javascript://" onClick="gonder('#department_id#','#department_head#','#branch_id#','#BRANCH_NAME#','#comp_id#','#NICK_NAME#','#admin1_position_code#','#admin1_position#','#admin2_position_code#','#admin2_position#');<cfif not isdefined("attributes.draggable")>window.close();</cfif>">#BRANCH_NAME#</a>
						</cfif>
						</td>
						<td><a href="javascript://" onClick="gonder('#department_id#','#department_head#','#branch_id#','#BRANCH_NAME#','#comp_id#','#NICK_NAME#','#admin1_position_code#','#admin1_position#','#admin2_position_code#','#admin2_position#');<cfif not isdefined("attributes.draggable")>window.close();</cfif>">#DEPARTMENT_HEAD#</a></td>
					</tr>
				</cfoutput>
				<cfelse>
				<tr>
					<td colspan="3"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
				</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
			<cfif attributes.totalrecords gt attributes.maxrows>
				<cfset url_string = "#url_string#&is_form_submitted=1">
				<cfif len(attributes.keyword)>
					<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
				</cfif>
				<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
					<cfset url_string = '#url_string#&draggable=#attributes.draggable#'>
				</cfif>
					<cf_paging page="#attributes.page#"
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="#ListFirst(attributes.fuseaction,'.')#.popup_list_departments#url_string#"
					isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
			</cfif>	
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

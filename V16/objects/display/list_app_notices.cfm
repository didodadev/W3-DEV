<cfif isDefined("attributes.STARTDATE") and len(attributes.STARTDATE)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif isDefined("attributes.FINISHDATE") and len(attributes.FINISHDATE)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<cfparam name="attributes.modal_id" default="">
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
		1=1
		<cfif IsDefined('attributes.status') and len(attributes.status)>
			AND STATUS = #attributes.status#
		</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND (NOTICE_HEAD LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%' 
				OR 
				NOTICE_NO LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%')
		</cfif>
		<cfif isDefined("attributes.STARTDATE") and len(attributes.STARTDATE)>
			AND STARTDATE >= #attributes.STARTDATE#
		</cfif>
		<cfif isDefined("attributes.FINISHDATE") and len(attributes.FINISHDATE)>
		   AND FINISHDATE <= #attributes.FINISHDATE#
		</cfif>
		<cfif len(attributes.company) and len(attributes.company_id)>
		   AND COMPANY_ID=#attributes.company_id#
		</cfif>
	</cfquery>
	<cfparam name="attributes.totalrecords" default="#get_notices.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfoutput>
<script type="text/javascript">
function add_pos(notice_id,notice_head,notice_no,company_name,company_id,department,department_id,branch,branch_id,our_company_id,our_company_name,position_id,position_name,position_cat_id,position_cat_name)
{
	<cfif isdefined("attributes.field_name")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.field_name#</cfoutput>.value = notice_head;
	</cfif>
	<cfif isdefined("attributes.field_id")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.field_id#</cfoutput>.value = notice_id;
	</cfif>
	<cfif isdefined("attributes.field_no")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.field_no#</cfoutput>.value = notice_no;
	</cfif>
	<cfif isdefined("attributes.field_comp") and isdefined("attributes.field_comp_id")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.field_comp#</cfoutput>.value = company_name;
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.field_comp_id#</cfoutput>.value = company_id;
	</cfif>
	<cfif isdefined("attributes.field_department_id") and isdefined("attributes.field_department")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.field_department_id#</cfoutput>.value = department_id;
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.field_department#</cfoutput>.value = department;
	</cfif>
	<cfif isdefined("attributes.field_branch_id") and isdefined("attributes.field_branch")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.field_branch_id#</cfoutput>.value = branch_id;
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.field_branch#</cfoutput>.value =branch;
	</cfif>	
	<cfif isdefined("attributes.field_our_company_id")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.field_our_company_id#</cfoutput>.value = our_company_id;
	</cfif>	
	<cfif isdefined("attributes.field_our_company_name")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.field_our_company_name#</cfoutput>.value = our_company_name;
	</cfif>	
	<cfif isdefined("attributes.field_pos_id")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.field_pos_id#</cfoutput>.value = position_id;
	</cfif>
	<cfif isdefined("attributes.field_pos_name")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.field_pos_name#</cfoutput>.value = position_name;
	</cfif>
	<cfif isdefined("attributes.field_pos_cat_id")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.field_pos_cat_id#</cfoutput>.value = position_cat_id;
	</cfif>
	<cfif isdefined("attributes.field_pos_cat_name")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.field_pos_cat_name#</cfoutput>.value = position_cat_name;
	</cfif>
	<cfif not isdefined("attributes.draggable")>
		window.close();
	<cfelse>
		closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
	</cfif>
	
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
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','İk İlanları',55174)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" closable="1">
		<cfform action="#request.self#?fuseaction=objects.popup_list_notices#url_string#" method="post" name="search">
			<input name="form_varmi" id="form_varmi" value="1" type="hidden">
			<cfif isdefined("attributes.draggable")>
				<input name="draggable" id="draggable" value="1" type="hidden">
			</cfif>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='32748.İlanlar'></cfsavecontent>
			<cf_box_search more="1">
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#message#" maxlength="50">
				</div>
				<div class="form-group" id="item-status">
					<select name="status" id="status">
						<option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
						<option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>
						<option value="" <cfif not len(attributes.status)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>			                        
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
					<cf_wrk_search_button button_type="4" search_function="control_popup() && loadPopupBox('search', #attributes.modal_id#)">
				</div>
			</cf_box_search>
			<cf_box_search_detail search_function="loadPopupBox('search', #attributes.modal_id#)"> 
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<div class="form-group" id="item-startdate">
						<div class="input-group">
							<input type="text" name="startdate" id="startdate"  style="width:65px;" value="<cfoutput>#dateformat(attributes.startdate,dateformat_style)#</cfoutput>">
							<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<div class="form-group" id="item-finishdate">
						<div class="input-group">
							<input type="text" name="finishdate" id="finishdate" value="<cfoutput>#dateformat(attributes.finishdate,dateformat_style)#</cfoutput>" style="width:65px;" >
							<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span> 
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<div class="form-group" id="item-finishdate">
						<div class="input-group">
							<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
							<input type="text" placeholder="<cfoutput>#getlang('','Kurumsal Üyeler',29408)#</cfoutput>" name="company" id="company" style="width:135px;" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>">
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=search.company&field_comp_id=search.company_id&select_list=2&keyword='+encodeURIComponent(document.search.company.value),'list');"></span> 
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
		<cfscript>
			url_string = '#url_string#&status=#attributes.status#&company_id=#attributes.company_id#&company=#attributes.company#';
			url_string = '#url_string#&startdate=#dateformat(attributes.startdate,dateformat_style)#';
			url_string = '#url_string#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#';
			if (len(attributes.keyword)) url_string = "#url_string#&keyword=#attributes.keyword#";
		</cfscript>
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='33331.İlan Kodu'></th>
					<th><cf_get_lang dictionary_id='33330.İlan'></th>
					<th width="100"><cf_get_lang dictionary_id='59004.Poziyon Tipi'></th>
					<th width="100"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
					<th width="65"><cf_get_lang dictionary_id='58607.Firma'></th>
					<th width="65"><cf_get_lang dictionary_id='57501.Başlama'></th>
					<th width="65"><cf_get_lang dictionary_id='57502.Bitiş'></th>
				</tr>
			</thead>
			<tbody>
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
							OUR_COMPANY.COMP_ID=#get_notices.our_company_id#
							AND BRANCH.COMPANY_ID=#get_notices.our_company_id#
							AND	BRANCH.BRANCH_ID=DEPARTMENT.BRANCH_ID
							AND BRANCH.BRANCH_ID=#get_notices.branch_id#
							AND DEPARTMENT.DEPARTMENT_ID=#get_notices.department_id#
						</cfquery>
					</cfif>
					<tr>
						<td><a href="javascript://" onClick="add_pos('#NOTICE_ID#','#NOTICE_NO#-#NOTICE_HEAD#','#NOTICE_NO#','#COMPANY#','#COMPANY_ID#'<cfif IsDefined('GET_OUR_COMPANY') and GET_OUR_COMPANY.recordcount>,'#GET_OUR_COMPANY.department_head#','#get_notices.department_id#','#GET_OUR_COMPANY.branch_name#','#get_notices.branch_id#','#get_notices.our_company_id#','#GET_OUR_COMPANY.NICK_NAME#'<cfelse>,'','','','','',''</cfif>,'#get_notices.position_id#','#get_notices.position_name#','#get_notices.position_cat_id#','#get_notices.position_cat_name#');" class="tableyazi">#notice_no#</a></td>
						<td><a href="javascript://" onClick="add_pos('#NOTICE_ID#','#NOTICE_NO#-#NOTICE_HEAD#','#NOTICE_NO#','#COMPANY#','#COMPANY_ID#'<cfif IsDefined('GET_OUR_COMPANY') and GET_OUR_COMPANY.recordcount>,'#GET_OUR_COMPANY.department_head#','#get_notices.department_id#','#GET_OUR_COMPANY.branch_name#','#get_notices.branch_id#','#get_notices.our_company_id#','#GET_OUR_COMPANY.NICK_NAME#'<cfelse>,'','','','','',''</cfif>,'#get_notices.position_id#','#get_notices.position_name#','#get_notices.position_cat_id#','#get_notices.position_cat_name#');" class="tableyazi">#notice_head#</a></td>
						<td>
							<cfif len(POSITION_CAT_ID)>
								<cfset attributes.POSITION_CAT_ID = POSITION_CAT_ID>
								<cfquery name="GET_POSITION_CAT" datasource="#dsn#">
									SELECT 
										* 
									FROM 
										SETUP_POSITION_CAT 
									WHERE 
										POSITION_CAT_ID IN (#ListSort(attributes.POSITION_CAT_ID,"numeric")#)
								</cfquery>
								<cfset POSITION_CAT = "#GET_POSITION_CAT.POSITION_CAT#">
							<cfelse>
								<cfset POSITION_CAT = "-">
							</cfif>
							#position_cat#
						</td>
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
									EMPLOYEE_POSITIONS.POSITION_CODE = #POSITION_ID#
							</cfquery>
								<cfset app_position = "#get_position_name.position_name# - #get_position_name.employee_name# #get_position_name.employee_surname#">
							<cfelse>
								<cfset app_position = "-">
							</cfif>
							#app_position#					  
						</td>
						<!---TolgaS 20051226 surun olmazsa 60 güne siline bilir<td><cfif len(get_notices.company_id)>#get_company.fullname#</cfif></td> --->
						<td><cfif len(get_notices.company)>#get_notices.company#</cfif></td>
						<td><cfif len(STARTDATE)>#dateformat(STARTDATE,dateformat_style)#</cfif></td>
						<td><cfif len(FINISHDATE)>#dateformat(FINISHDATE,dateformat_style)#</cfif></td>
					</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="7"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
						</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
			<cfif attributes.totalrecords gt attributes.maxrows>
				<cfif isdefined("attributes.form_varmi")>
					<cfset url_string = "#url_string#&form_varmi=#attributes.form_varmi#" >
				</cfif>
				<cf_paging 
					page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="objects.popup_list_notices#url_string#"
					isAjax = "#iif(isdefined("attributes.draggable"),1,0)#"> 
			</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	function control_popup() {
		date_check(search.startdate,search.finishdate,'<cfoutput>#message_date#</cfoutput>');
		<cfif isDefined("attributes.draggable")>
			loadPopupBox('search' , <cfoutput>#attributes.modal_id#</cfoutput>);
		</cfif>
	}
	document.getElementById('keyword').focus();
</script>

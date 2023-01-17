<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.type" default="0">

<cfquery name="get_list" datasource="#dsn#">
	SELECT 
		EL.LIST_ID, EL.LIST_NAME, EL.LIST_DETAIL, EL.LIST_STATUS, EL.NOTICE_ID, EL.OUR_COMPANY_ID, EL.DEPARTMENT_ID, EL.BRANCH_ID, EL.COMPANY_ID, EL.RECORD_DATE, EL.RECORD_EMP, COUNT( ER.LIST_ROW_ID) SATIR_SAYISI 
	FROM 
		EMPLOYEES_APP_SEL_LIST EL, 
		EMPLOYEES_APP_SEL_LIST_ROWS ER 
	WHERE 
		ER.LIST_ID=EL.LIST_ID
		<cfif len(attributes.keyword)>
		  AND EL.LIST_NAME LIKE '#attributes.keyword#%'
		</cfif>
		<cfif len(attributes.status)>
		  AND EL.LIST_STATUS=#attributes.status#
		</cfif>
	GROUP BY 
		EL.LIST_ID, EL.LIST_NAME, EL.LIST_DETAIL, EL.LIST_STATUS, EL.NOTICE_ID, EL.OUR_COMPANY_ID, EL.DEPARTMENT_ID, EL.BRANCH_ID, EL.COMPANY_ID, EL.RECORD_DATE, EL.RECORD_EMP ORDER BY EL.LIST_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_list.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "&field_name=#attributes.field_name#&field_id=#attributes.field_id#">
<cfset url_field = "&field_name=#attributes.field_name#&field_id=#attributes.field_id#">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55276.Seçim Listeleri"></cfsavecontent>
<cf_box_search>
	<cfform name="list_app" id="list_app" action="#request.self#?fuseaction=hr.popup_list_select_list#url_str#" method="post"> 
		<cfif isdefined("attributes.type") and attributes.type eq 1>
			<cfinput type="hidden" name="type" value="#attributes.type#">
		</cfif>
		<div class="form-group">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
			<cfsavecontent variable="message1"><cf_get_lang dictionary_id="40906.Geçerlilik"></cfsavecontent>
			<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" message="#message1#" maxlength="50" placeholder="#message#">
		</div>
		<div class="form-group">
			<select name="status" id="status">
				<option value="" <cfif not len(attributes.status)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>
				<option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
				<option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>
			</select>
		</div>
		<div class="form-group small">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
			<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
		</div>
		<div class="form-group">
			<cf_wrk_search_button button_type="4" search_function="control_ajax()">	
		</div>
	</cfform>
</cf_box_search>
	<cf_flat_list>
		<thead>
			<tr>
				<th width="125"><cf_get_lang dictionary_id='57509.Liste'></th>
				<th width="20"><cf_get_lang dictionary_id='56213.Aday'></th>
				<th><cf_get_lang dictionary_id='55159.İlan'></th>
				<th width="100"><cf_get_lang dictionary_id='57453.Şube'></th>
				<th width="100"><cf_get_lang dictionary_id='57585.Kurumsal Üye'></th>
				<th width="100"><cf_get_lang dictionary_id='57899.Kaydeden'></th>
				<th width="55"><cf_get_lang dictionary_id='57742.Tarih'></th>
				<th width="50"><cf_get_lang dictionary_id='57756.Durum'></th>
				<th><input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','list_id');"></th>
			</tr>
		</thead>
		<tbody>
		<cfif get_list.recordcount>
			<cfoutput query="get_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfset name_ = replace(get_list.list_name,"'"," ","ALL")>
			<tr>
				<td><a href='javascript://' onClick='add_list__("#name_#","#get_list.list_id#");' class='tableyazi'>#get_list.list_name#</a></td>
				<td>#get_list.SATIR_SAYISI#</td>
				<td><cfif len(get_list.notice_id)>
					<cfquery name="get_notice" datasource="#DSN#">
					SELECT NOTICE_HEAD,NOTICE_NO FROM NOTICES WHERE NOTICE_ID=#get_list.notice_id#
					</cfquery>
					#get_notice.notice_no#/#get_notice.notice_head#
					</cfif>
				</td>
				<td><cfif len(get_list.department_id) and len(get_list.our_company_id) and Len(get_list.branch_id)>
					<cfquery name="get_branch" datasource="#dsn#">
					SELECT BRANCH.BRANCH_NAME FROM BRANCH WHERE BRANCH.BRANCH_ID=#get_list.branch_id#
					</cfquery>
					#get_branch.branch_name#
					</cfif>
				</td>
				<td><cfif len(get_list.company_id)>
					<cfquery name="get_company" datasource="#dsn#">
					SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID=#get_list.company_id#
					</cfquery>
					#get_company.fullname#
					</cfif>
				</td>
				<td>#get_emp_info(get_list.record_emp,0,1)#</td>
				<td>#dateformat(get_list.record_date,dateformat_style)#</td>
				<td><cfif get_list.list_status eq 1>
						<cf_get_lang dictionary_id='57493.Aktif'>
					<cfelse>
						<cf_get_lang dictionary_id='57494.Pasif'>
					</cfif>
				</td>
				<td><input type="checkbox" value="#get_list.list_id#" id="list_id#currentrow#" name="list_id"></td>
			</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
			</tr>
		</cfif>
		</tbody>
	</cf_flat_list>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#&status=#attributes.status#">
	<cfif isdefined("attributes.draggable")>
		<cfset url_str = "#url_str#&draggable=#attributes.draggable#&modal_id=#attributes.modal_id#">
	</cfif>
	<cfif attributes.maxrows lt attributes.totalrecords>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="hr.popup_list_select_list#url_str#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#"
			target="list_div"
			>
	</cfif>
<script type="text/javascript">
	function add_list_(list_name,list_id)
	{
		<cfif isdefined("attributes.field_name")>
			<cfif not(isdefined("attributes.draggable"))>opener.</cfif><cfoutput>#field_name#</cfoutput>.value = list_name;
		</cfif>
		<cfif isdefined("attributes.field_id")>
			<cfif not(isdefined("attributes.draggable"))>opener.</cfif><cfoutput>#field_id#</cfoutput>.value = list_id;
		</cfif>
		<cfif not(isdefined("attributes.draggable"))>window.close();<cfelse>closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);</cfif>
	}

	function control_ajax()
	{
		<cfif attributes.type eq 1>
			var form_url = 'keyword=' + $('#keyword').val() + '&status=' + $('#status').val() + '&maxrows=' + $('#maxrows').val() ;
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=hr.popup_list_select_list&#url_field#&'+form_url+'<cfif isdefined("attributes.draggable")>&draggable=#attributes.draggable#&modal_id=#attributes.modal_id#</cfif>&empapp_id=#Replace(attributes.empapp_id,',','')#<cfif isdefined("attributes.type") and attributes.type eq 1>&type=#attributes.type#</cfif></cfoutput>','list_div');			
		<cfelse>
			return true;
		</cfif>
	}
</script>

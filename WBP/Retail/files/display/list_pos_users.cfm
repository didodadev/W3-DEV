<cfparam name="attributes.row_id" default="">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.pos_type" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.mode" default='4'>
<cfparam name="attributes.keyword" default="">

<cfif isdefined("attributes.is_form_submit")>
	<cfset wrk = createObject("component","wbp.retail.files.cfc.get_user")>
    <cfset get_users = wrk.select(
		keyword             :   attributes.keyword,
		branch             :   attributes.branch,
		pos_type             :   attributes.pos_type,
		employee_id: attributes.emp_id ,
        employee_name: attributes.emp_name ,
		dsn_dev : dsn_dev
    )>
<cfelse> 
	<cfset get_users.recordcount = 0>
</cfif> 
<cfparam name="attributes.totalrecords" default='#get_users.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT DISTINCT
		B.BRANCH_ID, 
		B.BRANCH_NAME 
	FROM 
		BRANCH B,
        DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        D.BRANCH_ID = B.BRANCH_ID AND
        D.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	ORDER BY 
		B.BRANCH_NAME
</cfquery>

<cfquery name="GET_POS_USERS" datasource="#dsn_dev#">
	SELECT
		PU.*,
        E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME
	FROM
		POS_USERS PU,
        #dsn_alias#.EMPLOYEES E
	WHERE
		E.EMPLOYEE_ID = PU.EMPLOYEE_ID AND
        PU.EMPLOYEE_ID IS NOT NULL
</cfquery>

<cfform name="form_pos_list" id="form_pos_list" method="post" action="#request.self#?fuseaction=retail.list_pos_users">
	<input type="hidden" name="is_form_submit" id="is_form_submit" value="1">
	<cf_box>
		<cf_box_search>
			<div class="form-group large" id="form_ul_employee_id">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57930.Kullanıcı'></cfsavecontent>
				<div class="input-group">
					<cfoutput>
						<input type="hidden" name="emp_id" id="emp_id" value="<cfif isdefined('attributes.emp_id') and len(attributes.emp_name)><cfoutput>#attributes.emp_id#</cfoutput></cfif>">
						<input type="text" name="emp_name" value="" placeholder="#message#" id="emp_name" style="width:200px;" autocomplete="off" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','MEMBER_NAME,MEMBER_ID','employee_name,employee_id','emp_puantaj','3','300');">
						<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_emps&is_period_kontrol=0&field_location=service&field_id=form_pos_list.emp_id&field_name=form_pos_list.emp_name&select_list=1</cfoutput>');"></span>
					</cfoutput>
				</div>												
			</div>
			<div class="form-group large">
				<div class="col col-12 col-xs-12">
					<select name="pos_type" id="pos_type" class="formthin">
						<option value="" selected><cf_get_lang dictionary_id='38925.Kullanıcı Tipi'>
						<option value="1" <cfif attributes.pos_type eq 1>selected</cfif>><cf_get_lang dictionary_id='29511.Yönetici'></option>
						<option value="2" <cfif attributes.pos_type eq 2>selected</cfif>><cf_get_lang dictionary_id='61713.Standart Kullanıcı'></option>
					</select>
				</div>
			</div>
			<div class="form-group large">
				<div class="col col-12 col-xs-12">
					<input type="hidden" name="hier" id="hier" value="">
					<input type="hidden" name="procat" id="procat" value="">
					<select name="branch" id="branch" class="formthin">
						<option value="" selected><cf_get_lang dictionary_id='57453.Şube'>
						<cfoutput  query="get_branch">
							<option value="#branch_id#"<cfif  attributes.branch eq branch_id > selected</cfif>>#branch_name#</option>
						</cfoutput>
					</select>
				</div>
			</div>
			<div class="form-group" id="form_ul_maxrows">
                <div class="input-group x-3_5">
                <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
                </div>
            </div>
			<div class="form-group" id="form_ul_search">
                    <cf_wrk_search_button button_type="4">
            </div>
		</cf_box_search>
	</cf_box>
</cfform>



<cfsavecontent variable="head"><cf_get_lang dictionary_id='61712.Yazar Kasa Kullanıcıları'></cfsavecontent>
<cf_box title="#head#">
	<cf_grid_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57453.Şube'></th>
				<th><cf_get_lang dictionary_id='57930.Kullanıcı'></th>
				<th><cf_get_lang dictionary_id='38925.Kullanıcı Tipi'></th>
				<th><cf_get_lang dictionary_id='58522.Kullanıcı Kodu'></th>
				<th><cf_get_lang dictionary_id='57756.Durum'></th>
				<th width="20">
					<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=retail.list_pos_users&event=add&branch_id=#BRANCH_ID#');"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a>
				</th>
			</tr>
		</thead>
		<tbody>
			<cfif get_users.recordcount>
				<cfoutput query="get_users" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>
							#branch_name#
						</td>
						<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
						<td>
							<cfif #POS_TYPE# eq 1>
								<cf_get_lang dictionary_id='29511.Yönetici'>
							<cfelseif #POS_TYPE# eq 2>
								<cf_get_lang dictionary_id='61713.Standart Kullanıcı'>
							</cfif>
						</td>
						<td>#USERNAME#</td>
						<td>
							<cfif #EMPLOYEE_STATUS# eq 1>
                                <cf_get_lang_main no='81.Aktif'>
                            <cfelseif #EMPLOYEE_STATUS# eq 0>
                                <cf_get_lang_main no='82.Pasif'>
                            </cfif>							
						</td>
						<td>
                            <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=retail.list_pos_users&event=upd&row_id=#row_id#');" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
						</td>
					</tr>				
				</cfoutput>
			<cfelse>
                <tr>
                    <td colspan="7"><cfif isdefined("attributes.is_form_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '>!</cfif></td>
                </tr>
			</cfif>			
		</tbody>
	</cf_grid_list>
	<cfset url_str = "&is_form_submit=1">
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfset url_str = "">
		<cfif isdefined("attributes.is_form_submit")>
			<cfset url_str = "#url_str#&is_form_submit=#attributes.is_form_submit#">
		</cfif>
		
		<cfif len(attributes.keyword)>
            <cfset url_str = url_str & "&keyword=#attributes.keyword#">
        </cfif>
		<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="retail.list_pos_users#url_str#&is_form_submit=#attributes.is_form_submit#">			
	</cfif>
</cf_box>

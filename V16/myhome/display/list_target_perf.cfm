<cfparam name="attributes.position_cat_id" default=''>
<cfparam name="attributes.emp_status" default=1>
<cfparam name="attributes.eval_date" default="">
<cfparam name="attributes.period_year" default="#session.ep.period_year#">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch_name" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.is_form_submit" default="0">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.eval_date)>
	<cf_date tarih = "attributes.eval_date">
</cfif>
<cfscript>
	if (not len(attributes.period_year) and attributes.is_form_submit)
		attributes.period_year = session.ep.period_year;
	url_str = "";
	if (attributes.is_form_submit)
		url_str = '#url_str#&is_form_submit=#attributes.is_form_submit#';
	if (len(attributes.keyword))
		url_str = "#url_str#&keyword=#attributes.keyword#";
	if (len(attributes.department_id))
		url_str = "#url_str#&department_id=#attributes.department_id#";
	if (len(attributes.department_name))
		url_str = "#url_str#&department_name=#attributes.department_name#";
	if (len(attributes.branch_name))
		url_str="#url_str#&branch_name=#attributes.branch_name#";
	if (len(attributes.branch_id))
		url_str="#url_str#&branch_id=#attributes.branch_id#";
	if (isdefined("attributes.position_cat_id"))
		url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#";
	if (len(attributes.eval_date) gt 9)
		url_str = "#url_str#&eval_date=#dateformat(attributes.eval_date,dateformat_style)#";
	if (isdefined("attributes.period_year"))
		url_str = "#url_str#&period_year=#attributes.period_year#";
	if (isdefined("attributes.attenders"))
		url_str = "#url_str#&attenders=#attributes.attenders#";
	if (isdefined('emp_status'))
		url_str = '#url_str#&emp_status=#attributes.emp_status#';
</cfscript>
<cfinclude template="../query/get_position_cats.cfm">
<cfif attributes.is_form_submit>
	<cfquery name="get_emp_pos" datasource="#dsn#">
		SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	</cfquery>
	<cfset position_list=valuelist(get_emp_pos.position_code,',')>
	<cfinclude template="../query/get_emp_codes.cfm">
	<cfquery name="get_performans" datasource="#dsn#">
	SELECT
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
		EMPLOYEE_POSITIONS.POSITION_CAT_ID,
		EMPLOYEE_POSITIONS.DEPARTMENT_ID,
		EP.*
	FROM 
		EMPLOYEE_PERFORMANCE_TARGET EPT,
		EMPLOYEE_PERFORMANCE EP,
		EMPLOYEE_POSITIONS
	WHERE
		 EMPLOYEE_POSITIONS.EMPLOYEE_ID=EP.EMP_ID AND
		 EMPLOYEE_POSITIONS.POSITION_CODE=EP.POSITION_CODE AND 
		 EP.PER_ID=EPT.PER_ID AND
         (EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> OR EPT.FIRST_BOSS_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> OR
         EPT.SECOND_BOSS_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		 <!---(
			EP.POSITION_CODE=#session.ep.position_code# <!--- AND EMP_VALID_FORM IS NULL --->
			<!--- Bu kısım Hedef Yetkinlik formunun  onaylanmamışlarını getirir. M.ER--->
			OR FIRST_BOSS_CODE = #session.ep.position_code# <!--- AND FIRST_BOSS_VALID_FORM IS NULL AND EMP_VALID_FORM = 1 --->
			OR (SECOND_BOSS_CODE = #session.ep.position_code# AND SECOND_BOSS_VALID_FORM IS NULL AND FIRST_BOSS_VALID_FORM = 1)
			OR (THIRD_BOSS_CODE = #session.ep.position_code# AND THIRD_BOSS_VALID_FORM IS NULL AND SECOND_BOSS_VALID_FORM = 1)
			OR (FOURTH_BOSS_CODE = #session.ep.position_code# AND FOURTH_BOSS_VALID_FORM IS NULL AND THIRD_BOSS_VALID_FORM = 1)
			OR (FIFTH_BOSS_CODE = #session.ep.position_code# AND FIFTH_BOSS_VALID_FORM IS NULL AND FOURTH_BOSS_VALID_FORM = 1)
			<!--- Bu alt kısım Hedef Yetkinlik değerlendirme sonuçlarının onaylanmamışlarını getirir. M.ER--->
			OR (SECOND_BOSS_CODE = #session.ep.position_code# AND SECOND_BOSS_VALID IS NULL AND FIRST_BOSS_VALID = 1)
			OR (THIRD_BOSS_CODE = #session.ep.position_code# AND THIRD_BOSS_VALID IS NULL AND SECOND_BOSS_VALID = 1)
			OR (FOURTH_BOSS_CODE = #session.ep.position_code# AND FOURTH_BOSS_VALID IS NULL AND THIRD_BOSS_VALID = 1)
			OR (FIFTH_BOSS_CODE = #session.ep.position_code# AND FIFTH_BOSS_VALID IS NULL AND FOURTH_BOSS_VALID = 1)
		)--->
			<cfif len(attributes.period_year)>AND YEAR(START_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_year#"></cfif>
			<cfif len(attributes.department_id)>AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"></cfif>
			<cfif len(attributes.position_cat_id)>AND EMPLOYEE_POSITIONS.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#"></cfif>
			<cfif len(attributes.eval_date)>AND EVAL_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.eval_date#"></cfif>
			<cfif len(attributes.keyword)>AND (EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)</cfif>
	</cfquery>
<cfelse>
	<cfset get_performans.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_performans.recordcount#'>
<cfform name="search" method="post" action="#request.self#?fuseaction=myhome.list_target_perf">
<input type="hidden" name="is_form_submit" id="is_form_submit" value="1">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57951.Hedef'> <cf_get_lang dictionary_id='31456.Yetkinlik Değerlendirme'></cfsavecontent>
<cf_big_list_search title="#message#">
	<cf_big_list_search_area>
		<div class="row form-inline">
			<div class="form-group" id="keyword">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
				<cfinput type="text" name="keyword" id="keyword" style="width:100px;" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
			</div>
			<div class="form-group" id="item-eval_date">
                <div class="input-group x-16">
					<cfif len(attributes.eval_date) gt 9>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='31401.Değerlendirme Tarihi'></cfsavecontent>
						<cfinput type="text" name="eval_date" placeholder="#message#" value="#dateformat(attributes.eval_date,dateformat_style)#" validate="#validate_style#" style="width:65px;" message="<cf_get_lang dictionary_id='31419.Değerlendirme Tarihi girilmelidir'>!">
					<cfelse>
						<cfinput type="text" name="eval_date" placeholder="#message#" value="" validate="#validate_style#" style="width:65px;" message="<cf_get_lang dictionary_id='31419.Değerlendirme Tarihi girilmelidir'>!">
					</cfif>
					<span class="input-group-addon"><cf_wrk_date_image date_field="eval_date"></span>
				</div>
			</div>	
			<div class="form-group x-3_5">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
			</div>
			<div class="form-group">
				<cf_wrk_search_button search_function='kontrol()'>
			</div>
			<cf_workcube_file_action pdf='0' mail='0' doc='0' print='1'>
		</div>
	</cf_big_list_search_area>
	<cf_big_list_search_detail_area>
		<div class="row">    
            <div class="col col-12 form-inline">
				<div class="form-group" id="branch_name">
					<input type="hidden" name="branch_id" id="branch_id" maxlength="50" value="<cfoutput>#attributes.branch_id#</cfoutput>">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57572.Departman'></cfsavecontent>
					<input type="text" name="branch_name" id="branch_name" maxlength="50" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.branch_name#</cfoutput>" style="width:120px;">
				</div>
				<div class="form-group" id="item-department_name">
                	<div class="input-group x-12">
						<input type="hidden" name="department_id" id="department_id" maxlength="50" value="<cfoutput>#attributes.department_id#</cfoutput>">
						<cfinput type="text" name="department_name" maxlength="50" value="#attributes.department_name#" style="width:100px;">
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_departments&field_id=search.department_id&field_name=search.department_name&branch_id=search.branch_id&branch_name=search.branch_name&without_department</cfoutput>&keyword='+encodeURIComponent(document.search.department_name.value),'list');"></span>
					</div>
				</div>	
				<div class="form-group" id="item-position_cat_id">
                	<div class="input-group x-24">
						<select name="position_cat_id" id="position_cat_id" style="width:150px;">
						<option value=""><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></option>
						<cfoutput query="get_position_cats">
							<option value="#position_cat_id#" <cfif attributes.position_cat_id eq position_cat_id>selected</cfif>>#position_cat#</option>
						</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-period_year">
                	<div class="input-group x-8">		
							<select name="period_year" id="period_year" style="width:50px;">
							<cfloop from="#year(now())+1#" to="2002" index="yr" step="-1">
								<option value="<cfoutput>#yr#</cfoutput>" <cfif isdefined('attributes.period_year') and (yr eq attributes.period_year)>selected</cfif>><cfoutput>#yr#</cfoutput></option>
							</cfloop>
						</select>
					</div>
				</div>
			</div>
		</div>	
	</cf_big_list_search_detail_area>
</cf_big_list_search>
</cfform>
<cf_big_list> 
	<thead>
		<tr>
			<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th><cf_get_lang dictionary_id='57576.Çalışan'></th>
			<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
			<th width="130"><cf_get_lang dictionary_id='58472.Dönem'></th>
			<th width="80"><cf_get_lang dictionary_id='31401.Değerlendirme Tarihi'></th>
			<th width="115"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
			<th class="header_icn_none">
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.target_plan_forms_info"><img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a>
			</th>
			<th class="header_icn_none"></th>
            <th class="header_icn_none"></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_performans.recordcount>
			<cfoutput query="get_performans">
				<tr>
					<td width="35">#currentrow#</td>
					<td>#get_emp_info(POSITION_CODE,1,0)#</td>
					<td>#emp_position_name#</td>
					<td>#DateFormat(START_DATE,dateformat_style)# - #DateFormat(FINISH_DATE,dateformat_style)#</td>
					<td>#DateFormat(EVAL_DATE,dateformat_style)#</td>
					<td>#DateFormat(RECORD_DATE,dateformat_style)# #TimeFormat(RECORD_DATE,'HH:mm:ss')#</td>
                    <cfif fusebox.circuit eq 'myhome'>
						<cfset PER_ID_ = contentEncryptingandDecodingAES(isEncode:1,content:PER_ID,accountKey:'wrk')>
                    <cfelse>
                        <cfset PER_ID_ = PER_ID>
                    </cfif>
					<td><a href="#request.self#?fuseaction=myhome.upd_target_plan_forms&per_id=#PER_ID_#"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='57766.Formu Güncelle'>"></a></td>
					<td width="15"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#PER_ID#&print_type=176','print_page','workcube_print');"><img src="/images/print2.gif" title="Print"></a></td>
					<td align="center">
						<cfif is_closed eq 1>
							<img src="/images/list_open.gif" alt="Kilitli Değerlendirme" title="Kilitli Değerlendirme">
						<cfelse>
							<img src="/images/list_lock.gif" alt="Açık (Kilitsiz) Değerlendirme" title="Açık (Kilitsiz) Değerlendirme">
						</cfif>
					</td>  
                </tr>
			</cfoutput>
			<cfelse>
				<tr>
					<td height="20" colspan="11"><cfif attributes.is_form_submit><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
				</tr>
		</cfif> 
	</tbody>
</cf_big_list>     
<cf_paging 
    page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="myhome.list_target_perf#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
function kontrol(){
	if(document.search.branch_name.value.length==0)document.search.branch_id.value="";
	if(document.search.department_name.value.length==0)document.search.department_id.value="";
	return true;
}
</script>
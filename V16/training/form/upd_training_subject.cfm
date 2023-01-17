<cf_get_lang_set module_name="training">
<cfinclude template="../query/get_training_subject.cfm">
<cfquery name="GET_TRAINING_SEC" datasource="#dsn#">
	SELECT 
    	TRAINING_CAT_ID, 
        TRAINING_SEC_ID, 
        SECTION_NAME, 
        RECORD_EMP, 
        RECORD_PAR, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_PAR, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	TRAINING_SEC
</cfquery>
<cfquery name="GET_TRAINING_CAT" datasource="#dsn#">
	SELECT 
    	TRAINING_CAT_ID, 
        TRAINING_CAT, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP
    FROM 
    	TRAINING_CAT
</cfquery>
<cfinclude template="../../training_management/query/get_training_style.cfm">
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT 
        MONEY, 
        PERIOD_ID, 
        COMPANY_ID, 
        ACCOUNT_950, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
        SETUP_MONEY 
    WHERE 
    	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
</cfquery>
<cfscript>
	XFA.upd = "training_management.upd_training_subject";
	XFA.del = "training_management.del_training_subject";	
</cfscript>
<cfquery name="GET_STAGE" datasource="#dsn#">
	SELECT TRAINING_STAGE_ID, TRAINING_STAGE FROM SETUP_TRAINING_STAGE
</cfquery> 
<cf_form_box title="#getLang('main',68)#">
<cfform  name="upd_training" method="post" action="#request.self#?fuseaction=training.upd_training_subject">
<input type="Hidden" name="train_id" id="train_id" value="<cfoutput>#attributes.train_id#</cfoutput>"> 
	<table>
		<tr>
			<td></td>
			<td><input type="checkbox" name="subject_status" id="subject_status" value="1" <cfif get_training_subject.subject_status eq 1>checked</cfif>><cf_get_lang_main no='81.aktif'></td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='68.konu'></td>
			<td colspan="3">
				<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='31.konu'></cfsavecontent>
				<cfinput type="text" name="train_head" style="width:423px;" value="#get_training_subject.train_head#" required="Yes" message="#message#" maxlength="125">
			</td>
		</tr>
		<tr>
			<td style="width:100px;"><cf_get_lang_main no='74.kategori'></td>
			<td style="width:180px;">
				<select name="training_cat_id" id="training_cat_id" size="1" onChange="get_tran_sec(this.value)" style="width:160px;">
					<option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
					<cfoutput query="get_training_cat">
						<option value="#training_cat_id#" <cfif get_training_subject.training_cat_id eq training_cat_id>selected</cfif>>#training_cat#</option>
					</cfoutput>
				</select>
			</td>
			<td><cf_get_lang_main no='70.Aşama'></td>
			<td>
				<!--- <select name="currency_id" id="currency_id" class="label" style="width:160px;">
					<cfoutput query="get_currency">
						<option value="#STAGE_ID#" <cfif STAGE_ID EQ get_training_subject.subject_currency_id >SELECTED</cfif>>#STAGE_NAME#</option>
					</cfoutput>
				</select> --->
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='583.bölüm'></td>
			<td>
				<select name="training_sec_id" id="training_sec_id" size="1" style="width:160px;">
					<option value="0"><cf_get_lang_main no='583.bölüm'></option>
				</select>	
			</td>
			<td><cf_get_lang no='51.Eğitimci'></td>
			<td>
				<input type="hidden" name="cons_id" id="cons_id" value="<cfoutput>#get_training_subject.trainer_cons#</cfoutput>">
				<input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#get_training_subject.trainer_emp#</cfoutput>">
				<input type="hidden" name="par_id" id="par_id" value="<cfoutput>#get_training_subject.trainer_par#</cfoutput>"> 
				<input type="hidden" name="member_type" id="member_type" <cfif len(get_training_subject.trainer_emp)>value="employee"<cfelseif len(get_training_subject.trainer_par)>value="partner"</cfif>> 
				<cfif len(get_training_subject.trainer_emp)>
					<cfset attributes.employee_id = get_training_subject.trainer_emp>
					<cfinclude template="../query/get_employee.cfm">
					<input type="text" name="emp_par_name" id="emp_par_name" value="<cfoutput>#get_employee.employee_name# #get_employee.employee_surname#</cfoutput>" style="width:160px;" readonly>
				<cfelseif len(get_training_subject.trainer_par)>
					<cfset attributes.partner_id = get_training_subject.trainer_par>
					<cfinclude template="../query/get_partner.cfm">
					<input type="text" name="emp_par_name" id="emp_par_name" value="<cfoutput>#get_partner.company_partner_name# #get_partner.company_partner_surname#</cfoutput>" style="width:160px;" readonly>
				<cfelseif len(get_training_subject.trainer_cons)>
					<input type="text" name="emp_par_name" id="emp_par_name" value="<cfoutput>#get_cons_info(get_training_subject.trainer_cons,0,0)#</cfoutput>" style="width:160px;" readonly>
				<cfelse>
					<input type="text" name="emp_par_name" id="emp_par_name" value="" style="width:160px;" readonly>
				</cfif>
				<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_training.emp_id&field_consumer=upd_training.cons_id&field_name=upd_training.emp_par_name&field_partner=upd_training.par_id&field_type=upd_training.member_type&select_list=1,2,3</cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang no='122.Eğitim Şekli'></td>		
			<td>
				<select name="training_style" id="training_style" style="width:160px">
					<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
					<cfoutput query="get_training_style">
						<option value="#training_style_id#" <cfif get_training_subject.training_style eq training_style_id>selected</cfif>>#TRAINING_STYLE#</option>
					</cfoutput>
				</select>
			</td>
			<td><cf_get_lang no ='120.Eğitim Tipi'></td>
			<td>
				<select name="training_type" id="training_type" style="width:160px">
					<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
					<option value="1" <cfif get_training_subject.training_type eq 1>selected</cfif>><cf_get_lang no ='440.Standart Eğitim'></option>
					<option value="2" <cfif get_training_subject.training_type eq 2>selected</cfif>><cf_get_lang no ='441.Teknik Gelişim Eğitimi'></option>
					<option value="3" <cfif get_training_subject.training_type eq 3>selected</cfif>><cf_get_lang no ='442.Zorunlu Eğitim'></option>
					<option value="4" <cfif get_training_subject.training_type eq 4>selected</cfif>><cf_get_lang no ='443.Yetkinlik Gelişim Eğitimi'></option>
				</select>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='1716.Süre'></td>
			<td><cfinput type="text" value="#get_training_subject.total_day#" name="totalday" style="width:160px;" validate="integer" message="Süre Gün Cinsinden Olmalıdır !"></td>
			<td><cf_get_lang no ='161.Tahmini Bedel'></td>
			<td>
				<cfinput type="text" name="expense" style="width:112px;" value="#tlformat(get_training_subject.training_expense)#"  onkeyup="return(FormatCurrency(this,event));" class="moneybox">
				<select name="money" id="money">
					<cfoutput query="get_money">
						<option value="#money#" <cfif money eq get_training_subject.money_currency>selected</cfif>>#money#</option>
					</cfoutput>
				</select>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang no='7.amaç'></td>			
			<td colspan="3"><input type="text" name="train_objective" id="train_objective" style="width:423px;" value="<cfoutput>#get_training_subject.train_objective#</cfoutput>"></td>
		</tr>
	</table>
	<br />
	<table>
		<tr>
			<td class="txtboldblue" height="20"><cf_get_lang_main no='241.İçerik'></td>
		</tr>
		<tr>
			<td>
			 <cfmodule
				template="/fckeditor/fckeditor.cfm"
				toolbarSet="WRKContent"
				basePath="/fckeditor/"
				instanceName="train_detail"
				valign="top"
				value="#get_training_subject.train_detail#"
				width="530"
				height="300">
			</td>
		</tr>
	</table>
	<cf_seperator id="egitim_kategorisi_" header="#getLang('training_management',444)#" is_closed="0">
	<table id="egitim_kategorisi_">
  <tr>
			<td><cf_relation_segment is_upd='1' is_form='1' field_id='#attributes.TRAIN_ID#' table_name='TRAINING' tag_head='<cf_get_lang no="444.Eğitim Kategorisinin geçerli olduğu koşullar">' action_table_name='RELATION_SEGMENT_TRAINING' select_list='1,2,3,4,5,6,7,8,9'></td>
		</tr>
	</table>
	<cf_form_box_footer>
		<cf_record_info query_name="get_training_subject">
		<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=#xfa.del#&train_id=#attributes.train_id#&head=#get_training_subject.train_head#' add_function='kontrol()'>	
	</cf_form_box_footer>
	</cfform>
</cf_form_box>
<script type="text/javascript">
	function get_tran_sec(cat_id)//bölümün içini dolduruyor
	{
		document.upd_training.training_sec_id.options.length = 0;
		var get_sec = wrk_safe_query('trn_get_sec','dsn',0,cat_id);
		document.upd_training.training_sec_id.options[0]=new Option('Bölüm !','0');
		for(var jj=0;jj<get_sec.recordcount;jj++)
			document.upd_training.training_sec_id.options[jj+1]=new Option(get_sec.SECTION_NAME[jj],get_sec.TRAINING_SEC_ID[jj])
		return true;
	}
	<cfif isDefined("get_training_subject.training_cat_id") and len(get_training_subject.training_cat_id)>//bölüme bu soruya ait kategori id yolluyor
		get_tran_sec(<cfoutput>#get_training_subject.training_cat_id#</cfoutput>);
	</cfif>
	
	<cfif isDefined("get_training_subject.training_sec_id") and len(get_training_subject.training_sec_id)>//konuya bu souya ait bölüm id yolluyor ve bu bölüme ait konular gelmiş oluyor
		document.upd_training.training_sec_id.value = <cfoutput>#get_training_subject.training_sec_id#</cfoutput>;
	</cfif>

	function kontrol()
	{
		upd_training.expense.value = filterNum(upd_training.expense.value);
	}
</script>

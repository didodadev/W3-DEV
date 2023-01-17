<cfinclude template="../query/get_position_cats.cfm">
<cfinclude template="../query/get_departments.cfm">
<cfquery name="GET_CONSUMER_CATS" datasource="#dsn#">
	SELECT CONSCAT_ID, CONSCAT FROM CONSUMER_CAT
</cfquery>		
<cfquery name="GET_PARTNER_CATS" datasource="#dsn#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT
</cfquery>
<cfinclude template="../query/get_training_sec_names.cfm">
<cfquery name="GET_TRAINING_SEC" datasource="#dsn#">
	SELECT 
    	TRAINING_CAT_ID, 
        TRAINING_SEC_ID, 
        SECTION_NAME, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_DATE, 
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
        TRAINING_LANGUAGE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	TRAINING_CAT
</cfquery>
<cfquery name="GET_TRAINING_STYLE" datasource="#dsn#">
	SELECT 
    	TRAINING_STYLE_ID, 
        TRAINING_STYLE, 
        DETAIL, 
        RECORD_IP,
        RECORD_DATE, 
        RECORD_EMP, 
        UPDATE_IP, 
        UPDATE_DATE, 
        UPDATE_EMP	 
    FROM 
    	SETUP_TRAINING_STYLE
</cfquery>
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT 
        MONEY, 
        PERIOD_ID, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_MONEY 
    WHERE 
	    PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfscript>
	XFA.add = "training_management.add_training_subject";
	XFA.abort = "training_management.del_folder";
</cfscript>
<cfquery name="GET_STAGE" datasource="#dsn#">
	SELECT TRAINING_STAGE_ID, TRAINING_STAGE FROM SETUP_TRAINING_STAGE
</cfquery>
<cf_popup_box title="#getLang('training',160)#">
<cfform name="add_training_management" method="post" action="#request.self#?fuseaction=training.emptypopup_add_training_subject_value">           
	<input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>">
	<input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
<cfif isdefined("attributes.list_type")>
	<input type="hidden" name="list_type" id="list_type" value="<cfoutput>#attributes.list_type#</cfoutput>">
<cfelseif isdefined("attributes.class_type")>
	<input type="hidden" name="class_type" id="class_type" value="<cfoutput>#attributes.class_type#</cfoutput>">
</cfif>	
	 <table>
		<tr class="txtbold"> 
			<td>&nbsp;&nbsp;<cf_get_lang_main no='74.kategori'></td>
			<td width="210"><cf_get_lang_main no='70.Aşama'></td>
			<td width="256">&nbsp;</td>
		</tr>
		<tr> 
		  <td width="312">
			<table>
				<tr> 
					<td width="160">
						<select name="training_cat_id" id="training_cat_id" size="1" onChange="get_tran_sec(this.value)" style="width:150px">
							<option value="0"><cf_get_lang_main no='74.kateogri'>  !</option>
							<cfoutput query="get_training_cat">
								<option value="#training_cat_id#">#training_cat#</option>
							</cfoutput>
						</select>
					</td>
					<td width="152">
						<select name="training_sec_id" id="training_sec_id" size="1" style="width:150px">
							<option value="0"><cf_get_lang_main no='583.Bölüm'>!</option>
						</select>
					</td>
				</tr>
			</table>
		  </td>
		  <!--- <td>
			  <select name="currency_id" id="currency_id" style="width:190px;">
				  <cfoutput query="get_currency"> 
					<option value="#STAGE_ID#">#STAGE_NAME#</option>
				  </cfoutput> 
			  </select>
		  </td> --->
		  <td>&nbsp;</td>
		</tr>
		<tr> 
			<td colspan="2" class="txtbold">&nbsp;&nbsp;<cf_get_lang_main no='68.Konu '>*</td>
			<td class="txtbold"><cf_get_lang_main no='1716.Süre'></td>
		</tr>
		<tr> 
			<td colspan="2">&nbsp;&nbsp;<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='68.Konu '>!</cfsavecontent>
				<cfinput type="text" name="train_head" style="width:495px" required="Yes" message="#message#" value="" maxlength="125"></td>
			<td><cfinput type="text" name="totalday" style="width:150px;" validate="integer" message="Süre Gün Cinsinden Olmalıdır !"></td>
		</tr>
		<tr> 
			<td class="txtbold">&nbsp;&nbsp;<cf_get_lang no ='7.Amaç'></td>
			<td class="txtbold"><cf_get_lang no='51.Eğitimci'></td>
			<td class="txtbold"><cf_get_lang no ='159.Seviye'></td>
		</tr>
		<tr> 
			<td>&nbsp;&nbsp;<input type="text" name="train_objective" id="train_objective" style="width:300px" value=""></td>
			<td><input type="hidden" name="emp_id" id="emp_id" value=""><input type="hidden" name="par_id" id="par_id" value=""> 
				<input type="hidden" name="member_type" id="member_type" value="">
				<input type="text" name="emp_par_name" id="emp_par_name" value="" style="width:190px;" readonly>
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_training_management.emp_id&field_name=add_training_management.emp_par_name&field_partner=add_training_management.par_id&field_type=add_training_management.member_type&select_list=1,2</cfoutput>','list');"><img src="/images/plus_thin.gif"></a></td>
		<td><select name="level" id="level" style="width:150px;">
			<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
			<cfoutput query="get_stage">
				<option value="#training_stage_id#">#training_stage#</option>
			</cfoutput>
			</select></td>
		</tr>
		<tr>
			<td class="txtbold">&nbsp;&nbsp;<cf_get_lang no ='120.Eğitim Tipi'></td>
			<td class="txtbold"><cf_get_lang no ='122.Eğitim Şekli'></td>
			<td class="txtbold"><cf_get_lang no ='161.Tahmini Bedel'></td>
		</tr>
		<tr>
		<td>&nbsp;&nbsp;<select name="training_type" id="training_type" style="width:300px">
				<cfif isdefined("attributes.class_type")>
					<option value="2" selected="selected"><cf_get_lang no ='121.Teknik Gelişim Eğitimi'></option>
				<cfelse>
					<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
					<option value="1"><cf_get_lang no ='105.Standart Eğitim'></option>
					<option value="2"><cf_get_lang no ='121.Teknik Gelişim Eğitimi'></option>
					<option value="3"><cf_get_lang no ='108.Zorunlu Eğitim'></option>
					<option value="4"><cf_get_lang no ='138.Yetkinlik Gelişim Eğitimi'></option>
				</cfif>
			</select></td>
		<td><select name="training_style" id="training_style" style="width:190px">
				<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
			<cfoutput query="get_training_style">
				<option value="#TRAINING_STYLE_ID#">#TRAINING_STYLE#</option>
			</cfoutput>
			</select></td>
		<td><cfinput type="text" name="expense" style="width:100px;" value=""  onkeyup="return(FormatCurrency(this,event));" class="moneybox">
		<select name="money" id="money" style="width:47px">
			<cfoutput query="get_money">
				<option value="#money#">#money#</option>
			</cfoutput>
		</select></td>
		</tr>
		<tr> 
			<td colspan="3">
				<cfmodule
					template="/fckeditor/fckeditor.cfm"
					toolbarSet="WRKContent"
					basePath="/fckeditor/"
					instanceName="train_detail"
					value=""
					width="700"
					height="300">
			</td>
		</tr> 
	 </table>
	<cf_popup_box_footer><cf_workcube_buttons type_format="1" is_upd='0'></cf_popup_box_footer>			
</cfform>
</cf_popup_box>
<script type="text/javascript">
	function kontrol()
	{
		add_training_management.expense.value = filterNum(add_training_management.expense.value);
		return OnFormSubmit();
	}
	function get_tran_sec(cat_id)
	{
		var get_sec = wrk_safe_query('trn_get_sec','dsn',0,cat_id);
		document.add_training_management.training_sec_id.options[0]=new Option('Bölüm !','0')
		for(var jj=0;jj<get_sec.recordcount;jj++)
		{
			document.add_training_management.training_sec_id.options[jj+1]=new Option(get_sec.SECTION_NAME[jj],get_sec.TRAINING_SEC_ID[jj])
		}
	}
</script>


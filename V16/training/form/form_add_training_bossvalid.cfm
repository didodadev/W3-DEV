<cfparam name="attributes.is_submit" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch_name" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.training" default="">
<cfparam name="attributes.training_sec_id" default="">
<cfquery name="GET_OUR_COMPANY" datasource="#dsn#">
	SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
</cfquery>
<cfquery name="GET_TRAININGS" datasource="#dsn#">
	SELECT 	TRAIN_ID, TRAIN_OBJECTIVE, TRAIN_HEAD FROM TRAINING ORDER BY TRAIN_HEAD
</cfquery>
<cfquery name="GET_TRAINING_SEC_NAMES" datasource="#dsn#">
	SELECT
		TRAINING_CAT.TRAINING_CAT_ID,
		TRAINING_SEC.TRAINING_SEC_ID,
		TRAINING_SEC.SECTION_NAME,
		TRAINING_CAT.TRAINING_CAT
	FROM
		TRAINING_SEC,
		TRAINING_CAT
	WHERE
		TRAINING_SEC.TRAINING_CAT_ID = TRAINING_CAT.TRAINING_CAT_ID
	ORDER BY
		TRAINING_CAT.TRAINING_CAT,
		TRAINING_SEC.SECTION_NAME
</cfquery>
<cfif len(attributes.is_submit)>
	<cfquery name="GET_TRANINING_VALID" datasource="#dsn#">
		SELECT
			TR.TRAIN_REQUEST_ID,
			TR.REQUEST_YEAR,
			TR.RECORD_DATE,
			TR.FIRST_BOSS_ID,
			TR.SECOND_BOSS_ID,
			TR.THIRD_BOSS_ID,
			TR.FOURTH_BOSS_ID,
			TR.FIFTH_BOSS_ID,
			TRR.REQUEST_ROW_ID,
			TRR.FIRST_BOSS_VALID_ROW,
			TRR.SECOND_BOSS_VALID_ROW,
			TRR.THIRD_BOSS_VALID_ROW,
			TRR.FOURTH_BOSS_VALID_ROW,
			TRR.FIFTH_BOSS_VALID_ROW,
			T.TRAIN_HEAD,
			T.TRAIN_OBJECTIVE,
			T.TRAINING_EXPENSE,
			T.MONEY_CURRENCY,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
		FROM 
			TRAINING_REQUEST TR,
			TRAINING_REQUEST_ROWS TRR,
			TRAINING T,
			EMPLOYEES E,
			EMPLOYEE_POSITIONS EP,
			DEPARTMENT D,
			BRANCH B,
			OUR_COMPANY OC
		WHERE 
			TR.IS_VALID_VALUE = 1 AND
			E.EMPLOYEE_ID = TR.EMPLOYEE_ID AND
			TRR.TRAIN_REQUEST_ID = TR.TRAIN_REQUEST_ID AND
			T.TRAIN_ID = TRR.TRAINING_ID AND
			E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND 
			D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND
			D.BRANCH_ID = B.BRANCH_ID AND 
			B.COMPANY_ID = OC.COMP_ID AND 
			(
				TR.EMPLOYEE_ID = #session.ep.userid# OR
				TR.FIRST_BOSS_ID = #session.ep.userid#  OR 
				TR.SECOND_BOSS_ID = #session.ep.userid#  OR 
				TR.THIRD_BOSS_ID = #session.ep.userid#  OR 
				TR.FOURTH_BOSS_ID = #session.ep.userid#  OR 
				TR.FIFTH_BOSS_ID = #session.ep.userid#
			)
			<cfif len(attributes.comp_id)>AND OC.COMP_ID = #attributes.comp_id#</cfif>
			<cfif len(attributes.branch_name) and len(attributes.branch_id)>AND B.BRANCH_ID = #attributes.branch_id#</cfif>
			<cfif len(attributes.department_name) and len(attributes.department_id)>AND D.DEPARTMENT_ID = #attributes.department_id#</cfif>
			<cfif len(attributes.keyword)>AND ( E.EMPLOYEE_NAME LIKE '%#attributes.keyword#%' OR E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%')</cfif>
			<cfif len(attributes.training)>AND T.TRAIN_ID = #attributes.training#</cfif>
			<cfif len(attributes.training_sec_id)>AND T.TRAINING_SEC_ID = #attributes.training_sec_id#</cfif>
	</cfquery>
	<cfparam name="attributes.totalrecords" default='#get_tranining_valid.recordcount#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = ''>
<table width="100%" cellspacing="0" cellpadding="0" height="100%">
  <tr>
    <td valign="top">
      <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
        <tr>
          <td class="headbold"><cf_get_lang no ='186.Toplu Onay Ekranı'></td>
          <td valign="bottom" align="right">
            <table>
              <cfform name="form1" method="post" action="">
			  <input type="hidden" name="is_submit" id="is_submit" value="1">
                <tr>
                  <td><cf_get_lang_main no='48.Filtre'>:</td>
                  <td><cfinput type="text" name="keyword" value="#attributes.keyword#"></td>
				    <td><select name="comp_id" id="comp_id" style="width:150px;">
						<option value=""><cf_get_lang_main no='1734.Şirketler'></option>
						<cfoutput query="get_our_company">
							<option value="#comp_id#"<cfif attributes.comp_id eq comp_id>selected</cfif>>#company_name#</option>
						</cfoutput>
					</select></td>
					<td><cf_get_lang no ='135.Şube Departman'></td>
					<td align="right" style="text-align:right;">
						<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
						<input type="text" name="branch_name" id="branch_name" value="<cfoutput>#attributes.branch_name#</cfoutput>" style="width:100px;">
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_branch_name=form1.branch_name&field_branch_id=form1.branch_id</cfoutput>','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
						<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#attributes.department_id#</cfoutput>">
						<input type="text" name="department_name" id="department_name" value="<cfoutput>#attributes.department_name#</cfoutput>" style="width:100px;">
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=form1.department_id&field_name=form1.department_name&is_all_departments</cfoutput>','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></td>
                  <td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
                  <td><cf_wrk_search_button></td>
                </tr>
              
            </table>
          </td>
        </tr>
      </table>
            <table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border" align="center">
              <tr class="color-row">
			  	<td align="right" colspan="9">
				<select name="training" id="training" style="width:300;">
					<option value=""><cf_get_lang_main no='7.Eğitim'></option>
					<cfoutput query="get_trainings">
						<option value="#train_id#" <cfif train_id eq attributes.training>selected</cfif>>#train_head#</option>
					</cfoutput>
				</select>
				<select name="training_sec_id" id="training_sec_id">
                      <option value=""><cf_get_lang no='62.Kategori / Bölüm'></option>
                      <cfoutput query="get_training_sec_names">
                        <option value="#training_sec_id#" <cfif attributes.training_sec_id eq training_sec_id>selected</cfif>>#training_cat# / #section_name#</option>
                      </cfoutput>
                    </select>
				</td>
			  </tr>
			  </cfform>
			  <tr class="color-header">
                <td height="22" class="form-title" width="25">No</td>
                <td class="form-title"><cf_get_lang_main no ='1050.İsim Soyisim'></td>
                <td class="form-title" width="120"><cf_get_lang no ='72.Eğitim Adı'></td>
                <td class="form-title" width="60"><cf_get_lang no ='104.Talep Yılı'></td>
                <td class="form-title" width="150"><cf_get_lang no ='110.İş Hedefine Katkısı'></td>
				<td width="100" align="right" class="form-title" style="text-align:right;"><cf_get_lang no ='188.Eğitim Bedeli'></td>
				<td class="form-title" width="70"><cf_get_lang_main no ='215.Kayıt Tarihi'></td>
				<td class="form-title"><cf_get_lang no ='189.Onay Durumu'></td>
				<td class="form-title" width="100"><cf_get_lang_main no='344.Durum'></td>
              </tr>
              <cfif len(attributes.is_submit)>
			  <form name="add_valid" id="add_valid" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=training.emptypopup_add_valid">
			  <cfif GET_TRANINING_VALID.recordcount>
				<cfoutput query="GET_TRANINING_VALID" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                  <cfset isshow = 0>
				  <cfset isstep = 0>
				  <cfif not len(first_boss_valid_row) or first_boss_valid_row eq 0>
				  	<cfif first_boss_id eq session.ep.userid>
						<cfset isshow = 1>
						<cfset isstep = 1>
					</cfif>
				  <cfelseif not len(second_boss_valid_row) or second_boss_valid_row eq 0>
				  	<cfif second_boss_id eq session.ep.userid>
						<cfset isshow = 1>
						<cfset isstep = 2>
					</cfif>
				  <cfelseif not len(third_boss_valid_row) or third_boss_valid_row eq 0>
				  	<cfif third_boss_id eq session.ep.userid>
						<cfset isshow = 1>
						<cfset isstep = 3>
					</cfif>
				  <cfelseif not len(fourth_boss_valid_row) or fourth_boss_valid_row eq 0>
				  	<cfif fourth_boss_id eq session.ep.userid>
						<cfset isshow = 1>
						<cfset isstep = 4>
					</cfif>
				  <cfelseif not len(fifth_boss_valid_row) or fifth_boss_valid_row eq 0>
				  	<cfif fifth_boss_id eq session.ep.userid>
						<cfset isshow = 1>
						<cfset isstep = 5>
					</cfif>
				  </cfif>
				  <cfif isshow eq 1>
				  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td>#currentrow#</td>
                    <td>#employee_name# #employee_surname#</td>
					<td>#train_head#</td>
					<td>#request_year#</td>
					<td>#train_objective#</td>
					<td align="right" style="text-align:right;">#training_expense# #money_currency#</td>
                    <td>#dateformat(record_date,dateformat_style)#</td>
					<td><cfif first_boss_valid_row eq 0><cf_get_lang_main no='1740.Red'><cfelseif first_boss_valid_row eq 1><cf_get_lang_main no ='88.Onay'><cfelseif not len(first_boss_valid_row)><cf_get_lang_main no ='203.Onay Bekliyor'>
					<cfelseif second_boss_valid_row eq 0><cf_get_lang_main no='1740.Red'><cfelseif second_boss_valid_row eq 1><cf_get_lang_main no ='88.Onay'><cfelseif not len(second_boss_valid_row)><cf_get_lang_main no ='203.Onay Bekliyor'>
					<cfelseif third_boss_valid_row eq 0><cf_get_lang_main no='1740.Red'><cfelseif third_boss_valid_row eq 1><cf_get_lang_main no ='88.Onay'><cfelseif not len(third_boss_valid_row)><cf_get_lang_main no ='203.Onay Bekliyor'>
					<cfelseif fourth_boss_valid_row eq 0><cf_get_lang_main no='1740.Red'><cfelseif fourth_boss_valid_row eq 1><cf_get_lang_main no ='88.Onay'><cfelseif not len(fourth_boss_valid_row)><cf_get_lang_main no ='203.Onay Bekliyor'>
					<cfelseif fifth_boss_valid_row eq 0><cf_get_lang_main no='1740.Red'><cfelseif fifth_boss_valid_row eq 1><cf_get_lang_main no ='88.Onay'><cfelseif not len(fifth_boss_valid_row)><cf_get_lang_main no ='203.Onay Bekliyor'></cfif></td>
					<td><input type="hidden" name="row_id" id="row_id" value="#request_row_id#">
                    	<input type="hidden" name="isstep#request_row_id#" id="isstep#request_row_id#" value="#isstep#" style="width:23;">
                        <input type="radio" name="isvalid#request_row_id#" id="isvalid#request_row_id#" value="0"><cf_get_lang_main no ='88.Onay'>
                    	<input type="radio" name="isvalid#request_row_id#" id="isvalid#request_row_id#" value="0"><cf_get_lang_main no='1740.Red'></td>
                  </tr>
				  </cfif>
                </cfoutput>
				<tr class="color-row">
				<cfsavecontent variable="alert"><cf_get_lang_main no ='1063.Onayla'></cfsavecontent>
					<td colspan="9" align="right" style="text-align:right;"><cf_workcube_buttons is_upd='0' insert_info='#alert#'></td>
				</tr>
				</form>
                <cfelse>
                <tr class="color-row" height="20">
                  <td colspan="20"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                </tr>
              </cfif>
			  <cfelse>
                <tr class="color-row" height="20">
                  <td colspan="20"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                </tr>
			  </cfif>
            </table>
      <cfif get_trainings.recordcount>
        <cfif attributes.totalrecords gt attributes.maxrows>
          <table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
            <tr>
              <td height="35"><cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="training.list_training_subjects#url_str#"> </td>
              <!-- sil --><td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
            </tr>
          </table>
        </cfif>
      </cfif>
    </td>
  </tr>
</table>


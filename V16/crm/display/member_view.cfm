<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.comp_cat" default="">
<cfparam name="attributes.ims_code_ids" default="0">
<cfparam name="attributes.related_ids" default="0">
<cfset attributes.ims_code_ids = #get_permited_ims(position_code : session.ep.position_code, output : 'ims_code_id', company_id : session.ep.company_id)#>
<cfset attributes.related_ids = #get_permited_ims(position_code : session.ep.position_code, output : 'related_id', company_id : session.ep.company_id)#>
<cfquery name="GET_CUSTOMER" datasource="#dsn#">
	SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT_ID
</cfquery>
<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT
		COMPANY.FULLNAME,
		COMPANY.RECORD_EMP,
		COMPANY.RECORD_DATE,
		COMPANY.COMPANY_ID,
		COMPANY.COMPANY_STATE,
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME,
		COMPANY_CAT.COMPANYCAT
	FROM
		COMPANY,
		DEPARTMENT,
		BRANCH,
		SETUP_CITY,
		EMPLOYEE_POSITIONS,
		COMPANY_CAT,
		SETUP_IMS_CODE
	WHERE
		COMPANY.COMPANYCAT_ID = COMPANY_CAT.COMPANYCAT_ID AND
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = COMPANY.RECORD_EMP AND
		SETUP_CITY.CITY_ID = COMPANY.CITY AND
		DEPARTMENT.DEPARTMENT_ID = EMPLOYEE_POSITIONS.DEPARTMENT_ID AND
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND 
		ISPOTANTIAL = 0 AND
		COMPANY.COMPANY_STATE IN (
			SELECT 
				(PROCESS_TYPE_ROWS.PROCESS_ROW_ID - 1)
			FROM
				PROCESS_TYPE,
				PROCESS_TYPE_OUR_COMPANY,
				PROCESS_TYPE_ROWS,
				PROCESS_TYPE_ROWS_POSID
			WHERE
				PROCESS_TYPE.IS_ACTIVE = 1 AND
				PROCESS_TYPE.FACTION LIKE '%crm.form_add_company%' AND
				PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_OUR_COMPANY.PROCESS_ID AND
				PROCESS_TYPE_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
				PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
				PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID AND 
				PROCESS_TYPE_ROWS.PROCESS_ROW_ID = PROCESS_TYPE_ROWS_POSID.PROCESS_ROW_ID		
		)
		AND (SETUP_IMS_CODE.IMS_CODE_ID = COMPANY.IMS_CODE_ID)
		<cfif attributes.ims_code_ids neq 0>AND (SETUP_IMS_CODE.IMS_CODE_ID IN (#attributes.ims_code_ids#)<cfelse>AND (COMPANY.COMPANY_ID > 0</cfif>
		<cfif attributes.related_ids neq 0>OR COMPANY.COMPANY_ID IN (#attributes.related_ids#))<cfelse>)</cfif>
		<cfif len(attributes.keyword)>AND COMPANY.FULLNAME LIKE '%#attributes.keyword#%'</cfif>
		<cfif len(attributes.comp_cat)>AND COMPANY.COMPANYCAT_ID = #attributes.comp_cat#</cfif>
	ORDER BY 
		COMPANY.FULLNAME
</cfquery>
<cfparam name='attributes.totalrecords' default='#get_company.recordcount#'>
<cfparam name='attributes.page' default='1'>
<cfparam name='attributes.maxrows' default='10'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_COMPANY_RED" datasource="#dsn#">
	SELECT
		COMPANY.FULLNAME,
		COMPANY.RECORD_EMP,
		COMPANY.RECORD_DATE,
		COMPANY.COMPANY_ID,
		COMPANY.COMPANY_STATE,
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME,
		COMPANY_CAT.COMPANYCAT
	FROM
		COMPANY,
		DEPARTMENT,
		BRANCH,
		SETUP_CITY,
		EMPLOYEE_POSITIONS,
		COMPANY_CAT,
		SETUP_IMS_CODE
	WHERE
		COMPANY.COMPANYCAT_ID = COMPANY_CAT.COMPANYCAT_ID AND
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = COMPANY.RECORD_EMP AND
		SETUP_CITY.CITY_ID = COMPANY.CITY AND
		DEPARTMENT.DEPARTMENT_ID = EMPLOYEE_POSITIONS.DEPARTMENT_ID AND
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND 
		ISPOTANTIAL = 0 AND
		COMPANY.COMPANY_STATE IN (
			SELECT 
				(PROCESS_TYPE_ROWS.PROCESS_ROW_ID - 1)
			FROM
				PROCESS_TYPE,
				PROCESS_TYPE_OUR_COMPANY,
				PROCESS_TYPE_ROWS,
				PROCESS_TYPE_ROWS_POSID
			WHERE
				PROCESS_TYPE.IS_ACTIVE = 1 AND
				PROCESS_TYPE.FACTION LIKE '%crm.form_add_company%' AND
				PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_OUR_COMPANY.PROCESS_ID AND
				PROCESS_TYPE_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
				PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
				PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID AND 
				PROCESS_TYPE_ROWS.PROCESS_ROW_ID = PROCESS_TYPE_ROWS_POSID.PROCESS_ROW_ID		
		)
		AND SETUP_IMS_CODE.IMS_CODE_ID = COMPANY.IMS_CODE_ID
		<cfif attributes.ims_code_ids neq 0>AND (SETUP_IMS_CODE.IMS_CODE_ID IN (#attributes.ims_code_ids#)<cfelse>AND (COMPANY.COMPANY_ID > 0</cfif>
		<cfif attributes.related_ids neq 0>OR COMPANY.COMPANY_ID IN (#attributes.related_ids#))<cfelse>)</cfif>
		<cfif len(attributes.keyword)>AND COMPANY.FULLNAME LIKE '%#attributes.keyword#%'</cfif>
		<cfif len(attributes.comp_cat)>AND COMPANY.COMPANYCAT_ID = #attributes.comp_cat#</cfif>
	ORDER BY 
		COMPANY.FULLNAME
</cfquery>
<cfquery name="GET_COMPANY_GONDERILEN" datasource="#dsn#">
	SELECT
		COMPANY.FULLNAME,
		COMPANY.RECORD_EMP,
		COMPANY.RECORD_DATE,
		COMPANY.COMPANY_ID,
		COMPANY.COMPANY_STATE,
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME,
		COMPANY_CAT.COMPANYCAT
	FROM
		COMPANY,
		DEPARTMENT,
		BRANCH,
		SETUP_CITY,
		EMPLOYEE_POSITIONS,
		COMPANY_CAT,
		SETUP_IMS_CODE
	WHERE
		COMPANY.COMPANYCAT_ID = COMPANY_CAT.COMPANYCAT_ID AND
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = COMPANY.RECORD_EMP AND
		SETUP_CITY.CITY_ID = COMPANY.CITY AND
		DEPARTMENT.DEPARTMENT_ID = EMPLOYEE_POSITIONS.DEPARTMENT_ID AND
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND 
		ISPOTANTIAL = 0 AND
		COMPANY.COMPANY_STATE IN (
			SELECT 
				(PROCESS_TYPE_ROWS.PROCESS_ROW_ID)
			FROM
				PROCESS_TYPE,
				PROCESS_TYPE_ROWS,
				PROCESS_TYPE_OUR_COMPANY,
				PROCESS_TYPE_ROWS_POSID
			WHERE
				PROCESS_TYPE.IS_ACTIVE = 1 AND
				PROCESS_TYPE.FACTION LIKE '%crm.form_add_company%' AND
				PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_OUR_COMPANY.PROCESS_ID AND
				PROCESS_TYPE_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
				PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID = #session.ep.position_code# AND
				PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID AND 
				PROCESS_TYPE_ROWS.PROCESS_ROW_ID = PROCESS_TYPE_ROWS_POSID.PROCESS_ROW_ID		
		)
		AND SETUP_IMS_CODE.IMS_CODE_ID = COMPANY.IMS_CODE_ID
		<cfif attributes.ims_code_ids neq 0>AND (SETUP_IMS_CODE.IMS_CODE_ID IN (#attributes.ims_code_ids#)<cfelse>AND (COMPANY.COMPANY_ID > 0</cfif>
		<cfif attributes.related_ids neq 0>OR COMPANY.COMPANY_ID IN (#attributes.related_ids#))<cfelse>)</cfif>
		<cfif len(attributes.keyword)>AND COMPANY.FULLNAME LIKE '%#attributes.keyword#%'</cfif>
		<cfif len(attributes.comp_cat)>AND COMPANY.CUSTOMER_TYPE = #attributes.comp_cat#</cfif>
	ORDER BY 
		COMPANY.FULLNAME
</cfquery>
<cfparam name='attributes.totalrecords2' default='#get_company_red.recordcount#'>
<cfparam name='attributes.page2' default='1'>
<cfparam name='attributes.maxrows2' default='10'>
<cfset attributes.startrow2 = ((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
	<cfif len(attributes.keyword)>
<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.comp_cat)>
	<cfset url_str = "#url_str#&comp_cat=#attributes.comp_cat#">
</cfif>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
  <tr>
    <td class="headbold" height="35"><cf_get_lang no ='935.Onay Bekleyen Müşteriler'></td>
       <!--- Arama --->
      <td style="text-align:right;">
	  <table>
	  <!-- sil -->
        <cfform name="form" method="post" action="#request.self#?fuseaction=crm.welcome">
          <tr>
            <td><cf_get_lang_main no='48.Filtre'>:</td>
            <td><cfinput type="text" name="keyword" style="width:85px;" value="#attributes.keyword#" maxlength="255"></td>
            <td>
              <select name="comp_cat" id="comp_cat" style="width:150">
                <option value=""><cf_get_lang no ='35.Müşteri Tipi'></option>
				<cfoutput query="get_customer">
					<option value="#companycat_id#" <cfif companycat_id eq attributes.comp_cat>selected</cfif>>#companycat#</option>
			    </cfoutput></select></td>
            <td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
            <td><cf_wrk_search_button></td>
		<td>
		<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_cons_graph','medium');"><img src="/images/report.gif" border="0" title="<cf_get_lang no ='19.Müşteri Profili'>"></a>
		</td>
		</tr>
        </cfform>
		 <!-- sil -->
      </table>
	  </td>
      <!--- Arama --->
  </tr>
</table>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td valign="top">
            <table border="0" cellpadding="0" cellspacing="0" class="color-border" width="100%">
              <tr>
                <td>
                  <table border="0" width="100%" cellpadding="2" cellspacing="1">
                    <tr class="color-header">
                      <td  width="20" height="22" class="form-title"><cf_get_lang_main no='75.No'></td>
                       <td  height="22" class="form-title" width="200"><cf_get_lang no ='936.Talepte Bulunan Depo'></td>
					   <td  height="22" class="form-title" width="180"><cf_get_lang no ='937.Talepte Bulunan Kişi'></td>
                       <td class="form-title"><cf_get_lang no ='938.Talep Tarihi'></td>
					   <td class="form-title"><cf_get_lang_main no='338.İşyeri Adı'></td>
					   <td class="form-title"><cf_get_lang no ='35.Müşteri Tipi'></td>
					   <td class="form-title"><cf_get_lang_main no ='70.Aşama'></td>
					   <td class="form-title" width="30">&nbsp;</td>
					   <td width="30">&nbsp;</td>
                    </tr>
                    <cfif get_company.recordcount>
                      <cfoutput query="get_company" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					   <cfquery name="GET_COMPANY_PROCESS" datasource="#dsn#">
					   		SELECT STAGE, LINE_NUMBER FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #company_state#
					   </cfquery>
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td>#currentrow#</td>
						<td>#branch_name# / #department_head#</td>
						<td>#get_emp_info(record_emp,0,1)#</td>
						<td>#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</td>
						<td><a href="#request.self#?fuseaction=crm.detail_company&cpid=#company_id#" class="tableyazi">#fullname#</a></td>
						<td>#companycat#</td>
						<td>#get_company_process.stage#</td>
						<cfsavecontent variable="rej_message"><cf_get_lang no ='941.Müşteri Onay Sürecini Red Ediyorsunuz Müşteri İptal Edilen Müşteriler Listesine Eklenecek Emin misiniz'></cfsavecontent>
						<td><a href="javascript://" onClick="if (confirm('#rej_message#')) windowopen('#request.self#?fuseaction=crm.emptypopup_add_company_to_red&cpid=#company_id#','small');" class="tableyazi"><cf_get_lang_main no='1740.Red'></a></td>
						<cfsavecontent variable="esc_message"><cf_get_lang no ='942.Yeni Müşteri Kaydını Onaylıyorsunuz Yeni Müşteri Kaydını Onaylamak İstediğinizden Emin misiniz'></cfsavecontent>
						<td><a href="javascript://" onClick="if (confirm('#esc_message#')) windowopen('#request.self#?fuseaction=crm.emptypopup_add_company_to_onay&cpid=#company_id#','small');" class="tableyazi"><cf_get_lang_main no ='88.Onay'></a></td>
                        </tr>
                      </cfoutput>
					  <cfelse>
                      <tr class="color-row" height="20">
                        <td colspan="9"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                      </tr>
                    </cfif>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
	  <cfif attributes.totalrecords gt attributes.maxrows>
	  <table width="100%" cellpadding="0" cellspacing="0" height="35">
    	<tr>
		  <td><cf_pages 
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="crm.welcome#url_str#"></td>
		  <td  style="text-align:right;"><cf_get_lang_main no='128.Toplam Kayıt'><cfoutput>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
	  </table>
  </cfif>
	  <table width="100%"  cellpadding="0" cellspacing="0" border="0" align="center">
	  <tr>
	  <td class="headbold" height="35"><cf_get_lang no ='939.Onaya Gönderilen Müşteriler'></td>
	  </tr>
	  </table>
	  <table border="0" cellpadding="0" cellspacing="0" width="100%">
	  <tr class="color-border">
	  <td>
	  <table border="0" width="100%" cellpadding="2" cellspacing="1">
                    <tr class="color-header">
                      <td  width="20" height="22" class="form-title"><cf_get_lang_main no='75.No'></td>
                       <td  height="22" class="form-title" width="200"><cf_get_lang no ='936.Talepte Bulunan Depo'></td>
					   <td  height="22" class="form-title" width="180"><cf_get_lang no ='937.Talepte Bulunan Kişi'></td>
                       <td class="form-title"><cf_get_lang no ='938.Talep Tarihi'></td>
					   <td class="form-title"><cf_get_lang_main no='338.İşyeri Adı'></td>
					   <td class="form-title"><cf_get_lang no ='35.Müşteri Tipi'></td>
					   <td class="form-title"><cf_get_lang_main no ='70.Aşama'></td>
					   <td class="form-title" width="50">&nbsp;</td>					  
                    </tr>
                    <cfif get_company_gonderilen.recordcount>
					<cfoutput query="get_company_gonderilen" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					   <cfquery name="GET_COMPANY_PROCESS2" datasource="#dsn#">
					   		SELECT STAGE, LINE_NUMBER FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #company_state#
					   </cfquery>
						<cfif (datediff("h", record_date, now()) gt 12) and (get_company_process2.line_number eq 1)>
						<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						  <td><font color="##990000">#currentrow#</font></td>
                          <td><font color="##990000">#branch_name# / #department_head#</font></td>
						  <td><font color="##990000">#get_emp_info(record_emp,0,1)#</font></td>
						  <td><font color="##990000">#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</font></td>
						  <td><a href="#request.self#?fuseaction=crm.detail_company&cpid=#company_id#" class="tableyazi">#fullname#</a></td>
						  <td><font color="##990000">#companycat#</font></td>
						  <td><font color="##990000">#get_company_process2.stage#</font></td>
						  <cfsavecontent variable="stg_message"><cf_get_lang no ='943.Müşteri Onay Sürecini İptal Ediyorsunuz Müşteri Aday Müşteriler Listesine Eklenecek Emin misiniz'></cfsavecontent>
						  <td align="center" width="30"><a href="javascript://" onClick="if (confirm('#stg_message#')) windowopen('#request.self#?fuseaction=crm.emptypopup_upd_member_record&cpid=#company_id#','small');" class="tableyazi"><cf_get_lang_main no ='1094.İptal'></a></td>
						  <cfelse>
						<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td>#currentrow#</td>
                          	<td>#branch_name# / #department_head#</td>
						  	<td>#get_emp_info(record_emp,0,1)#</td>
						  	<td>#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</td>
						  	<td><a href="#request.self#?fuseaction=crm.detail_company&cpid=#company_id#" class="tableyazi">#fullname#</a></td>
						  	<td>#companycat#</td>
						  	<td>#get_company_process2.stage#</td>
						  	 <cfsavecontent variable="stg_message"><cf_get_lang no ='943.Müşteri Onay Sürecini İptal Ediyorsunuz Müşteri Aday Müşteriler Listesine Eklenecek Emin misiniz'></cfsavecontent>
							<td align="center" width="30"><cfif get_company_process2.line_number eq 1><a href="javascript://" onClick="if (confirm('#stg_message#')) windowopen('#request.self#?fuseaction=crm.emptypopup_upd_member_record&cpid=#company_id#','small');" class="tableyazi"><cf_get_lang_main no ='1094.İptal'></a></cfif></td>
						  </tr></cfif>
					
					</cfoutput>
					<cfelse>
					  <tr class="color-row" height="20">
                        <td colspan="8"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
                      </tr>
					</cfif>  
            </table>
		  </td>
	  </tr>
	</table>
		  <cfif attributes.totalrecords gt attributes.maxrows>
	  <table width="100%" cellpadding="0" cellspacing="0" height="35">
    	<tr>
		  <td><cf_pages 
				page="#attributes.page2#"
				maxrows="#attributes.maxrows2#"
				totalrecords="#attributes.totalrecords2#"
				startrow="#attributes.startrow2#"
				adres="crm.welcome#url_str#"></td>
		  <td  style="text-align:right;"><cf_get_lang_main no='128.Toplam Kayıt'><cfoutput>:#attributes.totalrecords2#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
	  </table>
  </cfif>

	<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
	  <tr>
	  <td class="headbold" height="35"><cf_get_lang no ='940.Red Edilen Müşteriler'></td>
	  </tr>
	  </table>
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr class="color-border">
	<td>
	<table border="0" width="100%" cellpadding="2" cellspacing="1">
                    <tr class="color-header">
                      <td  width="20" height="22" class="form-title"><cf_get_lang_main no='75.No'></td>
                       <td  height="22" class="form-title" width="200"><cf_get_lang no ='936.Talepte Bulunan Depo'></td>
					   <td  height="22" class="form-title" width="180"><cf_get_lang no ='937.Talepte Bulunan Kişi'></td>
                       <td class="form-title"><cf_get_lang no ='938.Talep Tarihi'></td>
					   <td class="form-title"><cf_get_lang_main no='338.İşyeri Adı'></td>
					   <td class="form-title"><cf_get_lang no ='35.Müşteri Tipi'></td>
					   <td class="form-title"><cf_get_lang_main no ='70.Aşama'></td>
                    </tr>
					<cfif get_company_red.recordcount>
					<cfoutput query="get_company_red">
					   <cfquery name="GET_COMPANY_PROCESS1" datasource="#dsn#">
					   		SELECT STAGE, LINE_NUMBER FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #company_state#
					   </cfquery>
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td>#currentrow#</td>
						<td>#branch_name# / #department_head#</td>
						<td>#get_emp_info(record_emp,0,1)#</td>
						<td>#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</td>
						<td><a href="#request.self#?fuseaction=crm.detail_company&cpid=#company_id#" class="tableyazi">#fullname#</a></td>
						<td>#companycat#</td>
						<td>#get_company_process1.stage#</td>
					</tr>
					</cfoutput>
					<cfelse>
                      <tr class="color-row" height="20">
                        <td colspan="8"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
                      </tr>
			  </cfif>
            </table>
		  </td>
		</tr>
	  </table>
    </td>
  </tr>
</table>
<br/>
<!-- sil -->
<script type="text/javascript">
	document.form.keyword.focus();
</script>
<!-- sil -->

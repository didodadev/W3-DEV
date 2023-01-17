<cfquery name="get_accident" datasource="#dsn#">
	SELECT
		ASSET_P_ACCIDENT.ACCIDENT_ID,
		ASSET_P_ACCIDENT.EMPLOYEE_ID,
		ASSET_P_ACCIDENT.ASSETP_ID,
		ASSET_P_ACCIDENT.ACCIDENT_DATE,
		ASSET_P_ACCIDENT.DOCUMENT_NUM,
		ASSET_P_ACCIDENT.INSURANCE_PAYMENT,
		ASSET_P.ASSETP,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD,
		SETUP_ACCIDENT_TYPE.ACCIDENT_TYPE_NAME,
		SETUP_FAULT_RATIO.FAULT_RATIO_NAME
	FROM
		ASSET_P_ACCIDENT,
		ASSET_P,
		BRANCH,
		DEPARTMENT,
		SETUP_ACCIDENT_TYPE,
		SETUP_FAULT_RATIO
	WHERE
	 	ACCIDENT_ID = #attributes.accident_id# AND
		ASSET_P.ASSETP_ID = ASSET_P_ACCIDENT.ASSETP_ID AND
		DEPARTMENT.DEPARTMENT_ID = ASSET_P_ACCIDENT.DEPARTMENT_ID AND		
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND
		SETUP_ACCIDENT_TYPE.ACCIDENT_TYPE_ID = ASSET_P_ACCIDENT.ACCIDENT_TYPE_ID AND
		SETUP_FAULT_RATIO.FAULT_RATIO_ID = ASSET_P_ACCIDENT.FAULT_RATIO_ID
</cfquery>
<cfoutput query="get_accident">
<cfsavecontent variable="title_">
	#accident_id# <cf_get_lang no='451.Nolu'>  #dateformat(accident_date,dateformat_style)# <cf_get_lang no='450.tarihli kaza'>
</cfsavecontent>
<cf_box title="#title_#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
  <table width="100%" height="100%">
	  <tr style="height:22px;">		    
		<td class="txtbold" width="80"><cf_get_lang_main no='1656.Plaka'></td>
		<td width="180">#get_accident.assetp#</td>
		<td class="txtbold" width="100"><cf_get_lang_main no='468.Belge No'></td>
		<td>#document_num#</td>
	  </tr>
	  <tr height="22">
		<td class="txtbold"><cf_get_lang_main no='132.Sorumlu'></td>
		<td>#get_emp_info(employee_id,0,1)# </td>
		<td class="txtbold"><cf_get_lang no='398.Kusur Oranı'></td>
		<td>#fault_ratio_name#</td>
	  </tr>
	  <tr height="22">
		<td class="txtbold"><cf_get_lang_main no='2234.Lokasyon'></td>
		<td>#branch_name# - #department_head#</td>
		<td class="txtbold"><cf_get_lang no='399.Sigorta Ödemesi'></td>
		<td><cfif #insurance_payment# eq 0><cf_get_lang_main no='1134.Yok'><cfelse><cf_get_lang_main no='1152.Var'></cfif></td>
	  </tr>
	  <tr height="22">
		<td class="txtbold"><cf_get_lang no='395.Kaza Tarihi'></td>
		<td>#dateformat(accident_date,dateformat_style)#</td>
		<td class="txtbold"><cf_get_lang_main no='721.Fatura No'></td>
		<td></td>
	  </tr>
	  <tr height="22">
		<td class="txtbold"><cf_get_lang no='397.Kaza Tipi'></td>
		<td>#accident_type_name#</td>
		<td class="txtbold"><cf_get_lang no='452.Fatura Tutarı'></td>
		<td></td>
	  </tr>		
  </table>
</cf_box>
</cfoutput>

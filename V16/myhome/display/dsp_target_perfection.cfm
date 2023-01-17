<cfparam name="attributes.period" default="#year(now())#">
<cfparam name="attributes.keyword" default="">
<cfquery name="GET_POSITION" datasource="#dsn#">
	SELECT 
		POSITION_CODE,
		DEPARTMENT_ID 
	FROM 
		EMPLOYEE_POSITIONS 
	WHERE 
		EMPLOYEE_ID=#session.ep.userid#
	ORDER BY 
		EMPLOYEE_ID
</cfquery>
<cfscript>
	if (get_position.recordcount){
		position_list = valuelist(get_position.position_code,',');
		department_list = valuelist(get_position.department_id,',');
	}
	else{
		position_list = session.ep.position_code;
		department_list = 0;
	}
</cfscript>
<cfquery name="GET_DEPARTMENT" datasource="#dsn#">
	SELECT 
	DISTINCT 
		D.DEPARTMENT_HEAD,
		D.ADMIN1_POSITION_CODE,
		D.ADMIN2_POSITION_CODE,
		D.DEPARTMENT_ID,
		OC.COMP_ID
	FROM 
		DEPARTMENT D,
		BRANCH B,
		OUR_COMPANY OC
	WHERE 
		D.BRANCH_ID = B.BRANCH_ID AND
		B.COMPANY_ID = OC.COMP_ID AND
		(
			D.ADMIN1_POSITION_CODE IN (#position_list#) OR 
			D.ADMIN2_POSITION_CODE IN (#position_list#) OR 
			D.DEPARTMENT_ID IN (#department_list#)
		)
	ORDER BY 
		D.DEPARTMENT_ID
</cfquery>
<cfif get_department.recordcount>
	<cfset company_list = valuelist(get_department.comp_id,',')>
	<cfset all_department_list = valuelist(get_department.department_id,',')>
<cfelse>
	<cfset company_list = "">
	<cfset all_department_list = 0>
</cfif>
<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT 
		COMPANY_NAME,
		COMP_ID,
		NICK_NAME,
		MANAGER_POSITION_CODE,
		MANAGER_POSITION_CODE2
	FROM 
		OUR_COMPANY 
	WHERE 
		MANAGER_POSITION_CODE IN (#position_list#) OR MANAGER_POSITION_CODE2 IN (#position_list#)
		<cfif listlen(company_list,',')>OR COMP_ID IN(#company_list#)</cfif>
</cfquery>
<cfquery name="GET_PERFECTION" datasource="#dsn#">
	SELECT
		O.COMPANY_NAME,
		OCT.OUR_COMPANY_TARGET_ID,
		OCT.PERIOD,
		OCT.VIZYON,
		OCT.RECORD_DATE,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
		OUR_COMPANY_TARGET OCT,
		EMPLOYEES E,
		OUR_COMPANY O
	WHERE
		OCT.COMPANY_ID = O.COMP_ID AND
		OCT.RECORD_EMP = E.EMPLOYEE_ID  
		<cfif not session.ep.ehesap>
		AND 
		(OCT.COMPANY_ID IN (#valuelist(get_company.comp_id,',')#)
		OR OCT.COMPANY_ID IN (
				SELECT 
					PCR.COMPANY_ID 
				FROM 
					PERF_CHIEF PC,
					PERF_CHIEF_ROW PCR 
				WHERE 
					PC.PER_CHIEF_ID = PCR.PERF_CHIEF_ID AND
					PC.PERIOD = #session.ep.period_year# AND
					PCR.EMPLOYEE_ID = #session.ep.userid# AND
					PCR.TYPE = 1)
		)
		</cfif>
		<cfif len(attributes.period)>AND OCT.PERIOD = #attributes.period#</cfif>
		<cfif len(attributes.keyword)>AND O.COMPANY_NAME LIKE '%#attributes.keyword#%'</cfif>
	ORDER BY 
		O.COMPANY_NAME
</cfquery>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_perfection.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
	<td valign="top">	
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr> 
    <td height="35" class="headbold"><cf_get_lang dictionary_id="31341.Hedef Yetkinlik Belirleme"></td>
	<!-- sil -->
    <td  style="text-align:right;"> 
      <table>
        <cfform name="form" action="#request.self#?fuseaction=myhome.dsp_target_perfection" method="post">
          <tr> 
            <td><cf_get_lang dictionary_id='57460.Filtre'></td>
            <td><input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>"></td>
			<td><select name="period" id="period" style="width:70px;">
				<option value=""><cf_get_lang dictionary_id='58455.Yıl'>
				<cfloop from="2005" to="#year(now())+1#" index="i">
					<cfoutput>
					<option value="#i#" <cfif attributes.period eq i>selected</cfif>>#i#</option>
					</cfoutput>
				</cfloop>
			  </select></td>
            <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
			<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
            <td><cf_wrk_search_button></td>
  			<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
          </tr>
        </cfform>
      </table>	  
    </td>
	<!-- sil -->
  </tr>
</table>
<table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
  <tr class="color-border"> 
    <td> 
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-header"> 
          <td height="22" class="form-title" width="30"><cf_get_lang dictionary_id='57487.No'></td>
          <td class="form-title"><cf_get_lang dictionary_id="57574.Şirket"></td>
		  <td class="form-title" width="40"><cf_get_lang dictionary_id='58472.Dönem'></td>
          <td class="form-title" width="250"><cf_get_lang dictionary_id="57758.Vizyon"></td>
		  <td class="form-title" width="180"><cf_get_lang dictionary_id="57483.Kayıt"></td>
		  <td width="18"><a href="<cfoutput>#request.self#?fuseaction=myhome.form_add_target_perfection</cfoutput>"><img src="/images/plus_square.gif" align="absmiddle" border="0"></a></td>
        </tr>
		<cfif get_perfection.recordcount>
		<cfoutput query="get_perfection" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
       <tr height="20" onMouseOver="this.bgColor='#colorlist#';" onMouseOut="this.bgColor='#colorrow#';" bgcolor="#colorrow#">
          <td>#currentrow#</td>
		  <td>#company_name#</td>
		  <td>#period#</td>
		  <td>#vizyon#</td>
		  <td>#employee_name# #employee_surname# - #dateformat(record_date,dateformat_style)#</td>
		  <td><a href="#request.self#?fuseaction=myhome.detail_target_perfection&myhome.detail_target_perfection&target_id=#our_company_target_id#"><img src="/images/update_list.gif" align="absmiddle" border="0"></a></td>
        </tr>
		</cfoutput>
	<cfelse>
        <tr class="color-row"> 
          <td colspan="7" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
        </tr>
	</cfif>
      </table>
  </td>
 </tr>
</table>
<cfif attributes.maxrows lt attributes.totalrecords>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
  <tr> 
	<td>
	<cf_pages page="#attributes.page#"
	  maxrows="#attributes.maxrows#"
	  totalrecords="#attributes.totalrecords#"
	  startrow="#attributes.startrow#"
	  adres="myhome.dsp_target_perfection&keyword=#attributes.keyword#&period=#attributes.period#"> 
	</td>
	<!-- sil --><td style="text-align:right;"><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:<cfoutput>#GET_PERFECTION.recordcount#</cfoutput>-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:<cfoutput>#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
  </tr>
</table>
</cfif>
</td>
 </tr>
</table>
<script language="javascript">
	form.keyword.focus();
</script>

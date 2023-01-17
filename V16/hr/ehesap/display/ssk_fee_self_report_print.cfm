<cfinclude template="../query/get_fee.cfm">
<cfif not isDefined("attributes.document_date")>
<cf_popup_box title="İşyeri Kaza Bildirim Formu">
<cfform name="kaza_document" method="post" action="">
    <table>
      <input type="hidden" name="iframe" id="iframe" value="1">
      <tr>
        <td width="75"><cf_get_lang dictionary_id="57742.Tarih"></td>
		<td>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id="56704.Tarih Hatalı">!</cfsavecontent>
        <cfinput style="width:230px;" type="text" name="document_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" required="yes">
       <cf_wrk_date_image date_field="document_date"> 
        </td>
      </tr>
      <tr>
		<td><cf_get_lang dictionary_id="58820.Başlık"></td>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id="58059.Başlık Girmelisiniz">!</cfsavecontent>
        <td><cfinput style="width:250px;" type="text" name="document_head" value="Bölge Müdürlüğüne;" maxlength="200" message="#message#" required="yes"></td>
      </tr>
      <tr>
        <td valign="top"><cf_get_lang dictionary_id="57629.Açıklama"></td>
        <td>
            <TEXTAREA name="document_detail" id="document_detail" style="width:250px;height:80px;"></TEXTAREA>
        </td>
      </tr>
    </table>
    <cf_popup_box_footer><cf_workcube_buttons is_upd='0' insert_info = 'Yazdır'> </cf_popup_box_footer>
</cfform>
</cf_popup_box>
<cfelse>
	<cfset attributes.employee_id = GET_FEE.employee_id>
	<cfquery name="BIRTH" datasource="#dsn#">
		SELECT 
			BIRTH_DATE 
		FROM 
			EMPLOYEES_IDENTY 
		WHERE 
			EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
	</cfquery>
	<cfquery name="DETAIL" datasource="#dsn#">
		SELECT 
		 	START_DATE AS STARTDATE,
		    SOCIALSECURITY_NO
		FROM
			EMPLOYEES_IN_OUT
		WHERE 
			EMPLOYEES_IN_OUT.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
	</cfquery>
	<cfquery name="SSK" datasource="#dsn#">
		SELECT 
			BRANCH.SSK_NO,
			BRANCH.SSK_M,
			BRANCH.SSK_JOB,
			BRANCH.SSK_BRANCH,     
			BRANCH.SSK_CITY,
			BRANCH.SSK_CD,
			BRANCH.SSK_COUNTRY,
			BRANCH.BRANCH_ADDRESS,
			BRANCH.BRANCH_COUNTY,
			BRANCH.BRANCH_CITY,
			BRANCH.BRANCH_FULLNAME,
			OUR_COMPANY.COMPANY_NAME,
			OUR_COMPANY.MANAGER
		FROM 
			EMPLOYEE_POSITIONS,
			BRANCH,
			DEPARTMENT,
			OUR_COMPANY
		WHERE 
			EMPLOYEE_POSITIONS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
			AND DEPARTMENT.DEPARTMENT_ID = EMPLOYEE_POSITIONS.DEPARTMENT_ID
			AND BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID  
			AND OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
		<cfif not session.ep.ehesap>
			AND 
			BRANCH.BRANCH_ID IN (
								SELECT
									BRANCH_ID
								FROM
									EMPLOYEE_POSITION_BRANCHES
								WHERE
									EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
								)
		</cfif>
	</cfquery>
<cfinclude template="../query/get_employee.cfm">
<table cellpadding="0" cellspacing="0" style="height:280mm;width:190mm;" align="center" border="0" bordercolor="#CCCCCC">
	<tr>
	<td align="center"><cfinclude template="../../../objects/display/view_company_logo.cfm"></td>
	</tr>
	<tr>
		<td align="center"  class="headbold" height="100%" valign="top">
			<br/><br/>
			<cfoutput>
<table width="100%">
  <tr>
    <td  class="formbold" style="text-align:right;">#dateformat(attributes.document_date,dateformat_style)#</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><font style="font-size: 13px;">#attributes.document_head#</font></td>
  </tr>
  <tr>
    <td>
	<br/>
	#attributes.document_detail#
	</td>
  </tr>
  <tr>
    <td  style="text-align:right;">
	<br/>
	<br/><br/>
	<cf_get_lang dictionary_id="45897.Adı Soyadı ve İmzası">		
  </td>
  </tr>
    <tr>
    <td>
	<cf_get_lang dictionary_id="58723.ADRES">:<br/>
	<strong>#SSK.BRANCH_FULLNAME#</strong><br/>
	#SSK.BRANCH_ADDRESS# #SSK.BRANCH_COUNTY# #SSK.BRANCH_CITY#	
	</td>
  </tr>  
    <tr>
    <td>
	<br/><br/>
	* <cf_get_lang dictionary_id="59449.Olay Tutanağı Ektedir">.
	</td>
  </tr>
</table>
			</cfoutput>
		</td>
	</tr>
	<tr>
	<td align="center"><cfinclude template="../../../objects/display/view_company_info.cfm"></td>
	</tr>
</table>
<!--- 1.sayfa print --->
<!--- 2.sayfa print --->
<table cellpadding="0" cellspacing="0" style="height:280mm;width:190mm;" align="center" border="0" bordercolor="#CCCCCC">
	<tr>
	<td align="center"><cfinclude template="../../../objects/display/view_company_logo.cfm"></td>
	</tr>
	<tr>
		<td align="center"  class="headbold" height="100%" valign="top">
			<br/><br/>
			
<table border="0" align="center" cellspacing="0" width="650">
  <tr> 
    <td width="100%" colspan="3"> 
	<table width="100%">
        <tr> 
          <td colspan="2"  style="text-align:right;">
		    <cfoutput>
		  <strong><cf_get_lang dictionary_id="57742.Tarih">:#dateformat(get_fee.fee_date,dateformat_style)# - #get_fee.fee_hour#:00
		  </cfoutput>
		  </td>
        </tr>
        <tr> 
          <td width="18%"  style="text-align:right;"><strong><cf_get_lang dictionary_id="59450.İşyerinin Ünvanı">:</strong></td>
          <td width="82%"><cfoutput query="SSK">#BRANCH_FULLNAME#</cfoutput></td>
        </tr>
        <tr> 
          <td  style="text-align:right;"> <strong><cf_get_lang dictionary_id="49318.Adresi">:</strong></td>
          <td><cfoutput query="SSK">#BRANCH_ADDRESS#&nbsp;&nbsp;#BRANCH_COUNTY#/#BRANCH_CITY#</cfoutput></td>
        </tr>
        <tr>
          <td  style="text-align:right;"><strong><cf_get_lang dictionary_id="33779.SGK NO">:</strong></td>
          <td>
		   <cfoutput query="SSK">
		  #ssk_m# #ssk_job# #ssk_branch# #ssk_no# #ssk_city# #ssk_country# #ssk_cd#
		  </cfoutput>
		  </td>
        </tr>       
      </table>
	  </td>
  </tr>
  <tr> 
    <td width="100" height="30">&nbsp;&nbsp;&nbsp;1) <cf_get_lang dictionary_id="32328.Sicil No"></td>
    <td width="150"><cfoutput query="detail">#socialsecurity_no#</cfoutput>&nbsp;</td>
  </tr>
  <tr height="30"> 
    <td>&nbsp;&nbsp;&nbsp;2) <cf_get_lang dictionary_id="32370.Adı Soyadı"></td>
    <td><cfoutput>#get_employee.employee_name# #get_employee.employee_surname#</cfoutput></td>
  </tr>
  <tr height="30"> 
    <td>&nbsp;&nbsp;&nbsp;3) <cf_get_lang dictionary_id="58727.Doğum Tarihi"></td>
    <td><cfoutput query="birth">#dateformat(birth_date,dateformat_style)#</cfoutput>&nbsp;</td>

  </tr>
  <tr height="30"> 
    <td>&nbsp;&nbsp;&nbsp;4) <cf_get_lang dictionary_id="56543.İşe Giriş Tarihi"></td>
    <td><cfoutput query="detail">#dateformat(startdate,dateformat_style)#</cfoutput>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;&nbsp;&nbsp;5) <cf_get_lang dictionary_id="59451.Viziteye Çıkmak İçin İşyerinden Ayrıldığı Tarih ve Saat"></td>
    <td><cfoutput>#dateformat(get_fee.fee_dateout,dateformat_style)# - #get_fee.fee_hourout#:00</cfoutput>&nbsp;</td>
  </tr>
  <tr> 
    <td height="30">&nbsp;&nbsp;&nbsp;6) <cf_get_lang dictionary_id="59452.Olay Tarihindeki İşçi Sayısı"></td>
    <td>
	<cfoutput>
	#get_fee.total_emp#
	</cfoutput> &nbsp;
	</td>
  </tr>
  <tr height="30"> 
    <td>&nbsp;&nbsp;&nbsp;7) <cf_get_lang dictionary_id="59453.Sigortalının yaptığı iş ve bu işin mahiyeti"></td>
    <td>
	<cfoutput>
	#get_fee.emp_work#
	</cfoutput>&nbsp;
	</td>
  </tr>
  <tr> 
    <td>&nbsp;&nbsp;&nbsp;8) <cf_get_lang dictionary_id="59454.İş Kazasının Olş. Şekli,vuku bulduğu yer, tarih ve saat">:</td>
    <td>
	<cfoutput>
          #get_fee.event# - #get_fee.place# - #dateformat(get_fee.event_date,dateformat_style)# <cfif len(get_fee.event_hour)>#get_fee.event_hour#:#get_fee.event_min#</cfif> 
	</cfoutput>&nbsp;
	</td>
  </tr>
  <tr height="30"> 
    <td>&nbsp;&nbsp;&nbsp;9) <cf_get_lang dictionary_id="53472.Olay Günündeki İşbaşı Saati">:</td>
    <td>
	<cfif len(get_fee.workstart)>
	<cfoutput>
	#get_fee.workstart#
	</cfoutput>
	</cfif>&nbsp;
	</td>
  </tr>
  <tr height="30"> 
    <td>&nbsp;&nbsp;&nbsp;10) <cf_get_lang dictionary_id="59444.Tanıkların Adı ve Soyadları"></td>
    <td>
	<cfoutput>
	#get_fee.witness1#<br/>#get_fee.witness2#
	</cfoutput>&nbsp;</td>
  </tr>
</table>
	
		</td>
	</tr>
	<tr>
	<td align="center"><cfinclude template="../../../objects/display/view_company_info.cfm"></td>
	</tr>
</table>
<script>
	window.print();
</script>
</cfif>

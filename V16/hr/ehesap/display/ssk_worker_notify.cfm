<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
<cfparam name="attributes.sal_year" default="#year(now())#">
<cfinclude template="../query/get_ssk_offices.cfm">
<cfif not isDefined("attributes.print")> 
<cf_box title="#getlang('','İşçi Bildirim Listesi','32108')#">
<cfform name="employee" method="post"> 	
	<cf_box_search>
		<div class="form-group">
		  <input type="text" name="hierarchy" placeholder="<cf_get_lang dictionary_id="57789.Özel Kod">" id="hierarchy" maxlength="50" value="<cfif isdefined("attributes.hierarchy")><cfoutput>#attributes.hierarchy#</cfoutput></cfif>" style="width:100px;">
		  </div>
		<div class="form-group">
			<select name="SSK_OFFICE" id="SSK_OFFICE" style="width:200px;" > 
			  <cfoutput query="GET_SSK_OFFICES"> 
				  <option value="#branch_id#" <cfif isdefined("attributes.ssk_office") and attributes.ssk_office is '#branch_id#'>selected</cfif>>#BRANCH_NAME#-#SSK_OFFICE#-#SSK_NO#</option> 
			  </cfoutput> 
			</select> 
		</div>
		<div class="form-group">
			<select name="sal_mon" id="sal_mon"> 
			  <cfif session.ep.period_year lt dateformat(now(),'YYYY')> 
				<cfloop from="1" to="12" index="i"> 
				  <cfoutput> 
					<option value="#i#" <cfif isdefined("attributes.sal_mon") and attributes.sal_mon eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option> 
				  </cfoutput> 
				</cfloop> 
				<cfelse> 
				<cfloop from="1" to="12" index="i"> 
				  <cfoutput> 
					<option value="#i#" <cfif isdefined("attributes.sal_mon") and attributes.sal_mon eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option> 
				  </cfoutput> 
				</cfloop> 
			  </cfif> 
			</select>
		</div>
		<div class="form-group">
                <select name="sal_year" id="sal_year">
                    <option value=""><cf_get_lang dictionary_id='58455.Yıl'></option>
                    <cfloop from="-3" to="3" index="i">
                        <cfoutput><option value="#year(now()) + i#"<cfif attributes.sal_year eq (year(now()) + i)> selected</cfif>>#year(now()) + i#</option></cfoutput>
                    </cfloop>
                </select>
			</div>
		<div class="form-group"><cf_wrk_search_button button_type="4"></div>
</cf_box_search>
</cfform>
</cf_box>
<cfelse> 
	<script type="text/javascript">
		function waitfor(){
		  window.close();
		}
		setTimeout("waitfor()",3000);
		window.opener.close();
		window.print();
	</script> 
</cfif>

<cfif not isdefined("attributes.SSK_OFFICE")> 
	<cfexit method="exittemplate"> 
</cfif> 
<cfquery name="GET_COMPANY_INFO" datasource="#dsn#">
	SELECT COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID = #SESSION.EP.COMPANY_ID#
</cfquery> 
<cfquery name="GET_BRANCH_INFO" datasource="#dsn#">
	SELECT * FROM BRANCH WHERE
	BRANCH_ID = #attributes.SSK_OFFICE#
	<!--- <cfif database_type is "MSSQL">
		SSK_OFFICE + '-' + SSK_NO = '#attributes.SSK_OFFICE#'
	<cfelseif database_type is "DB2"> 
		SSK_OFFICE || '-' || SSK_NO = '#attributes.SSK_OFFICE#'
	</cfif>  --->
</cfquery> 

<cfparam name="attributes.maxrows" default=16>
<cfparam name="attributes.mode" default=16>
<cfinclude template="../query/get_ssk_employees_full.cfm"> 
<cf_box title="#getlang('','İşçi Bildirim Listesi','52981')#" uidrop="1">
<div class="ui-scroll ListContent">
<cfoutput query="get_ssk_employees_full">
<cfif ((currentrow mod attributes.mode is 1)) or (currentrow eq 1)><!--- print için gerekli if --->
<table cellpadding="0" cellspacing="0" align="center" border="0">
	<tr>
	<!--- <td>&nbsp;</td> --->
	<td >
		<table border="0" align="center" cellpadding="0" cellspacing="0"> 
		  <tr> 
			<td>
			 <table  border="0" cellspacing="0" cellpadding="0"> 
				<tr> 
				  <td CLASS="HEADBOLD" height="35" colspan="2"><cf_get_lang dictionary_id="32589.EK">-1 <cf_get_lang dictionary_id="32108.İŞÇİ BİLDİRİM LİSTESİ"></td> 
				</tr> 
				<tr> 
				  <td width="145" height="25" valign="top" class="txtbold"><cf_get_lang dictionary_id="59450.İŞYERİNİN ÜNVANI"> <br/><cf_get_lang dictionary_id="49318.ADRESİ">
				  </td> 
				  <td width="355">&nbsp;#get_branch_info.BRANCH_FULLNAME#<br/> 
					  #get_branch_info.BRANCH_ADDRESS# #get_branch_info.BRANCH_POSTCODE# #get_branch_info.BRANCH_COUNTY# #get_branch_info.BRANCH_CITY#
				  </td> 
				</tr> 
				<tr> 
				  <td height="25">&nbsp;</td> 
				  <td>&nbsp;</td> 
				</tr> 
				<tr> 
				  <td height="25" nowrap="nowrap"><cf_get_lang dictionary_id="42752.İŞYERİNDE YAPILAN İŞ"></td> 
				  <td>#GET_BRANCH_INFO.real_work#</td> 
				</tr> 
			  </table>
			</td> 
			<td width="50%" valign="left"> 
			<table border="0" cellspacing="0" cellpadding="0"> 
				<tr class="formbold"> 
				  <td height="25" colspan="3"><cf_get_lang dictionary_id="36245.İŞYERİNİN"></td> 
				</tr> 
				<tr> 
				  <td width="145" height="25"><cf_get_lang dictionary_id="39973.İŞKOLU"></td> 
				  <td width="50" align="center">(1)</td> 
				  <td> <table border="1" cellspacing="0" cellpadding="0" bordercolor="CCCCCC"> 
					  <tr HEIGHT="20"> 
						<td>#get_branch_info.BRANCH_WORK#</td> 
					  </tr> 
					</table></td> 
				</tr> 
				<tr> 
				  <td valign="left"><cf_get_lang dictionary_id="46483.BÖLGE MÜDÜRLÜĞÜ DOSYA NUMARASI"></td> 
				  <td align="center" valign="top">(2)</td> 
				  <td align="left"> <table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="CCCCCC"> 
					  <tr align="center"> 
						<td>S</td> 
						<td><cf_get_lang dictionary_id="55494.MESLEK"></td> 
						<td><cf_get_lang dictionary_id="50132.DOSYA NO"></td> 
						<td><cf_get_lang dictionary_id="58608.İL"></td> 
					  </tr> 
					  <tr> 
						<td width="20">#get_branch_info.WORK_ZONE_M#</td> 
						<td>#get_branch_info.WORK_ZONE_JOB#</td> 
						<td>#get_branch_info.WORK_ZONE_FILE#</td> 
						<td>#get_branch_info.WORK_ZONE_CITY#</td> 
					  </tr> 
					</table> 
					<br/> </td> 
				</tr> 
				<tr> 
				  <td><cf_get_lang dictionary_id="53821.SOSYAL SİGORTALAR KURUMU"> <cf_get_lang dictionary_id="53823.İŞYERİ SİCİL NO"></td> 
				  <td align="center" valign="left">(3)</td> 
				  <td align="left"> 
				  	<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="CCCCCC"> 
					  <tr align="center"> 
						<td>S</td> 
						<td><cf_get_lang dictionary_id="55494.MESLEK"></td> 
						<td>ŞB.</td> 
						<td><cf_get_lang dictionary_id="50132.DOSYA NO"></td>
						<td><cf_get_lang dictionary_id="58608.İL"></td> 
						<td><cf_get_lang dictionary_id="58638.İLÇE"></td> 
						<td>CD NO</td> 
					  </tr> 
					  <tr> 
						<td width="20">#get_branch_info.SSK_M#</td> 
						<td>#get_branch_info.SSK_JOB#</td> 
						<td>#get_branch_info.SSK_BRANCH#</td> 
						<td>#get_branch_info.SSK_NO#</td> 
						<td>#get_branch_info.SSK_CITY#</td> 
						<td>#get_branch_info.SSK_COUNTRY#</td> 
						<td>#get_branch_info.SSK_CD#&nbsp;</td> 
					  </tr> 
					</table>
					</td> 
				</tr> 
			  </table>
			  </td> 
		  </tr> 
		</table> 
		<br/> 
		<table border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC"> 
		  <tr> 
			<td height="35" colspan="8" align="center" CLASS="HEADBOLD"><cf_get_lang dictionary_id="45049.İşçi"></td> 
			<td rowspan="2" class="FORMBOLD" align="center" width="90"><cf_get_lang dictionary_id="32328.SİCİL NO"> (11)</td> 
		  </tr> 
		  <tr CLASS="TXTBOLD"> 
			<td height="22"><cf_get_lang dictionary_id="32370.ADI SOYADI"> (4)</td>
			<td width="70"><cf_get_lang dictionary_id="58025.TC KİMLİK"></td>
			<td><cf_get_lang dictionary_id="58033.BABA ADI">(5)</td> 
			<td width="80"><cf_get_lang dictionary_id="58727.DOĞUM TARİHİ">(6)</td> 
			<td width="25">C(7)</td> 
			<td width="95"><cf_get_lang dictionary_id="30201.GÖREV"> <cf_get_lang dictionary_id="32646.KODU">(8)</td> 
			<td width="90"><cf_get_lang dictionary_id="38923.İŞE GİRİŞ TARİHİ">(9)</td> 
			<td width="100"><cf_get_lang dictionary_id="30489.Sosyal Güvenlik Kurumu">(10)</td> 
		  </tr> 
</cfif><!--- print için gerekli if --->
    <tr> 
      <td height="22">&nbsp;#employee_name# #employee_surname#</td> 
	  <td>&nbsp;#TC_IDENTY_NO#</td>
      <td>&nbsp;#FATHER#</td> 
      <td>&nbsp; 
        <cfif LEN(BIRTH_DATE)> 
          #dateformat(BIRTH_DATE,dateformat_style)# 
        </cfif></td> 
      <td>&nbsp;<cfif SEX EQ 1>E<cfelseif SEX EQ 0>K</cfif></td> 
      <td>&nbsp;
	  <cfif DUTY_TYPE eq 1>1
	  <cfelse>4
	  </cfif>
	  </td> 
      <td width="50">&nbsp;<cfif LEN(STARTDATE)>#dateformat(STARTDATE,dateformat_style)#</cfif></td> 
      <td><cfswitch expression="#SSK_STATUTE#"> 
		  <cfcase value="1">1</cfcase> 
          <cfcase value="2">1</cfcase>
		  <cfcase value="3">1</cfcase>
		  <cfcase value="50">2</cfcase> 
          <cfcase value="60">3</cfcase>
		  <cfcase value="70">4</cfcase> 
        </cfswitch> 
        &nbsp;</td> 
      <td width="80"><cfif SSK_STATUTE eq 2 or SSK_STATUTE eq 18>#RETIRED_SGDP_NUMBER#<cfelse>#SOCIALSECURITY_NO#</cfif></td> <!---Muzaffer Yeraltı Gurubu--->
	</tr> 
<cfif (currentrow mod attributes.mode is 0) or (get_ssk_employees_full.recordcount eq currentrow)><!--- print için gerekli if --->
</table> 
<br/> 
<table border="0" align="center" cellpadding="0" cellspacing="0"> 
  <tr class="FORMBOLD"> 
    <td height="25">(8)<cf_get_lang dictionary_id="30201.GÖREV"> <cf_get_lang dictionary_id="32646.KODU"></td> 
    <td>&nbsp;</td> 
    <td>&nbsp;</td> 
    <td>&nbsp;</td> 
    <td>(10)<cf_get_lang dictionary_id="30489.SOSYAL GÜVENLİK KURULUŞ KODU"></td> 
    <td>&nbsp;</td> 
    <td>&nbsp;</td> 
    <td>&nbsp;</td> 
    <td><cf_get_lang dictionary_id="45901.İŞVEREN VEYA VEKİLİNİN"></td> 
    <td>&nbsp;</td> 
  </tr> 
  <tr> 
    <td height="25"><cf_get_lang dictionary_id="56405.İŞVEREN VEKİLİ"></td> 
    <td>1</td> 
    <td>&nbsp;</td> 
    <td>&nbsp;</td> 
    <td><cf_get_lang dictionary_id="58714.SGK"></td> 
    <td>1</td> 
    <td>&nbsp;</td> 
    <td>&nbsp;</td> 
    <td><cf_get_lang dictionary_id="32370.ADI SOYADI"></td> 
    <td>
		<cfif len(get_branch_info.ADMIN1_POSITION_CODE)>
            <cfset attributes.position_code = get_branch_info.ADMIN1_POSITION_CODE>
            <cfinclude template="../query/get_position_employee.cfm">
            <cfset admin1 = "#GET_POSITION_EMPLOYEE.EMPLOYEE_NAME# #GET_POSITION_EMPLOYEE.EMPLOYEE_SURNAME#">
           <strong>#admin1#</strong>         
         </cfif>
	</td> 
  </tr> 
  <tr> 
    <td height="25"><cf_get_lang dictionary_id="58156.DİĞER"> <cf_get_lang dictionary_id="59503.İDARİ GÖREVLİLER"></td> 
    <td>2</td> 
    <td>&nbsp;</td> 
    <td>&nbsp;</td> 
    <td><cf_get_lang dictionary_id="56422.EMEKLİ SANDIĞI"></td> 
    <td>2</td> 
    <td>&nbsp;</td> 
    <td>&nbsp;</td> 
    <td><cf_get_lang dictionary_id="57742.TARİH"></td> 
    <td><strong>#dateformat(now(),dateformat_style)#</strong></td> 
  </tr> 
  <tr> 
    <td height="25"><cf_get_lang dictionary_id="59504.GÜVENLİK GÖREVLİLERİ"></td> 
    <td>3</td> 
    <td>&nbsp;</td> 
    <td>&nbsp;</td> 
    <td><cf_get_lang dictionary_id="56423.BANKA VE DİĞERLERİ"></td> 
    <td>3</td> 
    <td>&nbsp;</td> 
    <td>&nbsp;</td> 
    <td><cf_get_lang dictionary_id="58957.İMZA"></td> 
    <td>&nbsp;</td> 
  </tr> 
  <tr> 
    <td height="25"><cf_get_lang dictionary_id="45159.DİĞERLERİ"></td> 
    <td>4</td> 
    <td>&nbsp;</td> 
    <td>&nbsp;</td> 
    <td><cf_get_lang dictionary_id="53956.BAĞ-KUR"></td> 
    <td>4</td> 
    <td>&nbsp;</td> 
    <td>&nbsp;</td> 
    <td>&nbsp;</td> 
    <td>&nbsp;</td> 
  </tr> 
</table> 
<br/> 
</td>
</tr>
</table>
<div style="page-break-before:always;"></div>
</cfif><!--- print için gerekli if --->
</cfoutput>
</div>
</cf_box>

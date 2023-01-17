<cfquery name="get_employee_detail" datasource="#DSN#">
	SELECT 
		E.*,
		ED.*,
		EP.POSITION_NAME 
	FROM 
		EMPLOYEES E,
		EMPLOYEES_DETAIL ED, 
		EMPLOYEE_POSITIONS EP 
	WHERE 
		E.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# 
	AND 
		E.EMPLOYEE_ID = ED.EMPLOYEE_ID 
	AND 
		E.EMPLOYEE_ID = EP.EMPLOYEE_ID
</cfquery>
  <table width="650" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
    <tr>
      <td class="headbold" align="center"><cf_get_lang no='13.KURUM İÇİ EĞİTMEN BİLGİ FORMU'></td>	   
    </tr>
  </table>
<cfoutput query="get_employee_detail">
        <table width="650" border="0" cellspacing="0" cellpadding="0" align="center">
          <tr clasS="color-border">
            <td>
              <table width="100%" border="0" cellspacing="1" cellpadding="2">
                <tr class="color-row">
                  <td valign="top">
                    <table border="0">
                      <tr>
                        <td class="txtbold" width="150"><cf_get_lang_main no='158.Ad Soyad'></td>
                        <td width="250">:#employee_name# #employee_surname# </td>
                        <td width="250" rowspan="7" valign="top" style="text-align:right;"><cfif len(PHOTO)><img src="/documents/hr/#PHOTO#" width="105" height="136"></cfif></td>
                      </tr>
                      <tr>
                        <td class="txtbold"><cf_get_lang_main no='216.Giriş Tarihi'></td>
                        <td>:#dateformat(GROUP_STARTDATE,dateformat_style)#
                        </td>
                      </tr>
                      <tr>
                        <td class="txtbold"><cf_get_lang_main no='161.Görev'></td>
                        <td>:#TASK#
                        </td>
                      </tr>
                      <tr>
                        <td class="txtbold"><cf_get_lang no='18.Son Mezun Olduğu Okul'></td>
                        <td>:
						<cfquery name="get_school_" datasource="#dsn#" maxrows="1">
							SELECT
								*
							FROM
								EMPLOYEES_APP_EDU_INFO
							WHERE
								EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
							ORDER BY EDU_START DESC
						</cfquery>
						<cfif get_school_.recordcount>
							#get_school_.edu_name#
						</cfif>
						<!--- <cfif len(EDU4)> 20071127 yd
						#edu4#
						<cfelseif len(EDU3)>	
						#edu3#
						<cfelseif len(EDU2)>	
						#edu2#
						<cfelseif len(EDU1)>	
						#edu1#
						</cfif> --->
                        </td>
                      </tr>
					  <tr>
                        <td class="txtbold"><cf_get_lang no='19.Meslek'></td>
                        <td>:#POSITION_NAME#</td>
				      </tr>                      
					    <tr>
                        <td class="txtbold"><cf_get_lang no='26.Önceki İş Tecrübesi'></td>
                        <td>:#EXP1# #EXP2# #EXP3#</td>
                      </tr>
					  <tr>
                        <td valign="top" class="txtbold"><cf_get_lang no='27.Uzmanlık Alanları'></td>
                        <td valign="top">: 
						<cfif len(TOOLS)>
							<cfloop from="1" to="#listlen(tools,";")#" index="i" step="2">
								 #listgetat(TOOLS,i,';')#
							</cfloop>
						</cfif>
						</td>
                      </tr>
                   </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
</cfoutput>

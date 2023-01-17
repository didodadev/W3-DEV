<cfprocessingdirective suppresswhitespace="Yes">
<!-- sil -->
<cfinclude template="../ehesap/query/get_ssk_offices.cfm">
<cfif not isdefined("attributes.sal_mon")>
<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
    <cfform name="employee" method="post">
      <tr class="color-border">
        <td>
          <table width="100%" cellpadding="2" cellspacing="1">
            <tr class="color-row">
              <td>
                <table>
                  <tr>
				  	<td class="headbold"><cf_get_lang dictionary_id='56035.Şube İcmal'></td>
                    <td>
                      <select name="SSK_OFFICE" id="SSK_OFFICE">
						<cfoutput query="GET_SSK_OFFICES">
                          <cfif len(SSK_OFFICE) and len(SSK_NO)>
                            <option value="#SSK_OFFICE#-#SSK_NO#-#BRANCH_ID#">#BRANCH_NAME#-#SSK_OFFICE#-#SSK_NO#</option>
                          </cfif>
                        </cfoutput>
                      </select>
                      <select name="sal_mon" id="sal_mon">
                        <cfif session.ep.period_year lt dateformat(now(),'YYYY')>
                          <cfloop from="1" to="12" index="i">
                            <cfoutput>
                              <option value="#i#" <cfif attributes.sal_mon is i>selected</cfif> >#listgetat(ay_list(),i,',')#</option>
                            </cfoutput>
                          </cfloop>
                          <cfelse>
                          <cfloop from="1" to="#evaluate(dateformat(now(),'MM'))#" index="i">
                            <cfoutput>
                              <option value="#i#" <cfif attributes.sal_mon is i>selected</cfif> >#listgetat(ay_list(),i,',')#</option>
                            </cfoutput>
                          </cfloop>
                        </cfif>
                      </select>
                      <input type="text" name="sal_year" id="sal_year" readonly value="<cfoutput>#session.ep.period_year#</cfoutput>" style="width:50px;">
                      <input type="text" name="hierarchy" id="hierarchy" maxlength="50" value="<cfif isdefined("attributes.hierarchy")><cfoutput>#attributes.hierarchy#</cfoutput></cfif>" style="width:100px;">
                    </td>
                    <td width="25">
                      <cf_wrk_search_button>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </cfform>
  </table>
  <cfexit method="exittemplate">
<cfelse>
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr class="color-border">
      <td>
        <table width="100%" cellpadding="2" cellspacing="1">
          <tr class="color-row">
            <td>
              <table>
                <cfform name="employee" method="post">
                  <tr>
				  <td class="headbold"><cf_get_lang dictionary_id='56035.Şube İcmal'></td>
				  
                    <td>
                      <select name="SSK_OFFICE" id="SSK_OFFICE">
					  		<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                        <cfoutput query="GET_SSK_OFFICES">
                          <cfif len(SSK_OFFICE) and len(SSK_NO)>
                            <option value="#SSK_OFFICE#-#SSK_NO#-#BRANCH_ID#" <cfif attributes.SSK_OFFICE eq "#SSK_OFFICE#-#SSK_NO#">selected</cfif>>#BRANCH_NAME#-#SSK_OFFICE#-#SSK_NO#</option>
                          </cfif>
                        </cfoutput>
                      </select>
                      <select name="sal_mon" id="sal_mon">
                        <cfif session.ep.period_year lt dateformat(now(),'YYYY')>
                          <cfloop from="1" to="12" index="i">
                            <cfoutput>
                              <option value="#i#" <cfif attributes.sal_mon eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option><!---  --->
                            </cfoutput>
                          </cfloop>
                          <cfelse>
                          <cfloop from="1" to="#evaluate(dateformat(now(),'MM'))#" index="i">
                            <cfoutput>
                              <option value="#i#" <cfif attributes.sal_mon eq i>selected</cfif> >#listgetat(ay_list(),i,',')#</option><!--- --->
                            </cfoutput>
                          </cfloop>
                        </cfif>
                      </select>
                      <input type="text" name="sal_year" id="sal_year" readonly value="<cfoutput>#session.ep.period_year#</cfoutput>" style="width:50px;">
                      <input type="text" name="hierarchy" id="hierarchy" maxlength="50" value="<cfif isdefined("attributes.hierarchy")><cfoutput>#attributes.hierarchy#</cfoutput></cfif>" style="width:100px;">
                    </td>
                    <td width="25">
                      <cf_wrk_search_button>
                    <cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popupflush_view_puantaj_print_pdf_agi&SSK_OFFICE=#attributes.SSK_OFFICE#&HIERARCHY=&SAL_YEAR=#attributes.SAL_YEAR#&SAL_MON=#attributes.SAL_MON#','page');"><img src="/images/family.gif" title="<cf_get_lang no ='324.PDF Ön İzlemeli Yazdır'>" border="0"></a></cfoutput>
					</td>
					<cf_workcube_file_action pdf='0' mail='1' doc='0' print='1'>					
                  </tr>
                </cfform>
              </table>
            </td>			
          </tr>
        </table>
      </td>
    </tr>
  </table>
</cfif>
<br/>
<cfinclude template="../ehesap/query/get_branch.cfm">
<cfinclude template="../ehesap/query/get_puantaj.cfm">
<cfif not get_puantaj.recordcount>
	<!--- puantaj oluşturulur --->
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='53768.Önce Puantaj Aktarımı Yapınız'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfset attributes.puantaj_id = get_puantaj.puantaj_id>
<cfinclude template="../ehesap/query/get_puantaj_rows.cfm">
<cfif not GET_PUANTAJ_ROWS.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfinclude template="../query/get_emp_codes.cfm">
<cfquery name="get_ogis" datasource="#dsn#">
	SELECT
		SUM(OGIR.DAMGA_VERGISI) AS OGI_DAMGA_TOPLAM,
		SUM(OGIR.ODENECEK_TUTAR) AS OGI_ODENECEK_TOPLAM
	FROM
		EMPLOYEES_OZEL_GIDER_IND_ROWS AS OGIR,
		EMPLOYEES_OZEL_GIDER_IND AS OGI,
		EMPLOYEES
	WHERE
		EMPLOYEES.EMPLOYEE_ID = OGIR.EMPLOYEE_ID AND
		OGI.PERIOD_YEAR = #attributes.SAL_YEAR# AND
		OGI.PERIOD_MONTH = #attributes.SAL_MON# AND
		<!--- BRANCH_ID IN (#VALUELIST(GET_BRANCH.BRANCH_ID)#) AND --->
		OGI.SSK_OFFICE = '#listgetat(attributes.SSK_OFFICE,1,'-')#' AND
		OGI.SSK_NO = '#listgetat(attributes.SSK_OFFICE,2,'-')#' AND
		OGIR.OZEL_GIDER_IND_ID = OGI.OZEL_GIDER_IND_ID
	<cfif fusebox.dynamic_hierarchy>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND 
				('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
					
			<cfelseif database_type is "DB2">
				AND 
				('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
					
			</cfif>
		</cfloop>
	<cfelse>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND ('.' + EMPLOYEES.HIERARCHY + '.') LIKE '%.#code_i#.%'
			<cfelseif database_type is "DB2">
				AND ('.' || EMPLOYEES.HIERARCHY || '.') LIKE '%.#code_i#.%'
			</cfif>
		</cfloop>
	</cfif>
</cfquery>

<cfquery name="get_kumulatif_gelir_vergisi" datasource="#dsn#">
	SELECT 
		SUM(EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI) AS TOPLAM
	FROM
		EMPLOYEES,
		EMPLOYEES_PUANTAJ,
		EMPLOYEES_PUANTAJ_ROWS
	WHERE
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
		EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND
		EMPLOYEES_PUANTAJ.SAL_YEAR = #SESSION.EP.PERIOD_YEAR# AND
		EMPLOYEES_PUANTAJ.SAL_MON < #attributes.SAL_MON# AND
		SSK_BRANCH_ID = '#LISTGETAT(attributes.SSK_OFFICE,3,'-')#'
	<cfif fusebox.dynamic_hierarchy>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND 
				('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
					
			<cfelseif database_type is "DB2">
				AND 
				('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
					
			</cfif>
		</cfloop>
	<cfelse>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND ('.' + EMPLOYEES.HIERARCHY + '.') LIKE '%.#code_i#.%'
			<cfelseif database_type is "DB2">
				AND ('.' || EMPLOYEES.HIERARCHY || '.') LIKE '%.#code_i#.%'
			</cfif>
		</cfloop>
	</cfif>
</cfquery>

<cfquery name="get_odeneks" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES_PUANTAJ_ROWS_EXT
	WHERE
		EMPLOYEE_PUANTAJ_ID IN (#VALUELIST(GET_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID)#) AND
		EXT_TYPE = 0
	ORDER BY
		COMMENT_PAY
</cfquery>
<cfquery name="get_kesintis" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES_PUANTAJ_ROWS_EXT
	WHERE
		EMPLOYEE_PUANTAJ_ID IN (#VALUELIST(GET_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID)#) AND
		EXT_TYPE = 1
	ORDER BY
		COMMENT_PAY
</cfquery>
<cfquery name="get_vergi_istisnas" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES_PUANTAJ_ROWS_EXT
	WHERE
		EMPLOYEE_PUANTAJ_ID IN (#VALUELIST(GET_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID)#) AND
		EXT_TYPE = 2
	ORDER BY
		COMMENT_PAY
</cfquery>

<cfset query_name = "get_puantaj_rows">
<cfset icmal_type = "genel">
<cfset kisi_say = get_puantaj_rows.recordcount>
<!-- sil -->
<cfinclude template="../ehesap/display/view_icmal.cfm">
</cfprocessingdirective>

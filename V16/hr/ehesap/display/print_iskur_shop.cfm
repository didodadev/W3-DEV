<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.sal_mon" default="#month(now())#">
<cfparam name="attributes.multi_branch_id" default="">
<cfparam name="attributes.city_id" default="">
<cfinclude template="../query/get_ssk_offices.cfm">
<cfif not isDefined("attributes.print")>

<cf_box title="#getlang('','İşkur Bildirimleri','47127')#">
	<cfform name="get_managers" action="" method="post">
	<cf_box_search>
    <div class="form-group">
      <select id="select_type" name="select_type" style="width:150px;height:23px" onchange="show_select()">
        <option value=""><cf_get_lang dictionary_id="40170.Listemeleme yöntemi"></option>
        <option value="1"><cf_get_lang dictionary_id="58608.İl"></option>
        <option value="2"><cf_get_lang dictionary_id="57453.Şube"></option>
      </select>
    </div>

        
    <script>
      function show_select() {
        if(document.getElementById("select_type").value == 1)
        {
          document.getElementById("city").style.display= '';
          document.getElementById("branch").style.display = 'none';
        }else if(document.getElementById("select_type").value == 2){
          document.getElementById("city").style.display = 'none';
          document.getElementById("branch").style.display = '';
        }else{
          document.getElementById("city").style.display = 'none';
          document.getElementById("branch").style.display = 'none';
        }
        
      }
      </script>
     <div class="form-group" id="city" style="<cfif not len(attributes.city_id)>display:none</cfif>">
      <select id="city_id" name="city_id" style="width:150px;height:23px" >
        <option value=""><cf_get_lang dictionary_id="31644.İl seçiniz"></option>
        <cfoutput query="GET_CITY_ID">
          <option value="#BRANCH_CITY#" <cfif isdefined("attributes.city_id") and (attributes.city_id eq BRANCH_CITY)> selected</cfif>>
            #BRANCH_CITY#
          </option>
        </cfoutput>
      </select>
     </div>
     <div class="form-group medium"  id="branch" style="<cfif not len(attributes.multi_branch_id)>display:none</cfif>">
      <cfsavecontent variable="message"><cf_get_lang dictionary_id="30126.Şube Seçiniz"></cfsavecontent>
        <cf_multiselect_check 
          query_name="GET_SSK_OFFICES"  
          option_text="#message#"
          name="multi_branch_id" 
          width="250"
          option_name="branch_name-ssk_office-ssk_no" 
          option_value="branch_id" 
          value="#attributes.multi_branch_id#"
          > 
     </div>
     <div class="form-group">
      <input type="text" name="hierarchy" id="hierarchy" maxlength="50" value="<cfif isdefined("attributes.hierarchy")><cfoutput>#attributes.hierarchy#</cfoutput></cfif>" style="width:100px;">
     </div>
     <div class="form-group">
      <cf_wrk_search_button button_type="4">
     </div>
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
<cfif (isdefined("attributes.multi_branch_id") and len(attributes.multi_branch_id)) or len(attributes.city_id) >
  <cfinclude template="../query/get_branch.cfm">
<cfset this_month_starts = CreateDate(attributes.SAL_YEAR, attributes.SAL_MON, 1)>
<!--- <cfset this_month_ends = CreateDate(attributes.SAL_YEAR, attributes.SAL_MON, daysinmonth(this_month_starts))> --->
<cfset this_month_ends = date_add('m',1,this_month_starts)>
<cfinclude template="../../query/get_emp_codes.cfm">
<cfquery name="get_all_personel" datasource="#dsn#">
	SELECT
		EMPLOYEES_IN_OUT.EMPLOYEE_ID,
		EMPLOYEES_IN_OUT.START_DATE,
		EMPLOYEES_IN_OUT.FINISH_DATE,
		EMPLOYEES_DETAIL.SEX,
		EMPLOYEES_DETAIL.TERROR_WRONGED,
		EMPLOYEES_DETAIL.SENTENCED_SIX_MONTH,
		EMPLOYEES_IN_OUT.DEFECTION_LEVEL
	FROM
		BRANCH,
		EMPLOYEES,
		EMPLOYEES_IN_OUT,
		EMPLOYEES_DETAIL
	WHERE
		EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
		EMPLOYEES_DETAIL.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
		EMPLOYEES_IN_OUT.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#"> AND
		(
			EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#">
			OR
			EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
		)
    AND BRANCH.BRANCH_ID = EMPLOYEES_IN_OUT.BRANCH_ID
    <cfif isdefined("attributes.multi_branch_id") and len(attributes.multi_branch_id)>
      AND BRANCH.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multi_branch_id#" list="yes"> )
    </cfif>
    <cfif  isdefined("attributes.city_id") and len(attributes.city_id)>
      AND BRANCH.BRANCH_CITY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.city_id#">
    </cfif>
 
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

<cfif NOT get_all_personel.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='54638.Çalışan Kaydı Bulunamadı'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfquery name="cirak_count" datasource="#dsn#">
	SELECT
		EMPLOYEE_ID
	FROM
		EMPLOYEES_IN_OUT
	WHERE
		SSK_STATUTE = 4
		AND EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#valuelist(get_all_personel.employee_id)#">)
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="52961.İşkur Bildirimleri"></cfsavecontent>
<cf_box title="#message#" uidrop="1">
  <div class="ui-scroll ListContent">
  <cfoutput> <br/>
    <br/>
    <table width="650" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td  class="txtbold" style="text-align:right;"> <cf_get_lang dictionary_id="46710.İŞ KURUMU"> <br/> <cf_get_lang dictionary_id="46519.İŞYERİ BİLGİ FORMU"> </td>
      </tr>
      <tr>
        <td height="30"><cf_get_lang dictionary_id="46695.İŞYERİ NUMARASI">:</td>
      </tr>
    </table>
    <table border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC">
      <tr>
        <td width="300" valign="top"><cf_get_lang dictionary_id="57571.Ünvanı"> : #get_branch.company_name# - #get_branch.branch_fullname#</td>
        <td width="175" valign="top"><cf_get_lang dictionary_id="46696.Ana Faaliyet Konusu">: #get_branch.REAL_WORK#</td>
        <td width="175" valign="top"><cf_get_lang dictionary_id="46694.Faaliyet Kodu">: #get_branch.BRANCH_WORK#</td>
      </tr>
      <tr>
        <td height="200" valign="top">
          <table width="200" height="100%">
            <tr>
              <td height="100%" valign="top"><cf_get_lang dictionary_id="58723.Adres">:<br/>#get_branch.BRANCH_ADDRESS# #get_branch.BRANCH_COUNTY# #get_branch.BRANCH_CITY#</td>
            </tr>
            <tr>
              <td><cf_get_lang dictionary_id="57499.Telefon">: #get_branch.BRANCH_TELCODE# #get_branch.BRANCH_TEL1#</td>
            </tr>
            <tr>
              <td>Fax: #get_branch.BRANCH_TELCODE# #get_branch.BRANCH_FAX#</td>
            </tr>
          </table>
        </td>
        <td colspan="2" valign="top"><table width="100%" border="0" cellspacing="0">
            <tr>
              <td colspan="4" class="txtbold"><cf_get_lang dictionary_id="57499.Bağlantı Kurulacak Kişi"></td>
            </tr>
            <tr>
              <td width="20"><cf_get_lang dictionary_id="57487.No"></td>
              <td><cf_get_lang dictionary_id="55757.Adı Soyadı"></td>
              <td><cf_get_lang dictionary_id="53916.Görevi"></td>
              <td><cf_get_lang dictionary_id="57499.Telefon"></td>
            </tr>
            <tr>
              <td width="20">1-</td>
              <td>
                <cfset admin1 = "">
                <cfif len(get_branch.ADMIN1_POSITION_CODE)>
                  <cfset attributes.position_code = get_branch.ADMIN1_POSITION_CODE>
                  <cfinclude template="../query/get_hr_homeadress.cfm">
                  <cfset admin1 = "#GET_HR_HOMEADRESS.EMPLOYEE_NAME# #GET_HR_HOMEADRESS.EMPLOYEE_SURNAME#">
                  <strong>#admin1#</strong>
                </cfif>
              </td>
              <td>
                <cfif len(get_branch.ADMIN1_POSITION_CODE)>
                  <cfquery name="GET_POSITION" datasource="#DSN#">
                  SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch.admin1_position_code#">
                  </cfquery>
                  <strong>#GET_POSITION.POSITION_NAME#</strong>
                </cfif>
              </td>
              <td>
                <cfif len(get_branch.ADMIN1_POSITION_CODE)>
                  #GET_HR_HOMEADRESS.DIRECT_TELCODE# #GET_HR_HOMEADRESS.DIRECT_TEL#
                </cfif>
              </td>
            </tr>
            <tr>
              <td width="20">2-</td>
              <td>
                <cfset admin2 = "">
                <cfif len(get_branch.ADMIN2_POSITION_CODE)>
                  <cfset attributes.position_code = get_branch.ADMIN2_POSITION_CODE>
                  <cfinclude template="../query/get_hr_homeadress.cfm">
                  <cfset admin2 = "#GET_HR_HOMEADRESS.EMPLOYEE_NAME# #GET_HR_HOMEADRESS.EMPLOYEE_SURNAME#">
                  <strong>#admin2#</strong>
                </cfif>
              </td>
              <td>
                <cfif len(get_branch.ADMIN2_POSITION_CODE)>
                  <cfquery name="GET_POSITION" datasource="#DSN#">
                  	SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch.admin2_position_code#">
                  </cfquery>
                  <strong>#GET_POSITION.POSITION_NAME#</strong>
                </cfif>
              </td>
              <td>
                <cfif len(get_branch.ADMIN1_POSITION_CODE)>
                  #GET_HR_HOMEADRESS.DIRECT_TELCODE# #GET_HR_HOMEADRESS.DIRECT_TEL#
                </cfif>
              </td>
            </tr>
            <tr>
              <td width="20">3-</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td><table width="100%" height="25" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td width="130"><cf_get_lang dictionary_id="30257.Kuruluş Tarihi"></td>
              <td>: #dateformat(get_branch.FOUNDATION_DATE,dateformat_style)#</td>
            </tr>
          </table>
        </td>
        <td colspan="2"><table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td width="70" valign="middle"><cf_get_lang dictionary_id="46693.Yasal Durum"></td>
              <td width="40"  style="text-align:right;">: <cf_get_lang dictionary_id="41536.Kamu"></td>
              <td width="30"><input type="radio" name="kamu_ozel" id="kamu_ozel" value="0">
              </td>
              <td width="40"  style="text-align:right;"><cf_get_lang dictionary_id="57979.Özel"></td>
              <td><input type="radio" name="kamu_ozel" id="kamu_ozel" value="1" checked>
              </td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td><table width="100%" height="25" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td width="130"><cf_get_lang dictionary_id="46704.Üniteye Kayıt Tarihi"> </td>
              <td>: </td>
            </tr>
          </table>
        </td>
        <td colspan="2" rowspan="5"><table width="100%" border="0">
            <tr>
              <td colspan="4" class="txtbold"><cf_get_lang dictionary_id="53837.Ücret Dışı Ödemeler"></td>
            </tr>
            <tr>
              <td width="80"><cf_get_lang dictionary_id="55795.İkramiye"></td>
              <td>
                <input type="checkbox" name="checkbox" id="checkbox" value="checkbox">
                </form>
              </td>
              <td width="80"><cf_get_lang dictionary_id="55667.Ulaşım"></td>
              <td><input type="checkbox" name="checkbox7" id="checkbox7" value="checkbox">
              </td>
            </tr>
            <tr>
              <td width="80"><cf_get_lang dictionary_id="46692.Yiyecek"></td>
              <td><input type="checkbox" name="checkbox2" id="checkbox2" value="checkbox">
              </td>
              <td width="80"><cf_get_lang dictionary_id="55776.Prim"></td>
              <td><input type="checkbox" name="checkbox8" id="checkbox8" value="checkbox">
              </td>
            </tr>
            <tr>
              <td width="80"><cf_get_lang dictionary_id="48005.Yakıt"></td>
              <td><input type="checkbox" name="checkbox3" id="checkbox3" value="checkbox">
              </td>
              <td width="80"><cf_get_lang dictionary_id="58575.İzin"></td>
              <td><input type="checkbox" name="checkbox9" id="checkbox9" value="checkbox">
              </td>
            </tr>
            <tr>
              <td width="80"><cf_get_lang dictionary_id="46691.Giyecek"></td>
              <td><input type="checkbox" name="checkbox4" id="checkbox4" value="checkbox">
              </td>
              <td width="80"><cf_get_lang dictionary_id="46690.Bayram"></td>
              <td><input type="checkbox" name="checkbox10" id="checkbox10" value="checkbox">
              </td>
            </tr>
            <tr>
              <td width="80"><cf_get_lang dictionary_id="46682.Çocuk Yrd."></td>
              <td><input type="checkbox" name="checkbox5" id="checkbox5" value="checkbox">
              </td>
              <td width="80"><cf_get_lang dictionary_id="46681.Aile Yrd."></td>
              <td><input type="checkbox" name="checkbox11" id="checkbox11" value="checkbox">
              </td>
            </tr>
            <tr>
              <td width="80"><cf_get_lang dictionary_id="46680.Kira Yrd."></td>
              <td><input type="checkbox" name="checkbox6" id="checkbox6" value="checkbox">
              </td>
              <td width="80"><cf_get_lang dictionary_id="46678.Diğer Yrd."></td>
              <td><input type="checkbox" name="checkbox12" id="checkbox12" value="checkbox">
              </td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td><table width="100%" height="25" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td width="130"><cf_get_lang dictionary_id="42391.Ticaret Sicil Numarası"> </td>
              <td>: #get_branch.t_no#</td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td><table width="100%" height="25" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td width="130"><cf_get_lang dictionary_id="46564.SGK İşyeri Sicil No"></td>
              <td>:<cfloop list="#valuelist(get_branch.SSK_NO)#" delimiters="," index="sskno">
                #sskno#<br>&nbsp;
              </cfloop>
              </td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td><table width="100%" height="25" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td width="130"><cf_get_lang dictionary_id="46676.Bölge Çalışma Md. No"></td>
              <td>: #get_branch.CAL_BOL_MUD_NO#</td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td><table width="100%" height="25" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td width="130" valign="middle"><cf_get_lang dictionary_id="46675.Çırak Çalıştırıyormusunuz?"></td>
              <td width="35">: <cf_get_lang dictionary_id="57495.Evet"></td>
              <td width="40">
                <input type="radio" name="cirak_count" id="cirak_count" value="0"<cfif cirak_count.recordcount> checked</cfif>>
              </td>
              <td width="30"  valign="middle" style="text-align:right;"><cf_get_lang dictionary_id="57496.Hayır"></td>
              <td>
                <input type="radio" name="cirak_count" id="cirak_count" value="1"<cfif not cirak_count.recordcount> checked</cfif>>
              </td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td colspan="3"><table width="100%" height="25" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td width="130"><cf_get_lang dictionary_id="46673.Toplam Çalışan Sayısı"> </td>
              <td>: #get_all_personel.RECORDCOUNT#</td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td colspan="3"><table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td height="30" class="txtbold"><cf_get_lang dictionary_id="46408.Açıklamalar">:</td>
            </tr>
            <tr>
              <td height="40">&nbsp;</td>
            </tr>
            <tr>
              <td><cf_get_lang dictionary_id="57467.Not">:<cf_get_lang dictionary_id="46674.İşverenden alınan tüm bilgiler gizli tutulacaktır ve bu bilgiler işgücü piyasası bilgilerinin oluşturulmasında kullanılacaktır."></td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </cfoutput>
</div>
</cf_box>
 <cfelseif isdefined("attributes.ssk_office") and not len(attributes.ssk_office)>
 	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='58579.Lütfen şube seçiniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

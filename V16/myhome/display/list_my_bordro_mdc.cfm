<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#"> 
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.employee_id" default="#session.ep.userid#">
<cfif isdefined("attributes.is_submit")>
	<cfset is_bireysel_bordro = 1>
	<cfinclude template="../../hr/ehesap/query/get_puantaj_personal.cfm">
	<cfif GET_PUANTAJ_PERSONAL.recordcount>
		<cfquery name="get_old_mail_emp" datasource="#dsn#">
			SELECT 
				* 
			FROM 
				EMPLOYEES_PUANTAJ_MAILS 
			WHERE 
				EMPLOYEE_ID = #GET_PUANTAJ_PERSONAL.EMPLOYEE_ID# AND
				BRANCH_ID = #GET_PUANTAJ_PERSONAL.branch_id# AND 
				SAL_MON = #GET_PUANTAJ_PERSONAL.sal_mon# AND 
				SAL_YEAR = #GET_PUANTAJ_PERSONAL.sal_year#
		</cfquery>
	</cfif>
	<cfif not GET_PUANTAJ_PERSONAL.recordcount>
		<script type="text/javascript">
			alert("Bu Kişi için puantaj kaydı <cfif not session.ep.ehesap>veya Yetkiniz</cfif> Yok !");
			window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_my_bordro';
		</script>
		<cfabort>
	<cfelseif GET_PUANTAJ_PERSONAL.recordcount and isdefined("get_old_mail_emp.recordcount") and (not get_old_mail_emp.recordcount or not len(get_old_mail_emp.first_mail_date)) and GET_PUANTAJ_PERSONAL.is_locked neq 1>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='31710.Puantaj Tamamlandığına Dair Uyarı Gelmeden veya Puantaj Kilitlenmeden Bordronuzu Kontrol Edemezsiniz'>!");
			window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_my_bordro';
		</script>
		<cfabort>
	</cfif>
</cfif>


<!-- sil -->
<table width="98%" height="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
<cfinclude template="../../objects/display/tree_back.cfm">
<td valign="top"><br/> 
<cfquery name="GET_PROTESTS" datasource="#DSN#" maxrows="1">
	SELECT * FROM EMPLOYEES_PUANTAJ_PROTESTS WHERE SAL_MON=#attributes.sal_mon# AND SAL_YEAR=#attributes.sal_year# AND EMPLOYEE_ID=#session.ep.userid# ORDER BY PROTEST_ID DESC
</cfquery>
            <table width="98%" cellpadding="2" cellspacing="1" class="color-border" align="center">
            <cfform name="employee" method="post" action="">
			 <tr class="color-row">
                <td>
                  <table>
                    <tr>
					<td class="headbold"><cf_get_lang dictionary_id='31148.Bordrom'></td>
                      <td>
						<input type="hidden" name="is_submit" id="is_submit" value="1">
						<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
						<input type="text" name="employee_name" id="employee_name" readonly="yes"  value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>" style="width:150px;">
					  <td>
                        <select name="sal_mon" id="sal_mon">
                          <cfif session.ep.period_year lt dateformat(now(),'YYYY')>
                            <cfloop from="1" to="12" index="i">
                              <cfoutput><option value="#i#" <cfif attributes.sal_mon is i>selected</cfif> >#listgetat(ay_list(),i,',')#</option></cfoutput><!--- --->
                            </cfloop>
                            <cfelse>
                            <cfloop from="1" to="#evaluate(dateformat(now(),'MM'))#" index="i">
                              <cfoutput><option value="#i#" <cfif attributes.sal_mon is i>selected</cfif> >#listgetat(ay_list(),i,',')#</option></cfoutput><!--- --->
                            </cfloop>
                          </cfif>
                        </select>
                      </td>
                      <td><input name="sal_year" id="sal_year" type="text" value="<cfoutput>#attributes.sal_year#</cfoutput>" readonly style="width:50px;"></td>
                      <td width="15"><cf_wrk_search_button></td>
					  <cf_workcube_file_action pdf='1' mail='1' doc='0' print='1' trail='0'>
					  <cfif isdefined("attributes.is_submit") and GET_PUANTAJ_PERSONAL.recordcount>
						  <td>
								<cfif get_old_mail_emp.recordcount>
									<cfquery name="upd_" datasource="#dsn#">
										UPDATE 
											EMPLOYEES_PUANTAJ_MAILS 
										SET 
											<cfif len(get_old_mail_emp.FIRST_READ_DATE)>
												LAST_READ_DATE = #NOW()#
											<cfelse>
												FIRST_READ_DATE = #NOW()#
											</cfif>
										WHERE 
											ROW_ID = #get_old_mail_emp.ROW_ID#
									</cfquery>
								<cfelse>
									<cfquery name="add_" datasource="#dsn#">
										INSERT INTO
											EMPLOYEES_PUANTAJ_MAILS 
											(
											EMPLOYEE_ID,
											SAL_MON,
											SAL_YEAR,
											BRANCH_ID,
											SSK_OFFICE_NO,
											SSK_OFFICE,
											FIRST_READ_DATE
											)
											VALUES
											(
											#GET_PUANTAJ_PERSONAL.EMPLOYEE_ID#,
											#GET_PUANTAJ_PERSONAL.sal_mon#,
											#GET_PUANTAJ_PERSONAL.sal_year#,
											#GET_PUANTAJ_PERSONAL.BRANCH_ID#,
											'#GET_PUANTAJ_PERSONAL.SSK_OFFICE_NO#',
											'#GET_PUANTAJ_PERSONAL.SSK_OFFICE#',
											#now()#	
											)
									</cfquery>
								</cfif>
						   <img src="/images/notkalem.gif" title="<cf_get_lang dictionary_id='31779.Puantaj Hazırlandı'>">
						   <cfif get_old_mail_emp.recordcount and (len(get_old_mail_emp.first_mail_date) or len(get_old_mail_emp.last_mail_date))><img src="/images/messenger8.gif" title="<cf_get_lang dictionary_id='31243.eMail Gönderildi'>"></cfif>
						   <img src="/images/messenger4.gif" title="Bordro Okundu">
						   <cfif get_protests.recordcount><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_list_bordro_protests&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&emp_puantaj_id=#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#&puantaj_id=#GET_PUANTAJ_PERSONAL.PUANTAJ_ID#</cfoutput>','list');"><img src="/images/messenger7.gif" title="<cf_get_lang dictionary_id='31714.itiraz Etti'>" border="0"></a></cfif>
						   <cfif get_protests.recordcount and len(get_protests.answer_date)><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_list_bordro_protests&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&emp_puantaj_id=#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#&puantaj_id=#GET_PUANTAJ_PERSONAL.PUANTAJ_ID#</cfoutput>','list');"><img src="/images/messenger2.gif" title="<cf_get_lang dictionary_id='31716.Cevaplandı'>" border="0"></a></cfif>
							<cfif not get_protests.recordcount>
								<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_add_puantaj_protest&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&emp_puantaj_id=#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#&puantaj_id=#GET_PUANTAJ_PERSONAL.PUANTAJ_ID#&branch_id=#GET_PUANTAJ_PERSONAL.branch_id#</cfoutput>','small');"><img src="/images/messenger5.gif" title="<cf_get_lang dictionary_id='31715.İtiraz Et'>" border="0"></a>
							</cfif>
						  </td>
					  </cfif>
					  </tr>
                  </table>
                </td>
              </tr>
			  </cfform>
            </table>
<!-- sil -->
<cfif isdefined("attributes.is_submit")>

	<cfscript>
	function QueryRow(Query,Row) 
		{
		var tmp = QueryNew(Query.ColumnList);
		QueryAddRow(tmp,1);
		for(x=1;x lte ListLen(tmp.ColumnList);x=x+1) QuerySetCell(tmp, ListGetAt(tmp.ColumnList,x), query[ListGetAt(tmp.ColumnList,x)][row]);
		return tmp;
		}
	</cfscript>
		<cfquery name="get_ogis" datasource="#dsn#"><!--- Ã¶zel gider indirimi sube ile baglanabilirdi ama gerek yok x yilin y ayinda bir kisi icin bir satir olabilir --->
			SELECT
				OGIR.DAMGA_VERGISI AS OGI_DAMGA_TOPLAM,
				OGIR.ODENECEK_TUTAR AS OGI_ODENECEK_TOPLAM
			FROM
				EMPLOYEES_OZEL_GIDER_IND_ROWS AS OGIR,
				EMPLOYEES_OZEL_GIDER_IND AS OGI
			WHERE
				OGIR.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
				OGI.PERIOD_YEAR = #attributes.SAL_YEAR# AND
				OGI.PERIOD_MONTH = #attributes.SAL_MON# AND
				OGIR.OZEL_GIDER_IND_ID = OGI.OZEL_GIDER_IND_ID
		</cfquery>
		<cfif not get_ogis.recordcount>
			<!--- HS20050215 ocak ayinda bu tutarlar puantajdan gelen kisiye bagli olmadigi icin 0 set ediliyor --->
			<cfset get_ogis.OGI_DAMGA_TOPLAM = 0>
			<cfset get_ogis.OGI_ODENECEK_TOPLAM = 0>
		</cfif>

		<cfquery name="get_kumulatif_gelir_vergisi" datasource="#dsn#">
			SELECT SUM(EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI) AS TOPLAM FROM EMPLOYEES_PUANTAJ, EMPLOYEES_PUANTAJ_ROWS WHERE EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND EMPLOYEES_PUANTAJ.SAL_YEAR = #session.ep.period_year# AND EMPLOYEES_PUANTAJ.SAL_MON < #attributes.SAL_MON# AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		</cfquery>
		<cfquery name="get_odeneks" datasource="#dsn#">
			SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EMPLOYEE_PUANTAJ_ID = #GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID# AND EXT_TYPE = 0 ORDER BY COMMENT_PAY
		</cfquery>
		<cfquery name="get_kesintis" datasource="#dsn#">
			SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EMPLOYEE_PUANTAJ_ID = #GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID# AND EXT_TYPE = 1 ORDER BY COMMENT_PAY
		</cfquery>
		<cfquery name="get_vergi_istisnas" datasource="#dsn#">
			SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EMPLOYEE_PUANTAJ_ID = #GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID# AND EXT_TYPE = 2 ORDER BY COMMENT_PAY
		</cfquery>
		<cfset icmal_type = "personal">
		<cfoutput query="get_puantaj_personal">
			<cfset temp_query_1 = QueryRow(get_puantaj_personal,currentrow)>
			<cfset query_name = "temp_query_1">
				<cfset this_birth_date_ = BIRTH_DATE>
                        <table cellpadding="0" cellspacing="0" width="98%" align="center">
                            <tr>
                                <td valign="top">
                                    <cfinclude template="view_icmal.cfm">
                                </td>
                            </tr>
                        </table>
                </cfoutput>
            </cfif>
        </td>
    </tr>
</table>


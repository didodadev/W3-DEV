<cfset attributes.employee_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.employee_id,accountKey:'wrk')>
<script type="text/javascript">
	if(!confirm('Bordronuza dair kişisel verileriniz görüntülenecektir. Devam etmek istiyor musunuz?') )
	{
		history.back();
	}
</script>
<cfset is_bireysel_bordro = 1>
<cfinclude template="../../hr/ehesap/query/get_puantaj_personal.cfm">
<cfif GET_PUANTAJ_PERSONAL.recordcount>
    <cfquery name="get_old_mail_emp" datasource="#dsn#">
        SELECT 
            * 
        FROM 
            EMPLOYEES_PUANTAJ_MAILS 
        WHERE 
            EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.employee_id#"> AND
            BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.branch_id#"> AND 
            SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.sal_mon#"> AND 
            SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.sal_year#">
    </cfquery>
</cfif>
<cfif not GET_PUANTAJ_PERSONAL.recordcount>
    <script type="text/javascript">
        alert("<cf_get_lang dictionary_id='31711.Bu çalışan için puantaj kaydı'> <cfif not session.ep.ehesap><cf_get_lang dictionary_id='31712.veya Yetkiniz'></cfif><cf_get_lang dictionary_id='58546.Yok'>!");
        //window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_extre';
    </script>
    <cfabort>
<cfelseif (not get_old_mail_emp.recordcount or (get_old_mail_emp.recordcount and not len(get_old_mail_emp.first_mail_date) and not len(get_old_mail_emp.last_mail_date) and not len(get_old_mail_emp.cau_mail_date))) and GET_PUANTAJ_PERSONAL.is_locked neq 1>
    <script type="text/javascript">
        alert("<cf_get_lang dictionary_id='31710.Puantaj Tamamlandığına Dair Uyarı Gelmeden veya Puantaj Kilitlenmeden Bordronuzu Kontrol Edemezsiniz'>!");
        //window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_extre';
    </script>
    <cfabort>
</cfif>
<cfquery name="GET_PROTESTS" datasource="#DSN#" maxrows="1">
	SELECT * FROM EMPLOYEES_PUANTAJ_PROTESTS WHERE SAL_MON=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND SAL_YEAR=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EMPLOYEE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> ORDER BY PROTEST_ID DESC
</cfquery>
<cfquery name="GET_DET_FORM" datasource="#dsn3#">
    SELECT 
        SPF.IS_XML,
        SPF.TEMPLATE_FILE,
        SPF.FORM_ID,
        SPF.IS_DEFAULT,
        SPF.NAME,
        SPF.PROCESS_TYPE,
        SPF.MODULE_ID,
        SPFC.PRINT_NAME
    FROM 
        SETUP_PRINT_FILES SPF,
        #dsn_alias#.SETUP_PRINT_FILES_CATS SPFC,
        #dsn_alias#.MODULES MOD
    WHERE
        SPF.ACTIVE = 1 AND
        SPF.MODULE_ID = MOD.MODULE_ID AND
        SPFC.PRINT_TYPE = SPF.PROCESS_TYPE AND 
        SPFC.PRINT_TYPE = 177 AND <!--- bordro--->
        SPF.IS_DEFAULT = 1
    ORDER BY
        SPF.IS_XML,
        SPF.NAME
</cfquery>
<cfif GET_DET_FORM.recordcount>
    <cfinclude template="#file_web_path#settings/#GET_DET_FORM.template_file#">
<cfelse>
    <cfscript>
        function QueryRow(Query,Row) 
            {
            var tmp = QueryNew(Query.ColumnList);
            QueryAddRow(tmp,1);
            for(x=1;x lte ListLen(tmp.ColumnList);x=x+1) QuerySetCell(tmp, ListGetAt(tmp.ColumnList,x), query[ListGetAt(tmp.ColumnList,x)][row]);
            return tmp;
            }
    </cfscript>
    <cfquery name="get_ogis" datasource="#dsn#"><!--- özel gider indirimi sube ile baglanabilirdi ama gerek yok x yilin y ayinda bir kisi icin bir satir olabilir --->
        SELECT
            OGIR.DAMGA_VERGISI AS OGI_DAMGA_TOPLAM,
            OGIR.ODENECEK_TUTAR AS OGI_ODENECEK_TOPLAM
        FROM
            EMPLOYEES_OZEL_GIDER_IND_ROWS AS OGIR,
            EMPLOYEES_OZEL_GIDER_IND AS OGI
        WHERE
            OGIR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
            OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
            OGI.PERIOD_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
            OGIR.OZEL_GIDER_IND_ID = OGI.OZEL_GIDER_IND_ID
    </cfquery>
    <cfif not get_ogis.recordcount>
    <!--- HS20050215 ocak ayinda bu tutarlar puantajdan gelen kisiye bagli olmadigi icin 0 set ediliyor --->
    <cfset get_ogis.OGI_DAMGA_TOPLAM = 0>
    <cfset get_ogis.OGI_ODENECEK_TOPLAM = 0>
    </cfif>
    <cfquery name="get_kumulatif_gelir_vergisi" datasource="#dsn#">
        SELECT SUM(EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI) AS TOPLAM,SUM(EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI_MATRAH) AS TOPLAM_MATRAH FROM EMPLOYEES_PUANTAJ, EMPLOYEES_PUANTAJ_ROWS WHERE EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EMPLOYEES_PUANTAJ.SAL_MON < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
    </cfquery>
    <cfquery name="get_odeneks" datasource="#dsn#">
        SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.employee_puantaj_id#"> AND EXT_TYPE = 0 ORDER BY COMMENT_PAY
    </cfquery>
    <cfquery name="get_kesintis" datasource="#dsn#">
        SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE FROM_SALARY = 0 AND EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.employee_puantaj_id#"> AND EXT_TYPE = 1 ORDER BY COMMENT_PAY
    </cfquery>
	<cfquery name="get_kesintis_brut" datasource="#dsn#">
        SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE FROM_SALARY = 1 AND EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.employee_puantaj_id#"> AND EXT_TYPE = 1 ORDER BY COMMENT_PAY
    </cfquery>
    <cfquery name="get_vergi_istisnas" datasource="#dsn#">
        SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.employee_puantaj_id#"> AND EXT_TYPE = 2 ORDER BY COMMENT_PAY
    </cfquery>
    <cfset icmal_type = "personal">
    <cfoutput query="get_puantaj_personal">
    <cfset temp_query_1 = QueryRow(get_puantaj_personal,currentrow)>
    <cfset query_name = "temp_query_1">
    
        <table cellpadding="0" cellspacing="0" width="100%" align="center">
            <tr>
                <td valign="top">
                    <!-- sil --><cfinclude template="../../hr/ehesap/display/view_icmal.cfm">
                </td>
                <!-- sil -->
                <!--- <td width="150" class="color-list" valign="top">
               
                        <table width="95%" align="center" cellpadding="3" cellspacing="0" border="1" style="font-size:16px;font-weight:bold;">
                            <tr>
                                <td style="text-align:center;" height="65"><cf_get_lang no ='1021.Puantaj Hazırlandı'></td>
                            </tr>
                        </table>
                   
                    <cfif len(get_old_mail_emp.first_mail_date)>
                        <table width="95%" align="center" cellpadding="3" cellspacing="0" border="1" style="font-size:16px;font-weight:bold;">
                            <tr>
                                <td style="text-align:center;" height="65">
                                    <cfif len(get_old_mail_emp.last_mail_date)>
                                        #dateformat(get_old_mail_emp.last_mail_date,dateformat_style)# <cf_get_lang no ='1025.Tarihinde Mail Aldınız'>
                                    <cfelse>
                                        #dateformat(get_old_mail_emp.first_mail_date,dateformat_style)# <cf_get_lang no ='1025.Tarihinde Mail Aldınız'>
                                    </cfif>
                                </td>
                            </tr>
                        </table>
                    <br/>
                    
                    </cfif>
                        <table width="95%" align="center" cellpadding="3" cellspacing="0" border="1" style="font-size:16px;font-weight:bold;">
                            <tr>
                                <td style="text-align:center;" height="65"><cf_get_lang no ='1022.Bordro Okundu'> #dateformat(now(),dateformat_style)#</td>
                            </tr>
                        </table>
                    <br/>
                    <cfquery name="get_apply_status" datasource="#dsn#">
                        SELECT 
                            APPLY_DATE,
                            ROW_ID
                        FROM 
                            EMPLOYEES_PUANTAJ_MAILS 
                        WHERE 
                            EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.employee_id#"> AND
                            BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.branch_id#"> AND 
                            SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.sal_mon#"> AND 
                            SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.sal_year#">
                    </cfquery>							
                    <div id="bordro_layer" style="height:1;width:1;display:none;"></div>
                    <table width="95%" align="center" cellpadding="3" cellspacing="0" border="1" style="font-size:16px;font-weight:bold;">
                        <tr>
                            <td style="text-align:center;" height="65" id="bordro_onay_td">
                                <cfif len(get_apply_status.apply_date)>
                                    Bordro Onaylandı #dateformat(now(),dateformat_style)#
                                <cfelse>
                                    <a href="javascript://" onclick="bordro_onayla('<cfoutput>#get_apply_status.ROW_ID#</cfoutput>');">Bordro Onayla</a>
                                </cfif>
                            </td>
                        </tr>
                    </table>
                    <br/>
                    <cfif get_protests.recordcount>
                        <table width="95%" align="center" cellpadding="3" cellspacing="0" border="1" style="font-size:16px;font-weight:bold;">
                            <tr>
                                <td style="text-align:center;" height="65"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_bordro_protests&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&emp_puantaj_id=#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#&puantaj_id=#GET_PUANTAJ_PERSONAL.PUANTAJ_ID#','list');"><cf_get_lang no ='1026.İtirazlarım'></a></td>
                            </tr>
                        </table>
                    <br/>
                    </cfif>
                    <cfif get_protests.recordcount and len(get_protests.answer_date)>
                        <table width="95%" align="center" cellpadding="3" cellspacing="0" border="1" style="font-size:16px;font-weight:bold;">
                            <tr>
                                <td style="text-align:center;" height="65"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=myhome.popup_list_bordro_protests&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&emp_puantaj_id=#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#&puantaj_id=#GET_PUANTAJ_PERSONAL.PUANTAJ_ID#','list');"><cf_get_lang no ='1027.İtirazlara Cevaplar'></a></td>
                            </tr>
                        </table>
                    <br/>
                    </cfif>
                    <cfif not get_protests.recordcount>
                        <table width="95%" align="center" cellpadding="3" cellspacing="0" border="1" style="font-size:16px;font-weight:bold;">
                            <tr>
                                <td style="text-align:center;" height="65"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=myhome.popup_add_puantaj_protest&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&emp_puantaj_id=#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#&puantaj_id=#GET_PUANTAJ_PERSONAL.PUANTAJ_ID#&branch_id=#GET_PUANTAJ_PERSONAL.branch_id#','small');"><cf_get_lang no ='957.İtiraz Et'></a></td>
                            </tr>
                        </table>
                    <br/>
                    </cfif>
                   	
                </td> --->
                <!-- sil -->
            </tr>
        </table>
    </cfoutput>
</cfif>
<script type="text/javascript">
	function bordro_onayla(row_id)
	{
		$.ajax({                
                url: '<cfoutput>#request.self#?fuseaction=myhome.emptypopup_apply_puantaj&row_id=</cfoutput>'+row_id,
                type: "GET",
                success: function (returnData) {
                  document.getElementById('bordro_onay_td').innerHTML = 'Bordro Onaylandı <cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>';
                }
				
            });
	}
</script>
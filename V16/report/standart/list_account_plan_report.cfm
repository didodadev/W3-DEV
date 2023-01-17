<!--- Hesap Plani Raporu FBS 20100419 --->
<cfparam name="attributes.module_id_control" default="22">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.code" default="">
<cfparam name="attributes.code1" default="">
<cfparam name="attributes.code2" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>

<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfif isdefined("attributes.is_submitted")>
	<cfquery name="GET_ACC_REMAINDER" datasource="#DSN2#">
        WITH CTE1 AS 
        (
            SELECT 
                * 
            FROM 
                ACCOUNT_PLAN
            WHERE
                ACCOUNT_CODE IS NOT NULL
                <cfif len(attributes.code)>AND ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.code#%"></cfif>
                <cfif len(attributes.code1)>AND ACCOUNT_CODE >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.code1#"></cfif>
                <cfif len(attributes.code2)>AND ACCOUNT_CODE <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.code2#"></cfif>
                <cfif len(attributes.keyword)>
                    AND 
                    (
                        ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> OR
                        ACCOUNT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                        <cfif session.ep.our_company_info.is_ifrs eq 1>
                            OR IFRS_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
                            OR IFRS_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                        </cfif>
                    )
                </cfif>
            
            ),
            CTE2 AS (
                        SELECT
                             CTE1.*,
                             ROW_NUMBER() OVER (ORDER BY ACCOUNT_CODE) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                        FROM
                             CTE1
                      )
                  SELECT
                        CTE2.*
                  FROM
                        CTE2
			<cfif attributes.is_excel neq 1>
                  WHERE
                        RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
            </cfif>
	</cfquery>
<cfelse>
	<cfset GET_ACC_REMAINDER.recordcount = 0>
</cfif>
<cfif GET_ACC_REMAINDER.recordcount>
	<cfparam name="attributes.totalrecords" default='#get_acc_remainder.QUERY_COUNT#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>	
</cfif>
<cfform name="form" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
<input type="hidden" name="is_submitted" id="is_submitted" value="1">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='58818.Hesaplar'></cfsavecontent>
<cf_report_list_search title="#title#">
	<cf_report_list_search_area>
        <div class="row">
            <div class="col col-12 col-xs-12">
                <div class="row formContent">
                    <div class="row" type="row">
                        <div class="col col-3 col-md-6 col-xs-12">
                            <div class="form-group">
                                <label class="col col-3"><cf_get_lang dictionary_id='57460.Filtre'></label>
                                <div class="col col-9">
                                    <cfinput type="text" name="keyword" value="#attributes.keyword#">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-3"><cf_get_lang dictionary_id='57652.Hesap'> 1</label>
                                <div class="col col-9">
                                    <div class="input-group">
                                        <cfinput type="text"name="code1" id="code1" value="#attributes.code1#" onFocus="AutoComplete_Create('code1','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'1\',0','','','form','3','250');" autocomplete="off">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:pencere_ac_muavin('form.code1');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-3"><cf_get_lang dictionary_id='57652.Hesap'> 2</label>
                                <div class="col col-9">
                                    <div class="input-group">
                                        <cfinput type="text" name="code2" id="code2" value="#attributes.code2#" onFocus="AutoComplete_Create('code2','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'1\',0','','','form','3','250');" autocomplete="off">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:pencere_ac_muavin('form.code2');"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row ReportContentBorder">
                    <div class="ReportContentFooter">
                        <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        <cfsavecontent variable="button_msg"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
                        <cf_wrk_report_search_button  is_excel='1' insert_info='#button_msg#' search_function='control()' button_type='1' >
                    </div>
                </div>
            </div>
        </div>
    </cf_report_list_search_area>
</cf_report_list_search>

</cfform>
<br />
<table cellspacing="0" cellpadding="0" border="0" width="99%" align="center">
	<tr class="color-border">
		<td>
		<table cellpadding="2" cellspacing="1" border="0" width="100%">
			<tr class="color-row" height="20">
				<cfoutput>
                    <td width="15" align="center"><a href="#request.self#?fuseaction=#attributes.fuseaction#&is_submitted=1" class="tableyazi">0</a></td>
                    <td width="15" align="center"><a href="#request.self#?fuseaction=#attributes.fuseaction#&code=1&is_submitted=1" class="tableyazi">1</a></td>
                    <td width="15" align="center"><a href="#request.self#?fuseaction=#attributes.fuseaction#&code=2&is_submitted=1" class="tableyazi">2</a></td>
                    <td width="15" align="center"><a href="#request.self#?fuseaction=#attributes.fuseaction#&code=3&is_submitted=1" class="tableyazi">3</a></td>
                    <td width="15" align="center"><a href="#request.self#?fuseaction=#attributes.fuseaction#&code=4&is_submitted=1" class="tableyazi">4</a></td>
                    <td width="15" align="center"><a href="#request.self#?fuseaction=#attributes.fuseaction#&code=5&is_submitted=1" class="tableyazi">5</a></td>
                    <td width="15" align="center"><a href="#request.self#?fuseaction=#attributes.fuseaction#&code=6&is_submitted=1" class="tableyazi">6</a></td>
                    <td width="15" align="center"><a href="#request.self#?fuseaction=#attributes.fuseaction#&code=7&is_submitted=1" class="tableyazi">7</a></td>
                    <td width="15" align="center"><a href="#request.self#?fuseaction=#attributes.fuseaction#&code=8&is_submitted=1" class="tableyazi">8</a></td>
                    <td width="15" align="center"><a href="#request.self#?fuseaction=#attributes.fuseaction#&code=9&is_submitted=1" class="tableyazi">9</a></td>
                    <td>&nbsp;</td>
				</cfoutput>
			</tr>
		</table>
		</td>
	</tr>
</table>

<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
    <cfset filename="list_account_plan_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-8">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<cfset type_ = 1>
<cfelse>
	<cfset type_ = 0>
</cfif>
<cf_report_list>    
		<thead>
            <tr>
                <th width="100"><cf_get_lang dictionary_id='38889.Hesap Kodu'></th>
                <th width="120"><cf_get_lang dictionary_id='38890.Hesap Adı'></th>
            <cfif session.ep.our_company_info.is_ifrs eq 1>
                <th width="80"><cf_get_lang dictionary_id='58130.UFRS Kod'></th>
                <th width="250"><cf_get_lang dictionary_id='58130.UFRS Kod'><cf_get_lang dictionary_id='57629.Açıklama'></th>
            </cfif>
                <th width="100"><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                <th width="200"><cf_get_lang dictionary_id='57789.Özel Kod'><cf_get_lang dictionary_id='57629.Açıklama'></th>
            </tr>
        </thead>
		<cfif isdefined("attributes.is_submitted") and get_acc_remainder.recordcount>
			<cfif attributes.is_excel eq 1>
				<cfset attributes.startrow=1>
                <cfset attributes.maxrows=get_acc_remainder.recordcount>
            </cfif>
            <tbody>
				<cfoutput query="get_acc_remainder">
                <cfif not Find(".",account_code) or listlen(account_code,".") eq 2><cfset str_line = 'txtbold'><cfelse><cfset str_line = ''></cfif>
                    <tr>
                        <td style="text-align:center;" class="#str_line#">#account_code#</td>
                        <td style="text-align:center;" class="#str_line#">#account_name#</td>
                    <cfif session.ep.our_company_info.is_ifrs eq 1>
                        <td style="text-align:center;" class="#str_line#">#ifrs_code#</td>
                        <td style="text-align:center;" class="#str_line#">#ifrs_name#</td>
                    </cfif>
                       <td style="text-align:center;" class="#str_line#">#account_code2#</td>
                      <td style="text-align:center;" class="#str_line#">#account_name2#</td>
                    </tr>
                </cfoutput>
            </tbody>
		</cfif>
	
</cf_report_list>
<cfif isdefined("is_submitted") and attributes.totalrecords gt attributes.maxrows>
<table width="98%" border="0" cellpadding="0" cellspacing="0" height="35" align="center">
	<tr>
		<td><cfset adres = '#attributes.fuseaction#&is_submitted=1'>
			<cfif len(attributes.keyword)><cfset adres = adres&'&keyword=#attributes.keyword#'></cfif>
			<cfif len(attributes.code)><cfset adres = adres&'&code=#attributes.code#'></cfif>
			<cfif len(attributes.code1)><cfset adres = adres&'&code1=#attributes.code1#'></cfif>
			<cfif len(attributes.code2)><cfset adres = adres&'&code2=#attributes.code2#'></cfif>
			<cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#adres#">
		</td>
		<!-- sil -->
		<td align="right" style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		<!-- sil -->
	</tr>
</table>
</cfif>
<script type="text/javascript">
    function control(){
 
		if(document.form.is_excel.checked==false)
			{
				document.form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.list_account_plan_report"
				return true;
			}
			else
       
				document.form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_list_account_plan_report</cfoutput>"
	}
	document.getElementById('keyword').focus();	
	function pencere_ac_muavin(alan1)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=' + alan1 + '&field_id2=' + alan1 + '&keyword=' + eval(alan1 + ".value"),'list');
	}
   

</script>

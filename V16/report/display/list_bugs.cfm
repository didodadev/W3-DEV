<cfparam name="attributes.keyword" default="">
<cfset emp_list = '2,6,1459,35,39,40,10,96,16,30,3,95,1457,4,23,28,12,29,15,292'>

<cfif isdefined("attributes.form_submitted")>
    <cfquery name="GET_BUGS" datasource="#DSN#">
		<!---SELECT
        	WORKCUBE_NAME,
            BUG_DETAIL,
            PAGE,
            BROWSER_TYPE,
            RECORD_DATE,
            RECORD_IP,
            RECORD_EMP,
            RECORD_PAR,
            RECORD_CON,
            RECORD_PDA
        FROM
        	BUGS
        WHERE
        	BUG_DETAIL <> '' OR
            BUG_DETAIL IS NOT NULL
        ORDER BY
        	BUG_ID DESC--->
        <cfloop from="1" to="#listlen(emp_list,',')#" index="i">
            SELECT
                TOP 25
                BUG_ID,
                WORKCUBE_NAME,
                BUG_DETAIL,
                PAGE,
                BROWSER_TYPE,
                RECORD_DATE,
                RECORD_IP,
                RECORD_EMP,
                RECORD_PAR,
                RECORD_CON,
                RECORD_PDA
            FROM
                BUGS
            WHERE
                RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(emp_list,i,',')#"> AND
                (BUG_DETAIL <> '' OR
                BUG_DETAIL IS NOT NULL)  
            <cfif listlast(emp_list,',') neq listgetat(emp_list,i,',')>UNION</cfif>  
		</cfloop>
        ORDER BY
            BUG_ID DESC
    </cfquery>
<cfelse>
	<cfset get_bugs.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='500'>
<cfparam name="attributes.totalrecords" default=#get_bugs.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="filter" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="Text" name="keyword" id="keyword" maxlength="255" value="#attributes.keyword#" placeholder="#getLang('','Filtre',57460)#">
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>      
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','Hata Raporları',62960)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='55657.Sıra Numarası'></th>
                    <th><cf_get_lang dictionary_id='58783.Workcube'> <cf_get_lang dictionary_id='57897.Adı'></th>
                    <th><cf_get_lang dictionary_id='42039.Hata Tanımı'></th>
                    <th><cf_get_lang dictionary_id='57581.Sayfa'></th>
                    <th><cf_get_lang dictionary_id='60646.Tarayıcı Çeşidi'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'> <cf_get_lang dictionary_id='47987.IP'></th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id='60645.Kritiklik Seviyesi'></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_bugs.recordcount>
                    <cfoutput query="get_bugs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#workcube_name#</td>
                            <td>#bug_detail#</td>
                            <td>#page#</td>
                            <td>#browser_type#</td>
                            <td>#DateFormat(record_date,dateformat_style)# #TimeFormat(record_date,timeformat_style)#</td>
                            <td>#record_ip#</td>
                            <td>
                                <cfif len(record_emp)>
                                    #get_emp_info(record_emp,0,0)#
                                <cfelseif len(record_par)>
                                    #get_par_info(record_par,0,-1,0)#
                                <cfelseif len(record_con)>
                                    #get_cons_info(record_con,0,0)#
                                <cfelseif len(record_pda)>
                                    #get_emp_info(record_emp,0,0)#
                                <cfelse>
                                    <cf_get_lang dictionary_id='62961.Site Ziyaretçisi'>
                                </cfif>
                            </td>
                            <td>
                                <cfif (bug_detail contains 'Invalid data') or (bug_detail contains 'Could not find the') or (bug_detail contains 'Invalid CFML construct') or (bug_detail contains 'Invalid list index') or (bug_detail contains 'Division by zero. Division by zero is not allowed') or (bug_detail contains 'could not be found') or (bug_detail contains 'A CFML variable name cannot end with') or ((bug_detail contains 'The tag') and (bug_detail contains 'requires an end tag'))>
                                    1
                                <cfelseif (bug_detail contains 'Parameter 1 of function IsDefined, which is now evaluate') or (bug_detail contains 'Attribute validation error for CFMAIL. The value of the TO attribute is invalid. The length of the string, 0 character(s), must be greater than or equal to 1 character(s).') or (bug_detail contains 'Error Executing') or (bug_detail contains 'Attribute validation error for') or (bug_detail contains 'Invalid token') or (bug_detail contains 'is an invalid date or time string.') or (bug_detail contains 'Date value passed to date function DateAdd is unspecified or invalid. Specify a valid date in DateAdd function')>  
                                    2
                                <cfelseif ((bug_detail contains 'Element') and (bug_detail contains 'is undefined')) or ((bug_detail contains 'Variable') and (bug_detail contains 'is undefined')) or ((bug_detail contains 'Routines cannot be declared more than once. The routine') and (bug_detail contains 'has been declared twice in different templates')) or (bug_detail contains 'Context validation error for') or (bug_detail contains 'Invalid tag nesting configuration') or (bug_detail contains 'An error occurred when performing a file operation')>
                                    3
                                <cfelseif ((bug_detail contains 'The resource') and (bug_detail contains 'was not found')) or ((bug_detail contains 'Invalid column index') and (bug_detail contains 'Allowable column range for')) or (bug_detail contains 'An error occurred when performing a file operation read on') or (bug_detail contains 'cannot be converted to a number.') or (bug_detail contains 'cannot convert the value' and bug_detail contains 'to a boolean') or (bug_detail contains 'No data was received in the uploaded file') or (bug_detail contains 'An exception occurred when performing a file operation copy') or (bug_detail contains 'Decryption has failed. The length of the passed string is') or (bug_detail contains 'function has an invalid parameter')>
                                    4
                                <cfelseif  ((bug_detail contains 'Cannot perform web service invocation') and (bug_detail contains 'The fault returned when invoking the web service')) or ((bug_detail contains 'Web service operation') and (bug_detail contains 'with parameters')) or (bug_detail contains 'function keyword is missing in FUNCTION declaration.')>
                                    5
                                </cfif>
                            </td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="9"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <!-- sil -->
        <cfif attributes.maxrows lt attributes.totalrecords>
            <cfset url_str = "">
            <cfif len(attributes.keyword)>
                <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
            </cfif>		
            <cfif len(attributes.form_submitted)>
                <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
            </cfif>
            <cf_paging 
                page="#attributes.page#" 
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#attributes.fuseaction##url_str#"> 
        </cfif>
        <!-- sil -->
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById("keyword").focus();
</script>

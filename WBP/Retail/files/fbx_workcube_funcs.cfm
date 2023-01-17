<!--- 
Workcube CF Fonksiyonları include
----------------------------------
* Sistem Çapında kullanılan fonksiyonları buraya ekleyiniz
* Eklediğiniz Fonksiyonlar için yardımı aşağıdaki formatta ekleyiniz

--->
<cfinclude template="../objects/functions/get_user_accounts.cfm">
<cfinclude template="../objects/functions/get_specer.cfm">

<cfinclude template="../objects/functions/get_prod_order_funcs.cfm">
<cfinclude template="../objects/functions/get_basket_money_js.cfm">

<cfsavecontent variable="ay1"><cf_get_lang_main no='541.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang_main no='542.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang_main no='543.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang_main no='544.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang_main no='545.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang_main no='546.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang_main no='547.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang_main no='548.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang_main no='549.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang_main no='550.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang_main no='551.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang_main no='153.Aralık'></cfsavecontent>
<cfset ay_list = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">

<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>

<cfset kasa_cikislar = "3,8,9,10,13">
<cfset kasa_cikis_olmayanlar = "2,4,5,12">
<cfset fazla_stok = "1">

<cfset koli_unit = "10">
<cfset teneke_unit = "39">
<cfset palet_unit = "31">

<cfinclude template="/objects/functions/get_wrk_content_clear.cfm">
<cfinclude template="display/cost_count.cfm">

<cfquery name="get_order_date" datasource="#dsn_dev#">
	SELECT ORDER_DAY FROM SEARCH_TABLES_DEFINES
</cfquery>
<cfset order_control_day = -1 * get_order_date.ORDER_DAY>

<cffunction name="GetPrinters" returntype="array" output="no">
   <!--- Define local vars --->    
   <cfset var piObj="">
   <!--- Get PrinterInfo object --->
   <cfobject type="java"
        action="create"
        name="piObj"            
        class="coldfusion.print.PrinterInfo">
   <!--- Return printer list --->
   <cfreturn piObj.getPrinters()>
</cffunction>

<cfif isdefined("session.ep.userid")>
    <cfquery name="get_my_branches" datasource="#dsn#">
        SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#
    </cfquery>
    <cfif get_my_branches.recordcount>
        <cfset my_branch_list = valuelist(get_my_branches.BRANCH_ID)>
    <cfelse>
        <cfset my_branch_list = '0'>
    </cfif>
<cfelseif isdefined("session.pp.userid")>
	<cfquery name="get_my_branches" datasource="#dsn#">
    	SELECT BRANCH_ID FROM BRANCH 
    </cfquery>
    <cfset my_branch_list = valuelist(get_my_branches.BRANCH_ID)>
    <cfset session.ep.maxrows = 20>
    <cfset session.ep.company_id = session.pp.our_company_id>
    <cfset session.EP.OUR_COMPANY_INFO.UNCONDITIONAL_LIST = 0>
    <cfset session.EP.USER_LOCATION = '1-1'>
    <cfset session.EP.money = session.pp.money>
    <cfset session.EP.period_id = session.pp.period_id>
    <cfset session.EP.period_year = session.pp.period_year>
    <cfset session.EP.OUR_COMPANY_INFO.PURCHASE_PRICE_ROUND_NUM = 2>
    <cfset session.EP.OUR_COMPANY_INFO.SALES_PRICE_ROUND_NUM = 2>
    <cfset session.EP.time_zone = 2>
    <cfif not isdefined("session.pp.project_id")>
    	<cfset session.pp.project_id = "">
        <cfset session.pp.project_name = "">
        <cfquery name="get_p_projects" datasource="#dsn#">
        	SELECT 
                WEP.PARTNER_ID,
                WG.PROJECT_ID,
                PP.PROJECT_HEAD
            FROM 
                WORK_GROUP WG,
                WORKGROUP_EMP_PAR WEP,
                PRO_PROJECTS PP
            WHERE
                WG.PROJECT_ID = PP.PROJECT_ID AND
                WG.WORKGROUP_ID = WEP.WORKGROUP_ID AND
                WEP.PARTNER_ID = #session.pp.userid#
        </cfquery>
        <cfif get_p_projects.recordcount>
        	<cfset session.pp.project_id = valuelist(get_p_projects.PROJECT_ID)>
            <cfset session.pp.project_name = valuelist(get_p_projects.PROJECT_HEAD)>
        </cfif>
    </cfif>    
</cfif>

<cffunction name="get_period_info_date" returntype="string">
    <cfargument
        name="period"
        type="string"
        required="true"
        />
    <cfargument
        name="yil"
        type="numeric"
        required="true"
        />
	<cfif ARGUMENTS.period is '1A1'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil,2,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '1A2'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil,3,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '1A3'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil,4,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '1A4'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil,5,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '1A5'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil,6,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '1A6'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil,7,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '1A7'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil,8,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '1A8'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil,9,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '1A9'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil,10,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '1A10'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil,11,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '1A11'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil,12,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '1A12'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil+1,1,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '2A12'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil,3,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '2A34'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil,5,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '2A56'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil,7,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '2A78'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil,9,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '2A910'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil,11,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '2A1112'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil+1,1,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '3A123'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil,4,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '3A456'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil,7,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '3A789'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil,10,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '3A101112'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil+1,1,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '6A123456'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil,7,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '6A789101112'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil+1,1,1)),'dd/mm/yyyy')>
    <cfelseif ARGUMENTS.period is '12A'>
    	<cfset donem_date = dateformat(createodbcdatetime(createdate(arguments.yil+1,1,1)),'dd/mm/yyyy')>
    </cfif>
    <cfreturn donem_date/>
</cffunction>

<cffunction
    name="GetDateByWeek"
    access="public"
    returntype="date"
    output="false"
    hint="Gets the first day of the week of the given year/week combo.">
 
    <!--- Define arguments. --->
    <cfargument
        name="Year"
        type="numeric"
        required="true"
        hint="The year we are looking at."
        />
 
    <cfargument
        name="Week"
        type="numeric"
        required="true"
        hint="The week we are looking at (1-53)."
        />
 
 
    <!--- Define the local scope. --->
    <cfset var LOCAL = StructNew() />
 
 
    <!---
        Get the first day of the year. This one is
        easy, we know it will always be January 1st
        of the given year.
    --->
    <cfset LOCAL.FirstDayOfYear = CreateDate(
        ARGUMENTS.Year,
        1,
        1
        ) />
 
    <!---
        Based on the first day of the year, let's
        get the first day of that week. This will be
        the first day of the calendar year.
    --->
    <cfset LOCAL.FirstDayOfCalendarYear = (
        LOCAL.FirstDayOfYear -
        DayOfWeek( LOCAL.FirstDayOfYear ) +
        1
        ) />
 
    <!---
        Now that we know the first calendar day of
        the year, all we need to do is add the
        appropriate amount of weeks. Weeks are always
        going to be seven days.
    --->
    <cfset LOCAL.FirstDayOfWeek = (
        LOCAL.FirstDayOfCalendarYear +
        (
            (ARGUMENTS.Week - 1) *
            7
        )) />
 
 
    <!---
        Return the first day of the week for the
        given year/week combination. Make sure to
        format the date so that it is not returned
        as a numeric date (this will just confuse
        too many people).
    --->
    <cfreturn DateFormat( LOCAL.FirstDayOfWeek ) />
</cffunction>
<!--- 
    Author : Uğur Hamurpet
    Create Date : 24/04/2020
    Desc :  This component name is mail_manager.
            Mail manager get mail adresses by fuseaction or employee id and send mail to in mail list.
    methods : {
        init : 'Construct function',
        get_mail_info : 'Get mail adress by fuseaction or emp_ids',
        get_mail_list : 'Create a mail list',
        send_mail : 'Send mail to the mail list'
    }
--->

<cfcomponent>

    <cfproperty name = "wo" type = "string" default = "" required = "false" />
    <cfproperty name = "action_id" type = "numeric" default = "0" required = "false" />
    <cfproperty name = "wocSettings" type = "struct" required = "false" />
    <cfproperty name = "mailSettings" type = "struct" required = "false" />

    <cfset dsn = dsn_alias = application.systemParam.systemParam().dsn />
    <cfset dsn2 = dsn2_alias = '#dsn#_#session.ep.period_year#_#session.ep.company_id#' />
    <cfset dsn3 = dsn3_alias = '#dsn#_#session.ep.company_id#' />
    <cfset fusebox = application.systemParam.systemParam().fusebox />

    <cffunction name = "init" access = "public">
        <cfargument name = "wo" type = "string" default = "" required = "false" />
        <cfargument name = "action_id" type = "numeric" default = "0" required = "false" />
        <cfargument name = "wocSettings" type = "struct" default = "#structNew()#" required = "false" />
        <cfargument name = "mailSettings" type = "struct" default = "#structNew()#" required = "false" />

        <cfset this.wo = arguments.wo />
        <cfset this.action_id = arguments.action_id />
        <cfset this.wocSettings = structCount( arguments.wocSettings ) ? arguments.wocSettings : {} />
        <cfset this.mailSettings = structCount( arguments.mailSettings ) ? arguments.mailSettings : {} />

        <cfreturn this />

    </cffunction>

    <cffunction name = "get_mail_info" access = "public" returnType = "any" hint = "Found mail address by action section">
        <cfargument name = "emp_ids" type = "string" default = "" required = "false" />

        <cfif len( arguments.emp_ids )>
            <cfquery name="get_mail_info" datasource="#dsn#">
                SELECT 
                    CONCAT( EMPLOYEE_NAME, ' ', EMPLOYEE_SURNAME ) AS COMPNAME, EMPLOYEE_EMAIL AS COMPMAIL, '' AS CONNAME, '' AS CONMAIL, 'emp' AS TYPE
                    FROM EMPLOYEES 
                    WHERE EMPLOYEE_ID IN ( <cfqueryparam value = "#arguments.emp_ids#" CFSQLType = "cf_sql_integer" list="#ListLen(arguments.emp_ids) ? 'yes' : 'no'#"> )
            </cfquery>
        <cfelse>
            <!---Fatura, İrsaliye, Satınalma siparişi, satınalma teklifi, bordro bildirimi, borc hatırlatma, cari hesap mutabakatı. --->
            <cfswitch expression="#this.wo#">
                <!--- Fatura --->
                <cfcase value="invoice.list_bill,invoice.form_add_bill,invoice.detail_invoice_purchase,invoice.form_add_bill_purchase,invoice.detail_invoice_sale">
                    <cfquery name="get_mail_info" datasource="#dsn2#">
                        SELECT COMP.FULLNAME AS COMPNAME, COMP.COMPANY_EMAIL AS COMPMAIL, CONCAT(CONS.CONSUMER_NAME , ' ', CONS.CONSUMER_SURNAME) AS CONNAME, CONS.CONSUMER_EMAIL AS CONMAIL, CASE WHEN COMP.FULLNAME IS NOT NULL THEN 'comp' ELSE 'cons' END AS TYPE
                        FROM INVOICE
                        LEFT JOIN #dsn#.COMPANY COMP ON COMP.COMPANY_ID = INVOICE.COMPANY_ID
                        LEFT JOIN #dsn#.CONSUMER CONS ON CONS.CONSUMER_ID = INVOICE.CONSUMER_ID
                        WHERE INVOICE.INVOICE_ID = <cfqueryparam value = "#this.action_id#" CFSQLType = "cf_sql_integer">
                    </cfquery>
                </cfcase>
                <!--- İrsaliye --->
                <cfcase value="stock.list_purchase,stock.form_add_sale,stock.form_upd_sale,stock.form_add_purchase,stock.form_upd_purchase,stock.form_add_fis,stock.form_upd_fis,stock.form_add_ship_open_fis,stock.form_upd_open_fis,stock.form_add_order_sale,stock.detail_order,stock.form_add_order_purchase,stock.detail_orderp">
                    <cfquery name="get_mail_info" datasource="#dsn2#">
                        SELECT COMP.FULLNAME AS COMPNAME, COMP.COMPANY_EMAIL AS COMPMAIL, CONCAT(CONS.CONSUMER_NAME , ' ', CONS.CONSUMER_SURNAME) AS CONNAME, CONS.CONSUMER_EMAIL AS CONMAIL, CASE WHEN COMP.FULLNAME IS NOT NULL THEN 'comp' ELSE 'cons' END AS TYPE
                        FROM SHIP
                        LEFT JOIN #dsn#.COMPANY COMP ON COMP.COMPANY_ID = SHIP.COMPANY_ID
                        LEFT JOIN #dsn#.CONSUMER CONS ON CONS.CONSUMER_ID = SHIP.CONSUMER_ID
                        WHERE SHIP.SHIP_ID = <cfqueryparam value = "#this.action_id#" CFSQLType = "cf_sql_integer">
                    </cfquery>
                </cfcase>
                <!--- Satınalma siparişi --->
                <cfcase value="purchase.list_order,sales.list_order">
                    <cfquery name="get_mail_info" datasource="#dsn3#">
                        SELECT COMP.FULLNAME AS COMPNAME, COMP.COMPANY_EMAIL AS COMPMAIL, CONCAT(CONS.CONSUMER_NAME , ' ', CONS.CONSUMER_SURNAME) AS CONNAME, CONS.CONSUMER_EMAIL AS CONMAIL, CASE WHEN COMP.FULLNAME IS NOT NULL THEN 'comp' ELSE 'cons' END AS TYPE
                        FROM ORDERS
                        LEFT JOIN #dsn#.COMPANY COMP ON COMP.COMPANY_ID = ORDERS.COMPANY_ID
                        LEFT JOIN #dsn#.CONSUMER CONS ON CONS.CONSUMER_ID = ORDERS.CONSUMER_ID
                        WHERE ORDERS.ORDER_ID = <cfqueryparam value = "#this.action_id#" CFSQLType = "cf_sql_integer">
                    </cfquery>
                </cfcase>
                <!--- Satınalma Teklifi --->
                <cfcase value="purchase.list_offer,sales.list_offer">
                    <cfquery name="get_mail_info" datasource="#dsn3#">
                        SELECT COMP.FULLNAME AS COMPNAME, COMP.COMPANY_EMAIL AS COMPMAIL, CONCAT(CONS.CONSUMER_NAME , ' ', CONS.CONSUMER_SURNAME) AS CONNAME, CONS.CONSUMER_EMAIL AS CONMAIL, CASE WHEN COMP.FULLNAME IS NOT NULL THEN 'comp' ELSE 'cons' END AS TYPE
                        FROM OFFER
                        LEFT JOIN #dsn#.COMPANY COMP ON COMP.COMPANY_ID = OFFER.COMPANY_ID
                        LEFT JOIN #dsn#.CONSUMER CONS ON CONS.CONSUMER_ID = OFFER.CONSUMER_ID
                        WHERE OFFER.OFFER_ID = <cfqueryparam value = "#this.action_id#" CFSQLType = "cf_sql_integer">
                    </cfquery>
                </cfcase>
                <cfdefaultcase><cfset get_mail_info.recordcount = 0 /></cfdefaultcase>
            </cfswitch>
        </cfif>
        
        <cfreturn get_mail_info />

    </cffunction>

    <cffunction name = "get_mail_list" access = "public" returnType = "struct" hint = "Create mail list">
       
        <cfset mailList = structNew() />
        <cfset mailList["to"]["mail"] = "" />
        <cfset mailList["cc"]["mail"] = "" />
        <cfset mailList["bcc"]["mail"] = "" />

        <!--- Mail adresleri fuseaction bilgisine göre aboneden alınır --->
        <cfif this.wocSettings.isGroup and !this.mailSettings.send_type>
                            
            <cfset getMailInfo = this.get_mail_info() />
            <cfif getMailInfo.recordcount>
                <cfset mailList["to"]["mail"] = len( getMailInfo.COMPMAIL ) ? getMailInfo.COMPMAIL : ( len(getMailInfo.CONMAIL) ? getMailInfo.CONMAIL : '' )  />
            </cfif>
            
        </cfif>

        <!--- Mail gönderilecek kişiler seçilmişse --->
        <cfif listLen(this.mailSettings.mail_to)>
            <cfloop list = "#this.mailSettings.mail_to#" index = "mail">
                <cfset mailList["to"]["mail"] = listAppend( mailList["to"]["mail"], mail ) />
            </cfloop>
        </cfif>

        <!--- CC'ye eklenecek kişiler seçilmişse --->
        <cfif listLen(this.mailSettings.mail_cc)>
            <cfloop list = "#this.mailSettings.mail_cc#" index = "mail">
                <cfset mailList["cc"]["mail"] = listAppend( mailList["cc"]["mail"], mail ) />
            </cfloop>
        </cfif>

        <!--- BCC'ye eklenecek kişiler seçilmişse --->
        <cfif listLen(this.mailSettings.mail_bcc)>
            <cfloop list = "#this.mailSettings.mail_bcc#" index = "mail">
                <cfset mailList["bcc"]["mail"] = listAppend( mailList["bcc"]["mail"], mail ) />
            </cfloop>
        </cfif>

        <cfreturn mailList />

    </cffunction>

    <cffunction name = "send_mail" access = "public" returnType = "struct" hint = "send mail to mail list">
        <cfargument name="subject" type="string" required="true">
        <cfargument name="content" type="string" required="true">
        <cfargument name="file" type="struct" required="true">


        <cfset mailList = this.get_mail_list() />

        <cfif structCount( mailList ) and len( mailList.to.mail ) >

            <!--- Bu css gerekli olursa mail içerisine eklenebilir ---->
            <!--- <cfsavecontent variable="css">
                <style type="text/css">
                    .color-header{background-color:a7caed;}
                    .color-list	{background-color:E6E6FF;}
                    .color-border{background-color:6699cc;}
                    .color-row{background-color:f1f0ff;}
                    .label{font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color:333333;padding-left: 4px;}
                    .form-title{font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color:white;font-weight : bold;padding-left: 2px;}	
                    .tableyazi{font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color:0033CC;}          
                    a.tableyazi:visited{font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color:0033CC;} 
                    a.tableyazi:active{text-decoration: none;}
                    a.tableyazi:hover{text-decoration: underline; color:339900;}  
                    a.tableyazi:link{font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;padding-left: 2px;color:0033CC;}
                    .headbold{font-family:Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
                    th{text-align:left;}
                    .modal{ display:none; }
                    .color-darkCyan{ display:none;}
                    .modal-title { display:none; }
                    img[class=hideable] {display: none;}
                    .close{display:none;  }
                </style>
            </cfsavecontent> --->

            <cftry>

                <cfmail 
                    from = "#session.ep.company# <#session.ep.company_email#>"
                    to = "#mailList.to.mail#" 
                    bcc = "#len( mailList.bcc.mail ) ? mailList.bcc.mail : ''#"
                    cc = "#len( mailList.cc.mail ) ? mailList.cc.mail : ''#"
                    subject = "#arguments.subject#" 
                    type = "html">

                    <cfif this.mailSettings.trail><cfinclude template="../V16/objects/display/view_company_logo.cfm"></cfif>
                    #arguments.content#<br>
                    <cfif this.mailSettings.trail><cfinclude template="../V16/objects/display/view_company_info.cfm"></cfif>
                    <cfmailparam file = "#file.path#" filename = "#file.name#">

                </cfmail>

                <cfreturn { status: true } />

                <cfcatch type="any">
                    <cfsavecontent variable = "message"><cf_get_lang dictionary_id='60852.Mail gönderimi sırasında hata oluştu'>!</cfsavecontent>
                    <cfreturn { status: false, message : message, error : cfcatch } />
                </cfcatch>

            </cftry>

        <cfelse>

            <cfsavecontent variable = "message"><cf_get_lang dictionary_id='60853.Tanımlı bir mail adresi bulunamadı'>!</cfsavecontent>
            <cfreturn { status: false, message : message, error : {} } />

        </cfif>

    </cffunction>

</cfcomponent>
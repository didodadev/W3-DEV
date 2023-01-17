<cfquery name="GET_OUR_COMPANY" datasource="#dsn#">
    SELECT
        EII.*,
        C.TAX_NO,
        C.COMPANY_NAME,
        OCI.ESHIPMENT_DATE,
        OCI.IS_ESHIPMENT
    FROM
        ESHIPMENT_INTEGRATION_INFO AS EII
    LEFT JOIN OUR_COMPANY AS C ON EII.COMP_ID = C.COMP_ID
    JOIN OUR_COMPANY_INFO AS OCI ON C.COMP_ID = OCI.COMP_ID
    WHERE
        IS_ESHIPMENT = 1 
</cfquery>

<cfset directory_name = getDirectoryFromPath(getBaseTemplatePath()) & "documents/eshipment_received">
<cfset common = createObject("Component","V16.e_government.cfc.eirsaliye.common")>

<cfloop query="GET_OUR_COMPANY">
    <cfset getCompInfo = common.get_our_company_fnc(company_id: GET_OUR_COMPANY.comp_id)>
    <cfif getCompInfo.eshipment_type_alias eq 'dp'>

    <cfelseif getCompInfo.eshipment_type_alias eq 'dgn'>
        <cfset soap = createObject("Component","V16.e_government.cfc.dogan.eirsaliye.soap")>
        <cfset soap.init()>

        <cfset received_despatches = soap.GetDespatch()>
        <cfset directory_name = "#upload_folder#eshipment_received">

        <cfif not DirectoryExists(directory_name)>
            <cfdirectory action="create" directory="#directory_name#">
        </cfif>

        <cfloop array="#received_despatches.invoices#" index="invoice">
            <cftry>
                <cfif len(invoice.InvoiceID)>
                    <cfquery name = "getPeriod" datasource = "#dsn#">
                        SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #GET_OUR_COMPANY.comp_id# AND '#listFirst(invoice.issuetime,'T')#' BETWEEN START_DATE AND FINISH_DATE
                    </cfquery>
                    <cfset dsn2 = '#dsn#_#getPeriod.period_year#_#GET_OUR_COMPANY.comp_id#'>
                    <cfset ubl_format = soap.GetDespatch(uuid: invoice.uuid, outputType: 'Ubl', direction: 'Incoming')>

                    <cffile action="write" file="#directory_name#/#invoice.uuid#.xml" output="#toString(tobinary(ubl_format.PDF_DATA))#" charset="utf-8" />

                    <cfquery name="INVOICE_CONTROL" datasource="#DSN2#">
                        SELECT 1 FROM ESHIPMENT_RECEIVING_DETAIL WHERE UUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#invoice.UUID#">
                    </cfquery>

                    <!--- IS_APPROVE alanı fatura Kaydet butonunun gelmesi icin düzenlendi--->
                    <cfif not invoice_control.recordcount>

                        <cfset helper = new V16.e_government.cfc.helper()>
                        <cfif len(invoice.Issuedate)> 
                            <cfset invoice.issuedate = helper.webtime2date(invoice.Issuedate)>
                        </cfif>
                        <cfif len(invoice.Issuetime)>
                            <cfset invoice.issuetime = helper.webtime2date(invoice.Issuetime)>
                        </cfif>
                        <cfif len(invoice.Createdate)>
                            <cfset invoice.createdate = helper.webtime2date(invoice.Createdate)>
                        </cfif>

                        <cfquery name="query_receivedshipment" datasource="#dsn2#">
                            INSERT INTO
                                ESHIPMENT_RECEIVING_DETAIL
                            (
                                SERVICE_RESULT,
                                UUID,
                                ESHIPMENT_ID,
                                STATUS_DESCRIPTION,
                                STATUS_CODE,
                                DESPATCH_ADVICE_TYPE_CODE,
                                SENDER_TAX_ID,
                                RECEIVER_TAX_ID,
                                PROFILE_ID,
                                ISSUE_DATE,
                                ISSUE_TIME,
                                PARTY_NAME,
                                RECEIVER_POSTBOX_NAME,
                                SENDER_POSTBOX_NAME,
                                DIRECTION,
                                PATH,
                                CREATE_DATE,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP
                            )
                            VALUES
                            (
                                'Success',
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.uuid#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.INVOICEID#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.STATUSDESCRIPTION#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#invoice.STATUSCODE#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.INVOICETYPECODE#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.SENDERTAXID#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.RECEIVERTAXID#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.PROFILEID#">,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#invoice.ISSUEDATE#">,
                                <cfqueryparam cfsqltype="cf_sql_time" value="#invoice.ISSUETIME#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.PARTYNAME#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.RECEIVERPOSTBOXNAME#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.SENDERPOSTBOXNAME#">,
                                'Incoming',
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.UUID#.xml">,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#invoice.CREATEDATE#">,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                                <cfif isdefined("session.ep.userid")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"><cfelse>NULL</cfif>,
                                <cfif isdefined("cgi.remote_addr")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#"><cfelse>NULL</cfif>
                            )
                        </cfquery>
                        
                    </cfif>
                    
                </cfif>
                <cfcatch>
                    <cfdump var="#cfcatch#">
                    <cfdump var="#invoice#">
                    <cfabort>
                </cfcatch>
            </cftry>
            
        </cfloop>

    <cfelseif getCompInfo.eshipment_type_alias eq 'spr'>
        <cfset soap = createObject("Component","V16.e_government.cfc.super.eshipment.soap")>
        <cfset soap.init()>
    
        <cfset received_despatches = soap.GetAvailableDespatch(company_id: GET_OUR_COMPANY.comp_id)>
        <cfset directory_name = "#upload_folder#eshipment_received">

        <cfif not DirectoryExists(directory_name)>
            <cfdirectory action="create" directory="#directory_name#">
        </cfif>

        <cfloop array="#received_despatches.invoices#" index="invoice">
            <!--- <cftry> --->
                <cfif len(invoice.InvoiceID)>
                    <cfquery name = "getPeriod" datasource = "#dsn#">
                        SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #GET_OUR_COMPANY.comp_id# AND '#listFirst(invoice.issuetime,'T')#' BETWEEN START_DATE AND FINISH_DATE
                    </cfquery>
                    <cfset dsn2 = '#dsn#_#getPeriod.period_year#_#GET_OUR_COMPANY.comp_id#'>
                    <cfset ubl_format = soap.GetDespatch(uuid: invoice.uuid, outputType: 'Ubl', direction: 'Incoming', ticket_req : 0)>

                    <cffile action="write" file="#directory_name#/#invoice.uuid#.xml" output="#toString(tobinary(ubl_format.PDF_DATA))#" charset="utf-8" />

                    <cfquery name="INVOICE_CONTROL" datasource="#DSN2#">
                        SELECT 1 FROM ESHIPMENT_RECEIVING_DETAIL WHERE UUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#invoice.UUID#">
                    </cfquery>

                    <!--- IS_APPROVE alanı fatura Kaydet butonunun gelmesi icin düzenlendi--->
                    <cfif not invoice_control.recordcount>

                        <cfset helper = new V16.e_government.cfc.helper()>
                        <cfif len(invoice.Issuedate)> 
                            <cfset invoice.issuedate = helper.webtime2date(invoice.Issuedate)>
                        </cfif>
                        <cfif len(invoice.Issuetime)>
                            <cfset invoice.issuetime = helper.webtime2date(invoice.Issuetime)>
                        </cfif>
                        <cfif len(invoice.Createdate)>
                            <cfset invoice.createdate = helper.webtime2date(invoice.Createdate)>
                        </cfif>

                        <cfquery name="query_receivedshipment" datasource="#dsn2#">
                            INSERT INTO
                                ESHIPMENT_RECEIVING_DETAIL
                            (
                                SERVICE_RESULT,
                                UUID,
                                ESHIPMENT_ID,
                                STATUS_DESCRIPTION,
                                STATUS_CODE,
                                DESPATCH_ADVICE_TYPE_CODE,
                                SENDER_TAX_ID,
                                RECEIVER_TAX_ID,
                                PROFILE_ID,
                                ISSUE_DATE,
                                ISSUE_TIME,
                                PARTY_NAME,
                                RECEIVER_POSTBOX_NAME,
                                SENDER_POSTBOX_NAME,
                                DIRECTION,
                                PATH,
                                CREATE_DATE,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP
                            )
                            VALUES
                            (
                                'Success',
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.uuid#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.INVOICEID#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.STATUSDESCRIPTION#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#invoice.STATUSCODE#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.INVOICETYPECODE#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.SENDERTAXID#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.RECEIVERTAXID#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.PROFILEID#">,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#invoice.ISSUEDATE#">,
                                <cfqueryparam cfsqltype="cf_sql_time" value="#invoice.ISSUETIME#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.PARTYNAME#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.RECEIVERPOSTBOXNAME#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.SENDERPOSTBOXNAME#">,
                                'Incoming',
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#invoice.UUID#.xml">,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#invoice.CREATEDATE#">,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                                <cfif isdefined("session.ep.userid")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"><cfelse>NULL</cfif>,
                                <cfif isdefined("cgi.remote_addr")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#"><cfelse>NULL</cfif>
                            )
                        </cfquery>
                        
                    </cfif>
                    
                </cfif>
                <!--- <cfcatch>
                    <cfdump var="#cfcatch#">
                    <cfdump var="#invoice#">
                    <cfabort>
                </cfcatch>
            </cftry> --->
            
        </cfloop>
    
    </cfif>
    gelen e-irsaliye raporu başarılı bir şekilde çalıştırıldı.<br />
</cfloop>

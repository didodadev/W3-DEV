<cfquery name="get_eshipment_comp" datasource="#dsn#">
    SELECT 
       COMP_ID
    FROM 
        OUR_COMPANY_INFO 
    WHERE 
        IS_ESHIPMENT = 1      
</cfquery>

<cfset cmp_id = valuelist(get_eshipment_comp.comp_id)>

<cfquery name="getCompInfo" datasource="#dsn#">
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
        IS_ESHIPMENT = 1 AND
        C.COMP_ID IN ( <cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#cmp_id#"> )
</cfquery>

<cfif getCompInfo.recordcount gt 0 >
    <cfloop query="getCompInfo">
        <cfset dsn2 = '#dsn#_#year(now())#_#getCompInfo.comp_id#'>

        <cfquery name="get_authorizaton" datasource="#dsn2#">
            SELECT ESHIPMENT_COMPANY_CODE, ESHIPMENT_USER_NAME, ESHIPMENT_PASSWORD, ESHIPMENT_TEST_SYSTEM, ESHIPMENT_TEST_URL, ESHIPMENT_LIVE_URL FROM #dsn#.ESHIPMENT_INTEGRATION_INFO WHERE COMP_ID = #getCompInfo.comp_id#
        </cfquery>

        <cfif get_authorizaton.ESHIPMENT_TEST_SYSTEM eq 1>
            <cfset urlPrefix = trim(get_authorizaton.ESHIPMENT_TEST_URL)>
        <cfelse>
            <cfset urlPrefix = trim(get_authorizaton.ESHIPMENT_LIVE_URL)>
        </cfif>
        <cfif right(urlPrefix, 1) neq "/">
            <cfset urlPrefix = urlPrefix & "/">
        </cfif>
        <cftry>
            <cfxml variable="ticket_data">
                <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                <soapenv:Body>
                    <tem:GetFormsAuthenticationTicket>
                        <tem:CorporateCode>#get_authorizaton.ESHIPMENT_COMPANY_CODE#</tem:CorporateCode>
                        <tem:LoginName>#get_authorizaton.ESHIPMENT_USER_NAME#</tem:LoginName>
                        <tem:Password>#get_authorizaton.ESHIPMENT_PASSWORD#</tem:Password>
                    </tem:GetFormsAuthenticationTicket>
                </soapenv:Body>
                </soapenv:Envelope>
                </cfoutput>
            </cfxml>

            <cfhttp url="#urlPrefix#IntegrationService.asmx" method="post" result="requestResult">
                <cfhttpparam type="header" name="content-type" value="text/xml">
                <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetFormsAuthenticationTicket">
                <cfhttpparam type="header" name="charset" value="utf-8">
                <cfhttpparam type="header" name="content-length" value="#len(ticket_data)#">
                <cfhttpparam type="xml" name="message" value="#trim(ticket_data)#">
            </cfhttp>
            <cfxml variable="xmlresult"><cfoutput>#requestResult.Filecontent#</cfoutput></cfxml>
            <cfset ticket = xmlresult.Envelope.Body.GetFormsAuthenticationTicketResponse.GetFormsAuthenticationTicketResult.XmlText>
            <cfcatch>
                Servis Doğrulama Sırasında Bir Sorun Oluştu!
                <cfabort>
            </cfcatch>
        </cftry>

        <cfquery name="GETSHIPMENT" datasource="#dsn2#">
            SELECT 
                ER.UUID,
                ER.STATUS,
                ER.PROFILE_ID,
                ER.INTEGRATION_ID,
                ER.RECORD_DATE,
                ER.ACTION_TYPE,
                S.SHIP_ID,
                S.SHIP_NUMBER,
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS NAME,
                C.FULLNAME,
                C.COMPANY_ID,
                CONS.CONSUMER_ID,
                CONS.CONSUMER_NAME,
                CONS.CONSUMER_SURNAME
            FROM 
                ESHIPMENT_RELATION ER,
                SHIP S
                LEFT JOIN #dsn#.COMPANY C ON C.COMPANY_ID = S.COMPANY_ID
                LEFT JOIN #dsn#.CONSUMER CONS ON CONS.CONSUMER_ID = S.CONSUMER_ID, 
                #dsn#.EMPLOYEES E
            WHERE 
                E.EMPLOYEE_ID = ER.RECORD_EMP AND
                ER.ACTION_ID = S.SHIP_ID AND
                ER.RECORD_DATE > DATEADD(MM, -1, GETDATE()) 
        </cfquery>
        <cfsavecontent variable="title">(<cfoutput>#COMPANY_NAME#</cfoutput>) -  <cf_get_lang dictionary_id='61726.e-İrsaliye durum Sorgulama'></cfsavecontent>
        <cf_box title="#title#">
            <cf_grid_list>
                <thead>
                    <th width="10"></th>
                    <th><cf_get_lang dictionary_id='58138.İrsaliye No No'></th>
                    <th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
                    <th><cf_get_lang dictionary_id='33800.Gönderim Tarihi'></th>
                    <th><cf_get_lang dictionary_id='48280.Gönderen Kişi'></th>
                    <th><cf_get_lang dictionary_id='57894.Statü'></th>
                    <th width="10"></th>
                </thead>
                <tbody>
                    <cfif GETSHIPMENT.recordCount>
                        <cfoutput query="GETSHIPMENT">

                            <cfxml variable="check_data">
                                <cfoutput>
                                    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                                    <soapenv:Header/>
                                    <soapenv:Body>
                                        <tem:CheckDespatchState>
                                            <tem:Ticket>#ticket#</tem:Ticket>
                                            <tem:UUID>#GETSHIPMENT.UUID#</tem:UUID>
                                            <tem:direction>Outgoing</tem:direction>
                                        </tem:CheckDespatchState>
                                    </soapenv:Body>
                                    </soapenv:Envelope>
                                </cfoutput>
                            </cfxml>

                            <!--- * Gönderilen İrsaliye durum sorgulanıyor --->
                            <cfhttp url="#urlPrefix#IntegrationService.asmx" method="post" result="requestResult">
                                <cfhttpparam type="header" name="content-type" value="text/xml">
                                <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/CheckDespatchState">
                                <cfhttpparam type="header" name="charset" value="utf-8">
                                <cfhttpparam type="header" name="content-length" value="#len(check_data)#">
                                <cfhttpparam type="xml" name="message" value="#trim(check_data)#">
                            </cfhttp>
                            <cfxml variable="xmlresult"><cfoutput>#requestResult.Filecontent#</cfoutput></cfxml>

                            <cfset resultdata = structNew()>
                            <cfset resultdata.uuid = xmlresult.Envelope.Body.CheckDespatchStateResponse.CheckDespatchStateResult.UUID.XmlText>
                            <cfset resultdata.statusdescription = xmlresult.Envelope.Body.CheckDespatchStateResponse.CheckDespatchStateResult.StatusDescription.XmlText>
                            <cfset resultdata.statuscode = xmlresult.Envelope.Body.CheckDespatchStateResponse.CheckDespatchStateResult.StatusCode.XmlText>
                          
                            <!--- * Gönderilen İrsaliye durum güncelleniyor --->
                            <cfquery name="UPD_ESHIPMENT_RELATION" datasource="#dsn2#">
                                UPDATE
                                    ESHIPMENT_RELATION
                                SET
                                    STATUS_CODE = #resultdata.StatusCode#,
                                    STATUS_DESCRIPTION = '#left(resultdata.StatusDescription,250)#',
                                    STATUS_DATE = #now()#                            
                                WHERE
                                    UUID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#resultdata.uuid#">
                            </cfquery>

                            <cfif resultdata.StatusCode eq 41> <!--- gönderim onayı bekliyor --->
                                <cfset divColor = 'background-color:##fff4de;color:##ffa800;'>
                            <cfelseif resultdata.StatusCode eq 1> <!--- gönderiliyor --->
                                <cfset divColor = 'background-color:##c9f7f5;color:##3699ff;'>
                            <cfelseif resultdata.StatusCode eq 54> <!--- alıcıya ulaştı --->
                                <cfset divColor = 'background-color:##ffe2e5;color:##f64e60;'>
                            <cfelseif resultdata.StatusCode eq 33> <!--- Maliyeye Gönderildi --->
                                <cfset divColor = 'background-color:##c9f7f5;color:##1bc5bd;'>
                            <cfelse>
                                <cfset divColor = 'background-color:##fff4de;color:##ffa800;'>
                            </cfif>

                            <tr>
                                <td>#currentrow#</td>
                                <td>#GETSHIPMENT.SHIP_NUMBER#</td>
                                <td>
                                    <cfif len(GETSHIPMENT.company_id)>
                                        #GETSHIPMENT.FULLNAME#
                                    <cfelseif len(GETSHIPMENT.consumer_id)>
                                        #GETSHIPMENT.CONSUMER_NAME# #GETSHIPMENT.CONSUMER_SURNAME#
                                    </cfif>
                                </td>
                                <td>#dateFormat(GETSHIPMENT.record_date,dateformat_style)# #dateFormat(GETSHIPMENT.record_date,timeformat_style)#</td>
                                <td>#GETSHIPMENT.NAME#</td>
                                <td style="width:200px;">
                                    <div style="#divColor#" class="process text-center">
                                        <b>#resultdata.StatusDescription#</b>
                                    </div>
                                </td>
                                <td>
                                    <cfif GETSHIPMENT.ACTION_TYPE eq 'SHIP'>
                                        <a href="#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=#GETSHIPMENT.SHIP_ID#" target="_blank"><i class="icon-detail"></i></a>
                                    <cfelse>
                                        <a href="#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=#GETSHIPMENT.SHIP_ID#" target="_blank"><i class="icon-detail"></i></a>
                                    </cfif>
                                </td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="7">(<cfoutput>#COMPANY_NAME#</cfoutput>) - <cf_get_lang dictionary_id='64927.Durumu Sorgulanacak İrsaliye Bulunamadı'></td>
                        </tr>
                    </cfif>
                </body>
            </cf_grid_list>
        </cf_box>
    </cfloop>
<cfelse>
    Tanım Bilgilerini Kontrol Edin!
</cfif>
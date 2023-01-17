<!---
    File: netbook_digital_planet_webservice.cfm
    Folder: V16\e_government\query
    Author: Fatih Ayık
    Date:
    Description:
        Digital Planet e-defter web servis

        attributes.type : 0 defteri sil,
        attributes.type : 1 defterin görüntüle,
        attributes.type : 2 defterin durumunu sorgula,
        attributes.type : 3 defteri imzala,berat oluştur vs,
        attributes.type : 4 beratı görüntüle,
        attributes.type : 5 beratı indir,
        attributes.type : 6 gib onaylı berat yükle,
        attributes.type : 7 defteri indir,
        attributes.type : 8 defteri PDF olarak indir,
        attributes.type : 9 defteri GİB'e gönder - Durgan
    History:
        12.10.2019 Gramoni-Mahmut Çifçi - E-Government standart modüle taşındı
    To Do:

--->

<!--- ticket alınıyor --->
<cfxml variable="netbookTicket"><cfoutput>	
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
    <soapenv:Header/>
    <soapenv:Body>
      <tem:GetFormsAuthenticationTicket>
         <tem:corporateCode>#getNetbookIntegrationInfo.NETBOOK_COMPANY_CODE#</tem:corporateCode>
         <tem:loginName>#getNetbookIntegrationInfo.NETBOOK_USERNAME#</tem:loginName>
         <tem:password>#xmlFormat(getNetbookIntegrationInfo.NETBOOK_PASSWORD,1)#</tem:password>
      </tem:GetFormsAuthenticationTicket>
    </soapenv:Body>
    </soapenv:Envelope></cfoutput>
</cfxml>
<cfhttp url="#getNetbookIntegrationInfo.NETBOOK_WEBSERVICE_URL#" method="post" result="httpResponse">
    <cfhttpparam type="header" name="content-type" value="text/xml">
    <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/IIntegrationService/GetFormsAuthenticationTicket">
    <cfhttpparam type="header" name="content-length" value="#len(netbookTicket)#">
    <cfhttpparam type="header" name="charset" value="utf-8">
    <cfhttpparam type="xml" name="message" value="#trim(netbookTicket)#">
</cfhttp>

<cfset Ticket = xmlParse(httpResponse.filecontent)>

<cfset Ticket = Ticket.Envelope.Body.GetFormsAuthenticationTicketResponse.GetFormsAuthenticationTicketResult.XmlText>
<cfquery name="getNetbook" datasource="#dsn2#">
    SELECT TOP 1 INTEGRATION_ID,START_DATE,FINISH_DATE FROM NETBOOK_DOCUMENTS WHERE UNIQUE_FILE_NAME = '#attributes.unique_file_name#'
</cfquery>
<cfif len(Ticket)>
	<cfif attributes.type eq 9>
        <cfxml variable="netbookSendMof"><cfoutput>	
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
               <soapenv:Header/>
               <soapenv:Body>
                  <tem:SendCertificatesToMof>
                     <tem:ticket>#Ticket#</tem:ticket>
                     <tem:netbookId>#getNetbook.integration_id#</tem:netbookId>
                  </tem:SendCertificatesToMof>
               </soapenv:Body>
            </soapenv:Envelope></cfoutput>
        </cfxml>
   		<cfhttp url="#getNetbookIntegrationInfo.NETBOOK_WEBSERVICE_URL#" method="post" result="httpResponseSendMof">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/IIntegrationService/SendCertificatesToMof">
            <cfhttpparam type="header" name="content-length" value="#len(netbookSendMof)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(netbookSendMof)#">
        </cfhttp>
        <cfset httpResponseSendMof = xmlParse(httpResponseSendMof.filecontent)>
        <script language="javascript">
			alert('<cfoutput>#Replace(httpResponseSendMof.Envelope.Body.SendCertificatesToMofResponse.SendCertificatesToMofResult.ServiceResultDescription.XmlText,"'","\'")#</cfoutput>');
			window.location = "<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&type=2&unique_file_name=#attributes.unique_file_name#</cfoutput>";
		</script>
    <cfelseif attributes.type eq 0>
    	<!--- defter siliniyor. --->
        <cfif getNetbook.recordcount and len(getNetbook.INTEGRATION_ID)>
            <cfxml variable="deleteNetbookFile"><cfoutput>	
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                   <soapenv:Header/>
                   <soapenv:Body>
                      <tem:DeleteNetbook>
                         <tem:ticket>#Ticket#</tem:ticket>
                         <tem:NetbookId>#getNetbook.INTEGRATION_ID#</tem:NetbookId>
                      </tem:DeleteNetbook>
                   </soapenv:Body>
                </soapenv:Envelope></cfoutput>
            </cfxml>
            <cfhttp url="#getNetbookIntegrationInfo.NETBOOK_WEBSERVICE_URL#" method="post" result="httpResponseDelete">
                <cfhttpparam type="header" name="content-type" value="text/xml">
                <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/IIntegrationService/DeleteNetbook">
                <cfhttpparam type="header" name="content-length" value="#len(deleteNetbookFile)#">
                <cfhttpparam type="header" name="charset" value="utf-8">
                <cfhttpparam type="xml" name="message" value="#trim(deleteNetbookFile)#">
            </cfhttp>
            <cfset netbookDelete = xmlParse(httpResponseDelete.filecontent)>
            <cfset statusDelete = netbookDelete.Envelope.Body.DeleteNetbookResponse.DeleteNetbookResult.ServiceResult.XmlText> 
            <cfset statusMessage = netbookDelete.Envelope.Body.DeleteNetbookResponse.DeleteNetbookResult.ServiceResultDescription.XmlText> 
            <cfif statusDelete is 'Successful'>
                <cfquery name="updNetbookStatus" datasource="#dsn2#">
                    UPDATE NETBOOKS SET STATUS = 0 WHERE UNIQUE_FILE_NAME = '#attributes.unique_file_name#'
                    UPDATE NETBOOK_DOCUMENTS SET STATUS_CODE = 0 WHERE UNIQUE_FILE_NAME = '#attributes.unique_file_name#'
                </cfquery>
                <script language="javascript">
					alert('Defterler silindi!');
					window.close();
					wrk_opener_reload();
				</script>
            <cfelse>
                <script language="javascript">
					alert('<cfoutput>#statusMessage#</cfoutput>');
					window.close();
				</script>
            </cfif>
        <cfelse>
        	<cfquery name="updNetbookStatus" datasource="#dsn2#">
                UPDATE NETBOOKS SET STATUS = 0 WHERE UNIQUE_FILE_NAME = '#attributes.unique_file_name#'
                UPDATE NETBOOK_DOCUMENTS SET STATUS_CODE = 0 WHERE UNIQUE_FILE_NAME = '#attributes.unique_file_name#'
            </cfquery>
            <script language="javascript">
				alert('Hata silindi!');
				window.close();
				wrk_opener_reload();
			</script>
        </cfif>
	<cfelseif attributes.type eq 2><!--- defterin durumu sorgulanıyor --->
    	<!--- defter oluşma işleinin tamamlanip tamamlanmadiği kontrol ediliyor. --->
        <cfxml variable="netbook_File_Status"><cfoutput>	
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
               <soapenv:Header/>
               <soapenv:Body>
                  <tem:GetNetbookStatusByFileName>
                     <tem:ticket>#Ticket#</tem:ticket>
                     <tem:filename>#attributes.unique_file_name#</tem:filename>
                  </tem:GetNetbookStatusByFileName>
               </soapenv:Body>
            </soapenv:Envelope></cfoutput>
        </cfxml>
   		<cfhttp url="#getNetbookIntegrationInfo.NETBOOK_WEBSERVICE_URL#" method="post" result="httpResponseFileStatus">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/IIntegrationService/GetNetbookStatusByFileName">
            <cfhttpparam type="header" name="content-length" value="#len(netbook_File_Status)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(netbook_File_Status)#">
        </cfhttp>
    	<cfset netbook_File_Status = xmlParse(httpResponseFileStatus.filecontent)>
	<!---<cfdump var="#netbook_File_Status#"><cfabort>--->
        <cfset netbook_File_Status_ = netbook_File_Status.Envelope.Body.GetNetbookStatusByFileNameResponse.GetNetbookStatusByFileNameResult.ServiceResult.XmlText>
        <cfset netbookFileStatusResult = netbook_File_Status.Envelope.Body.GetNetbookStatusByFileNameResponse.GetNetbookStatusByFileNameResult.StatusResult.XmlText>
        
    	<cfif netbook_File_Status_ is 'Successful' and netbookFileStatusResult is 'DataError'>
			<!--- defter hata aldımı kontrol ediliyor --->
            <cfxml variable="netbookFileError"><cfoutput>	
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                   <soapenv:Header/>
                   <soapenv:Body>
                      <tem:GetNetbookErrorsByFileName>
                         <tem:ticket>#Ticket#</tem:ticket>
                         <tem:filename>#attributes.unique_file_name#</tem:filename>
                      </tem:GetNetbookErrorsByFileName>
                   </soapenv:Body>
                </soapenv:Envelope></cfoutput>
            </cfxml>
            <cfhttp url="#getNetbookIntegrationInfo.NETBOOK_WEBSERVICE_URL#" method="post" result="httpResponseError">
                <cfhttpparam type="header" name="content-type" value="text/xml">
                <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/IIntegrationService/GetNetbookErrorsByFileName">
                <cfhttpparam type="header" name="content-length" value="#len(netbookFileError)#">
                <cfhttpparam type="header" name="charset" value="utf-8">
                <cfhttpparam type="xml" name="message" value="#trim(netbookFileError)#">
            </cfhttp>
        
            <cfset netbookError = xmlParse(httpResponseError.filecontent)>
            <cfset statusError = netbookError.Envelope.Body.GetNetbookErrorsByFileNameResponse.GetNetbookErrorsByFileNameResult.ServiceResult.XmlText>
            <cfif statusError is 'Successful'>
                <cfset errorMessage = netbookError.Envelope.Body.GetNetbookErrorsByFileNameResponse.GetNetbookErrorsByFileNameResult.ObjectList.WsNetbookError.ErrorMessage.XmlText>
                <cfquery name="updNetbookStatus" datasource="#dsn2#">
                    UPDATE 
                        NETBOOKS 
                    SET 
                        STATUS = -1,
                        ERROR_DETAIL = '#errorMessage#'
                    WHERE 
                        UNIQUE_FILE_NAME = '#attributes.unique_file_name#'
                </cfquery>	
                <cfoutput><br /><br />Hata : <b>#HTMLCodeFormat(errorMessage)#</b></cfoutput>
                <script language="javascript">
                    alert('Defter hata aldı! Detayları hatalı defterler ekranından görebilirsiniz!');
                    window.close();
					wrk_opener_reload();
                </script>
            </cfif>
        <cfelseif netbook_File_Status_ is 'Successful' and netbookFileStatusResult is 'SuccessfullyCompleted'>
            <!--- igili defterin adına göre netbook_id çekiliyor --->
            <cfxml variable="netbookFileName"><cfoutput>	
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                   <soapenv:Header/>
                   <soapenv:Body>
                      <tem:GetNetbookByFileName>
                         <tem:ticket>#Ticket#</tem:ticket>
                         <tem:filename>#attributes.unique_file_name#</tem:filename>
                      </tem:GetNetbookByFileName>
                   </soapenv:Body>
                </soapenv:Envelope></cfoutput>
            </cfxml>
            <cfhttp url="#getNetbookIntegrationInfo.NETBOOK_WEBSERVICE_URL#" method="post" result="httpResponseNetbookID">
                <cfhttpparam type="header" name="content-type" value="text/xml">
                <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/IIntegrationService/GetNetbookByFileName">
                <cfhttpparam type="header" name="content-length" value="#len(netbookFileName)#">
                <cfhttpparam type="header" name="charset" value="utf-8">
                <cfhttpparam type="xml" name="message" value="#trim(netbookFileName)#">
            </cfhttp>
            
            <cfset netbook = xmlParse(httpResponseNetbookID.filecontent)>
            <cfset statusHasEroor = netbook.Envelope.Body.GetNetbookByFileNameResponse.GetNetbookByFileNameResult.hasError.XmlText>
            <cfset statusNetbookServiceResult = netbook.Envelope.Body.GetNetbookByFileNameResponse.GetNetbookByFileNameResult.ServiceResult.XmlText>
			<cfif statusNetbookServiceResult is 'Successful'>
              <cfset netbookID = netbook.Envelope.Body.GetNetbookByFileNameResponse.GetNetbookByFileNameResult.ObjectList.WsNetbook.Id.XmlText>
              <cfquery name="updNetbook" datasource="#dsn2#">
                UPDATE NETBOOKS SET INTEGRATION_ID = #netbookID# WHERE UNIQUE_FILE_NAME = '#attributes.unique_file_name#'
              </cfquery>
              <!--- netbookId ye göre defter dokumanları cekiliyor --->
              <cfxml variable="netbookData"><cfoutput>	
                    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                       <soapenv:Header/>
                       <soapenv:Body>
                          <tem:GetNetbookDocumentsByNetbookId>
                             <tem:ticket>#Ticket#</tem:ticket>
                             <tem:netbookId>#netbookID#</tem:netbookId>
                          </tem:GetNetbookDocumentsByNetbookId>
                       </soapenv:Body>
                    </soapenv:Envelope></cfoutput>
                </cfxml>
                
                <cfhttp url="#getNetbookIntegrationInfo.NETBOOK_WEBSERVICE_URL#" method="post" result="httpResponseNetbooks">
                    <cfhttpparam type="header" name="content-type" value="text/xml">
                    <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/IIntegrationService/GetNetbookDocumentsByNetbookId">
                    <cfhttpparam type="header" name="content-length" value="#len(netbookData)#">
                    <cfhttpparam type="header" name="charset" value="utf-8">
                    <cfhttpparam type="xml" name="message" value="#trim(netbookData)#">
                </cfhttp>
                
                <cfset netbooks = xmlParse(httpResponseNetbooks.filecontent)>
				<cfset status_netbooks = netbooks.Envelope.Body.GetNetbookDocumentsByNetbookIdResponse.GetNetbookDocumentsByNetbookIdResult.ServiceResult.XmlText>
                <cfif status_netbooks is 'Successful'>
					<cfset item =  netbooks.Envelope.Body.GetNetbookDocumentsByNetbookIdResponse.GetNetbookDocumentsByNetbookIdResult.ObjectList.WsNetbookDocument>
                    <cfset line_count = arraylen(item)>
                    <cfif line_count gt 0>
                        <!--- deftere ait kayitlar siliniyor --->
                        <cfquery name="delNetbookDocuments" datasource="#dsn2#">
                            DELETE FROM NETBOOK_DOCUMENTS WHERE UNIQUE_FILE_NAME = '#attributes.unique_file_name#'
                        </cfquery>
                        <cfloop from="1" to="#line_count#" index="netbokIndex">
                            <cfquery name="addNetbookDocuments" datasource="#dsn2#">
                                INSERT INTO
                                    NETBOOK_DOCUMENTS
                                (
                                    UNIQUE_FILE_NAME,
                                    START_DATE,
                                    FINISH_DATE,
                                    FILE_NAME,
                                    FILE_PATH,
                                    WARRANT_FILE_PATH,
                                    GIB_WARRANT_FILE_PATH,
                                    TYPE,
                                    STATUS_CODE,
                                    STATUS_MESSAGE,
                                    UNIQUEID,
                                    INTEGRATION_ID,
                                    INTEGRATION_DOCUMENT_ID,
                                    RECORD_DATE,
                                    RECORD_EMP,
                                    RECORD_IP
                                )
                                VALUES
                                (
                                    '#attributes.unique_file_name#',
                                    #CreateODBCDateTime(replace(item[netbokIndex].PeriodCoveredStart.xmltext,'T',' '))#,
                                    #CreateODBCDateTime(replace(item[netbokIndex].PeriodCoveredEnd.xmltext,'T',' '))#,
                                    '#listlast(item[netbokIndex].BookPath.xmlText,'\')#',
                                    '#replace(item[netbokIndex].BookPath.xmlText,listlast(item[netbokIndex].BookPath.xmlText,'\'),'')#',
                                    <cfif len(item[netbokIndex].WarrantPath.xmlText)>'#item[netbokIndex].WarrantPath.xmlText#',<cfelse>NULL,</cfif>
                                    NULL,
                                    '#item[netbokIndex].Type.xmlText#',
                                    <cfif item[netbokIndex].StatusMessage.xmlText is 'nbCreated'>1
									<cfelseif item[netbokIndex].StatusMessage.xmlText is 'nbSigned' or item[netbokIndex].StatusMessage.xmlText is 'certCreated' or item[netbokIndex].StatusMessage.xmlText is 'certSigned'>2
									<cfelseif item[netbokIndex].StatusMessage.xmlText is 'nbLegal'>3
									<cfelseif item[netbokIndex].StatusMessage.xmlText is 'errSchema' or item[netbokIndex].StatusMessage.xmlText is 'errVerifySchema'>4
                                    <cfelse>0
                                    </cfif>,
                                    '#item[netbokIndex].StatusMessage.xmlText#',
                                    '#item[netbokIndex].UniqueId.xmlText#',
                                    #item[netbokIndex].NetbookId.xmlText#,
                                    #item[netbokIndex].Id.xmlText#,
                                    #now()#,
                                    #session.ep.userid#,
                                    '#cgi.REMOTE_ADDR#'
                                )
                            </cfquery>
                        </cfloop>
                        <script language="javascript">
                            alert('Defter durumları güncellendi!');
                            window.close();
							wrk_opener_reload();
                        </script>
                    </cfif>
                <cfelse>
                    <script language="javascript">
						alert('Kayıtlı defter bulunamadı! Lütfen daha sonra tekrar deneyiniz!');
						window.close();
					</script>
                </cfif>
            <cfelse>
                <script language="javascript">
					alert('Kayıtlı defter bulunamadı! Lütfen daha sonra tekrar deneyiniz!');
					window.close();
				</script>
            </cfif>
        <cfelseif netbook_File_Status_ is 'Successful' and netbookFileStatusResult is 'Continues'>
        	<script language="javascript">
				alert('Defterler henüz oluşmadı. İşlem devam ediyor!');
				window.close();
			</script>
		<cfelseif netbook_File_Status_ is 'Successful' and netbookFileStatusResult is 'ProcessHaventStartedYet'>
        	<script language="javascript">
				alert('Defter henüz işlenmeye başlamadı!');
				window.close();
			</script>
        </cfif>
    <cfelseif attributes.type eq 3><!--- defteri imzala ve beratları oluştur --->
    	<!--- defter oluşma işleinin tamamlanip tamamlanmadiği kontrol ediliyor. --->
        <cfxml variable="netbookFileStatus"><cfoutput>	
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
               <soapenv:Header/>
               <soapenv:Body>
                  <tem:GetNetbookStatusByFileName>
                     <tem:ticket>#Ticket#</tem:ticket>
                     <tem:filename>#attributes.unique_file_name#</tem:filename>
                  </tem:GetNetbookStatusByFileName>
               </soapenv:Body>
            </soapenv:Envelope></cfoutput>
        </cfxml>
   		<cfhttp url="#getNetbookIntegrationInfo.NETBOOK_WEBSERVICE_URL#" method="post" result="httpResponseStatus">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/IIntegrationService/GetNetbookStatusByFileName">
            <cfhttpparam type="header" name="content-length" value="#len(netbookFileStatus)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(netbookFileStatus)#">
        </cfhttp>
    	<cfset netbookFileStatus = xmlParse(httpResponseStatus.filecontent)>
        <cfset netbookFileStatus_ = netbookFileStatus.Envelope.Body.GetNetbookStatusByFileNameResponse.GetNetbookStatusByFileNameResult.ServiceResult.XmlText>
        <cfset netbookFileStatusResult = netbookFileStatus.Envelope.Body.GetNetbookStatusByFileNameResponse.GetNetbookStatusByFileNameResult.StatusResult.XmlText>
        
        <cfif netbookFileStatus_ is 'Successful' and netbookFileStatusResult is 'SuccessfullyCompleted'>
            <cfxml variable="netbookFileSign"><cfoutput>	
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                   <soapenv:Header/>
                   <soapenv:Body>
                      <tem:ProcessNetbook>
                         <tem:ticket>#Ticket#</tem:ticket>
                         <tem:NetbookId>#getNetbook.integration_id#</tem:NetbookId>
                      </tem:ProcessNetbook>
                   </soapenv:Body>
                </soapenv:Envelope></cfoutput>
            </cfxml>
            <cfhttp url="#getNetbookIntegrationInfo.NETBOOK_WEBSERVICE_URL#" method="post" result="httpResponseSign">
                <cfhttpparam type="header" name="content-type" value="text/xml">
                <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/IIntegrationService/ProcessNetbook">
                <cfhttpparam type="header" name="content-length" value="#len(netbookFileSign)#">
                <cfhttpparam type="header" name="charset" value="utf-8">
                <cfhttpparam type="xml" name="message" value="#trim(netbookFileSign)#">
            </cfhttp>
            <cfset netbookSign = xmlParse(httpResponseSign.filecontent)>
            <cfset status_netbookSign = netbookSign.Envelope.Body.ProcessNetbookResponse.ProcessNetbookResult.ServiceResult.XmlText>
            <cfif status_netbookSign is 'Successful'>
                <cfset item =  netbookSign.Envelope.Body.ProcessNetbookResponse.ProcessNetbookResult.ObjectList.WsNetbookDocument>
                <cfset line_count = arraylen(item)>
                <cfif line_count gt 0>
                    <!--- deftere ait kayitlar siliniyor --->
                    <cfquery name="delNetbookDocuments" datasource="#dsn2#">
                        DELETE FROM NETBOOK_DOCUMENTS WHERE UNIQUE_FILE_NAME = '#attributes.unique_file_name#'
                    </cfquery>
                    <cfloop from="1" to="#line_count#" index="netbokIndex">						
                        <cfquery name="addNetbookDocuments" datasource="#dsn2#">
                            INSERT INTO
                                NETBOOK_DOCUMENTS
                            (
                                UNIQUE_FILE_NAME,
                                START_DATE,
                                FINISH_DATE,
                                FILE_NAME,
                                FILE_PATH,
                                WARRANT_FILE_PATH,
                                GIB_WARRANT_FILE_PATH,
                                TYPE,
                                STATUS_CODE,
                                STATUS_MESSAGE,
                                UNIQUEID,
                                INTEGRATION_ID,
                                INTEGRATION_DOCUMENT_ID,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP
                            )
                            VALUES
                            (
                                '#attributes.unique_file_name#',
                                #CreateODBCDateTime(replace(item[netbokIndex].PeriodCoveredStart.xmltext,'T',' '))#,
                                #CreateODBCDateTime(replace(item[netbokIndex].PeriodCoveredEnd.xmltext,'T',' '))#,
                                '#listlast(item[netbokIndex].BookPath.xmlText,'\')#',
                                '#replace(item[netbokIndex].BookPath.xmlText,listlast(item[netbokIndex].BookPath.xmlText,'\'),'')#',
                                <cfif len(item[netbokIndex].WarrantPath.xmlText)>'#item[netbokIndex].WarrantPath.xmlText#',<cfelse>NULL,</cfif>
                                NULL,
                                '#item[netbokIndex].Type.xmlText#',
                                2,
                                '#item[netbokIndex].StatusMessage.xmlText#',
                                '#item[netbokIndex].UniqueId.xmlText#',
                                #item[netbokIndex].NetbookId.xmlText#,
                                #item[netbokIndex].Id.xmlText#,
                                #now()#,
                                #session.ep.userid#,
                                '#cgi.REMOTE_ADDR#'
                            )
                        </cfquery>
                    </cfloop>
                    <script language="javascript">
                        alert('Defterler imzalandı ve beratlar oluşturuldu!');
                        window.close();
						wrk_opener_reload();
                    </script>
                </cfif>
            <cfelseif status_netbookSign is 'error'>
            	<cfset status_netbookSignResultDesc = netbookSign.Envelope.Body.ProcessNetbookResponse.ProcessNetbookResult.ServiceResultDescription.XmlText>
                <script language="javascript">
					alert('<cfoutput>#status_netbookSignResultDesc#</cfoutput>');
					window.close();
				</script>
            </cfif>
        <cfelseif netbookFileStatus_ is 'Successful' and netbookFileStatusResult is 'ProcessHaventStartedYet'>
            <script language="javascript">
                alert('İmzalama işlemi henüz başlamadı !');
                window.close();
				wrk_opener_reload();
            </script>
        <cfelseif netbookFileStatus_ is 'Successful' and netbookFileStatusResult is 'Continues'>
            <script language="javascript">
                alert('İmzalama işlemi devam ediyor !');
                window.close();
				wrk_opener_reload();
            </script>
		<cfelseif netbookFileStatus_ is 'Successful' and netbookFileStatusResult is 'DataError'>
            <script language="javascript">
                alert('İmzalama işleminde sorun oluştu !');
                window.close();
				wrk_opener_reload();
            </script>
        </cfif>
    <cfelseif attributes.type eq 1 and len(attributes.integration_document_id)><!--- defteri görüntüle --->
    	<cfxml variable="NetbookHtmlContent"><cfoutput>	
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
               <soapenv:Header/>
               <soapenv:Body>
                  <tem:GetNetbookContent>
                     <tem:ticket>#ticket#</tem:ticket>
                     <tem:netbookDocumentId>#attributes.integration_document_id#</tem:netbookDocumentId>
                     <tem:ftype>Html</tem:ftype>
                     <tem:dtype>Document</tem:dtype>
                  </tem:GetNetbookContent>
               </soapenv:Body>
            </soapenv:Envelope></cfoutput>
        </cfxml>
        <cfhttp url="#getNetbookIntegrationInfo.NETBOOK_WEBSERVICE_URL#" method="post" result="httpResponseNetbookHTML">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/IIntegrationService/GetNetbookContent">
            <cfhttpparam type="header" name="content-length" value="#len(NetbookHtmlContent)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(NetbookHtmlContent)#">
        </cfhttp>
        
        <cfset netbookHTML = xmlParse(httpResponseNetbookHTML.filecontent)>
        <cfset status_netbookHTML = netbookHTML.Envelope.Body.GetNetbookContentResponse.GetNetbookContentResult.ServiceResult.XmlText>
        <cfif status_netbookHTML is 'Successful'>
            <cfset content = netbookHTML.Envelope.Body.GetNetbookContentResponse.GetNetbookContentResult.Content.XmlText>
            <cfoutput>#ToString(ToBinary(content))#</cfoutput>
        <cfelse>
        	<script language="javascript">
				alert('Görüntülenecek defter bulunamadı!');
				window.close();
			</script>
        </cfif>
    <cfelseif attributes.type eq 4 and len(attributes.integration_document_id)><!--- beratı görüntüle --->
    	<cfxml variable="certificateHtmlContent"><cfoutput>	
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
               <soapenv:Header/>
               <soapenv:Body>
                  <tem:GetNetbookContent>
                     <tem:ticket>#ticket#</tem:ticket>
                     <tem:netbookDocumentId>#attributes.integration_document_id#</tem:netbookDocumentId>
                     <tem:ftype>Html</tem:ftype>
                     <tem:dtype>Certificate</tem:dtype>
                  </tem:GetNetbookContent>
               </soapenv:Body>
            </soapenv:Envelope></cfoutput>
        </cfxml>
        <cfhttp url="#getNetbookIntegrationInfo.NETBOOK_WEBSERVICE_URL#" method="post" result="httpResponseCertificateHTML">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/IIntegrationService/GetNetbookContent">
            <cfhttpparam type="header" name="content-length" value="#len(certificateHtmlContent)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(certificateHtmlContent)#">
        </cfhttp>
        <cfset certificateHTML = xmlParse(httpResponseCertificateHTML.filecontent)>
        <cfset status_certificateHTML = certificateHTML.Envelope.Body.GetNetbookContentResponse.GetNetbookContentResult.ServiceResult.XmlText>
        <cfif status_certificateHTML is 'Successful'>
            <cfset content = certificateHTML.Envelope.Body.GetNetbookContentResponse.GetNetbookContentResult.Content.XmlText>
            <cfoutput>#ToString(ToBinary(content))#</cfoutput>
        <cfelse>
        	<script language="javascript">
				alert('Görüntülenecek berat bulunamadı!');
				window.close();
			</script>
        </cfif>
    <cfelseif attributes.type eq 5 and len(attributes.integration_document_id)><!--- beratı indir --->
    	<cfxml variable="certificateNetbookFile"><cfoutput>	
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
               <soapenv:Header/>
               <soapenv:Body>
                  <tem:GetCertificatesByNetbookId>
                     <tem:ticket>#Ticket#</tem:ticket>
                     <tem:netbookId>#getNetbook.integration_id#</tem:netbookId>
                  </tem:GetCertificatesByNetbookId>
               </soapenv:Body>
            </soapenv:Envelope></cfoutput>
        </cfxml>
        <cfhttp url="#getNetbookIntegrationInfo.NETBOOK_WEBSERVICE_URL#" method="post" result="httpResponseCertificateFile">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/IIntegrationService/GetCertificatesByNetbookId">
            <cfhttpparam type="header" name="content-length" value="#len(certificateNetbookFile)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(certificateNetbookFile)#">
        </cfhttp>
        <cfset certificateFile = xmlParse(httpResponseCertificateFile.filecontent)>
        <cfset status_certificateFile = certificateFile.Envelope.Body.GetCertificatesByNetbookIdResponse.GetCertificatesByNetbookIdResult.serviceResult.XmlText>
        <cfif status_certificateFile is 'Successful'>
        	<cfset filename = certificateFile.Envelope.Body.GetCertificatesByNetbookIdResponse.GetCertificatesByNetbookIdResult.FileName.XmlText>
            <cfset content = certificateFile.Envelope.Body.GetCertificatesByNetbookIdResponse.GetCertificatesByNetbookIdResult.Content.XmlText>
            <cfheader name="Content-Disposition" value="attachment;filename=#filename#">
            <cfcontent type="text/plain" variable="#ToBinary(ToString(content))#"/>
        <cfelse>
        	<script language="javascript">
				alert('İndirilecek berat dosyası bulunamadı!');
				window.close();
			</script>
        </cfif>
    <cfelseif attributes.type eq 7 and len(attributes.integration_document_id)><!--- defteri indir --->
    	<cfxml variable="netbookXMLContent"><cfoutput>	
			<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
               <soapenv:Header/>
               <soapenv:Body>
                  <tem:GetNetbookContent>
                     <tem:ticket>#ticket#</tem:ticket>
                     <tem:netbookDocumentId>#attributes.integration_document_id#</tem:netbookDocumentId>
                     <tem:ftype>Xbrl</tem:ftype>
                     <tem:dtype>Document</tem:dtype>
                  </tem:GetNetbookContent>
               </soapenv:Body>
            </soapenv:Envelope>
			</cfoutput>
        </cfxml>
        <cfhttp url="#getNetbookIntegrationInfo.NETBOOK_WEBSERVICE_URL#" method="post" result="httpResponseNetbookXML">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/IIntegrationService/GetNetbookContent">
            <cfhttpparam type="header" name="content-length" value="#len(netbookXMLContent)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(netbookXMLContent)#">
        </cfhttp>
        <cfset netbookXML = xmlParse(httpResponseNetbookXML.filecontent)>
        <cfset status_netbookXML = netbookXML.Envelope.Body.GetNetbookContentResponse.GetNetbookContentResult.ServiceResult.XmlText>
        <cfif status_netbookXML is 'Successful'>
            <cfset content = netbookXML.Envelope.Body.GetNetbookContentResponse.GetNetbookContentResult.Content.XmlText>
			<cfset netbookFileName = netbookXML.Envelope.Body.GetNetbookContentResponse.GetNetbookContentResult.FileName.XmlText>
            <cfheader name="Content-Disposition" value="attachment;filename=#netbookFileName#">
            <cfcontent type="text/plain" variable="#ToBinary(ToString(content))#"/>
        <cfelse>
        	<script language="javascript">
				alert('İndirilecek defter dosyası bulunamadı!');
				window.close();
			</script>
        </cfif>
    <cfelseif attributes.type eq 8 and len(attributes.integration_document_id)><!--- defteri pdf indir --->
    	<cfxml variable="netbookPDFContent"><cfoutput>	
			<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
               <soapenv:Header/>
               <soapenv:Body>
                  <tem:GetNetbookContent>
                     <tem:ticket>#ticket#</tem:ticket>
                     <tem:netbookDocumentId>#attributes.integration_document_id#</tem:netbookDocumentId>
                     <tem:ftype>Pdf</tem:ftype>
                     <tem:dtype>Document</tem:dtype>
                  </tem:GetNetbookContent>
               </soapenv:Body>
            </soapenv:Envelope>
			</cfoutput>
        </cfxml>
        <cfhttp url="#getNetbookIntegrationInfo.NETBOOK_WEBSERVICE_URL#" method="post" result="httpResponseNetbookPDF">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/IIntegrationService/GetNetbookContent">
            <cfhttpparam type="header" name="content-length" value="#len(netbookPDFContent)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(netbookPDFContent)#">
        </cfhttp>
        <cfset netbookPDF = xmlParse(httpResponseNetbookPDF.filecontent)>
        <cfset status_netbookPDF = netbookPDF.Envelope.Body.GetNetbookContentResponse.GetNetbookContentResult.ServiceResult.XmlText>
        <cfif status_netbookPDF is 'Successful'>
            <cfset content = netbookPDF.Envelope.Body.GetNetbookContentResponse.GetNetbookContentResult.Content.XmlText>
			<cfset netbookPDFFileName = netbookPDF.Envelope.Body.GetNetbookContentResponse.GetNetbookContentResult.FileName.XmlText>
            <cfheader name="Content-Disposition" value="attachment;filename=#netbookPDFFileName#">
            <cfcontent type="text/plain" variable="#ToBinary(ToString(content))#"/>
        <cfelse>
        	<script language="javascript">
				alert('İndirilecek PDF dosyası bulunamadı!');
				window.close();
			</script>
        </cfif>
    <cfelseif attributes.type eq 6><!--- GİB onaylı berat yükle --->
    	<cfif isdefined('attributes.form_submitted')>
        	<!--- yüklenen dosyanın adını okuyabilmek icin upload ediyoruz. --->
            <cffile action="upload" filefield="uploaded_file" destination="#upload_folder#reserve_files#dir_seperator#" nameconflict = "MakeUnique" mode="777">             
            <cffile action="readbinary" file="#attributes.uploaded_file#" variable="documentBinaryData"/>  
            <cfif attributes.bulkUpload eq 0>
                <cfxml variable="uploadCertificate"><cfoutput>	
                    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                       <soapenv:Header/>
                       <soapenv:Body>
                          <tem:UploadCertificate>
                             <tem:ticket>#Ticket#</tem:ticket>
                             <tem:netbookDocumentId>#attributes.integration_document_id#</tem:netbookDocumentId>
                             <tem:signedCertificate>#trim(ToBase64(documentBinaryData))#</tem:signedCertificate>
                             <tem:certificateName>#cffile.SERVERFILE#</tem:certificateName>
                          </tem:UploadCertificate>
                       </soapenv:Body>
                    </soapenv:Envelope></cfoutput>
                </cfxml>
                <!--- upload_edilen dosya siliniyor --->
                <cffile action="delete" file="#upload_folder#reserve_files#dir_seperator##cffile.SERVERFILE#">
                <cfhttp url="#getNetbookIntegrationInfo.NETBOOK_WEBSERVICE_URL#" method="post" result="httpResponseUpload">
                    <cfhttpparam type="header" name="content-type" value="text/xml">
                    <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/IIntegrationService/UploadCertificate">
                    <cfhttpparam type="header" name="content-length" value="#len(uploadCertificate)#">
                    <cfhttpparam type="header" name="charset" value="utf-8">
                    <cfhttpparam type="xml" name="message" value="#trim(uploadCertificate)#">
                </cfhttp>
                <cfset uploadCerticicate = xmlParse(httpResponseUpload.filecontent)>
                <cfset status_upload = uploadCerticicate.Envelope.Body.UploadCertificateResponse.UploadCertificateResult.ServiceResult.XmlText>
                <cfset operation_status = 'true'>
				<cfset status_message = uploadCerticicate.Envelope.Body.UploadCertificateResponse.UploadCertificateResult.ServiceResultDescription.XmlText>
            <cfelseif attributes.bulkUpload eq 1><!--- toplu berat yükle --->
            	<cfxml variable="uploadBulkCertificate"><cfoutput>	
                    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                       <soapenv:Header/>
                       <soapenv:Body>
                          <tem:UploadBulkCertificate>
                             <tem:ticket>#Ticket#</tem:ticket>
                             <tem:certificates>#trim(ToBase64(documentBinaryData))#</tem:certificates>
                          </tem:UploadBulkCertificate>
                       </soapenv:Body>
                    </soapenv:Envelope></cfoutput>
                </cfxml>
                <!--- upload_edilen dosya siliniyor --->
                <cffile action="delete" file="#upload_folder#reserve_files#dir_seperator##cffile.SERVERFILE#">
                <cfhttp url="#getNetbookIntegrationInfo.NETBOOK_WEBSERVICE_URL#" method="post" result="httpResponseBulkUpload">
                    <cfhttpparam type="header" name="content-type" value="text/xml">
                    <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/IIntegrationService/UploadBulkCertificate">
                    <cfhttpparam type="header" name="content-length" value="#len(uploadBulkCertificate)#">
                    <cfhttpparam type="header" name="charset" value="utf-8">
                    <cfhttpparam type="xml" name="message" value="#trim(uploadBulkCertificate)#">
                </cfhttp>
                <cfset uploadCerticicate = xmlParse(httpResponseBulkUpload.filecontent)>
				<cfset status_upload = uploadCerticicate.Envelope.Body.UploadBulkCertificateResponse.UploadBulkCertificateResult.ServiceResult.XmlText>
                <cfset operation_status = uploadCerticicate.Envelope.Body.UploadBulkCertificateResponse.UploadBulkCertificateResult.OperationStatus.XmlText>
                <cfset status_message = uploadCerticicate.Envelope.Body.UploadBulkCertificateResponse.UploadBulkCertificateResult.ServiceResultDescription.XmlText>
            </cfif>
            <cfif status_upload is 'Successful' and operation_status is true> 
                <cfquery name="updNetbookStatus"  datasource="#dsn2#">
                    UPDATE NETBOOK_DOCUMENTS SET STATUS_MESSAGE = 'nbLegal', STATUS_CODE = 3 WHERE UNIQUE_FILE_NAME = '#attributes.unique_file_name#'
                </cfquery>
                <script language="javascript">
					alert('Gib Onaylı Resmi Defteriniz Sisteme Yüklenmiştir!');
					window.close();
				</script>
            <cfelse>
            	<script language="javascript">
					alert('<cfoutput>#status_message#</cfoutput>!');
					history.back();
				</script>
            </cfif>
        </cfif>
        <cf_popup_box title="Gib Onaylı Berat Yükle">
            <cfform name="file_upload" enctype="multipart/form-data" method="post" action="">
            	<input type="hidden" name="type" id="type" value="<cfoutput>#attributes.type#</cfoutput>">
                <input type="hidden" name="integration_document_id" id="integration_document_id" value="<cfoutput>#attributes.integration_document_id#</cfoutput>">
                <input type="hidden" name="unique_file_name" id="unique_file_name" value="<cfoutput>#attributes.unique_file_name#</cfoutput>">
                <input type="hidden" name="bulkUpload" id="bulkUpload" value="<cfoutput>#attributes.bulkUpload#</cfoutput>">
                <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                <table>
                    <tr>
                      <td><cf_get_lang_main no='56.Belge'> *</td>
                      <td><input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;"></td>
                    </tr>
                </table>
                <cf_popup_box_footer><cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'></cf_popup_box_footer>
            </cfform>
         </cf_popup_box>
		<script type="text/javascript">
            function kontrol()
            {
                if(document.getElementById('uploaded_file').value == "")
                {
                    alert("Lütfen belge seçiniz !");
                    return false;
                }
                return true;
            }
        </script>
    </cfif>
<cfelse>
	<script language="javascript">
		alert('Ticket değeri alınamadı lütfen entegrasyon bilgilerinizi kontrol ediniz!');
		window.close();
	</script>
</cfif>
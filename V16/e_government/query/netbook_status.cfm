<!---
    File: netbook_status.cfm
    Folder: V16\e_government\query
    Author:
    Date:
    Description:
        E-defter durum sorgulama
    History:
        12.10.2019 Gramoni-Mahmut Çifçi - E-Government standart modüle taşındı
    To Do:

--->

<cftry>
	<!--- entegrasyon bilgileri --->
    <cfscript>
        netbook = createObject("component","V16.e_government.cfc.netbook");
        netbook.dsn = dsn;
        getNetbookIntegrationInfo = netbook.getNetbookIntegration();
    </cfscript>
    
    <cfif getNetbookIntegrationInfo.recordcount and getNetbookIntegrationInfo.NETBOOK_INTEGRATION_TYPE eq 1>
        <cfinclude template="netbook_digital_planet_webservice.cfm" />
    <cfelse>
        <script language="javascript">
            alert('Lütfen Entegrasyon Yönteminizi ve Muhasebeci Tanımlarınızı Kontrol Ediniz!');
            window.close();
        </script>
        <cfabort>
    </cfif>
    <cfcatch>
        <cfscript>
            if(isDefined("application.bugLog")){
                application.bugLog.notifyService(
                    message='#session.ep.COMPANY# Şirketinde E-Defter Hatası!',
                    exception=cfcatch,
                    AppName='E-GOVERNMENT');
            }
        </cfscript>
    	<cfinclude template="../display/edefter_hata.cfm">
    </cfcatch>
</cftry>
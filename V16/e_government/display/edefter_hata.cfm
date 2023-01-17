<!--- Durgan20150513 E-Defter kapsamında webservis kullanan sayfalarda web servisin down olması ya da beklenen dışında parametre
	  döndürmesi gibi durumlar için try-catch yapılarında include ediliyor --->
<cfset receiver = "e-defter@workcube.com">
<cfquery name="GET_ADMIN" datasource="#DSN#">
    SELECT ADMIN_MAIL,COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID = #session.ep.company_id#
</cfquery>

<cftry>
    <cfmail from="#get_admin.admin_mail#" to="#receiver#" subject="#get_admin.company_name# şirketinde E-Defter Hatası!" type="html">
        <cfoutput>
            <strong>Message:</strong> #cfcatch.Message#<br />
            <strong>Detail:</strong> #cfcatch.Detail#<br /><br />
            
            <strong>Cause.Message:</strong> #cfcatch.Cause#<br /><br />
            
            <strong>Attributes:</strong> #SerializeJSON(attributes)#
        </cfoutput>
    </cfmail>
<cfcatch></cfcatch>
</cftry>
<cfdump var="#cfcatch#">
<cfabort>
<script language="javascript">
    alert('Geçici bir sorun oluştu. Lütfen daha sonra tekrar deneyiniz.');
    window.close();
</script>
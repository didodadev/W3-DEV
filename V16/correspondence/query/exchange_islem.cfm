<cfsetting showdebugoutput="no">
<cfparam name="Form.islem" default="">
<cfparam name="Form.folder" default="">
<cfparam name="URL.pvalue" default="1">
<cfparam name="URL.islem" default="">

<cfinclude template="../display/exchange_conn.cfm">
<!--- Silinmiş Klasörü Boşalt--->

<cfif URL.islem is "delSilinmis">
	<cfexchangemail action="get" connection="sample" name="mails">
	  <cfexchangefilter name="folder" value="Silinmiş Öğeler">
	</cfexchangemail>
	
	<cfset meetingData=evaluate("mails")>
	
	<cfquery dbtype="query" name="theResponses">
		SELECT * FROM meetingData
	</cfquery>  
	
	<cfoutput query="theResponses">
	  <cfexchangemail action = "deleteAttachments" uid="#uid#" connection = "sample" folder = "Silinmiş Öğeler">
	  <cfexchangemail action="delete" uid="#uid#" connection="sample" folder = "Silinmiş Öğeler">
	</cfoutput>
	  Silinmiş Öğeler Klasörü Boşaltılmıştır...
	  
	<script language="javascript">
		AjaxPageLoad('index.cfm?fuseaction=correspondence.emptypopup_exchange_mails&folder=Silinmi%C5%9F%20%C3%96%C4%9Feler','mails',1);		
	</script>
	<cfabort>
</cfif>

<!--- MAİL VE EK TAŞIMA--->
<cfif Form.islem is "move">
  <cfoutput>
    <cfif not FORM.mail_id is "">
      <cfset mail_id = URLDecode(FORM.mail_id)>
      <cfloop list="#mail_id#" index="m_id">
        <cfexchangemail action="move" connection="sample" folder = "#Form.folder#" destinationFolder="#Form.destinationFolder#">
          <cfexchangefilter name="UID" value="<#m_id#>">
        </cfexchangemail>
      </cfloop>
      <script language="javascript">
		  	alert('İşleminiz başarıyla gerçekleşmiştir.');
		  	window.close();
			window.opener.focus();
		  </script>
    </cfif>
  </cfoutput>
</cfif>

<!--- MAİL VE EK SİLME--->
<cfif Form.islem is "del">
  <cfoutput>
    <cfif not FORM.mail_id is "">
      <cfloop list="#FORM.mail_id#" index="m_id">
        <cfif FORM.folder is "Silinmiş Öğeler">
          <cfexchangemail action = "deleteAttachments" uid = "<#m_id#>" connection = "sample" folder = "#Form.folder#">
          <cfexchangemail action="delete" connection="sample" UID="<#m_id#>" folder = "#Form.folder#">
          <cfelse>
          <cfexchangemail action="move" connection="sample" folder = "#Form.folder#" destinationFolder="Silinmiş Öğeler">
            <cfexchangefilter name="UID" value="<#m_id#>">
          </cfexchangemail>
        </cfif>
        <script language="javascript">
			//document.getElementById('tr_#m_id#_mail_id').innerHTML='';
			//document.getElementById('tr_#m_id#').style.display = 'none';
			AjaxPageLoad('index.cfm?fuseaction=correspondence.emptypopup_exchange_mails&folder=<cfoutput>#URLEncodedFormat(Form.folder)#</cfoutput>','mails',1);
		</script>
      </cfloop>
    </cfif>
  </cfoutput>
</cfif>


<!--- OKUNMADI ATAMASI --->
<cfif Form.islem is "unread">
  <cfset mail = StructNew()>
  <cfset mail.ISREAD = false>
  <cfif not FORM.mail_id is "">
    <cfoutput>
      <cfloop list="#FORM.mail_id#" index="m_id">
        <cfexchangemail action="set" uid="<#m_id#>" message = "#mail#" folder = "#FORM.folder#" connection = "sample">
        <script language="javascript">
			document.getElementById('tr_#m_id#').style.fontWeight='bold';
			document.getElementById('tr_#m_id#_img_isread').innerHTML='<img src="/images/exchange/unread.gif">';
		</script>
      </cfloop>
    </cfoutput>
  </cfif>
</cfif>

<!--- ÖNCELİK ATAMASI --->
<cfif Form.islem is "priority">
  <cfset mail = StructNew()>
  <cfswitch expression="#Trim(Form.pvalue)#">
    <cfcase value="1">
    <cfset mail.IMPORTANCE = "Low">
    <cfset src = "down">
    </cfcase>
    <cfcase value="2">
    <cfset mail.IMPORTANCE = "Normal">
    <cfset src = "">
    </cfcase>
    <cfcase value="3">
    <cfset mail.IMPORTANCE = "High">
    <cfset src = "exclamation">
    </cfcase>
    <cfdefaultcase>
    <cfabort>
    </cfdefaultcase>
  </cfswitch>
  
  <cfif not FORM.mail_id is "">
    <cfoutput>
      <cfloop list="#FORM.mail_id#" index="m_id">
        <cfexchangemail action="set" uid="<#m_id#>" message = "#mail#" folder = "#Form.folder#" connection = "sample">
        <script language="javascript">
		<cfif not src is "" >
			document.getElementById('tr_#m_id#_img_importance').innerHTML='<img src="/images/exchange/#src#.gif" width="14">';
		<cfelse>
			document.getElementById('tr_#m_id#_img_importance').innerHTML='';
		</cfif>
	  </script>
      </cfloop>
    </cfoutput>
  </cfif>
</cfif>


<cfquery name="RESERVATION" datasource="#dsn#">
	SELECT 
	    RESERVATION_ID,
      #dsn#.Get_Dynamic_Language(RESERVATION_ID,'#session.ep.language#','SETUP_RESERVATION','RESERVATION',NULL,NULL,RESERVATION) AS RESERVATION,
      COLOR, 
      RECORD_DATE, 
      RECORD_EMP, 
      RECORD_IP, 
      UPDATE_DATE, 
      UPDATE_EMP, 
      UPDATE_IP 
    FROM 
    	SETUP_RESERVATION
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
	<cfif reservation.recordcount>
        <cfoutput query="reservation">
          <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="170">&nbsp;<a href="#request.self#?fuseaction=settings.form_upd_reservation&ID=#reservation_ID#" class="tableyazi">#reservation#</a></td>
          </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
        </tr>
    </cfif>
</table>		


<cfquery name="GET_SERVICE" datasource="#DSN3#" maxrows="1">
	SELECT
		SERVICE.SERVICE_DETAIL,
		SERVICE_APPCAT.SERVICECAT,
		SP.PRIORITY,
		SP.COLOR,
		SS.SERVICE_SUBSTATUS
	FROM
		SERVICE,
		SERVICE_APPCAT,
		#dsn_alias#.SETUP_PRIORITY AS SP,
		SERVICE_SUBSTATUS SS
	WHERE 		
		SERVICE.SERVICE_ACTIVE = 1 AND
		SERVICE.SERVICECAT_ID=SERVICE_APPCAT.SERVICECAT_ID AND
		SP.PRIORITY_ID = SERVICE.PRIORITY_ID AND
		SERVICE.SERVICE_SUBSTATUS_ID = SS.SERVICE_SUBSTATUS_ID AND
		PRO_SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#"> AND
		(FINISH_DATE >= #NOW()# OR FINISH_DATE IS NULL)
	ORDER BY
		SERVICE.RECORD_DATE DESC
</cfquery>
<table>
  	<tr style="height:20px;">
  		<td class="formbold"><cf_get_lang no='625.Servis Durumu'> <cfif get_service.recordcount><cfoutput>: #get_service.SERVICE_HEAD#</cfoutput></cfif></td>
  	</tr>
  	<tr>
  		<td>
			<cfif get_service.recordcount>
                <cfoutput query="get_service">
                    <table>
                        <tr>
                            <td><cf_get_lang_main no='74.Kategori'></td>
                            <td>: #servicecat#</td>
                        </tr>
                        <tr>
                            <td><cf_get_lang_main no='70.Aşama'></td>
                            <td>: #service_substatus#</td>
                        </tr>
                        <tr>
                            <td><cf_get_lang_main no='330.Açıklama'></td>
                            <td>: #service_detail#</td>
                        </tr>
                    </table>
                </cfoutput>
            <cfelse>
                <cf_get_lang_main no='72.Bu ürün ile ilgili servis kayıtı bulunamadı'>!
            </cfif>
		</td>
  	</tr>
</table>
<br/>
<!--- <cfif not isdefined("session.ww.userid") and not isdefined("session.pp.userid")>
	<table>
		<tr>
			<td><img src="/images/listele.gif" align="absmiddle"> <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.public_login" class="tableyazi"><cf_get_lang no='626.Detaylı Bilgi İçin Üye Girişi Yapmalısınız'>!</a></td>
		</tr>
	</table>
</cfif>
<cfinclude template="../../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif> --->



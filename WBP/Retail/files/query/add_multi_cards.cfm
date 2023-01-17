<cfset hata_mesaj = "">
<cfset sayac = 0>
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cfif len(first_card_no) and len(last_card_no)>
    <cfloop from="#first_card_no#" to="#last_card_no#" index="cc">
    	<cfset cc_ = PrecisionEvaluate(cc + 0)>
        <cfset cc_ = listgetat(cc_,1,'.')>
    	<cfset sayac = sayac + 1>
    	<cftry>
            <cfquery name="get_customer" datasource="#dsn_gen#">
                SELECT 
                	FK_CUSTOMER 
                FROM 
                	CARD 
                WHERE 
                	CODE = '#cc_#'
            </cfquery>
            <cfif get_customer.recordcount>
                <cfquery name="upd_param" datasource="#dsn_gen#">
                    UPDATE CUSTOMER_EXTENSION SET CUST_PARAMETER = '#attributes.parameter#' WHERE FK_CUSTOMER = #get_customer.FK_CUSTOMER#
                </cfquery>
            </cfif>
        <cfcatch>
        	<cfdump var="#cfcatch#">
            <cfsavecontent variable="hata_mesaj">
            <cfoutput>
            	#hata_mesaj#
                <br>
                #sayac#. satır #cc# kart numarası için hata : işlem başarısız.
             </cfoutput>
            </cfsavecontent>
        </cfcatch>
		</cftry>
    </cfloop>
</cfif>
<cf_form_box title="Kart Aktarım Sonucu">
<table>
	<tr>
    	<td>
		  <cfoutput>
            	İşlem Kodu : #wrk_id# <br>
                Başlangıç Numarası: #attributes.first_card_no# <br>
                Bitiş Numarası: #attributes.last_card_no# <br>
                Kayıt Sayısı: #sayac# <br>
              #hata_mesaj#
            </cfoutput>
        </td>
    </tr>
</table>

</cf_form_box>
<!--- şirket potansiyel değilse, finans module kullanılıyorsa ve kullanıcının finance modulunde yetkisi varsa cari hesap görülebilir--->
      <cfif (get_company.ISPOTANTIAL eq 0) and get_module_user(16)>
        <table CELLSPACING="0" CELLPADDING="0" WIDTH="98%" border="0">
          <tr CLASS="color-border">
            <td>
              <table CELLSPACING="1" CELLPADDING="2" WIDTH="100%" border="0">
                <tr CLASS="color-header">
                  <td ALIGN="center" CLASS="form-title" HEIGHT="22"><cf_get_lang no='316.Finansal Özet'></td>
                </tr>
                <cfquery name="GET_REMAINDER" datasource="#dsn2#">
					SELECT 
						* 
					FROM 
						COMPANY_REMAINDER 
					WHERE 
						COMPANY_REMAINDER.COMPANY_ID=#URL.CPID#
                </cfquery>
                <cfif get_remainder.recordcount>
                  <cfset borc = get_remainder.borc>
                  <cfset alacak = get_remainder.alacak>
                  <cfset bakiye = get_remainder.bakiye>
                <cfelse>
                  <cfset borc = 0>
                  <cfset alacak = 0>
                  <cfset bakiye = 0>
                </cfif>
                <cfquery name="GET_CREDIT" datasource="#dsn#">
					SELECT 
						TOTAL_RISK_LIMIT,MONEY
					FROM 
						COMPANY_CREDIT 
					WHERE
						COMPANY_CREDIT.COMPANY_ID=#URL.CPID#
                </cfquery>                
                <tr>
                    <td CLASS="color-row" ALIGN="center">
					<cfoutput>
					Borç : #TLFormat(ABS(borc))#&nbsp;#session.ep.money# <br/>
					Alacak : #TLFormat(ABS(alacak))#&nbsp;#session.ep.money# <br/>
                	<cf_get_lang_main no='177.Bakiye'>: #TLFormat(abs(bakiye))#&nbsp;#session.ep.money# <cfif borc gte alacak>(B)<cfelse>(A)</cfif>
                    </cfoutput>
				  	</td>
                </tr>
				<!--- 
				Hesap hatası var. Ömer Turhan
               
				<tr CLASS="color-header">
                  <td ALIGN="center" CLASS="form-title" HEIGHT="22"><cf_get_lang no='68.Kredi Durumu'></td>
                </tr>
                <tr CLASS="color-row">
                  <cfif get_credit.recordcount>
                    <cfset kredi=get_credit.total_risk_limit-bakiye>
					<cfset para_br = get_credit.money>
                  <cfelse>
                    <cfset kredi=bakiye*(-1)>
					<cfset para_br = "TL">
                  </cfif>
                  <td HEIGHT="22" ALIGN="center"><cfoutput>#TLFormat(abs(kredi))# #para_br#</cfoutput>
                    <cfif bakiye gte 0>
                      <cf_get_lang no='182.Kredi Açılmış'>
                      <cfelse>
                      <cf_get_lang no='183.Kredimiz Var'>
                    </cfif>
                  </td>
                </tr>
 				--->              
 			</table>
            </td>
          </tr>
        </table>
		<br/>
      </cfif>
      <cfset borc = 0>
      <cfset alacak = 0>
      <cfset bakiye = 0>

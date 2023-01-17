<cfheader statuscode="400" statustext="Bad Request">
<cfparam name="attributes.msg" default="">
<div style="display: block; margin: auto; margin-top: 10%; width: 50%;">
    <cf_box title="Plevne WAS">
        <h1 style="text-align: center;">Plevne WAS Here!</h1>
    <cfif len(attributes.msg)>
        <cfif attributes.msg eq "fuseactionshield">
            <p>Bu url formatı hatalı.</p>
            <p>Lütfen eriştiğiniz sayfanın adresini kontrol edin. Girdiğiniz sayfa size bir e-posta yolu ile geldi ise lütfen sistem yöneticinize iletin ve e-posta linkini açmaya çalışmayın. Girdiğiniz sayfa ve diğer bilgiler Plevne tarafından toplanmakta ve kayıt altına alınmaktadır. Harici bir linkden gelmediyseniz ilgili sorun sistem yöneticinize ulaşacaktır.</p>
        <cfelseif attributes.msg eq "notoken">
            <p>Token bulunamadı. Sayfayı yenilemeyin!</p>
            <div><a href="<cfoutput>#cgi.HTTP_REFERER#</cfoutput>">Geri Dön</a></div>
        <cfelseif attributes.msg eq "username">
            <p>Hatalı kullanıcı adı formatı, kullanıcı adınızda @ _ - ve . işareti olabilir</p>
            <div><a href="<cfoutput>#cgi.HTTP_REFERER#</cfoutput>">Geri Dön</a></div>
        </cfif>
    <cfelse>
        <p>Bir güvenlik ihlali ile karşılaştık.</p>
        <p>Girdiğiniz sayfa size bir e-posta yolu ile geldi ise lütfen sistem yöneticinize iletin ve e-posta linkini açmaya çalışmayın. Girdiğiniz sayfa ve diğer bilgiler Plevne tarafından toplanmakta ve kayıt altına alınmaktadır. Harici bir linkden gelmediyseniz ilgili sorun sistem yöneticinize ulaşacaktır.</p>
    </cfif>
    </cf_box>
</div>
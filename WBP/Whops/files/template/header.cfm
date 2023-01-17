<div class="bootstrap">
    <nav class="navbar nav_bar navbar-expand-xl navbar-light fixed-top shadow-sm row-bg-w">
        <a href="/<cfoutput>#request.self#?wo=whops.welcome</cfoutput>">
            <div class="navbar-brand nav-img p-0">
                <img src="../asset/img/whops.svg" width="80">
            </div>
        </a>
        <button type="button" data-toggle="collapse" data-target="##navbarsExampleDefault" aria-controls="navbarsExampleDefault" aria-expanded="false" aria-label="Toggle navigation" class="navbar-toggler">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div id="navbarsExampleDefault" class="collapse navbar-collapse">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item active kasa_css"><a href="<cfoutput>#request.self#</cfoutput>?wo=invoice.whops" class="nav-link">SATIŞ</a></li>
                <li class="nav-item active kasa_css"><a href="<cfoutput>#request.self#</cfoutput>?wo=whops.desks" class="nav-link">MASALAR</a></li>
                <div style="display:none;">
                    <li class="nav-item active kasa_css"><a href="##" class="nav-link">ARA VER</a></li>
                    <li class="nav-item active kasa_css"><a href="##" class="nav-link">BİTİR</a></li>
                    <li class="nav-item active kasa_css"><a href="##" class="nav-link">GÜNCELLE</a></li>
                    <li class="nav-item active kasa_css"><a href="##" class="nav-link">ÖZET</a></li>
                </div>
            </ul>
        </div>
        <div class="navbar-collapse collapse">
            <ul class="navbar-nav ml-auto d-flex align-items-center">
                <li class="nav-item kasa_css">Kasa: 15 / <cfoutput>#session_base.name# #session_base.surname# / #dateformat(now(),dateformat_style)#, #timeformat(now(),timeformat_style)#</cfoutput></li>
                <li class="nav-item kasa_css"><a href="https://wiki.workcube.com" target="_blank" class="nav-link" style="margin: -17px -10px 0px 0;"><img src="../asset/img/life_buoy.png" title="Wiki" alt="Wiki" style="width:30px;height:30px;margin-top:10px;"/></a></li>
                <li class="nav-item kasa_css"><a href="javascript://" onclick="logout();" class="nav-link" style="margin: -17px -10px 0px 0;"><img src="../asset/img/logout.png" title="Çıkış" alt="Çıkış" style="width:30px;height:30px;margin-top:10px;"/></a></li>
            </ul>
        </div>
    </nav>
</div>
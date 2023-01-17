<cfif StructKeyExists(session, "ADMIN_PASSWORD") AND  session.ADMIN_PASSWORD EQ PRIMARY_DATA.MAINTENANCE_PASSWORD>
    <style>
        body{
            position: relative;
            top: 48px;
        }

        header {
            top: 48px !important;
        }

        .protein-admin-tools-container {
            position: fixed;
            background: #424242;
            height: 48px;
            padding: 10px 10px;
            color: #ff9a9a;
            width: 100%;
            top: 0;
            z-index: 999999;
            display: flex;
            flex-direction: row;
            flex-wrap: nowrap;
            align-content: center;
            justify-content: space-between;
            align-items: center;
            border-left: 4px solid #ff9800;
            border-bottom: 2px solid #9e9e9e;
            box-shadow: 0px 2px 20px 0px #21212185;
        }

        span.protein-admin-title {
            font-weight: bold;
            font-size: 15px;
            color: #757575;
        }
        span.protein-admin-title img {
            width: 170px;
        }
        ul.protein-admin-menu {
            display: flex;
        }

        ul.protein-admin-menu li {
            margin-left: 10px;
            font-size: 13px;
        }

        ul.protein-admin-menu li a {
            color: #bdbdbd;
        }

        .protein-admin-tools-container-left {
            width: 100%;
            display: flex;
            align-items: center;
            flex-direction: row;
            justify-content: flex-start;
        }

        .protein-admin-tools-container-right {
            width: 100%;
            display: flex;
            align-items: center;
            flex-direction: row;
            justify-content: flex-end;
        }
        span.protein-admin-mode-widget-config-button {
            position: absolute;
            z-index: 88;
            display: flex;
            align-content: center;
            align-items: center;
            justify-content: center;
            padding: 10px;
            background: #03a9f4;
            font-size: 20px;
            box-shadow: 0 0 20px 0px #03a9f4;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            opacity: 0.3;
            left: 10px;
        }

        span.protein-admin-mode-widget-config-button a {
            color: white;
            font-size: 20px;
        }
        span.protein-admin-mode-widget-config-button:hover {
            opacity:1;
        }
        .fixed-top {
            top: 45px !important;
        }
    </style>
    <div class="protein-admin-tools-container" id="protein-admin-app">
        <div class="protein-admin-tools-container-left">
            <span class="protein-admin-title">
                <img src="/src/assets/img/protein_logo_white.png"/>
            </span>
            <ul class="protein-admin-menu">
                <li>
                    <a href="http://<cfoutput>#application.systemParam.employee_url#/index.cfm?fuseaction=protein.site&event=upd&site=#GET_SITE.SITE_ID#</cfoutput>" target="_blank">
                        <span class="protein-admin-menu-item-icon fas fa-globe-europe"></span>
                        <span class="protein-admin-menu-item-title">Site Ayarları</span>
                    </a>
                </li>
                <li>
                    <a href="http://<cfoutput>#application.systemParam.employee_url#/index.cfm?fuseaction=protein.pages&event=upd&page=#GET_PAGE.PAGE_ID#&site=#GET_SITE.SITE_ID#</cfoutput>" target="_blank">
                        <span class="protein-admin-menu-item-icon fas fa-th-large"></span>
                        <span class="protein-admin-menu-item-title">Sayfa Ayarları</span>
                    </a>                   
                </li>

                <li>
                    <a href="http://<cfoutput>#application.systemParam.employee_url#/index.cfm?fuseaction=protein.pages&event=add&site=#GET_SITE.SITE_ID#</cfoutput>" target="_blank">
                        <span class="protein-admin-menu-item-icon fas fa-plus-square"></span>
                        <span class="protein-admin-menu-item-title">Sayfa Oluştur</span>
                    </a>
                </li>
                <li>
                    <a href="/?heart=restart" target="_blank">
                        <span class="protein-admin-menu-item-icon fas fa-heart-broken"></span>
                        <span class="protein-admin-menu-item-title">Application Restart</span>
                    </a>
                </li>
            </ul>
        </div>
        <div class="protein-admin-tools-container-right">
            <ul class="protein-admin-menu">
                <li>
                    <a href="#" @click="logOutAdmin()">
                        <span class="protein-admin-menu-item-icon fas fa-sign-out-alt"></span>
                        <span class="protein-admin-menu-item-title">Çıkış</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>
    <script>
        var proteinApp = new Vue({
            el: '#protein-admin-app',
            data: {
              vue: 0       
            },
            methods: {
                logOutAdmin : function(){
                    axios.get( "/cfc/system/login.cfc?method=logOutAdmin",{params:{key:200}})
                    .then(response => {
                       setTimeout(function(){location.reload();} , 2000);                              
                    })
                    .catch(e => {
                       console.log("");
                    })
                }
            }       
        });
    </script>
</cfif>
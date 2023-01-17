<!---

    File :          upgrade_workcube.cfm
    Author :        Uğur Hamurpet<ugurhamurpet@workcube.com>
    Date :          15.08.2019
    Description :   Masterdan upgrade sistemine geçişte kullanılır.
                    Güncel sürüme geçiş yönergelerini içerir,
                    Müşterinin params.cfc de yer alan tüm parametrelerini arayüze taşır,
                    kayıt işleminden sonra tüm parametrelerin WRK_LICENSE taplosunda ki PARAMS kolonuna JSON formatında kaydedilmesini sağlar.
                    Standart dosyalarda yapılan geliştirimlerin listesini döker ve discard edilmesini sağlar.
    Notes :         Müşteri upgrade sistemini kullanıyorsa direkt olarak parametre kayıt arayüzüne yönlenir, 
                    önceden kendi eklemiş olduğu parametreleri de arayüzde görüntüler, yeni parametre gelmişse doldurur, istediği parametreleri günceller.

--->

<cfsetting requestTimeOut = "1000">

<cfparam name="attributes.type" default="upgradesystem">
<!--- 
    Aşağıdaki sayfalardan hangisinin gösterileceğini belirler. 
    values :    upgradesystem => Güncel Sürüme Geçiş Süreci
                paramsettings => Sistem Parametre Ayarları
                cfgitdifflist => CfGit üzerinden standart dosyalarda yapılan geliştirimlerin listesi
                cfgitdiscardchanges => cfGit üzerinden standart dosyalarda yapılan geliştirimleri discard eder
                changerelease => Güncel Sürüme Geçiş Sayfası
                getwrolist => Yeni sürümle gelen tüm WRO ların listesini alır
                dbcompare => Masterdan sürüm sistemine ya da sürümler arası geçişte şema karşılaştırma yapmak için karşılaştırma şema tablo view ve kullanıcılarını oluşturur.
                getwolang => Yeni sürümle gelen tüm Solution, Family, Module, Object, Widget, WEX, Output Template, Process Template ve dilleri devcatalyst.workcube.com adresinden alarak listeler
                restartworkcube => Sürüm geçişi sonunda sistemin restarlanmadan önceki son ekranıdır
                restartedworkcube => Sürüm geçişi sonunda sistemin restart edilmesini sağlar

--->
<cfparam name="attributes.upgrademode" default="upgrade">
<!--- 
    Sürümler arası geçişte upgrade ve patch update işlemlerinde kullanılır.
    values :    upgrade => Sürümler arası geçiş,
                patch => Mevcut sürümün patchlerini alırken
--->

<cfparam name="attributes.systemmode" default="production">
<!--- 
    Production ya da dev ve qa sistemlerini upgrade etmek için kullanılır.
    values :    production => Müşteri ortamlarını upgrade ederken,
                dev => dev ve qa ortamlarını upgrade ederken (Tüm aşamaları tamamlar)
                free => workcube devops sistemlerini upgrade ederken (getwrolist, getwolang ve paramsettings adımlarını pas geçer)
--->

<cfparam name="attributes.mode" default="1">
<!--- 
    Sayfanın Upgrade sürecinde çağırılıp çağırılmadığını belirler
    values :    1 => Master ya da Dev'den Upgrade sistemine geçiş, 
                2 => Sürümler arası geçiş
--->
<cfif session.ep.admin eq 0>
    <script>
        alert('<cf_get_lang dictionary_id="34269.İşlem Yapmaya Yetkiniz Yok">');
        history.back(-1);
    </script>
    <cfabort>
</cfif>

<cfscript>

    get_params = application.systemParam.systemParam();
    upgradeErrorControl = createObject( "component","cfc/upgrade_workcube_error_control" );
    upgrade_notes = createObject( "component","V16.objects.cfc.upgrade_notes" );

    /*
        #Yeni params düzeninde dsn bilgisi params.cfc dosyasından çıkarılıyor ve db ye taşınıyor.
        #application start durumunda dsn bilgisinin okunacağı yer ihtiyacı oluştuğundan ana dizinde dsn.txt isminde bir dosya oluşturulur.
        #dsn bilgisi dsn.txt içerisine yazılır.
    */

    if ( not FileExists( get_params.download_folder & "dsn.txt" ) ) {
        fileWrite( get_params.download_folder & "dsn.txt", get_params.dsn );
    }

    paramsSettings = createObject("component","V16/settings/cfc/params_settings");

    if( attributes.type neq 'upgradesystem' and attributes.type neq 'paramsettings' ){ ///Sürüm geçişlerinde json params henüz oluşmadığı için parametreler db den alınmaz
        params = paramsSettings.getDeserializedParams();
    }

    if ( attributes.type eq 'cfgitdifflist' || attributes.type eq 'cfgitdiscardchanges' || attributes.type eq 'checkoutRelease' ) {
        
        /*
            Upgrade sistemine geçişte ve upgrade sisteminde çalışır.
            
            cfgitdifflist: cfGit ile git üzerinden V16/add_options dışındaki tüm standart dosyalarda yapılan geliştirimleri algılar
            cfgitdiscardchanges : Standart dosyalardaki geliştirimleri geri alır.
            checkoutRelease : Gönderilen branch isminde checkout yapar.
        */

        cfGit = createObject( "component", "cfc/cfGit" );
        cfGit.init( 
            argGit_path : "git", 
            argGit_folder : params.git.git_dir,
            argGit_url : params.git.git_url,
            argGit_username : params.git.git_username,
            argGit_password : params.git.git_password
        );
        diffPages = [];

        if( attributes.type neq 'checkoutRelease' ){

            //Standart dosyalardaki geliştirimleri algılar
            excluding = ["--"];
            diff = cfGit.diff( stat:true, nameOnly:true, option : { getArray:true, workTreeMode:true, excluding : excluding } );
            if( diff.status ) diffPages = diff.diffPages;
            else{
                upgradeErrorControl.setNewError(
                    errorMessageTitle :         application.functions.getLang('contract',242) & "!", /// Standart dosyalardaki geliştirimler algılanırken bir hata oluştu!
                    errorMessage :              application.functions.getLang('contract',237) & ".<br>" & application.functions.getLang('contract',241) & ".", /// Hata çıktısı aşağıdaki gibidir. <br> Sürüm geçişine devam etmek için Yeniden deneyine tıklayabilirsiniz
                    errorAfterRedirectUrl :     "#request.self#?fuseaction=objects.popup_upgrade_workcube&type=cfgitdifflist",
                    exception :                 diff.result
                );
            }

        }
            
        if( attributes.type eq 'cfgitdiscardchanges' ){
            
            resetResponse = structNew();
            resetResponse = { status: true };
            if( arrayLen( diffPages ) ){
                /* for ( page in diffPages ) {

                    response = cfGit.checkout( discardFilePath : page, option : { workTreeMode:true } );
                    if( !response.status ){
                        error = true;
                        errorMessage = response.result;
                        break;
                    }
                
                } */

                //Tüm standart dışı dosyaları resetler.
                resetResponse = cfGit.reset( option : { workTreeMode:true } );
            }

            if( resetResponse.status || findNoCase( "Updating files", resetResponse.result ) ) location( url = "#request.self#?fuseaction=objects.popup_upgrade_workcube&type=changerelease&upgrademode=#attributes.upgrademode#&systemmode=#attributes.systemmode#&mode=#attributes.mode#", addToken = "no" );
            else{
                upgradeErrorControl.setNewError(
                    errorMessageTitle :         application.functions.getLang('contract',224) & "!", /// Standart dosyalardaki geliştirimler kaldırılırken bir hata oluştu!
                    errorMessage :              application.functions.getLang('contract',237) & ".<br>" & application.functions.getLang('contract',241) & ".", /// Hata çıktısı aşağıdaki gibidir. <br> ///Sürüm geçişine devam etmek için Yeniden deneyine tıklayabilirsiniz.
                    errorAfterRedirectUrl :     "#request.self#?fuseaction=objects.popup_upgrade_workcube&type=cfgitdifflist&upgrademode=#attributes.upgrademode#&systemmode=#attributes.systemmode#",
                    exception :                 resetResponse.result
                );
            }

        }else if( attributes.type eq 'checkoutRelease' ){

            if( IsDefined("attributes.release_no") and len( attributes.release_no ) and IsDefined("attributes.last_release_date") and len( attributes.last_release_date ) and IsDefined("attributes.release_date") and len( attributes.release_date ) ){
                
                /// upgrade işleminin başladığını applicationa haber verir. Upgrade süresince kullanılacak parametreleri upgrade.cfc içerisinde property olarak saklar.
                /// Gönderilen branch isminde checkout yapar.
                /// Sistemdeki admin harici bütün kullanıcıların oturumlarını sonlandırır. 
                /// Checkout sonrasında sorun olmazsa Wro listeleme sayfasına yönlenir.

                if( not IsDefined("application.upgradeSystem") ){

                    application.upgradeSystem = createObject("component","cfc.upgrade");
                    structAppend(variables,application.upgradeSystem);
                
                }

                application.upgradeSystem.set(
                    status:             ( attributes.systemmode eq 'production' ) ? true : false,
                    step:               attributes.type,
                    release_no:         attributes.release_no,
                    last_release_date:  attributes.last_release_date,
                    release_date:       attributes.release_date,
                    patch_no:           ( attributes.systemmode eq 'production' ) ? ( attributes.upgrademode eq 'patch' ? attributes.patch_no : '' ) : '',
                    patch_date:         ( attributes.systemmode eq 'production' ) ? ( attributes.upgrademode eq 'patch' ? attributes.patch_date : '') : ''
                );

                if(attributes.systemmode eq 'production') upgrade_notes.DELETE_SESSION();
                
                ///Mevcut branch pull edilir
				pullResponse = cfGit.pull( 
					pullBranchName : (attributes.systemmode eq 'production') ? "releases/#get_params.workcube_version#" : "#get_params.workcube_version#", 
					option : { workTreeMode:true } 
				);
				
                if( pullResponse.status || findNoCase( "From", pullResponse.result ) ){

					///Yeni branchları almak için fetch yapılır
					fetchResponse = cfGit.fetch( option : { workTreeMode:true } );

					if( fetchResponse.status || findNoCase( "From", fetchResponse.result ) ){

						//Sürümler arası geçiş yapılıyorsa checkout yapılır.
						if( attributes.upgrademode eq 'upgrade' ) response = cfGit.checkout( checkoutBranchName : "releases/#attributes.release_no#", option : { workTreeMode:true } );
						else response = cfGit.pull( pullBranchName : (attributes.systemmode eq 'production') ? "releases/#attributes.release_no#" : "#attributes.release_no#", option : { workTreeMode:true } ); //Sürümün patchleri alınacaksa pull yapılır

						if( 
							response.status 
							|| ( attributes.upgrademode eq 'upgrade' && (findNoCase( "Switched to branch", response.result ) || findNoCase( "Switched to a new branch", response.result ) || findNoCase( "Already on", response.result )) )
							|| ( attributes.upgrademode eq 'patch' && findNoCase( "From", response.result ) ) 
						) {

							createObject("component","Application").OnApplicationStart();
							application.upgradeSystem.set(
								status:             ( attributes.systemmode eq 'production' ) ? true : false,
								step:               attributes.type,
								release_no:         attributes.release_no,
								last_release_date:  attributes.last_release_date,
								release_date:       attributes.release_date,
								patch_no:           ( attributes.systemmode eq 'production' ) ? ( attributes.upgrademode eq 'patch' ? attributes.patch_no : '' ) : '',
								patch_date:         ( attributes.systemmode eq 'production' ) ? ( attributes.upgrademode eq 'patch' ? attributes.patch_date : '') : ''
							);
							type = ( attributes.mode == 1 || attributes.systemmode eq 'dev' ) ? 'getwrolist' : 'paramsettings';
							location( url = "#request.self#?fuseaction=objects.popup_upgrade_workcube&upgrademode=#attributes.upgrademode#&systemmode=#attributes.systemmode#&type=#type#&mode=#attributes.mode#&runwro=1", addtoken = "no" );

						}else{
							upgradeErrorControl.setNewError(
								errorMessageTitle :         application.functions.getLang('contract',243) & "!", /// Sürüm geçişi sırasında bir hata oluştu!
								errorMessage :              application.functions.getLang('contract',237) & ".<br>" & application.functions.getLang('contract',241) & ".", /// Hata çıktısı aşağıdaki gibidir. <br> Sürüm geçişine devam etmek için Yeniden deneyine tıklayabilirsiniz.
								errorAfterRedirectUrl :     "#request.self#?fuseaction=objects.popup_upgrade_workcube&upgrademode=#attributes.upgrademode#&systemmode=#attributes.systemmode#&type=cfgitdifflist&mode=#attributes.mode#",
								exception :                 response.result
							);
						}
						
					}else{
						upgradeErrorControl.setNewError(
							errorMessageTitle :         application.functions.getLang('contract',243) & "!", /// Sürüm geçişi sırasında bir hata oluştu!
							errorMessage :              application.functions.getLang('contract',237) & ".<br>" & application.functions.getLang('contract',241) & ".", /// Hata çıktısı aşağıdaki gibidir. <br> Sürüm geçişine devam etmek için Yeniden deneyine tıklayabilirsiniz.
							errorAfterRedirectUrl :     "#request.self#?fuseaction=objects.popup_upgrade_workcube&type=cfgitdifflist&upgrademode=#attributes.upgrademode#&systemmode=#attributes.systemmode#&type=cfgitdifflist&mode=#attributes.mode#",
							exception :                 fetchResponse.result
						);
					}

                }else{
                    upgradeErrorControl.setNewError(
                        errorMessageTitle :         application.functions.getLang('contract',243) & "!", /// Sürüm geçişi sırasında bir hata oluştu!
                        errorMessage :              application.functions.getLang('contract',237) & ".<br>" & application.functions.getLang('contract',241) & ".", /// Hata çıktısı aşağıdaki gibidir. <br> Sürüm geçişine devam etmek için Yeniden deneyine tıklayabilirsiniz.
                        errorAfterRedirectUrl :     "#request.self#?fuseaction=objects.popup_upgrade_workcube&type=cfgitdifflist&upgrademode=#attributes.upgrademode#&systemmode=#attributes.systemmode#&type=cfgitdifflist&mode=#attributes.mode#",
                        exception :                 pullResponse.result
                    );
                }

            }

        }

    }else if( attributes.type eq 'paramsettings' ){

        /*
            #Upgrade sistemindeyse ya da upgrade sistemine geçişte parametre ayarları sayfasındaysa çalışır
            #Yeni bir parametre eklenecekse data structının son elemanı olarak eklenir.
            #Müşteri upgrade olurken yeni gelen parametreyi doldurur ve upgrade işlemine devam eder.
        */

        params_controller = createObject( "component", "cfc/params_controller" );
        getParamsSetting = params_controller.getParamsSetting();
        data = getParamsSetting.data;
        hasChildParamList = getParamsSetting.hasChildParamList;

        if( attributes.mode eq 2 ){

            //Mode 2 ise upgrade sisteminde işlem yapılıyordur.
            //Önceden kaydedilen parametreler de WRK_LICENSE PARAMS kolunundan alınarak data structına eklenir.
            
            data = paramsSettings.getAllParams(data);
    
        }

    }else if( attributes.type eq 'changerelease' ){
        
        //Yeni sürüme geçiş öncesi online kullanıcı sayısını bulur
        online_count = upgrade_notes.GET_ONLINE_COUNT();

        if( isDefined( "attributes.git_username" ) and len( attributes.git_username ) and isDefined( "attributes.git_password" ) and len( attributes.git_password ) ){
            
            params_settings = createObject("component", "V16/settings/cfc/params_settings");

            params.git.git_username = attributes.git_username;
            params.git.git_password = attributes.git_password;
            params_settings.UPDATE_PARAMS_COL( Replace( serializeJSON( params ), "//", "" ) );

        }
    
    }else if( attributes.type eq 'getwrolist' ){
        
        //Yeni sürüme ya da master dan upgrade sistemine geçişte çalışır.

        wroController = createObject("component","V16/settings/cfc/wroControl");
            
        //get WRO list
        wroController.readFilePath( 
            release_date: ( attributes.mode == 2 ) ? application.upgradeSystem.last_release_date : dateformat(dateadd('d',-360,now()),'yyyy-mm-dd H:m:s'), 
            new_release_date: ( attributes.mode == 2 and attributes.systemmode eq 'production' ) ? (attributes.upgrademode eq 'patch' ? application.upgradeSystem.patch_date : application.upgradeSystem.release_date) : dateformat(Now(),'yyyy-mm-dd H:m:s') 
        );
        wroList = wroController.getTable( 
            is_work : 0, 
            release_date: ( attributes.mode == 2 ) ? application.upgradeSystem.last_release_date : "", 
            new_release_date: ( attributes.mode == 2 and attributes.systemmode eq 'production' ) ? (attributes.upgrademode eq 'patch' ? application.upgradeSystem.patch_date : application.upgradeSystem.release_date) : dateformat(Now(),'yyyy-mm-dd H:m:s') 
        );

    }else if( attributes.type eq 'restartedworkcube' ){
        if( attributes.systemmode eq 'production' ){
            upgrade_notes.ADD_NEW_LICENSE(
                upgradeMode:url.upgrademode,
                release_no:application.upgradeSystem.release_no,
                release_date:application.upgradeSystem.release_date,
                git_url:params.git.git_url,
                git_dir:params.git.git_dir,
                git_branch:"releases/#application.upgradeSystem.release_no#",
                patch_no:attributes.upgrademode eq 'patch' ? application.upgradeSystem.patch_no : '',
                patch_date:attributes.upgrademode eq 'patch' ? application.upgradeSystem.patch_date : ''
            );
        }
        createObject("component","Application").OnApplicationStart();
    }

    //#Upgrade süreci boyunca header kısmında kullanılan başlıkları yönetir.

    /*
        #title : Header da gösterilecek başlık
        #show : Başlığın hangi aşamalarda header kısmında **görüntüleneceğini** yönetir. İki parametre alır.
            #mastertoupg : master ya da dev üzerinden upgrade sistemine geçişte gösterilecek başlıkları yönetir.
            #upgtoupg : upgrade sisteminde sürüm geçişlerinde gösterilecek başlıkları yönetir.
    */
    
    headerStep = StructNew();
    headerStep = {
        paramsettings = {
            title : application.functions.getLang("","Sistem Parametre Ayarlarını Düzenleyin",49443),
            show : { mastertoupg : "paramsettings,cfgitdifflist", upgtoupg : "cfgitdifflist,changerelease,paramsettings"}
        },
        cfgitdifflist = {
            title : application.functions.getLang("","Standart dosyalarda Yapılan Geliştirimleri Geri Alın",49445),
            show : { mastertoupg : "paramsettings,cfgitdifflist,changerelease", upgtoupg : "cfgitdifflist,changerelease"}
        },
        changerelease = {
            title : attributes.upgrademode eq 'upgrade' ? application.functions.getLang("","Workcube'ün Güncel Sürümüne Geçin",49462) : application.functions.getLang("","En son sürüm güncelleştirmelerini alın",64153),
            show : { mastertoupg : "paramsettings,cfgitdifflist,changerelease,getwrolist", upgtoupg : "cfgitdifflist,changerelease,paramsettings"}
        },
        getwrolist = {
            title : application.functions.getLang('','Tüm güncel WRO sorgularını çalıştırın',50998),
            show : { mastertoupg : "changerelease,getwrolist", upgtoupg : "paramsettings,getwrolist,getwolang,restartworkcube"}
        },
        getwolang = {
            title : application.functions.getLang('','Güncel Obje ve Dilleri Yükleyin',51000),
            show : { mastertoupg : "getwrolist,getwolang,restartworkcube", upgtoupg : "#(attributes.systemmode eq 'production' or attributes.systemmode eq 'dev') ? 'getwrolist,getwolang,restartworkcube' : ''#"}
        },
        restartworkcube = {
            title : application.functions.getLang('',"Workcube'ü Yeniden Başlatın",51001),
            show : { mastertoupg : "getwolang,restartworkcube", upgtoupg : "getwrolist,getwolang,restartworkcube"}
        }
    };

</cfscript>
<cf_box id="workcube_upgrade" title="">
    <div class="col col-12 col-md-12 col-xs-12 mt-3">
        <div  class="header col col-12 col-md-12 col-xs-12">
            <img src="css/assets/icons/catalyst-icon-svg/workcube-logo.svg" width="60" height="55">
            <h3>WORKCUBE</h3>
        </div>
        <cfif not upgradeErrorControl.errorStatus>
            
            <cfif attributes.type eq 'upgradesystem'>
                <div class="col col-12 col-md-12 col-xs-12 pl-0 pr-0">
                    <div class="col col-12 release_info">
                        <h4><cf_get_lang dictionary_id = "49430.Güncel Sürüme Geçiş Süreci"> <a href="<cfoutput>#request.self#?fuseaction=objects.popup_about_workcube</cfoutput>"><cf_get_lang dictionary_id = "49433.Sürüm Notlarına Geri Dön"></a></h4>
                        <div class="before-release col col-12">
                            <p>
                                <cf_get_lang dictionary_id = "49442.Sisteminizi en güncel sürüme yükseltmek için aşağıdaki yönergeleri izlemelisiniz">.
                            </p>
                            <cfoutput>
                                <div class="col col-12 before-release-warning">
                                    <div class="col col-4 col-xs-12">
                                        <div class="before-release-warning-content">
                                            <h3>1</h3>
                                            <h4><cfif attributes.mode eq 1>#headerStep["paramsettings"]["title"]#<cfelse>#headerStep["cfgitdifflist"]["title"]#</cfif></h4>
                                        </div>
                                    </div>
                                    <div class="col col-4 col-xs-12">
                                        <div class="before-release-warning-content">
                                            <h3>2</h3>
                                            <h4><cfif attributes.mode eq 1>#headerStep["cfgitdifflist"]["title"]#<cfelse>#headerStep["changerelease"]["title"]#</cfif></h4>
                                        </div>
                                    </div>
                                    <div class="col col-4 col-xs-12">
                                        <div class="before-release-warning-content">
                                            <h3>3</h3>
                                            <h4><cfif attributes.mode eq 1>#headerStep["changerelease"]["title"]#<cfelse>#headerStep["paramsettings"]["title"]#</cfif></h4>
                                        </div>
                                    </div>
                                </div>
                            </cfoutput>
                            <p>
                                <cf_get_lang dictionary_id = "49464.Hazırsanız devam et tuşuna tıklayarak devam edebilirsiniz">
                            </p>
                        </div>
                    </div>
                    <div class="col col-12 formContentFooter mt-3">
                        <cfform action="#request.self#?fuseaction=objects.popup_upgrade_workcube&type=paramsettings&mode=#attributes.mode#" type="formControl">
                            <div class="col col-9 col-xs-12" id="warningMessage"></div>
                            <div class="col col-3 col-xs-12">
                                <input type="submit" class="flt-r ui-wrk-btn ui-wrk-btn-success" value="<cf_get_lang dictionary_id='44097. Devam Et'>">
                            </div>
                        </cfform>
                    </div>
                </div>
            <cfelseif attributes.type eq 'paramsettings'>
                <div class="col col-12 col-md-12 col-xs-12 pl-0 pr-0">
                    <div class="col col-12 release_info">
                        <cfinclude template="upgrade_workcube_header.cfm">
                        <div class="before-release col col-12">
                            <p><cf_get_lang dictionary_id = "49422.Güncel sürüme geçiş yapmadan önce, aşağıdaki formda bulunan parametre ayarlarınızı doğrulamanız, eksik olduğunu düşündüğünüz parametreleri (+) butonunu kullanarak eklemeniz gerekmektedir"></p>
                            <p><cf_get_lang dictionary_id = "49423.Tüm parametre ayarlarının doğru olduğuna eminseniz, sayfanın en altında bulunan kaydet butonuna tıklayarak devam edebilirsiniz"></p>
                        </div>
                    </div>
                    <cfform name="form_params_settings" id="form_params_settings" method="post" type="formControl">
                        <div class="col col-12 col-md-12 mt-3">
                            <cfoutput>
                                <cf_flat_list id = "paramsettings">
                                    <thead>
                                        <tr>
                                            <th align="right">R</th>
                                            <th><cf_get_lang dictionary_id='48413.sistem parametre adı'></th>
                                            <th><cf_get_lang dictionary_id='58660.değeri'></th>
                                            <th width="20" class="text-center"><a href = "javascript://" onclick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <cfset currentRow = 1>
                                        <cfloop collection="#data#" item="key">
                                            <cfif ArrayFindNoCase( hasChildParamList, key )>
                                                <cfloop collection="#data[key]#" item="childKey">
                                                    <tr id="param_#currentrow#">
                                                        <td align="right">#iif((data[key][childKey]['required']), DE('*'), DE(''))#</td>
                                                        <td><div class="form-group"><input type="text" style="width:100%;" value="#LCase(key)#.#LCase(childKey)#" #iif((data[key][childKey]['required']), DE('required'), DE(''))# #iif((data[key][childKey]['readonlyKey']), DE('readonly'), DE(''))# placeholder="<cf_get_lang dictionary_id='48413.sistem parametre adı'>" name="name_row#currentrow#" id="name_row#currentrow#"></div></td>
                                                        <td>
                                                            <div class="form-group">
                                                                <cfif data[key][childKey]['type'] eq "select">
                                                                    <select name="value_row#currentrow#" id="value_row#currentrow#">
                                                                        <cfloop array="#data[key][childKey]['option']#" index="i" item="item">
                                                                            <option value="#item.value#" #data[key][childKey]['val'] eq item.value ? 'selected' : ''#>#item.text#</option>
                                                                        </cfloop>
                                                                    </select>
                                                                <cfelse>
                                                                    <input type="#data[key][childKey]['type']#" style="width:100%;" value="#data[key][childKey]['val']#" #iif((data[key][childKey]['required']), DE('required'), DE(''))# #iif((data[key][childKey]['readonlyValue']), DE('readonly'), DE(''))# placeholder="<cf_get_lang dictionary_id='58660.değeri'>" name="value_row#currentrow#" id="value_row#currentrow#">
                                                                </cfif>
                                                            </div>
                                                        </td>
                                                        <td width="20" class="text-center"><a href = "##" onclick="del_row('param_#currentrow#', #iif((data[key][childKey]['required']), DE('1'), DE('0'))#);return false;"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                                                    </tr>
                                                </cfloop>
                                            <cfelse>
                                                <tr id="param_#currentrow#">
                                                    <td align="right">#iif((data[key]['required']), DE('*'), DE(''))#</td>
                                                    <td><div class="form-group"><input type="text" style="width:100%;" value="#LCase(key)#" #iif((data[key]['required']), DE('required'), DE(''))# #iif((data[key]['readonlyKey']), DE('readonly'), DE(''))# placeholder="<cf_get_lang dictionary_id='48413.sistem parametre adı'>" name="name_row#currentrow#" id="name_row#currentrow#"></div></td>
                                                    <td>
                                                        <div class="form-group">
                                                            <cfif data[key]['type'] eq "select">
                                                                <select name="value_row#currentrow#" id="value_row#currentrow#">
                                                                    <cfloop array="#data[key]['option']#" index="i" item="item">
                                                                        <option value="#item.value#" #data[key]['val'] eq item.value ? 'selected' : ''#>#item.text#</option>
                                                                    </cfloop>
                                                                </select>
                                                            <cfelse>
                                                                <input type="#data[key]['type']#" style="width:100%;" value="#data[key]['val']#" #iif((data[key]['required']), DE('required'), DE(''))# #iif((data[key]['readonlyValue']), DE('readonly'), DE(''))# placeholder="<cf_get_lang dictionary_id='58660.değeri'>" name="value_row#currentrow#" id="value_row#currentrow# ">
                                                            </cfif>
                                                        </div>
                                                    </td>
                                                    <td width="20" class="text-center"><a href = "##" onclick="del_row('param_#currentrow#', #iif((data[key]['required']), DE('1'), DE('0'))#);return false;"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                                                </tr>
                                            </cfif>
                                            <cfset currentRow = currentRow + 1>
                                        </cfloop>
                                    </tbody>
                                </cf_flat_list>
                                <cf_box_footer>
                                    <div class="col col-8 col-xs-12" id="warningMessage"></div>
                                    <div class="col col-4 col-xs-12 mt-2 pdn-r-0">
                                        <input type="submit" class="pull-right ui-wrk-btn ui-wrk-btn-success" value="<cf_get_lang dictionary_id='57461. Kaydet'>">
                                    </div>
                                </cf_box_footer>
                            </cfoutput>
                        </div>
                    </cfform> 
                </div>
            <cfelseif attributes.type eq 'cfgitdifflist'>
                <div class="col col-12 col-md-12 col-xs-12 pl-0 pr-0">
                    <div class="col col-12 release_info">
                        <cfinclude template="upgrade_workcube_header.cfm">
                        <cfif arrayLen(diffPages)>
                            <div class="before-release col col-12">
                                <p><cf_get_lang dictionary_id="49956.Son sürüme geçebilmeniz için standart dosyalarda yaptığınız değişiklikleri kaldırmanız ya da dosyaları add options olarak kaydetmeniz gerekiyor">!</p>
                                <p><cf_get_lang dictionary_id="49960.Geliştirim yapılmış standart dosya sayısı"> : <strong><cfoutput>#arrayLen(diffPages)#</cfoutput></strong></p>
                                <p><cf_get_lang dictionary_id="49961.Devam et tuşuna basarak ilerlerseniz tüm değişiklikleriniz geri alınacak ve bir sonraki aşamaya geçilecek"></p>
                                <p><a href="javascript://" onclick = "location.reload();"><cf_get_lang dictionary_id="51808.Yeniden Kontrol et"></a></p>
                            </div>
                        </cfif>
                    </div>
                    <div class="col col-12 col-md-12 mt-3">
                        <cfoutput>
                            <cf_flat_list id = "cfgitdifflist">
                                <thead>
                                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                    <th><cf_get_lang dictionary_id="49955.Dosya Yolu"></th>
                                    <th><cf_get_lang dictionary_id="29800.Dosya Adı"></th>
                                </thead>
                                <tbody>
                                    <cfif arrayLen(diffPages)>
                                        <cfset i = 1>
                                        <cfloop array="#diffPages#" index="val">
                                            <tr>
                                                <td>#i#</td>
                                                <td>#val#</td>
                                                <td>#listLast(val,"/")#</td>
                                            </tr>
                                            <cfset i++>
                                        </cfloop>
                                    <cfelse>
                                        <tr><td colspan="3" class="text-center" style="font-size: 16px; color:##17b517; padding:25px;"><cf_get_lang dictionary_id="49962.Standart dosyalarda değişim bulunamadı">!</td></tr>
                                    </cfif>
                                </tbody>
                            </cf_flat_list>
                            <cfform action="#request.self#?fuseaction=objects.popup_upgrade_workcube&type=cfgitdiscardchanges&upgrademode=#attributes.upgrademode#&systemmode=#attributes.systemmode#&mode=#attributes.mode#" type="formControl">
                                <cf_box_footer>
                                    <div class="col col-9 col-xs-12" id="warningMessage"></div>
                                    <div class="col col-3 col-xs-12 mt-2 pdn-r-0">
                                        <input type="submit" class="flt-r ui-wrk-btn ui-wrk-btn-success" value="<cf_get_lang dictionary_id='44097. Devam Et'>">
                                    </div>
                                </cf_box_footer>
                            </cfform>
                        </cfoutput>
                    </div>
                </div>
            <cfelseif attributes.type eq 'changerelease'>
                <div class="col col-12 col-md-12 col-xs-12 pl-0 pr-0">
                    <div class="col col-12 release_info">
                        <cfinclude template="upgrade_workcube_header.cfm">
                        <cfset api_key = "201118kSm20">
                        <cfset session_ep_language = "#session.ep.language#">
                        <cfhttp url="https://networg.workcube.com/web_services/webserviceforrelease.cfc?method=GET_UPGRADE_NOTES" result="response" charset="utf-8">
                            <cfhttpparam name="api_key" type="formfield" value="#api_key#">
                            <cfhttpparam name="session_ep_language" type="formfield" value="#session_ep_language#">
                            <cfhttpparam name="get_last_release" type="formfield" value="1">
                        </cfhttp>
                        <cfset service_upgrade_notes =  DeserializeJSON(Replace(response.filecontent,"//",""))>
                        
                        <cfhttp url="https://networg.workcube.com/web_services/webserviceforrelease.cfc?method=CHECK_GIT_CODE" result="response" charset="utf-8">
                            <cfhttpparam name="api_key" type="formfield" value="#api_key#">
                            <cfhttpparam name="release_no" type="formfield" value="#service_upgrade_notes.RELEASE[1].release#">
                            <cfhttpparam name="git_username" type="formfield" value="#params.git.git_username#">
                            <cfhttpparam name="git_password" type="formfield" value="#params.git.git_password#">
                        </cfhttp>
                        <cfset checkGitCode =  DeserializeJSON(Replace(response.filecontent,"//",""))>

                        <cfif not checkGitCode.status>
                            <div class="before-release col col-12">
                                <p><cf_get_lang dictionary_id='63542.Sürüm yükseltme işlemine devam edebilmeniz için Git kullanıcı adı ve şifresini doğrulamanız gerekiyor!'></p>
                                <p><cf_get_lang dictionary_id='63543.Aşağıdaki kullanıcı adı ve şifre alanlarını Workcubeden aldığınız Git erişim bilgileriyle doldurunuz.'></p>
                                <p><cf_get_lang dictionary_id='65266.Kullanıcı adının doğruluğundan eminseniz Git Password alanının yanındaki Bitbucket App Password Al ikonuna tıklayınız, git şifresi otomatik olarak doldurulacaktır'>.</p>
                            </div>
                        </cfif>
                    </div>
                    <div class="col col-12 col-md-12 mt-3">
                        <cfif checkGitCode.status> <!--- Git erişim bilgileri doğrulandıysa --->
                            <cf_box>
                                <cf_box_elements>
                                    <div class="col col-12 col-md-12 mt-3 pdn-l-0 pdn-r-0">
                                        <cfoutput>
                                            <div class="col col-6 col-xs-12 mt-3 release_info pdn-l-0">
                                                <h4><cf_get_lang dictionary_id="43922.Sürüm Bilgileriniz"></h4>
                                                <span class="rd_title"><cfoutput>#(application.systemParam.systemParam().workcube_version eq "catalyst v1.0") ? "master" : application.systemParam.systemParam().workcube_version#</cfoutput></span>
                                            </div>
                                            <cfif attributes.systemmode eq 'production'>
                                                <div class="col col-6 col-xs-12 mt-3 release_info pdn-r-0">
                                                    <cfif attributes.upgrademode eq 'upgrade'>
                                                        <h4><cf_get_lang dictionary_id="43778.Upgrade Edilecek Sürüm"></h4>
                                                        <span class="rd_title"><cfoutput>#service_upgrade_notes.RELEASE[1].release#</cfoutput></span>
                                                        <span class="br_title">#dateformat(service_upgrade_notes.RELEASE[1].note_date,dateformat_style)#</span>
                                                    <cfelse>
                                                        <h4><cf_get_lang dictionary_id='63544.Sürüm Patch Bilgileri'></h4>
                                                        <cfscript>releaseInfo = arrayFilter(service_upgrade_notes.RELEASE, function( elm ){ return elm.release eq application.systemParam.systemParam().workcube_version; })[1];</cfscript>
                                                        <cfif len(releaseInfo.patch_info)>
                                                            <cfscript> lastPatch = arrayFilter(deserializeJSON( releaseInfo.patch_info ), function( el ){ return el.patch_status; })[1]; </cfscript>
                                                            <span class="rd_title"><cfoutput>#lastPatch.PATCH_NO#</cfoutput></span>
                                                            <span class="br_title">#dateformat(lastPatch.PATCH_DATE,dateformat_style)#</span>
                                                        </cfif>
                                                    </cfif>
                                                </div>
                                            </cfif>
                                        </cfoutput>
                                    </div>
                                    <cfset licenseVerified = true /><!--- systemmode = free olan ortamlarda doğrulama gerekmez!!! --->
                                    <cfif attributes.systemmode eq 'production' or attributes.systemmode eq 'dev'>
                                        <cfset licenseVerified = false />
                                        <cfset get_license_information =  upgrade_notes.get_license_information() />
                                        <cfif get_license_information.recordcount and len(get_license_information.WORKCUBE_ID)>
                                            <cfset api_key = "20180911HjPo356h">
                                            <cfhttp url="https://networg.workcube.com/web_services/uhtil854o2018.cfc?method=CHECK_LICENSE_CODE" result="response" charset="utf-8">
                                                <cfhttpparam name="api_key" type="formfield" value="#api_key#">
                                                <cfhttpparam name="domain_address" type="formfield" value="#listFirst(get_params.employee_url,';')#">
                                                <cfhttpparam name="license_code" type="formfield" value="#get_license_information.WORKCUBE_ID#">
                                            </cfhttp>
                                            <cfset licenseVerification = DeserializeJSON(response.filecontent)>
                                            <cfset licenseVerified = licenseVerification.STATUS />
                                        </cfif>
                                    </cfif>
                                    <div class="col col-12 col-md-12 mt-5 warning">
                                        <div class="col col-1 col-xs-12 warningTitle">
                                            <h4><cf_get_lang dictionary_id='57425.Uyarı'></h4>
                                        </div>
                                        <div class="col col-11 col-xs-12 warningContent">
                                            <ul>
                                                <cfif licenseVerified eq false>
                                                    <cfif get_license_information.recordcount and len(get_license_information.WORKCUBE_ID)><!--- Lisans bilgileri varsa ve lisans numarası doluysa  --->
                                                        <li><cf_get_lang dictionary_id="43931.Workcube lisans süreniz sona erdi">.</li>
                                                        <li><cf_get_lang dictionary_id="43945.Satın al butonuna tıklayarak lisans süresini uzatabilir ve ardından yükseltme işlemine devam edebilirsiniz">.</li>
                                                    <cfelse>
                                                        <li><cf_get_lang dictionary_id="61217.Workcube uygulama bilgileriniz doldurulmamış">.</li>
                                                        <li><a href = "javascript://" onclick = "window.opener.open('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.workcube_license','_blank')"><cf_get_lang dictionary_id="61218.Workcube uygulama bilgilerinizi doldurmak için tıklayın">.</a></li>
                                                    </cfif>
                                                <cfelse>
                                                    <li><cf_get_lang dictionary_id="43946.Sürümü yükselt butonuna tıkladığınızda Workcube bakım moduna geçecek"></li>
                                                    <li><cf_get_lang dictionary_id="50273.Sistemde aktif olan kullanıcı sayısı"> : <strong><cfoutput>#online_count.recordcount#</cfoutput></strong></li>
                                                    <li><cf_get_lang dictionary_id="50274.Tüm kullanıcıların oturumları sonlandırılacak">!</li>
                                                </cfif>
                                            </ul>
                                        </div>
                                    </div>
                                </cf_box_elements>
                                <cfif licenseVerified>
                                    <cfform name="form_upgrade_version" method="post" action="#request.self#?fuseaction=objects.popup_upgrade_workcube&upgrademode=#attributes.upgrademode#&type=checkoutRelease&mode=#attributes.mode#&systemmode=#attributes.systemmode#" type="formControl">
                                        <cfif attributes.systemmode eq 'production'>
                                            <input type="hidden" id="release_no" name="release_no" value="<cfoutput>#service_upgrade_notes.RELEASE[1].release#</cfoutput>">
                                            <input type="hidden" id="release_date" name="release_date" value="<cfoutput>#dateformat(service_upgrade_notes.RELEASE[1].note_date,'yyyy-mm-dd H:m:s')#</cfoutput>">
                                        <cfelse>
                                            <input type="hidden" id="release_no" name="release_no" value="<cfoutput>#get_params.workcube_version#</cfoutput>">
                                            <input type="hidden" id="release_date" name="release_date" value="<cfoutput>#dateformat(now(),'yyyy-mm-dd H:m:s')#</cfoutput>">
                                        </cfif>
                                        <input type="hidden" id="last_release_date" name="last_release_date" value="<cfoutput>#dateformat(dateadd('d',-360,now()),'yyyy-mm-dd H:m:s')#</cfoutput>">
                                        <cfif attributes.upgrademode eq 'patch' and attributes.systemmode eq 'production'>
                                            <input type="hidden" id="patch_no" name="patch_no" value="<cfoutput>#lastPatch.PATCH_NO#</cfoutput>">
                                            <input type="hidden" id="patch_date" name="patch_date" value="<cfoutput>#dateformat(lastPatch.PATCH_DATE,'yyyy-mm-dd H:m:s')#</cfoutput>">
                                        </cfif>
                                        <cf_box_footer>
                                            <div class="col col-9 col-xs-12">
                                                <label class="container flt-r" id="warning_accept"><cf_get_lang dictionary_id="43924.Uyarıları okudum, devam etmek istiyorum">
                                                    <input type="checkbox" name="warning_accept">
                                                    <span class="checkmark"></span>
                                                </label>
                                            </div>
                                            <div class="col col-3 col-xs-12 mt-2 pdn-r-0">
                                                <input type="submit" class="flt-r ui-wrk-btn ui-wrk-btn-success" name="upgrade_submit" value="<cf_get_lang dictionary_id='43791.Sürüm Yükselt'>" disabled> 
                                            </div>
                                        </cf_box_footer>
                                    </cfform>
                                <cfelse>
                                    <cf_box_footer>
                                        <div class="col col-3 col-xs-12 mt-2 pdn-r-0">
                                            <input type="button" onclick = "window.opener.open('https://www.workcube.com/iletisim','_blank')"  value="<cf_get_lang dictionary_id='34589.satın al'>">
                                        </div>
                                    </cf_box_footer>
                                    <cfmail
                                        to="workcube@workcube.com"
                                        from="#session.ep.company#<#session.ep.company_email#>"
                                        subject="Lisans İhlali"
                                        type="HTML">
                                        #session.ep.COMPANY# <cf_get_lang dictionary_id='63545.isimli firmanın lisans süresi dolmuştur!'>
                                    </cfmail>
                                </cfif>
                            </cf_box>
                        <cfelse>
                            <cfform name="form_upgrade_version" method="post" action="#request.self#?fuseaction=objects.popup_upgrade_workcube&upgrademode=#attributes.upgrademode#&type=changerelease&mode=#attributes.mode#&systemmode=#attributes.systemmode#" type="formControl">
                                <cf_box_elements id="git_information">
                                    <cfoutput>
                                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                                            <div class="form-group" id="item-process_stage">
                                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='63546.Git Username'>*</label>
                                                <div class="col col-8 col-sm-12">
                                                    <input type="text" name="git_username" id="git_username" value="#params.git.git_username#" required/>
                                                </div>                
                                            </div>
                                            <div class="form-group" id="item-process_stage">
                                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='63547.Git Password'>*</label>
                                                <div class="col col-8 col-sm-12">
                                                    <div class="input-group">
                                                        <input type="password" name="git_password" id="git_password" value="#params.git.git_password#" required/>
                                                        <span class="input-group-addon btn_Pointer" title="<cf_get_lang dictionary_id='65265.Bitbucket App Password Al'>" onclick="getAppPassword('git_password', '#service_upgrade_notes.RELEASE[1].release#')"><i class="fa fa-bitbucket"></i></span>
                                                    </div>
                                                </div>                
                                            </div> 
                                        </div>
                                    </cfoutput>
                                </cf_box_elements>
                                <cf_box_footer>
                                    <div class="col col-9 col-xs-12" id="warningMessage"></div>
                                    <div class="col col-3 col-xs-12 mt-2 pdn-r-0">
                                        <input type="submit" class="flt-r ui-wrk-btn ui-wrk-btn-success" name="upgrade_submit" value="Doğrula"> 
                                    </div>
                                </cf_box_footer>
                            </cfform>
                        </cfif> 
                    </div>
                </div>
            <cfelseif attributes.type eq 'getwrolist'>
                <div class="col col-12 col-md-12 col-xs-12 pl-0 pr-0">
                    <div class="col col-12 release_info">
                        <cfinclude template="upgrade_workcube_header.cfm">
                        <div class="before-release col col-12">
                            <cfif attributes.mode eq 2>
                            <p><cf_get_lang dictionary_id = "51002.WRO sorgularının oluşturulduğu tarih aralığı"> : <cfoutput>#dateformat(application.upgradeSystem.last_release_date,dateformat_style)# - #dateformat( (attributes.systemmode eq 'production') ? ( attributes.upgrademode eq 'upgrade' ? application.upgradeSystem.release_date : application.upgradeSystem.patch_date ) : now(),dateformat_style)#</cfoutput></p>
                            </cfif>
                            <p><cf_get_lang dictionary_id = "51003.Tüm WRO sorgularını çalıştırmak için devam butonuna basın">.</p>
                            <p><a href="javascript://" onclick = "location.reload();"><cf_get_lang dictionary_id="51808.Yeniden Kontrol et"></a></p>
                            <div class="col-md-12 mt-3">
                                <p><i class="fa fa-2x fa-bookmark-o"></i> : <cf_get_lang dictionary_id = "52128.Çalıştırmaya hazır"></p> 
                                <p><i class="fa fa-2x fa-bookmark flagTrue"></i> : <cf_get_lang dictionary_id = "52131.Başarılı bir şekilde çalıştırıldı"></p> 
                                <p><i class="fa fa-2x fa-bookmark flagWarning"></i> : <cf_get_lang dictionary_id = "52144.Daha önce başarılı şekilde gerçekleşmiş bir işlem tekrarlandı"></p> 
                                <p><i class="fa fa-2x fa-bookmark flagFalse"></i> : <cf_get_lang dictionary_id = "52151.Çalıştırılamadı"></p>
                            </div>
                        </div>
                    </div>
                    <div class="col col-12 col-md-12 mt-3">
                        <table class="workDevList">
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id='33599.Description'></th>
                                    <th>File Name</th>
                                    <th><cf_get_lang dictionary_id='52748.Status'></th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                            <cfif wroList.recordcount>
                                <cfoutput query="wroList">
                                    <tr>
                                        <td>#DESCRIPTION#</td>
                                        <td>#GetFileFromPath(FILE_NAME)#</td>
                                        <td><i class="fa fa-2x fa-bookmark-o"></i><input type="checkbox" data-type="fileids" name="fileids_#DBUPGRADE_SCRIPT_ID#" id="fileids_#DBUPGRADE_SCRIPT_ID#" data-id="fileids_#currentrow#" value="#DBUPGRADE_SCRIPT_ID#" checked style="display:none;"></td>
                                        <td><i class="fa fa-2x fa-angle-down" onclick="getFileContent(#DBUPGRADE_SCRIPT_ID#,'tr_#DBUPGRADE_SCRIPT_ID#')"></i></td>
                                    </tr>
                                    <tr>
                                        <td style="display:none;" id="tr_#DBUPGRADE_SCRIPT_ID#" colspan="5"></td>
                                    </tr>
                                </cfoutput>
                            <cfelse>
                                <tr><td colspan="5"></td></tr>
                            </cfif>
                            </tbody>
                        </table>
                    </div>
                    <div class="col col-12 formContentFooter mt-3">
                        <cfform name="form_run_wro" id="form_run_wro" method="post" action="#request.self#?fuseaction=objects.popup_upgrade_workcube&upgrademode=#attributes.upgrademode#&systemmode=#attributes.systemmode#&type=getwolang&mode=#attributes.mode#" type="formControl">
                            <input type="hidden" name="file_name">
                            <input type="hidden" name="file_id">
                            <div class="col col-9 col-xs-12" id="warningMessage"></div>
                            <div class="col col-3 col-xs-12">
                                <input type="submit" class="flt-r ui-wrk-btn ui-wrk-btn-success" name="upgrade_submit" value="<cf_get_lang dictionary_id='44097.Devam Et'>">
                            </div>
                        </cfform>
                    </div>
                </div>
            <!--- Uğur Hamurpet: 02/11/2021 dbCompare işlemlerine ihtiyaç kalmadığından dolayı kapatıldı --->
            <!--- <cfelseif attributes.type eq 'dbcompare'>
                <div class="col col-12 col-md-12 col-xs-12 pl-0 pr-0">
                    <div class="col col-12 mt-3 release_info">
                        <cfinclude template="upgrade_workcube_header.cfm">
                        <div class="before-release col col-12">
                            <p><cf_get_lang dictionary_id='Şema karşılaştırma işlemi için Workcubeün güncel veritabanı şema ve tablolarını yüklemeniz gerekiyor!'></p>
                            <p><cf_get_lang dictionary_id='63549.Bu işlem Veritabanınızda aşağıdaki şemaları ve bu şemaların kullanıcı ve tablolarını oluşturur.'>.</p>
                            <p>
                            <ul>
                                <cfoutput>
                                <li>#dsn#_compare</li>
                                <li>#dsn#_compare_product</li>
                                <li>#dsn#_compare_1</li>
                                <li>#dsn#_compare_#year(now())#_1</li>
                                </cfoutput>
                            </ul>
                            </p>
                            <p><cf_get_lang dictionary_id='63550.Güncel veritabanı şemalarını oluşturmaya başlamak için aşağıdaki bilgileri doldurarak Devam Et butonuna tıklayabilirsiniz!'></p>
                            <p><cf_get_lang dictionary_id='63551.Upgrade işlemi tamamlandıktan sonra şemalarınızı karşılaştırmak için :'> ( <i class="catalyst-settings"></i> ) <b><cf_get_lang dictionary_id='29670.Kontrol Paneli'> > System > DEV Tools > SCHEMA COMPARE</b>!</p>
                        </div>
                    </div>
                    <cfform name="form_create_compare_schema" id="form_create_compare_schema" method="post" action="#request.self#?fuseaction=objects.popup_upgrade_workcube&upgrademode=#attributes.upgrademode#&type=dbcompare&process=install&mode=#attributes.mode#" type="formControl">
                        <cfinput type="hidden" name="datasource" value="#dsn#_compare">
                        <div class="col col-12 col-md-12 mt-3">
                            <table class="workDevList">
                                <tbody>
                                    <tr>
                                        <td>Database Username*</td>
                                        <td><input type="text" name="db_username" id="db_username" required/></td>
                                    </tr>
                                    <tr>
                                        <td>Database Password*</td>
                                        <td><input type="password" name="db_password" id="db_password" required/></td>
                                    </tr>
                                    <tr>
                                        <td>CF Admin Password*</td>
                                        <td><input type="password" name="cf_admin_password" id="cf_admin_password" required/></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="col col-12 mt-3" id="compareProcessList">
                            <cfoutput>
                            <table class="workDevList">
                                <tr id="mainProductSchema">
                                    <td>Main and Product Schema</td>
                                    <td>#dsn#_compare, #dsn#_compare_product</td>
                                    <td><i class="fa fa-2x fa-bookmark-o"></i></td>
                                </tr>
                                <tr id="companySchema">
                                    <td>Company Schema</td>
                                    <td>#dsn#_compare_1</td>
                                    <td><i class="fa fa-2x fa-bookmark-o"></i></td>
                                </tr>
                                <tr id="periodSchema">
                                    <td>Period Schema</td>
                                    <td>#dsn#_compare_#year(now())#_1</td>
                                    <td><i class="fa fa-2x fa-bookmark-o"></i></td>
                                </tr>
                            </table>
                            </cfoutput>
                        </div>
                        <div class="col col-12 formContentFooter mt-3">
                            <div class="col col-9 col-xs-12" id="warningMessage"></div>
                            <div class="col col-3 col-xs-12">
                                <input type="submit" class="flt-r ui-wrk-btn ui-wrk-btn-success" value="<cf_get_lang dictionary_id='44097.Devam Et'>">
                            </div>
                        </div>
                    </cfform>
                </div> --->
            <cfelseif attributes.type eq 'getwolang'>
                <div class="col col-12 col-md-12 col-xs-12 pl-0 pr-0">
                    <div class="col col-12 release_info">
                        <cfinclude template="upgrade_workcube_header.cfm">
                        <div class="before-release col col-12">
                            <p><cf_get_lang dictionary_id = "51275.Kontrol edilecek tarih aralığı"> : <cfoutput>#dateformat(application.upgradeSystem.last_release_date,dateformat_style)# - #dateformat( (attributes.systemmode eq 'production') ? ( attributes.upgrademode eq 'upgrade' ? application.upgradeSystem.release_date : application.upgradeSystem.patch_date ) : now(),dateformat_style)#</cfoutput></p>
                            <p><cf_get_lang dictionary_id = "51204.Güncel Solution, Family, Module, Object, Widget ve Dilleri yüklemek için devam et butonuna basın">.</p>
                        </div>
                    </div>
                    <div class="col col-12 mt-3" id="woLangProcessList">
                        <table class="workDevList">
                            <tr>
                                <td>Langs</td>
                                <td><cf_get_lang dictionary_id='63552.Yeni eklenen dilleri yükler'></td>
                                <td><i class="fa fa-2x fa-bookmark-o"></i></td>
                            </tr>
                            <tr>
                                <td>Dictionaries</td>
                                <td>Yeni eklenen sözlük kayıtlarını yükler, güncellenen ve sözlüğünüzde <u><b>is_special</b> olarak işaretlenmemiş</u> sözlük kayıtlarını günceller.</td>
                                <td><i class="fa fa-2x fa-bookmark-o"></i></td>
                            </tr>
                            <tr>
                                <td>Solutions</td>
                                <td><cf_get_lang dictionary_id='63553.Yeni eklenen çözümleri yükler, güncellenenleri günceller.'></td>
                                <td><i class="fa fa-2x fa-bookmark-o"></i></td>
                            </tr>
                            <tr>
                                <td>Families</td>
                                <td><cf_get_lang dictionary_id='63554.Yeni eklenen obje ailelerini yükler, güncellenenleri günceller.'></td>
                                <td><i class="fa fa-2x fa-bookmark-o"></i></td>
                            </tr>
                            <tr>
                                <td>Module</td>
                                <td><cf_get_lang dictionary_id='63555.Yeni eklenen modülleri yükler, güncellenenleri günceller.'></td>
                                <td><i class="fa fa-2x fa-bookmark-o"></i></td>
                            </tr>
                            <tr>
                                <td>Modules</td>
                                <td><cf_get_lang dictionary_id='63688.Yeni eklenen Workcube modüllerini yükler, güncellenenleri günceller.'></td>
                                <td><i class="fa fa-2x fa-bookmark-o"></i></td>
                            </tr>
                            <tr>
                                <td>Objects</td>
                                <td>Yeni eklenen nesneleri (WO) yükler, güncellenen ve WO detayında <u><b>File Path</b> dizini add_options olmayan ve <b>Add-Options Controller File Path</b> dizini boş olanları</u> günceller.</td>
                                <td><i class="fa fa-2x fa-bookmark-o"></i></td>
                            </tr>
                            <tr>
                                <td>Widgets</td>
                                <td><cf_get_lang dictionary_id='63556.Yeni eklenen araçları yükler, güncellenenleri günceller.'></td>
                                <td><i class="fa fa-2x fa-bookmark-o"></i></td>
                            </tr>
                            <tr>
                                <td>WEXs</td>
                                <td><cf_get_lang dictionary_id='63557.Yeni eklenen WEX servislerini yükler, güncellenenleri günceller.'></td>
                                <td><i class="fa fa-2x fa-bookmark-o"></i></td>
                            </tr>
                            <tr>
                                <td>Output Templates</td>
                                <td><cf_get_lang dictionary_id='63558.Yeni eklenen çıktı şablonlarını yükler, güncellenenleri günceller.'></td>
                                <td><i class="fa fa-2x fa-bookmark-o"></i></td>
                            </tr>
                            <tr>
                                <td>Process Templates</td>
                                <td><cf_get_lang dictionary_id='63559.Yeni eklenen işlem şablonlarını yükler, güncellenenleri günceller.'></td>
                                <td><i class="fa fa-2x fa-bookmark-o"></i></td>
                            </tr>
                        </table>
                    </div>
                    <div class="col col-12 formContentFooter mt-3">
                        <cfform name="form_runWoLang" id="form_runWoLang" method="post" type="formControl">
                            <cfinput name="start_date" type="hidden" value="#createodbcdatetime(dateformat(application.upgradeSystem.last_release_date, "yyyy-mm-dd H:m:s"))#" />
                            <cfinput name="finish_date" type="hidden" value="#createodbcdatetime(dateformat( (attributes.systemmode eq 'production') ? (attributes.upgrademode eq 'patch' ? application.upgradeSystem.patch_date : application.upgradeSystem.release_date) : now(), "yyyy-mm-dd H:m:s"))#" />
                            <div class="col col-9 col-xs-12" id="warningMessage"></div>
                            <div class="col col-3 col-xs-12">
                                <input type="submit" class="flt-r ui-wrk-btn ui-wrk-btn-success" name="upgrade_submit" value="<cf_get_lang dictionary_id='44097.Devam Et'>">
                            </div>
                        </cfform>
                    </div>
                </div>
            <cfelseif attributes.type eq 'restartworkcube'>
                <div class="col col-12 col-md-12 col-xs-12 pl-0 pr-0">
                    <div class="col col-12 release_info">
                        <cfinclude template="upgrade_workcube_header.cfm">
                        <div class="col col-12 pdn-l-0 pdn-r-0">
                            <div class="col col-12 col-md-12 mt-3 pdn-l-0 pdn-r-0">
                                <cfoutput>
                                    <div class="col col-12 col-xs-12 mt-3 release_info pdn-r-0">
                                        <h4><cf_get_lang dictionary_id="43922.Sürüm Bilgileriniz"></h4>
                                        <span class="rd_title">#application.upgradeSystem.release_no#</span>
                                        <span class="br_title">#dateformat(application.upgradeSystem.last_release_date,dateformat_style)#</span>
                                    </div>
                                </cfoutput>
                            </div>
                            <div class="col col-12 col-md-12 mt-5 warning">
                                <div class="col col-1 col-xs-12 warningTitle">
                                    <h4><cf_get_lang dictionary_id='57425.Uyarı'></h4>
                                </div>
                                <div class="col col-11 col-xs-12 warningContent">
                                    <ul>
                                        <li><cf_get_lang dictionary_id="43950.Workcube sürümünüz başarıyla güncellendi">.</li>
                                        <li><cf_get_lang dictionary_id='60334.Devam et tuşuna bastığınızda sisteminiz yeniden başlatılacak ve kullanmaya devam edebileceksiniz'></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="col col-12 col-md-12 mt-5">
                                <cfform name="form_upgrade_version" method="post" action="#request.self#?fuseaction=objects.popup_upgrade_workcube&upgrademode=#attributes.upgrademode#&systemmode=#attributes.systemmode#&type=restartedworkcube&mode=#attributes.mode#" type="formControl">
                                    <div class="col col-7 col-xs-12">
                                        <label class="container flt-r" id="warning_accept"><cf_get_lang dictionary_id="43924.Uyarıları okudum, devam etmek istiyorum">
                                            <input type="checkbox" name="warning_accept">
                                            <span class="checkmark"></span>
                                        </label>
                                    </div>
                                    <div class="col col-5 col-xs-12">
                                        <input type="submit" class="flt-r ui-wrk-btn ui-wrk-btn-success" name="upgrade_submit" value="<cf_get_lang dictionary_id='51001.Workcubeü yeniden başlatın'>" disabled> 
                                    </div>
                                </cfform>
                            </div>
                        </div>
                    </div>
                </div>
            <cfelseif url.type eq 'restartedworkcube'>
                <script>
                    window.opener.location.reload();
                    window.close();
                </script>
                <div class="col col-12 release_info">
                    <div class="col col-12" style="margin: 25px; font-size: 16px; color:#17b517;" align="center">
                        <cf_get_lang dictionary_id='63560.Sisteminiz başarıyla güncellendi!'> <br> <cf_get_lang dictionary_id='63561.Çalışmaya devam etmek için lütfen aşağıdaki butona tıklayın!'>
                    </div>
                    <div class="col col-12" style="margin: 25px;" align="center">
                        <button type="button" class="ui-wrk-btn ui-wrk-btn-success" style="float:none !important;" onclick="try{window.opener.location.reload(); window.close();}catch{window.close();}"><cf_get_lang dictionary_id='63562.Çalışmaya Devam Et'></button>
                    <div>
                </div>
            </cfif>

        <cfelse>
            <div class="col col-12 col-md-12 col-xs-12 pl-0 pr-0">
                <div class="col col-12 release_info">
                    <div class="before-release col col-12">
                        <cfoutput>
                            <h4>#upgradeErrorControl.errorMessageTitle#</h4>
                            <p>#upgradeErrorControl.errorMessage#</p>
                            <p>#upgradeErrorControl.exception#</p>
                            <cfif len(upgradeErrorControl.errorAfterRedirectUrl)>
                                <p><a href="#upgradeErrorControl.errorAfterRedirectUrl#"><cf_get_lang dictionary_id="51928.Yeniden deneyin"></a></p>
                            </cfif>
                        </cfoutput>
                    </div>
                </div>
            </div>
        </cfif>
    </div>
</cf_box>
<style>.fa-angle-down{cursor:pointer;}.activeTr{background:#f5f5f5;}.flagTrue{color:green;}.flagFalse{color:red;}.flagWarning{color:orange;}</style>
<link rel="stylesheet" href="/css/assets/template/codemirror/codemirror.css">
<script type="text/javascript" src="/JS/codemirror/codemirror.js"></script>
<script type="text/javascript" src="/JS/codemirror/simplescrollbars.js"></script>
<script type="text/javascript" src="/JS/codemirror/sql.js"></script>
<script>
    (function() {
        function toJSONString( form ) {
            var obj = {};
            var elements = form.querySelectorAll( "input,select" );
            for( var i = 0; i < elements.length-1;i=i+2 ) {
               var element = elements[i];
                var name = element.name;
                var value = element.value;
                value = value.replace(/"/g,'');
                value = value.replace(/'/g,'');
                value = value.replace(/</g,'');
                value = value.replace(/>/g,'');
                value = value.replace(/`/g,'');
                value = value.replace(/ /g,'');
                var element2 = elements[i+1];
                var name2 = element2.name;
                var value2 = element2.value;
                value2 = value2.replace(/"/g,'');
                value2 = value2.replace(/'/g,'');
                value2 = value2.replace(/</g,'');
                value2 = value2.replace(/>/g,'');
                value2 = value2.replace(/`/g,'');
                if( value ) {
                    obj[value] = value2;
                }  
            }
            return JSON.stringify( obj );
        }
        document.addEventListener( "DOMContentLoaded", function() {
            if( document.getElementById( "form_params_settings" ) != undefined ){
                var form = document.getElementById( "form_params_settings" );
                form.addEventListener( "submit", function( e ) {
                    if(confirm('<cf_get_lang dictionary_id='54693.Tüm parametre ayarlarınızın doğruluğundan eminseniz tamam tuşuna basarak ilerleyebilirsiniz'>!')){
                        e.preventDefault();
                        json = toJSONString( this );
                        $.ajax({
                            type:'POST',
                            url:'V16/settings/cfc/params_settings.cfc?method=UPDATE_PARAMS_COL',
                            data: { json : json },
                            success: function ( response ) {
                                if( response ){
                                    <cfif attributes.mode eq 1>
                                        var paramActionLink = '<cfoutput>#request.self#?fuseaction=objects.popup_upgrade_workcube&upgrademode=#attributes.upgrademode#&systemmode=#attributes.systemmode#&type=cfgitdifflist&mode=#attributes.mode#</cfoutput>';
                                    <cfelse>
                                        var paramActionLink = '<cfoutput>#request.self#?fuseaction=objects.popup_upgrade_workcube&upgrademode=#attributes.upgrademode#&systemmode=#attributes.systemmode#&type=getwrolist&mode=#attributes.mode#</cfoutput>';
                                    </cfif>
                                    location.href = paramActionLink;
                                }else alert("<cf_get_lang dictionary_id='54694.Parametreleriniz kaydedilirken bir hata oluştu'>");
                            },
                            error: function (msg)
                            {
                                alert("<cf_get_lang dictionary_id='52126.Bir hata oluştu'>!");
                                return false;
                            }
                        });
                    }else return false;
                }, false);
            }
        });
    })();
    $(function(){
        $("input[name=warning_accept]").click(function(){
            if($(this).is(":checked")) $("input[name=upgrade_submit]").prop("disabled",false);
            else $("input[name=upgrade_submit]").prop("disabled",true);
        });

        $("form[type=formControl]").submit(function(){
            
            var submitButton = $(this).find("input[type=submit]");
            submitButton.prop("disabled",true).after('<span class="loading flt-r"><?xml version="1.0" encoding="utf-8"?><svg width="32px" height="32px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" preserveAspectRatio="xMidYMid" class="uil-ring-alt"><rect x="0" y="0" width="100" height="100" fill="none" class="bk"></rect><circle cx="50" cy="50" r="40" stroke="rgba(255,255,255,0)" fill="none" stroke-width="10" stroke-linecap="round"></circle><circle cx="50" cy="50" r="40" stroke="#ff8a00" fill="none" stroke-width="6" stroke-linecap="round"><animate attributeName="stroke-dashoffset" dur="2s" repeatCount="indefinite" from="0" to="502"></animate><animate attributeName="stroke-dasharray" dur="2s" repeatCount="indefinite" values="150.6 100.4;1 250;150.6 100.4"></animate></circle></svg></span>');
        
        });
    });
    function add_row() {
        var table = $("table#paramsettings");
        var elements = $(table).find("input[type=text]");
        var currentrow = elements.length/2;
        var row = '<tr id="param_'+currentrow+'"><td></td><td><div class="form-group"><input type="text" style="width:100%;" placeholder="<cf_get_lang dictionary_id="48413.sistem parametre adı">" name="name_row'+currentrow+'" id="name_row'+currentrow+'"></div></td><td><div class="form-group"><input type="text" style="width:100%;" placeholder="<cf_get_lang dictionary_id="58660.değeri">" name="value_row'+currentrow+'" id="value_row'+currentrow+'"></div></td><td width="20" class="text-center"><a href = "javascript://" onclick="del_row(\'param_'+currentrow+'\',0);return false;"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td></tr>';
        $(table).find("tbody").prepend(row);
        return false;
    }
    function del_row(currentrow, required) {
        if( !required ){
            var confirmed = confirm('<cfoutput>#getLang("assetcare",733,"Silmek istediğinize emin misiniz")#</cfoutput>?');
            if(confirmed) document.getElementById(currentrow).remove();
        }else alert("<cf_get_lang dictionary_id='54691.Zorunlu bir alanı kaldıramazsınız'>!");
    }
    function getAppPassword(el, release_no){
        var data = new FormData();
        data.append('release_no', release_no);
        AjaxControlPostDataJson( "V16/settings/cfc/params_settings.cfc?method=GET_BITBUCKET_APP_PASSWORD", data, function(response){
            if(response.STATUS) $("#"+el+"").val(response.MESSAGE);
            else alert(response.MESSAGE);
        });
    }
    function getwoLang( serviceName, divName ) {
        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.wo_lang_list&start_date=#application.upgradeSystem.last_release_date#&finish_date=#(attributes.upgrademode eq "patch" and isdefined("application.upgradeSystem.patch_date") ? application.upgradeSystem.patch_date : application.upgradeSystem.release_date)#</cfoutput>&serviceName='+serviceName, divName);
    }
    function getFileContent(file_id, showResponseid) {
        if( $("#"+showResponseid+"").hasClass("activeTr") ) 
            $("#"+showResponseid+"").hide().removeClass("activeTr");
        else{
            $("#"+showResponseid+"").show().addClass("activeTr");
            AjaxPageLoad('V16/settings/cfc/wroControl.cfc?method=getFileContent&is_work=0&release_date=<cfoutput>#application.upgradeSystem.last_release_date#</cfoutput>&new_release_date=<cfoutput>#(attributes.upgrademode eq "patch" and isdefined("application.upgradeSystem.patch_date") ? application.upgradeSystem.patch_date : application.upgradeSystem.release_date)#</cfoutput>&fileid='+file_id, showResponseid);
            setTimeout(function(){
                var content = document.getElementById("content_"+file_id);
                var editor = CodeMirror.fromTextArea(content, {
                    mode: "text/x-sql",
                    lineNumbers: true
                });
            }, 1000);
        }
    }
    function sendRequest( fileid, callback ) {
        
        $("input#fileids_"+ fileid +"").parent('td').find('i').removeClass('fa-bookmark-o').addClass('fa-cog fa-spin font-yellow-casablanca');
        $.ajax({
            url: "V16/settings/cfc/wroControl.cfc?method=execute_script_buffer",
            dataType: "json",
            method: "post",
            data: { fileid : fileid },
            success: callback
        });

    }

    var errorCounter = successCounter = warningCounter = 0;
    var runWro = false;
    var wroActionLink = "";

    function startRequest( fileid, checkboxid ){

        sendRequest( fileid, function( response ){
            
            var flag = $("input#fileids_"+response.FILEID+"").parent('td').find('i');
            if( response.STATUS ){
                $(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagTrue');
                successCounter++;
            }
            else{

                $(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark').attr({ 'onclick' : 'showMistakeMessage('+response.FILEID+')' }).css({ 'cursor' : 'pointer' });
                if(
                    (response.ERRORMESSAGE == "") ||
                    (response.ERRORMESSAGE.queryError == '') ||
                    (response.ERRORMESSAGE.queryError.includes('already exists')) ||
                    (response.ERRORMESSAGE.queryError.includes('There is already an object named')) ||
                    (response.ERRORMESSAGE.queryError.includes('Column names in each table must be unique'))
                ){
                    $(flag).addClass('flagWarning');
                    warningCounter++;
                }else{
                    $(flag).addClass('flagFalse');
                    errorCounter++;
                }

                if( response.ERRORMESSAGE.queryError != undefined ){

                    $("input#fileids_"+response.FILEID+"").parents('tr').after(
                        $('<tr>').attr({ 'id' : 'msgid_' + response.FILEID + '' }).append(
                            $('<td>').attr({ 'colspan' : 5 }).append(
                                $('<table>').addClass('WorkDevList').css({ 'width' : '100%' }).append(
                                    $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Type'), $('<td>').text( response.ERRORMESSAGE.Type )),
                                    $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Message'), $('<td>').text( response.ERRORMESSAGE.Message )),
                                    $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('DataSource'), $('<td>').text( response.ERRORMESSAGE.DataSource )),
                                    $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('queryError'), $('<td>').text( response.ERRORMESSAGE.queryError )),
                                    $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Sql'), $('<td>').text( response.ERRORMESSAGE.Sql ))
                                )
                            )
                        ).hide()
                    );

                }

            }

            checkboxid += 1;
            if( $("input[data-id = fileids_"+ checkboxid +"]").length > 0 ){
                var nextfileid = $("input[data-id = fileids_"+ checkboxid +"]").val();
                startRequest( nextfileid, checkboxid );
            }else{
                
                wroActionLink = '<cfoutput>#request.self#?fuseaction=objects.popup_upgrade_workcube&upgrademode=#attributes.upgrademode#&systemmode=#attributes.systemmode#&type=#attributes.systemmode eq 'free' ? 'restartworkcube' : 'getwolang'#&mode=#attributes.mode#</cfoutput>';
                
                runWro = true;

                $("span.loading").remove();
                $("input[name = upgrade_submit]").prop("disabled",false);

                Swal.fire({
                    title: '<cf_get_lang dictionary_id='54688.Tüm WRO dosyaları çalıştırıldı'>!',
                    html:   '<table class="workDevList">'+
                            '<tr><td width="50"><b><cf_get_lang dictionary_id='55387.Başarılı'></b></td><td>'+successCounter+'</td></tr>'+
                            '<tr><td width="50"><b><cf_get_lang dictionary_id='54686.Hatalı'></b></td><td>'+errorCounter+'</td></tr>'+
                            '<tr><td width="50"><b><cf_get_lang dictionary_id='57425.Uyarı'></b></td><td>'+warningCounter+'</td></tr>'+
                            '</table>',
                    type: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#1fbb39',
                    cancelButtonColor: '#3085d6',
                    confirmButtonText: '<cf_get_lang dictionary_id='44097.Devam Et'>',
                    cancelButtonText: '<cf_get_lang dictionary_id='54685.Sonuçları İncele'>',
                    closeOnConfirm: false,
                    allowOutsideClick:false
                }).then((result) => {
                    if (result.value) {
                        location.href = wroActionLink;
                    }
                })
                
            }

        } );

    }
    

    $("form[name = form_run_wro]").submit(function(){

        <cfif attributes.type eq 'getwrolist' and wroList.recordcount>
            if( !runWro ){
                var fileid = $("input[data-id = fileids_1]").val();
                startRequest( fileid, 1 );
            }else location.href = wroActionLink;
        <cfelse>
            location.href = '<cfoutput>#request.self#?fuseaction=objects.popup_upgrade_workcube&upgrademode=#attributes.upgrademode#&systemmode=#attributes.systemmode#&type=#attributes.systemmode eq 'free' ? 'restartworkcube' : 'getwolang'#&mode=#attributes.mode#</cfoutput>';
        </cfif>
        return false;

    });

    function showMistakeMessage( fileid ) {
        if( $('tr#msgid_'+fileid+'').hasClass("activeTr") ) 
            $('tr#msgid_'+fileid+'').hide().removeClass("activeTr");
        else $('tr#msgid_'+fileid+'').show().addClass("activeTr");
    }

    /* function startAjaxRequest( processes, row ) {
        
        var flag = $("div#compareProcessList table.workDevList tr#"+processes[row][1].elementid+" td > i");
        $(flag).removeClass('fa-bookmark-o').addClass('fa-cog fa-spin font-yellow-casablanca');
        $.ajax({
            url: "cfc/upgrade_install_schema.cfc?method=" + processes[row][1].method,
            dataType: "json",
            method: "post",
            data: processes[row][1].data,
            success: function( response ) {
                if( response.STATUS ){
                    $(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagTrue');
                    row += 1;
                    if( processes[row] != undefined ) startAjaxRequest( processes, row );
                    else location.href = '<cfoutput>#request.self#?fuseaction=objects.popup_upgrade_workcube&upgrademode=#attributes.upgrademode#&type=getwolang&mode=#attributes.mode#</cfoutput>';
                }else{
                    $(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showCompareMistakeMessage("'+processes[row][0]+'")' }).css({ 'cursor' : 'pointer' });
                    
                    $('tr#compare_'+processes[row][0]+'').remove();

                    $(flag).parents('tr').after(
                        $('<tr>').attr({ 'id' : 'compare_' + processes[row][0] + '' }).append(
                            $('<td>').attr({ 'colspan' : 3 }).append(
                                $('<table>').addClass('WorkDevList').css({ 'width' : '100%' }).append(
                                    $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Type'), $('<td>').text( response.ERRORMESSAGE.Type )),
                                    $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Message'), $('<td>').text( response.ERRORMESSAGE.Message )),
                                    $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Detail'), $('<td>').text( response.ERRORMESSAGE.Detail ))
                                )
                            )
                        ).hide()
                    );

                    $("span.loading").remove();
                    $("input[name = upgrade_submit]").prop("disabled",false);

                }
            }
        });

    }
    
    $("form[name = form_create_compare_schema]").submit(function(){

        $("div#compareProcessList table.workDevList tr td > i").removeClass("fa-bookmark flagFalse").addClass("fa-bookmark-o");

        var form = $(this).serialize();
        var process = {
            mainProduct : { method : "createMainProductSchema", elementid : "mainProductSchema" , data : form },
            company : { method : "createCompanySchema", elementid : "companySchema" , data : form },
            period : { method : "createPeriodSchema", elementid : "periodSchema" , data : form }
        }

        var processes = new Array();
        for( var i in process ) processes.push([i, process[i]]);

        startAjaxRequest( processes, 0 );

        return false;

    });

    function showCompareMistakeMessage( cmpName ) {
        if( $('tr#compare_'+cmpName+'').hasClass("activeTr") ) 
            $('tr#compare_'+cmpName+'').hide().removeClass("activeTr");
        else $('tr#compare_'+cmpName+'').show().addClass("activeTr");
    } */

    /* RunWoLang */

    function startWoLangAjaxRequest( processes, row ) {
        
        var flag = $("div#woLangProcessList table.workDevList tr:eq("+row+") td > i");
        $(flag).removeClass('fa-bookmark-o').addClass('fa-cog fa-spin font-yellow-casablanca');
        var start_date = $("form[name = form_runWoLang] input[name = start_date]").val();
        var finish_date = $("form[name = form_runWoLang] input[name = finish_date]").val();
        $.ajax({
            url: "cfc/upgrade_workcube_woLang.cfc?method=runWoLang",
            dataType: "json",
            method: "post",
            data: { functionName : processes[row], start_date : start_date, finish_date : finish_date },
            success: function( response ) {
                if( response.status ){
                    $(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagTrue');
                    row += 1;
                    if( processes[row] != undefined ) startWoLangAjaxRequest( processes, row );
                    else location.href = '<cfoutput>#request.self#?fuseaction=objects.popup_upgrade_workcube&upgrademode=#attributes.upgrademode#&systemmode=#attributes.systemmode#&type=restartworkcube&mode=#attributes.mode#</cfoutput>';
                }else{
                    $(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showWoLangMistakeMessage('+row+')' }).css({ 'cursor' : 'pointer' });
                    
                    $('tr#woLang_'+row+'').remove();

                    $(flag).parents('tr').after(
                        $('<tr>').attr({ 'id' : 'woLang_' + row + '' }).append(
                            $('<td>').attr({ 'colspan' : 3 }).append(
                                $('<table>').addClass('WorkDevList').css({ 'width' : '100%' }).append(
                                    $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Type'), $('<td>').text( response.error.type )),
                                    $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Message'), $('<td>').text( response.error.message )),
                                    $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Detail'), $('<td>').text( response.error.detail ))
                                )
                            )
                        ).hide()
                    );

                    if( response.error.type == 'database' ){
                        $("#woLang_" + row + " table tr:last-child").after(
                            $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Sql'), $('<td>').text( response.error.sql )),
                            $('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Queryerror'), $('<td>').text( response.error.queryerror ))
                        )
                    }

                    $("span.loading").remove();
                    $("input[name = upgrade_submit]").prop("disabled",false);

                }
            }
        });

    }

    $("form[name = form_runWoLang]").submit(function(){

        $("div#woLangProcessList table.workDevList tr td > i").removeClass("fa-bookmark flagFalse").addClass("fa-bookmark-o");

        var processes = [ 
            "getNewLangs", 
            "getNewLanguages,getUpdatedLanguages", 
            "getNewSolution,getUpdatedSolution", 
            "getNewFamily,getUpdatedFamily", 
            "getNewModule,getUpdatedModule", 
            "getNewModules,getUpdatedModules", 
            "getNewWO,getUpdatedWO", 
            "getNewWidget,getUpdatedWidget",
            "getNewWEX,getUpdatedWEX",
            "getNewOutputTemplates,getUpdatedOutputTemplates",
            "getNewProcessTemplates,getUpdatedProcessTemplates"
        ];

        startWoLangAjaxRequest( processes, 0 );

        return false;

    });

    function showWoLangMistakeMessage( index ) {
        if( $('tr#woLang_'+index+'').hasClass("activeTr") ) 
            $('tr#woLang_'+index+'').hide().removeClass("activeTr");
        else $('tr#woLang_'+index+'').show().addClass("activeTr");
    }

    /* RunWoLang */

</script>
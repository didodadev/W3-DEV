<!---<cfif isdefined('session.pp.userid')>--->
    <cfparam name="attributes.finance_type" default="1">
    <cfif attributes.finance_type eq 1 or attributes.finance_type eq 3>
        <cfquery name="Doviz" datasource="#DSN#">
            SELECT 
                CASE 
                    WHEN strSembol = 'SUSD' THEN 1
                    WHEN strSembol = 'SEUR' THEN 2
                    WHEN strSembol = 'SGBP' THEN 3
                    WHEN strSembol = 'SJPY' THEN 4
                    WHEN strSembol = 'SCHF' THEN 5
                    WHEN strSembol = 'SDKK' THEN 6
                END AS SIRA,
                strSembol,
                dblAlis,
                dblSatis,
                dblOncekiKapanis 
            FROM 
                FOREKS_Serbest 
            WHERE 
                strSembol IN('SUSD','SEUR','SGBP','SJPY','SCHF','SDKK')
            ORDER BY 
            	SIRA
        </cfquery>
    </cfif>
    <cfif attributes.finance_type eq 1 or attributes.finance_type eq 2>
        <cfquery name="GET_ALL_HISSE" datasource="#DSN#">
            SELECT strKod,dblSon,dblEnIyiAlis,dblEnIyiSatis,dblToplamHacim1,dblYuzdeDegisimGunluk dblYuzdeDegisim,dblGunEnDusuk,dblGunEnYuksek,dblOncekiSon,strSaat FROM FOREKS_ImkbHisse WHERE strSeri NOT IN('v','c')
        </cfquery>
        <cfquery name="HISSE_EN_COK_ARTAN" dbtype="query">
            SELECT strKod,dblSon,dblOncekiSon,dblYuzdeDegisim,strSaat FROM GET_ALL_HISSE order by dblYuzdeDegisim desc
        </cfquery>
    </cfif>
    <cfif attributes.finance_type eq 1 or attributes.finance_type eq 4>
        <cfquery name="EkonomikTakvim" datasource="#dsn#">
            SELECT 
            	* 
            FROM 
            <cfif session_base.language eq 'tr'>
	            FOREKS_EkonomikTakvim
            <cfelse>
    	       	FOREKS_EkonomikTakvim_ENG
            </cfif>
            ORDER BY IMPORTANCE DESC,date DESC,TSI DESC
        </cfquery>
    </cfif>
    <cfif attributes.finance_type eq 1 or attributes.finance_type eq 5>
        <cfquery name="GET_EMTIA" datasource="#dsn#">
            SELECT
                CASE 
                    WHEN strSembol = 'COT_EGESTD1' THEN 1 
                    WHEN strSembol = 'COT_EGESTDB1' THEN 2
                    WHEN strSembol = 'COT_EGESTDB2' THEN 3 
                    WHEN strSembol = 'XAU/USD' THEN 4 
                    WHEN strSembol = 'XAU/EUR' THEN 5 
                    WHEN strSembol = 'XAG/USD' THEN 6 
                    ELSE 7
                END AS SIRA,	
                dtmTarih,
                strSembol, 
                strAciklama, 
                dblSon, 
                dblAlis, 
                dblSatis, 
                dblEnDusuk, 
                dblEnYuksek 
            FROM 
                FOREKS_Emtia
            ORDER BY 
                SIRA    
        </cfquery>
    </cfif>
    <cfif attributes.finance_type eq 1 or attributes.finance_type eq 6>
        <cfquery name="GET_TAHVIL" datasource="#DSN#">
            SELECT
                dtmTarih, 
                strValor, 
                strMAT, 
                strID, 
                dblAV, 
                dblSY, 
                dblCY, 
                dblTV 
            FROM 
                FOREKS_Tahvil
            ORDER BY
            	dblTV DESC    
        </cfquery>
    </cfif>
    <link rel="stylesheet" type="text/css" media="screen" href="../../documents/templates/worknet/css/finans.css">
    <div class="stf_menu">
        <ul>
            <cfoutput>
            <li <cfif attributes.finance_type eq 1>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=1"><cf_get_lang no='275.Finans Anasayfa'></a></li>
            <li <cfif attributes.finance_type eq 2>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2"><cf_get_lang no='24.Borsa'></a></li>
            <li <cfif attributes.finance_type eq 3>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=3"><cf_get_lang_main no='265.Döviz'></a></li>
            <li <cfif attributes.finance_type eq 4>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=4"><cf_get_lang no='61.Ekonomik Takvim'></a></li>
            <li <cfif attributes.finance_type eq 5>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=5"><cf_get_lang no='240.EMTİA'></a></li>
            <li <cfif attributes.finance_type eq 6>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=6"><cf_get_lang no='243.Tahvil Repo'></a></li>
            <li <cfif attributes.finance_type eq 7>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=7"><cf_get_lang no='276.VOB'></a></li>
            <li style="margin-right:0px;" <cfif attributes.finance_type eq 8>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=8"><cf_get_lang no='280.Haberler'></a></li>
            </cfoutput>
        </ul>
    </div>
    <cfif attributes.finance_type eq 1>
       
        <cfquery name="VOB" datasource="#dsn#">
            SELECT TOP 6 strSozlesme,dblSon,dblAcilis FROM FOREKS_Vob ORDER BY dblGunToplamIslemMiktari desc
        </cfquery>
        <div class="stf_anasayfa">
            <div class="stf_kutu_1">
                <div class="stf_kutu_11">
                    <div class="stf_kutu_111"><cf_get_lang no='24.Borsa'></div>
                    <div class="stf_kutu_112">
                    <cfoutput>
                        <a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=1"><img src="../documents/templates/worknet/tasarim/stf_icon_1.png"  height="16" alt="İcon" /></a>
                        <!--- <a href=""><img src="../documents/templates/worknet/tasarim/stf_icon_2.png"  height="16" alt="İcon" /></a> --->
                        <a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2"><img src="../documents/templates/worknet/tasarim/stf_icon_3.png"  height="16" alt="İcon" /></a>
                    </cfoutput>    
                    </div>
                </div>
                <div class="stf_kutu_12">
                    <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="FFFFFF">
                        <tr class="satir_0">
                            <td width="25%"><cf_get_lang no='2.Hisse'></td>
                            <td width="25%"><cf_get_lang_main no='672.Fiyat'></td>
                            <td width="25%">%</td>
                            <td width="25%"><cf_get_lang_main no='79.Saat'></td>
                        </tr>
						<cfoutput query="HISSE_EN_COK_ARTAN" maxrows="6">
                            <tr class="satir_1">
                                <td>#strKod#</td>
                                <td style="text-align:right;">#tlformat(dblSon)#</td>
                                <td>
                                    <p style="float:left;text-align:right;width:40px">#wrk_round(dblYuzdeDegisim)#</p>
                                    <p style="float:right;"><img src="../documents/templates/worknet/tasarim/<cfif dblYuzdeDegisim lt 0 >stf_icon_5.png<cfelse>stf_icon_4.png</cfif>" width="16" height="16" alt="Yukarı" /></p>
                                </td>
                                <td style="text-align:right;">#left(strSaat,2)#:#mid(strSaat,3,2)#:#right(strSaat,2)#</td>
                            </tr>
                        </cfoutput>
                    </table>
                </div>
            </div>
            <div class="stf_kutu_1">
        
                <div class="stf_kutu_11">
                    <div class="stf_kutu_111"><cf_get_lang no='279.Döviz - Serbest Piyasa'></div>
                    <div class="stf_kutu_112">
                        <cfoutput>
                            <a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=1"><img src="../documents/templates/worknet/tasarim/stf_icon_1.png"  height="16" alt="İcon" /></a>
                            <!--- <a href=""><img src="../documents/templates/worknet/tasarim/stf_icon_2.png" height="16" alt="İcon" /></a> --->
                            <a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=3"><img src="../documents/templates/worknet/tasarim/stf_icon_3.png"  height="16" alt="İcon" /></a>
                        </cfoutput>
                    </div>
                </div>
                <div class="stf_kutu_12">
                    <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="FFFFFF">
                        <tr class="satir_0">
                            <td width="25%"><cf_get_lang_main no='265.Döviz'></td>
                            <td width="25%"><cf_get_lang_main no='764.Alış'></td>
                            <td width="25%"><cf_get_lang_main no='36.Satış'></td>
                            <td width="25%">%</td>
                        </tr>
						<cfoutput query="Doviz">
							<cfif session_base.language eq 'tr'>
                                <tr class="satir_2">
                                    <cfswitch expression = "#strSembol#">
                                        <cfcase value="SUSD"><td>Dolar</td></cfcase>
                                        <cfcase value="SEUR"><td>Euro</td></cfcase>
                                        <cfcase value="SGBP"><td>Sterlin</td></cfcase>
                                        <cfcase value="SJPY"><td>J.Yeni</td></cfcase>
                                        <cfcase value="SCHF"><td>İ.Frangi</td></cfcase>
                                        <cfcase value="SDKK"><td>D.Kronu</td></cfcase>
                                    </cfswitch>
                                    <td style="text-align:right;">#tlformat(dblAlis,4)#</td>
                                    <td style="text-align:right;">#tlformat(dblSatis,4)#</td>
                                    <td>
                                        <cfset degisim = wrk_round(((dblAlis-dblOncekiKapanis)/dblOncekiKapanis)*100)>
                                        <p style="float:left; text-align:right ;width:40px">#degisim#</p>
                                        <p style="float:right;"><img src="../documents/templates/worknet/tasarim/<cfif degisim lt 0 >stf_icon_5.png<cfelse>stf_icon_4.png</cfif>" width="16" height="16" alt="Yukarı" /></p>
                                    </td>
                                </tr>
                            <cfelse>
                                <tr class="satir_2">
                                    <td>#replace(strSembol,'S','')#</td>
                                    <td style="text-align:right;">#tlformat(dblAlis,4)#</td>
                                    <td style="text-align:right;">#tlformat(dblSatis,4)#</td>
                                    <td style="text-align:right;">
                                        <cfset degisim = wrk_round(((dblAlis-dblOncekiKapanis)/dblOncekiKapanis)*100)>
                                        <p style="float:left; text-align:right ;width:40px">#degisim#</p>
                                        <p style="float:right;"><img src="../documents/templates/worknet/tasarim/<cfif degisim lt 0 >stf_icon_5.png<cfelse>stf_icon_4.png</cfif>" width="16" height="16" alt="Yukarı" /></p>
                                    </td>
                                </tr>
                            </cfif>
						</cfoutput>
                    </table>
                </div>
            </div>
            <div class="stf_kutu_1" style="margin-right:0px;">
                <div class="stf_kutu_11">
                    <div class="stf_kutu_111"><cf_get_lang no='61.Ekonomik Takvim'></div>
                    <div class="stf_kutu_112">
                        <cfoutput>
                            <a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=1"><img src="../documents/templates/worknet/tasarim/stf_icon_1.png"  height="16" alt="İcon" /></a>
                            <!--- <a href=""><img src="../documents/templates/worknet/tasarim/stf_icon_2.png"  height="16" alt="İcon" /></a> --->
                            <a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=4"><img src="../documents/templates/worknet/tasarim/stf_icon_3.png"  height="16" alt="İcon" /></a>
                        </cfoutput>
                    </div>
                </div>
                <div class="stf_kutu_12">
                    <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="FFFFFF">
                        <tr class="satir_0">
                            <td width="25%"><cf_get_lang_main no='807.Ülke'></td>
                            <td width="36%"><cf_get_lang no='103.Gösterge'></td>
                            <td width="20%"><cf_get_lang no='141.Değer'></td>
                            <td width="17%"><cf_get_lang no='205.Önem'></td>
                    	</tr>
                    <cfoutput query="EkonomikTakvim" maxrows="6">
                        <tr class="satir_1">
                            <td>#COUNTRY#</td>
                            <td title="#eventname#"><cfif len(eventname) gt 10>#left(eventname,10)#...<cfelse>#eventname#</cfif></td>
                            <td style="text-align:right;">#actual#</td>
                            <td style="text-align:center;"><cfloop from="1" to="#importance#" index="k"><img src="../documents/templates/worknet/tasarim/stf_icon_14.png" width="11px" height="11px" alt="5" /></cfloop></td>
                        </tr>
                    </cfoutput>
                    </table>
                </div>
            </div>
            <div class="stf_kutu_1">
                <div class="stf_kutu_11">
                    <div class="stf_kutu_111"><cf_get_lang no='240.EMTİA'></div>
                    <div class="stf_kutu_112">
                        <cfoutput>
                            <a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=1"><img src="../documents/templates/worknet/tasarim/stf_icon_1.png"  height="16" alt="İcon" /></a>
                            <!--- <a href=""><img src="../documents/templates/worknet/tasarim/stf_icon_2.png"  height="16" alt="İcon" /></a> --->
                            <a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=5"><img src="../documents/templates/worknet/tasarim/stf_icon_3.png"  height="16" alt="İcon" /></a>
                        </cfoutput>
                    </div>
                </div>
                <div class="stf_kutu_12">
                    <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="FFFFFF">
                        <tr class="satir_0">
                            <td width="40%"><cf_get_lang no='2.Hisse'></td>
                            <td width="20%"><cf_get_lang_main no='672.Fiyat'></td>
                            <td width="20%"><cf_get_lang_main no='1171.Fark'></td>
                            <td width="15%">%</td>
                        </tr>
                        <cfoutput query="GET_EMTIA" maxrows="6">
                        <tr class="satir_1">
							<cfif session_base.language eq 'tr'>
                                <td title="#strAciklama#">#left(replace(strAciklama,'İzmir Tic. Borsası ',''),13)#..</td>
                            <cfelse>
                                <td>#strSembol#</td>    
                            </cfif>
                            <td style="text-align:right;">#tlformat(dblSatis)#</td>
                            <td style="text-align:right;">#tlformat(dblSon-dblSatis)#</td>
                            <cfset degisim = wrk_round(((dblSatis-dblSon)/dblSon)*100)>
                            <td style="text-align:right;">#degisim#</td>
                        </tr>
                      </cfoutput>
                    </table>
                </div>
            </div>
            <div class="stf_kutu_1">
                <div class="stf_kutu_11">
                    <div class="stf_kutu_111"><cf_get_lang no='243.Tahvil Repo'></div>
                    <div class="stf_kutu_112">
                        <cfoutput>
                            <a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=1"><img src="../documents/templates/worknet/tasarim/stf_icon_1.png"  height="16" alt="İcon" /></a>
                            <!--- <a href=""><img src="../documents/templates/worknet/tasarim/stf_icon_2.png" height="16" alt="İcon" /></a> --->
                            <a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=6"><img src="../documents/templates/worknet/tasarim/stf_icon_3.png"  height="16" alt="İcon" /></a>
                        </cfoutput>
                    </div>
                </div>
                <div class="stf_kutu_12">
                    <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
                        <tr class="satir_0">
                            <td width="20%"><cf_get_lang no='241.Valör'></td>
                            <td width="40%"><cf_get_lang no='242.ISIN Kodu'></td>
                            <td width="20%" title="<cf_get_lang no='278.B.Faiz'>"><cf_get_lang no='277.B Faiz'></td>
                            <td width="20%"><cf_get_lang_main no='79.Saat'></td>
                        </tr>
                        <cfoutput query="GET_TAHVIL"  maxrows="6">
                            <tr class="satir_1">
                                <td>#strValor#</td>
                                <td>#strMAT#</td>
                                <td style="text-align:right;">#tlformat(dblCY)#</td>
                                <td style="text-align:right;">#timeformat(dtmTarih,timeformat_style)#</td>
                            </tr>
                        </cfoutput>
                    </table>
                </div>
            </div>
            <div class="stf_kutu_1" style="margin-right:0px;">
                <div class="stf_kutu_11">
                    <div class="stf_kutu_111"><cf_get_lang no='276.VOB'></div>
                    <div class="stf_kutu_112">
                    <cfoutput>
                        <a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=1"><img src="../documents/templates/worknet/tasarim/stf_icon_1.png"  height="16" alt="İcon" /></a>
                        <!--- <a href=""><img src="../documents/templates/worknet/tasarim/stf_icon_2.png"  height="16" alt="İcon" /></a> --->
                        <a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=7"><img src="../documents/templates/worknet/tasarim/stf_icon_3.png"  height="16" alt="İcon" /></a>
                    </cfoutput>
                    </div>
                </div>
                <div class="stf_kutu_12">
                    <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="FFFFFF">
                        <tr class="satir_0">
                            <td width="50%"><cf_get_lang no='244.Kontrat'></td>
                            <td width="25%"><cf_get_lang_main no='672.Fiyat'></td>
                            <td width="25%">%</td>
                        </tr>
						<cfoutput query="VOB">
                            <tr class="satir_1">
                                <td>#strSozlesme#</td>
                                <td style="text-align:right;">#tlformat(dblSon)#</td>
                                <td style="text-align:right;"><cfif dblAcilis neq dblSon> #tlformat(((dblAcilis-dblSon)/dblAcilis)*100,2)#</cfif></td>
                            </tr>
                        </cfoutput>
                    </table>
                </div>
            </div>
            
        </div>
    <cfelseif attributes.finance_type eq 2><!--- Borsa --->
        <cfparam name="attributes.lot" default="A">
    
        <cfquery name="HISSE_EN_COK_ARTAN" dbtype="query">
            SELECT strKod,dblSon,dblOncekiSon,dblYuzdeDegisim,strSaat FROM GET_ALL_HISSE order by dblYuzdeDegisim desc
        </cfquery>
    
        <cfquery name="HISSE_EN_COK_AZALAN" dbtype="query">
            SELECT strKod,dblSon,dblOncekiSon,dblYuzdeDegisim,strSaat FROM GET_ALL_HISSE order by dblYuzdeDegisim
        </cfquery>
    
        <cfquery name="HISSE_TOPLAM_HACIM" dbtype="query">
            SELECT strKod,dblToplamHacim1,strSaat FROM GET_ALL_HISSE order by dblToplamHacim1 desc
        </cfquery>
        <cfquery name="GET_STOCKS_BY_NAME" dbtype="query">
            SELECT
                * 
            FROM 
                GET_ALL_HISSE 
            WHERE 
                <cfif len(attributes.lot) and not isdefined("attributes.lot_name")>strKod LIKE '#attributes.lot#%'</cfif>
                <cfif isdefined("attributes.lot_name") and len(attributes.lot_name)>strKod = '#attributes.lot_name#'</cfif>
        </cfquery>
        <div class="stf_anasayfa">
                <div class="stf_kutu_1">
                    <div class="stf_kutu_11">
                        <div class="stf_kutu_111"><cf_get_lang no='245.En Çok Artan'></div>
                        <div class="stf_kutu_112">
                        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.finance_mainpage&finance_type=2"><img src="../documents/templates/worknet/tasarim/stf_icon_1.png"  height="16" alt="İcon" /></a></div>
                    </div>
                    <div class="stf_kutu_12">
                        <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="FFFFFF">
                            <tr class="satir_0">
                                <td width="25%"><cf_get_lang no='2.Hisse'></td>
                                <td width="25%"><cf_get_lang_main no='672.Fiyat'></td>
                                <td width="25%">%</td>
                                <td width="25%"><cf_get_lang_main no='79.Saat'></td>
                            </tr>
                        <cfoutput query="HISSE_EN_COK_ARTAN" maxrows="6">
                            <tr class="satir_1">
                                <td>#strKod#</td>
                                <td style="text-align:right;">#tlformat(dblSon)#</td>
                                <td>
                                    <p style="float:left; text-align:right ;width:40px">#tlformat(dblYuzdeDegisim)#</p>
                                    <p style="float:right"><img src="../documents/templates/worknet/tasarim/<cfif dblYuzdeDegisim lt 0 >stf_icon_5.png<cfelse>stf_icon_4.png</cfif>" width="16" height="16" alt="Yukarı" /></p>
                                </td>
                                <td style="text-align:right;">#left(strSaat,2)#:#mid(strSaat,3,2)#:#right(strSaat,2)#</td>
                            </tr>
                        </cfoutput>
                        </table>
                    </div>
                </div>
                <div class="stf_kutu_1">
                    <div class="stf_kutu_11">
                        <div class="stf_kutu_111"><cf_get_lang no='246.En Çok Azalan'></div>
                        <div class="stf_kutu_112">
                        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.finance_mainpage&finance_type=2"><img src="../documents/templates/worknet/tasarim/stf_icon_1.png" height="16" alt="İcon" /></a></div>
                    </div>
                    <div class="stf_kutu_12">
                        <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="FFFFFF">
                            <tr class="satir_0">
                                <td width="25%"><cf_get_lang no='2.Hisse'></td>
                                <td width="25%"><cf_get_lang_main no='672.Fiyat'></td>
                                <td width="25%">%</td>
                                <td width="25%"><cf_get_lang_main no='79.Saat'></td>
                            </tr>
                        <cfoutput query="HISSE_EN_COK_AZALAN"  maxrows="6">
                            <tr class="satir_1">
                                <td>#strKod#</td>
                                <td style="text-align:right;">#tlformat(dblSon)#</td>
                                <td nowrap="nowrap">
                                    <p style="float:left; text-align:right ;width:40px">#tlformat(dblYuzdeDegisim,1)#</p>
                                    <p style="float:right"><img src="../documents/templates/worknet/tasarim/<cfif dblYuzdeDegisim lt 0 >stf_icon_5.png<cfelse>stf_icon_4.png</cfif>" width="16" height="16" alt="Yukarı" /></p>
                                </td>
                                <td style="text-align:right;">#left(strSaat,2)#:#mid(strSaat,3,2)#:#right(strSaat,2)#</td>
                            </tr>
                        </cfoutput>
                        </table>
                    </div>
                </div>
                <div class="stf_kutu_1" style="margin-right:0px;">
                    <div class="stf_kutu_11">
                        <div class="stf_kutu_111"><cf_get_lang_main no='280.İşlem'></div>
                        <div class="stf_kutu_112">
                            <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.finance_mainpage&finance_type=2"><img src="../documents/templates/worknet/tasarim/stf_icon_1.png"  height="16" alt="İcon" /></a>
                        </div>
                    </div>
                    <div class="stf_kutu_12">
                        <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="FFFFFF">
                            <tr class="satir_0">
                                <td width="25%"><cf_get_lang no='2.Hisse'></td>
                                <td width="50%"><cf_get_lang_main no='2317.Hacim'></td>
                                <td width="25%"><cf_get_lang_main no='79.Saat'></td>
                            </tr>
							<cfoutput query="HISSE_TOPLAM_HACIM" maxrows="6">
                            <tr class="satir_1">
                                <td>#strKod#</td>
                                <td style="text-align:right;">#tlformat(dblToplamHacim1)# TL</td>
                                <td style="text-align:right;">#left(strSaat,2)#:#mid(strSaat,3,2)#:#right(strSaat,2)#</td>
                            </tr>
                            </cfoutput>
                        </table>
                    </div>
                </div>
                <div class="stf_kutu_3">
                <dt id="hisse"></dt>
                    <div class="stf_kutu_21">
                        <div class="stf_kutu_211"><cf_get_lang no='282.Hisse Seçiniz'> : 
                             <select name="lot_search_name" id="lot_search_name" style="float: none;margin-left: 5px;" onchange="javascript:window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.finance_mainpage&finance_type=2&lot_name='+document.getElementById('lot_search_name').value+'##hisse';">
                                <cfoutput query="GET_ALL_HISSE">
                                <option value="#strKod#" <cfif isdefined("attributes.lot_name") and attributes.lot_name eq strKod>selected="selected"</cfif>>#strKod#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="stf_kutu_22">
                        <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="FFFFFF">
                            <tr>
                                <td colspan="9">
                                    <div class="stf_menu_2">
                                        <ul>
                                            <cfoutput>
                                                <li <cfif not isdefined("attributes.lot_name") and attributes.lot eq 'A'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=A##hisse">A</a></li>
                                                <li <cfif attributes.lot eq 'B'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=B##hisse">B</a></li>
                                                <li <cfif attributes.lot eq 'C'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=C##hisse">C</a></li>
                                                <li <cfif attributes.lot eq 'D'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=D##hisse">D</a></li>
                                                <li <cfif attributes.lot eq 'E'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=E##hisse">E</a></li>
                                                <li <cfif attributes.lot eq 'F'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=F##hisse">F</a></li>
                                                <li <cfif attributes.lot eq 'G'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=G##hisse">G</a></li>
                                                <li <cfif attributes.lot eq 'H'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=H##hisse">H</a></li>
                                                <li <cfif attributes.lot eq 'I'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=I##hisse">I</a></li>    
                                                <li <cfif attributes.lot eq 'K'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=K##hisse">K</a></li>
                                                <li <cfif attributes.lot eq 'L'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=L##hisse">L</a></li>
                                                <li <cfif attributes.lot eq 'M'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=M##hisse">M</a></li>
                                                <li <cfif attributes.lot eq 'N'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=N##hisse">N</a></li>
                                                <li <cfif attributes.lot eq 'O'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=O##hisse">O</a></li>
                                                <li <cfif attributes.lot eq 'P'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=P##hisse">P</a></li>
                                                <li <cfif attributes.lot eq 'R'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=R##hisse">R</a></li>
                                                <li <cfif attributes.lot eq 'S'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=S##hisse">S</a></li>
                                                <li <cfif attributes.lot eq 'T'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=T##hisse">T</a></li>
                                                <li <cfif attributes.lot eq 'U'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=U##hisse">U</a></li>
                                                <li <cfif attributes.lot eq 'V'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=V##hisse">V</a></li>
                                                <li <cfif attributes.lot eq 'Y'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=Y##hisse">Y</a></li>
                                                <li <cfif attributes.lot eq 'Z'>class="aktif"</cfif>><a href="#request.self#?fuseaction=worknet.finance_mainpage&finance_type=2&lot=Z##hisse">Z</a></li>
                                            </cfoutput>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                            <tr class="satir_0">
                                <td width="12%"><cf_get_lang no='2.Hisse'></td>
                                <td width="8%"><cf_get_lang no='248.Son Fiyat'></td>
                                <td width="11%"><cf_get_lang_main no='764.Alış'></td>
                                <td width="11%"><cf_get_lang_main no='36.Satış'></td>
                                <td width="15%"><cf_get_lang no='249.İşlem Hacmi'> (TL)</td>
                                <td width="8%">%</td>
                                <td width="9%"><cf_get_lang no='111.En Yüksek'></td>
                                <td width="9%"><cf_get_lang no='112.En Düşük'></td>
                                <td width="7%"><cf_get_lang_main no='79.Saat'></td>
                            </tr>
							<cfoutput query="GET_STOCKS_BY_NAME">
                            <tr class="satir_1" align="right">
                                <td>#strKod#</td>
                                <td style="text-align:right;">
                                    <p style="float:left; text-align:right ;width:40px">#tlformat(dblSon)#</p>
                                    <p style="float:right"><cfif dblYuzdeDegisim lt 0 ><img src="../documents/templates/worknet/tasarim/stf_icon_5.png" width="16" height="16" alt="Aşağı" /><cfelse><img src="../documents/templates/worknet/tasarim/stf_icon_4.png" width="16" height="16" alt="Yukarı" /></cfif></p>
                                </td>
                                <td style="text-align:right;">#tlformat(dblEnIyiAlis)#</td>
                                <td style="text-align:right;">#tlformat(dblEnIyiSatis)#</td>
                                <td style="text-align:right;">#tlformat(dblToplamHacim1)#</td>
                                <td style="text-align:right;">
                                    <p style="float:left; text-align:right ;width:40px">#tlformat(dblYuzdeDegisim)#</p>
                                    <p style="float:right"><cfif dblYuzdeDegisim lt 0 ><img src="../documents/templates/worknet/tasarim/stf_icon_5.png" width="16" height="16" alt="Aşağı" /><cfelse><img src="../documents/templates/worknet/tasarim/stf_icon_4.png" width="16" height="16" alt="Yukarı" /></cfif></p>
                                </td>
                                <td style="text-align:right;">#tlformat(dblGunEnYuksek)#</td>
                                <td style="text-align:right;">#tlformat(dblGunEnDusuk)#</td>
                                <td style="text-align:center;">#left(strSaat,2)#:#mid(strSaat,3,2)#:#right(strSaat,2)#</td>
                            </tr>
                            </cfoutput>
                        </table>
                    </div>
                </div>
            </div>
            
    <cfelseif attributes.finance_type eq 3><!--- Doviz --->
    <cfquery name="doviz_parite" datasource="#dsn#">
        SELECT
            CASE 
                WHEN strSembol = 'EUR/USD' THEN 1
                WHEN strSembol = 'GBP/USD' THEN 2
                WHEN strSembol = 'USD/JPY' THEN 3
                WHEN strSembol = 'EUR/GBP' THEN 4
                WHEN strSembol = 'EUR/JPY' THEN 5
                WHEN strSembol = 'GBP/JPY' THEN 6
            END AS SIRA,
            strSembol,
            dblAlis,
            dblSon,
            dblOncekiKapanis 
        FROM 
            FOREKS_DovizParite 
        WHERE 
            strSembol IN ('EUR/USD','GBP/USD','USD/JPY','EUR/GBP','EUR/JPY','GBP/JPY')
        ORDER BY 
            SIRA
    </cfquery>
    <cfquery name="GET_MERKEZ" datasource="#DSN#">
        SELECT 
            CASE 
                WHEN strSembol = 'M_USD' THEN 1
                WHEN strSembol = 'M_EUR' THEN 2
                WHEN strSembol = 'M_GBP' THEN 3
                WHEN strSembol = 'M_JPY' THEN 4
                WHEN strSembol = 'M_DKK' THEN 5
            END AS SIRA,
            strSembol,
            dblAlis,
            dblSatis,
            dblOncekiKapanis 
        FROM 
            FOREKS_MerkezBankasiDoviz 
        WHERE 
            strSembol IN ('M_EUR','M_GBP','M_USD','M_JPY','M_CHF','M_DKK')
        ORDER BY 
            SIRA
    </cfquery>
        <div class="stf_anasayfa">
            <div class="stf_kutu_1">
                <div class="stf_kutu_11">
                    <div class="stf_kutu_111"><cf_get_lang no="250.Serbest Piyasa"></div>
                    <div class="stf_kutu_112">
                    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.finance_mainpage&finance_type=3"><img src="../documents/templates/worknet/tasarim/stf_icon_1.png"  height="16" alt="İcon" /></a></div>
                </div>
                <div class="stf_kutu_12">
                    <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="FFFFFF">
                        <tr class="satir_0">
                            <td width="25%"><cf_get_lang_main no='265.Döviz'></td>
                            <td width="25%"><cf_get_lang_main no='764.Alış'></td>
                            <td width="25%"><cf_get_lang_main no='36.Satış'></td>
                            <td width="25%">%</td>
                        </tr>
                        <cfoutput query="Doviz">
                            <tr class="satir_2">
                            <cfif session_base.language eq 'tr'>
                                <cfswitch expression = "#strSembol#">
                                    <cfcase value="SUSD"><td>Dolar</td></cfcase>
                                    <cfcase value="SEUR"><td>Euro</td></cfcase>
                                    <cfcase value="SGBP"><td>Sterlin</td></cfcase>
                                    <cfcase value="SJPY"><td>J.Yeni</td></cfcase>
                                    <cfcase value="SCHF"><td>İ.Frangi</td></cfcase>
                                    <cfcase value="SDKK"><td>D.Kronu</td></cfcase>
                                    <cfdefaultcase>#strSembol#</cfdefaultcase>
                                </cfswitch>
                            <cfelse>
                            	<td>#replace(strSembol,'S','')#</td>
                            </cfif>    
                                <td style="text-align:right;">#tlformat(dblAlis,4)#</td>
                                <td style="text-align:right;">#tlformat(dblSatis,4)#</td>
                                <td style="text-align:right;">
									<cfset degisim = wrk_round(((dblAlis-dblOncekiKapanis)/dblOncekiKapanis)*100)>
                                    <p style="float:left; text-align:right ;width:40px">#degisim#</p>
                                    <p style="float:right"><cfif degisim lt 0 ><img src="../documents/templates/worknet/tasarim/stf_icon_5.png" width="16" height="16" alt="Aşağı" /><cfelse><img src="../documents/templates/worknet/tasarim/stf_icon_4.png" width="16" height="16" alt="Yukarı" /></cfif></p>
                                </td>
                            </tr>
                      </cfoutput>
                    </table>
                </div>
            </div>
            <div class="stf_kutu_1">
                <div class="stf_kutu_11">
                    <div class="stf_kutu_111"><cf_get_lang no='251.Merkez Bankası'></div>
                    <div class="stf_kutu_112">
                    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.finance_mainpage&finance_type=3"><img src="../documents/templates/worknet/tasarim/stf_icon_1.png"  height="16" alt="İcon" /></a></div>
                </div>
                <div class="stf_kutu_12">
                    <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="FFFFFF">
                        <tr class="satir_0">
                            <td width="25%"><cf_get_lang_main no='265.Döviz'></td>
                            <td width="25%"><cf_get_lang_main no='764.Alış'></td>
                            <td width="25%"><cf_get_lang_main no='36.Satış'></td>
                            <td width="25%">%</td>
                        </tr>
						<cfoutput query="GET_MERKEZ">
                            <tr class="satir_1">
								<cfif session_base.language eq 'tr'>
                                    <cfswitch expression = "#strSembol#">
                                        <cfcase value="M_USD"><td>Dolar</td></cfcase>
                                        <cfcase value="M_EUR"><td>Euro</td></cfcase>
                                        <cfcase value="M_GBP"><td>Sterlin</td></cfcase>
                                        <cfcase value="M_JPY"><td>J.Yeni</td></cfcase>
                                        <cfcase value="M_CHF"><td>İ.Frangi</td></cfcase>
                                        <cfcase value="M_DKK"><td>D.Kronu</td></cfcase>
                                        <cfdefaultcase>#strSembol#</cfdefaultcase>
                                    </cfswitch>
                                <cfelse>
                                	<td>#replace(strSembol,'M_','')#</td>
                                </cfif>                        
                                <td style="text-align:right;">#tlFormat(dblAlis,4)#</td>
                                <td style="text-align:right;">#tlFormat(dblSatis,4)#</td>
                                <td>
                                    <cfset degisim = wrk_round(((dblAlis-dblOncekiKapanis)/dblOncekiKapanis)*100)>
                                    <p style="float:left; text-align:right ;width:40px">#degisim#</p>
                                    <p style="float:right"><img src="../documents/templates/worknet/tasarim/<cfif degisim lt 0 >stf_icon_5.png<cfelse>stf_icon_4.png</cfif>" width="16" height="16" alt="Yukarı" /></p>
                                </td>
                            </tr>
                        </cfoutput>
                    </table>
                </div>
            </div>
            <div class="stf_kutu_1" style="margin-right:0px;">
                <div class="stf_kutu_11">
                    <div class="stf_kutu_111"><cf_get_lang no='270.Çapraz Kur'></div>
                    <div class="stf_kutu_112">
                    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.finance_mainpage&finance_type=3"><img src="../documents/templates/worknet/tasarim/stf_icon_1.png"  height="16" alt="İcon" /></a></div>
                </div>
                <div class="stf_kutu_12">
                <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="FFFFFF">
                    <tr class="satir_0">
                        <td width="50%"><cf_get_lang_main no='265.Döviz'></td>
                        <td width="25%">Son</td>
                        <td width="25%">%</td>
                    </tr>
                    <cfoutput query="doviz_parite">
	                    <tr class="satir_1">
                        <cfif session_base.language eq 'tr'>
                            <cfswitch expression = "#strSembol#">
                                <cfcase value="EUR/USD"><td>Euro / Dolar</td></cfcase>
                                <cfcase value="GBP/USD"><td>Sterlin / Dolar</td></cfcase>
                                <cfcase value="USD/JPY"><td>Dolar / Yen</td></cfcase>
                                <cfcase value="EUR/GBP"><td>Euro / Yen</td></cfcase>
                                <cfcase value="EUR/JPY"><td>Euro / Yen</td></cfcase>
                                <cfcase value="GBP/JPY"><td>Sterlin / Yen</td></cfcase>
                                <cfdefaultcase>#strSembol#</cfdefaultcase>
                            </cfswitch>
                        <cfelse>
	                        <td>#strSembol#</td>
                        </cfif>    
                        	<td style="text-align:right;">#tlformat(dblSon,4)#</td>
                            <td>
                                <cfset degisim = wrk_round(((dblSon-dblOncekiKapanis)/dblOncekiKapanis)*100)>
                                <p style="float:left; text-align:right ;width:40px">#degisim#</p>
                                <p style="float:right"><img src="../documents/templates/worknet/tasarim/<cfif degisim lt 0 >stf_icon_5.png<cfelse>stf_icon_4.png</cfif>" width="16" height="16" alt="Yukarı" /></p>
                            </td>
                        </tr>    
                    </cfoutput>
                    </table>
                </div>
            </div>
        </div>
    <cfelseif attributes.finance_type eq 4><!--- Ekonomik Takvim --->
        <div class="stf_anasayfa">
            <div class="stf_kutu_3">
                <div class="stf_kutu_21">
                    <div class="stf_kutu_211"><cf_get_lang no='61.Ekonomik Takvim'></div>
                    <div class="stf_kutu_212">
                    <!--- <a href="#"><img src="../documents/templates/worknet/tasarim/stf_icon_1.png"  height="16" alt="İcon" /></a> ---></div>
                </div>
                <div class="stf_kutu_22">
                    <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
                        <tr class="satir_0">
                            <td width="14%"><cf_get_lang_main no='807.Ülke'></td>
                            <td width="7%"><cf_get_lang_main no='330.Tarih'></td>
                            <td width="7%"><cf_get_lang_main no='79.Saat'></td>
                            <td width="20%"><cf_get_lang no='103.Gösterge'></td>
                            <td width="11%"><cf_get_lang no='252.Beklenti'></td>
                            <td width="11%"><cf_get_lang no='253.Gerçekleşen'></td>
                            <td width="11%"><cf_get_lang no='254.Önceki'></td>
                            <td width="8%"><cf_get_lang no='205.Önem'></td>
                            <td width="14%"><cf_get_lang_main no='1312.Ay'></td>
                        </tr>
                    <cfoutput query="EkonomikTakvim">
                        <tr class="satir_1">
                            <td>#COUNTRY#</td>
                            <td style="text-align:center;">#dateformat(date,'dd.mm')#</td>
                            <td style="text-align:center;">#timeformat(tsi,timeformat_style)#</td>
                            <td title="#eventname#"><cfif len(eventname) gt 17>#left(eventname,17)#...<cfelse>#eventname#</cfif></td>
                            <td style="text-align:right;">#forecast#</td>
                            <td style="text-align:right;">#actual#</td>
                            <td style="text-align:right;">#previous#</td>
                            <td style="text-align:center;"><cfloop from="1" to="#importance#" index="k"><img src="../documents/templates/worknet/tasarim/stf_icon_14.png" width="11px" height="11px" alt="5" style="float:none;" /></cfloop></td>
                            <td style="text-align:center;">#period#</td>
                        </tr>
                    </cfoutput>
                    </table>
                </div>
            </div>
        </div>    
    <cfelseif attributes.finance_type eq 5><!--- Emtia --->
    	<cfquery name="GET_ALTIN" datasource="#DSN#">
            SELECT
				strSembol,
                dblAlis,
                dblSatis,
                dblOncekiKapanis,
                dtmTarih,
                strSaat
            FROM 
                FOREKS_Serbest 
            WHERE 
                strSembol LIKE 'SG%' and strSembol NOT IN ('SGBP','SGLD')
            ORDER BY 
            	strSembol
        </cfquery>
        <cfquery name="GET_PETROL" datasource="#DSN#">
        	SELECT strPiyasa, strKod, strAd, dblKapanis, dblKapanisTarihi FROM FOREKS_Petrol WHERE strKod NOT IN ('GO1','GI1','SI1','PL1','TT1')
        </cfquery>
        <div class="stf_anasayfa">
       	  	<div class="stf_kutu_3">
            	<div class="stf_kutu_21">
                	<div class="stf_kutu_211"><!--- İstanbul Altın Borsası ---><cf_get_lang no='240.Emtia'></div>
                	<div class="stf_kutu_212"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.finance_mainpage&finance_type=5"><img src="../documents/templates/worknet/tasarim/stf_icon_1.png"  height="16" alt="İcon" /></a></div>
                </div>
                <div class="stf_kutu_22">
                    <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
                        <tr class="satir_0">
                            <td width="40%"></td>                        
                            <td width="20%"><cf_get_lang_main no='672.Fiyat'></td>			
                            <td width="20%"><cf_get_lang_main no='1171.Fark'></td>
                            <td width="20%">%<cf_get_lang_main no='604.Degisim'></td>
                        </tr>
                    <cfoutput query="GET_EMTIA">
                        <tr class="satir_1">
                            <cfif session_base.language eq 'tr'>
                                <td>#strAciklama#</td>
                            <cfelse>
                                <td>#strSembol#</td>	
                            </cfif>
                            <td style="text-align:right;">#tlformat(dblSatis)#</td>
                            <td style="text-align:right;">#tlformat(dblSon-dblSatis)#</td>
                            <td style="text-align:right;">#wrk_round(((dblSatis-dblSon)/dblSon)*100)#</td>
                        </tr>
                    </cfoutput>
                    </table>
                </div>
            </div>
       	  	<div class="stf_kutu_4">
            	<div class="stf_kutu_41">
                	<div class="stf_kutu_411"><cf_get_lang no='271.Petrol Fiyatları'></div>
                	<div class="stf_kutu_212"><a href="#"><img src="../documents/templates/worknet/tasarim/stf_icon_1.png"  height="16" alt="İcon" /></a></div>
                </div>
                <div class="stf_kutu_22">
                    <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
                        <tr class="satir_0">
                            <td width="40%"></td>
                            <td width="15%"><cf_get_lang no='272.Piyasa'></td>
                            <td width="15%"><cf_get_lang no='273.Kapanış'></td>
                            <td width="20%"><cf_get_lang_main no='330.Tarih'></td>
                        </tr>
						<cfoutput query="GET_PETROL">
                            <tr class="satir_1">
                                <td>#strAd#</td>
                                <td style="text-align:center;">#strPiyasa#</td>
                                <td style="text-align:right;">#tlformat(dblKapanis)#</td>
                                <td style="text-align:center;">#left(dblKapanisTarihi,2)#.#mid(dblKapanisTarihi,3,2)#.20#right(dblKapanisTarihi,2)#</td>
                            </tr>
                        </cfoutput>
                    </table>
                </div>
            </div>
       	  	<div class="stf_kutu_4" style="margin-right:0px;">
            	<div class="stf_kutu_41">
                	<div class="stf_kutu_411"><cf_get_lang no='274.Serbest Altın Piyasası'></div>
                	<div class="stf_kutu_212"><a href="#"><img src="../documents/templates/worknet/tasarim/stf_icon_1.png"  height="16" alt="İcon" /></a></div>
                </div>
                <div class="stf_kutu_22">
                    <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
                        <tr class="satir_0">
                            <td width="40%"></td>
                            <td width="20%"><cf_get_lang_main no='672.Fiyat'></td>
                            <td width="20%">%<cf_get_lang_main no='604.Degisim'></td>
                            <td width="20%"><cf_get_lang_main no='330.Tarih'></td>
                        </tr>
                        <cfoutput query="GET_ALTIN">
                            <tr class="satir_1">
                            <cfif session_base.language eq 'tr'>
                                <cfswitch expression = "#strSembol#">
                                    <cfcase value="SGCEYREK"><td>Çeyrek Altın</td></cfcase>
                                    <cfcase value="SGYARIM"><td>Yarım Altın</td></cfcase>
                                    <cfcase value="SGZIYNET"><td>Ziynet Altın</td></cfcase>
                                    <cfcase value="SGIKIBUCUK"><td>İkibuçuk Altın</td></cfcase>
				    				<cfcase value="SG22BIL"><td>22 Ayar Bilezik</td></cfcase>
                                    <cfcase value="SG18BIL"><td>18 Ayar Bilezik</td></cfcase>
                                    <cfcase value="SG14BIL"><td>14 Ayar Bilezik</td></cfcase>
                                    <cfcase value="SGGREMSE"><td>Gremse Altın</td></cfcase>
                                    <cfcase value="SGATA"><td>Ata Altın</td></cfcase>
				    				<cfdefaultcase>#strSembol#</cfdefaultcase>
                                </cfswitch>
                            <cfelse>
								<td>#strSembol#</td>                            
                            </cfif>
                                <td style="text-align:right;">#tlformat(dblSatis)#</td>
                                <td style="text-align:right">#wrk_round(((dblSatis-dblOncekiKapanis)/dblOncekiKapanis)*100)#</td>
                                <td style="text-align:center;">#dateformat(dtmTarih,'dd.mm.yyyy')#</td>
                            </tr>
                        </cfoutput>
                    </table>
                </div>
            </div>
		</div>
    <cfelseif attributes.finance_type eq 6><!--- Tahvil --->
        <div class="stf_anasayfa">
            <div class="stf_kutu_3">
            <div class="stf_kutu_21">
            <div class="stf_kutu_211"><cf_get_lang no='243.Tahvil Repo'></div>
            <div class="stf_kutu_212">
            <a href="#"><img src="../documents/templates/worknet/tasarim/stf_icon_1.png" height="16" alt="İcon" /></a></div>
            </div>
                <div class="stf_kutu_22">
                    <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
                        <tr class="satir_0">
                            <td width="7%"><cf_get_lang no='241.Valör'></td>
                            <td width="20%"><cf_get_lang no='242.ISIN Kodu'></td>
                            <td width="10%"><cf_get_lang no='267.Ortalama Fiyat'></td>
                            <td width="8%"><cf_get_lang no='268.Ortalama Faiz'></td>
                            <td width="8%"><cf_get_lang no='269.Bileşik Faiz'></td>
                            <td width="15%"><cf_get_lang no='249.İşlem Hacmi'></td>
                            <td width="7%"><cf_get_lang_main no='79.Saat'></td>
                        </tr>
                    <cfoutput query="GET_TAHVIL">
                        <tr class="satir_1">
                            <td style="text-align:center;">#strValor#</td>
                            <td>#strMAT#</td>
                            <td style="text-align:right;">#tlformat(dblAV)#</td>
                            <td style="text-align:right;">#tlformat(dblSY)#</td>
                            <td style="text-align:right;">#tlformat(dblCY)#</td>
                            <td style="text-align:right;">#tlformat(dblTV)#</td>
                            <td style="text-align:center;">#timeformat(dtmTarih,timeformat_style)#</td>
                        </tr>
                    </cfoutput>
                    </table>
                </div>
            </div>
        </div>
        <div class="ortala_cor"></div>
    <cfelseif attributes.finance_type eq 7><!--- VOB --->
        <cfquery name="VOB" datasource="#DSN#">
            SELECT strSozlesme,dblSon,dblUzlasmaFiyati,dblOncekiUzlasmaFiyati,dblAcikPozisyonSayisi,dblAcikPozisyonSayisiDegisimi,dblSeansEnDusuk,dblSeansEnYuksek FROM FOREKS_Vob ORDER BY dblGunToplamIslemMiktari desc
        </cfquery>
        <div class="stf_anasayfa">
            <div class="stf_kutu_3">
                <div class="stf_kutu_21">
                    <div class="stf_kutu_211"><cf_get_lang no='261.Vadeli İşlemler Opsiyon Borsası'></div>
                    <div class="stf_kutu_212"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.finance_mainpage&finance_type=7"><img src="../documents/templates/worknet/tasarim/stf_icon_1.png" height="16" alt="İcon" /></a></div>
                </div>
                <div class="stf_kutu_22">
                    <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="FFFFFF">
                        <tr class="satir_0">
                            <td width="19%"><cf_get_lang no='244.Kontrat'></td>
                            <td width="10%"><cf_get_lang_main no='672.Fiyat'></td>
                            <td width="8%" title="<cf_get_lang no='282.Bir önceki günün uzlaşma fiyatının son fiyata göre yüzde değişimi'>">%</td>
                            <td width="10%" title="<cf_get_lang no='255.Uzlaşma Fiyat'>"><cf_get_lang no='263.UF'></td>
                            <td width="10%" title="<cf_get_lang no='256.Onceki Uzlasma Fiyat'>"><cf_get_lang no='264.ÖUF'></td>
                            <td width="10%" title="<cf_get_lang no='257.Açık Pozisyon Sayısı'>"><cf_get_lang no='265.APS'></td>
                            <td width="10%" title="<cf_get_lang no='258.Açık Pozisyon Sayısı Değişim'>"><cf_get_lang no='266.APSD'></td>
                            <td width="12%"><cf_get_lang no='259.Gün En Düşük'></td>
                            <td width="12%"><cf_get_lang no='260.Gün En Yüksek'></td>
                        </tr>
                    <cfoutput query="VOB">
                        <tr class="satir_1">
                            <td style="text-align:left;">#strSozlesme#</td>
                            <td style="text-align:right;">#tlformat(dblSon)#</td>
                            <td style="text-align:right;">#wrk_round(((dblSon-dblOncekiUzlasmaFiyati)/dblOncekiUzlasmaFiyati)*100)#</td>
                            <td style="text-align:right;">#tlformat(dblUzlasmaFiyati)#</td>
                            <td style="text-align:right;">#tlformat(dblOncekiUzlasmaFiyati)#</td>
                            <td style="text-align:right;">#dblAcikPozisyonSayisi#</td>
                            <td style="text-align:right;">#dblAcikPozisyonSayisiDegisimi#</td>
                            <td style="text-align:right;">#tlformat(dblSeansEnDusuk)#</td>
                            <td style="text-align:right;">#tlformat(dblSeansEnYuksek)#</td>
                        </tr>
                    </cfoutput>
                    </table>
                </div>
            </div>
        </div>
    <cfelseif attributes.finance_type eq 8><!--- Haberler --->
	     <cfquery name="HABERLER" datasource="#dsn#">
            SELECT * FROM FOREKS_Haber ORDER BY tarih DESC
        </cfquery>
        <div class="stf_anasayfa">
            <div class="stf_kutu_3">
                <div class="stf_kutu_21">
                    <div class="stf_kutu_211"><cf_get_lang no='280.Haberler'></div>
                    <div class="stf_kutu_212">
                        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.finance_mainpage&finance_type=8"><img src="../documents/templates/worknet/tasarim/stf_icon_1.png"  height="16" alt="İcon" /></a></div>
                </div>
                <div class="stf_kutu_22">
                    <cfoutput query="haberler">
                        <div class="stf_kutu_221" id="news_short_#currentrow#">
                            <a href="javascript:gizle_goster(news_main_#currentrow#);gizle_goster(news_short_#currentrow#)"><cf_get_lang no='284.Devamı'></a>
                            <span>#dateformat(tarih,'dd-mm-yyyy')# #timeformat(tarih,timeformat_style)#</span>
                            <samp><b>#baslik#</b></samp>
                            <p>#left(detay,150)#</p>
                        </div>
                        <div class="stf_kutu_221" id="news_main_#currentrow#" style="display:none">
                            <a href="javascript:gizle_goster(news_main_#currentrow#);gizle_goster(news_short_#currentrow#)"><cf_get_lang no='284.Devamı'></a>
                            <span>#dateformat(tarih,'dd-mm-yyyy')# #timeformat(tarih,timeformat_style)#</span>
                            <samp><b>#baslik#</b></samp>
                            <p>#detay#</p>
                        </div>
                    </cfoutput>
                </div>
            </div>
            
        </div>    
    </cfif>
    <cfif session_base.language eq 'tr'>
        <div>
            <div style="text-align:right;width:390px">Finansal Datalar&nbsp;</div>
            <div>&nbsp;<img src="../documents/templates/worknet/tasarim/Foreks.png" height="16" alt="Foreks" />&nbsp;</div>
            <div>Tarafından Sağlanmaktadır.</div> 
        </div>
    <cfelse>
        <div>
            <div style="text-align:right;width:500px">Financial datas are provided by&nbsp;</div>
            <div>&nbsp;<img src="../documents/templates/worknet/tasarim/Foreks.png" height="16" alt="Foreks" />&nbsp;</div>
        </div>    
    </cfif>
<!---<cfelseif isdefined("session.ww.userid")>
	<script>
		alert('Bu sayfaya erişmek için firma çalışanı olarak giriş yapmanız gerekmektedir!');
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>--->

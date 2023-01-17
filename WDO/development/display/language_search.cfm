<cfset butun_liste = ''>
<cfset listem_a = "aa,ab,ac,aç,ad,ae,af,ag,ağ,ah,aı,ai,aj,ak,al,am,an,ao,aö,ap,ar,as,aş,at,au,aü,av,ay,az,ba,ca,ça,da,ea,fa,ga,ğa,ha,ıa,ia,ja,ka,la,ma,na,oa,öa,pa,ra,sa,şa,ta,ua,üa,va,ya,za">
<cfset listem_e = "ea,eb,ec,eç,ed,ee,ef,eg,eğ,eh,eı,ei,ej,ek,el,em,en,eo,eö,ep,er,es,eş,et,eu,eü,ev,ey,ez,ae,be,ce,çe,de,fe,ge,ğe,he,ıe,ie,je,ke,le,me,ne,oe,öe,pe,re,se,şe,te,ue,üe,ve,ye,ze">
<cfset listem_I = "ıa,ıb,ıc,ıç,ıd,ıe,ıf,ıg,ığ,ıh,ıı,ıi,ıj,ık,ıl,ım,ın,ıo,ıö,ıp,ır,ıs,ış,ıt,ıu,ıü,ıv,ıy,ız,aı,bı,cı,çı,dı,eı,fı,gı,ğı,hı,iı,jı,kı,lı,mı,nı,oı,öı,pı,rı,sı,şı,tı,uı,üı,vı,yı,zı">
<cfset listem_i = "ia,ib,ic,iç,id,ie,if,ig,iğ,ih,iı,ii,ij,ik,il,im,in,io,iö,ip,ir,is,iş,it,iu,iü,iv,iy,iz,ai,bi,ci,çi,di,ei,fi,gi,ği,hi,ıi,ji,ki,li,mi,ni,oi,öi,pi,ri,si,şi,ti,ui,üi,vi,yi,zi">
<cfset listem_o = "oa,ob,oc,oç,od,oe,of,og,oğ,oh,oı,oi,oj,ok,ol,om,on,oo,oö,op,or,os,oş,ot,ou,oü,ov,oy,oz,ao,bo,co,ço,do,eo,fo,go,ğo,ho,ıo,io,jo,ko,lo,mo,no,öo,po,ro,so,şo,to,uo,üo,vo,yo,zo">
<cfset listem_o_ = "öa,öb,öc,öç,öd,öe,öf,ög,öğ,öh,öı,öi,öj,ök,öl,öm,ön,öo,öö,öp,ör,ös,öş,öt,öu,öü,öv,öy,öz,aö,bö,cö,çö,dö,eö,fö,gö,ğö,hö,ıö,iö,jö,kö,lö,mö,nö,oö,pö,rö,sö,şö,tö,uö,üö,vö,yö,zö">
<cfset listem_u = "ua,ub,uc,uç,ud,ue,uf,ug,uğ,uh,uı,ui,uj,uk,ul,um,un,uo,uö,up,ur,us,uş,ut,uu,uü,uv,uy,uz,au,bu,cu,çu,du,eu,fu,gu,ğu,hu,ıu,iu,ju,ku,lu,mu,nu,ou,öu,pu,ru,su,şu,tu,üu,vu,yu,zu">
<cfset listem_u_ = "üa,üb,üc,üç,üd,üe,üf,üg,üğ,üh,üı,üi,üj,ük,ül,üm,ün,üo,üö,üp,ür,üs,üş,üt,üu,üü,üv,üy,üz,aü,bü,cü,çü,dü,eü,fü,gü,ğü,hü,ıü,iü,jü,kü,lü,mü,nü,oü,öü,pü,rü,sü,şü,tü,uü,vü,yü,zü">
<cfset listem_ozel = "gr">
<cfset butun_liste = listAppend(butun_liste,listem_a)>
<cfset butun_liste = listAppend(butun_liste,listem_e)>
<cfset butun_liste = listAppend(butun_liste,listem_I)>
<cfset butun_liste = listAppend(butun_liste,listem_i)>
<cfset butun_liste = listAppend(butun_liste,listem_o)>
<cfset butun_liste = listAppend(butun_liste,listem_o_)>
<cfset butun_liste = listAppend(butun_liste,listem_u)>
<cfset butun_liste = listAppend(butun_liste,listem_u_)>
<cfset butun_liste = listAppend(butun_liste,listem_ozel)>
<cfset butun_liste = ListDeleteDuplicates(butun_liste)>

<cfset ifade_sayisi_ = 0>
<cfset yasak_listem = "">
<cfset yasak_listem_1 = 'contains *elementById(*variable=*isdefined(*href=*name=*type=*class=*validate=*passthrough=*oncontextmenu=*onKeyup=*==*!=*message=*required=*function=*method=*nowrap=*valign=*=*value=*createObject(*,*lete_Create(*evaluate(*is *", *.href = *.target = *VarName(tag: *action = *index = * index=*process_type:*adres = *url_str = *LIKE *able_history = *column_name = *ffgram"][*xData[*sCurrent[* money_type = *passthrough = *include(*action_table = *wrk_query(*.align = *paper_duedate(*member_type = *var sql = *url_string = *getAttribute(*setAttribute(*wrkUrlStrings(*Option(*add_function = *add_function=*'>
<cfset yasak_listem_2 = 'align=*onfocus=*fuseact=*cfset *setAttribute(*insertCell(*className = *eval(*form_name = *dd_href_size = *.display = *wrk_select_all(* isdefined (*money_info(* findnocase(*action_list = *listfind(*throw(*== *//*process_cat(*session_values(*layoutFile = *denied_list = *goster_ikili(*, *,\*eadonly_info = *control_list = *for_submit = *money_info(\*eq * is not *SQLString:*sqlstring : *date tarih = *case *career_url = *safe_query(*.Forward(*JavaCast(*attr(*setEncoding(*AllowedVerbs(*web_path = *nstance_name = *contact_type = * DE(*work_fuse = *DULE_NAME = *_date_image(*'>
<cfset yasak_listem = listappend(yasak_listem,yasak_listem_1)>
<cfset yasak_listem = listappend(yasak_listem,yasak_listem_2)>
<cfset yasak_listem_3 = 'readonly*disabled*selected*value*fuseaction*colspan*onBlur*session_basket_kur_ekle*eval(*backgroun*height*margin*AND *NULL*display*onload*url_string*AND*SELECT*UPDATE_IP*UPDATE_EMP*keyword*onKeyUp'>
<cfset yasak_listem_4 = 'cfscript*javascript*text/css*'>



<cfsetting showdebugoutput="no">
<cfquery name="GET_MODULES" datasource="#DSN#">
	SELECT 
		MODULE_SHORT_NAME,
		MODULE_NAME_TR,
		MODULE_NAME,
        FOLDER
	FROM 
		MODULES
	ORDER BY
		MODULE_NAME_TR
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent  variable="title"><cf_get_lang dictionary_id='47614.DEV'> <cf_get_lang dictionary_id='58996.Language'></cfsavecontent>
    <cf_box title="#title#">
        <cfform name="language_search"  id="language_search" method="post" action="#request.self#?fuseaction=dev.language_search">
            <input type="hidden" value="1" name="is_submitted" id="is_submitted" />
            <cf_box_search more="0">
                <div class="form-group">
                    <label><cf_get_lang dictionary_id='64374.Fazla sayıda kayıt getireceği için lütfen tek tek modül seçiniz'>!</label>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
            <cf_flat_list>
                <thead>
                    <tr>
                        <th colspan="10"><cf_get_lang dictionary_id='59869.Ana Modüller'></th>
                    </tr>
                </thead>
                <tbody>                    				
                    <cfset x = 1>
                    <cfloop from="1" to="#ceiling(get_modules.recordcount/5)#" index="i">
                        <tr>
                            <cfoutput query="get_modules" startrow="#x#" maxrows="5">
                                <td width="200">#module_name_tr# (#module_name#)</td>
                                <td width="60"><input type="checkbox"  name="#module_short_name#_" id="#module_short_name#_" value="1"></td>
                            </cfoutput>
                            <cfset x = x+5>
                            <cfif ceiling(get_modules.recordcount/5) neq i></tr></cfif>
                    </cfloop>
                        <td width="140">My Home</td>
                        <td><input type="checkbox" name="myhome" id="myhome" value="1" /></td>
                        <td width="140">Objects 2</td>
                        <td><input type="checkbox" name="objects2" id="objects2"  value="1" /></td>
                        <td width="140">Schedules</td>
                        <td><input type="checkbox" name="schedules" id="schedules" value="1" /></td>
                    </tr>
                    <tr>
                        <td>PDA</td>
                        <td><input type="checkbox" name="pda" id="pda" value="1" /></td>
                        <td>Test</td>
                        <td><input type="checkbox" name="test" id="test" value="1" /></td>
                        <td>Add Options</td>
                        <td><input type="checkbox" name="add_options" id="add_options" value="1" /></td>	
                        <td>Documents</td>
                        <td><input type="checkbox" name="documents" id="documents" value="1" /></td>
                        <td>FCK Editor</td>
                        <td><input type="checkbox" name="fck_editor" id="fck_editor" value="1" /></td>
                    </tr>
                    <tr>
                        <td>JS</td>
                        <td><input type="checkbox" name="js" id="js"  value="1" /></td>
                        <td width="108">Design</td>
                        <td><input type="checkbox" name="design" id="design" value="1"></td>
                        <td width="108">CSS</td>
                        <td><input type="checkbox" name="css" id="css" value="1"></td>
                        <td width="108">Workdata</td>
                        <td><input type="checkbox" name="workdata" id="workdata"value="1"></td>
                    </tr>
                    <tr>
                        <td width="108"><b>Custom Tag</b></td>
                        <td><input type="checkbox" name="custom_tags" id="custom_tags" value="1"></td>
                    </tr>                   
                </tbody>
            </cf_flat_list>
        </cfform>
        
        <cfif isdefined("is_submitted")>
        
            <cfset like_list = ''>
            <cfoutput query="get_modules">
                <cfif isdefined("attributes.#module_short_name#_")>
                    <cfset folder_ = replace(folder,'/','\')>
                    <cfset like_list = listappend(like_list,folder_,',')>   
                </cfif>
            </cfoutput>
                <cfif isdefined("attributes.myhome")>
                    <cfset like_list = listappend(like_list,'myhome',',')>
                </cfif>
                <cfif isdefined("attributes.objects2")>
                    <cfset like_list = listappend(like_list,'objects2',',')>
                </cfif>
                <cfif isdefined("attributes.schedules")>
                    <cfset like_list = listappend(like_list,'schedules',',')>
                </cfif>
                <cfif isdefined("attributes.pda")>
                    <cfset like_list = listappend(like_list,'workcube_pda',',')>
                </cfif>
                <cfif isdefined("attributes.objects2")>
                    <cfset like_list = listappend(like_list,'objects2',',')>
                </cfif>
                <cfif isdefined("attributes.test")>
                    <cfset like_list = listappend(like_list,'test',',')>
                </cfif>
                <cfif isdefined("attributes.add_options")>
                    <cfset like_list = listappend(like_list,'add_options',',')>
                </cfif>
                <cfif isdefined("attributes.js")>
                    <cfset like_list = listappend(like_list,'JS',',')>
                </cfif>
                <cfif isdefined("attributes.extra")>
                    <cfset like_list = listappend(like_list,'extra',',')>
                </cfif>
                <cfif isdefined("attributes.design")>
                    <cfset like_list = listappend(like_list,'design',',')>
                </cfif>
                <cfif isdefined("attributes.custom_tags")>
                    <cfset like_list = listappend(like_list,'CustomTags',',')>
                </cfif>
                <cfif isdefined("attributes.css")>
                    <cfset like_list = listappend(like_list,'css',',')>
                </cfif>
                <cfif isdefined("attributes.workdata")>
                    <cfset like_list = listappend(like_list,'workdata',',')>
                </cfif>
                
            <cfset directory_list = "E:\Inetpub\workcube\">
            
            <cfset search_directory ="E:\Inetpub\workcube\">	
        
            <cfset sayi_ = 0>
            
            <cfset folder_list = "">
            <cfset search_count = 0>
            <cfdirectory directory="#search_directory#" name="get_folders" listinfo="all" action="list">
                <cfoutput query="get_folders">
                    <cfset folder_list =   listappend(folder_list,get_folders.name,',')>
                    
                    <cfif name eq 'hr' and listfind(like_list,'hr\ehesap')>
                        <cfset folder_list = listappend(folder_list,'hr\ehesap',',')> 
                    </cfif>
                    <cfif name eq 'account' and listfind(like_list,'account\account')>
                        <cfset folder_list = listappend(folder_list,'account\account',',')> 
                    </cfif>
                    <cfif name eq 'account' and listfind(like_list,'account\definition')>
                        <cfset folder_list = listappend(folder_list,'account\definition',',')> 
                    </cfif>
                    <cfif name eq 'account' and listfind(like_list,'account\financial_tables')>
                        <cfset folder_list = listappend(folder_list,'account\financial_tables',',')> 
                    </cfif>
                    <cfif name eq 'account' and listfind(like_list,'account\inventory')>
                        <cfset folder_list = listappend(folder_list,'account\inventory',',')> 
                    </cfif>
                </cfoutput>
                
                <cfloop list="#folder_list#" index="up_name_">
                    <cfoutput>
                        <cfset sayi_ = sayi_ + 1>
                        <cfif listfind(like_list,up_name_)>
                        <cfset directory_list = listappend(directory_list,'#search_directory##up_name_#\')>
        
                        <cfset sayi_ = sayi_ + 1>
                        <cfdirectory directory="#search_directory##up_name_#" name="get_folders_#sayi_#" action="list">
                           <cfloop query="get_folders_#sayi_#">
                                <cfif evaluate("get_folders_#sayi_#.type") is 'dir'>
                                    <cfset directory_list = listappend(directory_list,'#search_directory##up_name_#\#evaluate("get_folders_#sayi_#.name")#\')>
                                    <cfdirectory directory='#search_directory##up_name_#\#evaluate("get_folders_#sayi_#.name")#\' name='get_folders_#sayi_#_a' action='list'>
                                    <cfloop query="get_folders_#sayi_#_a">
                                        <cfif evaluate("get_folders_#sayi_#_a.type") is 'dir'>
                                            <cfset directory_list = listappend(directory_list,'#search_directory##up_name_#\#evaluate("get_folders_#sayi_#.name")#\#evaluate("get_folders_#sayi_#_a.name")#\')>
                                        </cfif>
                                    </cfloop>
                                </cfif>
                            </cfloop>
                        </cfif>
                    </cfoutput>
                </cfloop>
            <cfloop list="#directory_list#" index="d_name">
            <cfdirectory directory="#d_name#" name="get_sub_folders" action="list" filter="*.cfm|*.css|*.cfc|*.js">
                <cf_grid_list>
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>Klasör</th>
                            <th>Dosya Adı</th>
                            <th>Aranan</th>
                            <th>Geçiş Şekli</th>
                            <th>Şüpheli İfade</th>
                            <th>Dosya Yolu</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfif get_sub_folders.recordcount>
                            <cfoutput query="get_sub_folders">
                                <cftry>
                                    <cffile action="read" variable = "icerik_" file="#d_name##name#">
                                    <cfset icerik_ = "123456789012345" & icerik_ & "1234567890">
                                    <cfset folder_name = Replace(d_name,'E:\Inetpub\workcube\','','all')>
                                <cfcatch>
                                    Okunamayan Dosya : #d_name##name# (Dosya Kullanılıyor ya da zarar görmüş olabilir ! )<br />
                                </cfcatch>
                                </cftry>
                                    <cfset folder_kontrol = 0>
                                    <cfloop list="#butun_liste#" index="kelime_index">
                                        <cfset eleman_1 = '"'>
                                        <cfset eleman_2 = "'">
                                        <cfset eleman_3 = ">">
                                        <cfset ara1 = eleman_1 & kelime_index>
                                        <cfset ara2 = eleman_2 & kelime_index>
                                        <cfset ara3 = eleman_3 & kelime_index>
                                        
                                        <cfif findnocase(ara1,icerik_)>
                                            <cfset sira_ = findnocase(ara1,icerik_)>
                                            <cfset yazi_ = mid(icerik_,sira_-15,25)>
                                            <cfset yazi_asil = mid(icerik_,sira_+1,25)>
                                            <cfset yaz_ = 1>
                                            
                                            <cfloop list="#yasak_listem#" index="ccc" delimiters="*">
                                                <cfset ara_ic = ccc & ara1>
                                                <cfif findnocase(ara_ic,yazi_)>
                                                    <cfset yaz_ = 0>
                                                </cfif>
                                            </cfloop>
                                            <cfif yaz_ eq 1 and (ara1 is "'at") and yazi_ contains 'attri'><!--- özel kontrol --->
                                                <cfset yaz_ = 0>
                                            </cfif>
                                            <cfif yaz_ eq 1 and findnocase('RunContent( #ara1#',yazi_)><!--- özel kontrol --->
                                                <cfset yaz_ = 0>
                                            </cfif>
                                            <cfif left(name,1) is '_'>
                                                <cfset yaz_ = 0>
                                            </cfif>
                                            <cfif yaz_ eq 1>
                                                <cfset ifade_sayisi_ = ifade_sayisi_ + 1>
                                                <tr>
                                                    <td>#ifade_sayisi_#</td><td>#folder_name#</td><td>#name#</td><td>#htmleditformat(ara1)#</td><td>#htmleditformat(yazi_)#</td><td>#htmleditformat(yazi_asil)#</td><td><a href="file://epworkcube/Inetpub/workcube/#replace('#d_name#','#search_directory#','')##name#" class="tableyazi">#d_name##name#</a></td>
                                                </tr>
                                            </cfif>
                                        </cfif>
                                        
                                        <cfif findnocase(ara2,icerik_)>
                                            <cfset sira_ = findnocase(ara2,icerik_)>
                                            <cfset yazi_ = mid(icerik_,sira_-15,25)>
                                            <cfset yazi_asil = mid(icerik_,sira_+1,25)>
                                            <cfset yaz_ = 1>
                                            
                                            <cfloop list="#yasak_listem#" index="ccc" delimiters="*">
                                                <cfset ara_ic = ccc & ara2>
                                                <cfif findnocase(ara_ic,yazi_)>
                                                    <cfset yaz_ = 0>
                                                </cfif>
                                            </cfloop>
                                            <cfif yaz_ eq 1 and (ara2 is "'at") and (yazi_ contains 'attri')><!--- özel kontrol --->
                                                <cfset yaz_ = 0>
                                            </cfif>
                                            <cfif yaz_ eq 1 and findnocase('RunContent( #ara2#',yazi_)><!--- özel kontrol --->
                                                <cfset yaz_ = 0>
                                            </cfif>
                                            <cfif left(name,1) is '_'>
                                                <cfset yaz_ = 0>
                                            </cfif>
                                            <cfif yaz_ eq 1>
                                                <cfset ifade_sayisi_ = ifade_sayisi_ + 1>
                                                <tr>
                                                    <td>#ifade_sayisi_#</td><td>#folder_name#</td><td>#name#</td><td>#htmleditformat(ara2)#</td><td>#htmleditformat(yazi_)#</td><td>#htmleditformat(yazi_asil)#</td><td><a href="file://epworkcube/Inetpub/workcube/#replace('#d_name#','#search_directory#','')##name#" class="tableyazi">#d_name##name#</a></td>
                                                </tr>
                                            </cfif>
                                        </cfif>
                                        
                                        <cfif findnocase(ara3,icerik_)>
                                            <cfset sira_ = findnocase(ara3,icerik_)>
                                            <cfset yazi_ = mid(icerik_,sira_-15,25)>
                                            <cfset yazi_asil = mid(icerik_,sira_+1,25)>
                                            <cfset yaz_ = 1>
                                            <cfloop list="#yasak_listem_3#" index="ccc" delimiters="*">
                                                <cfif findnocase(ccc,yazi_asil)>
                                                    <cfset yaz_ = 0>
                                                </cfif>
                                            </cfloop>
                                            <cfloop list="#yasak_listem_4#" index="ccc" delimiters="*">
                                                <cfif findnocase(ccc,yazi_)>
                                                    <cfset yaz_ = 0>
                                                </cfif>
                                            </cfloop>
                                            <cfif yaz_ eq 1 and (findnocase(')#ara3#',yazi_) or findnocase(') #ara3#',yazi_))><!--- özel kontrol --->
                                                <cfset yaz_ = 0>
                                            </cfif>
                                            <cfif yaz_ eq 1 and findnocase('<script#ara3#',yazi_)><!--- özel kontrol --->
                                                <cfset yaz_ = 0>
                                            </cfif>
                                            <cfif yaz_ eq 1 and (ara3 is ">aj") and (yazi_ contains 'ajaxpage')><!--- özel kontrol --->
                                                <cfset yaz_ = 0>
                                            </cfif>   
                                            <cfif left(name,1) is '_'>
                                                <cfset yaz_ = 0>
                                            </cfif>                  
                                            <cfif yaz_ eq 1>
                                                <cfset ifade_sayisi_ = ifade_sayisi_ + 1>
                                                <tr>
                                                    <td>#ifade_sayisi_#</td><td>#folder_name#</td><td>#name#</td><td>#htmleditformat(ara3)#</td><td>#htmleditformat(yazi_)#</td><td>#htmleditformat(yazi_asil)#</td><td><a href="file://epworkcube/Inetpub/workcube/#replace('#d_name#','#search_directory#','')##name#" class="tableyazi">#d_name##name#</a></td>
                                                </tr>
                                            </cfif>                    
                                        </cfif>
                                    </cfloop>
                            </cfoutput>
                        <cfelse>
                            <tr><td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td></tr>
                        </cfif>                        
                    </tbody>
                </cf_grid_list>
            </cfloop>
            <br />
        </cfif>    
    </cf_box>
</div>


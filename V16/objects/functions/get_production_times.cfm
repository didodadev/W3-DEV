<cfsetting showdebugoutput="no">
<cfsetting enablecfoutputonly="yes">
<cfprocessingdirective suppresswhitespace="yes">
    <cffunction name="get_production_times" returntype="string" output="no">
    <cfargument name="station_id" type="numeric" default="1">
    <cfargument name="shift_id" type="numeric" default="1">
    <cfargument name="stock_id" type="numeric" default="1">
    <cfargument name="amount" type="numeric" default="1">
    <cfargument name="min_date" type="numeric" default="0">
    <cfargument name="setup_time_min" type="numeric" default="0">
    <cfargument name="production_type" type="boolean" default="0">
    <cfargument name="_now_" type="string" default="">
    <cfquery name="GET_STATION_CAPACITY" datasource="#DSN3#"><!--- Seçilen istasyona ve ürüne bağlı olarak istasyonumuzun o ürünü ne kadar zamanda ürettiği bilgileri --->
        SELECT 
            *
        FROM
            WORKSTATIONS_PRODUCTS WSP,
            WORKSTATIONS W
        WHERE
            W.STATION_ID=WSP.WS_ID AND 
            WSP.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"> AND
            WS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_id#">
    </cfquery>
    <cfif GET_STATION_CAPACITY.RECORDCOUNT>
		<cfset capacity = GET_STATION_CAPACITY.CAPACITY > 
	<cfelse>
		<cfset capacity = 1>
	</cfif>    
	<cfset amount = arguments.amount>
    <!--- İstasyon zamanlarında bazen hata oluyordu,onu engellemek için eklendi...Üretim zamanı 0,000001 gibi bi değer inifty oluyor ve 0 geldiği için çakıyordu --->
    <cfif capacity eq 0><cfset capacity =1></cfif>
    <cfset gerekli_uretim_zamanı_dak = wrk_round((amount/capacity)*60,6)>
    <cfif arguments.setup_time_min gt 0><cfset gerekli_uretim_zamanı_dak = arguments.setup_time_min + gerekli_uretim_zamanı_dak></cfif>
	<!--- <cfoutput><font color="FF0000">**********#arguments.min_date#************************ </font> </cfoutput> --->
	<cfif len(arguments._now_) and isdate(arguments._now_)>
		<cfset _now_ = arguments._now_>
    <cfelse>
        <cfset _now_ = date_add('h',session.ep.TIME_ZONE,now())>
    </cfif>
    <cfquery name="get_station_times" datasource="#dsn#">
        SELECT * FROM SETUP_SHIFTS WHERE IS_PRODUCTION = 1 AND FINISHDATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#_now_#"> AND SHIFT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.shift_id#">
    </cfquery>
    <cfif get_station_times.recordcount>
        <cfset calisma_start = (get_station_times.START_HOUR*60)+get_station_times.START_MIN>
        <cfset calisma_finish = (get_station_times.END_HOUR*60)+get_station_times.END_MIN>	
    <cfelse>
		<cfset calisma_start = 01>
        <cfset calisma_finish = 1439>
    </cfif>
    <cfquery name="get_station_select" datasource="#dsn3#">
        SELECT DISTINCT
            DATEPART(hh,START_DATE)*60+DATEPART(n,START_DATE) AS START_TIME,
            DATEPART(M,START_DATE) AS START_MONT,
            DATEPART(D,START_DATE) AS START_DAY,
            DATEPART(hh,FINISH_DATE)*60+DATEPART(n,FINISH_DATE) AS FINISH_TIME,
            DATEPART(M,FINISH_DATE) AS FINISH_MONT,
            DATEPART(D,FINISH_DATE) AS FINISH_DAY,
            datediff(d,START_DATE,FINISH_DATE) AS FARK,
            START_DATE,FINISH_DATE	
        FROM 
            PRODUCTION_ORDERS 
        WHERE 
            STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_id#"> AND 
			(START_DATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#_now_#"> OR FINISH_DATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#_now_#">)
    UNION ALL
        SELECT
            DISTINCT
            DATEPART(hh,START_DATE)*60+DATEPART(n,START_DATE) AS START_TIME,
            DATEPART(M,START_DATE) AS START_MONT,
            DATEPART(D,START_DATE) AS START_DAY,
            DATEPART(hh,FINISH_DATE)*60+DATEPART(n,FINISH_DATE) AS FINISH_TIME,
            DATEPART(M,FINISH_DATE) AS FINISH_MONT,
            DATEPART(D,FINISH_DATE) AS FINISH_DAY,
            datediff(d,START_DATE,FINISH_DATE) AS FARK,
            START_DATE,FINISH_DATE	
        FROM 
            PRODUCTION_ORDERS_CASH
        WHERE 
            STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_id#"> AND 
			(START_DATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#_now_#"> OR FINISH_DATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#_now_#">)
        ORDER BY 
            START_DATE ASC,FINISH_DATE ASC
    </cfquery>
    <cfset full_days =''>	<!---dolu olan günleri yani iş yüklemesi yapamıyacağım günleri belirliyoruz. --->
    <cfset production_type = arguments.production_type><!--- 0 ise sürekli üretim 1 ise parçalı üretim yapacak  --->
    <!--- Üretimlerimizin içinden başlangıç ve bitiş saatlerini hesaplayarak çalışma saatlerimizi şekillendiriyoruz. --->
    <table cellpadding="1" cellspacing="1" border="1" width="100%" class="">
    <cfoutput query="get_station_select">
        <cfset p_start_day = DateFormat(START_DATE,'YYYYMMDD')>
        <cfset p_finish_day = DateFormat(FINISH_DATE,'YYYYMMDD')>
       <tr>
        <cfif FARK gt 0><!--- Başlangıç ve bitiş tarihleri aynı olmayan üretim emirleri gelsin sadece. --->
            <cfloop from="0" to="#FARK#" index="_days_">
                <cfset new_days = DateFormat(date_add('D',_days_,START_DATE),'YYYYMMDD')>
                <cfif not ListFind(full_days,new_days,',') and new_days gte DateFormat(_NOW_,'YYYYMMDD')><!--- DOLU GÜNLER İÇİNDE OLMAYAN GÜNLER GELSİN SADECE --->
                    <cfif not isdefined('empty_days#new_days#') OR(isdefined('empty_days#new_days#') and not len(Evaluate('empty_days#new_days#')))><cfset 'empty_days#new_days#' = '#calisma_start#-#calisma_finish#'><!--- ----#new_days# ---></cfif>
                        <td>
                            <cfif new_days eq p_start_day><!--- Üretimin Başladığı Gün ise --->
                           <font color="33CC33">#new_days#[#START_TIME#]</font>
                                <cfif START_TIME lte ListGetAt(Evaluate('empty_days#new_days#'),2,'-') and START_TIME gte ListGetAt(Evaluate('empty_days#new_days#'),1,'-')><!--- Üretim zamanımız çalışma saatleri arasında ise --->
                                   <cfset 'empty_days#new_days#' = '#ListGetAt(Evaluate('empty_days#new_days#'),1,'-')#-#START_TIME-1#'>
                                </cfif>
                            <cfelseif new_days eq p_finish_day><!--- Üretimin Bittiği Gün ise --->
                            <font color="FF0000">bitiş=>#new_days#[#FINISH_TIME#]</font>
                            	<!--- <cfif ListLen(Evaluate('empty_days#new_days#'),'-') lt 2>#new_days#cccc#Evaluate('empty_days#new_days#')#aaaa<cfabort></cfif> --->
                                <cfif FINISH_TIME lte ListGetAt(Evaluate('empty_days#new_days#'),2,'-') and FINISH_TIME gte ListGetAt(Evaluate('empty_days#new_days#'),1,'-')>
                                    <cfset 'empty_days#new_days#' = '#FINISH_TIME+1#-#ListGetAt(Evaluate('empty_days#new_days#'),2,'-')#'>
                                <cfelseif  FINISH_TIME gte ListGetAt(Evaluate('empty_days#new_days#'),2,'-')><!--- eğer bitiş zamanı çalışma saatlerinin üzerinde ise,o zamanda o günüde dolu günler arasına alıyoruz. --->
                                    <cfset full_days =ListAppend(full_days,new_days,',')>#new_days#
                                </cfif>
                            <cfelse><!--- Üretimin başlagıç ve bitiş tarihi arasında kalan günler ise bu günler zaten üretim ile dolu günler olduğu için direkt olarak kapatıyoruz. --->
                                <cfset full_days =ListAppend(full_days,new_days,',')>#new_days#XX
                            </cfif>
                           <!--- ///[#Evaluate('empty_days#new_days#')#]// --->
                       </td>
                  </cfif>
            </cfloop>
        </cfif>
        </tr>
    </cfoutput>
    </table>
    <!--- bURDA İSE BAŞLANGIÇ VE BİTİŞ GÜNLERİ AYNI OLAN ÜRETİMLERİ ŞEKİLLENDİRİCEZ. --->
    <cfoutput query="get_station_select">
        <cfset p_start_day = DateFormat(START_DATE,'YYYYMMDD')>
        <cfif FARK eq 0 and not listfind(full_days,p_start_day,',') and p_start_day gte DateFormat(_NOW_,'YYYYMMDD')><!--- Başlama ve bitiş tarihi aynı olan günler yani 1 gün içinde başlayıp biten üretimlere bakıyoruz. --->
                <cfif not isdefined('empty_days#p_start_day#') OR (isdefined('empty_days#p_start_day#') and not len(Evaluate('empty_days#p_start_day#')))><cfset 'empty_days#p_start_day#' = '#calisma_start#-#calisma_finish#'></cfif>
                <!--- <cfset days_list = listdeleteduplicates(ListAppend(days_list,p_start_day,','))> --->
                <cfif START_TIME lt calisma_start><cfset START_TIME = calisma_start></cfif>
                <cfif FINISH_TIME lt calisma_finish><cfset FINISH_TIME = calisma_finish></cfif>
                <cfloop list="#Evaluate('empty_days#p_start_day#')#" index="list_d">
                	 <cfif ListLen(list_d,'-') neq 2>
						<cfset saat_basi=list_d><!--- Sadece hata vermesin diye eklendi daha sonra silinecek! --->
                        <cfset saat_sonu=list_d+60>
                        <cfset list_d = '#saat_basi#-#saat_sonu#'>
					<cfelse>
						<cfset saat_basi=ListGetAt(list_d,1,'-')>
                        <cfset saat_sonu=ListGetAt(list_d,2,'-')><!--- 11:00-13:00 --->
					</cfif>
                    <cfif START_TIME gt saat_basi and START_TIME lt saat_sonu and FINISH_TIME lt saat_sonu><!--- ortadaysa 11:30-12--->
                        <cfset aaa='#ListGetAt(list_d,1,'-')#-#START_TIME-1#'>
                        <cfset bb='#FINISH_TIME+1#-#ListGetAt(list_d,2,'-')#'>
                        <cfset 'empty_days#p_start_day#' = ListDeleteAt(Evaluate('empty_days#p_start_day#'),listfind(Evaluate('empty_days#p_start_day#'),list_d))>
                        <cfset 'empty_days#p_start_day#' = ListAppend(Evaluate('empty_days#p_start_day#'),aaa)>
                        <cfset 'empty_days#p_start_day#' = ListAppend(Evaluate('empty_days#p_start_day#'),bb)>
                      <!--- ##=>111111 : #aaa#--<!--- #bb# ---><br/> <!---  ---> --->
                     <cfelseif START_TIME lte saat_basi and FINISH_TIME gt saat_basi and FINISH_TIME lt saat_sonu><!--- 9-12 --->
                        <cfset ccc = '#FINISH_TIME+1#-#ListGetAt(list_d,2,'-')#'>
                       <cfif listlen(Evaluate('empty_days#p_start_day#')) and list_d gt 0 and listfind(Evaluate('empty_days#p_start_day#'),list_d) gt 0>
							<cfset 'empty_days#p_start_day#' = ListDeleteAt(Evaluate('empty_days#p_start_day#'),listfind(Evaluate('empty_days#p_start_day#'),list_d))>
							<cfset 'empty_days#p_start_day#' = ListAppend(Evaluate('empty_days#p_start_day#'),ccc)>
						</cfif>
                      <!---  2222222 :#START_TIME#---#FINISH_TIME#--*#ccc#<br/><!---  ---> --->
                     <cfelseif START_TIME lte saat_basi and FINISH_TIME gt saat_basi and FINISH_TIME gte saat_sonu> <!--- 9-14 --->
					 	<cfif listlen(Evaluate('empty_days#p_start_day#')) and list_d gt 0 and listfind(Evaluate('empty_days#p_start_day#'),list_d) gt 0>
							<cfset 'empty_days#p_start_day#' = ListDeleteAt(Evaluate('empty_days#p_start_day#'),listfind(Evaluate('empty_days#p_start_day#'),list_d))>
						</cfif>
                     <cfelseif START_TIME lte saat_basi and  FINISH_TIME gt saat_basi and FINISH_TIME lt saat_sonu><!--- 11-12 --->
                        <cfset ffff = '#FINISH_TIME+1#-#ListGetAt(list_d,2,'-')#'>
                        <cfset 'empty_days#p_start_day#' = ListDeleteAt(Evaluate('empty_days#p_start_day#'),listfind(Evaluate('empty_days#p_start_day#'),list_d))>
                        <cfset 'empty_days#p_start_day#' = ListAppend(Evaluate('empty_days#p_start_day#'),ffff)>
                       <!--- 33333333 :#START_TIME#---#FINISH_TIME#--*#ffff#<br/><!---  ---> --->
                     <cfelseif START_TIME gt saat_basi and  START_TIME lt saat_sonu and FINISH_TIME gte saat_sonu><!--- 12-13,12-14 --->
                        <cfset dddd = '#saat_basi#-#START_TIME-1#'>
                        <cfset 'empty_days#p_start_day#' = ListDeleteAt(Evaluate('empty_days#p_start_day#'),listfind(Evaluate('empty_days#p_start_day#'),list_d))>
                        <cfset 'empty_days#p_start_day#' = ListAppend(Evaluate('empty_days#p_start_day#'),dddd)>
                     <!---  44444444 :#START_TIME#---#FINISH_TIME#--*#dddd#<br/><!---   ---> --->
                    <cfelseif START_TIME gt saat_basi and START_TIME lte saat_sonu and FINISH_TIME gte saat_sonu>
                        <cfset eeee = '#ListGetAt(list_d,1,'-')#-#START_TIME-1#'>
                        <cfset 'empty_days#p_start_day#' = ListDeleteAt(Evaluate('empty_days#p_start_day#'),listfind(Evaluate('empty_days#p_start_day#'),list_d))>
                        <cfset 'empty_days#p_start_day#' = ListAppend(Evaluate('empty_days#p_start_day#'),eeee)>
                      <!---  555555 : ******#list_d#********-------#eeee#<br/> --->
                    <cfelseif (START_TIME lte calisma_start and FINISH_TIME gte calisma_finish)><!--- 9-14 --->
                        <!--- kapandı: --->
                        <cfset full_days = ListAppend(full_days,p_start_day,',')>
                    </cfif>
                </cfloop>
           <!---     #p_start_day#==>#Evaluate('empty_days#p_start_day#')#</font> <br/>
              #p_start_day#==>[[#Evaluate('empty_days#p_start_day#')#]]<br/>
                #Evaluate('empty_days#p_start_day#')#***#START_TIME#-#FINISH_TIME#<br/> --->
        </cfif>
    </cfoutput>
    <cfset uretim_birlesim_dakika = 0 >
    <cfoutput>
        <cfset songun = 365><!--- üretim verildikten sonra 1 yıl boyunca boş zamana bakıyoruz. --->
        <cfloop from="0" to="#songun#" index="_i_n_d_">
            <cfset crate_days = DateFormat(date_add('d',_i_n_d_,_NOW_),'YYYYMMDD')><!--- ilk gün olarak bugünü alıyoruz. --->
            <cfif not listfind(full_days,crate_days,',')><!--- Yukarda belirlediğimiz dolu günlerin içinde değil ise --->           
				<cfif not isdefined('empty_days#crate_days#') OR(isdefined('empty_days#crate_days#') and not len(Evaluate('empty_days#crate_days#')))><cfset 'empty_days#crate_days#' = '#calisma_start#-#calisma_finish#'><!--- tanımlanmamış boş kalmış günleri çalışma saatlerinin zamanlarını atıyoruz. ---></cfif>
                <cfset last_empty_time = listlast(Evaluate('empty_days#crate_days#'),',')><!---sonzaman=>günün son boş saatinin aralığı mesela [15:15-16:20],[17:00-19:30] saatleri boş zamanlar olsun,sondan ekleme yapmak için burda[17:00-19:30] luk kısmı getiriyor.  --->
                <cfset next_day = DateFormat(date_add('d',_i_n_d_+1,now()),'YYYYMMDD')><!--- bir sonraki günü belirliyoruz. --->
                <cfif DateFormat(_NOW_,'YYYYMMDD') eq crate_days><!--- eğer bugüne bakılıyorsa  --->
                    <cfset now_minute = (ListGetAt(TimeFormat(_now_,timeformat_style),1,':') * 60) + ListGetAt(TimeFormat(_now_,timeformat_style),2,':') ><!--- şu anı dk olarak set ediyoruz. --->
					<cfloop list="#Evaluate('empty_days#crate_days#')#" index="now_edit">
						<!--- #now_minute#___#ListGetAt(now_edit,1,'-')#___#ListGetAt(now_edit,2,'-')# --->
						<cfif now_minute gt ListGetAt(now_edit,1,'-') and now_minute lt ListGetAt(now_edit,2,'-')><!--- bugünün boş saatlerini şu andan sonra olacak şekilde düzenliyoruz. mesela şu anda saat 14:00 olsun,boş zaman [12:00-16:00] bu durumda bu boş zaman [14:00-16:00] arası oluyor. --->
                             <cfset 'empty_days#crate_days#' = ListSetAt(Evaluate('empty_days#crate_days#'),ListFind(Evaluate('empty_days#crate_days#'),now_edit,','),"#now_minute#-#ListGetAt(now_edit,2,'-')#",',')>
                        <cfelseif now_minute gt ListGetAt(now_edit,1,'-') and now_minute gt ListGetAt(now_edit,2,'-')>
							 <cfset full_days =ListAppend(full_days,crate_days,',')>
                        <cfelseif now_minute gt ListGetAt(now_edit,1,'-') and now_minute lt ListGetAt(now_edit,2,'-')>
							 <cfif ListFind(full_days,crate_days,',') gt 0>
								 <cfset full_days =ListDeleteAt(full_days,ListFind(full_days,crate_days,','),',')>
							</cfif>
							 <cfif ListFind(evaluate('empty_days#crate_days#'),now_edit,',')-1 gt 0>
								 <cfset 'empty_days#crate_days#' =ListDeleteAt(evaluate('empty_days#crate_days#'),ListFind(evaluate('empty_days#crate_days#'),now_edit,',')-1,',')>
							 </cfif>
                        <cfelseif now_minute lt ListGetAt(now_edit,1,'-') and now_minute lt ListGetAt(now_edit,2,'-')>
							<cfif ListFind(full_days,crate_days,',') gt 0>
								 <cfset full_days =ListDeleteAt(full_days,ListFind(full_days,crate_days,','),',')>
							</cfif>
							 <cfif ListFind(evaluate('empty_days#crate_days#'),now_edit,',')-1 gt 0>
								 <cfset 'empty_days#crate_days#' =ListDeleteAt(evaluate('empty_days#crate_days#'),ListFind(evaluate('empty_days#crate_days#'),now_edit,',')-1,',')>
							 </cfif>
						</cfif>
                    </cfloop>
                </cfif>#crate_days#==>#Evaluate('empty_days#crate_days#')#</font> <br/>
                <cfif not listfind(full_days,crate_days,',')>
                <cfif production_type eq 0><!--- continue üretim yapılıyor ise --->
                    <!--- #Evaluate('empty_days#crate_days#')#-- --->
                    <!--- #crate_days# #next_day#==> #Evaluate('empty_days#crate_days#')#==>sonzaman==> #last_empty_time# ==>birsonkgünbaş==>#next_first_empty_time# --->
                    <!--- <cfif ListLast(last_empty_time,'-') eq calisma_finish><!--- son boş zamanın bitiş saati istasyonun çalışma bitiş saatine eşitmi --->
                        <cfset last_time_diff = ListLast(last_empty_time,'-')-ListFirst(last_empty_time,'-')>
                    <cfelse>    
                        <cfset last_time_diff = -1>
                    </cfif>bugünFarkı=>#last_time_diff# --->
                   <!---  <cfif ListFirst(next_first_empty_time,'-') eq calisma_start>
                        <cfset firs_time_diff =  ListLast(next_first_empty_time,'-')-ListFirst(next_first_empty_time,'-')>
                    <cfelse>    
                        <cfset firs_time_diff = -1>
                    </cfif>=>sonrakiGFark=>#firs_time_diff# --->
                    <!--- günler bazında --->
                    <!--- birgün boşluğuna girecek bir üretim ise boş olan zamanlar dönsün --->
                    <cfif gerekli_uretim_zamanı_dak lte (calisma_finish-calisma_start)><!--- 1 gün içinde bitebilecek bir üretim ise günün içindeki boş zamanlara bakıyoruz. --->
                         <cfloop list="#Evaluate('empty_days#crate_days#')#" index="l_list">
                            <cfif ListGetAt(l_list,2,'-')-ListGetAt(l_list,1,'-') gte gerekli_uretim_zamanı_dak>
                                <cfset finded_production_start_day = crate_days >
                                <cfset finded_production_finish_day = crate_days >
                                <cfset finded_production_start_time = "#Int(ListGetAt(l_list,1,'-')/60)# : #ListGetAt(l_list,1,'-') mod 60#">
                                <cfset finded_production_finish_time = "#Int((ListGetAt(l_list,1,'-')+gerekli_uretim_zamanı_dak)/60)# : #(ListGetAt(l_list,1,'-')+gerekli_uretim_zamanı_dak) mod 60#">
                               <!---  bulundu!**#finded_production_start_day# -- #finded_production_start_time#-#finded_production_finish_time#<br/> --->
                                <cfset finded_production_start_finish_times = "#finded_production_start_day#,#finded_production_start_time#,#finded_production_finish_day#,#finded_production_finish_time#">
                            <cfreturn finded_production_start_finish_times>
                                <cfexit method="exittemplate"><!--- uygun aralığı bulursa çıksın --->
                            </cfif>
                        </cfloop>
                    </cfif>
                    <!--- birbirni takip eden günlerde üretim. --->
                    <cfif not listfind(full_days,next_day,',')><!--- bir sonraki gün dolu günler arasında değilse  --->
                        <cfif not isdefined('empty_days#next_day#')><!--- bir sonraki günün başlagınç zamanını alıcaz mesela 09:15-12:20 --->
                            <cfset next_first_empty_time = '#calisma_start#-#calisma_finish#'>
                        <cfelse>
                            <cfset next_first_empty_time = ListFirst(Evaluate('empty_days#DateFormat(date_add('d',_i_n_d_+1,now()),'YYYYMMDD')#'),',')>
                        </cfif>
                    <cfelse> 
                        <cfset next_first_empty_time = -1>
                    </cfif>
                    <cfif (not listfind(full_days,next_day,',')) and<!--- bulduğumuz bir sonraki gün dolu günler arasında değil ise --->
                           (ListLast(last_empty_time,'-') eq calisma_finish) and<!--- bugünün son boş zamanının bitiş saati calisma programının bitiş saati ile eşitmi --->
                           (ListFirst(next_first_empty_time,'-') eq calisma_start)<!--- bir sonraki gündeki boş zamanın başlangıç saati calisma programının başlamgıç saati ile eşitmi --->
                           >
                           <!--- <font color="0000FF">#Evaluate('empty_days#crate_days#')# uz:#ListLen(Evaluate('empty_days#crate_days#'),',')#</font> --->
                            <cfif ListLen(Evaluate('empty_days#crate_days#'),',') neq 1><!--- bir taneden fazla boş çalışma anı varsa eğer günümüzde yani =>[10:05-12:30],[13:13-15:00] böyle ise --->
                                <cfset finded_production_start_time = "#Int(ListGetAt(last_empty_time,1,'-')/60)# : #ListGetAt(last_empty_time,1,'-') mod 60#">
                                <cfset finded_production_start_day = crate_days >
                                <cfset uretim_birlesim_dakika = ListLast(last_empty_time,'-')-ListFirst(last_empty_time,'-')+ListLast(next_first_empty_time,'-')-ListFirst(next_first_empty_time,'-')>
                            <cfelseif ListFirst(next_first_empty_time,'-') eq calisma_start and ListLast(next_first_empty_time,'-') eq calisma_finish><!--- bir sonraki gündeki boş zamanın başlangıç saati calisma programının başlamgıç saati ile eşitmi --->
                                <cfset uretim_birlesim_dakika = uretim_birlesim_dakika + (ListLast(last_empty_time,'-')-ListFirst(last_empty_time,'-'))>
                            <cfelse>
                                <cfset uretim_birlesim_dakika = uretim_birlesim_dakika + (ListLast(last_empty_time,'-')-ListFirst(last_empty_time,'-')) + ListLast(next_first_empty_time,'-')-ListFirst(next_first_empty_time,'-')>
                            </cfif>	  
                    <cfelse>
                            <cfset uretim_birlesim_dakika = 0 >
                    </cfif>
                    <!---bulunan zamanı karşılaştırıyoruz. --->
                    <cfif uretim_birlesim_dakika gte gerekli_uretim_zamanı_dak>
                        <!--- <font color="66666"> --->
                            <cfif not isdefined('finded_production_start_day')>
                                <cfset finded_production_start_day = crate_days>
                                <cfset finded_production_start_time = "#Int(ListGetAt(last_empty_time,1,'-')/60)# : #ListGetAt(last_empty_time,1,'-') mod 60#">
                            </cfif>
                            <cfset _fark_ = uretim_birlesim_dakika-gerekli_uretim_zamanı_dak>
                            <cfset finded_production_finish_day = next_day >
                            <cfset finded_production_finish_time =" #Int((ListGetAt(next_first_empty_time,2,'-') - _fark_)/60)# : #(ListGetAt(next_first_empty_time,2,'-') - _fark_) mod 60#" >
                       <!---  #finded_production_start_day#__#finded_production_start_time#-----#finded_production_finish_day# : #finded_production_finish_time#
                        BULUNDU!!!!!!!!!!!!!!!!!!</font> --->
						<cfset finded_production_start_finish_times = "#finded_production_start_day#,#finded_production_start_time#,#finded_production_finish_day#,#finded_production_finish_time#">
                        <cfreturn finded_production_start_finish_times>
                        <cfexit method="exittemplate">
                    </cfif>
                <cfelse><!--- Parçalı Üretim yapılıyorsa --->
                      <cfif uretim_birlesim_dakika eq 0><!--- ilk günümüz belli oluyor.--->
                            <cfset finded_production_start_day = crate_days><cfif listlen(Evaluate('empty_days#finded_production_start_day#'),'-') lt 2>DOLU GÜNLER =>#full_days#---#finded_production_start_day#=>#Evaluate('empty_days#finded_production_start_day#')#--</cfif>
                            <cfset finded_production_start_time = "#Int(ListFirst(Evaluate('empty_days#finded_production_start_day#'),'-')/60)# : #ListFirst(Evaluate('empty_days#finded_production_start_day#'),'-') mod 60#">
                      </cfif>
                       <font color="FF0000">#Evaluate('empty_days#crate_days#')#</font><br/>
                      <cfloop list="#Evaluate('empty_days#crate_days#')#" index="new_indx">
                            <cfset uretim_birlesim_dakika = uretim_birlesim_dakika + (ListGetAt(new_indx,2,'-')-ListGetAt(new_indx,1,'-'))>
                            <cfif uretim_birlesim_dakika gte gerekli_uretim_zamanı_dak>
                                <cfset finded_production_finish_day = crate_days><!--- üretimin dolduğu anı buluyoruz. --->
                                <cfset onceki_uretim_birlesim_dakika = uretim_birlesim_dakika-(ListGetAt(new_indx,2,'-')-ListGetAt(new_indx,1,'-'))>
                                <cfset fark = gerekli_uretim_zamanı_dak-onceki_uretim_birlesim_dakika>
                                <cfset finded_production_finish_time =" #Int(((ListGetAt(new_indx,1,'-')+fark))/60)# : #((ListGetAt(new_indx,1,'-')+fark)) mod 60#" >
								<cfset finded_production_start_finish_times = "#finded_production_start_day#,#finded_production_start_time#,#finded_production_finish_day#,#finded_production_finish_time#">
                           <cfreturn finded_production_start_finish_times>
                                <cfexit method="exittemplate">
                            </cfif>
                      </cfloop>
                </cfif>
                </cfif>
                <!--- bu satırlar silinmesin bunlar test yaparken gerekli oluyor. 
               <font color="red">#ListLast(last_empty_time,'-')-ListFirst(last_empty_time,'-')#<!--- +#ListLast(next_first_empty_time,'-')-ListFirst(next_first_empty_time,'-')# --->==>[[[#uretim_birlesim_dakika#]]]</font>--->
            </cfif>
        </cfloop>
    </cfoutput>
    </cffunction>
</cfprocessingdirective>
<cfsetting enablecfoutputonly="no">

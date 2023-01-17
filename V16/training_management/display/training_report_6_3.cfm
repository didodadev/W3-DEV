<!--- bu dosya list_report_group_choosen.cfm dosyanının içinde kaç tane form seçildiyse o 
kadar include ediliyor,dışarda bir loop dönüyor..
Sayfanın çalışma mantığı şudur;İlk başta bölümler ve içerdiği seçenekler
get_quiz_chapters querysi ile çekiliyor,daha sonra aşağıda get_quiz_chapters querysi döndürülürken
her bölümün içerdiği soru listeleri,toplam puanları,ve hangi tarihte yapıldıkları  set ediliyor.
Max_point diye bir değişken tanımlanıyor bu her bölümdeki en yüksek puanı seçiyor %lik dilimi ortaya
çıkarırken bunun üzerinden gidiliyor.
hesaplanış Örnek :  

		seçenek 1--seçenek 2---seçenek 3---seçenek 4
soru 1	....x.......................................
soru 2	..............x.............................
soru 3	...........................x................
soru 4	.......................................x....
soru 5	..............x..............................

böyle bi bölüm olduğunu düşünelim
seçenek 1 = 35 puan
seçenek 2 = 30 puan
seçenek 3 = 20 puan
seçenek 4 = 15 puan

burada hesaplama yaparken şu şekilde yapıyoruz
	soruların toplam değeri = 35 + 30 + 20 + 15 = 100
	toplam soru sayısı      = 5
	max seçenek puanı       = 35
	
	total_chapter_points / toplam soru sayısı = 100/5 = 20
	max puanı 100 olarak kabul ederek oran orantı kurarız
	
	35====100
	20=====x
	
	x= 2000/35 =  % 57
	
	Aşağıda tarihe göre listeleme yapılmıştır,sınıfların başlangıç ve bitiş tarihleri ile
	kullanıcının görmek istediği tarihler listelenmektedir.
	
	M.ER 20070913
  --->
<cfquery name="get_quiz_chapters" datasource="#dsn#">
	SELECT
		CHAPTER,CHAPTER_ID,
		<cfloop from="1" to="20" index="sayac">
			ANSWER#sayac#_POINT <cfif  sayac lt 20 >,</cfif>
		</cfloop>
	FROM 
		EMPLOYEE_QUIZ_CHAPTER
	WHERE
		QUIZ_ID = #Evaluate('gizli#ListGetAt(ch_sub_list,2,'-')#')#
</cfquery>
<cfif isdefined("attributes.gr_type") and len(attributes.gr_type)>
	<cfparam name="attributes.graph_type" default="#attributes.gr_type#">
<cfelse>
	<cfparam name="attributes.graph_type" default="bar">
</cfif>
<cfif get_quiz_chapters.recordcount>
	<!--- Burada  --->
	<cfoutput query="get_quiz_chapters">
		<cfset chapter_ids = chapter_id>
		<cfset chapter_currentrow =  chapter_currentrow + 1 >
		<cfset all_date_list = '' >
		<cfquery name="get_agirlik" datasource="#dsn#">
			SELECT 	
				QUESTION_USER_ANSWERS,
				TP.CLASS_ID,
				TP.INTERVIEW_DATE
			FROM 
				EMPLOYEE_QUIZ_QUESTION EQQ,
				TRAINING_PERFORMANCE TP,
				EMPLOYEE_QUIZ_RESULTS EQR,
				EMPLOYEE_QUIZ_RESULTS_DETAILS EQRD,
				EMPLOYEES E
			WHERE
				EQQ.CHAPTER_ID = #CHAPTER_ID# AND
				TP.TRAINING_QUIZ_ID = #Evaluate('gizli#ListGetAt(ch_sub_list,2,'-')#')#
				AND
				(
				<cfloop from="1" to="#listlen(cls_liste)#" index="dt">
				(TP.CLASS_ID = #ListGetAt(cls_liste,dt,',')# AND
				TP.INTERVIEW_DATE >= #DATEADD('d',-1,CreateODBCDateTime(ListGetAt(s_date_list,dt,',')))# AND  
				TP.INTERVIEW_DATE <= #DATEADD('d',1,CreateODBCDateTime(ListGetAt(f_date_list,dt,',')))#)
					<cfif dt lt listlen(cls_liste)>
						OR
					</cfif>
				</cfloop>
				) AND
				EQR.QUIZ_ID = #Evaluate('gizli#ListGetAt(ch_sub_list,2,'-')#')# AND
				EQR.RESULT_ID = EQRD.RESULT_ID AND
				EQR.TRAINING_PERFORMANCE_ID = TP.TRAINING_PERFORMANCE_ID AND
				EQRD.QUESTION_ID = EQQ.QUESTION_ID AND
				TP.ENTRY_EMP_ID = E.EMPLOYEE_ID AND
				EQRD.GD <> 1
				<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
					AND TP.INTERVIEW_DATE >= #attributes.start_date#
				</cfif>
				<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
					AND TP.INTERVIEW_DATE <= #attributes.finish_date#
				</cfif>
			ORDER BY 
				TP.INTERVIEW_DATE
		</cfquery>
		<!--- 
		<cfloop query="get_agirlik"> 
		bu loop'u döndürerek cevap listelerini tarihe göre ayırıyorum,--->
		<cfloop query="get_agirlik">
			<cfif not isdefined('answer_list#Dateformat(INTERVIEW_DATE,'YYYYMMDD')#_#chapter_currentrow#')>
				<cfset 'answer_list#Dateformat(INTERVIEW_DATE,'YYYYMMDD')#_#chapter_currentrow#' = QUESTION_USER_ANSWERS>
			<cfelse>
				<cfset 'answer_list#Dateformat(INTERVIEW_DATE,'YYYYMMDD')#_#chapter_currentrow#' = ListAppend(Evaluate('answer_list#Dateformat(INTERVIEW_DATE,'YYYYMMDD')#_#chapter_currentrow#'),QUESTION_USER_ANSWERS,',')> 	
			</cfif>
			<cfset 'total_chapter_points#chapter_ids#_#Dateformat(INTERVIEW_DATE,'YYYYMMDD')#' = 0 >
			<cfset 'chapter_points#chapter_ids#_#Dateformat(INTERVIEW_DATE,'YYYYMMDD')#' = 0 >
			<cfset all_date_list = listdeleteduplicates(ListAppend(all_date_list,Dateformat(INTERVIEW_DATE,'YYYYMMDD'),','))>
			<cfset 'total_answer_#Dateformat(INTERVIEW_DATE,'YYYYMMDD')#' = 0 >
		</cfloop>
		<cfset max_point = 0 >
		<!--- <cfloop from="1" to="20" index="sayac"> 
		bu loop'da cevapları ve kaç puan olduklarını döndürüyorum--->
		<cfloop from="1" to="20" index="sayac">
			<!--- toplam 20 tane puan olabilir,eğer uzunlğu varsa işleme alıoyoruz. --->
			<cfif len(Evaluate('ANSWER#sayac#_POINT'))>
				<!--- Burada öncelkle all_date_list'i döndürüyoruz,çünkü tarihe göre gruplamamız gerekiyor. --->
				<cfloop list="#all_date_list#" index="kk">
					<!--- bölümün puanları 'kk' index'i  ile yani tarih ile birlikte set ediliyor --->
					<cfset 'total_chapter_points#chapter_id#_#kk#' = Evaluate('total_chapter_points#chapter_id#_#kk#') + Evaluate('ANSWER#sayac#_POINT')>
					<!--- Bölümün max_pointini belirliyoruz. --->
					<cfif Evaluate('ANSWER#sayac#_POINT') gt max_point>
						<cfset max_point = Evaluate('ANSWER#sayac#_POINT')>
					</cfif>
					<!--- Burada da formu dolduranların vermiş olduğu cevapları döndürüyoruz --->
					<cfloop list="#Evaluate('answer_list#kk#_#chapter_currentrow#')#" index="jj">
						<!--- Eğer verilen cevap eşitse bizim formumuzda belirtilen seçeneğe 
						jj = verilen cevap 
						sayac =  Formdaki seçenek
						--->
						<cfif jj eq sayac>
							<!--- bölümün toplam soru sayısı --->
							<cfset 'total_answer_#kk#'= Evaluate('total_answer_#kk#')+1>
							<!--- verilen cevab tarihe göre toplanıyor.--->
							<cfset 'chapter_points#chapter_id#_#kk#'= Evaluate('chapter_points#chapter_id#_#kk#') +  Evaluate('ANSWER#sayac#_POINT')>
						</cfif>
					</cfloop>
				</cfloop>
			</cfif>
		</cfloop>
		<!--- Burada bölümlere göre set ediliyor değerler
		aşağıda da yapılabilirdi ama yapılmadı,çünkü aşağıda set edince hesaplamada bi sapıtma oluyor. --->
		<cfloop list="#all_date_list#" index="kk">
			<cfif Evaluate('chapter_points#chapter_id#_#kk#') gt 0 and Evaluate('total_answer_#kk#') gt 0>
				<cfset 'deger#chapter_id#_#kk#' = wrk_round(Evaluate('chapter_points#chapter_id#_#kk#')/Evaluate('total_answer_#kk#')*100/max_point)>
			<cfelse>
				<cfset 'deger#chapter_id#_#kk#' = 0>
			</cfif>	
		</cfloop>	
		</cfoutput>
		<tr>
			<td>
				<table cellpadding="0" cellspacing="0" style="height:240mm;width:210mm;" align="center" border="0" bordercolor="#CCCCCC">
					<tr>
						<td align="center"><cfinclude template="../../objects/display/view_company_logo.cfm"></td>
					</tr>
					<tr>
						<td class="txtbold">
							<cfquery name="get_quiz_head" datasource="#dsn#">
								SELECT
									DISTINCT
									QUIZ_ID,
									QUIZ_HEAD
									
								FROM
									EMPLOYEE_QUIZ
								WHERE
									QUIZ_ID = #Evaluate('gizli#ListGetAt(ch_sub_list,2,'-')#')#
							</cfquery>
							Bölüm Ortalamaları Raporu:<cfoutput>#get_quiz_head.QUIZ_HEAD#</cfoutput>
							<br/>
							<cfset colorlist="d099ff,6666cc,33cc33,cc6600,ff6600,ffcc00,ff66ff,999933,cccc99,996699,339999,ccff66,ccccff,6699ff"> 
							<cfoutput query="get_quiz_chapters">
							<cfchart 
								show3d="yes"
								labelformat="number"
								pieslicestyle="solid"
								format="png"
								chartwidth="300"
								chartheight="250"
								scalefrom="0"scaleto="100"
								seriesplacement="default"
								 xaxistitle="#CHAPTER#"
								>
								<cfloop list="#all_date_list#" index="kk">							
									<cfchartseries type="#attributes.graph_type#" paintstyle="plain" colorlist="#colorlist#">
										<cfset deger = Evaluate('deger#chapter_id#_#kk#') >
										<cfchartdata  item="#kk#" value="#deger#">
									</cfchartseries>
								</cfloop>
							</cfchart>
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td align="center"><cfinclude template="../../objects/display/view_company_info.cfm"></td>
					</tr>	
				</table>
			</td>
		</tr>
</cfif>


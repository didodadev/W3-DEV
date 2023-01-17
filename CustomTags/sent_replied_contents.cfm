<!--- 

	ACIKLAMA :
	EMAIL YOLUYLA GONDERILEN VE DIREKT EMAIL ICINDEN CEVAPLANMASI YAPILACAK OLAN ICERIKLERIN
	KAYDEDILMESI VE KULLANICI CEVAPLANDIRDIGINDA VERITABANINA GEREKLI KAYITLARIN YAPILMASINI 
	SAGLAYAN CUSTOM TAG.
	
	KULLANIM:
	<cf_sent_replied_contents
	action="add,remove,get_reply,send_content" 
		add : sadece veritabanına kayıt eklemek için kullanılır. İçerik gonderme veya alma işlemi yapılmaz.
		remove: sadece veritabanından kayıt silmek için kullanılır. İçerik gonderme veya alma işlemi yapılmaz.
		get_reply : email ile gönderilen form sonuçlarını almak için kullanılır. Gönderilen unique key 
		kontrol edilerek doğruysa veritabanına form sonuçları işlenir.
		send_content : email ile formları yollamak için kullanılır. Unique key yaratılır ve bu key formla
		birlikte gönderilir. Email cevaplandığında güvenlik amacıyla unique key karşılaştırılarak sisteme
		işlenecektir.
	>
	
	ACTION = ADD | REMOVE | GET REPLY | SEND_CONTENT
	user_type_id = degerlendirici tip 1:employee, 2:consumer, 3:partner, 4: amir employee
	user_id = degerlendirecek
	send_emp = degerlendirilen
	content_type_id = degerlendirme tipi 1:OLCME/DEGERLENDIRME | 2:ANALIZ | 3:ANKET | 4:TEST/SINAV | 5:EMAIL
	content_id = ilgili degerlendirme belgesinin unique id si
	
	NOH20040918-20051118
	
 --->
 

<!--- DEFAULT PARAMETRELERIN SET EDILMESI --->
<cfparam name="error_msg" type="string" default="">

<!--- TAG'DE SET EDILMESI GEREKEN PARAMETRELERIN KONTROLU --->
<!--- ACTION --->
<cfif IsDefined("attributes.action")>
	<cfparam name="attributes.action" type="string" default="#attributes.action#">
<cfelse>
	<cfset error_msg = error_msg & "<li>ACTION</li>">
</cfif>

<!--- ACTION'A GORE GEREKLI ATTRIBUTELARIN KONTROLU VE DEFAULT DEGERLERIN ATANMASI --->
<cfswitch expression="#attributes.action#">
	<!--- ADD --->
	<cfcase value="add">
		<!--- DSN --->
		<cfif IsDefined("attributes.dsn")>
			<cfparam name="attributes.dsn" type="string" default="#attributes.dsn#">
		<cfelse>
			<cfset error_msg = error_msg & "<li>DSN</li>">
		</cfif>
		<!--- SEND_EMP --->
		<cfif IsDefined("attributes.send_emp")>
			<cfparam name="attributes.send_emp" type="numeric" default="#attributes.send_emp#">
		<cfelse>
			<cfset error_msg = error_msg & "<li>SEND_EMP</li>">
		</cfif>
		<!--- user_type --->
		<cfif IsDefined("attributes.user_type_id")>
			<cfparam name="attributes.user_type_id" type="string" default="#attributes.user_type_id#">
		<cfelse>
			<cfset error_msg = error_msg & "<li>USER_TYPE</li>">
		</cfif>
		<!--- USER_ID --->
		<cfif IsDefined("attributes.user_id")>
			<cfparam name="attributes.user_id" type="numeric" default="#attributes.user_id#">
		<cfelse>
			<cfset error_msg = error_msg & "<li>USER_ID</li>">
		</cfif>
		<!--- EMAIL --->
		<cfif IsDefined("attributes.email")>
			<cfparam name="attributes.email" type="string" default="#attributes.email#">
		<cfelse>
			<cfset error_msg = error_msg & "<li>EMAIL</li>">
		</cfif>
		<!--- content_type --->
		<cfif IsDefined("attributes.content_type_id")>
			<cfparam name="attributes.content_type_id" type="string" default="#attributes.content_type_id#">
		<cfelse>
			<cfset error_msg = error_msg & "<li>CONTENT_TYPE</li>">
		</cfif>
		<!--- CONTENT_ID --->
		<cfif IsDefined("attributes.content_id")>
			<cfparam name="attributes.content_id" type="numeric" default="#attributes.content_id#">
		<cfelse>
			<cfset error_msg = error_msg & "<li>CONTENT_ID</li>">
		</cfif>
		<!--- SET EDILMEYEN PARAMETRELERIN DEFAULT DEGERLERE SET EDILMESI --->
		<!--- SEND_DATE --->
		<cfif IsDefined("attributes.send_date")>
			<cfparam name="attributes.send_date" type="string" default="#attributes.send_date#">
		<cfelse>
			<cfparam name="attributes.send_date" type="string" default="#DateFormat(Now(),'dd/mm/yyyy')#">
		</cfif>
		<!--- KEY_STR --->
		<cfif IsDefined("attributes.key_str")>
			<cfparam name="attributes.key_str" type="numeric" default="#attributes.key_str#">
		<cfelse>
			<cfparam name="attributes.key_str" type="string" default="#createUUID()#">
		</cfif>
	</cfcase>
	
	<!--- REMOVE --->
	<cfcase value="remove">
		<!--- DSN --->
		<cfif IsDefined("attributes.dsn")>
			<cfparam name="attributes.dsn" type="string" default="#attributes.dsn#">
		<cfelse>
			<cfset error_msg = error_msg & "<li>DSN</li>">
		</cfif>
		<!--- EMAIL --->
		<cfif IsDefined("attributes.email")>
			<cfparam name="attributes.email" type="string" default="#attributes.email#">
		<cfelse>
			<cfset error_msg = error_msg & "<li>EMAIL</li>">
		</cfif>
		<!--- CONTENT_TYPE --->
		<cfif IsDefined("attributes.content_type_id")>
			<cfparam name="attributes.content_type_id" type="numeric" default="#attributes.content_type_id#">
		<cfelse>
			<cfset error_msg = error_msg & "<li>CONTENT_TYPE</li>">
		</cfif>
		<!--- CONTENT_ID --->
		<cfif IsDefined("attributes.content_id")>
			<cfparam name="attributes.content_id" type="numeric" default="#attributes.content_id#">
		<cfelse>
			<cfset error_msg = error_msg & "<li>CONTENT_ID</li>">
		</cfif>
		<!--- KEY_STR --->
		<cfif IsDefined("attributes.key_str")>
			<cfparam name="attributes.key_str" type="numeric" default="#attributes.key_str#">
		<cfelse>
			<cfset error_msg = error_msg & "<li>KEY_STR</li>">
		</cfif>
	</cfcase>
	
</cfswitch>

<cfif len(error_msg) gt 0>
	<cfoutput>#caller.getLang('main',2183)#.<br />user_type_id:#attributes.user_type_id#,user_id:#attributes.user_id#,email:#attributes.email#<hr><ul><font color="##FF0000">#error_msg#</font></ul></cfoutput>
	<!--- <cfabort> --->
<cfelse>
	<cf_date tarih='attributes.send_date'>
	<cfswitch expression="#attributes.action#">
		<!--- ADD --->
		<cfcase value="add">
			<cfquery name="ADD_SENT_EMAILS" datasource="#attributes.dsn#">
				INSERT 
					SENT_REPLIED_CONTENTS(
						USER_TYPE_ID,<!--- degerlendirici tipi --->
						USER_ID,<!--- degerlendirici ID si --->
						EMAIL_ADDRESS,
						CONTENT_TYPE_ID,<!--- degerlendirme tipi --->
						CONTENT_ID,<!--- degerlendirme belge unique ID si --->
						UNIQUE_KEY,
						SEND_DATE,
						SEND_EMP,<!--- degerlendirilen --->
						RECORD_DATE,
						RECORD_EMP
					)
				VALUES(
						#attributes.user_type_id#,<!--- attributes.user_type_id: 1=employee,2=consumer, 3=partner, 4:employee_amir --->
						#attributes.user_id#,
						'#attributes.email#',
						#attributes.content_type_id#,<!--- attributes.content_type_id:1=Ölçme/Değerlendirme,2=Analiz,3=Anket,4=Test/Sınav,5=email --->
						#attributes.content_id#,
						'#attributes.key_str#',
						#attributes.send_date#,
						#attributes.send_emp#,
						#now()#,
						#session.ep.userid#
					)
			</cfquery>
		</cfcase>
		<!--- REMOVE --->
		<cfcase value="remove">
			<cfquery name="REMOVE_SENT_EMAILS" datasource="#attributes.dsn#">
				DELETE FROM
					SENT_REPLIED_CONTENTS
				WHERE
					EMAIL_ADDRESS = '#attributes.email#'
					AND	CONTENT_TYPE_ID = #attributes.content_type_id#
					AND CONTENT_ID = #attributes.content_id#
					AND UNIQUE_KEY = '#attributes.key_str#'
			</cfquery>
		</cfcase>
		
	</cfswitch>
</cfif>

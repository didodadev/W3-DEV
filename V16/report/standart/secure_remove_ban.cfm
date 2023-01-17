<cfif isdefined(url.ip)>
	<cfquery name="get_random" datasource="#dsn#">
		SELECT RANDOM FROM WRK_SECURE_BANNED_IP	
		WHERE IP=#url.ip#	
	</cfquery>
<cfelse>
	Tanimsiz islem.
</cfif>
<cfif isDefined(form.submitted)>
	<cfmail
			to="form.mail"
			from="#attributes.workcube_server#<#attributes.admin_mail#>"
			subject="Workcube Ban Kaldirma">
			#form.ip# �zerinden Workcube'e saldirida bulunulmustur. Bunun sonunucunda bu IP adresinin sisteme girmesi engellenmistir.<br />
			Kisitlamayi kaldirmak i�in asagidaki linke tiklamaniz gerekmektedir.
			<a href="#request.self#?fuseaction=home.removeip&IP=#url.ip#&r=#get_random.RANDOM#">Bani a�</a>
	</cfmail>
</cfif>
<form name="remove_ip" action="#request.self#?fuseaction=report.remove_ip">
	IP:<input type="text" id="ip" name="ip" value="#attributes.ip#" /><br />
	Mail:<input type="text" id="mail" name="mail" value="" />
	<i>Note : Kullanici kendisine g�nderilen linke tikladigi zaman bani kalkar.</i>
	<input type="submit" value="Bani Kaldir" /> 
</form>

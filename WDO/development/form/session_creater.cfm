<cfparam name="session_user" default="">
<cfparam name="session_name" default="">
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td class="headbold">Session Creater</td>
  </tr>
</table>
  <table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
	<tr class="color-row">
	  <td>
		<table border="0">
		  <cfform method="POST" enctype="multipart/form-data" action="#request.self#?fuseaction=home.session_creater" name="hlp_dsk">
			<tr>
			  <td>User *</td>
			  <td><cfinput type="text" style="width:250px;" name="session_user" value="#session_user#"> (Maksimum Kullanıcı Sayısı)</td>
			</tr>
			<tr>
			  <td>Key *</td>
			  <td><cfinput type="text" style="width:250px;" name="session_name" value="#session_name#"> (Domain Name)</td>
			</tr>
			<tr>
			  <td style="text-align:right;" height="35" colspan="2">
				  <cf_workcube_buttons is_upd='0'>
			  </td>
			</tr>
		</cfform>
		<cfif isdefined("form.session_name")>
			<tr>
				<td colspan="2" class="formbold">
				<br />
				<br />
				<cfset domain_ = form.session_name>
				<cfset code_ = encrypt('#session_user#',domain_,'CFMX_COMPAT','Base64')>
				Session Code : <cfoutput>#code_# (#domain_# #form.session_name#)</cfoutput>
				<br />
				Not : Oluşan Kodda # işareti çıkarsa bunu ## olarak kullanınız!
				<hr />
				<cfset cozum = decrypt(code_,domain_,'CFMX_COMPAT','Base64')>
				<cfdump var="#cozum#">
				</td>
			</tr>
		</cfif>
	 </table>
	  </td>
	</tr>
  </table>

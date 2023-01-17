<cfif isdefined('session.pp.userid')>
	<cfset attributes.cpid = session.pp.company_id>
	<div class="haber_liste">
		<div class="haber_liste_1">
			<div class="haber_liste_11"><h1><cf_get_lang no='5.Sube Ekle'></h1></div>
		</div>
		<div class="talep_detay">
			<div class="talep_detay_1" style="width:100%;">
				<div class="talep_detay_12">
					<div class="td_kutu">
						<cfinclude template="../form/add_branch.cfm">
					</div>
				</div>
			</div>
		</div>
	</div>
<cfelseif isdefined("session.ww.userid")>
	<script>
		alert('Bu sayfaya erişmek için firma çalışanı olarak giriş yapmanız gerekmektedir!');
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>

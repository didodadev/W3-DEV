<script language="javascript">
	<cfif isdefined('session.pp.userid')>
		window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.list_partner';
	<cfelseif isdefined('session.ww.userid')>
		window.location.href='<cfoutput>#request.self#?fuseaction=worknet.detail_consumer&consumer_id=#session.ww.userid#</cfoutput>';
	</cfif>	
</script>

<cfif isdefined('form.vno') and len(form.vno)>
	<cfquery name="getCompanyID" datasource="#dsn#">
		SELECT 
			COMPANY_ID
		FROM 
			COMPANY 
		WHERE 
			TAXNO = '#form.vno#'
	</cfquery>
	<cfif getCompanyID.recordcount>
		<cfset companyID = getCompanyID.COMPANY_ID>
	</cfif>
</cfif>
<cf_get_lang_set module_name="member"><!--- sayfanin en altinda kapanisi var --->
<div class="haber_liste" id="checkID">
	<div class="haber_liste_1">
		<div class="haber_liste_11"><h1><cf_get_lang no='5.Uye Ol'></h1></div>
	</div>

	<div class="talep_detay_1" style="width:905px;">
		<div class="td_kutu">
			<div class="td_kutu_1"><h2>
        <cf_get_lang no='5.Uye Ol'>
      </h2></div>
			<div class="td_kutu_2" align="center">
				<cfform name="check_member" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_member">
					<table>
						<tr height="30">
							<td width="120" style="font-size: 13px;color: #333;"><cf_get_lang no='48.IHKIB uyesi misiniz'></td>
							<td valign="top" style="padding-left: 14px;">
								<input type="radio" value="1" name="is_related_company" id="is_related_company" checked="checked" style="float:left;"> <span style="margin:5px;"><cf_get_lang_main no='83.Evet'></span>
								<input type="radio" value="0" name="is_related_company" id="is_related_company" style="float:left;"> <span style="margin:5px;"><cf_get_lang_main no='84.Hayir'></span>
							</td>
						</tr>
						<tr height="30">
							<td nowrap="nowrap" style="font-size: 13px;color: #333;"><cf_get_lang_main no='340.Vergi No'>/<cf_get_lang_main no='613.TC Kimlik No'></td>
							<td><cfsavecontent variable="message"><cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='340.Vergi No'>/<cf_get_lang_main no='613.TC Kimlik No'> !</cfsavecontent>
								<cfif isdefined('form.vno') and len(form.vno)>
									<cfinput type="text" name="vno" id="vno" onKeyup="isNumber(this);" onblur="isNumber(this);" value="#form.vno#" style="width: 200px;margin-left: 17px;">
								<cfelse>
									<cfinput type="text" name="vno" id="vno" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" style="width: 200px;margin-left: 17px;">
								</cfif>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<div class="talep_detay_31" style="float:right; margin-right:30px;">
									<cfsavecontent variable="message"><cf_get_lang_main no='714.Devam'></cfsavecontent>
									<input class="btn_1" type="submit" onclick="return memberCheck();" value="<cfoutput>#message#</cfoutput>" /> 
								</div> 
							</td>
						</tr>
						<tr>
						  <td colspan="2"> 
							<a href="/add_consumer" style="color: #4487A7;font-weight: bold;margin-top: 11px;">Akademi Üyesi (Bireysel Üye) Olmak istiyorsaniz tiklayiniz</a>
						  </td>
						</tr>
					</table>
				</cfform>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	function memberCheck()
	{   
		if(document.getElementById('vno').value == '')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='340.Vergi No'>/<cf_get_lang_main no='613.TC Kimlik No'> !");
			return false;
		}
		if(document.getElementById('is_related_company').checked == true && (document.getElementById('vno').value.length > 11 || document.getElementById('vno').value.length < 10))
		{
			alert("Vergi no için 10 hane TCKN için 11 hane olmalıdır!");
			return false;
		}
		if(document.getElementById('is_related_company').checked == false && document.getElementById('vno').value.length > 40)
		{
			alert("Maksimum karakter sayısı 40 hane olmalıdır!");
			return false;
		}
		document.getElementById('check_member').submit();
	}
	<cfoutput>
		<cfif isdefined('form.vno') and len(form.vno) and isdefined('companyID') and len(companyID)>
			document.getElementById('checkID').style.display = 'none';
			window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.form_add_help&cpid=#companyID#';
		<cfelseif isdefined('form.vno') and len(form.vno) and not isdefined('companyID')>
			document.getElementById('checkID').style.display = 'none';
			window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.form_add_member&is_related_company=#attributes.is_related_company#&content_head_id=#attributes.content_head_id#&vno='+document.getElementById('vno').value+'';
		</cfif>
	</cfoutput>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->


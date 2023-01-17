<!--- TC Kimlik numarası girdigimiz yerlerde kullanılmak uzere duzenlenmistir. BK 20100622 --->
<cfparam name="attributes.fieldId" default=''>
<cfparam name="attributes.tc_identity_number" default=''>
<cfparam name="attributes.on_blur_control" default='0'>
<cfparam name="attributes.width_info" default=''>
<cfparam name="attributes.onFocus" default=''>
<cfparam name="attributes.tc_identity_required" default='no'>
<cfparam name="attributes.is_verify" default='no'><!--- Doğrulama yapması isteniyorsa 1 gönderilir. --->
<cfparam name="attributes.consumer_name" default='no'><!--- Doğrulama için isim zorunlu olduğu için ismin tutulduğu alan adı yazılmalı --->
<cfparam name="attributes.consumer_surname" default='no'><!--- Doğrulama için soyad zorunlu olduğu için soyadın tutulduğu alan adı yazılmalı --->
<cfparam name="attributes.birth_date" default='no'><!--- Doğrulama için doğum tarihi zorunlu olduğu için doğum tarihinin tutulduğu alan adı yazılmalı --->
<cfparam name="attributes.class" default="">
<cfoutput>
	<input type="hidden" name="is_verify" id="is_verify" value="">
	<cfif attributes.tc_identity_required and attributes.is_verify eq 0>
		<input type="text" name="#attributes.fieldId#" id="#attributes.fieldId#" <cfif len(attributes.class)>class="#attributes.class#"</cfif> <cfif len(attributes.width_info)>style="width:#attributes.width_info#px;"</cfif> value="#attributes.tc_identity_number#" onBlur="isTCNUMBER(this);" onkeyup="isNumber(this)" maxlength="11" autocomplete="off" <cfif len(attributes.onFocus)>onfocus="#attributes.onFocus#"</cfif>>
	<cfelse>
		<cfif attributes.is_verify eq 1>
			<div class="input-group">
		</cfif>
		<input type="text" name="#attributes.fieldId#" id="#attributes.fieldId#" <cfif len(attributes.class)>class="#attributes.class#"</cfif> style="width:#attributes.width_info#px;" value="#attributes.tc_identity_number#" <cfif attributes.on_blur_control eq 1>onBlur="kontrol_tcno_verify();"</cfif> onkeyup="isNumber(this)" maxlength="11" autocomplete="off" <cfif len(attributes.onFocus)>onfocus="#attributes.onFocus#"</cfif>>
	</cfif>
	<cfif attributes.is_verify eq 1>
		<span class="input-group-addon"  onclick="kontrol_tcno_verify();">
			<i class="fa fa-info-circle" title="TC Kimlik No Doğrula" border="0" align="absmiddle"></i>
		</a></span></div>
		<div id="TC_IDENTY_KONTROL"></div>
	</cfif>
	<script type="text/javascript">
		function kontrol_tcno_verify()
		{
			if(document.getElementById('#attributes.fieldId#').value == '' || document.getElementById('#attributes.consumer_name#').value == '' || document.getElementById('#attributes.consumer_surname#').value == '' || document.getElementById('#attributes.birth_date#').value == '')
			{
				alert("#caller.getLang('main',2176)#");
				return false;
			}
			AjaxPageLoad('#request.self#?fuseaction=objects2.emptypopup_verify_tc_identyno&tc_number='+document.getElementById('#attributes.fieldId#').value+'&consumer_name='+document.getElementById('#attributes.consumer_name#').value+'&consumer_surname='+document.getElementById('#attributes.consumer_surname#').value+'&birth_date='+document.getElementById('#attributes.birth_date#').value+'','TC_IDENTY_KONTROL',1);
		}
	</script>
</cfoutput>

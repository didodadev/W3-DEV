<!--- kullaným ve yardým

örnek tarih alma butonu :

<input  value="+" style="width:20px; heigth:18px;" onclick="window.open('<cfoutput>#request.self#?fuseaction=objects.popup_calender</cfoutput>&alan=employe_detail.start_date','','top=100,left=100,width=250,height=180');">

buradaki url den gelecek olan alan parametresi form.alan_adi þeklinde gönderilmeli


Ergün KOÇAK
--->

<cfif isDefined("url.ay") and isDefined("url.yil")>
	<cfset ay=#url.ay#>
	<cfset yil=#url.yil#>
<cfelse>	
	<cfset ay=DateFormat(now(),"mm")>
	<cfset url.ay=ay>
	<cfset yil=DateFormat(now(),"yyyy")>
	<cfset url.yil=yil>
</cfif>
<cfset alan="#URL.alan#">
<cfset oncekiyil = yil-1>
<cfset sonrakiyil = yil+1>
<cfset oncekiay = ay-1>
<cfset sonrakiay = ay+1>
<cfif ay EQ 1>
	<cfset oncekiay=12>
</cfif>
<cfif ay EQ 12>
	<cfset sonrakiay=1>
</cfif>
<cfsavecontent variable="ay1"><cf_get_lang_main no ='180.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang_main no ='181.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang_main no ='182.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang_main no ='183.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang_main no ='184.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang_main no ='185.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang_main no ='186.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang_main no ='187.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang_main no ='188.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang_main no ='189.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang_main no ='190.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang_main no ='191.Aralık'></cfsavecontent>
<cfset aylar="#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">

<cfset tarih = createDate(yil,ay,1)>
<cfset bas = DayofWeek(tarih)-1>
<cfif bas EQ 0>
	<cfset bas=7>
</cfif>
<cfset son = DaysinMonth(tarih)>
<cfset gun = 1>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Takvim v.1</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>

<script type="text/javascript">
function don(tarih)
{
	window.opener.<cfoutput>#alan#</cfoutput>.value=tarih;
	window.close();
}
</script>
<table border="0" width="200" align="center" cellpadding="0" cellspacing="0" height="25">
  <tr>
<cfoutput>
	  <td width="20"><a href="#request.self#?fuseaction=objects2.popup_calender&ay=#ay#&yil=#oncekiyil#&alan=#url.alan#"><img src="/images/previous20.gif" border="0" title="<cf_get_lang_main no ='528.Önceki Yıl'>"></a></td>
	  <td align="center" class="formbold" width="40">#Year(tarih)#</td>
	  <td width="20"  style="text-align:right;"><a href="#request.self#?fuseaction=objects2.popup_calender&ay=#ay#&yil=#sonrakiyil#&alan=#url.alan#"><img src="/images/next20.gif" border="0" title="<cf_get_lang_main no ='533.Sonraki Yıl'>"></a></td>
	<td width="20"><a href="#request.self#?fuseaction=objects2.popup_calender&ay=#oncekiay#&yil=<cfif url.ay eq 1>#oncekiyil#<cfelse>#yil#</cfif>&alan=#url.alan#"><img src="/images/previous20.gif" border="0" title="<cf_get_lang_main no ='529.Önceki Ay'>"></a></td>
	  <td align="center" class="formbold" width="60">#ListGetAt(aylar,Month(tarih))#</td>
	  <td width="20"  style="text-align:right;"><a href="#request.self#?fuseaction=objects2.popup_calender&ay=#sonrakiay#&yil=<cfif url.ay eq 12>#sonrakiyil#<cfelse>#yil#</cfif>&alan=#url.alan#"><img src="/images/next20.gif" border="0" title="<cf_get_lang_main no ='532.Sonraki Ay'>"></a></td>
</cfoutput>
</tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" align="center">
<tr class="color-border">
<td>
<table style="text-align: center;" border="0" cellpadding="2" cellspacing="1">
<tr class="color-header">
	<td class="form-title"><cf_get_lang_main no='207.Pts'></td>
	<td class="form-title"><cf_get_lang_main no='193.Salı'></td>
	<td class="form-title"><cf_get_lang_main no='209.Çrş'></td>
	<td class="form-title"><cf_get_lang_main no='210.Per'></td>
	<td class="form-title"><cf_get_lang_main no='211.Cum'></td>
	<td class="form-title"><cf_get_lang_main no='212.Cts'></td>
	<td class="form-title"><cf_get_lang_main no='213.Pzr'></td>
</tr>
<tr class="color-row">
<cfloop index=x from=1 to=#Evaluate(bas-1)#>
	<td align="center">&nbsp;</td>
</cfloop>
<cfloop index=x from=#bas# to=7>
	<td align="center"><a href="javascript:don('<cfif (not ("#gun#" contains "0")) and (gun lte 9)>0</cfif><cfoutput>#gun#/<cfif (not ("#ay#" contains "0")) and (ay lte 9)>0</cfif>#ay#/#yil#</cfoutput>');" class="tableyazi"><cfoutput><cfif (dateformat(now(),"dd") eq gun) and (dateformat(now(),"mm") eq ay) and (dateformat(now(),"yyyy") eq yil)><font color="red"></cfif>#gun#<cfif (dateformat(now(),"dd") eq gun) and (dateformat(now(),"mm") eq ay) and (dateformat(now(),"yyyy") eq yil)></font></cfif></cfoutput></a></td>
	<cfset gun = gun +1>
</cfloop>
</tr>

<cfloop index=y from=2 to=6>
<tr class="color-row">
	<cfloop index=x from=1 to=7>
		<cfif gun LTE son>
			<td align="center"><a href="javascript:don('<cfif (not ("#gun#" contains "0")) and (gun lte 9)>0</cfif><cfoutput>#gun#/<cfif (not ("#ay#" contains "0")) and (ay lte 9)>0</cfif>#ay#/#yil#</cfoutput>');" class="tableyazi"><cfoutput><cfif (dateformat(now(),"dd") eq gun) and (dateformat(now(),"mm") eq ay) and (dateformat(now(),"yyyy") eq yil)><font color="red"></cfif>#gun#<cfif (dateformat(now(),"dd") eq gun) and (dateformat(now(),"mm") eq ay) and (dateformat(now(),"yyyy") eq yil)></font></cfif></cfoutput></a></td>
		<cfelse>
			<td align="center">&nbsp;</td>
		</cfif>
		<cfset gun = gun +1>
	</cfloop>
</tr>
</cfloop>
</table>
</td>
</tr>
</table>
</body>
</html>
